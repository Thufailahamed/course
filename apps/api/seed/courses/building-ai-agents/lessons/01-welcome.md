An agent is a loop around a language model. The model reads the conversation so far and either answers or asks for a tool. The program runs the tool, adds the result to the conversation, and the loop repeats. The model supplies the choices. Everything else, the tools, the checks, the permissions and the budgets, is ordinary software that you can test.

This course drives every agent with a scripted model. A scripted model returns a fixed sequence of replies, so each behaviour is deterministic and can be checked in the page. The real hosted-model calls and protocol clients are shown as static code, and the reliability layers around them run here.

> **How to use this lesson:** run the grey boxes and read the trace each one prints. Challenges test your code, so a failing test tells you what to change.

## A scripted reply

A scripted reply has the same shape as a model reply: some content and an optional list of tool calls.

```python run
reply = {"content": "", "tool_calls": [{"id": "c1", "name": "add", "arguments": {"a": 2, "b": 3}}]}
print("the model asks for a tool:", reply["tool_calls"][0]["name"])
```

## Predict the stop

```python predict id=predict-stop title="When does the loop stop?"
reply = {"content": "The sum is 5.", "tool_calls": []}
print("stop" if not reply["tool_calls"] else "continue")
--- options
* stop
continue
error
retry
--- explain
A reply with no tool calls is a final answer, so the loop ends.
```

## Recap

- An agent is a loop: model, tool call, tool result, and then the model again.
- A reply without tool calls ends the loop with a final answer.
- Every part except the model is ordinary code, so it can be tested.

**Up next:** the loop itself, with a step budget so it cannot run forever.
