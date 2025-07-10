-- src/programs/glasses_test.lua
-- Simple HUD test: draws a full-screen shiny red rectangle using addRectangle

local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local os = require("os")

local Program = {}

function Program:run()
    -- Load registered devices
    local file = io.open("devices.dat", "r")
    if not file then
        print("No registered devices found.")
        os.exit()
    end

    local devices = serialization.unserialize(file:read("*a")) or {}
    file:close()

    local glassesDevice = nil
    for _, device in ipairs(devices) do
        if device.type == "GlassesHud" then
            glassesDevice = device
            break
        end
    end

    if not glassesDevice then
        print("No GlassesHud device registered.")
        os.exit()
    end

    local hud = GlassesHUD:new(glassesDevice.internalId, glassesDevice.address)

    -- Define full screen size (adjust if you use a different resolution)
    local screenW, screenH = 160, 90  -- typical OpenGlasses virtual HUD grid

    -- Add full-screen shiny red rectangle with full opacity
    hud:addRectangle("fullScreenRed", 0, 0, screenW, screenH, 0xFF0000, 1.0)

    print("Full-screen shiny red square drawn on HUD.")

    while true do os.sleep(1) end
end

return Program
