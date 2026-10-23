A golden set is a fixed collection of inputs with expected properties. You run it after every change to a prompt, a model or a retriever, and a drop in the score is a regression to investigate. Exact matches work for short answers and classifications. Rubric scoring works for longer answers, where you check that required facts appear.

## Exact match with normalization

Normalizing case and surrounding spaces stops formatting from failing a correct answer.

```python run
def exact_match(pred, gold):
    return pred.strip().lower() == gold.strip().lower()

print(exact_match("Paris ", "paris"), exact_match("Lyon", "Paris"))
```

## Rubric scoring

A rubric lists facts the answer must contain. The score is the share of facts found.

```python run
def rubric_score(answer, facts):
    text = answer.lower()
    return sum(f in text for f in facts) / len(facts)

print("all facts:", rubric_score("Paris is in France", ["paris", "france"]))
print("half the facts:", rubric_score("Paris is in France", ["paris", "berlin"]))
```

## Running a golden set

A golden set is run as a loop over cases. The pass rate is the number that is tracked over time.

```python run
golden = [
    {"question": "capital of France", "gold": "Paris"},
    {"question": "capital of Spain", "gold": "Madrid"},
    {"question": "capital of Italy", "gold": "Rome"},
]
answers = {"capital of France": "Paris", "capital of Spain": "Barcelona", "capital of Italy": "rome"}
results = [exact_match(answers[c["question"]], c["gold"]) for c in golden]
print("pass rate:", round(sum(results) / len(results), 3))
```

## Comparing two versions

A regression check compares the pass rate before and after a change, on the same cases.

```python run
before = [True, True, False, True]
after = [True, False, True, True]
print("before:", sum(before) / len(before), "| after:", sum(after) / len(after))
```

> **Pitfall:** a golden set that is too easy, or that was written by looking at the outputs, hides real failures. Add cases from real user traffic, especially the ones that failed.

> **In the wild:** teams keep golden sets in version control next to the prompts, and fail the build when the pass rate drops below an agreed threshold.

## Challenge: exact match

```python exercise id=exact-match title="Exact match after normalization"
# TODO: `exact_match(pred, gold)` returns True when the two strings are equal after stripping surrounding spaces and
# lowercasing both.
def exact_match(pred, gold):
    ...
--- solution
def exact_match(pred, gold):
    return pred.strip().lower() == gold.strip().lower()
--- test
assert exact_match("Paris ", "paris") is True, "Spaces and case should not matter."
assert exact_match("Lyon", "Paris") is False, "Different answers do not match."
--- hint
Apply `strip` and `lower` to both strings before comparing.
--- hint
`pred.strip().lower() == gold.strip().lower()`.
```

## Challenge: rubric score

```python exercise id=rubric title="Share of required facts found"
# TODO: `rubric_score(answer, facts)` returns the share of the facts (lowercase strings) that appear in the answer, compared
# case-insensitively, as a float. With no facts it returns 1.0.
def rubric_score(answer, facts):
    ...
--- solution
def rubric_score(answer, facts):
    if not facts:
        return 1.0
    text = answer.lower()
    return sum(f in text for f in facts) / len(facts)
--- test
result = rubric_score("Paris is in France", ["paris", "france"])
assert result is not None, "Replace the `...` in `rubric_score` with code that returns the score."
assert abs(result - 1.0) < 1e-9, f"Both facts appear, so the score is 1.0, but you returned {result}."
assert abs(rubric_score("Paris is in France", ["paris", "berlin"]) - 0.5) < 1e-9, "One of two facts appears, so the score is 0.5."
--- hint
Lowercase the answer once, then count the facts that are substrings of it.
--- hint
`sum(f in text for f in facts) / len(facts)`.
```

## Debug: case-sensitive matching

The facts are lowercase, but the answer is compared as written, so 'Paris' does not match 'paris'.

```python debug id=case-sensitive title="Compare facts case-insensitively"
facts = ["paris"]
answer = "Paris"
found = sum(f in answer for f in facts) / len(facts)     # bug: the answer is not lowercased
print("score:", found)
--- solution
facts = ["paris"]
answer = "Paris"
found = sum(f in answer.lower() for f in facts) / len(facts)
print("score:", found)
--- test
assert found == 1.0, f"The fact 'paris' appears in 'Paris' once case is ignored, so the score is 1.0, but the code gives {found}. Lowercase the answer before matching."
--- hint
Substring checks are case-sensitive in Python.
--- hint
Call `.lower()` on the answer.
```

## Predict the rubric score

```python predict id=predict-rub title="What is the rubric score of 'the capital of France is Paris' for the facts paris and berlin?"
ans = "the capital of france is paris"
facts = ["paris", "berlin"]
print(sum(f in ans for f in facts) / len(facts))
--- options
* 0.5
1.0
0.0
0.25
--- explain
Paris appears and Berlin does not, so one of two facts is found.
```

## Recap

- A golden set is a fixed set of cases, run after every change.
- Normalize before matching, and use rubrics for answers longer than a word.
- Track the pass rate over time, and investigate every drop.

**Up next:** LLM-as-a-judge, which scores answers you cannot match exactly, and how to check the judge.
