-- ===========================================
-- GTNH OC Automation System - Fluid.lua
-- Final version: Transposer, robust
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")
local ScreenUI = require("ui/ScreenUI")

local Fluid = {}
local transposer

local TANK_SIDE = 0

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
        Logger.warn("Fluid: No transposer proxy!")
        return
    end

    local tankCount = transposer.getTankCount(TANK_SIDE)
    Logger.info(string.format("Fluid: Tank count on side %d: %d", TANK_SIDE, tankCount))

    if tankCount == 0 then
        Logger.warn("Fluid: No tanks detected.")
        ScreenUI.setFluidStatus("Fluid: No tanks found.")
        return
    end

    for idx = 1, tankCount do
        local fluidData = transposer.getFluidInTank(TANK_SIDE, idx)
        if fluidData then
            local name = fluidData.name or "?"
            local amount = fluidData.amount or 0
            local capacity = fluidData.capacity or 0
            local percent = (capacity > 0) and (amount / capacity) * 100 or 0
            local msg = string.format("Tank %d: %.1f%% (%d/%d mB) %s", idx, percent, amount, capacity, name)
            Logger.info("Fluid: " .. msg)
            ScreenUI.setFluidStatus(msg)
        else
            Logger.warn(string.format("Fluid: Tank %d returned no data.", idx))
        end
    end
end

return Fluid
