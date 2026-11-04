return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      indent = { enabled = true, animate = { enabled = false } },
      scope = { enabled = true },
      words = { enabled = true },
      statuscolumn = { enabled = true },
      scroll = { enabled = false },
      picker = {
        enabled = true,
        ui_select = true,
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
        },
        win = {
          input = {
            keys = {
              ["<a-o>"] = { "opencode_send", mode = { "n", "i" } },
            },
          },
        },
        actions = {
          opencode_send = function(picker)
            local opencode = require "opencode"
            local items = vim.tbl_map(function(item)
              return item.file and opencode.format { path = item.file, from = item.pos, to = item.end_pos } or item.text
            end, picker:selected { fallback = true })
            opencode.prompt(table.concat(items, ", ") .. " ")
          end,
        },
      },
      terminal = { win = { style = "terminal" } },
      styles = {
        notification = { wo = { wrap = true } },
      },
    },
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Search everywhere",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>,",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command history",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Files",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent { filter = { cwd = true } }
        end,
        desc = "Recent files",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath "config" }
        end,
        desc = "Config files",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Word or selection",
        mode = { "n", "x" },
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer lines",
      },
      {
        "<leader>sB",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep open buffers",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "File structure",
      },
      {
        "<leader>sS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Workspace symbols",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumps",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix",
      },
      {
        "<leader>sr",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume search",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo history",
      },
      {
        "<leader>sn",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notifications",
      },
      {
        "<leader>uC",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Definition",
      },
      {
        "gD",
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = "Declaration",
      },
      {
        "grr",
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = "References",
      },
      {
        "gri",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Implementations",
      },
      {
        "grt",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Type definition",
      },
      {
        "<leader>ci",
        function()
          Snacks.picker.lsp_incoming_calls()
        end,
        desc = "Incoming calls",
      },
      {
        "<leader>co",
        function()
          Snacks.picker.lsp_outgoing_calls()
        end,
        desc = "Outgoing calls",
      },
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename file",
      },
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Previous reference",
        mode = { "n", "t" },
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete buffer",
      },
      {
        "<leader>bo",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "Delete other buffers",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Open on remote",
        mode = { "n", "x" },
      },
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log_file()
        end,
        desc = "File history",
      },
      {
        "<leader>tt",
        function()
          Snacks.terminal()
        end,
        desc = "Terminal",
      },
      {
        "<C-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Terminal",
        mode = { "n", "t" },
      },
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Zen mode",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
          Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
          Snacks.toggle.option("relativenumber", { name = "Relative number" }):map "<leader>uL"
          Snacks.toggle.diagnostics():map "<leader>ud"
          Snacks.toggle.inlay_hints():map "<leader>uh"
          Snacks.toggle.treesitter():map "<leader>uT"
          Snacks.toggle.indent():map "<leader>ug"
          Snacks.toggle.dim():map "<leader>uD"
        end,
      })
    end,
  },
}
