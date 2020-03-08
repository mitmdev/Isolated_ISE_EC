local utils = {}
function utils.round(number, precision)
   local fmtStr = string.format('%%0.%sf',precision)
   number = string.format(fmtStr,number)
   return number
end

function utils.round_total_digits(number)    
    local l = 7 - string.len(string.format('%i', number))    
    return utils.round(number, l)
end
return utils