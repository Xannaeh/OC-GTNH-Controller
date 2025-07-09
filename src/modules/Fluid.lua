-- ===========================================
-- GTNH OC Automation System - Fluid.lua
-- Hardcoded manual method tests
-- ===========================================
local component = require("component")
local Logger = require("utils/Logger")

local Fluid = {}
local tanks = {}

function Fluid.init(settings)
    for name, address in pairs(settings.fluidTanks) do
        Logger.info(string.format("Fluid Test: Trying to proxy tank [%s] UUID: %s", name, address))
        local tank = component.proxy(address)
        if tank then
            Logger.info(string.format("Fluid Test: Proxy created for tank [%s].", name))
            tanks[name] = tank
        else
            Logger.error(string.format("Fluid Test: Proxy failed for tank [%s]!", name))
        end
    end
    Logger.info("Fluid Test: Manual Method Probe Mode Ready.")
end

function Fluid.update()
    for name, tank in pairs(tanks) do
        Logger.info(string.format("Fluid Test: BEGIN manual checks for [%s]...", name))

        local function safeCall(methodName)
            if tank[methodName] then
                local ok, result = pcall(tank[methodName])
                if ok then
                    Logger.info(string.format("Fluid Test: [%s] %s() = %s", name, methodName, tostring(result)))
                else
                    Logger.warn(string.format("Fluid Test: [%s] %s() threw: %s", name, methodName, result))
                end
            else
                Logger.warn(string.format("Fluid Test: [%s] %s() not found!", name, methodName))
            end
        end

        -- 🔍 TEST THESE BY HAND:
        safeCall("getStoredSteam")
        safeCall("getSteamStored")
        safeCall("getSteamMaxStored")
        safeCall("getSteamCapacity")
        safeCall("getStoredEU")
        safeCall("getEUStored")
        safeCall("getEUCapacity")
        safeCall("getEUCapacityString")
        safeCall("getStoredEUString")
        safeCall("getWorkProgress")
        safeCall("getWorkMaxProgress")
        safeCall("getCoordinates")
        safeCall("getName")
        safeCall("isMachineActive")

        Logger.info(string.format("Fluid Test: END manual checks for [%s].", name))
    end
end

return Fluid
