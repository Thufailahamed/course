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
  {
    slug: "llm-engineering",
    title: "LLM Engineering: From Prompt to Production",
    subtitle: "Prompting, RAG, fine-tuning, evaluation and deployment for real-world LLM applications.",
    category: "generative-ai",
    instructor: "lena",
    level: "intermediate",
    price: 0,
    compareAt: null,
    accent: 292,
    featured: true,
    students: 31870,
    tags: ["LLMs", "RAG", "Fine-tuning", "Evaluation", "Embeddings"],
    learn: [
      "Design prompts and structured outputs that are reliable at scale",
      "Build retrieval-augmented generation (RAG) with vector search",
      "Fine-tune open models with LoRA for your domain",
      "Evaluate LLM systems with automated and human-in-the-loop evals",
      "Control cost and latency with caching, routing and batching",
      "Deploy, monitor and guardrail LLM features in production",
    ],
    requirements: ["Solid Python", "Basic familiarity with APIs and JSON", "No prior ML experience required"],
    audience: ["Software engineers building AI features", "Tech leads evaluating LLM architectures", "Founders prototyping AI products"],
    snippet: `def answer(question: str) -> str:\n    hits = index.search(embed(question), k=5)\n    context = "\\n\\n".join(h.text for h in hits)\n    return llm.generate(\n        system="Answer using only the context. Cite sources.",\n        prompt=f"Context:\\n{context}\\n\\nQuestion: {question}",\n    )`,
    sections: [
      ["How LLMs Work", ["v|Course overview|5", "v|Tokens, embeddings and attention in 15 minutes|15", "a|Sampling: temperature, top-p and friends|10"]],
      ["Prompt Engineering That Scales", ["v|Anatomy of a great prompt|14", "v|Few-shot, chain-of-thought and decomposition|18", "a|Structured outputs and JSON schemas|12", "q|Checkpoint: prompting"]],
      ["Retrieval-Augmented Generation", ["v|Why RAG?|9", "v|Chunking strategies|16", "v|Vector databases and hybrid search|19", "a|Reranking and query rewriting|14", "v|Building a RAG app end-to-end|28"]],
      ["Fine-tuning", ["v|When to fine-tune (and when not to)|12", "v|LoRA and parameter-efficient tuning|21", "a|Preparing instruction datasets|15"]],
      ["Evaluation", ["v|Offline evals: golden sets and rubrics|17", "v|LLM-as-a-judge, done carefully|15", "a|Regression testing for prompts|10"]],
      ["Production", ["v|Latency and cost optimization|16", "v|Guardrails, safety and prompt injection|18", "v|Observability and tracing|13", "q|Final assessment"]],
    ],
    quiz: [
      ["What is the main purpose of retrieval-augmented generation?", ["To make models smaller", "To ground responses in external, up-to-date knowledge", "To speed up tokenization", "To replace fine-tuning entirely"], 1, "RAG retrieves relevant documents at query time and supplies them as context."],
      ["LoRA fine-tuning works by…", ["Training every weight in the model", "Adding small low-rank update matrices to frozen weights", "Pruning attention heads", "Distilling into a smaller model"], 1, "LoRA learns low-rank adapters while the base weights stay frozen."],
      ["Lower sampling temperature generally makes outputs…", ["More random", "More deterministic", "Longer", "Multilingual"], 1, "Temperature scales logits; lower values sharpen the distribution."],
      ["Which is a key defense against prompt injection in tool-using apps?", ["Higher temperature", "Treating retrieved and user content as untrusted data, with least-privilege tools", "Longer system prompts", "Using a bigger model"], 1, "Separate instructions from data and limit what tools can do."],
    ],
  },
  {
    slug: "transformers-from-scratch",
    title: "Transformers from Scratch",
    subtitle: "Implement attention, build a GPT-style model and train it on your own data.",
    category: "deep-learning",
    instructor: "maya",
    level: "advanced",
    price: 0,
    compareAt: null,
    accent: 318,
    featured: true,
    students: 21460,
    tags: ["Transformers", "Attention", "GPT", "PyTorch"],
    learn: [
      "Derive and implement scaled dot-product and multi-head attention",
      "Build a decoder-only transformer (GPT) line by line",
      "Train a tokenizer with byte-pair encoding",
      "Apply modern tricks: RoPE, RMSNorm, KV-caching",
      "Scale training with mixed precision and gradient accumulation",
    ],
    requirements: ["Deep Learning Foundations or equivalent", "Comfort with PyTorch"],
    audience: ["ML engineers who want to understand LLM internals", "Researchers and grad students"],
    snippet: `def attention(q, k, v, mask=None):\n    scores = q @ k.transpose(-2, -1) / math.sqrt(q.size(-1))\n    if mask is not None:\n        scores = scores.masked_fill(mask == 0, float("-inf"))\n    return scores.softmax(dim=-1) @ v`,
    sections: [
      ["Why Attention", ["v|From RNNs to attention|14", "a|Reading 'Attention Is All You Need'|18"]],
      ["Attention, Implemented", ["v|Scaled dot-product attention|19", "v|Multi-head attention|17", "v|Causal masking|10", "q|Checkpoint: attention"]],
      ["Building GPT", ["v|Tokenization with BPE|21", "v|Embeddings and positional encoding|15", "v|The transformer block|23", "a|Putting it together: model.py|20"]],
      ["Training at Scale", ["v|Mixed precision and gradient accumulation|16", "v|Learning-rate warmup and cosine decay|11", "v|Sampling and KV-cache|18", "q|Final assessment"]],
    ],
    quiz: [
      ["Why divide attention scores by √d_k?", ["To normalize the output vectors", "To keep softmax inputs from growing with dimension and saturating", "To make attention causal", "To reduce memory"], 1, "Dot products grow with d_k; scaling keeps gradients healthy."],
      ["What does a causal mask prevent?", ["Attending to padding tokens", "Attending to future positions", "Exploding gradients", "Overfitting"], 1, "Decoder-only models must not see future tokens during training."],
      ["A KV-cache speeds up…", ["Training", "Autoregressive inference by reusing past keys and values", "Tokenization", "Backpropagation"], 1, "Previously computed keys/values are reused for each new token."],
    ],
  },
  {
    slug: "building-ai-agents",
    title: "Building Reliable AI Agents",
    subtitle: "Tool use, planning, memory and evaluation for agents that actually work in production.",
    category: "ai-agents",
    instructor: "lena",
    level: "intermediate",
    price: 0,
    compareAt: null,
    accent: 165,
    featured: true,
    students: 17920,
    tags: ["Agents", "Tool Use", "MCP", "Evaluation"],
    learn: [
      "Design agent loops with tools, planning and reflection",
      "Expose tools safely with schemas and permissions",
      "Add short- and long-term memory",
      "Orchestrate multi-agent workflows",
      "Evaluate agents with trajectories and task suites",
    ],
    requirements: ["LLM Engineering or equivalent experience calling LLM APIs"],
    audience: ["AI engineers", "Backend developers adding automation", "Product teams exploring agents"],
    snippet: `while True:\n    response = llm.chat(messages, tools=TOOLS)\n    if not response.tool_calls:\n        break\n    for call in response.tool_calls:\n        result = TOOLS[call.name](**call.arguments)\n        messages.append(tool_result(call.id, result))`,
    sections: [
      ["Agent Fundamentals", ["v|What makes something an agent?|11", "a|The agent loop|9", "v|Tool calling deep dive|18"]],
      ["Tools & Environments", ["v|Designing great tool interfaces|16", "v|Sandboxing and permissions|14", "a|Model Context Protocol (MCP) primer|12", "q|Checkpoint: tools"]],
      ["Planning & Memory", ["v|Planning strategies|17", "v|Memory architectures|15", "v|Context management for long tasks|13"]],
      ["Multi-agent Systems", ["v|Orchestrator–worker patterns|19", "a|When multi-agent is worth it|8"]],
      ["Shipping Agents", ["v|Evaluating agent trajectories|20", "v|Observability, cost and safety|15", "q|Final assessment"]],
    ],
    quiz: [
      ["What most distinguishes an agent from a single LLM call?", ["A larger model", "A loop where the model chooses actions, observes results and continues", "A longer prompt", "Fine-tuning"], 1, "Agents iterate: act, observe, decide."],
      ["Good tool design emphasizes…", ["As many parameters as possible", "Clear names, tight schemas and helpful error messages", "Returning raw HTML", "Hiding errors from the model"], 1, "Models use tools better when interfaces are clear and errors are actionable."],
      ["Agent evaluation should primarily look at…", ["Token count only", "Task success and the trajectory taken", "Response length", "Model temperature"], 1, "Outcome plus process reveals both failures and inefficiencies."],
    ],
  },
  {
    slug: "computer-vision-bootcamp",
    title: "Computer Vision Bootcamp",
    subtitle: "Classification, detection, segmentation and vision transformers with hands-on projects.",
    category: "computer-vision",
    instructor: "sofia",
    level: "intermediate",
    price: 0,
    compareAt: null,
    accent: 24,
    featured: false,
    students: 24310,
    tags: ["CNNs", "Object Detection", "Segmentation", "ViT"],
    learn: [
      "Master image preprocessing and augmentation",
      "Train state-of-the-art classifiers with transfer learning",
      "Build object detectors and understand YOLO-style models",
      "Segment images with U-Net",
      "Use vision transformers and CLIP",
    ],
    requirements: ["Python and basic PyTorch", "Some deep learning exposure helps"],
    audience: ["Engineers building vision features", "Robotics and imaging practitioners"],
    snippet: `import torchvision.transforms.v2 as T\n\ntrain_tf = T.Compose([\n    T.RandomResizedCrop(224),\n    T.RandomHorizontalFlip(),\n    T.ColorJitter(0.2, 0.2, 0.2),\n    T.ToImage(), T.ToDtype(torch.float32, scale=True),\n])`,
    sections: [
      ["Images as Data", ["v|Pixels, channels and color spaces|12", "a|Augmentation strategies|11"]],
      ["Classification", ["v|Modern CNN architectures|19", "v|Transfer learning in practice|17", "q|Checkpoint: classification"]],
      ["Detection", ["v|Bounding boxes, IoU and NMS|15", "v|One-stage vs two-stage detectors|18", "a|Training a detector on custom data|20"]],
      ["Segmentation", ["v|Semantic vs instance segmentation|12", "v|U-Net from scratch|22"]],
      ["Vision Transformers", ["v|ViT explained|16", "v|CLIP and zero-shot vision|14", "q|Final assessment"]],
    ],
    quiz: [
      ["Intersection over Union (IoU) measures…", ["Classification confidence", "Overlap between predicted and ground-truth boxes", "Model size", "Pixel intensity"], 1, "IoU = area of overlap / area of union."],
      ["Non-maximum suppression is used to…", ["Augment data", "Remove duplicate overlapping detections", "Normalize images", "Speed up training"], 1, "NMS keeps the highest-scoring box among overlapping ones."],
      ["CLIP enables zero-shot classification by…", ["Training on ImageNet only", "Aligning images and text in a shared embedding space", "Using larger CNNs", "Segmenting images"], 1, "Compare an image embedding with embeddings of text labels."],
    ],
  },
  {
    slug: "mlops-in-production",
    title: "MLOps: Shipping Models to Production",
    subtitle: "Pipelines, feature stores, CI/CD for ML, serving, monitoring and drift detection.",
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
      "Version data, code and models reproducibly",
      "Build training pipelines and feature stores",
      "Serve models with low latency",
      "Set up CI/CD and automated evaluation for ML",
      "Detect drift and monitor model quality",
    ],
    requirements: ["Experience training ML models", "Comfort with the command line and Docker basics"],
    audience: ["ML engineers", "Data scientists shipping their first models", "Platform engineers"],
    snippet: `@app.post("/predict")\nasync def predict(req: PredictRequest):\n    features = feature_store.get(req.user_id)\n    with latency.time():\n        score = model.predict_proba([features])[0, 1]\n    log_prediction(req.user_id, features, score)\n    return {"score": float(score)}`,
    sections: [
      ["The ML Lifecycle", ["v|Why most models never ship|10", "a|Maturity levels of MLOps|9"]],
      ["Reproducibility", ["v|Versioning data and models|15", "v|Experiment tracking|13", "q|Checkpoint: reproducibility"]],
      ["Pipelines & Features", ["v|Orchestrating training pipelines|18", "v|Feature stores|14", "a|Batch vs online features|11"]],
      ["Serving", ["v|Model serving patterns|17", "v|Optimizing inference latency|16"]],
      ["Monitoring", ["v|Data and concept drift|15", "v|Alerting and retraining loops|13", "q|Final assessment"]],
    ],
    quiz: [
      ["Concept drift means…", ["The input distribution changed", "The relationship between inputs and the target changed", "The model file is corrupted", "Latency increased"], 1, "P(y|x) shifts over time, so a once-good model degrades."],
      ["A feature store primarily helps to…", ["Train larger models", "Serve consistent features for training and inference", "Label data", "Replace databases"], 1, "It prevents training/serving skew."],
      ["Shadow deployment means…", ["Deploying at night", "Running a new model on live traffic without affecting responses", "Deleting old models", "Training on production data"], 1, "Compare predictions safely before switching."],
    ],
  },
  {
    slug: "nlp-with-transformers",
    title: "Modern NLP with Hugging Face",
    subtitle: "Tokenizers, embeddings, fine-tuning BERT-style models and evaluating NLP systems.",
    category: "nlp",
    instructor: "maya",
    level: "intermediate",
    price: 0,
    compareAt: null,
    accent: 340,
    featured: false,
    students: 18740,
    tags: ["NLP", "Hugging Face", "BERT", "Embeddings"],
    learn: [
      "Understand tokenization and subword vocabularies",
      "Use sentence embeddings for search and clustering",
      "Fine-tune encoders for classification and NER",
      "Evaluate NLP models properly",
    ],
    requirements: ["Python and basic PyTorch"],
    audience: ["Engineers building text features", "Data scientists working with language data"],
    snippet: `from transformers import AutoTokenizer, AutoModelForSequenceClassification\n\ntok = AutoTokenizer.from_pretrained("distilbert-base-uncased")\nmodel = AutoModelForSequenceClassification.from_pretrained(\n    "distilbert-base-uncased", num_labels=3\n)\nbatch = tok(["I loved it", "Not great"], padding=True, return_tensors="pt")\nlogits = model(**batch).logits`,
    sections: [
      ["Text as Data", ["v|From bag-of-words to embeddings|15", "a|Tokenization deep dive|12"]],
      ["Embeddings", ["v|Word and sentence embeddings|17", "v|Semantic search|16", "q|Checkpoint: embeddings"]],
      ["Fine-tuning Encoders", ["v|BERT and friends|18", "v|Text classification|20", "v|Named entity recognition|17"]],
      ["Evaluation", ["a|Metrics for NLP tasks|11", "v|Error analysis|13", "q|Final assessment"]],
    ],
    quiz: [
      ["Subword tokenization helps models…", ["Run faster on GPUs", "Handle rare and unseen words by composing known pieces", "Avoid attention", "Translate languages"], 1, "Rare words decompose into frequent subword units."],
      ["Cosine similarity between embeddings measures…", ["Their length", "The angle between them (semantic similarity)", "Their dimensionality", "Token count"], 1, "Direction encodes meaning; cosine compares direction."],
      ["BERT is pretrained mainly with…", ["Next-token prediction", "Masked language modeling", "Reinforcement learning", "Image captioning"], 1, "BERT predicts masked tokens using bidirectional context."],
    ],
  },
  {
    slug: "generative-ai-diffusion",
    title: "Generative AI: Diffusion Models",
    subtitle: "Understand and build the models behind modern image generation.",
    category: "generative-ai",
    instructor: "sofia",
    level: "advanced",
    price: 0,
    compareAt: null,
    accent: 275,
    featured: false,
    students: 11640,
    tags: ["Diffusion", "Image Generation", "U-Net", "Generative AI"],
    learn: [
      "Understand the forward and reverse diffusion processes",
      "Implement DDPM training and sampling",
      "Add text conditioning and classifier-free guidance",
      "Fine-tune with DreamBooth and LoRA",
    ],
    requirements: ["Deep Learning Foundations", "Comfort with probability basics"],
    audience: ["ML engineers and researchers", "Creative technologists"],
    snippet: `t = torch.randint(0, T, (x0.size(0),))\nnoise = torch.randn_like(x0)\nxt = sqrt_alpha_bar[t] * x0 + sqrt_one_minus_alpha_bar[t] * noise\nloss = F.mse_loss(model(xt, t), noise)`,
    sections: [
      ["Generative Modeling", ["v|The generative landscape: VAEs, GANs, diffusion|16", "a|Intuition for diffusion|10"]],
      ["DDPM", ["v|The forward noising process|15", "v|Learning to denoise|19", "v|Sampling|14", "q|Checkpoint: diffusion"]],
      ["Conditioning", ["v|Text conditioning with cross-attention|17", "v|Classifier-free guidance|12"]],
      ["Customization", ["v|Latent diffusion|15", "a|DreamBooth and LoRA fine-tuning|14", "q|Final assessment"]],
    ],
    quiz: [
      ["In DDPM training, the network typically learns to predict…", ["The class label", "The noise added to the image", "The next pixel", "The image caption"], 1, "Predicting ε is the standard, stable parameterization."],
      ["Classifier-free guidance trades off…", ["Speed and memory", "Sample diversity and adherence to the condition", "Resolution and color", "Training and inference"], 1, "Higher guidance → closer to the prompt, less diverse."],
      ["Latent diffusion runs the diffusion process…", ["In pixel space", "In a compressed autoencoder latent space", "On text tokens", "In frequency space only"], 1, "Working in latent space makes generation far cheaper."],
    ],
  },
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
