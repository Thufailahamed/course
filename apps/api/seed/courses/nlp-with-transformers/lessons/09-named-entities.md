Named-entity recognition finds the people, places, organizations and dates in a sentence. It is a sequence-labelling problem: every token receives a tag, and the tags are then grouped into **spans**. The common tagging scheme, BIO, marks the first token of each entity with B and the rest with I. Decoding BIO tags into spans is a small but exact procedure, and most NER errors that look like model errors are actually decoding or boundary errors.

## BIO tags

```python run
tokens = ["Maria", "Lopez", "joined", "Acme", "Corp", "in", "Paris", "."]
tags = ["B-PER", "I-PER", "O", "B-ORG", "I-ORG", "O", "B-LOC", "O"]
for t, g in zip(tokens, tags):
    print(f"{t:>8}  {g}")
```

The entity "Maria Lopez" is a person spanning tokens 0 and 1. "Acme Corp" is an organization. Everything else is outside any entity.

## Decoding spans

A span starts at a B tag and continues over the I tags that follow with the same label. An I tag that does not follow a matching tag starts a new span in most decoders.

```python run
def decode_spans(tags):
    spans, start, label = [], None, None
    for i, tag in enumerate(tags + ["O"]):
        if tag.startswith("B-") or tag == "O" or (tag.startswith("I-") and tag[2:] != label):
            if start is not None:
                spans.append((start, i, label))
                start, label = None, None
            if tag.startswith("B-") or (tag.startswith("I-")):
                start, label = i, tag[2:]
    return spans

print(decode_spans(tags))
```

Spans are reported as (start, end, label) with the end index exclusive, so a span of two tokens starting at 0 is (0, 2, label).

## Scoring spans exactly

NER is scored at the span level: a prediction counts only if its boundaries and label match the gold span exactly. A prediction that gets the label right but one boundary wrong is a miss and a false alarm.

```python run
gold = {(0, 2, "PER"), (3, 5, "ORG"), (6, 7, "LOC")}
pred = {(0, 2, "PER"), (3, 4, "ORG"), (6, 7, "LOC")}
tp = len(gold & pred)
precision, recall = tp / len(pred), tp / len(gold)
f1 = 2 * precision * recall / (precision + recall)
print("precision:", round(precision, 3), "| recall:", round(recall, 3), "| span F1:", round(f1, 3))
```

The organization was found but its boundary was wrong, so it counts as one miss and one false alarm.

> **Pitfall:** token-level accuracy looks high for NER because most tokens are "O". Span-level F1 is the number that reflects the entities you care about.

> **In the wild:** Hugging Face token-classification pipelines output BIO-like labels that must be aggregated into spans. Aggregation errors are a frequent source of bad entity extraction.

Each entity in a BIO-tagged sequence starts with exactly one B tag, so counting B tags counts the entities.

```python run
tags_ex = ["B-PER", "I-PER", "O", "B-LOC", "O", "B-PER"]
print("entities found:", sum(t.startswith("B-") for t in tags_ex))
```

## Challenge: decode BIO tags

```python exercise id=bio-decode title="Decode BIO tags into spans"
# TODO: `bio_to_spans(tags)` takes a list of BIO tags and returns a list of (start, end, label) tuples, with end exclusive.
# A B-X tag starts a span, following I-X tags continue it, and any other tag (O, or an I-X that does not continue a span)
# ends the current span. An I-X tag that does not continue a span starts a new one.
def bio_to_spans(tags):
    ...
--- solution
def bio_to_spans(tags):
    spans, start, label = [], None, None
    for i, tag in enumerate(list(tags) + ["O"]):
        if tag.startswith("B-") or tag == "O" or (tag.startswith("I-") and tag[2:] != label):
            if start is not None:
                spans.append((start, i, label))
                start, label = None, None
            if tag.startswith("B-") or tag.startswith("I-"):
                start, label = i, tag[2:]
    return spans
--- test
result = bio_to_spans(["B-PER", "I-PER", "O", "B-LOC"])
assert result is not None, "Replace the `...` in `bio_to_spans` with code that returns the spans."
assert result == [(0, 2, "PER"), (3, 4, "LOC")], f"The person spans tokens 0 and 1 and the location is token 3, so the spans are [(0, 2, 'PER'), (3, 4, 'LOC')], but you returned {result}."
assert bio_to_spans(["I-ORG", "I-ORG"]) == [(0, 2, "ORG")], "An I tag with no B tag starts a span, which continues over the following I tags."
assert bio_to_spans(["O", "O"]) == [], "Outside tags produce no spans."
--- hint
Walk through the tags, remembering where the current span started and its label. Close the span when a tag does not continue it, and at the end of the sequence.
--- hint
Compare each tag with the current label: `tag[2:]` is the label of a B or I tag.
```

## Challenge: span F1

```python exercise id=span-f1 title="Exact span F1"
# TODO: `span_f1(pred, gold)` takes two sets of (start, end, label) spans and returns the F1 score of exact matches:
# precision = matches / number predicted, recall = matches / number gold, F1 = their harmonic mean. Return 0.0 when
# there are no matches.
def span_f1(pred, gold):
    ...
--- solution
def span_f1(pred, gold):
    pred, gold = set(pred), set(gold)
    tp = len(pred & gold)
    if tp == 0:
        return 0.0
    precision, recall = tp / len(pred), tp / len(gold)
    return 2 * precision * recall / (precision + recall)
--- test
result = span_f1({(0, 2, "PER")}, {(0, 2, "PER"), (3, 4, "LOC")})
assert result is not None, "Replace the `...` in `span_f1` with code that returns the score."
assert abs(result - 2 / 3) < 1e-9, f"One exact match out of one prediction and two gold spans gives precision 1 and recall 0.5, so F1 is 2/3, but you returned {result!r}."
assert span_f1({(0, 1, "X")}, {(0, 2, "X")}) == 0.0, "A boundary error is a miss: no exact match, so F1 is zero."
assert abs(span_f1({(0, 1, "X")}, {(0, 1, "X")}) - 1.0) < 1e-9, "A perfect match gives F1 of one."
--- hint
Count the spans that appear in both sets. Precision divides by the predicted count, recall by the gold count.
--- hint
Use set intersection: `len(pred & gold)`.
```

## Debug the span end

This decoder is meant to report exclusive ends, but it reports the index of the last token, so spans are one token short.

```python debug id=span-end title="Use an exclusive end"
tags = ["B-PER", "I-PER", "O"]
spans, start = [], 0
spans.append((start, 1, "PER"))          # bug: the span covers tokens 0 and 1, so its exclusive end is 2
print(spans)
--- solution
tags = ["B-PER", "I-PER", "O"]
spans, start = [], 0
spans.append((start, 2, "PER"))
print(spans)
--- test
assert spans == [(0, 2, "PER")], f"The entity covers tokens 0 and 1, so with an exclusive end the span is (0, 2, 'PER'), but it is {spans}."
--- hint
An exclusive end is one past the last token of the span.
--- hint
The last token of the span is index 1, so the end is 2.
```

## Predict the span

```python predict id=predict-span title="Which span does this decode to?"
tags = ["O", "B-LOC", "I-LOC", "O"]
print([i for i, t in enumerate(tags) if t != "O"])
--- options
* [1, 2]
[1, 2, 3]
[0, 1]
[2]
--- explain
The non-outside tags are at positions 1 and 2, so the location span is (1, 3, 'LOC'). Its tokens are the two positions listed here.
```
