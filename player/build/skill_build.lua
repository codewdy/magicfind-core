--[[

-- For CAPI
M.reset()
M.add_modifier(idx, name)
M.remove_modifier(idx, name)
M.reset_line(idx)
M.line_size()
M.get_max_line()
M.line_arg(idx, arg)
M.line_modifiers(idx)
M.line_resource(idx)
M.get_enable_lines(result)
M.get_resource()
M.get_resource_max()

-- For Player
M.update_skills()
--]]

local M = {}

local skill_modifier = require("player.skill_modifier")
local buff_manager = require("gamesystem.buff_manager")
local skill_arg = require("gamesystem.skill_arg")
local skill_level = require("player.build.skill_level")
local player_manager = require("gamesystem.player_manager")

M.player = player_manager.get_player()
M.player.modifiers = { size = 0, vec = {} }
M.modifiers = M.player.modifiers

function M.reset()
  M.modifiers.size = 0
end

function M.resize_to(idx)
  if idx > M.modifiers.size then
    for i=M.modifiers.size + 1,idx do
      if M.modifiers.vec[i] == nil then
        M.modifiers.vec[i] = {
          trigger = nil,
          caster = nil,
          supporter = { size = 0, vec = {} }
        }
      else
        M.modifiers.vec[i].trigger = nil
        M.modifiers.vec[i].caster = nil
        M.modifiers.vec[i].supporter.size = 0
      end
    end
    M.modifiers.size = idx
  end
end

function M.add_modifier(idx, name)
  M.resize_to(idx)
  local modifier = skill_modifier.get(name)
  if modifier == nil then
    error("modifier is not found.")
  end
  if modifier.type == skill_modifier.TRIGGER then
    M.modifiers.vec[idx].trigger = modifier
  elseif modifier.type == skill_modifier.CASTER then
    M.modifiers.vec[idx].caster = modifier
  elseif modifier.type == skill_modifier.SUPPORTER then
    local supporter = M.modifiers.vec[idx].supporter
    for i=1,supporter.size do
      if supporter.vec[i] == modifier then
        -- modifier is already inserted.
        return
      end
    end
    supporter.size = supporter.size + 1
    supporter.vec[supporter.size] = modifier
  else
    error("unknown modifier.")
  end
end

function M.remove_modifier(idx, name)
  M.resize_to(idx)
  local modifier = skill_modifier.get(name)
  if modifier == nil then
    error("modifier is not found.")
  end
  if modifier.type == skill_modifier.TRIGGER then
    if M.modifiers.vec[idx].trigger == modifier then
      M.modifiers.vec[idx].trigger = nil
    end
  elseif modifier.type == skill_modifier.CASTER then
    if M.modifiers.vec[idx].caster == modifier then
      M.modifiers.vec[idx].caster = nil
    end
  elseif modifier.type == skill_modifier.SUPPORTER then
    local supporter = M.modifiers.vec[idx].supporter
    local k = 0
    for i=1,supporter.size do
      if supporter.vec[i] == modifier then
        k = i
        break
      end
    end
    if k > 0 then
      for i=k,supporter.size-1 do
        supporter.vec[i] = supporter.vec[i + 1]
      end
      supporter.size = supporter.size - 1
    end
  else
    error("unknown modifier.")
  end
end

function M.reset_line(idx)
  M.resize_to(idx)
  M.modifiers.vec[idx].trigger = nil
  M.modifiers.vec[idx].caster = nil
  M.modifiers.vec[idx].supporter.size = 0
end

function M.line_size()
  return M.modifiers.size
end

function M.get_max_line()
  return M.player.status.player_status.max_skill_line
end

function M.line_arg(idx, arg)
  M.reset_line(idx)
  skill_modifier.reset_arg(arg)
  local modifier = M.modifiers[idx]
  if modifier.trigger ~= nil then
    modifier.trigger.modify(
        skill_level.level(M.player, modifier.trigger), arg)
  end
  if modifier.caster ~= nil then
    modifier.caster.modify(
        skill_level.level(M.player, modifier.caster), arg)
  end
  for i = 1,modifier.supporter.size do
    modifier.supporter.vec[i].modify(
        skill_level.level(M.player, modifier.supporter.vec[i]), arg)
  end
end

function M.line_modifiers(idx)
  M.reset_line(idx)
  return M.modifiers[idx]
end

function M.line_resource(idx)
  M.reset_line(idx)
  local resource = 1
  if M.modifiers[idx].trigger ~= nil then
    resource = resource * M.modifiers[idx].trigger.resource
  end
  if M.modifiers[idx].caster ~= nil then
    resource = resource * M.modifiers[idx].caster.resource
  end
  for i = 1,M.modifiers[idx].supporter.size do
    resource = resource * M.modifiers[idx].supporter.vec[i].resource
  end
end

function M.get_enable_lines(result)
  result.size = 0
  local resource = 0
  M.reset_line(M.get_max_line())
  for i=1,M.get_max_line() do
    if M.modifiers[i].trigger ~= nil and M.modifiers[i].caster ~= nil then
      resource = resource + M.line_resource(i)
      if resource > M.get_max_resource() then
        return
      end
      result.size = result.size + 1
      result.vec[result.size] = i
    end
  end
end

function M.get_resource()
  M.reset_line(M.get_max_line())
  local resource = 0
  for i=1,M.get_max_line() do
    if M.modifiers[i].trigger ~= nil and M.modifiers[i].caster ~= nil then
      resource = resource + M.line_resource(i)
    end
  end
end

function M.get_max_resource()
  return M.player.status.player_status.max_skill_resource
end

-- for optimization, do not use other apis
function M.update_skills()
  M.reset_line(M.get_max_line())
  local resource = 0
  local skills = M.player.prototype.skills
  skills.size = 0
  for i=1,M.get_max_line() do
    local modifier = M.modifiers.vec[i]
    if modifier.trigger ~= nil and modifier.caster ~= nil then
      local line_resource = modifier.trigger.resource * modifier.caster.resource
      for j=1,modifier.supporter.size do
        line_resource = line_resource * modifier.supporter.vec[j].resource
      end
      resource = resource + line_resource
      if resource > M.player.status.player_status.max_skill_resource then
        return
      end
      skills.size = skills.size + 1
      if skills.vec[skills.size] == nil then
        skills.vec[skills.size] = skill_arg.create({})
      end
      skill_modifier.reset_arg(skills.vec[skills.size])

      modifier.trigger.modify(
          skill_level.level(modifier.trigger),
          skills.vec[skills.size])
      modifier.caster.modify(
          skill_level.level(modifier.caster),
          skills.vec[skills.size])
      for j = 1,modifier.supporter.size do
        modifier.supporter.vec[j].modify(
            skill_level.level(modifier.supporter.vec[j]),
            skills.vec[skills.size])
      end
    end
  end
end

function M.buff_update_status(buff, player)
  M.update_skills()
end

M.Buff = buff_manager.create_buff({
  updateStatus = M.buff_update_status
})

return M
