Files let a program keep data after it stops. Java's `java.nio.file` package provides `Path` for locations and `Files` for operations. The browser runtime gives Java a small virtual filesystem, so the same code works here and on a desktop.

## Writing and reading

```java run
Path path = Paths.get("notes.txt");
List<String> lines = Arrays.asList("first line", "second line", "third line");

Files.write(path, lines);
System.out.println(Files.readAllLines(path));
```

`Paths.get` creates a path object; it does not touch the disk. `Files.write` creates or replaces the file and writes each list element as a line. `Files.readAllLines` returns a `List<String>`.

## Appending

```java run
Path path = Paths.get("log.txt");

Files.write(path, Arrays.asList("started"), StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
Files.write(path, Arrays.asList("finished"), StandardOpenOption.APPEND);

System.out.println(Files.readAllLines(path));
```

The first call creates a fresh file. The second opens it in append mode, so `finished` is added after `started`. Without `CREATE`, writing to a path that does not exist throws `NoSuchFileException`.

## Inspecting a file

```java run
Path path = Paths.get("report.txt");
Files.write(path, Arrays.asList("alpha", "beta"));

System.out.println(Files.exists(path));
System.out.println(Files.size(path));
System.out.println(Files.readAllLines(path).size());
```

`exists` returns a boolean, `size` returns the number of bytes, and the size of the returned list tells you how many lines were read. File sizes depend on encoding and line endings, so do not assume one character equals one byte.

## Handling missing files

```java run
Path path = Paths.get("does-not-exist.txt");

try {
    System.out.println(Files.readAllLines(path));
} catch (IOException e) {
    System.out.println("Could not read the file: " + e.getClass().getSimpleName());
}
```

`readAllLines` declares a checked `IOException`, so the compiler requires you to catch it or declare it. A checked exception is part of the method's contract; the compiler makes sure callers acknowledge it.

```java predict id=files-predict title="What is printed?"
Path path = Paths.get("missing-file.txt");
System.out.println(Files.exists(path));
--- options
* false
true
null
IOException
--- explain
`exists` checks the filesystem and returns `false` when the path is absent. It does not throw for a missing file.
```

## Challenges

```java exercise id=write-and-read title="Write a file and read it back"
Path path = Paths.get("challenge.txt");
String result = "";

// Write "one" and "two" as two lines, then join the lines with "|".
--- solution
Path path = Paths.get("challenge.txt");
Files.write(path, Arrays.asList("one", "two"));
String result = String.join("|", Files.readAllLines(path));
--- test
__check(result.equals("one|two"), "The file should contain one and two");
--- hint
Use `Files.write` with `Arrays.asList(...)`.
--- hint
`String.join("|", Files.readAllLines(path))`
```

```java exercise id=count-file-lines title="Count the lines in a file"
Path path = Paths.get("count.txt");
int count = 0;

// Write three lines, then count them by reading the file.
--- solution
Path path = Paths.get("count.txt");
Files.write(path, Arrays.asList("alpha", "beta", "gamma"));
int count = Files.readAllLines(path).size();
--- test
__check(count == 3, "The file should have three lines");
--- hint
`Files.readAllLines` returns a list whose `size()` is the line count.
--- hint
Write three strings first.
```

```java debug id=fix-missing-create title="Appending to a new file fails"
Path path = Paths.get("new-log.txt");
Files.write(path, Arrays.asList("first"), StandardOpenOption.APPEND);
System.out.println(Files.exists(path));
--- solution
Path path = Paths.get("new-log.txt");
Files.write(path, Arrays.asList("first"), StandardOpenOption.CREATE, StandardOpenOption.APPEND);
System.out.println(Files.exists(path));
--- test
__check(__out().trim().equals("true"), "The file should exist after writing");
--- hint
Append mode does not create a missing file by itself.
--- hint
Add `StandardOpenOption.CREATE` to the options.
```
