-- src/programs/glasses_test.lua
-- Simple HUD test: draws a big red square in the middle using addRect

local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local os = require("os")

local Program = {}

function Program:run()
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

    local squareSize = 60
    local screenW, screenH = 160, 90
    local cx = (screenW - squareSize) / 2
    local cy = (screenH - squareSize) / 2

    hud:addRect("centerSquare", cx, cy, squareSize, squareSize, 0xFF0000, 0.7)

    print("Red square drawn in the center of HUD.")

    while true do os.sleep(1) end
end

return Program
