local io = {}
local bit, i2c, tmr = bit, i2c, tmr
local id = 0
function io._read_byte(dev_addr)
    local t = 10000
    local data = 0x00    
    i2c.start(id)
    if i2c.address(0, dev_addr, i2c.RECEIVER) == true then
        data = i2c.read(id, 1)        
    end
    tmr.delay(t)
    i2c.stop(id)
    return data
end
function io._write_byte(dev_addr, reg_addr, data, res_to)        
    local t = 10000
    i2c.start(id)
    i2c.address(id, dev_addr, i2c.TRANSMITTER)
    i2c.write(id,reg_addr)
    tmr.delay(t)    
    if data ~= false then 
        i2c.write(id,data)
        tmr.delay(t)
    end
    i2c.stop(id)
    if res_to ~= nil and res_to ~= false then tmr.delay(res_to*1000) end
end
function io.read_reg(dev_addr)
    local t,e,m,p = 0x00
    t = io._read_byte(dev_addr)
    e = io._read_byte(dev_addr)
    m = io._read_byte(dev_addr)
    p = io._read_byte(dev_addr)
    return t,e,m,p
end
function io._read_register(dev_addr, reg_addr)
    io._change_register(dev_addr, reg_addr)    
    local t,e,m,p = io.read_reg(dev_addr)
    local temp = t .. e .. m .. p    
    local data = struct.unpack('f', temp)    
    return data
end
function io._write_register(dev_addr, reg_addr, f, r)    
    if r == false then
        local n = utils.round_total_digits(f)
        f = struct.pack('f', n)
    end
    io._write_byte(dev_addr, reg_addr, f)    
end
function io._change_register(dev_addr, reg_addr)
    io._write_byte(dev_addr, reg_addr, false)    
end
function io._reset_register(dev_addr, reg_addr)
    local rst = {0x00, 0x00, 0xC0, 0x7F}
    io._write_register(dev_addr, reg_addr, rst, true)    
end
function io._bit_set(v, index, x)
    local ret = x and bit.set(v, index) or bit.clear(v, index)    
    return ret    
end
return io
