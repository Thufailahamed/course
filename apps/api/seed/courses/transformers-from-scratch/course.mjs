// Transformers from Scratch: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs transformers-from-scratch
export const course = {
  slug: "transformers-from-scratch",
  title: "Transformers from Scratch",
  subtitle: "Attention, tokenization and a GPT, built line by line — then trained the way real models are.",
  category: "deep-learning",
  instructor: "maya",
  level: "advanced",
  price: 0,
  compareAt: null,
  accent: 318,
  featured: false,
  students: 21460,
  tags: ["Transformers", "Attention", "GPT", "PyTorch"],
  learn: [
    "Derive and implement scaled dot-product and multi-head attention",
    "Build the parts of a decoder-only transformer (GPT) and explain each one",
    "Train a tokenizer with byte-pair encoding and understand why it works",
    "Apply modern tricks: rotary positions, RMSNorm and KV-caching",
    "Scale training with warmup, cosine decay, gradient accumulation and mixed precision",
    "Sample text with temperature and top-k, and evaluate a language model with perplexity",
  ],
  requirements: [
    "Deep Learning Foundations or equivalent: backpropagation, softmax and cross-entropy",
    "Python and NumPy. The browser runs them; the PyTorch model code is shown for local use",
  ],
  audience: [
    "Engineers who want to understand the architecture behind modern language models",
    "Deep-learning practitioners who use transformers but have never written one",
    "Researchers preparing to read and modify transformer papers",
  ],
  description: `The transformer is the architecture behind nearly every modern language model, and it is built from a small number of ideas: attention, residual connections, normalization and a feed-forward network, repeated many times. This course builds each piece yourself, checks it against the formulas, and then assembles a small GPT that generates text.

## Learn by building

- **Every component in NumPy.** Attention, multi-head splitting, masking, positional encodings, layer normalization and the transformer block all run in the page.
- **A real tokenizer.** You implement byte-pair encoding and see how it turns text into the tokens a model reads.
- **Training ideas, tested.** Learning-rate schedules, gradient accumulation and sampling strategies are functions you write and check against exact answers.
- **Debug challenges.** You fix the bugs that break real transformers: a missing causal mask, attention normalized along the wrong axis, and a learning-rate warmup that is off by one.
- **PyTorch shown honestly.** The full GPT model and training loop are static PyTorch code for you to run locally, with a NumPy version of each piece that runs here.

## What you'll cover

- **Why attention:** from recurrent networks to attention.
- **Attention, implemented:** scaled dot-product, multi-head attention and causal masks.
- **Building GPT:** tokenization, embeddings, positions, the transformer block and a complete forward pass.
- **Training at scale:** next-token loss, schedules, accumulation, mixed precision and caching.
- **Modern tricks:** rotary positions and RMSNorm, then an evaluation with perplexity.

## Why this course?

Most people use transformers as black boxes. Once you have written the attention formula, handled the masks and debugged a shape error in the residual stream, the models stop being mysterious, and you can read the next architecture paper with confidence.

You need the basics of deep learning. Everything about transformers is taught from the ground up.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "Attention Is All You Need (Vaswani et al.)", url: "https://arxiv.org/abs/1706.03762" },
  { title: "The Illustrated Transformer (Jay Alammar)", url: "https://jalammar.github.io/illustrated-transformer/" },
  { title: "nanoGPT (Andrej Karpathy)", url: "https://github.com/karpathy/nanoGPT" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Why Attention",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-from-rnns-to-attention.md", "From recurrent networks to attention", 16),
    ],
  },
  {
    title: "Attention, Implemented",
    lessons: [
      lesson("03-scaled-dot-product.md", "Scaled dot-product attention", 18),
      lesson("04-multi-head-attention.md", "Multi-head attention", 18),
      lesson("05-causal-masks-positions.md", "Causal masks and positional information", 16),
      quiz("s1.json", "Checkpoint: attention"),
    ],
  },
  {
    title: "Building GPT",
    lessons: [
      lesson("06-byte-pair-encoding.md", "Tokenization with byte-pair encoding", 20),
      lesson("07-embeddings-layernorm.md", "Embeddings and layer normalization", 16),
      lesson("08-transformer-block.md", "The transformer block: residuals and feed-forward layers", 18),
      lesson("09-tiny-gpt.md", "Putting it together: a tiny GPT", 22),
    ],
  },
  {
    title: "Training at Scale",
    lessons: [
      lesson("10-next-token-loss.md", "Next-token prediction and its loss", 16),
      lesson("11-schedules-accumulation.md", "Learning-rate schedules and gradient accumulation", 18),
      lesson("12-mixed-precision.md", "Mixed precision: fast training without losing gradients", 14),
      lesson("13-sampling-caching.md", "Sampling and the KV-cache", 18),
      quiz("s2.json", "Checkpoint: building and training GPT"),
    ],
  },
  {
    title: "Modern Tricks and Evaluation",
    lessons: [
      lesson("14-rope-rmsnorm.md", "Rotary positions and RMSNorm", 16),
      lesson("15-capstone-evaluation.md", "Capstone: assemble and evaluate a language model", 30),
      quiz("s3.json", "Final assessment: Transformers from Scratch"),
    ],
  },
];
