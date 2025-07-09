-- ===========================================
-- GTNH OC Automation System - main.lua
-- Bootstrap and main loop with init/create events.log in-game
-- ===========================================

-- Prepend src folder to package.path so require() works
package.path = "/home/src/?/init.lua;/home/src/?.lua;" .. package.path

-- Load core libraries
local fs       = require("filesystem")
local io       = require("io")
local os       = require("os")
local component = require("component")
local computer  = require("computer")
local event     = require("event")

-- Load game config
local Settings = require("config/settings")

-- Ensure "/logs" directory exists in-game
if not fs.exists("/logs") then
    local ok, err = fs.makeDirectory("/logs")
    if not ok then
        error("Failed to create /logs directory: " .. tostring(err))
    end
end

-- Ensure the events.log file exists (create if missing)
local f = io.open(Settings.logFile, "r")
if not f then
    local w = io.open(Settings.logFile, "w")
    if w then
        w:write("") w:close()
    else
        error("Failed to create log file at " .. Settings.logFile)
    end
else
    f:close()
end

-- Load and initialize modules
local Logger      = require("utils/Logger")
local Power       = require("modules/Power")
local Fluid       = require("modules/Fluid")
local Environment = require("modules/Environment")
local ScreenUI    = require("ui/ScreenUI")
local HudOverlay  = require("ui/HudOverlay")

Logger.info("System booting up...")

Power.init(Settings)
Fluid.init(Settings)
Environment.init(Settings)
ScreenUI.init(Settings)
HudOverlay.init(Settings)

Logger.info("All modules initialized.")

-- Main update loop
while true do
    local ok, err = pcall(function()
        Power.update()
        Fluid.update()
        Environment.update()
        ScreenUI.update()
        HudOverlay.update()
    end)

    if not ok then
        Logger.error("Main loop error: " .. tostring(err))
    end

    os.sleep(Settings.updateInterval or 2)
end
