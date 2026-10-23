# Latent — a premium AI & ML course platform

Latent is a full-stack, single-vendor course marketplace: you create the courses and sell them. Everything runs on Cloudflare.

| Layer | Tech | Cloudflare product |
|---|---|---|
| Frontend | Next.js 16 (App Router), React 19, Tailwind CSS v4, Radix, TanStack Query, Motion | Workers via [OpenNext](https://opennext.js.org/cloudflare) |
| API | Hono 4 + Drizzle ORM + Zod | Workers |
| Database | SQLite | **D1** |
| Media (thumbnails, avatars, videos) | Multipart uploads, range streaming | **R2** |
| Rate limiting | Fixed-window counters | **KV** |
| AI tutor "Atlas" | Streaming chat grounded in the current lesson | **Workers AI** |
| Payments | Stripe Checkout (one-time + subscriptions), webhooks | — |

## Features

**Learners:** catalog with search, filters and a ⌘K palette · rich course pages (curriculum, previews, reviews, instructor) · cart with coupons · Stripe checkout · **Pro** all-access membership · dashboard with streaks and an activity heatmap · course player (custom video player with resume and auto-complete, articles with KaTeX math and code highlighting, quizzes, **interactive coding lessons** with in-browser Python, auto-checked challenges and a step-through debugger) · timestamped notes · per-lesson Q&A · AI tutor · verifiable, printable certificates · wishlist · profile, security and billing settings.

**Studio (instructors and admins):** revenue, enrollment and signup analytics · course editor · drag-and-drop curriculum builder · lesson editor (Markdown, quiz builder, resources, multipart video upload to R2) · publish workflow · Q&A inbox · review moderation. Admins also get students (roles, manual enrollments), orders and refunds, coupons, categories, learning paths, and team leads.

Instructors only see and manage their own courses. Admins see everything.

## Interactive lessons

Lessons of type `interactive` are Markdown with live cells. Learners write, run and debug real code **in the browser**: Python 3.14 and NumPy run in [Pyodide](https://pyodide.org) inside a Web Worker, JavaScript runs in the browser's own engine, Java and C run from WebAssembly toolchains, and HTML/CSS renders in a sandboxed live preview. No code ever runs on your servers.

- **Cells:** runnable examples that share a notebook-style kernel, auto-checked **challenges** with hidden tests and progressive hints, **debug challenges** (fix the bug), and **predict-the-output** questions.
- **HTML/CSS previews:** every HTML cell renders in a sandboxed iframe with desktop, tablet and phone widths. Challenges run JavaScript DOM/CSS assertions against the real rendered document, including `getComputedStyle`.
- **Debugger:** step forwards and backwards line by line, set breakpoints, and watch variables change. It records an execution trace with `sys.settrace` (Python).
- **Errors:** the failing line is highlighted, each error gets a plain-language tip, and **Explain with Atlas** sends the code and traceback to the AI tutor.
- **Progress:** solved challenges are stored per learner (`exercise_progress`). Solving every challenge completes the lesson. Solutions are stripped from learner payloads and fetched on demand.
- **Authoring:** in the studio, set the lesson type to *Interactive*, insert cells from the toolbar, then **Preview & run** and **Validate**.

Twenty-one fully interactive courses ship with the seed data:

| Course | Folder | Content |
|---|---|---|
| **Python Basics** | `apps/api/seed/courses/python-basics` | 30 lessons (3 capstone projects) and 8 quizzes, for complete beginners |
| **Python for Data Science** | `apps/api/seed/courses/python-for-data-science` | 10 interactive lessons and a checkpoint quiz: NumPy, pandas, matplotlib and an end-to-end EDA |
| **NumPy Mastery** | `apps/api/seed/courses/numpy` | 28 lessons and 8 quizzes |
| **Mathematics for Machine Learning** | `apps/api/seed/courses/math-for-machine-learning` | 16 lessons and 4 quizzes: vectors, matrices, eigenvalues, SVD and PCA, calculus and gradient descent, probability and maximum likelihood |
| **Deep Learning Foundations** | `apps/api/seed/courses/deep-learning-foundations` | 21 lessons and 5 quizzes: neurons, backpropagation from scratch, training networks, PyTorch in practice, CNNs, attention and a capstone image classifier. PyTorch code is shown for you to run locally; each idea also has a runnable NumPy version |
| **MLOps: Shipping Models to Production** | `apps/api/seed/courses/mlops-in-production` | 12 lessons and 4 quizzes: why models fail to ship and how to measure maturity, data fingerprints and experiment tracking, dependency ordering for pipelines, point-in-time features without leakage, batch and online features with cache freshness, micro-batching and latency percentiles, drift with the population stability index, and alerting and retraining rules with a monitored-model capstone. Docker, orchestration and cloud configuration are shown as static code; every mechanism runs in the page |
| **Building Reliable AI Agents** | `apps/api/seed/courses/building-ai-agents` | 12 lessons and 4 quizzes: the agent loop, tool calling and argument validation, tool interfaces that recover from errors, permissions and sandboxes, planning with retries, memory and context budgets, orchestrator-worker routing, the cost of multi-agent designs, trajectory evaluation, and an observability capstone. Agents run on a scripted model so every step works in the page; hosted-model and Model Context Protocol clients are shown as static code |
| **LLM Engineering: From Prompt to Production** | `apps/api/seed/courses/llm-engineering` | 12 lessons and 4 quizzes: sampling with temperature and top-p, prompt anatomy and token budgets, validated structured outputs, chunking, retrieval ranking with fusion, recall and reciprocal rank for RAG, instruction data, golden sets, LLM-as-a-judge calibration with Cohen's kappa, cost and latency, and guardrails. Calls to hosted models are shown as static code to run with your own key; every other step runs in the page |
| **Generative AI: Diffusion Models** | `apps/api/seed/courses/generative-ai-diffusion` | 12 lessons and 4 quizzes: the forward noising process, noise prediction, DDPM and DDIM sampling, noise schedules, cross-attention conditioning, classifier-free guidance, latent diffusion, LoRA, a DreamBooth recipe and a toy diffusion capstone. U-Net, cross-attention and LoRA layers are shown as PyTorch code for you to run locally; each idea also has a runnable NumPy version |
| **Computer Vision Bootcamp** | `apps/api/seed/courses/computer-vision-bootcamp` | 14 lessons and 4 quizzes: pixels and convolutions, augmentation, CNN architectures and receptive fields, transfer learning with a linear probe, IoU and NMS, anchors, training a detector, semantic and instance segmentation, U-Net, vision transformer patches, CLIP zero-shot classification and a detector capstone. PyTorch, torchvision and CLIP code is shown for you to run locally; each idea also has a runnable NumPy version |
| **Modern NLP with Transformers** | `apps/api/seed/courses/nlp-with-transformers` | 13 lessons and 3 quizzes: tokenization, bag-of-words and TF-IDF, word and sentence embeddings, semantic search, masked language models and pooling, named entities with span F1, imbalanced classes, overlap metrics such as ROUGE, error analysis, and a capstone text classifier that learns its features from training text only. Hugging Face model code is shown for you to run locally; each idea also has a runnable NumPy version |
| **Transformers from Scratch** | `apps/api/seed/courses/transformers-from-scratch` | 15 lessons and 3 quizzes: scaled and multi-head attention, causal masks and positions, byte-pair encoding, embeddings and layer normalization, the transformer block, a tiny GPT, next-token loss, schedules, mixed precision, sampling with a KV-cache, rotary positions and RMSNorm, and an evaluated capstone. The GPT training loop is shown as PyTorch code for local use |
| **Reinforcement Learning Essentials** | `apps/api/seed/courses/reinforcement-learning-essentials` | 16 lessons and 3 quizzes: agents and returns, bandits, Markov decision processes, dynamic programming, TD learning, Q-learning and SARSA, deep Q-networks, policy gradients, PPO, RLHF, DPO and reward hacking, with a capstone agent. Environments and algorithms run in NumPy; deep-learning code is shown for local use |
| **Practical Machine Learning with scikit-learn** | `apps/api/seed/courses/machine-learning-a-z` | 17 lessons and 3 quizzes: the ML workflow, linear and logistic regression, trees, forests, boosting and nearest neighbours built in NumPy, honest evaluation, leak-free pipelines, tuning, explanations and a churn capstone. scikit-learn and XGBoost code is shown for local use |
| **Python for Data Science** | `apps/api/seed/courses/python-for-data-science` | 17 lessons and 2 quizzes: Python containers and functions, NumPy arrays and missing values, pandas from loading to time series, honest charts with matplotlib, and a complete sales analysis capstone. Runs in the page with pandas and matplotlib |
| **JavaScript Basics** | `apps/api/seed/courses/javascript-basics` | 25 lessons (3 capstone projects) and 7 quizzes, from `console.log` to JSON and classes |
| **JavaScript Advanced** | `apps/api/seed/courses/javascript-advanced` | 24 lessons (3 capstone projects) and 7 quizzes: closures, prototypes, the event loop, async patterns |
| **Java Basics** | `apps/api/seed/courses/java-basics` | A complete first course, run in the browser through CheerpJ |
| **C Basics** | `apps/api/seed/courses/c-basics` | Pointers, memory and systems programming, compiled from WebAssembly |
| **C Advanced** | `apps/api/seed/courses/c-advanced` | Data structures and closer-to-the-metal C |
| **HTML & CSS Basics** | `apps/api/seed/courses/html-css-basics` | 17 lessons (2 capstone projects) and 6 quizzes, with a live sandboxed preview and DOM-checked challenges |
| **HTML & CSS Advanced** | `apps/api/seed/courses/html-css-advanced` | 17 lessons (2 capstone projects) and 5 quizzes: the cascade, container queries, motion, accessibility and performance |

See [`apps/api/seed/courses/AUTHORING.md`](apps/api/seed/courses/AUTHORING.md) for the cell syntax and quality bar. Every cell is machine-checked in the same runtime learners use:

```bash
cd apps/api && node seed/courses/validate.mjs numpy           # all lessons; add a file filter and --verbose
cd apps/api && node seed/courses/validate.mjs python-basics
cd apps/api && node seed/courses/validate.mjs python-for-data-science
cd apps/api && node seed/courses/validate.mjs math-for-machine-learning      # NumPy cells, same runtime as the course
cd apps/api && node seed/courses/validate.mjs deep-learning-foundations       # NumPy cells; PyTorch snippets are static
cd apps/api && node seed/courses/validate.mjs mlops-in-production
cd apps/api && node seed/courses/validate.mjs building-ai-agents
cd apps/api && node seed/courses/validate.mjs llm-engineering
cd apps/api && node seed/courses/validate.mjs generative-ai-diffusion
cd apps/api && node seed/courses/validate.mjs computer-vision-bootcamp
cd apps/api && node seed/courses/validate.mjs nlp-with-transformers
cd apps/api && node seed/courses/validate.mjs transformers-from-scratch
cd apps/api && node seed/courses/validate.mjs reinforcement-learning-essentials
cd apps/api && node seed/courses/validate.mjs machine-learning-a-z
cd apps/api && node seed/courses/validate.mjs python-for-data-science
cd apps/api && node seed/courses/validate.mjs html-css-basics 04 --verbose   # headless Chrome
pnpm --filter @latent/api db:course:math-for-machine-learning:local           # add or refresh one course without re-seeding everything
pnpm --filter @latent/api db:course:deep-learning-foundations:local            # same for deep-learning-foundations
pnpm --filter @latent/api db:course:mlops-in-production:local
pnpm --filter @latent/api db:course:building-ai-agents:local
pnpm --filter @latent/api db:course:llm-engineering:local
pnpm --filter @latent/api db:course:generative-ai-diffusion:local
pnpm --filter @latent/api db:course:computer-vision-bootcamp:local
pnpm --filter @latent/api db:course:nlp-with-transformers:local
pnpm --filter @latent/api db:course:transformers-from-scratch:local
pnpm --filter @latent/api db:course:reinforcement-learning-essentials:local
pnpm --filter @latent/api db:course:machine-learning-a-z:local
pnpm --filter @latent/api db:course:python-for-data-science:local
pnpm --filter @latent/api db:course:python-basics:local       # add or refresh one course without re-seeding everything
pnpm --filter @latent/api db:course:python-for-data-science:local
pnpm --filter @latent/api db:course:javascript-basics:local   # same for javascript-basics and javascript-advanced
pnpm --filter @latent/api db:course:html-css-basics:local     # HTML/CSS courses have the same one-course refresh
cd apps/api && node seed/courses/validate.mjs javascript-advanced   # JavaScript cells run in Node with the browser kernel
```

| Piece | Where |
|---|---|
| Kernel (namespaces, rich output, tracer, checks, completion) | `apps/web/public/runtime/kernel.py` |
| Web Worker host | `apps/web/public/runtime/python-worker.js` |
| HTML preview, test harness and CSS helpers | `packages/shared/src/html-harness.ts` |
| Runtime client, editor (CodeMirror 6), cells, debugger UI | `apps/web/src/components/code/` |
| Cell parser (shared by API, web and seed) | `packages/shared/src/interactive.ts` |

Pyodide loads from jsDelivr by default (cached after the first visit). Set `NEXT_PUBLIC_PYODIDE_URL` to self-host it. When the site is cross-origin isolated (COOP/COEP headers), **Stop** interrupts running code with `KeyboardInterrupt`; otherwise it restarts the worker. HTML/CSS previews need no download at all — the browser is the runtime.

## Repository layout

```
apps/
  api/                 Hono API worker
    src/routes/        auth, me, catalog, learn, commerce, admin
    src/db/schema.ts   Drizzle schema (D1)
    migrations/        generated SQL migrations
    seed/              demo catalog + seed generator
  web/                 Next.js app (OpenNext on Workers)
    src/app/(site)     marketing, catalog, course pages, cart, learner portal
    src/app/(auth)     login / signup / password reset
    src/app/learn      fullscreen course player
    src/app/studio     creator studio
    src/components/ui  design system
packages/
  shared/              shared types, zod schemas, formatters
```

The browser only talks to `/api/*` on the web origin. A Next route handler forwards those calls to the API worker: over a **service binding** in production, and to `API_URL` in local dev. Session cookies therefore stay first-party and httpOnly, and streaming responses (AI tutor, video ranges) pass straight through.

## Local development

Requirements: Node 20+ and pnpm 10+.

```bash
pnpm install
pnpm db:migrate        # apply D1 migrations to the local (Miniflare) database
pnpm db:seed           # demo catalog, users, orders, reviews
pnpm dev               # API on :8787 and web on :3000
```

Open http://localhost:3000.

| Role | Email | Password |
|---|---|---|
| Admin | admin@latent.dev | admin12345 |
| Instructor | maya@latent.dev | instructor12345 |
| Student | student@latent.dev | student12345 |

Local dev needs no Cloudflare account. D1, R2 and KV are simulated.

- **Payments:** without `STRIPE_SECRET_KEY`, checkout runs in *demo mode* and completes instantly. To use Stripe test mode, copy `apps/api/.dev.vars.example` to `apps/api/.dev.vars` and fill it in. Then forward webhooks with `stripe listen --forward-to localhost:8787/api/webhooks/stripe`.
- **AI tutor:** Workers AI has no local simulator. Run `npx wrangler login`, then `pnpm --filter @latent/api dev:ai` instead of `pnpm dev:api`. Without it, the tutor replies with a setup hint.
- **Email:** without `RESEND_API_KEY`, password-reset and receipt emails are printed to the API console.

## Deploying to Cloudflare

```bash
cd apps/api
npx wrangler login
npx wrangler d1 create latent-db               # copy database_id into wrangler.jsonc
npx wrangler kv namespace create KV            # copy id into wrangler.jsonc
npx wrangler r2 bucket create latent-media
# set APP_URL in wrangler.jsonc "vars" to your site URL
npx wrangler secret put STRIPE_SECRET_KEY
npx wrangler secret put STRIPE_WEBHOOK_SECRET
npx wrangler secret put RESEND_API_KEY          # optional
pnpm db:migrate:remote
pnpm db:seed:remote                             # optional demo data
pnpm deploy

cd ../web
pnpm deploy                                     # builds with OpenNext and deploys latent-web
```

> **Windows:** the OpenNext build creates symlinks, which Windows only allows with **Developer Mode** enabled (Settings → System → For developers) or from an elevated shell. Otherwise it fails with `EPERM: operation not permitted, symlink`. You can also build from WSL, or let CI deploy: `.github/workflows/deploy.yml` deploys both workers on every push to `main`. Add `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` repository secrets, plus a `SITE_URL` variable.

Then:

1. Attach your domain to the **latent-web** worker. The API needs no public route, because the web worker reaches it over the `API` service binding.
2. In Stripe, add a webhook endpoint at `https://<your-domain>/api/webhooks/stripe` for these events: `checkout.session.completed`, `checkout.session.async_payment_succeeded`, `customer.subscription.updated`, `customer.subscription.deleted`, `charge.refunded`.
3. Set `NEXT_PUBLIC_SITE_URL` for the web build so canonical URLs and the sitemap are correct.

### Video at scale

Lesson videos uploaded in the studio go to R2. They are streamed with HTTP range support, and access is checked per request (`/api/stream/:lessonId`). Lessons can also point at an external URL. For adaptive bitrate and DRM, Cloudflare Stream is a drop-in upgrade: store the Stream playback URL in `videoUrl`.

## Useful scripts

| Command | What it does |
|---|---|
| `pnpm dev` | Run API and web together |
| `pnpm typecheck` | Type-check every package |
| `pnpm db:generate` | Generate a migration after editing `apps/api/src/db/schema.ts` |
| `pnpm db:migrate` / `pnpm db:seed` | Migrate or seed the local database |
| `pnpm --filter @latent/web preview` | Build with OpenNext and preview on the Workers runtime locally |
