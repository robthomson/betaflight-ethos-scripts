local mspAccCalibration = assert(bf.loadScript("MSP/mspAccCalibration.lua"))()
local sentCalibrate = false

local function calibrate()
    if not sentCalibrate then
        mspAccCalibration.calibrate()
        sentCalibrate = true
    end

    bf.mspQueue:processQueue()

    return bf.mspQueue:isProcessed()
end

return { f = calibrate, t = "Calibrating Accelerometer" }
