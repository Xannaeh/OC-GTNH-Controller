-- ===========================================
-- GTNH OC Automation System - Fluid.lua
-- Log + Screen update
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")
local ScreenUI = require("ui/ScreenUI")

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

        local msg = string.format("%s: %.2f%% (%d / %d mB)", name, percent, amount, capacity)
        Logger.info("Fluid: " .. msg)
        ScreenUI.setFluidStatus(msg)
    end
end

return Fluid
