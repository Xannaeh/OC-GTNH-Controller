-- src/programs/glasses_demo.lua
-- Demonstrates OC glasses: a 3D dot follows the player

local component = require("component")
local event = require("event")
local os = require("os")
local glassesMod = require("modules.glasses")
local GlassesConstants = require("constants.glasses_constants")

local hasPosition = component.isAvailable("position")
local hasDetector = component.isAvailable("player_detector")

local function getPlayerPosition()
    if hasPosition then
        return component.position.get()
    elseif hasDetector then
        local list = component.player_detector.getPlayers()
        if #list >= 1 then
            return component.player_detector.getPlayer(list[1])
        end
    end
    return nil
end

local Program = {}

function Program:run()
    if not component.isAvailable("glasses") then
        print("Error: glasses component not installed. Exiting.")
        return
    end
    if not (hasPosition or hasDetector) then
        print("Error: requires position or player_detector component. Exiting.")
        return
    end

    local g = glassesMod.init()
    g:clear()

    local dotId = "playerDot"
    print("Glasses demo running. Wear glasses and look around.")

    while true do
        local pos = getPlayerPosition()
        if pos then
            g:remove(dotId)
            g:addDot(dotId, pos.x, pos.y + 1.5, pos.z,
                    GlassesConstants.DEFAULT_COLOR,
                    GlassesConstants.DEFAULT_THROUGH)
            g:update()
        end
        os.sleep(GlassesConstants.TICK_RATE)
    end
end

return Program
