local M = {}

local effect_proto_manager = require("gamesystem.effect_prototype_manager")

M.lightning = effect_proto_manager.create("Lightning", {
})

return M
