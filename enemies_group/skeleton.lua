local M = {}

local enemy_manager = require("gamesystem.enemy_manager")

local skeleton = require("units.skeleton")

enemy_manager.add_enemies_group({
  { prototype = skeleton.prototype, size = 100 }
}, 1)

return M
