local group = vim.api.nvim_create_augroup("aaron", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = group,
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd "checktime"
    end
  end,
})

autocmd("VimResized", {
  group = group,
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd "tabdo wincmd ="
    vim.cmd("tabnext " .. tab)
  end,
})

autocmd("BufReadPost", {
  group = group,
  callback = function(event)
    local skip = { gitcommit = true, jj = true, jjdescription = true }
    if skip[vim.bo[event.buf].filetype] or vim.b[event.buf].restored_cursor then
      return
    end
    vim.b[event.buf].restored_cursor = true
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(event.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("FileType", {
  group = group,
  pattern = { "checkhealth", "help", "lspinfo", "man", "notify", "qf", "query" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

autocmd("FileType", {
  group = group,
  pattern = { "gitcommit", "jj", "jjdescription", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd("BufWritePre", {
  group = group,
  callback = function(event)
    if event.match:match "^%w%w+:[\\/][\\/]" then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
