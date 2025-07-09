-- ===========================================
-- GTNH OC Automation System - main.lua
-- Bootstrap and main loop with log rotation
-- ===========================================

package.path = "/home/src/?/init.lua;/home/src/?.lua;" .. package.path

local fs = require("filesystem")
local io = require("io")
local os = require("os")
local component = require("component")
local computer = require("computer")
local event = require("event")

local Settings = require("config/settings")

-- Ensure /home/logs exists
if not fs.exists("/home/logs") then
    local ok, err = fs.makeDirectory("/home/logs")
    if not ok then
        error("Failed to create /home/logs: " .. tostring(err))
    end
end

-- === Log rotation ===
if fs.exists(Settings.logFile) then
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local newName = "/home/logs/events_" .. timestamp .. ".log"
    local ok, err = fs.rename(Settings.logFile, newName)
    if not ok then
        io.write("Failed to rotate log: " .. tostring(err) .. "\n")
    else
        io.write("Previous log rotated to " .. newName .. "\n")
    end
end

-- Create fresh events.log
local f = io.open(Settings.logFile, "w")
if f then f:close() else error("Could not create fresh events.log!") end

-- Now load modules
local Logger = require("utils/Logger")
local Power = require("modules/Power")
local Fluid = require("modules/Fluid")
local Environment = require("modules/Environment")
local ScreenUI = require("ui/ScreenUI")
local HudOverlay = require("ui/HudOverlay")

Logger.info("System booting up...")
Power.init(Settings)
Fluid.init(Settings)
Environment.init(Settings)
ScreenUI.init(Settings)
HudOverlay.init(Settings)
Logger.info("All modules initialized.")

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
