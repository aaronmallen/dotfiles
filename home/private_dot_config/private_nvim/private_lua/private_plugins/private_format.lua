local web = { "biome-check", "prettierd", stop_after_first = true }

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format { async = true }
        end,
        mode = { "n", "x" },
        desc = "Format",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle({
            name = "Format on save",
            get = function()
              return not vim.g.disable_autoformat
            end,
            set = function(state)
              vim.g.disable_autoformat = not state
            end,
          }):map "<leader>uf"
        end,
      })
    end,
    opts = {
      default_format_opts = { lsp_format = "fallback" },
      formatters_by_ft = {
        css = { "prettierd" },
        html = { "prettierd" },
        javascript = web,
        javascriptreact = web,
        json = web,
        jsonc = web,
        lua = { "stylua" },
        markdown = { "markdownlint-cli2" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        toml = { "taplo" },
        typescript = web,
        typescriptreact = web,
        yaml = { "yamlfmt" },
      },
      formatters = {
        ["biome-check"] = { require_cwd = true },
        prettierd = { require_cwd = true },
      },
      format_on_save = function()
        if vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 1000 }
      end,
    },
  },
}
