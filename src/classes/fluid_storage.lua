local component = require("component")

local FluidStorage = {}
FluidStorage.__index = FluidStorage

function FluidStorage:new(internalId, address, fluid, side, capacity, amount, display)
    local obj = setmetatable({}, self)
    obj.internalId = internalId
    obj.address = address
    obj.fluid = fluid or ""
    obj.side = side or 0
    obj.capacity = capacity or 0
    obj.amount = amount or 0
    obj.display = display or false
    return obj
end

function FluidStorage:readFluidStatus()
    local transposer = component.proxy(self.address)
    local fluids = transposer.getFluidInTank(self.side)
    if fluids and #fluids > 0 then
        self.fluid = fluids[1].name or "Unknown"
        self.amount = fluids[1].amount or 0
        self.capacity = transposer.getTankCapacity(self.side) or 0
    end
end

function FluidStorage:getPercent()
    if self.capacity > 0 then
        return (self.amount / self.capacity) * 100
    else
        return 0
    end
end

function FluidStorage:toString()
    return string.format(
            "FluidStorage[%s]: %s %d/%d mB (%.1f%%)",
            self.internalId,
            self.fluid,
            self.amount,
            self.capacity,
            self:getPercent()
    )
end

return FluidStorage
