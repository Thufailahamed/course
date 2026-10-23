// HTML & CSS Advanced: how the platform really works. Lesson bodies live in
// ./lessons/*.md, section quizzes in ./quizzes/*.json. Validate with:
//   node seed/courses/validate.mjs html-css-advanced
export const course = {
  slug: "html-css-advanced",
  title: "HTML & CSS Advanced: Systems, Motion & Modern Layout",
  subtitle: "Master the cascade, build resilient layout systems and ship accessible, animated interfaces that hold up in production.",
  category: "web-development",
  instructor: "noah",
  level: "advanced",
  codeLanguage: "html",
  price: 0,
  compareAt: null,
  accent: 265,
  featured: false,
  students: 9860,
  tags: ["CSS Architecture", "Grid", "Container Queries", "Accessibility", "Animation", "Design Systems"],
  learn: [
    "Reason about the cascade, specificity, inheritance and modern cascade layers instead of fighting them",
    "Build themeable interfaces with custom properties, design tokens and dark mode",
    "Use :is(), :where(), :has() and container queries to write smaller, more resilient CSS",
    "Master Flexbox and Grid, including minmax(), auto-fit, named areas and intrinsic sizing",
    "Create motion that feels expensive and respects prefers-reduced-motion",
    "Audit and fix accessibility, focus order, contrast and performance on real pages",
    "Ship a responsive analytics dashboard and a reusable design system",
  ],
  requirements: ["Comfortable with HTML elements and basic CSS selectors", "Our HTML & CSS Basics course, or equivalent experience", "A modern browser (Chrome, Safari, Firefox or Edge)"],
  audience: [
    "Front-end developers who can build a page but want to understand why it breaks",
    "Designers moving into design engineering and component work",
    "Full-stack engineers who want to ship polished, accessible interfaces",
    "Anyone preparing for senior front-end interviews or design-system work",
  ],
  description: `Beginner CSS teaches you properties. Advanced CSS teaches you the **system underneath them**: the cascade, formatting contexts, intrinsic sizing, containment and the tiny set of rules that explain a thousand layout bugs.

## Go from "it works on my screen" to "it works everywhere"

- **Real computed styles, real rendering.** Every challenge runs in the browser and is checked against the DOM, so you learn what the engine actually does.
- **The cascade, demystified.** Specificity, inheritance, \`@layer\`, \`:where()\` and \`!important\` — with a decision framework you can use at work.
- **Layout that survives content.** Flexbox and Grid deep dives, including the min-content traps, \`minmax()\`, \`auto-fit\` and container queries.
- **Motion with judgement.** Transforms, keyframes, view transitions, timing and reduced-motion support.
- **Accessibility and performance as engineering.** Contrast, focus management, ARIA rules, responsive images, font loading and layout shift.

## Two production-grade capstones

Build a **responsive analytics dashboard** with a sidebar, fluid cards and accessible data tables, then extract the visual language into a **reusable design system** with tokens, components and a dark theme. Both projects are checked by the same DOM assertions used throughout the course.

## Who this is for

If you can make a page but sometimes feel like you are guessing at \`z-index\`, \`min-width: auto\`, or why a grid track refuses to shrink, this course is for you.`,
};

export const resources = [
  { title: "MDN: CSS cascade and inheritance", url: "https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_cascade" },
  { title: "MDN: CSS container queries", url: "https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_containment/Container_queries" },
  { title: "WCAG 2.2 quick reference", url: "https://www.w3.org/WAI/WCAG22/quickref/" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "The Cascade, Mastered",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-cascade-specificity.md", "Cascade, specificity and inheritance: the real rules", 24, { preview: true }),
      lesson("03-custom-properties.md", "Custom properties and design tokens", 22),
      lesson("04-modern-selectors.md", "Modern selectors: :is(), :where(), :has() and relational CSS", 22),
      quiz("s1.json", "Checkpoint: the cascade, mastered"),
    ],
  },
  {
    title: "Layout Mastery",
    lessons: [
      lesson("05-flexbox-deep.md", "Flexbox in depth: growth, shrinkage and the min-content trap", 24),
      lesson("06-grid-deep.md", "Grid in depth: intrinsic tracks, minmax and named areas", 26),
      lesson("07-positioning-stacking.md", "Positioning and stacking: absolute, sticky and z-index", 22),
      lesson("08-responsive-systems.md", "Responsive systems: container queries, fluid type and logical properties", 24),
      quiz("s2.json", "Checkpoint: layout mastery"),
    ],
  },
  {
    title: "Motion & Interaction",
    lessons: [
      lesson("09-motion-keyframes.md", "Motion: transitions, transforms and keyframes", 24),
      lesson("10-accessible-motion.md", "Motion for everyone: focus, reduced motion and perceived speed", 20),
      lesson("11-forms-ux.md", "Forms that feel premium: validation, states and custom controls", 22),
      quiz("s3.json", "Checkpoint: motion & interaction"),
    ],
  },
  {
    title: "Accessibility & Performance",
    lessons: [
      lesson("12-semantics-aria.md", "Semantics, ARIA and the accessibility tree", 24),
      lesson("13-color-dark-mode.md", "Color systems, contrast and dark mode", 22),
      lesson("14-performance-media.md", "Performance: critical CSS, fonts, responsive images and CLS", 24),
      quiz("s4.json", "Checkpoint: accessibility & performance"),
    ],
  },
  {
    title: "Modern CSS & Capstones",
    lessons: [
      lesson("15-modern-css.md", "Modern CSS: nesting, color functions, scroll snap and @supports", 22),
      lesson("16-project-dashboard.md", "Project: a responsive analytics dashboard", 44),
      lesson("17-project-design-system.md", "Project: a reusable design system", 46),
      quiz("s5.json", "Final exam: HTML & CSS Advanced"),
    ],
  },
];
