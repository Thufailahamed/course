Retrieval starts with documents split into pieces small enough to embed and to fit in a prompt. Chunks that are too small lose their context, and chunks that are too large dilute the match. Overlap between neighbouring chunks keeps a sentence that straddles a boundary whole in at least one chunk.

## Chunks with overlap

```python run
def chunk_words(words, size, overlap):
    step = size - overlap
    chunks = []
    i = 0
    while True:
        chunks.append(words[i:i + size])
        if i + size >= len(words):
            break
        i += step
    return chunks

words = "the refund policy lasts thirty days from delivery".split()
for c in chunk_words(words, size=4, overlap=1):
    print(" ".join(c))
```

Each chunk repeats one word from the previous chunk, so a phrase that spans the boundary is still whole somewhere.

## Sentence boundaries

Splitting on sentence-ending punctuation keeps each sentence intact, which often suits retrieval better than fixed word counts.

```python run
import re
text = "Refunds take five days. Shipping is free! Do you need help?"
sentences = re.split(r"(?<=[.!?])\s+", text.strip())
print(sentences)
```

## Counting chunks

The number of chunks follows from the length, the size and the step between chunk starts.

```python run
import math
for n_words, size, overlap in [(8, 4, 1), (10, 4, 0), (100, 50, 10)]:
    step = size - overlap
    print(f"{n_words} words, size {size}, overlap {overlap}: {math.ceil((n_words - overlap) / step)} chunks")
```

## A rough token size

Chunks are sized in tokens, and a quick estimate from words is enough for planning.

```python run
def est_tokens(text):
    return int(len(text.split()) * 1.3) + 1

chunk = "the refund policy lasts thirty days from delivery"
print("estimated tokens in the chunk:", est_tokens(chunk))
```

> **Pitfall:** splitting by characters can cut a word or a number in half, so a chunk ends with "£12" and the next starts with "5". Split on words or sentences, then add overlap.

> **In the wild:** teams keep the chunk size and overlap as configuration, then measure retrieval recall for each setting, as in lesson 7.

## Challenge: word chunks

```python exercise id=chunk-words title="Split words into overlapping chunks"
# TODO: `chunk_words(words, size, overlap)` splits the list of words into chunks of length size. Each new chunk starts
# size − overlap positions after the previous one. Stop after the chunk that reaches the end of the list.
def chunk_words(words, size, overlap):
    ...
--- solution
def chunk_words(words, size, overlap):
    step = size - overlap
    chunks = []
    i = 0
    while True:
        chunks.append(words[i:i + size])
        if i + size >= len(words):
            break
        i += step
    return chunks
--- test
result = chunk_words([1, 2, 3, 4, 5], 3, 1)
assert result is not None, "Replace the `...` in `chunk_words` with code that returns the chunks."
assert result == [[1, 2, 3], [3, 4, 5]], f"With size 3 and overlap 1 the chunks are [1, 2, 3] and [3, 4, 5], but you returned {result}."
assert chunk_words(list("abcd"), 2, 0) == [["a", "b"], ["c", "d"]], "Without overlap the chunks are disjoint."
--- hint
Advance by size minus overlap, and stop once a chunk reaches the end.
--- hint
Check `i + size >= len(words)` after appending each chunk.
```

## Challenge: sentence split

```python exercise id=split-sentences title="Split text into sentences"
import re

# TODO: `split_sentences(text)` splits text after each sentence-ending mark (. ! or ?) followed by whitespace, keeping the
# punctuation and returning the non-empty sentences.
def split_sentences(text):
    ...
--- solution
import re

def split_sentences(text):
    return [s for s in re.split(r"(?<=[.!?])\s+", text.strip()) if s]
--- test
result = split_sentences("Hi there. Bye!")
assert result is not None, "Replace the `...` in `split_sentences` with code that returns the sentences."
assert result == ["Hi there.", "Bye!"], f"The text has two sentences with their punctuation, but you returned {result}."
assert split_sentences("   ") == [], "Whitespace alone gives no sentences."
--- hint
A lookbehind for the punctuation keeps the mark inside the sentence.
--- hint
`re.split(r"(?<=[.!?])\s+", text.strip())`.
```

## Debug: the overlap is ignored

The chunks should overlap by one word, but this version starts each chunk at the end of the previous one.

```python debug id=overlap-ignored title="Apply the overlap between chunks"
words = list("abcdefgh")
size, overlap = 4, 1
step = size                                   # bug: the overlap is ignored
chunks = [words[i:i + size] for i in range(0, len(words) - overlap, step)]
print(["".join(c) for c in chunks])
--- solution
words = list("abcdefgh")
size, overlap = 4, 1
step = size - overlap
chunks = [words[i:i + size] for i in range(0, len(words) - overlap, step)]
print(["".join(c) for c in chunks])
--- test
assert ["".join(c) for c in chunks] == ["abcd", "defg", "gh"], f"With overlap 1 the chunks should be abcd, defg and gh, but the code gives {[''.join(c) for c in chunks]}. Step by size minus overlap."
--- hint
The step between starts must be smaller than the chunk size.
--- hint
Use `step = size - overlap`.
```

## Predict the chunk count

```python predict id=predict-chunks title="How many chunks do 10 words give at size 4 with no overlap?"
import math
print(math.ceil(10 / 4))
--- options
* 3
2
4
10
--- explain
The chunks start at words 0, 4 and 8, so the last chunk holds the final two words. That gives 3.
```

## Recap

- Chunk size trades context against precision, and overlap protects boundary facts.
- Split on sentences or words, never inside a word or a number.
- Measure retrieval for each chunking setting, rather than choosing by feel.

**Up next:** ranking the chunks, from cosine similarity to hybrid scores and fusion.
