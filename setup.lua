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
    "/home/src/config",
    "/home/src/constants",
    "/home/src/modules",
    "/home/src/programs",
    "/home/src/ui",
    "/home/src/utils",
    "/home/logs"   -- ✅ logs live here under /home
}

for _, dir in ipairs(dirs) do
    shell.execute("mkdir " .. dir)
end

-- Files (non-persistent)
local files = {
    { path = "/home/src/classes/battery_buffer.lua", url = github .. "/src/classes/battery_buffer.lua" },
    { path = "/home/src/classes/fluid_storage.lua", url = github .. "/src/classes/fluid_storage.lua" },
    { path = "/home/src/classes/glasses_hud.lua", url = github .. "/src/classes/glasses_hud.lua" },
    { path = "/home/src/classes/power_storage.lua", url = github .. "/src/classes/power_storage.lua" },
    { path = "/home/src/classes/universal_tank.lua", url = github .. "/src/classes/universal_tank.lua" },
    { path = "/home/src/constants/device_types.lua", url = github .. "/src/constants/device_types.lua" },
    { path = "/home/src/constants/glasses_constants.lua", url = github .. "/src/constants/glasses_constants.lua" },
    { path = "/home/src/modules/Environment.lua", url = github .. "/src/modules/Environment.lua" },
    { path = "/home/src/modules/Fluid.lua", url = github .. "/src/modules/Fluid.lua" },
    { path = "/home/src/modules/glasses.lua", url = github .. "/src/modules/glasses.lua" },
    { path = "/home/src/modules/Power.lua", url = github .. "/src/modules/Power.lua" },
    { path = "/home/src/programs/device_registry.lua", url = github .. "/src/programs/device_registry.lua" },
    { path = "/home/src/programs/device_status.lua", url = github .. "/src/programs/device_status.lua" },
    { path = "/home/src/programs/glasses_demo.lua", url = github .. "/src/programs/glasses_demo.lua" },
    { path = "/home/src/ui/HudOverlay.lua", url = github .. "/src/ui/HudOverlay.lua" },
    { path = "/home/src/ui/ScreenUI.lua", url = github .. "/src/ui/ScreenUI.lua" },
    { path = "/home/src/utils/Logger.lua", url = github .. "/src/utils/Logger.lua" },
    { path = "/home/src/utils/StateHelper.lua", url = github .. "/src/utils/StateHelper.lua" },
    { path = "/home/src/main.lua", url = github .. "/src/main.lua" },
}

for _, f in ipairs(files) do
    run(string.format("wget -f \"%s\" \"%s\"", f.url, f.path))
end

-- Persistent files
local persistent = {
    { path = "/home/src/config/devices.cfg", url = github .. "/src/config/devices.cfg" },
    { path = "/home/src/config/glasses_config.lua", url = github .. "/src/config/glasses_config.lua" },
    { path = "/home/src/config/settings.lua", url = github .. "/src/config/settings.lua" },
    { path = "/home/src/config/state.lua", url = github .. "/src/config/state.lua" }
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
