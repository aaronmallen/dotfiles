return {
  "rawnly/rex.nvim",
  enabled = vim.fn.has "macunix" == 1,
  cond = function()
    return require("configs.rex").active()
  end,
  lazy = false,
  main = "rex-nvim",
  opts = { prefix = "<leader>ar" },
}
