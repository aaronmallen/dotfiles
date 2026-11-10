# Serena

Serena's data folder, set by `SERENA_HOME` in `~/.config/serena/env.sh`.

Serena writes to `serena_config.yml` itself, to record projects and a secret. Chezmoi merges the settings
in `modify_private_serena_config.yml` into that file and leaves the rest alone.

[Configuration](https://oraios.github.io/serena/02-usage/050_configuration.html)
