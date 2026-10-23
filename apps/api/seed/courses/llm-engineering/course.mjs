// LLM Engineering: From Prompt to Production: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs llm-engineering
export const course = {
  slug: "llm-engineering",
  title: "LLM Engineering: From Prompt to Production",
  subtitle: "Prompt design, structured outputs, retrieval, evaluation, cost control and guardrails, with the engineering arithmetic behind each decision.",
  category: "generative-ai",
  instructor: "lena",
  level: "intermediate",
  price: 0,
  compareAt: null,
  accent: 292,
  featured: true,
  students: 31870,
  tags: ["LLMs", "RAG", "Fine-tuning", "Evaluation", "Embeddings"],
  learn: [
    "Control sampling with temperature and top-p, and reason about tokens",
    "Design prompts and structured outputs that are validated, not trusted",
    "Chunk documents and rank retrieval results, including hybrid and fused rankings",
    "Measure retrieval and answer quality with golden sets and calibrated judges",
    "Prepare instruction data and decide when fine-tuning pays off",
    "Estimate cost and latency, and screen inputs for prompt injection and personal data",
  ],
  requirements: [
    "Solid Python",
    "Basic familiarity with APIs and JSON. No prior machine learning experience is needed",
  ],
  audience: [
    "Software engineers building AI features",
    "Tech leads evaluating LLM architectures",
    "Founders prototyping AI products who need to know what will break in production",
  ],
  description: `Building with a language model is easy to demo and hard to ship. The difference is engineering: prompts that behave the same way twice, outputs that are validated before they reach your code, retrieval that finds the right passage, evaluations that catch regressions, and budgets that stay under control. This course teaches each of those with runnable Python.

## Learn by building

- **Every mechanism in code.** Sampling, prompt assembly, schema validation, chunking, ranking, rubric scoring, agreement statistics, cost arithmetic and input screening all run in the page.
- **Measured, not guessed.** You compute recall, reciprocal rank, Cohen's kappa and cost per request, so decisions rest on numbers.
- **Debug challenges.** You fix the bugs that show up in real LLM systems: a temperature applied in the wrong direction, a validator that accepts booleans as integers, chunks with no overlap, and a judge agreement computed with a shifted index.
- **Real APIs shown honestly.** Calls to hosted models are static code for you to run with your own key. Every idea around them runs here without a network connection.

## What you'll cover

- **How LLMs decide:** tokens and sampling.
- **Prompting at scale:** prompt anatomy, token budgets and structured outputs.
- **Retrieval-augmented generation:** chunking, ranking and RAG evaluation.
- **Data and evaluation:** instruction datasets, golden sets and LLM-as-a-judge calibration.
- **Production:** cost and latency, guardrails, and a final assessment.

## Why this course?

Most LLM failures are not model failures. They are missing validation, weak retrieval, prompts that drift and costs nobody measured. This course gives you the checks and the arithmetic that catch those problems before your users do.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "Retrieval-Augmented Generation for Knowledge-Intensive NLP (Lewis et al.)", url: "https://arxiv.org/abs/2005.11401" },
  { title: "Chain-of-Thought Prompting Elicits Reasoning (Wei et al.)", url: "https://arxiv.org/abs/2201.11903" },
  { title: "Judging LLM-as-a-Judge with MT-Bench (Zheng et al.)", url: "https://arxiv.org/abs/2306.05685" },
  { title: "LoRA: Low-Rank Adaptation of Large Language Models", url: "https://arxiv.org/abs/2106.09685" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "How LLMs Decide",
    lessons: [
      lesson("01-welcome.md", "How this course works", 6, { preview: true }),
      lesson("02-tokens-and-sampling.md", "Tokens, logits and sampling with temperature and top-p", 16),
    ],
  },
  {
    title: "Prompting at Scale",
    lessons: [
      lesson("03-prompt-anatomy.md", "Anatomy of a prompt and its token budget", 16),
      lesson("04-structured-outputs.md", "Structured outputs: validate, don't trust", 16),
      quiz("s1.json", "Checkpoint: prompting"),
    ],
  },
  {
    title: "Retrieval-Augmented Generation",
    lessons: [
      lesson("05-chunking.md", "Chunking documents with overlap", 14),
      lesson("06-retrieval-ranking.md", "Ranking: cosine similarity, hybrid scores and fusion", 18),
      lesson("07-rag-evaluation.md", "Evaluating retrieval: recall and reciprocal rank", 16),
      quiz("s2.json", "Checkpoint: retrieval"),
    ],
  },
  {
    title: "Data and Evaluation",
    lessons: [
      lesson("08-instruction-data.md", "Preparing instruction data and deciding to fine-tune", 16),
      lesson("09-golden-sets.md", "Golden sets and rubric scoring", 14),
      lesson("10-judge-calibration.md", "LLM-as-a-judge, calibrated against people", 16),
      quiz("s3.json", "Checkpoint: data and evaluation"),
    ],
  },
  {
    title: "Production",
    lessons: [
      lesson("11-cost-and-latency.md", "Cost, latency and caching", 16),
      lesson("12-guardrails-capstone.md", "Guardrails and a capstone check", 22),
      quiz("s4.json", "Final assessment: LLM Engineering"),
    ],
  },
];
