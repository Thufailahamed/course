/* C runtime worker. Clang 22 compiled to WebAssembly (@live-codes/clang-wasm), so every
 * learner program is compiled and run here, in the browser, and never on our servers.
 * The package's browser bundle sets `self.clangWasm`. Assets (about 29 MB, cached after
 * the first visit) come from jsDelivr, pinned to the version the Node validator uses. */

const PACKAGE = "https://cdn.jsdelivr.net/npm/@live-codes/clang-wasm@0.3.0";

let compiler = null;
let queue = Promise.resolve();

function getCompiler() {
  if (!compiler) {
    importScripts(`${PACKAGE}/dist/clang-wasm.global.js`);
    compiler = self.clangWasm.createCompiler("c", {
      baseUrl: `${PACKAGE}/assets/`,
      onProgress: (value) => self.postMessage({ type: "status", phase: "loading", message: `Downloading the C compiler ${Math.round(value * 100)}%` }),
    });
  }
  return compiler;
}

async function compileAndRun(source) {
  const c = await getCompiler();
  let r;
  try {
    r = await c.run(source, "");
  } catch (err) {
    // Compile errors come back as values. A thrown error means the program ran and trapped
    // (a WebAssembly trap such as a stack overflow), so report it as a crash.
    return { compiled: true, crashed: true, exitCode: 1, stdout: "", stderr: `The program crashed: ${err.message ?? err}`, errors: [], duration: 0 };
  }
  return { compiled: r.exitCode !== null, exitCode: r.exitCode, stdout: r.stdout, stderr: r.stderr, errors: r.errors, duration: r.runMs ?? r.compileMs ?? 0 };
}

self.onmessage = async (e) => {
  const msg = e.data;
  if (msg.type === "init") {
    try {
      await getCompiler();
      self.postMessage({ type: "status", phase: "ready", message: "C" });
    } catch (err) {
      self.postMessage({ type: "status", phase: "error", message: `The C compiler failed to load: ${err.message ?? err}` });
    }
    return;
  }
  if (msg.type === "call") {
    // Requests run one at a time: the compiler instance is not re-entrant.
    queue = queue.then(async () => {
      let response;
      try {
        response = await compileAndRun(msg.source);
      } catch (err) {
        response = { compiled: false, exitCode: null, stdout: "", stderr: "", errors: [String(err.message ?? err)], duration: 0 };
      }
      self.postMessage({ type: "reply", id: msg.id, response });
    });
  }
};
