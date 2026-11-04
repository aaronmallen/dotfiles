local highlights = {
  MatchParen = { bg = "#3b514d", bold = true },
  CursorLine = { bg = "#3b3539" },
  TreeFolderRed = { fg = "#ff6188" },
  TreeFolderOrange = { fg = "#fc9867" },
  TreeFolderYellow = { fg = "#ffd866" },
  TreeFolderGreen = { fg = "#a9dc76" },
  TreeFolderCyan = { fg = "#78dce8" },
  TreeFolderPurple = { fg = "#ab9df2" },
  TreeFolderGrey = { fg = "#939293" },
  TreeFolderText = { fg = "#fcfcfa" },
}

local tree = {
  NeoTreeNormal = "#fcfcfa",
  NeoTreeNormalNC = "#fcfcfa",
  NeoTreeDirectoryName = "#fcfcfa",
  NeoTreeFileName = "#fcfcfa",
  NeoTreeDotfile = "#c1c0c0",
  NeoTreeHiddenByName = "#c1c0c0",
  NeoTreeGitIgnored = "#939293",
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
      devicons = true,
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
