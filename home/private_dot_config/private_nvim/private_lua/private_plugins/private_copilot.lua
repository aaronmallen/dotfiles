return {
  {
    "zbirenbaum/copilot.lua",
    enabled = vim.fn.executable "node" == 1,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = {
        auto_trigger = true,
        keymap = { accept = "<C-y>" },
      },
    },
  },
}
