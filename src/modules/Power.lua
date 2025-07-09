-- ===========================================
-- GTNH OC Automation System - Power.lua
-- Module for power storage monitoring
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")

local Power = {}

local powerDevice

function Power.init(settings)
    powerDevice = component.proxy(settings.powerDevice)
    Logger.info("Power module initialized.")
end

function Power.update()
    if not powerDevice then
        Logger.warn("Power device not set.")
        return
    end

    local current = powerDevice.getEUStored and powerDevice.getEUStored() or 0
    local capacity = powerDevice.getEUCapacity and powerDevice.getEUCapacity() or 1

    local percent = (current / capacity) * 100
    Logger.info(string.format("Power: %.1f%% (%d / %d EU)", percent, current, capacity))
end

return Power
