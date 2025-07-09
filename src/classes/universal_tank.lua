local component = require("component")
local FluidStorage = require("classes.fluid_storage")

local UniversalTank = setmetatable({}, {__index = FluidStorage})
UniversalTank.__index = UniversalTank

function UniversalTank:new(internalId, address, fluid, side, capacity, amount, display)
    local obj = FluidStorage.new(self, internalId, address, fluid, side, capacity, amount, display)
    if not side or side == -1 then
        obj.side = obj:autoDetectSide()
    end
    return obj
end

function UniversalTank:autoDetectSide()
    local transposer = component.proxy(self.address)
    for s = 0, 5 do
        local count = transposer.getTankCount(s)
        if count and count > 0 then
            local fluids = transposer.getFluidInTank(s)
            if fluids and #fluids > 0 then
                return s
            end
        end
    end
    return 0
end

function UniversalTank:readFluidStatus()
    local transposer = component.proxy(self.address)
    local tank = transposer.getFluidInTank(self.side)
    if tank and #tank > 0 then
        self.fluid = tank[1].name or "Unknown"
        self.amount = tank[1].amount or 0
        self.capacity = transposer.getTankCapacity(self.side) or 0
    end
end

return UniversalTank
