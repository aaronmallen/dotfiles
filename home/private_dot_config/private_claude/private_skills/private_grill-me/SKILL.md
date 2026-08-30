---
name: grill-me
description: 'Relentlessly interview the user about a plan, decision, or idea, one question at a time, until you reach a shared understanding. Use when the user wants to stress-test their thinking, or says "grill me", "grill this", or "poke holes in this".'
license: MIT
metadata:
  tags: "Planning, Design, Interview, Productivity"
  category: "productivity"
  source: "https://github.com/mattpocock/skills (skills/productivity/grilling)"
---

# grill-me

Interview the user until you reach a shared understanding. Map the subject as a **design tree**: every decision
branches into the decisions that hang off it.

## One question at a time

Ask one question. Wait for the answer. Ask the next.

Never stack. No second question after the recommendation, no "and while I have you", no list of things you will ask
later. One question is the whole message.

Batching feels efficient and is not. The user has to hold five open threads at once, answers get skipped, and the
answer to the first question usually changes the fourth before they reach it.

## Choosing the next question

The **frontier** is every decision whose prerequisites are settled: what you can ask now without guessing at an answer
you have not heard.

Recompute the frontier after every answer, not every few. Then pick one question from it:

- Prefer the question the last answer just reshaped. That is where the user's thinking is already pointed.
- Otherwise take the question that unblocks the most of the tree.
- A question that depends on something still open is not on the frontier. Hold it.

Keep the rest of the tree in your head. Do not recite it.

## Format

```text
✅ **Settled**: <one line on what the last answer fixed>

❓ **<question title>**

<the tension: what makes this a real question, and what breaks either way>

<two to four named options>

➡️ <your recommendation, and the reason it wins>

<the strongest case against your recommendation>
```

Lead with what the last answer settled so the user watches the tree close behind them. Skip that line on the first
question.

Always recommend. A question with no recommendation makes the user do the work twice.

Then argue against yourself. If you cannot state a real cost of your own recommendation, you have not understood the
decision well enough to ask about it.

## Facts are yours, decisions are theirs

Finding _facts_ is your job, never the user's. When a question needs a fact from the environment (filesystem, git
history, tools, the web), go and find it before you ask.

Read the documents the user points you at, and the ones next to them. When two of their own documents disagree, say so
plainly and ask which one is current. That contradiction is usually the best question you have.

The _decisions_ are the user's. Put one to them and wait.

## Stopping early

The user may cut the session short. When they do, hand back every decision that got settled, in one short list, and
offer to write it down where it belongs. Otherwise the whole session lives only in the transcript.

## Done

The session ends when the frontier is empty: every branch visited, nothing silently assumed.

Do not act on the plan until the user confirms you have reached a shared understanding.

