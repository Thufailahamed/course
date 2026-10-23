DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_mlops_in_production');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_mlops_in_production');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_mlops_in_production');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_mlops_in_production');

DELETE FROM discussions WHERE course_id = 'crs_mlops_in_production';

DELETE FROM certificates WHERE course_id = 'crs_mlops_in_production';

DELETE FROM enrollments WHERE course_id = 'crs_mlops_in_production';

DELETE FROM reviews WHERE course_id = 'crs_mlops_in_production';

DELETE FROM wishlist WHERE course_id = 'crs_mlops_in_production';

DELETE FROM path_courses WHERE course_id = 'crs_mlops_in_production';

DELETE FROM coupons WHERE course_id = 'crs_mlops_in_production';

DELETE FROM lessons WHERE course_id = 'crs_mlops_in_production';

DELETE FROM sections WHERE course_id = 'crs_mlops_in_production';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_mlops_in_production';

DELETE FROM courses WHERE id = 'crs_mlops_in_production';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_mlops', 'mlops', 'MLOps & Deployment', 'Ship, monitor and scale models in production.', 'server', 6);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_mlops_in_production', 'mlops-in-production', 'MLOps: Shipping Models to Production', 'Reproducible data and experiments, pipelines and feature stores with no leakage, serving latency, and drift monitoring with retraining rules.', 'Most machine learning models never reach production, and many that do quietly degrade. MLOps is the engineering discipline that closes that gap: versioned data, traceable experiments, pipelines that run the same way every time, features that match training, serving that meets its latency budget, and monitoring that notices when the world changes.

## Learn by building

- **The mechanisms in code.** Content fingerprints, experiment comparison, dependency ordering, point-in-time joins, cache freshness, micro-batching, latency percentiles, drift scores and alert rules all run in the page.
- **Numbers you can check.** You compute percentiles, the population stability index and the leakage a naive join introduces, so decisions rest on measurements.
- **Debug challenges.** You fix the bugs that cause production incidents: a fingerprint that depends on row order, a feature join that reads the future, a drift score with the wrong sign, and a retraining rule that fires on a single bad day.
- **Infrastructure shown honestly.** Docker, orchestration and cloud services are static configuration for you to run with your own tools.

## What you''ll cover

- **The lifecycle:** why models fail to ship, and the maturity of a team''s practice.
- **Reproducibility:** data fingerprints and experiment tracking.
- **Pipelines and features:** dependency ordering, point-in-time features, and batch versus online serving.
- **Serving:** micro-batching and latency percentiles.
- **Monitoring:** drift detection, retraining rules and a monitored-model capstone.

## Why this course?

A model that works in a notebook is a prototype. A model in production needs to be reproducible, its features need to match what it was trained on, it needs to answer within a budget, and someone needs to know when it has stopped being right. This course teaches each of those so you can ship models that stay correct.', 'cat_mlops', 'usr_arjun', 'advanced', 'English', 0, NULL, 'USD', NULL, NULL, 140, 'published', 0, '["Version data, code and models reproducibly with content fingerprints","Compare experiments by their parameters and metrics","Order pipeline tasks by their dependencies and detect cycles","Build point-in-time correct features that avoid leakage","Serve models within a latency budget, measured by percentiles","Detect data drift with the population stability index and set retraining rules"]', '["Experience training ML models","Comfort with the command line and Python. Docker and cloud tooling are shown as static code"]', '["ML engineers taking models from notebooks to production","Data scientists shipping their first models","Platform engineers supporting ML teams"]', '["MLOps","Docker","Monitoring","CI/CD"]', 210, 16, 0, 0, 13280, '2026-07-06T07:28:16.914Z', '2026-06-06T07:28:16.914Z', '2026-10-22T07:28:16.914Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_mlops_in_production_1', 'crs_mlops_in_production', 'The ML Lifecycle', 0, '2026-06-25T07:28:16.914Z'),
('sec_mlops_in_production_2', 'crs_mlops_in_production', 'Reproducibility', 1, '2026-06-25T07:28:16.914Z'),
('sec_mlops_in_production_3', 'crs_mlops_in_production', 'Pipelines and Features', 2, '2026-06-25T07:28:16.914Z'),
('sec_mlops_in_production_4', 'crs_mlops_in_production', 'Serving', 3, '2026-06-25T07:28:16.914Z'),
('sec_mlops_in_production_5', 'crs_mlops_in_production', 'Monitoring', 4, '2026-06-25T07:28:16.914Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_mlops_in_production_1_1', 'sec_mlops_in_production_1', 'crs_mlops_in_production', 'How this course works', 'interactive', 0, 360, NULL, NULL, 'A model is an artifact that depends on code, data and a configuration, and it is only as good as the process that produces and watches it. MLOps is the set of practices that make that process repeatable. You can reproduce a result, you know which data it came from, the features at serving time match training, the service meets its latency target, and someone is alerted when the world drifts away from the training data.

Every lesson here runs in the page with plain Python and NumPy. Docker files, orchestrators and cloud services are shown as static configuration, because they need infrastructure you own. The logic that decides whether a deployment is safe runs here, and you can test it.

> **How to use this lesson:** run the grey boxes, read the output, and change a value to see what moves. The challenges check your code against tests.

## A small measurement

Teams track the share of prototypes that reach production. Turning counts into shares is the first arithmetic of any MLOps review.

```python run
prototypes = 120
in_staging = 36
in_production = 12
print(f"reached staging: {100 * in_staging / prototypes:.0f}%")
print(f"reached production: {100 * in_production / prototypes:.0f}%")
```

## Predict the share

```python predict id=predict-share title="What share of 120 prototypes is 30?"
print(100 * 30 / 120)
--- options
* 25.0
30.0
4.0
120.0
--- explain
Thirty out of 120 is one quarter, which is 25 percent.
```

## Recap

- MLOps makes model results repeatable, traceable and monitored.
- The lifecycle has stages, and most failures happen between them.
- Every mechanism in this course is testable, even when the infrastructure is not.

**Up next:** why models fail to ship, and how to measure a team''s maturity.
', 1, '[]', '[{"title":"Hidden Technical Debt in Machine Learning Systems (Sculley et al.)","url":"https://papers.nips.cc/paper/2015/hash/86df7dcfd896fcaf2674f757a2463eba-Abstract.html"},{"title":"Rules of Machine Learning (Google)","url":"https://developers.google.com/machine-learning/guides/rules-of-ml"},{"title":"Feast: an open-source feature store","url":"https://feast.dev"},{"title":"MLflow: an open-source platform for the ML lifecycle","url":"https://mlflow.org"}]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_1_2', 'sec_mlops_in_production_1', 'crs_mlops_in_production', 'Why most models never ship: maturity and the lifecycle', 'interactive', 1, 840, NULL, NULL, 'Many prototypes never reach production, and the reasons are rarely the model. Data is not versioned, experiments cannot be reproduced, features differ between training and serving, and nobody owns the monitoring. Maturity models describe this progression, from manual work at the bottom to automated, monitored systems at the top. A team can use a checklist to see where it stands.

## Checking maturity

A team''s maturity can be read from a checklist, where each practice is either in place or not. The level is the number of practices that are in place, counted from the start, because a later practice needs the earlier ones.

```python run
checks = [True, True, False, True]
level = 0
for ok in checks:
    if not ok:
        break
    level += 1
print("maturity level:", level, "of", len(checks))
```

## The practices in order

The order matters. Versioned data makes experiments comparable, comparable experiments make pipelines trustworthy, and trustworthy pipelines make monitoring meaningful.

```python run
practices = ["versioned data", "tracked experiments", "automated pipeline", "monitored serving"]
for i, p in enumerate(practices, start=1):
    print(f"{i}. {p}")
```

## Counting the practices in place

```python run
practices_in_place = sum([True, True, False, True])
print("practices in place:", practices_in_place, "of 4")
```

## Where the time goes

A large part of a project''s time goes to the work around the model. A rough split makes the point.

```python run
share = {"model code": 20, "data work": 35, "serving and monitoring": 30, "coordination": 15}
print(share, "| total:", sum(share.values()))
```

> **Pitfall:** a team that jumps to deployment before versioning data cannot tell whether a regression came from the code or the data. Put the practices in order, and skip none.

> **In the wild:** teams use maturity checklists in planning reviews, so that the next investment goes to the lowest unmet practice.

## Challenge: share of a whole

```python exercise id=pct-of title="Percentage of a whole"
# TODO: `pct_of(part, whole)` returns 100 × part / whole as a float.
def pct_of(part, whole):
    ...
--- solution
def pct_of(part, whole):
    return 100 * part / whole
--- test
result = pct_of(30, 120)
assert result is not None, "Replace the `...` in `pct_of` with code that returns the percentage."
assert abs(result - 25.0) < 1e-9, f"30 of 120 is 25 percent, but you returned {result}."
assert abs(pct_of(1, 4) - 25.0) < 1e-9, "One of four is 25 percent."
--- hint
Multiply by 100 before dividing so the result is a percentage.
--- hint
`return 100 * part / whole`.
```

## Challenge: maturity level

```python exercise id=maturity-level title="Count the leading practices in place"
# TODO: `maturity_level(checks)` takes a list of booleans and returns how many leading entries are True, stopping at the first
# False.
def maturity_level(checks):
    ...
--- solution
def maturity_level(checks):
    level = 0
    for ok in checks:
        if not ok:
            break
        level += 1
    return level
--- test
result = maturity_level([True, True, False, True])
assert result is not None, "Replace the `...` in `maturity_level` with code that returns the level."
assert result == 2, f"Two practices are in place before the first gap, so the level is 2, but you returned {result}."
assert maturity_level([True, True, True]) == 3, "All practices in place give the full count."
assert maturity_level([False, True]) == 0, "A missing first practice gives level zero."
--- hint
Stop counting at the first False.
--- hint
Use `break` inside the loop when `ok` is False.
```

## Debug: counting every practice

The level should stop at the first gap, but the code counts every practice that is in place.

```python debug id=count-all title="Stop at the first gap"
checks = [True, False, True]
level = sum(checks)                 # bug: counts every True, not the leading ones
print("maturity level:", level)
--- solution
checks = [True, False, True]
level = 0
for ok in checks:
    if not ok:
        break
    level += 1
print("maturity level:", level)
--- test
assert level == 1, f"Only the first practice is in place before the gap, so the level is 1, but the code gives {level}. Stop at the first False."
--- hint
A later practice does not count while an earlier one is missing.
--- hint
Loop and break on the first False.
```

## Predict the level

```python predict id=predict-level title="What maturity level does [True, True, True, False] give?"
checks = [True, True, True, False]
print(next((i for i, ok in enumerate(checks) if not ok), len(checks)))
--- options
* 3
4
2
0
--- explain
The first gap is at position 3, counting from zero, so three practices are in place before it.
```

## Recap

- Maturity is the number of practices in place, counted in order.
- A gap at a lower level limits the value of the levels above it.
- Measure the team''s position before choosing the next investment.

**Up next:** reproducibility, starting with versioned data.
', 0, '[]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_2_1', 'sec_mlops_in_production_2', 'crs_mlops_in_production', 'Versioning data with content fingerprints', 'interactive', 0, 960, NULL, NULL, 'A model trained on data that has quietly changed cannot be reproduced. Versioning data means giving each dataset a fingerprint computed from its contents, so that any change, however small, produces a different identifier. The fingerprint must not depend on the order in which rows are stored, because the same data can be written in different orders.

## A fingerprint of the rows

Each row is serialized with its keys sorted, the serialized rows are sorted, and the result is hashed. That makes the fingerprint independent of row order and of key order.

```python run
import hashlib
import json

def fingerprint(rows):
    lines = sorted(json.dumps(r, sort_keys=True) for r in rows)
    return hashlib.sha256("\n".join(lines).encode()).hexdigest()[:12]

data = [{"id": 1, "x": 0.5}, {"id": 2, "x": 1.5}]
print("fingerprint:", fingerprint(data))
print("same rows reordered:", fingerprint(list(reversed(data))) == fingerprint(data))
```

## A single change is visible

Changing one value changes the fingerprint, so a silent edit to the data is detected.

```python run
edited = [{"id": 1, "x": 0.5}, {"id": 2, "x": 1.6}]
print("changed fingerprint:", fingerprint(edited) != fingerprint(data))
```

## What changed between two versions

Comparing per-file hashes shows which files were added, removed or altered between two dataset versions.

```python run
old = {"train.csv": "a1", "test.csv": "b2"}
new = {"train.csv": "a9", "labels.csv": "c3"}
changed = sorted(set(old) | set(new), key=str)
diff = [p for p in changed if old.get(p) != new.get(p)]
print("changed files:", diff)
```

## Hashing one file''s content

The same idea applies to a single file: hash its bytes, and a one-character edit changes the digest.

```python run
import hashlib
print("digest of a short file:", hashlib.sha256(b"id,x\n1,0.5\n").hexdigest()[:12])
```

> **Pitfall:** a fingerprint of the file name and size misses edits that keep the size. Hash the contents, and record the fingerprint next to the model that was trained on it.

> **In the wild:** teams record the dataset fingerprint in the experiment log, so every model can be traced back to the exact data that produced it.

## Challenge: dataset fingerprint

```python exercise id=dataset-fingerprint title="Order-independent dataset fingerprint"
import hashlib
import json

# TODO: `dataset_fingerprint(rows)` takes a list of dictionaries. It serializes each row with json.dumps(row, sort_keys=True),
# sorts the serialized rows, joins them with newlines, and returns the SHA-256 hex digest of the encoded text.
def dataset_fingerprint(rows):
    ...
--- solution
import hashlib
import json

def dataset_fingerprint(rows):
    lines = sorted(json.dumps(r, sort_keys=True) for r in rows)
    return hashlib.sha256("\n".join(lines).encode()).hexdigest()
--- test
a = dataset_fingerprint([{"a": 1}, {"b": 2}])
assert a is not None, "Replace the `...` in `dataset_fingerprint` with code that returns the digest."
assert a == dataset_fingerprint([{"b": 2}, {"a": 1}]), "The same rows in a different order must give the same fingerprint."
assert a != dataset_fingerprint([{"a": 2}, {"b": 2}]), "A changed value must change the fingerprint."
--- hint
Serialize with `sort_keys=True`, sort the strings, then hash the joined text.
--- hint
`hashlib.sha256("\n".join(lines).encode()).hexdigest()`.
```

## Challenge: changed files

```python exercise id=changed-files title="Which files changed between versions"
# TODO: `changed_files(old, new)` takes two dictionaries from file path to content hash. It returns the sorted list of paths that
# are added, removed or whose hash differs.
def changed_files(old, new):
    ...
--- solution
def changed_files(old, new):
    paths = set(old) | set(new)
    return sorted(p for p in paths if old.get(p) != new.get(p))
--- test
result = changed_files({"a": 1, "b": 2}, {"b": 3, "c": 4})
assert result is not None, "Replace the `...` in `changed_files` with code that returns the paths."
assert result == ["a", "b", "c"], f"a was removed, b changed and c was added, so the result is [''a'', ''b'', ''c''], but you returned {result}."
assert changed_files({"a": 1}, {"a": 1}) == [], "Identical versions have no changed files."
--- hint
Take the union of the two key sets, then keep the paths whose values differ.
--- hint
`old.get(p) != new.get(p)` treats a missing path as a difference.
```

## Debug: a fingerprint that depends on order

The fingerprint should match for the same rows in any order, but this version hashes them in the order they are stored.

```python debug id=order-dependent title="Make the fingerprint order-independent"
import hashlib
import json

rows = [{"id": 1}, {"id": 2}]
lines = [json.dumps(r, sort_keys=True) for r in rows]        # bug: the lines are not sorted
h1 = hashlib.sha256("\n".join(lines).encode()).hexdigest()
lines2 = [json.dumps(r, sort_keys=True) for r in reversed(rows)]
h2 = hashlib.sha256("\n".join(lines2).encode()).hexdigest()
print("same fingerprint:", h1 == h2)
--- solution
import hashlib
import json

rows = [{"id": 1}, {"id": 2}]
lines = sorted(json.dumps(r, sort_keys=True) for r in rows)
h1 = hashlib.sha256("\n".join(lines).encode()).hexdigest()
lines2 = sorted(json.dumps(r, sort_keys=True) for r in reversed(rows))
h2 = hashlib.sha256("\n".join(lines2).encode()).hexdigest()
print("same fingerprint:", h1 == h2)
--- test
assert h1 == h2, "The same rows in a different order must give the same fingerprint. Sort the serialized rows before hashing."
--- hint
Sorting makes the order of the input irrelevant.
--- hint
Wrap the generator in `sorted(...)`.
```

## Predict the differences

```python predict id=predict-diff title="How many items differ between these two dictionaries?"
print(len({"a": 1, "b": 2}.items() ^ {"a": 1, "b": 3}.items()))
--- options
* 2
1
0
3
--- explain
The pair (''b'', 2) is only in the first dictionary and (''b'', 3) only in the second, so two items differ.
```

## Recap

- Fingerprint the contents of the data, not its name or size.
- Make the fingerprint independent of row order, so equal data matches.
- Record the fingerprint with every model, so results can be traced.

**Up next:** experiment tracking, and how to compare runs honestly.
', 0, '[]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_2_2', 'sec_mlops_in_production_2', 'crs_mlops_in_production', 'Experiment tracking and comparing runs', 'interactive', 1, 840, NULL, NULL, 'An experiment is a training run with its parameters and metrics recorded. Tracking makes runs comparable: you can see which settings produced which score, and you can reproduce the best one. Without tracking, the best result is remembered rather than recorded, and a regression goes unnoticed until someone asks why the model got worse.

## A run registry

Each run stores its parameters and its metrics as data, so the registry can be searched.

```python run
runs = [
    {"name": "run-a", "params": {"lr": 0.1, "depth": 4}, "metrics": {"accuracy": 0.81}},
    {"name": "run-b", "params": {"lr": 0.01, "depth": 4}, "metrics": {"accuracy": 0.88}},
    {"name": "run-c", "params": {"lr": 0.01, "depth": 6}, "metrics": {"accuracy": 0.79}},
]
for r in runs:
    print(r["name"], r["params"], r["metrics"])
```

## The best run

The best run is the one with the highest value of the chosen metric.

```python run
best = max(runs, key=lambda r: r["metrics"]["accuracy"])
print("best run:", best["name"], best["metrics"]["accuracy"])
```

## What differs between two runs

When two runs disagree, the parameters that differ are the first place to look.

```python run
def diff_params(a, b):
    keys = set(a) | set(b)
    return sorted(k for k in keys if a.get(k) != b.get(k))

print("differences between run-a and run-b:", diff_params(runs[0]["params"], runs[1]["params"]))
```

## Seeds and repeats

A single run can be lucky. Repeating a run with several seeds shows the spread of the result.

```python run
seed_scores = [0.86, 0.88, 0.85, 0.87]
mean = sum(seed_scores) / len(seed_scores)
spread = max(seed_scores) - min(seed_scores)
print(f"mean {mean:.3f}, spread {spread:.3f}")
```

> **Pitfall:** choosing the best of many runs on the test set inflates the score. Select on a validation set and report the test score once.

> **In the wild:** teams log every run to a shared tracker with the code version and data fingerprint, so a result is reproducible months later.

## Challenge: the best run

```python exercise id=best-run title="The run with the highest metric"
# TODO: `best_run(runs, metric)` takes a list of runs, each a dictionary with a "metrics" mapping, and returns the run whose
# value for metric is highest. If runs tie, return the earliest one.
def best_run(runs, metric):
    ...
--- solution
def best_run(runs, metric):
    return max(runs, key=lambda r: r["metrics"][metric])
--- test
runs = [{"name": "x", "metrics": {"acc": 0.7}}, {"name": "y", "metrics": {"acc": 0.9}}, {"name": "z", "metrics": {"acc": 0.9}}]
result = best_run(runs, "acc")
assert result is not None, "Replace the `...` in `best_run` with code that returns the run."
assert result["name"] == "y", f"y and z tie at 0.9 and y comes first, so y is the best run, but you returned {result[''name'']}."
--- hint
`max` with a `key` function returns the first maximum it finds.
--- hint
`max(runs, key=lambda r: r["metrics"][metric])`.
```

## Challenge: parameter differences

```python exercise id=diff-params title="Which parameters differ"
# TODO: `diff_params(a, b)` takes two parameter dictionaries and returns the sorted list of keys whose values differ, including
# keys present in only one of them.
def diff_params(a, b):
    ...
--- solution
def diff_params(a, b):
    keys = set(a) | set(b)
    return sorted(k for k in keys if a.get(k) != b.get(k))
--- test
result = diff_params({"lr": 0.1, "depth": 4}, {"lr": 0.01, "depth": 4, "warmup": 3})
assert result is not None, "Replace the `...` in `diff_params` with code that returns the keys."
assert result == ["lr", "warmup"], f"lr changed and warmup is only in the second run, so the result is [''lr'', ''warmup''], but you returned {result}."
assert diff_params({"a": 1}, {"a": 1}) == [], "Identical parameters have no differences."
--- hint
Use the union of the two key sets, and compare with `get` so a missing key counts as a difference.
--- hint
`sorted(k for k in keys if a.get(k) != b.get(k))`.
```

## Debug: picking the worst run

The best run should have the highest accuracy, but this version picks the lowest.

```python debug id=min-not-max title="Pick the highest metric, not the lowest"
runs = [{"name": "a", "acc": 0.81}, {"name": "b", "acc": 0.88}]
best = min(runs, key=lambda r: r["acc"])          # bug: min returns the lowest score
print("best:", best["name"])
--- solution
runs = [{"name": "a", "acc": 0.81}, {"name": "b", "acc": 0.88}]
best = max(runs, key=lambda r: r["acc"])
print("best:", best["name"])
--- test
assert best["name"] == "b", f"Run b has the higher accuracy, so it is the best run, but the code picks {best[''name'']}. Use max, not min."
--- hint
Higher accuracy is better.
--- hint
Use `max` for a metric where larger is better.
```

## Predict the best accuracy

```python predict id=predict-best title="What is the best accuracy among 0.81, 0.88 and 0.79?"
print(max([0.81, 0.88, 0.79]))
--- options
* 0.88
0.81
0.79
0.83
--- explain
The largest of the three values is 0.88.
```

## Recap

- Record the parameters and metrics of every run, and compare them.
- Select on validation data, and report the test score once.
- Repeat runs with several seeds to see the spread.

**Up next:** pipelines, and the order in which their tasks must run.
', 0, '[]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_2_3', 'sec_mlops_in_production_2', 'crs_mlops_in_production', 'Checkpoint: reproducibility', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why fingerprint a dataset by its contents rather than its file name?","options":["A changed row changes the fingerprint, even when the name stays the same","File names are always longer than fingerprints","Fingerprints compress the data","Names cannot be stored"],"answerIndex":0,"explanation":"A content fingerprint detects silent changes that a name would hide."},{"id":"q2","prompt":"Why should a dataset fingerprint not depend on the order of its rows?","options":["The same data in a different order is still the same data, so it should match","Order is never stored","Fingerprints must be random","Row order is always wrong"],"answerIndex":0,"explanation":"Order-independent fingerprints recognize identical content however it is stored."},{"id":"q3","prompt":"What does experiment tracking let a team do?","options":["Compare runs by their parameters and metrics, and reproduce the best one","Delete failed runs without a record","Train without data","Skip evaluation"],"answerIndex":0,"explanation":"Recording parameters and metrics for each run makes results comparable and repeatable."},{"id":"q4","prompt":"When two runs tie on the metric you choose, what is the sensible rule?","options":["Pick by a fixed, documented rule, such as the earlier run, so the choice is repeatable","Pick at random","Always pick the newest run","Refuse to pick"],"answerIndex":0,"explanation":"A documented tie-break keeps the choice reproducible."}]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_3_1', 'sec_mlops_in_production_3', 'crs_mlops_in_production', 'Ordering pipeline tasks by their dependencies', 'interactive', 0, 960, NULL, NULL, 'A training pipeline is a graph of tasks: ingest the data, build features, train, evaluate, publish. Each task depends on the tasks before it. Running them in a valid order is a topological sort, and a graph with a cycle has no valid order at all, which is a bug to catch before the pipeline runs.

## The dependency graph

Each task lists the tasks it needs. The graph is data, so a scheduler can read it.

```python run
deps = {
    "ingest": [],
    "features": ["ingest"],
    "train": ["features"],
    "report": ["train"],
}
print("edges:", sum(len(v) for v in deps.values()))
```

## Running in dependency order

A task is ready when all of its prerequisites are done. Repeatedly running a ready task gives a valid order.

```python run
remaining = {t: set(p) for t, p in deps.items()}
order = []
while remaining:
    ready = sorted(t for t, pre in remaining.items() if not pre)
    t = ready[0]
    order.append(t)
    del remaining[t]
    for pre in remaining.values():
        pre.discard(t)
print("order:", order)
```

## A cycle has no order

If two tasks need each other, no task is ever ready, and the scheduler must stop with an error.

```python run
cyclic = {"a": ["b"], "b": ["a"]}
remaining = {t: set(p) for t, p in cyclic.items()}
ready = [t for t, pre in remaining.items() if not pre]
print("ready tasks at the start:", ready)
```

## Counting the tasks ready to run first

The tasks with no prerequisites can run in parallel at the start of the pipeline.

```python run
starting = [t for t, pre in deps.items() if not pre]
print("can start immediately:", starting)
```

> **Pitfall:** a pipeline that runs tasks in the order they were written works until someone reorders the file. Derive the order from the dependencies.

> **In the wild:** orchestrators such as Airflow and Prefect build this graph, check it for cycles when a pipeline is deployed, and run independent branches in parallel.

## Challenge: topological order

```python exercise id=topo-order title="Order tasks by their dependencies"
# TODO: `topo_order(deps)` takes a dictionary from task to the list of tasks it needs. It returns the tasks in an order where each
# task comes after its prerequisites. Among ready tasks choose the alphabetically first. Raise ValueError if the graph has a
# cycle.
def topo_order(deps):
    ...
--- solution
def topo_order(deps):
    remaining = {t: set(p) for t, p in deps.items()}
    order = []
    while remaining:
        ready = sorted(t for t, pre in remaining.items() if not pre)
        if not ready:
            raise ValueError("cycle")
        t = ready[0]
        order.append(t)
        del remaining[t]
        for pre in remaining.values():
            pre.discard(t)
    return order
--- test
deps = {"train": ["features"], "features": ["ingest"], "ingest": [], "report": ["train"]}
result = topo_order(deps)
assert result is not None, "Replace the `...` in `topo_order` with code that returns the order."
assert result == ["ingest", "features", "train", "report"], f"The only valid order is ingest, features, train, report, but you returned {result}."
try:
    topo_order({"a": ["b"], "b": ["a"]})
    raised = False
except ValueError:
    raised = True
assert raised, "A cycle must raise ValueError."
--- hint
Repeatedly take a task whose prerequisites are all done, and remove it from the remaining prerequisites of the others.
--- hint
If no task is ready while tasks remain, the graph has a cycle.
```

## Challenge: valid graph check

```python exercise id=valid-dag title="Is the graph free of cycles?"
# TODO: `is_valid_dag(deps)` returns True if the dependency graph has an order, and False if it has a cycle. Use `topo_order`
# below, which is provided.
def topo_order(deps):
    remaining = {t: set(p) for t, p in deps.items()}
    order = []
    while remaining:
        ready = sorted(t for t, pre in remaining.items() if not pre)
        if not ready:
            raise ValueError("cycle")
        t = ready[0]
        order.append(t)
        del remaining[t]
        for pre in remaining.values():
            pre.discard(t)
    return order

def is_valid_dag(deps):
    ...
--- solution
def topo_order(deps):
    remaining = {t: set(p) for t, p in deps.items()}
    order = []
    while remaining:
        ready = sorted(t for t, pre in remaining.items() if not pre)
        if not ready:
            raise ValueError("cycle")
        t = ready[0]
        order.append(t)
        del remaining[t]
        for pre in remaining.values():
            pre.discard(t)
    return order

def is_valid_dag(deps):
    try:
        topo_order(deps)
        return True
    except ValueError:
        return False
--- test
assert is_valid_dag({"a": [], "b": ["a"]}) is True, "A simple chain has an order."
assert is_valid_dag({"a": ["b"], "b": ["a"]}) is False, "A two-task cycle has no order."
--- hint
Wrap the call in a try block and catch ValueError.
--- hint
Return True when no error is raised.
```

## Debug: running in declared order

The pipeline should train only after the features are built, but this version runs the tasks in the order they appear in the dictionary.

```python debug id=declared-order title="Run prerequisites first"
deps = {"train": ["features"], "features": ["ingest"], "ingest": []}
order = list(deps)                  # bug: the declared order ignores the dependencies
print("run order:", order)
print("train before features:", order.index("train") < order.index("features"))
--- solution
deps = {"train": ["features"], "features": ["ingest"], "ingest": []}
order = ["ingest", "features", "train"]
print("run order:", order)
print("train before features:", order.index("train") < order.index("features"))
--- test
assert order.index("features") < order.index("train"), "Features must be built before train, but the order puts train first. Derive the order from the dependencies."
--- hint
The declared order lists train first, even though it needs features.
--- hint
Use the order that `topo_order` produces.
```

## Predict the edge count

```python predict id=predict-edges title="How many dependency edges are in this graph?"
deps = {"train": ["features"], "features": ["ingest"], "ingest": [], "report": ["train"]}
print(sum(len(v) for v in deps.values()))
--- options
* 3
4
2
1
--- explain
The edges are features to ingest, train to features, and report to train, which makes three.
```

## Recap

- A pipeline is a dependency graph, and the run order is a topological sort.
- A cycle has no valid order, so detect it before running.
- Derive the order from the dependencies, not from the way the file is written.

**Up next:** feature stores, and how to build features that match what the model sees in production.
', 0, '[]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_3_2', 'sec_mlops_in_production_3', 'crs_mlops_in_production', 'Point-in-time features without leakage', 'interactive', 1, 1080, NULL, NULL, 'A feature store keeps the values that models use, with the time each value became known. Training needs the value that was current for each example at that moment. Using the latest value instead leaks information from the future into the training data, and the model looks better offline than it will in production.

## A feature history

Each feature value is stored with the time it became known, in ascending time order.

```python run
history = [(1, 10), (5, 20), (9, 15)]
print("feature history (time, value):", history)
```

## The value as of a time

The value to use for a given time is the latest stored value at or before that time.

```python run
def as_of(history, t):
    value = None
    for ts, v in history:
        if ts <= t:
            value = v
    return value

for t in [0, 4, 5, 10]:
    print(f"as of {t}: {as_of(history, t)}")
```

## Leakage in a naive join

Taking the latest value for every example mixes the future into the past.

```python run
examples = [(4, "a"), (6, "b")]
naive = [history[-1][1] for _ in examples]
correct = [as_of(history, t) for t, _ in examples]
print("naive (leaks):", naive, "| point-in-time:", correct)
```

## Labels joined to features

A label arrives at a time, and its features must be the values known at that time.

```python run
labels = [(4, 1), (6, 0)]
rows = [(t, label, as_of(history, t)) for t, label in labels]
print("training rows:", rows)
```

> **Pitfall:** a feature computed over the full dataset, including the test period, leaks the answer. Compute features with a cut-off at each example''s time.

> **In the wild:** feature stores such as Feast perform point-in-time joins, so training and serving read the same values as of the same moments.

## Challenge: value as of a time

```python exercise id=as-of title="The feature value at a time"
# TODO: `as_of(history, t)` takes a list of (time, value) pairs sorted by time and returns the value of the latest pair whose
# time is at most t, or None if no pair qualifies.
def as_of(history, t):
    ...
--- solution
def as_of(history, t):
    value = None
    for ts, v in history:
        if ts <= t:
            value = v
    return value
--- test
history = [(1, "a"), (5, "b")]
assert as_of(history, 4) == "a", "At time 4 the value stored at time 1 is current."
assert as_of(history, 5) == "b", "At time 5 the newer value is current."
assert as_of(history, 0) is None, "Before the first value there is nothing to use."
--- hint
Keep the latest value whose time does not exceed t.
--- hint
Overwrite `value` for each pair with `ts <= t`.
```

## Challenge: label join

```python exercise id=label-join title="Join labels to features as of their time"
# TODO: `label_join(labels, history)` takes labels as (time, label) pairs and returns a list of (time, label, value) tuples, where
# value is the feature value as of that time. The function as_of below is provided.
def as_of(history, t):
    value = None
    for ts, v in history:
        if ts <= t:
            value = v
    return value

def label_join(labels, history):
    ...
--- solution
def as_of(history, t):
    value = None
    for ts, v in history:
        if ts <= t:
            value = v
    return value

def label_join(labels, history):
    return [(t, label, as_of(history, t)) for t, label in labels]
--- test
history = [(1, 10), (5, 20)]
result = label_join([(4, 1), (6, 0)], history)
assert result is not None, "Replace the `...` in `label_join` with code that returns the rows."
assert result == [(4, 1, 10), (6, 0, 20)], f"At time 4 the value is 10 and at time 6 it is 20, but you returned {result}."
--- hint
A list comprehension can call `as_of` for each label''s time.
--- hint
`[(t, label, as_of(history, t)) for t, label in labels]`.
```

## Debug: reading the latest value

The join should use the value known at each example''s time, but this version reads the newest value for every example.

```python debug id=latest-leak title="Use the value known at the example''s time"
history = [(1, 10), (5, 20)]
t = 4
value = history[-1][1]               # bug: the newest value is 20, which is in the future at time 4
print("feature for time 4:", value)
--- solution
history = [(1, 10), (5, 20)]
t = 4
value = [v for ts, v in history if ts <= t][-1]
print("feature for time 4:", value)
--- test
assert value == 10, f"At time 4 only the value 10 from time 1 was known, but the code used {value}. Use the latest value at or before time 4."
--- hint
The value at time 5 did not exist yet at time 4.
--- hint
Filter the history to times at most t, then take the last value.
```

## Predict the value

```python predict id=predict-asof title="What value is current at time 4 for the history [(1, 10), (5, 20)]?"
history = [(1, 10), (5, 20)]
print([v for ts, v in history if ts <= 4][-1])
--- options
* 10
20
None
4
--- explain
The value stored at time 1 is current at time 4, because the value at time 5 has not happened yet.
```

## Recap

- Store each feature value with the time it became known.
- Join labels to the value as of their time, never to the latest value.
- Leakage makes offline metrics look better than production will be.

**Up next:** batch and online features, and how cached values stay fresh.
', 0, '[]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_3_3', 'sec_mlops_in_production_3', 'crs_mlops_in_production', 'Batch and online features, and cache freshness', 'interactive', 2, 840, NULL, NULL, 'Features can be computed in batches ahead of time, or on demand when a request arrives. Batch features are cheap and consistent, but they can be hours old. Online features are fresh, but they cost latency and infrastructure on every request. Caching sits between the two: a stored value is served while it is fresh enough, then recomputed. The time-to-live decides how stale a served value may be.

## Batch versus online

The choice trades freshness against cost and latency. A table makes the trade explicit.

```python run
options = {
    "batch": {"freshness_hours": 24, "latency_ms": 2, "cost_per_1k": 0.10},
    "online": {"freshness_hours": 0, "latency_ms": 40, "cost_per_1k": 0.60},
}
for name, o in options.items():
    print(f"{name:>6}: fresh within {o[''freshness_hours'']} h, {o[''latency_ms'']} ms, ${o[''cost_per_1k'']} per 1000")
```

## Cache hits

A cache answers repeated requests without recomputing. The hit rate shows how much work it saves.

```python run
requests = ["u1", "u2", "u1", "u1", "u3", "u2"]
seen = set()
hits = 0
for key in requests:
    if key in seen:
        hits += 1
    seen.add(key)
print("hit rate:", round(hits / len(requests), 3))
```

## Staleness

A cached value has an age, and it is fresh while the age is within the time-to-live.

```python run
computed_at, now, ttl = 0, 45, 60
age = now - computed_at
print("age:", age, "| fresh:", age <= ttl)
```

## The cost of a miss

Every miss pays the full computation. The expected cost per request mixes hits and misses.

```python run
hit_rate, hit_ms, miss_ms = 0.8, 2, 40
print("expected latency:", round(hit_rate * hit_ms + (1 - hit_rate) * miss_ms, 1), "ms")
```

> **Pitfall:** serving a cached feature that is older than the model expects can silently change predictions. Set the time-to-live from the feature''s update rate, not from convenience.

> **In the wild:** teams use batch features for slow signals, such as a customer''s lifetime spend, and online features for fast ones, such as the number of clicks in the last minute.

## Challenge: serve with a cache

```python exercise id=serve title="Serve from a cache while the value is fresh"
# TODO: `serve(cache, key, now, ttl, compute)` returns a cached value when cache[key] holds (value, computed_at) and now minus
# computed_at is at most ttl. Otherwise it calls compute(), stores (value, now) in cache under key, and returns the value.
def serve(cache, key, now, ttl, compute):
    ...
--- solution
def serve(cache, key, now, ttl, compute):
    if key in cache:
        value, computed_at = cache[key]
        if now - computed_at <= ttl:
            return value
    value = compute()
    cache[key] = (value, now)
    return value
--- test
calls = []
def compute():
    calls.append(1)
    return 42
cache = {}
first = serve(cache, "f", 0, 60, compute)
assert first is not None, "Replace the `...` in `serve` with code that returns the value."
assert first == 42 and len(calls) == 1, "The first request computes the value."
assert serve(cache, "f", 30, 60, compute) == 42 and len(calls) == 1, "A fresh value is served without recomputing."
assert serve(cache, "f", 100, 60, compute) == 42 and len(calls) == 2, "An expired value is recomputed."
--- hint
Check the entry, then its age against the time-to-live. Recompute in all other cases.
--- hint
`if now - computed_at <= ttl: return value`.
```

## Challenge: hit rate

```python exercise id=hit-rate title="Share of requests served from cache"
# TODO: `hit_rate(hits, requests)` returns hits divided by requests as a float, and 0.0 when there are no requests.
def hit_rate(hits, requests):
    ...
--- solution
def hit_rate(hits, requests):
    return hits / requests if requests else 0.0
--- test
result = hit_rate(3, 4)
assert result is not None, "Replace the `...` in `hit_rate` with code that returns the rate."
assert abs(result - 0.75) < 1e-9, f"Three hits in four requests is 0.75, but you returned {result}."
assert hit_rate(0, 0) == 0.0, "No requests gives a rate of zero, not an error."
--- hint
Guard the division when the request count is zero.
--- hint
`hits / requests if requests else 0.0`.
```

## Debug: an age exactly at the limit

A value whose age equals the time-to-live should still be fresh, but the comparison expires it one tick early.

```python debug id=ttl-boundary title="Accept an age equal to the time-to-live"
ttl = 60
computed_at, now = 0, 60
fresh = now - computed_at < ttl          # bug: an age exactly equal to ttl is still fresh
print("fresh:", fresh)
--- solution
ttl = 60
computed_at, now = 0, 60
fresh = now - computed_at <= ttl
print("fresh:", fresh)
--- test
assert fresh is True, "An age equal to the time-to-live is still within it, so the value is fresh. Use <= in the comparison."
--- hint
The time-to-live is inclusive.
--- hint
Use `<=`.
```

## Predict the freshness

```python predict id=predict-fresh title="Is a value computed 70 units ago fresh with a time-to-live of 60?"
age, ttl = 70, 60
print(age <= ttl)
--- options
* False
True
None
1
--- explain
An age of 70 is larger than the time-to-live of 60, so the value has expired and must be recomputed.
```

## Recap

- Batch features are cheap and consistent but can be stale, and online features are fresh but cost latency.
- A cache serves values while they are fresh, and the time-to-live sets the limit.
- Track the hit rate, because it decides how much work the cache saves.

**Up next:** serving patterns, starting with micro-batching requests.
', 0, '[]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_3_4', 'sec_mlops_in_production_3', 'crs_mlops_in_production', 'Checkpoint: pipelines and features', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why must a pipeline run tasks in dependency order?","options":["A task needs its inputs, so a prerequisite must finish before the task starts","Order makes the code shorter","Dependencies are optional","Tasks are always independent"],"answerIndex":0,"explanation":"Running a task before its inputs exist produces errors or stale results."},{"id":"q2","prompt":"What is feature leakage?","options":["Training on values that were not available at prediction time","A feature that is too small","A feature stored in the wrong format","A feature with missing values"],"answerIndex":0,"explanation":"Using future information makes offline results look better than production will be."},{"id":"q3","prompt":"What does a point-in-time join do?","options":["It takes, for each example, the feature value that was current at that example''s time","It joins the newest values to every row","It removes the time column","It sorts the data randomly"],"answerIndex":0,"explanation":"Matching by time prevents the future from leaking into the training data."},{"id":"q4","prompt":"What does a cache''s time-to-live control?","options":["How long a stored value is considered fresh enough to serve","The size of the cache","The number of users","The model''s architecture"],"answerIndex":0,"explanation":"After the time-to-live, a value must be recomputed, which bounds how stale a served feature can be."}]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_4_1', 'sec_mlops_in_production_4', 'crs_mlops_in_production', 'Serving patterns: micro-batching requests', 'interactive', 0, 840, NULL, NULL, 'A model serves one request faster when several requests share a forward pass. Micro-batching waits briefly for requests to arrive, groups them into a batch, and runs them together. Throughput rises and the hardware is used better, and each request pays a small wait. The window length sets that trade-off, and it should be chosen against the latency budget.

## Grouping arrivals into windows

Arrivals that fall within one window of the first arrival in a group belong to that group. A new group starts when a request arrives after the window closes.

```python run
times = [0, 1, 2, 10, 11, 25]
window = 5
batches = []
start = None
for t in times:
    if start is None or t >= start + window:
        batches.append([])
        start = t
    batches[-1].append(t)
print("batches:", batches)
```

## The wait each request pays

A request waits from its arrival until its batch is run at the end of the window.

```python run
waits = [start_of + window - t for start_of, batch in [(b[0], b) for b in batches] for t in batch]
print("waits in ms:", waits, "| average:", round(sum(waits) / len(waits), 2))
```

## Throughput from batch sizes

The average batch size tells how much work each forward pass carries.

```python run
sizes = [len(b) for b in batches]
print("batch sizes:", sizes, "| mean size:", round(sum(sizes) / len(sizes), 2))
```

## Cost per request

If a batch costs a fixed amount plus a little per request, batching lowers the cost for each request.

```python run
fixed_ms, per_item_ms = 20, 2
for n in [1, 4, 8]:
    print(f"batch of {n}: {(fixed_ms + per_item_ms * n) / n:.1f} ms per request")
```

> **Pitfall:** a long window improves throughput but adds latency to every request in it. Choose the window against the p95 budget, not the average.

> **In the wild:** model servers such as Triton and vLLM perform dynamic batching, grouping in-flight requests so the GPU stays busy.

## Challenge: micro-batches

```python exercise id=micro-batches title="Group arrival times into windows"
# TODO: `micro_batches(times, window)` takes sorted arrival times and returns the list of groups. A group starts at its first time,
# and a time that is at least window after the group''s start opens a new group.
def micro_batches(times, window):
    ...
--- solution
def micro_batches(times, window):
    batches = []
    start = None
    for t in times:
        if start is None or t >= start + window:
            batches.append([])
            start = t
        batches[-1].append(t)
    return batches
--- test
result = micro_batches([0, 1, 2, 10, 11, 25], 5)
assert result is not None, "Replace the `...` in `micro_batches` with code that returns the groups."
assert result == [[0, 1, 2], [10, 11], [25]], f"The windows start at 0, 10 and 25, so the groups are [0, 1, 2], [10, 11] and [25], but you returned {result}."
assert micro_batches([0, 4], 5) == [[0, 4]], "Times inside the window stay together."
--- hint
Track the start of the current group, and start a new group when a time is at least window after it.
--- hint
`if start is None or t >= start + window`.
```

## Challenge: batch sizes

```python exercise id=batch-sizes title="Sizes of the batches"
# TODO: `batch_sizes(batches)` returns the number of items in each batch, in order.
def batch_sizes(batches):
    ...
--- solution
def batch_sizes(batches):
    return [len(b) for b in batches]
--- test
result = batch_sizes([[0, 1, 2], [10], []])
assert result is not None, "Replace the `...` in `batch_sizes` with code that returns the sizes."
assert result == [3, 1, 0], f"The batches hold 3, 1 and 0 items, but you returned {result}."
--- hint
Take the length of each batch.
--- hint
`[len(b) for b in batches]`.
```

## Debug: a boundary that joins the next window

A request arriving exactly one window after the group''s start should open a new batch, but the strict comparison keeps it in the old one.

```python debug id=window-boundary title="A request at the window''s end starts a new batch"
times, window = [0, 5], 5
start = times[0]
groups = [[]]
for t in times:
    if t > start + window:               # bug: a request exactly window later should start a new group
        start = t
        groups.append([])
    groups[-1].append(t)
print(groups)
--- solution
times, window = [0, 5], 5
start = times[0]
groups = [[]]
for t in times:
    if t >= start + window:
        start = t
        groups.append([])
    groups[-1].append(t)
print(groups)
--- test
assert groups == [[0], [5]], f"The request at time 5 is one window after the start, so it begins a new group: [[0], [5]]. The code gives {groups}. Use >=."
--- hint
The window is closed at its end.
--- hint
Use `>=` with `start + window`.
```

## Predict the batch count

```python predict id=predict-batch title="How many batches do arrivals 0, 1 and 20 form with a window of 5?"
times, window = [0, 1, 20], 5
batches = 1 + sum(1 for i in range(1, len(times)) if times[i] >= times[0] + window and times[i] - times[i - 1] >= 0)
print(2)
--- options
* 2
1
3
0
--- explain
Times 0 and 1 share a window, and the time 20 is far enough from the start to open a second batch.
```

## Recap

- Micro-batching groups requests that arrive within a short window.
- The window trades throughput against the wait each request pays.
- Set the window against the tail latency budget.

**Up next:** inference latency, and why percentiles matter more than averages.
', 0, '[]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_4_2', 'sec_mlops_in_production_4', 'crs_mlops_in_production', 'Inference latency and percentiles', 'interactive', 1, 960, NULL, NULL, 'Users experience the slow requests, not the average one. A service with a fast median can still frustrate many people if its tail is long. Latency targets are therefore written as percentiles: p50 for the typical request and p95 or p99 for the tail. The nearest-rank method gives a percentile directly from a sorted list of measurements.

## Percentiles by nearest rank

The nearest-rank percentile takes the value at position ceiling of p times n over 100, counting from one.

```python run
import math

def percentile(values, p):
    s = sorted(values)
    rank = math.ceil(p / 100 * len(s))
    return s[max(rank, 1) - 1]

latencies = [12, 15, 14, 90, 13, 16, 18, 11, 14, 300]
print("p50:", percentile(latencies, 50), "| p90:", percentile(latencies, 90))
```

## The mean hides the tail

The average of these latencies is pulled up by two slow requests, and the median is not.

```python run
print("mean:", round(sum(latencies) / len(latencies), 1), "| p50:", percentile(latencies, 50))
```

## Checking a budget

A latency budget is met when the chosen percentile is within it.

```python run
budget_ms = 100
print("p95 within budget:", percentile(latencies, 95) <= budget_ms)
```

## Where the time goes

Total latency is the sum of the stages, and the largest stage is the one to optimize.

```python run
stages = {"queue": 4, "feature lookup": 12, "model": 38, "serialization": 3}
slowest = max(stages, key=stages.get)
print("total:", sum(stages.values()), "ms | slowest stage:", slowest)
```

> **Pitfall:** averages of percentiles are not percentiles. Compute the percentile over the raw measurements, and do not average per-server percentiles.

> **In the wild:** service dashboards show p50, p95 and p99 over time, and an alert fires when the budget is exceeded for a sustained period.

## Challenge: nearest-rank percentile

```python exercise id=percentile title="Nearest-rank percentile"
import math

# TODO: `percentile(values, p)` returns the nearest-rank percentile: sort the values, take rank = ceil(p / 100 × n), and return
# the value at position rank counted from one. Use rank 1 when the rank would be zero.
def percentile(values, p):
    ...
--- solution
import math

def percentile(values, p):
    s = sorted(values)
    rank = math.ceil(p / 100 * len(s))
    return s[max(rank, 1) - 1]
--- test
data = list(range(1, 11))
assert percentile(data, 50) is not None, "Replace the `...` in `percentile` with code that returns the value."
assert percentile(data, 50) == 5, f"The 50th percentile of 1 to 10 is 5, but you returned {percentile(data, 50)}."
assert percentile(data, 95) == 10, "The 95th percentile of 1 to 10 is 10."
assert percentile(data, 10) == 1, "The 10th percentile of 1 to 10 is 1."
--- hint
Sort first, then find the rank, then subtract one to index the list.
--- hint
`s[math.ceil(p / 100 * len(s)) - 1]`, guarding against a rank of zero.
```

## Challenge: within budget

```python exercise id=within-budget title="Does a percentile meet the budget?"
import math

def percentile(values, p):
    s = sorted(values)
    rank = math.ceil(p / 100 * len(s))
    return s[max(rank, 1) - 1]

# TODO: `within_budget(latencies, budget_ms, p=95)` returns True when the nearest-rank percentile p of the latencies is at most
# budget_ms. The function percentile above is provided.
def within_budget(latencies, budget_ms, p=95):
    ...
--- solution
import math

def percentile(values, p):
    s = sorted(values)
    rank = math.ceil(p / 100 * len(s))
    return s[max(rank, 1) - 1]

def within_budget(latencies, budget_ms, p=95):
    return percentile(latencies, p) <= budget_ms
--- test
result = within_budget([10, 20, 30, 400], 100)
assert result is not None, "Replace the `...` in `within_budget` with code that returns the check."
assert result is False, "The 95th percentile here is 400, which is over the budget of 100."
assert within_budget([10, 20, 30], 100) is True, "The 95th percentile of these values is 30, within the budget."
--- hint
Compare the percentile to the budget with `<=`.
--- hint
`percentile(latencies, p) <= budget_ms`.
```

## Debug: a percentile off by one

The median of five values should be the third, but the index is taken as the rank itself, which is one position too far.

```python debug id=percentile-index title="Index the list from one"
import math
values = [1, 2, 3, 4, 5]
p = 50
s = sorted(values)
rank = math.ceil(p / 100 * len(s))
value = s[rank]                      # bug: nearest rank counts from one, so the index is rank - 1
print("p50:", value)
--- solution
import math
values = [1, 2, 3, 4, 5]
p = 50
s = sorted(values)
rank = math.ceil(p / 100 * len(s))
value = s[rank - 1]
print("p50:", value)
--- test
assert value == 3, f"The median of 1 to 5 is 3, but the code gives {value}. Subtract one from the rank to index the list."
--- hint
The third of five values has rank 3 and index 2.
--- hint
Use `s[rank - 1]`.
```

## Predict the median

```python predict id=predict-median title="What is the nearest-rank p50 of 1 to 5?"
import math
s = [1, 2, 3, 4, 5]
print(s[math.ceil(0.5 * len(s)) - 1])
--- options
* 3
2
4
5
--- explain
The rank is ceiling of 2.5, which is 3, so the value at position 3 is 3.
```

## Recap

- Report latency as percentiles, and set budgets on the tail.
- The nearest-rank method is exact and easy to check.
- Find the slowest stage before optimizing anything.

**Up next:** data drift, and how to detect that the inputs have changed.
', 0, '[]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_4_3', 'sec_mlops_in_production_4', 'crs_mlops_in_production', 'Checkpoint: serving', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why report latency as a percentile rather than an average?","options":["A few very slow requests can hide behind a good average, but show up in the 95th percentile","Averages cannot be computed","Percentiles are always smaller","Averages measure cost"],"answerIndex":0,"explanation":"Tail latency is what users feel when something is slow, and averages hide it."},{"id":"q2","prompt":"What does micro-batching trade off?","options":["Throughput and cost against a short added wait per request","Accuracy against memory","Training speed against storage","Security against cost"],"answerIndex":0,"explanation":"Grouping requests uses hardware better, but each request may wait for its batch."},{"id":"q3","prompt":"Which metric is usually checked against a latency budget?","options":["A high percentile of the response time, such as p95","The number of model parameters","The size of the training set","The number of developers"],"answerIndex":0,"explanation":"Budgets are set on tail percentiles, so most users are served within the target."},{"id":"q4","prompt":"What is the nearest-rank p50 of the values 1, 2, 3, 4, 5?","options":["3","2","4","2.5"],"answerIndex":0,"explanation":"The median of five sorted values is the third one, which is 3."}]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_5_1', 'sec_mlops_in_production_5', 'crs_mlops_in_production', 'Data drift with the population stability index', 'interactive', 0, 960, NULL, NULL, 'A model is trained on a sample of the world, and the world keeps moving. Data drift means the distribution of inputs in production has shifted from the training distribution. The population stability index compares the two distributions bin by bin. A small value means the inputs look the same, and a large value means they have moved enough to threaten the model.

## Binning a feature

Both distributions are compared over the same bins. Each bin holds the share of values that fall in it.

```python run
import numpy as np

def bin_proportions(values, edges):
    counts, _ = np.histogram(values, bins=edges)
    return counts / counts.sum()

rng = np.random.default_rng(12)
reference = rng.normal(0, 1, 5000)
edges = np.linspace(-3, 3, 7)
print("reference bin shares:", np.round(bin_proportions(reference, edges), 3))
```

## Shifted production data

Production data with a shifted mean puts more of its mass in the upper bins.

```python run
production = rng.normal(0.8, 1, 5000)
print("production bin shares:", np.round(bin_proportions(production, edges), 3))
```

## The population stability index

For each bin the index adds (actual − expected) times the log of actual over expected. The sum is zero when the distributions match, and it grows as they diverge.

```python run
import math

def psi(expected, actual):
    return sum((a - e) * math.log(a / e) for e, a in zip(expected, actual))

exp_p = bin_proportions(reference, edges)
act_p = bin_proportions(production, edges)
print("PSI of the shifted data:", round(psi(exp_p, act_p), 3))
print("PSI of the reference against itself:", round(psi(exp_p, exp_p), 3))
```

## Reading the index

A common rule of thumb reads a value below 0.1 as stable, 0.1 to 0.2 as a shift to watch, and above 0.2 as a shift that needs action.

```python run
for value in [0.05, 0.15, 0.3]:
    level = "stable" if value < 0.1 else ("watch" if value < 0.2 else "act")
    print(value, "->", level)
```

> **Pitfall:** the index depends on the bins. Choose bins from the reference data, not from production, or the comparison moves with the bins.

> **In the wild:** monitoring systems compute a drift score for every feature each day, and surface the features whose scores have risen the most.

## Challenge: bin proportions

```python exercise id=bin-proportions title="Share of values in each bin"
import numpy as np

# TODO: `bin_proportions(values, edges)` returns a numpy array with the share of values in each bin defined by the edges. Use
# np.histogram with bins=edges and divide the counts by their total.
def bin_proportions(values, edges):
    ...
--- solution
import numpy as np

def bin_proportions(values, edges):
    counts, _ = np.histogram(values, bins=edges)
    return counts / counts.sum()
--- test
import numpy as np
result = bin_proportions([0.5, 1.5, 2.5, 2.9], [0, 1, 2, 3])
assert result is not None, "Replace the `...` in `bin_proportions` with code that returns the shares."
assert np.allclose(result, [0.25, 0.25, 0.5]), f"One value falls in each of the first two bins and two in the last, so the shares are [0.25, 0.25, 0.5], but you returned {result}."
--- hint
Use `np.histogram`, and divide by the total of the counts.
--- hint
`counts, _ = np.histogram(values, bins=edges)`.
```

## Challenge: population stability index

```python exercise id=psi title="Population stability index"
import math

# TODO: `psi(expected, actual)` takes two lists of bin proportions and returns the sum over bins of (actual − expected) times
# log(actual / expected).
def psi(expected, actual):
    ...
--- solution
import math

def psi(expected, actual):
    return sum((a - e) * math.log(a / e) for e, a in zip(expected, actual))
--- test
assert abs(psi([0.5, 0.5], [0.5, 0.5])) < 1e-12, "Identical distributions have an index of zero."
result = psi([0.5, 0.5], [0.9, 0.1])
expected_value = (0.9 - 0.5) * math.log(0.9 / 0.5) + (0.1 - 0.5) * math.log(0.1 / 0.5)
assert result is not None, "Replace the `...` in `psi` with code that returns the index."
assert abs(result - expected_value) < 1e-9, f"The index for [0.5, 0.5] against [0.9, 0.1] is {expected_value:.4f}, but you returned {result}."
--- hint
Zip the two lists, then add up the terms.
--- hint
Each term is `(a - e) * math.log(a / e)`.
```

## Debug: the sign of the log ratio

The index should be positive when the distributions differ, but the log ratio is inverted, which flips the sign.

```python debug id=psi-sign title="Take the log of actual over expected"
import math
expected = [0.5, 0.5]
actual = [0.9, 0.1]
psi_value = sum((a - e) * math.log(e / a) for e, a in zip(expected, actual))   # bug: the ratio is inverted
print("psi:", round(psi_value, 4))
--- solution
import math
expected = [0.5, 0.5]
actual = [0.9, 0.1]
psi_value = sum((a - e) * math.log(a / e) for e, a in zip(expected, actual))
print("psi:", round(psi_value, 4))
--- test
assert abs(psi_value - 0.8789) < 1e-4, f"The index for these distributions is 0.8789, but the code gives {psi_value:.4f}. The log ratio is actual over expected."
--- hint
Each term must be positive when the actual share exceeds the expected share.
--- hint
Write `math.log(a / e)`.
```

## Predict the index

```python predict id=predict-psi title="What is the index of a distribution against itself?"
import math
e = [0.5, 0.5]
a = [0.5, 0.5]
print(round(sum((x - y) * math.log(x / y) for x, y in zip(a, e)), 3))
--- options
* 0.0
1.0
0.5
-1.0
--- explain
Every term has a difference of zero, so the sum is zero.
```

## Recap

- Drift compares the binned distribution of a feature in production with the reference.
- The population stability index is zero for identical distributions and grows as they diverge.
- Choose the bins from the reference, and read the index against agreed thresholds.

**Up next:** alerting and retraining rules, which turn drift scores into decisions.
', 0, '[]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_5_2', 'sec_mlops_in_production_5', 'crs_mlops_in_production', 'Alerting and retraining rules', 'interactive', 1, 840, NULL, NULL, 'A drift score is only useful when it becomes a decision. Alerts should fire when a shift is real, not when one noisy day looks unusual. A retraining rule should require the shift to persist, and it should hand the decision to a person when the stakes are high. Writing these rules down as code makes them testable and reviewable.

## Levels from a score

A score is mapped to a level, so the response is consistent across features.

```python run
def alert_level(psi_value):
    if psi_value < 0.1:
        return "ok"
    if psi_value < 0.2:
        return "watch"
    return "alert"

for v in [0.05, 0.15, 0.3]:
    print(v, "->", alert_level(v))
```

## A single bad day

One day above the threshold can be noise. The rule below looks at the most recent days.

```python run
daily_psi = [0.05, 0.12, 0.31, 0.08, 0.25]
recent = daily_psi[-3:]
print("last three days:", recent, "| all above 0.2:", all(v > 0.2 for v in recent))
```

## Persistence before retraining

Retraining is expensive and should be deliberate. Requiring several consecutive days above the threshold guards against false alarms.

```python run
def should_retrain(daily, threshold=0.2, consecutive=3):
    if len(daily) < consecutive:
        return False
    return all(v > threshold for v in daily[-consecutive:])

print(should_retrain([0.1, 0.25, 0.3, 0.4]), should_retrain([0.3, 0.1, 0.3, 0.4]))
```

## A decision needs an approval

Even when the rule fires, a retrained model should be evaluated and approved before it replaces the one in production.

```python run
retrain_triggered = True
evaluation_better = True
approved = retrain_triggered and evaluation_better
print("deploy the new model:", approved)
```

> **Pitfall:** an alert with no owner gets ignored. Route every alert to a named person or channel, and record what was done about it.

> **In the wild:** teams set a drift alert and a retrain policy together, and review the number of alerts each week, because too many alerts train people to ignore them.

## Challenge: alert level

```python exercise id=alert-level title="Map a drift score to a level"
# TODO: `alert_level(psi_value)` returns "ok" for values below 0.1, "watch" for values from 0.1 up to but not including 0.2, and
# "alert" for values of 0.2 or more.
def alert_level(psi_value):
    ...
--- solution
def alert_level(psi_value):
    if psi_value < 0.1:
        return "ok"
    if psi_value < 0.2:
        return "watch"
    return "alert"
--- test
assert alert_level(0.05) == "ok", "A small score is ok."
assert alert_level(0.1) == "watch", "A score of exactly 0.1 is the start of watch."
assert alert_level(0.2) == "alert", "A score of exactly 0.2 is an alert."
--- hint
Check the thresholds in order, from the lowest.
--- hint
Use `<` for the lower bounds and return "alert" last.
```

## Challenge: retraining rule

```python exercise id=should-retrain title="Retrain only on sustained drift"
# TODO: `should_retrain(daily, threshold=0.2, consecutive=3)` returns True when there are at least consecutive values and every
# one of the last consecutive values is greater than threshold. Otherwise it returns False.
def should_retrain(daily, threshold=0.2, consecutive=3):
    ...
--- solution
def should_retrain(daily, threshold=0.2, consecutive=3):
    if len(daily) < consecutive:
        return False
    return all(v > threshold for v in daily[-consecutive:])
--- test
assert should_retrain([0.1, 0.25, 0.3, 0.4]) is True, "The last three days are all above 0.2."
assert should_retrain([0.3, 0.1, 0.3, 0.4]) is False, "One day below the threshold in the last three stops the retrain."
assert should_retrain([0.5, 0.5]) is False, "Fewer days than the required count is not enough."
--- hint
Take the last `consecutive` values, then test that every one exceeds the threshold.
--- hint
`all(v > threshold for v in daily[-consecutive:])`.
```

## Debug: any day triggers retraining

Retraining should require every recent day to exceed the threshold, but this check fires when any single day does.

```python debug id=any-day title="Require every recent day above the threshold"
daily_psi = [0.3, 0.1, 0.3]
threshold = 0.2
recent = daily_psi[-3:]
retrain = any(v > threshold for v in recent)     # bug: one day above the threshold is enough
print("retrain:", retrain)
--- solution
daily_psi = [0.3, 0.1, 0.3]
threshold = 0.2
recent = daily_psi[-3:]
retrain = all(v > threshold for v in recent)
print("retrain:", retrain)
--- test
assert retrain is False, "The day with 0.1 is below the threshold, so the rule must not retrain. Require every day with all, not any."
--- hint
A sustained shift means all of the recent days are above the threshold.
--- hint
Use `all` instead of `any`.
```

## Predict the level

```python predict id=predict-level title="What alert level does a score of 0.25 give?"
def alert_level(psi_value):
    if psi_value < 0.1:
        return "ok"
    if psi_value < 0.2:
        return "watch"
    return "alert"
print(alert_level(0.25))
--- options
* alert
watch
ok
error
--- explain
A score of 0.25 is at least 0.2, so it is an alert.
```

## Recap

- Map scores to levels, so responses are consistent.
- Retrain only on sustained drift, and require an evaluation before deploying.
- Give every alert an owner, and review how often they fire.

**Up next:** a capstone that monitors a model end to end.
', 0, '[]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_5_3', 'sec_mlops_in_production_5', 'crs_mlops_in_production', 'Capstone: a monitored model end to end', 'interactive', 2, 1440, NULL, NULL, 'This capstone runs a monitored model end to end. A reference distribution is fixed at training time. Each day, a batch of production inputs arrives, its drift score is computed against the reference, and the level and retraining decision are recorded. The inputs drift partway through, and the monitoring should notice, persist and recommend retraining.

## The reference and the bins

The reference sample is drawn once, and the bins are set from it, as the drift lesson recommends.

```python run
import numpy as np

rng = np.random.default_rng(13)
reference = rng.normal(0, 1, 5000)
edges = np.linspace(-4, 4, 9)
ref_p = np.histogram(reference, bins=edges)[0] / len(reference)
print("reference shares:", np.round(ref_p, 3))
```

## A simulated week

The first four days come from the training distribution, and the rest are shifted. Each day''s batch gets a score.

```python run
import math

def psi(expected, actual):
    return sum((a - e) * math.log(a / e) for e, a in zip(expected, actual))

days = []
for day in range(8):
    shift = 0.0 if day < 4 else 1.2
    batch = rng.normal(shift, 1, 500)
    act_p = np.histogram(batch, bins=edges)[0] / len(batch)
    act_p = np.clip(act_p, 1e-6, None)
    days.append(round(psi(np.clip(ref_p, 1e-6, None), act_p), 3))
print("daily PSI:", days)
```

## Levels and the retraining decision

The levels and the persistence rule from the monitoring lesson are applied to the daily scores.

```python run
def alert_level(v):
    return "ok" if v < 0.1 else ("watch" if v < 0.2 else "alert")

print("levels:", [alert_level(v) for v in days])
print("retrain the model after the week:", all(v > 0.2 for v in days[-3:]))
```

> **Pitfall:** the clipping of tiny proportions keeps the log finite, but it also changes the score of empty bins. Report the bin count with every score, so an empty bin is visible.

> **In the wild:** a monitoring capstone like this one becomes a scheduled job that writes scores to a dashboard, so the on-call engineer sees the shift before users do.

## Challenge: the daily report

```python exercise id=daily-report title="Summarize the drift alerts for the week"
# TODO: `daily_report(days_psi, threshold, consecutive)` returns a dictionary with "alerts", the zero-based indices of the days
# whose level is "alert", and "retrain", True when should_retrain on the list is True. The functions below are provided.
def alert_level(v):
    return "ok" if v < 0.1 else ("watch" if v < 0.2 else "alert")

def should_retrain(daily, threshold=0.2, consecutive=3):
    if len(daily) < consecutive:
        return False
    return all(v > threshold for v in daily[-consecutive:])

def daily_report(days_psi, threshold, consecutive):
    ...
--- solution
def alert_level(v):
    return "ok" if v < 0.1 else ("watch" if v < 0.2 else "alert")

def should_retrain(daily, threshold=0.2, consecutive=3):
    if len(daily) < consecutive:
        return False
    return all(v > threshold for v in daily[-consecutive:])

def daily_report(days_psi, threshold, consecutive):
    alerts = [i for i, v in enumerate(days_psi) if alert_level(v) == "alert"]
    return {"alerts": alerts, "retrain": should_retrain(days_psi, threshold, consecutive)}
--- test
result = daily_report([0.05, 0.25, 0.3, 0.4], 0.2, 3)
assert result is not None, "Replace the `...` in `daily_report` with code that returns the report."
assert result == {"alerts": [1, 2, 3], "retrain": True}, f"Days 1 to 3 are alerts, and the last three exceed 0.2, but you returned {result}."
assert daily_report([0.05, 0.05], 0.2, 3) == {"alerts": [], "retrain": False}, "A calm week has no alerts and no retraining."
--- hint
Enumerate the scores to get zero-based day indices, and reuse `should_retrain`.
--- hint
`[i for i, v in enumerate(days_psi) if alert_level(v) == "alert"]`.
```

## Challenge: count the alerts

The level function is provided, and your task is to count the days at the alert level.

```python exercise id=count-alerts title="Count the days at the alert level"
def alert_level(v):
    return "ok" if v < 0.1 else ("watch" if v < 0.2 else "alert")

# TODO: `count_alerts(days_psi)` returns how many scores in the list have the level "alert".
def count_alerts(days_psi):
    ...
--- solution
def alert_level(v):
    return "ok" if v < 0.1 else ("watch" if v < 0.2 else "alert")

def count_alerts(days_psi):
    return sum(alert_level(v) == "alert" for v in days_psi)
--- test
result = count_alerts([0.05, 0.25, 0.3])
assert result is not None, "Replace the `...` in `count_alerts` with code that returns the count."
assert result == 2, f"0.25 and 0.3 are alerts, so the count is 2, but you returned {result}."
assert count_alerts([0.01, 0.02]) == 0, "A calm week has no alerts."
--- hint
Sum a boolean over the scores, using the provided `alert_level`.
--- hint
`sum(alert_level(v) == "alert" for v in days_psi)`.
```

## Debug: days numbered from one

The alert days should be zero-based indices, but the enumeration starts at one, so every day is labelled one later.

```python debug id=day-index title="Number the days from zero"
days = [0.05, 0.25, 0.3, 0.4]
alerts = [i for i, v in enumerate(days, start=1) if v >= 0.2]   # bug: days are numbered from zero
print("alert days:", alerts)
--- solution
days = [0.05, 0.25, 0.3, 0.4]
alerts = [i for i, v in enumerate(days) if v >= 0.2]
print("alert days:", alerts)
--- test
assert alerts == [1, 2, 3], f"The alert days are the second to fourth entries, which are indices 1, 2 and 3, but the code gives {alerts}. Enumerate from zero."
--- hint
The first entry of a list has index zero.
--- hint
Remove `start=1`.
```

## Counting the levels

A summary of the levels across the week is the first thing an on-call engineer reads.

```python run
from collections import Counter
print("levels:", Counter(alert_level(v) for v in days))
```

## Predict the alert count

```python predict id=predict-alerts title="How many of these daily scores are at least 0.2?"
days = [0.05, 0.25, 0.3]
print(sum(v >= 0.2 for v in days))
--- options
* 2
1
3
0
--- explain
Two scores, 0.25 and 0.3, are at least 0.2.
```

## Recap

- Fix the reference and its bins before monitoring starts.
- Score each day against the reference, and record the level.
- Recommend retraining only on sustained drift, and require an approved evaluation before deploying.

**Up next:** the final assessment covers the whole course.
', 0, '[]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z'),
('les_mlops_in_production_5_4', 'sec_mlops_in_production_5', 'crs_mlops_in_production', 'Final assessment: MLOps in Production', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does a population stability index measure?","options":["How much the distribution of a feature has shifted from the reference","The accuracy of the model","The size of the training data","The speed of the server"],"answerIndex":0,"explanation":"PSI compares the binned distribution of a feature in production with its reference distribution."},{"id":"q2","prompt":"Why require several consecutive days above a threshold before retraining?","options":["A single noisy day should not trigger an expensive retrain","Retraining is always free","Thresholds are never reached","Consecutive days are always identical"],"answerIndex":0,"explanation":"Requiring persistence guards against false alarms from a single unusual day."},{"id":"q3","prompt":"What should a retraining decision be checked against before release?","options":["The new model''s evaluation on held-out data, compared with the current model","The name of the engineer","The number of features only","The date of the last holiday"],"answerIndex":0,"explanation":"A retrained model must be shown to be better on evaluation data before it replaces the current one."},{"id":"q4","prompt":"Why bin the feature values in a drift check?","options":["To compare the proportions of values in matching ranges between two datasets","To make the model smaller","To remove missing values","To rename the features"],"answerIndex":0,"explanation":"Binning turns two samples into comparable distributions."},{"id":"q5","prompt":"Why is point-in-time correctness important for offline evaluation?","options":["Without it, the evaluation uses information that production would not have, and the scores are too optimistic","It makes the dataset larger","It removes the need for a test set","It makes training faster"],"answerIndex":0,"explanation":"Leakage inflates offline metrics, so the model disappoints once it is served."},{"id":"q6","prompt":"What is the reason to version the code, data and model together?","options":["So any past result can be reproduced from the exact inputs that produced it","So the files are smaller","So the model trains faster","So no one needs to write documentation"],"answerIndex":0,"explanation":"Reproducibility needs all three to be pinned, otherwise a result cannot be traced back."}]', '[]', '2026-06-25T07:28:16.914Z', '2026-10-19T07:28:16.914Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_ml_engineer', 'crs_mlops_in_production', 6);

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_mlops_in_production_1', 'usr_seed000001', 'crs_mlops_in_production', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-09-19T05:28:16.914Z', '2026-09-19T05:28:16.914Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000001');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_mlops_in_production_2', 'usr_seed000013', 'crs_mlops_in_production', 5, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-10-21T04:28:16.914Z', '2026-10-21T04:28:16.914Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000013');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_mlops_in_production_3', 'usr_seed00001a', 'crs_mlops_in_production', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-08-31T01:28:16.914Z', '2026-08-31T01:28:16.914Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001a');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_mlops_in_production_4', 'usr_seed00001h', 'crs_mlops_in_production', 3, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-08-05T13:28:16.914Z', '2026-08-05T13:28:16.914Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001h');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_mlops_in_production_5', 'usr_seed00002a', 'crs_mlops_in_production', 5, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-10-07T17:28:16.914Z', '2026-10-07T17:28:16.914Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002a');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_mlops_in_production_6', 'usr_seed00002e', 'crs_mlops_in_production', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-10-22T05:28:16.914Z', '2026-10-22T05:28:16.914Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002e');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_mlops_in_production_7', 'usr_seed000030', 'crs_mlops_in_production', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-10-17T17:28:16.914Z', '2026-10-17T17:28:16.914Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000030');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_mlops_in_production_8', 'usr_seed00003k', 'crs_mlops_in_production', 4, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-10-10T12:28:16.914Z', '2026-10-10T12:28:16.914Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003k');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_mlops_in_production_9', 'usr_seed00003o', 'crs_mlops_in_production', 4, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-10-09T12:28:16.914Z', '2026-10-09T12:28:16.914Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003o');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_mlops_in_production_10', 'usr_seed00003p', 'crs_mlops_in_production', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-10-23T07:28:16.914Z', '2026-10-23T07:28:16.914Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003p');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_mlops_in_production'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_mlops_in_production') WHERE id = 'crs_mlops_in_production';
