local ise_dev_addr = 0x3f
local ec_dev_addr  = 0x3c
ise_dev, ec_dev = false
utils, io, api = {}
function ufire_setup()
    device_init()
    if ise_dev == true or ec_dev == true then        
        io    = require('ufire-io')        
        api   = require('ufire-api')        
        utils = require('ufire-utils')
        collectgarbage()
    end
end
function device_init()
    if i2c_device_check(ise_dev_addr) == true then 
        ise_dev = true 
    end
    if i2c_device_check(ec_dev_addr) == true then 
        ec_dev = true 
    end
end
ufire_setup()
