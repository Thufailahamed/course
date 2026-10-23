A language model is a function that turns text into a probability distribution over the next token, and an application is everything you build around that function. Most of the engineering effort goes into that surrounding system: the prompt, the validation of its output, the documents it can see, the tests that tell you whether it still works, and the cost of each call.

This course covers those parts in order. Every lesson runs in the page with plain Python, so you can change a number and see its effect. Calls to hosted models are shown as static code, because they need a key and a network connection. Everything around them can be tested here.

> **How to use this lesson:** run the grey boxes, change a value and read the output. Challenges check your code against tests.

## A first piece of arithmetic

Models price their work by tokens. A rough estimate of tokens from words is useful for budgeting before you call anything.

```python run
import math

def approx_tokens(text):
    return math.ceil(len(text.split()) * 1.3)

prompt = "Summarize the following support ticket in two sentences."
print("approximate tokens:", approx_tokens(prompt))
```

## Predict the count

```python predict id=predict-words title="How many approximate tokens does 'one two three four' give?"
import math
print(math.ceil(4 * 1.3))
--- options
* 6
4
5
8
--- explain
Four words at about 1.3 tokens per word is 5.2, which rounds up to 6.
```

## Recap

- An application is the system around the model, and most failures live there.
- Tokens are the unit of cost and of context, so budget with them.
- Each lesson's ideas can be tested without calling a model.

**Up next:** how the model turns scores into a choice, and how temperature and top-p control that choice.
