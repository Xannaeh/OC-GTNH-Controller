-- src/classes/elements/triangle2d.lua
local Base = require("classes.glasses_element")
local Color = require("classes.utils.color")


local Triangle2D = setmetatable({}, Base)
Triangle2D.__index = Triangle2D

function Triangle2D:new(id, glasses, hud, v1, v2, v3, color, alpha)
    local obj = Base.new(self, id, glasses, hud)
    obj.v1 = v1
    obj.v2 = v2
    obj.v3 = v3
    obj.color = color or 0xFFFFFF
    obj.alpha = alpha or 1
    return obj
end

function Triangle2D:draw()
    local triangle = self.glasses.addTriangle()
    triangle.setColor(Color.RGB(self.color))
    triangle.setAlpha(self.alpha)
    triangle.setVertex(1, self.hud:applyScale(self.v1[1]), self.hud:applyScale(self.v1[2]))
    triangle.setVertex(2, self.hud:applyScale(self.v2[1]), self.hud:applyScale(self.v2[2]))
    triangle.setVertex(3, self.hud:applyScale(self.v3[1]), self.hud:applyScale(self.v3[2]))
    self.drawable = triangle
end

return Triangle2D
