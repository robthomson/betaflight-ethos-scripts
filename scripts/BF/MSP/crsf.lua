-- CRSF Devices
local CRSF_ADDRESS_BETAFLIGHT          = 0xC8
local CRSF_ADDRESS_RADIO_TRANSMITTER   = 0xEA

-- CRSF Frame Types
local CRSF_FRAMETYPE_MSP_REQ           = 0x7A      -- response request using msp sequence as command
local CRSF_FRAMETYPE_MSP_RESP          = 0x7B      -- reply with 60 byte chunked binary
local CRSF_FRAMETYPE_MSP_WRITE         = 0x7C      -- write with 60 byte chunked binary

local crsfMspCmd = 0


local crsfPopFrame
local crsfPushFrame

if crsf.getSensor ~= nil then
    local sensor = crsf.getSensor()
    crsfPopFrame = function() return sensor:popFrame() end
    crsfPushFrame = function(x,y) return sensor:pushFrame(x,y) end
else
    crsfPopFrame = function() return crsf.popFrame() end
    crsfPushFrame = function(x,y) return crsf.pushFrame(x,y) end
end

bf.protocol.mspSend = function(payload)
    local payloadOut = { CRSF_ADDRESS_BETAFLIGHT, CRSF_ADDRESS_RADIO_TRANSMITTER }
    for i=1, #(payload) do
        payloadOut[i+2] = payload[i]
    end
    return crsfPushFrame(crsfMspCmd, payloadOut)
end

bf.protocol.mspRead = function(cmd)
    crsfMspCmd = CRSF_FRAMETYPE_MSP_REQ
    return mspSendRequest(cmd, {})
end

bf.protocol.mspWrite = function(cmd, payload)
    crsfMspCmd = CRSF_FRAMETYPE_MSP_WRITE
    return mspSendRequest(cmd, payload)
end

bf.protocol.mspPoll = function()
    while true do
        local cmd, data = crsfPopFrame()
        if cmd == CRSF_FRAMETYPE_MSP_RESP and data[1] == CRSF_ADDRESS_RADIO_TRANSMITTER and data[2] == CRSF_ADDRESS_BETAFLIGHT then
--[[
            bf.print("cmd:0x"..string.format("%X", cmd))
            bf.print("  data length: "..string.format("%u", #data))
            for i=1,#data do
                bf.print("  ["..string.format("%u", i).."]:  0x"..string.format("%X", data[i]))
            end
--]]
            local mspData = {}
            for i = 3, #data do
                mspData[i - 2] = data[i]
            end
            return mspData
        elseif cmd == nil then
            return nil
        end
    end
end
