// Python for Data Science: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs python-for-data-science
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
  tags: ["Python", "pandas", "NumPy", "Free"],
  learn: [
    "Write clean, idiomatic Python for data work",
    "Select, filter, clean and reshape tabular data with pandas",
    "Group, join and summarize data the way analysts do every day",
    "Work with time series: parse dates, resample and smooth",
    "Plot honest, readable charts with matplotlib and pandas",
    "Run a complete exploratory data analysis and report what you found",
  ],
  requirements: [
    "No programming experience required. You will learn Python as you go",
    "A modern browser. Python, NumPy, pandas and matplotlib run in the page",
  ],
  audience: [
    "Complete beginners who want a career in data",
    "Analysts moving from spreadsheets to code",
    "Engineers who need to explore data before building models",
  ],
  description: `Data science starts with a simple question and a messy table. This course teaches the everyday craft of turning raw data into answers: writing clear Python, reshaping tables with pandas, cleaning the mistakes that every real dataset contains, drawing charts that tell the truth, and presenting what you found.

## Learn by doing

- **Runnable code everywhere.** Every idea is a cell you can edit, run and break in the page.
- **Real analysis workflows.** You clean a messy sales table, reshape it, and answer business questions with it.
- **Challenges with hidden tests.** Your functions are checked on new data, so a hard-coded answer will not pass.
- **Debug challenges.** You fix the mistakes analysts actually make: chained assignment that silently does nothing, joins that duplicate rows, averages over missing values, and charts with misleading axes.
- **Predict-the-output questions** that build a feel for how pandas behaves before you run it.

## What you'll cover

- **Python for data:** clean containers, comprehensions and functions you can test.
- **NumPy for data:** arrays, boolean masks and missing values, as the engine under pandas.
- **pandas:** DataFrames, selection, cleaning, grouping, joining, reshaping and time series.
- **Visualization:** matplotlib from first principles, pandas plotting, and the design rules behind honest charts.
- **Exploratory analysis:** a repeatable workflow, outliers, relationships, and a capstone analysis from start to finish.

## Why this course?

Every machine-learning project begins here. Most of the hours in a data job go into loading, checking, cleaning and understanding data, not into fancy models. This course gives you those skills in the order you will use them.

No prior experience is needed. You will get the most from it by running every cell and trying to predict the output first.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "pandas documentation: getting started", url: "https://pandas.pydata.org/docs/getting_started/index.html" },
  { title: "Python for Data Analysis (Wes McKinney, free online chapters)", url: "https://wesmckinney.com/book/" },
  { title: "Matplotlib tutorials", url: "https://matplotlib.org/stable/tutorials/index.html" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Python for Data Work",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-python-for-data.md", "Containers, loops and comprehensions for data", 16),
      lesson("03-functions-clean-code.md", "Functions you can trust", 16),
    ],
  },
  {
    title: "NumPy for Data",
    lessons: [
      lesson("04-arrays-and-masks.md", "Arrays, boolean masks and vectorized thinking", 16),
      lesson("05-missing-values.md", "Missing values with NumPy", 14),
    ],
  },
  {
    title: "pandas Essentials",
    lessons: [
      lesson("06-dataframes.md", "DataFrames: load, inspect and summarize", 18),
      lesson("07-selecting-filtering.md", "Selecting, filtering and assigning", 18),
      lesson("08-cleaning-data.md", "Cleaning data: types, duplicates and gaps", 20),
      lesson("09-grouping-aggregation.md", "Grouping and aggregation", 18),
      lesson("10-joining-reshaping.md", "Joining and reshaping tables", 18),
      lesson("11-time-series.md", "Time series: dates, resampling and rolling windows", 18),
      quiz("s1.json", "Checkpoint: pandas essentials"),
    ],
  },
  {
    title: "Visualization",
    lessons: [
      lesson("12-matplotlib-basics.md", "Plotting with matplotlib from first principles", 16),
      lesson("13-plotting-dataframes.md", "Plotting DataFrames and choosing the right chart", 16),
      lesson("14-honest-charts.md", "Charts that tell the truth", 14),
    ],
  },
  {
    title: "Exploratory Data Analysis",
    lessons: [
      lesson("15-eda-workflow.md", "A repeatable exploratory workflow", 18),
      lesson("16-relationships-outliers.md", "Relationships, correlation and outliers", 18),
      lesson("17-capstone-sales-analysis.md", "Capstone: a complete sales analysis", 30),
      quiz("s2.json", "Final assessment: Python for Data Science"),
    ],
  },
];
