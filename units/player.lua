local M = {}

local unit_prototype_manager = require("gamesystem.unit_prototype_manager")
local player_manager = require("gamesystem.player_manager")

M.prototype = unit_prototype_manager.create()
M.prototype.icon = "_player"
M.prototype.size = 2

local lightning_chain = require("skills.lightning_chain")
local skill_arg = require("gamesystem.skill_arg")
M.prototype.skills.size = 1
M.prototype.skills.vec[1] = skill_arg.create({
  type = skill_arg.TIMEOUT,
  skill = lightning_chain,
  factor = 0.02,
  id = 1
})

player_manager.set_prototype(M.prototype)

return M
