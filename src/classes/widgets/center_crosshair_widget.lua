-- src/classes/widgets/center_crosshair_widget.lua
local GlassesWidget = require("classes.glasses_widget")
local Line2D = require("classes.elements.line2d")
local Colors = require("constants.colors")

local CenterCrosshairWidget = {}
CenterCrosshairWidget.__index = CenterCrosshairWidget

function CenterCrosshairWidget:new(id, glasses, hud, thickness)
    local obj = setmetatable({}, self)
    obj.base = GlassesWidget:new(id, glasses)

    local centerX = hud.width / 2
    local centerY = hud.height / 2
    local offset = 100

    -- Right up line
    obj.base:addElement(Line2D:new(
            id .. "_line1", glasses, hud,
            centerX - offset, centerY - offset,
            centerX, centerY,
            0xFF0000, 1.0, thickness
    ))

    -- Right down line
    obj.base:addElement(Line2D:new(
            id .. "_line2", glasses, hud,
            centerX - offset, centerY + offset,
            centerX, centerY,
            0xFF0000, 1.0, thickness
    ))

    return obj
end

function CenterCrosshairWidget:render()
    self.base:render()
end

return CenterCrosshairWidget
