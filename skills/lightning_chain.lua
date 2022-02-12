local M = {}

local effect_manager = require("gamesystem.effect_manager")
local effects = require("effects")
local unit_manager = require("gamesystem.unit_manager")
local projectile = require("skills.utils.projectile")

function M.shoot(context, src, dest)
  effect_manager.add_effect(effects.lightning,
      src.posX, src.posY, dest.posX, dest.posY, 12)
  return 3
end

function M.hit(context, src, dest)
  dest.hp = dest.hp - 0
end

function M.cast(arg, unit, target)
  local context = projectile.create()
  context.shoot = M.shoot
  context.hit = M.hit
  context.source = unit
  context.target = target
  -- Mock
  context.target = unit_manager.random_unit(2)
  context.arg = arg
  context.count = 5
  context.cast(context)
end

return M
