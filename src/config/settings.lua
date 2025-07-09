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
Settings.transposer = "0b863cd7-daba-47e3-bc46-5074614a7782"


-- Screen settings
Settings.screenResolution = { width = 80, height = 25 }
Settings.hudEnabled = true

-- Log file
Settings.logFile = "/home/logs/events.log"

return Settings
