-- ===========================================
-- GTNH OC Automation System - Logger.lua
-- Simple, robust logging utility
-- ===========================================
local io = require("io")
local os = require("os")
local term = require("term")
local Settings = require("config/settings")
local Logger = {}

local function writeLog(level, message)
    local path = Settings.logFile or "/logs/events.log"
    local file, err = io.open(path, "a")
    if not file then
        local text = "Logger error: " .. tostring(err) .. "\n"
        if io.stderr and io.stderr.write then
            io.stderr:write(text)
        else
            term.write(text)
        end
        return
    end

    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    file:write(string.format("[%s] [%s] %s\n", timestamp, level, message))
    file:close()
end

function Logger.info(msg)  writeLog("INFO",  msg) end
function Logger.warn(msg)  writeLog("WARN",  msg) end
function Logger.error(msg) writeLog("ERROR", msg) end

return Logger
