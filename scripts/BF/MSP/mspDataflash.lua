local function getDataflashSummary(callback, callbackParam)
    local message = {
        command = 70, -- MSP_DATAFLASH_SUMMARY
        processReply = function(self, buf)
            local summary = {}
            --bf.print("buf length: "..#buf)
            local flags = bf.mspHelper.readU8(buf)
            summary.ready = bit32.band(flags, 1) ~= 0
            summary.supported = bit32.band(flags, 2) ~= 0
            summary.sectors = bf.mspHelper.readU32(buf)
            summary.totalSize = bf.mspHelper.readU32(buf)
            summary.usedSize = bf.mspHelper.readU32(buf)
            --bf.print("summary.ready: "..tostring(summary.ready))
            --bf.print("summary.supported: "..tostring(summary.supported))
            --bf.print("summary.sectors: "..tostring(summary.sectors))
            --bf.print("summary.totalSize: "..tostring(summary.totalSize))
            --bf.print("summary.usedSize: "..tostring(summary.usedSize))

            callback(callbackParam, summary)
        end,
        simulatorResponse = { 3, 1,0,0,0, 0,4,0,0, 0,3,0,0 }
    }
    bf.mspQueue:add(message)
end

local function eraseDataflash(callback, callbackParam)
    local message = {
        command = 72, -- MSP_DATAFLASH_ERASE
        processReply = function(self, buf)
            local summary = {}
            bf.print("buf length: "..#buf)
            callback(callbackParam, summary)
        end,
        simulatorResponse = { }
    }
    bf.mspQueue:add(message)
end

return {
    getDataflashSummary = getDataflashSummary,
    eraseDataflash = eraseDataflash
}