-- ===========================================
-- GTNH OC Automation System - HudOverlay.lua
-- Safe OpenGlasses HUD overlay
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")

local glasses = component.isAvailable("glasses") and component.glasses or nil

local HudOverlay = {}

function HudOverlay.init(settings)
    if glasses then
        Logger.info("HUD overlay initialized.")
    else
        Logger.warn("HUD overlay skipped: OpenGlasses not found or not paired.")
    end
end

function HudOverlay.update()
    if glasses then
        glasses.removeAll()
        glasses.addText(1, 1, "OC GTNH Base HUD", 0xFF00FF)
    end
end

return HudOverlay
