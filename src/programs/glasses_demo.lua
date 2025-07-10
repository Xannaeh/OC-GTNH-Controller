-- src/programs/glasses_test.lua
-- Simple glasses test: draws a cube in front of the wearer

local component = require("component")
local os = require("os")
local GlassesHUD = require("classes.glasses_hud")
local GlassesConstants = require("constants.glasses_constants")

local Program = {}

function Program:run()
    if not component.isAvailable("glasses") then
        print("Error: glasses upgrade not installed. Exiting.")
        return
    end

    local hud = GlassesHUD:new(component.glasses)
    hud:clear()

    local id = "testCube"
    local size = 1
    local x, y, z = 0, 1.5, 2 -- cube center 2 blocks ahead
    local color = {1, 1, 0} -- yellow

    local cube = hud.glasses.addCube3D()
    cube.set3DPos(
            x - size/2, y - size/2, z - size/2,
            x + size/2, y + size/2, z + size/2
    )
    cube.setColor(color[1], color[2], color[3])
    if GlassesConstants.DEFAULT_THROUGH then
        cube.setVisibleThroughObjects(true)
    end
    hud.widgets[id] = cube

    hud:update()
    print("Glasses test: displaying a cube 2m ahead. Wear glasses to view it.")

    while true do
        os.sleep(1)
    end
end

return Program
