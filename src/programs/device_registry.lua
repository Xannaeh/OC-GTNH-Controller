local component = require("component")
local serialization = require("serialization")
local deviceTypes = require("constants.device_types")

local DeviceRegistry = {}
DeviceRegistry.__index = DeviceRegistry

DeviceRegistry.devices = {}

function DeviceRegistry:load()
    local file = io.open("devices.dat", "r")
    if file then
        local data = file:read("*a")
        self.devices = serialization.unserialize(data) or {}
        file:close()
    end
end

function DeviceRegistry:save()
    local file = io.open("devices.dat", "w")
    file:write(serialization.serialize(self.devices))
    file:close()
end

function DeviceRegistry:pickDeviceClass()
    local keys = {}
    local i = 1
    print("Available device classes:")
    for k, _ in pairs(deviceTypes) do
        print(string.format("%d) %s", i, k))
        keys[i] = k
        i = i + 1
    end
    io.write("Pick class number: ")
    local choice = tonumber(io.read())
    if choice and keys[choice] then
        return keys[choice]
    else
        print("Invalid choice.")
        return nil
    end
end

function DeviceRegistry:pickAddress(deviceType)
    local ctype = deviceTypes[deviceType]
    local addresses = {}
    local i = 1
    print("Available component addresses:")
    for addr, _ in component.list(ctype) do
        if not self:isAddressRegistered(addr) then
            print(string.format("%d) %s", i, addr))
            addresses[i] = addr
            i = i + 1
        end
    end
    if #addresses == 0 then
        print("No available addresses for type: " .. deviceType)
        return nil
    end
    io.write("Pick address number: ")
    local num = tonumber(io.read())
    if num and addresses[num] then
        return addresses[num]
    else
        print("Invalid choice.")
        return nil
    end
end

function DeviceRegistry:isAddressRegistered(address)
    for _, device in pairs(self.devices) do
        if device.address == address then
            return true
        end
    end
    return false
end

function DeviceRegistry:registerDevice(deviceType, address, internalId)
    table.insert(self.devices, {
        type = deviceType,
        address = address,
        internalId = internalId
    })
    self:save()
end

function DeviceRegistry:listDevices()
    print("Registered devices:")
    local grouped = {}
    for _, device in ipairs(self.devices) do
        grouped[device.type] = grouped[device.type] or {}
        table.insert(grouped[device.type], device)
    end

    for class, list in pairs(grouped) do
        print(class .. ":")
        for _, device in ipairs(list) do
            print(string.format(" - ID: %s | Address: %s", device.internalId, device.address))
        end
    end
end

function DeviceRegistry:removeDevice(internalId)
    for i, device in ipairs(self.devices) do
        if device.internalId == internalId then
            table.remove(self.devices, i)
            break
        end
    end
    self:save()
end

function DeviceRegistry:run()
    self:load()
    while true do
        print("\n1) List Classes\n2) Register Device\n3) List Devices\n4) Remove Device\n5) Exit")
        io.write("> ")
        local choice = io.read()
        if choice == "1" then
            self:pickDeviceClass() -- show numbered list
        elseif choice == "2" then
            local class = self:pickDeviceClass()
            if class then
                local addr = self:pickAddress(class)
                if addr then
                    io.write("Internal ID: ")
                    local id = io.read()
                    self:registerDevice(class, addr, id)
                    print("Device registered.")
                end
            end
        elseif choice == "3" then
            self:listDevices()
        elseif choice == "4" then
            io.write("Internal ID to remove: ")
            local id = io.read()
            self:removeDevice(id)
            print("Device removed.")
        elseif choice == "5" then
            break
        else
            print("Invalid option.")
        end
    end
end

return DeviceRegistry
