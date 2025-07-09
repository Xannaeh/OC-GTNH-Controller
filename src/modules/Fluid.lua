-- ===========================================
-- GTNH OC Automation System - Fluid.lua
-- Correct GT Machine fluid reading
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")

local Fluid = {}
local tanks = {}

function Fluid.init(settings)
    for name, address in pairs(settings.fluidTanks) do
        tanks[name] = component.proxy(address)
    end
    Logger.info("Fluid module initialized.")
end

function Fluid.update()
    for name, tank in pairs(tanks) do
        local amount = tank.getStoredSteam()
        local capacity = tank.getSteamCapacity()
        local percent = (amount / capacity) * 100

        Logger.info(string.format("Tank [%s]: %.2f%% (%d / %d)", name, percent, amount, capacity))
    end
end

return Fluid
