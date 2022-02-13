--[[
player_status = {
  strength = {
    flat = 0.0,
    factor = 1.0,
    additionFactor = 1.0
  },
  intelligence = {
    flat = 0.0,
    factor = 1.0,
    additionFactor = 1.0
  },
  agility = {
    flat = 0.0,
    factor = 1.0,
    additionFactor = 1.0
  },
  skill_level_modifier = {
    "all": ...,
    ...
  },
  max_skill_line = 5,
  max_skill_resource = 100,
}

M.clear_status(player)
--]]

local M = {}

local buff_manager = require("gamesystem.buff_manager")

function M.clear_status(player)
  player.status.player_status = {
    strength = {
      flat = 0.0,
      factor = 1.0,
      additionFactor = 1.0
    },
    intelligence = {
      flat = 0.0,
      factor = 1.0,
      additionFactor = 1.0
    },
    agility = {
      flat = 0.0,
      factor = 1.0,
      additionFactor = 1.0
    },
    skill_level_modifier = {
    },
    max_skill_line = 5,
    max_skill_resource = 100,
  }
end

function M.buff_update_status(_, player)
  M.clear_status(player)
end

M.Buff = buff_manager.create_buff({
  updateStatus = M.buff_update_status
})

return M
