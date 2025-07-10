-- src/programs/glasses_test.lua
-- Creates a checkerboard grid of black & white quads with coordinate labels

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

    -- === Grid config ===
    local cellSize = 32   -- Adjustable: cell pixel size
    local textScale = 0.5 -- Text label scale

    local cols = math.floor(screenW / cellSize)
    local rows = math.floor(screenH / cellSize)

    print("Drawing checkerboard grid: " .. cols .. " x " .. rows .. " cells")

    for y = 0, rows - 1 do
        for x = 0, cols - 1 do
            local px = x * cellSize
            local py = y * cellSize

            -- Checkerboard pattern: black or white
            local color = ((x + y) % 2 == 0) and 0x000000 or 0xFFFFFF

            -- Add quad
            local quadId = "cell_" .. x .. "_" .. y
            hud:addRectangle(quadId, px, py, cellSize, cellSize, color, 1.0)

            -- Add label at cell center
            local labelId = "label_" .. x .. "_" .. y
            local labelX = px + cellSize / 4
            local labelY = py + cellSize / 4
            local labelColor = (color == 0x000000) and 0xFFFFFF or 0x000000 -- invert text for contrast
            hud:addText(labelId, "(" .. x .. "," .. y .. ")", labelX, labelY, labelColor, textScale, 1)
        end
    end

    print("Checkerboard grid drawn! Cell size: " .. cellSize .. " px")

    while true do os.sleep(1) end
end

return Program
