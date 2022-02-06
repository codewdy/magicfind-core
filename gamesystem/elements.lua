local M = {}
M.Random = 0
M.Physical = 1
M.Arcane = 2
M.Fire = 3
M.Ice = 4
M.Lightning = 5
M.Light = 6
M.Dark = 7

M.Elements = {
  M.Physical,
  M.Arcane,
  M.Fire,
  M.Ice,
  M.Lightning,
  M.Light,
  M.Dark,
}

M.ElementName = {
  [M.Physical] = "Physical",
  [M.Arcane] = "Arcane",
  [M.Fire] = "Fire",
  [M.Ice] = "Ice",
  [M.Lightning] = "Lightning",
  [M.Light] = "Light",
  [M.Dark] = "Dark",
}

return M
