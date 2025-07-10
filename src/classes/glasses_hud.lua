-- src/classes/glasses_hud.lua
-- Manages active widget objects for glasses overlays

local GlassesHUD = {}
GlassesHUD.__index = GlassesHUD

function GlassesHUD:new(glassesProxy)
    return setmetatable({
        glasses = glassesProxy,
        widgets = {}
    }, self)
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

function GlassesHUD:addQuad(id, x1, y1, x2, y2, color)
    local w = self.glasses.addQuad()
    w.set(x1, y1, x2, y2)
    w.setColor(color[1], color[2], color[3], color[4] or 1)
    self.widgets[id] = w
end

function GlassesHUD:addTextLabel(id, x, y, text, color, scale)
    local w = self.glasses.addTextLabel()
    w.set(x, y, text, color[1], color[2], color[3], color[4] or 1, scale or 0.02)
    self.widgets[id] = w
end


function GlassesHUD:update()
    -- Optional: update widget positions/state if needed later
end

return GlassesHUD
