local M = {}

local skill_modifier = require("player.skill_modifier")
local lightning_chain = require("skills.lightning_chain")

function M.modify(level, arg)
  arg.skill = lightning_chain
end

M.skill_modifier = {
  name = "LightningChain",
  type = skill_modifier.CASTER,
  group = { size = 2, vec = {"all", "caster"} },
  resource = 1,
  modify = M.modify
}

skill_modifier.add(M.skill_modifier)

return M
