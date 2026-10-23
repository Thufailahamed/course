A tool is an interface that a model uses without seeing its code, so its name, description, arguments and results matter as much as its behaviour. The most useful property a tool can have is a clear failure. When a tool raises an exception, the loop crashes. When it returns an error the model can read, the agent can recover, by trying different arguments or by asking the user.

## Wrapping a tool in a safe call

A wrapper turns any exception into a result with ok set to false and a message the model can read.

```python run
def safe_call(fn, **kwargs):
    try:
        return {"ok": True, "result": fn(**kwargs)}
    except Exception as e:
        return {"ok": False, "error": str(e)}

print(safe_call(lambda a, b: a + b, a=2, b=3))
print(safe_call(lambda a, b: a / b, a=1, b=0))
```

## Results the model can use

A structured result separates the value from the status, which makes it easy for the loop to check.

```python run
def search_orders(customer_id):
    orders = {"c1": ["A-17", "B-02"]}
    if customer_id not in orders:
        return {"ok": False, "error": f"no customer {customer_id}"}
    return {"ok": True, "result": orders[customer_id]}

print(search_orders("c1"))
print(search_orders("c9"))
```

## Descriptions guide the model

The description is part of the interface. A precise one tells the model when to use the tool and when not to.

```python run
tool_spec = {
    "name": "search_orders",
    "description": "Find the order ids for a customer id. Use only when the user gives a customer id.",
    "parameters": {"customer_id": "string"},
}
print(tool_spec["name"], "-", tool_spec["description"])
```

## Idempotent tools are safer to retry

A read is safe to repeat, and a write may not be. Naming and documenting the difference lets the loop retry only the safe calls.

```python run
calls = [("search_orders", True), ("refund_order", False)]
for name, idempotent in calls:
    print(name, "safe to retry:", idempotent)
```

> **Pitfall:** a tool that returns a long raw dump floods the context and hides the answer. Return the fields the model needs, and keep the rest available through a separate call.

> **In the wild:** good tool interfaces read like good APIs: few arguments, clear names, documented errors and predictable results.

## Challenge: safe call

```python exercise id=safe-call title="Turn exceptions into results"
# TODO: `safe_call(fn, **kwargs)` calls fn with the keyword arguments. It returns {"ok": True, "result": value} on success,
# and {"ok": False, "error": str(exception)} if the call raises an exception.
def safe_call(fn, **kwargs):
    ...
--- solution
def safe_call(fn, **kwargs):
    try:
        return {"ok": True, "result": fn(**kwargs)}
    except Exception as e:
        return {"ok": False, "error": str(e)}
--- test
ok = safe_call(lambda a, b: a + b, a=2, b=3)
assert ok is not None, "Replace the `...` in `safe_call` with code that returns the result dictionary."
assert ok == {"ok": True, "result": 5}, f"A successful call returns ok and the result, but you returned {ok}."
bad = safe_call(lambda a, b: a / b, a=1, b=0)
assert bad["ok"] is False and "division" in bad["error"], "A division by zero must be returned as an error that mentions division."
--- hint
Wrap the call in a try block, and catch `Exception`.
--- hint
`except Exception as e: return {"ok": False, "error": str(e)}`.
```

## Challenge: order search

```python exercise id=find-order title="Look up orders for a customer"
# TODO: `find_order(orders, customer_id)` returns {"ok": True, "result": orders[customer_id]} when the customer is present, and
# {"ok": False, "error": "no customer <id>"} otherwise.
def find_order(orders, customer_id):
    ...
--- solution
def find_order(orders, customer_id):
    if customer_id not in orders:
        return {"ok": False, "error": f"no customer {customer_id}"}
    return {"ok": True, "result": orders[customer_id]}
--- test
orders = {"c1": ["A-17"]}
found = find_order(orders, "c1")
assert found is not None, "Replace the `...` in `find_order` with code that returns the result."
assert found == {"ok": True, "result": ["A-17"]}, "A known customer returns the order list."
assert find_order(orders, "c9") == {"ok": False, "error": "no customer c9"}, "An unknown customer returns the error message."
--- hint
Check membership first, as the error branch.
--- hint
Use `f"no customer {customer_id}"` for the message.
```

## Debug: keyword arguments

The tool expects keyword arguments from the model's call, but this version passes the dictionary as one positional argument.

```python debug id=kwargs-unpacking title="Unpack the arguments into keywords"
def add(a, b):
    return a + b

args = {"a": 2, "b": 3}
result = add(args)                 # bug: the dictionary must be unpacked into keyword arguments
print("result:", result)
--- solution
def add(a, b):
    return a + b

args = {"a": 2, "b": 3}
result = add(**args)
print("result:", result)
--- test
assert result == 5, f"The tool should add 2 and 3 to give 5, but the code gives {result}. Unpack the dictionary with **args."
--- hint
The tool takes two named parameters, not one dictionary.
--- hint
Use `add(**args)`.
```

## Predict the flag

```python predict id=predict-ok title="What is the ok flag of a successful safe call?"
safe = {"ok": True, "result": 5}
print(safe["ok"])
--- options
* True
False
None
5
--- explain
A successful call sets ok to True and carries the result alongside it.
```

## Recap

- Tools should fail with readable results, not exceptions that stop the loop.
- Keep descriptions precise, and return only the fields the model needs.
- Mark which tools are safe to retry, because a write may not be.

**Up next:** permissions and sandboxes, which decide what a tool may do.
