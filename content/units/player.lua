local M = {}

local unit_prototype_manager = require("gamesystem.unit_prototype_manager")
local player_manager = require("gamesystem.player_manager")
local player_status = require("player.player_status")
local skill_build = require("player.build.skill_build")

M.prototype = unit_prototype_manager.create()
M.prototype.icon = "_player"
M.prototype.size = 2

M.prototype.talents.size = 1
M.prototype.talents.vec = {
  player_status.Buff
}

M.prototype.post_buff_talents.size = 1
M.prototype.post_buff_talents.vec = {
  skill_build.Buff
}

--[[
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
--]]

player_manager.set_prototype(M.prototype)

skill_build.add_modifier(1, "Timeout")
skill_build.add_modifier(1, "LightningChain")

return M
