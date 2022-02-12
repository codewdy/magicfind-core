local M = {}

local unit_prototype_manager = require("gamesystem.unit_prototype_manager")
local player_manager = require("gamesystem.player_manager")

M.prototype = unit_prototype_manager.create()
M.prototype.icon = "_player"
M.prototype.size = 2

local lightning_chain = require("skills.lightning_chain")
local skill_arg = require("gamesystem.skill_arg")
M.prototype.skills.size = 10
for i=1,M.prototype.skills.size do
M.prototype.skills.vec[i] = skill_arg.create({
  type = skill_arg.TIMEOUT,
  skill = lightning_chain,
  factor = 1,
  id = i
})
end

player_manager.set_prototype(M.prototype)

return M
