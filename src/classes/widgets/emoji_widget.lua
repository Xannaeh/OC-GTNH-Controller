-- src/classes/widgets/emoji_widget.lua

local GlassesWidget = require("classes.glasses_widget")
local Text2D = require("classes.elements.text2d")
local Colors = require("constants.colors")

local EmojiWidget = {}
EmojiWidget.__index = EmojiWidget

function EmojiWidget:new(id, glasses, hud, emoji, x, y)
    local obj = setmetatable({}, self)
    obj.base = GlassesWidget:new(id, glasses)

    obj.base:addElement(Text2D:new(
            id .. "_emoji", glasses, hud,
            emoji, x, y,
            Colors.DECOR, 2.0, 1.0
    ))

    return obj
end

function EmojiWidget:render()
    self.base:render()
end

return EmojiWidget
