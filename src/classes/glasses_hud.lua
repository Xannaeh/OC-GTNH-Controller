local component = require("component")
local event = require("event")
local GlassesHUD = {}
GlassesHUD.__index = GlassesHUD

function GlassesHUD:new(internalId, address)
    local obj = setmetatable({}, self)
    obj.internalId = internalId
    obj.address = address
    obj.glasses = component.proxy(address)
    obj.widgets = {}
    obj.timers = {}

    for k,v in pairs(require("component").proxy(address)) do print(k,v) end

    return obj
end

function GlassesHUD:clear()
    for _, w in pairs(self.widgets) do
        pcall(self.glasses.removeObject, self.glasses, w)
    end
    self.widgets = {}
    for _, t in ipairs(self.timers) do event.cancel(t) end
    self.timers = {}
end

function GlassesHUD:addText(id, x, y, text, color, scale)
    local w = self.glasses.addTextLabel(x, y, text, color)
    if scale and w.setScale then w:setScale(scale) end
    self.widgets[id] = w
    return w
end

function GlassesHUD:addIcon(id, x, y, itemId, scale, alpha)
    local w = self.glasses.addItem(x, y, itemId)
    if scale and w.setScale then w:setScale(scale) end
    if alpha and w.setOpacity then w:setOpacity(alpha) end
    self.widgets[id] = w
    return w
end

function GlassesHUD:Rect2D(id, x, y, width, height, color, alpha)
    local w = self.glasses.Rect2D(x, y, width, height, color)
    if alpha and w.setOpacity then w:setOpacity(alpha) end
    self.widgets[id] = w
    return w
end

function GlassesHUD:addLine(id, x1, y1, x2, y2, color, alpha)
    local w = self.glasses.addLine2D(x1, y1, x2, y2, color)
    if alpha and w.setOpacity then w:setOpacity(alpha) end
    self.widgets[id] = w
    return w
end

function GlassesHUD:remove(id)
    local w = self.widgets[id]
    if w then
        pcall(self.glasses.removeObject, self.glasses, w)
        self.widgets[id] = nil
    end
end

function GlassesHUD:updateText(id, newText)
    local w = self.widgets[id]
    if w and w.setText then w:setText(newText) end
end

function GlassesHUD:setOpacity(id, alpha)
    local w = self.widgets[id]
    if w and w.setOpacity then w:setOpacity(alpha) end
end

-- Timer-based animation utilities:

function GlassesHUD:blink(id, interval)
    local state = true
    local timer = event.timer(interval, function()
        local w = self.widgets[id]
        if w and w.setOpacity then
            w:setOpacity(state and 1 or 0)
        end
        state = not state
    end, math.huge)
    table.insert(self.timers, timer)
end

function GlassesHUD:fadeOut(id, duration, steps)
    steps = steps or 20
    local dt = duration / steps
    local count = 0
    local timer
    timer = event.timer(dt, function()
        count = count + 1
        local w = self.widgets[id]
        if w and w.setOpacity then
            w:setOpacity(1 - (count / steps))
        end
        if count >= steps then event.cancel(timer) end
    end, steps)
    table.insert(self.timers, timer)
end

function GlassesHUD:updateLoop(interval, func)
    local timer = event.timer(interval, function()
        pcall(func)
    end, math.huge)
    table.insert(self.timers, timer)
end

function GlassesHUD:update()
    -- placeholder for future dynamic updates if needed
end

return GlassesHUD
