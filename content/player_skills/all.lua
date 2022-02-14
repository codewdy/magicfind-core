local root = "content.player_skills."

local function loader(list)
  local M = {}
  for _,name in ipairs(list) do
    M[name] = require(root .. name)
  end
  return M
end

return loader({
  "timeout",
  "lightning_chain",
})
