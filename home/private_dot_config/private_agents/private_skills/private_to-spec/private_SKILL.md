---
name: to-spec
description: 'Turn the current conversation into a spec and publish it. No interview, just synthesis of what has already been discussed. Invoke with /to-spec.'
disable-model-invocation: true
license: MIT
metadata:
  tags: "Planning, Specs, Documentation, Engineering"
  category: "engineering"
  source: "https://github.com/mattpocock/skills (skills/engineering/to-spec)"
---

# to-spec

Take the current conversation context and codebase understanding and produce a spec.

Do NOT interview the user. Synthesize what you already know. If a decision genuinely was never made, list it under
**Further Notes** as an open question rather than stopping to ask.

## Process

1. Explore the repo to understand the current state of the codebase, if you have not already. Use the project's own
    vocabulary throughout the spec (README, existing docs, domain glossary if one exists) and respect any ADRs covering
    the area you are touching.

2. Sketch out the seams at which you are going to test the feature. Prefer existing seams to new ones. Use the highest
    seam possible. If new seams are needed, propose them at the highest point you can. The fewer seams across the
    codebase, the better; the ideal number is one.

    Check with the user that these seams match their expectations before writing the spec.

3. Write the spec using the template below, filling in every section.

4. Ask the user where it should go, then publish it there:

    - **Markdown file** in the repo (default to `docs/specs/<kebab-case-slug>.md`; follow the repo's own convention if
      it already has one)
    - **Linear issue** via the Linear MCP server, if connected. Confirm the team before creating it
    - **GitHub issue** via `gh issue create` in the current repo

    Do not publish to an external tracker without the user picking it in this step.

## Spec template

```markdown
## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

Example:

1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions
    about my spending

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built or modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine,
reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype.
Trim to the decision-rich parts, not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (similar types of tests already in the codebase)

## Out of Scope

A description of the things that are out of scope for this spec.

## Further Notes

Any further notes about the feature, including decisions the conversation never settled.
```
