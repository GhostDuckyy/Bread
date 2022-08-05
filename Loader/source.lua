local game_list = {
    ["1257535190"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Godzilla_Sim.lua",
}

for i,v in next, (game_list) do
    print(i,v)
    if game.PlaceId == tonumber(i) then
        loadstring(game:HttpGet(v,true))()
    end
end
