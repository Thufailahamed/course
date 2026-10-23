Every app that tracks work has a list at its heart: a to-do list, a cart, an inbox, a queue of jobs. In this project you'll build a **to-do manager**. It stores tasks as objects, adds new ones, marks them done, removes them, and runs a batch of commands to produce a final list, the way a real app would replay a user's actions.

The project has five stages, and each stage is a function with a challenge. Every stage builds on the one before it, so the starter code for each later stage includes the functions you wrote earlier. As in the grades project, you're using only what you've learned so far, but this project adds one important habit: **don't change data in place**. Each function will return a new list, and the old list will stay exactly as it was.

## Why new lists, not changed lists

Here is the idea in a few lines. Suppose the app keeps the current list, and the user undoes a change. If your code edited the list in place, the undo would have nothing to go back to:

```js run
const before = [1, 2];
const after = [...before, 3];

console.log(before, after);
```

`after` is a new array with the extra item, and `before` is untouched. That's the approach every stage in this project takes. A function that never mutates its input is easy to test, easy to undo, and safe to call from anywhere.

## Stage 1: create a task

A task is an object with an `id`, a `title`, and a `done` flag. The id lets you refer to a task later, even after the list has changed:

```js run
const demo = { id: 1, title: "Buy milk", done: false };

console.log(demo.id, demo.title, demo.done);
```

Your first function builds that object for you, so every task starts with the same shape:

```js exercise id=create-task title="Stage 1: create a task"
function createTask(id, title) {
  // TODO: return { id, title, done } with done set to false
  return null;
}
--- solution
function createTask(id, title) {
  return { id: id, title: title, done: false };
}
--- test
assertEqual(createTask(3, "Pay rent"), { id: 3, title: "Pay rent", done: false }, "A new task is not done yet");
assertEqual(createTask(1, "Walk dog").done, false, "done should start as false");
assertEqual(createTask(2, "Read").title, "Read", "The title should be stored as given");
--- hint
Return an object literal with three properties. `id` and `title` come from the parameters.
--- hint
Set `done: false` directly in the object. New tasks always start out unfinished.
```

## Stage 2: add a task without changing the list

Next, adding a task. The natural first draft pushes the new task onto the list and returns it. That works, but it changes the caller's list too. Here is that draft. It's your debug challenge:

Fix it so `addTask` returns a new list with the task at the end, and leaves the list it was given unchanged. The starter includes `createTask` from stage 1.

```js debug id=add-task title="Stage 2: add without mutating"
function createTask(id, title) {
  return { id: id, title: title, done: false };
}

function addTask(tasks, task) {
  tasks.push(task);
  return tasks;
}
--- solution
function createTask(id, title) {
  return { id: id, title: title, done: false };
}

function addTask(tasks, task) {
  return [...tasks, task];
}
--- test
const first = createTask(1, "Buy milk");
const second = createTask(2, "Walk dog");
const list = addTask([first], second);
assertEqual(list.length, 2, "The new list should have both tasks");
assertEqual(list[1].title, "Walk dog", "The new task should be added at the end");
const original = [first];
addTask(original, second);
assertEqual(original.length, 1, "addTask must not change the array it was given");
assertEqual(addTask([], first), [first], "Adding to an empty list should give a one-item list");
--- hint
`push` changes the array it's called on. Look at the array the caller passed in, and what happens to it.
--- hint
Return a new array that contains every item from `tasks` followed by `task`. The spread syntax `[...tasks, task]` does exactly that.
```

> **Pitfall:** `push` returns the new length, not the array, and it always changes the array in place. Methods such as `push`, `pop`, `splice` and `sort` change the array they're called on. `map`, `filter`, `slice` and spread all return new arrays. When a list is shared with the rest of your program, reach for the second group.

## Stage 3: toggle a task

Marking a task done or not done changes one item in the list. The clean way is to use `map`: keep every task as it is, except the one with the matching id, which becomes a copy with its `done` flag flipped:

```js run
const flags = [false, true];

console.log(flags.map((f) => !f));
console.log(flags);
```

Now the stage. `toggleTask` returns a new list in which the task with the given id has `done` reversed. Other tasks stay as they are:

```js exercise id=toggle-task title="Stage 3: toggle a task"
function createTask(id, title) {
  return { id: id, title: title, done: false };
}

function toggleTask(tasks, id) {
  // TODO: return a new array. The task with this id gets done flipped (true becomes false and back).
  // Every other task stays the same. Don't change the tasks you were given.
  return null;
}
--- solution
function createTask(id, title) {
  return { id: id, title: title, done: false };
}

function toggleTask(tasks, id) {
  return tasks.map((t) => (t.id === id ? { ...t, done: !t.done } : t));
}
--- test
const tasks = [createTask(1, "Buy milk"), createTask(2, "Walk dog")];
const toggled = toggleTask(tasks, 2);
assertEqual(toggled.map((t) => t.done), [false, true], "Only task 2 should be marked done");
assertEqual(tasks[1].done, false, "The original task must not be changed");
assertEqual(toggleTask(toggled, 2)[1].done, false, "Toggling the same task twice should undo it");
assertEqual(toggleTask(tasks, 99).map((t) => t.done), [false, false], "An unknown id should change nothing");
--- hint
Use `tasks.map(...)`. For the matching task, return a copy with one property changed. Spread can copy the object: `{ ...t, done: !t.done }`.
--- hint
For every other task, return `t` itself. Put the condition `t.id === id` in a ternary: `t.id === id ? ... : t`.
```

> **Tip:** Unchanged tasks are the same objects in the old and new lists. That's fine, because nothing edits a task in place. The rule that makes the program safe is that every change creates a new object, and never modifies an existing one.

## Stage 4: remove a task

Removing a task is the opposite of keeping one. `filter` keeps the tasks you want and leaves out the rest, so it's a natural fit:

```js run
const ids = [1, 2, 3];
const withoutTwo = ids.filter((id) => id !== 2);

console.log(withoutTwo, ids);
```

Next, `removeTask`. It returns a new list without the task that has the given id. A task id that doesn't exist should leave the list with the same tasks:

```js exercise id=remove-task title="Stage 4: remove a task"
function createTask(id, title) {
  return { id: id, title: title, done: false };
}

function removeTask(tasks, id) {
  // TODO: return a new array without the task whose id matches
  return null;
}
--- solution
function createTask(id, title) {
  return { id: id, title: title, done: false };
}

function removeTask(tasks, id) {
  return tasks.filter((t) => t.id !== id);
}
--- test
const tasks = [createTask(1, "Buy milk"), createTask(2, "Walk dog"), createTask(3, "Read")];
const remaining = removeTask(tasks, 2);
assertEqual(remaining.map((t) => t.id), [1, 3], "Task 2 should be removed and the others kept in order");
assertEqual(tasks.length, 3, "The original list must still have all three tasks");
assertEqual(removeTask(tasks, 42).length, 3, "Removing an unknown id should keep every task");
assertEqual(removeTask([], 1), [], "Removing from an empty list should give an empty list");
--- hint
`filter` keeps the items for which the callback returns `true`. You want every task whose id is not the one you're removing.
--- hint
Return `tasks.filter((t) => t.id !== id)`. This returns a brand-new array and leaves `tasks` alone.
```

## Stage 5: run a batch of commands

The final stage is a replay engine. Real apps often record what a user did as a list of commands, then rebuild the current state by applying them in order. Each command is an object with a `type` and the information it needs:

```js run
const commands = [
  { type: "add", title: "Buy milk" },
  { type: "toggle", id: 1 },
  { type: "remove", id: 1 },
];

for (const command of commands) {
  console.log(command.type);
}
```

Your last function, `runCommands`, starts from an empty list and applies each command in order. An `add` command creates a task with the next id, starting at `1` and increasing by one for every add. The final result is a list of text lines, one per task, that shows `[x]` for done and `[ ]` for not done. The starter includes the four functions you wrote, and your job is the last one:

```js exercise id=run-commands title="Stage 5: replay the commands"
function createTask(id, title) {
  return { id: id, title: title, done: false };
}

function addTask(tasks, task) {
  return [...tasks, task];
}

function toggleTask(tasks, id) {
  return tasks.map((t) => (t.id === id ? { ...t, done: !t.done } : t));
}

function removeTask(tasks, id) {
  return tasks.filter((t) => t.id !== id);
}

function runCommands(commands) {
  // TODO: start with an empty list and apply each command in order.
  // "add" takes a title and gives the task the next id (1, then 2, ...).
  // "toggle" and "remove" take an id.
  // Return one line per task: "[x] Title" if done, "[ ] Title" if not.
  return null;
}
--- solution
function createTask(id, title) {
  return { id: id, title: title, done: false };
}

function addTask(tasks, task) {
  return [...tasks, task];
}

function toggleTask(tasks, id) {
  return tasks.map((t) => (t.id === id ? { ...t, done: !t.done } : t));
}

function removeTask(tasks, id) {
  return tasks.filter((t) => t.id !== id);
}

function runCommands(commands) {
  let tasks = [];
  let nextId = 1;
  for (const command of commands) {
    if (command.type === "add") {
      tasks = addTask(tasks, createTask(nextId, command.title));
      nextId = nextId + 1;
    } else if (command.type === "toggle") {
      tasks = toggleTask(tasks, command.id);
    } else if (command.type === "remove") {
      tasks = removeTask(tasks, command.id);
    }
  }
  return tasks.map((t) => `${t.done ? "[x]" : "[ ]"} ${t.title}`);
}
--- test
const sample = [
  { type: "add", title: "Buy milk" },
  { type: "add", title: "Walk dog" },
  { type: "toggle", id: 1 },
  { type: "remove", id: 2 },
  { type: "add", title: "Call mum" },
];
assertEqual(runCommands(sample), ["[x] Buy milk", "[ ] Call mum"], "Milk should be done, the dog task removed, and the new task should get id 3");
assertEqual(runCommands([]), [], "No commands should give an empty list");
assertEqual(runCommands([{ type: "add", title: "Solo" }]), ["[ ] Solo"], "One add should give one pending line");
--- hint
Keep two variables: `tasks`, which starts as `[]`, and `nextId`, which starts at `1`. In the loop, check `command.type` with an `if` for each of the three kinds.
--- hint
For `add`, call `createTask(nextId, command.title)`, pass the result to `addTask`, and then increase `nextId`. Finish with `tasks.map(...)` to build the lines.
```

Before you move on, predict what this filter call does to the original list:

```js predict id=filter-keeps-original title="What does this print?"
const tasks = [1, 2, 3];
const kept = tasks.filter((n) => n > 1);
console.log(tasks.length, kept.length);
--- options
2 2
* 3 2
2 3
3 3
--- explain
`filter` returns a new array with only the items that pass the test. It never changes `tasks`, so `tasks.length` is still `3`. Two numbers, `2` and `3`, pass the test, so `kept.length` is `2`. Like the other stages here, the original is unchanged.
```

> **Under the hood:** The spread syntax copies an array or object one level deep, and `map` and `filter` build new arrays. That's why these functions are cheap to write but still share unchanged items with the old list. The data is safe as long as nobody edits an object in place.

> **In the wild:** Redux, the state library used in many React apps, is built on this rule: reducers take the current state and return a new one, and they never mutate it. A replay of actions works for the same reason your `runCommands` does, and it's what makes "undo" and time-travel debugging possible.

## Running the whole manager

Once every stage passes, the five functions form a complete program. Replay a sample list of commands in a fresh cell that contains your functions, and print each line with a `for...of` loop. Then check that running the same commands twice gives the same result, which is the payoff of never changing data in place.

## Recap

- Store each task as an object with an `id`, a `title` and a `done` flag.
- `push`, `pop`, `splice` and `sort` change an array in place. `map`, `filter`, `slice` and spread return new arrays.
- To update one item in a list, use `map` and return a copy of the object you changed.
- To remove an item, use `filter` and keep everything else.
- A program that replays commands on a fresh list is easy to test, and easy to undo, because it never modifies earlier state.

**Up next:** Project: a budget tracker. You'll write your own classes and save the data as JSON, then load it back.
