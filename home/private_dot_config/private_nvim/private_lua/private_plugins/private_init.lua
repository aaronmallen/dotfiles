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
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        git_ignored = false,
        custom = { "^\\.git$", "^\\.jj$", "^\\.DS_Store$" },
      },
      renderer = {
        icons = { glyphs = { git = { ignored = "" } } },
      },
    },
  },

  {
    "lukas-reineke/virt-column.nvim",
    event = "User FilePost",
    opts = { char = "│", virtcolumn = "81,121", highlight = "VirtColumn" },
  },
}
