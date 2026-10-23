Every model call sends the whole context, and the cost and the limit both depend on its length. A long task fills the window with old tool results. Context management decides what to keep. The system message is never dropped, the most recent turns are kept, and older material is trimmed to fit the budget.

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
Compute the system message's words first, then walk the other messages from the end.
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
assert kept == ["f g", "h"], f"The most recent messages fit the budget, so the kept messages should be ['f g', 'h'], but the code keeps {kept}. Walk from the newest message."
--- hint
The newest messages are at the end of the list.
--- hint
Iterate with `reversed(rest)` and reverse `kept` at the end.
```

## Predict the word count

```python predict id=predict-words title="How many tokens does 'one two three' count as, by words?"
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
