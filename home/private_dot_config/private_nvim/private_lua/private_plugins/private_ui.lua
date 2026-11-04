return {
  { "nvim-tree/nvim-web-devicons", opts = {} },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>a", group = "opencode", mode = { "n", "x" } },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code", mode = { "n", "x" } },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>j", group = "jj", mode = { "n", "x" } },
        { "<leader>jb", group = "bookmark" },
        { "<leader>q", group = "session" },
        { "<leader>r", group = "rex" },
        { "<leader>s", group = "search", mode = { "n", "x" } },
        { "<leader>t", group = "terminal" },
        { "<leader>u", group = "toggle" },
        { "<leader>x", group = "problems" },
        { "<leader>w", group = "window", proxy = "<C-w>" },
        { "[", group = "previous" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround", mode = { "n", "x" } },
        { "z", group = "fold" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer keymaps",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          theme = "monokai-pro",
          globalstatus = true,
          component_separators = "",
          section_separators = { left = "\u{e0b4}", right = "\u{e0b6}" },
          disabled_filetypes = { statusline = { "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            "diagnostics",
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = " ●" } },
          },
          lualine_x = {
            { require("opencode").statusline },
            "lsp_status",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "lazy", "man", "mason", "neo-tree", "quickfix", "trouble" },
      }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned buffers" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to the left" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
    },
    opts = {
      options = {
        close_command = function(buf)
          Snacks.bufdelete(buf)
        end,
        right_mouse_command = function(buf)
          Snacks.bufdelete(buf)
        end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        separator_style = "thin",
        offsets = {
          { filetype = "neo-tree", text = "Project", highlight = "Directory", text_align = "left", separator = true },
        },
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { focus = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Problems" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Problems in file" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
      { "<leader>xr", "<cmd>Trouble lsp toggle win.position=right<cr>", desc = "LSP references" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix in Trouble" },
    },
  },
}
