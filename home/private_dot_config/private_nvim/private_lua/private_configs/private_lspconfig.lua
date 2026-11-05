require("nvchad.configs.lspconfig").defaults()

local servers = {
  "bashls",
  "cssls",
  "eslint",
  "herb_ls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "rubocop",
  "ruby_lsp",
  "rust_analyzer",
  "rust_glancer",
  "stylua",
  "taplo",
  "vtsls",
  "yamlls",
}
vim.lsp.enable(servers)
