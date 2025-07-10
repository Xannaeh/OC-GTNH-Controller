-- src/programs/glasses_test.lua
-- Simple HUD test: draws a big red square in the middle of the HUD

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

    local data = file:read("*a")
    file:close()
    local devices = serialization.unserialize(data) or {}

    -- Find the first registered GlassesHud
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

    -- Create the HUD
    local hud = GlassesHUD:new(glassesDevice.internalId, glassesDevice.address)

    local squareSize = 60
    local screenW, screenH = 160, 90  -- adjust if different
    local cx = (screenW - squareSize) / 2
    local cy = (screenH - squareSize) / 2

    hud:addRect("centerSquare", cx, cy, squareSize, squareSize, 0xFF0000, 0.7)
    print("Red square drawn in the center of HUD.")

    print("Red square added at center of HUD.")

    -- Keep alive
    while true do
        os.sleep(1)
    end
end

return Program
