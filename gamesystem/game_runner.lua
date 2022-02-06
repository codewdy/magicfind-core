local M = {}
local battle_runner = require("gamesystem.battle_runner")
local config = require("config")

M.state = {
  Init = 1,
  PathFinding = 2,
  Battle = 3,
  Death = 4
}

M.context = {
  state = M.state.Init,
}

M.processor = {
  [M.state.Init] = {
    start = function() end,
    stop = function() end,
    run = function() return M.state.PathFinding end
  },
  [M.state.PathFinding] = {
    start = function() M.context.countdown = config.path_finding_time end,
    stop = function() end,
    run = function()
      M.context.countdown = M.context.countdown - 1
      if M.context.countdown == 0 then
        return M.state.Battle
      else
        return M.state.PathFinding
      end
    end
  },
  [M.state.Battle] = {
    start = function() battle_runner.start() end,
    stop = function() battle_runner.stop() end,
    run = function()
      battle_runner.run()
      if battle_runner.player_death() then
        return M.state.Death
      end
      if battle_runner.all_clear() then
        return M.state.PathFinding
      end
      return M.state.Battle
    end
  },
  [M.state.Death] = {
    start = function() end,
    stop = function() end,
    run = function() return M.state.PathFinding end
  },
}

function M.run()
  local state = M.state.Init
  if (M.context.change_to_state ~= nil) then
    state = M.context.change_to_state
    M.context.change_to_state = nil
  else
    state = M.processor[M.context.state].run()
  end
  if state ~= M.context.state then
    M.processor[M.context.state].stop()
    M.context.state = state
    M.processor[M.context.state].start()
  end
end

return M
