-- ===========================================
-- OC GTNH Project Installer
-- Auto-create folders, fetch files from GitHub
-- Usage: setup.lua Y|N  (Y = replace all, N = skip persistent)
-- ===========================================

local shell = require("shell")
local args = {...}
local replace = args[1] or "N"
local github = "https://raw.githubusercontent.com/Xannaeh/OC-GTNH-Controller/main"

local function run(cmd)
    print("> " .. cmd)
    os.execute(cmd)
end

-- Directories
local dirs = {
    "/home/src",
    "/home/src/classes",
    "/home/src/classes/elements",
    "/home/src/classes/utils",
    "/home/src/constants",
    "/home/src/programs",
}

for _, dir in ipairs(dirs) do
    shell.execute("mkdir " .. dir)
end

-- Files (non-persistent)
local files = {
    { path = "/home/src/classes/elements/line2d.lua", url = github .. "/src/classes/elements/line2d.lua" },
    { path = "/home/src/classes/elements/rectangle2d.lua", url = github .. "/src/classes/elements/rectangle2d.lua" },
    { path = "/home/src/classes/elements/text2d.lua", url = github .. "/src/classes/elements/text2d.lua" },
    { path = "/home/src/classes/elements/triangle2d.lua", url = github .. "/src/classes/elements/triangle2d.lua" },
    { path = "/home/src/classes/utils/color.lua", url = github .. "/src/classes/utils/color.lua" },
    { path = "/home/src/classes/battery_buffer.lua", url = github .. "/src/classes/battery_buffer.lua" },
    { path = "/home/src/classes/fluid_storage.lua", url = github .. "/src/classes/fluid_storage.lua" },
    { path = "/home/src/classes/glasses_element.lua", url = github .. "/src/classes/glasses_element.lua" },
    { path = "/home/src/classes/glasses_hud.lua", url = github .. "/src/classes/glasses_hud.lua" },
    { path = "/home/src/classes/glasses_widget.lua", url = github .. "/src/classes/glasses_widget.lua" },
    { path = "/home/src/classes/power_storage.lua", url = github .. "/src/classes/power_storage.lua" },
    { path = "/home/src/classes/universal_tank.lua", url = github .. "/src/classes/universal_tank.lua" },
    { path = "/home/src/constants/device_types.lua", url = github .. "/src/constants/device_types.lua" },
    { path = "/home/src/constants/glasses_constants.lua", url = github .. "/src/constants/glasses_constants.lua" },
    { path = "/home/src/programs/device_registry.lua", url = github .. "/src/programs/device_registry.lua" },
    { path = "/home/src/programs/device_status.lua", url = github .. "/src/programs/device_status.lua" },
    { path = "/home/src/programs/glasses_demo.lua", url = github .. "/src/programs/glasses_demo.lua" },
    { path = "/home/src/programs/glasses_test.lua", url = github .. "/src/programs/glasses_test.lua" },
    { path = "/home/src/main.lua", url = github .. "/src/main.lua" },
}

for _, f in ipairs(files) do
    run(string.format("wget -f \"%s\" \"%s\"", f.url, f.path))
end

-- Persistent files
local persistent = {
}

if replace == "Y" then
    print("Replacing persistent files...")
    for _, f in ipairs(persistent) do
        run(string.format("wget -f \"%s\" \"%s\"", f.url, f.path))
    end
else
    print("Keeping existing persistent files.")
end

print("✅ Install complete.")
