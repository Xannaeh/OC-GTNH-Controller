-- src/programs/glasses_test.lua
-- Draws:
--  1️⃣ A centered red square
--  2️⃣ A bottom-left energy panel with border + text
--  3️⃣ Corner markers to verify screen bounds

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
-- ✅ Create centered square widget (debug info)
----------------------------------------------------
local function createCenteredSquareWidget(hud)
    local screenW, screenH = hud.screenResolution[1], hud.screenResolution[2]
    local squareSize = 200

    local px = (screenW - squareSize) / 2
    local py = (screenH - squareSize) / 2

    print("➡️ Screen resolution: " .. screenW .. "x" .. screenH)
    print("🟥 Centered square:")
    print("  Top-left corner: (" .. px .. ", " .. py .. ")")
    print("  Bottom-right corner: (" .. (px + squareSize) .. ", " .. (py + squareSize) .. ")")
    print("  Center point: (" .. (px + squareSize / 2) .. ", " .. (py + squareSize / 2) .. ")")

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
-- ✅ Create bottom-left energy panel widget (dynamic)
----------------------------------------------------
local function createBottomPanelWidget(hud)
    local screenH = hud.screenResolution[2]

    local panelWidget = GlassesWidget:new("bottom_panel", hud.glasses)

    local panelX = 0
    local panelH = 65
    local panelY = screenH - panelH  -- Snap to bottom
    local panelW = 1007

    local bgColor = 0xF1C6F4
    local borderColor = 0x635164

    print("🔲 Bottom panel:")
    print("  Top-left: (" .. panelX .. ", " .. panelY .. ")")
    print("  Bottom-right: (" .. (panelX + panelW) .. ", " .. (panelY + panelH) .. ")")

    -- Background
    panelWidget:addElement(Element.Rectangle2D:new(
            "panel_bg",
            hud.glasses, hud,
            panelX, panelY,
            panelW, panelH,
            bgColor, 1.0
    ))

    -- Borders
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

    -- Text inside
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
-- ✅ Create corner markers for visual bounds test
----------------------------------------------------
local function createCornerMarkers(hud)
    local markers = {}

    local screenW, screenH = hud.screenResolution[1], hud.screenResolution[2]
    local markerSize = 80

    local corners = {
        {
            name = "top_left",
            x = 0,
            y = 0,
            color = 0xFF0000
        },
        {
            name = "top_right",
            x = screenW - markerSize,
            y = 0,
            color = 0x00FF00
        },
        {
            name = "bottom_left",
            x = 0,
            y = screenH - markerSize,
            color = 0x0000FF
        },
        {
            name = "bottom_right",
            x = screenW - markerSize,
            y = screenH - markerSize,
            color = 0xFFFF00
        }
    }

    for _, corner in ipairs(corners) do
        print("🧩 Marker: " .. corner.name)
        print("  Top-left: (" .. corner.x .. ", " .. corner.y .. ")")
        print("  Bottom-right: (" .. (corner.x + markerSize) .. ", " .. (corner.y + markerSize) .. ")")

        local widget = GlassesWidget:new("marker_" .. corner.name, hud.glasses)

        widget:addElement(Element.Rectangle2D:new(
                "rect_" .. corner.name,
                hud.glasses, hud,
                corner.x, corner.y,
                markerSize, markerSize,
                corner.color,
                1.0
        ))

        table.insert(markers, widget)
    end

    return markers
end

----------------------------------------------------
-- ✅ Program main run
----------------------------------------------------
function Program:run()
    local glassesDevice = loadGlassesDevice()
    local hud = GlassesHUD:new(glassesDevice.internalId, glassesDevice.address, 2560, 1370, 3)

    hud:clear()

    local centerWidget = createCenteredSquareWidget(hud)
    local panelWidget = createBottomPanelWidget(hud)
    local markerWidgets = createCornerMarkers(hud)

    hud:addWidget(centerWidget)
    hud:addWidget(panelWidget)
    for _, w in ipairs(markerWidgets) do
        hud:addWidget(w)
    end

    hud:render()

    print("✅ Centered square + bottom panel + corners rendered!")

    while true do os.sleep(1) end
end

return Program
