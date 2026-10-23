"""Executes interactive-lesson cells with the same kernel the browser uses.

Job:    {"kernel": "<dir containing kernel.py>", "lessons": [{"file": ..., "cells": [...]}]}
Result: {"results": [{"file": ..., "findings": [{"cell", "ok", "message"}]}]}

Runs inside Pyodide (validate.mjs default, exact browser parity) or as a CPython script reading the job on stdin.
"""

import json
import sys
import time

SLOW_MS = 1500


def output_of(r):
    parts = [r["stdout"].rstrip()]
    if r.get("value"):
        parts.append(r["value"]["repr"])
    text = "\n".join(p for p in parts if p)
    return "\n".join(line.rstrip() for line in text.split("\n")).strip()


def err(r):
    e = r.get("error") or {}
    return f"{e.get('ename')}: {e.get('evalue')} (line {e.get('line')} of {e.get('file')})"


def run_job(job):
    sys.path.insert(0, job["kernel"])
    global kernel
    import kernel

    # The first matplotlib import is a one-time ~5 s cost in Pyodide (the browser shows a
    # "Running…" state); warm it up so the slow-cell check measures the cells themselves.
    if any("matplotlib" in (c["code"] + (c["solution"] or "")) for l in job["lessons"] for c in l["cells"]):
        kernel._prepare_matplotlib("matplotlib")

    results = []
    for lesson in job["lessons"]:
        findings = []
        add = lambda cell, ok, msg: findings.append({"cell": cell, "ok": ok, "message": msg})
        cells = lesson["cells"]
        setup = [c["code"] for c in cells if c["kind"] == "setup"]
        try:
            kernel.reset(setup)
        except BaseException as e:  # noqa: BLE001
            add("setup", False, f"setup failed: {kernel.format_error(e)['traceback']}")
            results.append({"file": lesson["file"], "findings": findings})
            continue
        for c in cells:
            cid = c["id"]
            t0 = time.perf_counter()
            if c["kind"] == "run":
                r = kernel.execute(c["code"], kernel._kernel, stream=False)
                if c["expectError"]:
                    add(cid, not r["ok"], "raises as intended" if not r["ok"] else "marked `error` but ran cleanly")
                else:
                    add(cid, r["ok"], "runs" if r["ok"] else err(r))
                if r["ok"] and not c["expectError"] and not (r["stdout"].strip() or r.get("value") or r["images"]):
                    findings.append({"cell": cid, "ok": True, "warn": True, "message": "run cell produces no visible output; end with an expression or print()"})
            elif c["kind"] in ("exercise", "debug"):
                s = kernel.check(c["solution"] or "", c["test"], setup, stream=False)
                add(cid, bool(s.get("passed")), "solution passes" if s.get("passed") else f"solution FAILS: {s.get('message') or err(s)}")
                st = kernel.check(c["code"], c["test"], setup, stream=False)
                add(cid, not st.get("passed"), "starter fails as expected" if not st.get("passed") else "starter code already PASSES the tests")
                if not st.get("passed"):
                    findings.append({"cell": cid, "ok": True, "message": f"starter feedback: {st.get('message') or err(st)}", "info": True})
            elif c["kind"] == "predict":
                correct = [o for o in c["options"] if o["correct"]]
                r = kernel.execute(c["code"], kernel._fresh_ns(setup), stream=False)
                actual = output_of(r)
                if not r["ok"]:
                    add(cid, False, err(r))
                elif len(correct) != 1:
                    add(cid, False, "needs exactly one `* ` option")
                else:
                    ok = actual == correct[0]["text"].strip()
                    add(cid, ok, "correct option matches output" if ok else f"actual output {actual!r} != marked option {correct[0]['text']!r}")
                    dupes = [o["text"] for o in c["options"] if o["text"].strip() == actual and not o["correct"]]
                    if dupes:
                        add(cid, False, "a wrong option also equals the real output")
            ms = (time.perf_counter() - t0) * 1000
            if ms > SLOW_MS:
                add(cid, False, f"slow: {ms:.0f} ms (keep cells snappy in the browser; re-run if the machine was busy)")
        results.append({"file": lesson["file"], "findings": findings})

    return {"results": results}


if __name__ == "__main__":
    json.dump(run_job(json.load(sys.stdin)), sys.stdout)
