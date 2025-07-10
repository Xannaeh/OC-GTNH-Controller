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

    -- Dimensions for the red square
    local squareSize = 60  -- in HUD "pixels"
    -- Assuming a virtual screen size; adjust as your HUD uses
    local screenW, screenH = 160, 90
    local centerX = (screenW - squareSize) / 2
    local centerY = (screenH - squareSize) / 2

    -- Draw big red square in middle
    hud:addBox(
            "centerSquare",
            centerX, centerY,
            squareSize, squareSize,
            0xFF0000,  -- HEX color for red
            0.7        -- alpha/transparency 0-1
    )

    print("Red square added at center of HUD.")

    -- Keep alive
    while true do
        os.sleep(1)
    end
end

return Program
