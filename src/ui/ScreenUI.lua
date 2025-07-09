-- ===========================================
-- GTNH OC Automation System - ScreenUI.lua
-- Improved screen UI with clear and redraw
-- ===========================================
local component = require("component")
local term = require("term")
local gpu = component.gpu
local Settings = require("config/settings")
local Logger = require("utils/Logger")

local ScreenUI = {}

function ScreenUI.init(settings)
    gpu.setResolution(settings.screenResolution.width, settings.screenResolution.height)
    term.clear()
    Logger.info("ScreenUI initialized.")
end

function ScreenUI.update()
    -- Clear the full screen
    term.clear()
    term.setCursor(1, 1)

    -- Redraw status lines
    term.write("GTNH OC Automation: Running...")

    -- Optionally show more info later:
    -- e.g. term.setCursor(1,2); term.write("Power: <value>")
end

return ScreenUI
