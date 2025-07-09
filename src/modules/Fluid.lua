-- ===========================================
-- GTNH OC Automation System - Fluid.lua
-- Auto-detects tank side once, saves to settings
-- ===========================================

local component = require("component")
local Logger = require("utils/Logger")
local ScreenUI = require("ui/ScreenUI")
local serialization = require("serialization")
local fs = require("filesystem")

local Fluid = {}
local transposer
local TANK_SIDE = nil

function Fluid.init(settings)
    transposer = component.proxy(settings.transposer)
    if not transposer then
        Logger.error("Fluid: Transposer not found!")
        return
    end

    Logger.info(string.format("Fluid: Using Transposer UUID: %s", settings.transposer))

    -- Use stored side if available
    if settings.tankSide then
        TANK_SIDE = settings.tankSide
        Logger.info("Fluid: Using stored side: " .. TANK_SIDE)
    else
        -- Auto detect once
        Logger.info("Fluid: No side in settings, scanning for valid tank...")
        for side = 0, 5 do
            local count = transposer.getTankCount(side)
            if count and count > 0 then
                local fluids = transposer.getFluidInTank(side)
                if fluids and #fluids > 0 then
                    TANK_SIDE = side
                    settings.tankSide = side
                    Logger.info("Fluid: Found tank on side " .. side .. ". Saving to settings...")

                    -- Ensure /home/src/config exists
                    if not fs.exists("/home/src/config") then
                        fs.makeDirectory("/home/src/config")
                    end

                    local file, err = fs.open("/home/src/config/settings.lua", "w")
                    if not file then
                        Logger.error("Fluid: Failed to save settings! " .. tostring(err))
                        break
                    end

                    file:write("local Settings = {}\n\n")
                    file:write(string.format("Settings.transposer = \"%s\"\n", settings.transposer))
                    file:write(string.format("Settings.tankSide = %d\n", side))
                    file:write(string.format("Settings.updateInterval = %s\n", tostring(settings.updateInterval)))
                    file:write(string.format("Settings.powerDevice = \"%s\"\n", settings.powerDevice))
                    file:write(string.format("Settings.fluidTanks = { main = \"%s\" }\n", settings.fluidTanks.main))
                    file:write(string.format("Settings.logFile = \"%s\"\n", settings.logFile))
                    file:write("Settings.screenResolution = { width = 80, height = 25 }\n")
                    file:write("Settings.hudEnabled = true\n")
                    file:write("return Settings\n")
                    file:close()

                    Logger.info("Fluid: Settings saved to /home/src/config/settings.lua")
                    break
                end
            end
        end

        if not TANK_SIDE then
            Logger.warn("Fluid: No valid tank found on any side.")
        end
    end

    Logger.info("Fluid module ready. Using side: " .. tostring(TANK_SIDE))
end

function Fluid.update()
    if not transposer or not TANK_SIDE then
        Logger.warn("Fluid: Not ready or no side set.")
        return
    end

    local fluids = transposer.getFluidInTank(TANK_SIDE)
    if not fluids or #fluids == 0 then
        Logger.warn("Fluid: Tank empty or not detected.")
        ScreenUI.setFluidStatus("Fluid: Empty.")
        return
    end

    local fluid = fluids[1]
    local amount = fluid.amount or 0
    local capacity = fluid.capacity or 1
    local percent = (amount / capacity) * 100
    local name = fluid.name or "?"

    local msg = string.format("Fluid: %s: %.1f%% (%d / %d mB)", name, percent, amount, capacity)
    Logger.info(msg)
    ScreenUI.setFluidStatus(msg)
end

return Fluid
