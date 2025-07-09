-- ===========================================
-- GTNH OC Automation System - Fluid.lua
-- Stronger probe: all method calls, force log errors too
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
    Logger.info("Fluid Test: Module initialized.")
end

function Fluid.update()
    for name, tank in pairs(tanks) do
        Logger.info(string.format("Fluid Test: Dumping methods for [%s]...", name))
        for k, v in pairs(tank) do
            if type(v) == "function" then
                local ok, result = pcall(v)
                if ok then
                    result = tostring(result)
                    if #result > 100 then
                        result = result:sub(1, 100) .. "..."
                    end
                    Logger.info(string.format("Fluid Test: [%s] %s() = %s", name, k, result))
                else
                    Logger.warn(string.format("Fluid Test: [%s] %s() threw error: %s", name, k, result))
                end
            end
        end
    end
end

return Fluid
