---
name: grill-me
description: 'Relentlessly interview the user about a plan, decision, or idea until you reach a shared understanding. Use when the user wants to stress-test their thinking, or says "grill me", "grill this", or "poke holes in this".'
license: MIT
metadata:
  tags: "Planning, Design, Interview, Productivity"
  category: "productivity"
  source: "https://github.com/mattpocock/skills (skills/productivity/grilling)"
---

# grill-me

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision
branches into the decisions that hang off it.

## Rounds

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions
you can ask _now_ without guessing at answers you have not heard yet.

Ask the whole frontier in one round. Number each question and give your recommended answer. Then wait for the user's
answers before the next round.

Format a round like so:

```text
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round of answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended
on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open
in this round belongs to a _later_ round, not this one.

## Facts are yours, decisions are theirs

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem,
git history, tools, the web), go find it; dispatch a sub-agent if the search is broad. Never ask the user for something
you could look up yourself.

Do not block on it. A running exploration is an unsettled prerequisite, so only the questions downstream of it wait for
the result; ask the rest of the frontier now.

The _decisions_ are the user's. Put each one to them and wait.

## Done

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed.

Do not act on the plan until the user confirms you have reached a shared understanding.
