-- src/programs/glasses_test_2.lua
local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local BarWidget = require("classes.widgets.bar_widget")
local PowerWaveWidget = require("classes.widgets.power_wave_widget")
local EmojiWidget = require("classes.widgets.emoji_widget")
local Colors = require("constants.colors")
local os = require("os")

local Program = {}

-----------------------------------------------------
-- ✅ Load HUD
-----------------------------------------------------
local function loadHUD()
    local file = io.open("devices.dat", "r")
    if not file then print("No devices."); os.exit() end
    local devices = serialization.unserialize(file:read("*a")) or {}; file:close()
    local glassesDevice = nil
    for _, d in ipairs(devices) do if d.type == "GlassesHud" then glassesDevice = d break end end
    if not glassesDevice then print("No HUD found."); os.exit() end
    local hud = GlassesHUD:new(glassesDevice.internalId, glassesDevice.address, 2560, 1370, 3)
    hud:clear()
    return hud
end

-----------------------------------------------------
-- ✅ Power Wave
-----------------------------------------------------
local function createPowerWave(hud)
    local wavePoints = {
        {0, 40}, {200, 30}, {400, 50}, {600, 35}, {800, 45}, {1000, 40}
    }
    local powerWave = PowerWaveWidget:new("power_wave", hud.glasses, hud, wavePoints, 20, 1300,Colors.PURPLE_VERY_DARK)
    hud:addWidget(powerWave)
end

-----------------------------------------------------
-- ✅ Bar Widgets
-----------------------------------------------------
local function createBarWidgets(hud)
    local barX = 20
    local barBaseY = 1290
    local barWidth = 40
    local barHeight = 200
    local spacing = 10

    local heights = {
        barHeight, barHeight,                   -- AB
        barHeight * 0.75, barHeight * 0.75,     -- CD
        barHeight * 0.75 * 0.75, barHeight * 0.75 * 0.75, -- EH
        barHeight * 0.75 * 0.75 * 0.75, barHeight * 0.75 * 0.75 * 0.75 -- IJ
    }

    local colors = {
        Colors.ACCENT1, Colors.ACCENT1,
        Colors.ACCENT2, Colors.ACCENT2,
        Colors.ACCENT3, Colors.ACCENT3,
        Colors.ACCENT4, Colors.ACCENT4
    }

    for i = 1, #heights do
        local h = heights[i]
        local y = barBaseY - h
        local bar = BarWidget:new(
                "bar_" .. i, hud.glasses, hud,
                barX, y, barWidth, h,
                colors[i], Colors.PURPLE_DARK, "Water",
                Colors.PASTEL_PINK1
        )
        hud:addWidget(bar)
        barX = barX + barWidth + spacing
    end
end

-----------------------------------------------------
-- ✅ Cat Emoji
-----------------------------------------------------
local function createCat(hud)
    local catX = 1255
    local catY = 1260
    local cat = EmojiWidget:new("cat_emoji", hud.glasses, hud, "=^.^=", catX, catY,Colors.PASTEL_PINK1)
    hud:addWidget(cat)
end

-----------------------------------------------------
-- ✅ Run all
-----------------------------------------------------
function Program:run()
    local hud = loadHUD()
    createPowerWave(hud)
    createBarWidgets(hud)
    createCat(hud)
    hud:render()
    print("✅ HUD rendered: wave, bars, cat.")
    while true do os.sleep(1) end
end

return Program
