-- ===========================================
-- GTNH OC Automation System - settings.lua
-- Central config table for easy tuning
-- ===========================================
local Settings = {}

-- Update loop interval in seconds
Settings.updateInterval = 2

-- Device addresses (example)
Settings.powerDevice = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
Settings.fluidTanks = {
    nitrogen = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    oxygen = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

-- Display config
Settings.screenResolution = { width = 80, height = 25 }
Settings.hudEnabled = true

-- Logging
Settings.logFile = "/logs/events.log"

return Settings
