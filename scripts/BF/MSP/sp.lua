local LOCAL_SENSOR_ID  = 0x0D
local SMARTPORT_REMOTE_SENSOR_ID = 0x1B
local FPORT_REMOTE_SENSOR_ID = 0x00
local REQUEST_FRAME_ID = 0x30
local REPLY_FRAME_ID   = 0x32

local lastSensorId, lastFrameId, lastDataId, lastValue

bf.protocol.mspSend = function(payload)
    local dataId = payload[1] + bit32.lshift(payload[2], 8)
    local value = 0
    for i = 3, #payload do
        value = value + bit32.lshift(payload[i], (i - 3) * 8)
    end
    return bf.protocol.push(LOCAL_SENSOR_ID, REQUEST_FRAME_ID, dataId, value)
end

bf.protocol.mspRead = function(cmd)
    return mspSendRequest(cmd, {})
end

bf.protocol.mspWrite = function(cmd, payload)
    return mspSendRequest(cmd, payload)
end

-- Discards duplicate data from lua input buffer
local function smartPortTelemetryPop()
    while true do
        local sensorId, frameId, dataId, value = bf.sportTelemetryPop()
        if not sensorId then
            return nil
        elseif (lastSensorId == sensorId) and (lastFrameId == frameId) and (lastDataId == dataId) and (lastValue == value) then
            -- Keep checking
        else
            lastSensorId = sensorId
            lastFrameId = frameId
            lastDataId = dataId
            lastValue = value
            return sensorId, frameId, dataId, value
        end
    end
end

bf.protocol.mspPoll = function()
    while true do
        local sensorId, frameId, dataId, value = smartPortTelemetryPop()
        if (sensorId == SMARTPORT_REMOTE_SENSOR_ID or sensorId == FPORT_REMOTE_SENSOR_ID) and frameId == REPLY_FRAME_ID then
	 	    --bf.print("sensorId:0x"..string.format("%X", sensorId).." frameId:0x"..string.format("%X", frameId).." dataId:0x"..string.format("%X", dataId).." value:0x"..string.format("%X", value))
      	  	local payload = {}
            payload[1] = bit32.band(dataId, 0xFF)
            dataId = bit32.rshift(dataId, 8)
            payload[2] = bit32.band(dataId, 0xFF)
            payload[3] = bit32.band(value, 0xFF)
            value = bit32.rshift(value, 8)
            payload[4] = bit32.band(value, 0xFF)
            value = bit32.rshift(value, 8)
            payload[5] = bit32.band(value, 0xFF)
            value = bit32.rshift(value, 8)
            payload[6] = bit32.band(value, 0xFF)
            --for i=1,#payload do
            --    bf.print(  "["..string.format("%u", i).."]:  0x"..string.format("%X", payload[i]))
            --end
        	return payload
        elseif sensorId == nil then
            return nil
        end
    end
end
