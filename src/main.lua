-- main.lua
-- ... existing boot, log rotation ...

local Power = require("modules/Power")
local Fluid = require("modules/Fluid")
-- ... other modules ...

Power.init(Settings)
Fluid.init(Settings)
-- ... init others ...

while true do
    ScreenUI.resetLines()  -- clear lines each tick
    Power.update()
    Fluid.update()
    -- other updates ...
    ScreenUI.render()
    os.sleep(Settings.updateInterval)
end
