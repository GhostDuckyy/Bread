local game_list = {
    -- Blox fruit
    ["2753915549 4442272183 4442272183"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Bread_Fruit.lua",
    -- Godzilla Simulator
    ["1257535190"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Godzilla_Sim.lua",
    -- Rebirth Champions X
    ["8540346411"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Rebirth%20Champions%20X.lua",
    -- Tapping Simulator
    ["9498006165"] = "https://raw.githubusercontent.com/GhostDuckyy/Bread/main/Storage/Tapping%20Simulator.lua"
}

for ID, url in next, (game_list) do
    if string.find(ID,tostring(game.PlaceId)) or string.match(ID,tostring(game.PlaceId)) then
        if url ~= nil then
            local s,e = pcall(function() loadstring(game:HttpGet(url,true))(); end)
            if s then
                warn("Bread🍞 Success to load!")
            end
            if e and not s then
                warn("Bread🍞 Failed to load!")
            end
            break;
        end
    end
end
