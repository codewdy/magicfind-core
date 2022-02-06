local M = {}

local json = require("json")

M.dict = {}

function M.create(type, config)
  local handle = #M.dict + 1
  M.dict[handle] = {
    type = type,
    config = json.dump(config)
  }
  return handle
end

function M.get(handle)
  return M.dict[handle]
end

return M
