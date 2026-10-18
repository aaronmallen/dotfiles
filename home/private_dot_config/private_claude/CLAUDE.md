## Memory, Artifacts and Sessions

Use the `aaronmallen-me` MCP server for memory, artifacts and sessions, in place of Claude Code's own memory files and
local notes.

**The site always wins.** When a memory or artifact on aaronmallen.me disagrees with a local memory file, `CLAUDE.md`
memory note or local plan, follow the site's and fix or delete the local copy.

- **Start every run with `start_session`.** Name yourself with agent and model slugs, such as `claude-code` and
  `claude-opus-5-5`, and pass the repo as `owner/name` and any project or task you know. It loads your memory. Pass
  the `session_id` it returns on every memory and artifact write, and call `end_session` when the run is done.
- **Remember things on the site.** Save a preference, convention, gotcha or piece of context with `add_memory_fact`,
  or `create_memory_file` when no file fits. Pick the narrowest scope that holds it: global, repo, project or task.
  Fix a wrong fact with `edit_memory_fact` or `remove_memory_fact`. Do not write a local memory file.
- **Write documents as artifacts.** A plan, spec, research, handoff, notes, review or postmortem goes in
  `create_artifact`, and a later change in `update_artifact`, which keeps each version. Check `list_artifacts` for one
  that already covers the work before you make another. Write a local file or a page only when I ask for one.
- **When the server is not connected** or this connection lacks a tool, say so once, then use the local default.

## Writing Rules

Review every prose output (READMEs, docs, issues, commit messages) against these rules before delivering:

1. Never use a metaphor, simile or other figure of speech which you are used to seeing in print.
2. Never use a long word where a short one will do.
3. If it is possible to cut a word out, always cut it out.
4. Never use the passive where you can use the active.
5. Never use a foreign phrase, a scientific word or a jargon word if you can think of an everyday English equivalent.
6. Never use emdash
7. Break any of these rules sooner than say anything outright barbarous.
