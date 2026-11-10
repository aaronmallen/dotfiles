local shell = "com.superlogical.terminal.shell"

local function check(result, err)
  if err ~= nil then
    error(err, 0)
  end
  return result
end

rex.action {
  name = "monitor",
  title = "Open Monitor",
  description = "Rename the session to monitor, with btop in its first tab.",
  run = function(ctx)
    local session_id = ctx.session_id
    local view = check(rex.session.view { session_id = session_id })
    check(rex.session.set_label { session_id = session_id, label = "monitor" })

    local windows, rest = {}, nil
    for _, window in ipairs(view.windows or {}) do
      if window.label == "btop" then
        windows[window.label] = windows[window.label] or window.window_id
      elseif rest == nil then
        rest = window.window_id
      end
    end

    local function open(label, command)
      if windows[label] then
        return windows[label]
      end
      return check(rex.session.new_window {
        session_id = session_id,
        window_label = label,
        focus = false,
        layout = rex.layout.block { flavor = shell, options = { initial_input = command .. "\n" } },
      }).window_id
    end

    local btop = open("btop", "btop")
    check(rex.session.move_window { session_id = session_id, window_id = btop, before_window_id = rest })
    check(rex.session.focus_window { session_id = session_id, window_id = btop })
  end,
}
