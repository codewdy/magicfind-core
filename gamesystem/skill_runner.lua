local M = {}

function M.update(unit)
  for i=1,unit.prototype.skills.size do
    unit.prototype.skills.vec[i].update(unit.prototype.skills.vec[i], i, unit)
  end
end

return M
