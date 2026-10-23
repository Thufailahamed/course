// Deep Learning Foundations: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs deep-learning-foundations
export const course = {
  slug: "deep-learning-foundations",
  title: "Deep Learning Foundations",
  subtitle: "Build neural networks from scratch, then master PyTorch — the intuition, the math and the code.",
  category: "deep-learning",
  instructor: "maya",
  level: "beginner",
  price: 0,
  compareAt: null,
  accent: 262,
  featured: true,
  students: 48210,
  tags: ["PyTorch", "Neural Networks", "Backpropagation", "CNNs", "Transformers"],
  learn: [
    "Implement a neural network, its forward pass and backpropagation from scratch in NumPy",
    "Check your gradients numerically and know when a training bug is in the math or the code",
    "Train, regularize and debug multi-layer networks with SGD, momentum and Adam",
    "Write the same training loop in PyTorch, and map every line back to the NumPy version",
    "Build convolutions, CNNs, recurrent networks and attention, and explain how each one works",
    "Finish with a capstone image classifier that you train and evaluate yourself",
  ],
  requirements: [
    "Comfortable writing Python functions, loops and lists",
    "High-school algebra. Calculus is taught as you go, with no prior calculus needed",
    "A modern browser. Python and NumPy run in the page; PyTorch code is shown for you to run on your own machine",
  ],
  audience: [
    "Software engineers moving into machine learning",
    "Data analysts who want to understand what happens inside a neural network",
    "Students preparing for machine-learning courses, research or roles",
  ],
  description: `Deep learning looks like magic until you have built the machinery yourself. A neural network is a stack of simple functions, its learning is the chain rule applied over and over, and every modern architecture is a small variation on the same loop: predict, measure the error, push the error backwards, take a step. This course builds that loop from first principles and then shows you how the professional tools implement it.

## Learn by building

- **Runnable NumPy everywhere.** Every neuron, layer, gradient and optimizer is code you write, run and break in the page.
- **Gradient checks.** You verify your backpropagation against finite differences, the same technique used to debug real frameworks.
- **Challenges with hidden tests.** Your functions are checked on fresh inputs, so they must be correct, not just pass one example.
- **Debug challenges.** You fix the bugs that real practitioners hit: a missing sum over the batch, a flipped transpose, dropout without rescaling and a learning rate that explodes.
- **PyTorch, mapped to NumPy.** Each PyTorch idea is shown next to the NumPy code you already wrote, so nothing in the framework is magic.

> **Honest note on PyTorch:** the browser runs NumPy, not PyTorch. The PyTorch lessons show complete PyTorch code for you to run on your own machine, and each one has runnable NumPy cells that compute the same thing.

## What you'll cover

- **Neurons and forward passes:** the artificial neuron, activation functions, batched layers and loss functions.
- **How networks learn:** gradient descent, computational graphs, a tiny autograd engine and backpropagation through a dense layer.
- **Training networks:** full training loops, optimizers, regularization, initialization and normalization.
- **PyTorch in practice:** tensors and autograd, the training loop and a field guide to debugging training.
- **Convolutional and sequence models:** convolutions, CNNs, recurrent networks and the attention mechanism behind Transformers.
- **Capstone:** train and evaluate an image classifier end to end.

## Why this course?

Most introductions show you how to call a framework. This one shows you what the framework is doing. When your model's loss is NaN, or your validation accuracy is stuck, you will know where to look, because you have already built the parts that can go wrong.

You need Python and basic algebra. Everything else is taught from the ground up.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "Neural Networks: Zero to Hero (Andrej Karpathy)", url: "https://karpathy.ai/zero-to-hero.html" },
  { title: "Dive into Deep Learning (free, interactive book)", url: "https://d2l.ai/" },
  { title: "PyTorch tutorials", url: "https://pytorch.org/tutorials/" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Neurons and Forward Passes",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-artificial-neuron.md", "The artificial neuron", 16),
      lesson("03-activation-functions.md", "Activation functions and why they matter", 16),
      lesson("04-forward-pass.md", "The forward pass for a batch of data", 18),
      lesson("05-loss-functions.md", "Loss functions: measuring how wrong a model is", 18),
    ],
  },
  {
    title: "How Networks Learn",
    lessons: [
      lesson("06-gradient-descent-one-neuron.md", "Gradient descent for a single neuron", 16),
      lesson("07-computational-graphs.md", "Computational graphs and the chain rule", 16),
      lesson("08-autograd-from-scratch.md", "Backpropagation with a tiny autograd engine", 20),
      lesson("09-backprop-dense-layer.md", "Backpropagation through a dense layer", 20),
      quiz("s1.json", "Checkpoint: neurons and backpropagation"),
    ],
  },
  {
    title: "Training Networks",
    lessons: [
      lesson("10-training-an-mlp.md", "Training a multi-layer network from scratch", 20),
      lesson("11-optimizers.md", "Optimizers: momentum, RMSProp and Adam", 18),
      lesson("12-regularization.md", "Overfitting, dropout and weight decay", 18),
      lesson("13-initialization-normalization.md", "Initialization and normalization", 16),
      quiz("s2.json", "Checkpoint: training networks"),
    ],
  },
  {
    title: "PyTorch in Practice",
    lessons: [
      lesson("14-tensors-autograd.md", "Tensors and autograd in PyTorch", 16),
      lesson("15-training-loop-pytorch.md", "The PyTorch training loop", 18),
      lesson("16-debugging-training.md", "Debugging training: a field guide", 18),
      quiz("s3.json", "Checkpoint: PyTorch in practice"),
    ],
  },
  {
    title: "Convolutional and Sequence Models",
    lessons: [
      lesson("17-convolutions.md", "Convolutions from first principles", 18),
      lesson("18-cnns.md", "Building convolutional networks", 18),
      lesson("19-recurrent-networks.md", "Recurrent networks and vanishing gradients", 16),
      lesson("20-attention-transformers.md", "Attention: the core of Transformers", 18),
      quiz("s4.json", "Checkpoint: convolutional and sequence models"),
    ],
  },
  {
    title: "Capstone",
    lessons: [
      lesson("21-capstone-shape-classifier.md", "Capstone: train an image classifier end to end", 30),
      quiz("s5.json", "Final assessment: Deep Learning Foundations"),
    ],
  },
];
