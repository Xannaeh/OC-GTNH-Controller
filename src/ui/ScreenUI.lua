-- ===========================================
-- GTNH OC Automation System - ScreenUI.lua
-- Simple screen text output
-- ===========================================
local component = require("component")
local term = require("term")
local gpu = component.gpu
local Logger = require("utils/Logger")

local ScreenUI = {}

function ScreenUI.init(settings)
    gpu.setResolution(settings.screenResolution.width, settings.screenResolution.height)
    term.clear()
    Logger.info("ScreenUI initialized.")
end

function ScreenUI.update()
    term.setCursor(1, 1)
    term.clearLine()
    term.write("GTNH OC Automation: Running...")

    -- For now, minimal placeholder
end

return ScreenUI
