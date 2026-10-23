// NumPy Mastery: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// section quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs numpy
export const course = {
  slug: "numpy-mastery",
  title: "NumPy Mastery: The Interactive Course",
  subtitle: "Write, run and debug real NumPy in your browser, from your first array to vectorized machine-learning code.",
  category: "data-science",
  instructor: "daniel",
  level: "beginner",
  price: 0,
  compareAt: null,
  accent: 205,
  featured: true,
  students: 21360,
  tags: ["NumPy", "Python", "Interactive", "Data Science", "Linear Algebra"],
  learn: [
    "Create, index, reshape and combine N-dimensional arrays with confidence",
    "Replace slow Python loops with fast, vectorized NumPy code",
    "Master broadcasting, the axis argument and views vs. copies",
    "Solve linear systems, compute statistics and work with images as arrays",
    "Debug shape, dtype and broadcasting errors like a pro, with a real step-through debugger",
    "Build k-means, linear regression and simulations from scratch",
  ],
  requirements: ["Basic Python: variables, lists, loops and functions", "A modern browser. Nothing to install; Python runs in the page"],
  audience: [
    "Python developers moving into data science or machine learning",
    "Students who want NumPy fluency before deep learning",
    "Analysts who want to go beyond spreadsheets and pandas one-liners",
  ],
  description: `Most people learn NumPy by copying snippets until something works. This course is different: **every lesson is a live coding environment**. You read a short explanation, run the code, change it, break it, and fix it, all inside your browser with a real Python interpreter and NumPy.

## Learn by doing, not by watching

- **Runnable code everywhere.** Every example is editable and runs instantly. Variables persist across cells like a notebook.
- **140 hands-on challenges.** Each one is checked automatically, with progressive hints when you're stuck.
- **Debug challenges.** You get realistic buggy code (wrong axis, accidental copy, broadcasting mistakes) and fix it.
- **A real debugger.** Step through code line by line, set breakpoints, and watch every variable change.
- **48 predict-the-output questions** build the intuition that separates NumPy beginners from experts.
- **Atlas, your AI tutor,** explains any error in plain language without handing you the answer.

## What you'll build

You'll finish with three capstone projects written from scratch in pure NumPy: **k-means clustering**, **linear regression trained with gradient descent**, and a **Game of Life + Monte Carlo simulation**. These are the same building blocks used inside scikit-learn, PyTorch and pandas.

## Why NumPy?

NumPy is the foundation of the entire Python data stack. pandas, scikit-learn, PyTorch, JAX, SciPy and matplotlib all speak its language. Once you think in arrays, everything else gets easier.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "NumPy: the absolute basics for beginners", url: "https://numpy.org/doc/stable/user/absolute_beginners.html" },
  { title: "NumPy API reference", url: "https://numpy.org/doc/stable/reference/index.html" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Welcome to NumPy",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-why-numpy.md", "Why NumPy? Lists vs. arrays", 14, { preview: true }),
      lesson("03-first-arrays.md", "Your first arrays: shape, dtype and friends", 16),
      quiz("s1.json", "Checkpoint: NumPy fundamentals"),
    ],
  },
  {
    title: "Creating Arrays",
    lessons: [
      lesson("04-array-factories.md", "Array factories: zeros, ones, full and eye", 14),
      lesson("05-ranges-grids.md", "Ranges and grids: arange, linspace, meshgrid", 16),
      lesson("06-random.md", "Random numbers the modern way", 16),
      lesson("07-dtypes.md", "dtypes in depth: precision, casting and overflow", 18),
      quiz("s2.json", "Checkpoint: creating arrays"),
    ],
  },
  {
    title: "Indexing & Selection",
    lessons: [
      lesson("08-indexing-slicing.md", "Indexing and slicing in N dimensions", 18),
      lesson("09-views-copies.md", "Views vs. copies: NumPy's #1 source of bugs", 16),
      lesson("10-boolean-masks.md", "Boolean masks and filtering", 16),
      lesson("11-fancy-indexing.md", "Fancy indexing and np.where", 16),
      quiz("s3.json", "Checkpoint: indexing & selection"),
    ],
  },
  {
    title: "Reshaping & Combining",
    lessons: [
      lesson("12-reshape.md", "reshape, ravel and memory order", 14),
      lesson("13-axes.md", "Adding, removing and swapping axes", 14),
      lesson("14-stack-split.md", "Joining and splitting arrays", 14),
      quiz("s4.json", "Checkpoint: reshaping & combining"),
    ],
  },
  {
    title: "Vectorized Computation",
    lessons: [
      lesson("15-ufuncs.md", "Universal functions and element-wise math", 16),
      lesson("16-broadcasting.md", "Broadcasting, demystified", 20),
      lesson("17-aggregations.md", "Aggregations and the axis argument", 18),
      lesson("18-vectorization.md", "From loops to vectorized code", 18),
      quiz("s5.json", "Checkpoint: vectorized computation"),
    ],
  },
  {
    title: "Linear Algebra & Statistics",
    lessons: [
      lesson("19-matmul-einsum.md", "Dot products, @ and einsum", 18),
      lesson("20-linalg.md", "Solving systems with np.linalg", 18),
      lesson("21-sorting-stats.md", "Sorting, searching and statistics", 16),
      quiz("s6.json", "Checkpoint: linear algebra & statistics"),
    ],
  },
  {
    title: "NumPy in the Real World",
    lessons: [
      lesson("22-nan-floats.md", "NaN, infinity and floating-point traps", 16),
      lesson("23-images.md", "Images are just arrays", 18),
      lesson("24-structured-io.md", "Structured arrays and file I/O", 14),
      lesson("25-performance.md", "Memory layout, strides and performance", 18),
      quiz("s7.json", "Checkpoint: NumPy in the real world"),
    ],
  },
  {
    title: "Capstone Projects",
    lessons: [
      lesson("26-kmeans.md", "Project: k-means clustering from scratch", 25),
      lesson("27-linear-regression.md", "Project: linear regression with gradient descent", 25),
      lesson("28-simulations.md", "Project: Game of Life and Monte Carlo simulation", 22),
      quiz("s8.json", "Final exam: NumPy Mastery"),
    ],
  },
];
