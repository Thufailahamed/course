// Building Reliable AI Agents: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs building-ai-agents
export const course = {
  slug: "building-ai-agents",
  title: "Building Reliable AI Agents",
  subtitle: "Agent loops, tool design, permissions, planning, memory, multi-agent systems and trajectory evaluation, built on a scripted model so every step can be tested.",
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
    "Write an agent loop with tool calls, a step budget and clear termination",
    "Design tool interfaces that validate arguments and return errors the model can act on",
    "Put permissions and a filesystem sandbox around every tool",
    "Plan, retry and manage memory and context within a token budget",
    "Decide when a multi-agent design is worth its cost",
    "Evaluate agents on trajectories and track cost, safety and observability",
  ],
  requirements: [
    "Python and basic familiarity with calling LLM APIs. The course uses a scripted model, so no API key is needed",
  ],
  audience: [
    "AI engineers who need agents that behave predictably",
    "Backend developers adding automation to existing systems",
    "Product teams deciding whether an agent is the right design",
  ],
  description: `An agent is a loop: a model reads the conversation, chooses a tool or a final answer, the program runs the tool, and the result goes back into the conversation. Most of what makes an agent reliable happens around that loop. The tools must validate their inputs, the permissions must stop the dangerous calls, the plan must recover from failure, the memory must fit the budget, and the evaluation must judge the whole trajectory, not only the final sentence.

## Learn by building

- **A scripted model.** Each lesson drives the agent with a fixed sequence of replies, so every behaviour is deterministic and can be tested in the page. No API key is needed.
- **Every guard in code.** Argument validation, error results, permission tiers, sandbox paths, retries, trimming and trajectory scores all run here.
- **Debug challenges.** You fix the bugs that break agents in production: a tool result attached to the wrong call, a path check that accepts a sibling directory, a retry loop with the wrong count, and a tie that is broken in an unpredictable order.
- **Real APIs shown honestly.** Calls to hosted models and the Model Context Protocol are static code for you to run with your own setup.

## What you'll cover

- **Agent fundamentals:** the loop, and tool calling.
- **Tools and environments:** interface design, permissions and sandboxing.
- **Planning and memory:** retries, recall and context management.
- **Multi-agent systems:** routing, and the cost of coordination.
- **Shipping agents:** trajectory evaluation, cost, observability and a capstone.

## Why this course?

Agents fail in ways that a single model call does not. They loop, they call the wrong tool with the wrong arguments, they run a dangerous action without asking, and they forget what they learned. This course gives you the mechanisms that prevent each of those failures, and the measurements that show whether they work.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "ReAct: Synergizing Reasoning and Acting in Language Models", url: "https://arxiv.org/abs/2210.03629" },
  { title: "Toolformer: Language Models Can Teach Themselves to Use Tools", url: "https://arxiv.org/abs/2302.04761" },
  { title: "Building effective agents (Anthropic)", url: "https://www.anthropic.com/research/building-effective-agents" },
  { title: "Model Context Protocol", url: "https://modelcontextprotocol.io" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Agent Fundamentals",
    lessons: [
      lesson("01-welcome.md", "How this course works", 6, { preview: true }),
      lesson("02-agent-loop.md", "The agent loop: model, tools, results", 16),
      lesson("03-tool-calling.md", "Tool calling and argument validation", 16),
    ],
  },
  {
    title: "Tools and Environments",
    lessons: [
      lesson("04-tool-interfaces.md", "Designing tool interfaces that recover from errors", 16),
      lesson("05-permissions-sandbox.md", "Permissions, sandboxes and the Model Context Protocol", 18),
      quiz("s1.json", "Checkpoint: tools"),
    ],
  },
  {
    title: "Planning and Memory",
    lessons: [
      lesson("06-planning-retries.md", "Planning with retries", 16),
      lesson("07-memory.md", "Short-term and long-term memory", 15),
      lesson("08-context-management.md", "Managing context within a token budget", 14),
      quiz("s2.json", "Checkpoint: planning and memory"),
    ],
  },
  {
    title: "Multi-agent Systems",
    lessons: [
      lesson("09-orchestrator-worker.md", "Orchestrator and worker agents", 18),
      lesson("10-when-multi-agent.md", "When multi-agent is worth its cost", 10),
      quiz("s3.json", "Checkpoint: multi-agent"),
    ],
  },
  {
    title: "Shipping Agents",
    lessons: [
      lesson("11-trajectory-evals.md", "Evaluating agent trajectories", 18),
      lesson("12-observability-capstone.md", "Observability, cost and a capstone", 24),
      quiz("s4.json", "Final assessment: Building Reliable AI Agents"),
    ],
  },
];
