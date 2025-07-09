-- ===========================================
-- GTNH OC Automation System - Logger.lua
-- Simple logging utility
-- ===========================================
local filesystem = require("filesystem")
local io = require("io")
local os = require("os")

local Settings = require("config/settings")

local Logger = {}

local function writeLog(level, message)
    local path = Settings.logFile or "/logs/events.log"
    local file, err = io.open(path, "a")
    if not file then
        io.stderr:write("Logger error: " .. tostring(err) .. "\n")
        return
    end

    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    file:write(string.format("[%s] [%s] %s\n", timestamp, level, message))
    file:close()
end

function Logger.info(message)
    writeLog("INFO", message)
end

function Logger.warn(message)
    writeLog("WARN", message)
end

function Logger.error(message)
    writeLog("ERROR", message)
end

return Logger
