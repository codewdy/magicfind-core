local M = {}
local elements = require("gamesystem.elements")
local object_pool = require("gamesystem.object_pool")
local skill_runner = require("gamesystem.skill_runner")

function M.obj_new()
  local unit = {
    maxHp = 1,
    hp = 1,
    death = false,
    posX = 0,
    posY = 0,
    group = 1,
    buffs = {},
    cooldown = {
      size = 0,
      vec = {}
    },
    status = {
      maxHp = {
        flat = 1.0,
        factor = 1.0,
        additionFactor = 1.0
      },
      onHit = {size = 0, vec = {}},
      onStruck = {size = 0, vec = {}},
      onKill = {size = 0, vec = {}},
      onDeath = {size = 0, vec = {}},
      onUpdate = {size = 0, vec = {}},
      elements = {}
    },
  }
  for _,ele in ipairs(elements.Elements) do
    unit.status.elements[ele] = {
      damage = {
        flat = 0.0,
        factor = 1.0,
        additionFactor = 1.0
      },
      flat_damage_reducer = {
        flat = 0.0,
        factor = 1.0,
        additionFactor = 1.0
      }
    }
  end
  return unit
end

function M.obj_recycle(unit)
  unit.maxHp = 1
  unit.hp = 1
  unit.death = false
  unit.cooldown.size = 0
  for _,buff in pairs(unit.buffs) do
    buff.recycle(buff)
  end
  unit.buffs = {}
end

M.object_pool = object_pool.create(M.obj_new, M.obj_recycle)

function M.create(prototype)
  local ret = M.object_pool.get()
  ret.prototype = prototype
  ret.maxHp = prototype.maxHp
  ret.hp = prototype.maxHp
  return ret
end

function M.recycle(unit)
  M.object_pool.recycle(unit)
end

function M.reset_status(unit)
  local status = unit.status

  status.maxHp.flat = unit.prototype.maxHp
  status.maxHp.factor = 1.0
  status.maxHp.additionFactor = 1.0

  status.onHit.size = 0
  status.onStruck.size = 0
  status.onKill.size = 0
  status.onDeath.size = 0
  status.onUpdate.size = 0

  for _,ele in ipairs(elements.Elements) do
    local element = status.elements[ele]
    element.damage.flat = unit.prototype.damage
    element.damage.factor = 1.0
    element.damage.additionFactor = 1.0

    element.flat_damage_reducer.flat = unit.prototype.flat_damage_reducer
    element.flat_damage_reducer.factor = 1.0
    element.flat_damage_reducer.additionFactor = 1.0
  end
end

function M.update(unit)
  M.reset_status(unit)
  for i=1,unit.prototype.talents.size do
    unit.prototype.talents.vec[i].update(unit.prototype.talents.vec[i], unit)
  end
  for _,buff in pairs(unit.buffs) do
    buff.update(buff, unit)
  end
  for i=1,unit.prototype.post_buff_talents.size do
    unit.prototype.post_buff_talents.vec[i].update(unit.prototype.post_buff_talents.vec[i], unit)
  end
  skill_runner.update(unit)
  for i=1,unit.status.onUpdate.size do
    unit.status.onUpdate.vec[i].onUpdate(unit.status.onUpdate.vec[i], unit)
  end
end

function M.struck(source, dest)
  for i=1,dest.status.onStruck.size do
    dest.status.onStruck.vec[i].onStruck(dest.status.onStruck.vec[i], source, dest)
  end
end

function M.hit(source, dest)
  for i=1,source.status.onHit.size do
    source.status.onHit.vec[i].onHit(source.status.onHit.vec[i], source, dest)
  end
end

function M.kill(source, dest)
  for i=1,source.status.onKill.size do
    source.status.onKill.vec[i].onKill(source.status.onKill.vec[i], source, dest)
  end
end

function M.death(unit)
  for i=1,unit.status.onDeath.size do
    unit.status.onDeath.vec[i].onDeath(unit.status.onDeath.vec[i], unit)
  end
end

return M
