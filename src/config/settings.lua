-- ===========================================
-- GTNH OC Automation System - settings.lua
-- Central config table for easy tuning
-- ===========================================
local Settings = {}

-- Update interval
Settings.updateInterval = 2

-- Power storage: GT Battery Buffer UUID
Settings.powerDevice = "afb812d4-a11f-498b-8f75-4d3cdb62e7f4"

-- Fluid Tanks: one GT machine UUID
Settings.fluidTanks = {
    main = "a45c6d6e-930c-41ef-a98b-97869ad1d667"
}

-- Screen settings
Settings.screenResolution = { width = 80, height = 25 }
Settings.hudEnabled = true

-- Log file
Settings.logFile = "/logs/events.log"

return Settings
