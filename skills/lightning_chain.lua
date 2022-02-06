local M = {}

local effect_manager = require("gamesystem.effect_manager")
local effects = require("effects")
local unit_manager = require("gamesystem.unit_manager")

function M.cast(arg, unit, target)
  local src = unit
  local dest = target
  for i=1,10 do
    effect_manager.add_effect(effects.lightning,
    src.posX, src.posY, dest.posX, dest.posY, 10)
    src = dest
    dest = unit_manager.random_nearby_unit(src, target.group, 5, false)
  end
end

return M
