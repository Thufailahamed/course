Images are fixed grids, but many important inputs are sequences: sentences, sensor readings, music, prices over time. A **recurrent neural network** (RNN) processes a sequence one step at a time and carries a hidden state forward, a memory of what it has seen. The idea is simple. The difficulty is that memory fades, and in this lesson you will see exactly why.

## One step, one update

At each time step the RNN reads an input $x_t$ and combines it with the previous state $h_{t-1}$:

$$
h_t = \tanh\bigl(x_t W_x + h_{t-1} W_h + b\bigr)
$$

The same weights $W_x$, $W_h$ and $b$ are used at every step. That reuse is what lets an RNN handle sequences of any length.

```python run
import numpy as np

def rnn_step(x_t, h_prev, Wx, Wh, b):
    return np.tanh(x_t @ Wx + h_prev @ Wh + b)

rng = np.random.default_rng(0)
Wx = rng.normal(0, 0.5, size=(2, 3))     # 2 input features, 3 hidden units
Wh = rng.normal(0, 0.5, size=(3, 3))
b = np.zeros(3)

h = np.zeros(3)                          # start with an empty memory
x1 = np.array([1.0, -0.5])
h = rnn_step(x1, h, Wx, Wh, b)
print("state after one step:", np.round(h, 3))
```

## Unroll the sequence

Run the same step over a whole sequence, and keep every state. The final state summarizes the sequence, and the earlier states are what a model uses to make predictions at each time step.

```python run
def rnn_forward(xs, h0, Wx, Wh, b):
    states = []
    h = h0
    for x_t in xs:
        h = rnn_step(x_t, h, Wx, Wh, b)
        states.append(h)
    return np.array(states)

xs = rng.normal(size=(6, 2))             # a sequence of 6 steps
states = rnn_forward(xs, np.zeros(3), Wx, Wh, b)
print("states shape:", states.shape, "(time steps, hidden units)")
print("norm of each state:", np.round(np.linalg.norm(states, axis=1), 3))
```

## Memory fades

Put a single strong signal at the start of a sequence and then silence. How long does the network remember it? The answer depends on the size of the recurrent weight. Try the two settings below.

```python run
def impulse_memory(w_rec, steps=15):
    h = 1.0                              # an input at t = 0, then nothing
    trace = [h]
    for _ in range(steps):
        h = np.tanh(w_rec * h)           # a one-unit RNN with no input after t = 0
        trace.append(h)
    return np.array(trace)

for w_rec in [0.5, 0.95]:
    trace = impulse_memory(w_rec)
    print(f"recurrent weight {w_rec}: state after 15 steps = {trace[-1]:.4f}")
```

With a recurrent weight of 0.5 the signal is gone in a few steps. With 0.95 it lingers. Neither network can remember the first input after a long delay without a change to the design.

## Why gradients vanish

Training an RNN means backpropagating through every time step. The gradient flowing back $t$ steps picks up one recurrent factor per step, so it grows or shrinks like a power of the recurrent weight. Look at what that does over 50 steps.

```python run
for w_rec in [0.5, 0.9, 1.1]:
    g = 1.0
    for _ in range(50):
        g *= w_rec                       # one factor per time step
    print(f"recurrent weight {w_rec}: gradient factor after 50 steps = {g:.2e}")
```

A factor below one vanishes to nothing, so the network cannot learn from distant inputs. A factor above one explodes, which is why gradient clipping from lesson 16 is standard for RNNs. The tanh derivative, which is at most one, makes vanishing even more likely.

> **Under the hood:** LSTMs and GRUs fix the vanishing problem with gates. A gate is a learned value between zero and one that controls how much of the old memory is kept, so information can flow across many steps without being multiplied away at each one.

## Challenge: one recurrent step

```python exercise id=rnn-step title="One recurrent step"
# TODO: `rnn_step(x_t, h_prev, Wx, Wh, b)` returns the new hidden state tanh(x_t Wx + h_prev Wh + b).
# x_t has shape (d,), h_prev has shape (k,), Wx has shape (d, k), Wh has shape (k, k), and b has shape (k,).
def rnn_step(x_t, h_prev, Wx, Wh, b):
    ...
--- solution
def rnn_step(x_t, h_prev, Wx, Wh, b):
    return np.tanh(x_t @ Wx + h_prev @ Wh + b)
--- test
Wx_t = np.array([[1.0, 0.0], [0.0, 1.0]])
Wh_t = np.array([[0.5, 0.0], [0.0, 0.5]])
result = rnn_step(np.array([1.0, 0.0]), np.array([0.0, 2.0]), Wx_t, Wh_t, np.zeros(2))
assert result is not None, "Replace the `...` in `rnn_step` with code that returns the new state."
assert result.shape == (2,), f"The new state should have shape (2,), but it has {result.shape}."
assert np.allclose(result, np.tanh([1.0, 1.0])), f"The pre-activation is [1, 0] + [0, 1] = [1, 1], so the state should be tanh([1, 1]), but you returned {result}."
--- hint
Add the input contribution `x_t @ Wx`, the memory contribution `h_prev @ Wh`, and the bias, then apply `np.tanh`.
--- hint
`return np.tanh(x_t @ Wx + h_prev @ Wh + b)`.
```

## Challenge: run the whole sequence

```python exercise id=rnn-forward title="Unroll an RNN over a sequence"
# TODO: `rnn_states(xs, h0, Wx, Wh, b)` runs rnn_step over every row of xs (shape (T, d)), starting from h0,
# and returns an array of shape (T, k) holding the state after each step.
def rnn_states(xs, h0, Wx, Wh, b):
    ...
--- solution
def rnn_states(xs, h0, Wx, Wh, b):
    states = []
    h = h0
    for x_t in xs:
        h = np.tanh(x_t @ Wx + h @ Wh + b)
        states.append(h)
    return np.array(states)
--- test
rng_t = np.random.default_rng(2)
xs_t = rng_t.normal(size=(5, 2))
Wx_t = rng_t.normal(size=(2, 3))
Wh_t = rng_t.normal(size=(3, 3))
b_t = np.zeros(3)
result = rnn_states(xs_t, np.zeros(3), Wx_t, Wh_t, b_t)
assert result is not None, "Replace the `...` in `rnn_states` with code that returns the states."
assert result.shape == (5, 3), f"Five steps with three hidden units should give shape (5, 3), but you returned {result.shape}."
h = np.zeros(3)
for x_t in xs_t:
    h = np.tanh(x_t @ Wx_t + h @ Wh_t + b_t)
assert np.allclose(result[-1], h), "The last state should equal the state after running every step in order."
assert np.allclose(result[0], np.tanh(xs_t[0] @ Wx_t + b_t)), "With a zero start, the first state depends only on the first input."
--- hint
Keep a variable `h` for the current state, update it inside the loop, and append it to a list.
--- hint
Start `h = h0`, and inside the loop set `h = np.tanh(x_t @ Wx + h @ Wh + b)` and append `h`.
```

## Debug the state bookkeeping

This version records states one step late. It appends the state before updating it.

```python debug id=state-timing title="Record the state after the update"
def rnn_states(xs, h0, Wx, Wh, b):
    states = []
    h = h0
    for x_t in xs:
        states.append(h)                              # bug: stores the state before the update
        h = np.tanh(x_t @ Wx + h @ Wh + b)
    return np.array(states)

rng_d = np.random.default_rng(1)
xs_d = rng_d.normal(size=(3, 2))
print(np.round(rnn_states(xs_d, np.zeros(2), rng_d.normal(size=(2, 2)), np.eye(2) * 0.5, np.zeros(2)), 3))
--- solution
def rnn_states(xs, h0, Wx, Wh, b):
    states = []
    h = h0
    for x_t in xs:
        h = np.tanh(x_t @ Wx + h @ Wh + b)
        states.append(h)
    return np.array(states)

rng_d = np.random.default_rng(1)
xs_d = rng_d.normal(size=(3, 2))
print(np.round(rnn_states(xs_d, np.zeros(2), rng_d.normal(size=(2, 2)), np.eye(2) * 0.5, np.zeros(2)), 3))
--- test
rng_t = np.random.default_rng(1)
xs_t = rng_t.normal(size=(3, 2))
Wx_t = rng_t.normal(size=(2, 2))
out = rnn_states(xs_t, np.zeros(2), Wx_t, np.eye(2) * 0.5, np.zeros(2))
assert np.allclose(out[0], np.tanh(xs_t[0] @ Wx_t)), "The first state should already include the first input. The states are recorded before the update."
assert np.all(np.any(out != 0, axis=1)), "Every step should produce a non-zero state for these inputs. A zero row means the state was recorded too early."
--- hint
Look at the order of the two lines inside the loop: which one happens first, the append or the update?
--- hint
Swap them: update `h` first, then append it.
```

## Predict the gradient factor

```python predict id=predict-rnn title="What is the gradient factor?"
w_rec = 0.5
g = 1.0
for _ in range(3):
    g *= w_rec
print(g)
--- options
* 0.125
0.5
1.5
0.03125
--- explain
Each of the three steps multiplies the gradient by 0.5, so the factor is 0.5³ = 0.125. The same multiplication over 50 steps gives a factor near 10⁻¹⁶, which is why distant inputs stop influencing the weights.
```

## Recap

- An RNN updates a hidden state with $h_t = \tanh(x_t W_x + h_{t-1} W_h + b)$, reusing the same weights at every step.
- The hidden state is a memory of the sequence, and its final value summarizes the input.
- Backpropagation through time multiplies one recurrent factor per step, so gradients vanish or explode with the recurrent weight.
- Gates in LSTMs and GRUs let information survive long sequences.

**Up next:** attention. Instead of squeezing a whole sequence into one memory, the model looks back at every position directly, and that idea powers Transformers.
