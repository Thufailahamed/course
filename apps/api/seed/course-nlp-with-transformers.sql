DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_nlp_with_transformers');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_nlp_with_transformers');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_nlp_with_transformers');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_nlp_with_transformers');

DELETE FROM discussions WHERE course_id = 'crs_nlp_with_transformers';

DELETE FROM certificates WHERE course_id = 'crs_nlp_with_transformers';

DELETE FROM enrollments WHERE course_id = 'crs_nlp_with_transformers';

DELETE FROM reviews WHERE course_id = 'crs_nlp_with_transformers';

DELETE FROM wishlist WHERE course_id = 'crs_nlp_with_transformers';

DELETE FROM path_courses WHERE course_id = 'crs_nlp_with_transformers';

DELETE FROM coupons WHERE course_id = 'crs_nlp_with_transformers';

DELETE FROM lessons WHERE course_id = 'crs_nlp_with_transformers';

DELETE FROM sections WHERE course_id = 'crs_nlp_with_transformers';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_nlp_with_transformers';

DELETE FROM courses WHERE id = 'crs_nlp_with_transformers';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_nlp', 'nlp', 'Natural Language Processing', 'Tokenization, embeddings, sequence models and evaluation.', 'message-square', 5);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_nlp_with_transformers', 'nlp-with-transformers', 'Modern NLP with Transformers', 'Tokenization, embeddings, semantic search and fine-tuned encoders — with the evaluation that makes them trustworthy.', 'Language is the messiest data most teams handle. Customer messages, documents, reviews and logs all need to be turned into numbers that a model can compare and classify. This course follows that path from raw text to a trustworthy NLP system, and it treats evaluation as seriously as modelling.

## Learn by building

- **Text pipelines you can read.** Tokenizers, n-grams, TF-IDF, co-occurrence embeddings and span decoders are written in plain Python and NumPy, and they run in the page.
- **Search you can measure.** You rank documents by meaning and score the ranking with reciprocal ranks, not by eye.
- **Metrics that tell the truth.** Macro-F1, span-level scores and ROUGE overlap are computed from their definitions.
- **Debug challenges.** You fix the mistakes that break NLP systems: case-sensitive matching, pooling that averages over padding, a data leak from fitting a vectorizer on the test set, and span boundaries that are off by one.
- **Hugging Face shown honestly.** Pretrained encoders and their fine-tuning loops are static code for local use, next to the NumPy mechanics they rely on.

## What you''ll cover

- **Text as data:** bags of words, TF-IDF and tokenization.
- **Embeddings:** word vectors from co-occurrence, sentence vectors and semantic search.
- **Fine-tuning encoders:** masked language modelling, classification and named-entity recognition.
- **Evaluation:** metrics for imbalanced and structured predictions, and error analysis.
- **Capstone:** a complete text classifier, compared against a baseline and analysed for errors.

## Why this course?

Most NLP failures are evaluation failures: a model that looks accurate on a skewed dataset, or a search that ranks well on the examples someone happened to check. This course teaches the habits and the numbers that catch those failures before users do.

You need Python and basic NumPy. Transformers are introduced from the ground up.', 'cat_nlp', 'usr_maya', 'intermediate', 'English', 0, NULL, 'USD', NULL, NULL, 340, 'published', 0, '["Understand tokenization, subword vocabularies and what a model actually reads","Turn text into vectors with counts, TF-IDF and learned embeddings, and measure their similarity","Build semantic search that ranks documents by meaning and evaluate it properly","Explain how encoders such as BERT are pretrained and fine-tuned for classification and entity recognition","Choose the right NLP metrics, including macro-F1 and span-level scores, and run an honest error analysis"]', '["Python and basic NumPy","Some familiarity with deep learning helps. The transformer lessons are self-contained","A modern browser. The text processing and metrics run in the page; Hugging Face model code is shown for local use"]', '["Analysts and engineers who work with text and want to go beyond keyword rules","Developers building search, classification or information-extraction features","Data scientists preparing for NLP roles"]', '["NLP","Hugging Face","BERT","Embeddings"]', 251, 16, 0, 0, 18740, '2026-03-13T07:06:21.232Z', '2026-02-11T07:06:21.232Z', '2026-10-22T07:06:21.232Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_nlp_with_transformers_1', 'crs_nlp_with_transformers', 'Text as Data', 0, '2026-06-25T07:06:21.232Z'),
('sec_nlp_with_transformers_2', 'crs_nlp_with_transformers', 'Embeddings and Search', 1, '2026-06-25T07:06:21.232Z'),
('sec_nlp_with_transformers_3', 'crs_nlp_with_transformers', 'Fine-tuning Encoders', 2, '2026-06-25T07:06:21.232Z'),
('sec_nlp_with_transformers_4', 'crs_nlp_with_transformers', 'Evaluation and Error Analysis', 3, '2026-06-25T07:06:21.232Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_nlp_with_transformers_1_1', 'sec_nlp_with_transformers_1', 'crs_nlp_with_transformers', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'Welcome to **Modern NLP with Transformers**. Natural language processing is the craft of getting computers to work with text: classifying messages, finding the documents that answer a question, pulling names and dates out of sentences. For years it was built from word counts and hand-written rules. Today most systems use transformers, but the job is the same: turn text into numbers that carry meaning, then judge the results honestly.

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
result = word_tokens("Hello, World!  It''s 2026.")
assert result is not None, "Replace the `...` in `word_tokens` with code that returns the tokens."
assert result == ["hello", "world", "it", "s"], f"Keep only lowercase runs of letters, giving [''hello'', ''world'', ''it'', ''s''], but you returned {result}."
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
assert counts["the"] == 3, f"''The'' and ''the'' are the same word, so ''the'' should appear 3 times, but it appears {counts[''the'']} times. Lowercase the text before matching."
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
', 1, '[]', '[{"title":"Hugging Face NLP course (free)","url":"https://huggingface.co/learn/nlp-course"},{"title":"BERT: Pre-training of Deep Bidirectional Transformers (paper)","url":"https://arxiv.org/abs/1810.04805"},{"title":"Speech and Language Processing (Jurafsky & Martin, free drafts)","url":"https://web.stanford.edu/~jurafsky/slp3/"}]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_1_2', 'sec_nlp_with_transformers_1', 'crs_nlp_with_transformers', 'From bag-of-words to TF-IDF', 'interactive', 1, 1080, NULL, NULL, 'The simplest representation of a document is a **bag of words**: count how often each vocabulary word appears, and ignore order. It is crude, but surprisingly strong, and it is the baseline every fancier method must beat. Its weakness is that common words such as "the" dominate the counts. **TF-IDF** fixes that by weighting each count with how rare the word is across the collection, so distinctive words stand out.

## Counts

```python run
import numpy as np

docs = ["the cat sat on the mat", "the dog sat on the log", "the dog barked"]
vocab = sorted({w for d in docs for w in d.split()})
index = {w: i for i, w in enumerate(vocab)}
counts = np.zeros((len(docs), len(vocab)))
for r, d in enumerate(docs):
    for w in d.split():
        counts[r, index[w]] += 1

print("vocabulary:", vocab)
print("counts for the first document:", counts[0].astype(int))
```

Each document is a row of counts over the same vocabulary. Order is lost: "dog bites man" and "man bites dog" would have identical rows.

## Inverse document frequency

A word that appears in most documents tells you little. The inverse document frequency gives a weight that is large for rare words and near zero for words everywhere:

$$
\operatorname{idf}(w) = \log \frac{N}{\operatorname{df}(w)}
$$

where $N$ is the number of documents and $\operatorname{df}(w)$ is how many of them contain $w$.

```python run
N = len(docs)
df = (counts > 0).sum(axis=0)
idf = np.log(N / df)
for w, val in zip(vocab, idf):
    print(f"{w:>8}: idf {val:.3f}")
```

"the" appears in every document, so its weight is zero. "barked" appears in one document, so it gets the largest weight.

## TF-IDF

Multiplying the counts by the idf weights gives TF-IDF. Each document now emphasizes the words that make it different from the rest.

```python run
tfidf = counts * idf
print("TF-IDF of the third document:")
for w, val in zip(vocab, tfidf[2]):
    if val > 0:
        print(f"  {w}: {val:.3f}")
```

> **Pitfall:** the idf must be computed on the training collection only. Fitting it on a collection that includes future documents, or test documents, leaks information in the same way as any other preprocessing step.

> **In the wild:** search engines and classic text classifiers are built on TF-IDF. scikit-learn''s `TfidfVectorizer` implements it with some refinements, such as smoothing.

Document frequency turns raw counts into weights. A word that appears in every document, such as ''the'', gets an inverse document frequency of zero.

```python run
from collections import Counter
import math
docs = ["the cat sat", "the dog sat", "the cat ran"]
df_counts = Counter(w for d in docs for w in set(d.split()))
print({w: round(math.log(len(docs) / c), 3) for w, c in sorted(df_counts.items())})
```

## Challenge: TF-IDF matrix

```python exercise id=tfidf-matrix title="Build a TF-IDF matrix"
import numpy as np

# TODO: `tfidf_matrix(docs)` takes a list of strings and returns (vocab, M). vocab is the sorted list of distinct
# words. M has one row per document and one column per word, holding the word''s count in that document multiplied by
# its inverse document frequency log(N / df), where N is the number of documents and df counts documents containing it.
def tfidf_matrix(docs):
    ...
--- solution
import numpy as np

def tfidf_matrix(docs):
    vocab = sorted({w for d in docs for w in d.split()})
    index = {w: i for i, w in enumerate(vocab)}
    counts = np.zeros((len(docs), len(vocab)))
    for r, d in enumerate(docs):
        for w in d.split():
            counts[r, index[w]] += 1
    df = (counts > 0).sum(axis=0)
    idf = np.log(len(docs) / df)
    return vocab, counts * idf
--- test
import numpy as np
vocab, M = tfidf_matrix(["a b", "a c"])
assert M is not None, "Replace the `...` in `tfidf_matrix` with code that returns (vocab, matrix)."
assert vocab == ["a", "b", "c"], f"The vocabulary should be sorted, [''a'', ''b'', ''c''], but it is {vocab}."
assert M.shape == (2, 3), "Two documents and three words give shape (2, 3)."
assert np.allclose(M[0], [0.0, np.log(2), 0.0]), f"''a'' is in both documents so its weight is zero; ''b'' is in one of two documents, so it weighs log 2. You returned {M[0]}."
assert np.allclose(M[1], [0.0, 0.0, np.log(2)]), "The second document''s distinctive word is ''c''."
--- hint
Count the words per document, count the documents containing each word, then multiply the counts by `np.log(N / df)`.
--- hint
`df = (counts > 0).sum(axis=0)` and `counts * np.log(len(docs) / df)`.
```

## Challenge: cosine similarity

```python exercise id=cosine-sim title="Cosine similarity of two vectors"
import numpy as np

# TODO: `cosine(u, v)` returns the cosine of the angle between two vectors: their dot product divided by the product of
# their lengths. If either vector has zero length, return 0.0.
def cosine(u, v):
    ...
--- solution
import numpy as np

def cosine(u, v):
    u = np.asarray(u, dtype=float)
    v = np.asarray(v, dtype=float)
    nu, nv = np.linalg.norm(u), np.linalg.norm(v)
    if nu == 0 or nv == 0:
        return 0.0
    return float(u @ v / (nu * nv))
--- test
result = cosine([1.0, 0.0], [1.0, 1.0])
assert result is not None, "Replace the `...` in `cosine` with code that returns the similarity."
assert abs(result - 1 / np.sqrt(2)) < 1e-9, f"The angle between [1, 0] and [1, 1] is 45 degrees, so the cosine is 0.707, but you returned {result!r}."
assert abs(cosine([2.0, 0.0], [5.0, 0.0]) - 1.0) < 1e-9, "Parallel vectors have cosine 1, whatever their lengths."
assert cosine([0.0, 0.0], [1.0, 2.0]) == 0.0, "A zero vector has similarity 0 with everything."
--- hint
Dot product over the product of the two lengths, with `np.linalg.norm` for lengths.
--- hint
Guard against zero lengths before dividing.
```

## Debug the document frequency

This idf counts how many times a word appears, not how many documents contain it, so words repeated within one document are overweighted down.

```python debug id=df-counts title="Count documents, not occurrences"
import numpy as np

docs = ["spam spam spam", "ham eggs", "ham"]
counts = np.array([[3.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]])
df = counts.sum(axis=0)                    # bug: this sums occurrences, not documents
print("document frequency:", df)
--- solution
import numpy as np

docs = ["spam spam spam", "ham eggs", "ham"]
counts = np.array([[3.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]])
df = (counts > 0).sum(axis=0)
print("document frequency:", df)
--- test
assert list(df) == [1, 1, 1], f"Each word appears in exactly one document, so the document frequencies are [1, 1, 1], but the code gives {list(df)}. Count documents where the count is positive."
--- hint
Summing counts adds up occurrences. A document frequency asks only whether the word is present.
--- hint
`(counts > 0).sum(axis=0)`.
```

## Predict the weight

```python predict id=predict-idf title="What is the idf of a word that appears in every document?"
import numpy as np
N = 5
df = 5
print(round(float(np.log(N / df)), 3))
--- options
* 0.0
1.609
5.0
-1.0
--- explain
When a word is in every document, N divided by df is one, and log of one is zero. Such a word carries no information for telling documents apart.
```

## Recap

- A bag of words counts each vocabulary word per document and discards order.
- The inverse document frequency downweights words that appear everywhere and rewards rare, distinctive ones.
- TF-IDF multiplies the counts by idf, and its cosine similarity is a strong baseline for search.
- Fit idf on training documents only.

**Up next:** tokenization in more depth, including n-grams and the choices behind every token.
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_1_3', 'sec_nlp_with_transformers_1', 'crs_nlp_with_transformers', 'Tokenization: words, punctuation and n-grams', 'interactive', 2, 960, NULL, NULL, 'Every representation starts with tokens, and the choices behind tokenization shape everything after it. Should "Don''t" be one token or two? Should punctuation count? Should "running" and "run" be related? Two more ideas extend single tokens: **n-grams** keep short sequences of neighbouring words, which recovers some order, and **subword** units handle words the vocabulary has never seen.

## Normalizing text

Normalization makes different surface forms equal. Common steps are lowercasing, removing accents or punctuation, and collapsing whitespace. Each step throws away information, so choose it for the task.

```python run
import re

raw = "  The  COMPANY''s   results,  Q3-2026!  "
normalized = re.sub(r"\s+", " ", raw).strip().lower()
print(repr(normalized))
print(re.findall(r"[a-z0-9]+", normalized))
```

The apostrophe split "company''s" into "company" and "s", which may or may not be what you want. A tokenizer is a policy, not a fact.

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

> **Pitfall:** the same word can tokenize differently in different contexts, and a tokenizer trained on one domain may split another domain''s words badly. Check token counts on your real data.

> **In the wild:** Hugging Face tokenizers for BERT use WordPiece, a subword scheme close to BPE, with special tokens such as [CLS] and [SEP] added around each input.

A simple regular expression already shows the choices a tokenizer makes: where words split, and what happens to punctuation.

```python run
import re
sample = "Don''t stop-start tokens!"
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
assert result == ["q3", "results", "in", "2026"], f"Expected [''q3'', ''results'', ''in'', ''2026''], but you returned {result}."
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
assert found == ["and"], f"The text contains ''And'', which is the stop word ''and'' after normalization, but the code found {found}. Lowercase the text before matching."
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
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_2_1', 'sec_nlp_with_transformers_2', 'crs_nlp_with_transformers', 'Word embeddings from co-occurrence', 'interactive', 0, 1200, NULL, NULL, 'Words that appear in similar contexts tend to have similar meanings. "Cat" and "dog" both appear near "pet", "feed" and "vet"; "car" appears near "engine" and "road". Word embeddings turn that observation into vectors: words with similar contexts get similar vectors. The classic recipe needs no neural network. Count how often words co-occur, reweight the counts so that surprising pairs stand out, and compress the result with a singular value decomposition.

## Co-occurrence counts

Slide a window over each sentence and count which words appear near each other.

```python run
import numpy as np

corpus = [
    "the cat drinks milk", "the dog drinks water", "the cat eats fish",
    "the dog eats meat", "the car needs fuel", "the car needs oil",
    "the truck needs fuel", "a cat and a dog", "the engine needs oil",
]
vocab = sorted({w for s in corpus for w in s.split()})
index = {w: i for i, w in enumerate(vocab)}
C = np.zeros((len(vocab), len(vocab)))
window = 2
for s in corpus:
    words = s.split()
    for i, w in enumerate(words):
        for j in range(max(0, i - window), min(len(words), i + window + 1)):
            if j != i:
                C[index[w], index[words[j]]] += 1
print("vocabulary size:", len(vocab))
print("co-occurrences of ''cat'' with:", {vocab[j]: int(C[index["cat"], j]) for j in np.nonzero(C[index["cat"]])[0]})
```

Raw counts favour frequent words such as "the", which co-occur with everything. The next step fixes that.

## Positive pointwise mutual information

Pointwise mutual information compares how often two words co-occur with how often they would by chance. Its positive part (PPMI) keeps only the informative associations:

$$
\operatorname{PPMI}(w, c) = \max\!\left(0, \log \frac{p(w, c)}{p(w)\, p(c)}\right)
$$

```python run
total = C.sum()
p_wc = C / total
p_w = p_wc.sum(axis=1, keepdims=True)
p_c = p_wc.sum(axis=0, keepdims=True)
with np.errstate(divide="ignore", invalid="ignore"):
    pmi = np.log(p_wc / (p_w * p_c))
PPMI = np.where(np.isfinite(pmi), np.maximum(pmi, 0), 0)
print("PPMI of ''cat'' with ''drinks'':", round(PPMI[index["cat"], index["drinks"]], 3))
print("PPMI of ''cat'' with ''the'':", round(PPMI[index["cat"], index["the"]], 3))
```

The association between "cat" and "drinks" is strong. Its association with "the" is weak, because "the" co-occurs with everything.

## Compress with an SVD

A singular value decomposition factors the PPMI matrix into directions ranked by importance. Keeping the top $d$ directions gives dense embeddings of $d$ numbers per word.

```python run
U, S, Vt = np.linalg.svd(PPMI)
d = 3
E = U[:, :d] * np.sqrt(S[:d])
def neighbours(word, k=3):
    v = E[index[word]]
    sims = E @ v / (np.linalg.norm(E, axis=1) * np.linalg.norm(v) + 1e-12)
    order = [i for i in np.argsort(-sims) if vocab[i] != word]
    return [(vocab[i], round(float(sims[i]), 2)) for i in order[:k]]

print("nearest to ''cat'':", neighbours("cat"))
print("nearest to ''car'':", neighbours("car"))
```

Words that share contexts end up close together, so animals cluster with animals and vehicles with vehicles, even though nobody labelled them.

> **Pitfall:** embeddings learned from a small corpus reflect that corpus. Two words may be close only because they share a quirk of the text, not because they mean the same thing.

> **In the wild:** word2vec, GloVe and the input embedding tables of modern transformers all learn vectors from co-occurrence statistics of this kind.

Cosine similarity compares the directions of two vectors and ignores their lengths. Normalizing each row to unit length turns one matrix product into a table of similarities.

```python run
import numpy as np
vecs = np.array([[0.9, 0.8], [0.85, 0.9], [0.1, 0.2]])
unit = vecs / np.linalg.norm(vecs, axis=1, keepdims=True)
print(np.round(unit @ unit.T, 3))
```

## Challenge: PPMI

```python exercise id=ppmi-matrix title="Positive pointwise mutual information"
import numpy as np

# TODO: `ppmi(C)` takes a non-negative co-occurrence matrix and returns its positive PMI: with total = sum of all counts,
# p(w, c) = C / total, p(w) and p(c) the row and column sums of p, the value max(0, log(p(w,c) / (p(w) p(c)))).
# Entries where C is zero are 0.
def ppmi(C):
    ...
--- solution
import numpy as np

def ppmi(C):
    C = np.asarray(C, dtype=float)
    total = C.sum()
    p_wc = C / total
    p_w = p_wc.sum(axis=1, keepdims=True)
    p_c = p_wc.sum(axis=0, keepdims=True)
    with np.errstate(divide="ignore", invalid="ignore"):
        pmi = np.log(p_wc / (p_w * p_c))
    return np.where(np.isfinite(pmi), np.maximum(pmi, 0), 0)
--- test
import numpy as np
result = ppmi(np.array([[2.0, 0.0], [0.0, 2.0]]))
assert result is not None, "Replace the `...` in `ppmi` with code that returns the matrix."
assert result.shape == (2, 2), "The output has the same shape as the input."
assert np.allclose(result, [[np.log(2), 0.0], [0.0, np.log(2)]]), f"Each diagonal pair has p = 0.5 against p(w)p(c) = 0.25, so the value is log 2, and the zeros stay zero. You returned {result}."
assert np.all(result >= 0), "PPMI is never negative."
--- hint
Divide by the total to get probabilities, then the row and column marginals. Use `np.log` and clip the negative values to zero.
--- hint
`np.maximum(np.log(p_wc / (p_w * p_c)), 0)`, with zero entries handled so they do not produce infinities.
```

## Challenge: embeddings from an SVD

```python exercise id=svd-embed title="Dense embeddings from a matrix"
import numpy as np

# TODO: `svd_embeddings(M, d)` returns the d-dimensional embeddings of the rows of M: the first d left singular vectors,
# each column multiplied by the square root of its singular value.
def svd_embeddings(M, d):
    ...
--- solution
import numpy as np

def svd_embeddings(M, d):
    U, S, _ = np.linalg.svd(np.asarray(M, dtype=float))
    return U[:, :d] * np.sqrt(S[:d])
--- test
import numpy as np
result = svd_embeddings(np.diag([4.0, 1.0]), 2)
assert result is not None, "Replace the `...` in `svd_embeddings` with code that returns the embeddings."
assert result.shape == (2, 2), "Two rows with two dimensions give shape (2, 2)."
assert np.allclose(np.abs(result), [[2.0, 0.0], [0.0, 1.0]]), f"The singular values 4 and 1 give square roots 2 and 1 along the axes, but you returned {result}. Signs of singular vectors may differ, so compare absolute values."
--- hint
Use `np.linalg.svd(M)` and keep the first d columns of U, scaled by the square roots of the first d singular values.
--- hint
`U[:, :d] * np.sqrt(S[:d])`.
```

## Debug the probabilities

This PPMI uses the raw counts where it should use probabilities, so the values are not comparable across matrices of different sizes.

```python debug id=raw-counts title="Use probabilities, not raw counts"
import numpy as np

C = np.array([[2.0, 0.0], [0.0, 2.0]])
row = C.sum(axis=1, keepdims=True)
col = C.sum(axis=0, keepdims=True)
pmi = np.log(C / (row * col))               # bug: the ratio uses counts, not probabilities
print("pmi:", np.round(pmi, 3))
--- solution
import numpy as np

C = np.array([[2.0, 0.0], [0.0, 2.0]])
p_wc = C / C.sum()
p_w = p_wc.sum(axis=1, keepdims=True)
p_c = p_wc.sum(axis=0, keepdims=True)
pmi = np.log(p_wc / (p_w * p_c))
print("pmi:", np.round(pmi, 3))
--- test
assert abs(pmi[0, 0] - np.log(2)) < 1e-9, f"The diagonal PMI should be log 2 ≈ 0.693 with probabilities, but the code gives {pmi[0, 0]:.3f}. Divide the counts by the total first."
--- hint
PMI compares joint probabilities with products of marginal probabilities, so every term must be a probability.
--- hint
Divide `C` by `C.sum()` before computing the marginals.
```

## Predict the value

```python predict id=predict-ppmi title="What is the PPMI for a pair that never co-occurs?"
import numpy as np
print(max(0.0, 0.0))
--- options
* 0.0
1.0
-1.0
log 2
--- explain
A pair with zero co-occurrence has no positive association, and the PPMI is clipped at zero. Negative association is discarded by design.
```

## Recap

- Words in similar contexts get similar vectors, which is the distributional hypothesis.
- PPMI reweights co-occurrence counts so that informative pairs stand out and frequent words do not dominate.
- An SVD compresses the PPMI matrix into dense embeddings with a chosen number of dimensions.
- Embeddings reflect their training corpus, so check the neighbours you get.

**Up next:** sentence embeddings, which combine word vectors into one vector per text and compare texts with cosine similarity.
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_2_2', 'sec_nlp_with_transformers_2', 'crs_nlp_with_transformers', 'Sentence embeddings and cosine similarity', 'interactive', 1, 960, NULL, NULL, 'Most NLP tasks need one vector per text, not one per word. The simplest way to get it is to average the vectors of the words in the text. Averaging throws away order, which is a loss, but it is fast, surprisingly effective and the foundation of many systems. To compare two texts you then need a similarity, and cosine similarity is the standard choice, because it measures direction rather than length.

## Averaging word vectors

```python run
import numpy as np

word_vectors = {
    "cat": np.array([0.9, 0.1]), "dog": np.array([0.8, 0.2]),
    "car": np.array([0.1, 0.9]), "road": np.array([0.2, 0.8]),
}

def sentence_vector(tokens, vectors):
    known = [vectors[t] for t in tokens if t in vectors]
    if not known:
        return np.zeros(2)
    return np.mean(known, axis=0)

print("''cat dog'':", sentence_vector(["cat", "dog"], word_vectors))
print("''the cat road'':", sentence_vector(["the", "cat", "road"], word_vectors))
```

Unknown words such as "the" are skipped, because they have no vector. Averaging then gives the sentence a position in the space of meanings.

## Cosine similarity

The cosine of the angle between two vectors is 1 when they point the same way, 0 when they are unrelated, and -1 when opposite. It ignores length, so a long document and a short one about the same topic still match.

```python run
def cosine(u, v):
    return float(u @ v / (np.linalg.norm(u) * np.linalg.norm(v)))

animal = sentence_vector(["cat", "dog"], word_vectors)
vehicle = sentence_vector(["car", "road"], word_vectors)
query = sentence_vector(["dog", "cat", "cat"], word_vectors)
print("query vs animal:", round(cosine(query, animal), 3))
print("query vs vehicle:", round(cosine(query, vehicle), 3))
```

A query about animals matches the animal sentence far better than the vehicle sentence.

## Normalize, then dot

If every vector is scaled to unit length, the dot product equals the cosine. Many systems normalize once, store the vectors, and then compare with fast dot products.

```python run
def normalize_rows(M):
    norms = np.linalg.norm(M, axis=1, keepdims=True)
    return np.divide(M, norms, out=np.zeros_like(M), where=norms > 0)

docs = np.stack([animal, vehicle])
unit = normalize_rows(docs)
print("unit lengths:", np.round(np.linalg.norm(unit, axis=1), 6))
print("dot product equals cosine:", np.isclose(unit[0] @ normalize_rows(query[None])[0], cosine(query, animal)))
```

> **Pitfall:** averaging gives long texts and short texts vectors of similar length, but a single very common word can still dominate. Remove stop words or weight words by TF-IDF when that matters.

> **In the wild:** sentence-embedding models produce one vector per sentence directly, trained so that cosine similarity reflects meaning. The comparison step is identical to the one here.

Two vectors that point the same way have cosine similarity one, however long they are. An unrelated vector scores near zero.

```python run
import numpy as np
v_a = np.array([1.0, 2.0, 0.0])
v_b = np.array([2.0, 4.0, 0.0])
v_c = np.array([0.0, 0.0, 1.0])
def cosine(u, v):
    return float(u @ v / (np.linalg.norm(u) * np.linalg.norm(v)))
print(round(cosine(v_a, v_b), 3), round(cosine(v_a, v_c), 3))
```

## Challenge: sentence vector

```python exercise id=sentence-vec title="Average the known word vectors"
import numpy as np

# TODO: `sentence_vector(tokens, vectors)` returns the mean of the vectors (a dictionary from word to array) of the
# tokens that appear in `vectors`, skipping the others. If no token is known, return a zero vector of the same length
# as any stored vector.
def sentence_vector(tokens, vectors):
    ...
--- solution
import numpy as np

def sentence_vector(tokens, vectors):
    known = [vectors[t] for t in tokens if t in vectors]
    if not known:
        size = len(next(iter(vectors.values())))
        return np.zeros(size)
    return np.mean(known, axis=0)
--- test
import numpy as np
vecs = {"a": np.array([1.0, 0.0]), "b": np.array([0.0, 1.0])}
result = sentence_vector(["a", "b", "zzz"], vecs)
assert result is not None, "Replace the `...` in `sentence_vector` with code that returns the average."
assert np.allclose(result, [0.5, 0.5]), f"The known words are a and b, whose average is [0.5, 0.5], but you returned {result}."
assert np.allclose(sentence_vector(["zzz"], vecs), [0.0, 0.0]), "If no token is known, the result is a zero vector of the right size."
--- hint
Collect the vectors of the known tokens into a list, then average them with `np.mean(..., axis=0)`.
--- hint
`known = [vectors[t] for t in tokens if t in vectors]`.
```

## Challenge: normalize rows

```python exercise id=norm-rows title="Scale rows to unit length"
import numpy as np

# TODO: `normalize_rows(M)` returns a copy of the 2-D array M in which each row is divided by its length (Euclidean norm).
# Rows that are all zero stay zero.
def normalize_rows(M):
    ...
--- solution
import numpy as np

def normalize_rows(M):
    M = np.asarray(M, dtype=float)
    norms = np.linalg.norm(M, axis=1, keepdims=True)
    return np.divide(M, norms, out=np.zeros_like(M), where=norms > 0)
--- test
import numpy as np
result = normalize_rows(np.array([[3.0, 4.0], [0.0, 0.0]]))
assert result is not None, "Replace the `...` in `normalize_rows` with code that returns the normalized rows."
assert np.allclose(result[0], [0.6, 0.8]), f"[3, 4] has length 5, so its unit vector is [0.6, 0.8], but you returned {result[0]}."
assert np.allclose(result[1], [0.0, 0.0]), "A zero row stays zero, without a division error."
assert np.allclose(np.linalg.norm(result[0]), 1.0), "The normalized row has length one."
--- hint
Divide each row by its norm, computed with `np.linalg.norm(M, axis=1, keepdims=True)`. Guard the zero rows.
--- hint
`np.divide(M, norms, out=np.zeros_like(M), where=norms > 0)`.
```

## Debug the normalization

This normalization divides each row by its sum, not its length, so the rows do not have unit length.

```python debug id=sum-not-length title="Divide by the length, not the sum"
import numpy as np

M = np.array([[3.0, 4.0]])
unit = M / M.sum(axis=1, keepdims=True)        # bug: the sum is not the length
print("length of the result:", np.round(np.linalg.norm(unit), 3))
--- solution
import numpy as np

M = np.array([[3.0, 4.0]])
unit = M / np.linalg.norm(M, axis=1, keepdims=True)
print("length of the result:", np.round(np.linalg.norm(unit), 3))
--- test
assert abs(np.linalg.norm(unit) - 1.0) < 1e-9, f"A unit vector has length one, but this one has length {np.linalg.norm(unit):.3f}. Divide by the Euclidean norm, not the sum."
--- hint
The length of a vector is the square root of the sum of its squares, not its sum.
--- hint
Use `np.linalg.norm(M, axis=1, keepdims=True)`.
```

## Predict the similarity

```python predict id=predict-cos title="What is the cosine similarity of two vectors that point the same way?"
import numpy as np
u = np.array([2.0, 0.0])
v = np.array([5.0, 0.0])
print(round(float(u @ v / (np.linalg.norm(u) * np.linalg.norm(v))), 1))
--- options
* 1.0
0.0
-1.0
0.5
--- explain
The vectors point in the same direction, so the angle is zero and the cosine is one, whatever their lengths.
```

## Recap

- A sentence vector is the average of its known word vectors, which discards order but is fast and effective.
- Cosine similarity compares direction, so it is insensitive to length.
- Normalize vectors once, and comparisons become dot products.
- Averaging lets common words dominate, so weight or filter them when that matters.

**Up next:** semantic search, which ranks documents by these similarities and evaluates the ranking.
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_2_3', 'sec_nlp_with_transformers_2', 'crs_nlp_with_transformers', 'Semantic search and ranking', 'interactive', 2, 1080, NULL, NULL, 'Search is ranking. Given a query, return the documents most likely to be useful, in order. Keyword search only finds documents that share words with the query. Semantic search embeds the query and the documents in the same space and ranks them by similarity, so a query about "automobile repairs" can find a document about "car servicing". Ranking is also where evaluation gets interesting, because the quality you care about is the position of the right answer.

## Ranking by similarity

```python run
import numpy as np

docs = {
    "engine oil guide": np.array([0.1, 0.9, 0.1]),
    "cat food reviews": np.array([0.9, 0.1, 0.0]),
    "car service costs": np.array([0.2, 0.8, 0.3]),
    "dog walking tips": np.array([0.8, 0.0, 0.2]),
}
query = np.array([0.15, 0.85, 0.2])                # "how much does a car service cost"

def rank(query, docs):
    names = list(docs)
    M = np.stack([docs[n] for n in names])
    sims = M @ query / (np.linalg.norm(M, axis=1) * np.linalg.norm(query))
    order = np.argsort(-sims)
    return [(names[i], round(float(sims[i]), 3)) for i in order]

for name, score in rank(query, docs):
    print(f"{score:6.3f}  {name}")
```

The two car-related documents come first. Neither needed to share a single word with the query beyond what the embeddings captured.

## Top-k and what the user sees

Users read the first few results. A search system is judged on whether the right document appears near the top, often in the first ten.

```python run
ranking = [n for n, _ in rank(query, docs)]
relevant = {"car service costs"}
top2 = ranking[:2]
print("top two results:", top2)
print("relevant document shown in top two:", bool(relevant & set(top2)))
```

## Reciprocal rank

The **reciprocal rank** of a query is one divided by the position of the first relevant result. A relevant result first scores 1, second scores 1/2, and so on. Averaged over many queries, it is the mean reciprocal rank (MRR), which rewards putting the right answer high.

```python run
rankings = [
    ["car service costs", "engine oil guide"],
    ["dog walking tips", "cat food reviews", "car service costs"],
    ["engine oil guide", "car service costs"],
]
rr = [1.0 / (r.index("car service costs") + 1) for r in rankings]
print("reciprocal ranks:", [round(x, 3) for x in rr])
print("mean reciprocal rank:", round(float(np.mean(rr)), 3))
```

> **Pitfall:** evaluate search with queries and relevance judgements that were not used to tune the embeddings. A system tuned on its own test queries will look better than it is.

> **In the wild:** production search combines embedding similarity with keyword matching and a reranker, and it is measured with MRR, recall at k and user engagement.

Ranking a search is a sort by score, highest first. The top result is the document most similar to the query.

```python run
import numpy as np
doc_scores = np.array([0.2, 0.9, 0.5, 0.7])
order = np.argsort(-doc_scores)
print("ranking:", order, "| top score:", doc_scores[order[0]])
```

## Challenge: rank documents

```python exercise id=rank-docs title="Rank documents by cosine similarity"
import numpy as np

# TODO: `rank_documents(query, D)` takes a query vector and a 2-D array D with one document vector per row. Return the
# row indices of D sorted from most to least similar to the query, by cosine similarity. Ties keep the original order.
def rank_documents(query, D):
    ...
--- solution
import numpy as np

def rank_documents(query, D):
    query = np.asarray(query, dtype=float)
    D = np.asarray(D, dtype=float)
    sims = D @ query / (np.linalg.norm(D, axis=1) * np.linalg.norm(query))
    return list(np.argsort(-sims, kind="stable"))
--- test
import numpy as np
D = np.array([[1.0, 0.0], [0.0, 1.0], [1.0, 1.0]])
result = rank_documents(np.array([1.0, 0.1]), D)
assert result is not None, "Replace the `...` in `rank_documents` with code that returns the ordering."
assert list(result) == [0, 2, 1], f"The query is closest to document 0, then document 2, then document 1, so the order is [0, 2, 1], but you returned {list(result)}."
assert list(rank_documents(np.array([0.0, 1.0]), np.array([[1.0, 0.0], [1.0, 0.0]]))) == [0, 1], "Ties keep the original order."
--- hint
Compute the cosine similarity of the query with every row, then sort the indices by decreasing similarity. `np.argsort` on the negated scores does that.
--- hint
`np.argsort(-sims, kind="stable")`.
```

## Challenge: reciprocal rank

```python exercise id=reciprocal-rank title="Reciprocal rank of the first relevant result"
# TODO: `reciprocal_rank(ranking, relevant)` returns 1 divided by the position (starting at 1) of the first item in
# `ranking` that is in the set `relevant`. If no item is relevant, return 0.0.
def reciprocal_rank(ranking, relevant):
    ...
--- solution
def reciprocal_rank(ranking, relevant):
    for position, item in enumerate(ranking, start=1):
        if item in relevant:
            return 1.0 / position
    return 0.0
--- test
result = reciprocal_rank(["a", "b", "c"], {"b", "c"})
assert result is not None, "Replace the `...` in `reciprocal_rank` with code that returns the value."
assert abs(result - 0.5) < 1e-9, f"The first relevant item is ''b'' at position 2, so the reciprocal rank is 0.5, but you returned {result!r}."
assert reciprocal_rank(["a"], {"a"}) == 1.0, "A relevant first item gives 1."
assert reciprocal_rank(["a", "b"], {"z"}) == 0.0, "No relevant item gives 0."
--- hint
Walk through the ranking with `enumerate(ranking, start=1)` and stop at the first relevant item.
--- hint
Return `1.0 / position` as soon as you find a relevant item.
```

## Debug the ranking order

This ranking is meant to put the most similar documents first, but it sorts the scores in ascending order, so the least similar come first.

```python debug id=ascending-rank title="Most similar first"
import numpy as np

sims = np.array([0.2, 0.9, 0.5])
order = np.argsort(sims)                  # bug: ascending order puts the weakest match first
print("ranking:", order)
--- solution
import numpy as np

sims = np.array([0.2, 0.9, 0.5])
order = np.argsort(-sims)
print("ranking:", order)
--- test
assert list(order) == [1, 2, 0], f"The most similar document is index 1, then 2, then 0, but the ranking is {list(order)}. Sort in decreasing order of similarity."
--- hint
Smaller similarities should come later, not earlier.
--- hint
Sort the negated scores, `np.argsort(-sims)`.
```

## Predict the reciprocal rank

```python predict id=predict-rr title="What is the reciprocal rank when the relevant item is third?"
print(round(1 / 3, 3))
--- options
* 0.333
0.5
1.0
0.0
--- explain
The reciprocal rank is one divided by the position. Position three gives one third.
```

## Recap

- Semantic search ranks documents by the similarity of their embeddings to the query.
- Users see the top results, so evaluate the position of the right answer, not only whether it appears.
- Reciprocal rank rewards placing the first relevant document high, and MRR averages it over queries.
- Keep the evaluation queries separate from anything used to tune the system.

**Checkpoint:** the quiz below covers representations and search. Then the course moves to fine-tuning encoders.
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_2_4', 'sec_nlp_with_transformers_2', 'crs_nlp_with_transformers', 'Checkpoint: text representations and search', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why does TF-IDF give almost zero weight to the word ''the'' in a collection of English documents?","options":["Because ''the'' is always removed by the tokenizer","Because ''the'' appears in nearly every document, so its inverse document frequency is near zero","Because counts of ''the'' are always zero","Because TF-IDF only uses nouns"],"answerIndex":1,"explanation":"A word in almost every document has a document frequency close to N, so log(N / df) is close to zero."},{"id":"q2","prompt":"Why is PPMI clipped at zero?","options":["Because negative counts are impossible","Because negative association is unreliable with sparse counts, and the positive part captures the informative pairs","Because the SVD requires non-negative inputs only","Because zero is the most common value"],"answerIndex":1,"explanation":"Co-occurrence counts are too sparse to estimate negative association reliably, so PPMI keeps only the positive part."},{"id":"q3","prompt":"Why is cosine similarity preferred to Euclidean distance for comparing text vectors?","options":["It is faster to compute on any vector","It compares direction and ignores length, so a long and a short text about the same topic still match","Euclidean distance cannot be computed for text","Cosine always returns integers"],"answerIndex":1,"explanation":"Text vectors often differ in magnitude because of length, and cosine focuses on the direction that carries the topic."},{"id":"q4","prompt":"A search system returns the relevant document in position 4 for a query. What is its reciprocal rank?","options":["4","0.25","0.5","1.0"],"answerIndex":1,"explanation":"The reciprocal rank is one divided by the position, so one quarter."},{"id":"q5","prompt":"Why should search queries used for evaluation be kept separate from those used to tune the system?","options":["Because tuning queries are always wrong","Because a system tuned on its own test queries looks better on them than it really is","Because evaluation queries must be longer","Because the ranking must be random during evaluation"],"answerIndex":1,"explanation":"Tuning on the evaluation queries fits the system to them, so the measured quality is optimistic."}]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_3_1', 'sec_nlp_with_transformers_3', 'crs_nlp_with_transformers', 'Masked language models and BERT', 'interactive', 0, 1080, NULL, NULL, 'An encoder such as BERT learns from text by hiding some of it. During pretraining, a fraction of the tokens are replaced by a special [MASK] token, and the model must predict the originals from the words around them on both sides. That objective, **masked language modelling**, forces the model to use context in both directions, and it turns unlabelled text into a rich training signal. Afterwards, the pretrained encoder is reused for many tasks.

## Masking tokens

```python run
import numpy as np

tokens = ["the", "delivery", "arrived", "late", "and", "the", "box", "was", "damaged"]
rng = np.random.default_rng(3)
n_mask = max(1, int(round(0.15 * len(tokens))))
positions = rng.choice(len(tokens), size=n_mask, replace=False)
masked = [("[MASK]" if i in positions else t) for i, t in enumerate(tokens)]
print("original:", " ".join(tokens))
print("masked:  ", " ".join(masked))
print("the model must recover:", [tokens[i] for i in sorted(positions)])
```

Masking about one token in seven gives a clear prediction task without hiding so much that the sentence becomes meaningless.

## Why both sides matter

A model that reads only the left context cannot use words that come after the gap. In the example below the missing word is determined by the word after it.

```python run
corpus = "the cat sat on the mat . the dog sat on the rug . the cat lay on the mat".split()
left_only = {}
both_sides = {}
for i in range(1, len(corpus) - 1):
    key_left = corpus[i - 1]
    key_both = (corpus[i - 1], corpus[i + 1])
    left_only.setdefault(key_left, []).append(corpus[i])
    both_sides.setdefault(key_both, []).append(corpus[i])
print("guess after ''the'' alone:", sorted(set(left_only["the"])))
print("guess for ''on _ mat'':", sorted(set(both_sides[("on", "mat")])))
```

Knowing "on _ mat" narrows the answer to words that fit both sides. This is why BERT reads the whole sequence at once.

## Special tokens

BERT-style inputs wrap the text in special tokens: [CLS] at the start, which later serves as a summary of the sequence, and [SEP] between segments. Segment ids tell the model which segment each token belongs to.

```python run
segment_a = ["the", "box", "was", "damaged"]
segment_b = ["it", "was", "replaced"]
input_tokens = ["[CLS]"] + segment_a + ["[SEP]"] + segment_b + ["[SEP]"]
segment_ids = [0] * (len(segment_a) + 2) + [1] * (len(segment_b) + 1)
print(list(zip(input_tokens, segment_ids)))
```

> **Pitfall:** the 15% masking rate is a choice. A model pretrained with too little masking learns little per sentence, and too much leaves too little context to predict from.

> **In the wild:** BERT and its descendants are pretrained on large corpora with this objective. Fine-tuning then adds a small head on top for each task, which the next lessons cover.

Masking is random. A fixed seed makes the choice of masked positions reproducible, which matters when comparing training runs.

```python run
import numpy as np
mask_rng = np.random.default_rng(5)
tokens_m = ["the", "box", "was", "damaged"]
masked_here = mask_rng.random(len(tokens_m)) < 0.5
print("masked positions:", np.nonzero(masked_here)[0])
```

## Challenge: mask positions

```python exercise id=mask-positions title="Replace positions with a mask token"
# TODO: `mask_tokens(tokens, positions, mask_token)` returns a new list with the tokens at the given positions replaced by
# mask_token. The input list must not change.
def mask_tokens(tokens, positions, mask_token):
    ...
--- solution
def mask_tokens(tokens, positions, mask_token):
    out = list(tokens)
    for p in positions:
        out[p] = mask_token
    return out
--- test
tokens = ["a", "b", "c"]
result = mask_tokens(tokens, [1], "[MASK]")
assert result is not None, "Replace the `...` in `mask_tokens` with code that returns the masked list."
assert result == ["a", "[MASK]", "c"], f"Position 1 should hold the mask, giving [''a'', ''[MASK]'', ''c''], but you returned {result}."
assert tokens == ["a", "b", "c"], "The input list must not change."
assert mask_tokens(["x"], [], "[MASK]") == ["x"], "No positions means no change."
--- hint
Copy the list first so the input is not changed, then assign the mask token at each position.
--- hint
`out = list(tokens)` and then `out[p] = mask_token` in a loop.
```

## Challenge: masked mean pooling

```python exercise id=masked-mean title="Mean over the real tokens only"
import numpy as np

# TODO: `masked_mean(H, mask)` takes a (tokens, features) array H and a 0/1 array mask of length tokens. It returns the mean
# of the rows of H where mask is 1. Rows with mask 0 (padding) must not contribute.
def masked_mean(H, mask):
    ...
--- solution
import numpy as np

def masked_mean(H, mask):
    H = np.asarray(H, dtype=float)
    mask = np.asarray(mask, dtype=float)
    return (H * mask[:, None]).sum(axis=0) / mask.sum()
--- test
import numpy as np
H = np.array([[1.0, 1.0], [3.0, 3.0], [100.0, 100.0]])
result = masked_mean(H, [1, 1, 0])
assert result is not None, "Replace the `...` in `masked_mean` with code that returns the pooled vector."
assert np.allclose(result, [2.0, 2.0]), f"Only the first two rows are real, so the mean is [2, 2], but you returned {result}. The padding row must not count."
assert np.allclose(masked_mean(H, [0, 0, 1]), [100.0, 100.0]), "With only one real token the pooled vector is that token."
--- hint
Multiply each row by its mask value, sum over the tokens, and divide by the number of real tokens, which is the sum of the mask.
--- hint
`(H * mask[:, None]).sum(axis=0) / mask.sum()`.
```

## Debug the pooling

This pooled vector is meant to average only the real tokens, but it averages padding too, so the long padded sequence is diluted.

```python debug id=pool-padding title="Pool over real tokens only"
import numpy as np

H = np.array([[1.0, 1.0], [3.0, 3.0], [0.0, 0.0], [0.0, 0.0]])
mask = np.array([1, 1, 0, 0])
pooled = H.mean(axis=0)                # bug: includes the padding rows
print("pooled:", pooled)
--- solution
import numpy as np

H = np.array([[1.0, 1.0], [3.0, 3.0], [0.0, 0.0], [0.0, 0.0]])
mask = np.array([1, 1, 0, 0])
pooled = (H * mask[:, None]).sum(axis=0) / mask.sum()
print("pooled:", pooled)
--- test
assert np.allclose(pooled, [2.0, 2.0]), f"The real tokens average to [2, 2], but the pooled vector is {pooled}. Exclude the padding rows."
--- hint
Padding rows have mask 0 and should contribute nothing to the sum or the count.
--- hint
Weight each row by the mask before summing, and divide by `mask.sum()`.
```

## Predict the masked count

```python predict id=predict-mask title="How many tokens are masked in a 10-token sequence at a 15% rate?"
print(max(1, int(round(0.15 * 10))))
--- options
* 2
1
15
0
--- explain
Fifteen per cent of ten tokens is 1.5, which rounds to 2 under round-half-to-even, and the rule keeps at least one token masked.
```
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_3_2', 'sec_nlp_with_transformers_3', 'crs_nlp_with_transformers', 'Pooling and text classification', 'interactive', 1, 1080, NULL, NULL, 'Turning a pretrained encoder into a classifier needs two steps. **Pooling** reduces the per-token vectors to one vector for the whole text, and a small **classification head**, usually a linear layer followed by softmax, maps that vector to class probabilities. Only the head is new. During fine-tuning the encoder''s weights are adjusted too, but the mathematics of the head and of the loss is the same as in any multi-class classifier.

## Softmax over classes

```python run
import numpy as np

def softmax_rows(Z):
    e = np.exp(Z - Z.max(axis=1, keepdims=True))
    return e / e.sum(axis=1, keepdims=True)

logits = np.array([[2.0, 0.5, -1.0], [0.0, 0.0, 0.0]])
probs = softmax_rows(logits)
print(np.round(probs, 3))
print("rows sum to:", probs.sum(axis=1))
```

Equal logits give equal probabilities, one over the number of classes. That is the honest answer of an untrained head.

## A head on top of pooled vectors

The head is a weight matrix and a bias. Given pooled vectors for a batch of texts, it produces one row of logits per text.

```python run
rng = np.random.default_rng(0)
n_per_class, d = 20, 4
centres = np.array([[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0]])
X = np.vstack([c + rng.normal(0, 0.3, (n_per_class, d)) for c in centres])
y = np.repeat([0, 1, 2], n_per_class)
W = np.zeros((d, 3))
b = np.zeros(3)
for _ in range(300):
    P = softmax_rows(X @ W + b)
    G = P.copy()
    G[np.arange(len(y)), y] -= 1
    W -= 0.5 * X.T @ G / len(y)
    b -= 0.5 * G.mean(axis=0)
accuracy = np.mean(np.argmax(X @ W + b, axis=1) == y)
print("training accuracy of the head:", round(float(accuracy), 3))
```

The head learns to separate the three clusters. In real fine-tuning the pooled vectors come from the encoder, which is also updated.

## Cross-entropy

The loss for a batch is the average negative log probability of each text''s correct class. It is small when the head is confident and right, and large when it is confident and wrong.

```python run
P_demo = np.array([[0.7, 0.2, 0.1], [0.1, 0.8, 0.1]])
labels = np.array([0, 1])
loss = -np.mean(np.log(P_demo[np.arange(2), labels]))
print("cross-entropy:", round(float(loss), 4))
```

> **Pitfall:** pooling must respect padding. Averaging over padding positions makes a text''s representation depend on how much padding the batch needed, which changes predictions for the same text.

> **In the wild:** `AutoModelForSequenceClassification` in Hugging Face adds exactly this head on top of a pretrained encoder, and it pools the [CLS] token by default.

Mean pooling averages token vectors over the real tokens. A weight of one for each real token and zero for padding gives the same result with a single product.

```python run
import numpy as np
H = np.array([[1.0, 2.0], [3.0, 4.0], [9.0, 9.0]])
keep = np.array([1.0, 1.0, 0.0])
print("mean over real tokens:", (keep @ H) / keep.sum())
```

## Challenge: row softmax

```python exercise id=softmax-rows title="Softmax over each row"
import numpy as np

# TODO: `softmax_rows(Z)` returns the softmax of each row of the 2-D array Z, computed stably.
def softmax_rows(Z):
    ...
--- solution
import numpy as np

def softmax_rows(Z):
    Z = np.asarray(Z, dtype=float)
    e = np.exp(Z - Z.max(axis=1, keepdims=True))
    return e / e.sum(axis=1, keepdims=True)
--- test
import numpy as np
result = softmax_rows(np.array([[0.0, 0.0, 0.0], [1000.0, 1000.0, 0.0]]))
assert result is not None, "Replace the `...` in `softmax_rows` with code that returns the probabilities."
assert np.allclose(result[0], [1 / 3, 1 / 3, 1 / 3]), "Equal logits give equal probabilities."
assert np.allclose(result[1], [0.5, 0.5, 0.0], atol=1e-9), "Huge logits must not overflow. Subtract the row maximum first."
assert np.allclose(result.sum(axis=1), 1.0), "Each row sums to one."
--- hint
Subtract each row''s maximum before exponentiating, then divide by the row sums.
--- hint
`e = np.exp(Z - Z.max(axis=1, keepdims=True))` and `e / e.sum(axis=1, keepdims=True)`.
```

## Challenge: cross-entropy from probabilities

```python exercise id=ce-from-probs title="Average negative log probability of the correct class"
import numpy as np

# TODO: `cross_entropy_from_probs(P, y)` takes a (texts, classes) array of probabilities and an array of correct class
# indices. Return the mean of −log P[i, y_i] over the texts.
def cross_entropy_from_probs(P, y):
    ...
--- solution
import numpy as np

def cross_entropy_from_probs(P, y):
    P = np.asarray(P, dtype=float)
    y = np.asarray(y)
    return float(-np.mean(np.log(P[np.arange(len(y)), y])))
--- test
import numpy as np
result = cross_entropy_from_probs(np.array([[0.5, 0.5], [0.25, 0.75]]), [0, 1])
assert result is not None, "Replace the `...` in `cross_entropy_from_probs` with code that returns the loss."
expected = -(np.log(0.5) + np.log(0.75)) / 2
assert abs(result - expected) < 1e-9, f"The correct-class probabilities are 0.5 and 0.75, so the loss is {expected:.4f}, but you returned {result!r}."
assert abs(cross_entropy_from_probs(np.array([[1.0, 0.0]]), [0])) < 1e-9, "A certain correct prediction has zero loss."
--- hint
Pick the probability of the correct class in each row with fancy indexing, take the negative log, and average.
--- hint
`P[np.arange(len(y)), y]`.
```

## Debug the column

This loss is meant to use each text''s correct class, but it always reads the first class column.

```python debug id=wrong-column title="Read the correct class for each text"
import numpy as np

P = np.array([[0.1, 0.9], [0.8, 0.2]])
y = np.array([1, 0])
picked = P[:, 0]                       # bug: always the first class, not the correct one
print("picked:", picked)
--- solution
import numpy as np

P = np.array([[0.1, 0.9], [0.8, 0.2]])
y = np.array([1, 0])
picked = P[np.arange(len(y)), y]
print("picked:", picked)
--- test
assert np.allclose(picked, [0.9, 0.8]), f"The correct classes are 1 and 0, so the picked probabilities are [0.9, 0.8], but they are {picked}. Index each row by its own label."
--- hint
Each text has its own label, so the column changes from row to row.
--- hint
`P[np.arange(len(y)), y]` picks one entry per row.
```

## Predict the probability

```python predict id=predict-softmax title="What is the softmax probability of each class when all logits are zero and there are four classes?"
import numpy as np
z = np.zeros(4)
print(round(float(np.exp(z[0]) / np.exp(z).sum()), 2))
--- options
* 0.25
0.5
0.0
1.0
--- explain
With four equal logits every class has probability one quarter.
```
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_3_3', 'sec_nlp_with_transformers_3', 'crs_nlp_with_transformers', 'Named-entity recognition and span decoding', 'interactive', 2, 1080, NULL, NULL, 'Named-entity recognition finds the people, places, organizations and dates in a sentence. It is a sequence-labelling problem: every token receives a tag, and the tags are then grouped into **spans**. The common tagging scheme, BIO, marks the first token of each entity with B and the rest with I. Decoding BIO tags into spans is a small but exact procedure, and most NER errors that look like model errors are actually decoding or boundary errors.

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
assert result == [(0, 2, "PER"), (3, 4, "LOC")], f"The person spans tokens 0 and 1 and the location is token 3, so the spans are [(0, 2, ''PER''), (3, 4, ''LOC'')], but you returned {result}."
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
assert spans == [(0, 2, "PER")], f"The entity covers tokens 0 and 1, so with an exclusive end the span is (0, 2, ''PER''), but it is {spans}."
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
The non-outside tags are at positions 1 and 2, so the location span is (1, 3, ''LOC''). Its tokens are the two positions listed here.
```
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_3_4', 'sec_nlp_with_transformers_3', 'crs_nlp_with_transformers', 'Imbalanced classes and macro-F1', 'interactive', 3, 960, NULL, NULL, 'Real text datasets are usually imbalanced. Most support tickets are routine, most reviews are positive, and the rare class is often the one that matters most, such as urgent complaints or fraud reports. A classifier that always predicts the common class can score high accuracy and find nothing useful. Evaluation must therefore look at each class, and the standard summary for that is **macro-F1**, the average of the per-class F1 scores, where every class counts equally.

## Accuracy hides the rare class

```python run
import numpy as np

y_true = np.array([0] * 95 + [1] * 5)               # 95 routine tickets, 5 urgent ones
y_pred = np.zeros(100, dtype=int)                    # a model that always says "routine"
accuracy = np.mean(y_true == y_pred)
urgent_recall = np.sum((y_true == 1) & (y_pred == 1)) / np.sum(y_true == 1)
print("accuracy:", accuracy, "| urgent recall:", urgent_recall)
```

Ninety-five per cent accuracy, and not one urgent ticket found. The per-class numbers reveal the failure at once.

## Per-class F1

For each class, F1 combines its precision and recall. Averaging the per-class values gives every class the same weight, however large it is.

```python run
def f1_for_class(y_true, y_pred, c):
    tp = np.sum((y_pred == c) & (y_true == c))
    fp = np.sum((y_pred == c) & (y_true != c))
    fn = np.sum((y_pred != c) & (y_true == c))
    if tp == 0:
        return 0.0
    p, r = tp / (tp + fp), tp / (tp + fn)
    return 2 * p * r / (p + r)

f1_routine = f1_for_class(y_true, y_pred, 0)
f1_urgent = f1_for_class(y_true, y_pred, 1)
print("F1 routine:", round(f1_routine, 3), "| F1 urgent:", f1_urgent)
print("macro-F1:", round((f1_routine + f1_urgent) / 2, 3))
```

The routine class scores 0.97, the urgent class scores 0, and their average is 0.49. The average is far below what accuracy suggested, and the per-class scores show exactly where the failure is.

## Class weights

One way to make training attend to the rare class is to weight its errors more. Inverse-frequency weights make each class contribute equally to the loss on average.

```python run
classes, counts = np.unique(y_true, return_counts=True)
weights = len(y_true) / (len(classes) * counts)
print("class weights:", dict(zip(classes.tolist(), np.round(weights, 3).tolist())))
```

> **Pitfall:** balancing by oversampling the rare class must happen only on the training data. Duplicating rare examples before the split puts copies of the same text on both sides, which inflates every score.

> **In the wild:** support, moderation and fraud teams report macro-F1 and per-class recall because the classes they care about are usually the rare ones.

Accuracy hides the minority class. With 95 negatives and 5 positives, always predicting negative scores 95%, which is why per-class measures come first.

```python run
import numpy as np
y_imb = np.array([0] * 95 + [1] * 5)
print("always-negative accuracy:", round(float(np.mean(y_imb == 0)), 2))
```

## Challenge: macro-F1

```python exercise id=macro-f1 title="Macro-averaged F1"
import numpy as np

# TODO: `macro_f1(y_true, y_pred, classes)` returns the unweighted mean over `classes` of the per-class F1 score. The F1 of a
# class is 0 when it has no true positives.
def macro_f1(y_true, y_pred, classes):
    ...
--- solution
import numpy as np

def macro_f1(y_true, y_pred, classes):
    y_true = np.asarray(y_true)
    y_pred = np.asarray(y_pred)
    scores = []
    for c in classes:
        tp = np.sum((y_pred == c) & (y_true == c))
        fp = np.sum((y_pred == c) & (y_true != c))
        fn = np.sum((y_pred != c) & (y_true == c))
        if tp == 0:
            scores.append(0.0)
            continue
        p, r = tp / (tp + fp), tp / (tp + fn)
        scores.append(2 * p * r / (p + r))
    return float(np.mean(scores))
--- test
result = macro_f1([0, 0, 1, 1], [0, 1, 1, 1], [0, 1])
assert result is not None, "Replace the `...` in `macro_f1` with code that returns the score."
expected = (2 / 3 + 0.8) / 2
assert abs(result - expected) < 1e-9, f"Class 0 has F1 2/3 and class 1 has F1 0.8, so macro-F1 is {expected:.4f}, but you returned {result!r}."
assert macro_f1([0, 1], [0, 1], [0, 1]) == 1.0, "Perfect predictions give macro-F1 of one."
--- hint
Compute the F1 of each class separately with true positives, false positives and false negatives, then average the list.
--- hint
Keep a list of per-class scores and return `np.mean(scores)`.
```

## Challenge: inverse-frequency weights

```python exercise id=class-weights title="Inverse-frequency class weights"
import numpy as np

# TODO: `class_weights(y, k)` returns an array of k weights, one per class 0 to k − 1, equal to n / (k × count of the class),
# where n is the number of labels. A class that does not appear gets weight 0.
def class_weights(y, k):
    ...
--- solution
import numpy as np

def class_weights(y, k):
    y = np.asarray(y)
    n = len(y)
    counts = np.bincount(y, minlength=k).astype(float)
    return np.where(counts > 0, n / (k * np.maximum(counts, 1)), 0.0)
--- test
import numpy as np
result = class_weights([0, 0, 0, 1], 2)
assert result is not None, "Replace the `...` in `class_weights` with code that returns the weights."
assert np.allclose(result, [4 / 6, 4 / 2]), f"With n = 4 and k = 2, class 0 has count 3 and class 1 has count 1, so the weights are 4/6 and 4/2, but you returned {result}."
assert np.allclose(class_weights([0, 1], 2), [1.0, 1.0]), "A balanced dataset gives equal weights of one."
--- hint
Count each class with `np.bincount(y, minlength=k)`, then divide the number of labels by `k` times each count.
--- hint
`n / (k * counts)`, guarding against zero counts.
```

## Debug the weight direction

These class weights are meant to give the rare class the larger weight, but they use the count instead of its inverse, so the common class is favoured.

```python debug id=weight-direction title="Rare classes get larger weights"
import numpy as np

y = np.array([0, 0, 0, 1])
counts = np.bincount(y, minlength=2)
weights = counts / len(y)                # bug: this gives the common class the larger weight
print("weights:", np.round(weights, 3))
--- solution
import numpy as np

y = np.array([0, 0, 0, 1])
counts = np.bincount(y, minlength=2)
weights = len(y) / (2 * counts)
print("weights:", np.round(weights, 3))
--- test
assert weights[1] > weights[0], f"The rare class 1 must get the larger weight, but the weights are {weights}. Use the inverse of the frequency."
--- hint
Weights should be large for rare classes, which means inverse to the count.
--- hint
Divide the number of labels by the count, rather than the other way round.
```

## Predict the macro-F1

```python predict id=predict-macro title="What is the macro-F1 when one class scores 1.0 and the other 0.0?"
import numpy as np
print(np.mean([1.0, 0.0]))
--- options
* 0.5
1.0
0.0
0.25
--- explain
Macro-F1 averages the per-class scores with equal weight, so one perfect class and one failed class average to one half, however many examples each has.
```
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_3_5', 'sec_nlp_with_transformers_3', 'crs_nlp_with_transformers', 'Checkpoint: fine-tuning and classification', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why does BERT-style masked language modelling read context on both sides of a gap?","options":["Because the mask token is placed at the end of the sequence","Because the model sees the whole sequence, so a masked word can be predicted from the words before and after it","Because the model reads backwards","Because masking removes the need for context"],"answerIndex":1,"explanation":"The encoder attends in both directions, so the words after a gap are as available as the words before it."},{"id":"q2","prompt":"A pooled vector averages over padding positions. What goes wrong?","options":["Nothing, padding is always zero","The representation of a text depends on how much padding its batch needed, so the same text can get different predictions","The softmax stops working","The learning rate must be lowered"],"answerIndex":1,"explanation":"Padding changes the average, so the same text gets different vectors in different batches. Pooling must use only the real tokens."},{"id":"q3","prompt":"Why is NER scored at the span level rather than the token level?","options":["Token scores are impossible to compute","Most tokens are outside any entity, so token accuracy hides errors on the entities themselves","Spans are always longer than tokens","Span scores are always higher"],"answerIndex":1,"explanation":"Token accuracy is dominated by the O tags. Span F1 measures whether each entity is found with the right boundaries and label."},{"id":"q4","prompt":"A dataset has 98% negative examples. A model that always predicts negative has high accuracy. Which metric exposes the failure?","options":["Accuracy, since it is high","Recall on the positive class, or macro-F1","The number of tokens","The learning rate"],"answerIndex":1,"explanation":"Recall on the rare class, and macro-F1, reveal that the model finds none of the positives, which accuracy hides."},{"id":"q5","prompt":"Why should oversampling a rare class happen after the train/test split?","options":["Because oversampling is slower after the split","Because duplicates of the same text on both sides of the split inflate the test scores","Because the test set must be balanced by design","Because the split creates the classes"],"answerIndex":1,"explanation":"Copies of a text in both training and test data let the model memorize answers it will be tested on, so the score is optimistic."}]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_nlp_with_transformers_4_1', 'sec_nlp_with_transformers_4', 'crs_nlp_with_transformers', 'Overlap metrics for generated text', 'interactive', 0, 960, NULL, NULL, 'Some NLP tasks produce text: summaries, translations, rewritten answers. Judging the output needs a measure of how close it is to a reference text written by a person. The oldest and still common family of measures counts **overlap**: how many words or n-grams the candidate shares with the reference. These metrics are cheap and reproducible, but they reward shared words, not meaning, so they must be read with care.

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

Only two of the candidate''s five words can be credited, because the reference has "the" twice and "cat" once.

## Precision, recall and F1 of overlap

Precision divides the overlap by the candidate''s length, and recall divides it by the reference''s length. ROUGE-1 reports their harmonic mean.

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
assert abs(result - 2 / 3) < 1e-9, f"The overlap is ''the'' and ''cat'', so precision and recall are both 2/3 and F1 is 2/3, but you returned {result!r}."
assert abs(rouge1_f1(["the", "the", "the", "cat"], ["the", "cat"]) - 2 * 0.5 * 1.0 / 1.5) < 1e-9, "Clipping gives ''the'' only one credit: overlap 2, precision 0.5, recall 1, F1 2/3."
assert rouge1_f1(["a"], ["b"]) == 0.0, "No overlap gives zero."
--- hint
Count both texts with `Counter`, sum `min` of the two counts over the candidate''s words, then compute precision and recall.
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
assert abs(result - 0.5) < 1e-9, f"Of the four candidate words only ''the'' (once) and ''cat'' are credited, giving 2/4 = 0.5, but you returned {result!r}."
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
The reference contains ''the'' only once, so only one of the three candidate ''the'' tokens should earn credit.
--- hint
Compare counts, using `min` of the candidate and reference counts for each word.
```

## Predict the overlap

```python predict id=predict-overlap title="What is the clipped unigram overlap of ''a a b'' against ''a c''?"
from collections import Counter
cand, ref = Counter("a a b".split()), Counter("a c".split())
print(sum(min(cand[w], ref[w]) for w in cand))
--- options
* 1
2
0
3
--- explain
The reference has ''a'' once, so only one of the two ''a'' tokens earns credit. ''b'' is not in the reference. The overlap is 1.
```
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_4_2', 'sec_nlp_with_transformers_4', 'crs_nlp_with_transformers', 'Error analysis: find where the model fails', 'interactive', 1, 1080, NULL, NULL, 'A metric tells you how much a model is wrong, but not where or why. Error analysis answers those questions: which classes get confused with which, which kinds of input fail, and whether the failures share a pattern you could fix. It is the step most often skipped, and it is the step that turns a score into a decision.

## The confusion matrix

A confusion matrix counts every pair of true and predicted labels. Rows are true classes and columns are predicted classes, so the diagonal holds the correct predictions.

```python run
import numpy as np

labels = ["complaint", "praise", "question"]
y_true = np.array([0, 0, 0, 1, 1, 2, 2, 2, 2])
y_pred = np.array([0, 2, 0, 1, 1, 2, 2, 0, 2])
conf = np.zeros((3, 3), dtype=int)
for t, p in zip(y_true, y_pred):
    conf[t, p] += 1
print("rows = true, columns = predicted")
print(conf)
```

Each off-diagonal entry is a specific mistake. Here a complaint was labelled as a question once, and a question was labelled as a complaint once.

## Where the errors concentrate

The largest off-diagonal entry is the first place to look. Read the examples behind it before deciding what to change.

```python run
off = conf.copy()
np.fill_diagonal(off, 0)
i, j = np.unravel_index(np.argmax(off), off.shape)
print(f"largest confusion: true ''{labels[i]}'' predicted as ''{labels[j]}'' ({off[i, j]} cases)")
```

## Errors by input length

Failures often cluster on certain inputs. Bucketing examples by length can reveal that the model struggles with long texts, which is a fixable problem, such as truncation.

```python run
def length_bucket(n_tokens):
    if n_tokens < 5:
        return "short"
    if n_tokens < 10:
        return "medium"
    return "long"

texts = [3, 4, 7, 12, 15, 2, 9, 11]
errors = [1, 0, 0, 1, 1, 0, 0, 1]
for bucket in ["short", "medium", "long"]:
    idx = [i for i, n in enumerate(texts) if length_bucket(n) == bucket]
    rate = np.mean([errors[i] for i in idx]) if idx else float("nan")
    print(f"{bucket:>6}: error rate {rate:.2f} over {len(idx)} examples")
```

> **Pitfall:** a few examples can suggest a pattern that is not there. Count each bucket, and treat rates from small groups as tentative.

> **In the wild:** teams read a sample of errors each week, group them into categories, and track the categories, because the largest category is usually where a fix pays off.

Per-class recall reads the confusion matrix by rows: each diagonal entry divided by its row total is how often that true class is found.

```python run
import numpy as np
conf_ex = np.array([[5, 1], [2, 7]])
print("per-class recall:", np.round(np.diag(conf_ex) / conf_ex.sum(axis=1), 3))
```

## Challenge: confusion matrix

```python exercise id=confusion-matrix title="Build a confusion matrix"
import numpy as np

# TODO: `confusion(y_true, y_pred, k)` returns a k × k integer array whose entry [t, p] counts the examples with true
# class t predicted as class p.
def confusion(y_true, y_pred, k):
    ...
--- solution
import numpy as np

def confusion(y_true, y_pred, k):
    M = np.zeros((k, k), dtype=int)
    for t, p in zip(y_true, y_pred):
        M[t, p] += 1
    return M
--- test
import numpy as np
result = confusion([0, 0, 1], [0, 1, 1], 2)
assert result is not None, "Replace the `...` in `confusion` with code that returns the matrix."
assert np.array_equal(result, [[1, 1], [0, 1]]), f"Rows are true classes: class 0 is predicted correctly once and as 1 once; class 1 is predicted correctly once. Expected [[1, 1], [0, 1]], but you returned {result.tolist()}."
assert result.sum() == 3, "Every example is counted exactly once."
--- hint
Loop over the pairs and increment the cell in row = true class, column = predicted class.
--- hint
`M[t, p] += 1`.
```

## Challenge: length bucket

```python exercise id=length-bucket title="Assign an input to a length bucket"
# TODO: `length_bucket(n)` returns "short" when n is less than 5, "medium" when n is at least 5 and less than 10, and "long"
# otherwise.
def length_bucket(n):
    ...
--- solution
def length_bucket(n):
    if n < 5:
        return "short"
    if n < 10:
        return "medium"
    return "long"
--- test
assert length_bucket(3) == "short", "Three tokens is short."
assert length_bucket(5) == "medium", "Five is the first medium length."
assert length_bucket(9) == "medium", "Nine is still medium."
assert length_bucket(10) == "long", "Ten and above is long."
--- hint
Check the boundaries in order: below five first, then below ten, and everything else is long.
--- hint
Use two `if` statements with the cut-off values 5 and 10.
```

## Debug the orientation

This confusion matrix is meant to have true classes as rows, but the indices are swapped, so the rows are predicted classes.

```python debug id=transposed-confusion title="Rows are the true classes"
import numpy as np

y_true, y_pred = [0, 0, 1], [0, 1, 1]
M = np.zeros((2, 2), dtype=int)
for t, p in zip(y_true, y_pred):
    M[p, t] += 1                       # bug: rows and columns are swapped
print(M)
--- solution
import numpy as np

y_true, y_pred = [0, 0, 1], [0, 1, 1]
M = np.zeros((2, 2), dtype=int)
for t, p in zip(y_true, y_pred):
    M[t, p] += 1
print(M)
--- test
assert np.array_equal(M, [[1, 1], [0, 1]]), f"Rows must be the true classes, so the matrix should be [[1, 1], [0, 1]], but it is {M.tolist()}. Index the row by the true label."
--- hint
In the convention used here, the row index is the true class.
--- hint
Index `M[t, p]`, not `M[p, t]`.
```

## Predict the error count

```python predict id=predict-err title="How many errors does this confusion matrix record?"
import numpy as np
conf = np.array([[5, 1], [2, 7]])
print(int(conf.sum() - np.trace(conf)))
--- options
* 3
2
1
14
--- explain
The total is 15 and the diagonal sums to 12, so 3 entries are off the diagonal, which are the errors.
```
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_4_3', 'sec_nlp_with_transformers_4', 'crs_nlp_with_transformers', 'Capstone: build and evaluate a text classifier', 'interactive', 2, 1800, NULL, NULL, 'This is the capstone. You will build a text classifier end to end, the way a careful team would: split the data first, learn the vocabulary and weights from training text only, train a model, compare it with a baseline, measure per-class quality, and analyse the errors. The task is to classify short product reviews as positive or negative.

The reviews are generated from templates in the page, so the dataset is reproducible and you can see exactly what the model is learning from.

## Build the dataset

```python run
import numpy as np

rng = np.random.default_rng(7)
positive_adj = ["great", "excellent", "lovely", "reliable", "fast", "happy"]
negative_adj = ["broken", "awful", "slow", "faulty", "late", "poor"]
items = ["battery", "screen", "delivery", "service", "charger", "speaker"]

def make_review(label):
    adjs = positive_adj if label == 1 else negative_adj
    item = rng.choice(items)
    a1, a2 = rng.choice(adjs, 2, replace=False)
    return f"the {item} was {a1} and {a2}", label

data = [make_review(int(rng.integers(0, 2))) for _ in range(90)]
texts = [t for t, _ in data]
labels = np.array([l for _, l in data])
print("examples:", len(texts), "| positive share:", round(float(labels.mean()), 2))
print("first example:", texts[0], "->", labels[0])
```

## Split first

```python run
order = rng.permutation(len(texts))
test_idx, train_idx = order[:27], order[27:]
train_texts = [texts[i] for i in train_idx]
test_texts = [texts[i] for i in test_idx]
y_train, y_test = labels[train_idx], labels[test_idx]
print("train:", len(train_texts), "| test:", len(test_texts))
```

The test reviews are set aside before any vocabulary or weight is learned.

## Learn the vocabulary and idf from training text only

```python run
from collections import Counter
import math

vocab = sorted({w for t in train_texts for w in t.split()})
index = {w: i for i, w in enumerate(vocab)}
n_docs = len(train_texts)
df = Counter(w for t in train_texts for w in set(t.split()))
idf = np.array([math.log(n_docs / df[w]) for w in vocab])

def vectorize(text):
    v = np.zeros(len(vocab))
    for w in text.split():
        if w in index:
            v[index[w]] += 1
    return v * idf

X_train = np.stack([vectorize(t) for t in train_texts])
X_test = np.stack([vectorize(t) for t in test_texts])
print("feature size:", X_train.shape[1], "| unseen test words are ignored")
```

The idf values come from the training reviews only, and unseen test words contribute nothing, which is the honest behaviour for a deployed model.

## Train and compare with a baseline

```python run
def train_logreg(X, y, steps=400, lr=0.5):
    w = np.zeros(X.shape[1])
    b = 0.0
    for _ in range(steps):
        p = 1 / (1 + np.exp(-(X @ w + b)))
        w -= lr * X.T @ (p - y) / len(y)
        b -= lr * np.mean(p - y)
    return w, b

w, b = train_logreg(X_train, y_train)
pred = (X_test @ w + b > 0).astype(int)
baseline = np.full_like(y_test, int(round(y_train.mean())))
print("test accuracy, logistic regression:", round(float(np.mean(pred == y_test)), 3))
print("test accuracy, majority baseline:  ", round(float(np.mean(baseline == y_test)), 3))
```

A baseline that always predicts the majority training label is the floor. The model must beat it on the test reviews.

## Per-class quality

```python run
def per_class_f1(y_true, y_pred, c):
    tp = np.sum((y_pred == c) & (y_true == c))
    fp = np.sum((y_pred == c) & (y_true != c))
    fn = np.sum((y_pred != c) & (y_true == c))
    if tp == 0:
        return 0.0
    p, r = tp / (tp + fp), tp / (tp + fn)
    return 2 * p * r / (p + r)

scores = [per_class_f1(y_test, pred, c) for c in [0, 1]]
print("F1 negative:", round(scores[0], 3), "| F1 positive:", round(scores[1], 3))
print("macro-F1:", round(float(np.mean(scores)), 3))
```

Report the macro average, not just accuracy, so that a weak class cannot hide behind a strong one.

## Errors

```python run
wrong = np.nonzero(pred != y_test)[0]
print("misclassified test reviews:", len(wrong))
for i in wrong[:3]:
    print(" ", test_texts[i], "| true", y_test[i], "| predicted", pred[i])
```

> **Pitfall:** the most common capstone mistake is fitting the vocabulary or idf on all the data before splitting. The score then looks better than the model is, because the test words shaped the features.

> **In the wild:** deployed text classifiers are monitored with exactly these numbers, on fresh data, because the language they see drifts over time.

## Challenge: training idf

```python exercise id=train-idf title="Inverse document frequency from training documents"
import math
from collections import Counter

# TODO: `train_idf(docs)` takes a list of training strings and returns a dictionary mapping each word to
# log(N / df), where N is the number of documents and df counts the documents that contain the word.
def train_idf(docs):
    ...
--- solution
import math
from collections import Counter

def train_idf(docs):
    df = Counter(w for d in docs for w in set(d.split()))
    n = len(docs)
    return {w: math.log(n / c) for w, c in df.items()}
--- test
result = train_idf(["a b", "a c"])
assert result is not None, "Replace the `...` in `train_idf` with code that returns the dictionary."
assert abs(result["a"]) < 1e-9, "''a'' appears in both documents, so its idf is zero."
assert abs(result["b"] - math.log(2)) < 1e-9, "''b'' appears in one of two documents, so its idf is log 2."
assert set(result) == {"a", "b", "c"}, "Every word of the training documents must be in the dictionary."
--- hint
Count the documents containing each word using `set(d.split())` for each document, then compute `log(n / count)`.
--- hint
`{w: math.log(n / c) for w, c in df.items()}`.
```

## Challenge: majority label

```python exercise id=majority-label title="The majority label"
from collections import Counter

# TODO: `majority_label(labels)` returns the most common label in the list. If two labels tie, return the smaller one.
def majority_label(labels):
    ...
--- solution
from collections import Counter

def majority_label(labels):
    counts = Counter(labels)
    best = max(counts.values())
    return min(label for label, c in counts.items() if c == best)
--- test
assert majority_label([1, 0, 1]) == 1, "Label 1 appears twice, so it is the majority."
assert majority_label([0, 1]) == 0, "On a tie the smaller label, 0, is returned."
assert majority_label(["neg", "neg", "pos"]) == "neg", "The most common label works for strings too."
--- hint
Count the labels, find the highest count, and among the labels with that count choose the smallest.
--- hint
`min(label for label, c in counts.items() if c == best)`.
```

## Debug the leakage

This vocabulary is meant to come from the training texts only, but it is built from every text, so words that appear only in the test set become part of the model.

```python debug id=idf-leak title="Build the vocabulary from training texts only"
import math
from collections import Counter

train_docs = ["the battery was great", "the screen was broken"]
test_docs = ["the speaker was faulty"]
all_docs = train_docs + test_docs
df = Counter(w for d in all_docs for w in set(d.split()))     # bug: uses every document
idf = {w: math.log(len(all_docs) / c) for w, c in df.items()}
print("vocabulary size:", len(idf))
print("contains test-only word ''faulty'':", "faulty" in idf)
--- solution
import math
from collections import Counter

train_docs = ["the battery was great", "the screen was broken"]
test_docs = ["the speaker was faulty"]
df = Counter(w for d in train_docs for w in set(d.split()))
idf = {w: math.log(len(train_docs) / c) for w, c in df.items()}
print("vocabulary size:", len(idf))
print("contains test-only word ''faulty'':", "faulty" in idf)
--- test
assert "faulty" not in idf, "''faulty'' appears only in the test set, so it must not shape the training features. Build df from the training documents only."
assert len(idf) == len(set(" ".join(train_docs).split())), "The vocabulary should be exactly the training words."
--- hint
Which documents should the idf be computed from?
--- hint
Use `train_docs` in both the document frequency and the number of documents.
```

## Predict the metric

```python predict id=predict-cap title="What is the macro-F1 when both classes score 0.8?"
import numpy as np
print(round(float(np.mean([0.8, 0.8])), 2))
--- options
* 0.8
1.6
0.4
0.64
--- explain
Macro-F1 averages the per-class scores, and the average of two equal values is that value, 0.8.
```
', 0, '[]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z'),
('les_nlp_with_transformers_4_4', 'sec_nlp_with_transformers_4', 'crs_nlp_with_transformers', 'Final assessment: Modern NLP with Transformers', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why do overlap metrics such as ROUGE clip repeated words?","options":["To make the metric faster","So that a candidate cannot earn credit for repeating a word more times than the reference uses it","To remove stop words automatically","Because the reference is always shorter"],"answerIndex":1,"explanation":"Without clipping, a candidate that repeats a common word would score well regardless of content."},{"id":"q2","prompt":"A classifier scores 95% accuracy on a dataset that is 95% negative. What should you check next?","options":["Per-class recall and macro-F1, to see whether the positive class is found at all","The learning rate only","The number of training epochs only","Nothing, 95% is excellent"],"answerIndex":0,"explanation":"A model that always predicts the majority class scores 95% here. Per-class measures reveal whether it finds the minority class."},{"id":"q3","prompt":"Why is a confusion matrix more useful than accuracy during error analysis?","options":["It replaces the test set","It removes the need for labels","It is always symmetric","It shows which true classes are confused with which predicted classes, pointing to specific fixes"],"answerIndex":3,"explanation":"The off-diagonal entries name the specific mistakes, which is where analysis begins."},{"id":"q4","prompt":"Which step in the capstone pipeline must happen before any vocabulary or idf is computed?","options":["Computing the macro-F1","Training the model","Splitting the data into training and test sets","Printing the first example"],"answerIndex":2,"explanation":"Learning features from the test data leaks information. The split must come first, and the features learned from the training part only."},{"id":"q5","prompt":"Why report macro-F1 alongside accuracy?","options":["Because macro-F1 is always higher","Because it gives each class equal weight, so a weak minority class cannot hide behind a strong majority class","Because accuracy cannot be computed for two classes","Because macro-F1 uses the test set twice"],"answerIndex":1,"explanation":"Macro-F1 averages the per-class scores, so a poor class pulls the summary down however large it is."},{"id":"q6","prompt":"A span prediction gets the label right but the end boundary one token too early. How is it scored under exact span F1?","options":["As a miss and a false alarm","As half a correct span","It is ignored","As a correct span"],"answerIndex":0,"explanation":"Exact span F1 requires matching boundaries and label, so a boundary error counts as a missed gold span and a wrong prediction."}]', '[]', '2026-06-25T07:06:21.232Z', '2026-10-19T07:06:21.232Z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_nlp_with_transformers_1', 'usr_seed00000o', 'crs_nlp_with_transformers', 4, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-09-28T23:06:21.232Z', '2026-09-28T23:06:21.232Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000o');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_nlp_with_transformers_2', 'usr_seed00002c', 'crs_nlp_with_transformers', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-08-05T11:06:21.232Z', '2026-08-05T11:06:21.232Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002c');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_nlp_with_transformers_3', 'usr_seed00002d', 'crs_nlp_with_transformers', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-10-02T18:06:21.232Z', '2026-10-02T18:06:21.232Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002d');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_nlp_with_transformers_4', 'usr_seed00003q', 'crs_nlp_with_transformers', 4, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-10-20T18:06:21.232Z', '2026-10-20T18:06:21.232Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003q');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_nlp_with_transformers_5', 'usr_seed00003t', 'crs_nlp_with_transformers', 4, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-10-17T23:06:21.232Z', '2026-10-17T23:06:21.232Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003t');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_nlp_with_transformers'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_nlp_with_transformers') WHERE id = 'crs_nlp_with_transformers';
