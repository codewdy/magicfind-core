local M = {}

M.DEBUG = 1
M.INFO = 2
M.WARN = 3
M.ERROR = 4
M.TOKEN_END = 5

M.TOKEN = {
  "DEBUG",
  "INFO ",
  "WARN ",
  "ERROR"
}

M.level = M.TOKEN_END

function M.InitLogger(filename, level)
  M.level = level
  M.file = io.open(filename, "w")
  if M.file then
		M.file:setvbuf("line")
    M.file:write("=======================new logger==================\n")
  else
    M.level = M.TOKEN_END
    error("open logger file error.")
  end
end

function M.Log(level, value)
  if level >= M.level then
    M.file:write(tostring(value))
    M.file:write("\n")
  end
end

function M.Debug(value)
  M.Log(M.DEBUG, value)
end

function M.Info(value)
  M.Log(M.INFO, value)
end

function M.Warn(value)
  M.Log(M.WARN, value)
end

function M.Error(value)
  M.Log(M.ERROR, value)
end

return M
