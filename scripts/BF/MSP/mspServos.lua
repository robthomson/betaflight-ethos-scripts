local function getServoConfigurations(callback, callbackParam)
    local message = {
        command = 120, -- MSP_SERVO_CONFIGURATIONS
        processReply = function(self, buf)
            local servoCount = bf.mspHelper.readU8(buf)
            --bf.print("Servo count "..tostring(servoCount))
            local configs = {}
            for i = 0, servoCount-1 do
                local config = {}
                config.mid = { value = bf.mspHelper.readU16(buf), min = 50,    max = 2250 }
                config.min = { value = bf.mspHelper.readS16(buf), min = -1000, max = 1000 }
                config.max = { value = bf.mspHelper.readS16(buf), min = -1000, max = 1000 }
                config.scaleNeg = { value = bf.mspHelper.readU16(buf), min = 100, max = 1000 }
                config.scalePos = { value = bf.mspHelper.readU16(buf), min = 100, max = 1000 }
                config.rate = { value = bf.mspHelper.readU16(buf), min = 50, max = 5000 }
                config.speed = { value = bf.mspHelper.readU16(buf), min = 0, max = 60000 }
                config.flags = { value = bf.mspHelper.readU16(buf), min = 0, max = 3 }
                configs[i] = config
            end
            callback(callbackParam, configs)
        end,
        simulatorResponse = {
            2,
            220, 5, 68, 253, 188, 2, 244, 1, 244, 1, 77, 1, 0, 0, 0, 0,
            221, 5, 68, 253, 188, 2, 244, 1, 244, 1, 77, 1, 0, 0, 0, 0
        }
    }
    bf.mspQueue:add(message)
end

local function setServoConfiguration(servoIndex, servoConfig)
    local message = {
        command = 212, -- MSP_SET_SERVO_CONFIGURATION
        payload = {}
    }
    bf.mspHelper.writeU8(message.payload, servoIndex)
    bf.mspHelper.writeU16(message.payload, servoConfig.mid.value)
    bf.mspHelper.writeU16(message.payload, servoConfig.min.value)
    bf.mspHelper.writeU16(message.payload, servoConfig.max.value)
    bf.mspHelper.writeU16(message.payload, servoConfig.scaleNeg.value)
    bf.mspHelper.writeU16(message.payload, servoConfig.scalePos.value)
    bf.mspHelper.writeU16(message.payload, servoConfig.rate.value)
    bf.mspHelper.writeU16(message.payload, servoConfig.speed.value)
    bf.mspHelper.writeU16(message.payload, servoConfig.flags.value)
    bf.mspQueue:add(message)
end

local function disableServoOverride(servoIndex)
    local message = {
        command = 193, -- MSP_SET_SERVO_OVERRIDE
        payload = { servoIndex }
    }
    bf.mspHelper.writeU16(message.payload, 2001)
    bf.mspQueue:add(message)
end

local function enableServoOverride(servoIndex)
    local message = {
        command = 193, -- MSP_SET_SERVO_OVERRIDE
        payload = { servoIndex }
    }
    bf.mspHelper.writeU16(message.payload, 0)
    bf.mspQueue:add(message)
end

return {
    enableServoOverride = enableServoOverride,
    disableServoOverride = disableServoOverride,
    getServoConfigurations = getServoConfigurations,
    setServoConfiguration = setServoConfiguration
}