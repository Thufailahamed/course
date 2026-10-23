A model trained on data that has quietly changed cannot be reproduced. Versioning data means giving each dataset a fingerprint computed from its contents, so that any change, however small, produces a different identifier. The fingerprint must not depend on the order in which rows are stored, because the same data can be written in different orders.

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

## Hashing one file's content

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
assert result == ["a", "b", "c"], f"a was removed, b changed and c was added, so the result is ['a', 'b', 'c'], but you returned {result}."
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
The pair ('b', 2) is only in the first dictionary and ('b', 3) only in the second, so two items differ.
```

## Recap

- Fingerprint the contents of the data, not its name or size.
- Make the fingerprint independent of row order, so equal data matches.
- Record the fingerprint with every model, so results can be traced.

**Up next:** experiment tracking, and how to compare runs honestly.
