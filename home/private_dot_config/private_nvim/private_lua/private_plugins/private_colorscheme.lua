local red = "#ff6188"
local orange = "#fc9867"
local yellow = "#ffd866"
local green = "#a9dc76"
local cyan = "#78dce8"
local purple = "#ab9df2"
local text = "#fcfcfa"
local grey = "#939293"

local keyword = { fg = red, italic = true }
local struct = { fg = green }
local enum = { fg = green, italic = true }
local trait = { fg = cyan, italic = true }
local plain = { fg = text }
local accent = { fg = cyan }
local builtin = { fg = cyan, italic = true }
local literal = { fg = purple }

local highlights = {
  ["@keyword.import"] = keyword,
  ["@keyword.coroutine"] = keyword,
  ["@keyword.function"] = keyword,
  ["@keyword.return"] = keyword,
  ["@keyword.modifier"] = keyword,
  ["@keyword.type"] = keyword,
  ["@keyword.repeat"] = keyword,
  ["@keyword.conditional"] = keyword,
  ["@keyword.operator"] = keyword,
  ["@variable.builtin"] = keyword,
  ["@lsp.type.selfKeyword"] = keyword,
  ["@boolean"] = literal,
  ["@lsp.type.boolean"] = literal,
  ["@constant.builtin"] = literal,
  ["@string.special.symbol"] = literal,
  ["@variable.member.ruby"] = literal,
  ["@keyword.visibility"] = accent,
  ["@keyword.crate"] = accent,
  ["@keyword.dyn"] = accent,
  ["@keyword.move"] = accent,
  ["@string.escape"] = accent,
  ["@function.builtin"] = builtin,
  ["@type.builtin"] = keyword,
  ["@lsp.type.builtinType"] = keyword,
  ["@type"] = struct,
  ["@type.definition"] = struct,
  ["@lsp.type.class"] = struct,
  ["@lsp.type.struct"] = struct,
  ["@lsp.type.typeAlias"] = struct,
  ["@lsp.typemod.class.defaultLibrary"] = struct,
  ["@lsp.typemod.struct.defaultLibrary"] = struct,
  ["@lsp.typemod.type.defaultLibrary"] = struct,
  ["@lsp.typemod.typeAlias.defaultLibrary"] = struct,
  ["@lsp.type.enum"] = enum,
  ["@lsp.type.enumMember"] = enum,
  ["@lsp.typemod.enum.defaultLibrary"] = enum,
  ["@lsp.typemod.enumMember.defaultLibrary"] = enum,
  ["@lsp.type.interface"] = trait,
  ["@lsp.type.typeParameter"] = trait,
  ["@lsp.typemod.function.defaultLibrary"] = struct,
  ["@lsp.typemod.method.defaultLibrary"] = struct,
  ["@module"] = plain,
  ["@lsp.type.namespace"] = plain,
  ["@function.macro"] = plain,
  ["@lsp.type.macro"] = plain,
  ["@lsp.type.lifetime"] = plain,
  ["@attribute"] = accent,
  ["@attribute.name"] = accent,
  ["@lsp.type.attribute"] = accent,
  ["@lsp.type.derive"] = accent,
  ["@lsp.type.decorator"] = accent,
  ["@lsp.typemod.macro.defaultLibrary"] = plain,
  ["@lsp.typemod.variable.defaultLibrary"] = plain,
  ["@function.javascript"] = builtin,
  ["@function.call.javascript"] = builtin,
  ["@lsp.type.function.javascript"] = builtin,
  ["@function.typescript"] = builtin,
  ["@function.call.typescript"] = builtin,
  ["@lsp.type.function.typescript"] = builtin,
  ["@function.tsx"] = builtin,
  ["@function.call.tsx"] = builtin,
  ["@lsp.type.function.tsx"] = builtin,
  ["@type.builtin.typescript"] = builtin,
  ["@lsp.type.enum.typescript"] = builtin,
  ["@lsp.type.type.typescript"] = builtin,
  ["@type.builtin.tsx"] = builtin,
  ["@lsp.type.enum.tsx"] = builtin,
  ["@lsp.type.type.tsx"] = builtin,
  ["@constant"] = { fg = orange },
  ["@punctuation.bracket"] = { fg = grey },
  MatchParen = { bg = "#3b514d", bold = true },
  CursorLine = { bg = "#3b3539" },
  TreeFolderRed = { fg = red },
  TreeFolderOrange = { fg = orange },
  TreeFolderYellow = { fg = yellow },
  TreeFolderGreen = { fg = green },
  TreeFolderCyan = { fg = cyan },
  TreeFolderPurple = { fg = purple },
  TreeFolderGrey = { fg = grey },
  TreeFolderText = { fg = text },
}

local tree = {
  NeoTreeNormal = text,
  NeoTreeNormalNC = text,
  NeoTreeDirectoryName = text,
  NeoTreeFileName = text,
  NeoTreeDotfile = "#c1c0c0",
  NeoTreeHiddenByName = "#c1c0c0",
  NeoTreeGitIgnored = grey,
}

local function apply_tree()
  for name, fg in pairs(tree) do
    local spec = vim.api.nvim_get_hl(0, { name = name, link = false })
    spec.fg = fg
    vim.api.nvim_set_hl(0, name, spec)
  end
end

return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      filter = "pro",
      terminal_colors = true,
      devicons = true,
      styles = {
        comment = { italic = true },
        keyword = { italic = true },
        storageclass = { italic = true },
        parameter = { italic = true },
        annotation = { italic = true },
        tag_attribute = { italic = true },
      },
      background_clear = {},
      plugins = {
        bufferline = { underline_selected = false, underline_visible = false },
        indent_blankline = { context_highlight = "pro", context_start_underline = false },
      },
    },
    config = function(_, opts)
      require("monokai-pro").setup(opts)
      local group = vim.api.nvim_create_augroup("aaron_colors", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "monokai-pro",
        group = group,
        callback = function()
          for name, spec in pairs(highlights) do
            vim.api.nvim_set_hl(0, name, spec)
          end
          apply_tree()
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        group = group,
        callback = apply_tree,
      })
      vim.cmd.colorscheme "monokai-pro"
    end,
  },
}
