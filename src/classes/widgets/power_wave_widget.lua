-- src/classes/widgets/power_wave_widget.lua

local GlassesWidget = require("classes.glasses_widget")
local Line2D = require("classes.elements.line2d")
local Rectangle2D = require("classes.elements.rectangle2d")
local Text2D = require("classes.elements.text2d")
local Colors = require("constants.colors")

local PowerWaveWidget = {}
PowerWaveWidget.__index = PowerWaveWidget

function PowerWaveWidget:new(id, glasses, hud, points, baseX, baseY, colorText)
    local obj = setmetatable({}, self)
    obj.base = GlassesWidget:new(id, glasses)
    obj.hud = hud
    obj.points = points or {}
    obj.baseX = baseX or 20
    obj.baseY = baseY or 1280

    local width = 920   -- shorter to NOT touch vanilla hotbar
    local height = 90   -- taller for bottom line to reach screen edge

    -- ✅ Background panel
    obj.base:addElement(Rectangle2D:new(
            id .. "_bg", glasses, hud,
            obj.baseX, obj.baseY,
            width, height,
            Colors.PURPLE_LIGHT, 0.5
    ))

    -- ✅ Thicker wave lines using Line2D (thick quad lines)
    for i = 1, #points - 1 do
        local x1 = obj.baseX + points[i][1]
        local y1 = obj.baseY + points[i][2]
        local x2 = obj.baseX + points[i + 1][1]
        local y2 = obj.baseY + points[i + 1][2]

        obj.base:addElement(Line2D:new(
                id .. "_seg_" .. i, glasses, hud,
                x1, y1, x2, y2,
                Colors.ACCENT1, 1.0, 4
        ))
    end

    -- ✅ Status text on right side, inside: % on top, EU/t on bottom
    obj.percentText = Text2D:new(
            id .. "_percent", glasses, hud,
            "80%", obj.baseX + width - 80, obj.baseY + 5,
            colorText, 1.5, 1.0
    )
    obj.base:addElement(obj.percentText)

    obj.euText = Text2D:new(
            id .. "_eu", glasses, hud,
            "+1200 EU/t", obj.baseX + width - 120, obj.baseY + height - 25,
            colorText, 1.5, 1.0
    )
    obj.base:addElement(obj.euText)

    return obj
end

function PowerWaveWidget:render()
    self.base:render()
end

return PowerWaveWidget
