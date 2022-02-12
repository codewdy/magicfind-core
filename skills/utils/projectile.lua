local M = {}

--[[
--  local projectile = require("skills.utils.projectile")
--  local context = projectile.create()
--  context.recycle_callback = ...  -- optional
--  context.shoot = ...
--  context.hit = ...
--  context.source = ...
--  context.target = ...
--  context.count = ...
--  context.cast(projectile)
--]]

local task_runner = require("gamesystem.task_runner")
local unit_manager = require("gamesystem.unit_manager")
local object_pool = require("gamesystem.object_pool")

M.default_radius = 5

M.prototype = {}

function M.prototype.run(context)
  context.hit(context, context.source, context.target)
  context.count = context.count - 1
  if context.count > 0 then
    local new_target = unit_manager.random_nearby_unit(
        context.target, context.target.group, context.radius, false)
    if new_target == nil then
      context.recycle(context)
      return
    end
    local delay = context.shoot(context, context.target, new_target)
    context.target = new_target
    if delay ~= nil and delay > 0 then
      task_runner.schedule(delay, context)
    else
      context.recycle(context)
    end
  else
    context.recycle(context)
  end
end

function M.prototype.abort(context)
  context.recycle(context)
end

function M.prototype.recycle(context)
  if context.recycle_callback ~= nil then
    context.recycle_callback(context)
  end
  M.object_pool.recycle(context)
end

function M.prototype.cast(context)
  local delay = context.shoot(context, context.source, context.target)
  if delay ~= nil and delay > 0 then
    task_runner.schedule(delay, context)
  else
    context.recycle(context)
  end
end

function M.obj_create()
  return {
    run = M.prototype.run,
    abort = M.prototype.abort,
    cast = M.prototype.cast,
    recycle = M.prototype.recycle,
    radius = M.default_radius
  }
end

function M.obj_recycle(context)
  context.recycle_callback = nil
  context.shoot = nil
  context.hit = nil
  context.source = nil
  context.target = nil
  context.count = nil
  context.radius = M.default_radius
end

M.object_pool = object_pool.create(M.obj_create, M.obj_recycle)

function M.create()
  return M.object_pool.get()
end

return M
