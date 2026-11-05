require "nvchad.autocmds"

vim.api.nvim_create_autocmd("CmdlineChanged", {
  pattern = { ":", "/", "?" },
  command = "call wildtrigger()",
})
