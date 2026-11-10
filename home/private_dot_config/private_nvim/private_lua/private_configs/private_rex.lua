local M = {}

local session = vim.env.REX_SESSION
local block = vim.env.REX_BLOCK
local layers = {}

function M.active()
  return session ~= nil and block ~= nil and vim.fn.executable "rex" == 1
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
          vim.notify(
            vim.trim(result.stderr ~= "" and result.stderr or result.stdout),
            vim.log.levels.ERROR,
            { title = "Rex" }
          )
        end
      end)
    end
  )
end

local function open_layer(name, command)
  api("session.new_layer", {
    bounds = { 0.1, 0.08, 0.8, 0.84 },
    focus = true,
    layout = {
      block = {
        flavor = "com.superlogical.terminal.shell",
        label = name,
        options = { cwd = vim.fn.getcwd(), command = command },
      },
    },
  }, function(result)
    layers[name] = result.layer_id
  end)
end

function M.float(name, command)
  local layer = layers[name]
  if not layer then
    return open_layer(name, command)
  end
  api("session.set_layer_state", { layer_id = layer, state = "normal", focus = true }, nil, function()
    layers[name] = nil
    open_layer(name, command)
  end)
end

return M
