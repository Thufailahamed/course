// MLOps: Shipping Models to Production: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs mlops-in-production
export const course = {
  slug: "mlops-in-production",
  title: "MLOps: Shipping Models to Production",
  subtitle: "Reproducible data and experiments, pipelines and feature stores with no leakage, serving latency, and drift monitoring with retraining rules.",
  category: "mlops",
  instructor: "arjun",
  level: "advanced",
  price: 0,
  compareAt: null,
  accent: 140,
  featured: false,
  students: 13280,
  tags: ["MLOps", "Docker", "Monitoring", "CI/CD"],
  learn: [
    "Version data, code and models reproducibly with content fingerprints",
    "Compare experiments by their parameters and metrics",
    "Order pipeline tasks by their dependencies and detect cycles",
    "Build point-in-time correct features that avoid leakage",
    "Serve models within a latency budget, measured by percentiles",
    "Detect data drift with the population stability index and set retraining rules",
  ],
  requirements: [
    "Experience training ML models",
    "Comfort with the command line and Python. Docker and cloud tooling are shown as static code",
  ],
  audience: [
    "ML engineers taking models from notebooks to production",
    "Data scientists shipping their first models",
    "Platform engineers supporting ML teams",
  ],
  description: `Most machine learning models never reach production, and many that do quietly degrade. MLOps is the engineering discipline that closes that gap: versioned data, traceable experiments, pipelines that run the same way every time, features that match training, serving that meets its latency budget, and monitoring that notices when the world changes.

## Learn by building

- **The mechanisms in code.** Content fingerprints, experiment comparison, dependency ordering, point-in-time joins, cache freshness, micro-batching, latency percentiles, drift scores and alert rules all run in the page.
- **Numbers you can check.** You compute percentiles, the population stability index and the leakage a naive join introduces, so decisions rest on measurements.
- **Debug challenges.** You fix the bugs that cause production incidents: a fingerprint that depends on row order, a feature join that reads the future, a drift score with the wrong sign, and a retraining rule that fires on a single bad day.
- **Infrastructure shown honestly.** Docker, orchestration and cloud services are static configuration for you to run with your own tools.

## What you'll cover

- **The lifecycle:** why models fail to ship, and the maturity of a team's practice.
- **Reproducibility:** data fingerprints and experiment tracking.
- **Pipelines and features:** dependency ordering, point-in-time features, and batch versus online serving.
- **Serving:** micro-batching and latency percentiles.
- **Monitoring:** drift detection, retraining rules and a monitored-model capstone.

## Why this course?

A model that works in a notebook is a prototype. A model in production needs to be reproducible, its features need to match what it was trained on, it needs to answer within a budget, and someone needs to know when it has stopped being right. This course teaches each of those so you can ship models that stay correct.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "Hidden Technical Debt in Machine Learning Systems (Sculley et al.)", url: "https://papers.nips.cc/paper/2015/hash/86df7dcfd896fcaf2674f757a2463eba-Abstract.html" },
  { title: "Rules of Machine Learning (Google)", url: "https://developers.google.com/machine-learning/guides/rules-of-ml" },
  { title: "Feast: an open-source feature store", url: "https://feast.dev" },
  { title: "MLflow: an open-source platform for the ML lifecycle", url: "https://mlflow.org" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "The ML Lifecycle",
    lessons: [
      lesson("01-welcome.md", "How this course works", 6, { preview: true }),
      lesson("02-why-models-fail.md", "Why most models never ship: maturity and the lifecycle", 14),
    ],
  },
  {
    title: "Reproducibility",
    lessons: [
      lesson("03-data-versioning.md", "Versioning data with content fingerprints", 16),
      lesson("04-experiment-tracking.md", "Experiment tracking and comparing runs", 14),
      quiz("s1.json", "Checkpoint: reproducibility"),
    ],
  },
  {
    title: "Pipelines and Features",
    lessons: [
      lesson("05-pipeline-dag.md", "Ordering pipeline tasks by their dependencies", 16),
      lesson("06-feature-store.md", "Point-in-time features without leakage", 18),
      lesson("07-batch-vs-online.md", "Batch and online features, and cache freshness", 14),
      quiz("s2.json", "Checkpoint: pipelines and features"),
    ],
  },
  {
    title: "Serving",
    lessons: [
      lesson("08-micro-batching.md", "Serving patterns: micro-batching requests", 14),
      lesson("09-inference-latency.md", "Inference latency and percentiles", 16),
      quiz("s3.json", "Checkpoint: serving"),
    ],
  },
  {
    title: "Monitoring",
    lessons: [
      lesson("10-drift-detection.md", "Data drift with the population stability index", 16),
      lesson("11-alerting-retraining.md", "Alerting and retraining rules", 14),
      lesson("12-monitored-model-capstone.md", "Capstone: a monitored model end to end", 24),
      quiz("s4.json", "Final assessment: MLOps in Production"),
    ],
  },
];
