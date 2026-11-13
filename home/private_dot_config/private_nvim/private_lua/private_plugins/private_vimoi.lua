return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "gotmpl")
    end,
  },
  {
    "dirichy/vimoi.nvim",
    lazy = false,
    opts = {},
  },
}
