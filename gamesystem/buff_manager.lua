local M = {}

local object_pool = require("gamesystem.object_pool")

function M.create_buff_type(args)
  L = {}
  function L.update(buff, unit)
    if buff.updateStatus ~= nil then
      buff.updateStatus(buff, unit)
    end
    if buff.onHit ~= nil then
      unit.status.onHit.size = unit.status.onHit.size + 1
      unit.status.onHit.vec[unit.status.onHit.size] = buff
    end
    if buff.onStruck ~= nil then
      unit.status.onStruck.size = unit.status.onStruck.size + 1
      unit.status.onStruck.vec[unit.status.onStruck.size] = buff
    end
    if buff.onKill ~= nil then
      unit.status.onKill.size = unit.status.onKill.size + 1
      unit.status.onKill.vec[unit.status.onKill.size] = buff
    end
    if buff.onDeath ~= nil then
      unit.status.onDeath.size = unit.status.onDeath.size + 1
      unit.status.onDeath.vec[unit.status.onDeath.size] = buff
    end
    if buff.onUpdate ~= nil then
      unit.status.onUpdate.size = unit.status.onUpdate.size + 1
      unit.status.onUpdate.vec[unit.status.onUpdate.size] = buff
    end
  end
  function L.obj_new()
    local buff = {
      update = L.update,
      updateStatus = args.updateStatus,
      onHit = args.onHit,
      onStruck = args.onStruck,
      onKill = args.onKill,
      onDeath = args.onDeath,
      onUpdate = args.onUpdate,
      recycle = L.object_pool.recycle
    }
    if args.init ~= nil then
      args.init(buff)
    end
    return buff
  end
  function L.obj_recycle(buff)
    if args.recycle ~= nil then
      args.recycle(buff)
    end
    if args.init ~= nil then
      args.init(buff)
    end
  end
  L.object_pool = object_pool.create(L.obj_new, M.obj_recycle)
  return L.object_pool.get
end

function M.create_buff(args)
  return M.create_buff_type(args)()
end

return M
