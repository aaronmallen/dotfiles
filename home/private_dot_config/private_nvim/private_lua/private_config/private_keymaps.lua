local map = vim.keymap.set

map("n", ";", ":", { desc = "Command line" })
map("i", "jk", "<Esc>")
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>")
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })

map({ "n", "i", "x" }, "<C-s>", "<cmd>write<cr><Esc>", { desc = "Save" })
map("n", "<leader>qq", "<cmd>quitall<cr>", { desc = "Quit all" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split right" })

map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Last buffer" })

map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line up" })
map("x", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move lines down" })
map("x", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move lines up" })

map("x", "<", "<gv")
map("x", ">", ">gv")

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location list" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })
