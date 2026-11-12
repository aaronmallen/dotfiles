local action, created, calls
local windows = 0
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
  call = function(method, args)
    assert(method == "session.create" and args.label == "monitor" and args.session_id == nil)
    assert(#args.initial_windows == 1 and args.initial_windows[1].window_label == "monitor")
    calls[#calls + 1] = method
    created = args.initial_windows[1].layout
    windows = windows + 1
    return {
      session_id = "session-" .. windows,
      initial_windows = { { window_id = "monitor-" .. windows } },
    }
  end,
  client = {
    queue = function(name, args)
      calls[#calls + 1] = name
      if name == "session.select" then
        assert(args.session_id == "session-" .. windows and args.window_id == "monitor-" .. windows)
      end
    end,
  },
}
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
    assert(table.concat(calls, ",") == "session.create,session.select,client.tab.move_to_new_window")
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
run(pane("local", 0, 0))
run(pane("local", 0, 0))
assert(windows == 4)
os.remove(path)
io.open = open
print "monitor action checks passed"
