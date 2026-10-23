Welcome to **Modern NLP with Transformers**. Natural language processing is the craft of getting computers to work with text: classifying messages, finding the documents that answer a question, pulling names and dates out of sentences. For years it was built from word counts and hand-written rules. Today most systems use transformers, but the job is the same: turn text into numbers that carry meaning, then judge the results honestly.

This course follows that path. You will build the classic representations in plain Python and NumPy, measure how well they work, and see how pretrained encoders such as BERT are used on top of the same ideas. The Hugging Face code is shown as static code for you to run locally, because the browser does not download model weights.

> **How to use this lesson:** read a little, run a little. Every grey box runs in the page.

## Run your first text pipeline

```python run
import re

sentence = "The delivery arrived late, and the box was damaged!"
tokens = re.findall(r"[a-z]+", sentence.lower())
print("tokens:", tokens)
print("number of tokens:", len(tokens))
```

Lowercasing and splitting on letters is the simplest possible tokenizer. It already makes a decision that matters: "The" and "the" become the same token. Every later lesson builds on decisions like this one.

## Predict the result

```python predict id=predict-tokens title="How many tokens does this produce?"
import re
text = "Good food, fast service!"
print(len(re.findall(r"[a-z]+", text.lower())))
--- options
* 4
5
3
6
--- explain
The regular expression keeps runs of letters, so the tokens are good, food, fast and service. The comma and the exclamation mark are dropped, which leaves four tokens.
```

## Your first challenge

A **challenge** asks you to write a function that the course tests on new text.

```python exercise id=lowercase-words title="Lowercase word tokens"
import re

# TODO: `word_tokens(text)` returns the lowercase words of a text as a list, keeping only runs of letters.
def word_tokens(text):
    ...
--- solution
import re

def word_tokens(text):
    return re.findall(r"[a-z]+", text.lower())
--- test
result = word_tokens("Hello, World!  It's 2026.")
assert result is not None, "Replace the `...` in `word_tokens` with code that returns the tokens."
assert result == ["hello", "world", "it", "s"], f"Keep only lowercase runs of letters, giving ['hello', 'world', 'it', 's'], but you returned {result}."
assert word_tokens("") == [], "Empty text has no tokens."
assert word_tokens("ONE two") == ["one", "two"], "Matching must not depend on capitalization."
--- hint
Lowercase the text first, then find all runs of letters with `re.findall(r"[a-z]+", ...)`.
--- hint
`return re.findall(r"[a-z]+", text.lower())`.
```

## Debug the case

This token counter is meant to count how often each word appears, but "The" and "the" are counted separately.

```python debug id=case-counts title="Count words regardless of case"
import re
from collections import Counter

text = "The cat saw the dog. The dog ran."
counts = Counter(re.findall(r"[a-z]+", text))     # bug: the text is not lowercased first
print(counts["the"])
--- solution
import re
from collections import Counter

text = "The cat saw the dog. The dog ran."
counts = Counter(re.findall(r"[a-z]+", text.lower()))
print(counts["the"])
--- test
assert counts["the"] == 3, f"'The' and 'the' are the same word, so 'the' should appear 3 times, but it appears {counts['the']} times. Lowercase the text before matching."
--- hint
Matching is case-sensitive, so capital letters never match the lowercase pattern.
--- hint
Call `.lower()` on the text before `re.findall`.
```

## Recap

- Text becomes tokens through decisions about case, punctuation and boundaries, and those decisions change every result.
- A regular expression is a compact way to state which characters count as part of a token.
- Write tokenizers as functions with tests, so their behaviour is fixed and checkable.
- Every representation in this course starts from tokens.

**Up next:** from counting words to weighting them, with bags of words and TF-IDF.
