return {
  {
    "nicolasgb/jj.nvim",
    version = "*",
    cmd = { "J", "Jdiff", "Jvdiff", "Jhdiff", "Jbrowse" },
    dependencies = { "folke/snacks.nvim", "esmuellert/codediff.nvim" },
    keys = {
      {
        "<leader>jl",
        function()
          require("jj.cmd").log()
        end,
        desc = "Log",
      },
      {
        "<leader>jL",
        function()
          require("jj.cmd").log { revisions = "'all()'" }
        end,
        desc = "Log all",
      },
      {
        "<leader>js",
        function()
          require("jj.cmd").status()
        end,
        desc = "Status",
      },
      {
        "<leader>jd",
        function()
          require("jj.cmd").describe()
        end,
        desc = "Describe",
      },
      {
        "<leader>jc",
        function()
          require("jj.cmd").commit()
        end,
        desc = "Commit",
      },
      {
        "<leader>jn",
        function()
          require("jj.cmd").new()
        end,
        desc = "New",
      },
      {
        "<leader>je",
        function()
          require("jj.cmd").edit()
        end,
        desc = "Edit",
      },
      {
        "<leader>jS",
        function()
          require("jj.cmd").squash()
        end,
        desc = "Squash",
      },
      {
        "<leader>jr",
        function()
          require("jj.cmd").rebase()
        end,
        desc = "Rebase",
      },
      {
        "<leader>ja",
        function()
          require("jj.cmd").abandon()
        end,
        desc = "Abandon",
      },
      {
        "<leader>ju",
        function()
          require("jj.cmd").undo()
        end,
        desc = "Undo",
      },
      {
        "<leader>jy",
        function()
          require("jj.cmd").redo()
        end,
        desc = "Redo",
      },
      {
        "<leader>jf",
        function()
          require("jj.cmd").fetch()
        end,
        desc = "Fetch",
      },
      {
        "<leader>jbc",
        function()
          require("jj.cmd").bookmark_create()
        end,
        desc = "Create bookmark",
      },
      {
        "<leader>jbm",
        function()
          require("jj.cmd").bookmark_move()
        end,
        desc = "Move bookmark",
      },
      {
        "<leader>jbd",
        function()
          require("jj.cmd").bookmark_delete()
        end,
        desc = "Delete bookmark",
      },
      {
        "<leader>jv",
        function()
          require("jj.diff").open_vdiff()
        end,
        desc = "Diff file",
      },
      {
        "<leader>jp",
        function()
          require("jj.picker").status()
        end,
        desc = "Changed files",
      },
      {
        "<leader>jh",
        function()
          require("jj.picker").file_history()
        end,
        desc = "File history",
      },
      {
        "<leader>jx",
        function()
          require("jj.picker").conflict()
        end,
        desc = "Conflicts",
      },
      {
        "<leader>jX",
        function()
          require("jj.picker").conflict_sections()
        end,
        desc = "Conflict sections",
      },
      {
        "<leader>jB",
        function()
          require("jj.cmd").annotate()
        end,
        desc = "Annotate file",
      },
      { "<leader>jo", "<cmd>Jbrowse<cr>", mode = { "n", "x" }, desc = "Open on remote" },
    },
    opts = {
      diff = { backend = "codediff" },
      cmd = {
        describe = {
          editor = {
            type = "buffer",
            keymaps = { close = { "q", "<C-c>" } },
          },
        },
      },
    },
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Review changes" },
    },
    opts = {},
  },
}
