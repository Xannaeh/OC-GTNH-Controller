local component = require("component")
local event = require("event")

local GlassesHUD = {}
GlassesHUD.__index = GlassesHUD

function GlassesHUD:new(internalId, address, screenWidth, screenHeight, guiScale)
    local obj = setmetatable({}, self)
    obj.internalId = internalId
    obj.address = address
    obj.glasses = component.proxy(address)
    obj.widgets = {}
    obj.timers = {}

    obj.screenResolution = {screenWidth or 2560, screenHeight or 1440}
    obj.guiScale = guiScale or 3

    if not obj.glasses then
        error("[GlassesHUD] Could not proxy glasses component at: " .. tostring(address))
    end

    return obj
end

function GlassesHUD:setResolution(width, height)
    self.screenResolution = {width, height}
end

function GlassesHUD:setGuiScale(scale)
    self.guiScale = scale
end

function GlassesHUD:applyScale(value)
    return value / self.guiScale
end

function GlassesHUD:addWidget(widget)
    table.insert(self.widgets, widget)
end

function GlassesHUD:render()
    for _, widget in ipairs(self.widgets) do
        widget:render()
    end
end

function GlassesHUD:clear()
    local ok = pcall(function() self.glasses.removeAll() end)
    if not ok then error("[GlassesHUD] Failed to clear all widgets.") end
    self.widgets = {}
    for _, t in ipairs(self.timers) do event.cancel(t) end
    self.timers = {}
end

return GlassesHUD
