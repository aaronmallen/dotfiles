local parsers = {
  "bash",
  "css",
  "diff",
  "dockerfile",
  "embedded_template",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "query",
  "regex",
  "ron",
  "ruby",
  "rust",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "zsh",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require "nvim-treesitter"
      treesitter.install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("aaron_treesitter", { clear = true }),
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match)
          if not lang or not pcall(vim.treesitter.start, event.buf, lang) then
            return
          end
          if vim.treesitter.query.get(lang, "indents") then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    init = function()
      vim.g.no_plugin_maps = true
    end,
    opts = {
      select = { lookahead = true },
      move = { set_jumps = true },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      local select = require "nvim-treesitter-textobjects.select"
      local move = require "nvim-treesitter-textobjects.move"
      local swap = require "nvim-treesitter-textobjects.swap"

      local objects = {
        f = "function",
        c = "class",
        a = "parameter",
        o = "loop",
        i = "conditional",
        b = "block",
      }
      for key, name in pairs(objects) do
        vim.keymap.set({ "x", "o" }, "a" .. key, function()
          select.select_textobject("@" .. name .. ".outer", "textobjects")
        end, { desc = "Around " .. name })
        vim.keymap.set({ "x", "o" }, "i" .. key, function()
          select.select_textobject("@" .. name .. ".inner", "textobjects")
        end, { desc = "Inside " .. name })
      end

      local moves = { f = "function", k = "class", a = "parameter" }
      for key, name in pairs(moves) do
        local query = "@" .. name .. ".outer"
        vim.keymap.set({ "n", "x", "o" }, "]" .. key, function()
          move.goto_next_start(query, "textobjects")
        end, { desc = "Next " .. name })
        vim.keymap.set({ "n", "x", "o" }, "[" .. key, function()
          move.goto_previous_start(query, "textobjects")
        end, { desc = "Previous " .. name })
        vim.keymap.set({ "n", "x", "o" }, "]" .. key:upper(), function()
          move.goto_next_end(query, "textobjects")
        end, { desc = "Next " .. name .. " end" })
        vim.keymap.set({ "n", "x", "o" }, "[" .. key:upper(), function()
          move.goto_previous_end(query, "textobjects")
        end, { desc = "Previous " .. name .. " end" })
      end

      vim.keymap.set("n", "<leader>cs", function()
        swap.swap_next "@parameter.inner"
      end, { desc = "Swap with next parameter" })
      vim.keymap.set("n", "<leader>cS", function()
        swap.swap_previous "@parameter.inner"
      end, { desc = "Swap with previous parameter" })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
