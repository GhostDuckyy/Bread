local game_list = {
    -- Godzilla Simulator
    ["1257535190"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Godzilla_Sim.lua",
    -- Rebirth Champions X
    ["8540346411"] = "",
}

for i,v in next, (game_list) do
    if game.PlaceId == tonumber(i) then
        if v ~= nil then
            loadstring(game:HttpGet(v,true))()
        end
    end
end
