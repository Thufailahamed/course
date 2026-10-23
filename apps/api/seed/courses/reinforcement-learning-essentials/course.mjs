// Reinforcement Learning Essentials: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs reinforcement-learning-essentials
export const course = {
  slug: "reinforcement-learning-essentials",
  title: "Reinforcement Learning Essentials",
  subtitle: "From bandits and Q-learning to policy gradients, PPO and the RLHF that aligns language models.",
  category: "machine-learning",
  instructor: "daniel",
  level: "advanced",
  price: 0,
  compareAt: null,
  accent: 8,
  featured: false,
  students: 9870,
  tags: ["Reinforcement Learning", "Q-Learning", "PPO", "RLHF"],
  learn: [
    "Formulate problems as Markov decision processes with states, actions, rewards and discounting",
    "Solve small problems exactly with dynamic programming, then learn from experience with TD and Q-learning",
    "Balance exploration and exploitation with bandits, epsilon-greedy and upper-confidence methods",
    "Derive the policy-gradient theorem and see why baselines and PPO make it stable",
    "Understand how RLHF trains a reward model and aligns language models, including DPO",
    "Recognise reward hacking and evaluate an agent honestly",
  ],
  requirements: [
    "Probability basics: expectations, conditional probability and averages",
    "Python and NumPy. The browser runs them; deep-learning code is shown for local use",
    "Calculus at the level of derivatives and the chain rule helps for the policy-gradient lessons",
  ],
  audience: [
    "Engineers who want to understand how agents learn from rewards",
    "Machine-learning practitioners curious about RLHF and language-model alignment",
    "Students who have finished supervised learning and want the next step",
  ],
  description: `Supervised learning answers "what is the right label?". Reinforcement learning answers a harder question: "what should I do next, given that my actions change what I see later?" Robots, recommendation systems, game players and language models trained with human feedback all rely on this idea.

This course builds the theory from the ground up. You will solve small decision problems exactly, learn values from experience, and train policies with gradients. Every algorithm is written in NumPy and run in the page, on environments you can inspect.

## Learn by building

- **Environments you can read.** Gridworlds, cliffs and bandits are small enough to inspect, and each lesson runs the agent on one.
- **Exact answers to check against.** Dynamic programming gives the true values, so you can confirm that your learning algorithm converges to them.
- **Challenges with hidden tests.** Your update rules and loss functions are checked on new numbers.
- **Debug challenges.** You fix the mistakes that break real agents: a discount applied twice, a bootstrap target that uses the wrong state, and a policy gradient with the wrong sign.
- **Deep-learning code, shown honestly.** DQN, PPO and RLHF training loops are shown as static code for PyTorch, with NumPy versions of their core equations that run here.

## What you'll cover

- **Foundations:** agents, rewards and returns; bandits; Markov decision processes.
- **Value-based methods:** dynamic programming, temporal-difference learning, Q-learning, exploration and deep Q-networks.
- **Policy-based methods:** policy gradients, baselines and actor-critic, and PPO.
- **RL for language models:** reward models, RLHF, DPO and reward hacking.
- **Capstone:** train an agent that solves a custom environment, and evaluate it honestly.

## Why this course?

Reinforcement learning is famous for spectacular results and notorious for fragile training. Understanding the equations behind the results is what lets you tell a sound agent from a lucky one, and that is the skill this course is built to give you.

You need probability and a little calculus. Everything else is introduced as you go.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "Reinforcement Learning: An Introduction (Sutton & Barto, free PDF)", url: "http://incompleteideas.net/book/the-book-2nd.html" },
  { title: "Spinning Up in Deep RL (OpenAI)", url: "https://spinningup.openai.com/" },
  { title: "Proximal Policy Optimization paper", url: "https://arxiv.org/abs/1707.06347" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Foundations",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-agents-rewards.md", "Agents, environments, rewards and returns", 16),
      lesson("03-bandits.md", "Multi-armed bandits: exploring under uncertainty", 18),
      lesson("04-markov-decision-processes.md", "Markov decision processes", 18),
    ],
  },
  {
    title: "Value-based Methods",
    lessons: [
      lesson("05-dynamic-programming.md", "Dynamic programming: exact values and policies", 20),
      lesson("06-temporal-difference.md", "Learning from experience: Monte Carlo and TD", 18),
      lesson("07-q-learning.md", "Q-learning: learning the value of actions", 20),
      lesson("08-exploration-sarsa.md", "Exploration and SARSA: on-policy versus off-policy", 16),
      lesson("09-deep-q-networks.md", "Deep Q-networks: function approximation and replay", 18),
      quiz("s1.json", "Checkpoint: value-based methods"),
    ],
  },
  {
    title: "Policy-based Methods",
    lessons: [
      lesson("10-policy-gradients.md", "Policy gradients: learning the policy directly", 20),
      lesson("11-baselines-actor-critic.md", "Baselines, advantages and actor-critic", 18),
      lesson("12-ppo.md", "Proximal policy optimization (PPO)", 18),
      quiz("s2.json", "Checkpoint: policy-based methods"),
    ],
  },
  {
    title: "Reinforcement Learning for Language Models",
    lessons: [
      lesson("13-rlhf.md", "RLHF: learning from human preferences", 20),
      lesson("14-dpo.md", "Direct preference optimization (DPO)", 16),
      lesson("15-reward-hacking-evaluation.md", "Reward hacking and honest evaluation", 16),
    ],
  },
  {
    title: "Capstone",
    lessons: [
      lesson("16-capstone-agent.md", "Capstone: train and evaluate an agent", 30),
      quiz("s3.json", "Final assessment: Reinforcement Learning Essentials"),
    ],
  },
];
