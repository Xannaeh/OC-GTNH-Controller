local component = require("component")
local Logger = require("utils/Logger")
local ScreenUI = require("ui/ScreenUI")
local State = require("config/state")

local Fluid = {}
Fluid.units = {}

local function initTransposers()
    for _, info in ipairs(State.transposers) do
        local proxy = component.proxy(info.uuid)
        if proxy then
            table.insert(Fluid.units, {
                proxy = proxy,
                side = info.side or 0,
                id = info.uuid
            })
            Logger.info(("Fluid: found transposer %s (side %s)"):format(info.uuid, info.side or "?"))
        else
            Logger.error(("Fluid: could not init transposer %s"):format(info.uuid))
        end
    end
end

function Fluid.init(settings)
    initTransposers()
    Logger.info(("Fluid: %d transposer units ready"):format(#Fluid.units))
end

function Fluid.update()
    local statuses = {}
    for _, unit in ipairs(Fluid.units) do
        local t = unit.proxy
        local s = unit.side
        local count = t.getTankCount(s)
        local status = { id = unit.id }

        if count > 0 then
            local fluids = t.getFluidInTank(s, 1)  -- only first tank
            if fluids and fluids.amount then
                status.name, status.amount, status.capacity = fluids.name, fluids.amount, fluids.capacity
                status.percent = (fluids.amount / fluids.capacity) * 100
            end
        end

        statuses[#statuses + 1] = status
    end

    -- combine into UI
    local summary = {}
    for _, st in ipairs(statuses) do
        if st.name then
            table.insert(summary, string.format("[%s]: %s %.1f%% (%d/%d)",
                    st.id:sub(1,5), st.name, st.percent, st.amount, st.capacity))
        else
            table.insert(summary, ("[%s]: empty or no data"):format(st.id:sub(1,5)))
        end
    end

    local msg = table.concat(summary, " | ")
    Logger.info("Fluid: "..msg)
    ScreenUI.setFluidStatus(msg)
end

return Fluid
