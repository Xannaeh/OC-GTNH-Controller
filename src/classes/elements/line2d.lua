-- src/classes/elements/line2d.lua
local Base = require("classes.glasses_element")
local Color = require("classes.utils.color")

local Line2D = setmetatable({}, Base)
Line2D.__index = Line2D

function Line2D:new(id, glasses, hud, x1, y1, x2, y2, color, alpha)
    local obj = Base.new(self, id, glasses, hud)
    obj.x1 = x1
    obj.y1 = y1
    obj.x2 = x2
    obj.y2 = y2
    obj.color = color or 0xFFFFFF
    obj.alpha = alpha or 1
    return obj
end

function Line2D:draw()
    local line = self.glasses.addLine2D(
            self.hud:applyScale(self.x1),
            self.hud:applyScale(self.y1),
            self.hud:applyScale(self.x2),
            self.hud:applyScale(self.y2),
            Color.RGB(self.color)
    )
    if self.alpha then line.setAlpha(self.alpha) end
    self.drawable = line
end

return Line2D
