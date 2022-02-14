local root = "content.skills."

local function loader(list)
  local M = {}
  for _,name in ipairs(list) do
    M[name] = require(root .. name)
  end
  return M
end

return loader({
  "lightning_chain",
})
