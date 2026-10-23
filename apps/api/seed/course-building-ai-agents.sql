DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_building_ai_agents');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_building_ai_agents');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_building_ai_agents');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_building_ai_agents');

DELETE FROM discussions WHERE course_id = 'crs_building_ai_agents';

DELETE FROM certificates WHERE course_id = 'crs_building_ai_agents';

DELETE FROM enrollments WHERE course_id = 'crs_building_ai_agents';

DELETE FROM reviews WHERE course_id = 'crs_building_ai_agents';

DELETE FROM wishlist WHERE course_id = 'crs_building_ai_agents';

DELETE FROM path_courses WHERE course_id = 'crs_building_ai_agents';

DELETE FROM coupons WHERE course_id = 'crs_building_ai_agents';

DELETE FROM lessons WHERE course_id = 'crs_building_ai_agents';

DELETE FROM sections WHERE course_id = 'crs_building_ai_agents';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_building_ai_agents';

DELETE FROM courses WHERE id = 'crs_building_ai_agents';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_ai-agents', 'ai-agents', 'AI Agents', 'Tool use, planning, memory and multi-agent systems.', 'bot', 3);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_building_ai_agents', 'building-ai-agents', 'Building Reliable AI Agents', 'Agent loops, tool design, permissions, planning, memory, multi-agent systems and trajectory evaluation, built on a scripted model so every step can be tested.', 'An agent is a loop: a model reads the conversation, chooses a tool or a final answer, the program runs the tool, and the result goes back into the conversation. Most of what makes an agent reliable happens around that loop. The tools must validate their inputs, the permissions must stop the dangerous calls, the plan must recover from failure, the memory must fit the budget, and the evaluation must judge the whole trajectory, not only the final sentence.

## Learn by building

- **A scripted model.** Each lesson drives the agent with a fixed sequence of replies, so every behaviour is deterministic and can be tested in the page. No API key is needed.
- **Every guard in code.** Argument validation, error results, permission tiers, sandbox paths, retries, trimming and trajectory scores all run here.
- **Debug challenges.** You fix the bugs that break agents in production: a tool result attached to the wrong call, a path check that accepts a sibling directory, a retry loop with the wrong count, and a tie that is broken in an unpredictable order.
- **Real APIs shown honestly.** Calls to hosted models and the Model Context Protocol are static code for you to run with your own setup.

## What you''ll cover

- **Agent fundamentals:** the loop, and tool calling.
- **Tools and environments:** interface design, permissions and sandboxing.
- **Planning and memory:** retries, recall and context management.
- **Multi-agent systems:** routing, and the cost of coordination.
- **Shipping agents:** trajectory evaluation, cost, observability and a capstone.

## Why this course?

Agents fail in ways that a single model call does not. They loop, they call the wrong tool with the wrong arguments, they run a dangerous action without asking, and they forget what they learned. This course gives you the mechanisms that prevent each of those failures, and the measurements that show whether they work.', 'cat_ai-agents', 'usr_lena', 'intermediate', 'English', 0, NULL, 'USD', NULL, NULL, 165, 'published', 1, '["Write an agent loop with tool calls, a step budget and clear termination","Design tool interfaces that validate arguments and return errors the model can act on","Put permissions and a filesystem sandbox around every tool","Plan, retry and manage memory and context within a token budget","Decide when a multi-agent design is worth its cost","Evaluate agents on trajectories and track cost, safety and observability"]', '["Python and basic familiarity with calling LLM APIs. The course uses a scripted model, so no API key is needed"]', '["AI engineers who need agents that behave predictably","Backend developers adding automation to existing systems","Product teams deciding whether an agent is the right design"]', '["Agents","Tool Use","MCP","Evaluation"]', 215, 16, 0, 0, 17920, '2026-06-13T07:24:31.120Z', '2026-05-14T07:24:31.120Z', '2026-10-08T07:24:31.120Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_building_ai_agents_1', 'crs_building_ai_agents', 'Agent Fundamentals', 0, '2026-06-25T07:24:31.120Z'),
('sec_building_ai_agents_2', 'crs_building_ai_agents', 'Tools and Environments', 1, '2026-06-25T07:24:31.120Z'),
('sec_building_ai_agents_3', 'crs_building_ai_agents', 'Planning and Memory', 2, '2026-06-25T07:24:31.120Z'),
('sec_building_ai_agents_4', 'crs_building_ai_agents', 'Multi-agent Systems', 3, '2026-06-25T07:24:31.120Z'),
('sec_building_ai_agents_5', 'crs_building_ai_agents', 'Shipping Agents', 4, '2026-06-25T07:24:31.120Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_building_ai_agents_1_1', 'sec_building_ai_agents_1', 'crs_building_ai_agents', 'How this course works', 'interactive', 0, 360, NULL, NULL, 'An agent is a loop around a language model. The model reads the conversation so far and either answers or asks for a tool. The program runs the tool, adds the result to the conversation, and the loop repeats. The model supplies the choices. Everything else, the tools, the checks, the permissions and the budgets, is ordinary software that you can test.

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
', 1, '[]', '[{"title":"ReAct: Synergizing Reasoning and Acting in Language Models","url":"https://arxiv.org/abs/2210.03629"},{"title":"Toolformer: Language Models Can Teach Themselves to Use Tools","url":"https://arxiv.org/abs/2302.04761"},{"title":"Building effective agents (Anthropic)","url":"https://www.anthropic.com/research/building-effective-agents"},{"title":"Model Context Protocol","url":"https://modelcontextprotocol.io"}]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_1_2', 'sec_building_ai_agents_1', 'crs_building_ai_agents', 'The agent loop: model, tools, results', 'interactive', 1, 960, NULL, NULL, 'The loop has three parts. It calls the model with the messages so far, it runs any tools the model requested, and it appends the results. It stops when the model answers without a tool call, or when it reaches a step budget. The budget matters, because an agent that never stops costs money and never delivers an answer.

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

The loop below runs the tool and records the result under the call''s id, which is how the model connects a result to its request.

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
assert messages[0]["tool_call_id"] == "c1", f"The result must answer call c1, but it is attached to {messages[0][''tool_call_id'']!r}. Use the call''s id."
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
', 0, '[]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_1_3', 'sec_building_ai_agents_1', 'crs_building_ai_agents', 'Tool calling and argument validation', 'interactive', 2, 960, NULL, NULL, 'A model calls a tool by naming it and supplying arguments as data. The program must check that data before running anything. Arguments can be missing, mistyped or extra, and each of those should produce a clear error the model can read and correct, not a crash in the middle of a side effect.

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

```python predict id=predict-missing title="How many schema keys are missing from {''a'': 1}?"
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

- A schema lists the names and types of a tool''s arguments, and the validator checks them.
- Report missing, wrong and unknown arguments, so the model can correct the call.
- Dispatch only after the checks pass, and refuse unknown tool names before indexing.

**Up next:** designing tool interfaces, including the error results that let an agent recover.
', 0, '[]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_2_1', 'sec_building_ai_agents_2', 'crs_building_ai_agents', 'Designing tool interfaces that recover from errors', 'interactive', 0, 960, NULL, NULL, 'A tool is an interface that a model uses without seeing its code, so its name, description, arguments and results matter as much as its behaviour. The most useful property a tool can have is a clear failure. When a tool raises an exception, the loop crashes. When it returns an error the model can read, the agent can recover, by trying different arguments or by asking the user.

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

The tool expects keyword arguments from the model''s call, but this version passes the dictionary as one positional argument.

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
', 0, '[]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_2_2', 'sec_building_ai_agents_2', 'crs_building_ai_agents', 'Permissions, sandboxes and the Model Context Protocol', 'interactive', 1, 1080, NULL, NULL, 'Permissions decide which tools the agent may use, and sandboxes decide where a file tool may reach. A read-only search is harmless to run automatically. A tool that sends an email should ask first, and a tool that deletes data should not run from an agent at all. A sandbox keeps file access inside a directory, even when the model asks for a path that climbs out of it.

## Risk tiers

Each tool belongs to a tier. Reads run automatically, writes need confirmation, and dangerous actions are denied. A tool with no tier is denied by default.

```python run
TIER_DECISION = {"read": "allow", "write": "confirm", "dangerous": "deny"}
policy = {"search": "read", "email": "write", "delete": "dangerous"}

def decide(tool, policy):
    tier = policy.get(tool)
    return TIER_DECISION.get(tier, "deny")

for tool in ["search", "email", "delete", "unknown_tool"]:
    print(tool, "->", decide(tool, policy))
```

## Normalizing paths

A path such as "/data/../etc/passwd" leaves the directory it starts in. Normalizing the path first shows where it really points.

```python run
import posixpath
print(posixpath.normpath("/data/reports/../summary.txt"))
print(posixpath.normpath("/data/../etc/passwd"))
```

## Inside the sandbox

A path is inside a root when it equals the root or sits below it with a slash. A simple prefix check is not enough, because "/database" starts with "/data".

```python run
def is_inside(path, root):
    norm = posixpath.normpath(path)
    return norm == root or norm.startswith(root.rstrip("/") + "/")

print(is_inside("/data/a.txt", "/data"), is_inside("/database/x", "/data"), is_inside("/data/../etc/passwd", "/data"))
```

## The Model Context Protocol

The Model Context Protocol is a standard way for an agent to discover and call tools served by another process. A server publishes its tools with schemas and permissions, and the agent connects to it. The client shown below is static code, because it needs a running server.

```python
# Static example: a Model Context Protocol client with the official Python SDK.
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

server = StdioServerParameters(command="python", args=["orders_server.py"])

async def list_tools():
    async with stdio_client(server) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            tools = await session.list_tools()
            return [t.name for t in tools.tools]
```

## Traversal in a path

Normalization collapses the parent steps, so a path that appears to stay in a folder may not.

```python run
print(posixpath.normpath("/data/a/../../secret"))
```

> **Pitfall:** a permission check on the tool name is not enough when the arguments change what the tool does. Check the arguments too, such as the recipient of an email or the path of a file.

> **In the wild:** agent platforms ask the user before every write, run reads automatically, and log each decision. The sandbox is the last line of defence, not the first.

## Challenge: permission decision

```python exercise id=decide title="Decide whether a tool may run"
# TODO: `decide(tool, policy)` takes a dictionary from tool name to tier ("read", "write" or "dangerous"). It returns "allow"
# for read, "confirm" for write and "deny" for dangerous. A tool with no tier, or with an unknown tier, is denied.
def decide(tool, policy):
    ...
--- solution
def decide(tool, policy):
    decision = {"read": "allow", "write": "confirm", "dangerous": "deny"}
    return decision.get(policy.get(tool), "deny")
--- test
policy = {"search": "read", "email": "write", "delete": "dangerous"}
assert decide("search", policy) == "allow", "Read tools run automatically."
assert decide("email", policy) == "confirm", "Write tools ask first."
assert decide("delete", policy) == "deny", "Dangerous tools are denied."
assert decide("unknown", policy) == "deny", "A tool with no tier is denied by default."
--- hint
Look up the tier, then look up the decision for that tier, with a default of deny.
--- hint
`decision.get(policy.get(tool), "deny")`.
```

## Challenge: inside a root

```python exercise id=is-inside title="Is a path inside the sandbox?"
import posixpath

# TODO: `is_inside(path, root)` returns True when the normalized path equals root or lies below root with a slash, and False
# otherwise. Use posixpath.normpath on the path first.
def is_inside(path, root):
    ...
--- solution
import posixpath

def is_inside(path, root):
    norm = posixpath.normpath(path)
    return norm == root or norm.startswith(root.rstrip("/") + "/")
--- test
assert is_inside("/data/a.txt", "/data") is True, "A file below the root is inside."
assert is_inside("/data/../etc/passwd", "/data") is False, "A path that climbs out of the root is outside."
assert is_inside("/database/x", "/data") is False, "A sibling directory with the same prefix is outside."
--- hint
Normalize first, then compare against the root followed by a slash.
--- hint
`norm.startswith(root.rstrip("/") + "/")`.
```

## Debug: a prefix that is not a directory

The sandbox check should only accept paths inside the root directory, but a plain prefix test also accepts a sibling directory.

```python debug id=prefix-sibling title="Check the directory boundary"
import posixpath
path, root = "/database/x", "/data"
norm = posixpath.normpath(path)
inside = norm.startswith(root)                  # bug: a plain prefix also matches /database
print("inside:", inside)
--- solution
import posixpath
path, root = "/database/x", "/data"
norm = posixpath.normpath(path)
inside = norm == root or norm.startswith(root.rstrip("/") + "/")
print("inside:", inside)
--- test
assert inside is False, "/database is a sibling of /data, not a child, so the path is outside. Require the slash after the root."
--- hint
A directory boundary is a slash, not just a common prefix.
--- hint
Add `+ "/"` to the root before the prefix test.
```

## Predict the decision

```python predict id=predict-decide title="What does decide return for a write tool?"
print({"read": "allow", "write": "confirm", "dangerous": "deny"}["write"])
--- options
* confirm
allow
deny
error
--- explain
Write tools are not allowed silently, so they ask the user to confirm first.
```

## Recap

- Assign each tool to a tier, and deny anything without one.
- Normalize paths, and check the directory boundary, not a string prefix.
- Check the arguments as well as the tool name, because arguments change the effect.

**Up next:** planning, and how an agent recovers when a step fails.
', 0, '[]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_2_3', 'sec_building_ai_agents_2', 'crs_building_ai_agents', 'Checkpoint: tools', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why should a tool return an error result instead of raising an exception?","options":["So the loop can show the error to the model and let it recover","Because exceptions are faster","Because the model cannot read strings","So the tool never runs"],"answerIndex":0,"explanation":"A readable error lets the agent correct its arguments or choose another action, instead of stopping."},{"id":"q2","prompt":"What should happen when the model names a tool that does not exist?","options":["The dispatcher returns an error without indexing the tools table","The program crashes","The tool is created automatically","The loop runs the closest tool"],"answerIndex":0,"explanation":"Checking the name first turns a typo into a readable error."},{"id":"q3","prompt":"Which tier should a tool that sends an email to an external address use?","options":["Write, so the user confirms before it runs","Read, so it runs automatically","Dangerous, so it is never available","No tier, because email is harmless"],"answerIndex":0,"explanation":"Sending a message changes the outside world, so the user should confirm it."},{"id":"q4","prompt":"Why is a plain prefix check unsafe for a sandbox?","options":["/database starts with /data, so a sibling directory would pass","Prefix checks are too slow","Paths cannot be strings","Prefix checks never match"],"answerIndex":0,"explanation":"The directory boundary must be checked, so sibling directories with the same prefix are excluded."}]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_3_1', 'sec_building_ai_agents_3', 'crs_building_ai_agents', 'Planning with retries', 'interactive', 0, 960, NULL, NULL, 'A plan breaks a task into steps, and an executor runs them in order. Real steps fail: a fetch times out, a parse finds an unexpected format. A reliable agent retries a failed step a bounded number of times, then stops and reports, rather than retrying forever or silently skipping the failure. The retry budget is the number that controls both cost and recovery.

## A plan as data

A plan is a list of steps with a status. Keeping the status in data makes it easy to resume and to inspect.

```python run
plan = [{"step": "fetch orders", "done": False}, {"step": "summarize", "done": False}]

def next_step(plan):
    for s in plan:
        if not s["done"]:
            return s["step"]
    return None

print("next:", next_step(plan))
plan[0]["done"] = True
print("next:", next_step(plan))
```

## Retrying one step

A scripted outcome table makes the first attempt at one step fail. The loop retries until the step succeeds or the budget runs out.

```python run
outcomes = {("parse", 1): False}

def run_once(step, attempt):
    return outcomes.get((step, attempt), True)

for step in ["fetch", "parse"]:
    attempt = 1
    while not run_once(step, attempt) and attempt < 3:
        attempt += 1
    print(step, "succeeded on attempt", attempt)
```

## The retry budget sets the attempts

With a budget of r retries, each step gets r + 1 attempts in total.

```python run
for retries in [0, 1, 3]:
    print(f"{retries} retries -> {retries + 1} attempts per step")
```

## The worst-case cost

Every attempt is a model call, so the worst case is the plan''s steps times the attempts times the tokens per call.

```python run
per_step_tokens = 800
retries = 1
print("worst-case tokens for 3 steps:", 3 * per_step_tokens * (retries + 1))
```

> **Pitfall:** retrying a write step can repeat its side effect, such as charging a card twice. Retry only steps that are safe to repeat, or make the write idempotent with a key.

> **In the wild:** agent runs record each attempt, and the on-call engineer can see exactly which step failed and how many times it was retried.

## Challenge: execute a plan

```python exercise id=execute-plan title="Run a plan with bounded retries"
# TODO: `execute_plan(steps, run_step, max_retries)` runs each step in order. run_step(step, attempt) returns (ok, output),
# with attempts numbered from 1. A step gets max_retries + 1 attempts. Append the output when a step succeeds and go on to
# the next step. If a step fails every attempt, stop and return the outputs so far.
def execute_plan(steps, run_step, max_retries):
    ...
--- solution
def execute_plan(steps, run_step, max_retries):
    results = []
    for step in steps:
        for attempt in range(1, max_retries + 2):
            ok, output = run_step(step, attempt)
            if ok:
                results.append(output)
                break
        else:
            return results
    return results
--- test
attempts = []
def run_step(step, attempt):
    attempts.append((step, attempt))
    if step == "parse" and attempt == 1:
        return False, None
    return True, f"{step} done"

out = execute_plan(["fetch", "parse", "report"], run_step, max_retries=1)
assert out is not None, "Replace the `...` in `execute_plan` with code that runs the plan."
assert out == ["fetch done", "parse done", "report done"], f"The parse step succeeds on its retry, so all three outputs appear, but you returned {out}."
assert attempts == [("fetch", 1), ("parse", 1), ("parse", 2), ("report", 1)], f"The attempts should be fetch 1, parse 1 and 2, then report 1, but they were {attempts}."
stuck = []
def always_fail(step, attempt):
    stuck.append(attempt)
    return False, None
assert execute_plan(["a", "b"], always_fail, max_retries=2) == [], "A step that never succeeds stops the plan with no outputs."
assert stuck == [1, 2, 3], "The first step gets max_retries + 1 attempts, numbered from 1."
--- hint
Loop over the attempts with `range(1, max_retries + 2)`, and use the `else` of the inner loop to stop when every attempt has failed.
--- hint
`for attempt in range(1, max_retries + 2):` followed by `break` on success.
```

## Challenge: the next step

```python exercise id=next-step title="The next unfinished step"
# TODO: `next_step(plan)` returns the name of the first step whose done flag is False, or None when every step is done.
def next_step(plan):
    ...
--- solution
def next_step(plan):
    for s in plan:
        if not s["done"]:
            return s["step"]
    return None
--- test
result = next_step([{"step": "a", "done": True}, {"step": "b", "done": False}])
assert result is not None, "Replace the `...` in `next_step` with code that returns the step."
assert result == "b", f"Step a is done, so the next step is b, but you returned {result!r}."
assert next_step([{"step": "a", "done": True}]) is None, "When every step is done there is no next step."
--- hint
Loop over the plan and return the first step that is not done.
--- hint
Return None after the loop.
```

## Debug: one retry too few

With one retry allowed, each step should get two attempts, but the loop only makes one.

```python debug id=retry-count title="Give the retry budget its attempts"
max_retries = 1
attempts = 0
for _ in range(max_retries):      # bug: this makes one attempt, not max_retries + 1
    attempts += 1
print("attempts allowed:", attempts)
--- solution
max_retries = 1
attempts = 0
for _ in range(max_retries + 1):
    attempts += 1
print("attempts allowed:", attempts)
--- test
assert attempts == 2, f"One retry means two attempts in total, but the code allows {attempts}. The number of attempts is max_retries + 1."
--- hint
The first attempt is not a retry, so it must be counted too.
--- hint
Use `range(max_retries + 1)`.
```

## Predict the attempts

```python predict id=predict-attempts title="How many attempts are recorded when the first fails and the second succeeds?"
attempts = [False, True]
print(len(attempts))
--- options
* 2
1
0
3
--- explain
Two attempts were made, the first failing and the retry succeeding.
```

## Recap

- A plan is data: steps with a status, which the executor updates.
- A retry budget bounds the attempts, so recovery has a clear cost.
- Retry only steps that are safe to repeat, and log every attempt.

**Up next:** memory, the part of the agent that holds what it has learned.
', 0, '[]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_3_2', 'sec_building_ai_agents_3', 'crs_building_ai_agents', 'Short-term and long-term memory', 'interactive', 1, 900, NULL, NULL, 'An agent needs two kinds of memory. Short-term memory is the recent conversation, which is kept in the context window and trimmed as it grows. Long-term memory is a store of facts that outlives the conversation, such as a user''s preferences, and it is searched for the facts relevant to the current request rather than being replayed in full.

## Short-term memory as a window

A window keeps the most recent messages. Older messages drop out of the context as new ones arrive.

```python run
messages = [f"msg{i}" for i in range(1, 7)]
print("window of the last four:", messages[-4:])
```

## Long-term facts

Stored facts are searched for the words they share with the query. The best match is the one with the most shared words.

```python run
facts = ["user likes tea", "user lives in Oslo", "order 12 shipped"]
query_words = set("where lives the user".split())
scores = [len(query_words & set(f.split())) for f in facts]
print("scores:", scores)
best = max(range(len(facts)), key=lambda i: scores[i])
print("best fact:", facts[best])
```

## Bounded storage

A long-term store needs a limit, so the oldest facts are evicted once it is full.

```python run
store = []
for i in range(150):
    store.append(i)
    store = store[-100:]
print("items kept:", len(store))
```

## Summaries

A summary condenses a set of facts into a shorter form that is cheaper to keep in context.

```python run
summary = " | ".join(f.split()[0] for f in facts)
print("summary:", summary)
```

> **Pitfall:** a memory that only grows will eventually fill the context and push out the instructions. Bound it by count or by tokens, and decide what to evict.

> **In the wild:** production agents store user preferences and past outcomes in a database, and retrieve only the entries relevant to the current task.

## Challenge: last n messages

```python exercise id=last-n title="The last n messages"
# TODO: `last_n(messages, n)` returns the last n items of the list in their original order. If n is zero, return an empty list.
def last_n(messages, n):
    ...
--- solution
def last_n(messages, n):
    return messages[-n:] if n > 0 else []
--- test
result = last_n([1, 2, 3, 4], 2)
assert result is not None, "Replace the `...` in `last_n` with code that returns the window."
assert result == [3, 4], f"The last two of [1, 2, 3, 4] are [3, 4], but you returned {result}."
assert last_n([1, 2], 5) == [1, 2], "Asking for more than the list holds returns the whole list."
assert last_n([1, 2], 0) == [], "Zero messages gives an empty window."
--- hint
Slicing from the negative index gives the tail, but n = 0 needs a special case.
--- hint
`messages[-n:] if n > 0 else []`.
```

## Challenge: recall facts

```python exercise id=recall title="Recall the most relevant facts"
# TODO: `recall(facts, query, k)` returns the k facts that share the most words with the query, most shared first. Ties keep
# the original order. Compare words in lowercase, split on spaces.
def recall(facts, query, k):
    ...
--- solution
def recall(facts, query, k):
    query_words = set(query.lower().split())
    scores = [len(query_words & set(f.lower().split())) for f in facts]
    order = sorted(range(len(facts)), key=lambda i: -scores[i])
    return [facts[i] for i in order[:k]]
--- test
facts = ["user likes tea", "user lives in Oslo", "order 12 shipped"]
result = recall(facts, "where lives the user", 1)
assert result is not None, "Replace the `...` in `recall` with code that returns the facts."
assert result == ["user lives in Oslo"], f"The fact with the most shared words is ''user lives in Oslo'', but you returned {result}."
assert recall(facts, "tea", 2)[0] == "user likes tea", "A fact sharing a word with the query comes first."
--- hint
Score each fact by the size of the intersection, then sort the indices by the negative score.
--- hint
`sorted(range(len(facts)), key=lambda i: -scores[i])` keeps ties in their original order.
```

## Debug: an off-by-one window

The window should hold exactly the last four messages, but the slice starts one position too early.

```python debug id=window-size title="Keep exactly the last n messages"
messages = [1, 2, 3, 4, 5, 6]
n = 4
window = messages[-n - 1:]              # bug: the slice starts one position too early
print("window:", window)
--- solution
messages = [1, 2, 3, 4, 5, 6]
n = 4
window = messages[-n:]
print("window:", window)
--- test
assert len(window) == 4 and window == [3, 4, 5, 6], f"The window should hold the last four messages, but it holds {window}."
--- hint
A negative slice index of -n already starts at the n-th item from the end.
--- hint
Remove the `- 1`.
```

## Predict the store size

```python predict id=predict-store title="How many items does a store of size 100 keep after 150 inserts?"
store = list(range(150))[-100:]
print(len(store))
--- options
* 100
150
50
0
--- explain
The store keeps only the most recent 100 items once it is full.
```

## Recap

- Short-term memory is the recent window, and it needs trimming.
- Long-term memory is searched for the facts relevant to the query.
- Bound every store, and decide what to evict.

**Up next:** context management, which fits memory into a token budget.
', 0, '[]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_3_3', 'sec_building_ai_agents_3', 'crs_building_ai_agents', 'Managing context within a token budget', 'interactive', 2, 840, NULL, NULL, 'Every model call sends the whole context, and the cost and the limit both depend on its length. A long task fills the window with old tool results. Context management decides what to keep. The system message is never dropped, the most recent turns are kept, and older material is trimmed to fit the budget.

## Measuring the context

A simple token count, by words, is enough to plan a budget before a call.

```python run
messages = [("system", "a b"), ("user", "c d e"), ("assistant", "f g"), ("user", "h")]
used = sum(len(text.split()) for _, text in messages)
print("tokens in the context:", used)
```

## Keeping the system message

Trimming must never remove the rules. The system message is pulled out first and always kept.

```python run
system = [m for m in messages if m[0] == "system"]
rest = [m for m in messages if m[0] != "system"]
print("kept as rules:", system)
print("eligible to trim:", [t for _, t in rest])
```

## Trimming from the end

Walking backwards from the newest message keeps the recent turns, which carry the current task.

```python run
budget = 6
used = sum(len(text.split()) for _, text in system)
kept = []
for role, text in reversed(rest):
    if used + len(text.split()) > budget:
        break
    used += len(text.split())
    kept.append((role, text))
kept.reverse()
print("kept messages:", kept, "| tokens used:", used)
```

## Summaries replace dropped turns

When a dropped section holds facts the agent still needs, a short summary takes its place in the context.

```python run
dropped = ["user asked about refunds", "agent checked the policy"]
summary = ("summary: " + "; ".join(dropped))
print(summary)
```

> **Pitfall:** trimming the middle of a conversation can remove the tool call while keeping its result, which confuses the model. Keep each call and its result together, or drop both.

> **In the wild:** agent frameworks summarize old turns, cache stable prefixes and reserve part of the window for the answer, so a long task does not run out of room.

## Challenge: trim to budget

```python exercise id=trim-budget title="Trim a conversation to a budget"
# TODO: `trim_to_budget(messages, budget)` takes (role, text) pairs. Keep every "system" message. Then, walking backwards from
# the newest non-system message, keep messages while the total word count stays within budget (system words count too).
# Stop at the first message that does not fit. Return the kept messages in their original order, system first.
def trim_to_budget(messages, budget):
    ...
--- solution
def trim_to_budget(messages, budget):
    system = [m for m in messages if m[0] == "system"]
    rest = [m for m in messages if m[0] != "system"]
    used = sum(len(text.split()) for _, text in system)
    kept = []
    for role, text in reversed(rest):
        if used + len(text.split()) > budget:
            break
        used += len(text.split())
        kept.append((role, text))
    kept.reverse()
    return system + kept
--- test
msgs = [("system", "a b"), ("user", "c d e"), ("assistant", "f g"), ("user", "h")]
result = trim_to_budget(msgs, 6)
assert result is not None, "Replace the `...` in `trim_to_budget` with code that returns the trimmed list."
assert result == [("system", "a b"), ("assistant", "f g"), ("user", "h")], f"With budget 6 the system message (2 words) and the last two turns (3 words) fit, but you returned {result}."
assert trim_to_budget(msgs, 1) == [("system", "a b")], "When nothing else fits, only the system message remains."
--- hint
Compute the system message''s words first, then walk the other messages from the end.
--- hint
Reverse the kept list at the end so the original order is restored.
```

## Challenge: count the tokens

```python exercise id=count-tokens title="Count the words in a conversation"
# TODO: `count_tokens(messages)` takes (role, text) pairs and returns the total number of whitespace-separated words in all texts.
def count_tokens(messages):
    ...
--- solution
def count_tokens(messages):
    return sum(len(text.split()) for _, text in messages)
--- test
result = count_tokens([("system", "a b"), ("user", "c")])
assert result is not None, "Replace the `...` in `count_tokens` with code that returns the count."
assert result == 3, f"The texts hold 2 and 1 words, so the total is 3, but you returned {result}."
assert count_tokens([]) == 0, "An empty conversation has no tokens."
--- hint
Sum the word counts of the texts, ignoring the roles.
--- hint
`sum(len(text.split()) for _, text in messages)`.
```

## Debug: keeping the oldest messages

The budget should keep the most recent messages, but this loop keeps the oldest ones that fit.

```python debug id=oldest-first title="Keep the newest messages within the budget"
rest = [("user", "c d e"), ("assistant", "f g"), ("user", "h")]
budget = 3
kept, used = [], 0
for role, text in rest:                  # bug: walks from the oldest message
    if used + len(text.split()) <= budget:
        kept.append(text)
        used += len(text.split())
print(kept)
--- solution
rest = [("user", "c d e"), ("assistant", "f g"), ("user", "h")]
budget = 3
kept, used = [], 0
for role, text in reversed(rest):
    if used + len(text.split()) <= budget:
        kept.append(text)
        used += len(text.split())
kept.reverse()
print(kept)
--- test
assert kept == ["f g", "h"], f"The most recent messages fit the budget, so the kept messages should be [''f g'', ''h''], but the code keeps {kept}. Walk from the newest message."
--- hint
The newest messages are at the end of the list.
--- hint
Iterate with `reversed(rest)` and reverse `kept` at the end.
```

## Predict the word count

```python predict id=predict-words title="How many tokens does ''one two three'' count as, by words?"
print(len("one two three".split()))
--- options
* 3
2
1
5
--- explain
There are three whitespace-separated words, so the count is three.
```

## Recap

- Measure the context before each call, and set a budget with room for the answer.
- Always keep the system message, then keep the most recent turns that fit.
- Keep tool calls and their results together, and summarize what must survive.

**Up next:** multi-agent systems, starting with the orchestrator and its workers.
', 0, '[]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_3_4', 'sec_building_ai_agents_3', 'crs_building_ai_agents', 'Checkpoint: planning and memory', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What is the purpose of a retry budget in a plan?","options":["It limits how many times a failing step is attempted before the plan stops","It sets the speed of the model","It removes failing steps from memory","It doubles the cost of every step"],"answerIndex":0,"explanation":"A bounded retry budget recovers from transient failures without looping forever."},{"id":"q2","prompt":"What does short-term memory usually hold?","options":["The most recent messages that fit in the context window","Every message ever sent","Only the system prompt","The tools'' source code"],"answerIndex":0,"explanation":"Short-term memory is the recent window of the conversation, trimmed to fit."},{"id":"q3","prompt":"When trimming context to a budget, what should always be kept?","options":["The system message, and the most recent messages that fit","The oldest message only","The longest message only","Nothing, because trimming removes everything"],"answerIndex":0,"explanation":"The rules stay in place, and the most recent turns carry the current task."},{"id":"q4","prompt":"What does long-term memory recall do?","options":["It retrieves stored facts relevant to the current query","It replays every past conversation","It trains the model","It deletes old facts"],"answerIndex":0,"explanation":"Long-term memory is a store that is searched for facts relevant to the request."}]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_4_1', 'sec_building_ai_agents_4', 'crs_building_ai_agents', 'Orchestrator and worker agents', 'interactive', 0, 1080, NULL, NULL, 'An orchestrator-worker design splits a task among specialists. The orchestrator routes each incoming task to the worker best suited to it, and combines the answers. Routing can be done with rules, with keyword matches, or with a model. Whichever is used, the routing decision must be deterministic enough to reproduce, so that a failure can be traced to the route that caused it.

## The worker registry

Each worker declares the keywords it handles. The registry is data, which makes routing easy to change and to test.

```python run
workers = {
    "billing": {"refund", "invoice", "charge"},
    "tech": {"crash", "error", "login"},
}
for name, kws in workers.items():
    print(name, "handles", sorted(kws))
```

## Scoring a task

A task is scored against each worker by how many of its keywords the task contains.

```python run
task = "refund my invoice"
words = set(task.lower().split())
scores = {name: len(words & kws) for name, kws in workers.items()}
print("scores:", scores)
```

## Fanning out a batch

The orchestrator routes every task in a batch and records the decision for each one.

```python run
tasks = ["refund my invoice", "app crash on login", "where is my parcel"]
routes = {}
for t in tasks:
    words = set(t.lower().split())
    scores = {name: len(words & kws) for name, kws in workers.items()}
    best = max(scores.values())
    routes[t] = max(scores, key=scores.get) if best > 0 else "generalist"
print(routes)
```

## Combining the results

After the workers answer, the orchestrator joins their results in a fixed order, so the final answer is stable.

```python run
answers = {"tech": "Clear the cache.", "billing": "A refund takes five days."}
combined = "\n".join(f"{name}: {answers[name]}" for name in sorted(answers))
print(combined)
```

> **Pitfall:** when two workers tie, a route that depends on dictionary order or on timing can change between runs. Break ties by a fixed rule, such as alphabetical order.

> **In the wild:** orchestrators often use a model to classify the task, and fall back to a generalist when no worker is confident. Log every route so misrouted tasks can be reviewed.

## Challenge: route a task

```python exercise id=route title="Route a task to the best worker"
# TODO: `route(task, workers)` takes a task string and a dictionary from worker name to a set of keywords. It scores each worker
# by the number of keywords present in the task (compared in lowercase words). It returns the name of the best-scoring
# worker, breaking ties by the alphabetically first name, or "generalist" if no worker scores above zero.
def route(task, workers):
    ...
--- solution
def route(task, workers):
    words = set(task.lower().split())
    scores = {name: len(words & kws) for name, kws in workers.items()}
    best = max(scores.values(), default=0)
    if best == 0:
        return "generalist"
    return min(name for name, s in scores.items() if s == best)
--- test
workers = {"billing": {"refund", "invoice"}, "tech": {"crash", "error"}}
assert route("refund my invoice", workers) == "billing", "Two billing keywords match."
assert route("app crash error", workers) == "tech", "Two tech keywords match."
assert route("hello there", workers) == "generalist", "No keyword matches goes to the generalist."
assert route("refund crash", workers) == "billing", "A tie goes to the alphabetically first worker."
--- hint
Count the shared words for each worker, then find the best count.
--- hint
Among workers with the best count, choose the smallest name.
```

## Challenge: fan out a batch

The function `route` is provided, and your task is to apply it to a whole batch.

```python exercise id=fan-out title="Route every task in a batch"
def route(task, workers):
    words = set(task.lower().split())
    scores = {name: len(words & kws) for name, kws in workers.items()}
    best = max(scores.values(), default=0)
    if best == 0:
        return "generalist"
    return min(name for name, s in scores.items() if s == best)

# TODO: `fan_out(tasks, workers)` returns a dictionary mapping each task string to route(task, workers).
def fan_out(tasks, workers):
    ...
--- solution
def route(task, workers):
    words = set(task.lower().split())
    scores = {name: len(words & kws) for name, kws in workers.items()}
    best = max(scores.values(), default=0)
    if best == 0:
        return "generalist"
    return min(name for name, s in scores.items() if s == best)

def fan_out(tasks, workers):
    return {t: route(t, workers) for t in tasks}
--- test
workers = {"billing": {"refund", "invoice"}, "tech": {"crash", "error"}}
result = fan_out(["refund my invoice", "app crash", "hello"], workers)
assert result is not None, "Replace the `...` in `fan_out` with code that returns the mapping."
assert result == {"refund my invoice": "billing", "app crash": "tech", "hello": "generalist"}, f"Each task should map to its route, but you returned {result}."
--- hint
A dictionary comprehension over the tasks is enough.
--- hint
`{t: route(t, workers) for t in tasks}`.
```

## Debug: a tie broken by insertion order

Two workers score equally, and the rule says the alphabetically first should win, but `max` returns the one that was inserted first.

```python debug id=tie-break title="Break ties alphabetically"
scores = {"tech": 1, "billing": 1}       # equal scores, with tech inserted first
best = max(scores, key=scores.get)       # bug: max returns the first maximum, not the alphabetical one
print("route to:", best)
--- solution
scores = {"tech": 1, "billing": 1}
best = min(scores, key=lambda w: (-scores[w], w))
print("route to:", best)
--- test
assert best == "billing", f"With equal scores the alphabetically first worker, billing, should win, but the code routes to {best}. Break ties by name."
--- hint
`max` keeps the first maximum it sees, which depends on insertion order.
--- hint
Sort by the negative score and then by the name.
```

## Predict the route

```python predict id=predict-route title="Which worker wins when billing scores 1 and tech scores 2?"
scores = {"billing": 1, "tech": 2}
print(max(scores, key=lambda k: scores[k]))
--- options
* tech
billing
generalist
tie
--- explain
Tech has the higher score, so it is the best match.
```

## Recap

- An orchestrator routes each task to a worker and combines the answers.
- Keep the registry as data, and log every route.
- Break ties by a fixed rule, so routing is reproducible.

**Up next:** when a multi-agent design pays for its extra cost.
', 0, '[]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_4_2', 'sec_building_ai_agents_4', 'crs_building_ai_agents', 'When multi-agent is worth its cost', 'interactive', 1, 600, NULL, NULL, 'Several agents are not better by default. Each agent and the orchestrator make their own model calls with their own context, and every call is billed. Multi-agent designs pay off when the subtasks are independent and large, so that parallel specialists finish sooner and each keeps a focused context. For a short sequential task, a single agent usually does the job for far less.

## Cost of a multi-agent design

The total is the workers'' calls times their tokens, plus the orchestrator''s calls times its tokens.

```python run
def multi_agent_cost(n_workers, calls_per_worker, tokens_per_call, orchestrator_calls, orchestrator_tokens):
    return n_workers * calls_per_worker * tokens_per_call + orchestrator_calls * orchestrator_tokens

print("3 workers, 4 calls each, 1000 tokens, orchestrator 2 calls of 500:",
      multi_agent_cost(3, 4, 1000, 2, 500))
```

## Cost of a single agent

A single agent makes its calls with one growing context, so the comparison is a matter of counting calls and tokens.

```python run
single = 8 * 1000
print("single agent, 8 calls of 1000 tokens:", single)
```

## Comparing the two

The comparison shows the overhead that coordination adds for the same amount of work.

```python run
multi = multi_agent_cost(3, 4, 1000, 2, 500)
print("multi-agent costs", round(multi / single, 2), "times the single agent")
```

## Latency with parallel workers

Parallel workers finish in the time of the slowest one, plus the orchestrator''s steps, which is the case where a multi-agent design wins.

```python run
worker_seconds = [4.0, 5.0, 3.5]
orchestrator_seconds = 1.0
print("parallel latency:", max(worker_seconds) + orchestrator_seconds, "seconds")
print("sequential latency:", sum(worker_seconds) + orchestrator_seconds, "seconds")
```

> **Pitfall:** adding agents to a task that does not split cleanly multiplies cost and adds failure modes, such as workers that disagree. Start with one agent, and split only when a measured limit appears.

> **In the wild:** teams use multi-agent designs for broad research and parallel data gathering, and a single agent for most tool-using tasks.

## Challenge: multi-agent cost

```python exercise id=multi-cost title="Total tokens of a multi-agent run"
# TODO: `multi_agent_cost(n_workers, calls_per_worker, tokens_per_call, orchestrator_calls, orchestrator_tokens)` returns the total
# tokens: n_workers × calls_per_worker × tokens_per_call plus orchestrator_calls × orchestrator_tokens.
def multi_agent_cost(n_workers, calls_per_worker, tokens_per_call, orchestrator_calls, orchestrator_tokens):
    ...
--- solution
def multi_agent_cost(n_workers, calls_per_worker, tokens_per_call, orchestrator_calls, orchestrator_tokens):
    return n_workers * calls_per_worker * tokens_per_call + orchestrator_calls * orchestrator_tokens
--- test
result = multi_agent_cost(3, 4, 1000, 2, 500)
assert result is not None, "Replace the `...` in `multi_agent_cost` with code that returns the total."
assert result == 13000, f"Workers use 3 × 4 × 1000 = 12000 and the orchestrator uses 2 × 500 = 1000, so the total is 13000, but you returned {result}."
assert multi_agent_cost(1, 1, 10, 0, 0) == 10, "One worker call with no orchestrator is just that call."
--- hint
Add the two products.
--- hint
`n_workers * calls_per_worker * tokens_per_call + orchestrator_calls * orchestrator_tokens`.
```

## Challenge: single-agent cost

```python exercise id=single-cost title="Tokens of a single agent"
# TODO: `single_cost(calls, tokens_per_call)` returns the total tokens of a single agent: calls times tokens_per_call.
def single_cost(calls, tokens_per_call):
    ...
--- solution
def single_cost(calls, tokens_per_call):
    return calls * tokens_per_call
--- test
result = single_cost(8, 1000)
assert result is not None, "Replace the `...` in `single_cost` with code that returns the total."
assert result == 8000, f"Eight calls of 1000 tokens is 8000, but you returned {result}."
assert single_cost(0, 500) == 0, "No calls means no tokens."
--- hint
Multiply the number of calls by the tokens per call.
--- hint
`return calls * tokens_per_call`.
```

## Debug: forgetting the orchestrator

The total should include the orchestrator''s calls, but this version counts only the workers.

```python debug id=orchestrator-cost title="Count the orchestrator too"
n_workers, calls_per_worker, tokens_per_call = 3, 4, 1000
orchestrator_calls, orchestrator_tokens = 2, 500
total = n_workers * calls_per_worker * tokens_per_call     # bug: the orchestrator''s calls are missing
print("total tokens:", total)
--- solution
n_workers, calls_per_worker, tokens_per_call = 3, 4, 1000
orchestrator_calls, orchestrator_tokens = 2, 500
total = n_workers * calls_per_worker * tokens_per_call + orchestrator_calls * orchestrator_tokens
print("total tokens:", total)
--- test
assert total == 13000, f"The workers use 12000 tokens and the orchestrator 1000, so the total is 13000, but the code gives {total}. Add the orchestrator''s tokens."
--- hint
Every model call is billed, including the ones the orchestrator makes.
--- hint
Add `orchestrator_calls * orchestrator_tokens`.
```

## Predict the single-agent cost

```python predict id=predict-single title="How many tokens does a single agent use with 8 calls of 1000 tokens?"
print(8 * 1000)
--- options
* 8000
1000
8
80000
--- explain
Eight calls of 1000 tokens each is 8000 tokens.
```

## Recap

- Multi-agent designs add coordination calls, and every call is billed.
- They pay off for independent, large subtasks, where parallel workers cut the latency.
- Start with a single agent, and split only when measurement shows the need.

**Up next:** evaluating whole trajectories, not just final answers.
', 0, '[]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_4_3', 'sec_building_ai_agents_4', 'crs_building_ai_agents', 'Checkpoint: multi-agent', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"In an orchestrator-worker design, what does the orchestrator do?","options":["It routes tasks to workers and combines their results","It answers every task itself with no workers","It stores the model weights","It replaces the tools"],"answerIndex":0,"explanation":"The orchestrator decides which worker handles each task and assembles the outcome."},{"id":"q2","prompt":"When is a single agent usually the better choice?","options":["When the task is sequential and the coordination cost of several agents outweighs their benefit","When every task is completely independent and large","Always, because multi-agent systems are never useful","When the agents need to share a single tool"],"answerIndex":0,"explanation":"Coordination adds tokens and failure modes, which a simple task does not repay."},{"id":"q3","prompt":"How should ties between equally suited workers be broken?","options":["By a fixed, documented rule, such as alphabetical order, so routing is repeatable","Randomly on every request","By the order the workers were started","By always choosing the most expensive worker"],"answerIndex":0,"explanation":"A deterministic tie-break keeps routing reproducible, which makes failures easier to debug."},{"id":"q4","prompt":"Why does a multi-agent design usually cost more tokens?","options":["Each agent and the orchestrator make their own model calls with their own context","The tools become larger","The memory is deleted","The prompts are shorter"],"answerIndex":0,"explanation":"Every agent call is billed, so the total grows with the number of calls and contexts."}]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_5_1', 'sec_building_ai_agents_5', 'crs_building_ai_agents', 'Evaluating agent trajectories', 'interactive', 0, 1080, NULL, NULL, 'An agent''s final answer can be right for the wrong reasons. It may have called a tool it was not allowed to use, taken twelve steps where three would do, or guessed and been lucky. A trajectory evaluation scores the whole sequence of actions: whether the final answer matches, how many steps it took, and whether any forbidden action appeared along the way.

## A trajectory as data

A trajectory is the list of actions the agent took, each with its tool and, for the last one, its answer.

```python run
trajectory = [
    {"tool": "search", "answer": None},
    {"tool": "delete", "answer": None},
    {"tool": "final", "answer": "42"},
]
print("steps:", len(trajectory), "| tools:", [a["tool"] for a in trajectory])
```

## Did the answer match?

The final action carries the answer, so success is checked on the last action only.

```python run
expected = "42"
print("success:", trajectory[-1]["answer"] == expected)
```

## A forbidden action

A policy names the tools a task must never use. The check looks at every action, not only the answer.

```python run
forbidden = {"delete"}
violated = any(a["tool"] in forbidden for a in trajectory)
print("policy violated:", violated)
```

## Scoring many runs

A suite of trajectories is summarized by the rate of success, the average steps and the count of violations.

```python run
runs = [
    [{"tool": "search", "answer": None}, {"tool": "final", "answer": "42"}],
    [{"tool": "search", "answer": None}, {"tool": "final", "answer": "41"}],
]
successes = sum(r[-1]["answer"] == "42" for r in runs)
print("success rate:", successes / len(runs), "| average steps:", sum(len(r) for r in runs) / len(runs))
```

> **Pitfall:** a suite that checks only final answers rewards agents that guess and agents that break policy whenever the answer is right. Score the trajectory as well.

> **In the wild:** agent teams keep a suite of tasks with expected answers and forbidden tools, and fail a release when either the success rate or the violation count gets worse.

## Challenge: score a trajectory

```python exercise id=score-trajectory title="Score one agent run"
# TODO: `score_trajectory(actions, expected, forbidden)` takes a list of action dictionaries with keys "tool" and "answer". It
# returns {"success": bool, "steps": int, "violated": bool}. success is True when the last action''s answer equals expected.
# violated is True when any action''s tool is in the forbidden set.
def score_trajectory(actions, expected, forbidden):
    ...
--- solution
def score_trajectory(actions, expected, forbidden):
    return {
        "success": actions[-1]["answer"] == expected,
        "steps": len(actions),
        "violated": any(a["tool"] in forbidden for a in actions),
    }
--- test
actions = [{"tool": "search", "answer": None}, {"tool": "delete", "answer": None}, {"tool": "final", "answer": "42"}]
result = score_trajectory(actions, "42", {"delete"})
assert result is not None, "Replace the `...` in `score_trajectory` with code that returns the score."
assert result == {"success": True, "steps": 3, "violated": True}, f"The answer matches, there are three steps, and delete was used, but you returned {result}."
clean = score_trajectory([{"tool": "search", "answer": None}, {"tool": "final", "answer": "41"}], "42", {"delete"})
assert clean == {"success": False, "steps": 2, "violated": False}, "A wrong answer with no forbidden tool is not a success and not a violation."
--- hint
Check the last action for the answer, the length for steps, and the tools of all actions against the forbidden set.
--- hint
`any(a["tool"] in forbidden for a in actions)`.
```

## Challenge: success rate

```python exercise id=success-rate title="Share of runs that reached the expected answer"
# TODO: `success_rate(runs)` takes a list of (actions, expected) pairs. A run succeeds when its last action''s answer equals
# expected. Return the share of runs that succeed, as a float.
def success_rate(runs):
    ...
--- solution
def success_rate(runs):
    wins = sum(actions[-1]["answer"] == expected for actions, expected in runs)
    return wins / len(runs)
--- test
result = success_rate([([{"tool": "f", "answer": "x"}], "x"), ([{"tool": "f", "answer": "y"}], "x")])
assert result is not None, "Replace the `...` in `success_rate` with code that returns the rate."
assert abs(result - 0.5) < 1e-9, f"One of the two runs ends with the expected answer, so the rate is 0.5, but you returned {result}."
assert success_rate([([{"tool": "f", "answer": "x"}], "x")]) == 1.0, "A single successful run has rate one."
--- hint
Compare the last action''s answer with the expected answer for each run.
--- hint
Sum the booleans and divide by the number of runs.
```

## Debug: the first action instead of the last

Success should be decided by the final answer, but this version reads the first action, which has no answer.

```python debug id=first-action title="Check the final answer, not the first action"
actions = [{"tool": "search", "answer": None}, {"tool": "final", "answer": "42"}]
expected = "42"
success = actions[0]["answer"] == expected        # bug: the answer is on the last action
print("success:", success)
--- solution
actions = [{"tool": "search", "answer": None}, {"tool": "final", "answer": "42"}]
expected = "42"
success = actions[-1]["answer"] == expected
print("success:", success)
--- test
assert success is True, f"The final answer 42 matches, so the run succeeded, but the code says {success}. Read the answer from the last action."
--- hint
The answer is produced at the end of the run.
--- hint
Use `actions[-1]`.
```

## Predict the success rate

```python predict id=predict-rate title="What is the success rate when three of four runs succeed?"
print(3 / 4)
--- options
* 0.75
0.5
0.25
3.0
--- explain
Three of four runs succeeded, so the rate is 3 divided by 4.
```

## Recap

- Score the whole trajectory: the answer, the steps and any forbidden action.
- Summarize a suite with success rate, average steps and violations.
- Fail a release on a worse result in any of those numbers.

**Up next:** observability, cost and a capstone that combines the pieces.
', 0, '[]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_building_ai_agents_5_2', 'sec_building_ai_agents_5', 'crs_building_ai_agents', 'Observability, cost and a capstone', 'interactive', 1, 1440, NULL, NULL, 'Shipping an agent means knowing what it did, what it cost and whether it stayed safe. Observability records every step as an event. Cost is tokens times price, summed over the steps of each task. The capstone below runs a scripted agent, checks its tool calls against permissions, scores the trajectory and reports the cost, with every step logged.

## A structured event log

Each step is recorded as an event with the task, the step number and what happened, so a failure can be traced to the step that caused it.

```python run
log = []
def record(task, step, event, **details):
    log.append({"task": task, "step": step, "event": event, **details})

record("t1", 1, "tool_call", tool="search")
record("t1", 2, "tool_result", ok=True)
record("t1", 3, "final", answer="42")
print(len(log), "events; last event:", log[-1]["event"])
```

## Token cost per task

A task''s cost is its total tokens times the price per million tokens, divided by one million.

```python run
tokens_per_step = 1000
steps = 5
price_per_million = 3.0
print("cost of the task:", round(tokens_per_step * steps * price_per_million / 1_000_000, 4), "dollars")
```

## A safety gate on each call

Before a tool runs, its permission tier is checked, and the call is logged with the decision.

```python run
policy = {"search": "read", "email": "write"}
decision = {"read": "allow", "write": "confirm"}
for tool in ["search", "email"]:
    print(tool, "->", decision[policy[tool]])
```

## Summary of a suite

The capstone summarizes the runs with success rate and average steps, the two numbers an on-call engineer checks first.

```python run
runs = [{"success": True, "steps": 2}, {"success": False, "steps": 4}, {"success": True, "steps": 3}]
rate = sum(r["success"] for r in runs) / len(runs)
avg_steps = sum(r["steps"] for r in runs) / len(runs)
print("success rate:", round(rate, 3), "| average steps:", round(avg_steps, 3))
```

> **Pitfall:** logs that record only the final answer make a bad run impossible to diagnose. Log each tool call and its result, and keep the logs for the length of your incident window.

> **In the wild:** agent platforms show a trace for every run, with the cost per step, so the team can see which step burned the budget.

## Challenge: task cost

```python exercise id=task-cost title="Cost of one agent task"
# TODO: `task_cost(tokens_per_step, steps, price_per_million)` returns the dollar cost of a task with the given tokens per step
# and number of steps, at a price per million tokens.
def task_cost(tokens_per_step, steps, price_per_million):
    ...
--- solution
def task_cost(tokens_per_step, steps, price_per_million):
    return tokens_per_step * steps * price_per_million / 1_000_000
--- test
result = task_cost(1000, 5, 3.0)
assert result is not None, "Replace the `...` in `task_cost` with code that returns the cost."
assert abs(result - 0.015) < 1e-9, f"5000 tokens at 3 dollars per million is 0.015 dollars, but you returned {result}."
--- hint
Total tokens times the price, divided by one million.
--- hint
`tokens_per_step * steps * price_per_million / 1_000_000`.
```

## Challenge: suite summary

```python exercise id=summarize title="Summarize a suite of runs"
# TODO: `summarize(results)` takes a list of dictionaries with keys "success" (bool) and "steps" (int). It returns
# {"success_rate": share of successful runs, "avg_steps": mean number of steps} as floats.
def summarize(results):
    ...
--- solution
def summarize(results):
    n = len(results)
    return {
        "success_rate": sum(r["success"] for r in results) / n,
        "avg_steps": sum(r["steps"] for r in results) / n,
    }
--- test
result = summarize([{"success": True, "steps": 2}, {"success": False, "steps": 4}])
assert result is not None, "Replace the `...` in `summarize` with code that returns the summary."
assert abs(result["success_rate"] - 0.5) < 1e-9, "One of two runs succeeded, so the rate is 0.5."
assert abs(result["avg_steps"] - 3.0) < 1e-9, "Two and four steps average to 3."
--- hint
Sum the flags and divide by the number of runs, for each measure.
--- hint
Booleans add as 0 and 1 in Python.
```

## Debug: the wrong divisor

The average should divide the total steps by the number of runs, but this version divides by the number of successful runs.

```python debug id=average-divisor title="Average over all runs"
results = [{"success": True, "steps": 2}, {"success": False, "steps": 4}]
avg_steps = sum(r["steps"] for r in results) / sum(r["success"] for r in results)   # bug: divides by successes
print("average steps:", avg_steps)
--- solution
results = [{"success": True, "steps": 2}, {"success": False, "steps": 4}]
avg_steps = sum(r["steps"] for r in results) / len(results)
print("average steps:", avg_steps)
--- test
assert abs(avg_steps - 3.0) < 1e-9, f"Two runs with 2 and 4 steps average 3, but the code gives {avg_steps}. Divide by the number of runs."
--- hint
The average is over every run, not only the successful ones.
--- hint
Use `len(results)`.
```

## Predict the rate

```python predict id=predict-cap title="What is the success rate when one of two runs succeeds?"
results = [{"success": True}, {"success": False}]
print(sum(r["success"] for r in results) / len(results))
--- options
* 0.5
1.0
0.0
2.0
--- explain
One success out of two runs gives a rate of one half.
```

## Capstone: a monitored run

This capstone ties the course together. A scripted agent calls a tool, a gate checks it against the policy, the trajectory is scored and the cost is reported, with every step recorded.

```python run
replies = [
    {"tool": "search", "args": {"q": "order 42"}},
    {"tool": "email", "args": {"to": "a@b.com"}},
    {"tool": "final", "answer": "shipped"},
]
policy = {"search": "read", "email": "write", "final": "read"}
decision = {"read": "allow", "write": "confirm"}
log = []
actions = []
for step, reply in enumerate(replies, start=1):
    tool = reply["tool"]
    verdict = decision.get(policy.get(tool), "deny") if tool != "final" else "allow"
    log.append({"step": step, "tool": tool, "verdict": verdict})
    actions.append({"tool": tool, "answer": reply.get("answer")})
    if verdict == "confirm":
        log.append({"step": step, "event": "waiting for user confirmation"})
        break
success = actions[-1]["answer"] == "shipped"
cost = 3 * 1000 * 3.0 / 1_000_000
print("log:", log)
print("success:", success, "| steps:", len(actions), "| cost:", round(cost, 6), "dollars")
```

> **Pitfall:** a gate that stops at a confirmation and silently continues later hides the approval step. Log the wait, and resume only with a recorded decision.

## Recap

- Log each step as an event, so a failure can be traced to its step.
- Cost is tokens times price, summed over the steps of each task.
- Gate every risky tool call, and summarize the suite with the numbers an on-call engineer checks.

**Up next:** the final assessment covers the whole course.
', 0, '[]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z'),
('les_building_ai_agents_5_3', 'sec_building_ai_agents_5', 'crs_building_ai_agents', 'Final assessment: Building Reliable AI Agents', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What is a trajectory in agent evaluation?","options":["The sequence of actions the agent took, not only its final answer","The speed of the model","The list of tools in the registry","The price of the model"],"answerIndex":0,"explanation":"Evaluating the trajectory reveals wrong tools, forbidden actions and wasted steps that a final answer hides."},{"id":"q2","prompt":"Why track steps and cost per task, not only success?","options":["A task can succeed at a high cost or with many wasted steps, which matters in production","Steps and cost are always identical","Success is never measured","Cost is only relevant for training"],"answerIndex":0,"explanation":"Efficiency and cost decide whether a successful agent is affordable to run."},{"id":"q3","prompt":"What does a forbidden-tool check in a trajectory detect?","options":["Any use of a tool that the policy does not allow for that task","Slow responses","Missing documentation","Long answers"],"answerIndex":0,"explanation":"A safety check on the trajectory catches policy violations even when the final answer looks right."},{"id":"q4","prompt":"Why should an agent''s logs record each tool call and result?","options":["So failures can be traced to the step that caused them","So the model is retrained every night","So the tools become faster","So the logs can be deleted sooner"],"answerIndex":0,"explanation":"Per-step records turn an unexplained bad answer into a specific, fixable step."}]', '[]', '2026-06-25T07:24:31.120Z', '2026-10-19T07:24:31.120Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_llm_engineer', 'crs_building_ai_agents', 3);

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_building_ai_agents_1', 'usr_seed00000g', 'crs_building_ai_agents', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-08-28T07:24:31.120Z', '2026-08-28T07:24:31.120Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000g');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_building_ai_agents_2', 'usr_seed00000l', 'crs_building_ai_agents', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-09-28T23:24:31.120Z', '2026-09-28T23:24:31.120Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000l');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_building_ai_agents_3', 'usr_seed00000n', 'crs_building_ai_agents', 5, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-09-29T17:24:31.120Z', '2026-09-29T17:24:31.120Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000n');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_building_ai_agents_4', 'usr_seed000013', 'crs_building_ai_agents', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-09-25T08:24:31.120Z', '2026-09-25T08:24:31.120Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000013');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_building_ai_agents_5', 'usr_seed00001x', 'crs_building_ai_agents', 5, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-10-22T01:24:31.120Z', '2026-10-22T01:24:31.120Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001x');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_building_ai_agents_6', 'usr_seed000027', 'crs_building_ai_agents', 3, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-08-14T21:24:31.120Z', '2026-08-14T21:24:31.120Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000027');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_building_ai_agents_7', 'usr_seed00004f', 'crs_building_ai_agents', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-10-19T08:24:31.120Z', '2026-10-19T08:24:31.120Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00004f');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_building_ai_agents'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_building_ai_agents') WHERE id = 'crs_building_ai_agents';
