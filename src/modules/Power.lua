-- ===========================================
-- GTNH OC Automation System - Power.lua
-- Correct GT Battery Buffer reading with debug logs
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")

local Power = {}
local powerDevice

function Power.init(settings)
    if settings.powerDevice then
        Logger.info("Power: Trying to proxy UUID: " .. settings.powerDevice)
        powerDevice = component.proxy(settings.powerDevice)

        if powerDevice then
            Logger.info("Power: Proxy created for GT Battery Buffer.")
        else
            Logger.error("Power: Proxy failed — device not found.")
        end

        -- Check if required methods exist
        if powerDevice and not powerDevice.getEUStored then
            Logger.error("Power: getEUStored method not found on device.")
        end
        if powerDevice and not powerDevice.getEUCapacity then
            Logger.error("Power: getEUCapacity method not found on device.")
        end

        Logger.info("Power module initialized.")
    else
        Logger.warn("Power device UUID is empty in settings.")
    end
end

function Power.update()
    if not powerDevice then
        Logger.warn("Power device not set.")
        return
    end

    local current = powerDevice.getEUStored()
    local capacity = powerDevice.getEUCapacity()

    if not current then
        Logger.error("Power: getEUStored returned nil!")
    end
    if not capacity then
        Logger.error("Power: getEUCapacity returned nil!")
    end

    local percent = (current / capacity) * 100
    Logger.info(string.format("Power: %.2f%% (%d / %d EU)", percent, current, capacity))
end

return Power
