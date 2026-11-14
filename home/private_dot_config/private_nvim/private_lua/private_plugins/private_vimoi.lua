return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "gotmpl")
    end,
  },
  {
    "dirichy/vimoi.nvim",
    lazy = false,
    opts = {
      highlight = { mode = "injection" },
      diagnostics = { enabled = false },
    },
    config = function(_, opts)
      local filetype = require "vimoi.editor.filetype"
      local host_filetype = filetype.host_filetype
      -- shortcut: uses vimoi internals until upstream removes the blocking filetype lookup.
      filetype.host_filetype = function(path, buf)
        local cli = require "vimoi.core.cli"
        if cli.source_root and vim.fs.relpath(cli.source_root, path) ~= nil then
          for _, rule in ipairs(require("vimoi.core.source").template_rules) do
            if path:gsub("%.tmpl$", ""):match("^" .. rule.pattern .. "$") then
              return host_filetype(path, buf)
            end
          end
          local target = cli.run { "target-path", path }
          if target and vim.trim(target) ~= "" then
            path = vim.trim(target)
          end
        end
        return host_filetype(path, buf)
      end
      require("vimoi").setup(opts)
    end,
  },
}
