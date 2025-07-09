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
    "/home/src/modules",
    "/home/src/ui",
    "/home/src/utils",
    "/home/src/config",
    "/home/logs"
}

for _, dir in ipairs(dirs) do
    shell.execute("mkdir " .. dir)
end

-- Files (non-persistent)
local files = {
    { path = "/home/src/main.lua", url = github .. "/src/main.lua" },
    { path = "/home/src/modules/Power.lua", url = github .. "/src/modules/Power.lua" },
    { path = "/home/src/modules/Fluid.lua", url = github .. "/src/modules/Fluid.lua" },
    { path = "/home/src/modules/Environment.lua", url = github .. "/src/modules/Environment.lua" },
    { path = "/home/src/ui/ScreenUI.lua", url = github .. "/src/ui/ScreenUI.lua" },
    { path = "/home/src/ui/HudOverlay.lua", url = github .. "/src/ui/HudOverlay.lua" },
    { path = "/home/src/utils/Logger.lua", url = github .. "/src/utils/Logger.lua" }
}

for _, f in ipairs(files) do
    run(string.format("wget -f \"%s\" \"%s\"", f.url, f.path))
end

-- Persistent files
local persistent = {
    { path = "/home/src/config/settings.lua", url = github .. "/src/config/settings.lua" }
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



