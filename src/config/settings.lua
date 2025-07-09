-- ===========================================
-- GTNH OC Automation System - settings.lua
-- Single source of truth for config
-- ===========================================
local Settings = {}

-- Update interval
Settings.updateInterval = 2

-- Power storage: GT Battery Buffer UUID
Settings.powerDevice = "d23fb12d-a11a-4f54-b1d5-a47897ac0e74"

-- Fluid Tanks: one GT machine UUID
Settings.fluidTanks = {
    main = "a45c6d6e-930c-41ef-a98b-97869ad1d667"
}


-- Screen settings
Settings.screenResolution = { width = 80, height = 25 }
Settings.hudEnabled = true

-- Log file
Settings.logFile = "/home/logs/events.log"  -- ✅ now uses /home/logs

return Settings
