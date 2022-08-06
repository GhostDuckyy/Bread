local game_list = {
    -- Godzilla Simulator
    ["1257535190"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Godzilla_Sim.lua",
    -- Rebirth Champions X
    ["8540346411"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Rebirth%20Champions%20X.lua",
}

for ID, url in next, (game_list) do
    if string.find(ID,game.PlaceId) or string.match(ID,game.PlaceId) then
        if url ~= nil then
            loadstring(game:HttpGet(url,true))();
            break;
        end
    end
end
