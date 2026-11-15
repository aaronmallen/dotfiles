local action, created, calls, connected
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
    calls[#calls + 1] = method
    if method == "session.list" then
      return { sessions = { { session_id = "test" } } }
    end
    assert(args.session_id == "session-" .. windows)
    if method == "session.view" then
      return { windows = { { window_id = "starter-" .. windows } } }
    elseif method == "session.new_window" then
      assert(args.window_label == "monitor")
      created = args.layout
    elseif method == "session.set_label" then
      assert(args.label == "monitor")
    elseif method == "session.close_window" then
      assert(created and args.window_id == "starter-" .. windows)
    else
      error("Unexpected call: " .. method)
    end
    return {}
  end,
  json = {
    encode = function(value)
      return value
    end,
  },
  exec = function(argv)
    assert(
      argv[1]
        == os.getenv "HOME"
          .. "/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex"
    )
    assert(argv[2] == "-C" and argv[3] == "app")
    assert(argv[5]:match "/rex/monitor.lua$")
    rex.args = argv[#argv]
    dofile "home/private_dot_config/private_rex/private_monitor.lua"
    return { ok = true }
  end,
  on = function(event, callback)
    assert(event == "client_connected")
    connected = callback
  end,
  after = function() end,
  stop = function() end,
  client = {
    queue = function(name)
      assert(name == "client.window.new")
      calls[#calls + 1] = name
      windows = windows + 1
      connected({ session_id = "test" }, { client_id = "app" })
      connected({ session_id = "unrelated" }, { client_id = "other-app" })
      connected({ session_id = "session-" .. windows }, { client_id = "app" })
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
  local ok, err = pcall(action.run, { session_id = "test", client_id = "app" })
  if expected_error then
    assert(not ok and tostring(err):find(expected_error, 1, true), tostring(err))
    assert(#calls == 0)
  else
    assert(ok, err)
    assert(
      table.concat(calls, ",")
        == "session.list,client.window.new,session.view,session.new_window,session.set_label,session.close_window"
    )
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
