local Settings = {}

Settings.updateInterval = 2

-- main lists just hold the first/defaults; extras go in state.lua
Settings.powerDevice = {"d23fb12d-a11a-4f54-b1d5-a47897ac0e74"}
Settings.transposers = {"0b863cd7-daba-47e3-bc46-5074614a7782"}

Settings.screenResolution = { width = 80, height = 25 }
Settings.hudEnabled = true
Settings.logFile = "/home/logs/events.log"

return Settings
