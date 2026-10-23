A transformer does not read letters or words. It reads **tokens**, pieces of text drawn from a fixed vocabulary. Byte-pair encoding (BPE) builds that vocabulary from data: start with single characters, then repeatedly merge the most frequent adjacent pair into a new symbol. Common words end up as single tokens, and rare words are split into familiar pieces, so the vocabulary stays a manageable size and no word is ever unknown.

## Words as symbols

Each word is written as a sequence of symbols, here single characters, with an end-of-word marker. The corpus keeps a count of how often each word appears.

```python run
corpus = {
    ("l", "o", "w", "</w>"): 5,
    ("l", "o", "w", "e", "r", "</w>"): 2,
    ("n", "e", "w", "e", "s", "t", "</w>"): 6,
    ("w", "i", "d", "e", "s", "t", "</w>"): 3,
}
print("number of distinct words:", len(corpus))
print("total occurrences:", sum(corpus.values()))
```

## Count adjacent pairs

Each adjacent pair of symbols is counted once for every occurrence of its word. The most frequent pair is the next candidate for a merge.

```python run
from collections import Counter

pairs = Counter()
for symbols, freq in corpus.items():
    for a, b in zip(symbols, symbols[1:]):
        pairs[(a, b)] += freq
print("most common pairs:", pairs.most_common(3))
```

Three pairs tie at nine occurrences: ("e", "s"), ("s", "t") and ("t", "</w>"). A deterministic tie-break, such as the smallest pair in alphabetical order, keeps the training reproducible.

## Merge and repeat

```python run
def merge_pair_in_corpus(corpus, pair):
    new_corpus = {}
    for symbols, freq in corpus.items():
        out, i = [], 0
        while i < len(symbols):
            if i + 1 < len(symbols) and (symbols[i], symbols[i + 1]) == pair:
                out.append(symbols[i] + symbols[i + 1])
                i += 2
            else:
                out.append(symbols[i])
                i += 1
        new_corpus[tuple(out)] = new_corpus.get(tuple(out), 0) + freq
    return new_corpus

corpus = merge_pair_in_corpus(corpus, ("e", "s"))
print(list(corpus.items())[2])
```

After the first merge, "es" is a single symbol, so "newest" and "widest" now share a token. Repeating this many times builds the whole vocabulary.

> **Pitfall:** BPE is learned from a corpus, so its tokens reflect that corpus. A tokenizer trained on English may split code or other languages into far more tokens, which costs context length and money.

> **In the wild:** GPT-style models use byte-level BPE, which starts from raw bytes so that any text, in any script, can be encoded.

After one merge the number of distinct symbols shrinks, because the pair now counts as one piece. Counting the symbols before and after shows the effect.

```python run
def symbol_types(corpus):
    return len({s for symbols in corpus for s in symbols})

before = symbol_types(corpus.keys())
merged_corpus = merge_pair_in_corpus(corpus, ("s", "t"))
print("symbol types before merging ('s', 't'):", before)
print("symbol types after:", symbol_types(merged_corpus.keys()))
```

## Challenge: count the pairs

```python exercise id=count-pairs title="Count adjacent pairs"
from collections import Counter

# TODO: `count_pairs(corpus)` takes a dictionary mapping tuples of symbols to frequencies and returns a Counter of
# adjacent pairs, where each pair counts the frequency of the word it came from.
def count_pairs(corpus):
    ...
--- solution
from collections import Counter

def count_pairs(corpus):
    pairs = Counter()
    for symbols, freq in corpus.items():
        for a, b in zip(symbols, symbols[1:]):
            pairs[(a, b)] += freq
    return pairs
--- test
from collections import Counter
result = count_pairs({("a", "b", "a"): 2, ("b", "a"): 1})
assert result is not None, "Replace the `...` in `count_pairs` with code that returns the counts."
assert result[("a", "b")] == 2, "The pair (a, b) appears once in a word that occurs twice, so it counts 2."
assert result[("b", "a")] == 3, "The pair (b, a) appears once in the twice-occurring word and once in the other, so it counts 2 + 1 = 3."
assert sum(result.values()) == 5, "Each word of length n contributes n − 1 pairs, weighted by its frequency."
--- hint
Loop over the words and their frequencies, look at each neighbouring pair with `zip(symbols, symbols[1:])`, and add the frequency to that pair.
--- hint
`pairs[(a, b)] += freq` inside the inner loop.
```

## Challenge: the best pair

```python exercise id=best-pair title="Choose the most frequent pair"
# TODO: `best_pair(counts)` returns the pair with the highest count. If several pairs tie, return the one that comes
# first in alphabetical order.
def best_pair(counts):
    ...
--- solution
def best_pair(counts):
    return sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))[0][0]
--- test
counts = {("a", "b"): 3, ("b", "c"): 3, ("a", "c"): 1}
result = best_pair(counts)
assert result is not None, "Replace the `...` in `best_pair` with code that returns the pair."
assert result == ("a", "b"), f"Two pairs tie at 3, and ('a', 'b') comes first alphabetically, but you returned {result!r}."
assert best_pair({("x", "y"): 9}) == ("x", "y"), "A single pair is the best pair."
--- hint
Sort the items by count from highest to lowest, and break ties by the pair itself.
--- hint
`sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))[0][0]`.
```

## Debug the overlapping merge

This merge is meant to combine each occurrence of a pair, but it merges the wrong symbols when the pair overlaps itself, so ("a", "a", "a") becomes ("aa", "aa", "a").

```python debug id=overlap-merge title="Merge left to right, without reusing symbols"
def merge_word(symbols, pair):
    return tuple(
        a + b if (a, b) == pair else a
        for a, b in zip(symbols, symbols[1:])
    ) + (symbols[-1],)               # bug: a symbol inside a merged pair is also used as the start of the next pair

print(merge_word(("a", "a", "a"), ("a", "a")))
--- solution
def merge_word(symbols, pair):
    out, i = [], 0
    while i < len(symbols):
        if i + 1 < len(symbols) and (symbols[i], symbols[i + 1]) == pair:
            out.append(symbols[i] + symbols[i + 1])
            i += 2
        else:
            out.append(symbols[i])
            i += 1
    return tuple(out)

print(merge_word(("a", "a", "a"), ("a", "a")))
--- test
assert merge_word(("a", "a", "a"), ("a", "a")) == ("aa", "a"), f"Merging left to right gives ('aa', 'a'), but the code gives {merge_word(('a', 'a', 'a'), ('a', 'a'))}. Once a pair is merged, its symbols must not be used again."
assert merge_word(("l", "o", "w"), ("o", "w")) == ("l", "ow"), "A simple pair in the middle of a word should merge once."
--- hint
When two symbols merge, the scan must skip both of them, so the next comparison starts after the merged pair.
--- hint
Use a while loop with an index, and advance by two after a merge and by one otherwise.
```

## Predict the number of tokens

```python predict id=predict-bpe title="How many symbols does ('a', 'a', 'a') have after merging ('a', 'a')?"
from collections import Counter
symbols = ("a", "a", "a")
merged = ("aa", "a")
print(len(merged))
--- options
* 2
3
1
4
--- explain
Merging left to right joins the first two a's into "aa" and leaves the third a alone, so two symbols remain.

```