--
local user = "ufire"
local pass = "ufire"
local host = "192.168.10.240"
local port = 1883
--
local mqtt = mqtt.Client(wifi_mac, 10, user, pass)
local tmr = tmr

function connect()        
    mqtt:lwt(wifi_mac .. "/lwt", "offline", 0, 0)
    mqtt:connect(host, port, false)
    collectgarbage()
end
mqtt:on("connect", function(conn)    
    mqtt:subscribe(wifi_mac.."/#",0, function(conn)
        local info = "online"
        local topic = "/startup"
        pub(topic, info)                
    end)                  
end)
mqtt:on("offline", function(conn)    
    tmr.delay(1000000)
    connect()
    collectgarbage()
end)
mqtt:on("message", function(conn, topic, data)
    if(topic == wifi_mac .. "/cmd/api") then
        local cmd = loadstring(data)
        cmd()
    elseif(topic == wifi_mac .. "/get/ec/temp") then
        local temp = api.measure(0x3c, 55, 40, 5, 750, "/ec/temp")
    elseif(topic == wifi_mac .. "/get/ise/temp") then
        local temp = api.measure(0x3f, 39, 40, 5, 750, "/ise/temp")
    elseif(topic == wifi_mac .. "/get/ec/ec") then
        local temp = api.measure(0x3c, 55, 80, 1, 750, "/ec/ec")
    elseif(topic == wifi_mac .. "/get/ise/ph") then
        local temp = api.measure(0x3f, 39, 80, 1, 250, "/ise/ph")
    elseif(topic == wifi_mac .. "/node/heap") then
        local heap = node.heap()
        pub("/heap",heap)
    elseif(topic == wifi_mac .. "/node/restart") then
        mqtt:publish(wifi_mac .. "/restart",'Remote Reboot',0,0, function(conn)
            node.restart()
        end)        
    end
    collectgarbage()
end)
function pub(topic, msg)
    mqtt:publish(wifi_mac .. topic,msg,0,0, function(conn) 
        collectgarbage()
    end)    
end
connect()
