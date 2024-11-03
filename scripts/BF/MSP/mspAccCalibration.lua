local function calibrate(callback, callbackParam)
    local message =
    {
        command = 205, -- MSP_ACC_CALIBRATION
        processReply = function(self, buf)
            bf.print("Accelerometer calibrated.")
            if callback then callback(callbackParam) end
        end,
        simulatorResponse = {}
    }
    bf.mspQueue:add(message)
end

return {
    calibrate = calibrate
}