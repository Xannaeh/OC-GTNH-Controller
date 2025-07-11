-- src/classes/elements/line2d.lua
local Base = require("classes.glasses_element")
local Color = require("classes.utils.color")

local Line2D = setmetatable({}, Base)
Line2D.__index = Line2D

function Line2D:new(id, glasses, hud, x1, y1, x2, y2, color, alpha, thickness)
    local obj = Base.new(self, id, glasses, hud)
    obj.x1 = x1
    obj.y1 = y1
    obj.x2 = x2
    obj.y2 = y2
    obj.color = color or 0xFFFFFF
    obj.alpha = alpha or 1
    obj.thickness = thickness or 2
    return obj
end

function Line2D:draw()
    local quad = self.glasses.addQuad()
    quad.setColor(Color.RGB(self.color))
    quad.setAlpha(self.alpha)

    local dx = self.x2 - self.x1
    local dy = self.y2 - self.y1
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 0.001 then len = 1 end  -- prevent zero division

    local nx = -dy / len * self.thickness / 2
    local ny =  dx / len * self.thickness / 2

    quad.setVertex(1, self.hud:applyScale(self.x1 + nx), self.hud:applyScale(self.y1 + ny))
    quad.setVertex(2, self.hud:applyScale(self.x1 - nx), self.hud:applyScale(self.y1 - ny))
    quad.setVertex(3, self.hud:applyScale(self.x2 - nx), self.hud:applyScale(self.y2 - ny))
    quad.setVertex(4, self.hud:applyScale(self.x2 + nx), self.hud:applyScale(self.y2 + ny))

    self.drawable = quad
end

return Line2D
