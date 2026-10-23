// HTML & CSS Basics: a fully interactive course for complete beginners. Lesson bodies live in
// ./lessons/*.md, section quizzes in ./quizzes/*.json. Validate with:
//   node seed/courses/validate.mjs html-css-basics
export const course = {
  slug: "html-css-basics",
  title: "HTML & CSS Basics: The Interactive Course",
  subtitle: "Build real, beautiful web pages from your first tag. Write HTML and CSS in the browser and watch every change render instantly.",
  category: "web-development",
  instructor: "noah",
  level: "beginner",
  codeLanguage: "html",
  price: 0,
  compareAt: null,
  accent: 198,
  featured: true,
  students: 24680,
  tags: ["HTML", "CSS", "Web Design", "Frontend", "Responsive", "Beginner"],
  learn: [
    "Structure pages with semantic HTML that browsers, search engines and screen readers understand",
    "Style with selectors, the box model, typography and color until a page looks intentional",
    "Build layouts with Flexbox and CSS Grid instead of fighting floats and margins",
    "Make pages responsive with mobile-first media queries and fluid type",
    "Create accessible links, images, forms and focus states from the start",
    "Ship two complete projects: a personal profile page and a product landing page",
  ],
  requirements: ["No coding experience at all. We start with your first tag", "A modern browser. Pages render live on the page, so there is nothing to install"],
  audience: [
    "Complete beginners who want to build for the web and understand what they are typing",
    "Designers who want to turn mockups into working, responsive pages",
    "Marketers and founders who need to edit a landing page without fear",
    "Developers from other languages who want a precise, modern HTML and CSS foundation",
  ],
  description: `Most beginner web courses show you a finished page and ask you to copy it. This one gives you a **live browser preview under every example**, so you can change a line and see the consequence immediately.

## Learn by looking, changing and breaking

- **Every lesson is a live playground.** Write HTML and CSS, run it, and see the real page rendered by your browser. No setup, no build step, no guessing.
- **Dozens of hands-on challenges.** Each one is checked against the real DOM and real computed styles, not a screenshot or a multiple-choice quiz. Progressive hints appear when you are stuck.
- **Debug challenges.** Real beginner bugs — a missing closing tag, a broken selector, a margin that collapses, an image without \`alt\` — that you track down and fix.
- **Predict-the-render questions** train you to read CSS before you run it, which is the skill that separates people who guess from people who know.
- **A responsive preview toolbar.** Check every page at desktop, tablet and phone width without leaving the lesson.

## From a blank file to a real page

You start with \`<h1>Hello, web</h1>\` and finish with two portfolio-ready projects: a **personal profile page** with a responsive layout and a **product landing page** with a hero, feature grid, pricing cards and an accessible signup form.

## Built for what comes next

Everything here is the foundation for front-end development, design systems and JavaScript. When you are done, **HTML & CSS Advanced** picks up with the cascade, container queries, modern selectors, motion and production accessibility.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "MDN: HTML element reference", url: "https://developer.mozilla.org/en-US/docs/Web/HTML/Element" },
  { title: "MDN: CSS reference", url: "https://developer.mozilla.org/en-US/docs/Web/CSS/Reference" },
  { title: "WebAIM: Contrast checker", url: "https://webaim.org/resources/contrastchecker/" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Getting Started",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-first-page.md", "Your first page: elements, tags and structure", 16, { preview: true }),
      lesson("03-text-and-lists.md", "Text that means something: headings, lists and emphasis", 18),
      quiz("s1.json", "Checkpoint: getting started"),
    ],
  },
  {
    title: "Links, Images & Structure",
    lessons: [
      lesson("04-links-and-images.md", "Links and images: connecting pages, describing pictures", 20),
      lesson("05-page-structure.md", "Page structure: landmarks, sections and the document outline", 18),
      lesson("06-tables.md", "Tables: data that stays readable", 18),
      quiz("s2.json", "Checkpoint: links, images & structure"),
    ],
  },
  {
    title: "Forms & Accessibility",
    lessons: [
      lesson("07-forms.md", "Forms: labels, inputs and buttons people can actually use", 20),
      lesson("08-accessible-html.md", "Accessible HTML: the defaults that make a page usable by everyone", 20),
      quiz("s3.json", "Checkpoint: forms & accessibility"),
    ],
  },
  {
    title: "CSS Foundations",
    lessons: [
      lesson("09-css-first-steps.md", "Your first stylesheet: selectors, colors and the cascade", 20),
      lesson("10-box-model.md", "The box model: space, borders and why nothing lines up", 20),
      lesson("11-typography-color.md", "Typography and color: making a page feel designed", 20),
      quiz("s4.json", "Checkpoint: CSS foundations"),
    ],
  },
  {
    title: "Layout & Responsive",
    lessons: [
      lesson("12-flexbox.md", "Flexbox: rows, alignment and navigation bars", 22),
      lesson("13-grid.md", "CSS Grid: real two-dimensional layouts", 22),
      lesson("14-responsive.md", "Responsive design: one page on every screen", 22),
      quiz("s5.json", "Checkpoint: layout & responsive design"),
    ],
  },
  {
    title: "Motion & Capstone Projects",
    lessons: [
      lesson("15-motion-states.md", "Interaction polish: hover, focus and transitions", 18),
      lesson("16-project-profile.md", "Project: a personal profile page", 32),
      lesson("17-project-landing.md", "Project: a product landing page", 40),
      quiz("s6.json", "Final exam: HTML & CSS Basics"),
    ],
  },
];
