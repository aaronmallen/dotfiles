local data = os.getenv "XDG_DATA_HOME" or os.getenv "HOME" .. "/.local/share"
dofile(data .. "/rex/plugins/rex-agents/lua/rex-agents/init.lua").setup {
  panel_key = "ctrl+cmd+a",
  waiting_key = "ctrl+cmd+e",
}
