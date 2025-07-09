-- ===========================================
-- GTNH OC Automation System - Power.lua
-- Correct GT Battery Buffer reading
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")

local Power = {}
local powerDevice

function Power.init(settings)
    if settings.powerDevice then
        powerDevice = component.proxy(settings.powerDevice)
        Logger.info("Power module initialized.")
    else
        Logger.warn("Power device not set.")
    end
end

function Power.update()
    if not powerDevice then
        Logger.warn("Power device not set.")
        return
    end

    local current = powerDevice.getEUStored()
    local capacity = powerDevice.getEUCapacity()
    local percent = (current / capacity) * 100

    Logger.info(string.format("Power: %.2f%% (%d / %d EU)", percent, current, capacity))
end

return Power
