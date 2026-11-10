local highlight = {
  "RainbowDelimiterRed",
  "RainbowDelimiterYellow",
  "RainbowDelimiterBlue",
  "RainbowDelimiterOrange",
  "RainbowDelimiterGreen",
  "RainbowDelimiterViolet",
}

return {
  {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    event = "User FilePost",
    init = function()
      vim.g.rainbow_delimiters = { highlight = highlight }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = { "rainbow-delimiters.nvim" },
    opts = function(_, opts)
      opts.indent.highlight = highlight
      opts.scope.highlight = highlight
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
}
