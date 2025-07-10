-- src/programs/glasses_test.lua
-- Simple HUD test: draws 2D quad and label to verify visibility

local component = require("component")
local os = require("os")
local GlassesHUD = require("classes.glasses_hud")

local Program = {}

function Program:run()
    if not component.isAvailable("glasses") then
        print("Error: glasses component missing. Exiting.")
        return
    end

    local hud = GlassesHUD:new(component.glasses)
    hud:clear()

    hud:addQuad("hudQuad", 0.3, 0.85, 0.7, 0.92, {0, 0, 0, 0.6})
    hud:addTextLabel("hudText", 0.5, 0.88, "HUD TEST", {1, 1, 1, 1}, 0.03)

    hud:update()
    print("HUD test active. Wear glasses to view it.")

    while true do os.sleep(1) end
end

return Program
