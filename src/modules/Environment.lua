-- ===========================================
-- GTNH OC Automation System - Environment.lua
-- Module for environment monitoring (TPS etc.)
-- ===========================================
local computer = require("computer")
local Logger = require("utils/Logger")

local Environment = {}

local lastTime = os.clock()
local lastUptime = computer.uptime()

function Environment.init(settings)
    Logger.info("Environment module initialized.")
end

function Environment.update()
    local uptime = computer.uptime()
    local delta = uptime - lastUptime
    local tps = 20

    if delta > 0 then
        tps = 1 / delta * 20
    end

    Logger.info(string.format("Approx TPS: %.2f", tps))

    lastUptime = uptime
end

return Environment
