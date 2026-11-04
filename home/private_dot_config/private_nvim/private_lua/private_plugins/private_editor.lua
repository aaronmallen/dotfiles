return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = { modes = { search = { enabled = false } } },
    keys = {
      {
        "s",
        function()
          require("flash").jump()
        end,
        mode = { "n", "x", "o" },
        desc = "Jump",
      },
      {
        "S",
        function()
          require("flash").treesitter()
        end,
        mode = { "n", "x", "o" },
        desc = "Select syntax node",
      },
      {
        "r",
        function()
          require("flash").remote()
        end,
        mode = "o",
        desc = "Remote jump",
      },
    },
  },
  {
    "nvim-mini/mini.surround",
    keys = {
      { "gsa", mode = { "n", "x" }, desc = "Add surrounding" },
      { "gsd", desc = "Delete surrounding" },
      { "gsr", desc = "Replace surrounding" },
      { "gsf", desc = "Find surrounding" },
      { "gsh", desc = "Highlight surrounding" },
    },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        replace = "gsr",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "nvim-mini/mini.pairs",
    event = "InsertEnter",
    opts = {
      modes = { insert = true, command = false, terminal = false },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sR",
        function()
          require("grug-far").open { transient = true }
        end,
        mode = { "n", "x" },
        desc = "Replace in files",
      },
    },
    opts = { headerMaxWidth = 80 },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Pick session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load { last = true }
        end,
        desc = "Restore last session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Skip saving session",
      },
    },
  },
}
