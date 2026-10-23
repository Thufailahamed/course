A model calls a tool by naming it and supplying arguments as data. The program must check that data before running anything. Arguments can be missing, mistyped or extra, and each of those should produce a clear error the model can read and correct, not a crash in the middle of a side effect.

## A tool schema

A schema describes the arguments of a tool: their names and types. It is what the model sees, and what the validator checks.

```python run
ADD_SCHEMA = {"a": int, "b": int}
print("schema for add:", {k: t.__name__ for k, t in ADD_SCHEMA.items()})
```

## Checking the arguments

The validator reports missing arguments, wrong types and unexpected extras, all at once.

```python run
def validate_args(args, schema):
    errors = []
    for key, typ in schema.items():
        if key not in args:
            errors.append(f"missing {key}")
        elif not isinstance(args[key], typ):
            errors.append(f"{key} should be {typ.__name__}")
    for key in args:
        if key not in schema:
            errors.append(f"unknown {key}")
    return errors

print(validate_args({"a": 2, "b": 3}, ADD_SCHEMA))
print(validate_args({"a": "2", "c": 1}, ADD_SCHEMA))
```

## Dispatch only valid calls

A dispatcher runs the tool only when its arguments pass validation, and otherwise returns an error the model can read.

```python run
def dispatch(name, args, tools, schemas):
    errors = validate_args(args, schemas[name])
    if errors:
        return {"ok": False, "error": "; ".join(errors)}
    return {"ok": True, "result": tools[name](**args)}

tools = {"add": lambda a, b: a + b}
schemas = {"add": ADD_SCHEMA}
print(dispatch("add", {"a": 2, "b": 3}, tools, schemas))
print(dispatch("add", {"a": 2}, tools, schemas))
```

## Refusing an unknown tool

A dispatcher that checks the name first returns a readable error for a tool that does not exist.

```python run
def dispatch_safe(name, args, tools, schemas):
    if name not in schemas:
        return {"ok": False, "error": "unknown tool"}
    return dispatch(name, args, tools, schemas)

print(dispatch_safe("sub", {}, tools, schemas))
```

> **Pitfall:** a model may invent a tool name that you never defined. The dispatcher must check that the name exists before indexing the tools table, or a typo becomes a KeyError that stops the agent.

> **In the wild:** structured-output and tool-calling APIs constrain arguments to a schema, but a validator in your code remains the last line of defence.

## Challenge: argument validation

```python exercise id=validate-args title="Validate tool arguments against a schema"
# TODO: `validate_args(args, schema)` returns a list of error strings. Add "missing <key>" for each schema key absent from args,
# "<key> should be <type name>" for each key whose value is not an instance of the schema type, and "unknown <key>" for each
# argument key not in the schema.
def validate_args(args, schema):
    ...
--- solution
def validate_args(args, schema):
    errors = []
    for key, typ in schema.items():
        if key not in args:
            errors.append(f"missing {key}")
        elif not isinstance(args[key], typ):
            errors.append(f"{key} should be {typ.__name__}")
    for key in args:
        if key not in schema:
            errors.append(f"unknown {key}")
    return errors
--- test
result = validate_args({"a": 1, "c": 2}, {"a": int, "b": int})
assert result is not None, "Replace the `...` in `validate_args` with code that returns the errors."
assert "missing b" in result, "A schema key that is absent must be reported as missing."
assert "unknown c" in result, "An argument that is not in the schema must be reported."
assert validate_args({"a": 1, "b": 2}, {"a": int, "b": int}) == [], "Valid arguments give no errors."
assert validate_args({"a": "x", "b": 2}, {"a": int, "b": int}) == ["a should be int"], "A wrong type must be reported."
--- hint
Loop over the schema for missing and wrong-type keys, then loop over the arguments for unknown keys.
--- hint
`isinstance(args[key], typ)` checks the type, and `typ.__name__` names it.
```

## Challenge: a single dispatch

```python exercise id=dispatch title="Dispatch a call only when it is valid"
# TODO: `dispatch(name, args, tools, schemas)` returns {"ok": False, "error": message} when name is not in schemas or the
# arguments fail validation, where message joins the errors with "; " or says "unknown tool". Otherwise it returns
# {"ok": True, "result": tools[name](**args)}. The helper `validate_args` below is provided.
def validate_args(args, schema):
    errors = []
    for key, typ in schema.items():
        if key not in args:
            errors.append(f"missing {key}")
        elif not isinstance(args[key], typ):
            errors.append(f"{key} should be {typ.__name__}")
    for key in args:
        if key not in schema:
            errors.append(f"unknown {key}")
    return errors

def dispatch(name, args, tools, schemas):
    ...
--- solution
def validate_args(args, schema):
    errors = []
    for key, typ in schema.items():
        if key not in args:
            errors.append(f"missing {key}")
        elif not isinstance(args[key], typ):
            errors.append(f"{key} should be {typ.__name__}")
    for key in args:
        if key not in schema:
            errors.append(f"unknown {key}")
    return errors

def dispatch(name, args, tools, schemas):
    if name not in schemas:
        return {"ok": False, "error": "unknown tool"}
    errors = validate_args(args, schemas[name])
    if errors:
        return {"ok": False, "error": "; ".join(errors)}
    return {"ok": True, "result": tools[name](**args)}
--- test
tools = {"add": lambda a, b: a + b}
schemas = {"add": {"a": int, "b": int}}
assert dispatch("add", {"a": 2, "b": 3}, tools, schemas) == {"ok": True, "result": 5}, "A valid call runs the tool."
assert dispatch("sub", {}, tools, schemas)["ok"] is False, "An unknown tool is refused without running anything."
bad = dispatch("add", {"a": 2}, tools, schemas)
assert bad["ok"] is False and "missing b" in bad["error"], "A missing argument is refused with a readable error."
--- hint
Check the tool name first, then validate, then call the tool.
--- hint
Call `tools[name](**args)` only after the errors list is empty.
```

## Debug: missing keys are not reported

The validator should report arguments that are missing from the call, but this version only looks at the keys that are present.

```python debug id=missing-keys title="Report keys that are missing"
schema = {"a": int, "b": int}
args = {"a": 1}
errors = []
for key in args:                      # bug: iterates the arguments, not the schema
    if not isinstance(args[key], schema[key]):
        errors.append(f"{key} should be {schema[key].__name__}")
print(errors)
--- solution
schema = {"a": int, "b": int}
args = {"a": 1}
errors = []
for key in schema:
    if key not in args:
        errors.append(f"missing {key}")
    elif not isinstance(args[key], schema[key]):
        errors.append(f"{key} should be {schema[key].__name__}")
print(errors)
--- test
assert "missing b" in errors, f"The argument b is missing, so it must be reported, but the errors are {errors}. Loop over the schema keys and check for absence."
--- hint
A missing argument does not appear in the arguments, so you can only find it by looking at the schema.
--- hint
Loop over `schema` instead of `args`.
```

## Predict the missing count

```python predict id=predict-missing title="How many schema keys are missing from {'a': 1}?"
schema = {"a": int, "b": int}
args = {"a": 1}
print(len([k for k in schema if k not in args]))
--- options
* 1
0
2
3
--- explain
The schema has a and b, the arguments have only a, so b is the single missing key.
```

## Recap

- A schema lists the names and types of a tool's arguments, and the validator checks them.
- Report missing, wrong and unknown arguments, so the model can correct the call.
- Dispatch only after the checks pass, and refuse unknown tool names before indexing.

**Up next:** designing tool interfaces, including the error results that let an agent recover.
