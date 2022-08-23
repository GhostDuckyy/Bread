local game_list = {
    --// Blox fruit
    ["2753915549 4442272183 4442272183"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Blox%20Fruit.lua",
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
    --// Wheat Farming Simulator
    ["10106105124"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Wheat%20Farming%20Simulator.lua",
}

for ID, url in next, (game_list) do
    if string.find(ID,tostring(game.PlaceId)) or string.match(ID,tostring(game.PlaceId)) then
        if url ~= nil then
            local s,e = pcall(function() loadstring(game:HttpGet(url,true))(); end)
            if s then
                warn("Bread🍞 Success to load!")
            end
            if e then
                warn("Bread🍞 Failed to load!")
                loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Loader/error.lua",true))();
            	break;
            end
        end
    end
end
