local M = {}

local enemy_manager = require("gamesystem.enemy_manager")
local player_manager = require("gamesystem.player_manager")
local unit_module = require("gamesystem.unit")

function M.init()
  M.units = {
    { player_manager.get_player() },
    enemy_manager.create_enemies()
  }
  M.player = M.units[1][1]
  M.enemies = M.units[2]

  M.player.group = 1
  M.player.id = 1
  for id,unit in ipairs(M.enemies) do
    unit.group = 2
    unit.id = id + 1
  end
  M.alive_units = {{}, {}}
  M.nearby_alive_units = {{}, {}}
end

function M.run()
  M.prepare_alive_units()
  if not M.player.death then
    unit_module.update(M.player)
  end
  for _,unit in ipairs(M.enemies) do
    if not unit.death then
      unit_module.update(unit)
    end
  end
end

function M.abort()
  for _,unit in ipairs(M.enemies) do
    unit_module.recycle(unit)
  end
end

function M.death_check()
  if M.player.hp <= 0 and not M.player.death then
    unit_module.death(M.player)
    M.player.death = true
  end
  for _,unit in ipairs(M.enemies) do
    if unit.hp <= 0 and not unit.death then
      unit_module.kill(M.player, unit)
      unit_module.death(unit)
      unit.death = true
    end
  end
end

function M.prepare_alive_units()
  for group = 1,2 do
    local alive_units = M.alive_units[group]
    for i,_ in ipairs(alive_units) do alive_units[i] = nil end
    for _,i in ipairs(M.units[group]) do
      table.insert(alive_units, i)
    end
  end
  M.prepare_nearby_units(M.player)
  for _,enemy in ipairs(M.enemies) do
    M.prepare_nearby_units(enemy)
  end
end

function M.nearby_sort_function(a, b)
  return ((M._posX - a.posX) * (M._posX - a.posX) +
  (M._posY - a.posY) * (M._posY - a.posY)) <
  ((M._posX - b.posX) * (M._posX - b.posX) +
  (M._posY - b.posY) * (M._posY - b.posY))
end

function M.prepare_nearby_units(unit)
  for group = 1,2 do
    if M.nearby_alive_units[group][unit.id] == nil then
      M.nearby_alive_units[group][unit.id] = {}
    end
    local nearby_alive_units = M.nearby_alive_units[group][unit.id]
    for i,_ in ipairs(nearby_alive_units) do nearby_alive_units[i] = nil end
    M._posX = unit.posX
    M._posY = unit.posY
    for i,u in ipairs(M.alive_units[group]) do nearby_alive_units[i] = u end
    table.sort(nearby_alive_units, M.nearby_sort_function)
  end
end

function M.random_unit(group)
  if #M.alive_units[group] == 0 then
    return M.units[group][1]
  end
  return M.alive_units[group][math.random(#M.alive_units[group])]
end

function M.random_nearby_unit(unit, group, radius, with_source)
  local size = #M.nearby_alive_units[group][unit.id]
  for i,u in ipairs(M.nearby_alive_units[group][unit.id]) do
    if ((unit.posX - u.posX) * (unit.posX - u.posX) +
        (unit.posY - u.posY) * (unit.posY - u.posY)) > (radius * radius) then
      size = i - 1
      break
    end
  end
  if (unit.group == group) and (not with_source) then
    if size <= 1 then
      return nil
    else
      return M.nearby_alive_units[group][unit.id][math.random(size - 1) + 1]
    end
  else
    if size == 0 then
      return nil
    else
      return M.nearby_alive_units[group][unit.id][math.random(size)]
    end
  end
end

function M.all_clear()
  for _,unit in ipairs(M.enemies) do
    if not unit.death then
      return false
    end
  end
  return true
end

function M.player_death()
  return M.player.death
end

return M
