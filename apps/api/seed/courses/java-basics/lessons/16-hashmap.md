A `HashMap` stores **keys** and **values**. You give it a key and it gives back the associated value, usually in constant time. It is the natural structure for lookups: a name to a phone number, a word to its count, a product code to a price.

## Putting and getting

```java run
HashMap<String, Integer> ages = new HashMap<>();

ages.put("Ada", 36);
ages.put("Grace", 45);

System.out.println(ages.get("Ada"));
System.out.println(ages.size());
System.out.println(ages);
```

`HashMap<String, Integer>` maps strings to integers. `put` adds a pair or replaces the value for an existing key. `get` returns the value, or `null` if the key is absent.

## Missing keys

```java run
HashMap<String, Integer> stock = new HashMap<>();
stock.put("apple", 3);

System.out.println(stock.get("pear"));
System.out.println(stock.getOrDefault("pear", 0));
System.out.println(stock.containsKey("apple"));
```

`get` on a missing key returns `null`, which can cause a `NullPointerException` if you immediately do arithmetic with it. `getOrDefault` supplies a fallback and is usually the safer choice.

## Updating counts

```java run
String[] words = {"java", "code", "java", "test", "java"};
HashMap<String, Integer> counts = new HashMap<>();

for (String word : words) {
    counts.put(word, counts.getOrDefault(word, 0) + 1);
}

System.out.println(counts.get("java"));
System.out.println(counts.get("code"));
```

The `getOrDefault(word, 0) + 1` pattern reads the old count (or zero), adds one, and stores it back. This is the standard frequency-counting idiom.

## Removing and iterating

```java run
HashMap<String, Integer> scores = new HashMap<>();
scores.put("Ada", 95);
scores.put("Grace", 88);
scores.put("Alan", 91);

scores.remove("Grace");
System.out.println(scores.containsKey("Grace"));

for (String name : scores.keySet()) {
    System.out.println(name + " -> " + scores.get(name));
}

for (HashMap.Entry<String, Integer> entry : scores.entrySet()) {
    System.out.println(entry.getKey() + ": " + entry.getValue());
}
```

`keySet()` gives the keys, `values()` gives the values, and `entrySet()` gives key-value pairs. A `HashMap` does **not** promise iteration order; if you need sorted keys, use a `TreeMap`.

```java predict id=hashmap-predict title="What is printed?"
HashMap<String, Integer> map = new HashMap<>();
map.put("a", 1);
System.out.println(map.get("b"));
--- options
* null
0
1
b
--- explain
There is no entry for `"b"`, so `get` returns `null`. Use `getOrDefault("b", 0)` if you want a number.
```

## Challenges

```java exercise id=word-frequency title="Count occurrences of a word"
String[] words = {"java", "code", "java", "test", "java"};
HashMap<String, Integer> counts = new HashMap<>();

// Count how many times each word appears.
--- solution
String[] words = {"java", "code", "java", "test", "java"};
HashMap<String, Integer> counts = new HashMap<>();

for (String word : words) {
    counts.put(word, counts.getOrDefault(word, 0) + 1);
}
--- test
__check(counts.get("java") == 3 && counts.get("code") == 1, "java appears three times and code once");
--- hint
Loop over the words and update the count for each one.
--- hint
`counts.put(word, counts.getOrDefault(word, 0) + 1);`
```

```java exercise id=price-lookup title="Store and look up a price"
HashMap<String, Double> prices = new HashMap<>();

// Add apple -> 1.5 and bread -> 3.0, then read the apple price.
double applePrice = 0;
--- solution
HashMap<String, Double> prices = new HashMap<>();
prices.put("apple", 1.5);
prices.put("bread", 3.0);
double applePrice = prices.get("apple");
--- test
__check(Math.abs(applePrice - 1.5) < 0.0001, "An apple costs 1.5");
--- hint
Use `put` for each pair, then `get("apple")`.
--- hint
`double applePrice = prices.get("apple");`
```

```java debug id=fix-missing-key title="The missing key crashes the count"
String word = "pear";
HashMap<String, Integer> counts = new HashMap<>();
counts.put("apple", 2);

counts.put(word, counts.get(word) + 1);
System.out.println(counts.get(word));
--- solution
String word = "pear";
HashMap<String, Integer> counts = new HashMap<>();
counts.put("apple", 2);

counts.put(word, counts.getOrDefault(word, 0) + 1);
System.out.println(counts.get(word));
--- test
__check(__out().trim().equals("1"), "The first pear should count as 1");
--- hint
`counts.get("pear")` is `null`, and `null + 1` throws.
--- hint
Replace `get(word)` with `getOrDefault(word, 0)`.
```
