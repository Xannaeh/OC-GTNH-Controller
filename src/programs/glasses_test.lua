-- src/programs/glasses_test.lua
-- Draws a checkerboard with safe yielding!

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

    local screenW = hud.screenResolution[1]
    local screenH = hud.screenResolution[2]

    local cellSize = 32   -- easily tweakable: 2, 4, 8, 16, 32, etc.
    local textScale = 0.5

    local cols = math.floor(screenW / cellSize)
    local rows = math.floor(screenH / cellSize)

    print("Drawing checkerboard grid: " .. cols .. " x " .. rows .. " cells")

    local batch = 0

    for y = 0, rows - 1 do
        for x = 0, cols - 1 do
            local px = x * cellSize
            local py = y * cellSize

            local isBlack = ((x + y) % 2 == 0)
            local color = isBlack and 0x000000 or 0xFFFFFF
            local labelColor = isBlack and 0xFFFFFF or 0x000000

            local quadId = "cell_" .. x .. "_" .. y
            hud:addRectangle(quadId, px, py, cellSize, cellSize, color, 1.0)

            local labelId = "label_" .. x .. "_" .. y
            local labelX = px + 2
            local labelY = py + 2
            hud:addText(labelId, x .. "," .. y, labelX, labelY, labelColor, textScale, 1.0)

            batch = batch + 1
            if batch >= 100 then
                os.sleep(1) -- yield every 100 cells
                batch = 0
            end
        end
    end

    print("Done. Checkerboard drawn with yielding!")

    while true do os.sleep(1) end
end

return Program
