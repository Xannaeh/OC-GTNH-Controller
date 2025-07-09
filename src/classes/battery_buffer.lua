local PowerStorage = require("classes.power_storage")
local BatteryBuffer = setmetatable({}, {__index = PowerStorage})
BatteryBuffer.__index = BatteryBuffer

function BatteryBuffer:new(internalId, address, capacity, amount, display)
    local obj = PowerStorage.new(self, internalId, address, capacity, amount, display)
    return obj
end

return BatteryBuffer
