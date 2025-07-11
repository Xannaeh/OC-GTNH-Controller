-- Example glasses_test.lua

local serialization = require("serialization")
local GlassesHUD = require("classes.glasses_hud")
local BarWidget = require("classes.widgets.bar_widget")
local PowerWaveWidget = require("classes.widgets.power_wave_widget")
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

    -- Add 5 bar pairs (light/dark)
    local barX = 20
    local barY = 20
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

    -- Add power wave widget
    local wavePoints = {
        {0, 0}, {20, -30}, {40, 10}, {60, -20}, {80, 0}
    }
    local powerWave = PowerWaveWidget:new("power_wave", hud.glasses, hud, wavePoints, 600, 1250)
    hud:addWidget(powerWave)

    hud:render()
    print("HUD with bars & power wave rendered!")
    while true do os.sleep(1) end
end

return Program
