"""Latent interactive-lesson kernel.

Runs learner code inside Pyodide (and under CPython for the seed validator).
The web worker calls `handle(request_json)` and receives a JSON string back.
Output is streamed through `EMIT(stream_name, text)` when set.

Namespaces
  kernel  shared by a lesson's `run` cells, like a notebook
  fresh   a new namespace per call: challenges are checked in isolation

Every namespace starts with `import numpy as np` plus the lesson's setup cells.
"""

import ast
import base64
import io
import json
import linecache
import sys
import time
import traceback
import types

import numpy as np

EMIT = None  # set by the host: callable(stream_name, text)

USER_FILES = ("<cell>", "<setup>", "<test>")
MAX_OUTPUT = 100_000
MAX_STEPS = 1500

_kernel = {}
_setup = []
_exec_count = 0


# ── namespaces ─────────────────────────────────────────────


def _fresh_ns(setup):
    ns = {"__name__": "__main__", "__builtins__": __builtins__}
    exec("import numpy as np", ns)
    for src in setup or []:
        _prepare_matplotlib(src)
        _run_source(src, ns, "<setup>")
    return ns


def reset(setup=None):
    global _kernel, _setup, _exec_count
    _setup = list(setup or [])
    _exec_count = 0
    _kernel = _fresh_ns(_setup)


# ── output capture ─────────────────────────────────────────


class _Capture(io.TextIOBase):
    def __init__(self, name, sink):
        self.name = name
        self.sink = sink

    def writable(self):
        return True

    def write(self, s):
        if not isinstance(s, str):
            s = str(s)
        self.sink.write(self.name, s)
        return len(s)

    def flush(self):
        pass


class _Sink:
    def __init__(self, stream):
        self.stream = stream
        self.parts = []
        self.size = 0
        self.truncated = False

    def write(self, name, s):
        if not s or self.truncated:
            return
        if self.size + len(s) > MAX_OUTPUT:
            s = s[: MAX_OUTPUT - self.size]
            self.truncated = True
            s += "\n… output truncated …\n"
        self.size += len(s)
        self.parts.append((name, s))
        if self.stream and EMIT is not None:
            EMIT(name, s)

    def text(self, name="stdout"):
        return "".join(s for n, s in self.parts if n == name)


class _Redirect:
    def __init__(self, sink):
        self.sink = sink

    def __enter__(self):
        self.saved = sys.stdout, sys.stderr
        sys.stdout = _Capture("stdout", self.sink)
        sys.stderr = _Capture("stderr", self.sink)
        return self

    def __exit__(self, *exc):
        sys.stdout, sys.stderr = self.saved
        return False


# ── values ─────────────────────────────────────────────────


def _short_repr(v, limit, threshold=120):
    try:
        with np.printoptions(threshold=threshold, edgeitems=3, linewidth=78, precision=6):
            r = repr(v)
    except Exception:
        r = f"<{type(v).__name__} object>"
    return r if len(r) <= limit else r[:limit] + " …"


def describe(v, limit=4000, threshold=400):
    info = {"type": type(v).__name__}
    if isinstance(v, np.ndarray):
        info.update(kind="ndarray", shape=list(v.shape), dtype=str(v.dtype), nbytes=int(v.nbytes))
    elif isinstance(v, np.generic):
        info.update(kind="scalar", dtype=str(v.dtype))
    elif isinstance(v, (types.FunctionType, types.BuiltinFunctionType)):
        info.update(kind="function")
    elif isinstance(v, type):
        info.update(kind="class")
    elif isinstance(v, (list, tuple, dict, set)):
        info.update(kind="collection", length=len(v))
    else:
        info.update(kind="value")
    info["repr"] = _short_repr(v, limit, threshold)
    return info


def _visible(name, value):
    return not name.startswith("_") and not isinstance(value, types.ModuleType)


def variables(ns, limit=60):
    out = []
    for name, value in list(ns.items()):
        if _visible(name, value):
            d = describe(value, limit=600, threshold=60)
            d["name"] = name
            out.append(d)
    return out[:limit]


# ── execution ──────────────────────────────────────────────


def _register(src, filename):
    linecache.cache[filename] = (len(src), None, src.splitlines(True), filename)


def _compile(src, filename):
    """Compiles `src`, splitting off a trailing expression so its value can be displayed."""
    tree = ast.parse(src, filename, "exec")
    last = None
    if tree.body and isinstance(tree.body[-1], ast.Expr):
        last = ast.Expression(tree.body.pop().value)
    body = compile(tree, filename, "exec")
    return body, (compile(last, filename, "eval") if last else None)


def _run_source(src, ns, filename):
    _register(src, filename)
    body, last = _compile(src, filename)
    exec(body, ns)
    return eval(last, ns) if last else None


def format_error(e):
    frames = traceback.extract_tb(e.__traceback__)
    user = [f for f in frames if f.filename in USER_FILES]
    line = user[-1].lineno if user and user[-1].filename == "<cell>" else None
    if isinstance(e, SyntaxError) and e.filename == "<cell>":
        line = e.lineno
    te = traceback.TracebackException.from_exception(e, capture_locals=False)
    te.stack = traceback.StackSummary.from_list(user)
    te.__cause__ = te.__context__ = None
    lines = list(te.format())
    if len(lines) > 1 and lines[0].startswith("Traceback") and not user:
        lines = lines[1:]
    where = user[-1].filename if user else ("<cell>" if line else None)
    return {
        "ename": type(e).__name__,
        "evalue": str(e),
        "line": line,
        "file": where,
        "traceback": "".join(lines).rstrip(),
    }


def _figures():
    if "matplotlib.pyplot" not in sys.modules:
        return []
    plt = sys.modules["matplotlib.pyplot"]
    images = []
    for num in plt.get_fignums():
        fig = plt.figure(num)
        buf = io.BytesIO()
        fig.savefig(buf, format="png", dpi=110, bbox_inches="tight")
        images.append(base64.b64encode(buf.getvalue()).decode("ascii"))
    plt.close("all")
    return images


def _prepare_matplotlib(src):
    if "matplotlib" not in src or "matplotlib.pyplot" in sys.modules:
        return
    try:
        import matplotlib

        matplotlib.use("Agg")
        import matplotlib.pyplot as plt

        plt.show = lambda *a, **k: None
        plt.rcParams.update({"figure.figsize": (6.4, 3.6), "figure.dpi": 110, "axes.spines.top": False, "axes.spines.right": False})
    except Exception:
        pass


class _StepLimit(Exception):
    pass


def _stack(frame):
    out = []
    f = frame
    while f is not None:
        if f.f_code.co_filename == "<cell>":
            out.append({"func": f.f_code.co_name, "line": f.f_lineno})
        f = f.f_back
    return out[::-1]


def _snapshot(frame):
    snap = {}
    for name, value in list(frame.f_locals.items()):
        if _visible(name, value) and not isinstance(value, (types.FunctionType, type)):
            snap[name] = describe(value, limit=400, threshold=40)
        if len(snap) >= 40:
            break
    return snap


def _traced(fn, sink, steps):
    def tracer(frame, event, arg):
        if frame.f_code.co_filename != "<cell>":
            return None
        # Module-level "return" events are noise (the final "end" step covers them).
        if event == "return" and frame.f_code.co_name == "<module>":
            return tracer
        if event in ("line", "return", "exception"):
            step = {
                "line": frame.f_lineno,
                "event": event,
                "func": frame.f_code.co_name,
                "stack": _stack(frame),
                "vars": _snapshot(frame),
                "out": sum(len(s) for _, s in sink.parts),
            }
            if event == "return":
                step["value"] = describe(arg, limit=300, threshold=40)
            elif event == "exception":
                step["exc"] = f"{arg[0].__name__}: {arg[1]}"
            steps.append(step)
            if len(steps) >= MAX_STEPS:
                raise _StepLimit()
        return tracer

    sys.settrace(tracer)
    try:
        return fn()
    finally:
        sys.settrace(None)


def execute(code, ns, *, trace=False, stream=True):
    """Runs `code` in `ns`. Returns a result dict (never raises for user errors)."""
    sink = _Sink(stream)
    steps = [] if trace else None
    result = {"ok": True, "value": None, "error": None, "images": [], "steps": None, "truncatedSteps": False}
    _prepare_matplotlib(code)
    started = time.perf_counter()
    with _Redirect(sink):
        try:
            run = lambda: _run_source(code, ns, "<cell>")
            value = _traced(run, sink, steps) if trace else run()
            if value is not None:
                result["value"] = describe(value)
        except _StepLimit:
            result["truncatedSteps"] = True
        except KeyboardInterrupt:
            result["ok"] = False
            result["error"] = {"ename": "KeyboardInterrupt", "evalue": "Execution interrupted", "line": None, "file": None, "traceback": "KeyboardInterrupt: execution was stopped"}
        except BaseException as e:  # noqa: BLE001 — report everything, including SystemExit
            result["ok"] = False
            result["error"] = format_error(e)
    result["duration"] = round((time.perf_counter() - started) * 1000, 2)
    try:
        result["images"] = _figures()
    except Exception:
        pass
    result["stdout"] = sink.text("stdout")
    result["stderr"] = sink.text("stderr")
    if trace:
        steps.append({"line": None, "event": "end", "func": "<module>", "stack": [], "vars": _snapshot(_Frame(ns)), "out": sum(len(s) for _, s in sink.parts)})
        result["steps"] = steps
        result["output"] = "".join(s for _, s in sink.parts)
    return result


class _Frame:
    """Minimal stand-in so `_snapshot` can read a namespace."""

    def __init__(self, ns):
        self.f_locals = ns


def check(code, test, setup=None, stream=True):
    """Runs a challenge: setup → learner code → hidden tests, all in a fresh namespace."""
    try:
        ns = _fresh_ns(setup)
    except BaseException as e:  # noqa: BLE001
        return {"ok": False, "error": format_error(e), "passed": False, "message": "The lesson setup failed to run.", "stdout": "", "stderr": "", "images": [], "value": None}
    res = execute(code, ns, stream=stream)
    if not res["ok"]:
        res["passed"] = False
        res["message"] = None
        return res
    ns["_stdout"] = res["stdout"]
    sink = _Sink(False)
    with _Redirect(sink):
        try:
            _run_source(test or "", ns, "<test>")
            res["passed"] = True
            res["message"] = None
        except AssertionError as e:
            res["passed"] = False
            res["message"] = str(e) or "One of the checks did not pass."
        except BaseException as e:  # noqa: BLE001
            res["passed"] = False
            name = type(e).__name__
            if isinstance(e, NameError):
                missing = getattr(e, "name", None) or str(e)
                res["message"] = f"Your code needs to define `{missing}`." if getattr(e, "name", None) else f"{name}: {e}"
            else:
                res["message"] = f"The checker hit {name}: {e}"
    return res


# ── completion ─────────────────────────────────────────────


def complete(expr):
    """Attribute and name completion for a dotted expression like `np.li` or `arr.re`."""
    if not all(part.isidentifier() for part in expr.split(".")[:-1]):
        return []
    *head, prefix = expr.split(".")
    if head:
        try:
            obj = _kernel[head[0]] if head[0] in _kernel else __builtins__[head[0]] if isinstance(__builtins__, dict) else getattr(__builtins__, head[0])
            for part in head[1:]:
                obj = getattr(obj, part)
        except Exception:
            return []
        names = [n for n in dir(obj) if n.startswith(prefix) and (prefix.startswith("_") or not n.startswith("_"))]
        out = []
        for n in names[:200]:
            try:
                attr = getattr(obj, n)
                kind = "function" if callable(attr) and not isinstance(attr, type) else "class" if isinstance(attr, type) else "module" if isinstance(attr, types.ModuleType) else "property"
            except Exception:
                kind = "property"
            out.append({"label": n, "type": kind})
        return out
    names = set(_kernel) | set(dir(__builtins__) if not isinstance(__builtins__, dict) else __builtins__)
    return [{"label": n, "type": "variable" if n in _kernel else "builtin"} for n in sorted(names) if n.startswith(prefix) and not n.startswith("_")][:200]


# ── host entry point ───────────────────────────────────────


def handle(request_json):
    global _exec_count
    req = json.loads(request_json)
    op = req.get("op")
    if op == "reset":
        try:
            reset(req.get("setup"))
            return json.dumps({"ok": True, "vars": variables(_kernel)})
        except BaseException as e:  # noqa: BLE001
            reset([])
            return json.dumps({"ok": False, "error": format_error(e), "vars": []})
    if op == "run":
        fresh = req.get("ns") == "fresh"
        ns = _fresh_ns(req.get("setup") or _setup) if fresh else _kernel
        res = execute(req["code"], ns, trace=bool(req.get("trace")))
        if not fresh:
            _exec_count += 1
            res["count"] = _exec_count
            res["vars"] = variables(_kernel)
        return json.dumps(res)
    if op == "check":
        return json.dumps(check(req["code"], req.get("test"), req.get("setup") or _setup))
    if op == "vars":
        return json.dumps({"vars": variables(_kernel)})
    if op == "complete":
        return json.dumps({"items": complete(req.get("expr", ""))})
    return json.dumps({"ok": False, "error": {"ename": "ValueError", "evalue": f"unknown op {op!r}", "line": None, "file": None, "traceback": ""}})


reset([])
