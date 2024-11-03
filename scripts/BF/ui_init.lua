local mspApiVersion = assert(bf.loadScript("MSP/mspApiVersion.lua"))()
local returnTable = { f = nil, t = "" }
local apiVersion
local lastRunTS

local function init()
    if bf.getRSSI() == 0 and not bf.runningInSimulator then
        returnTable.t = "Waiting for connection"
        return false
    end

    if not apiVersion and (not lastRunTS or lastRunTS + 2 < bf.clock()) then
        returnTable.t = "Waiting for API version"
        mspApiVersion.getApiVersion(function(_, version) apiVersion = version end)
        lastRunTS = bf.clock()
    end

    bf.mspQueue:processQueue()

    if bf.mspQueue:isProcessed() and apiVersion then
        local apiVersionAsString = string.format("%.2f", apiVersion)
        --if apiVersion < 1.46 then
        --    returnTable.t = "This version of the Lua\nscripts can't be used\nwith the selected model\nwhich has version "..apiVersionAsString.."."
        --else
            -- received correct API version, proceed
            bf.apiVersion = apiVersion
            collectgarbage()
            return true
        --end
    end

    return false
end

returnTable.f = init

return returnTable
