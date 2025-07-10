-- src/programs/glasses_demo.lua
-- Demo: glasses dot follows nearest player using os_entdetector

local component = require("component")
local osEnt = require("component").os_entdetector
local osTimer = require("event").timer
local os = require("os")

local glassesMod = require("modules.glasses")
local GlassesConstants = require("constants.glasses_constants")

local Program = {}

function Program:run()
    if not component.isAvailable("glasses") then
        print("Error: glasses component missing. Exiting.")
        return
    end
    if not component.isAvailable("os_entdetector") then
        print("Error: os_entdetector upgrade not found. Exiting.")
        return
    end

    local g = glassesMod.init()
    g:clear()

    local dotId = "playerDot"
    print("Glasses demo running. Scan for players near entity detector.")

    while true do
        local players = osEnt.scanPlayers(1)
        if players and #players > 0 then
            local p = players[1]
            g:remove(dotId)
            g:addDot(dotId, p.x, p.y + 1.5, p.z,
                    GlassesConstants.DEFAULT_COLOR,
                    GlassesConstants.DEFAULT_THROUGH)
            g:update()
        end
        os.sleep(GlassesConstants.TICK_RATE)
    end
end

return Program
