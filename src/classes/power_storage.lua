local PowerStorage = {}
PowerStorage.__index = PowerStorage

function PowerStorage:new(internalId, address, capacity, amount, display)
    local obj = setmetatable({}, self)
    obj.internalId = internalId
    obj.address = address
    obj.capacity = capacity or 0
    obj.amount = amount or 0
    obj.display = display or false
    return obj
end

function PowerStorage:getPercent()
    if self.capacity > 0 then
        return (self.amount / self.capacity) * 100
    else
        return 0
    end
end

function PowerStorage:update(newAmount)
    self.amount = newAmount or self.amount
end

function PowerStorage:toString()
    return string.format(
            "PowerStorage[%s]: %d/%d EU (%.1f%%)",
            self.internalId,
            self.amount,
            self.capacity,
            self:getPercent()
    )
end

return PowerStorage
