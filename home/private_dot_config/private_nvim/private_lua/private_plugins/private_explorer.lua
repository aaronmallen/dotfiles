return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File tree" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal file in tree" },
      { "<leader>ge", "<cmd>Neotree float git_status<cr>", desc = "Changed files" },
      { "<leader>be", "<cmd>Neotree float buffers<cr>", desc = "Buffer tree" },
    },
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("aaron_neotree_start", { clear = true }),
        callback = function()
          local arg = vim.fn.argv(0)
          if vim.fn.argc() == 0 or (arg ~= "" and vim.fn.isdirectory(arg) == 1) then
            vim.schedule(function()
              vim.cmd "Neotree show"
            end)
          end
        end,
      })
    end,
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      source_selector = {
        winbar = true,
        sources = {
          { source = "filesystem" },
          { source = "buffers" },
          { source = "git_status" },
          { source = "document_symbols" },
        },
      },
      open_files_do_not_replace_types = { "terminal", "trouble", "qf", "opencode_terminal" },
      default_component_configs = {
        indent = { with_expanders = true },
      },
      window = {
        position = "left",
        width = 36,
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["Y"] = {
            function(state)
              local path = state.tree:get_node():get_id()
              vim.fn.setreg("+", path)
              vim.notify("Copied " .. path)
            end,
            desc = "Copy path",
          },
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = { ".git", ".jj", ".DS_Store" },
          never_show = { ".DS_Store" },
        },
      },
      document_symbols = { follow_cursor = true },
    },
    config = function(_, opts)
      local events = require "neo-tree.events"
      local function renamed(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end
      opts.event_handlers = {
        { event = events.FILE_MOVED, handler = renamed },
        { event = events.FILE_RENAMED, handler = renamed },
      }
      require("neo-tree").setup(opts)
    end,
  },
}
