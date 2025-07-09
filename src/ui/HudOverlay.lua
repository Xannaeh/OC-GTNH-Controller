-- ===========================================
-- GTNH OC Automation System - HudOverlay.lua
-- Correct OpenGlasses HUD using addTextLabel
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")

local HudOverlay = {}

local glasses

function HudOverlay.init(settings)
    if component.isAvailable("glasses") then
        glasses = component.glasses
        if glasses and glasses.addTextLabel then
            Logger.info("HUD overlay initialized (OpenGlasses linked).")
        else
            Logger.warn("OpenGlasses found but addTextLabel missing. Check pairing.")
            glasses = nil
        end
    else
        Logger.warn("HUD overlay skipped: OpenGlasses not found.")
    end
end

function HudOverlay.update()
    if glasses and glasses.addTextLabel then
        glasses.removeAll()
        glasses.addTextLabel(1, 1, "OC GTNH Base HUD", 0xFF00FF)
    end
end

return HudOverlay
