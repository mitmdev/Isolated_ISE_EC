local id, scl, sda = 0, 1, 2
local i2c = i2c
-- scl: PIN 1 (I/O index) = GPIO5 (D1)
-- sda: PIN 2 (I/O index) = GPIO4 (D2)
function i2c_setup(sda,scl)
    i2c.setup(id, sda, scl, i2c.FASTPLUS)    
end
function i2c_device_check(dev_addr)
    i2c.start(id)
    local ret = i2c.address(id, dev_addr, i2c.TRANSMITTER)
    i2c.stop(id)
    return ret
end
i2c_setup(sda,scl)
