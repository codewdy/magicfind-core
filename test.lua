--[[
object_pool = require("gamesystem.object_pool").object_pool

p = object_pool(
function()
  return {
    k = 0
  }
end,
function(x)
  x.k = 0
end)

z = {}
for i=1,10000 do
  for j=1,10000 do
    z[j] = p.get()
  end
  for j=1,10000 do
    p.recycle(z[j])
    z[j] = nil
  end
end
--]]

--[[
local M = {}
local object_pool = require("gamesystem.object_pool").object_pool
local task_runner = require("gamesystem.task_runner")

p = object_pool(
function()
  return {
    k = 0,
    run = M.run
  }
end,
function(x)
  x.k = 0
end)

function M.run(x)
  if (x.k < 10) then
    x.k = x.k + 1
    task_runner.schedule(1, x)
  else
    p.recycle(x)
  end
end

function M.abort(x)
  p.recycle(x)
end

for t=1,2000 do
  for i=1,10000 do
    task_runner.schedule(1, p.get())
  end
  for i=1,5 do
    task_runner.run()
  end
  task_runner.abort()
end
--]]

function run(a, b, c, d, e, f, g)
  print(tostring(a))
  print(tostring(b))
  print(tostring(c))
  print(tostring(d))
  print(tostring(e))
  print(tostring(f))
  print(tostring(g))
end

run(1, 2, 3, 4)
