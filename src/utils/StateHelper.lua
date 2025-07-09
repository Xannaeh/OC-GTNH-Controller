local fs = require("filesystem")

local StateHelper = {}

function StateHelper.save(state, path)
    local file, err = io.open(path, "w")
    if not file then return false, err end

    file:write("local State = {}\n\n")

    -- Tanks
    file:write("State.tanks = {\n")
    for _, t in ipairs(state.tanks or {}) do
        file:write(string.format("  { uuid = \"%s\", side = %d },\n", t.uuid, t.side))
    end
    file:write("}\n\n")

    -- Power devices
    file:write("State.powerDevices = {\n")
    for _, p in ipairs(state.powerDevices or {}) do
        file:write(string.format("  { uuid = \"%s\" },\n", p.uuid))
    end
    file:write("}\n\n")

    file:write("return State\n")
    file:close()
    return true
end

return StateHelper
