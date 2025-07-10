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
    if not obj.glasses then
        error("[GlassesHUD] Failed to proxy glasses component at address: " .. tostring(address))
    end
    return obj
end

function GlassesHUD:clear()
    for _, w in pairs(self.widgets) do
        local ok, err = pcall(self.glasses.removeObject, self.glasses, w)
        if not ok then
            error("[GlassesHUD] Failed to remove widget: " .. tostring(err))
        end
    end
    self.widgets = {}
    for _, t in ipairs(self.timers) do event.cancel(t) end
    self.timers = {}
end

function GlassesHUD:addText(id, x, y, text, color, scale)
    if not self.glasses.addTextLabel then error("[GlassesHUD] addTextLabel method not available") end
    local ok, w = pcall(self.glasses.addTextLabel, x, y, text, color)
    if not ok then error("[GlassesHUD] Failed to add text: " .. tostring(w)) end
    if scale and w.setScale then w:setScale(scale) end
    self.widgets[id] = w
    return w
end

function GlassesHUD:addIcon(id, x, y, itemId, scale, alpha)
    if not self.glasses.addItem then error("[GlassesHUD] addItem method not available") end
    local ok, w = pcall(self.glasses.addItem, x, y, itemId)
    if not ok then error("[GlassesHUD] Failed to add icon: " .. tostring(w)) end
    if scale and w.setScale then w:setScale(scale) end
    if alpha and w.setOpacity then w:setOpacity(alpha) end
    self.widgets[id] = w
    return w
end

function GlassesHUD:addRect(id, x, y, width, height, color, alpha)
    if not self.glasses.addRect then error("[GlassesHUD] addRect method not available") end
    local ok, w = pcall(self.glasses.addRect, x, y, width, height, color)
    if not ok then error("[GlassesHUD] Failed to add rectangle: " .. tostring(w)) end
    if alpha and w.setOpacity then w:setOpacity(alpha) end
    self.widgets[id] = w
    return w
end

function GlassesHUD:addLine(id, x1, y1, x2, y2, color, alpha)
    if not self.glasses.addLine2D then error("[GlassesHUD] addLine2D method not available") end
    local ok, w = pcall(self.glasses.addLine2D, x1, y1, x2, y2, color)
    if not ok then error("[GlassesHUD] Failed to add line: " .. tostring(w)) end
    if alpha and w.setOpacity then w:setOpacity(alpha) end
    self.widgets[id] = w
    return w
end

function GlassesHUD:remove(id)
    local w = self.widgets[id]
    if w then
        local ok, err = pcall(self.glasses.removeObject, self.glasses, w)
        if not ok then error("[GlassesHUD] Failed to remove widget: " .. tostring(err)) end
        self.widgets[id] = nil
    else
        error("[GlassesHUD] Tried to remove non-existent widget ID: " .. tostring(id))
    end
end

function GlassesHUD:updateText(id, newText)
    local w = self.widgets[id]
    if w and w.setText then
        local ok, err = pcall(w.setText, newText)
        if not ok then error("[GlassesHUD] Failed to update text: " .. tostring(err)) end
    else
        error("[GlassesHUD] Cannot updateText, widget not found or invalid: " .. tostring(id))
    end
end

function GlassesHUD:setOpacity(id, alpha)
    local w = self.widgets[id]
    if w and w.setOpacity then
        local ok, err = pcall(w.setOpacity, alpha)
        if not ok then error("[GlassesHUD] Failed to set opacity: " .. tostring(err)) end
    else
        error("[GlassesHUD] Cannot setOpacity, widget not found or invalid: " .. tostring(id))
    end
end

function GlassesHUD:blink(id, interval)
    local state = true
    local timer = event.timer(interval, function()
        local w = self.widgets[id]
        if w and w.setOpacity then
            local ok = pcall(w.setOpacity, state and 1 or 0)
            if not ok then error("[GlassesHUD] Blink failed for widget: " .. tostring(id)) end
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
            local alpha = 1 - (count / steps)
            local ok = pcall(w.setOpacity, alpha)
            if not ok then error("[GlassesHUD] fadeOut failed for widget: " .. tostring(id)) end
        end
        if count >= steps then event.cancel(timer) end
    end, steps)
    table.insert(self.timers, timer)
end

function GlassesHUD:updateLoop(interval, func)
    local timer = event.timer(interval, function()
        local ok, err = pcall(func)
        if not ok then error("[GlassesHUD] updateLoop function failed: " .. tostring(err)) end
    end, math.huge)
    table.insert(self.timers, timer)
end

return GlassesHUD
