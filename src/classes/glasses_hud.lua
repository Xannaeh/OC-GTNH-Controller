-- src/classes/glasses_hud.lua
-- Manages active widget objects for glasses overlays

local GlassesHUD = {}
GlassesHUD.__index = GlassesHUD

function GlassesHUD:new(glassesProxy)
    local obj = {
        glasses = glassesProxy,
        widgets = {}, -- id → widget proxy
    }
    return setmetatable(obj, self)
end

function GlassesHUD:clear()
    self.glasses.removeAll()
    self.widgets = {}
end

function GlassesHUD:addDot(id, x, y, z, color, through)
    local w = self.glasses.addDot3D()
    w.set3DPos(x, y, z)
    w.setColor(color[1], color[2], color[3])
    if through then w.setVisibleThroughObjects(true) end
    self.widgets[id] = w
end

function GlassesHUD:remove(id)
    local w = self.widgets[id]
    if w then
        self.glasses.removeObject(w)
        self.widgets[id] = nil
    end
end

-- Placeholder for addLine, addCube, addText, etc.

function GlassesHUD:update()
    -- To be implemented: update widget positions/state
end

return GlassesHUD
