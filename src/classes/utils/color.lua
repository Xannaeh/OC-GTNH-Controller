-- src/classes/utils/color.lua

local Color = {}

function Color.RGB(hex)
    local r = ((hex >> 16) & 0xFF) / 255.0
    local g = ((hex >> 8) & 0xFF) / 255.0
    local b = (hex & 0xFF) / 255.0
    return r, g, b
end

return Color
