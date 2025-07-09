local State = {}

-- Detected transposer configurations
State.transposers = {
    { uuid = "0b863cd7-daba-47e3-bc46-5074614a7782", side = 4 },
    -- add more transposers if you have multiple
}

-- Detected power devices
State.powerDevices = {
    { uuid = "d23fb12d-a11a-4f54-b1d5-a47897ac0e74" },
    -- add more battery buffer UUIDs here
}

return State
