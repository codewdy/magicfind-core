local M = {}

local task_runner = require("gamesystem.task_runner")

M.prototype = {}

function M.prototype.run(context)
end

function M.prototype.abort(context)
end

function M.prototype.cast(context, unit, target)
  task_runner.schedule(context.delay, context)
end

function M.create()
  return {}
end

return M
