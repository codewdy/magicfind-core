local M = {}

M.handle_counter = 1

M.prototypes = {}

function M.create()
  local ret = {
    icon = "",
    size = 1,
    maxHp = 100,
    handle = M.handle_counter,
    strength = 0,
    intelligence = 0,
    agility = 0,
    damage = 1,
    flat_damage_reducer = 0,
    talents = {vec = {}, size = 0},
    post_buff_talents = {vec = {}, size = 0},
    skills = {vec = {}, size = 0},
  }
  M.prototypes[ret.handle] = ret
  M.handle_counter = M.handle_counter + 1
  return ret
end

function M.get(handle)
  return M.prototypes[handle]
end

return M
