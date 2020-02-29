function connect (conn, data)
   local query_data   
   local res = ''   
   --port,ip = conn:getpeer()
   --print(ip, port)   
   conn:on ("receive", 
      function (cn, req_data)
        -- print("FULL REQUEST: " .. req_data)         
        res = "hello world!"
        query_data = get_http_req (req_data)
        --print("REQUEST: " .. query_data["REQUEST"])        
        if (query_data["PARAMS"] ~= nil) then
            --print("---")
            --print("PARAMS")
            local ref = 0
            for k,v in pairs(query_data["PARAMS"]) do
                if (k == "reboot") then
                    node.restart()
                elseif (k == "heap") then
                    res = node.heap()                  
                elseif (k == "getCalibrateOffset") then
                    res = v == "1" and api.getCalibrate(0x3c, 33, "/ec/calibrate/offset") or api.getCalibrate(0x3f, 9, "/ise/calibrate/offset")
                elseif (k == "getCalibrateRefHigh") then
                    res = v == "1" and api.getCalibrate(0x3c, 17, "/ec/calibrate/ref/high") or api.getCalibrate(0x3f, 13, "ise/calibrate/ref/high")
                elseif (k == "getCalibrateRefLow") then
                    res = v == "1" and api.getCalibrate(0x3c, 21, "/ec/calibrate/ref/low") or api.getCalibrate(0x3f, 17, "/ise/calibrate/ref/low")
                elseif (k == "getCalibrateReadHigh") then
                    res = v == "1" and api.getCalibrate(0x3c, 25, "/ec/calibrate/read/high") or api.getCalibrate(0x3f, 21, "/ise/calibrate/read/high")
                elseif (k == "getCalibrateReadLow") then
                    res = v == "1" and api.getCalibrate(0x3c, 29, "/ec/calibrate/read/low") or api.getCalibrate(0x3f, 25, "/ise/calibrate/read/low")
                elseif (k == "getTemperatureCompensation") then
                    res = v == "1" and api.getTemperatureCompensation(0x3c, 54, "/ec/temp/compensation") or api.getTemperatureCompensation(0x3f, 38, "/ise/temp/compensation")
                elseif (k == "getTempConstant") then -- ec only
                    res = api.getTempConstant()
                elseif (k == "getTempCoefficient") then -- ec only
                    res = api.getTempCoefficient()
                elseif (k == "getFirmware") then
                    res = v == "1" and api.getFirmware(0x3c, 53, "/ec/firmware") or api.getFirmware(0x3f, 37, "/ise/firmware")
                elseif (k == "getVersion") then
                    res = v == "1" and api.getVersion(0x3c, 0, "/ec/version") or api.getVersion(0x3f, 0, "/ise/version")
                elseif(k == "ec_temp") then
                    res = api.measure(0x3c, 55, 40, 5, 750, "/ec/temp")
                elseif(k == "ise_temp") then
                    res = api.measure(0x3f, 39, 40, 5, 750, "/ise/temp")
                elseif(k == "ec_ec") then
                    res = api.measure(0x3c, 55, 80, 1, 750, "/ec/ec")
                elseif(k == "ise_mv") then
                    res = api.measure(0x3f, 39, 80, 1, 250, "/ise/mv")
                end
                --print("KEY: " .. k,  "VALUE: " .. v) 
            end
            --print("---")
        end        
        --print ("METHOD: " .. query_data["METHOD"] .. " UA: " .. " " .. query_data["User-Agent"])
        --print ("")         
        cn:send (res)
     end)
     
   conn:on("sent", function(cn)
        cn:close()
        collectgarbage()
     end)
end

-- Build and return a table of the http request data
function get_http_req (instr)
   local t = {}
   local first = nil
   local key, v, strt_ndx, end_ndx   

   for str in string.gmatch (instr, "([^\n]+)") do
      -- First line in the method and path
      if (first == nil) then
         first = 1
         strt_ndx, end_ndx = string.find (str, "([^ ]+)")
         v = trim (string.sub (str, end_ndx + 2))
         key = trim (string.sub (str, strt_ndx, end_ndx))
         t["METHOD"] = key
         t["REQUEST"] = v
         s_ndx, e_ndx = string.find (v, "([^ ]+)")         
         r = trim (string.sub (v, s_ndx + 1, e_ndx))
         
         if(string.len(r) > 0) then            
            -- print(r)
            p = parse_url(r)
            t["PARAMS"] = p
            -- debug
            -- for k,v in pairs(p) do print(k,v) end
         end         
         -- print(p.user);
      else -- Process and reamaining ":" fields
         strt_ndx, end_ndx = string.find (str, "([^:]+)")
         if (end_ndx ~= nil) then
            v = trim (string.sub (str, end_ndx + 2))
            key = trim (string.sub (str, strt_ndx, end_ndx))
            t[key] = v
         end
      end
   end

   return t
end

function decode(s)
    s = s:gsub('+', ' ')
    s = s:gsub('%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

function parse_url(s)
    --s = s:match('%s+(.+)')
    local ans = {}
    for k,v in s:gmatch('([^&=]+)=([^&=]*)&?' ) do
        ans[ k ] = decode(v)
    end
    return ans
end

function escape_pattern(text)
    return text:gsub("([^%w])", "%%%1")
end

-- String trim left and right
function trim (s)
  return (s:gsub ("^%s*(.-)%s*$", "%1"))
end

local busy = false

-- Create the httpd server
svr = net.createServer (net.TCP, 30)

-- Server listening on port 80, call connect function if a request is received
svr:listen (80, connect)

collectgarbage()