Dates show up everywhere: a subscription renews on the 1st, an invoice is due in 30 days, a log line needs a timestamp, a deadline is "the Friday before launch." Dates look simple until you write code that calculates with them. Months start at zero, a February 31st quietly becomes March, and the same instant prints as a different day depending on where the code runs. Most date bugs come from one of those three traps.

This page teaches you to create dates, read their parts, do arithmetic with days, and format them as text. It sticks to UTC, the same clock everywhere in the world, so your results are identical for every reader and every computer. That's the right default for data and for anything you store.

## A date is a moment in time

A `Date` object stores one instant as a count of milliseconds since 1 January 1970 at midnight UTC. Everything else is a way of looking at that number. You create one from a set of parts, and `Date.UTC` builds it without any time zone surprises:

```js run
const launch = new Date(Date.UTC(2026, 2, 15));

console.log(launch.toISOString());
console.log(launch.getTime());
```

`toISOString()` gives the standard text form, `2026-03-15T00:00:00.000Z`. The `Z` means UTC. `getTime()` gives the raw millisecond count, which is what you compare and subtract.

> **Pitfall:** Months are zero-based. January is `0`, March is `2`, and December is `11`. The day of the month, by contrast, starts at 1. `Date.UTC(2026, 3, 1)` is 1 May, not 1 April. This is the most common date bug in JavaScript, and you'll meet it again in the challenges.

## Reading the parts

Use the UTC getters to read a date's year, month, day and weekday. The weekday uses `0` for Sunday through `6` for Saturday:

```js run
const deadline = new Date("2026-05-10");

console.log(deadline.getUTCFullYear());
console.log(deadline.getUTCMonth());
console.log(deadline.getUTCDate());
console.log(deadline.getUTCDay());
```

A string in the form `YYYY-MM-DD` is read as UTC midnight, so it gives the same answer everywhere. That's why the ISO date format is the safest way to store a day that doesn't have a time attached.

> **Pitfall:** Methods without `UTC` in their name, such as `getDate()` and `getHours()`, use the time zone of the computer running the code. A date-only string is UTC, but a string with a time and no `Z`, like `"2026-05-10T09:00"`, is read in local time. Use UTC methods and `Z` strings for anything you store or compare, and keep local formatting for the display layer of an app.

Here's a practical use of the weekday number. The lookup table turns the number into a name:

```js run
const names = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
const meeting = new Date("2026-05-10");

console.log(names[meeting.getUTCDay()]);
```

## Adding and subtracting days

A date supports arithmetic through its milliseconds. One day is `24 * 60 * 60 * 1000`, which is `86400000` milliseconds. Add days by adding that many milliseconds per day:

```js run
const start = Date.UTC(2026, 0, 1);
const dayMs = 24 * 60 * 60 * 1000;

const thirtyDaysLater = new Date(start + 30 * dayMs);
console.log(thirtyDaysLater.toISOString().slice(0, 10));
```

Because each day is a fixed number of milliseconds in UTC, the calculation never drifts. This is also how you find the number of days between two dates: subtract the two times and divide by a day.

Now the first challenge. Write a function that takes a date as `"YYYY-MM-DD"` text and returns the date `n` days later in the same format. Work in UTC throughout:

```js exercise id=add-days title="Add days to a date"
function addDays(isoDate, days) {
  // TODO: return the date that is `days` after isoDate, formatted as "YYYY-MM-DD"
  return null;
}
--- solution
function addDays(isoDate, days) {
  const start = Date.parse(isoDate + "T00:00:00Z");
  const result = new Date(start + days * 24 * 60 * 60 * 1000);
  return result.toISOString().slice(0, 10);
}
--- test
assertEqual(addDays("2026-02-27", 2), "2026-03-01", "2026 is not a leap year, so two days after 27 February is 1 March");
assertEqual(addDays("2024-02-28", 1), "2024-02-29", "2024 is a leap year, so 29 February exists");
assertEqual(addDays("2026-12-31", 1), "2027-01-01", "Adding a day should cross into the next year");
assertEqual(addDays("2026-06-10", 0), "2026-06-10", "Adding zero days should give the same date");
--- hint
Convert the text to a time with `Date.parse`, adding `"T00:00:00Z"` so it's read as UTC. Then add `days` worth of milliseconds.
--- hint
Multiply `days` by `24 * 60 * 60 * 1000`. Finish with `toISOString()` and `slice(0, 10)` to keep only the date part.
```

## Differences between dates

To count the days from one date to another, subtract their times and divide by one day. Because you're working in UTC, the answer is exact:

```js run
const a = Date.parse("2026-01-01");
const b = Date.parse("2026-03-01");

console.log((b - a) / (24 * 60 * 60 * 1000));
```

Your next challenge is a function that does this for you. The result should be negative when the second date comes first:

```js exercise id=days-between title="Count the days between two dates"
function daysBetween(fromDate, toDate) {
  // TODO: return how many whole days lie from fromDate to toDate (negative if toDate is earlier)
  return null;
}
--- solution
function daysBetween(fromDate, toDate) {
  const ms = Date.parse(toDate + "T00:00:00Z") - Date.parse(fromDate + "T00:00:00Z");
  return Math.round(ms / (24 * 60 * 60 * 1000));
}
--- test
assertEqual(daysBetween("2026-01-01", "2026-01-31"), 30, "January has 30 days after the 1st");
assertEqual(daysBetween("2026-01-31", "2026-01-01"), -30, "Going backwards should give a negative number");
assertEqual(daysBetween("2024-02-28", "2024-03-01"), 2, "2024 has a 29 February, so this is two days");
assertEqual(daysBetween("2026-05-10", "2026-05-10"), 0, "The same date is zero days apart");
--- hint
Subtract the first date's time from the second's. Both need `Date.parse` with `"T00:00:00Z"` so they're in UTC.
--- hint
Divide the difference in milliseconds by `24 * 60 * 60 * 1000`. Wrap the result in `Math.round` so that any tiny rounding error disappears.
```

## Months: the rollover trap

JavaScript never complains about an impossible date. It rolls the extra days forward into the next month. Requesting 31 February gives you the first days of March, which is almost always a bug you need to catch:

```js predict id=feb-rollover title="What date does this print?"
console.log(new Date(Date.UTC(2026, 1, 31)).toISOString().slice(0, 10));
--- options
2026-02-28
2026-02-31
* 2026-03-03
2026-03-31
--- explain
Month `1` is February, which has 28 days in 2026. Day 31 is three days past the end of February, so the date rolls forward to 3 March. `Date.UTC` never throws here; it silently gives a valid date. Validate month and day yourself when the input comes from a user.
```

Now the bug. This function should return the first day of a month as `"YYYY-MM-DD"`. It takes the month as a normal, one-based number, like `3` for March, but it passes that number straight to `Date.UTC`:

```js debug id=first-of-month title="Fix the month that's off by one"
function firstOfMonth(year, month) {
  const date = new Date(Date.UTC(year, month, 1));
  return date.toISOString().slice(0, 10);
}
--- solution
function firstOfMonth(year, month) {
  const date = new Date(Date.UTC(year, month - 1, 1));
  return date.toISOString().slice(0, 10);
}
--- test
assertEqual(firstOfMonth(2026, 3), "2026-03-01", "March is month 3 for the caller, so it should give 2026-03-01");
assertEqual(firstOfMonth(2026, 1), "2026-01-01", "January is month 1 for the caller");
assertEqual(firstOfMonth(2024, 12), "2024-12-01", "December is month 12 for the caller");
--- hint
The caller counts months from 1, but `Date.UTC` counts from 0. Which way do you need to shift the number?
--- hint
Subtract 1 from `month` inside `Date.UTC`, so that March (3) becomes index 2.
```

> **Under the hood:** `toISOString()` always returns UTC, so the output is the same on every machine. Local-time methods such as `toLocaleDateString()` depend on the computer's settings and language, which is why this course never prints them. For text your users read, use `Intl.DateTimeFormat` with an explicit time zone.

> **In the wild:** Date handling is where many production bugs hide. Payment systems, calendars and scheduling tools almost always store timestamps in UTC and convert to the viewer's zone only for display. Libraries such as `date-fns` and `Temporal` exist to make that split explicit.

## Recap

- `Date.UTC(year, monthIndex, day)` builds a date in UTC. Months are zero-based, so March is `2`.
- Use UTC getters like `getUTCDay()` and `getUTCMonth()`. Local getters depend on the computer's time zone.
- A `"YYYY-MM-DD"` string is read as UTC, and `toISOString().slice(0, 10)` turns a date back into that text.
- Add and subtract days by working in milliseconds, using `24 * 60 * 60 * 1000` per day.
- JavaScript rolls impossible dates forward, so 31 February becomes 3 March. Validate dates that come from users.

**Up next:** Project: a grade report. You'll combine functions, arrays, objects and loops to turn raw scores into a summary.
