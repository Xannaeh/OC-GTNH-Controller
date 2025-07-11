-- src/programs/glasses_test_2.lua

local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local BarWidget = require("classes.widgets.bar_widget")
local PowerWaveWidget = require("classes.widgets.power_wave_widget")
local EmojiWidget = require("classes.widgets.emoji_widget")
local os = require("os")
local Colors = require("constants.colors")

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

    -- Bars bottom left
    local screenH = hud.screenResolution[2]
    local barX = 20
    local barY = screenH - 200 - 20  -- bottom margin

    local barWidth = 40
    local barHeight = 200

    local barColors = {
        {Colors.ACCENT1, Colors.ACCENT2},
        {Colors.ACCENT3, Colors.ACCENT4},
        {Colors.ACCENT5, Colors.ACCENT6}
    }

    local n = 1
    for i, pair in ipairs(barColors) do
        for j = 1, 2 do
            local bar = BarWidget:new(
                    "bar_" .. n, hud.glasses, hud,
                    barX, barY, barWidth, barHeight,
                    pair[j % 2 + 1], Colors.PURPLE_DARK, "Water"
            )
            hud:addWidget(bar)
            barX = barX + barWidth + 10
            n = n + 1
        end
    end
    print("✅ Bars at X/Y: " .. barX .. "," .. barY)

    -- Power wave
    local wavePoints = {
        {0, 0}, {20, -20}, {40, 10}, {60, -15}, {80, 0}
    }
    local powerWave = PowerWaveWidget:new("power_wave", hud.glasses, hud, wavePoints, 600, screenH - 250)
    hud:addWidget(powerWave)
    print("🌊 Wave graph at X/Y: " .. 600 .. "," .. (screenH - 250))

    -- Cat emoji
    local cat = EmojiWidget:new("emoji_cat", hud.glasses, hud, "=^.^=", 1200, screenH - 100)
    hud:addWidget(cat)

    -- Moon emoji
    local moon = EmojiWidget:new("emoji_moon", hud.glasses, hud, "( )", 1250, screenH - 100)
    hud:addWidget(moon)

    -- Hearts emoji
    local hearts = EmojiWidget:new("emoji_hearts", hud.glasses, hud, "♥♥♥", 1300, screenH - 100)
    hud:addWidget(hearts)

    hud:render()
    print("✅ Full multi-widget HUD rendered!")

    while true do os.sleep(1) end
end

return Program
