require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>qq", "<cmd>quitall<cr>", { desc = "Quit all" })

if require("configs.rex").active() then
  local splits = require "smart-splits"
  for key, direction in pairs { h = "left", j = "down", k = "up", l = "right" } do
    map("n", "<C-" .. key .. ">", splits["move_cursor_" .. direction], { desc = "Move " .. direction })
    map("n", "<A-" .. key .. ">", splits["resize_" .. direction], { desc = "Resize " .. direction })
  end
end
