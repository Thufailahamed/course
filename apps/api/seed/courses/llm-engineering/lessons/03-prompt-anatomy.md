A prompt is a document the model reads before it answers, and it has parts that do different jobs: a role, the rules, the context, examples and the task. Keeping those parts in named sections makes prompts easier to review and to change. The prompt also has a budget. Every token of context competes with the answer, so the size of each section matters.

## Assembling a prompt

Build the prompt from sections, with the task last so the instruction is the final thing the model reads.

```python run
def build_prompt(task, context, examples):
    parts = ["Rules: answer only from the context.", f"Context:\n{context}"]
    for i, (inp, out) in enumerate(examples, start=1):
        parts.append(f"Example {i}:\nInput: {inp}\nOutput: {out}")
    parts.append(f"Task:\n{task}")
    return "\n\n".join(parts)

print(build_prompt("Summarize the ticket.", "Customer reports a login error.", [("Refund?", "Route to billing.")]))
```

## Estimating the budget

A prompt that is too long leaves no room for the answer, and each section has a cost.

```python run
import math

def approx_tokens(text):
    return math.ceil(len(text.split()) * 1.3)

prompt = build_prompt("Summarize the ticket.", "Customer reports a login error.", [("Refund?", "Route to billing.")])
context_limit = 4096
answer_reserve = 512
print("prompt tokens:", approx_tokens(prompt), "| room left for context:", context_limit - answer_reserve - approx_tokens(prompt))
```

## Chat message structure

Hosted chat APIs take a list of messages with roles. The system message holds the rules, and the user message holds the request.

```python run
messages = [
    {"role": "system", "content": "You are a support triage assistant. Reply with one team name."},
    {"role": "user", "content": "I cannot log in after the password reset."},
]
for m in messages:
    print(m["role"], "->", m["content"][:40])
```

## Examples in the prompt

Few-shot examples teach the format by showing it. Use the same format for every example, so the model copies the structure and not the wording.

```python run
examples = [("Refund request", "billing"), ("App crashes on start", "engineering")]
for i, (inp, out) in enumerate(examples, start=1):
    print(f"Example {i}: {inp} => {out}")
```

> **Pitfall:** a long system prompt is paid for on every request. Move rarely needed rules into the retrieved context, and keep the stable core short.

> **In the wild:** prompts are source code. Teams review them, version them and test them against a golden set, as lesson 9 describes.

## Challenge: a token estimate

```python exercise id=approx-tokens title="Approximate token count"
import math

# TODO: `approx_tokens(text)` returns the number of whitespace-separated words multiplied by 1.3, rounded up to an integer.
def approx_tokens(text):
    ...
--- solution
import math

def approx_tokens(text):
    return math.ceil(len(text.split()) * 1.3)
--- test
result = approx_tokens("one two three")
assert result is not None, "Replace the `...` in `approx_tokens` with code that returns the estimate."
assert result == 4, f"Three words at 1.3 each is 3.9, which rounds up to 4, but you returned {result}."
assert approx_tokens("") == 0, "An empty string has no tokens."
--- hint
Count the words with `split()`, then multiply and round up.
--- hint
`math.ceil(len(text.split()) * 1.3)`.
```

## Challenge: prompt assembly

```python exercise id=build-prompt title="Assemble a prompt with numbered examples"
# TODO: `build_examples(examples)` takes a list of (input, output) pairs and returns one string. Each pair becomes
# "Example i:\nInput: ...\nOutput: ..." with i counting from 1, and the blocks are joined with a blank line.
def build_examples(examples):
    ...
--- solution
def build_examples(examples):
    blocks = [f"Example {i}:\nInput: {inp}\nOutput: {out}" for i, (inp, out) in enumerate(examples, start=1)]
    return "\n\n".join(blocks)
--- test
result = build_examples([("a", "1"), ("b", "2")])
assert result is not None, "Replace the `...` in `build_examples` with code that returns the string."
assert result.startswith("Example 1:\nInput: a\nOutput: 1"), "The first example is numbered 1."
assert "Example 2:\nInput: b\nOutput: 2" in result, "The second example is numbered 2 and appears after the first."
--- hint
Use `enumerate(examples, start=1)` and join the blocks with two newlines.
--- hint
`"\n\n".join(f"Example {i}:\nInput: {inp}\nOutput: {out}" for i, (inp, out) in enumerate(examples, start=1))`.
```

## Debug: numbering from zero

The examples should be numbered from 1, but the counter starts at 0.

```python debug id=numbering-start title="Number the examples from one"
examples = [("a", "1"), ("b", "2")]
blocks = []
for i, (inp, out) in enumerate(examples):    # bug: enumerate starts at 0
    blocks.append(f"Example {i}:\nInput: {inp}\nOutput: {out}")
text = "\n\n".join(blocks)
print(text)
--- solution
examples = [("a", "1"), ("b", "2")]
blocks = []
for i, (inp, out) in enumerate(examples, start=1):
    blocks.append(f"Example {i}:\nInput: {inp}\nOutput: {out}")
text = "\n\n".join(blocks)
print(text)
--- test
assert "Example 1:" in text and "Example 2:" in text, f"The examples must be numbered 1 and 2, but the text starts with {text[:12]!r}. Use enumerate(..., start=1)."
--- hint
Users read the first example as 'Example 1', not 'Example 0'.
--- hint
Pass `start=1` to `enumerate`.
```

## Predict the token estimate

```python predict id=predict-tokens title="What does approx_tokens return for 'one two three four' with 1.3 per word?"
import math
print(math.ceil(len("one two three four".split()) * 1.3))
--- options
* 6
5
4
8
--- explain
Four words at 1.3 each is 5.2, which rounds up to 6.
```

## Recap

- A prompt has parts with different jobs, and each part costs budget.
- The chat format separates rules from requests, and examples teach the output format.
- Estimate tokens before a request, so the answer has room.

**Up next:** structured outputs, where the code checks what the model returns.
