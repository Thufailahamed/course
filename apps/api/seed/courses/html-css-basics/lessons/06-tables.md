A train timetable, an invoice, a league table, a recipe conversion chart: they all share a shape. Every value means something only in relation to a row heading and a column heading. HTML has a dedicated element for exactly that relationship, and it is not a grid of boxes you style until it looks right. A real table tells the browser — and a screen reader — which cell is a header, which cells belong to it, and what the whole thing is about.

That structure is also what keeps a table readable when the data gets wider than the page. In this lesson you will build tables that survive long content, merged cells and small screens, and you will learn why the quickest-looking layout trick is the one that causes the most damage.

## A table is a relationship, not a layout

Use a table when the data has two axes: rows and columns that both carry meaning. A market schedule qualifies. A row of three feature cards does not. The difference is not visual — it is whether a cell's meaning depends on its row and column headings.

```html run
<h1>Saturday at the market</h1>
<p>Three stalls, three jobs, one very early start.</p>

<table>
  <tr>
    <th scope="col">Stall</th>
    <th scope="col">Opens</th>
    <th scope="col">Closes</th>
  </tr>
  <tr>
    <th scope="row">Bread</th>
    <td>7:00</td>
    <td>13:00</td>
  </tr>
  <tr>
    <th scope="row">Flowers</th>
    <td>8:00</td>
    <td>12:30</td>
  </tr>
  <tr>
    <th scope="row">Coffee</th>
    <td>6:30</td>
    <td>14:00</td>
  </tr>
</table>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  table { border-collapse: collapse; }
  th, td { padding: 0.5rem 1rem; border-bottom: 1px solid #cbd5e1; text-align: left; }
  tr:first-child th { background: #f1f5f9; }
</style>
```

Every data cell here is meaningful because of two headers: the column tells you whether `7:00` is an opening or closing time, and the row tells you which stall it belongs to. That is the test. If the data becomes ambiguous without its headings, a table is probably right.

> **Pitfall:** Before CSS Grid existed, developers built entire page layouts with tables. The result looked fine and behaved badly: screen readers announced navigation as tabular data, responsive layouts became impossible, and one extra cell could shift the whole page. Never use a table to position things. Use it to describe data.

## The anatomy of a table

A table is built from rows. Inside each row, `th` marks a header cell and `td` marks a data cell. Around those rows, three optional groups add meaning: `thead` for the header row, `tbody` for the main data, and `tfoot` for totals or closing notes. A `caption` names the table and travels with it.

```html run
<table>
  <caption>Intro to screen printing — Saturday, 14 June</caption>
  <thead>
    <tr>
      <th scope="col">Time</th>
      <th scope="col">Session</th>
      <th scope="col">Room</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">09:30</th>
      <td>Paper, ink and a very sharp squeegee</td>
      <td>Studio A</td>
    </tr>
    <tr>
      <th scope="row">11:00</th>
      <td>Preparing a screen</td>
      <td>Studio B</td>
    </tr>
    <tr>
      <th scope="row">13:30</th>
      <td>Printing your first layer</td>
      <td>Studio A</td>
    </tr>
  </tbody>
  <tfoot>
    <tr><th scope="row">Finish</th><td colspan="2">Bring your prints home — wear clothes you can ruin</td></tr>
  </tfoot>
</table>
<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  table { border-collapse: collapse; width: 100%; max-width: 40rem; }
  caption { padding: 0 0 1rem; text-align: left; font-weight: 700; font-size: 1.1rem; }
  th, td { padding: 0.75rem 1rem; border-bottom: 1px solid #e2e8f0; text-align: left; vertical-align: top; }
  thead th { background: #0f172a; color: #f8fafc; }
  tfoot th, tfoot td { background: #f8fafc; font-weight: 600; }
</style>
```

`caption` is not a replacement for a heading. A page still needs its own `h1` and section headings. The caption belongs to the table the way a `figcaption` belongs to a figure: it describes the specific object, and assistive technology can announce it when someone enters the table.

The groups matter for more than styling. `thead` and `tfoot` tell the browser which rows are not ordinary data, which helps when a long table is printed or split across pages. `tbody` can appear more than once if a table has genuinely separate chunks of data, but most tables need one.

> **Under the hood:** The browser repairs table markup aggressively. A stray `td` can create an implicit row, a `tfoot` written before `tbody` may be moved, and a missing closing tag can restructure the whole grid. Validate your table structure rather than trusting the parser to guess.

## Headers need a scope

A visual header is only half the job. `scope` tells assistive technology whether a `th` describes the column below it or the row beside it. `scope="col"` is for the header row; `scope="row"` is for the first cell in a data row.

```html run
<table class="ledger">
  <caption>March studio expenses</caption>
  <thead>
    <tr>
      <th scope="col">Item</th>
      <th scope="col">Date</th>
      <th scope="col" class="number">Amount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Clay</th>
      <td>4 March</td>
      <td class="number">£86.00</td>
    </tr>
    <tr>
      <th scope="row">Glaze</th>
      <td>11 March</td>
      <td class="number">£42.50</td>
    </tr>
    <tr>
      <th scope="row">Kiln service</th>
      <td>19 March</td>
      <td class="number">£130.00</td>
    </tr>
  </tbody>
</table>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  .ledger { border-collapse: collapse; width: 100%; max-width: 34rem; }
  .ledger caption { text-align: left; font-weight: 700; padding-bottom: 0.75rem; }
  .ledger th, .ledger td { padding: 0.7rem 0.9rem; border-bottom: 1px solid #e2e8f0; text-align: left; }
  .ledger thead th { background: #ecfdf5; color: #065f46; }
  .ledger .number { text-align: right; font-variant-numeric: tabular-nums; }
</style>
```

Without `scope`, a screen reader has to guess. With it, moving to `£42.50` can be announced as "Glaze, 11 March, £42.50" instead of a bare number. The attribute costs almost nothing and removes a whole class of ambiguity.

A useful test is to read a single data cell aloud with no visual context. If you cannot say which row and column it belongs to, the header relationships are incomplete. That is also why a header cannot be replaced by bold text or a shaded background: those are visual cues, and the accessibility tree never sees them.

Not every `th` needs to be in `thead`. The first cell of each body row is a header too, which is why it is a `th` with `scope="row"` rather than a `td`. If the top-left cell is empty because the table has both column and row headers, leave it as an empty `td` or give it a meaningful label such as "Item".

## Challenge: build a schedule table

Build a three-column schedule for a Saturday workshop. The table needs a caption that reads `Saturday studio schedule`, three column headers (`Time`, `Session`, `Room`) with the correct scope, and three sessions. The starter already has two sessions; add the third at `11:00`, called `Glazing`, in `Studio B`.

```html exercise id=tables-schedule title="Build a schedule table"
<table>
  <thead>
    <tr>
      <td>Time</td>
      <td>Session</td>
      <td>Room</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>09:00</td>
      <td>Doors open</td>
      <td>Atrium</td>
    </tr>
    <tr>
      <td>09:30</td>
      <td>Keynote</td>
      <td>Main hall</td>
    </tr>
  </tbody>
</table>
--- solution
<table>
  <caption>Saturday studio schedule</caption>
  <thead>
    <tr>
      <th scope="col">Time</th>
      <th scope="col">Session</th>
      <th scope="col">Room</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>09:00</td>
      <td>Doors open</td>
      <td>Atrium</td>
    </tr>
    <tr>
      <td>09:30</td>
      <td>Keynote</td>
      <td>Main hall</td>
    </tr>
    <tr>
      <td>11:00</td>
      <td>Glazing</td>
      <td>Studio B</td>
    </tr>
  </tbody>
</table>
--- test
assertExists("table caption", "The table needs a caption that names the schedule");
assertText("table caption", "Saturday studio schedule", "The caption should read: Saturday studio schedule");
assertCount("table thead th", 3, "The header row needs three th cells, not td cells");
const headers = Array.from(document.querySelectorAll("table thead th"));
assert(headers.every((th) => th.getAttribute("scope") === "col"), "Each column header needs scope=\"col\" so assistive technology knows what it labels");
assertText("table thead th:nth-child(1)", "Time", "The first column header should read: Time");
assertText("table thead th:nth-child(2)", "Session", "The second column header should read: Session");
assertText("table thead th:nth-child(3)", "Room", "The third column header should read: Room");
assertCount("table tbody tr", 3, "The schedule should have three sessions in the body");
const last = document.querySelectorAll("table tbody tr")[2];
assertCount("table tbody tr:last-child > *", 3, "Each schedule row should still have exactly three cells");
assert(normalize(last.children[0].textContent) === "11:00", "The third session should start at 11:00");
assert(normalize(last.children[1].textContent) === "Glazing", "The third session should be called Glazing");
assert(normalize(last.children[2].textContent) === "Studio B", "The third session belongs in Studio B");
--- hint
A caption goes immediately inside the table, before the header row.
--- hint
The cells in the header row describe columns, so use `<th scope="col">` instead of `<td>`.
--- hint
Copy one of the existing body rows, then change its three values to 11:00, Glazing and Studio B.
```

## Merging cells with colspan and rowspan

Sometimes one cell really does cover several columns or rows. `colspan="2"` makes a cell stretch across two columns; `rowspan="2"` makes it stretch down two rows. The number counts columns or rows, not pixels, so the rest of the row has to add up.

```html run
<table>
  <caption>Pottery classes</caption>
  <thead>
    <tr>
      <th scope="col">Day</th>
      <th scope="col">Morning</th>
      <th scope="col">Afternoon</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row" rowspan="2">Saturday</th>
      <td>Wheel throwing</td>
      <td>Glazing</td>
    </tr>
    <tr>
      <td colspan="2">Open studio — bring your own project</td>
    </tr>
    <tr>
      <th scope="row">Sunday</th>
      <td>Hand building</td>
      <td>Kiln loading</td>
    </tr>
  </tbody>
</table>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  table { border-collapse: collapse; width: 100%; max-width: 38rem; }
  caption { text-align: left; font-weight: 700; padding-bottom: 0.75rem; }
  th, td { padding: 0.7rem 0.9rem; border: 1px solid #cbd5e1; text-align: left; }
  thead th { background: #f1f5f9; }
</style>
```

The Saturday header spans two rows, so the following row starts with the merged Saturday cell already in place. The open studio cell spans both the Morning and Afternoon columns, so it is the only cell in that row besides the row header. Read the rows as a grid: every row still accounts for three columns.

> **Pitfall:** Merged cells are hard to navigate with a keyboard or a screen reader, and they break simple copy-and-paste into a spreadsheet. Use them when the data genuinely merges — a lunch break that covers the whole afternoon, a date shared by two sessions — not to make a prettier header.

```html predict id=tables-colspan-predict title="What does colspan do to the row?"
<table>
  <caption>Workshop sign-ups</caption>
  <tr>
    <th scope="col">Name</th>
    <th scope="col">Morning</th>
    <th scope="col">Afternoon</th>
  </tr>
  <tr>
    <th scope="row">Ada</th>
    <td colspan="2">All-day pass</td>
  </tr>
  <tr>
    <th scope="row">Grace</th>
    <td>Wheel</td>
    <td>Glaze</td>
  </tr>
</table>
--- options
* Ada's cell stretches across the Morning and Afternoon columns, so the row still accounts for three columns
Ada's cell sits only in Morning, and the Afternoon cell is left empty
The table grows a fourth column to hold the extra cell
Every cell in Ada's row merges into one wide column
--- explain
`colspan="2"` makes one cell occupy two column tracks. The cell does not add a fourth column; it consumes the two columns that follow it. That is why the row still lines up with the three headers above it. If you add up the widths and get more than the table has, the browser will create extra columns and the grid will look broken.
```

## Challenge: a totals row that belongs in tfoot

A totals row is not another data row. Put it in `tfoot`, give its label a `th` with `scope="row"`, and let the label span the first two columns so the number lands under `Amount`. Reuse the `number` class on the amount so it stays right-aligned with tabular figures.

The starter has the invoices but no footer. Add a `tfoot` with one row: a row header that says `Total outstanding` and spans two columns, followed by a data cell containing `£2,150`.

```html exercise id=tables-totals title="Add a totals row with tfoot"
<table>
  <caption>February invoices</caption>
  <thead>
    <tr>
      <th scope="col">Client</th>
      <th scope="col">Invoice</th>
      <th scope="col" class="number">Amount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Moss &amp; Pine</td>
      <td>#1042</td>
      <td class="number">£1,200</td>
    </tr>
    <tr>
      <td>Field Notes</td>
      <td>#1043</td>
      <td class="number">£650</td>
    </tr>
    <tr>
      <td>Atelier North</td>
      <td>#1044</td>
      <td class="number">£300</td>
    </tr>
  </tbody>
</table>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  table { border-collapse: collapse; width: 100%; max-width: 40rem; }
  caption { text-align: left; font-weight: 700; padding-bottom: 0.75rem; }
  th, td { padding: 0.7rem 0.9rem; border-bottom: 1px solid #e2e8f0; text-align: left; }
  thead th { background: #0f172a; color: #f8fafc; }
  .number { text-align: right; font-variant-numeric: tabular-nums; }
</style>
--- solution
<table>
  <caption>February invoices</caption>
  <thead>
    <tr>
      <th scope="col">Client</th>
      <th scope="col">Invoice</th>
      <th scope="col" class="number">Amount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Moss &amp; Pine</td>
      <td>#1042</td>
      <td class="number">£1,200</td>
    </tr>
    <tr>
      <td>Field Notes</td>
      <td>#1043</td>
      <td class="number">£650</td>
    </tr>
    <tr>
      <td>Atelier North</td>
      <td>#1044</td>
      <td class="number">£300</td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <th scope="row" colspan="2">Total outstanding</th>
      <td class="number">£2,150</td>
    </tr>
  </tfoot>
</table>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  table { border-collapse: collapse; width: 100%; max-width: 40rem; }
  caption { text-align: left; font-weight: 700; padding-bottom: 0.75rem; }
  th, td { padding: 0.7rem 0.9rem; border-bottom: 1px solid #e2e8f0; text-align: left; }
  thead th { background: #0f172a; color: #f8fafc; }
  tfoot th, tfoot td { background: #f8fafc; font-weight: 700; }
  .number { text-align: right; font-variant-numeric: tabular-nums; }
</style>
--- test
assertExists("table tfoot", "A totals row belongs in tfoot, not at the end of tbody");
assertCount("table tfoot tr", 1, "tfoot should contain exactly one totals row");
const total = query("table tfoot th");
assert(total.getAttribute("scope") === "row", "The totals label is a row header, so it needs scope=\"row\"");
assertAttr("table tfoot th", "colspan", "2", "The label should span the Client and Invoice columns");
assertText("table tfoot th", "Total outstanding", "The totals label should read: Total outstanding");
assertText("table tfoot td", "£2,150", "The amount cell should show the sum: £2,150");
assertCount("table tfoot tr > *", 2, "The totals row has two cells: the spanning header and the amount");
assertStyle("table", "border-collapse", "collapse", "Collapse the table borders so the footer shares the same grid lines");
assertStyle("table tfoot tr > td:last-child", "text-align", "right", "Right-align the total so it lines up under the Amount column");
assertStyle("table tfoot tr > td:last-child", "font-variant-numeric", "tabular-nums", "Use tabular numbers so the total aligns with the amounts above");
--- hint
`tfoot` is a sibling of `tbody`, not a row inside it.
--- hint
The label is a `th` with `scope="row"`, and `colspan="2"` lets it cover the first two columns.
--- hint
The amount belongs in a `td` after the row header, so it sits under the Amount column.
```

## Making a wide table readable

A table can be structurally perfect and still unpleasant to read. The usual fixes are small: collapse the borders, give cells breathing room, align numbers to the right, and use a typeface where digits line up.

```html run
<div class="table-wrap">
  <table>
    <caption>Trail series standings</caption>
    <thead>
      <tr>
        <th scope="col">Runner</th>
        <th scope="col">Races</th>
        <th scope="col" class="number">Points</th>
      </tr>
    </thead>
    <tbody>
      <tr><th scope="row">Ada</th><td>6</td><td class="number">482</td></tr>
      <tr><th scope="row">Grace</th><td>5</td><td class="number">461</td></tr>
      <tr><th scope="row">Lin</th><td>6</td><td class="number">447</td></tr>
      <tr><th scope="row">Sam</th><td>4</td><td class="number">398</td></tr>
      <tr><th scope="row">Jo</th><td>6</td><td class="number">376</td></tr>
      <tr><th scope="row">Noor</th><td>5</td><td class="number">351</td></tr>
    </tbody>
  </table>
</div>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  .table-wrap { max-width: 36rem; max-height: 15rem; overflow: auto; border: 1px solid #cbd5e1; border-radius: 12px; }
  table { width: 100%; border-collapse: collapse; }
  caption { padding: 1rem; text-align: left; font-weight: 700; background: #f8fafc; }
  th, td { padding: 0.7rem 1rem; border-bottom: 1px solid #e2e8f0; text-align: left; }
  thead th { position: sticky; top: 0; background: #0f172a; color: #f8fafc; }
  tbody tr:nth-child(even) { background: #f8fafc; }
  .number { text-align: right; font-variant-numeric: tabular-nums; }
</style>
```

`border-collapse: collapse` makes adjacent borders share a single line instead of drawing two lines with a gap. Without it, every cell looks slightly heavier and the grid develops a double-border shimmer. `font-variant-numeric: tabular-nums` asks the font for fixed-width digits, so a column of prices or points lines up no matter which digits appear.

Keep the caption visible, even when the page already has a heading above the table. The caption is the only name the table itself carries into the accessibility tree. If the design cannot give it a full line, make it smaller or place it below the table with `caption-side: bottom`; do not remove it and hope the nearest heading does the job.

The sticky header is the one piece that needs a scroll container. The `thead th` cells use `position: sticky; top: 0` inside `.table-wrap`, whose `max-height` and `overflow: auto` create the scrolling box. Scroll the table and the column labels stay in view. The container also keeps a wide table from forcing the whole page sideways.

> **Tip:** On a phone, a five-column table rarely fits. Let the table scroll inside its own container, keep the first column visible if you can, and never shrink the text until it becomes unreadable. A horizontal scroll bar inside the table's own container is far better than a page that scrolls sideways.

## Debug: the table that only looks like a table

This timetable renders convincingly. The first row is bold and shaded, and the first column reads like a set of labels. But every cell is a `td`, and the table has no caption. A screen reader gets a rectangle of values with no idea what any of them mean.

Fix the semantics without changing the visible data: add the caption `Weekly studio timetable`, make the top row column headers with `scope="col"`, and make the first cell of each body row a row header with `scope="row"`.

```html debug id=tables-missing-headers title="The table that only looks like a table"
<table class="timetable">
  <thead>
    <tr>
      <td>Day</td>
      <td>Morning</td>
      <td>Afternoon</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Monday</td>
      <td>Open studio</td>
      <td>Life drawing</td>
    </tr>
    <tr>
      <td>Tuesday</td>
      <td>Wheel throwing</td>
      <td>Glazing</td>
    </tr>
  </tbody>
</table>

<style>
  .timetable { border-collapse: collapse; width: 100%; max-width: 34rem; font-family: system-ui, sans-serif; }
  .timetable td { padding: 0.7rem 0.9rem; border: 1px solid #cbd5e1; text-align: left; }
  .timetable tr:first-child td { background: #f1f5f9; font-weight: 700; }
</style>
--- solution
<table class="timetable">
  <caption>Weekly studio timetable</caption>
  <thead>
    <tr>
      <th scope="col">Day</th>
      <th scope="col">Morning</th>
      <th scope="col">Afternoon</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Monday</th>
      <td>Open studio</td>
      <td>Life drawing</td>
    </tr>
    <tr>
      <th scope="row">Tuesday</th>
      <td>Wheel throwing</td>
      <td>Glazing</td>
    </tr>
  </tbody>
</table>

<style>
  .timetable { border-collapse: collapse; width: 100%; max-width: 34rem; font-family: system-ui, sans-serif; }
  .timetable th, .timetable td { padding: 0.7rem 0.9rem; border: 1px solid #cbd5e1; text-align: left; }
  .timetable thead th { background: #f1f5f9; }
</style>
--- test
assertExists("table caption", "The table still has no caption, so nothing names what the timetable is for");
assertText("table caption", "Weekly studio timetable", "The caption should read: Weekly studio timetable");
assertCount("table thead th", 3, "The top row is still made of td cells. Use th for column headers");
const columns = Array.from(document.querySelectorAll("table thead th"));
assert(columns.every((cell) => cell.getAttribute("scope") === "col"), "Every column header needs scope=\"col\"");
assertCount("table tbody th", 2, "Each body row needs a row header for its day");
const rows = Array.from(document.querySelectorAll("table tbody th"));
assert(rows.every((cell) => cell.getAttribute("scope") === "row"), "Each day header needs scope=\"row\"");
assertCount("table tbody td", 4, "The four session cells should stay as data cells");
assertText("table tbody tr:first-child th", "Monday", "The first body row should still start with Monday");
assertText("table tbody tr:last-child th", "Tuesday", "The last body row should still start with Tuesday");
--- hint
Run it first. It looks fine, which is exactly the problem: visual boldness is not semantics.
--- hint
The top row describes columns; the first cell of each body row describes that row.
--- hint
Change the header-row cells to `<th scope="col">`, the day cells to `<th scope="row">`, and add a caption before `thead`.
```

## A short table checklist

Before you ship a table, read it the way a browser does:

- Does the data genuinely need two axes, or are you using a table for layout?
- Does it have a `caption` that names what the table contains?
- Is the header row inside `thead`, with `th scope="col"` on every column header?
- Does each data row have a `th scope="row"` if the first cell labels the row?
- Do `colspan` and `rowspan` values still add up to a consistent grid?
- Are numbers right-aligned and set with `tabular-nums` where columns are compared?
- Does a wide table scroll inside a container instead of pushing the page sideways?

None of these require JavaScript. They are all decisions in the markup and a few lines of CSS.

## Recap

- A table describes data with two axes. If the content is only a layout, use CSS.
- `caption`, `thead`, `tbody` and `tfoot` give the table a name and a structure that survives printing and assistive technology.
- `th` marks headers; `scope="col"` and `scope="row"` say which cells they describe.
- `colspan` and `rowspan` merge cells across columns and rows, and the rest of the grid must still add up.
- `border-collapse: collapse`, right-aligned `tabular-nums`, and a sticky `thead` make dense data easier to read.
- A table that looks right but uses only `td` cells is still inaccessible.

**Up next:** forms — the place where visitors stop reading and start typing, and where a missing label or the wrong button type quietly loses their data.
