DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_reinforcement_learning_essentials');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_reinforcement_learning_essentials');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_reinforcement_learning_essentials');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_reinforcement_learning_essentials');

DELETE FROM discussions WHERE course_id = 'crs_reinforcement_learning_essentials';

DELETE FROM certificates WHERE course_id = 'crs_reinforcement_learning_essentials';

DELETE FROM enrollments WHERE course_id = 'crs_reinforcement_learning_essentials';

DELETE FROM reviews WHERE course_id = 'crs_reinforcement_learning_essentials';

DELETE FROM wishlist WHERE course_id = 'crs_reinforcement_learning_essentials';

DELETE FROM path_courses WHERE course_id = 'crs_reinforcement_learning_essentials';

DELETE FROM coupons WHERE course_id = 'crs_reinforcement_learning_essentials';

DELETE FROM lessons WHERE course_id = 'crs_reinforcement_learning_essentials';

DELETE FROM sections WHERE course_id = 'crs_reinforcement_learning_essentials';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_reinforcement_learning_essentials';

DELETE FROM courses WHERE id = 'crs_reinforcement_learning_essentials';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_machine-learning', 'machine-learning', 'Machine Learning', 'Classical ML, from regression to gradient boosting.', 'brain', 0);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_reinforcement_learning_essentials', 'reinforcement-learning-essentials', 'Reinforcement Learning Essentials', 'From bandits and Q-learning to policy gradients, PPO and the RLHF that aligns language models.', 'Supervised learning answers "what is the right label?". Reinforcement learning answers a harder question: "what should I do next, given that my actions change what I see later?" Robots, recommendation systems, game players and language models trained with human feedback all rely on this idea.

This course builds the theory from the ground up. You will solve small decision problems exactly, learn values from experience, and train policies with gradients. Every algorithm is written in NumPy and run in the page, on environments you can inspect.

## Learn by building

- **Environments you can read.** Gridworlds, cliffs and bandits are small enough to inspect, and each lesson runs the agent on one.
- **Exact answers to check against.** Dynamic programming gives the true values, so you can confirm that your learning algorithm converges to them.
- **Challenges with hidden tests.** Your update rules and loss functions are checked on new numbers.
- **Debug challenges.** You fix the mistakes that break real agents: a discount applied twice, a bootstrap target that uses the wrong state, and a policy gradient with the wrong sign.
- **Deep-learning code, shown honestly.** DQN, PPO and RLHF training loops are shown as static code for PyTorch, with NumPy versions of their core equations that run here.

## What you''ll cover

- **Foundations:** agents, rewards and returns; bandits; Markov decision processes.
- **Value-based methods:** dynamic programming, temporal-difference learning, Q-learning, exploration and deep Q-networks.
- **Policy-based methods:** policy gradients, baselines and actor-critic, and PPO.
- **RL for language models:** reward models, RLHF, DPO and reward hacking.
- **Capstone:** train an agent that solves a custom environment, and evaluate it honestly.

## Why this course?

Reinforcement learning is famous for spectacular results and notorious for fragile training. Understanding the equations behind the results is what lets you tell a sound agent from a lucky one, and that is the skill this course is built to give you.

You need probability and a little calculus. Everything else is introduced as you go.', 'cat_machine-learning', 'usr_daniel', 'advanced', 'English', 0, NULL, 'USD', NULL, NULL, 8, 'published', 0, '["Formulate problems as Markov decision processes with states, actions, rewards and discounting","Solve small problems exactly with dynamic programming, then learn from experience with TD and Q-learning","Balance exploration and exploitation with bandits, epsilon-greedy and upper-confidence methods","Derive the policy-gradient theorem and see why baselines and PPO make it stable","Understand how RLHF trains a reward model and aligns language models, including DPO","Recognise reward hacking and evaluate an agent honestly"]', '["Probability basics: expectations, conditional probability and averages","Python and NumPy. The browser runs them; deep-learning code is shown for local use","Calculus at the level of derivatives and the chain rule helps for the policy-gradient lessons"]', '["Engineers who want to understand how agents learn from rewards","Machine-learning practitioners curious about RLHF and language-model alignment","Students who have finished supervised learning and want the next step"]', '["Reinforcement Learning","Q-Learning","PPO","RLHF"]', 311, 19, 0, 0, 9870, '2026-01-26T06:54:38.127Z', '2025-12-27T06:54:38.127Z', '2026-10-14T06:54:38.127Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_reinforcement_learning_essentials_1', 'crs_reinforcement_learning_essentials', 'Foundations', 0, '2026-06-25T06:54:38.127Z'),
('sec_reinforcement_learning_essentials_2', 'crs_reinforcement_learning_essentials', 'Value-based Methods', 1, '2026-06-25T06:54:38.127Z'),
('sec_reinforcement_learning_essentials_3', 'crs_reinforcement_learning_essentials', 'Policy-based Methods', 2, '2026-06-25T06:54:38.127Z'),
('sec_reinforcement_learning_essentials_4', 'crs_reinforcement_learning_essentials', 'Reinforcement Learning for Language Models', 3, '2026-06-25T06:54:38.127Z'),
('sec_reinforcement_learning_essentials_5', 'crs_reinforcement_learning_essentials', 'Capstone', 4, '2026-06-25T06:54:38.127Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_reinforcement_learning_essentials_1_1', 'sec_reinforcement_learning_essentials_1', 'crs_reinforcement_learning_essentials', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'Welcome to **Reinforcement Learning Essentials**. In supervised learning, someone tells the model the right answer for every example. In reinforcement learning, nobody does. An agent acts, the world responds, and the only feedback is a reward that may arrive long after the action that earned it. Learning to act well in that situation is one of the hardest and most useful problems in machine learning.

This course is for people who are ready for the mathematics. You will meet the central equations, implement the algorithms with NumPy, and check each one against an exact answer where one exists. The deep-learning versions are shown as static PyTorch code for you to run locally, and each has a NumPy version that runs here.

> **How to use this lesson:** read a little, run a little. Every grey box runs in the page.

## Run your first agent

Here is the smallest possible reinforcement-learning loop: an agent in a corridor of five cells, with a reward for reaching the right-hand end. It moves at random for now.

```python run
import numpy as np

rng = np.random.default_rng(0)
position, steps = 0, 0
while position < 4 and steps < 100:
    action = rng.choice([-1, 1])                 # left or right, at random
    position = int(np.clip(position + action, 0, 4))
    steps += 1
print("reached the goal after", steps, "random steps")
```

A random walk eventually finds the goal, but slowly. Reinforcement learning is about learning to reach it quickly, from the rewards alone.

## Predict the return

```python predict id=predict-return title="What is the discounted return?"
rewards = [0.0, 0.0, 1.0]
gamma = 0.5
print(sum(gamma ** t * r for t, r in enumerate(rewards)))
--- options
* 0.25
1.0
0.5
0.125
--- explain
The reward of 1 arrives at time step 2, so it is discounted by gamma squared, which is 0.5 × 0.5 = 0.25. The earlier rewards are zero and add nothing. Discounting makes distant rewards worth less than immediate ones.
```

## Your first challenge

A **challenge** asks you to write a function that the course tests on new data.

```python exercise id=discounted-return title="Compute a discounted return"
# TODO: `discounted_return(rewards, gamma)` returns Σ γᵗ rₜ for the list of rewards, where t starts at 0.
def discounted_return(rewards, gamma):
    ...
--- solution
def discounted_return(rewards, gamma):
    return sum(gamma ** t * r for t, r in enumerate(rewards))
--- test
result = discounted_return([1.0, 1.0, 1.0], 0.5)
assert result is not None, "Replace the `...` in `discounted_return` with code that returns the return."
assert abs(result - 1.75) < 1e-9, f"With gamma 0.5 the return is 1 + 0.5 + 0.25 = 1.75, but you returned {result!r}."
assert discounted_return([], 0.9) == 0, "An empty list of rewards has return 0."
assert abs(discounted_return([0.0, 2.0], 0.1) - 0.2) < 1e-9, "The second reward is discounted by gamma once: 2 × 0.1 = 0.2."
--- hint
Use `enumerate` to get the step number `t` alongside each reward, and multiply the reward by `gamma ** t`.
--- hint
`sum(gamma ** t * r for t, r in enumerate(rewards))`.
```

## Debug the discount

This code is meant to discount rewards by how far in the future they arrive, but it discounts the first reward twice.

```python debug id=double-discount title="Discount each reward once"
rewards = [1.0, 2.0, 3.0]
gamma = 0.5
total = 0.0
for t, r in enumerate(rewards):
    total += gamma ** (t + 1) * r          # bug: the first reward is discounted by gamma once already
print("return:", total)
--- solution
rewards = [1.0, 2.0, 3.0]
gamma = 0.5
total = 0.0
for t, r in enumerate(rewards):
    total += gamma ** t * r
print("return:", total)
--- test
assert abs(total - 2.75) < 1e-9, f"With gamma 0.5 the return is 1 + 2·0.5 + 3·0.25 = 2.75, but the code gives {total}. The first reward should not be discounted."
--- hint
The first reward arrives at time zero, so it should not be discounted at all.
--- hint
Use `gamma ** t`, not `gamma ** (t + 1)`.
```

## Recap

- An agent acts in an environment and receives rewards. Its goal is the total discounted return, not the next reward.
- The discount factor $\gamma$ makes near rewards count more than distant ones.
- Learning must come from rewards alone, with no labelled answers.
- Every method in this course is a different way of estimating or using returns.

**Up next:** agents, environments and rewards in more depth, with the idea of a return made precise.
', 1, '[]', '[{"title":"Reinforcement Learning: An Introduction (Sutton & Barto, free PDF)","url":"http://incompleteideas.net/book/the-book-2nd.html"},{"title":"Spinning Up in Deep RL (OpenAI)","url":"https://spinningup.openai.com/"},{"title":"Proximal Policy Optimization paper","url":"https://arxiv.org/abs/1707.06347"}]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_1_2', 'sec_reinforcement_learning_essentials_1', 'crs_reinforcement_learning_essentials', 'Agents, environments, rewards and returns', 'interactive', 1, 960, NULL, NULL, 'Reinforcement learning has four moving parts. The **agent** chooses actions. The **environment** responds to each action with a new situation and a reward. A **policy** is the agent''s rule for choosing actions, and the **return** is the total reward the agent is trying to maximize. Almost every algorithm in this course is a way of improving a policy by estimating returns.

## The interaction loop

At each step the agent observes a state $s_t$, picks an action $a_t$, and the environment returns a reward $r_{t+1}$ and the next state $s_{t+1}$. The sequence of those steps is an **episode**.

```python run
import numpy as np

class Corridor:
    """Five cells in a row. Reaching cell 4 gives reward 1 and ends the episode."""
    def __init__(self):
        self.n = 5
    def reset(self):
        self.s = 0
        return self.s
    def step(self, action):                  # action 0 = left, 1 = right
        self.s = int(np.clip(self.s + (1 if action == 1 else -1), 0, self.n - 1))
        done = self.s == self.n - 1
        return self.s, (1.0 if done else 0.0), done

env = Corridor()
state = env.reset()
trajectory = []
done = False
while not done:
    action = 1                               # a fixed policy: always move right
    next_state, reward, done = env.step(action)
    trajectory.append((state, action, reward))
    state = next_state
print("trajectory (state, action, reward):", trajectory)
```

A trajectory is the raw data of reinforcement learning. Every learning algorithm reads these tuples and asks which actions led to good returns.

## Returns: what the agent optimizes

The return from time $t$ is the discounted sum of future rewards:

$$
G_t = r_{t+1} + \gamma\, r_{t+2} + \gamma^2 r_{t+3} + \dots = \sum_{k=0}^{\infty} \gamma^k r_{t+k+1}
$$

The discount $\gamma$ between 0 and 1 expresses two things: a preference for sooner rewards, and uncertainty about the far future.

```python run
def returns_from(rewards, gamma):
    G, out = 0.0, []
    for r in reversed(rewards):              # work backwards so each return reuses the next one
        G = r + gamma * G
        out.append(G)
    return list(reversed(out))

rewards = [0.0, 0.0, 1.0]
print("returns with gamma 0.9:", np.round(returns_from(rewards, 0.9), 3))
print("returns with gamma 0.5:", np.round(returns_from(rewards, 0.5), 3))
```

Computing returns backwards, as above, is standard. Each return is a reward plus the discounted return that follows.

How long do episodes last under a random policy? Run twenty episodes and average their lengths.

```python run
rng_len = np.random.default_rng(1)
lengths = []
for _ in range(20):
    env = Corridor()
    s, done, steps = env.reset(), False, 0
    while not done and steps < 500:
        s, _, done = env.step(int(rng_len.integers(2)))
        steps += 1
    lengths.append(steps)
print("average random-policy episode length:", round(float(np.mean(lengths)), 1))
```

Random behaviour takes much longer than the four steps a deliberate agent needs, which is the gap that learning closes.

## Policies

A **deterministic** policy maps each state to one action. A **stochastic** policy gives a probability for each action, and a stochastic policy is what makes exploration possible.

```python run
rng = np.random.default_rng(0)
probs_right = np.array([0.9, 0.5, 0.1])       # probability of moving right, by state
for s, p in enumerate(probs_right):
    sample = rng.random(2000) < p
    print(f"state {s}: moves right {sample.mean():.2f} of the time")
```

## Predict the return

```python predict id=predict-gamma title="What is the return at time 0 with gamma 0.5?"
print(round(sum(0.5 ** k * r for k, r in enumerate([2.0, 0.0, 4.0])), 2))
--- options
* 3.0
6.0
2.0
4.0
--- explain
The rewards are 2 at time 0, 0 at time 1 and 4 at time 2. The last one is discounted by 0.5 squared, so 4 × 0.25 = 1. The total is 2 + 0 + 1 = 3.
```

## Challenge: returns for every step

```python exercise id=returns-each-step title="The return at every time step"
# TODO: `returns_each_step(rewards, gamma)` returns a list G where G[t] is the discounted return starting at step t,
# that is, Σₖ γᵏ rₜ₊ₖ. Compute it backwards, so each return uses the one after it.
def returns_each_step(rewards, gamma):
    ...
--- solution
def returns_each_step(rewards, gamma):
    G, out = 0.0, []
    for r in reversed(rewards):
        G = r + gamma * G
        out.append(G)
    return list(reversed(out))
--- test
result = returns_each_step([0.0, 0.0, 1.0], 0.5)
assert result is not None, "Replace the `...` in `returns_each_step` with code that returns the list."
assert len(result) == 3, "There should be one return per reward."
assert abs(result[0] - 0.25) < 1e-9 and abs(result[2] - 1.0) < 1e-9, f"With gamma 0.5 the returns are [0.25, 0.5, 1.0], but you returned {result}."
assert returns_each_step([], 0.9) == [], "An empty trajectory has no returns."
--- hint
Walk through the rewards from the last one to the first, keeping a running return `G = r + gamma * G`.
--- hint
Collect the values as you go, then reverse the list so index 0 corresponds to the first step.
```

## Challenge: total reward of a trajectory

```python exercise id=total-reward title="Total the rewards of a trajectory"
# TODO: `total_reward(trajectory)` takes a list of (state, action, reward) tuples and returns the sum of their rewards.
def total_reward(trajectory):
    ...
--- solution
def total_reward(trajectory):
    return sum(reward for _, _, reward in trajectory)
--- test
result = total_reward([(0, 1, 0.0), (1, 1, 0.0), (2, 0, 1.0)])
assert result is not None, "Replace the `...` in `total_reward` with code that returns the sum."
assert result == 1.0, f"The rewards are 0, 0 and 1, which sum to 1, but you returned {result!r}."
assert total_reward([]) == 0, "An empty trajectory has total reward 0."
--- hint
Each element of the list is a tuple, so unpack the reward from each one and add them up.
--- hint
`sum(reward for _, _, reward in trajectory)`.
```

## Debug the reversed list

This code computes the returns but returns them in the wrong order, so the first step gets the last return.

```python debug id=return-order title="Return the returns in time order"
rewards = [0.0, 0.0, 1.0]
gamma = 0.5
G, out = 0.0, []
for r in reversed(rewards):
    G = r + gamma * G
    out.append(G)
print("returns in time order:", out)               # bug: the list is still in reverse order
--- solution
rewards = [0.0, 0.0, 1.0]
gamma = 0.5
G, out = 0.0, []
for r in reversed(rewards):
    G = r + gamma * G
    out.append(G)
out = list(reversed(out))
print("returns in time order:", out)
--- test
assert np.allclose(out, [0.25, 0.5, 1.0]), f"out[0] should be the return from the first step, 0.25, but the list is {out}. Reverse it before printing."
--- hint
The loop runs from the last step to the first, so `out` is built backwards.
--- hint
Reverse the list after the loop with `list(reversed(out))`.
```

## Recap

- An agent, an environment, a policy and a return are the four parts of every reinforcement-learning problem.
- A trajectory is a sequence of states, actions and rewards, and every learning algorithm reads these.
- The return is the discounted sum of future rewards, and it is computed backwards.
- A stochastic policy gives probabilities over actions, which makes exploration possible.

**Up next:** the simplest decision problem with learning, the multi-armed bandit.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_1_3', 'sec_reinforcement_learning_essentials_1', 'crs_reinforcement_learning_essentials', 'Multi-armed bandits: exploring under uncertainty', 'interactive', 2, 1080, NULL, NULL, 'A **multi-armed bandit** is the simplest decision problem that needs learning. You face several slot machines, each with an unknown average payout. Pull an arm, observe a reward, and repeat. The dilemma is exploration versus exploitation: pulling the arm you currently believe is best earns reward now, but trying the others might reveal a better one. Every reinforcement-learning method has to solve this dilemma in some form.

## Estimating an arm''s value

The value of an action is its expected reward. After $n$ pulls of an arm, the best estimate of its value is the sample average of its rewards, and it can be updated one pull at a time:

$$
Q_{n+1} = Q_n + \frac{1}{n + 1}\bigl(R_{n+1} - Q_n\bigr)
$$

```python run
import numpy as np

rng = np.random.default_rng(0)
true_mean = 0.7
estimate, count = 0.0, 0
for _ in range(20):
    reward = rng.normal(true_mean, 1.0)
    count += 1
    estimate += (reward - estimate) / count     # incremental average, no need to store rewards
print("estimate after 20 pulls:", round(estimate, 3), "| true value:", true_mean)
```

The update moves the estimate a little towards each new reward, with a step that shrinks as evidence accumulates. It is the same running-average rule that will reappear in every learning algorithm in this course.

## Epsilon-greedy

The simplest exploration rule is epsilon-greedy: with probability $\varepsilon$ pick a random arm, and otherwise pick the arm with the highest estimate.

```python run
def run_bandit(true_means, epsilon, pulls, rng):
    k = len(true_means)
    Q, N = np.zeros(k), np.zeros(k)
    total = 0.0
    for _ in range(pulls):
        if rng.random() < epsilon:
            a = rng.integers(k)
        else:
            a = int(np.argmax(Q))
        r = rng.normal(true_means[a], 1.0)
        N[a] += 1
        Q[a] += (r - Q[a]) / N[a]
        total += r
    return total / pulls

means = np.array([0.2, 0.5, 0.9, 0.4])
for eps in [0.0, 0.1, 0.3]:
    avg = np.mean([run_bandit(means, eps, 1000, np.random.default_rng(s)) for s in range(20)])
    print(f"epsilon {eps}: average reward per pull {avg:.3f}")
```

With no exploration the agent can lock onto a poor arm early. A little exploration finds the best arm, while too much keeps wasting pulls on bad ones.

## Upper confidence bounds

Epsilon-greedy explores blindly. The upper-confidence-bound rule explores the arms that are uncertain, choosing the arm with the highest estimate plus a bonus that shrinks as the arm is pulled more.

$$
A_t = \arg\max_a \left[ Q_t(a) + c \sqrt{\frac{\ln t}{N_t(a)}} \right]
$$

```python run
def run_ucb(true_means, c, pulls, rng):
    k = len(true_means)
    Q, N = np.zeros(k), np.zeros(k)
    total = 0.0
    for t in range(1, pulls + 1):
        if t <= k:
            a = t - 1                          # try every arm once first
        else:
            a = int(np.argmax(Q + c * np.sqrt(np.log(t) / N)))
        r = rng.normal(true_means[a], 1.0)
        N[a] += 1
        Q[a] += (r - Q[a]) / N[a]
        total += r
    return total / pulls

avg_ucb = np.mean([run_ucb(means, 1.0, 1000, np.random.default_rng(s)) for s in range(20)])
print(f"UCB (c = 1): average reward per pull {avg_ucb:.3f}")
```

## Regret measures the cost of learning

**Regret** is the reward you lost compared with always playing the best arm. A good algorithm has regret that grows slowly, so its average reward approaches the best arm''s value.

```python run
best = means.max()
print("best arm value:", best)
print("UCB average reward is within", round(best - avg_ucb, 3), "of the best arm")
```

> **In the wild:** bandit algorithms choose which article to show, which advertisement to serve and which treatment to try first. The same exploration trade-off appears in every reinforcement-learning system.

## Challenge: incremental mean

```python exercise id=incremental-mean title="Update an estimate with one reward"
# TODO: `update_estimate(estimate, count, reward)` returns (new_estimate, new_count), where new_count is count + 1 and
# new_estimate is the average of all rewards seen so far, computed incrementally: estimate + (reward − estimate) / new_count.
def update_estimate(estimate, count, reward):
    ...
--- solution
def update_estimate(estimate, count, reward):
    count = count + 1
    return estimate + (reward - estimate) / count, count
--- test
result = update_estimate(2.0, 1, 4.0)
assert result is not None, "Replace the `...` in `update_estimate` with code that returns (estimate, count)."
new_est, new_count = result
assert new_count == 2, "The count should go from 1 to 2."
assert abs(new_est - 3.0) < 1e-9, f"The average of the rewards 2 and 4 is 3, but you returned {new_est!r}."
e, c = 0.0, 0
for r in [3.0, 1.0, 8.0]:
    e, c = update_estimate(e, c, r)
assert abs(e - 4.0) < 1e-9 and c == 3, "After rewards 3, 1 and 8 the average is 4, with a count of 3."
--- hint
The new count is one more than the old count. The estimate moves towards the reward by one over the new count.
--- hint
`count = count + 1` and `return estimate + (reward - estimate) / count, count`.
```

## Challenge: epsilon-greedy choice

```python exercise id=epsilon-choice title="Choose an arm with epsilon-greedy"
import numpy as np

# TODO: `epsilon_greedy(Q, epsilon, u)` returns an arm index. With probability epsilon (u < epsilon) return a
# uniformly random index of the form int(u * len(Q) / epsilon) clipped to the last arm; otherwise return the index of
# the largest value in Q, using the first one on ties. Here u is a number drawn from [0, 1) by the caller.
def epsilon_greedy(Q, epsilon, u):
    ...
--- solution
import numpy as np

def epsilon_greedy(Q, epsilon, u):
    Q = np.asarray(Q, dtype=float)
    if u < epsilon:
        return min(int(u / epsilon * len(Q)), len(Q) - 1)
    return int(np.argmax(Q))
--- test
import numpy as np
Q_t = np.array([0.1, 0.9, 0.3])
assert epsilon_greedy(Q_t, 0.1, 0.5) == 1, "With u = 0.5 above epsilon, the agent should exploit and pick the best arm, index 1."
assert epsilon_greedy(Q_t, 0.1, 0.99) == 1, "With u above epsilon the agent always exploits."
assert epsilon_greedy(np.array([0.0, 0.0]), 1.0, 0.0) == 0, "With epsilon 1 and u = 0 the agent explores the first arm."
assert epsilon_greedy(np.array([0.2, 0.2, 0.2]), 0.0, 0.5) == 0, "Ties go to the first arm when exploiting."
--- hint
Compare `u` with `epsilon` first. If `u < epsilon`, explore; otherwise return `np.argmax(Q)`.
--- hint
When exploring, scale `u` by `len(Q) / epsilon` to get an index, and clip it to the last index.
```

## Predict the average

```python predict id=predict-bandit title="Which arm has the highest estimate after these pulls?"
import numpy as np
Q = np.zeros(3)
N = np.zeros(3)
for arm, reward in [(0, 1.0), (1, 3.0), (1, 1.0)]:
    N[arm] += 1
    Q[arm] += (reward - Q[arm]) / N[arm]
print(int(np.argmax(Q)))
--- options
* 1
0
2
3
--- explain
Arm 0 has one reward of 1, so its estimate is 1. Arm 1 has rewards 3 and 1, so its estimate is their average, 2. Arm 1 has the highest estimate.
```

## Debug the update

This bandit update is meant to track the average reward of each arm, but it overwrites the estimate with the latest reward.

```python debug id=overwrite-estimate title="Average the rewards, don''t overwrite them"
import numpy as np
rewards = [1.0, 3.0, 5.0]
Q, N = 0.0, 0
for r in rewards:
    N += 1
    Q = r                              # bug: the estimate should move towards r by 1/N, not be replaced by it
print("estimate:", Q)
--- solution
import numpy as np
rewards = [1.0, 3.0, 5.0]
Q, N = 0.0, 0
for r in rewards:
    N += 1
    Q += (r - Q) / N
print("estimate:", Q)
--- test
assert abs(Q - 3.0) < 1e-9, f"The average of 1, 3 and 5 is 3, but the estimate is {Q}. Move the estimate towards each reward by 1/N instead of overwriting it."
--- hint
Replacing the estimate throws away every earlier reward.
--- hint
Use `Q += (r - Q) / N`.
```

## Recap

- A bandit has unknown arm values. Learn them from rewards with incremental averages.
- Epsilon-greedy explores at random, and upper confidence bounds explore uncertain arms.
- Regret measures the reward lost while learning, and good algorithms keep it growing slowly.
- The exploration trade-off in bandits reappears in every reinforcement-learning method.

**Up next:** Markov decision processes, the framework that adds states and transitions to the bandit.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_1_4', 'sec_reinforcement_learning_essentials_1', 'crs_reinforcement_learning_essentials', 'Markov decision processes', 'interactive', 3, 1080, NULL, NULL, 'A bandit has one state. Most real problems do not: the right action depends on where you are, and actions change where you go next. A **Markov decision process** (MDP) describes such problems with four ingredients: states, actions, the probabilities of moving between states, and the rewards. The Markov property says the next state depends only on the current state and action, not on how you got there.

## A small MDP

Here is a three-state world. From the start state you can take a safe route or a risky one. The risky route pays more on average, but it can drop you into a trap.

```python run
import numpy as np

states = ["start", "safe", "trap", "goal"]
# P[s][a] is a list of (probability, next_state, reward)
P = {
    "start": {"safe_route": [(1.0, "safe", 0.0)],
              "risky_route": [(0.5, "goal", 2.0), (0.5, "trap", -1.0)]},
    "safe": {"continue": [(1.0, "goal", 1.0)]},
    "trap": {"stay": [(1.0, "trap", -1.0)]},
    "goal": {"stay": [(1.0, "goal", 0.0)]},
}

for action, outcomes in P["start"].items():
    expected = sum(p * r for p, _, r in outcomes)
    print(f"{action:>12}: expected immediate reward {expected:+.2f}")
```

The risky route looks better on immediate reward, but its outcomes are random. A decision needs the value of each state, which depends on the whole future.

## Values of states

The value of a state under a policy is the expected return from that state. It satisfies the **Bellman equation**, which says that a state''s value is the expected immediate reward plus the discounted value of the states that follow.

$$
V^{\pi}(s) = \sum_{a} \pi(a \mid s) \sum_{s'', r} p(s'', r \mid s, a)\bigl[\, r + \gamma V^{\pi}(s'') \,\bigr]
$$

```python run
gamma = 0.9
V_goal = 0.0                                  # the goal state keeps paying zero
V_safe = 1.0 + gamma * V_goal                 # one step of reward 1, then the goal
V_start_safe = 0.0 + gamma * V_safe           # the safe route from the start
V_start_risky = 0.5 * (2.0 + gamma * V_goal) + 0.5 * (-1.0 + gamma * (-1.0 / (1 - gamma)))
print("value of ''safe'' under gamma 0.9:", round(V_safe, 2))
print("value of ''start'' via the safe route:", round(V_start_safe, 2))
print("value of ''start'' via the risky route:", round(V_start_risky, 2))
```

The Bellman equation turns the question "which route is better?" into arithmetic. Here the safe route is worth more, because the trap''s penalty is repeated forever.

## Policies and their values

A policy chooses actions. Evaluating a policy means computing its value function, and improving it means choosing actions that do better. Both use the same equation.

```python run
def evaluate_policy(P, policy, gamma, sweeps=200):
    V = {s: 0.0 for s in P}
    for _ in range(sweeps):
        for s in P:
            a = policy[s]
            V[s] = sum(p * (r + gamma * V[s2]) for p, s2, r in P[s][a])
    return V

policy_safe = {"start": "safe_route", "safe": "continue", "trap": "stay", "goal": "stay"}
policy_risky = {"start": "risky_route", "safe": "continue", "trap": "stay", "goal": "stay"}
for name, pol in [("safe policy", policy_safe), ("risky policy", policy_risky)]:
    V = evaluate_policy(P, pol, gamma)
    print(f"{name}: value of start = {V[''start'']:.2f}")
```

## Predict the value

```python predict id=predict-mdp title="What is the value of a goal state that pays 0 forever?"
gamma = 0.9
print(0.0 + gamma * 0.0)
--- options
* 0.0
1.0
0.9
-1.0
--- explain
The goal state pays zero every step and stays there, so its value is zero plus the discounted value of itself, which is zero. Only the reward matters, and the reward is zero.
```

The safe policy''s values for every state, computed by the evaluation function above.

```python run
V_safe_policy = evaluate_policy(P, policy_safe, gamma)
print({s: round(v, 2) for s, v in V_safe_policy.items()})
```

Terminal and absorbing states keep their own values, and the start state inherits its value from the route it follows.

## Challenge: a one-step Bellman backup

```python exercise id=bellman-backup title="A one-step Bellman backup"
# TODO: `backup(outcomes, V, gamma)` returns the expected value of one action, given its outcomes as a list of
# (probability, next_state, reward) tuples and the state values V (a dictionary). Use r + gamma * V[next_state].
def backup(outcomes, V, gamma):
    ...
--- solution
def backup(outcomes, V, gamma):
    return sum(p * (r + gamma * V[s2]) for p, s2, r in outcomes)
--- test
V_t = {"a": 2.0, "b": -1.0}
result = backup([(0.5, "a", 1.0), (0.5, "b", 0.0)], V_t, 0.5)
assert result is not None, "Replace the `...` in `backup` with code that returns the expected value."
expected = 0.5 * (1.0 + 0.5 * 2.0) + 0.5 * (0.0 + 0.5 * -1.0)
assert abs(result - expected) < 1e-9, f"0.5 · (1 + 0.5·2) + 0.5 · (0 + 0.5·(−1)) = 0.75, but you returned {result!r}."
assert abs(backup([(1.0, "a", 0.0)], V_t, 0.9) - 1.8) < 1e-9, "A single certain outcome gives the reward plus the discounted next value."
--- hint
Multiply each outcome''s probability by its reward plus the discounted value of the next state, then add them up.
--- hint
`sum(p * (r + gamma * V[s2]) for p, s2, r in outcomes)`.
```

## Challenge: evaluate a policy

```python exercise id=evaluate-policy title="Evaluate a deterministic policy"
# TODO: `evaluate_policy(P, policy, gamma)` returns a dictionary of state values for the policy, computed by repeatedly
# applying the Bellman backup for the action the policy chooses in each state, for 500 sweeps starting from zeros.
# P has the same format as the lesson: P[s][a] is a list of (probability, next_state, reward).
def evaluate_policy(P, policy, gamma):
    ...
--- solution
def evaluate_policy(P, policy, gamma):
    V = {s: 0.0 for s in P}
    for _ in range(500):
        for s in P:
            V[s] = sum(p * (r + gamma * V[s2]) for p, s2, r in P[s][policy[s]])
    return V
--- test
P_t = {"x": {"go": [(1.0, "y", 1.0)]}, "y": {"stay": [(1.0, "y", 0.0)]}}
V = evaluate_policy(P_t, {"x": "go", "y": "stay"}, 0.5)
assert V is not None, "Replace the `...` in `evaluate_policy` with code that returns the values."
assert abs(V["y"]) < 1e-9, "State y pays nothing forever, so its value is 0."
assert abs(V["x"] - 1.0) < 1e-6, f"From x you get reward 1 and then move to y, so V(x) = 1, but you returned {V[''x'']!r}."
--- hint
Start every state at zero. In each sweep, update each state using only the action its policy chooses.
--- hint
Repeat `V[s] = sum(p * (r + gamma * V[s2]) for p, s2, r in P[s][policy[s]])` for each state, many times.
```

## Debug the Bellman update

This value update is meant to use the discount, but it applies the discount to the reward instead of to the next value.

```python debug id=bellman-discount title="Discount the next value, not the reward"
gamma = 0.5
V = {"next": 4.0}
outcomes = [(1.0, "next", 1.0)]
value = sum(p * (gamma * r + V[s2]) for p, s2, r in outcomes)     # bug: gamma multiplies the reward
print("value:", value)
--- solution
gamma = 0.5
V = {"next": 4.0}
outcomes = [(1.0, "next", 1.0)]
value = sum(p * (r + gamma * V[s2]) for p, s2, r in outcomes)
print("value:", value)
--- test
assert abs(value - 3.0) < 1e-9, f"The value should be the reward 1 plus 0.5 × 4 = 3, but the code gives {value}. The discount multiplies the next value."
--- hint
In the Bellman equation the discount multiplies the value of the next state.
--- hint
Write `r + gamma * V[s2]`.
```

## Recap

- An MDP has states, actions, transition probabilities and rewards. The next state depends only on the current state and action.
- The Bellman equation says a state''s value is the expected reward plus the discounted value of what follows.
- Evaluating a policy means solving the Bellman equation for its actions, which can be done by repeated backups.
- Comparing the values of different choices tells you which policy is better.

**Up next:** dynamic programming, which uses the Bellman equation to find the exact best policy when the MDP is known.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_2_1', 'sec_reinforcement_learning_essentials_2', 'crs_reinforcement_learning_essentials', 'Dynamic programming: exact values and policies', 'interactive', 0, 1200, NULL, NULL, 'When the MDP is fully known, you do not have to learn anything from experience. Dynamic programming solves the Bellman equations directly: **policy evaluation** computes the value of a policy by repeated backups, and **value iteration** computes the best value by repeating the optimal backup. The methods are exact, so they are the reference against which every learning algorithm is later checked.

The world below is the classic 4 × 4 gridworld. Two corners are terminal. Every step costs −1, and the agent moves up, down, left or right, staying put when it would leave the grid.

```python run
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]          # up, down, left, right

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

print("from (1, 1) moving right you go to", move((1, 1), 3))
print("from (0, 2) moving up you stay at", move((0, 2), 0))
```

## Policy evaluation

Start every state at zero. Repeatedly update each state''s value to the expected backup under the policy. The uniform random policy chooses each of the four moves with probability one quarter.

$$
V_{k+1}(s) = \frac{1}{4} \sum_{a} \bigl[ -1 + V_k(s'') \bigr], \qquad s'' = \text{move}(s, a)
$$

```python run
def evaluate_uniform(sweeps=300):
    V = np.zeros((N, N))
    for _ in range(sweeps):
        new = V.copy()
        for r in range(N):
            for c in range(N):
                if (r, c) in TERMINAL:
                    continue
                new[r, c] = np.mean([-1.0 + V[move((r, c), a)] for a in range(4)])
        V = new
    return V

V_random = evaluate_uniform()
print(np.round(V_random, 1))
```

The values count the expected number of steps to reach a corner, with a minus sign. Cells far from both corners are the most negative.

## Value iteration

Policy evaluation answers "how good is this policy?". Value iteration answers "what is the best value?" by taking the best action in each backup instead of averaging over them.

```python run
def value_iteration(sweeps=100):
    V = np.zeros((N, N))
    for _ in range(sweeps):
        new = V.copy()
        for r in range(N):
            for c in range(N):
                if (r, c) in TERMINAL:
                    continue
                new[r, c] = max(-1.0 + V[move((r, c), a)] for a in range(4))
        V = new
    return V

V_star = value_iteration()
print(np.round(V_star, 1))
```

The optimal values are never lower than the random-policy values, and the optimal policy is simply the action that achieves the maximum in each state.

## Extract the greedy policy

```python run
def greedy_policy(V):
    names = ["up", "down", "left", "right"]
    policy = {}
    for r in range(N):
        for c in range(N):
            if (r, c) in TERMINAL:
                continue
            best = max(range(4), key=lambda a: V[move((r, c), a)])
            policy[(r, c)] = names[best]
    return policy

pol = greedy_policy(V_star)
print("best move from (0, 1):", pol[(0, 1)], "| from (3, 2):", pol[(3, 2)])
```

> **Pitfall:** dynamic programming needs the transition model. In most real problems you do not have it, which is why the next lessons learn values from experience instead.

> **In the wild:** planning systems in robotics and logistics use value iteration on known maps. Model-free learning is the choice when the map is unknown.

## Challenge: iterative policy evaluation

```python exercise id=evaluate-uniform title="Evaluate the random policy"
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

# TODO: `evaluate_uniform(sweeps)` returns a 4 × 4 array of state values for the uniform random policy. Start from
# zeros and, for each sweep, set each non-terminal state to the average over its four moves of (−1 + value of the
# next state). Terminal states keep value 0.
def evaluate_uniform(sweeps):
    ...
--- solution
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

def evaluate_uniform(sweeps):
    V = np.zeros((N, N))
    for _ in range(sweeps):
        new = V.copy()
        for r in range(N):
            for c in range(N):
                if (r, c) in TERMINAL:
                    continue
                new[r, c] = np.mean([-1.0 + V[move((r, c), a)] for a in range(4)])
        V = new
    return V
--- test
import numpy as np
V = evaluate_uniform(500)
assert V is not None, "Replace the `...` in `evaluate_uniform` with code that returns the values."
assert V.shape == (4, 4), f"The grid is 4 × 4, but you returned shape {V.shape}."
assert V[0, 0] == 0 and V[3, 3] == 0, "The terminal corners keep value 0."
expected = np.array([[0, -14, -20, -22], [-14, -18, -20, -20], [-20, -20, -18, -14], [-22, -20, -14, 0]])
assert np.allclose(V, expected, atol=0.05), f"The known values for this grid are\n{expected}\nbut you returned\n{np.round(V, 1)}."
--- hint
Average over the four actions with `np.mean`, and use `move((r, c), a)` for each next state. Skip the terminal cells.
--- hint
`new[r, c] = np.mean([-1.0 + V[move((r, c), a)] for a in range(4)])`.
```

## Challenge: one value-iteration sweep

```python exercise id=value-iteration-step title="One value-iteration sweep"
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

# TODO: `value_iteration_step(V)` returns a new 4 × 4 array after one sweep. Each non-terminal state takes the
# maximum over its four actions of (−1 + value of the next state). Terminal states keep their value.
def value_iteration_step(V):
    ...
--- solution
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

def value_iteration_step(V):
    new = V.copy()
    for r in range(N):
        for c in range(N):
            if (r, c) in TERMINAL:
                continue
            new[r, c] = max(-1.0 + V[move((r, c), a)] for a in range(4))
    return new
--- test
import numpy as np
V0 = np.zeros((4, 4))
V1 = value_iteration_step(V0)
assert V1 is not None, "Replace the `...` in `value_iteration_step` with code that returns the new values."
assert np.isclose(V1[0, 1], -1.0) and np.isclose(V1[1, 1], -1.0), "From any non-terminal cell, one step costs −1 when all values start at 0."
assert V1[0, 0] == 0 and V1[3, 3] == 0, "Terminal corners keep value 0."
V2 = value_iteration_step(V1)
assert np.isclose(V2[0, 2], -2.0), f"After two sweeps the cell (0, 2) is two steps from the corner, so its value is −2, but you returned {V2[0, 2]}. Take the best action (the maximum), not the average."
--- hint
Use `max` over the four actions, not `np.mean`, because the agent chooses the best action.
--- hint
`new[r, c] = max(-1.0 + V[move((r, c), a)] for a in range(4))` and keep the terminal cells as they are.
```

## Debug the step reward

This value-iteration step is meant to charge a cost of one per step, but it adds a reward instead, so the agent is rewarded for wandering.

```python debug id=step-reward title="Charge a cost per step"
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

V = np.zeros((N, N))
new = V.copy()
new[0, 1] = max(1.0 + V[move((0, 1), a)] for a in range(4))       # bug: the step reward is −1, not +1
print("value of (0, 1):", new[0, 1])
--- solution
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

V = np.zeros((N, N))
new = V.copy()
new[0, 1] = max(-1.0 + V[move((0, 1), a)] for a in range(4))
print("value of (0, 1):", new[0, 1])
--- test
assert np.isclose(new[0, 1], -1.0), f"Every step costs −1, so the value of (0, 1) after one sweep is −1, but it is {new[0, 1]}. The reward per step is negative."
--- hint
Reward here is a cost. Check the sign of the constant inside the `max`.
--- hint
Use `-1.0 + V[...]`.
```

## Predict the optimal value

```python predict id=predict-dp title="What is the optimal value of a cell next to a corner?"
import numpy as np
V = np.zeros((4, 4))
V[0, 0] = 0.0
print(max(-1.0 + V[0, 0], -1.0 + V[1, 1]))
--- options
* -1.0
0.0
1.0
-2.0
--- explain
Moving into the terminal corner costs one step and then gives value zero, so the best option is −1. The best value of a cell next to a terminal corner is therefore −1.
```

## Recap

- Policy evaluation computes the value of a fixed policy by repeated Bellman backups.
- Value iteration replaces the average with a maximum, and converges to the optimal values.
- The greedy policy with respect to the optimal values is optimal.
- Dynamic programming needs the full model, which is why learning from experience matters.

**Up next:** temporal-difference learning, which learns values from experience without a model.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_2_2', 'sec_reinforcement_learning_essentials_2', 'crs_reinforcement_learning_essentials', 'Learning from experience: Monte Carlo and TD', 'interactive', 1, 1080, NULL, NULL, 'Dynamic programming needs the transition model. Real agents usually do not have one, so they must learn from experience: act, observe what happened, and adjust their estimates. **Monte Carlo** methods wait for the full return of an episode before updating. **Temporal-difference** (TD) methods update after every step, using the next state''s current estimate. TD is the workhorse of reinforcement learning, and its single update rule is worth understanding completely.

## The random walk

Five states in a row, A to E, start in the middle. Each step moves left or right with equal probability. Reaching E pays 1, reaching A pays 0, and both end the episode. The true values are the probabilities of finishing on the right, which are 1/6, 2/6, 3/6, 4/6 and 5/6 for the five states.

```python run
import numpy as np

rng = np.random.default_rng(0)

def walk_episode(rng):
    s = 2                                   # start in the middle, state C
    path = [s]
    while 0 < s < 4:
        s += 1 if rng.random() < 0.5 else -1
        path.append(s)
    reward = 1.0 if s == 4 else 0.0
    return path, reward

path, reward = walk_episode(rng)
print("one episode visits", path, "and pays", reward)
```

## Monte Carlo: wait for the whole return

Monte Carlo averages the complete returns observed after each state. It is unbiased, but every update must wait until the episode ends.

```python run
def mc_values(episodes, rng):
    total, count = np.zeros(5), np.zeros(5)
    for _ in range(episodes):
        path, reward = walk_episode(rng)
        for s in set(path[:-1]):              # first-visit style: each state counts once per episode
            total[s] += reward
            count[s] += 1
    return total / np.maximum(count, 1)

print("Monte Carlo estimates:", np.round(mc_values(5000, rng)[1:4], 3))
print("true values for B, C, D:", np.round([2 / 6, 3 / 6, 4 / 6], 3))
```

## TD(0): learn after every step

TD(0) updates the value of the state just left, moving it towards the observed reward plus the discounted value of the state entered:

$$
V(S_t) \leftarrow V(S_t) + \alpha \bigl[\, R_{t+1} + \gamma V(S_{t+1}) - V(S_t) \,\bigr]
$$

The bracketed term is the TD error: how much better or worse the outcome was than the current estimate predicted.

```python run
def td_values(episodes, alpha, rng, gamma=1.0):
    V = np.zeros(5)
    for _ in range(episodes):
        s = 2
        while 0 < s < 4:
            s2 = s + (1 if rng.random() < 0.5 else -1)
            r = 1.0 if s2 == 4 else 0.0
            target = r + gamma * V[s2] if 0 < s2 < 4 else r
            V[s] += alpha * (target - V[s])
            s = s2
    return V

print("TD(0) estimates:", np.round(td_values(2000, 0.05, np.random.default_rng(1))[1:4], 3))
```

TD learns after each step, so it can adapt in environments that never end. Both methods converge to the same values, but TD usually does so with less variance.

> **In the wild:** TD learning is how value functions are learned in game-playing and control systems, and it is the basis of the Q-learning in the next lesson.

Across all five states, TD(0) recovers the whole line of probabilities, from the nearly-zero value at A to the largest at E. Compare it with the true values in the table above.

```python run
print("TD(0) on all five states:", np.round(td_values(2000, 0.05, np.random.default_rng(2)), 2))
```

## Challenge: the TD update

```python exercise id=td-update title="One TD(0) update"
# TODO: `td0_update(V, s, r, s_next, alpha, gamma, done)` returns a new list of values, with only entry s changed.
# The target is r when done is True, and r + gamma × V[s_next] otherwise. Move V[s] towards the target by alpha.
def td0_update(V, s, r, s_next, alpha, gamma, done):
    ...
--- solution
def td0_update(V, s, r, s_next, alpha, gamma, done):
    new = list(V)
    target = r if done else r + gamma * V[s_next]
    new[s] = V[s] + alpha * (target - V[s])
    return new
--- test
result = td0_update([0.0, 0.5, 1.0], 1, 0.0, 2, 0.1, 0.9, False)
assert result is not None, "Replace the `...` in `td0_update` with code that returns the new values."
assert abs(result[1] - (0.5 + 0.1 * (0.9 * 1.0 - 0.5))) < 1e-9, f"The target is 0 + 0.9 × 1.0 = 0.9, so V[1] should move to 0.5 + 0.1 × 0.4 = 0.54, but you returned {result[1]!r}."
assert result[0] == 0.0 and result[2] == 1.0, "Only the entry for state s should change."
done_case = td0_update([0.0, 0.5], 1, 1.0, 0, 0.5, 0.9, True)
assert abs(done_case[1] - 0.75) < 1e-9, "At the end of an episode the target is just the reward, 1, so V[1] moves from 0.5 to 0.75."
--- hint
Compute the target first. It is `r` when the episode is done, and `r + gamma * V[s_next]` otherwise.
--- hint
`new = list(V)`, then `new[s] = V[s] + alpha * (target - V[s])`.
```

## Challenge: Monte Carlo average

```python exercise id=mc-average title="Average the returns of a state"
# TODO: `mc_average(returns)` returns the average of a list of sampled returns. An empty list gives 0.0.
def mc_average(returns):
    ...
--- solution
def mc_average(returns):
    if not returns:
        return 0.0
    return sum(returns) / len(returns)
--- test
assert mc_average([1.0, 0.0, 0.0, 1.0]) == 0.5, "The average of 1, 0, 0 and 1 is 0.5."
assert mc_average([]) == 0.0, "With no returns the estimate is 0."
assert abs(mc_average([2.0]) - 2.0) < 1e-9, "One return is its own average."
--- hint
Add the values and divide by how many there are, guarding the empty list.
--- hint
`sum(returns) / len(returns)`, with `if not returns: return 0.0` first.
```

## Debug the bootstrap target

This TD update is meant to bootstrap from the next state, but it uses the current state''s value, so the estimate chases itself.

```python debug id=bootstrap-state title="Bootstrap from the next state"
import numpy as np

V = np.array([0.0, 0.5, 1.0])
s, s_next, r, gamma, alpha = 1, 2, 0.0, 0.9, 0.1
target = r + gamma * V[s]               # bug: this uses the value of the state being updated
V[s] += alpha * (target - V[s])
print("updated V:", V)
--- solution
import numpy as np

V = np.array([0.0, 0.5, 1.0])
s, s_next, r, gamma, alpha = 1, 2, 0.0, 0.9, 0.1
target = r + gamma * V[s_next]
V[s] += alpha * (target - V[s])
print("updated V:", V)
--- test
assert abs(V[1] - 0.54) < 1e-9, f"The target should use V[s_next] = 1.0, giving V[1] = 0.54, but it is {V[1]:.4f}. Bootstrap from the next state."
--- hint
In TD(0) the value of the state entered, `s_next`, is what the update learns from.
--- hint
Replace `V[s]` with `V[s_next]` inside the target.
```

## Predict the TD error

```python predict id=predict-td title="What is the TD error?"
r, gamma = 1.0, 0.5
V_s, V_next = 2.0, 4.0
print(r + gamma * V_next - V_s)
--- options
* 1.0
0.0
-1.0
3.0
--- explain
The TD error is the target minus the estimate: 1 + 0.5 × 4 − 2 = 1 + 2 − 2 = 1. Positive means the outcome was better than predicted.
```

## Recap

- Monte Carlo averages complete returns and must wait for the end of each episode.
- TD(0) updates each state after one step, moving its estimate towards the reward plus the discounted next estimate.
- The TD error measures how much an outcome beat or missed the prediction, and it drives learning.
- TD needs no model, which makes it the basis of model-free control.

**Up next:** Q-learning, which applies the same idea to the value of actions, and learns the best policy directly.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_2_3', 'sec_reinforcement_learning_essentials_2', 'crs_reinforcement_learning_essentials', 'Q-learning: learning the value of actions', 'interactive', 2, 1200, NULL, NULL, 'Q-learning is the most famous model-free algorithm in reinforcement learning. Instead of learning the value of states, it learns the value of **state-action pairs**, written $Q(s, a)$: the expected return from taking action $a$ in state $s$ and acting well afterwards. Once you know $Q$, the best action is simply the one with the largest value, and you never need a model of the world.

## A cliff to learn from

The world below is a small grid. The agent starts in the bottom-left corner and must reach the bottom-right corner. The bottom row between them is a cliff: stepping onto it costs 100 and sends the agent back to the start. Every other step costs 1.

```python run
import numpy as np

ROWS, COLS = 3, 6
START, GOAL = (2, 0), (2, 5)
CLIFF = {(2, c) for c in range(1, 5)}
MOVES = [(-1, 0), (1, 0), (0, -1), (0, 1)]           # up, down, left, right

def idx(r, c):
    return r * COLS + c

def env_step(s, a):
    r, c = s
    dr, dc = MOVES[a]
    nr, nc = min(max(r + dr, 0), ROWS - 1), min(max(c + dc, 0), COLS - 1)
    if (nr, nc) in CLIFF:
        return START, -100.0, False
    if (nr, nc) == GOAL:
        return (nr, nc), -1.0, True
    return (nr, nc), -1.0, False

reward_total = 0.0
s, done = START, False
for a in [3, 3, 3, 3, 3]:                             # walk right along the top route
    s, r, done = env_step(s, a)
    reward_total += r
print("five steps right from the start: position", s, "| total reward", reward_total)
```

The start is on the cliff row, so stepping right walks onto the cliff, costs 100 and sends the agent back to the start. The total shows the penalty. That is the trap the agent must learn to avoid.

## The Q-learning update

After each step, Q-learning moves $Q(s, a)$ towards the reward plus the discounted value of the best action in the next state. Taking the maximum over next actions is what makes it learn the best policy, whatever the agent actually does.

$$
Q(s, a) \leftarrow Q(s, a) + \alpha \bigl[\, r + \gamma \max_{a''} Q(s'', a'') - Q(s, a) \,\bigr]
$$

```python run
def q_learning(episodes, alpha=0.5, gamma=1.0, eps=0.1, seed=0):
    rng = np.random.default_rng(seed)
    Q = np.zeros((ROWS * COLS, 4))
    returns = []
    for _ in range(episodes):
        s, total, done = START, 0.0, False
        for _ in range(500):
            a = rng.integers(4) if rng.random() < eps else int(np.argmax(Q[idx(*s)]))
            s2, r, done = env_step(s, a)
            target = r if done else r + gamma * np.max(Q[idx(*s2)])
            Q[idx(*s), a] += alpha * (target - Q[idx(*s), a])
            total += r
            s = s2
            if done:
                break
        returns.append(total)
    return Q, returns

Q, returns = q_learning(500)
print("average return over the last 50 episodes:", round(np.mean(returns[-50:]), 1))
```

## The learned policy

```python run
arrows = ["↑", "↓", "←", "→"]
for r in range(ROWS):
    row = []
    for c in range(COLS):
        if (r, c) in CLIFF:
            row.append(" C ")
        elif (r, c) == GOAL:
            row.append(" G ")
        else:
            row.append(f" {arrows[int(np.argmax(Q[idx(r, c)]))]} ")
    print("".join(row))
```

The arrows show the greedy policy. Along the row above the cliff the agent learns to step up first, which is the safe route.

> **Pitfall:** Q-learning''s target uses the best next action even if the agent will not take it. That is what makes it off-policy, and it is why it learns the optimal route rather than the route that is safe to explore with. The next lesson contrasts it with SARSA.

> **In the wild:** tabular Q-learning appears in small control problems, and deep Q-networks, covered later in this course, use the same update with a neural network.

The learned action values at the start state show which move the agent prefers, and by how much.

```python run
print("Q-values at the start (up, down, left, right):", np.round(Q[idx(*START)], 1))
```

## Challenge: the Q target

```python exercise id=q-target title="The Q-learning target"
import numpy as np

# TODO: `q_target(r, next_q, done, gamma)` returns the target r when done is True, and r + gamma × max(next_q)
# otherwise, where next_q is the array of action values in the next state.
def q_target(r, next_q, done, gamma):
    ...
--- solution
import numpy as np

def q_target(r, next_q, done, gamma):
    if done:
        return float(r)
    return float(r + gamma * np.max(next_q))
--- test
import numpy as np
result = q_target(1.0, np.array([0.5, 2.0]), False, 0.5)
assert result is not None, "Replace the `...` in `q_target` with code that returns the target."
assert abs(result - 2.0) < 1e-9, f"The target is 1 + 0.5 × max(0.5, 2.0) = 2.0, but you returned {result!r}."
assert abs(q_target(1.0, np.array([0.5, 2.0]), True, 0.5) - 1.0) < 1e-9, "At the end of an episode there is no future value, so the target is just r."
assert abs(q_target(-1.0, np.array([-3.0, -1.0]), False, 1.0) + 2.0) < 1e-9, "The maximum over the actions is −1, so the target is −1 + (−1) = −2."
--- hint
Use `np.max` over the next state''s action values, and skip it when the episode is done.
--- hint
`return float(r) if done else float(r + gamma * np.max(next_q))`.
```

## Challenge: one Q-learning update

```python exercise id=q-update title="Apply one Q-learning update"
import numpy as np

# TODO: `q_update(Q, s, a, r, s2, done, alpha, gamma)` returns a NEW copy of the 2-D array Q, in which entry [s, a] has
# moved towards the Q-learning target by alpha. The input Q must not be changed.
def q_update(Q, s, a, r, s2, done, alpha, gamma):
    ...
--- solution
import numpy as np

def q_update(Q, s, a, r, s2, done, alpha, gamma):
    new = np.array(Q, dtype=float, copy=True)
    target = r if done else r + gamma * np.max(new[s2])
    new[s, a] += alpha * (target - new[s, a])
    return new
--- test
import numpy as np
Q0 = np.zeros((3, 4))
Q1 = q_update(Q0, 0, 1, 1.0, 2, False, 0.5, 0.9)
assert Q1 is not None, "Replace the `...` in `q_update` with code that returns the new table."
assert abs(Q1[0, 1] - 0.5) < 1e-9, f"The target is 1 + 0.9 × max(row 2) = 1, so Q[0, 1] moves from 0 to 0.5, but you returned {Q1[0, 1]!r}."
assert np.all(Q0 == 0), "The input table must not change."
Q2 = np.zeros((3, 4))
Q2[2, 3] = 4.0
Q3 = q_update(Q2, 1, 0, -1.0, 2, False, 1.0, 0.5)
assert abs(Q3[1, 0] - (-1.0 + 0.5 * 4.0)) < 1e-9, "The target uses the best action in the next state, which is 4 here."
--- hint
Copy the array first, compute the target from `np.max(new[s2])` unless the episode is done, then add `alpha * (target − current)` to the entry.
--- hint
`new = np.array(Q, dtype=float, copy=True)` protects the input.
```

## Debug the next-state value

This update is meant to learn the best action in the next state, but it looks up the value of the action that was actually taken instead.

```python debug id=q-next-action title="Use the best next action, not the taken one"
import numpy as np

Q = np.zeros((3, 2))
Q[2] = [0.0, 3.0]                       # in the next state, action 1 is far better
s, a, r, s2, alpha, gamma = 0, 0, -1.0, 2, 0.5, 1.0
target = r + gamma * Q[s2, a]           # bug: uses the value of the action taken, not the best one
Q[s, a] += alpha * (target - Q[s, a])
print("Q[0, 0] after the update:", Q[0, 0])
--- solution
import numpy as np

Q = np.zeros((3, 2))
Q[2] = [0.0, 3.0]
s, a, r, s2, alpha, gamma = 0, 0, -1.0, 2, 0.5, 1.0
target = r + gamma * np.max(Q[s2])
Q[s, a] += alpha * (target - Q[s, a])
print("Q[0, 0] after the update:", Q[0, 0])
--- test
assert abs(Q[0, 0] - 1.0) < 1e-9, f"The target is −1 + max(0, 3) = 2, so Q[0, 0] should move to 1.0, but it is {Q[0, 0]}. Q-learning uses the best next action."
--- hint
Q-learning''s target does not depend on which action the agent takes next. It takes the maximum.
--- hint
Replace `Q[s2, a]` with `np.max(Q[s2])`.
```

## Predict the target

```python predict id=predict-q title="What is the Q-learning target?"
import numpy as np
r, gamma = 2.0, 0.5
next_q = np.array([1.0, 4.0, 2.0])
print(r + gamma * np.max(next_q))
--- options
* 4.0
3.0
2.0
5.0
--- explain
The best next action has value 4, and the discount halves it to 2. Adding the reward 2 gives 4. The other actions do not matter, because Q-learning always looks at the maximum.
```

## Recap

- Q-learning learns the value of state-action pairs and updates them towards reward plus the discounted best next value.
- Because it uses the maximum, it learns the optimal policy even while the agent explores.
- Terminal transitions use only the reward, with no future value.
- The learned policy is the arrow in each state with the largest value.

**Up next:** exploration choices, and SARSA, the on-policy cousin that learns the value of the policy actually followed.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_2_4', 'sec_reinforcement_learning_essentials_2', 'crs_reinforcement_learning_essentials', 'Exploration and SARSA: on-policy versus off-policy', 'interactive', 3, 960, NULL, NULL, 'Q-learning learns the best policy, but the agent that learns it may behave differently: during training it still takes random exploratory actions, and those can walk it off the cliff. **SARSA** is the on-policy cousin of Q-learning. It learns the value of the policy the agent actually follows, exploration included, and that difference changes the route it learns. This lesson compares the two and explains how exploration is scheduled.

## On-policy versus off-policy

Q-learning''s target uses the best next action, which may not be the one taken. SARSA''s target uses the action the agent actually takes next:

$$
\text{Q-learning:}\quad r + \gamma \max_{a''} Q(s'', a'') \qquad\qquad \text{SARSA:}\quad r + \gamma\, Q(s'', a'')
$$

The letters in SARSA name the quintuple it uses: state, action, reward, next state, next action.

```python run
import numpy as np

ROWS, COLS = 3, 6
START, GOAL = (2, 0), (2, 5)
CLIFF = {(2, c) for c in range(1, 5)}
MOVES = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def idx(r, c):
    return r * COLS + c

def env_step(s, a):
    r, c = s
    dr, dc = MOVES[a]
    nr, nc = min(max(r + dr, 0), ROWS - 1), min(max(c + dc, 0), COLS - 1)
    if (nr, nc) in CLIFF:
        return START, -100.0, False
    if (nr, nc) == GOAL:
        return (nr, nc), -1.0, True
    return (nr, nc), -1.0, False

def train(method, episodes=500, alpha=0.5, gamma=1.0, eps=0.1, seed=0):
    rng = np.random.default_rng(seed)
    Q = np.zeros((ROWS * COLS, 4))
    def choose(s):
        return rng.integers(4) if rng.random() < eps else int(np.argmax(Q[idx(*s)]))
    returns = []
    for _ in range(episodes):
        s, total, done = START, 0.0, False
        a = choose(s)
        for _ in range(500):
            s2, r, done = env_step(s, a)
            a2 = choose(s2)
            if method == "sarsa":
                target = r if done else r + gamma * Q[idx(*s2), a2]
            else:
                target = r if done else r + gamma * np.max(Q[idx(*s2)])
            Q[idx(*s), a] += alpha * (target - Q[idx(*s), a])
            total += r
            s, a = s2, a2
            if done:
                break
        returns.append(total)
    return returns

for method in ["q-learning", "sarsa"]:
    returns = train(method)
    print(f"{method:>10}: average return over the last 50 episodes {np.mean(returns[-50:]):.1f}")
```

Q-learning often shows a better average during the final episodes, because it learns the cliff-edge route it would take if it did not explore. SARSA''s exploration is part of what it learned, so it keeps a safer distance from the cliff while exploration is on.

Averaging over three random seeds gives a fairer comparison than a single run.

```python run
for method in ["q-learning", "sarsa"]:
    avg = np.mean([np.mean(train(method, seed=s)[-50:]) for s in range(3)])
    print(f"{method:>10}: average return over the last 50 episodes, three seeds {avg:.1f}")
```

## Exploration needs a schedule

Exploration is essential early and costly late. A common solution is an epsilon schedule that starts high and decays towards a small floor.

```python run
def epsilon_at(episode, eps_start=1.0, eps_end=0.05, decay_episodes=200):
    frac = min(episode / decay_episodes, 1.0)
    return eps_start + frac * (eps_end - eps_start)

for ep in [0, 50, 100, 200, 400]:
    print(f"episode {ep:>3}: epsilon {epsilon_at(ep):.3f}")
```

A schedule that decays too fast can lock the agent into an early habit. Decaying too slowly wastes episodes on random actions. The right schedule depends on how hard the environment is to explore.

## Stochastic environments

Exploration matters most when the world is uncertain. The bandit lesson already showed that a fixed epsilon can waste reward forever, which is why many systems decay it.

> **Pitfall:** when an episode ends, the target must not bootstrap from the next state. A terminal state has no future, so its target is just the reward. Forgetting this makes the agent believe it can keep earning rewards after the episode is over.

> **In the wild:** SARSA is preferred when mistakes during learning are costly, such as a robot that should not learn by falling down stairs, because it learns a policy that accounts for its own exploration.

Plotting the smoothed returns shows how each method improves over time.

```python run
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(5, 3))
for method in ["q-learning", "sarsa"]:
    returns = train(method)
    ax.plot(np.convolve(returns, np.ones(20) / 20, mode="valid"), label=method)
ax.set_xlabel("episode"); ax.set_ylabel("return (20-episode average)")
ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

## Challenge: the SARSA target

```python exercise id=sarsa-target title="The SARSA target"
import numpy as np

# TODO: `sarsa_target(r, q_next_taken, done, gamma)` returns r when done is True, and r + gamma × q_next_taken otherwise,
# where q_next_taken is the value of the action the agent actually takes in the next state.
def sarsa_target(r, q_next_taken, done, gamma):
    ...
--- solution
def sarsa_target(r, q_next_taken, done, gamma):
    if done:
        return float(r)
    return float(r + gamma * q_next_taken)
--- test
result = sarsa_target(1.0, 3.0, False, 0.5)
assert result is not None, "Replace the `...` in `sarsa_target` with code that returns the target."
assert abs(result - 2.5) < 1e-9, f"The target is 1 + 0.5 × 3 = 2.5, but you returned {result!r}."
assert abs(sarsa_target(1.0, 3.0, True, 0.5) - 1.0) < 1e-9, "At the end of an episode the target is just the reward."
--- hint
SARSA uses the value of the next action it will take, not the maximum over actions.
--- hint
`return float(r) if done else float(r + gamma * q_next_taken)`.
```

## Challenge: an epsilon schedule

```python exercise id=epsilon-schedule title="A linear epsilon schedule"
# TODO: `linear_epsilon(episode, eps_start, eps_end, decay_episodes)` returns epsilon for an episode, falling linearly
# from eps_start at episode 0 to eps_end at episode `decay_episodes`, and staying at eps_end afterwards.
def linear_epsilon(episode, eps_start, eps_end, decay_episodes):
    ...
--- solution
def linear_epsilon(episode, eps_start, eps_end, decay_episodes):
    frac = min(episode / decay_episodes, 1.0)
    return eps_start + frac * (eps_end - eps_start)
--- test
assert abs(linear_epsilon(0, 1.0, 0.1, 10) - 1.0) < 1e-9, "At episode 0 epsilon is its starting value."
assert abs(linear_epsilon(5, 1.0, 0.1, 10) - 0.55) < 1e-9, "Halfway through the decay, epsilon is halfway between 1.0 and 0.1, which is 0.55."
assert abs(linear_epsilon(10, 1.0, 0.1, 10) - 0.1) < 1e-9, "At the decay length epsilon reaches its floor."
assert abs(linear_epsilon(99, 1.0, 0.1, 10) - 0.1) < 1e-9, "After the decay it stays at the floor."
--- hint
Find the fraction of the way through the decay, cap it at 1, and move from the start value towards the end value by that fraction.
--- hint
`frac = min(episode / decay_episodes, 1.0)`, then `eps_start + frac * (eps_end - eps_start)`.
```

## Debug the terminal bootstrap

This SARSA target is meant to stop at the end of the episode, but it keeps adding the value of a next state even when the episode has finished.

```python debug id=terminal-bootstrap title="Do not bootstrap from a terminal state"
import numpy as np

Q = np.array([[0.0, 0.0], [5.0, 5.0]])
s2, a2, r, gamma, done = 1, 0, 1.0, 0.9, True
target = r + gamma * Q[s2, a2]            # bug: a finished episode has no future value
print("target:", target)
--- solution
import numpy as np

Q = np.array([[0.0, 0.0], [5.0, 5.0]])
s2, a2, r, gamma, done = 1, 0, 1.0, 0.9, True
target = r if done else r + gamma * Q[s2, a2]
print("target:", target)
--- test
assert abs(target - 1.0) < 1e-9, f"The episode is done, so the target should be the reward 1.0, but it is {target}. Use only the reward when the episode ends."
--- hint
When `done` is True there is no next state to learn from.
--- hint
Write `target = r if done else r + gamma * Q[s2, a2]`.
```

## Predict the schedule

```python predict id=predict-eps title="What is epsilon halfway through a 100-episode linear decay from 1 to 0?"
frac = 50 / 100
print(1.0 + frac * (0.0 - 1.0))
--- options
* 0.5
0.0
1.0
0.25
--- explain
Halfway through the decay, the fraction is one half, so epsilon is 1 minus one half, which is 0.5.
```

## Recap

- SARSA uses the value of the action actually taken next, so it learns the policy that includes its own exploration.
- Q-learning uses the maximum, so it learns the optimal policy regardless of exploration.
- An epsilon schedule starts with exploration and decays it, and its decay rate is a design choice.
- Terminal transitions use only the reward.

**Up next:** deep Q-networks, which replace the table with a function approximator that generalizes.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_2_5', 'sec_reinforcement_learning_essentials_2', 'crs_reinforcement_learning_essentials', 'Deep Q-networks: function approximation and replay', 'interactive', 4, 1080, NULL, NULL, 'A Q-table works when there are a few hundred states. A robot camera or a game screen has millions. A **deep Q-network** (DQN) replaces the table with a function that estimates $Q(s, a)$ from features of the state, so experience in one situation teaches the agent about similar ones. Two tricks make that stable, and both are essential: an **experience replay** buffer that breaks the correlation between consecutive steps, and a **target network** that stops the target from moving every time the estimate changes.

This lesson builds both ideas in NumPy with a simple function approximator, then shows the standard deep version in PyTorch as static code for you to run locally.

## Function approximation

A linear approximator scores each action with a weighted sum of state features. With one weight vector per action, $Q(s, a) = w_a \cdot \phi(s)$. Nearby states have similar features, so they share what they learn.

```python run
import numpy as np

def features(x):
    # radial basis features over a continuous position x in [0, 1]
    centers = np.linspace(0, 1, 6)
    return np.exp(-((x - centers) ** 2) / 0.02)

x = 0.37
print("feature vector at x = 0.37:", np.round(features(x), 2))

W = np.zeros((2, 6))                  # two actions, six features each
q_values = W @ features(x)
print("Q-values for both actions:", q_values)
```

## Experience replay

Consecutive steps are highly correlated, and learning from them one after another is unstable. A replay buffer stores past transitions, and training samples random mini-batches from it.

```python run
rng = np.random.default_rng(0)
buffer = []
for t in range(100):
    s = rng.random()
    a = rng.integers(2)
    buffer.append((s, a, rng.normal(), rng.random(), False))
    if len(buffer) > 50:
        buffer.pop(0)                  # keep only the most recent 50 transitions

batch = [buffer[i] for i in rng.choice(len(buffer), 8, replace=False)]
print("buffer holds", len(buffer), "transitions; a random batch has", len(batch))
```

## Training with a target network

The target is computed with a separate copy of the weights, updated only every few hundred steps. The estimate chases a target that does not move with every update, which damps oscillations.

```python run
def train_dqn(steps=3000, lr=0.05, gamma=0.9, seed=0):
    rng = np.random.default_rng(seed)
    W = np.zeros((2, 6))
    W_target = W.copy()
    buf = []
    x = rng.random()
    for t in range(steps):
        a = rng.integers(2) if rng.random() < 0.3 else int(np.argmax(W @ features(x)))
        # toy environment: action 1 pays 1 when x is above 0.5, action 0 pays 1 otherwise
        r = 1.0 if (a == 1) == (x > 0.5) else 0.0
        x2 = rng.random()
        buf.append((x, a, r, x2))
        if len(buf) > 500:
            buf.pop(0)
        xb, ab, rb, x2b = buf[rng.integers(len(buf))]
        target = rb + gamma * np.max(W_target @ features(x2b))
        pred = W[ab] @ features(xb)
        W[ab] += lr * (target - pred) * features(xb)
        if t % 200 == 0:
            W_target = W.copy()
        x = x2
    return W

W = train_dqn()
test_x = np.array([0.1, 0.4, 0.6, 0.9])
policy = [int(np.argmax(W @ features(v))) for v in test_x]
print("learned action for x =", test_x, "->", policy)
```

The learned policy is correct for every test state, although the agent never saw these exact inputs during training. That is generalization through features.

After training, the Q-values at a state show the agent''s preference between the two actions, and how confident it is.

```python run
print("Q-values at x = 0.9:", np.round(W @ features(0.9), 2))
print("Q-values at x = 0.1:", np.round(W @ features(0.1), 2))
```

## The deep version

The same algorithm with a neural network as the function approximator is standard in libraries. The code below is for you to run on your own machine, because it needs PyTorch.

```python
# Static: run this on your own machine with PyTorch installed
import torch
import torch.nn as nn

q_net = nn.Sequential(nn.Linear(4, 64), nn.ReLU(), nn.Linear(64, 2))
target_net = nn.Sequential(nn.Linear(4, 64), nn.ReLU(), nn.Linear(64, 2))
target_net.load_state_dict(q_net.state_dict())
optimizer = torch.optim.Adam(q_net.parameters(), lr=1e-3)

def dqn_step(states, actions, rewards, next_states, dones, gamma=0.99):
    q = q_net(states).gather(1, actions.unsqueeze(1)).squeeze(1)
    with torch.no_grad():
        next_max = target_net(next_states).max(dim=1).values
        target = rewards + gamma * (1 - dones) * next_max
    loss = nn.functional.mse_loss(q, target)
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
    return loss.item()
```

Map every line to a lesson idea: the `gather` picks the taken action''s value, the `no_grad` block is the target network, and `(1 - dones)` is the terminal rule from the last lesson.

## Challenge: sample a replay batch

```python exercise id=replay-batch title="Sample a replay batch without repeats"
import numpy as np

# TODO: `replay_indices(buffer_size, batch_size, seed)` returns an array of `batch_size` distinct indices in
# the range 0 to buffer_size − 1, drawn uniformly with np.random.default_rng(seed).
def replay_indices(buffer_size, batch_size, seed):
    ...
--- solution
import numpy as np

def replay_indices(buffer_size, batch_size, seed):
    return np.random.default_rng(seed).choice(buffer_size, batch_size, replace=False)
--- test
import numpy as np
result = replay_indices(100, 8, 0)
assert result is not None, "Replace the `...` in `replay_indices` with code that returns the indices."
assert len(result) == 8, "The batch should hold 8 indices."
assert len(set(result.tolist())) == 8, "The indices must be distinct."
assert result.min() >= 0 and result.max() < 100, "Indices must lie inside the buffer."
assert np.array_equal(replay_indices(100, 8, 0), result), "The same seed must give the same batch."
--- hint
`rng.choice(n, k, replace=False)` draws k distinct values from 0 to n − 1.
--- hint
`np.random.default_rng(seed).choice(buffer_size, batch_size, replace=False)`.
```

## Challenge: DQN targets

```python exercise id=dqn-targets title="Compute DQN targets for a batch"
import numpy as np

# TODO: `dqn_targets(rewards, next_max_q, dones, gamma)` returns an array of targets: rewards + gamma × next_max_q,
# with the future term set to zero where done is 1 (True). All inputs are arrays of the same length.
def dqn_targets(rewards, next_max_q, dones, gamma):
    ...
--- solution
import numpy as np

def dqn_targets(rewards, next_max_q, dones, gamma):
    rewards = np.asarray(rewards, dtype=float)
    next_max_q = np.asarray(next_max_q, dtype=float)
    dones = np.asarray(dones, dtype=float)
    return rewards + gamma * (1.0 - dones) * next_max_q
--- test
import numpy as np
result = dqn_targets([1.0, 0.0], [4.0, 10.0], [0, 1], 0.5)
assert result is not None, "Replace the `...` in `dqn_targets` with code that returns the targets."
assert np.allclose(result, [1.0 + 0.5 * 4.0, 0.0]), f"The first target is 1 + 0.5 × 4 = 3, and the second is 0 because that episode is done. You returned {result}."
assert result.shape == (2,), "There is one target per transition."
--- hint
Multiply the future value by `(1 − done)`, so finished episodes lose that term. Then add the rewards.
--- hint
`rewards + gamma * (1 - dones) * next_max_q`, with all three inputs converted to arrays first.
```

## Debug the terminal term

This target is meant to drop the future value of finished episodes, but it keeps it.

```python debug id=dqn-done-term title="Drop the future value at the end of an episode"
import numpy as np

rewards = np.array([1.0, 0.0])
next_max_q = np.array([4.0, 10.0])
dones = np.array([0.0, 1.0])
gamma = 0.5
targets = rewards + gamma * next_max_q            # bug: the done flag is ignored
print("targets:", targets)
--- solution
import numpy as np

rewards = np.array([1.0, 0.0])
next_max_q = np.array([4.0, 10.0])
dones = np.array([0.0, 1.0])
gamma = 0.5
targets = rewards + gamma * (1 - dones) * next_max_q
print("targets:", targets)
--- test
assert np.allclose(targets, [3.0, 0.0]), f"The second episode is done, so its target should be 0, but the targets are {targets}. Multiply the future term by (1 − dones)."
--- hint
A done flag of 1 must switch off the future term.
--- hint
Insert the factor `(1 - dones)` in front of `next_max_q`.
```

## Predict the target

```python predict id=predict-dqn title="What target does a done transition give?"
import numpy as np
r, gamma, done, next_max = 2.0, 0.9, 1.0, 100.0
print(r + gamma * (1 - done) * next_max)
--- options
* 2.0
92.0
90.0
102.0
--- explain
The episode is done, so the future term is multiplied by zero. The target is just the reward 2.0, however large the value of the next state looks.
```

## Recap

- A function approximator generalizes across similar states, which tables cannot do.
- Experience replay samples random past transitions, which stabilizes training.
- A target network is copied only occasionally, so the target does not chase the estimate.
- Terminal transitions drop the future term, as in every method in this course.

**Up next:** checkpoint quiz, then policy-gradient methods, which learn the policy directly.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_2_6', 'sec_reinforcement_learning_essentials_2', 'crs_reinforcement_learning_essentials', 'Checkpoint: value-based methods', 'quiz', 5, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"With discount factor 0.9, what is the return of rewards 0, 0, 10 starting at time 0?","options":["10.0","8.1","9.0","0.0"],"answerIndex":1,"explanation":"The reward of 10 arrives at time 2, so it is discounted by 0.9 squared, which is 0.81. 10 × 0.81 = 8.1."},{"id":"q2","prompt":"In Q-learning, the target for a non-terminal transition uses…","options":["The value of the action actually taken next","The maximum over actions of Q in the next state","The reward alone","The average of all Q values in the table"],"answerIndex":1,"explanation":"Q-learning bootstraps from the best next action, which makes it learn the optimal policy even while exploring."},{"id":"q3","prompt":"What is the main difference between SARSA and Q-learning?","options":["SARSA learns the value of the policy actually followed, including exploration; Q-learning learns the greedy optimal policy","SARSA cannot use a discount factor","Q-learning requires a neural network","There is no difference"],"answerIndex":0,"explanation":"SARSA is on-policy and uses the next action taken. Q-learning is off-policy and uses the maximum over next actions."},{"id":"q4","prompt":"Why does a DQN use a target network?","options":["To make the network smaller","To keep the regression target from moving with every update, which stabilizes training","To replace the replay buffer","To remove the discount factor"],"answerIndex":1,"explanation":"A separate, slowly updated copy of the weights provides a stable target, which damps oscillations in learning."},{"id":"q5","prompt":"A bandit agent that always picks the arm with the highest estimate, from the start, can get stuck because…","options":["Its estimates never change","It may never try the best arm after an early unlucky result, so it lacks exploration","Bandits have no rewards","The arms are always identical"],"answerIndex":1,"explanation":"Without exploration an early poor estimate can lock the agent onto a worse arm. Epsilon-greedy and upper confidence bounds address this."}]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_reinforcement_learning_essentials_3_1', 'sec_reinforcement_learning_essentials_3', 'crs_reinforcement_learning_essentials', 'Policy gradients: learning the policy directly', 'interactive', 0, 1200, NULL, NULL, 'So far the agent has learned values and then acted greedily on them. A **policy gradient** method skips the values and learns the policy directly: a parameterized rule for choosing actions, adjusted by gradient ascent on the expected return. It handles continuous actions and stochastic policies naturally, and it is the foundation of PPO and RLHF.

## A softmax policy

Give each action a preference score $\theta_a$ in each state. A softmax turns the preferences into probabilities, so every action has a positive chance and the chances sum to one:

$$
\pi(a) = \frac{e^{\theta_a}}{\sum_b e^{\theta_b}}
$$

```python run
import numpy as np

def softmax(theta):
    e = np.exp(theta - np.max(theta))
    return e / e.sum()

theta = np.array([0.0, 1.0, -1.0])
print("action probabilities:", np.round(softmax(theta), 3))
```

Raising one preference makes its action more likely, without ever making any other action impossible. That is what allows the policy to explore while it improves.

## The policy gradient

The REINFORCE theorem says that the gradient of the expected return with respect to the parameters is an average of $\nabla \log \pi(a \mid s)$ scaled by the return that followed:

$$
\nabla J(\theta) = \mathbb{E}\bigl[\, \nabla_\theta \log \pi_\theta(a \mid s)\; G \,\bigr]
$$

For a softmax policy the gradient of $\log \pi(a)$ with respect to the preferences has a simple form: the one-hot vector of the chosen action minus the probabilities.

$$
\nabla_\theta \log \pi(a) = \mathbf{e}_a - \pi
$$

```python run
def grad_log_softmax(theta, a):
    p = softmax(theta)
    onehot = np.zeros_like(theta)
    onehot[a] = 1.0
    return onehot - p

# check the formula against a numerical derivative
theta = np.array([0.2, -0.5, 0.7])
a = 2
eps = 1e-6
numeric = np.array([(np.log(softmax(theta + eps * np.eye(3)[j])[a]) - np.log(softmax(theta - eps * np.eye(3)[j])[a])) / (2 * eps) for j in range(3)])
print("formula:  ", np.round(grad_log_softmax(theta, a), 5))
print("numerical:", np.round(numeric, 5))
```

## Learn a three-armed bandit

```python run
rng = np.random.default_rng(0)
true_rewards = np.array([0.1, 0.8, 0.3])
theta = np.zeros(3)
lr = 0.1
baseline_reward = []
for episode in range(2000):
    p = softmax(theta)
    a = rng.choice(3, p=p)
    r = true_rewards[a] + rng.normal(0, 0.1)
    theta += lr * r * grad_log_softmax(theta, a)     # gradient ascent on expected reward
    baseline_reward.append(r)

print("final probabilities:", np.round(softmax(theta), 3))
print("average reward in the last 200 episodes:", round(np.mean(baseline_reward[-200:]), 3))
```

The policy concentrates on the best arm, which has reward 0.8. Notice that no value estimate was needed: the update uses only the sampled reward and the score of the action taken.

> **Pitfall:** raw returns make REINFORCE noisy, because every action in a good episode is praised, including the bad ones. The next lesson fixes this with baselines.

> **In the wild:** every policy-gradient method in use for language models and robotics is a refinement of this estimator, usually with a learned baseline and a constraint on how far the policy moves.

Sampling actions from the softmax policy gives frequencies that match its probabilities. Over a thousand draws the counts settle near those values.

```python run
rng_s = np.random.default_rng(4)
p_pref = softmax(np.array([0.0, 1.0, -1.0]))
draws = rng_s.choice(3, size=1000, p=p_pref)
print("sampled action frequencies:", np.bincount(draws, minlength=3) / 1000)
print("softmax probabilities:      ", np.round(p_pref, 3))
```

## Challenge: the softmax score

```python exercise id=softmax-score title="The score of a chosen action"
import numpy as np

# TODO: `score(theta, a)` returns the gradient of log π(a) for a softmax policy with preferences theta, which is
# the one-hot vector of action a minus the softmax probabilities.
def score(theta, a):
    ...
--- solution
import numpy as np

def score(theta, a):
    theta = np.asarray(theta, dtype=float)
    p = np.exp(theta - theta.max())
    p = p / p.sum()
    onehot = np.zeros_like(theta)
    onehot[a] = 1.0
    return onehot - p
--- test
import numpy as np
result = score(np.array([0.0, 0.0]), 0)
assert result is not None, "Replace the `...` in `score` with code that returns the gradient."
assert np.allclose(result, [0.5, -0.5]), f"With equal preferences π = [0.5, 0.5], so the score for action 0 is [1, 0] − [0.5, 0.5] = [0.5, −0.5], but you returned {result}."
assert abs(score(np.array([1.0, 2.0, 3.0]), 2).sum()) < 1e-9, "The scores of a softmax policy always sum to zero."
--- hint
Build the one-hot vector with a 1 at position `a`, and subtract the softmax probabilities. Use the shifted exponentials for stability.
--- hint
`onehot[a] = 1.0` then `return onehot - p`.
```

## Challenge: a REINFORCE step

```python exercise id=reinforce-step title="One REINFORCE update"
import numpy as np

# TODO: `reinforce_step(theta, a, G, lr)` returns the new preferences after one gradient-ascent step: theta + lr × G × score,
# where score is the gradient of log π(a) for the softmax policy with preferences theta.
def reinforce_step(theta, a, G, lr):
    ...
--- solution
import numpy as np

def reinforce_step(theta, a, G, lr):
    theta = np.asarray(theta, dtype=float)
    p = np.exp(theta - theta.max())
    p = p / p.sum()
    onehot = np.zeros_like(theta)
    onehot[a] = 1.0
    return theta + lr * G * (onehot - p)
--- test
import numpy as np
result = reinforce_step(np.array([0.0, 0.0]), 0, 2.0, 0.5)
assert result is not None, "Replace the `...` in `reinforce_step` with code that returns the new preferences."
assert np.allclose(result, [0.5, -0.5]), f"The step is 0.5 × 2 × [0.5, −0.5] = [0.5, −0.5], but you returned {result}."
down = reinforce_step(np.array([0.0, 0.0]), 1, -1.0, 1.0)
assert np.allclose(down, [0.5, -0.5]), "A negative return with action 1 should move its preference down, which lowers the preference of action 0 relative to it."
--- hint
Compute the score exactly as in the previous challenge, then add `lr * G` times it to theta.
--- hint
`return theta + lr * G * (onehot - p)`.
```

## Debug the direction of the step

This policy update is meant to make rewarding actions more likely, but it moves the preferences downhill.

```python debug id=ascent-direction title="Ascend the reward, don''t descend it"
import numpy as np

theta = np.zeros(2)
a, G, lr = 0, 1.0, 0.5
p = np.exp(theta) / np.exp(theta).sum()
onehot = np.array([1.0, 0.0])
theta = theta - lr * G * (onehot - p)           # bug: a rewarding action should be pushed up
print("preferences after one step:", theta)
--- solution
import numpy as np

theta = np.zeros(2)
a, G, lr = 0, 1.0, 0.5
p = np.exp(theta) / np.exp(theta).sum()
onehot = np.array([1.0, 0.0])
theta = theta + lr * G * (onehot - p)
print("preferences after one step:", theta)
--- test
assert theta[0] > theta[1], f"Action 0 earned a positive return, so its preference should rise above action 1''s, but the preferences are {theta}. Gradient ascent adds the step."
--- hint
We maximize expected return, so we move in the direction of the gradient, not against it.
--- hint
Replace `theta - lr * G * ...` with `theta + lr * G * ...`.
```

## Predict the probability

```python predict id=predict-pg title="What is the softmax probability of action 0 when both preferences are zero?"
import numpy as np
theta = np.zeros(2)
print(np.exp(theta[0]) / np.exp(theta).sum())
--- options
* 0.5
1.0
0.0
0.25
--- explain
With equal preferences every action has the same weight, so each of the two actions has probability one half.
```

## Recap

- A policy gradient method learns the policy''s parameters directly, by gradient ascent on expected return.
- A softmax policy gives every action a positive probability, which supports exploration.
- The REINFORCE gradient is the score of the chosen action times the return that followed.
- Raw returns are noisy, which motivates baselines.

**Up next:** baselines and advantages, and the actor-critic that learns both a policy and a value.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_3_2', 'sec_reinforcement_learning_essentials_3', 'crs_reinforcement_learning_essentials', 'Baselines, advantages and actor-critic', 'interactive', 1, 1080, NULL, NULL, 'The REINFORCE estimator is unbiased, but noisy. In an episode that earned a large return, every action gets pushed up, even the mediocre ones. A **baseline** fixes this without changing the expected gradient: subtract a value that depends only on the state, and push up only the actions that did better than expected. The difference between the return and the baseline is the **advantage**, and it is the quantity most modern policy-gradient methods use.

## Subtracting a baseline keeps the gradient honest

Any baseline $b(s)$ that does not depend on the action leaves the expected gradient unchanged, because the expected score is zero:

$$
\mathbb{E}_{a \sim \pi}\bigl[\nabla_\theta \log \pi(a \mid s)\bigr] = 0
$$

So $\nabla_\theta \log \pi(a \mid s)\,\bigl(G - b(s)\bigr)$ has the same expectation as the version without $b$, but much lower variance. The natural baseline is the state''s value $V(s)$.

```python run
rng = np.random.default_rng(0)
mean_reward = np.array([10.0, 11.0])          # two actions, returns around 10 and 11
p = np.array([0.5, 0.5])                      # a uniform policy
n_samples = 20000
a = rng.choice(2, size=n_samples, p=p)
G = mean_reward[a] + rng.normal(0, 1.0, n_samples)
score = np.eye(2)[a] - p                      # ∇ log π(a) for a softmax policy at θ = 0
baseline = p @ mean_reward                    # the state''s value, 10.5
g_without = G[:, None] * score
g_with = (G - baseline)[:, None] * score
print("mean gradient without baseline:", g_without.mean(axis=0).round(3))
print("mean gradient with baseline:   ", g_with.mean(axis=0).round(3))
print("spread without baseline:", g_without.std(axis=0).round(2), "| with baseline:", g_with.std(axis=0).round(2))
```

Both estimators agree on the average gradient, which is the point of the theory. The baselined version has a much smaller spread, so each sampled step is steadier and more useful.

How much does a baseline change the spread? Compare several baseline values for the same noisy returns.

```python run
rng_b = np.random.default_rng(5)
G_samples = rng_b.normal(10, 2, 5000)
for b in [0.0, 8.0, 10.0]:
    print(f"baseline {b:>4}: mean of G − b {np.mean(G_samples - b):6.2f}, std {np.std(G_samples - b):.2f}")
```

The mean moves with the baseline, but the gradient estimator is unbiased only when the baseline is a function of the state and not of the action. The best baseline removes the variance without changing the policy''s expected update.

## Advantages

The advantage $A = G - V(s)$ measures how much better the action was than the state''s average. Positive advantages are reinforced, and negative ones discouraged.

```python run
returns = np.array([12.0, 9.0, 11.0, 7.0])
values = np.array([10.0, 10.0, 10.0, 10.0])
advantages = returns - values
print("advantages:", advantages)
print("actions to reinforce:", np.where(advantages > 0)[0])
```

## Actor-critic

An **actor** is the policy and a **critic** is a learned value function. The critic estimates $V(s)$ and the actor is updated with the advantage, which the critic supplies. Actor-critic methods learn online, after every step, using the TD error as an advantage estimate.

```python run
def actor_critic(episodes=1500, lr_pi=0.05, lr_v=0.1, gamma=0.9, seed=0):
    # a two-state chain: in state 0 action 1 moves to state 1, which pays 1 and ends the episode
    rng = np.random.default_rng(seed)
    theta = np.zeros((2, 2))
    V = np.zeros(2)
    for _ in range(episodes):
        s, done = 0, False
        while not done:
            p = np.exp(theta[s] - theta[s].max()); p = p / p.sum()
            a = rng.choice(2, p=p)
            if s == 0 and a == 1:
                s2, r, done = 1, 0.0, False
            elif s == 0:
                s2, r, done = 0, 0.0, False
            else:
                s2, r, done = 0, 1.0, True
            target = r if done else r + gamma * V[s2]
            td_error = target - V[s]                    # the advantage estimate
            V[s] += lr_v * td_error
            onehot = np.zeros(2); onehot[a] = 1.0
            theta[s] += lr_pi * td_error * (onehot - p)
            s = s2
    return theta, V

theta_ac, V_ac = actor_critic()
print("learned values:", np.round(V_ac, 2))
print("policy in state 0 (prob of action 1):", round(float(np.exp(theta_ac[0, 1]) / np.exp(theta_ac[0]).sum()), 3))
```

The critic learns that state 0 is worth something positive, and the actor learns to take the path that leads to the reward.

> **In the wild:** A2C, A3C and the PPO methods of the next lesson are all actor-critic algorithms. Their critics are usually neural networks, and their advantages are often computed over several steps at once.

## Challenge: advantages

```python exercise id=advantages title="Compute advantages"
import numpy as np

# TODO: `advantages(returns, values)` returns the array of returns minus the matching baseline values, as floats.
def advantages(returns, values):
    ...
--- solution
import numpy as np

def advantages(returns, values):
    return np.asarray(returns, dtype=float) - np.asarray(values, dtype=float)
--- test
import numpy as np
result = advantages([5.0, 2.0, 7.0], [4.0, 4.0, 4.0])
assert result is not None, "Replace the `...` in `advantages` with code that returns the array."
assert np.allclose(result, [1.0, -2.0, 3.0]), f"The advantages are the returns minus the values, [1, −2, 3], but you returned {result}."
assert np.allclose(advantages([1.0], [1.0]), [0.0]), "An action that exactly matched expectations has zero advantage."
--- hint
Subtract the values from the returns elementwise. Convert to arrays first so both inputs may be lists.
--- hint
`np.asarray(returns, dtype=float) - np.asarray(values, dtype=float)`.
```

## Challenge: the TD advantage

```python exercise id=td-advantage title="The one-step TD advantage"
# TODO: `td_advantage(r, v_s, v_next, gamma, done)` returns the one-step advantage estimate r + gamma × v_next − v_s,
# where v_next is taken as zero when done is True.
def td_advantage(r, v_s, v_next, gamma, done):
    ...
--- solution
def td_advantage(r, v_s, v_next, gamma, done):
    future = 0.0 if done else gamma * v_next
    return float(r + future - v_s)
--- test
result = td_advantage(1.0, 2.0, 4.0, 0.5, False)
assert result is not None, "Replace the `...` in `td_advantage` with code that returns the estimate."
assert abs(result - 1.0) < 1e-9, f"The TD advantage is 1 + 0.5 × 4 − 2 = 1, but you returned {result!r}."
assert abs(td_advantage(1.0, 2.0, 4.0, 0.5, True) + 1.0) < 1e-9, "When the episode is done there is no future value, so the advantage is 1 − 2 = −1."
--- hint
This is the TD error: the one-step target minus the current value. Drop the future term when the episode is done.
--- hint
`future = 0.0 if done else gamma * v_next`, then `return float(r + future - v_s)`.
```

## Debug the baseline

This variance check is meant to subtract the baseline, but it subtracts the return from the value instead.

```python debug id=baseline-sign title="Advantage is the return minus the baseline"
import numpy as np

G = np.array([12.0, 9.0])
V = np.array([10.0, 10.0])
A = V - G                       # bug: the advantage is the return minus the baseline
print("advantages:", A)
--- solution
import numpy as np

G = np.array([12.0, 9.0])
V = np.array([10.0, 10.0])
A = G - V
print("advantages:", A)
--- test
assert np.allclose(A, [2.0, -1.0]), f"The advantage of an action that returned 12 against a baseline of 10 is +2, but the advantages are {A}. Subtract the baseline from the return."
--- hint
An action that beats expectations has a positive advantage. Which quantity should come first in the subtraction?
--- hint
Write `A = G - V`.
```

## Predict the advantage

```python predict id=predict-adv title="What is the advantage?"
G, V = 3.0, 5.0
print(G - V)
--- options
* -2.0
2.0
8.0
-8.0
--- explain
The action returned 3, which is worse than the expected 5, so its advantage is 3 − 5 = −2. Negative advantages discourage the action.
```

## Recap

- A state-dependent baseline leaves the expected policy gradient unchanged and reduces its variance.
- The advantage is the return minus the baseline: how much better the action was than expected.
- Actor-critic learns a policy and a value function together, with the TD error as the advantage estimate.
- The critic''s accuracy determines how useful the advantages are.

**Up next:** PPO, which keeps each policy update inside a safe region.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_3_3', 'sec_reinforcement_learning_essentials_3', 'crs_reinforcement_learning_essentials', 'Proximal policy optimization (PPO)', 'interactive', 2, 1080, NULL, NULL, 'Policy gradients have a dangerous failure mode: one large update can destroy a good policy, and the agent never recovers. **Proximal policy optimization** (PPO) keeps each update close to the previous policy. It measures how much the new policy''s probability for each action has changed, the **probability ratio**, and clips that ratio to a narrow band. Improvements that would move the policy too far earn no extra credit, so the optimizer has no reason to take them.

## The probability ratio

The ratio compares the new policy with the old one for the action that was actually taken:

$$
r_t(\theta) = \frac{\pi_\theta(a_t \mid s_t)}{\pi_{\theta_{\text{old}}}(a_t \mid s_t)}
$$

A ratio of 1 means no change. A ratio of 1.5 means the new policy is fifty per cent more likely to take that action than the old one was.

```python run
import numpy as np

pi_old = np.array([0.5, 0.3, 0.2])
pi_new = np.array([0.6, 0.25, 0.15])
ratios = pi_new / pi_old
print("probability ratios for each action:", np.round(ratios, 2))
```

## The clipped objective

PPO maximizes a surrogate objective that multiplies each ratio by its advantage, but clips the ratio to $[1 - \varepsilon, 1 + \varepsilon]$ and takes the pessimistic minimum of the two versions:

$$
L^{\text{CLIP}} = \mathbb{E}\Bigl[\min\bigl(r_t A_t,\; \operatorname{clip}(r_t, 1-\varepsilon, 1+\varepsilon)\, A_t\bigr)\Bigr]
$$

```python run
def ppo_objective(ratio, advantage, eps=0.2):
    unclipped = ratio * advantage
    clipped = np.clip(ratio, 1 - eps, 1 + eps) * advantage
    return np.minimum(unclipped, clipped)

ratios = np.array([0.5, 1.0, 1.5])
for A in [1.0, -1.0]:
    print(f"advantage {A:+.0f}: objective {np.round(ppo_objective(ratios, A), 2)}")
```

Read the output carefully. With a positive advantage, a ratio above 1.2 gains nothing: the objective is flat, so the optimizer has no incentive to push the action further. With a negative advantage, a ratio below 0.8 gains nothing. The clip stops improvements that would move the policy too far in either direction.

## How often does clipping happen?

The fraction of samples that hit the clip is a useful health check. Too many clipped samples means the learning rate or the number of update epochs is too large.

```python run
rng = np.random.default_rng(0)
for spread in [0.05, 0.3]:
    ratio = 1 + rng.normal(0, spread, 5000)
    clipped = np.mean(np.abs(ratio - 1) > 0.2)
    print(f"policy change spread {spread}: fraction clipped {clipped:.3f}")
```

> **Pitfall:** clipping limits each update but does not guarantee a monotone improvement. PPO still needs a sensible learning rate, and it is normal to monitor the clip fraction and the KL divergence between the old and new policies during training.

## A PPO training loop

The full algorithm collects a batch of experience with the current policy, then performs several epochs of clipped updates on the same batch. The code below is for you to run locally with PyTorch, because it needs a neural network and an automatic-differentiation engine.

```python
# Static: run this on your own machine with PyTorch installed
import torch

def ppo_loss(new_logp, old_logp, advantages, clip=0.2):
    ratio = torch.exp(new_logp - old_logp)
    unclipped = ratio * advantages
    clipped = torch.clamp(ratio, 1 - clip, 1 + clip) * advantages
    return -torch.min(unclipped, clipped).mean()     # minimize the negative objective

# inside the training loop, for several epochs on the same batch:
# loss = ppo_loss(policy.log_prob(actions, states), old_logp, advantages)
# optimizer.zero_grad(); loss.backward(); optimizer.step()
```

The NumPy function `ppo_objective` above computes the same quantity. The torch version negates it because optimizers minimize, and it works with automatic differentiation so the gradient flows through the ratio.

Across a range of ratios, the objective is flat beyond the band in the direction the advantage favours.

```python run
ratios_grid = np.linspace(0.5, 1.5, 5)
print("ratio:             ", np.round(ratios_grid, 2))
print("objective (A = +1):", np.round(ppo_objective(ratios_grid, 1.0), 2))
print("objective (A = −1):", np.round(ppo_objective(ratios_grid, -1.0), 2))
```

## Challenge: the clipped objective

```python exercise id=ppo-clip title="The PPO clipped objective"
import numpy as np

# TODO: `ppo_clip(ratio, advantage, eps)` returns min(ratio × advantage, clip(ratio, 1 − eps, 1 + eps) × advantage)
# for a single ratio and advantage.
def ppo_clip(ratio, advantage, eps):
    ...
--- solution
import numpy as np

def ppo_clip(ratio, advantage, eps):
    clipped_ratio = min(max(ratio, 1 - eps), 1 + eps)
    return float(min(ratio * advantage, clipped_ratio * advantage))
--- test
result = ppo_clip(1.5, 1.0, 0.2)
assert result is not None, "Replace the `...` in `ppo_clip` with code that returns the objective."
assert abs(result - 1.2) < 1e-9, f"A ratio of 1.5 with advantage 1 is clipped to 1.2, and the minimum of 1.5 and 1.2 is 1.2, but you returned {result!r}."
assert abs(ppo_clip(0.5, 1.0, 0.2) - 0.5) < 1e-9, "A ratio below the band is not clipped in this direction, so the value stays 0.5."
assert abs(ppo_clip(1.5, -1.0, 0.2) + 1.5) < 1e-9, "With a negative advantage the unclipped term is the smaller one, so the value is −1.5."
--- hint
Clip the ratio into the band `[1 − eps, 1 + eps]` first, multiply both versions by the advantage, and take the minimum.
--- hint
`clipped_ratio = min(max(ratio, 1 - eps), 1 + eps)`, then `min(ratio * advantage, clipped_ratio * advantage)`.
```

## Challenge: the clip fraction

```python exercise id=clip-fraction title="How many ratios are clipped"
import numpy as np

# TODO: `clip_fraction(ratios, eps)` returns the fraction of ratios that lie outside the band [1 − eps, 1 + eps].
def clip_fraction(ratios, eps):
    ...
--- solution
import numpy as np

def clip_fraction(ratios, eps):
    ratios = np.asarray(ratios, dtype=float)
    return float(np.mean((ratios < 1 - eps) | (ratios > 1 + eps)))
--- test
import numpy as np
result = clip_fraction([0.5, 1.0, 1.5, 1.1], 0.2)
assert result is not None, "Replace the `...` in `clip_fraction` with code that returns the fraction."
assert abs(result - 0.5) < 1e-9, f"Two of four ratios (0.5 and 1.5) lie outside the band, so the fraction is 0.5, but you returned {result!r}."
assert clip_fraction([1.0, 1.0], 0.2) == 0.0, "No ratio outside the band gives a fraction of 0."
--- hint
A ratio is clipped when it is below `1 - eps` or above `1 + eps`. Combine the two tests with `|` and average the boolean array.
--- hint
`np.mean((ratios < 1 - eps) | (ratios > 1 + eps))`.
```

## Debug the clip direction

This PPO objective is meant to take the pessimistic minimum, but it takes the maximum, which rewards exactly the large updates the clip is meant to prevent.

```python debug id=ppo-max title="Take the pessimistic minimum"
import numpy as np

ratio, advantage, eps = 1.5, 1.0, 0.2
clipped = np.clip(ratio, 1 - eps, 1 + eps) * advantage
objective = max(ratio * advantage, clipped)           # bug: the max lets large updates through
print("objective:", objective)
--- solution
import numpy as np

ratio, advantage, eps = 1.5, 1.0, 0.2
clipped = np.clip(ratio, 1 - eps, 1 + eps) * advantage
objective = min(ratio * advantage, clipped)
print("objective:", objective)
--- test
assert abs(objective - 1.2) < 1e-9, f"PPO takes the minimum, giving 1.2 here, but the code gives {objective}. Taking the maximum rewards overly large policy changes."
--- hint
The clip is there to remove the incentive for large changes, so the objective must be the pessimistic version.
--- hint
Replace `max` with `min`.
```

## Predict the clip

```python predict id=predict-clip title="What is the objective for a ratio of 0.5 with a positive advantage?"
import numpy as np
ratio, advantage, eps = 0.5, 1.0, 0.2
print(min(ratio * advantage, np.clip(ratio, 1 - eps, 1 + eps) * advantage))
--- options
* 0.5
0.8
0.2
1.0
--- explain
The ratio 0.5 is below the band, so its clipped version is 0.8. The minimum of 0.5 and 0.8 is 0.5, so the unclipped value is used here. The clip prevents gains from growing past the band, not losses from shrinking.
```

## Recap

- The probability ratio compares the new and old policies for each action taken.
- PPO''s clipped objective removes the incentive for updates that move the policy beyond a narrow band.
- The clip fraction and the policy divergence are the health checks to watch during training.
- Taking the pessimistic minimum is the heart of the method.

**Up next:** reinforcement learning for language models, starting with RLHF and the reward model that learns from human preferences.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_3_4', 'sec_reinforcement_learning_essentials_3', 'crs_reinforcement_learning_essentials', 'Checkpoint: policy-based methods', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"In a softmax policy, what is the gradient of log π(a) with respect to the preferences θ?","options":["The one-hot vector of a minus the probabilities","The probabilities only","The reward of action a","A vector of zeros"],"answerIndex":0,"explanation":"For a softmax policy the score of action a is the one-hot vector of a minus the probability vector."},{"id":"q2","prompt":"Why does subtracting a state-dependent baseline from the return reduce variance without biasing the gradient?","options":["The baseline has the same expected score as zero, so its contribution averages out","The baseline makes the returns larger","The baseline removes the reward entirely","The baseline depends on the chosen action"],"answerIndex":0,"explanation":"A baseline that depends only on the state has zero expected score-weighted contribution, so the expected gradient is unchanged while the noise falls."},{"id":"q3","prompt":"In PPO, what does the clipped objective prevent?","options":["Any update from being computed","Improvements from being credited when the policy moves too far from the old policy","The advantage from being positive","The value function from being learned"],"answerIndex":1,"explanation":"Clipping the probability ratio removes the incentive for updates beyond a narrow band, keeping each step close to the previous policy."},{"id":"q4","prompt":"A PPO ratio of 1.5 with a positive advantage of 1, and clip epsilon 0.2, gives an objective of…","options":["1.5","1.2","0.8","1.0"],"answerIndex":1,"explanation":"The ratio is clipped to 1.2, and the minimum of 1.5 and 1.2 times the advantage is 1.2."},{"id":"q5","prompt":"What is the advantage of an action that returned 3 in a state whose value is 5?","options":["8","2","−2","15"],"answerIndex":2,"explanation":"The advantage is the return minus the baseline, 3 − 5 = −2, so the action performed worse than expected."}]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_4_1', 'sec_reinforcement_learning_essentials_4', 'crs_reinforcement_learning_essentials', 'RLHF: learning from human preferences', 'interactive', 0, 1200, NULL, NULL, 'Language models are trained to predict text, which does not make them helpful, honest or safe. **Reinforcement learning from human feedback** (RLHF) bridges that gap. People compare pairs of model answers and say which they prefer. A **reward model** learns to score answers the way people do, and the language model is then trained with reinforcement learning to earn high scores, while staying close to its original behaviour.

RLHF has three stages: collect preferences, train a reward model on them, and optimize the policy against the reward model with a penalty that keeps it from drifting too far. This lesson builds the first two in NumPy, and explains the third.

## Preferences as comparisons

People find it easier to say which of two answers is better than to give each answer a score. Those comparisons are modelled with the **Bradley–Terry** rule: the probability that answer $A$ is preferred to $B$ depends on the difference of their rewards.

$$
P(A \succ B) = \sigma\bigl(r(A) - r(B)\bigr)
$$

```python run
import numpy as np

def sigmoid(z):
    return 1 / (1 + np.exp(-z))

for diff in [-2.0, 0.0, 2.0]:
    print(f"reward difference {diff:+.1f}: P(preferred) = {sigmoid(diff):.3f}")
```

A difference of zero means a coin flip. A large difference means the preference is nearly certain.

## Train a reward model

Represent each answer by a few features, and let the reward be a weighted sum. The training loss is the negative log-likelihood of the observed preferences.

```python run
rng = np.random.default_rng(0)
n_pairs, d = 300, 3
true_w = np.array([1.0, -0.5, 2.0])          # what the people really value, unknown to the model
A = rng.normal(0, 1, (n_pairs, d))            # features of the preferred answer
B = rng.normal(0, 1, (n_pairs, d))            # features of the rejected answer
prefers_A = (sigmoid((A - B) @ true_w + rng.normal(0, 0.3, n_pairs)) > 0.5)
chosen = np.where(prefers_A[:, None], A, B)
rejected = np.where(prefers_A[:, None], B, A)

w = np.zeros(d)
for step in range(500):
    diff = (chosen - rejected) @ w
    grad = -((1 - sigmoid(diff))[:, None] * (chosen - rejected)).mean(axis=0)
    w -= 0.5 * grad

print("learned reward weights:", w.round(2))
print("training pairs ranked correctly:", round(float(np.mean((chosen - rejected) @ w > 0)), 3))
```

The learned weights point the same way as the hidden values, up to a scale. A reward model only needs to rank answers correctly, so its absolute scale does not matter.

## Optimize the policy with a KL penalty

Once a reward model exists, the policy is trained to maximize it, but a policy that simply chases the reward model drifts into strange text that scores well and reads badly. RLHF keeps the policy close to the original model $\pi_{\text{ref}}$ with a KL penalty:

$$
\max_{\pi}\; \mathbb{E}\bigl[ r(x, y) \bigr] - \beta\, \mathrm{KL}\bigl(\pi(\cdot \mid x)\,\|\,\pi_{\text{ref}}(\cdot \mid x)\bigr)
$$

The coefficient $\beta$ trades reward for fidelity. Large $\beta$ keeps the model close to the original, and small $\beta$ lets it chase the reward model harder.

```python run
def kl(p, q):
    return float(np.sum(p * np.log(p / q)))

pi_ref = np.array([0.4, 0.4, 0.2])
pi_drift = np.array([0.05, 0.05, 0.9])        # a policy that bet everything on one answer
print("KL of a mild change:", round(kl(np.array([0.45, 0.35, 0.2]), pi_ref), 4))
print("KL of the drifted policy:", round(kl(pi_drift, pi_ref), 4))
```

> **Pitfall:** a reward model is only an approximation of human judgement. A policy optimized hard against it will find the approximation''s blind spots. This is reward hacking, and the last lessons of this course are about it.

> **In the wild:** the instruction-following behaviour of modern assistants was trained with preference data and reinforcement learning of this kind, with the KL penalty and a large reward model.

The reward model turns each pair into a predicted probability. For the first five training pairs, the model''s confidence is shown below.

```python run
probs = sigmoid((chosen - rejected) @ w)
print("predicted preference probabilities for five pairs:", np.round(probs[:5], 2))
```

## Challenge: the preference probability

```python exercise id=preference-prob title="Probability that one answer is preferred"
import numpy as np

# TODO: `preference_prob(r_a, r_b)` returns sigmoid(r_a − r_b), the Bradley–Terry probability that answer A is preferred.
def preference_prob(r_a, r_b):
    ...
--- solution
import numpy as np

def preference_prob(r_a, r_b):
    return float(1 / (1 + np.exp(-(r_a - r_b))))
--- test
result = preference_prob(2.0, 2.0)
assert result is not None, "Replace the `...` in `preference_prob` with code that returns the probability."
assert abs(result - 0.5) < 1e-9, "Equal rewards give a probability of one half."
assert abs(preference_prob(1.0, 0.0) - 1 / (1 + np.exp(-1.0))) < 1e-9, "The probability depends on the difference r_a − r_b through the sigmoid."
assert preference_prob(10.0, 0.0) > 0.999, "A large advantage should give a probability near one."
--- hint
Compute the difference first, then pass it through the sigmoid `1 / (1 + exp(−z))`.
--- hint
`return float(1 / (1 + np.exp(-(r_a - r_b))))`.
```

## Challenge: the pairwise loss

```python exercise id=pairwise-loss title="Reward model loss on one pair"
import numpy as np

# TODO: `pairwise_loss(r_chosen, r_rejected)` returns the negative log-likelihood −log σ(r_chosen − r_rejected) of the
# observed preference. Compute it stably as log(1 + exp(−diff)) using np.logaddexp(0, −diff).
def pairwise_loss(r_chosen, r_rejected):
    ...
--- solution
import numpy as np

def pairwise_loss(r_chosen, r_rejected):
    diff = r_chosen - r_rejected
    return float(np.logaddexp(0.0, -diff))
--- test
result = pairwise_loss(0.0, 0.0)
assert result is not None, "Replace the `...` in `pairwise_loss` with code that returns the loss."
assert abs(result - np.log(2)) < 1e-9, f"With equal rewards the probability is 1/2 and the loss is log 2 ≈ 0.693, but you returned {result!r}."
assert pairwise_loss(5.0, 0.0) < 0.01, "A confident correct ranking gives a very small loss."
assert pairwise_loss(-5.0, 0.0) > 4.9, "A confident wrong ranking gives a large loss."
--- hint
The loss is the negative log of the sigmoid of the difference. `np.logaddexp(0, -diff)` computes that without overflow.
--- hint
`return float(np.logaddexp(0.0, -(r_chosen - r_rejected)))`.
```

## Debug the preference direction

This reward-model loss is meant to penalize a wrong ranking, but it reverses the difference, so it rewards the wrong answer.

```python debug id=pref-direction title="Score the chosen answer above the rejected one"
import numpy as np

r_chosen, r_rejected = 3.0, 0.0
diff = r_rejected - r_chosen          # bug: the chosen answer should be the first term
loss = np.logaddexp(0.0, -diff)
print("loss:", round(float(loss), 4))
--- solution
import numpy as np

r_chosen, r_rejected = 3.0, 0.0
diff = r_chosen - r_rejected
loss = np.logaddexp(0.0, -diff)
print("loss:", round(float(loss), 4))
--- test
assert abs(loss - np.logaddexp(0.0, -3.0)) < 1e-9, f"The chosen answer (reward 3) beats the rejected one (0), so the loss should be small, about 0.0486, but it is {loss:.4f}. The difference must be chosen minus rejected."
--- hint
The chosen answer''s reward should be the one that goes first in the difference.
--- hint
Write `diff = r_chosen - r_rejected`.
```

## Predict the probability

```python predict id=predict-rlhf title="What is the Bradley–Terry probability when the rewards are 1 and 1?"
import numpy as np
print(round(float(1 / (1 + np.exp(-(1.0 - 1.0)))), 2))
--- options
* 0.5
0.0
1.0
0.73
--- explain
Equal rewards mean the difference is zero, and the sigmoid of zero is one half. The people are equally likely to prefer either answer.
```

## Recap

- Human preferences are pairwise comparisons, modelled with the Bradley–Terry probability.
- A reward model is trained to rank preferred answers above rejected ones, and only its ranking matters.
- The policy is optimized against the reward model with a KL penalty that keeps it close to the original model.
- The reward model is an approximation, which makes reward hacking a central risk.

**Up next:** DPO, which optimizes the policy directly from preferences and skips the separate reward model.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_4_2', 'sec_reinforcement_learning_essentials_4', 'crs_reinforcement_learning_essentials', 'Direct preference optimization (DPO)', 'interactive', 1, 960, NULL, NULL, 'RLHF works, but it is complicated. It needs a reward model, a reinforcement-learning loop, sampling from the policy during training and careful tuning of the penalty. **Direct preference optimization** (DPO) shows that the same objective can be optimized with a single supervised loss on preference pairs, with no separate reward model and no sampling loop. It has become one of the most widely used alternatives to RLHF.

## The idea in one line

The RLHF objective has an optimal policy in closed form. Rearranging that solution expresses the reward as a log-ratio between the trained policy and the reference policy. Substituting it into the Bradley–Terry preference model gives a loss that depends only on the policy''s log probabilities.

$$
\mathcal{L}_{\text{DPO}} = -\log \sigma\!\left( \beta \Big[ \bigl(\log \pi_\theta(y_w \mid x) - \log \pi_{\text{ref}}(y_w \mid x)\bigr) - \bigl(\log \pi_\theta(y_l \mid x) - \log \pi_{\text{ref}}(y_l \mid x)\bigr) \Big] \right)
$$

Here $y_w$ is the preferred answer and $y_l$ the rejected one. The loss grows when the policy prefers the rejected answer, relative to the reference model, more than it prefers the chosen one.

```python run
import numpy as np

def sigmoid(z):
    return 1 / (1 + np.exp(-z))

def dpo_loss(logp_w, logp_l, ref_w, ref_l, beta=0.1):
    margin = beta * ((logp_w - ref_w) - (logp_l - ref_l))
    return float(np.logaddexp(0.0, -margin))

# the reference model finds both answers equally likely
print("no change from the reference:", round(dpo_loss(-5.0, -5.0, -5.0, -5.0), 4))
print("policy favours the chosen answer:", round(dpo_loss(-3.0, -7.0, -5.0, -5.0), 4))
print("policy favours the rejected answer:", round(dpo_loss(-7.0, -3.0, -5.0, -5.0), 4))
```

When the policy is no different from the reference, the loss is $\log 2$. Training pushes the chosen answer''s relative probability up and the rejected answer''s down.

## Why the reference model matters

The reference model is a fixed copy of the starting policy. Measuring the change against it is what keeps the policy close to where it started, which plays the role of the KL penalty in RLHF.

```python run
beta = 0.1
ref = np.array([-5.0, -5.0])
for shift in [0.0, 1.0, 3.0]:
    policy = ref + np.array([shift, -shift])        # more mass on the chosen answer
    loss = dpo_loss(policy[0], policy[1], ref[0], ref[1], beta)
    print(f"shift {shift}: loss {loss:.4f}, implicit reward margin {beta * (2 * shift):.2f}")
```

The implicit reward margin is what the loss rewards, and it grows with the shift. A larger $\beta$ makes the same change count for more.

Training uses many pairs at once, and the loss is averaged over the batch. Here three pairs are scored: one the policy prefers correctly, one it gets wrong, and one where it has not moved.

```python run
pairs = np.array([[-3.0, -7.0, -5.0, -5.0],
                  [-6.0, -4.0, -5.0, -5.0],
                  [-5.0, -5.0, -5.0, -5.0]])
losses = [dpo_loss(*row, beta=0.1) for row in pairs]
print("loss per pair:", np.round(losses, 3))
print("mean loss over the batch:", round(float(np.mean(losses)), 3))
```

## DPO in practice

The loss needs the log probability of each full answer under the policy and the reference, which language-model libraries compute for you. The code below is for you to run locally, because it needs a language model.

```python
# Static: run this on your own machine with a language model and PyTorch installed
import torch
import torch.nn.functional as F

def dpo_loss_torch(policy_w, policy_l, ref_w, ref_l, beta=0.1):
    margin = beta * ((policy_w - ref_w) - (policy_l - ref_l))
    return -F.logsigmoid(margin).mean()

# policy_w = model.log_prob(chosen_answers), ref_w = reference.log_prob(chosen_answers), and so on
```

> **Pitfall:** DPO is only as good as its preference data. Pairs that are noisy, or that differ only in length, teach the model to prefer length rather than quality.

> **In the wild:** DPO and its variants are used to align open language models, often alongside supervised fine-tuning on high-quality examples first.

The loss falls smoothly as the margin grows. A confident, correct margin contributes almost no gradient, so training focuses on the pairs it still gets wrong.

```python run
margins = np.linspace(-2, 2, 5)
print("margin:", margins)
print("loss:  ", np.round(np.logaddexp(0.0, -margins), 3))
for m_val in [0.0, 2.0, 5.0]:
    print(f"margin {m_val}: gradient size {1 / (1 + np.exp(m_val)):.4f}")
```

## Challenge: the DPO margin

```python exercise id=dpo-margin title="The DPO margin"
# TODO: `dpo_margin(logp_w, logp_l, ref_w, ref_l, beta)` returns beta × ((logp_w − ref_w) − (logp_l − ref_l)).
def dpo_margin(logp_w, logp_l, ref_w, ref_l, beta):
    ...
--- solution
def dpo_margin(logp_w, logp_l, ref_w, ref_l, beta):
    return beta * ((logp_w - ref_w) - (logp_l - ref_l))
--- test
result = dpo_margin(-3.0, -7.0, -5.0, -5.0, 0.5)
assert result is not None, "Replace the `...` in `dpo_margin` with code that returns the margin."
assert abs(result - 0.5 * (2.0 - (-2.0))) < 1e-9, f"The chosen answer rose by 2 and the rejected one fell by 2, so the margin is 0.5 × (2 + 2) = 2, but you returned {result!r}."
assert abs(dpo_margin(-5.0, -5.0, -5.0, -5.0, 0.1)) < 1e-9, "With no change from the reference the margin is zero."
--- hint
Compute the change of each log probability from the reference, subtract the rejected change from the chosen change, then multiply by beta.
--- hint
`beta * ((logp_w - ref_w) - (logp_l - ref_l))`.
```

## Challenge: the DPO loss

```python exercise id=dpo-loss title="The DPO loss from the margin"
import numpy as np

# TODO: `dpo_loss_value(margin)` returns −log σ(margin) for a margin given as a number, computed stably with
# np.logaddexp(0, −margin).
def dpo_loss_value(margin):
    ...
--- solution
import numpy as np

def dpo_loss_value(margin):
    return float(np.logaddexp(0.0, -margin))
--- test
result = dpo_loss_value(0.0)
assert result is not None, "Replace the `...` in `dpo_loss_value` with code that returns the loss."
assert abs(result - np.log(2)) < 1e-9, f"A zero margin gives log 2 ≈ 0.693, but you returned {result!r}."
assert dpo_loss_value(10.0) < 0.001, "A large positive margin gives a loss close to zero."
assert dpo_loss_value(-10.0) > 9.9, "A large negative margin gives a loss close to 10."
--- hint
This is the negative log of the sigmoid of the margin. The stable form is `np.logaddexp(0, -margin)`.
--- hint
`return float(np.logaddexp(0.0, -margin))`.
```

## Debug the swapped answers

This DPO margin is meant to reward the chosen answer, but the two answers are swapped, so the policy is pushed towards the rejected one.

```python debug id=swapped-answers title="Keep the chosen answer first"
import numpy as np

logp_chosen, logp_rejected = -3.0, -7.0
ref_chosen, ref_rejected = -5.0, -5.0
beta = 0.1
margin = beta * ((logp_rejected - ref_rejected) - (logp_chosen - ref_chosen))   # bug: the two are swapped
print("margin:", round(margin, 3))
--- solution
import numpy as np

logp_chosen, logp_rejected = -3.0, -7.0
ref_chosen, ref_rejected = -5.0, -5.0
beta = 0.1
margin = beta * ((logp_chosen - ref_chosen) - (logp_rejected - ref_rejected))
print("margin:", round(margin, 3))
--- test
assert abs(margin - 0.4) < 1e-9, f"The chosen answer rose by 2 and the rejected one fell by 2, so the margin is 0.1 × 4 = 0.4, but it is {margin:.3f}. The chosen answer goes first."
--- hint
The margin should be large and positive when the policy favours the chosen answer.
--- hint
Put the chosen terms first: `(logp_chosen - ref_chosen) - (logp_rejected - ref_rejected)`.
```

## Predict the loss

```python predict id=predict-dpo title="What is the DPO loss when the margin is zero?"
import numpy as np
print(round(float(np.logaddexp(0.0, -0.0)), 3))
--- options
* 0.693
0.0
0.5
1.0
--- explain
With a zero margin the chosen and rejected answers are treated as equal, so the loss is log 2, which is about 0.693.
```

## Recap

- DPO optimizes a supervised loss on preference pairs, with the reference model as the baseline.
- Its margin compares how much the policy changed the chosen answer''s probability against the rejected one''s.
- It removes the reward model and the sampling loop of RLHF, at the cost of depending entirely on the preference data.
- The loss is $-\log\sigma(\text{margin})$, which is $\log 2$ when the policy has not moved.

**Up next:** reward hacking, and how to evaluate an agent in a way that the agent cannot game.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_4_3', 'sec_reinforcement_learning_essentials_4', 'crs_reinforcement_learning_essentials', 'Reward hacking and honest evaluation', 'interactive', 2, 960, NULL, NULL, 'An agent optimizes the reward it is given, not the goal you had in mind. When the reward is an imperfect measure of the goal, a capable enough optimizer finds the gap between them. A cleaning robot rewarded for "no visible dirt" learns to hide the dirt. A chatbot rewarded for approval learns to flatter. This is **reward hacking**, and it is the reason the evaluation of an agent must be designed as carefully as its training.

## Goodhart''s law in numbers

Goodhart''s law says that when a measure becomes a target, it ceases to be a good measure. The simulation below has a true quality that we cannot observe, and a proxy reward that we can. Optimizing the proxy harder first helps the true quality, then hurts it.

```python run
import numpy as np

rng = np.random.default_rng(0)
effort = np.linspace(0, 10, 11)                     # how hard the agent optimizes the proxy
true_quality = effort - 0.15 * effort ** 2          # helps at first, then hurts
proxy_reward = effort                               # the reward keeps climbing

for e, q, p in zip(effort[::2], true_quality[::2], proxy_reward[::2]):
    print(f"effort {e:4.1f}: proxy reward {p:5.1f}   true quality {q:+6.2f}")
```

The proxy reward keeps rising, but true quality peaks and then falls. An agent that is only monitored by the proxy will never notice the decline.

## Evaluate with held-out measures

The defence is to evaluate with measures the agent did not train on, ideally collected separately. Compare two policies on the held-out measure rather than the reward they were trained on.

```python run
rng = np.random.default_rng(1)
trained_on = rng.normal(1.0, 0.2, 200)              # the score the agent was optimized for
held_out = rng.normal(0.2, 0.2, 200)                # an independent check of real quality
print("training reward looks great:", round(trained_on.mean(), 2))
print("held-out quality is modest: ", round(held_out.mean(), 2))
```

A large gap between the optimized measure and the held-out measure is the warning sign of reward hacking.

## Uncertainty: report an interval, not a point

An evaluation averaged over a few episodes can look better or worse by luck. A **bootstrap** confidence interval resamples the observed results to show how much the average could move.

$$
\text{resample the } n \text{ scores with replacement, take the mean, repeat, and read off the 2.5th and 97.5th percentiles}
$$

```python run
scores = np.array([0.9, 1.1, 0.8, 1.3, 0.7, 1.0, 1.2, 0.95, 1.05, 0.85])
boot_rng = np.random.default_rng(2)
boot_means = np.array([boot_rng.choice(scores, len(scores)).mean() for _ in range(2000)])
low, high = np.percentile(boot_means, [2.5, 97.5])
print("mean:", round(scores.mean(), 3), "| 95% interval:", round(low, 3), "to", round(high, 3))
```

Two agents whose intervals overlap heavily are not reliably different, however their point estimates compare.

> **Pitfall:** comparing a single run per agent, or a single average over a few episodes, is how weak improvements get published as wins. Run several seeds and report intervals.

> **In the wild:** evaluation suites for language models and agents combine held-out benchmarks, human ratings and adversarial tests, precisely because any single measure can be gamed.

Two agents with similar means can still differ in ways that the interval must account for. Compare their scores on the same five test episodes.

```python run
agent_a = np.array([1.0, 1.2, 0.9, 1.1, 1.0])
agent_b = np.array([0.95, 1.3, 0.8, 1.2, 1.05])
print("agent A mean:", agent_a.mean().round(3), "| agent B mean:", agent_b.mean().round(3))
print("difference of means:", (agent_a.mean() - agent_b.mean()).round(3))
```

With only five episodes, a difference this small is not reliable, which is why the next challenge and the bootstrap interval matter.

## Challenge: a bootstrap interval

```python exercise id=bootstrap-ci title="Bootstrap confidence interval for a mean"
import numpy as np

# TODO: `bootstrap_ci(values, n_boot, seed)` returns (low, high), the 2.5th and 97.5th percentiles of the means of
# `n_boot` bootstrap resamples of `values` (each resample has the same length, drawn with replacement).
# Use np.random.default_rng(seed).
def bootstrap_ci(values, n_boot, seed):
    ...
--- solution
import numpy as np

def bootstrap_ci(values, n_boot, seed):
    values = np.asarray(values, dtype=float)
    rng = np.random.default_rng(seed)
    means = np.array([rng.choice(values, len(values)).mean() for _ in range(n_boot)])
    low, high = np.percentile(means, [2.5, 97.5])
    return float(low), float(high)
--- test
import numpy as np
values = np.full(20, 3.0)
result = bootstrap_ci(values, 200, 0)
assert result is not None, "Replace the `...` in `bootstrap_ci` with code that returns the interval."
low, high = result
assert np.isclose(low, 3.0) and np.isclose(high, 3.0), "Identical values give an interval of zero width at that value."
data = np.arange(10, dtype=float)
lo, hi = bootstrap_ci(data, 1000, 1)
assert lo < data.mean() < hi, f"The interval should contain the sample mean 4.5, but it is ({lo:.2f}, {hi:.2f})."
assert bootstrap_ci(data, 1000, 1) == (lo, hi), "The same seed must give the same interval."
--- hint
Draw `n_boot` resamples with `rng.choice(values, len(values))`, take each mean, then use `np.percentile` with `[2.5, 97.5]`.
--- hint
Collect the means in an array first, then call `np.percentile(means, [2.5, 97.5])`.
```

## Challenge: win rate between two agents

```python exercise id=win-rate title="Win rate of one agent over another"
import numpy as np

# TODO: `win_rate(a_scores, b_scores)` returns the fraction of paired episodes in which agent A scores higher than
# agent B. A tie counts as half a win. Both inputs have one score per episode, in the same order.
def win_rate(a_scores, b_scores):
    ...
--- solution
import numpy as np

def win_rate(a_scores, b_scores):
    a = np.asarray(a_scores, dtype=float)
    b = np.asarray(b_scores, dtype=float)
    return float(np.mean((a > b) + 0.5 * (a == b)))
--- test
result = win_rate([1.0, 2.0, 3.0], [2.0, 2.0, 1.0])
assert result is not None, "Replace the `...` in `win_rate` with code that returns the rate."
assert abs(result - 0.5) < 1e-9, f"A loses the first episode, ties the second (half a win) and wins the third, so the rate is (0 + 0.5 + 1) / 3 = 0.5, but you returned {result!r}."
assert abs(win_rate([5.0], [1.0]) - 1.0) < 1e-9, "A single episode that A wins gives a rate of 1."
--- hint
Compare the two arrays elementwise. Counting wins as 1 and ties as 0.5 gives `(a > b) + 0.5 * (a == b)`.
--- hint
Average that array with `np.mean`.
```

## Debug the interval source

This evaluation is meant to report the uncertainty of the mean, but it uses the spread of the raw scores as if it were the uncertainty of the average.

```python debug id=ci-source title="Interval of the mean, not of single scores"
import numpy as np

scores = np.array([0.9, 1.1, 0.8, 1.3, 0.7, 1.0, 1.2, 0.95, 1.05, 0.85])
low, high = np.percentile(scores, [2.5, 97.5])     # bug: this is the spread of single scores
print("interval for the mean:", round(low, 3), "to", round(high, 3))
--- solution
import numpy as np

scores = np.array([0.9, 1.1, 0.8, 1.3, 0.7, 1.0, 1.2, 0.95, 1.05, 0.85])
boot_rng = np.random.default_rng(2)
boot_means = np.array([boot_rng.choice(scores, len(scores)).mean() for _ in range(2000)])
low, high = np.percentile(boot_means, [2.5, 97.5])
print("interval for the mean:", round(low, 3), "to", round(high, 3))
--- test
assert high - low < 0.5, f"The uncertainty of the average of ten scores is much narrower than the spread of the scores themselves, but the interval is ({low:.3f}, {high:.3f}). Resample the means."
--- hint
An interval for the mean must come from the distribution of means, not from the individual scores.
--- hint
Compute bootstrap means, then take the percentiles of those means.
```

## Predict the gap

```python predict id=predict-gap title="What does a large gap between the proxy and the held-out measure suggest?"
print("reward hacking")
--- options
* reward hacking
a well-calibrated agent
a perfect reward
sampling noise only
--- explain
When an optimized measure rises while an independent measure does not, the agent has likely found a way to score well on the proxy without improving the goal. That divergence is the signature of reward hacking.
```

## Recap

- Optimizing a proxy hard eventually hurts the true goal, as Goodhart''s law predicts.
- Evaluate with held-out measures that the agent was not optimized against.
- Report uncertainty with a bootstrap interval, and compare agents across several seeds.
- Treat any single measure as easy to game, and combine several.

**Up next:** the capstone, where you train an agent and evaluate it honestly.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_5_1', 'sec_reinforcement_learning_essentials_5', 'crs_reinforcement_learning_essentials', 'Capstone: train and evaluate an agent', 'interactive', 0, 1800, NULL, NULL, 'This is the capstone. You will design a small environment, train a Q-learning agent on it, and evaluate the agent the way a careful practitioner would: over several seeds, on an independent check, with an uncertainty interval, and with a warning about the failure you should watch for.

The environment is a one-dimensional corridor of seven cells. The agent starts in the middle and the goal pays 10 at the right-hand end. A hazard cell lies between them, and each time the agent steps onto it the agent pays 5, so the best route must pass through it at the lowest cost. Every step costs 0.1, so an agent that lingers is penalized.

## Define the environment

```python run
import numpy as np

N_CELLS = 7
START, GOAL, HAZARD = 3, 6, 4

def env_step(s, a):
    s2 = min(max(s + (1 if a == 1 else -1), 0), N_CELLS - 1)
    if s2 == HAZARD:
        return s2, -5.0, False
    if s2 == GOAL:
        return s2, 10.0, True
    return s2, -0.1, False

print("from the start, stepping right goes to", env_step(START, 1)[0], "and stepping left to", env_step(START, 0)[0])
```

## Train with Q-learning

```python run
def train_q(seed, episodes=300, alpha=0.2, gamma=0.95, eps=0.2):
    rng = np.random.default_rng(seed)
    Q = np.zeros((N_CELLS, 2))
    for _ in range(episodes):
        s, done = START, False
        for _ in range(100):
            a = rng.integers(2) if rng.random() < eps else int(np.argmax(Q[s]))
            s2, r, done = env_step(s, a)
            target = r if done else r + gamma * np.max(Q[s2])
            Q[s, a] += alpha * (target - Q[s, a])
            s = s2
            if done:
                break
    return Q

Q = train_q(0)
print("learned action values (left, right) per cell:")
print(np.round(Q, 2))
```

## Roll out the greedy policy

```python run
def rollout_length(Q, max_steps=50):
    s, steps, total = START, 0, 0.0
    while steps < max_steps:
        s, r, done = env_step(s, int(np.argmax(Q[s])))
        steps += 1
        total += r
        if done:
            return steps, total, True
    return steps, total, False

steps, total, reached = rollout_length(Q)
print("greedy rollout: steps", steps, "| return", round(total, 2), "| reached the goal:", reached)
```

## Evaluate over several seeds

A single training run can be lucky or unlucky. Repeat the whole procedure over several seeds, and report the spread.

```python run
returns = []
for seed in range(8):
    Q_seed = train_q(seed)
    _, total, reached = rollout_length(Q_seed)
    returns.append(total if reached else -10.0)
returns = np.array(returns)
print("returns over 8 seeds:", np.round(returns, 2))
print("mean return:", round(returns.mean(), 2), "| seeds that reached the goal:", int(np.sum(returns > 0)), "of 8")
```

## Report an honest interval

```python run
boot = np.random.default_rng(3)
means = np.array([boot.choice(returns, len(returns)).mean() for _ in range(2000)])
low, high = np.percentile(means, [2.5, 97.5])
print(f"95% bootstrap interval for the mean return: {low:.2f} to {high:.2f}")
```

The interval, not the single best run, is the result you report.

## Challenge: greedy rollout length

```python exercise id=greedy-rollout title="Count the steps of the greedy policy"
import numpy as np

N_CELLS = 7
START, GOAL, HAZARD = 3, 6, 4

def env_step(s, a):
    s2 = min(max(s + (1 if a == 1 else -1), 0), N_CELLS - 1)
    if s2 == HAZARD:
        return s2, -5.0, False
    if s2 == GOAL:
        return s2, 10.0, True
    return s2, -0.1, False

# TODO: `greedy_steps(Q, max_steps)` follows the greedy policy (argmax of Q[s]) from START using env_step, and returns
# the number of steps taken until the goal is reached. If the goal is not reached within max_steps, return None.
def greedy_steps(Q, max_steps):
    ...
--- solution
import numpy as np

N_CELLS = 7
START, GOAL, HAZARD = 3, 6, 4

def env_step(s, a):
    s2 = min(max(s + (1 if a == 1 else -1), 0), N_CELLS - 1)
    if s2 == HAZARD:
        return s2, -5.0, False
    if s2 == GOAL:
        return s2, 10.0, True
    return s2, -0.1, False

def greedy_steps(Q, max_steps):
    s, steps = START, 0
    while steps < max_steps:
        s, _, done = env_step(s, int(np.argmax(Q[s])))
        steps += 1
        if done:
            return steps
    return None
--- test
import numpy as np
Q_good = np.zeros((7, 2))
Q_good[:, 1] = 1.0                       # always prefer moving right
result = greedy_steps(Q_good, 20)
assert result is not None, "Replace the `...` in `greedy_steps` with code that returns the number of steps."
assert result == 3, f"From cell 3 moving right three times reaches the goal at cell 6, so the answer is 3, but you returned {result!r}."
Q_left = np.zeros((7, 2))
Q_left[:, 0] = 1.0                       # always prefer moving left, away from the goal
assert greedy_steps(Q_left, 10) is None, "A policy that never reaches the goal should return None."
--- hint
Start at START and repeat: choose the action with `np.argmax(Q[s])`, apply `env_step`, count the step, and stop when `done` is True.
--- hint
Keep a counter for the steps and return it when `done`. If the loop ends without reaching the goal, return None.
```

## Challenge: average over seeds

```python exercise id=seed-average title="Average the returns over seeds"
import numpy as np

# TODO: `seed_summary(returns)` returns a tuple (mean, fraction_positive) for a list of returns, where fraction_positive
# is the share of runs whose return is greater than zero.
def seed_summary(returns):
    ...
--- solution
import numpy as np

def seed_summary(returns):
    returns = np.asarray(returns, dtype=float)
    return float(returns.mean()), float(np.mean(returns > 0))
--- test
result = seed_summary([4.0, -10.0, 6.0, 2.0])
assert result is not None, "Replace the `...` in `seed_summary` with code that returns the tuple."
mean, frac = result
assert abs(mean - 0.5) < 1e-9, f"The mean of 4, −10, 6 and 2 is 0.5, but you returned {mean!r}."
assert abs(frac - 0.75) < 1e-9, f"Three of four runs are positive, so the fraction is 0.75, but you returned {frac!r}."
--- hint
Use `np.mean` for the average and compare the array with zero for the positive share.
--- hint
`return float(returns.mean()), float(np.mean(returns > 0))`.
```

## Debug the evaluation policy

This evaluation is meant to measure the greedy policy, but it chooses actions at random during the rollout, so its score reflects exploration, not the learned behaviour.

```python debug id=eval-explores title="Evaluate the greedy policy, not an exploring one"
import numpy as np

rng = np.random.default_rng(1)
Q = np.array([[0.0, 1.0]] * 7)           # the learned policy always prefers moving right
s, steps = 3, 0
while s != 6 and steps < 50:
    a = rng.integers(2)                  # bug: the evaluation should follow argmax(Q[s])
    s = min(max(s + (1 if a == 1 else -1), 0), 6)
    steps += 1
print("steps taken:", steps)
--- solution
import numpy as np

rng = np.random.default_rng(1)
Q = np.array([[0.0, 1.0]] * 7)
s, steps = 3, 0
while s != 6 and steps < 50:
    a = int(np.argmax(Q[s]))
    s = min(max(s + (1 if a == 1 else -1), 0), 6)
    steps += 1
print("steps taken:", steps)
--- test
assert steps == 3, f"The greedy policy moves right from cell 3 and reaches cell 6 in 3 steps, but the evaluation took {steps}. Choose the action with argmax, not at random."
--- hint
An evaluation measures the policy you learned, so it must always pick the best-valued action.
--- hint
Replace `rng.integers(2)` with `int(np.argmax(Q[s]))`.
```

## Predict the honest report

```python predict id=predict-report title="Which number should you report?"
print("interval")
--- options
* interval
single best run
training return only
the highest seed
--- explain
A single or best run overstates what the method does on average. Several seeds with an uncertainty interval describe the method honestly, and that is the number to report.
```

## Recap

- Design the environment so that the reward is a faithful measure of the goal, and watch for hacks.
- Train over several seeds, because one run can be lucky.
- Evaluate with a greedy rollout, never an exploring one.
- Report an interval for the mean, and treat a single best run as an anecdote.

**Congratulations.** You now understand how agents learn from rewards, from bandits to PPO and RLHF, and how to judge whether they learned anything real. The final assessment checks the whole course.
', 0, '[]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z'),
('les_reinforcement_learning_essentials_5_2', 'sec_reinforcement_learning_essentials_5', 'crs_reinforcement_learning_essentials', 'Final assessment: Reinforcement Learning Essentials', 'quiz', 1, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Dynamic programming needs something that model-free methods do not. What is it?","options":["A large dataset of past episodes","A known model of the transition probabilities and rewards","A neural network","An exploration schedule"],"answerIndex":1,"explanation":"Dynamic programming solves the Bellman equations exactly, which requires the full transition model. Model-free methods learn from experience instead."},{"id":"q2","prompt":"In RLHF, the Bradley–Terry model gives P(A preferred to B) as…","options":["The sum of the two rewards","The sigmoid of the reward difference r(A) − r(B)","The maximum of the two rewards","A uniform one half always"],"answerIndex":1,"explanation":"The probability depends on the difference of the rewards through the sigmoid, so a large difference means a near-certain preference."},{"id":"q3","prompt":"What does the KL penalty in RLHF do?","options":["It increases the reward model''s accuracy","It keeps the trained policy close to the original reference model","It removes the need for preference data","It sets the discount factor"],"answerIndex":1,"explanation":"The penalty trades reward for fidelity, so the policy does not drift into text that scores well on the reward model but reads badly."},{"id":"q4","prompt":"In DPO, what does a margin of zero mean for the loss?","options":["The loss is zero","The loss is log 2, because the policy has not moved relative to the reference","The loss is infinite","The policy has perfectly learned the preferences"],"answerIndex":1,"explanation":"A zero margin gives −log σ(0) = log 2. Training increases the margin by favouring the chosen answer relative to the reference."},{"id":"q5","prompt":"An agent''s optimized reward rises steadily, but an independent quality check stays flat or falls. What is the most likely explanation?","options":["The agent is learning faster","Reward hacking: the agent exploits the gap between the proxy reward and the true goal","The discount factor is too large","The evaluation is too precise"],"answerIndex":1,"explanation":"A proxy that keeps rising while the true goal does not is the classic signature of Goodhart''s law and reward hacking."},{"id":"q6","prompt":"Why should an agent be evaluated over several seeds with an interval rather than with its single best run?","options":["Because a single run is always wrong","Because one run can be lucky, and an interval shows how much the average could vary","Because intervals are always narrower","Because seeds change the environment''s rules"],"answerIndex":1,"explanation":"The best of many runs overstates typical performance. Repeated runs with an interval describe how reliably the method works."}]', '[]', '2026-06-25T06:54:38.127Z', '2026-10-19T06:54:38.127Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_ai_researcher', 'crs_reinforcement_learning_essentials', 3);

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_reinforcement_learning_essentials_1', 'usr_seed00000n', 'crs_reinforcement_learning_essentials', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-09-20T02:54:38.127Z', '2026-09-20T02:54:38.127Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000n');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_reinforcement_learning_essentials_2', 'usr_seed000010', 'crs_reinforcement_learning_essentials', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-09-09T23:54:38.127Z', '2026-09-09T23:54:38.127Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000010');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_reinforcement_learning_essentials_3', 'usr_seed000018', 'crs_reinforcement_learning_essentials', 4, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-09-16T16:54:38.127Z', '2026-09-16T16:54:38.127Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000018');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_reinforcement_learning_essentials_4', 'usr_seed00001u', 'crs_reinforcement_learning_essentials', 3, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-08-15T04:54:38.127Z', '2026-08-15T04:54:38.127Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001u');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_reinforcement_learning_essentials_5', 'usr_seed00001z', 'crs_reinforcement_learning_essentials', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-10-08T02:54:38.127Z', '2026-10-08T02:54:38.127Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_reinforcement_learning_essentials_6', 'usr_seed000028', 'crs_reinforcement_learning_essentials', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-10-22T22:54:38.127Z', '2026-10-22T22:54:38.127Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000028');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_reinforcement_learning_essentials_7', 'usr_seed00002c', 'crs_reinforcement_learning_essentials', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-10-23T01:54:38.127Z', '2026-10-23T01:54:38.127Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002c');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_reinforcement_learning_essentials_8', 'usr_seed00003a', 'crs_reinforcement_learning_essentials', 5, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-10-16T08:54:38.127Z', '2026-10-16T08:54:38.127Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003a');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_reinforcement_learning_essentials_9', 'usr_seed00004a', 'crs_reinforcement_learning_essentials', 2, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-10-08T06:54:38.127Z', '2026-10-08T06:54:38.127Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00004a');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_reinforcement_learning_essentials'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_reinforcement_learning_essentials') WHERE id = 'crs_reinforcement_learning_essentials';
