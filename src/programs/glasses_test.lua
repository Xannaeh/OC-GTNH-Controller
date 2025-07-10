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

    -- Draw semi-transparent dark panel near top-center
    g:addQuad2D("hudQuad",
            0.3, 0.85,
            0.7, 0.92,
            {0, 0, 0, 0.6}
    )

    -- Draw white centered test label
    g:addTextLabel("hudText",
            0.5, 0.88,
            "HUD TEST",
            {1, 1, 1, 1},
            0.03
    )

    g:update()
    print("HUD test active. Press Ctrl+C to exit.")

    while true do
        os.sleep(1)
    end
end

return Program
