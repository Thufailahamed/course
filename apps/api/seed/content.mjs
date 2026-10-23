// Seed catalog for local development and demos.
// Lesson specs: "v|Title|minutes" (video), "a|Title|minutes" (article), "q|Title" (quiz).

export const categories = [
  ["machine-learning", "Machine Learning", "Classical ML, from regression to gradient boosting.", "brain"],
  ["deep-learning", "Deep Learning", "Neural networks, backprop, CNNs, RNNs and Transformers.", "layers"],
  ["generative-ai", "LLMs & Generative AI", "Large language models, diffusion, fine-tuning and RAG.", "sparkles"],
  ["ai-agents", "AI Agents", "Tool use, planning, memory and multi-agent systems.", "bot"],
  ["computer-vision", "Computer Vision", "Image classification, detection, segmentation and more.", "eye"],
  ["nlp", "Natural Language Processing", "Tokenization, embeddings, sequence models and evaluation.", "message-square"],
  ["mlops", "MLOps & Deployment", "Ship, monitor and scale models in production.", "server"],
  ["math", "Math for AI", "Linear algebra, calculus, probability and optimization.", "sigma"],
  ["data-science", "Data Science", "Python, pandas, visualization and experimentation.", "bar-chart"],
  ["programming", "Programming", "Python from first principles: core language, clean code and real projects.", "code"],
  ["web-development", "Web Development", "HTML, CSS and JavaScript — design and build for the browser.", "globe"],
];

export const instructors = [
  {
    key: "maya",
    name: "Dr. Maya Chen",
    email: "maya@latent.dev",
    headline: "Former Research Scientist · Deep Learning & LLMs",
    bio: "Maya spent eight years training large-scale language and vision models in industry research labs, and has taught deep learning to more than 200,000 engineers. She believes every equation should come with an intuition and a working notebook.",
  },
  {
    key: "arjun",
    name: "Arjun Mehta",
    email: "arjun@latent.dev",
    headline: "Staff ML Engineer · MLOps & Production Systems",
    bio: "Arjun has built recommendation and ranking systems serving hundreds of millions of requests a day. He teaches the unglamorous parts of ML that decide whether a model ever reaches users: data pipelines, evaluation, deployment and monitoring.",
  },
  {
    key: "sofia",
    name: "Sofia Alvarez",
    email: "sofia@latent.dev",
    headline: "Applied Scientist · Computer Vision",
    bio: "Sofia works on perception systems for robotics and medical imaging. Before that she completed a PhD in computer vision. Her courses are known for crisp visual explanations and real-world projects.",
  },
  {
    key: "daniel",
    name: "Daniel Okafor",
    email: "daniel@latent.dev",
    headline: "Mathematician · Educator · Author",
    bio: "Daniel taught university mathematics for a decade before moving into ML education. He specialises in making linear algebra, probability and optimisation feel obvious in hindsight.",
  },
  {
    key: "lena",
    name: "Lena Hoffmann",
    email: "lena@latent.dev",
    headline: "AI Engineer · Agents & Retrieval Systems",
    bio: "Lena builds agentic and retrieval-augmented applications for enterprises. She focuses on evaluation-driven development and shipping LLM features that are reliable, observable and affordable.",
  },
  {
    key: "noah",
    name: "Noah Bennett",
    email: "noah@latent.dev",
    headline: "Design Engineer · Front-end, CSS & Accessibility",
    bio: "Noah has spent twelve years building interfaces at design-led product companies, from marketing sites to complex dashboards. He teaches CSS as a system: a small set of durable ideas that explain a thousand layout bugs, with an obsession for accessible, fast pages.",
  },
];

const VID = [
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
];
export const sampleVideo = (i) => VID[i % VID.length];

export const courses = [
];

export const paths = [
  {
    slug: "ml-engineer",
    title: "Machine Learning Engineer",
    subtitle: "Go from Python basics to production ML systems.",
    description: "A structured path through the math, algorithms and engineering practices hiring managers look for in ML engineers. Finish with a portfolio of deployed projects.",
    accent: 205,
    level: "beginner",
    courses: ["python-basics", "python-for-data-science", "numpy-mastery", "math-for-machine-learning", "machine-learning-a-z", "deep-learning-foundations", "mlops-in-production"],
  },
  {
    slug: "llm-engineer",
    title: "LLM & AI Engineer",
    subtitle: "Build, evaluate and ship applications on top of large language models.",
    description: "Learn how transformers work, then build RAG systems, fine-tune models and ship reliable agents with real evaluation.",
    accent: 290,
    level: "intermediate",
    courses: ["deep-learning-foundations", "transformers-from-scratch", "llm-engineering", "building-ai-agents"],
  },
  {
    slug: "ai-researcher",
    title: "Deep Learning Researcher",
    subtitle: "The theory and practice behind state-of-the-art models.",
    description: "For those who want to read and reproduce papers: math foundations, transformers, diffusion and reinforcement learning.",
    accent: 330,
    level: "advanced",
    courses: ["math-for-machine-learning", "transformers-from-scratch", "generative-ai-diffusion", "reinforcement-learning-essentials"],
  },
  {
    slug: "frontend-engineer",
    title: "Frontend Engineer",
    subtitle: "From your first HTML page to production-grade interfaces.",
    description: "Build the visual web from the ground up: semantic HTML, modern CSS, responsive layout, motion, accessibility and the JavaScript that makes it interactive. Finish with a portfolio of real, accessible pages.",
    accent: 205,
    level: "beginner",
    courses: ["html-css-basics", "html-css-advanced", "javascript-basics", "javascript-advanced"],
  },
];

export const firstNames = ["Aisha", "Ben", "Carla", "Dev", "Elena", "Farah", "Gabriel", "Hana", "Ivan", "Jia", "Kofi", "Laura", "Mateo", "Nadia", "Omar", "Priya", "Quinn", "Rafael", "Sara", "Tomás", "Uma", "Victor", "Wen", "Ximena", "Yusuf", "Zoe", "Liam", "Mei", "Noah", "Olivia", "Pablo", "Rina", "Sam", "Tara", "Arash", "Bianca", "Chen", "Diego", "Emma", "Felix"];
export const lastNames = ["Rahman", "Carter", "Silva", "Patel", "Novak", "Haddad", "Rossi", "Kim", "Petrov", "Wang", "Mensah", "Schmidt", "García", "Aziz", "Farouk", "Iyer", "Brooks", "Costa", "Lindqvist", "Ruiz", "Nair", "Dubois", "Li", "Torres", "Demir", "Müller", "O'Brien", "Tanaka", "Andersson", "Moreau"];
export const headlines = ["Software Engineer", "Data Analyst", "ML Engineer", "Product Manager", "PhD Student", "Backend Developer", "Data Scientist", "Research Engineer", "CS Student", "Founder", "Analytics Lead", "Frontend Engineer"];

export const reviewTemplates = [
  ["Best course I've taken on the topic", "The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what's happening under the hood instead of copying snippets."],
  ["Worth every minute", "Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing."],
  ["Exceptional production quality", "Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections."],
  ["Helped me land an ML role", "I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended."],
  ["Dense but fantastic", "This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level."],
  ["Finally clicked", "I'd tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together."],
  ["Great instructor, great community", "Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam."],
  ["Solid and practical", "Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I'd take another course from this instructor."],
  ["Clear explanations", "The visual explanations of difficult concepts are the best I've seen. Code is clean and modern. Updated content too, which matters a lot in this field."],
  ["Very good", "Well organized and easy to follow. I appreciated the real-world examples and the honest discussion of trade-offs rather than hype."],
];

export const articleBodies = {
  "Setting up your environment": `We'll use **Python 3.12**, **PyTorch** and **Jupyter**. You can work locally or in a hosted notebook — both are covered below.

## Option A — local setup

\`\`\`bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\\Scripts\\activate
pip install torch torchvision numpy matplotlib jupyterlab
jupyter lab
\`\`\`

Verify your install:

\`\`\`python
import torch
print(torch.__version__, torch.cuda.is_available())
\`\`\`

## Option B — hosted notebooks

If you don't have a GPU, a hosted notebook with a free GPU tier is perfect for this course. Upload the course notebooks from the **Resources** tab and select a GPU runtime.

> **Tip:** Keep one notebook per section. It makes reviewing much easier later.

## Checklist

- [ ] Python 3.10+ installed
- [ ] PyTorch imports without errors
- [ ] You can open and run a notebook cell`,
  "Backprop step-by-step: a worked example": `Let's compute gradients by hand for a tiny network so backprop stops feeling like magic.

## The network

A single hidden unit with a sigmoid, followed by a linear output and squared error loss:

- $z_1 = w_1 x + b_1$, $h = \\sigma(z_1)$
- $\\hat{y} = w_2 h + b_2$
- $L = \\tfrac{1}{2}(\\hat{y} - y)^2$

## Backward pass

Apply the chain rule from the loss backwards:

| Quantity | Expression |
|---|---|
| ∂L/∂ŷ | ŷ − y |
| ∂L/∂w₂ | (ŷ − y) · h |
| ∂L/∂h | (ŷ − y) · w₂ |
| ∂L/∂z₁ | ∂L/∂h · σ(z₁)(1 − σ(z₁)) |
| ∂L/∂w₁ | ∂L/∂z₁ · x |

## In code

\`\`\`python
import numpy as np

sigmoid = lambda z: 1 / (1 + np.exp(-z))
x, y = 1.5, 0.8
w1, b1, w2, b2 = 0.4, 0.1, -0.6, 0.2

z1 = w1 * x + b1; h = sigmoid(z1)
y_hat = w2 * h + b2
dy = y_hat - y
dw2 = dy * h
dz1 = dy * w2 * h * (1 - h)
dw1 = dz1 * x
print(f"dw1={dw1:.4f}  dw2={dw2:.4f}")
\`\`\`

Check your numbers against PyTorch autograd — they should match to many decimal places. That equivalence is the whole point: **autograd is just this, automated.**`,
  "Structured outputs and JSON schemas": `Free-form text is great for humans and terrible for programs. When an LLM's output feeds code, constrain it.

## Three levels of control

1. **Instructions only** — "Respond in JSON with keys …". Works most of the time; fails at scale.
2. **Schema + validation** — provide a JSON schema, validate the response, retry on failure.
3. **Constrained decoding** — the provider guarantees schema-valid output.

## Validate everything

\`\`\`python
from pydantic import BaseModel, Field

class Ticket(BaseModel):
    category: str = Field(pattern="^(billing|bug|feature)$")
    urgency: int = Field(ge=1, le=5)
    summary: str

ticket = Ticket.model_validate_json(llm_output)
\`\`\`

> Treat model output like user input: **parse, validate, and handle failure explicitly.**`,
  "Debugging training: a field guide": `When training goes wrong, work through this list in order — it catches the vast majority of issues.

1. **Overfit a single batch.** If loss won't go near zero on 8 examples, you have a bug, not a tuning problem.
2. **Check your data.** Visualize inputs *after* preprocessing. Are labels aligned?
3. **Check the loss at init.** For 10-class cross-entropy it should be ≈ ln(10) ≈ 2.30.
4. **Watch gradient norms.** Exploding → lower LR or clip; vanishing → check activations and init.
5. **Learning rate sweep.** Try 1e-4, 3e-4, 1e-3, 3e-3 for a few hundred steps.

\`\`\`python
total = 0.0
for p in model.parameters():
    if p.grad is not None:
        total += p.grad.norm().item() ** 2
print("grad norm:", total ** 0.5)
\`\`\``,
};
