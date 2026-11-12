local action, created, calls, fail
local shell = "com.superlogical.terminal.shell"
local window = { window_id = "initial", label = "shell", layers = { { blocks = { { flavor = shell } } } } }
local view = { windows = { window } }
rex = {
  action = function(value)
    action = value
  end,
  layout = {
    block = function(value)
      return value
    end,
    horizontal = function(ratio, a, b)
      return { direction = "horizontal", ratio = ratio, a = a, b = b }
    end,
    vertical = function(ratio, a, b)
      return { direction = "vertical", ratio = ratio, a = a, b = b }
    end,
  },
  session = {},
}
for _, name in ipairs { "view", "set_label", "new_window", "move_window", "focus_window", "close_window" } do
  local name = name
  rex.session[name] = function(args)
    calls[#calls + 1] = name
    if name == fail then
      return nil, "failed"
    end
    if name == "view" then
      return view
    end
    if name == "new_window" then
      created = args.layout
    end
    return { window_id = "monitor" }
  end
end
dofile "home/private_dot_config/private_rex/private_actions.lua"
local path = os.tmpname()
local open = io.open
io.open = function(filename, mode)
  if filename:match "/rex/monitor.toml$" then
    filename = path
  end
  return open(filename, mode)
end
local function run(contents, expected_error)
  os.remove(path)
  if contents then
    local file = assert(io.open(path, "w"))
    file:write(contents)
    file:close()
  end
  calls, created = {}, nil
  local ok, err = pcall(action.run, { session_id = "test" })
  if expected_error then
    assert(not ok and tostring(err):find(expected_error, 1, true), tostring(err))
    assert(#calls == 0)
  else
    assert(ok, err)
  end
end
local function pane(label, col, row, command)
  return string.format('[panes.%s]\ncommand = "%s"\ncol = %s\nrow = %s\n', label, command or "btop", col, row)
end
run(nil, "Cannot read")
run("[panes", "monitor.toml")
run("", "at least one pane")
run(pane("a", 0, 0, " "), "nonempty string")
run(pane("a", -1, 0), "nonnegative integer")
run(pane("a", 0, 0.5), "nonnegative integer")
run(pane("a", "true", 0), "nonnegative integer")
run(pane("a", 0, 0) .. pane("b", 0, 0), "duplicate position")
run(pane("local", 0, 0))
assert(created, table.concat(calls, ","))
assert(created.label == "local")
assert(calls[#calls - 1] == "focus_window" and calls[#calls] == "close_window")
run(
  pane("remote", 3, 5, "ssh missing-host custom-tui")
    .. pane("local", 0, 0)
    .. pane("middle", 1, 0)
    .. pane("bottom", 0, 5)
)
assert(created.direction == "horizontal" and created.ratio == 1 / 3)
assert(created.a.direction == "vertical" and created.a.ratio == 0.5)
assert(created.a.a.label == "local" and created.a.b.label == "bottom")
assert(created.b.ratio == 0.5 and created.b.a.label == "middle")
assert(created.b.b.options.initial_input == "ssh missing-host custom-tui\n")
view.windows = { window, window }
run(pane("local", 0, 0))
assert(calls[#calls] == "focus_window")
view.windows = { { window_id = "existing", label = "btop" } }
run(pane("local", 0, 0))
assert(created == nil and calls[#calls] == "focus_window")
os.remove(path)
io.open = open
print "monitor action checks passed"
