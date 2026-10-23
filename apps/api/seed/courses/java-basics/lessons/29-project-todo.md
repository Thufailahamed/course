A to-do list is a small but realistic program: it stores items, changes their state, removes them, and reports what is left. You will build it with `ArrayList`, classes and methods.

## Step 1: a list of strings

```java run class
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        ArrayList<String> tasks = new ArrayList<>();
        tasks.add("Buy milk");
        tasks.add("Write report");
        tasks.add("Call Ada");

        tasks.remove("Write report");
        System.out.println(tasks);
        System.out.println(tasks.size());
    }
}
```

`remove("Write report")` removes by value. Removing by index would be `remove(1)`. The two overloads are easy to mix up, so choose deliberately.

## Step 2: a Task class

```java run class
class Task {
    String title;
    boolean done;

    Task(String title) {
        this.title = title;
        this.done = false;
    }

    void complete() {
        done = true;
    }

    public String toString() {
        return (done ? "[x] " : "[ ] ") + title;
    }
}

public class Main {
    public static void main(String[] args) {
        Task task = new Task("Buy milk");
        System.out.println(task);
        task.complete();
        System.out.println(task);
    }
}
```

The boolean `done` is part of the task's state. `toString` gives a compact display, and the ternary chooses the checkbox.

## Step 3: a TodoList class

```java run class
import java.util.ArrayList;

class Task {
    String title;
    boolean done;
    Task(String title) { this.title = title; }
    void complete() { done = true; }
    public String toString() { return (done ? "[x] " : "[ ] ") + title; }
}

class TodoList {
    private ArrayList<Task> tasks = new ArrayList<>();

    void add(String title) {
        tasks.add(new Task(title));
    }

    void complete(int index) {
        if (index >= 0 && index < tasks.size()) {
            tasks.get(index).complete();
        }
    }

    int remaining() {
        int count = 0;
        for (Task task : tasks) {
            if (!task.done) count++;
        }
        return count;
    }

    void print() {
        for (int i = 0; i < tasks.size(); i++) {
            System.out.println(i + ": " + tasks.get(i));
        }
    }
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.add("Buy milk");
        list.add("Write report");
        list.complete(0);
        list.print();
        System.out.println("Remaining: " + list.remaining());
    }
}
```

`complete` checks the index before touching the list. The `remaining` method counts only unfinished tasks. `print` shows the index so the user knows what to pass to `complete`.

## Step 4: a complete small app

```java run class
import java.util.ArrayList;

class Task {
    String title;
    boolean done;
    Task(String title) { this.title = title; }
    void complete() { done = true; }
    public String toString() { return (done ? "[x] " : "[ ] ") + title; }
}

class TodoList {
    private ArrayList<Task> tasks = new ArrayList<>();

    void add(String title) {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Title cannot be empty");
        }
        tasks.add(new Task(title.trim()));
    }

    void complete(int index) {
        if (index < 0 || index >= tasks.size()) {
            throw new IndexOutOfBoundsException("No task at " + index);
        }
        tasks.get(index).complete();
    }

    void removeCompleted() {
        for (int i = tasks.size() - 1; i >= 0; i--) {
            if (tasks.get(i).done) {
                tasks.remove(i);
            }
        }
    }

    int remaining() {
        int count = 0;
        for (Task task : tasks) if (!task.done) count++;
        return count;
    }

    void print() {
        for (int i = 0; i < tasks.size(); i++) {
            System.out.println(i + ": " + tasks.get(i));
        }
    }
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.add("Buy milk");
        list.add("Write report");
        list.add("Call Ada");
        list.complete(1);
        list.removeCompleted();
        list.print();
        System.out.println("Remaining: " + list.remaining());
    }
}
```

`removeCompleted` walks **backwards**. Removing from an `ArrayList` shifts later elements left, so a forward loop would skip the item after each removal. Walking backwards keeps the indexes valid.

```java predict class id=todo-predict title="What is printed?"
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        ArrayList<String> tasks = new ArrayList<>();
        tasks.add("a");
        tasks.add("b");
        tasks.add("c");
        tasks.remove(0);
        System.out.println(tasks.get(0));
    }
}
--- options
* b
a
c
IndexOutOfBoundsException
--- explain
Removing index 0 removes `"a"` and shifts the rest left. The list is `[b, c]`, so index 0 is `"b"`.
```

## Challenges

```java exercise class id=add-task title="Add tasks to the list"
import java.util.ArrayList;

class TodoList {
    ArrayList<String> tasks = new ArrayList<>();

    // Add a method add(String title) that appends the title.
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.add("Buy milk");
        System.out.println(list.tasks.size());
    }
}
--- solution
import java.util.ArrayList;

class TodoList {
    ArrayList<String> tasks = new ArrayList<>();

    void add(String title) {
        tasks.add(title);
    }
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.add("Buy milk");
        System.out.println(list.tasks.size());
    }
}
--- test
TodoList list = new TodoList();
list.add("Buy milk");
list.add("Write report");
__check(list.tasks.size() == 2, "Two tasks should be stored");
--- hint
The method takes a `String` and calls `tasks.add`.
--- hint
`void add(String title) { tasks.add(title); }`
```

```java exercise class id=complete-task title="Mark a task complete"
class Task {
    String title;
    boolean done;
    Task(String title) { this.title = title; }

    // Add complete().
}

public class Main {
    public static void main(String[] args) {
        Task task = new Task("Buy milk");
        task.complete();
        System.out.println(task.done);
    }
}
--- solution
class Task {
    String title;
    boolean done;
    Task(String title) { this.title = title; }

    void complete() {
        done = true;
    }
}

public class Main {
    public static void main(String[] args) {
        Task task = new Task("Buy milk");
        task.complete();
        System.out.println(task.done);
    }
}
--- test
Task task = new Task("Buy milk");
task.complete();
__check(task.done, "complete() should set done to true");
--- hint
`done` starts as `false` by default.
--- hint
`void complete() { done = true; }`
```

```java debug class id=fix-remaining-count title="The remaining count includes finished tasks"
import java.util.ArrayList;

class Task {
    boolean done;
    Task(boolean done) { this.done = done; }
}

class TodoList {
    ArrayList<Task> tasks = new ArrayList<>();

    int remaining() {
        return tasks.size();
    }
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.tasks.add(new Task(true));
        list.tasks.add(new Task(false));
        System.out.println(list.remaining());
    }
}
--- solution
import java.util.ArrayList;

class Task {
    boolean done;
    Task(boolean done) { this.done = done; }
}

class TodoList {
    ArrayList<Task> tasks = new ArrayList<>();

    int remaining() {
        int count = 0;
        for (Task task : tasks) {
            if (!task.done) count++;
        }
        return count;
    }
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.tasks.add(new Task(true));
        list.tasks.add(new Task(false));
        System.out.println(list.remaining());
    }
}
--- test
TodoList list = new TodoList();
list.tasks.add(new Task(true));
list.tasks.add(new Task(false));
list.tasks.add(new Task(false));
__check(list.remaining() == 2, "Only the two unfinished tasks should count");
--- hint
`size()` counts every task, finished or not.
--- hint
Loop through the tasks and count only those with `!task.done`.
```
