-- src/programs/glasses_test.lua
-- Draws a single centered square using the modular HUD system

local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local GlassesWidget = require("classes.glasses_widget")
local Element = {
    Text2D = require("classes.elements.text2d"),
    Rectangle2D = require("classes.elements.rectangle2d")
}
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

    local hud = GlassesHUD:new(glassesDevice.internalId, glassesDevice.address, 2560, 1440, 3)
    hud:clear()

    local screenW, screenH = hud.screenResolution[1], hud.screenResolution[2]

    -- Desired square size
    local squareSize = 200  -- in real screen pixels

    -- Calculate top-left corner for centered position
    local px = (screenW - squareSize) / 2
    local py = (screenH - squareSize) / 2

    local widget = GlassesWidget:new("centered_square", hud.glasses)

    -- Add the centered square
    widget:addElement(
            Element.Rectangle2D:new(
                    "center_square",
                    hud.glasses,
                    hud,
                    px, py,
                    squareSize, squareSize,
                    0xFF0000, -- bright red
                    0.8       -- slightly transparent
            )
    )

    -- Add a text label in the center
    widget:addElement(
            Element.Text2D:new(
                    "center_label",
                    hud.glasses,
                    hud,
                    "CENTER",
                    px + squareSize / 4,
                    py + squareSize / 4,
                    0xFFFFFF,
                    2.0,   -- text scale
                    1.0    -- alpha
            )
    )

    hud:addWidget(widget)
    hud:render()

    print("Centered square rendered!")

    while true do os.sleep(1) end
end

return Program
