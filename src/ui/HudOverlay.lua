-- ===========================================
-- GTNH OC Automation System - HudOverlay.lua
-- Simple OpenGlasses overlay test
-- ===========================================
local component = require("component")
local glasses = component.glasses
local Logger = require("utils/Logger")

local HudOverlay = {}

function HudOverlay.init(settings)
    if settings.hudEnabled and glasses then
        Logger.info("HUD overlay initialized.")
    else
        Logger.warn("HUD disabled or OpenGlasses not found.")
    end
end

function HudOverlay.update()
    -- Example: Clear and draw simple text
    if glasses then
        glasses.removeAll()
        glasses.addText(1, 1, "OC GTNH Base HUD", 0xFF00FF)
    end
end

return HudOverlay
