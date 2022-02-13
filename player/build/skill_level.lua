local M = {}

local player_manager = require("gamesystem.player_manager")
M.player = player_manager.get_player()

function M.add_experience(modifier, experience)
  -- TODO
end

function M.level(modifier)
  -- TODO
  return 5
end

return M
