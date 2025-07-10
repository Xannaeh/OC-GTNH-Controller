-- src/modules/glasses.lua
-- Wrapper for component.glasses

local component = require("component")
local GlassesHUD = require("classes.glasses_hud")

local Glasses = {}
Glasses.__index = Glasses

function Glasses.init()
    assert(component.isAvailable("glasses"), "Glasses component required")
    return setmetatable({ hud = GlassesHUD:new(component.glasses) }, Glasses)
end

function Glasses:clear()
    self.hud:clear()
end

function Glasses:update()
    self.hud:update()
end

function Glasses:addDot(id, pos, color, through)
    self.hud:addDot(id, pos.x, pos.y, pos.z, color, through)
end

function Glasses:addQuad2D(id, x1, y1, x2, y2, color)
    self.hud:addQuad2D(id, x1, y1, x2, y2, color)
end

function Glasses:addTextLabel(id, x, y, text, color, scale)
    self.hud:addTextLabel(id, x, y, text, color, scale)
end

return Glasses
