local M = {}

local player_manager = require("gamesystem.player_manager")
local unit_module = require("gamesystem.unit")
local config = require("config")

local pi = 3.1415926

M.enemies_group = {
}

function M.randomLocation(unit)
  local alpha = math.random() * pi * 2
  local beta_min = unit.prototype.size + player_manager.prototype.size
  local beta_max = config.battle_field_radius - player_manager.prototype.size
  local beta = math.sqrt(math.random() * (beta_max * beta_max - beta_min * beta_min) + beta_min * beta_min)
  unit.posX = beta * math.sin(alpha)
  unit.posY = beta * math.cos(alpha)
  return unit
end

function M.create_enemies()
  if #M.enemies_group == 0 then
    -- A Mock enemies
    return {player_manager.get_player()}
  else
    local enemies_group = M.enemies_group[math.random(#M.enemies_group)]
    local ret = {}
    for _,g in ipairs(enemies_group) do
      for i=1,g.size do
        table.insert(ret, M.randomLocation(unit_module.create(g.prototype)))
      end
    end
    return ret
  end
end

function M.add_enemies_group(group, weight)
  for _=1,weight do
    table.insert(M.enemies_group, group)
  end
end

return M
