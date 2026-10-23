// Python for Data Science: a fully interactive course. Lesson bodies live in
// ./lessons/*.md, the checkpoint quiz in ./quizzes/s1.json. Validate with:
//   node seed/courses/validate.mjs python-for-data-science
export const course = {
  slug: "python-for-data-science",
  title: "Python for Data Science",
  subtitle: "NumPy, pandas, visualization and analysis — the foundation for everything in ML.",
  category: "data-science",
  instructor: "arjun",
  level: "beginner",
  price: 0,
  compareAt: null,
  accent: 210,
  featured: false,
  students: 88420,
  tags: ["Python", "pandas", "NumPy", "Matplotlib", "Interactive", "Data Analysis", "Free"],
  learn: [
    "Write clean, idiomatic Python for real data work — types, control flow, functions and comprehensions",
    "Think in arrays: index, slice, reshape and broadcast NumPy data without loops",
    "Load, clean, filter, group, join and reshape tables with pandas",
    "Choose the right chart and build clear, publication-ready visualizations with matplotlib",
    "Run a complete exploratory analysis, from a messy CSV to written, evidence-backed conclusions",
    "Read shape, dtype, merge and missing-value errors, then fix them with a real debugger",
  ],
  requirements: [
    "No data-science experience required — we start with the Python you need",
    "A modern browser. Python, pandas, NumPy and matplotlib run inside the page; nothing to install",
  ],
  audience: [
    "Complete beginners moving from spreadsheets to code",
    "Analysts who want to turn one-off Excel work into repeatable Python",
    "Students preparing for machine learning, statistics or a data role",
    "Developers who know Python but want practical NumPy, pandas and EDA fluency",
  ],
  description: `Most data-science courses show you a finished notebook and ask you to believe it. This one hands you the keyboard: **every lesson is a live coding environment** with Python, pandas, NumPy and matplotlib running inside your browser.

## Learn by doing, not by watching

- **Ten hands-on lessons, one checkpoint quiz.** Every concept is followed by runnable code you can edit and break.
- **30 auto-checked challenges.** Hidden tests check behaviour, not one specific answer, and progressive hints meet you where you're stuck.
- **Debug challenges.** Real analyst bugs — a string column that should be numeric, a merge that duplicates rows, a broadcast that silently subtracts from the wrong axis — that you track down and fix.
- **Predict-the-output questions** train you to read code before you run it.
- **A real step-through debugger.** Watch variables change line by line instead of guessing.
- **Atlas, your AI tutor,** explains any error in plain language without spoiling the exercise.

## From first variable to first insight

You'll start with the Python primitives that every DataFrame column is built from, then move through NumPy arrays, pandas tables, grouping, joins and reshaping, and finish by running a complete exploratory analysis on a messy subscription dataset and defending your conclusions with charts.

## Built for what comes next

NumPy and pandas are the substrate under scikit-learn, PyTorch, Jupyter, BI tools and almost every production ML pipeline. The habits you build here — vectorize, inspect shapes, validate joins, plot the distribution before modelling — will stay useful long after this course ends.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "pandas: 10 minutes to pandas", url: "https://pandas.pydata.org/docs/user_guide/10min.html" },
  { title: "NumPy: the absolute basics for beginners", url: "https://numpy.org/doc/stable/user/absolute_beginners.html" },
  { title: "Matplotlib: anatomy of a figure", url: "https://matplotlib.org/stable/users/explain/figure/figure_intro.html" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Python Essentials",
    lessons: [
      lesson("01-welcome.md", "Welcome: how this course works", 8, { preview: true }),
      lesson("02-variables-control-flow.md", "Variables, types and control flow", 16, { preview: true }),
      lesson("03-functions-comprehensions.md", "Functions and comprehensions", 14),
    ],
  },
  {
    title: "NumPy",
    lessons: [
      lesson("04-arrays-broadcasting.md", "Arrays and broadcasting", 17),
      lesson("05-vectorization.md", "Vectorization in practice", 12),
    ],
  },
  {
    title: "pandas",
    lessons: [
      lesson("06-dataframes.md", "DataFrames 101", 17),
      lesson("07-grouping.md", "Grouping and aggregation", 14),
      lesson("08-joining-reshaping.md", "Joining and reshaping", 14),
      quiz("s1.json", "Checkpoint: pandas"),
    ],
  },
  {
    title: "Visualization & EDA",
    lessons: [
      lesson("09-plotting.md", "Plotting with matplotlib and seaborn", 14),
      lesson("10-end-to-end-eda.md", "An end-to-end EDA", 19),
    ],
  },
];
