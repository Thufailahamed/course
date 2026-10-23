A model asked for JSON usually returns JSON, but not always, and the rare failures are the ones that break your code. Treat every model output as untrusted input. Parse it, check its fields and types against a schema, and retry or fall back when it fails. The checks below are plain Python, so they apply to any model or API.

## Parsing with a fallback

A parser returns the object when the text is valid JSON and None when it is not.

```python run
import json

def parse_or_none(text):
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return None

outputs = ['{"category": "billing", "urgent": true}', 'Sure! Here is the JSON: {...}']
for text in outputs:
    print(parse_or_none(text))
```

## Checking the fields

A schema lists each required field and its type. The validator reports every mismatch, not only the first.

```python run
schema = {"category": str, "urgent": bool, "score": int}

def validate_fields(obj, schema):
    errors = []
    for key, typ in schema.items():
        if key not in obj:
            errors.append(f"missing {key}")
        elif not isinstance(obj[key], typ):
            errors.append(f"{key} should be {typ.__name__}")
    return errors

print(validate_fields({"category": "billing", "urgent": True, "score": 3}, schema))
print(validate_fields({"category": 7, "urgent": "yes"}, schema))
```

## A retry loop

When validation fails, the caller can ask again or stop. The loop below uses scripted outputs in place of a model.

```python run
scripted = ["not json", '{"category": "billing", "urgent": true, "score": 2}']
result = None
for attempt, text in enumerate(scripted, start=1):
    obj = parse_or_none(text)
    if obj is not None and not validate_fields(obj, schema):
        result = obj
        break
print("accepted on attempt", attempt, "->", result)
```

## Booleans are integers in Python

Python treats True as an integer, which matters when a schema asks for an integer score.

```python run
print("isinstance(True, int):", isinstance(True, int))
```

> **Pitfall:** a validator that only checks that the output parses will accept a score of "high" or an answer with missing fields. Always check the types and the values your code depends on.

> **In the wild:** hosted APIs offer JSON modes and schema-constrained decoding, which reduce these failures. The validator still belongs in your code, because the schema and the model can disagree.

## Challenge: parse or none

```python exercise id=parse-or-none title="Parse JSON or return None"
import json

# TODO: `parse_or_none(text)` returns the parsed object from a JSON string, or None if the text is not valid JSON.
def parse_or_none(text):
    ...
--- solution
import json

def parse_or_none(text):
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return None
--- test
result = parse_or_none('{"a": 1}')
assert result is not None, "Replace the `...` in `parse_or_none` with code that returns the object."
assert result == {"a": 1}, f"Valid JSON should parse to the dictionary, but you returned {result!r}."
assert parse_or_none("Sure, here it is") is None, "Text that is not JSON gives None."
--- hint
Wrap `json.loads` in a try block and catch `json.JSONDecodeError`.
--- hint
`try: return json.loads(text)` then `except json.JSONDecodeError: return None`.
```

## Challenge: field validation

```python exercise id=validate-fields title="List the schema errors"
# TODO: `validate_fields(obj, schema)` returns a list of error strings: "missing <key>" for each schema key absent from obj, and
# "<key> should be <type name>" for each key whose value is not an instance of the schema type.
def validate_fields(obj, schema):
    ...
--- solution
def validate_fields(obj, schema):
    errors = []
    for key, typ in schema.items():
        if key not in obj:
            errors.append(f"missing {key}")
        elif not isinstance(obj[key], typ):
            errors.append(f"{key} should be {typ.__name__}")
    return errors
--- test
result = validate_fields({"score": "high"}, {"score": int, "name": str})
assert result is not None, "Replace the `...` in `validate_fields` with code that returns the errors."
assert "missing name" in result, "A missing key must be reported."
assert "score should be int" in result, "A value of the wrong type must be reported."
assert validate_fields({"score": 3, "name": "a"}, {"score": int, "name": str}) == [], "A valid object has no errors."
--- hint
Loop over the schema, then check membership and then the type with `isinstance`.
--- hint
Use `typ.__name__` to print the type's name.
```

## Debug: booleans passing as integers

A score must be an integer, and a boolean should be rejected, but the check accepts True because bool is a subclass of int.

```python debug id=bool-as-int title="Reject booleans in integer fields"
def is_int_field(value):
    return isinstance(value, int)     # bug: True is also an int in Python

print("True accepted as an int?", is_int_field(True))
print("3 accepted as an int?", is_int_field(3))
--- solution
def is_int_field(value):
    return isinstance(value, int) and not isinstance(value, bool)

print("True accepted as an int?", is_int_field(True))
print("3 accepted as an int?", is_int_field(3))
--- test
assert is_int_field(True) is False, "A boolean is not a valid integer score, so True must be rejected. Exclude bool explicitly."
assert is_int_field(3) is True, "The integer 3 must still be accepted."
--- hint
Python's bool is a subclass of int.
--- hint
Add `and not isinstance(value, bool)`.
```

## Predict the parsed value

```python predict id=predict-json title="What does this JSON parse to when you read the key 'a'?"
import json
print(json.loads('{"a": 1}')["a"])
--- options
* 1
"1"
{"a": 1}
None
--- explain
json.loads returns a dictionary, and its value for 'a' is the number 1.
```

## Recap

- Treat model output as untrusted input, and parse it defensively.
- Validate every field your code uses, including its type.
- Retry on failure with a bounded number of attempts, then fall back.

**Up next:** retrieval-augmented generation, starting with how documents are split.
