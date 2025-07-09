-- ===========================================
-- GTNH OC Automation System - Fluid.lua
-- Fluid monitoring using Transposer
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")
local ScreenUI = require("ui/ScreenUI")

local Fluid = {}
local transposer

-- Which side the tank is on (0–5)
local TANK_SIDE = 0

function Fluid.init(settings)
    Logger.info(string.format("Fluid: Trying to proxy Transposer UUID: %s", settings.transposer))
    transposer = component.proxy(settings.transposer)
    if transposer then
        Logger.info("Fluid: Proxy created for Transposer.")
    else
        Logger.error("Fluid: Proxy failed — Transposer not found!")
    end
    Logger.info("Fluid module initialized.")
end

function Fluid.update()
    if not transposer then
        Logger.warn("Fluid: No Transposer proxy available.")
        return
    end

    local tankInfo = transposer.getTankInfo(TANK_SIDE)
    if not tankInfo or #tankInfo == 0 then
        Logger.warn("Fluid: getTankInfo returned no data.")
        return
    end

    for idx, tank in ipairs(tankInfo) do
        local amount = tank.amount or 0
        local capacity = tank.capacity or 0
        local percent = (capacity > 0) and (amount / capacity) * 100 or 0
        local msg = string.format("Tank %d: %.2f%% (%d / %d mB)", idx, percent, amount, capacity)
        Logger.info("Fluid: " .. msg)
        ScreenUI.setFluidStatus(msg)
    end
end

return Fluid
