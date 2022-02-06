local M = {}

local config = require("config")

M.effects = {
  vec = {},
  size = 0,
  total_size = 0
}

function M.add_effect(effect_handle, a, b, c, d, e, f, g)
  local target = 0
  if M.effects.size < config.max_effect_per_frame then
    M.effects.size = M.effects.size + 1
    if M.effects.vec[M.effects.size] == nil then
      M.effects.vec[M.effects.size] = {}
    end
    target = M.effects.size
  else
    M.effects.total_size = M.effects.total_size + 1
    target = math.random(M.effects.total_size)
  end
  if target <= config.max_effect_per_frame then
    M.effects.vec[target].handle = effect_handle
    M.effects.vec[target].a = a
    M.effects.vec[target].b = b
    M.effects.vec[target].c = c
    M.effects.vec[target].d = d
    M.effects.vec[target].e = e
    M.effects.vec[target].f = f
    M.effects.vec[target].g = g
  end
end

function M.get_all_effects(output)
  output.vec = M.effects.vec
  output.size = M.effects.size
  M.effects.size = 0
  M.effects.total_size = 0
end

return M
