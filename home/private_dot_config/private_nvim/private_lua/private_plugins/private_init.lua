return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "lukas-reineke/virt-column.nvim",
    event = "User FilePost",
    opts = { char = "│", virtcolumn = "81,121", highlight = "VirtColumn" },
  },
}
