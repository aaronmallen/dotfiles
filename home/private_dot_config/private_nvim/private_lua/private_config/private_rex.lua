local M = {}

local session = vim.env.REX_SESSION
local block = vim.env.REX_BLOCK
local layers = {}
local last_command

function M.active()
  return session ~= nil and block ~= nil and vim.fn.executable "rex" == 1
end

local function notify_error(result)
  vim.schedule(function()
    vim.notify(
      vim.trim(result.stderr ~= "" and result.stderr or result.stdout),
      vim.log.levels.ERROR,
      { title = "Rex" }
    )
  end)
end

local function rex(args, on_done)
  vim.system(vim.list_extend({ "rex" }, args), { text = true }, function(result)
    if result.code ~= 0 then
      notify_error(result)
    elseif on_done then
      vim.schedule(function()
        on_done(result.stdout)
      end)
    end
  end)
end

local function api(method, params, on_done, on_fail)
  params.session_id = session
  vim.system(
    { "rex", "api", "call", "-s", session, method, "-" },
    { text = true, stdin = vim.json.encode(params) },
    function(result)
      vim.schedule(function()
        if result.code == 0 then
          if on_done then
            on_done(vim.json.decode(result.stdout))
          end
        elseif on_fail then
          on_fail(result)
        else
          notify_error(result)
        end
      end)
    end
  )
end

local function open_layer(name, command, bounds)
  local options = { cwd = vim.fn.getcwd() }
  if command then
    options.command = command
  end
  api("session.new_layer", {
    bounds = bounds or { 0.1, 0.08, 0.8, 0.84 },
    focus = true,
    layout = { block = { flavor = "com.superlogical.terminal.shell", label = name, options = options } },
  }, function(result)
    layers[name] = result.layer_id
  end)
end

function M.float(name, command, bounds)
  local layer = layers[name]
  if not layer then
    return open_layer(name, command, bounds)
  end
  api("session.set_layer_state", { layer_id = layer, state = "normal", focus = true }, nil, function()
    layers[name] = nil
    open_layer(name, command, bounds)
  end)
end

function M.split(command, direction, ratio, label)
  local args =
    { "split", "-s", session, "-b", block, "--split=" .. direction, "--ratio", tostring(ratio), "-c", vim.fn.getcwd() }
  if label then
    vim.list_extend(args, { "--label", label, "--keep-open" })
  end
  if command then
    table.insert(args, "--")
    vim.list_extend(args, command)
  end
  rex(args)
end

function M.run()
  vim.ui.input({ prompt = "Run in Rex: ", default = last_command }, function(input)
    if not input or input == "" then
      return
    end
    last_command = input
    M.split({ "sh", "-c", input }, "below", 30, input)
  end)
end

function M.zoom()
  rex { "zoom", block }
end

function M.navigate(direction)
  local keys = { left = "h", down = "j", up = "k", right = "l" }
  local before = vim.api.nvim_get_current_win()
  vim.cmd.wincmd(keys[direction])
  if vim.api.nvim_get_current_win() == before then
    rex { "focus", direction, "-s", session }
  end
end

function M.setup()
  if not M.active() then
    return
  end
  local map = vim.keymap.set
  for direction, key in pairs { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" } do
    map("n", key, function()
      M.navigate(direction)
    end, { desc = "Window " .. direction })
  end
  map("n", "<leader>rf", function()
    M.float "shell"
  end, { desc = "Floating shell" })
  map("n", "<leader>ro", function()
    M.float("opencode", { "opencode" })
  end, { desc = "Floating opencode" })
  map("n", "<leader>rs", function()
    M.split(nil, "below", 30)
  end, { desc = "Shell below" })
  map("n", "<leader>rv", function()
    M.split(nil, "right", 40)
  end, { desc = "Shell right" })
  map("n", "<leader>rr", M.run, { desc = "Run command" })
  map("n", "<leader>rz", M.zoom, { desc = "Zoom editor" })
end

return M
