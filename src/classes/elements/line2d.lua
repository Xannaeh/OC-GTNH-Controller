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

    -- Line length
    local len = math.sqrt(dx*dx + dy*dy)
    if len < 0.001 then len = 1 end

    -- Unit direction
    local ux = dx / len
    local uy = dy / len

    -- Perpendicular unit
    local px = -uy
    local py =  ux

    -- Half thickness offset
    local tx = px * (self.thickness / 2)
    local ty = py * (self.thickness / 2)

    -- Build corners: CCW
    local x1 = self.x1 + tx
    local y1 = self.y1 + ty
    local x2 = self.x1 - tx
    local y2 = self.y1 - ty
    local x3 = self.x2 - tx
    local y3 = self.y2 - ty
    local x4 = self.x2 + tx
    local y4 = self.y2 + ty

    quad.setVertex(1, self.hud:applyScale(x1), self.hud:applyScale(y1))
    quad.setVertex(2, self.hud:applyScale(x2), self.hud:applyScale(y2))
    quad.setVertex(3, self.hud:applyScale(x3), self.hud:applyScale(y3))
    quad.setVertex(4, self.hud:applyScale(x4), self.hud:applyScale(y4))

    self.drawable = quad
end

return Line2D
