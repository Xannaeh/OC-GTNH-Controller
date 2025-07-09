-- ===========================================
-- GTNH OC Automation System - ScreenUI.lua
-- Draw Power + Fluid status on screen
-- ===========================================
local component = require("component")
local term = require("term")
local gpu = component.gpu
local Logger = require("utils/Logger")

local ScreenUI = {}

local latestPower = "?"
local latestFluid = "?"

function ScreenUI.init(settings)
    gpu.setResolution(settings.screenResolution.width, settings.screenResolution.height)
    term.clear()
    Logger.info("ScreenUI initialized.")
end

function ScreenUI.update()
    -- Clear screen
    term.clear()
    term.setCursor(1, 1)
    term.write("GTNH OC Automation: Running...")

    -- Show Power
    term.setCursor(1, 3)
    term.write("Power: " .. latestPower)

    -- Show Fluid
    term.setCursor(1, 5)
    term.write("Fluid: " .. latestFluid)
end

-- These setters will be called by Power/Fluid modules:
function ScreenUI.setPowerStatus(text)
    latestPower = text
end

function ScreenUI.setFluidStatus(text)
    latestFluid = text
end

return ScreenUI
