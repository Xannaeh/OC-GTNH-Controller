local component = require("component")
local Logger = require("utils/Logger")
local ScreenUI = require("ui/ScreenUI")
local State = require("config/state")

local Power = {}
Power.devices = {}

function Power.init(settings)
    for _, info in ipairs(State.powerDevices) do
        local proxy = component.proxy(info.uuid)
        if proxy and proxy.getEUStored and proxy.getEUCapacity then
            table.insert(Power.devices, proxy)
            Logger.info(("Power: Found buffer %s"):format(info.uuid))
        else
            Logger.error(("Power: Couldn't init buffer %s"):format(info.uuid))
        end
    end
end

function Power.update()
    local totalStored, totalCapacity = 0, 0
    for _, dev in ipairs(Power.devices) do
        local c = dev.getEUStored()
        local cap = dev.getEUCapacity()
        if c and cap then
            totalStored=totalStored + c
            totalCapacity=totalCapacity + cap
        else
            Logger.warn("Power: device returned nil")
        end
    end

    if totalCapacity > 0 then
        local pct = (totalStored / totalCapacity) * 100
        local msg = string.format("%.2f%% (%d / %d EU)", pct, totalStored, totalCapacity)
        Logger.info("Power: "..msg)
        ScreenUI.setPowerStatus(msg)
    else
        ScreenUI.setPowerStatus("No power devices")
    end
end

return Power
