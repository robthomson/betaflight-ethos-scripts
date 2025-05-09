local PageFiles = {}

--if bf.apiVersion >= 1.36 and features.vtx then
--if bf.apiVersion >= 1.36 then
--    PageFiles[#PageFiles + 1] = { title = "VTX Settings", script = "vtx.lua", init = "PAGES/INIT/vtx.lua" }
--end

if bf.apiVersion >= 1.16 then
    PageFiles[#PageFiles + 1] = { title = "Profiles", script = "profiles.lua" }
end

if bf.apiVersion >= 1.16 then
    PageFiles[#PageFiles + 1] = { title = "PIDs 1", script = "pids1.lua" }
end

if bf.apiVersion >= 1.21 then
    PageFiles[#PageFiles + 1] = { title = "PIDs 2", script = "pids2.lua" }
end

if bf.apiVersion >= 1.16 then
    PageFiles[#PageFiles + 1] = { title = "Rates", script = "rates.lua" }
end

if bf.apiVersion >= 1.16 then
    PageFiles[#PageFiles + 1] = { title = "Advanced PIDs", script = "pid_advanced.lua" }
end

if bf.apiVersion >= 1.44 then
    PageFiles[#PageFiles + 1] = { title = "Simplified Tuning", script = "simplified_tuning.lua" }
end

if bf.apiVersion >= 1.16 then
    PageFiles[#PageFiles + 1] = { title = "Filters 1", script = "filters1.lua" }
end

if bf.apiVersion >= 1.42 then
    PageFiles[#PageFiles + 1] = { title = "Filters 2", script = "filters2.lua" }
end

if bf.apiVersion >= 1.16 then
    PageFiles[#PageFiles + 1] = { title = "System / Motor", script = "pwm.lua", init = "PAGES/INIT/pwm.lua" }
end

if bf.apiVersion >= 1.16 then
    PageFiles[#PageFiles + 1] = { title = "Receiver", script = "rx.lua" }
end

if bf.apiVersion >= 1.16 then
    PageFiles[#PageFiles + 1] = { title = "Failsafe", script = "failsafe.lua" }
end

--if bf.apiVersion >= 1.41 and features.gps then
if bf.apiVersion >= 1.41 then
    PageFiles[#PageFiles + 1] = { title = "GPS Rescue", script = "rescue.lua" }
end

--if bf.apiVersion >= 1.41 and features.gps then
if bf.apiVersion >= 1.41 then
    PageFiles[#PageFiles + 1] = { title = "GPS PIDs", script = "gpspids.lua" }
end

if bf.apiVersion >= 1.16 then
    PageFiles[#PageFiles + 1] = { title = "Trim Accelerometer", script = "acc_trim.lua" }
end

--if bf.apiVersion >= 1.45 and features.osdSD then
if bf.apiVersion >= 1.45 then
    PageFiles[#PageFiles + 1] = { title = "OSD Elements", script = "pos_osd.lua" }
end

return PageFiles
