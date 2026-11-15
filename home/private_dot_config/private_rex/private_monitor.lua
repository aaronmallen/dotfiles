local function check(result, err)
  if err ~= nil then
    error(err, 0)
  end
  return result
end

local sessions = {}
for _, session in ipairs(check(rex.call "session.list").sessions) do
  sessions[session.session_id] = true
end

rex.on("client_connected", function(ctx, ev)
  if ev.client_id ~= rex.args.client_id or sessions[ctx.session_id] then
    return
  end
  sessions[ctx.session_id] = true
  local session = check(rex.call("session.view", { session_id = ctx.session_id }))
  assert(#session.windows == 1, "Expected one starter tab in the new monitor session")
  check(rex.call("session.new_window", {
    session_id = ctx.session_id,
    window_label = "monitor",
    layout = rex.args.layout,
  }))
  check(rex.call("session.set_label", { session_id = ctx.session_id, label = "monitor" }))
  check(rex.call("session.close_window", {
    session_id = ctx.session_id,
    window_id = session.windows[1].window_id,
  }))
  rex.stop()
end)

rex.after(10, function()
  error "Rex did not attach the new monitor window within 10 seconds"
end)
rex.client.queue "client.window.new"
