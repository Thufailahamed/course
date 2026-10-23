You have now computed gradients by hand for one neuron and for a small graph. Writing those formulas for a real network would take forever, and every change to the architecture would break them. The fix is to let the computer build the graph and run the backward pass for you. That is what **automatic differentiation**, or **autograd**, does, and it is the engine inside every deep-learning framework.

In this lesson you will read a complete autograd engine of about forty lines, then write its two most important pieces yourself: the backward rule for multiplication, and the procedure that walks the graph.

## A value that remembers how it was made

The idea is simple. Each number becomes a `Value` object that stores three things: its data, its gradient, and a small function that knows how to push the gradient back to the values that produced it. Adding or multiplying two `Value`s builds a new `Value` and records the link.

```python run
import numpy as np

class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data * other.data, (self, other))
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        return out

    def tanh(self):
        t = np.tanh(self.data)
        out = Value(t, (self,))
        def _backward():
            self.grad += (1 - t ** 2) * out.grad
        out._backward = _backward
        return out

    def backward(self):
        order, seen = [], set()
        def build(v):
            if v not in seen:
                seen.add(v)
                for p in v._parents:
                    build(p)
                order.append(v)
        build(self)
        self.grad = 1.0
        for v in reversed(order):
            v._backward()

    __radd__ = __add__
    __rmul__ = __mul__

print("Value engine ready")
```

The class is short, but read it slowly. The `+=` in every `_backward` is the important part: a value used on several paths collects the gradient from each of them, which is the rule you saw in lesson 7.

## Run it on a small expression

```python run
a = Value(2.0)
b = Value(-3.0)
c = Value(10.0)
d = a * b + c           # d = a·b + c
f = d * d               # d is used twice
f.backward()

print("f =", f.data)
print("df/da =", a.grad, "(expected -24)")
print("df/db =", b.grad, "(expected 16)")
print("df/dc =", c.grad, "(expected 8)")
```

The engine reproduces the numbers from lesson 7 without a single formula written by hand.

## A neuron with tanh, with autograd

```python run
x1, x2 = Value(0.5), Value(-1.0)
w1, w2 = Value(0.8), Value(0.3)
bias = Value(0.1)

n = x1 * w1 + x2 * w2 + bias
out = n.tanh()
out.backward()

print("output:", round(out.data, 4))
print("grad w1:", round(w1.grad, 4), "| grad w2:", round(w2.grad, 4))
```

Every weight now has a gradient, and the training loop only has to subtract a little of each.

## Check it numerically

Trust the engine the way you trust your own code: test it against a numerical estimate.

```python run
def forward(w1_value):
    return np.tanh(0.5 * w1_value - 0.3 + 0.1)

h = 1e-6
numeric = (forward(0.8 + h) - forward(0.8 - h)) / (2 * h)
print("numerical grad w1:", round(numeric, 4), "| engine:", round(w1.grad, 4))
```

## Gradients accumulate, and so do calls

Calling `backward` twice on the same graph adds to the gradients a second time. This is why real frameworks ask you to zero the gradients before each training step, and you will see the same rule in PyTorch.

```python run
w = Value(1.0)
diff = w + (-4.0)           # w - 4, built from the operations we have
loss = diff * diff          # loss = (w - 4)², with diff used twice
loss.backward()
print("after one backward:", w.grad)
loss.backward()
print("after a second backward:", w.grad)
```

> **In the wild:** PyTorch's `loss.backward()` accumulates into `.grad` in exactly this way. Forgetting `optimizer.zero_grad()` is the most common reason a training run behaves oddly for no visible reason.

## Challenge: backward for multiplication

The starter below is almost complete. Your task is the backward rule for `__mul__`: the gradient with respect to each input is the other input times the gradient of the output.

```python exercise id=value-mul title="Multiplication with its backward rule"
class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        # TODO: return a new Value holding self.data * other.data, and set its
        # _backward so it adds other.data * out.grad to self.grad and self.data * out.grad to other.grad.
        ...

    __radd__ = __add__
    __rmul__ = __mul__
--- solution
class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data * other.data, (self, other))
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        return out

    __radd__ = __add__
    __rmul__ = __mul__
--- test
a = Value(2.0)
b = Value(-3.0)
out = a * b
assert out is not None, "Replace the `...` in `__mul__` so it returns a new Value."
assert isinstance(out, Value), "`__mul__` should return a Value."
assert out.data == -6.0, f"2 × -3 should be -6, but the output holds {out.data}."
out.grad = 1.0
out._backward()
assert a.grad == -3.0, f"The gradient for a should be b = -3, but it is {a.grad}. Use the other input's data times out.grad."
assert b.grad == 2.0, f"The gradient for b should be a = 2, but it is {b.grad}."
x = Value(5.0)
y = x * 3.0
assert y.data == 15.0, "Multiplying by a plain number should also work, through Value(3.0)."
--- hint
Create `out = Value(self.data * other.data, (self, other))`, then write a `_backward` function that adds to both inputs' gradients, as `__add__` does.
--- hint
Inside `_backward`, `self.grad += other.data * out.grad` and `other.grad += self.data * out.grad`, then set `out._backward = _backward` and return `out`.
```

## Challenge: walk the graph

Calling `_backward` on each node in the wrong order gives wrong answers. The correct procedure visits every node once, in reverse topological order, so that a node's gradient is complete before it passes that gradient on. Write `backward(self)` for the class below.

```python exercise id=value-backward title="Backpropagate through the whole graph"
class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data * other.data, (self, other))
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        return out

    def backward(self):
        # TODO: order the graph so every node comes after its parents (a depth-first
        # walk that records each node once), set self.grad = 1.0, then call _backward
        # on the nodes in reverse order.
        ...

    __radd__ = __add__
    __rmul__ = __mul__
--- solution
class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data * other.data, (self, other))
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        return out

    def backward(self):
        order, seen = [], set()
        def build(v):
            if v not in seen:
                seen.add(v)
                for p in v._parents:
                    build(p)
                order.append(v)
        build(self)
        self.grad = 1.0
        for v in reversed(order):
            v._backward()

    __radd__ = __add__
    __rmul__ = __mul__
--- test
a = Value(2.0)
b = Value(3.0)
c = a * b + a          # c = a·b + a, so dc/da = b + 1 = 4 and dc/db = a = 2
assert c is not None and c.data == 8.0, "Check that `__add__` and `__mul__` produce c = 8."
c.backward()
assert np.isclose(a.grad, 4.0), f"a is used on two paths, so its gradient should be b + 1 = 4, but it is {a.grad}. Accumulate with += across the whole graph."
assert np.isclose(b.grad, 2.0), f"The gradient for b should be a = 2, but it is {b.grad}."
x = Value(2.0)
y = x * x               # y = x², so dy/dx = 2x = 4
y.backward()
assert np.isclose(x.grad, 4.0), f"For y = x * x with x = 2, the gradient should be 4, but it is {x.grad}."
p = Value(-1.0)
q = (p * p + p) * p     # q = p³ + p², dq/dp = 3p² + 2p = 1 at p = -1
q.backward()
assert np.isclose(p.grad, 1.0), f"For q = p³ + p² at p = -1 the gradient should be 1, but it is {p.grad}."
--- hint
Make a list of every node in the graph, visiting each one once and visiting its parents before the node itself. A recursive helper with a `seen` set does this.
--- hint
After you build `order`, set `self.grad = 1.0`. Then loop over `reversed(order)` and call each node's `_backward()`.
```

## Debug the accumulation bug

Here is a minimal engine with a classic bug. The gradient is assigned instead of accumulated, so a value used twice loses one of its contributions.

```python debug id=assign-not-add title="Accumulate, don't overwrite"
class Value:
    def __init__(self, data):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = ()

    def __mul__(self, other):
        out = Value(self.data * other.data)
        def _backward():
            self.grad = other.data * out.grad      # bug: this overwrites the gradient
            other.grad = self.data * out.grad
        out._backward = _backward
        out._parents = (self, other)
        return out

    def backward(self):
        order, seen = [], set()
        def build(v):
            if v not in seen:
                seen.add(v)
                for p in v._parents:
                    build(p)
                order.append(v)
        build(self)
        self.grad = 1.0
        for v in reversed(order):
            v._backward()

a = Value(3.0)
y = a * a           # y = a², so dy/da = 2a = 6
y.backward()
print("dy/da =", a.grad, "(expected 6.0)")
--- solution
class Value:
    def __init__(self, data):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = ()

    def __mul__(self, other):
        out = Value(self.data * other.data)
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        out._parents = (self, other)
        return out

    def backward(self):
        order, seen = [], set()
        def build(v):
            if v not in seen:
                seen.add(v)
                for p in v._parents:
                    build(p)
                order.append(v)
        build(self)
        self.grad = 1.0
        for v in reversed(order):
            v._backward()

a = Value(3.0)
y = a * a           # y = a², so dy/da = 2a = 6
y.backward()
print("dy/da =", a.grad, "(expected 6.0)")
--- test
a = Value(3.0)
y = a * a
y.backward()
assert np.isclose(a.grad, 6.0), f"dy/da for y = a² at a = 3 is 6, but a.grad is {a.grad}. When a value is used twice, both contributions must add up."
b = Value(2.0)
z = b * Value(5.0)
z.backward()
assert np.isclose(b.grad, 5.0), f"The gradient for b in z = b × 5 should be 5, but it is {b.grad}."
--- hint
Both uses of `a` in `a * a` call `_backward`, and each one should add its share. Look at the two lines that assign to `grad`.
--- hint
Replace `=` with `+=` on both lines in `_backward`.
```

## Predict the accumulated gradient

```python predict id=predict-accumulate title="What does the gradient total?"
a = 3.0
grad = 0.0
grad += 2 * a      # first path through the graph
grad += 2 * a      # second path through the graph
print(grad)
--- options
* 12.0
6.0
4.0
18.0
--- explain
Each path adds 2 × 3 = 6, and the two paths together give 12. The same accumulation rule is what lets a value used many times collect its full gradient.
```

## Recap

- An autograd engine stores each value with its gradient and the rule that propagates it backwards.
- Backpropagation walks the graph in reverse topological order, so each node's gradient is complete before it is used.
- Gradients accumulate with `+=`. A value used on several paths needs the sum of all of them.
- Forgetting to zero gradients between training steps makes gradients accumulate across steps, which is a common and silent bug.

**Up next:** the same idea applied to whole layers at once. A dense layer's backward pass is three matrix products, and you will derive each one.
