-- src/classes/widgets/bar_widget.lua

local GlassesWidget = require("classes.glasses_widget")
local Rectangle2D = require("classes.elements.rectangle2d")
local Text2D = require("classes.elements.text2d")
local Colors = require("constants.colors")

local BarWidget = {}
BarWidget.__index = BarWidget

function BarWidget:new(id, glasses, hud, x, y, width, height, colorFill, colorBorder, liquidName, colorText)
    local obj = setmetatable({}, self)
    obj.base = GlassesWidget:new(id, glasses)
    obj.hud = hud
    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height
    obj.colorFill = colorFill
    obj.colorBorder = colorBorder
    obj.liquidName = liquidName
    obj.percent = 100

    -- Border
    obj.base:addElement(Rectangle2D:new(
            id .. "_border", glasses, hud,
            x, y, width, height, colorBorder, 1.0
    ))

    -- Fill
    obj.fillElement = Rectangle2D:new(
            id .. "_fill", glasses, hud,
            x + 1, y + 1, width - 2, height - 2,
            colorFill, 1.0
    )
    obj.base:addElement(obj.fillElement)

    -- Text: % inside bar bottom
    obj.percentText = Text2D:new(
            id .. "_percent", glasses, hud,
            obj.percent .. "%", x + 4, y + height - 25,
            colorText, 1.2, 1.0
    )
    obj.base:addElement(obj.percentText)

    -- Text: name inside bar above %
    obj.nameText = Text2D:new(
            id .. "_name", glasses, hud,
            liquidName, x + 4, y + height - 12,
            colorText, 1.2, 1.0
    )
    obj.base:addElement(obj.nameText)

    return obj
end

function BarWidget:render()
    self.base:render()
end

function BarWidget:updateFill(percent)
    self.percent = percent
    local newHeight = (self.height - 2) * (percent / 100)
    self.fillElement.height = newHeight
    self.percentText.text = percent .. "%"
end

return BarWidget
