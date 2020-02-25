local api = {}
--api.res_to = 0
--api.measure(0x3c, 55, 40, 5, 750, "/ec/temp")
--api.measure(0x3c, 55, 80, 1, 750, "/ec/ec")
--api.measure(0x3f, 39, 40, 5, 750, "/ise/temp")
--api.measure(0x3f, 39, 80, 1, 250, "/ise/ph")
function api.measure(dev_addr, task_reg, task_cmd, res_reg, res_to, topic)
    --io.res_to = res_to
    io._write_byte(dev_addr, task_reg, task_cmd, res_to)
    --local tmr = tmr
    --tmr.delay(res_to*1000)    
    local ret = io._read_register(dev_addr, res_reg)    
    mqtt_pub(topic, ret)
    collectgarbage()
    return ret
end

--api.setTemp(0x3c, 5, tempC, "/ec/set/temp")
--api.setTemp(0x3f, 5, tempC, "/ise/set/temp")
function api.setTemp(dev_addr, dev_reg, tempC, topic)
    io._write_register(dev_addr, dev_reg, tempC)
    mqtt_pub(topic, tempC)
end

--api.useTemperatureCompensation(0x3c, 1, 54, true|false)
--api.useTemperatureCompensation(0x3f, 1, 38, true|false)
function api.useTemperatureCompensation(dev_addr, bit_pos, tgt_reg, b)
    io._change_register(dev_addr, tgt_reg)
    local ret = string.byte(io._read_byte(dev_addr))
    local v = io._bit_set(ret, bit_pos, b)
    io._write_byte(dev_addr, tgt_reg, v)
    return ret
end

--api.getTemperatureCompensation(0x3c, 54, "/ec/temp/compensation")
--api.getTemperatureCompensation(0x3f, 38, "/ise/temp/compensation")
function api.getTemperatureCompensation(dev_addr, tgt_reg, topic)
    io._change_register(dev_addr, tgt_reg)
    local ret = bit.isset(string.byte(io._read_byte(dev_addr)), 1)
    mqtt_pub(topic, ret and "yes" or "no")
end

--api.setTempConstant(temp_constant)
function api.setTempConstant(tempC) -- ec only
     io._write_register(0x3c, 45, tempC)
end

--api.getTempConstant()
function api.getTempConstant() -- ec only
    local ret = io._read_register(0x3c, 45)
    mqtt_pub("/ec/temp/constant", ret)
    return ret
end

--api.setTempCoefficient(temp_coef)
function api.setTempCoefficient(temp_coef) -- ec only
    io._write_register(0x3c, 13, temp_coef)
    --mqtt_pub('/set/temp/coefficient', temp_coef)
end

--api.getTempCoefficient()
function api.getTempCoefficient() -- ec only
    local ret = io._read_register(0x3c, 13)
    mqtt_pub("/ec/temp/coefficient", ret)
    return ret
end

--api.reset(dev_addr, ecprobe, topic)
function api.reset(dev_addr, ecprobe, topic)
    io._reset_register(dev_addr, ecprobe and 33 or 9)
    io._reset_register(dev_addr, ecprobe and 17 or 13)
    io._reset_register(dev_addr, ecprobe and 21 or 17)
    io._reset_register(dev_addr, ecprobe and 25 or 21)
    io._reset_register(dev_addr, ecprobe and 29 or 25)
    if ecprobe == true then
        api.setTempConstant(25)
        api.setTempCoefficient(0.019)
        api.useTemperatureCompensation(False)
    end
    mqtt_pub(topic, "ok")
end

--api.getCalibrate(0x3c, 33, "/ec/calibrate/offset")
--api.getCalibrate(0x3f, 9, "/ise/calibrate/offset")
--api.getCalibrate(0x3c, 17, "/ec/calibrate/ref/high")
--api.getCalibrate(0x3f, 13, "ise/calibrate/ref/high")
--api.getCalibrate(0x3c, 21, "/ec/calibrate/ref/low")
--api.getCalibrate(0x3f, 17, "/ise/calibrate/ref/low")
--api.getCalibrate(0x3c, 25, "/ec/calibrate/read/high")
--api.getCalibrate(0x3f, 21, "/ise/calibrate/read/high")
--api.getCalibrate(0x3c, 29, "/ec/calibrate/read/low")
--api.getCalibrate(0x3f, 25, "/ise/calibrate/read/low")
function api.getCalibrate(dev_addr, dev_reg, topic)
    local ret = io._read_register(dev_addr, dev_reg)
    mqtt_pub(topic, ret)
    return ret
end

--api.calibrate(solution, ecprobe)
function api.calibration(solution, ecprobe)
    local dev_addr = ecprobe and 0x3c or 0x3f
    local dev_reg = ecprobe and 9 or 29
    io._write_register(dev_addr, dev_reg, solution)
    return dev_addr
end

--api.calibrate(0x3c, 55, 20, 750, solution, true, "/ec/calibrate/single")
--api.calibrate(0x3f, 39, 20, 250, solution, false, "/ise/calibrate/single")
--api.calibrate(0x3c, 55, 10, 750, solution, true, "/ec/calibrate/low")
--api.calibrate(0x3f, 39, 10, 250, solution, false, "/ise/calibrate/low")
--api.calibrate(0x3c, 55, 8, 750, solution, true, "/ec/calibrate/high")
--api.calibrate(0x3f, 39, 8, 250, solution, false, "/ise/calibrate/high")
function api.calibrate(dev_addr, task_reg, task_cmd, res_to, solution, ecprobe, topic)
    api.calibration(solution, ecprobe)
    io._write_byte(dev_addr, task_reg, task_cmd, res_to)
end

--api.setDualPointCalibration(refLow, refHigh, readLow, readHigh, ecprobe)
function api.setDualPointCalibration(refLow, refHigh, readLow, readHigh, ecprobe)
    local dev_addr = ecprobe and 0x3c or 0x3f
    local dev_reg = ecprobe and 21 or 17
    io._write_register(dev_addr, dev_reg, refLow)
    dev_reg = ecprobe and 17 or 13
    io._write_register(dev_addr, dev_reg, refHigh)
    dev_reg = ecprobe and 29 or 25
    io._write_register(dev_addr, dev_reg, readLow)
    dev_reg = ecprobe and 25 or 21
    io._write_register(dev_addr, dev_reg, readHigh)
end

--api.setCalibrateOffset(offset)
function api.setCalibrateOffset(offset) -- ec only
    io._write_register(0x3c, 33, offset)
end

--api.getFirmware(0x3c, 53, "/ec/firmware")
--api.getFirmware(0x3f, 37, "/ise/firmware")
function api.getFirmware(dev_addr, dev_reg, topic)
    io._change_register(dev_addr, dev_reg)
    local ret = string.byte(io._read_byte(dev_addr, dev_reg))
    mqtt_pub(topic, ret)
    return ret
end

--api.getVersion(0x3c, 0, "/ec/version")
--api.getVersion(0x3f, 0, "/ise/version")
function api.getVersion(dev_addr, dev_reg, topic)
    io._change_register(dev_addr, dev_reg)
    local ret = string.byte(io._read_byte(dev_addr))
    mqtt_pub(topic, ret)
    return ret
end

function mqtt_pub(topic,msg)
    if minimal == false then pub(topic, msg) end
end

return api
