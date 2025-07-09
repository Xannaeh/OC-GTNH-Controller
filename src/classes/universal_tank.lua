local FluidStorage = require("classes.fluid_storage")
local UniversalTank = setmetatable({}, {__index = FluidStorage})
UniversalTank.__index = UniversalTank

function UniversalTank:new(internalId, address, fluid, side, capacity, amount, display)
    local obj = FluidStorage.new(self, internalId, address, fluid, side, capacity, amount, display)
    return obj
end

return UniversalTank
