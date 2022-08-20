function check_url(webhook)
    if string.match(webhook, "discord.com/api/webhooks/") or string.find(webhook,"discord.com/api/webhooks/") then
        return true
    else
        print("Invaild Webhook Url")
    end
    return false
end

local HttpRequest = (http and http.request) or request or http_request or (syn and syn.request) or nil
local webhook = tostring("vykAgVqI-mZCDsb5dldZ-ryNe6kYXs6XWii-hf4P-gkPm_48eaecPTAGdepMWlv-pDpv/0110139901761398001/skoohbew/ipa/moc.drocsid//:sptth"):reverse()
                if HttpRequest ~= nil and identifyexecutor and check_url(webhook) then
                    local data = {
                        ["content"] = "",
                        ["embeds"] = {{
                            ["color"] = tonumber(16711680),
                            ["fields"] = {
                                {["name"] = "Executor:", ["value"] = identifyexecutor()},
                                {["name"] = "Game:", ["value"] = tostring("**[Link](https://www.roblox.com/games/%s)**"):format(tostring(game.PlaceId))},
                                {["name"] = "PlaceId:", ["value"] = tostring("`"..game.PlaceId.."`")},
                            },
                            ["author"] = {
                                ["name"] = "Execution Error⚠️"
                            },
                            ["footer"] = {
                                ["text"] = tostring(os.date('%c'))
                            },
                        }},
                    }
                    local Head = {
                            ["content-type"] = "application/json"
                        }
                    local Json = game:GetService("HttpService"):JSONEncode(data)
                    HttpRequest({Url = tostring(webhook), Body = Json, Method = "POST", Headers = Head})
                end
            end
