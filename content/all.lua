local root = "content."

local function loader(list)
  local M = {}
  for _,name in ipairs(list) do
    M[name] = require(root .. name .. ".all")
  end
  return M
end

return loader({
  "skills",
  "player_skills",
  "units",
  "enemies_group",
})

