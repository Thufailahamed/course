A model is an artifact that depends on code, data and a configuration, and it is only as good as the process that produces and watches it. MLOps is the set of practices that make that process repeatable. You can reproduce a result, you know which data it came from, the features at serving time match training, the service meets its latency target, and someone is alerted when the world drifts away from the training data.

Every lesson here runs in the page with plain Python and NumPy. Docker files, orchestrators and cloud services are shown as static configuration, because they need infrastructure you own. The logic that decides whether a deployment is safe runs here, and you can test it.

> **How to use this lesson:** run the grey boxes, read the output, and change a value to see what moves. The challenges check your code against tests.

## A small measurement

Teams track the share of prototypes that reach production. Turning counts into shares is the first arithmetic of any MLOps review.

```python run
prototypes = 120
in_staging = 36
in_production = 12
print(f"reached staging: {100 * in_staging / prototypes:.0f}%")
print(f"reached production: {100 * in_production / prototypes:.0f}%")
```

## Predict the share

```python predict id=predict-share title="What share of 120 prototypes is 30?"
print(100 * 30 / 120)
--- options
* 25.0
30.0
4.0
120.0
--- explain
Thirty out of 120 is one quarter, which is 25 percent.
```

## Recap

- MLOps makes model results repeatable, traceable and monitored.
- The lifecycle has stages, and most failures happen between them.
- Every mechanism in this course is testable, even when the infrastructure is not.

**Up next:** why models fail to ship, and how to measure a team's maturity.
