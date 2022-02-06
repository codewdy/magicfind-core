local M = {}

local object_pool = require("gamesystem.object_pool")

M.tasks = {}
M.current = 0

M.task_processor_pool = object_pool.create(
function()
  return {
    vec = {},
    size = 0
  }
end,
function(x)
  x.size = 0
end)

function M.schedule(delay, runner)
  local t = M.current + delay
  if M.tasks[t] == nil then
    M.tasks[t] = M.task_processor_pool.get()
  end
  local task = M.tasks[t]
  task.size = task.size + 1
  task.vec[task.size] = runner
end

function M.run()
  M.current = M.current + 1
  local task = M.tasks[M.current]
  if task == nil then
    return
  end
  for i=1,task.size do
    task.vec[i].run(task.vec[i])
  end
  M.tasks[M.current] = nil
  M.task_processor_pool.recycle(task)
end

function M.abort()
  for _,task in ipairs(M.tasks) do
    for i=1,task.size do
      task.vec[i].abort(task.vec[i])
    end
    M.task_processor_pool.recycle(task)
  end
  M.tasks = {}
end

return M
