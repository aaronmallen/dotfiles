local shell = "com.superlogical.terminal.shell"

local function check(result, err)
  if err ~= nil then
    error(err, 0)
  end
  return result
end

local function split(items, direction)
  local layout = items[#items]
  for i = #items - 1, 1, -1 do
    layout = direction(1 / (#items - i + 1), items[i], layout)
  end
  return layout
end

local function monitor_layout()
  local path = (os.getenv "XDG_CONFIG_HOME" or os.getenv "HOME" .. "/.config") .. "/rex/monitor.toml"
  local file, err = io.open(path, "r")
  if not file then
    error("Cannot read " .. path .. ": " .. err, 0)
  end
  local contents = file:read "*a"
  file:close()
  local ok, config = pcall(require("tinytoml").parse, contents, { load_from_string = true })
  if not ok then
    error(path .. ": " .. config, 0)
  end
  assert(type(config.panes) == "table" and next(config.panes), path .. ": panes must contain at least one pane")
  local panes, occupied = {}, {}
  for label, pane in pairs(config.panes) do
    assert(
      type(pane) == "table" and type(pane.command) == "string" and pane.command:match "%S",
      path .. ": " .. label .. ": command must be a nonempty string"
    )
    for _, axis in ipairs { "col", "row" } do
      local value = pane[axis]
      assert(
        type(value) == "number" and value >= 0 and value % 1 == 0,
        path .. ": " .. label .. ": " .. axis .. " must be a nonnegative integer"
      )
    end
    local position = pane.col .. ":" .. pane.row
    assert(not occupied[position], path .. ": " .. label .. ": duplicate position " .. position)
    occupied[position] = true
    pane.label = label
    panes[#panes + 1] = pane
  end
  table.sort(panes, function(a, b)
    return a.col < b.col or (a.col == b.col and a.row < b.row)
  end)
  local columns, rows, col = {}, {}, nil
  for _, pane in ipairs(panes) do
    if col ~= nil and pane.col ~= col then
      columns[#columns + 1] = split(rows, rex.layout.vertical)
      rows = {}
    end
    col = pane.col
    rows[#rows + 1] = rex.layout.block {
      flavor = shell,
      label = pane.label,
      options = { initial_input = pane.command .. "\n" },
    }
  end
  columns[#columns + 1] = split(rows, rex.layout.vertical)
  return split(columns, rex.layout.horizontal)
end

rex.action {
  name = "monitor",
  title = "Open Monitor",
  description = "Open the panes configured in ~/.config/rex/monitor.toml.",
  run = function(ctx)
    local layout = monitor_layout()
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

    local function open(label)
      if windows[label] then
        return windows[label]
      end
      return check(rex.session.new_window {
        session_id = session_id,
        window_label = label,
        focus = false,
        layout = layout,
      }).window_id
    end

    local btop = open "btop"
    check(rex.session.move_window { session_id = session_id, window_id = btop, before_window_id = rest })
    check(rex.session.focus_window { session_id = session_id, window_id = btop })
    if rest and #view.windows == 1 then
      local layers = view.windows[1].layers
      if #layers == 1 and #layers[1].blocks == 1 and layers[1].blocks[1].flavor == shell then
        check(rex.session.close_window { session_id = session_id, window_id = rest })
      end
    end
  end,
}
