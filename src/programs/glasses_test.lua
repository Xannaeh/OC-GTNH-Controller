-- src/programs/glasses_test.lua
-- Simple HUD test: draws a 2D rectangle and label to verify visibility

local component = require("component")
local os = require("os")
local glassesMod = require("modules.glasses")
local GlassesConstants = require("constants.glasses_constants")

local Program = {}

function Program:run()
    if not component.isAvailable("glasses") then
        print("Error: glasses component missing. Exiting.")
        return
    end

    local g = glassesMod.init()
    g:clear()

    local quadId = "hudQuad"
    local textId = "hudText"
    local width, height = 0.4, 0.05   -- 40% screen width, 5% height
    local x, y = 0.5, 0.9            -- centered near top

    -- Draw semi-transparent dark panel
    g.hud:addQuad2D(quadId,
            x - width/2, y - height/2,
            x + width/2, y + height/2,
            {0, 0, 0, 0.6}
    )

    -- Draw white test label centered inside panel
    g.hud:addTextLabel(textId,
            x, y, "HUD TEST", {1, 1, 1}, 0.03
    )

    g:update()
    print("HUD test active. Press Ctrl+C to exit.")

    while true do
        os.sleep(1)
    end
end

return Program
