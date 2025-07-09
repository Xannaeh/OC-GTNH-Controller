-- ===========================================
-- GTNH OC Automation System - main.lua
-- Bootstrap and main loop
-- ===========================================

-- Load standard libs
local component = require("component")
local computer = require("computer")
local event = require("event")
local os = require("os")

-- Load custom modules
local Logger = require("utils/Logger")
local Settings = require("config/settings")

local Power = require("modules/Power")
local Fluid = require("modules/Fluid")
local Environment = require("modules/Environment")
local ScreenUI = require("ui/ScreenUI")
local HudOverlay = require("ui/HudOverlay")

-- Init log
Logger.info("System booting up...")

-- Init modules
Power.init(Settings)
Fluid.init(Settings)
Environment.init(Settings)
ScreenUI.init(Settings)
HudOverlay.init(Settings)

Logger.info("All modules initialized.")

-- === MAIN LOOP ===
while true do
    -- Update each module
    local status, err = pcall(function()
        Power.update()
        Fluid.update()
        Environment.update()
        ScreenUI.update()
        HudOverlay.update()
    end)

    if not status then
        Logger.error("Main loop error: " .. tostring(err))
    end

    -- Sleep for X seconds before next loop
    os.sleep(Settings.updateInterval or 2)
end
