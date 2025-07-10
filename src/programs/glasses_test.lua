-- src/programs/glasses_test.lua
-- Simple HUD test: draws 2D quad and label to verify visibility

local component = require("component")
local os = require("os")

local Program = {}

function Program:run()
    component.proxy(self.address)
    local glasses = component.glasses  -- OpenGlasses component from the terminal

    -- Create a text object on the HUD
    local hudText = glasses.addText(5, 5, "Power: 45%")  -- (x=5, y=5) small offset from top-left
    hudText.setScale(1)        -- 1x scale (default size)
    hudText.setColor(0, 1, 0)  -- green text (r=0, g=1, b=0 in [0,1] normalized range)

    print("HUD text added. It should now be visible in your AR glasses.")

    -- Keep the program running so the text stays (OpenGlasses requires the program to persist to maintain the drawables)
    while true do
        os.sleep(1)  -- idle loop
    end

end

return Program
