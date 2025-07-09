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

function FluidStorage:getPercent()
    if self.capacity > 0 then
        return (self.amount / self.capacity) * 100
    else
        return 0
    end
end

function FluidStorage:update(newAmount)
    self.amount = newAmount or self.amount
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
