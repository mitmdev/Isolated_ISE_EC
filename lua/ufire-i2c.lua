local ise_dev_addr = 0x3f
local ec_dev_addr  = 0x3c
ise_dev, ec_dev = false
utils, io, api = {}
function ufire_setup()    
    if ise_dev or ec_dev then      
        io    = require('ufire-io')        
        api   = require('ufire-api')        
        utils = require('ufire-utils')        
    end
end
function device_init()
    ise_dev = i2c_device_check(ise_dev_addr)
    ec_dev = i2c_device_check(ec_dev_addr)
end
device_init()
ufire_setup()
collectgarbage()
