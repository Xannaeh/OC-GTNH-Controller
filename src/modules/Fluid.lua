-- ===========================================
-- GTNH OC Automation System - Fluid.lua
-- Robust GT Machine fluid reading with debug logs
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")
local ScreenUI = require("ui/ScreenUI")

local Fluid = {}
local tanks = {}

function Fluid.init(settings)
    for name, address in pairs(settings.fluidTanks) do
        Logger.info(string.format("Fluid: Trying to proxy tank [%s] UUID: %s", name, address))
        local tank = component.proxy(address)
        if tank then
            Logger.info(string.format("Fluid: Proxy created for tank [%s].", name))
            tanks[name] = tank
        else
            Logger.error(string.format("Fluid: Proxy failed for tank [%s] — device not found!", name))
        end
    end
    Logger.info("Fluid module initialized.")
end

function Fluid.update()
    for name, tank in pairs(tanks) do
        if not tank then
            Logger.error(string.format("Fluid: Tank [%s] proxy is nil!", name))
            goto continue
        end

        if not tank.getStoredSteam then
            Logger.error(string.format("Fluid: Tank [%s] has no getStoredSteam method!", name))
            goto continue
        end
        if not tank.getSteamCapacity then
            Logger.error(string.format("Fluid: Tank [%s] has no getSteamCapacity method!", name))
            goto continue
        end

        local amount = tank.getStoredSteam()
        local capacity = tank.getSteamCapacity()

        if not amount then
            Logger.error(string.format("Fluid: Tank [%s] getStoredSteam returned nil!", name))
            goto continue
        end
        if not capacity then
            Logger.error(string.format("Fluid: Tank [%s] getSteamCapacity returned nil!", name))
            goto continue
        end

        local percent = (amount / capacity) * 100
        local msg = string.format("%s: %.2f%% (%d / %d mB)", name, percent, amount, capacity)

        Logger.info("Fluid: " .. msg)
        ScreenUI.setFluidStatus(msg)

        ::continue::
    end
end

return Fluid
