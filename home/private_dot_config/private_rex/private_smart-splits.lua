local data = os.getenv "XDG_DATA_HOME" or os.getenv "HOME" .. "/.local/share"
local plugin = loadfile(data .. "/nvim/lazy/smart-splits-backend-rex/rex/lua/smart-splits-rex/init.lua")

if plugin then
  plugin().setup {}
  for key, direction in pairs { h = "left", j = "down", k = "up", l = "right" } do
    rex.bind("ctrl+" .. key, "smart_splits_focus", { direction = direction, key = "ctrl+" .. key })
    rex.bind("alt+" .. key, "smart_splits_resize", { direction = direction, key = "alt+" .. key })
  end
end
