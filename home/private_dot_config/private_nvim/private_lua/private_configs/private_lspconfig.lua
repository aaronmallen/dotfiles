require("nvchad.configs.lspconfig").defaults()

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
})

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
