local servers = {
  "bashls",
  "cssls",
  "eslint",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "ruby_lsp",
  "taplo",
  "vtsls",
  "yamlls",
}

local tools = {
  "markdownlint-cli2",
  "prettierd",
  "shfmt",
  "stylua",
  "yamlfmt",
}

local function on_attach(event)
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if not client then
    return
  end
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
  end
  map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
  map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP info")
  map("n", "<leader>cc", vim.lsp.codelens.run, "Run code lens")
  map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
  if client:supports_method "textDocument/inlayHint" then
    vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
  end
  if client:supports_method "textDocument/codeLens" then
    vim.lsp.codelens.enable(true, { bufnr = event.buf })
  end
end

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = { ui = { border = "rounded" } },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = { ensure_installed = tools },
    config = function(_, opts)
      local installer = require "mason-tool-installer"
      installer.setup(opts)
      installer.run_on_start()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "b0o/SchemaStore.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.diagnostic.config {
        severity_sort = true,
        update_in_insert = false,
        underline = true,
        virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
        float = { source = "if_many" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "\u{f057} ",
            [vim.diagnostic.severity.WARN] = "\u{f071} ",
            [vim.diagnostic.severity.INFO] = "\u{f05a} ",
            [vim.diagnostic.severity.HINT] = "\u{f0335} ",
          },
        },
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("aaron_lsp", { clear = true }),
        callback = on_attach,
      })

      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
            hint = { enable = true, arrayIndex = "Disable" },
            format = { enable = false },
          },
        },
      })

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
            keyOrdering = false,
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })

      vim.lsp.config("vtsls", {
        settings = {
          complete_function_calls = true,
          vtsls = {
            autoUseWorkspaceTsdk = true,
            enableMoveToFileCodeAction = true,
            experimental = { completion = { enableServerSideFuzzyMatch = true } },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            referencesCodeLens = { enabled = true, showOnAllFunctions = true },
            implementationsCodeLens = { enabled = true },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
      })

      require("mason-lspconfig").setup {
        ensure_installed = servers,
        automatic_enable = { exclude = { "rust_analyzer" } },
      }
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, buf)
            local function map(lhs, rhs, desc)
              vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
            end
            map("K", function()
              vim.cmd.RustLsp { "hover", "actions" }
            end, "Hover actions")
            map("<leader>ce", function()
              vim.cmd.RustLsp "explainError"
            end, "Explain error")
            map("<leader>cE", function()
              vim.cmd.RustLsp "renderDiagnostic"
            end, "Render diagnostic")
            map("<leader>cx", function()
              vim.cmd.RustLsp "runnables"
            end, "Runnables")
            map("<leader>ct", function()
              vim.cmd.RustLsp "testables"
            end, "Tests")
            map("<leader>cM", function()
              vim.cmd.RustLsp "expandMacro"
            end, "Expand macro")
            map("<leader>cp", function()
              vim.cmd.RustLsp "parentModule"
            end, "Parent module")
            map("<leader>cC", function()
              vim.cmd.RustLsp "openCargo"
            end, "Open Cargo.toml")
            map("J", function()
              vim.cmd.RustLsp "joinLines"
            end, "Join lines")
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true, buildScripts = { enable = true } },
              check = { command = "clippy" },
              lens = {
                debug = { enable = false },
                implementations = { enable = false },
                references = {
                  adt = { enable = true },
                  enumVariant = { enable = true },
                  method = { enable = true },
                  trait = { enable = true },
                },
              },
              procMacro = { enable = true },
              imports = { granularity = { group = "crate" }, prefix = "crate" },
              inlayHints = {
                closureReturnTypeHints = { enable = "with_block" },
                lifetimeElisionHints = { enable = "skip_trivial" },
              },
              files = { exclude = { ".git", ".jj", "target", "node_modules" } },
            },
          },
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = true, actions = true, completion = true, hover = true },
    },
  },
}
