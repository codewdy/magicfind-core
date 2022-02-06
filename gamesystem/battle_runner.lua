local unit_manager = require("gamesystem.unit_manager")
local task_runner = require("gamesystem.task_runner")

local M = {}

function M.start()
  unit_manager.init()
end

function M.stop()
  unit_manager.abort()
  task_runner.abort()
end

function M.run()
  unit_manager.run()
  task_runner.run()
  unit_manager.death_check()
end

function M.all_clear()
  return unit_manager.all_clear()
end

function M.player_death()
  return unit_manager.player_death()
end

return M
