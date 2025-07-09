-- ===========================================
-- GTNH OC Automation System - HudOverlay.lua
-- Safe OpenGlasses HUD overlay with bulletproof checks
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")

local HudOverlay = {}

local glasses = nil

function HudOverlay.init(settings)
    if component.isAvailable("glasses") then
        glasses = component.glasses
        -- Confirm it has addText capability
        if glasses and glasses.addText then
            Logger.info("HUD overlay initialized (OpenGlasses linked).")
        else
            Logger.warn("OpenGlasses found but no addText function (are you paired?)")
            glasses = nil
        end
    else
        Logger.warn("HUD overlay skipped: OpenGlasses Terminal not found.")
    end
end

function HudOverlay.update()
    if glasses and glasses.addText then
        glasses.removeAll()
        glasses.addText(1, 1, "OC GTNH Base HUD", 0xFF00FF)
    end
end

return HudOverlay
