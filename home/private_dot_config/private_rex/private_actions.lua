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
  description = "Open ~/.config/rex/monitor.toml in a new monitor session and window.",
  run = function()
    local layout = monitor_layout()
    local session = check(rex.call("session.create", {
      label = "monitor",
      initial_windows = { { window_label = "monitor", layout = layout } },
    }))
    rex.client.queue("session.select", {
      session_id = session.session_id,
      window_id = session.initial_windows[1].window_id,
    })
    rex.client.queue "client.tab.move_to_new_window"
  end,
}
