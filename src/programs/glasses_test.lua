local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local GlassesWidget = require("classes.glasses_widget")
local Element = {
    Text2D = require("classes.elements.text2d"),
    Rectangle2D = require("classes.elements.rectangle2d"),
    Line2D = require("classes.elements.line2d"),
    Triangle2D = require("classes.elements.triangle2d")
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
    local cellSize = 64
    local textScale = 1.5

    local cols = math.floor(screenW / cellSize)
    local rows = math.floor(screenH / cellSize)

    local widget = GlassesWidget:new("checkerboard", hud.glasses)

    for y = 0, rows - 1 do
        for x = 0, cols - 1 do
            local px = x * cellSize
            local py = y * cellSize
            local isBlack = ((x + y) % 2 == 0)
            local color = isBlack and 0x000000 or 0xFFFFFF
            local labelColor = isBlack and 0xFFFFFF or 0x000000

            widget:addElement(Element.Rectangle2D:new("cell_"..x.."_"..y, hud.glasses, hud, px, py, cellSize, cellSize, color, 1.0))
            widget:addElement(Element.Text2D:new("label_"..x.."_"..y, hud.glasses, hud, x..","..y, px + 2, py + 2, labelColor, textScale, 1.0))
        end
        os.sleep(0)
    end

    hud:addWidget(widget)
    hud:render()

    print("Checkerboard widget rendered!")

    while true do os.sleep(1) end
end

return Program
