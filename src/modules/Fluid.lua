-- ===========================================
-- GTNH OC Automation System - Fluid.lua
-- Final version using Transposer side 4
-- ===========================================

local component = require("component")
local Logger = require("utils/Logger")
local ScreenUI = require("ui/ScreenUI")

local Fluid = {}
local transposer

-- We confirmed side 4 works
local TANK_SIDE = 4

function Fluid.init(settings)
    Logger.info(string.format("Fluid: Using Transposer UUID: %s", settings.transposer))
    transposer = component.proxy(settings.transposer)
    if transposer then
        Logger.info("Fluid: Transposer proxy created.")
    else
        Logger.error("Fluid: Transposer not found!")
    end
    Logger.info("Fluid module ready.")
end

function Fluid.update()
    if not transposer then
        Logger.warn("Fluid: No Transposer proxy available.")
        return
    end

    local tankCount = transposer.getTankCount(TANK_SIDE)
    Logger.info(string.format("Fluid: Side %d tank count: %s", TANK_SIDE, tostring(tankCount)))

    if tankCount == 0 then
        Logger.warn("Fluid: No tanks detected on side " .. TANK_SIDE)
        ScreenUI.setFluidStatus("Fluid: No tanks detected.")
        return
    end

    local data = transposer.getFluidInTank(TANK_SIDE)
    if not data or #data == 0 then
        Logger.warn("Fluid: getFluidInTank returned empty.")
        ScreenUI.setFluidStatus("Fluid: Empty tank.")
        return
    end

    -- Always take first tank result
    local fluid = data[1]
    local name = fluid.name or "?"
    local amount = fluid.amount or 0
    local capacity = fluid.capacity or 1 -- avoid /0
    local percent = (amount / capacity) * 100

    local msg = string.format("Fluid: %s: %.1f%% (%d / %d mB)", name, percent, amount, capacity)
    Logger.info(msg)
    ScreenUI.setFluidStatus(msg)
end

return Fluid
