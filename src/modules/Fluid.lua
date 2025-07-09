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
        Logger.warn("Fluid: No Transposer proxy available.")
        return
    end

    Logger.info("=== BEGIN FULL TRANSPOSER TANK DUMP ===")

    for side = 0, 5 do
        -- getTankCount
        local count = transposer.getTankCount(side)
        Logger.info(string.format("Side %d: getTankCount() = %s", side, tostring(count)))

        -- getTankLevel
        local level = transposer.getTankLevel(side)
        Logger.info(string.format("Side %d: getTankLevel() = %s", side, tostring(level)))

        -- getTankCapacity
        local cap = transposer.getTankCapacity(side)
        Logger.info(string.format("Side %d: getTankCapacity() = %s", side, tostring(cap)))

        -- getFluidInTank
        local tanks = transposer.getFluidInTank(side)
        local text
        if tanks and #tanks > 0 then
            for idx, t in ipairs(tanks) do
                text = string.format(
                        "Side %d: getFluidInTank() Tank %d => name=%s, amount=%s, capacity=%s",
                        side, idx, tostring(t.name), tostring(t.amount), tostring(t.capacity)
                )
                Logger.info(text)
            end
        else
            Logger.info(string.format("Side %d: getFluidInTank() returned empty.", side))
        end
    end

    Logger.info("=== END FULL TRANSPOSER TANK DUMP ===")
end


return Fluid
