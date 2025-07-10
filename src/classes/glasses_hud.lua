local component = require("component")
local event = require("event")

local GlassesHUD = {}
GlassesHUD.__index = GlassesHUD

-- Internal hex to normalized RGB
local function RGB(hex)
    local r = ((hex >> 16) & 0xFF) / 255.0
    local g = ((hex >> 8) & 0xFF) / 255.0
    local b = (hex & 0xFF) / 255.0
    return r, g, b
end

function GlassesHUD:new(internalId, address, screenWidth, screenHeight, guiScale)
    local obj = setmetatable({}, self)
    obj.internalId = internalId
    obj.address = address
    obj.glasses = component.proxy(address)
    obj.widgets = {}
    obj.timers = {}

    -- Resolution and scale config
    obj.screenResolution = {screenWidth or 2560, screenHeight or 1440}
    obj.guiScale = guiScale or 3
    obj.virtualWidth = obj.screenResolution[1] / obj.guiScale
    obj.virtualHeight = obj.screenResolution[2] / obj.guiScale

    if not obj.glasses then
        error("[GlassesHUD] Could not proxy glasses component at: " .. tostring(address))
    end

    return obj
end

function GlassesHUD:setResolution(width, height)
    self.screenResolution = {width, height}
    self.virtualWidth = width / self.guiScale
    self.virtualHeight = height / self.guiScale
end

function GlassesHUD:setGuiScale(scale)
    self.guiScale = scale
    self.virtualWidth = self.screenResolution[1] / self.guiScale
    self.virtualHeight = self.screenResolution[2] / self.guiScale
end

function GlassesHUD:applyScale(value)
    return value / self.guiScale
end

function GlassesHUD:clear()
    local ok = pcall(function() self.glasses.removeAll() end)
    if not ok then error("[GlassesHUD] Failed to clear all widgets.") end
    self.widgets = {}
    for _, t in ipairs(self.timers) do event.cancel(t) end
    self.timers = {}
end

function GlassesHUD:addText(id, text, x, y, color, scale, alpha)
    local label = self.glasses.addTextLabel()
    if not label then error("[GlassesHUD] addTextLabel failed.") end

    label.setText(text)
    label.setPosition(self:applyScale(x), self:applyScale(y))
    label.setColor(RGB(color or 0xFFFFFF))
    label.setScale((scale or 1) / self.guiScale)  -- text scales too
    if alpha then label.setAlpha(alpha) end

    self.widgets[id] = label
    return label
end

function GlassesHUD:addRectangle(id, x, y, width, height, color, alpha)
    local quad = self.glasses.addQuad()
    if not quad then error("[GlassesHUD] addQuad failed.") end

    quad.setColor(RGB(color or 0xFFFFFF))
    quad.setAlpha(alpha or 1.0)

    local x1 = self:applyScale(x)
    local y1 = self:applyScale(y)
    local x2 = self:applyScale(x + width)
    local y2 = self:applyScale(y + height)

    quad.setVertex(1, x1, y1)
    quad.setVertex(2, x1, y2)
    quad.setVertex(3, x2, y2)
    quad.setVertex(4, x2, y1)

    self.widgets[id] = quad
    return quad
end

function GlassesHUD:addTriangle(id, v1, v2, v3, color, alpha)
    local triangle = self.glasses.addTriangle()
    if not triangle then error("[GlassesHUD] addTriangle failed.") end

    triangle.setColor(RGB(color or 0xFFFFFF))
    triangle.setAlpha(alpha or 1.0)

    triangle.setVertex(1, self:applyScale(v1[1]), self:applyScale(v1[2]))
    triangle.setVertex(2, self:applyScale(v2[1]), self:applyScale(v2[2]))
    triangle.setVertex(3, self:applyScale(v3[1]), self:applyScale(v3[2]))

    self.widgets[id] = triangle
    return triangle
end

function GlassesHUD:addLine(id, x1, y1, x2, y2, color, alpha)
    local line = self.glasses.addLine2D(
            self:applyScale(x1),
            self:applyScale(y1),
            self:applyScale(x2),
            self:applyScale(y2),
            RGB(color or 0xFFFFFF)
    )
    if not line then error("[GlassesHUD] addLine2D failed.") end
    if alpha then line.setAlpha(alpha) end

    self.widgets[id] = line
    return line
end

function GlassesHUD:remove(id)
    local w = self.widgets[id]
    if w then
        local ok = pcall(function() self.glasses.removeObject(w.getID()) end)
        if not ok then error("[GlassesHUD] Failed to remove widget ID: " .. tostring(id)) end
        self.widgets[id] = nil
    else
        error("[GlassesHUD] Tried to remove non-existent widget ID: " .. tostring(id))
    end
end

function GlassesHUD:updateText(id, newText)
    local w = self.widgets[id]
    if w and w.setText then
        local ok = pcall(function() w.setText(newText) end)
        if not ok then error("[GlassesHUD] Failed to update text for ID: " .. tostring(id)) end
    else
        error("[GlassesHUD] Cannot updateText, invalid widget ID: " .. tostring(id))
    end
end

function GlassesHUD:setOpacity(id, alpha)
    local w = self.widgets[id]
    if w and w.setAlpha then
        local ok = pcall(function() w.setAlpha(alpha) end)
        if not ok then error("[GlassesHUD] Failed to set opacity for ID: " .. tostring(id)) end
    else
        error("[GlassesHUD] Cannot setOpacity, invalid widget ID: " .. tostring(id))
    end
end

function GlassesHUD:blink(id, interval)
    local state = true
    local timer = event.timer(interval, function()
        local w = self.widgets[id]
        if w and w.setAlpha then
            w.setAlpha(state and 1 or 0)
            state = not state
        end
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
        if w and w.setAlpha then
            w.setAlpha(1 - (count / steps))
        end
        if count >= steps then event.cancel(timer) end
    end, steps)
    table.insert(self.timers, timer)
end

function GlassesHUD:updateLoop(interval, func)
    local timer = event.timer(interval, function()
        local ok, err = pcall(func)
        if not ok then error("[GlassesHUD] updateLoop error: " .. tostring(err)) end
    end, math.huge)
    table.insert(self.timers, timer)
end

return GlassesHUD
