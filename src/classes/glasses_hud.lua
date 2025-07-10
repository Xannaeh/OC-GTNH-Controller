local component = require("component")

local GlassesHUD = {}
GlassesHUD.__index = GlassesHUD

function GlassesHUD:new(internalId, address)
    local obj = setmetatable({}, self)
    obj.internalId = internalId
    obj.address = address
    obj.glasses = component.proxy(address)
    obj.widgets = {}
    return obj
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
    w.setPosition(x1, y1, x2, y2)
    w.setColor(color[1], color[2], color[3], color[4] or 1)
    self.widgets[id] = w
end

function GlassesHUD:addTextLabel(id, x, y, text, color, scale)
    local w = self.glasses.addTextLabel()
    w.setPosition(x, y)
    w.setText(text)
    w.setColor(color[1], color[2], color[3], color[4] or 1)
    w.setScale(scale or 0.02)
    self.widgets[id] = w
end

function GlassesHUD:update()
    -- placeholder for future dynamic updates if needed
end

return GlassesHUD
