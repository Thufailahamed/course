Simulation is where vectorized thinking pays off most dramatically. Instead of updating one cell, one particle or one dart at a time, you update **all of them at once** with a handful of array operations. A simulation that crawls as a Python loop runs comfortably in NumPy, even in a browser.

In this final project you'll build three classic simulations:

1. **Conway's Game of Life**: a whole universe evolving by simple local rules, updated with no loops over cells.
2. **Monte Carlo estimation of π**: throwing a hundred thousand random darts at once.
3. **Random walks**: thousands of random paths simulated together, and the surprising $\sqrt{t}$ law they obey.

```python setup
def show(board):
    """Print a 0/1 board: █ for live cells, · for dead ones."""
    print("\n".join("".join("█" if v else "·" for v in row) for row in board))

glider = np.zeros((8, 8), dtype=int)
glider[0, 1] = glider[1, 2] = glider[2, 0] = glider[2, 1] = glider[2, 2] = 1
```

## Part 1: the Game of Life

The Game of Life is played on a grid of cells, each alive (`1`) or dead (`0`). Every generation, every cell looks at its **8 neighbors** and follows two rules:

| Cell is… | Live neighbors | Next generation |
|---|---|---|
| alive | 2 or 3 | stays alive (survival) |
| alive | anything else | dies (loneliness or overcrowding) |
| dead | exactly 3 | comes alive (birth) |
| dead | anything else | stays dead |

From these rules emerge gliders that crawl across the grid, oscillators, and even patterns that build other patterns. The setup created a **glider** and a `show` helper to print boards:

```python run
show(glider)
print("live cells:", glider.sum())
```

### Counting neighbors without looping over cells

The naive approach visits every cell and inspects its 8 neighbors, a double loop over the whole grid. The NumPy approach flips it around: **shift the entire board** in each of the 8 directions and add the shifted copies together. Each cell then holds exactly how many live neighbors it has.

`np.roll` shifts an array along an axis and **wraps** what falls off one edge around to the other. That turns the grid into a torus, so gliders that leave on the right re-enter on the left:

```python run
a = np.array([1, 2, 3, 4, 5])
print("roll right by 1:", np.roll(a, 1))
print("roll left by 1: ", np.roll(a, -1))

b = np.array([[1, 0, 0],
              [0, 0, 0],
              [0, 0, 0]])
print("2-D roll by (1, 1), down and right:")
print(np.roll(b, (1, 1), axis=(0, 1)))
```

```python predict id=predict-roll title="Where does the last element go?"
print(np.roll(np.array([1, 2, 3, 4]), 1))
--- options
[2 3 4 1]
* [4 1 2 3]
[0 1 2 3]
[1 2 3 4]
--- explain
Rolling by `+1` moves every element one position to the right, and the element that falls off the end (`4`) wraps around to the front. With a plain shift it would be lost; with `np.roll` nothing is ever lost.
```

```python exercise id=count-neighbors title="Count every cell's live neighbors"
def count_neighbors(board):
    """For every cell, count live neighbors among the 8 surrounding cells (edges wrap around)."""
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) == (0, 0):
                continue  # a cell is not its own neighbor
            # TODO: add the board shifted by dy rows and dx columns into `total`
            ...
    return total

print(count_neighbors(glider))
--- solution
def count_neighbors(board):
    """For every cell, count live neighbors among the 8 surrounding cells (edges wrap around)."""
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) == (0, 0):
                continue  # a cell is not its own neighbor
            total += np.roll(board, (dy, dx), axis=(0, 1))
    return total

print(count_neighbors(glider))
--- test
rng_t = np.random.default_rng(2)
B = (rng_t.random((7, 9)) < 0.4).astype(int)
B_before = B.copy()
N = count_neighbors(B)
assert N is not None and N is not ..., "count_neighbors should return the array of counts."
N = np.asarray(N)
assert N.shape == (7, 9), f"The counts should have the same shape as the board, (7, 9), got {N.shape}."
assert N.any(), "Every count is 0. Add each shifted copy of the board into `total`."
ref = np.zeros((7, 9), dtype=int)
for i in range(7):
    for j in range(9):
        ref[i, j] = sum(B[(i + di) % 7, (j + dj) % 9] for di in (-1, 0, 1) for dj in (-1, 0, 1) if (di, dj) != (0, 0))
assert np.array_equal(N, ref), "Some counts are wrong. Shift along both axes at once (rows by dy, columns by dx), and remember edges wrap."
assert np.array_equal(B, B_before), "count_neighbors should not modify the board."
--- hint
This loop runs only 8 times, once per direction, not once per cell. Each time, add a shifted copy of the *whole* board to `total`.
--- hint
`np.roll(board, (dy, dx), axis=(0, 1))` shifts rows by `dy` and columns by `dx` in one call. Add it with `total += ...`.
```

### One generation in three lines

With neighbor counts in hand, the rules become boolean array logic. Remember from earlier in the course: combine element-wise conditions with `&` and `|`, and **always wrap each comparison in parentheses**.

```python exercise id=life-step title="Advance the universe one generation"
def count_neighbors(board):  # from the previous challenge
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) != (0, 0):
                total += np.roll(board, (dy, dx), axis=(0, 1))
    return total

def step(board):
    """Return the next generation as an integer array of 0s and 1s."""
    n = count_neighbors(board)
    # TODO: live cells survive with 2 or 3 neighbors; dead cells are born with exactly 3
    return ...

print(step(glider))
--- solution
def count_neighbors(board):  # from the previous challenge
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) != (0, 0):
                total += np.roll(board, (dy, dx), axis=(0, 1))
    return total

def step(board):
    """Return the next generation as an integer array of 0s and 1s."""
    n = count_neighbors(board)
    survive = (board == 1) & ((n == 2) | (n == 3))
    born = (board == 0) & (n == 3)
    return (survive | born).astype(int)

show(step(glider))
--- test
blinker = np.zeros((5, 5), dtype=int)
blinker[2, 1:4] = 1
nxt = step(blinker)
assert nxt is not ..., "step returns `...`. Replace the placeholder with your code."
nxt = np.asarray(nxt)
assert nxt.shape == (5, 5), f"step should return a board of the same shape, (5, 5), got {nxt.shape}."
assert np.issubdtype(nxt.dtype, np.integer), f"step should return 0s and 1s as integers, not {nxt.dtype}. Try `.astype(int)`."
assert set(np.unique(nxt).tolist()) <= {0, 1}, "The next generation should contain only 0s and 1s."
vertical = np.zeros((5, 5), dtype=int)
vertical[1:4, 2] = 1
assert np.array_equal(nxt, vertical), "A horizontal line of 3 (a 'blinker') should turn vertical after one step."
assert np.array_equal(blinker[2, 1:4], [1, 1, 1]), "step should not modify the board it's given."
block = np.zeros((4, 4), dtype=int)
block[1:3, 1:3] = 1
assert np.array_equal(step(block), block), "A 2×2 block is stable; it should not change."
g = glider.copy()
for _ in range(4):
    g = step(g)
assert np.array_equal(g, np.roll(glider, (1, 1), axis=(0, 1))), "After 4 generations the glider should move one cell down and one cell right."
rng_t = np.random.default_rng(4)
B = (rng_t.random((9, 11)) < 0.35).astype(int)
N = count_neighbors(B)
ref = np.array([[1 if (B[i, j] and N[i, j] in (2, 3)) or (not B[i, j] and N[i, j] == 3) else 0 for j in range(11)] for i in range(9)])
assert np.array_equal(step(B), ref), "step gives the wrong result on a random board. Check both rules: survival with 2 or 3, birth with exactly 3."
--- hint
Build two boolean masks: `survive` for live cells with 2 or 3 neighbors, and `born` for dead cells with exactly 3. The next board is `survive | born`.
--- hint
`survive = (board == 1) & ((n == 2) | (n == 3))`. Write `born` the same way, then convert the combined mask with `.astype(int)`.
```

### Debug challenge: the universe explodes

A teammate wrote their own `step`, but every simulation instantly fills with life. Their neighbor count is correct; the bug is elsewhere.

```python debug id=life-precedence-bug title="Why is every cell suddenly alive?"
def count_neighbors(board):
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) != (0, 0):
                total += np.roll(board, (dy, dx), axis=(0, 1))
    return total

def step(board):
    n = count_neighbors(board)
    born = (board == 0) & (n == 3)
    survive = board == 1 & (n == 2) | (n == 3)
    return (born | survive).astype(int)

blinker = np.zeros((5, 5), dtype=int)
blinker[2, 1:4] = 1
show(step(blinker))
--- solution
def count_neighbors(board):
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) != (0, 0):
                total += np.roll(board, (dy, dx), axis=(0, 1))
    return total

def step(board):
    n = count_neighbors(board)
    born = (board == 0) & (n == 3)
    survive = (board == 1) & ((n == 2) | (n == 3))
    return (born | survive).astype(int)

blinker = np.zeros((5, 5), dtype=int)
blinker[2, 1:4] = 1
show(step(blinker))
--- test
blinker = np.zeros((5, 5), dtype=int)
blinker[2, 1:4] = 1
vertical = np.zeros((5, 5), dtype=int)
vertical[1:4, 2] = 1
out = np.asarray(step(blinker))
assert out.sum() < 10, "Almost every cell came alive. Dead cells must stay dead unless they have exactly 3 neighbors."
assert np.array_equal(out, vertical), f"A horizontal blinker should become vertical, but the next board has {int(out.sum())} live cells instead of 3."
g = glider.copy()
for _ in range(4):
    g = step(g)
assert np.array_equal(g, np.roll(glider, (1, 1), axis=(0, 1))), "The glider should move one cell diagonally every 4 generations."
--- hint
Run it: almost every dead cell came alive. Which line decides whether a cell is alive in the next generation, and could it be true for a *dead* cell?
--- hint
In Python, `&` and `|` bind **more tightly** than `==`. So `board == 1 & (n == 2) | (n == 3)` is read as `board == ((1 & (n == 2)) | (n == 3))`. Add parentheses around each comparison.
```

### Watch it live

Here's the glider over eight generations. Each frame uses the same `step` logic you just wrote:

```python run
import matplotlib.pyplot as plt

def life_step(board):
    n = sum(np.roll(board, (dy, dx), axis=(0, 1)) for dy in (-1, 0, 1) for dx in (-1, 0, 1) if (dy, dx) != (0, 0))
    return (((board == 1) & ((n == 2) | (n == 3))) | ((board == 0) & (n == 3))).astype(int)

fig, axes = plt.subplots(1, 8, figsize=(10, 1.6))
board = glider
for gen, ax in enumerate(axes):
    ax.imshow(board, cmap="Greys", vmin=0, vmax=1)
    ax.set_title(f"gen {gen}", fontsize=8)
    ax.set_xticks([])
    ax.set_yticks([])
    board = life_step(board)
plt.show()
```

Every four generations the glider reappears one cell further down and to the right. Now scale up: a random 64 × 64 "soup" left to evolve for 150 generations. That's 615,000 cell updates, with no loop over cells:

```python run
import matplotlib.pyplot as plt

soup = (np.random.default_rng(1).random((64, 64)) < 0.3).astype(int)
population = [soup.sum()]
for _ in range(150):
    soup = life_step(soup)
    population.append(soup.sum())

fig, (left, right) = plt.subplots(1, 2, figsize=(9, 3.4))
left.plot(population)
left.set_xlabel("generation")
left.set_ylabel("live cells")
left.set_title("Population settles down")
right.imshow(soup, cmap="Greys")
right.set_title("Generation 150")
right.set_xticks([])
right.set_yticks([])
plt.show()
print("start:", population[0], " end:", population[-1])
```

The population crashes from chaos, then settles into a sparse world of stable blocks, blinkers and the occasional glider.

## Part 2: Monte Carlo π

Monte Carlo methods answer hard questions with random sampling. Here's the classic: throw darts uniformly at the unit square $[0, 1]^2$. The quarter circle $x^2 + y^2 \le 1$ covers an area of $\pi / 4$, so the fraction of darts landing inside approximates $\pi / 4$:

$$
\pi \approx 4 \cdot \frac{\#\{\text{darts with } x^2 + y^2 \le 1\}}{n}
$$

With NumPy, all $n$ darts are thrown at once: one `(n, 2)` array of random numbers, one comparison, and one mean.

```python exercise id=estimate-pi title="Estimate π by throwing darts"
def estimate_pi(n, seed=0):
    """Estimate π from n random points in the unit square."""
    rng = np.random.default_rng(seed)
    points = ...   # TODO: n random points, shape (n, 2), uniform in [0, 1)
    inside = ...   # TODO: boolean mask, True where x² + y² <= 1
    return ...     # TODO: 4 times the fraction of points inside

print(estimate_pi(100_000))
--- solution
def estimate_pi(n, seed=0):
    """Estimate π from n random points in the unit square."""
    rng = np.random.default_rng(seed)
    points = rng.random((n, 2))
    inside = (points ** 2).sum(axis=1) <= 1
    return 4 * inside.mean()

print(estimate_pi(100_000))
--- test
est = estimate_pi(200_000, seed=1)
assert est is not ..., "estimate_pi returns `...`. Replace the placeholders with your code."
assert np.ndim(est) == 0, f"estimate_pi should return a single number, got shape {np.shape(est)}."
assert abs(float(est) - np.pi) < 0.02, f"With 200,000 darts the estimate should be within 0.02 of π, but it is {float(est):.4f}."
assert estimate_pi(1000, seed=4) == estimate_pi(1000, seed=4), "The same seed should give the same estimate. Build the generator from `seed`."
assert estimate_pi(1000, seed=4) != estimate_pi(1000, seed=5), "Different seeds should give different estimates. Are you ignoring `seed`?"
small = float(estimate_pi(10, seed=0))
hits = small * 10 / 4
assert np.isclose(hits, round(hits)), "With n=10 the estimate should be 4 × (a whole number of hits) / 10. Is every point counted exactly once?"
--- hint
`rng.random((n, 2))` gives `n` points. Each row is one `(x, y)` dart.
--- hint
Square every coordinate, sum each row with `.sum(axis=1)`, and compare with `<= 1`. The mean of a boolean array is the fraction of `True` values.
```

Here are the darts, plus the question every simulation must answer: **how accurate is it?**

```python run
import matplotlib.pyplot as plt

rng = np.random.default_rng(0)
pts = rng.random((3000, 2))
inside = (pts ** 2).sum(axis=1) <= 1

plt.figure(figsize=(3.8, 3.8))
plt.scatter(*pts[inside].T, s=3, color="tab:blue")
plt.scatter(*pts[~inside].T, s=3, color="tab:orange")
plt.title(f"3,000 darts: π ≈ {4 * inside.mean():.4f}")
plt.gca().set_aspect("equal")
plt.show()
```

```python run
import matplotlib.pyplot as plt

rng = np.random.default_rng(1)
ns = np.array([100, 1_000, 10_000, 100_000])
errors = []
for n in ns:
    estimates = [4 * ((rng.random((n, 2)) ** 2).sum(axis=1) <= 1).mean() for _ in range(10)]
    errors.append(np.mean(np.abs(np.array(estimates) - np.pi)))

plt.loglog(ns, errors, "o-", label="average error (10 runs)")
plt.loglog(ns, 1.3 / np.sqrt(ns), "k--", label=r"$\propto 1/\sqrt{n}$")
plt.xlabel("darts")
plt.ylabel("|estimate − π|")
plt.legend()
plt.show()
print(np.round(errors, 5))
```

The error shrinks like $1/\sqrt{n}$: **100× more darts buy only 10× more accuracy**. That law holds for every Monte Carlo method, from option pricing to particle physics, and it's why those fields care so much about fast, vectorized sampling.

## Part 3: random walks

A random walk starts at 0 and takes steps of $+1$ or $-1$ with equal probability. It models diffusing molecules, stock prices and gambler's fortunes. The position after each step is the **running total** of the steps, which is exactly what `cumsum` computes:

```python run
rng = np.random.default_rng(3)
steps = rng.choice([-1, 1], size=10)
print("steps:    ", steps)
print("positions:", steps.cumsum())
```

```python predict id=predict-cumsum title="Where does the walk end, and how low does it go?"
steps = np.array([1, -1, -1, 1, 1])
positions = steps.cumsum()
print(positions[-1], positions.min())
--- options
* 1 -1
1 0
5 -1
3 -2
--- explain
The running totals are `1, 0, -1, 0, 1`. The walk ends at `1` (the same as `steps.sum()`), and its lowest point is `-1`, after the third step.
```

To study walks statistically, simulate thousands at once: a 2-D array of steps with **one walk per row**, and a cumulative sum **along each row**.

```python exercise id=random-walks title="Simulate many walks at once"
def random_walks(n_walks, n_steps, seed=0):
    """Return positions of shape (n_walks, n_steps): each row is one walk of ±1 steps."""
    rng = np.random.default_rng(seed)
    steps = ...   # TODO: random -1/+1 steps, shape (n_walks, n_steps)
    return ...    # TODO: the running total along each walk (row)

walks = random_walks(5, 8)
print(walks)
--- solution
def random_walks(n_walks, n_steps, seed=0):
    """Return positions of shape (n_walks, n_steps): each row is one walk of ±1 steps."""
    rng = np.random.default_rng(seed)
    steps = rng.choice([-1, 1], size=(n_walks, n_steps))
    return steps.cumsum(axis=1)

walks = random_walks(5, 8)
print(walks)
--- test
P = random_walks(4000, 100, seed=3)
assert P is not ..., "random_walks returns `...`. Replace the placeholders with your code."
P = np.asarray(P)
assert P.shape == (4000, 100), f"random_walks(4000, 100) should have shape (4000, 100), got {P.shape}."
assert set(np.unique(P[:, 0]).tolist()) <= {-1, 1}, "Each walk's first position should be its first step: -1 or +1."
assert set(np.unique(np.diff(P, axis=1)).tolist()) <= {-1, 1}, "Consecutive positions in a walk should differ by exactly ±1. Is the running total taken along each row (axis=1)?"
assert np.array_equal(random_walks(50, 20, seed=1), random_walks(50, 20, seed=1)), "The same seed should give the same walks."
final = P[:, -1].astype(float)
assert abs(final.mean()) < 0.6, f"Steps should be +1 or -1 with equal probability, but the average final position is {final.mean():.2f}."
assert abs(np.sqrt((final ** 2).mean()) - 10) < 0.6, "After 100 fair ±1 steps the typical distance from 0 should be about 10. Check that steps are independent."
--- hint
`rng.choice([-1, 1], size=(n_walks, n_steps))` draws every step of every walk in one call.
--- hint
`cumsum` needs an axis here: the running total must go along each row, `axis=1`. Without an axis it flattens everything into one long walk.
```

Now the payoff. Simulate 2,000 walks of 400 steps and look at how far they spread:

```python run
import matplotlib.pyplot as plt

rng = np.random.default_rng(7)
walks = rng.choice([-1, 1], size=(2000, 400)).cumsum(axis=1)
t = np.arange(1, 401)
rms = np.sqrt((walks.astype(float) ** 2).mean(axis=0))

plt.plot(t, walks[:12].T, lw=0.8, alpha=0.8)
plt.plot(t, rms, "k", lw=2, label="RMS distance over 2,000 walks")
plt.plot(t, -rms, "k", lw=2)
plt.plot(t, np.sqrt(t), "r--", label=r"$\sqrt{t}$")
plt.xlabel("step t")
plt.ylabel("position")
plt.legend(loc="upper left")
plt.show()
print("RMS distance after 100, 400 steps:", rms[99].round(2), rms[399].round(2))
```

The black envelope tracks $\sqrt{t}$ almost perfectly. A random walker travels a typical distance of $\sqrt{t}$ after $t$ steps: **four times the time, only twice the distance**. This is the same square-root law as the Monte Carlo error above, and the reason diffusion is so slow.

```python exercise id=walk-stats title="Summarize a batch of walks"
def walk_stats(positions, target=10):
    """Return (mean_final, rms_final, frac_reached) for a (n_walks, n_steps) array."""
    final = ...          # TODO: the last position of every walk, shape (n_walks,)
    mean_final = ...     # TODO: the average final position
    rms_final = ...      # TODO: root-mean-square final distance: sqrt(mean(final ** 2))
    frac_reached = ...   # TODO: fraction of walks whose position is ever >= target
    return mean_final, rms_final, frac_reached

demo = np.array([[1, 2, 3, 2], [-1, -2, -1, 0], [1, 0, 1, 2]])
print(walk_stats(demo, target=3))
--- solution
def walk_stats(positions, target=10):
    """Return (mean_final, rms_final, frac_reached) for a (n_walks, n_steps) array."""
    final = positions[:, -1]
    mean_final = final.mean()
    rms_final = np.sqrt((final.astype(float) ** 2).mean())
    frac_reached = (positions.max(axis=1) >= target).mean()
    return mean_final, rms_final, frac_reached

demo = np.array([[1, 2, 3, 2], [-1, -2, -1, 0], [1, 0, 1, 2]])
print(walk_stats(demo, target=3))
--- test
demo = np.array([[1, 2, 3, 2], [-1, -2, -1, 0], [1, 0, 1, 2]])
out = walk_stats(demo, target=3)
assert isinstance(out, tuple) and len(out) == 3, "walk_stats should return a tuple (mean_final, rms_final, frac_reached)."
m, r, f = out
assert m is not ... and r is not ... and f is not ..., "walk_stats still returns a `...` placeholder. Fill in every TODO."
assert np.ndim(m) == 0 and np.ndim(r) == 0 and np.ndim(f) == 0, "All three statistics should be single numbers. Did you reduce over the right axis?"
assert np.isclose(m, 4 / 3), f"mean_final should average the *last* position of each walk (2, 0 and 2), giving 1.333, but got {m}."
assert np.isclose(r, np.sqrt(8 / 3)), f"rms_final should be sqrt(mean(final ** 2)) = sqrt((4 + 0 + 4) / 3), but got {r}."
assert np.isclose(f, 1 / 3), f"Only the first walk ever reaches 3, so frac_reached should be 1/3, but got {f}. Look at each walk's maximum, not its final position."
rng_t = np.random.default_rng(8)
P = rng_t.choice([-1, 1], size=(300, 60)).cumsum(axis=1)
m2, r2, f2 = walk_stats(P, target=8)
assert np.isclose(m2, P[:, -1].mean()) and np.isclose(r2, np.sqrt((P[:, -1].astype(float) ** 2).mean())), "walk_stats gives the wrong mean or RMS on random walks."
assert np.isclose(f2, (P.max(axis=1) >= 8).mean()), "walk_stats gives the wrong frac_reached on random walks. Respect the `target` argument."
--- hint
The final positions are the last *column*: `positions[:, -1]`. Means and RMS of that 1-D array are single numbers.
--- hint
A walk "ever reaches" the target when its **maximum** over time is at least `target`: `positions.max(axis=1) >= target` gives one boolean per walk, and its `.mean()` is the fraction.
```

> **In the wild:** these exact patterns (shifted-array stencils, batched random sampling, `cumsum` along an axis) power real scientific code: image filters and fluid simulations use roll-and-add stencils, reinforcement learning computes discounted returns with cumulative sums, and Monte Carlo dropout and bootstrapping are batched sampling.

## Recap

- Vectorized simulations update **every** cell, dart or walker at once; loops shrink to a handful of passes over whole arrays.
- `np.roll` plus addition counts neighbors on a wrapping grid; boolean masks with parenthesized `&` / `|` express the rules.
- Monte Carlo estimates converge like $1/\sqrt{n}$, and random walks spread like $\sqrt{t}$.
- `cumsum(axis=1)` turns a batch of steps into a batch of trajectories, and per-row reductions such as `max(axis=1)` summarize them.

**Congratulations!** You've completed every project in NumPy Mastery. You can now read, write and debug the array code behind pandas, scikit-learn and PyTorch. Take the final exam to earn your certificate.
