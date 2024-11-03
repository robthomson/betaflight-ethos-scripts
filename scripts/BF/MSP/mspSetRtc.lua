local function setRtc(callback, callbackParam)
    local message = {
        command = 246, -- MSP_SET_RTC
        payload = {},
        processReply = function(self, buf)
            --bf.print("RTC set.")
            if callback then callback(callbackParam) end
        end,
        simulatorResponse = {}
    }

    local now = getRtcTime()
    -- format: seconds after the epoch (32) / milliseconds (16)
    for i = 1, 4 do
        bf.mspHelper.writeU8(message.payload, bit32.band(now, 0xFF))
        now = bit32.rshift(now, 8)
    end
    -- we don't have milliseconds
    bf.mspHelper.writeU16(message.payload, 0)

    bf.mspQueue:add(message)
end

return {
    setRtc = setRtc
}