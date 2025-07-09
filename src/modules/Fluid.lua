-- ===========================================
-- GTNH OC Automation System - Fluid.lua
-- Module for fluid tank monitoring
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
        local fluid = tank.getFluidInTank(1)
        local amount = fluid[1] and fluid[1].amount or 0
        local capacity = fluid[1] and fluid[1].capacity or 1

        local percent = (amount / capacity) * 100
        Logger.info(string.format("Tank [%s]: %.1f%% (%d / %d mB)", name, percent, amount, capacity))
    end
end

return Fluid
