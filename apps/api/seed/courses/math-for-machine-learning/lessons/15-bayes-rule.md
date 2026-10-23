A medical test comes back positive. The test is 95% accurate. Should you panic? Most people say yes, and most people are wrong: if the disease is rare, the answer is probably not. The reason is **Bayes' rule**, the formula for updating a belief when evidence arrives. It is the foundation of spam filters, diagnostic tools, probabilistic programming and every Bayesian method in machine learning.

By the end of this lesson you will apply Bayes' rule to a real-world test, verify the answer with a simulated population, update a belief one observation at a time on a grid, and build a naive Bayes spam score.

## The base-rate trap

Suppose a disease affects 1 in 100 people. A test detects it 95% of the time when it is present (sensitivity), and wrongly flags 5% of healthy people (false-positive rate). You test positive. What is the chance you are sick?

```python run
import numpy as np

prevalence = 0.01          # P(disease)
sensitivity = 0.95         # P(positive | disease)
false_positive = 0.05      # P(positive | no disease)

p_positive = sensitivity * prevalence + false_positive * (1 - prevalence)
posterior = sensitivity * prevalence / p_positive

print(f"P(positive) = {p_positive:.4f}")
print(f"P(disease | positive) = {posterior:.4f}")
```

The answer is about 16%, not 95%. Most positive results come from the large healthy population, which produces many false alarms, and that outweighs the small sick population.

## Bayes' rule

Bayes' rule converts the probability of the evidence given the hypothesis into the probability of the hypothesis given the evidence.

$$
P(A \mid B) = \frac{P(B \mid A)\, P(A)}{P(B)}
$$

The denominator, $P(B)$, is found by the **law of total probability**: sum the evidence over both possibilities for $A$. Here $P(\text{positive}) = P(+ \mid \text{sick})P(\text{sick}) + P(+ \mid \text{healthy})P(\text{healthy})$, which is exactly the `p_positive` line above.

## Check it with a simulated population

Simulation is the best defence against a wrong formula. Create 200,000 people, give each their true status and then a test result, and count.

```python run
rng = np.random.default_rng(0)
N = 200_000
sick = rng.random(N) < prevalence
positive = np.where(sick, rng.random(N) < sensitivity, rng.random(N) < false_positive)

print("simulated P(disease | positive):", round(sick[positive].mean(), 4))
print("formula:                        ", round(posterior, 4))
```

The simulated fraction agrees with the formula. You can trust Bayes' rule because you can reproduce it by counting.

## Updating a belief, one observation at a time

Bayes' rule can run repeatedly. Each posterior becomes the prior for the next observation. Here we infer a coin's unknown bias $p$ on a grid of possible values. We start with no preference (a uniform prior), observe 7 heads and 3 tails, and multiply the prior by the likelihood $p^{h}(1-p)^{t}$ at every grid point.

```python run
import matplotlib.pyplot as plt

grid = np.linspace(0, 1, 501)              # possible values of p = P(heads)
prior = np.ones_like(grid) / grid.size     # every value equally likely at first

def update(belief, heads, tails):
    likelihood = grid ** heads * (1 - grid) ** tails
    posterior = belief * likelihood
    return posterior / posterior.sum()

after_10 = update(prior, heads=7, tails=3)
print("most probable p after 7 heads and 3 tails:", round(float(grid[np.argmax(after_10)]), 3))

fig, ax = plt.subplots()
ax.plot(grid, prior, "--", label="prior: no idea")
ax.plot(grid, after_10, label="posterior after 10 flips")
ax.set_xlabel("p"); ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

The posterior is a curve centred near 0.7, and it is narrower than the flat prior. Evidence concentrates belief.

> **Tip:** the grid approach works for any model you can write down. Real systems use exact formulas or sampling, but the logic is the same: prior times likelihood, then normalize.

## Naive Bayes: many clues at once

A spam filter sees many words. If we assume the words are independent given the class (the "naive" part), the posterior odds multiply:

$$
P(\text{spam} \mid w_1, \dots, w_k) \propto P(\text{spam}) \prod_i P(w_i \mid \text{spam})
$$

The normalization divides by the same product computed for "not spam" too.

```python run
def spam_probability(p_spam, likelihoods_spam, likelihoods_ham):
    spam_score = p_spam * np.prod(likelihoods_spam)
    ham_score = (1 - p_spam) * np.prod(likelihoods_ham)
    return spam_score / (spam_score + ham_score)

# Words "free" and "meeting": how likely each is in spam and in legitimate mail
print("P(spam | free, meeting):", round(spam_probability(0.4, [0.6, 0.05], [0.1, 0.3]), 3))
```

The word "free" is common in spam and rare in legitimate mail, so it pushes the score up. "Meeting" does the opposite, and the combined probability reflects both.

## Challenges

```python exercise id=posterior-positive title="The probability of disease after a positive test"
# TODO: `posterior_positive(prevalence, sensitivity, false_positive)` should return
# P(disease | positive), using the law of total probability in the denominator.
def posterior_positive(prevalence, sensitivity, false_positive):
    ...
--- solution
def posterior_positive(prevalence, sensitivity, false_positive):
    p_positive = sensitivity * prevalence + false_positive * (1 - prevalence)
    return sensitivity * prevalence / p_positive
--- test
result = posterior_positive(0.01, 0.95, 0.05)
assert result is not None, "Replace the `...` in `posterior_positive` with code that returns the probability."
assert np.isclose(result, 0.161, atol=1e-3), f"With a 1% prevalence, a 95% sensitivity and a 5% false-positive rate, P(disease | positive) is about 0.161, but you returned {result!r}."
assert np.isclose(posterior_positive(0.5, 0.9, 0.1), 0.9), "With prevalence 50%, sensitivity 0.9 and false-positive rate 0.1, P(disease | positive) should be 0.9."
--- hint
The denominator is the chance of a positive result from either group: sick people who test positive, plus healthy people who test positive.
--- hint
`p_positive = sensitivity * prevalence + false_positive * (1 - prevalence)`, then divide the sick-and-positive term by `p_positive`.
```

```python exercise id=grid-belief title="Update a belief on a grid"
# TODO: `update_belief(belief, grid, heads, tails)` should multiply the belief by the
# likelihood grid**heads * (1 - grid)**tails and return the normalized posterior.
def update_belief(belief, grid, heads, tails):
    ...
--- solution
def update_belief(belief, grid, heads, tails):
    posterior = belief * grid ** heads * (1 - grid) ** tails
    return posterior / posterior.sum()
--- test
grid = np.linspace(0, 1, 101)
prior = np.ones_like(grid) / grid.size
result = update_belief(prior, grid, heads=6, tails=4)
assert result is not None, "Replace the `...` in `update_belief` with code that returns the posterior."
assert np.isclose(result.sum(), 1.0), f"A posterior must sum to 1, but yours sums to {result.sum()!r}."
assert abs(grid[np.argmax(result)] - 0.6) < 0.011, f"With a flat prior, 6 heads and 4 tails peak at p = 0.6, but your peak is at {grid[np.argmax(result)]}."
second = update_belief(result, grid, heads=0, tails=0)
assert np.allclose(second, result), "With no new data, the posterior should not change."
--- hint
Multiply the belief by `grid ** heads * (1 - grid) ** tails` elementwise, then divide by the total so the result sums to 1.
--- hint
`posterior = belief * grid ** heads * (1 - grid) ** tails`, then `posterior / posterior.sum()`.
```

```python exercise id=naive-spam title="Naive Bayes spam probability"
# TODO: `spam_probability(p_spam, likelihoods_spam, likelihoods_ham)` should return
# P(spam | words) under the naive independence assumption. `likelihoods_spam` holds
# P(word | spam) for each word, and `likelihoods_ham` holds P(word | not spam).
def spam_probability(p_spam, likelihoods_spam, likelihoods_ham):
    ...
--- solution
def spam_probability(p_spam, likelihoods_spam, likelihoods_ham):
    spam_score = p_spam * np.prod(likelihoods_spam)
    ham_score = (1 - p_spam) * np.prod(likelihoods_ham)
    return spam_score / (spam_score + ham_score)
--- test
result = spam_probability(0.4, [0.6, 0.05], [0.1, 0.3])
assert result is not None, "Replace the `...` in `spam_probability` with code that returns the probability."
assert np.isclose(result, 0.4), f"With these numbers P(spam | words) = 0.012 / (0.012 + 0.018) = 0.4, but you returned {result!r}."
assert np.isclose(spam_probability(0.2, [0.8], [0.1]), 2 / 3), "With prior 0.2 and one word, the answer should be 2/3."
--- hint
Compute the score for spam as prior times the product of the spam likelihoods, and the score for ham the same way. Then divide the spam score by the sum of both.
--- hint
`np.prod` multiplies a list of numbers together.
```

```python debug denominator-bug id=denominator-bug title="Too confident"
prevalence = 0.01
sensitivity = 0.95
false_positive = 0.05

# P(disease | positive) = P(positive | disease) P(disease) / P(positive)
p_positive = sensitivity * prevalence     # P(positive)
posterior = sensitivity * prevalence / p_positive
print("P(disease | positive):", round(posterior, 3))
--- solution
prevalence = 0.01
sensitivity = 0.95
false_positive = 0.05

# P(disease | positive) = P(positive | disease) P(disease) / P(positive)
p_positive = sensitivity * prevalence + false_positive * (1 - prevalence)
posterior = sensitivity * prevalence / p_positive
print("P(disease | positive):", round(posterior, 3))
--- test
assert np.isclose(posterior, 0.161, atol=1e-3), f"P(disease | positive) should be about 0.161, but it is {posterior:.3f}."
--- hint
A posterior of 1.0 means a positive test proves disease, which cannot be right with a 5% false-positive rate. Check which healthy people also test positive.
--- hint
`P(positive)` has two parts: sick people who test positive, and healthy people who test positive. The second part is missing.
```

```python predict id=predict-bayes title="Bayes by hand"
p_a = 0.5
p_b_given_a = 0.8
p_b_given_not_a = 0.2
p_a_given_b = p_b_given_a * p_a / (p_b_given_a * p_a + p_b_given_not_a * (1 - p_a))
print(round(p_a_given_b, 2))
--- options
0.5
0.2
* 0.8
0.6
--- explain
The numerator is 0.8 × 0.5 = 0.4. The denominator is 0.4 + 0.2 × 0.5 = 0.5. Dividing gives 0.4 / 0.5 = 0.8.
```

## Recap

- Bayes' rule: $P(A \mid B) = P(B \mid A)P(A) / P(B)$. The posterior combines prior belief and evidence.
- The base-rate effect: when a condition is rare, most positive results can be false, even with an accurate test.
- Check a formula by simulating a population and counting.
- Repeated updating multiplies the prior by each likelihood and renormalizes.
- Naive Bayes multiplies per-word likelihoods, assuming the words are independent given the class.

**Up next:** maximum likelihood, the principle that turns Bayes' likelihood into a way of fitting models to data.
