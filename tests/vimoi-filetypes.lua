local cli = require "vimoi.core.cli"
local host_filetype = require("vimoi.editor.filetype").host_filetype
local run = cli.run
cli.run = function(args, ...)
  assert(args[1] ~= "source-path", "filetype detection must not read the full source state")
  return run(args, ...)
end

local cases = {
  { "private_dot_config/private_nvim/private_init.lua", "lua" },
  { "private_dot_config/private_mise/private_config.toml", "toml" },
  { "private_dot_config/private_apt/private_aptfile.tmpl", nil },
  { "symlink_dot_bashrc", "sh" },
  { ".chezmoiignore", "gitignore" },
  { ".chezmoiremove", "gitignore" },
  { ".chezmoiexternals/zsh-completions.toml", "toml" },
}

for _, case in ipairs(cases) do
  local path = cli.source_root .. "/" .. case[1]
  local started = vim.uv.hrtime()
  local detected = host_filetype(path, 0)
  assert(detected == case[2], case[1] .. ": unexpected filetype " .. tostring(detected))
  print(string.format("%s: %.1f ms", case[1], (vim.uv.hrtime() - started) / 1e6))
end

assert(host_filetype("/etc/example.lua", 0) == "lua")
for _, path in ipairs {
  "private_dot_config/private_nvim/private_init.lua",
  "private_dot_config/private_apt/private_aptfile.tmpl",
  "private_dot_config/private_mise/private_config.toml",
} do
  local started = vim.uv.hrtime()
  vim.cmd.edit(cli.source_root .. "/" .. path)
  print(string.format("open %s: %.1f ms", path, (vim.uv.hrtime() - started) / 1e6))
end
cli.run = run
