// Modern NLP with Hugging Face: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs nlp-with-transformers
export const course = {
  slug: "nlp-with-transformers",
  title: "Modern NLP with Transformers",
  subtitle: "Tokenization, embeddings, semantic search and fine-tuned encoders — with the evaluation that makes them trustworthy.",
  category: "nlp",
  instructor: "maya",
  level: "intermediate",
  price: 0,
  compareAt: null,
  accent: 340,
  featured: false,
  students: 18740,
  tags: ["NLP", "Hugging Face", "BERT", "Embeddings"],
  learn: [
    "Understand tokenization, subword vocabularies and what a model actually reads",
    "Turn text into vectors with counts, TF-IDF and learned embeddings, and measure their similarity",
    "Build semantic search that ranks documents by meaning and evaluate it properly",
    "Explain how encoders such as BERT are pretrained and fine-tuned for classification and entity recognition",
    "Choose the right NLP metrics, including macro-F1 and span-level scores, and run an honest error analysis",
  ],
  requirements: [
    "Python and basic NumPy",
    "Some familiarity with deep learning helps. The transformer lessons are self-contained",
    "A modern browser. The text processing and metrics run in the page; Hugging Face model code is shown for local use",
  ],
  audience: [
    "Analysts and engineers who work with text and want to go beyond keyword rules",
    "Developers building search, classification or information-extraction features",
    "Data scientists preparing for NLP roles",
  ],
  description: `Language is the messiest data most teams handle. Customer messages, documents, reviews and logs all need to be turned into numbers that a model can compare and classify. This course follows that path from raw text to a trustworthy NLP system, and it treats evaluation as seriously as modelling.

## Learn by building

- **Text pipelines you can read.** Tokenizers, n-grams, TF-IDF, co-occurrence embeddings and span decoders are written in plain Python and NumPy, and they run in the page.
- **Search you can measure.** You rank documents by meaning and score the ranking with reciprocal ranks, not by eye.
- **Metrics that tell the truth.** Macro-F1, span-level scores and ROUGE overlap are computed from their definitions.
- **Debug challenges.** You fix the mistakes that break NLP systems: case-sensitive matching, pooling that averages over padding, a data leak from fitting a vectorizer on the test set, and span boundaries that are off by one.
- **Hugging Face shown honestly.** Pretrained encoders and their fine-tuning loops are static code for local use, next to the NumPy mechanics they rely on.

## What you'll cover

- **Text as data:** bags of words, TF-IDF and tokenization.
- **Embeddings:** word vectors from co-occurrence, sentence vectors and semantic search.
- **Fine-tuning encoders:** masked language modelling, classification and named-entity recognition.
- **Evaluation:** metrics for imbalanced and structured predictions, and error analysis.
- **Capstone:** a complete text classifier, compared against a baseline and analysed for errors.

## Why this course?

Most NLP failures are evaluation failures: a model that looks accurate on a skewed dataset, or a search that ranks well on the examples someone happened to check. This course teaches the habits and the numbers that catch those failures before users do.

You need Python and basic NumPy. Transformers are introduced from the ground up.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "Hugging Face NLP course (free)", url: "https://huggingface.co/learn/nlp-course" },
  { title: "BERT: Pre-training of Deep Bidirectional Transformers (paper)", url: "https://arxiv.org/abs/1810.04805" },
  { title: "Speech and Language Processing (Jurafsky & Martin, free drafts)", url: "https://web.stanford.edu/~jurafsky/slp3/" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Text as Data",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-bag-of-words-tfidf.md", "From bag-of-words to TF-IDF", 18),
      lesson("03-tokenization.md", "Tokenization: words, punctuation and n-grams", 16),
    ],
  },
  {
    title: "Embeddings and Search",
    lessons: [
      lesson("04-word-embeddings.md", "Word embeddings from co-occurrence", 20),
      lesson("05-sentence-embeddings.md", "Sentence embeddings and cosine similarity", 16),
      lesson("06-semantic-search.md", "Semantic search and ranking", 18),
      quiz("s1.json", "Checkpoint: text representations and search"),
    ],
  },
  {
    title: "Fine-tuning Encoders",
    lessons: [
      lesson("07-masked-language-models.md", "Masked language models and BERT", 18),
      lesson("08-pooling-classification.md", "Pooling and text classification", 18),
      lesson("09-named-entities.md", "Named-entity recognition and span decoding", 18),
      lesson("10-imbalanced-classes.md", "Imbalanced classes and macro-F1", 16),
      quiz("s2.json", "Checkpoint: fine-tuning and classification"),
    ],
  },
  {
    title: "Evaluation and Error Analysis",
    lessons: [
      lesson("11-generation-metrics.md", "Overlap metrics for generated text", 16),
      lesson("12-error-analysis.md", "Error analysis: find where the model fails", 18),
      lesson("13-capstone-classifier.md", "Capstone: build and evaluate a text classifier", 30),
      quiz("s3.json", "Final assessment: Modern NLP with Transformers"),
    ],
  },
];
