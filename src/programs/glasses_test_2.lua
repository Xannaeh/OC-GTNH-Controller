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
    local barBaseY = waveBaseY - 10  -- start just above wave
    local barWidth = 40
    local barHeight = 200

    local barPairs = {
        {Colors.ACCENT1, Colors.ACCENT1},
        {Colors.ACCENT2, Colors.ACCENT2},
        {Colors.ACCENT3, Colors.ACCENT3},
        {Colors.ACCENT4, Colors.ACCENT4},
        {Colors.ACCENT5, Colors.ACCENT5}
    }

    local n = 1
    local barSpacing = 10
    for _, pair in ipairs(barPairs) do
        for j = 1, 2 do
            local h = barHeight * (0.8 ^ (n - 1))
            local barY = barBaseY - h  -- align bottom
            local bar = BarWidget:new(
                    "bar_" .. n, hud.glasses, hud,
                    barX, barY, barWidth, h,
                    pair[j], Colors.PURPLE_DARK, "Water"
            )
            hud:addWidget(bar)
            barX = barX + barWidth + barSpacing
            n = n + 1
        end
    end

    -------------------------
    -- ✅ 3) Cat Emoji
    -------------------------
    local catX = 1220  -- adjust horizontally (centered above hotbar)
    local catY = 1320  -- adjust vertically above vanilla hearts
    local cat = EmojiWidget:new("cat_emoji", hud.glasses, hud, "ฅ^•ﻌ•^ฅ", catX, catY,Colors.PASTEL_PINK1)
    hud:addWidget(cat)

    ---------------------------------------
    -- ✅ Render all
    ---------------------------------------
    hud:render()
    print("✅ HUD done: wave, bars, cat")
    while true do os.sleep(1) end
end

return Program
