-- src/classes/elements/rectangle2d.lua
local Base = require("classes.glasses_element")
local Color = require("classes.utils.color")

local Rectangle2D = setmetatable({}, Base)
Rectangle2D.__index = Rectangle2D

function Rectangle2D:new(id, glasses, hud, x, y, width, height, color, alpha)
    local obj = Base.new(self, id, glasses, hud)
    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height
    obj.color = color or 0xFFFFFF
    obj.alpha = alpha or 1
    return obj
end

function Rectangle2D:draw()
    local quad = self.glasses.addQuad()
    quad.setColor(Color.RGB(self.color))
    quad.setAlpha(self.alpha)

    local x1 = self.hud:applyScale(self.x)
    local y1 = self.hud:applyScale(self.y)
    local x2 = self.hud:applyScale(self.x + self.width)
    local y2 = self.hud:applyScale(self.y + self.height)

    quad.setVertex(1, x1, y1)
    quad.setVertex(2, x1, y2)
    quad.setVertex(3, x2, y2)
    quad.setVertex(4, x2, y1)

    self.drawable = quad
end

return Rectangle2D
