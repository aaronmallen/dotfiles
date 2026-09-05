# Output styles

Claude Code reads user-level output styles from `$CLAUDE_CONFIG_DIR/output-styles`,
which `../env.sh` points at `~/.config/claude`. Upstream's install docs say
`~/.claude/output-styles`; that is wrong for this setup.

The styles here come from [attention-span](https://github.com/alexgreensh/attention-span),
which is AGPL-3.0. They are fetched at apply time by
`home/.chezmoiexternals/attention-span.toml` rather than committed, so no AGPL
content lands in this MIT-licensed repo. This directory exists only to own the
`0700` permissions the rest of `~/.config/claude` uses.

Pick one with `/config` → *Output style* (writes `.claude/settings.local.json`,
per project) or set `outputStyle` in `~/.config/claude/settings.json` for every
session. Takes effect on the next `/clear` or new session.
