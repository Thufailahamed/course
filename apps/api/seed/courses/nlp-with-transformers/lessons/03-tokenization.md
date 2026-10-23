Every representation starts with tokens, and the choices behind tokenization shape everything after it. Should "Don't" be one token or two? Should punctuation count? Should "running" and "run" be related? Two more ideas extend single tokens: **n-grams** keep short sequences of neighbouring words, which recovers some order, and **subword** units handle words the vocabulary has never seen.

## Normalizing text

Normalization makes different surface forms equal. Common steps are lowercasing, removing accents or punctuation, and collapsing whitespace. Each step throws away information, so choose it for the task.

```python run
import re

raw = "  The  COMPANY's   results,  Q3-2026!  "
normalized = re.sub(r"\s+", " ", raw).strip().lower()
print(repr(normalized))
print(re.findall(r"[a-z0-9]+", normalized))
```

The apostrophe split "company's" into "company" and "s", which may or may not be what you want. A tokenizer is a policy, not a fact.

## N-grams keep neighbours

An n-gram is a run of $n$ consecutive tokens. Bigrams (n = 2) capture phrases such as "New York" that single words miss.

```python run
def ngrams(tokens, n):
    return [tuple(tokens[i:i + n]) for i in range(len(tokens) - n + 1)]

tokens = ["the", "new", "york", "office"]
print("bigrams:", ngrams(tokens, 2))
print("trigrams:", ngrams(tokens, 3))
```

Bigrams add many features, so the vocabulary grows quickly. They are most useful when the phrase carries meaning that its parts do not.

## Subwords handle rare words

A word-level vocabulary cannot represent a word it has never seen. Splitting words into smaller pieces, as byte-pair encoding does, lets the model build unfamiliar words from familiar parts.

```python run
vocab_pieces = {"un", "believ", "able", "happi", "ness"}
def greedy_split(word, pieces):
    out, i = [], 0
    while i < len(word):
        for j in range(len(word), i, -1):
            if word[i:j] in pieces:
                out.append(word[i:j])
                i = j
                break
        else:
            out.append(word[i])
            i += 1
    return out

print(greedy_split("unbelievable", vocab_pieces))
print(greedy_split("happiness", vocab_pieces))
```

> **Pitfall:** the same word can tokenize differently in different contexts, and a tokenizer trained on one domain may split another domain's words badly. Check token counts on your real data.

> **In the wild:** Hugging Face tokenizers for BERT use WordPiece, a subword scheme close to BPE, with special tokens such as [CLS] and [SEP] added around each input.

A simple regular expression already shows the choices a tokenizer makes: where words split, and what happens to punctuation.

```python run
import re
sample = "Don't stop-start tokens!"
print(re.findall(r"[a-z]+|[^\sa-z]", sample.lower()))
```

## Challenge: n-grams

```python exercise id=ngrams-fn title="Build n-grams"
# TODO: `ngrams(tokens, n)` returns a list of tuples, one for each run of n consecutive tokens, in order.
def ngrams(tokens, n):
    ...
--- solution
def ngrams(tokens, n):
    return [tuple(tokens[i:i + n]) for i in range(len(tokens) - n + 1)]
--- test
result = ngrams(["a", "b", "c", "d"], 2)
assert result is not None, "Replace the `...` in `ngrams` with code that returns the list."
assert result == [("a", "b"), ("b", "c"), ("c", "d")], f"Bigrams of a, b, c, d are (a, b), (b, c) and (c, d), but you returned {result}."
assert ngrams(["x"], 2) == [], "A sequence shorter than n has no n-grams."
assert ngrams(["a", "b"], 1) == [("a",), ("b",)], "Unigrams are single-token tuples."
--- hint
There are `len(tokens) - n + 1` starting positions. Slice each window and turn it into a tuple.
--- hint
`[tuple(tokens[i:i + n]) for i in range(len(tokens) - n + 1)]`.
```

## Challenge: normalize and tokenize

```python exercise id=normalize-tokens title="Normalize, then tokenize"
import re

# TODO: `normalize_tokens(text)` collapses runs of whitespace, lowercases the text, and returns the list of runs of
# letters and digits (a-z and 0-9) found in it.
def normalize_tokens(text):
    ...
--- solution
import re

def normalize_tokens(text):
    cleaned = re.sub(r"\s+", " ", text).strip().lower()
    return re.findall(r"[a-z0-9]+", cleaned)
--- test
result = normalize_tokens("  Q3   results,\tIN 2026! ")
assert result is not None, "Replace the `...` in `normalize_tokens` with code that returns the tokens."
assert result == ["q3", "results", "in", "2026"], f"Expected ['q3', 'results', 'in', '2026'], but you returned {result}."
assert normalize_tokens("") == [], "Empty text has no tokens."
--- hint
Lowercase first, then find runs of letters and digits. Whitespace collapsing is not needed for `findall`, but it keeps the text tidy.
--- hint
`re.findall(r"[a-z0-9]+", text.lower())` gives the tokens directly.
```

## Debug the matching

This vocabulary check should find the stop word "and", but the text is not normalized, so "And" is missed.

```python debug id=missed-and title="Normalize before matching"
import re

stop_words = {"and", "the"}
text = "Cats And Dogs"
tokens = re.findall(r"[a-z]+", text)            # bug: capitalized words never match the lowercase set
found = [t for t in tokens if t in stop_words]
print("stop words found:", found)
--- solution
import re

stop_words = {"and", "the"}
text = "Cats And Dogs"
tokens = re.findall(r"[a-z]+", text.lower())
found = [t for t in tokens if t in stop_words]
print("stop words found:", found)
--- test
assert found == ["and"], f"The text contains 'And', which is the stop word 'and' after normalization, but the code found {found}. Lowercase the text before matching."
--- hint
Normalize both sides of a comparison, or compare in one consistent case.
--- hint
Call `.lower()` on the text before matching.
```

## Predict the count

```python predict id=predict-bigram title="How many bigrams does a 5-token sentence have?"
tokens = ["a", "b", "c", "d", "e"]
print(len(tokens) - 2 + 1)
--- options
* 4
5
3
2
--- explain
A bigram starts at each position that leaves room for a second token, so there are len − 1 = 4 bigrams.
```

## Recap

- Tokenization is a set of policies about case, punctuation and boundaries, and each policy changes the results.
- N-grams keep neighbouring words, capturing phrases at the cost of a larger vocabulary.
- Subword units handle rare and unseen words by building them from familiar pieces.
- Check how your tokenizer treats real data, not just clean examples.

**Up next:** word embeddings learned from co-occurrence, which give words a geometry of meaning.
