/* Latent Python runtime: Pyodide + NumPy in a module Web Worker.
 *
 * Loaded with { type: "module" } so Pyodide comes in through dynamic import(),
 * which is more robust than synchronous importScripts behind proxies.
 *
 * Protocol (main → worker):
 *   { type: "init", indexURL, kernelURL, interruptBuffer? }
 *   { type: "call", id, request }        request = kernel.py `handle` payload
 * Worker → main:
 *   { type: "status", phase, message }   phase: loading | ready | error
 *   { type: "stream", id, name, text }   live stdout / stderr
 *   { type: "reply", id, response }      parsed kernel response
 */
let pyodide = null;
let kernel = null;
let currentId = null;
let queue = Promise.resolve();

const status = (phase, message, extra) => self.postMessage({ type: "status", phase, message, ...extra });

async function init({ indexURL, kernelURL, interruptBuffer }) {
  try {
    status("loading", "Downloading the Python runtime");
    const { loadPyodide } = await import(indexURL + "pyodide.mjs");
    pyodide = await loadPyodide({ indexURL, stdout: () => {}, stderr: () => {} });
    if (interruptBuffer) pyodide.setInterruptBuffer(interruptBuffer);

    status("loading", "Installing NumPy");
    await pyodide.loadPackage("numpy");

    status("loading", "Starting the kernel");
    const source = await (await fetch(kernelURL)).text();
    pyodide.FS.writeFile("/home/pyodide/latent_kernel.py", source);
    pyodide.runPython("import sys; sys.path.insert(0, '/home/pyodide')");
    kernel = pyodide.pyimport("latent_kernel");
    kernel.EMIT = (name, text) => self.postMessage({ type: "stream", id: currentId, name, text });

    const versions = JSON.parse(pyodide.runPython("import sys, json, numpy; json.dumps({'python': sys.version.split()[0], 'numpy': numpy.__version__})"));
    status("ready", "Ready", { versions, interruptible: !!interruptBuffer });
  } catch (err) {
    status("error", (err && err.message) || String(err));
  }
}

async function call(id, request) {
  if (!kernel) {
    self.postMessage({ type: "reply", id, response: { ok: false, error: { ename: "RuntimeError", evalue: "Python is not ready yet", line: null, file: null, traceback: "" } } });
    return;
  }
  try {
    const sources = [request.code, request.test, ...(request.setup || [])].filter(Boolean).join("\n");
    if (/\bimport\b/.test(sources)) {
      try {
        await pyodide.loadPackagesFromImports(sources);
      } catch {
        /* unknown packages surface as ModuleNotFoundError when the code runs */
      }
    }
    currentId = id;
    const raw = kernel.handle(JSON.stringify(request));
    self.postMessage({ type: "reply", id, response: JSON.parse(raw) });
  } catch (err) {
    self.postMessage({
      type: "reply",
      id,
      response: { ok: false, error: { ename: "InternalError", evalue: (err && err.message) || String(err), line: null, file: null, traceback: String(err) } },
    });
  } finally {
    currentId = null;
  }
}

self.onmessage = (e) => {
  const msg = e.data;
  if (msg.type === "init") queue = queue.then(() => init(msg));
  else if (msg.type === "call") queue = queue.then(() => call(msg.id, msg.request));
};
