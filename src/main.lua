-- ===========================================
-- GTNH OC Automation System - main.lua
-- Bootstrap and program selector
-- ===========================================

package.path = "/home/src/?/init.lua;/home/src/?.lua;" .. package.path

local io = require("io")

local DeviceRegistry = require("programs/device_registry")
local DeviceStatus = require("programs/device_status")
--local GlassesDemo = require("programs/glasses_demo")
local GlassesTest = require("programs/glasses_test")
local GlassesTest2 = require("programs/glasses_test_2")

-- === Main loop ===
local function runMainLoop()
    print("Not implemented yet")
end

-- === Device Registry ===
local function runDeviceRegistry()
    DeviceRegistry:run()
end

local function runDeviceStatus()
    DeviceStatus:run()
end

--local function runGlassesDemo()
--    GlassesDemo:run()
--end

local function runGlassesTest()
    GlassesTest:run()
end

local function runGlassesTest2()
    GlassesTest2:run()
end

print("Select program to run:")
print("1) Main Automation Loop")
print("2) Device Registry CLI")
print("3) Show Device Status")
print("4) Glasses Demo")
print("5) Glasses HUD Test")
print("6) Glasses HUD Test 2")
io.write("> ")
local choice = io.read()

if choice == "1" then
    runMainLoop()
elseif choice == "2" then
    runDeviceRegistry()
elseif choice == "3" then
    runDeviceStatus()
--elseif choice == "4" then
--    runGlassesDemo()
elseif choice == "5" then
    runGlassesTest()
elseif choice == "5" then
    runGlassesTest2()
else
    print("Invalid choice. Exiting.")
end
