local function getPilotConfig(callback, callbackParam)
    local message = {
        command = 12, -- MSP_PILOT_CONFIG
        processReply = function(self, buf)
            local config = {}
            --bf.print("buf length: "..#buf)
            config.model_id = { value = bf.mspHelper.readU8(buf), min = 0, max = 99 }
            config.model_param1_type = { value = bf.mspHelper.readU8(buf), min = 0, max = 12, table = { [0] = "NONE", "TIMER1", "TIMER2", "TIMER3", "GV1", "GV2", "GV3", "GV4", "GV5", "GV6", "GV7", "GV8", "GV9" } }
            config.model_param1_value = { value = bf.mspHelper.readS16(buf), min = -32000, max = 32000 }
            config.model_param2_type = { value = bf.mspHelper.readU8(buf), min = 0, max = 12, table = { [0] = "NONE", "TIMER1", "TIMER2", "TIMER3", "GV1", "GV2", "GV3", "GV4", "GV5", "GV6", "GV7", "GV8", "GV9" } }
            config.model_param2_value = { value = bf.mspHelper.readS16(buf), min = -32000, max = 32000 }
            config.model_param3_type = { value = bf.mspHelper.readU8(buf), min = 0, max = 12, table = { [0] = "NONE", "TIMER1", "TIMER2", "TIMER3", "GV1", "GV2", "GV3", "GV4", "GV5", "GV6", "GV7", "GV8", "GV9" } }
            config.model_param3_value = { value = bf.mspHelper.readS16(buf), min = -32000, max = 32000 }
            callback(callbackParam, config)
        end,
        simulatorResponse = { 21,  1, 240, 0,  0, 0, 0,  0, 0, 0 }
    }
    bf.mspQueue:add(message)
end

local function setPilotConfig(config)
    local message = {
        command = 13, -- MSP_SET_PILOT_CONFIG
        payload = {},
        simulatorResponse = {}
    }
    bf.mspHelper.writeU8(message.payload, config.model_id.value)
    bf.mspHelper.writeU8(message.payload, config.model_param1_type.value)
    bf.mspHelper.writeU16(message.payload, config.model_param1_value.value)
    bf.mspHelper.writeU8(message.payload, config.model_param2_type.value)
    bf.mspHelper.writeU16(message.payload, config.model_param2_value.value)
    bf.mspHelper.writeU8(message.payload, config.model_param3_type.value)
    bf.mspHelper.writeU16(message.payload, config.model_param3_value.value)
    bf.mspQueue:add(message)
end

return {
    getPilotConfig = getPilotConfig,
    setPilotConfig = setPilotConfig
}