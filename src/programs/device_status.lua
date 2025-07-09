-- device status
local serialization = require("serialization")
local component = require("component")
local UniversalTank = require("classes.universal_tank")
local FluidStorage = require("classes.fluid_storage")
local PowerStorage = require("classes.power_storage")
local BatteryBuffer = require("classes.battery_buffer")

local DeviceStatus = {}
DeviceStatus.__index = DeviceStatus

function DeviceStatus:run()
    local file = io.open("devices.dat", "r")
    if not file then
        print("No registered devices found.")
        os.exit()
    end

    local data = file:read("*a")
    file:close()

    local devices = serialization.unserialize(data) or {}
    print("=== DEVICE STATUS ===")

    for _, device in ipairs(devices) do
        if device.type == "UniversalTank" then
            local tank = UniversalTank:new(device.internalId, device.address, device.fluid, device.side)
            tank:readFluidStatus()
            print(tank:toString())
        elseif device.type == "FluidStorage" then
            local storage = FluidStorage:new(device.internalId, device.address, device.fluid, device.side)
            storage:readFluidStatus()
            print(storage:toString())
        elseif device.type == "PowerStorage" then
            local power = PowerStorage:new(device.internalId, device.address)
            power:readPowerStatus()
            print(power:toString())
        elseif device.type == "BatteryBuffer" then
            local battery = BatteryBuffer:new(device.internalId, device.address)
            battery:readPowerStatus()
            print(battery:toString())
        else
            print("Unknown device type: " .. tostring(device.type))
        end
    end
end

return DeviceStatus
