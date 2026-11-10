local M = {}

M.base_30 = {
  white = "#f7f1ff",
  darker_black = "#191919",
  black = "#222222",
  black2 = "#29282a",
  one_bg = "#2f2e30",
  one_bg2 = "#363537",
  one_bg3 = "#403e41",
  grey = "#525053",
  grey_fg = "#5d5b5e",
  grey_fg2 = "#69676c",
  light_grey = "#8b888f",
  red = "#fc618d",
  baby_pink = "#fd7ea3",
  pink = "#fc618d",
  line = "#363537",
  green = "#7bd88f",
  vibrant_green = "#8ee0a0",
  nord_blue = "#5ad4e6",
  blue = "#5ad4e6",
  yellow = "#fce566",
  sun = "#fce566",
  purple = "#948ae3",
  dark_purple = "#7f74d6",
  teal = "#5ad4e6",
  orange = "#fd9353",
  cyan = "#5ad4e6",
  statusline_bg = "#29282a",
  lightbg = "#363537",
  pmenu_bg = "#7bd88f",
  folder_bg = "#5ad4e6",
}

M.base_16 = {
  base00 = "#222222",
  base01 = "#363537",
  base02 = "#525053",
  base03 = "#69676c",
  base04 = "#8b888f",
  base05 = "#f7f1ff",
  base06 = "#f7f1ff",
  base07 = "#f7f1ff",
  base08 = "#f7f1ff",
  base09 = "#948ae3",
  base0A = "#5ad4e6",
  base0B = "#fce566",
  base0C = "#5ad4e6",
  base0D = "#7bd88f",
  base0E = "#fc618d",
  base0F = "#fd9353",
}

M.polish_hl = {
  treesitter = {
    ["@variable.parameter"] = { fg = M.base_30.orange, italic = true },
    ["@variable.member"] = { fg = M.base_30.white },
    ["@property"] = { fg = M.base_30.white },
    ["@operator"] = { fg = M.base_30.red },
    ["@punctuation.bracket"] = { fg = M.base_30.light_grey },
    ["@punctuation.delimiter"] = { fg = M.base_30.light_grey },
    ["@tag"] = { fg = M.base_30.red },
    ["@tag.attribute"] = { fg = M.base_30.blue, italic = true },
  },

  syntax = {
    Operator = { fg = M.base_30.red },
  },
}

M.type = "dark"

M = require("base46").override_theme(M, "monokai_pro_spectrum")

return M
