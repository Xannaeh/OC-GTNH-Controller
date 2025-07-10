-- src/programs/glasses_test.lua
-- Now using real screen resolution with scaling handled inside HUD class

local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local os = require("os")

local Program = {}

function Program:run()
    local file = io.open("devices.dat", "r")
    if not file then
        print("No registered devices found.")
        os.exit()
    end

    local devices = serialization.unserialize(file:read("*a")) or {}
    file:close()

    local glassesDevice = nil
    for _, device in ipairs(devices) do
        if device.type == "GlassesHud" then
            glassesDevice = device
            break
        end
    end

    if not glassesDevice then
        print("No GlassesHud device registered.")
        os.exit()
    end

    local hud = GlassesHUD:new(glassesDevice.internalId, glassesDevice.address, 2560, 1440, 3)

    -- Use REAL resolution now!
    local screenW = hud.screenResolution[1]
    local screenH = hud.screenResolution[2]

    hud:addRectangle("fullScreenRed", 0, 0, screenW, screenH, 0xFF0000, 1.0)

    print(
            "Red rectangle covers real area: "
                    .. screenW .. "x" .. screenH
                    .. " with GUI scale 1/" .. hud.guiScale
    )

    while true do os.sleep(1) end
end

return Program
