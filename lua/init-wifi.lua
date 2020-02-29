--
local SSID = "UFIRE"
local KEY  = "PASSWORD"
--
local wifiT = nil
local wifi = wifi
local tmr = tmr
wifi_mac = ''

function startup()
    wifi.setmode (wifi.STATION)
    wifi.sta.config {ssid=SSID,pwd=KEY}
    wifi.sta.autoconnect(1)
    wait_for_wifi_conn()    
end
function wait_for_wifi_conn()
    wifiT = tmr.create()
    wifiT:register(100, tmr.ALARM_AUTO, function()
        if wifi.sta.getip() == nil then
        elseif wifi_mac == '' then
            --local ip,mask,gw = wifi.sta.getip()
            wifi_mac = wifi.sta.getmac()
            wifiT:unregister()
            require('i2c-setup')            
            require('ufire-i2c')            
            if minimal == "http" then require('httpd-server')
            elseif minimal == "mqtt" then require('mqtt-client') end
            collectgarbage()
        end
    end)
    wifiT:start()    
end
startup()
