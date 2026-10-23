Every application ends up talking to servers, and every server eventually has a bad afternoon. Requests fail with a dropped connection, return a 503 during a deploy, or take ten seconds when the user has already navigated away. A good API client handles those moments without making the app worse: it retries the failures that are worth retrying, reuses answers it already has, shares work that's already in flight, and stops waiting when nobody needs the result anymore.

In this final capstone you'll build those behaviors one stage at a time: classifying and reporting HTTP failures, retrying with exponential backoff, caching with a clock you control, and cancelling with `AbortController`. Then you'll compose all four into one `createApiClient`. There's no network in this course, so the client takes a `transport` function as an argument. In an app that would wrap `fetch`, and in tests it's a fake that you script. Keeping the transport injected is the same dependency-injection habit from the testing lesson, and it's what makes every behavior here deterministic.

## The transport contract

A transport is an async function from a path to `{ status, body }`. A successful HTTP exchange resolves with its status. A network failure, such as a dropped connection, rejects instead. The client has to treat those two kinds of failure differently, and the first challenge is about making that distinction visible in the error.

```js run
const fakeTransport = async (path) =>
  path === "/ok" ? { status: 200, body: { hello: "world" } } : { status: 404, body: null };

const res = await fakeTransport("/ok");
console.log(res.status, res.body);
```

## Stage 1: turn HTTP status into a usable error

The client should return the body for a 2xx response and throw for everything else. The thrown error needs a `status` property, because retry and display logic both need to know what happened. Attaching the status to an `Error` with `Object.assign` keeps the message readable and the data machine-friendly.

```js exercise id=fetch-json title="Return the body, or throw with the status"
async function fetchJson(transport, path) {
  // TODO: call transport(path). Return res.body for a 2xx status.
  // For any other status, throw an Error whose message includes the status
  // and which has a numeric `status` property.
  return null;
}
--- solution
async function fetchJson(transport, path) {
  const res = await transport(path);
  if (res.status < 200 || res.status >= 300) {
    throw Object.assign(new Error(`Request failed with ${res.status}`), { status: res.status });
  }
  return res.body;
}
--- test
const ok = async (path) => ({ status: 200, body: { path } });
assertEqual(await fetchJson(ok, "/users"), { path: "/users" }, "A 2xx response should return its body");
const missing = async () => ({ status: 404, body: null });
let caught = null;
try {
  await fetchJson(missing, "/nope");
} catch (err) {
  caught = err;
}
assert(caught instanceof Error, "A 404 should throw an Error");
assertEqual(caught.status, 404, "The error should carry the HTTP status");
assert(caught.message.includes("404"), "The message should mention the status");
--- hint
Check the range first: `res.status < 200 || res.status >= 300` means the request failed. Return `res.body` in the other case.
--- hint
Build the error with `Object.assign(new Error(message), { status: res.status })`, and throw it.
```

## Stage 2: retry transient failures with backoff

Retrying is only safe for failures that might succeed later. A network error and a 5xx response are transient. A 404 or 400 will fail the same way every time, so retrying it wastes time and can hammer a server that's already unhappy. Retries also need spacing: waiting a little longer after each failure (exponential backoff) gives a struggling server room to recover.

The helper below takes a function that receives the attempt number, retries the transient cases, and throws the last error when it runs out of attempts.

Here is the shape of a retry loop with a fake operation that fails once before it succeeds:

```js run
const attempts = [];
const flakyOnce = async () => {
  attempts.push(attempts.length);
  if (attempts.length < 2) throw new Error("transient");
  return "recovered";
};

let result = null;
for (let i = 0; i < 3 && result === null; i++) {
  try {
    result = await flakyOnce();
  } catch {
    await new Promise((r) => setTimeout(r, 5));
  }
}
console.log(result, attempts.length);
```

The loop is the core of every retry helper. Each failed attempt waits before the next one, and the loop stops at a fixed budget so a permanent failure can't spin forever.

```js exercise id=with-retry title="Retry transient failures with exponential backoff"
async function withRetry(fn, { retries = 2, baseDelay = 5 } = {}) {
  // TODO: call fn(attempt), starting at attempt 0. Return its result.
  // If it throws a transient failure (no status, or status 500 or higher), wait
  // baseDelay * 2 ** attempt milliseconds and try again, up to `retries` retries.
  // Errors with a 4xx status are thrown immediately. When retries run out, throw the last error.
  return null;
}
--- solution
async function withRetry(fn, { retries = 2, baseDelay = 5 } = {}) {
  for (let attempt = 0; ; attempt++) {
    try {
      return await fn(attempt);
    } catch (err) {
      const transient = err.status === undefined || err.status >= 500;
      if (!transient || attempt >= retries) throw err;
      await new Promise((r) => setTimeout(r, baseDelay * 2 ** attempt));
    }
  }
}
--- test
let calls = 0;
const flaky = async () => {
  calls++;
  if (calls < 3) throw Object.assign(new Error("503"), { status: 503 });
  return "ok";
};
assertEqual(await withRetry(flaky, { baseDelay: 1 }), "ok", "A flaky call should succeed on a later attempt");
assertEqual(calls, 3, "It should keep trying until the call succeeds");

let notFound = 0;
const missing = async () => {
  notFound++;
  throw Object.assign(new Error("404"), { status: 404 });
};
let status = null;
try {
  await withRetry(missing, { baseDelay: 1 });
} catch (err) {
  status = err.status;
}
assertEqual(status, 404, "A 4xx error should be thrown");
assertEqual(notFound, 1, "A 4xx error should never be retried");

let down = 0;
const broken = async () => {
  down++;
  throw Object.assign(new Error("down"), { status: 500 });
};
let last = null;
try {
  await withRetry(broken, { retries: 2, baseDelay: 1 });
} catch (err) {
  last = err.message;
}
assertEqual(down, 3, "One try plus two retries, then give up");
assertEqual(last, "down", "The last error should be thrown");
--- hint
A `for` loop with a `try` inside can `return` the result on success. In the `catch`, decide whether the error is transient, and if it is not, throw it.
--- hint
Wait with `await new Promise((r) => setTimeout(r, baseDelay * 2 ** attempt))`. Give up when `attempt >= retries`.
```

> **Pitfall:** Retrying a non-idempotent request (a POST that charges a card, for example) can repeat its side effect. Retry reads freely, and retry writes only when the server supports idempotency keys.

## Stage 3: cache with an injected clock

A cache with a time-to-live needs to know the current time, and calling `Date.now()` inside it would make the tests depend on the real clock. Injecting `now` solves that. The cache also needs one more guarantee: if ten components ask for the same resource at the same moment, the loader should run once, and all ten should wait on the same promise. Failed loads must never be cached, or one bad response would poison the cache for the whole TTL.

A cache entry needs a timestamp and a freshness check against the current time. Passing the clock in as a function means a test can move time forward on purpose:

```js run
let clock = 0;
const cache = new Map();
const remember = (key, value) => cache.set(key, { value, at: clock });
const recall = (key, ttl) => {
  const hit = cache.get(key);
  return hit && clock - hit.at < ttl ? hit.value : undefined;
};

remember("user", "Ada");
clock = 50;
console.log(recall("user", 100));
clock = 150;
console.log(recall("user", 100));
```

The first read is fresh, and the second one falls outside the 100 ms window, so the cache reports a miss. The exercise below adds the loader and the sharing rules on top of this check.

```js exercise id=cached-getter title="A cached getter with a TTL and shared loads"
function createCachedGetter(loader, { ttl = 1000, now = () => 0 } = {}) {
  // TODO: return get(key). It returns a promise for loader(key), with these rules:
  // 1. A value loaded less than `ttl` ms ago (by now()) is returned without calling loader.
  // 2. Concurrent calls for the same key share one loader call.
  // 3. A failed load rejects the caller and is not cached.
  return null;
}
--- solution
function createCachedGetter(loader, { ttl = 1000, now = () => 0 } = {}) {
  const cache = new Map();
  const inflight = new Map();
  return (key) => {
    const hit = cache.get(key);
    if (hit && now() - hit.at < ttl) return Promise.resolve(hit.value);
    if (!inflight.has(key)) {
      inflight.set(
        key,
        loader(key).then(
          (value) => {
            cache.set(key, { value, at: now() });
            inflight.delete(key);
            return value;
          },
          (err) => {
            inflight.delete(key);
            throw err;
          },
        ),
      );
    }
    return inflight.get(key);
  };
}
--- test
let clock = 0;
let loads = 0;
const get = createCachedGetter(
  async (k) => {
    loads++;
    return k.toUpperCase();
  },
  { ttl: 100, now: () => clock },
);
const [a, b] = await Promise.all([get("x"), get("x")]);
assertEqual([a, b], ["X", "X"], "Concurrent callers should get the same value");
assertEqual(loads, 1, "Concurrent requests for one key should share a single load");
assertEqual(await get("x"), "X", "A fresh cache entry should be returned");
assertEqual(loads, 1, "A cache hit should not load again");
clock = 150;
await get("x");
assertEqual(loads, 2, "After the TTL, the value should be loaded again");

let failNext = true;
const shaky = createCachedGetter(async () => {
  if (failNext) throw new Error("offline");
  return "back";
});
let message = null;
try {
  await shaky("k");
} catch (err) {
  message = err.message;
}
failNext = false;
assertEqual(message, "offline", "A failed load should reject the caller");
assertEqual(await shaky("k"), "back", "A failed load should not be cached");
--- hint
Keep two maps: one for finished values (with the time they were stored) and one for promises that are still loading. Check the cache first, then the in-flight map, and only then call the loader.
--- hint
Store the loader's promise in `inflight` right away, and in its `then` callbacks write the value to `cache` and delete the in-flight entry on success or failure.
```

> **Under the hood:** Storing the promise, not the value, is what makes concurrent requests share one load. The second caller finds the same pending promise in the map, so it waits on the work already in progress instead of starting a duplicate.

## Stage 4: cancel work nobody is waiting for

A user who navigates away should not keep a request alive in the UI layer. `AbortController` is the standard tool: it produces a `signal`, and when you call `abort()`, every listener on the signal runs. The client's job is to honor the signal by rejecting early, without calling a task that has already been cancelled.

```js run
const controller = new AbortController();
console.log(controller.signal.aborted);
controller.abort();
console.log(controller.signal.aborted, controller.signal.reason.name);
```

The helper below turns a signal into a rejection. Cancellation doesn't stop the underlying task (JavaScript promises can't be stopped), so it only decides whether the caller still gets the result.

```js exercise id=run-cancellable title="Reject early when the signal aborts"
function runCancellable(task, signal) {
  // TODO: return a promise for task(). Rules:
  // - If signal is already aborted, reject with an Error named "AbortError" and do not call task.
  // - If the signal aborts while the task runs, reject with an AbortError right away.
  // - Otherwise resolve or reject with the task's own outcome.
  return null;
}
--- solution
function runCancellable(task, signal) {
  const abortError = () => Object.assign(new Error("Aborted"), { name: "AbortError" });
  return new Promise((resolve, reject) => {
    if (signal?.aborted) return reject(abortError());
    const onAbort = () => reject(abortError());
    signal?.addEventListener("abort", onAbort, { once: true });
    Promise.resolve()
      .then(task)
      .then(resolve, reject)
      .finally(() => signal?.removeEventListener("abort", onAbort));
  });
}
--- test
let ran = false;
const pre = new AbortController();
pre.abort();
let preName = null;
try {
  await runCancellable(() => {
    ran = true;
    return 1;
  }, pre.signal);
} catch (err) {
  preName = err.name;
}
assertEqual(preName, "AbortError", "An already aborted signal should reject with AbortError");
assertEqual(ran, false, "The task should not start when the signal is already aborted");

const ctrl = new AbortController();
const slow = runCancellable(() => new Promise((r) => setTimeout(() => r("done"), 50)), ctrl.signal);
setTimeout(() => ctrl.abort(), 10);
let lateName = null;
try {
  await slow;
} catch (err) {
  lateName = err.name;
}
assertEqual(lateName, "AbortError", "Aborting while the task runs should reject early");
assertEqual(await runCancellable(async () => "fine", new AbortController().signal), "fine", "Without an abort, the result should pass through");
--- hint
Check `signal?.aborted` before you start the task. If the signal is still live, add an `abort` listener that rejects the promise.
--- hint
`signal.addEventListener("abort", onAbort, { once: true })` registers the listener. Remove it in `finally` so finished requests don't keep listeners alive.
```

> **Pitfall:** Forgetting to remove `abort` listeners is a quiet memory leak. A long-lived signal, such as one tied to the whole page, keeps every finished request's callback alive until it's removed.

## Predict: the exponent is right-associative

Retry schedules are often written as powers, which brings in one operator rule you have to know cold. Predict this before you check the options.

```js predict id=predict-backoff-math title="Backoff delays and a surprising exponent"
const delays = [0, 1, 2, 3].map((attempt) => 100 * 2 ** attempt);
console.log(delays.join(" "), 2 ** 3 ** 2);
--- options
100 200 400 800 64
100 200 400 800 8
200 400 800 1600 512
* 100 200 400 800 512
--- explain
The first part maps each attempt to `100 * 2 ** attempt`, giving 100, 200, 400 and 800. The second part looks like it should be `(2 ** 3) ** 2`, which is 64, but `**` is right-associative, so `3 ** 2` is evaluated first and the expression becomes `2 ** 9`, which is 512. Wrap the parts in parentheses whenever you want a specific grouping, especially in backoff formulas.
```

## Final: compose the client

Now combine the stages into `createApiClient`. Its `get` method has to do all of this, in a specific order:

1. Refuse immediately if the signal is already aborted.
2. Return a fresh cached body if one exists.
3. Share one in-flight load per path, where the load itself retries transient failures and throws the status errors from stage 1.
4. Stop waiting as soon as the signal aborts, and don't cache results that arrive after the caller has gone.

The structure is the same as the stage functions, arranged so each one has one job. The final solution keeps the load loop self-contained, because the integrated challenge runs in a fresh scope.

```js exercise id=create-api-client title="An API client with retries, caching and cancellation"
function createApiClient({ transport, retries = 2, baseDelay = 5, ttl = 1000, now = () => 0 }) {
  // TODO: return { get(path, { signal }) }. Rules:
  // 1. An aborted signal rejects with an AbortError before anything else happens.
  // 2. A body cached less than ttl ms ago (by now()) is returned without calling transport.
  // 3. Concurrent calls for the same path share one in-flight load.
  // 4. Network failures (transport rejects) and 5xx responses are retried with exponential backoff.
  // 5. Other non-2xx responses, and retries that run out, throw an Error with a numeric `status`.
  // 6. Aborting while a load is in flight rejects that caller with an AbortError.
  return null;
}
--- solution
function createApiClient({ transport, retries = 2, baseDelay = 5, ttl = 1000, now = () => 0 }) {
  const cache = new Map();
  const inflight = new Map();
  const abortError = () => Object.assign(new Error("Aborted"), { name: "AbortError" });
  const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
  const load = async (path) => {
    for (let attempt = 0; ; attempt++) {
      let res;
      try {
        res = await transport(path);
      } catch {
        res = { status: 0, body: null };
      }
      if (res.status >= 200 && res.status < 300) return res.body;
      const transient = res.status === 0 || res.status >= 500;
      if (!transient || attempt >= retries) {
        throw Object.assign(new Error(`Request failed with ${res.status}`), { status: res.status });
      }
      await sleep(baseDelay * 2 ** attempt);
    }
  };
  const abortable = (promise, signal) =>
    new Promise((resolve, reject) => {
      const onAbort = () => reject(abortError());
      signal?.addEventListener("abort", onAbort, { once: true });
      promise.then(resolve, reject).finally(() => signal?.removeEventListener("abort", onAbort));
    });
  return {
    async get(path, { signal } = {}) {
      if (signal?.aborted) throw abortError();
      const hit = cache.get(path);
      if (hit && now() - hit.at < ttl) return hit.body;
      if (!inflight.has(path)) {
        inflight.set(path, load(path).finally(() => inflight.delete(path)));
      }
      const body = await abortable(inflight.get(path), signal);
      cache.set(path, { body, at: now() });
      return body;
    },
  };
}
--- test
let clock = 0;
const seen = { count: 0 };
let failures = 2;
const transport = async (path) => {
  seen.count++;
  if (path === "/down") return { status: 404, body: null };
  if (path === "/flaky" && failures > 0) {
    failures--;
    throw new Error("network");
  }
  return { status: 200, body: `body of ${path}` };
};
const api = createApiClient({ transport, retries: 2, baseDelay: 1, ttl: 100, now: () => clock });

assertEqual(await api.get("/flaky"), "body of /flaky", "Network failures should be retried until success");
assertEqual(seen.count, 3, "Two failures plus one success should be three transport calls");

const beforeHit = seen.count;
await api.get("/flaky");
assertEqual(seen.count, beforeHit, "A fresh cached body should not call the transport");
clock = 500;
await api.get("/flaky");
assertEqual(seen.count, beforeHit + 1, "An expired entry should be fetched again");

const beforeShared = seen.count;
const [x, y] = await Promise.all([api.get("/other"), api.get("/other")]);
assertEqual(x, "body of /other", "Shared loads should return the body");
assertEqual(y, x, "Both callers should get the same result");
assertEqual(seen.count - beforeShared, 1, "Concurrent requests for one path should share one transport call");

let downStatus = null;
try {
  await api.get("/down");
} catch (err) {
  downStatus = err.status;
}
assertEqual(downStatus, 404, "A 4xx response should throw with its status");

const ctrl = new AbortController();
ctrl.abort();
let abortName = null;
try {
  await api.get("/other", { signal: ctrl.signal });
} catch (err) {
  abortName = err.name;
}
assertEqual(abortName, "AbortError", "An aborted signal should reject with AbortError");

let brokenCalls = 0;
const broken = createApiClient({
  transport: async () => {
    brokenCalls++;
    return { status: 503, body: null };
  },
  retries: 1,
  baseDelay: 1,
});
let brokenStatus = null;
try {
  await broken.get("/x");
} catch (err) {
  brokenStatus = err.status;
}
assertEqual(brokenStatus, 503, "Exhausted retries should throw with the last status");
assertEqual(brokenCalls, 2, "One try plus one retry");
--- hint
Keep three things: a `cache` Map of finished bodies with their timestamps, an `inflight` Map of pending loads, and a `load(path)` loop that retries transient failures with `sleep(baseDelay * 2 ** attempt)`.
--- hint
In `get`, check the signal, then the cache, then start a load only if `inflight` has none. Race the shared promise against the signal with a small helper that rejects on `abort`, and store the body in `cache` once it arrives.
```

## Debugging: the cache that never expires

The final challenge is a debugging exercise on the stage 3 cache. The bug is a sign error in the age check, and it's the kind that passes every test where the clock never moves.

```js debug id=cache-expiry title="A cache that never expires"
function createCachedGetter(loader, { ttl = 1000, now = () => 0 } = {}) {
  const cache = new Map();
  const inflight = new Map();
  return (key) => {
    const hit = cache.get(key);
    if (hit && hit.at - now() < ttl) return Promise.resolve(hit.value);
    if (!inflight.has(key)) {
      inflight.set(
        key,
        loader(key).then(
          (value) => {
            cache.set(key, { value, at: now() });
            inflight.delete(key);
            return value;
          },
          (err) => {
            inflight.delete(key);
            throw err;
          },
        ),
      );
    }
    return inflight.get(key);
  };
}
--- solution
function createCachedGetter(loader, { ttl = 1000, now = () => 0 } = {}) {
  const cache = new Map();
  const inflight = new Map();
  return (key) => {
    const hit = cache.get(key);
    if (hit && now() - hit.at < ttl) return Promise.resolve(hit.value);
    if (!inflight.has(key)) {
      inflight.set(
        key,
        loader(key).then(
          (value) => {
            cache.set(key, { value, at: now() });
            inflight.delete(key);
            return value;
          },
          (err) => {
            inflight.delete(key);
            throw err;
          },
        ),
      );
    }
    return inflight.get(key);
  };
}
--- test
let clock = 0;
let loads = 0;
const get = createCachedGetter(
  async () => {
    loads++;
    return loads;
  },
  { ttl: 100, now: () => clock },
);
await get("k");
await get("k");
assertEqual(loads, 1, "A fresh entry should be served from the cache");
clock = 100;
const stale = await get("k");
assertEqual(loads, 2, "Once the TTL has passed, the loader should run again");
assertEqual(stale, 2, "The new value should come from the second load");
--- hint
Read the age check out loud. How much time has passed since the entry was stored? Which number should be subtracted from which?
--- hint
The age is `now() - hit.at`. The check is only fresh while that age is less than `ttl`. The current code subtracts the other way around, so the age is always negative.
```

## Recap

- Treat a network failure and an HTTP status as different events, and attach the status to the error so the rest of the code can act on it.
- Retry only transient failures, and space the attempts with exponential backoff.
- Inject `now` and the transport, so cache expiry and retries stay deterministic in tests.
- Share in-flight work by storing the promise, and never cache a failed load.
- Cancellation rejects the caller early through an `abort` listener. It can't stop the underlying work, so clean up the listener.
- Use parentheses when you write exponent formulas, because `**` groups to the right.

**Up next:** the course is complete. Take the final exam to check how well the advanced ideas hold together.
