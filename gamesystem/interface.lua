local M = {}

math.randomseed(os.time())

local game_runner = require("gamesystem.game_runner")
local unit_manager = require("gamesystem.unit_manager")
local unit_prototype_manager = require("gamesystem.unit_prototype_manager")
local effect_manager = require("gamesystem.effect_manager")
local effect_proto_manager = require("gamesystem.effect_prototype_manager")
local logger = require("logger")

M.context = {
  state = game_runner.state.Init,
  units = {
    vec = {},
    size = 0
  },
  new_effects = {
    vec = {},
    size = 0
  }
}

function M.add_unit(unit)
  M.context.units.size = M.context.units.size + 1
  if M.context.units.vec[M.context.units.size] == nil then
    M.context.units.vec[M.context.units.size] = {}
  end
  local out_unit = M.context.units.vec[M.context.units.size]
  out_unit.prototype_handle = unit.prototype.handle
  out_unit.maxHp = unit.maxHp
  out_unit.hp = unit.hp
  out_unit.posX = unit.posX
  out_unit.posY = unit.posY
  out_unit.death = unit.death
end

function M.run_one_frame()
  game_runner.run()
  M.context.state = game_runner.context.state
  M.context.units.size = 0
  M.context.new_effects.size = 0
  if M.context.state == game_runner.state.Battle then
    M.add_unit(unit_manager.player)
    for _,enemy in ipairs(unit_manager.enemies) do
      M.add_unit(enemy)
    end
  end
  effect_manager.get_all_effects(M.context.new_effects)
  return M.context
end

function M.get_unit_prototype(handle)
  return unit_prototype_manager.get(handle)
end

M.get_effect_prototype = effect_proto_manager.get

M.init_logger = logger.InitLogger

return M
