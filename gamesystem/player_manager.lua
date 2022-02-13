local M = {}

local unit_module = require("gamesystem.unit")
local unit_prototype_manager = require("gamesystem.unit_prototype_manager")

M.prototype = unit_prototype_manager.create()
M.player = unit_module.create(M.prototype)

function M.get_player()
  return M.player
end

function M.set_prototype(prototype)
  M.prototype = prototype
  M.player.prototype = prototype
end

return M
