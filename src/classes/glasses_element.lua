-- src/classes/glasses_element.lua
local GlassesElement = {}
GlassesElement.__index = GlassesElement

function GlassesElement:new(id, glasses, hud)
    local obj = setmetatable({}, self)
    obj.id = id
    obj.glasses = glasses
    obj.hud = hud
    obj.drawable = nil
    return obj
end

function GlassesElement:draw()
    error("[GlassesElement] draw() must be implemented in subclass")
end

function GlassesElement:remove()
    if self.drawable then
        self.glasses.removeObject(self.drawable.getID())
        self.drawable = nil
    end
end

return GlassesElement
