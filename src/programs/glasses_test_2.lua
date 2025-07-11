local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local BarWidget = require("classes.widgets.bar_widget")
local EmojiWidget = require("classes.widgets.emoji_widget")
local PowerWaveWidget = require("classes.widgets.power_wave_widget")
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

    ---------------------------------------
    -- ✅ Power Wave Widget
    ---------------------------------------
    local wavePoints = {
        {0, 30}, {100, 10}, {200, 35}, {300, 5}, {400, 30}, {500, 15}, {600, 40}, {700, 20}, {800, 30}
    }
    local powerWave = PowerWaveWidget:new("power_wave", hud.glasses, hud, wavePoints, 20, 1240)
    hud:addWidget(powerWave)

    ---------------------------------------
    -- ✅ Bars stacked above wave
    ---------------------------------------
    local barX = 20
    local barY = 1100  -- start above wave
    local barWidth = 30
    local baseHeight = 200

    local barColors = {
        Colors.ACCENT1, Colors.ACCENT2, Colors.ACCENT3, Colors.ACCENT4, Colors.ACCENT5
    }

    local pairHeight = baseHeight

    for i = 1, 10 do
        local colorIdx = math.floor((i - 1) / 2) + 1
        local color = barColors[colorIdx]
        local bar = BarWidget:new(
                "bar_" .. i, hud.glasses, hud,
                barX, barY,
                barWidth, pairHeight,
                color, Colors.PURPLE_DARK, "Water"
        )
        hud:addWidget(bar)
        barX = barX + barWidth + 8
        if i % 2 == 0 then pairHeight = pairHeight * 0.75 end
    end

    ---------------------------------------
    -- ✅ Cat Emoji widget
    ---------------------------------------
    local catX = 1280  -- adjust to your screen center
    local catY = 1320  -- just above hotbar
    local cat = EmojiWidget:new("cat_face", hud.glasses, hud, "=^.^=", catX, catY)
    hud:addWidget(cat)

    ---------------------------------------
    -- ✅ Render all
    ---------------------------------------
    hud:render()
    print("✅ Wave, bars, and cat rendered.")
    while true do os.sleep(1) end
end

return Program
