-- src/programs/glasses_demo.lua
-- Demonstrates OC glasses: a 3D dot follows the player

local component = require("component")
local event = require("event")
local os = require("os")
local glassesMod = require("modules.glasses")
local GlassesConstants = require("constants.glasses_constants")

assert(component.isAvailable("glasses"), "Requires glasses upgrade")
assert(component.isAvailable("player_detector") or component.isAvailable("position"), "Requires position component")

local g = glassesMod.init()
g:clear()

local dotId = "playerDot"

local function getPlayerPosition()
    if component.isAvailable("position") then
        return component.position.get()
    elseif component.isAvailable("player_detector") then
        local list = component.player_detector.getPlayers()
        if #list >= 1 then
            return component.player_detector.getPlayer(list[1])
        end
    end
    return nil
end

print("Glasses demo running. Wear glasses and look at your character.")

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
