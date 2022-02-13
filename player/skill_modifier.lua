--[[
skill_modifier = {
  name = ...,
  type = ...,
  group = {"all", ...},
  resource = ...,
  modify = function(level, skill_arg)...,
}
M.add(modifier)
M.get_all()
M.get(name)
--]]

M = {}

M.TRIGGER = 1
M.CASTER = 2
M.SUPPORTER = 3

M.all = { size = 0, vec = {} }
M.dict = {}

function M.add(modifier)
  M.all.size = M.all.size + 1
  M.all.vec[M.all.size] = modifier
  M.dict[modifier.name] = modifier
end

function M.get_all()
  return M.all
end

function M.get(name)
  return M.dict[name]
end

function M.reset_arg(arg)
  arg.type = nil
  arg.factor = nil
  arg.skill = nil
  arg.element = nil
  arg.chain_num = 1
  arg.target_num = 1
  arg.area_factor = 1
  arg.damage_factor = 1
  arg.effect_factor = 1
end

return M
