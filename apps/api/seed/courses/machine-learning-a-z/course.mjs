// Practical Machine Learning: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs machine-learning-a-z
export const course = {
  slug: "machine-learning-a-z",
  title: "Practical Machine Learning with scikit-learn",
  subtitle: "Build the core algorithms yourself in NumPy, then use them the way scikit-learn does.",
  category: "machine-learning",
  instructor: "arjun",
  level: "beginner",
  price: 0,
  compareAt: null,
  accent: 200,
  featured: true,
  students: 62340,
  tags: ["scikit-learn", "XGBoost", "Regression", "Classification"],
  learn: [
    "Frame business problems as machine-learning problems, with features, targets and a metric",
    "Train linear models, logistic regression, decision trees, random forests and gradient boosting",
    "Engineer features and build leak-free pipelines",
    "Evaluate models with the right metrics, cross-validation and honest held-out data",
    "Tune hyperparameters efficiently and explain predictions",
    "Ship a complete churn model from raw data to a defensible result",
  ],
  requirements: [
    "Basic Python. Functions, lists and dictionaries are enough",
    "High-school algebra. Matrix notation is introduced as you need it",
    "A modern browser. Algorithms run in NumPy in the page; the scikit-learn and XGBoost code is shown for you to run locally",
  ],
  audience: [
    "Analysts and engineers starting their first machine-learning project",
    "Developers who use models but want to understand what they are doing",
    "Students preparing for data-science roles",
  ],
  description: `Most machine-learning work is not choosing a clever algorithm. It is framing the problem, preparing features without leaking the answer, evaluating honestly, and explaining the result. This course covers the whole practice, and it builds the core algorithms yourself so that the library calls stop being magic.

## Learn by building

- **Algorithms from scratch.** Linear and logistic regression, a decision tree, bagging, boosting, nearest neighbours and cross-validation are written in NumPy, and you run them in the page.
- **The scikit-learn way.** Every algorithm is then shown with the scikit-learn API, as static code you can run on your own machine. You will see that the two versions compute the same thing.
- **Challenges with hidden tests.** Your functions are checked on new data, so memorized answers do not pass.
- **Debug challenges.** You find the mistakes that wreck real projects: scaling before the split, accuracy on an imbalanced problem, and a validation set used for tuning and reporting.
- **Predict-the-output questions** that build intuition about metrics and models.

## What you'll cover

- **Foundations:** the machine-learning workflow and your first model.
- **Supervised learning:** linear and logistic regression, trees, forests, boosting and nearest neighbours.
- **Evaluation:** splits, cross-validation, metrics, bias and variance.
- **Features and pipelines:** feature engineering, data leakage and reproducible pipelines.
- **Tuning and interpretability:** search strategies and explaining predictions.
- **Capstone:** a churn model, built end to end.

## Why this course?

A model that scores 95% in a notebook can still fail in production, usually because of how it was evaluated or prepared. This course teaches the habits that prevent those failures, using the algorithms you have built with your own hands.

You need basic Python. The rest is taught from the ground up.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "scikit-learn user guide", url: "https://scikit-learn.org/stable/user_guide.html" },
  { title: "An Introduction to Statistical Learning (free book)", url: "https://www.statlearning.com/" },
  { title: "XGBoost documentation", url: "https://xgboost.readthedocs.io/" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Foundations",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-ml-workflow.md", "The machine-learning workflow: framing the problem", 16),
      lesson("03-first-model.md", "Your first model: linear regression", 18),
    ],
  },
  {
    title: "Supervised Learning",
    lessons: [
      lesson("04-logistic-regression.md", "Logistic regression for classification", 18),
      lesson("05-decision-trees.md", "Decision trees: learning rules from data", 18),
      lesson("06-random-forests.md", "Random forests and bagging", 16),
      lesson("07-gradient-boosting.md", "Gradient boosting: learning from mistakes", 18),
      lesson("08-nearest-neighbors.md", "Nearest neighbours and distance", 14),
    ],
  },
  {
    title: "Evaluation Done Right",
    lessons: [
      lesson("09-splits-cross-validation.md", "Train, validation and test splits; cross-validation", 18),
      lesson("10-metrics.md", "Choosing metrics: accuracy is rarely enough", 18),
      lesson("11-bias-variance.md", "Bias, variance and learning curves", 16),
      quiz("s1.json", "Checkpoint: supervised learning and evaluation"),
    ],
  },
  {
    title: "Features and Pipelines",
    lessons: [
      lesson("12-feature-engineering.md", "Feature engineering: scaling, encoding and gaps", 20),
      lesson("13-data-leakage.md", "Avoiding data leakage", 16),
      lesson("14-pipelines.md", "Pipelines: fit, transform and predict as one unit", 18),
      quiz("s2.json", "Checkpoint: features and pipelines"),
    ],
  },
  {
    title: "Tuning and Interpretability",
    lessons: [
      lesson("15-hyperparameter-search.md", "Hyperparameter search: grid and random", 16),
      lesson("16-explaining-predictions.md", "Explaining predictions: permutation importance and SHAP", 16),
    ],
  },
  {
    title: "Capstone",
    lessons: [
      lesson("17-capstone-churn.md", "Capstone: predict customer churn end to end", 30),
      quiz("s3.json", "Final assessment: Practical Machine Learning"),
    ],
  },
];
