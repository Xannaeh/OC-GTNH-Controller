local component = require("component")
local Logger = require("utils/Logger")
local ScreenUI = require("ui/ScreenUI")
local StateHelper = require("utils/StateHelper")
local State = require("config/state")

local Fluid = {}
local transposer
local TANK_SIDE = nil
local STATE_PATH = "/home/src/config/state.lua"

function Fluid.init(settings)
    transposer = component.proxy(settings.transposer)
    if not transposer then
        Logger.error("Fluid: Transposer not found!")
        return
    end

    Logger.info(string.format("Fluid: Using Transposer UUID: %s", settings.transposer))

    local known = nil
    for _, t in ipairs(State.tanks or {}) do
        if t.uuid == settings.fluidTanks.main then
            known = t.side
            break
        end
    end

    if known then
        TANK_SIDE = known
        Logger.info("Fluid: Using cached side: " .. TANK_SIDE)
    else
        Logger.info("Fluid: Scanning for valid tank...")
        for side = 0, 5 do
            local count = transposer.getTankCount(side)
            if count and count > 0 then
                local fluids = transposer.getFluidInTank(side)
                if fluids and #fluids > 0 then
                    TANK_SIDE = side
                    table.insert(State.tanks, { uuid = settings.fluidTanks.main, side = side })
                    local ok, err = StateHelper.save(State, STATE_PATH)
                    if ok then
                        Logger.info("Fluid: Detected side " .. side .. " saved to state.")
                    else
                        Logger.error("Fluid: Failed to save state: " .. tostring(err))
                    end
                    break
                end
            end
        end

        if not TANK_SIDE then
            Logger.warn("Fluid: No valid tank found on any side.")
        end
    end

    Logger.info("Fluid module ready. Using side: " .. tostring(TANK_SIDE))
end

function Fluid.update()
    if not transposer or not TANK_SIDE then
        Logger.warn("Fluid: Not ready or no side set.")
        return
    end

    local fluids = transposer.getFluidInTank(TANK_SIDE)
    if not fluids or #fluids == 0 then
        Logger.warn("Fluid: Tank empty or not detected.")
        ScreenUI.setFluidStatus("Fluid: Empty.")
        return
    end

    local fluid = fluids[1]
    local amount = fluid.amount or 0
    local capacity = fluid.capacity or 1
    local percent = (amount / capacity) * 100
    local name = fluid.name or "?"

    local msg = string.format("Fluid: %s: %.1f%% (%d / %d mB)", name, percent, amount, capacity)
    Logger.info(msg)
    ScreenUI.setFluidStatus(msg)
end

return Fluid
