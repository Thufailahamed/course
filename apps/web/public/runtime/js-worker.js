/* Latent JavaScript runtime: runs lesson code in a module Web Worker.
 *
 * Same protocol as python-worker.js, so the runtime client can drive either one:
 *   main → worker  { type: "init" }   and   { type: "call", id, request }
 *   worker → main  { type: "status", phase, message, versions? }
 *                  { type: "stream", id, name, text }
 *                  { type: "reply", id, response }
 */
import { handle, setEmit } from "./js-kernel.mjs";

let currentId = null;
let queue = Promise.resolve();

const status = (phase, message, extra) => self.postMessage({ type: "status", phase, message, ...extra });

function init() {
  setEmit((name, text) => self.postMessage({ type: "stream", id: currentId, name, text }));
  status("ready", "Ready", { versions: { javascript: "ES2024" }, interruptible: false });
}

async function call(id, request) {
  currentId = id;
  try {
    const response = await handle(request);
    self.postMessage({ type: "reply", id, response });
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
  if (msg.type === "init") queue = queue.then(init);
  else if (msg.type === "call") queue = queue.then(() => call(msg.id, msg.request));
};
