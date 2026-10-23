The loop has three parts. It calls the model with the messages so far, it runs any tools the model requested, and it appends the results. It stops when the model answers without a tool call, or when it reaches a step budget. The budget matters, because an agent that never stops costs money and never delivers an answer.

## A scripted model

The scripted model below asks for one tool call, then gives its final answer. Its state records which reply comes next.

```python run
def make_model(replies):
    state = {"i": 0}
    def model(messages):
        reply = replies[state["i"]]
        state["i"] += 1
        return reply
    return model

model = make_model([
    {"content": "", "tool_calls": [{"id": "c1", "name": "add", "arguments": {"a": 2, "b": 3}}]},
    {"content": "The sum is 5.", "tool_calls": []},
])
tools = {"add": lambda a, b: a + b}
print("scripted model and tools ready")
```

## The loop, written out

The loop below runs the tool and records the result under the call's id, which is how the model connects a result to its request.

```python run
messages = [{"role": "user", "content": "What is 2 plus 3?"}]
for step in range(5):
    response = model(messages)
    calls = response["tool_calls"]
    if not calls:
        print("final answer:", response["content"])
        break
    messages.append({"role": "assistant", "content": response["content"], "tool_calls": calls})
    for call in calls:
        result = tools[call["name"]](**call["arguments"])
        messages.append({"role": "tool", "tool_call_id": call["id"], "content": str(result)})
print("messages recorded:", len(messages))
```

Once the loop has run, the tool results are in the messages, and they can be read back out.

```python run
print("tool results so far:", [m["content"] for m in messages if m["role"] == "tool"])
```

## A budget that stops runaway loops

A loop that always requests a tool would run forever without a budget. The budget turns that into a clear failure the caller can handle.

```python run
def runaway_model(messages):
    return {"content": "", "tool_calls": [{"id": "x", "name": "add", "arguments": {"a": 1, "b": 1}}]}

steps_used = 0
for step in range(3):
    steps_used += 1
    response = runaway_model([])
    if not response["tool_calls"]:
        break
print("steps used before the budget stopped it:", steps_used)
```

> **Pitfall:** a tool that returns an exception object instead of a string can break the message format on the next call. Always convert tool results into a plain, serializable form before appending them.

> **In the wild:** teams log every loop iteration with its tool calls and token use, and set a step budget per task. The budget is one of the first controls added after an incident.

## Challenge: the agent loop

```python exercise id=run-agent title="Run an agent until it answers"
# TODO: `run_agent(model, tools, messages, max_steps)` calls `model(messages)` in a loop. If the reply has no tool calls, return
# its content. Otherwise append an assistant message with the tool calls, run each tool with its arguments as keyword
# arguments, append a tool message with the call id and the str of the result, and go round again. Return None after
# max_steps replies without a final answer.
def run_agent(model, tools, messages, max_steps):
    ...
--- solution
def run_agent(model, tools, messages, max_steps):
    for _ in range(max_steps):
        response = model(messages)
        calls = response.get("tool_calls", [])
        if not calls:
            return response["content"]
        messages.append({"role": "assistant", "content": response.get("content", ""), "tool_calls": calls})
        for call in calls:
            result = tools[call["name"]](**call["arguments"])
            messages.append({"role": "tool", "tool_call_id": call["id"], "content": str(result)})
    return None
--- test
def make_model(replies):
    state = {"i": 0}
    def model(messages):
        reply = replies[state["i"]]
        state["i"] += 1
        return reply
    return model

model = make_model([
    {"content": "", "tool_calls": [{"id": "c1", "name": "add", "arguments": {"a": 2, "b": 3}}]},
    {"content": "The sum is 5.", "tool_calls": []},
])
msgs = [{"role": "user", "content": "2 + 3?"}]
result = run_agent(model, {"add": lambda a, b: a + b}, msgs, 5)
assert result is not None, "Replace the `...` in `run_agent` with code that runs the loop."
assert result == "The sum is 5.", f"The final answer should be returned, but you returned {result!r}."
tool_msgs = [m for m in msgs if m["role"] == "tool"]
assert tool_msgs and tool_msgs[0]["content"] == "5" and tool_msgs[0]["tool_call_id"] == "c1", "The tool result must be recorded with the call id."
assert run_agent(make_model([{"content": "", "tool_calls": [{"id": "z", "name": "add", "arguments": {"a": 1, "b": 1}}]}] * 3), {"add": lambda a, b: a + b}, [], 2) is None, "Running out of steps returns None."
--- hint
Use a `for` loop over `range(max_steps)` and return early when there are no tool calls.
--- hint
Call each tool with `**call["arguments"]` and record `str(result)`.
```

## Challenge: tool results

```python exercise id=tool-results title="Collect the tool results"
# TODO: `tool_results(messages)` returns the content of every message whose role is "tool", in order.
def tool_results(messages):
    ...
--- solution
def tool_results(messages):
    return [m["content"] for m in messages if m["role"] == "tool"]
--- test
msgs = [{"role": "user", "content": "hi"}, {"role": "tool", "content": "5"}, {"role": "tool", "content": "7"}]
result = tool_results(msgs)
assert result is not None, "Replace the `...` in `tool_results` with code that returns the contents."
assert result == ["5", "7"], f"Two tool messages hold 5 and 7, but you returned {result}."
assert tool_results([{"role": "user", "content": "hi"}]) == [], "No tool messages give an empty list."
--- hint
Filter on the role, then take the content.
--- hint
`[m["content"] for m in messages if m["role"] == "tool"]`.
```

## Debug: the wrong call id

Each tool result should carry the id of the call it answers, but this version records the tool name instead.

```python debug id=tool-call-id title="Attach each result to its call"
calls = [{"id": "c1", "name": "add", "arguments": {"a": 2, "b": 3}}]
tools = {"add": lambda a, b: a + b}
messages = []
for call in calls:
    result = tools[call["name"]](**call["arguments"])
    messages.append({"role": "tool", "tool_call_id": call["name"], "content": str(result)})  # bug: the id is the name
print(messages)
--- solution
calls = [{"id": "c1", "name": "add", "arguments": {"a": 2, "b": 3}}]
tools = {"add": lambda a, b: a + b}
messages = []
for call in calls:
    result = tools[call["name"]](**call["arguments"])
    messages.append({"role": "tool", "tool_call_id": call["id"], "content": str(result)})
print(messages)
--- test
assert messages[0]["tool_call_id"] == "c1", f"The result must answer call c1, but it is attached to {messages[0]['tool_call_id']!r}. Use the call's id."
assert messages[0]["content"] == "5", "The sum is 5."
--- hint
Each call has an `id` field, separate from its `name`.
--- hint
Use `call["id"]`.
```

## Predict the loop count

```python predict id=predict-steps title="How many model calls does the scripted run need when the first reply asks for a tool and the second answers?"
replies = [{"tool_calls": [{"id": "c1"}]}, {"tool_calls": []}]
print(len(replies))
--- options
* 2
1
3
0
--- explain
One call asks for the tool and a second call gives the answer, so the loop calls the model twice.
```

## Recap

- The loop calls the model, runs the requested tools, records each result under its call id, and repeats.
- A step budget turns an endless loop into a handled failure.
- Convert tool results to plain strings before storing them.

**Up next:** tool calling in detail, starting with the arguments a model supplies.
