-- src/programs/glasses_test.lua
-- Creates a grid of tiny quads and text to visualize HUD pixel coordinates

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
    local cellSize = 32   -- << adjustable: each grid cell will be 32x32 screen pixels
    local textScale = 0.5 -- << scale for text label, adjust for readability

    local cols = math.floor(screenW / cellSize)
    local rows = math.floor(screenH / cellSize)

    print("Drawing grid: " .. cols .. " x " .. rows .. " cells")

    for y = 0, rows - 1 do
        for x = 0, cols - 1 do
            local px = x * cellSize
            local py = y * cellSize

            -- Add quad for this cell
            local quadId = "cell_" .. x .. "_" .. y
            hud:addRectangle(quadId, px, py, cellSize, cellSize, 0x0000FF, 0.2) -- semi-transparent blue

            -- Add text label at center of cell
            local labelId = "label_" .. x .. "_" .. y
            local labelX = px + cellSize / 4
            local labelY = py + cellSize / 4
            hud:addText(labelId, "(" .. x .. "," .. y .. ")", labelX, labelY, 0xFFFFFF, textScale, 1)
        end
    end

    print("Grid drawn. Each cell is " .. cellSize .. "x" .. cellSize .. " pixels.")

    while true do os.sleep(1) end
end

return Program
