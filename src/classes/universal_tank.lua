local component = require("component")
local FluidStorage = require("classes.fluid_storage")

local UniversalTank = setmetatable({}, {__index = FluidStorage})
UniversalTank.__index = UniversalTank

function UniversalTank:new(internalId, address, fluid, side, capacity, amount, display)
    local obj = FluidStorage.new(self, internalId, address, fluid, side, capacity, amount, display)
    -- Only detect if *side* is nil *and* NO side saved
    if not obj.side or obj.side == -1 then
        print("[DEBUG] Running autoDetectSide()")
        obj.side = obj:autoDetectSide()
        print("[DEBUG] Side detected:", obj.side)
    end
    return obj
end


function UniversalTank:autoDetectSide()
    local transposer = component.proxy(self.address)
    local ctype = component.type(self.address)
    print("[DEBUG] UniversalTank: Using address:", self.address)
    print("[DEBUG] Detected component type:", ctype)

    for s = 0, 5 do
        print("[DEBUG] Checking side:", s)

        local success1, count = pcall(function() return transposer.getTankCount(s) end)
        if not success1 then
            print("[DEBUG] getTankCount failed on side", s, ":", tostring(count))
        else
            print("[DEBUG] getTankCount:", count)
            if count and count > 0 then
                local success2, fluids = pcall(function() return transposer.getFluidInTank(s) end)
                if not success2 then
                    print("[DEBUG] getFluidInTank failed:", tostring(fluids))
                else
                    if fluids and #fluids > 0 then
                        print("[DEBUG] Found fluid on side", s, ":", fluids[1].name)
                        return s
                    end
                end
            end
        end
    end

    print("[DEBUG] No valid side found, defaulting to 0")
    return 0
end


function UniversalTank:readFluidStatus()
    local transposer = component.proxy(self.address)
    local tank = transposer.getFluidInTank(self.side)
    if tank and #tank > 0 then
        self.fluid = tank[1].name or "Unknown"
        self.amount = tank[1].amount or 0
        self.capacity = transposer.getTankCapacity(self.side) or 0
    end
end

return UniversalTank
