local M = {}

local unit_module = require("gamesystem.unit")

function M.get_player()
  if M.player == nil then
    M.player = unit_module.create(M.prototype)
  end
  return M.player
end

function M.set_prototype(prototype)
  M.prototype = prototype
end

return M
