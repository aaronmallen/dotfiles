---
name: rex
description: |
  Use the rex CLI to manage Rex sessions, open tabs, arrange panes, run commands, inspect terminal output, and control
  connected Rex apps.
metadata:
  rex-stub: "2"
---
<!-- Installed by "rex skill setup". Remove it with "rex skill remove". -->

Run `rex skill show` and follow the guide it prints. The guide comes from
the installed Rex CLI, so it describes the commands available in that version.

Follow the Rex Sessions rules in `AGENTS.md` over the guide's naming advice:
confirm your session with `rex --autostart=false whoami --json`, then always
rename it to match the chat, even if it already has a custom name. Use two to
four lowercase words joined by hyphens, and rename it when the main task changes.

If `rex skill show` is unavailable, try `rex __internal skill`. If neither
command is available, start with `rex --autostart=false whoami --json`, then use
`rex --help` and `rex COMMAND --help`.
