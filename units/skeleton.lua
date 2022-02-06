local M = {}

local unit_prototype_manager = require("gamesystem.unit_prototype_manager")

M.prototype = unit_prototype_manager.create()
M.prototype.icon = "skeleton"
M.prototype.size = 1
M.prototype.maxHp = 100

return M
