-- ===========================================
-- GTNH OC Automation System - main.lua
-- Bootstrap and program selector
-- ===========================================

package.path = "/home/src/?/init.lua;/home/src/?.lua;" .. package.path

local fs = require("filesystem")
local io = require("io")
local os = require("os")
local component = require("component")
local computer = require("computer")
local event = require("event")

local Settings = require("config/settings")
local Logger = require("utils/Logger")
local Power = require("modules/Power")
local Fluid = require("modules/Fluid")
local Environment = require("modules/Environment")
local ScreenUI = require("ui/ScreenUI")
local HudOverlay = require("ui/HudOverlay")
local DeviceRegistry = require("programs/device_registry")
local DeviceStatus = require("programs/device_status")
local GlassesDemo = require("programs/glasses_demo")
local GlassesTest = require("programs/glasses_test")


-- === Ensure /home/logs exists ===
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

-- === Main loop ===
local function runMainLoop()
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
end

-- === Device Registry ===
local function runDeviceRegistry()
    DeviceRegistry:run()
end

local function runDeviceStatus()
    DeviceStatus:run()
end

local function runGlassesDemo()
    GlassesDemo:run()
end

local function runGlassesTest()
    GlassesTest:run()
end

print("Select program to run:")
print("1) Main Automation Loop")
print("2) Device Registry CLI")
print("3) Show Device Status")
print("4) Glasses Demo")
print("5) Glasses HUD Test")
io.write("> ")
local choice = io.read()

if choice == "1" then
    runMainLoop()
elseif choice == "2" then
    runDeviceRegistry()
elseif choice == "3" then
    runDeviceStatus()
elseif choice == "4" then
    runGlassesDemo()
elseif choice == "5" then
    runGlassesTest()
else
    print("Invalid choice. Exiting.")
end
