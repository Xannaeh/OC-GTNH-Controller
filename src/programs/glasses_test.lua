-- src/programs/glasses_test.lua
-- Draws:
--  1️⃣ A centered red square
--  2️⃣ A bottom-left energy panel with border and text

local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local GlassesWidget = require("classes.glasses_widget")
local Element = {
    Text2D = require("classes.elements.text2d"),
    Rectangle2D = require("classes.elements.rectangle2d")
}
local os = require("os")

local Program = {}

----------------------------------------------------
-- ✅ Load & find glasses device
----------------------------------------------------
local function loadGlassesDevice()
    local file = io.open("devices.dat", "r")
    if not file then
        print("No registered devices found.")
        os.exit()
    end

    local devices = serialization.unserialize(file:read("*a")) or {}
    file:close()

    for _, device in ipairs(devices) do
        if device.type == "GlassesHud" then
            return device
        end
    end

    print("No GlassesHud device registered.")
    os.exit()
end

----------------------------------------------------
-- ✅ Create centered square widget
----------------------------------------------------
local function createCenteredSquareWidget(hud)
    local screenW, screenH = hud.screenResolution[1], hud.screenResolution[2]
    local squareSize = 200

    local px = (screenW - squareSize) / 2
    local py = (screenH - squareSize) / 2

    local widget = GlassesWidget:new("centered_square", hud.glasses)

    widget:addElement(Element.Rectangle2D:new(
            "center_square",
            hud.glasses, hud,
            px, py,
            squareSize, squareSize,
            0xFF0000, 0.8
    ))

    widget:addElement(Element.Text2D:new(
            "center_label",
            hud.glasses, hud,
            "CENTER",
            px + squareSize / 4, py + squareSize / 4,
            0xFFFFFF,
            2.0, 1.0
    ))

    return widget
end

----------------------------------------------------
-- ✅ Create bottom-left energy panel widget
----------------------------------------------------
local function createBottomPanelWidget(hud)
    local panelWidget = GlassesWidget:new("bottom_panel", hud.glasses)

    local panelX, panelY = 0, 1374
    local panelW, panelH = 1007, 1439 - 1374  -- height = 65px

    local bgColor = 0xF1C6F4
    local borderColor = 0x635164

    -- Background
    panelWidget:addElement(Element.Rectangle2D:new(
            "panel_bg",
            hud.glasses, hud,
            panelX, panelY,
            panelW, panelH,
            bgColor, 1.0
    ))

    -- Borders: top, bottom, left, right
    panelWidget:addElement(Element.Rectangle2D:new(
            "panel_border_top",
            hud.glasses, hud,
            panelX, panelY,
            panelW, 1,
            borderColor, 1.0
    ))

    panelWidget:addElement(Element.Rectangle2D:new(
            "panel_border_bottom",
            hud.glasses, hud,
            panelX, panelY + panelH - 1,
            panelW, 1,
            borderColor, 1.0
    ))

    panelWidget:addElement(Element.Rectangle2D:new(
            "panel_border_left",
            hud.glasses, hud,
            panelX, panelY,
            1, panelH,
            borderColor, 1.0
    ))

    panelWidget:addElement(Element.Rectangle2D:new(
            "panel_border_right",
            hud.glasses, hud,
            panelX + panelW - 1, panelY,
            1, panelH,
            borderColor, 1.0
    ))

    -- Left-centered text
    panelWidget:addElement(Element.Text2D:new(
            "panel_text",
            hud.glasses, hud,
            "Hello ^_^ I'm your energy",
            panelX + 10, panelY + (panelH / 2) - 10,
            borderColor,
            2.0, 1.0
    ))

    return panelWidget
end

----------------------------------------------------
-- ✅ Program main run
----------------------------------------------------
function Program:run()
    local glassesDevice = loadGlassesDevice()
    local hud = GlassesHUD:new(glassesDevice.internalId, glassesDevice.address, 2560, 1440, 3)

    -- Clear existing
    hud:clear()

    -- Add widgets
    local centerWidget = createCenteredSquareWidget(hud)
    local panelWidget = createBottomPanelWidget(hud)

    hud:addWidget(centerWidget)
    hud:addWidget(panelWidget)

    -- Render all
    hud:render()

    print("✅ Centered square + bottom panel rendered!")

    while true do os.sleep(1) end
end

return Program
