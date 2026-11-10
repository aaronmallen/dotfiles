local rex = require "configs.rex"

local terminal = {
  win = { position = "right", width = 0.4, enter = false },
}

local function toggle()
  if rex.active() then
    rex.float("opencode", { "opencode" })
  else
    require("snacks.terminal").toggle("opencode", terminal)
  end
end

return {
  {
    "nickjvandyke/opencode.nvim",
    dependencies = { "folke/snacks.nvim" },
    keys = {
      {
        "<leader>aa",
        function()
          require("opencode").ask "@this: "
        end,
        mode = { "n", "x" },
        desc = "Ask",
      },
      {
        "<leader>as",
        function()
          require("opencode").select()
        end,
        mode = { "n", "x" },
        desc = "Prompts and commands",
      },
      { "<leader>at", toggle, desc = "Toggle opencode" },
      { "<C-.>", toggle, mode = { "n", "t" }, desc = "Toggle opencode" },
      {
        "go",
        function()
          return require("opencode").operator "@this"
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Send to opencode",
      },
      {
        "goo",
        function()
          return require("opencode").operator "@this" .. "_"
        end,
        expr = true,
        desc = "Send line to opencode",
      },
    },
    init = function()
      vim.g.opencode_opts = {
        server = {
          start = function()
            if rex.active() then
              rex.float("opencode", { "opencode" })
            else
              require("snacks.terminal").open("opencode", terminal)
            end
          end,
        },
      }
      vim.api.nvim_create_autocmd("User", {
        pattern = "OpencodeEvent:session.execution.started",
        callback = function()
          if rex.active() then
            return
          end
          local win = require("snacks.terminal").get("opencode", { create = false })
          if win then
            win:show()
          end
        end,
      })
    end,
  },
}
