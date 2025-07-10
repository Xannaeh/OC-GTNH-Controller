-- src/programs/glasses_test.lua
-- Simple HUD test: draws 2D quad and label to verify visibility

local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local os = require("os")

local Program = {}

function Program:run()
    -- Load registered devices
    local file = io.open("devices.dat", "r")
    if not file then
        print("No registered devices found.")
        os.exit()
    end

    local data = file:read("*a")
    file:close()
    local devices = serialization.unserialize(data) or {}

    -- Find the first registered GlassesHud
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

    -- Create the HUD
    local hud = GlassesHUD:new(glassesDevice.internalId, glassesDevice.address)

    -- Add a test text label
    hud:addTextLabel("testText", 5, 5, "Power: 45%", {0, 1, 0}, 0.02)

    print("HUD text added. It should now be visible in your AR glasses.")

    -- Keep program alive to maintain HUD
    while true do
        os.sleep(1)
    end
end

return Program
