-- src/programs/glasses_test_2.lua
local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local BarWidget = require("classes.widgets.bar_widget")
local PowerWaveWidget = require("classes.widgets.power_wave_widget")
local EmojiWidget = require("classes.widgets.emoji_widget")
local Colors = require("constants.colors")
local os = require("os")

local Program = {}

function Program:run()
    local file = io.open("devices.dat", "r")
    if not file then print("No devices."); os.exit() end
    local devices = serialization.unserialize(file:read("*a")) or {}; file:close()
    local glassesDevice = nil
    for _, d in ipairs(devices) do if d.type == "GlassesHud" then glassesDevice = d break end end
    if not glassesDevice then print("No HUD found."); os.exit() end

    local hud = GlassesHUD:new(glassesDevice.internalId, glassesDevice.address, 2560, 1370, 3)
    hud:clear()

    -------------------------
    -- ✅ 1) Power Wave
    -------------------------
    local waveBaseX = 20
    local waveBaseY = 1300
    local waveLength = 600

    local wavePoints = {
        {0, 40}, {100, 20}, {200, 60}, {300, 20}, {400, 50}, {500, 25}, {600, 40}
    }

    local powerWave = PowerWaveWidget:new("power_wave", hud.glasses, hud, wavePoints, waveBaseX, waveBaseY)
    hud:addWidget(powerWave)

    -------------------------
    -- ✅ 2) Bar Widgets
    -------------------------
    local barX = waveBaseX
    local barBaseY = waveBaseY - 10  -- same base line
    local barWidth = 40
    local barHeight = 200
    local barSpacing = 10

    local pairHeights = {
        barHeight,                -- AB
        barHeight * 0.75,         -- CD
        barHeight * 0.75 * 0.75,  -- EH
        barHeight * 0.75 * 0.75 * 0.75, -- IJ
        barHeight * 0.75 * 0.75 * 0.75 * 0.75  -- extra pair if needed
    }


    local barPairs = {
        Colors.ACCENT1,
        Colors.ACCENT2,
        Colors.ACCENT3,
        Colors.ACCENT4,
        Colors.ACCENT5
    }

    local n = 1
    for i, baseColor in ipairs(barPairs) do
        local h = pairHeights[i]
        if not h then error("Missing pairHeights for pair " .. tostring(i)) end
        for j = 1, 2 do
            local barY = barBaseY - h
            local bar = BarWidget:new(
                    "bar_" .. n, hud.glasses, hud,
                    barX, barY, barWidth, h,
                    baseColor, Colors.PURPLE_DARK, "Water"
            )
            hud:addWidget(bar)
            barX = barX + barWidth + barSpacing
            n = n + 1
        end
    end


    -------------------------
    -- ✅ 3) Cat Emoji
    -------------------------
    local catX = 1255  -- adjust horizontally (centered above hotbar)
    local catY = 1260  -- adjust vertically above vanilla hearts
    local cat = EmojiWidget:new("cat_emoji", hud.glasses, hud, "=^.^=", catX, catY, Colors.PASTEL_PINK1)
    hud:addWidget(cat)

    ---------------------------------------
    -- ✅ Render all
    ---------------------------------------
    hud:render()
    print("✅ HUD done: wave, bars, cat")
    while true do os.sleep(1) end
end

return Program
