local opt = vim.opt

opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"

opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.cursorline = true
opt.signcolumn = "yes"
opt.colorcolumn = "121"
opt.laststatus = 3
opt.showmode = false
opt.ruler = false
opt.cmdheight = 1
opt.pumheight = 12
opt.pumblend = 0
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "\u{f078}", foldclose = "\u{f054}", foldsep = " ", diff = "╱" }
opt.termguicolors = true
opt.winborder = "rounded"
opt.splitkeep = "screen"
opt.smoothscroll = true
opt.shortmess:append { I = true, W = true, c = true, C = true }

opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.undolevels = 10000
opt.confirm = true
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 400
opt.updatetime = 250
opt.virtualedit = "block"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.wildmode = { "longest:full", "full" }
opt.jumpoptions = "view"
opt.sessionoptions = { "buffers", "curdir", "folds", "globals", "help", "tabpages", "winsize", "skiprtp" }
opt.spelllang = { "en_us" }
opt.formatoptions = "jcroqlnt"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
