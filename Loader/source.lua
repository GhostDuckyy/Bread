local game_list = {
    --// Blox fruit
    ["2753915549 4442272183 4442272183"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Bread_Fruit.lua",
    --// Godzilla Simulator
    ["1257535190"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Godzilla_Sim.lua",
    --// Rebirth Champions X
    ["8540346411"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Rebirth%20Champions%20X.lua",
    --// Tapping Simulator
    ["9498006165"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Tapping%20Simulator.lua",
    --// Op ninja simulator
    ["4225025295"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/op%20ninja%20simulator.lua",
    --// Mining Clicker Simulator
    ["8884334497"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Mining%20Clicker%20Simulator.lua",
    --// Dragon Farm Simulator
    ["9983979661"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Dragon%20Farm%20Simulator.lua",

}

function check_url(webhook)
    if string.match(webhook, "discord.com/api/webhooks/") or string.find(webhook,"discord.com/api/webhooks/") then
        return true
    else
        print("Invaild Webhook Url")
    end
    return false
end

for ID, url in next, (game_list) do
    if string.find(ID,tostring(game.PlaceId)) or string.match(ID,tostring(game.PlaceId)) then
        if url ~= nil then
            local s,e = pcall(function() loadstring(game:HttpGet(url,true))(); end)
            if s then
                warn("Bread🍞 Success to load!")
            end
            if e and not s then
                warn("Bread🍞 Failed to load!")
                local HttpRequest = (http and http.request) or request or http_request or (syn and syn.request) or nil
                local webhook = "https://discord.com/api/webhooks/1008931671099310110/vpDp-vlWMpedGATPceae84_mPkg-P4fh-iiWX6sXYk6eNyr-Zdld5bsDCZm-IqVgAkyv"
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
            break;
        end
    end
end
