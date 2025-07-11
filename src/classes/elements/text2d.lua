-- src/classes/elements/text2d.lua
local Base = require("classes.glasses_element")
local Color = require("classes.utils.color")


local Text2D = setmetatable({}, Base)
Text2D.__index = Text2D

function Text2D:new(id, glasses, hud, text, x, y, color, scale, alpha)
    local obj = Base.new(self, id, glasses, hud)
    obj.text = text
    obj.x = x
    obj.y = y
    obj.color = color or 0xFFFFFF
    obj.scale = scale or 1
    obj.alpha = alpha or 1
    return obj
end

function Text2D:draw()
    local label = self.glasses.addTextLabel()
    label.setText(self.text)
    label.setPosition(self.hud:applyScale(self.x), self.hud:applyScale(self.y))
    label.setColor(Color.RGB(self.color))
    label.setScale(self.scale / self.hud.guiScale)
    if self.alpha then label.setAlpha(self.alpha) end
    self.drawable = label
end

return Text2D
