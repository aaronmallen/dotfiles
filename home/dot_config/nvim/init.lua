local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('loctvl842/monokai-pro.nvim')

vim.call('plug#end')

vim.cmd('silent! colorscheme monokai-pro')

require("monokai-pro").setup({
  filter = "classic"
})
