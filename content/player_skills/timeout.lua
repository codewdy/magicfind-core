local M = {}

local skill_modifier = require("player.skill_modifier")
local skill_arg = require("gamesystem.skill_arg")

function M.modify(level, arg)
  arg.type = skill_arg.TIMEOUT
  arg.factor = 0.1
end

M.skill_modifier = {
  name = "Timeout",
  type = skill_modifier.TRIGGER,
  group = { size = 2, vec = {"all", "trigger"} },
  resource = 1,
  modify = M.modify
}

skill_modifier.add(M.skill_modifier)

return M
