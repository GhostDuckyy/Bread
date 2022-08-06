local game_list = {
    -- Godzilla Simulator
    ["1257535190"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Godzilla_Sim.lua",
    -- Rebirth Champions X
    ["8540346411"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Rebirth%20Champions%20X.lua",
}

for i,v in next, (game_list) do
    if game.PlaceId == tonumber(i) then
        if v ~= nil and type(v) == "string" then
            local url = v;
            loadstring(game:HttpGet(url,true))()
        end
    end
end
