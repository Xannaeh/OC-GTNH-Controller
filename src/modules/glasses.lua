-- src/modules/glasses.lua
-- Wrapper for component.glasses

local component = require("component")
local GlassesHUD = require("classes.glasses_hud")

local Glasses = {}
Glasses.__index = Glasses

function Glasses.init()
    assert(component.isAvailable("glasses"), "Glasses component required")
    local proxy = component.glasses
    local hud = GlassesHUD:new(proxy)
    return setmetatable({ hud = hud }, Glasses)
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

-- More methods (addLine, addCube, etc.)...

return Glasses
