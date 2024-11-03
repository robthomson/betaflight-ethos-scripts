local function getStatus(callback, callbackParam)
    local message = {
        command = 101, -- MSP_STATUS
        processReply = function(self, buf)
            local status = {}
            --status.pidCycleTime = bf.mspHelper.readU16(buf)
            --status.gyroCycleTime = bf.mspHelper.readU16(buf)
            buf.offset = 12
            status.realTimeLoad = bf.mspHelper.readU16(buf)
            --bf.print("Real-time load: "..tostring(status.realTimeLoad))
            status.cpuLoad = bf.mspHelper.readU16(buf)
            --bf.print("CPU load: "..tostring(status.cpuLoad))
            buf.offset = 18
            status.armingDisableFlags = bf.mspHelper.readU32(buf)
            --bf.print("Arming disable flags: "..tostring(status.armingDisableFlags))
            buf.offset = 24
            status.profile = bf.mspHelper.readU8(buf)
            --bf.print("Profile: "..tostring(status.profile))
            --status.numProfiles = bf.mspHelper.readU8(buf)
            buf.offset = 26
            status.rateProfile = bf.mspHelper.readU8(buf)
            --status.numRateProfiles = bf.mspHelper.readU8(buf)
            --status.motorCount = bf.mspHelper.readU8(buf)
            --bf.print("Number of motors: "..tostring(status.motorCount))
            --status.servoCount = bf.mspHelper.readU8(buf)
            --bf.print("Number of servos: "..tostring(status.servoCount))
            callback(callbackParam, status)
        end,
        simulatorResponse = { 240, 1, 124, 0, 35, 0, 0, 0, 0, 0, 0, 224, 1, 10, 1, 0, 26, 0, 0, 0, 0, 0, 2, 0, 6, 0, 6, 1, 4, 1 }
    }

    bf.mspQueue:add(message)
end

return {
    getStatus = getStatus
}