// Mathematics for Machine Learning: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs math-for-machine-learning
export const course = {
  slug: "math-for-machine-learning",
  title: "Mathematics for Machine Learning",
  subtitle: "Linear algebra, calculus and probability — explained visually and coded in NumPy.",
  category: "math",
  instructor: "daniel",
  level: "beginner",
  price: 7900,
  compareAt: 12900,
  accent: 48,
  featured: true,
  students: 39150,
  tags: ["Linear Algebra", "Calculus", "Probability", "NumPy"],
  learn: [
    "Think geometrically about vectors, matrices and transformations",
    "Use dot products and matrix multiplication the way machine-learning libraries do",
    "Use eigenvalues, the SVD and PCA to find structure in data",
    "Compute gradients and train a model with gradient descent, including the chain rule behind backpropagation",
    "Reason with probability, expectation, Bayes' rule and maximum likelihood",
    "Read the math in machine-learning papers and turn it into working NumPy code",
  ],
  requirements: [
    "High-school algebra: variables, functions and graphs",
    "Basic Python: variables, lists and functions",
    "A modern browser. Nothing to install; Python and NumPy run in the page",
  ],
  audience: [
    "Anyone intimidated by the math behind machine learning",
    "Engineers who want to refresh linear algebra, calculus and probability",
    "Students preparing for a machine-learning course or role",
  ],
  description: `Machine learning is applied mathematics. Every model you train is built from three ideas: **vectors and matrices** represent data, **calculus** tells a model how to improve, and **probability** tells it how confident to be. This course teaches all three the way they are used in practice: geometrically, visually, and in code you run yourself.

## Learn by doing, not by memorizing

- **Runnable code everywhere.** Every formula is backed by a NumPy cell you can edit, run and break.
- **Visual explanations.** Vectors, transformations, eigen-directions, gradient descent and probability distributions are drawn as plots, not only described in words.
- **Challenges with hidden tests.** You write the NumPy yourself and get checked automatically, with hints when you are stuck.
- **Debug challenges.** You fix the bugs machine-learning engineers actually hit: transposed matrices, silent broadcasting, integer truncation and numerical underflow.
- **Predict-the-output questions** that build intuition before you run a single line.

## What you'll cover

- **Linear algebra:** vectors, dot products and cosine similarity; matrices as transformations; matrix multiplication.
- **Eigenvalues and structure:** eigenvectors, the singular value decomposition (SVD) and principal component analysis (PCA).
- **Calculus and optimization:** derivatives, partial derivatives, gradients, gradient descent and the chain rule behind backpropagation.
- **Probability and statistics:** random variables, expectation, variance and covariance, Bayes' rule and maximum likelihood estimation.

## Why this course?

Every concept ends with a real machine-learning use. Linear regression is a matrix equation. Dimensionality reduction is an eigenvalue problem. Training a neural network is the chain rule, repeated. A spam filter is Bayes' rule. Once you can read the math, papers and library documentation stop being opaque.

You need high-school algebra and basic Python. You do not need calculus or statistics before you start.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "Mathematics for Machine Learning (free book, Deisenroth, Faisal & Ong)", url: "https://mml-book.github.io/" },
  { title: "Essence of linear algebra (3Blue1Brown)", url: "https://www.3blue1brown.com/topics/linear-algebra" },
  { title: "NumPy linear algebra reference", url: "https://numpy.org/doc/stable/reference/routines.linalg.html" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Vectors and Matrices",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-vectors.md", "Vectors: arrows, lists and data points", 14, { preview: true }),
      lesson("03-dot-products.md", "Dot products, lengths and angles", 16),
      lesson("04-matrices-transformations.md", "Matrices as transformations", 18),
      lesson("05-matrix-multiplication.md", "Matrix multiplication: composing transformations", 18),
      quiz("s1.json", "Checkpoint: vectors and matrices"),
    ],
  },
  {
    title: "Eigenvalues, SVD and PCA",
    lessons: [
      lesson("06-eigenvectors.md", "Eigenvectors and eigenvalues", 18),
      lesson("07-svd.md", "The singular value decomposition", 18),
      lesson("08-pca.md", "Principal component analysis from scratch", 20),
      quiz("s2.json", "Checkpoint: eigenvalues, SVD and PCA"),
    ],
  },
  {
    title: "Calculus and Optimization",
    lessons: [
      lesson("09-derivatives.md", "Derivatives as sensitivity", 16),
      lesson("10-gradients.md", "Partial derivatives and gradients", 16),
      lesson("11-gradient-descent.md", "Gradient descent: walking downhill", 18),
      lesson("12-chain-rule.md", "The chain rule and backpropagation", 18),
      quiz("s3.json", "Checkpoint: calculus and optimization"),
    ],
  },
  {
    title: "Probability and Statistics",
    lessons: [
      lesson("13-random-variables.md", "Random variables and distributions", 16),
      lesson("14-expectation-variance.md", "Expectation, variance and covariance", 16),
      lesson("15-bayes-rule.md", "Bayes' rule: updating beliefs with evidence", 16),
      lesson("16-maximum-likelihood.md", "Maximum likelihood: fitting models to data", 18),
      quiz("s4.json", "Final assessment: Mathematics for Machine Learning"),
    ],
  },
];
