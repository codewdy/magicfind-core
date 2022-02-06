local M = {}

local unit_manager = require("gamesystem.unit_manager")

M.TIMEOUT = 1
M.HIT = 2
M.STRUCK = 3
M.KILL = 4
M.DEATH = 5

M.prototype = {}

function M.prototype.onHit(arg, unit, dest)
  if math.random() < arg.factor then
    arg.skill.cast(arg, unit, dest)
  end
end

function M.prototype.onStruck(arg, src, unit)
  if math.random() < arg.factor then
    arg.skill.cast(arg, unit, src)
  end
end

function M.prototype.onKill(arg, unit, dest)
  if math.random() < arg.factor then
    arg.skill.cast(arg, unit, dest)
  end
end

function M.prototype.onDeath(arg, unit)
  if math.random() < arg.factor then
    arg.skill.cast(arg, unit, unit_manager.random_unit(3 - unit.group))
  end
end

function M.prototype.onUpdate(arg, unit)
  if (unit.cooldown.size < arg.id) then
    for i=unit.cooldown.size,arg.id do
      unit.cooldown.vec[i] = 0
    end
    unit.cooldown.size = arg.id
  end
  unit.cooldown.vec[arg.id] = unit.cooldown.vec[arg.id] + 1
  if unit.cooldown.vec[arg.id] >= 1.0 / arg.factor then
    unit.cooldown.vec[arg.id] = 0
    arg.skill.cast(arg, unit, unit_manager.random_unit(3 - unit.group))
  end
end

function M.prototype.update(arg, unit)
  if arg.type == M.TIMEOUT then
    unit.status.onUpdate.size = unit.status.onUpdate.size + 1
    unit.status.onUpdate.vec[unit.status.onUpdate.size] = arg
  elseif arg.type == M.Hit then
    unit.status.onHit.size = unit.status.onHit.size + 1
    unit.status.onHit.vec[unit.status.onHit.size] = arg
  elseif arg.type == M.STRUCK then
    unit.status.onStruck.size = unit.status.onStruck.size + 1
    unit.status.onStruck.vec[unit.status.onStruck.size] = arg
  elseif arg.type == M.KILL then
    unit.status.onKill.size = unit.status.onKill.size + 1
    unit.status.onKill.vec[unit.status.onKill.size] = arg
  elseif arg.type == M.DEATH then
    unit.status.onDeath.size = unit.status.onDeath.size + 1
    unit.status.onDeath.vec[unit.status.onDeath.size] = arg
  end
end

function M.create(args)
  local ret = {}
  for k,v in pairs(M.prototype) do ret[k] = v end
  if args ~= nil then
    for k,v in pairs(args) do ret[k] = v end
  end
  return ret
end

return M
