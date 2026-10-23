Some NLP tasks produce text: summaries, translations, rewritten answers. Judging the output needs a measure of how close it is to a reference text written by a person. The oldest and still common family of measures counts **overlap**: how many words or n-grams the candidate shares with the reference. These metrics are cheap and reproducible, but they reward shared words, not meaning, so they must be read with care.

## Clipped counts

Overlap is counted with clipping: a word repeated in the candidate earns credit only as many times as it appears in the reference. Without clipping, a candidate that repeats "the" many times would score well for no reason.

```python run
from collections import Counter

reference = "the cat sat on the mat".split()
candidate = "the the the the cat".split()
ref_counts, cand_counts = Counter(reference), Counter(candidate)
overlap = sum(min(cand_counts[w], ref_counts[w]) for w in cand_counts)
print("clipped overlap:", overlap, "of", len(candidate), "candidate words")
```

Only two of the candidate's five words can be credited, because the reference has "the" twice and "cat" once.

## Precision, recall and F1 of overlap

Precision divides the overlap by the candidate's length, and recall divides it by the reference's length. ROUGE-1 reports their harmonic mean.

```python run
precision = overlap / len(candidate)
recall = overlap / len(reference)
rouge1 = 2 * precision * recall / (precision + recall)
print("precision:", round(precision, 3), "| recall:", round(recall, 3), "| ROUGE-1 F1:", round(rouge1, 3))
```

A short candidate can have high precision and still miss content, which is why summarization uses recall and precision together.

## Higher-order n-grams

Matching bigrams or trigrams rewards phrases in the right order, which unigram overlap ignores. Clipped n-gram precision applies the same counting to n-grams.

```python run
def ngram_counts(tokens, n):
    return Counter(tuple(tokens[i:i + n]) for i in range(len(tokens) - n + 1))

for n in [1, 2]:
    cand_ng, ref_ng = ngram_counts(candidate, n), ngram_counts(reference, n)
    matched = sum(min(c, ref_ng[g]) for g, c in cand_ng.items())
    total = sum(cand_ng.values())
    print(f"{n}-gram precision:", round(matched / total, 3))
```

> **Pitfall:** overlap metrics reward wording that matches the reference, and penalize correct paraphrases. A good summary in different words scores poorly. Pair them with human judgement or semantic similarity.

> **In the wild:** machine-translation and summarization papers still report BLEU and ROUGE, and they are read alongside human evaluations because each measures something different.

Bigram overlap rewards short phrases that appear in the right order. Set intersection finds the shared ones.

```python run
cand_words = "a quick brown fox".split()
ref_words = "a fast brown fox".split()
shared_bi = set(zip(cand_words, cand_words[1:])) & set(zip(ref_words, ref_words[1:]))
print("shared bigrams:", sorted(shared_bi))
```

## Challenge: ROUGE-1 F1

```python exercise id=rouge1 title="ROUGE-1 F1 with clipped overlap"
from collections import Counter

# TODO: `rouge1_f1(candidate, reference)` takes two lists of words. Count the clipped overlap of words (each word credited
# up to its count in the reference), compute precision as overlap / candidate length and recall as overlap / reference
# length, and return their harmonic mean. Return 0.0 when the overlap is zero.
def rouge1_f1(candidate, reference):
    ...
--- solution
from collections import Counter

def rouge1_f1(candidate, reference):
    cand, ref = Counter(candidate), Counter(reference)
    overlap = sum(min(cand[w], ref[w]) for w in cand)
    if overlap == 0:
        return 0.0
    p, r = overlap / len(candidate), overlap / len(reference)
    return 2 * p * r / (p + r)
--- test
result = rouge1_f1("the cat sat".split(), "the cat slept".split())
assert result is not None, "Replace the `...` in `rouge1_f1` with code that returns the score."
assert abs(result - 2 / 3) < 1e-9, f"The overlap is 'the' and 'cat', so precision and recall are both 2/3 and F1 is 2/3, but you returned {result!r}."
assert abs(rouge1_f1(["the", "the", "the", "cat"], ["the", "cat"]) - 2 * 0.5 * 1.0 / 1.5) < 1e-9, "Clipping gives 'the' only one credit: overlap 2, precision 0.5, recall 1, F1 2/3."
assert rouge1_f1(["a"], ["b"]) == 0.0, "No overlap gives zero."
--- hint
Count both texts with `Counter`, sum `min` of the two counts over the candidate's words, then compute precision and recall.
--- hint
`overlap = sum(min(cand[w], ref[w]) for w in cand)`.
```

## Challenge: clipped n-gram precision

```python exercise id=ngram-precision title="Clipped n-gram precision"
from collections import Counter

# TODO: `ngram_precision(candidate, reference, n)` returns the clipped n-gram precision: the number of candidate n-grams
# matched in the reference (each n-gram credited up to its reference count), divided by the number of candidate n-grams.
# Return 0.0 if the candidate has no n-grams.
def ngram_precision(candidate, reference, n):
    ...
--- solution
from collections import Counter

def ngram_precision(candidate, reference, n):
    cand = Counter(tuple(candidate[i:i + n]) for i in range(len(candidate) - n + 1))
    ref = Counter(tuple(reference[i:i + n]) for i in range(len(reference) - n + 1))
    total = sum(cand.values())
    if total == 0:
        return 0.0
    matched = sum(min(c, ref[g]) for g, c in cand.items())
    return matched / total
--- test
result = ngram_precision(["the", "the", "the", "cat"], ["the", "cat"], 1)
assert result is not None, "Replace the `...` in `ngram_precision` with code that returns the precision."
assert abs(result - 0.5) < 1e-9, f"Of the four candidate words only 'the' (once) and 'cat' are credited, giving 2/4 = 0.5, but you returned {result!r}."
assert abs(ngram_precision(["a", "b", "c"], ["a", "b", "c"], 2) - 1.0) < 1e-9, "An exact copy has precision one."
assert ngram_precision(["a"], ["a", "b"], 2) == 0.0, "A candidate with no bigrams returns zero."
--- hint
Build a Counter of n-grams for each text, then credit each candidate n-gram up to its count in the reference.
--- hint
Use `tuple(candidate[i:i + n])` for each start position.
```

## Debug the clipping

This overlap counts every candidate word that appears in the reference, so repeated words earn credit every time, and the precision is inflated.

```python debug id=no-clip title="Clip the repeated words"
from collections import Counter

reference = ["the", "cat"]
candidate = ["the", "the", "the", "cat"]
overlap = sum(1 for w in candidate if w in set(reference))    # bug: no clipping, every repeat is credited
print("precision:", overlap / len(candidate))
--- solution
from collections import Counter

reference = ["the", "cat"]
candidate = ["the", "the", "the", "cat"]
cand, ref = Counter(candidate), Counter(reference)
overlap = sum(min(cand[w], ref[w]) for w in cand)
print("precision:", overlap / len(candidate))
--- test
assert abs(overlap / len(candidate) - 0.5) < 1e-9, f"The clipped overlap is 2 out of 4 candidate words, so precision is 0.5, but the code gives {overlap / len(candidate)}. Credit each word only up to its count in the reference."
--- hint
The reference contains 'the' only once, so only one of the three candidate 'the' tokens should earn credit.
--- hint
Compare counts, using `min` of the candidate and reference counts for each word.
```

## Predict the overlap

```python predict id=predict-overlap title="What is the clipped unigram overlap of 'a a b' against 'a c'?"
from collections import Counter
cand, ref = Counter("a a b".split()), Counter("a c".split())
print(sum(min(cand[w], ref[w]) for w in cand))
--- options
* 1
2
0
3
--- explain
The reference has 'a' once, so only one of the two 'a' tokens earns credit. 'b' is not in the reference. The overlap is 1.
```
