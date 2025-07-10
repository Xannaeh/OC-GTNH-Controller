-- src/programs/glasses_test.lua
-- Now using scale + resolution aware HUD

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

    -- Default resolution 2560x1440, GUI scale 3
    local hud = GlassesHUD:new(glassesDevice.internalId, glassesDevice.address, 2560, 1440, 3)

    -- Draw full-screen shiny red overlay using scaled virtual width/height
    hud:addRectangle("fullScreenRed", 0, 0, hud.virtualWidth, hud.virtualHeight, 0xFF0000, 1.0)

    print(
            "Red rectangle covers virtual area: "
                    .. math.floor(hud.virtualWidth)
                    .. "x"
                    .. math.floor(hud.virtualHeight)
                    .. " (scale factor 1/" .. hud.guiScale .. ")"
    )


    while true do os.sleep(1) end
end

return Program
