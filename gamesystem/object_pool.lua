local M = {}

function M.create(creator, recycle)
  local obj = {}
  obj.arr = {}
  obj.last_ptr = 0
  function obj.get()
    if obj.last_ptr == 0 then
      return creator()
    else
      local x = obj.arr[obj.last_ptr]
      obj.last_ptr = obj.last_ptr - 1
      return x
    end
  end
  function obj.recycle(x)
    recycle(x)
    obj.last_ptr = obj.last_ptr + 1
    obj.arr[obj.last_ptr] = x
  end
  return obj
end

return M
