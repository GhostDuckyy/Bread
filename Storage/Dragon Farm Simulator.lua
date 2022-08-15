--// Wait game loaded
while true do
    if game:IsLoaded() then break; end
    wait(.005)
end

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))();
local w = Library.Load({
    Title = "Bread🍞",
    Style = 1,
    SizeX = 400,
    SizeY = 300,
    Theme = "Dark"
})

--// Service
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = workspace.CurrentCamera

local TweenService = game:GetService("TweenService")

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local PathfindingService = game:GetService("PathfindingService")

--// remote
function FireServer(remote,...)
    if remote and remote:IsA("RemoteEvent") and type(...) == "table" then
        local args = ...
        return remote:FireServer(unpack(args))
    else
        local args = {...}
        return remote:FireServer(unpack(args))
    end
    if (...) == nil and remote and remote:IsA("RemoteEvent") then
        remote:FireServer()
    end
end
function InvokeServer(remote,...)
    if remote and remote:IsA("RemoteFunction") and type(...) == "table" then
        local args = ...
        return remote:InvokeServer(unpack(args))
    else
        local args = {...}
        return remote:InvokeServer(unpack(args))
    end
    if (...) == nil and remote and remote:IsA("RemoteFunction") then
        return remote:InvokeServer()
    end
end

local Collect_event = ReplicatedStorage.Remotes.CollectEgg
local BuyDragon_function = ReplicatedStorage.Remotes.BuyDragon

--// Script
local info = w.New({Title = "info"})
local status = info.Button({Text = "Status: wait player claim tycoon",Callback = function() return end})
info.Button({Text = "Copy discord invite",function() if setclipboard then local x,y = pcall(function()setclipboard("https://discord.gg/TFUeFEESVv")end) if x then game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Bread",Text = "Copied discord invite",Icon = "rbxassetid://10599406889",Duration = 5,}) end end end})
info.Button({Text = "Scripting: Ghost-Ducky#7698"},function() return end)
info.Button({Text = "UI: Material Lua"},function() return end)

function getTycoon()
    local Tycoon_function = ReplicatedStorage.Remotes:FindFirstChild("GetPlayerTycoon")
    if Tycoon_function then
        local output = InvokeServer(Tycoon_function,nil)
        if output ~= nil then
            local output_name = tostring(output):lower()
            for i,v in next, (workspace.Tycoons:GetChildren()) do
                local tycoon_name = tostring(v.Name):lower()
                if tycoon_name == output_name or string.find(tycoon_name,output_name) or string.match(tycoon_name,output_name) and v:IsA("Folder") then
                    return v
                end
            end
        end
    end
end
local Tycoon = getTycoon()
while Tycoon == nil do
    Tycoon = getTycoon()
    if Tycoon ~= nil then break; end
    task.wait(.1)
end
status:SetText("Status: Loaded")

getgenv().Setting = {
    Collect = false,
    Sell = false,
    Dragon = nil,
    Buy_dragon = false,
}

local main = w.New({Title = "main"})
-- local misc = w.New({Title = "misc"})

main.Toggle({
    Text = "Auto collect eggs",
    Callback = function(x)
        getgenv().Setting.Collect = x;
        if x then
            spawn(function()
                if Tycoon:FindFirstChild("Eggs") then
                    for i,v in ipairs(Tycoon["Eggs"]:GetChildren()) do
                        if v:FindFirstChild("Hitbox") then
                            FireServer(Collect_event,v)
                        end
                    end
                end
            end)
        end
    end,
    Enabled = false
})
Tycoon["Eggs"].DescendantAdded:Connect(function(child)
    if getgenv().Setting.Collect then
        task.wait(.1)
        if child:FindFirstChild("Hitbox") then
            FireServer(Collect_event,child)
        end
    end
end)

main.Toggle({
    Text = "Auto sell",
    Callback = function(x)
        getgenv().Setting.Sell = x;
        if x then
            Sell_eggs()
        end
    end
})
function Sell_eggs()
    spawn(function()
        local EggSellMachine = nil;
        for i,v in ipairs(Tycoon["Interaction"]:GetChildren()) do
            if tostring(v.Name):lower() == tostring("EggSellMachine"):lower() then
                EggSellMachine = v;
            end
        end
        while getgenv().Setting.Sell and task.wait(.01) do
            if EggSellMachine == nil then
                for i,v in ipairs(Tycoon["Interaction"]:GetChildren()) do
                    if tostring(v.Name):lower() == tostring("EggSellMachine"):lower() then
                        EggSellMachine = v;
                    end
                end
            else
                if EggSellMachine:FindFirstChild("SellButton") then
                    local Sell_Btn = EggSellMachine["SellButton"]:FindFirstChild("Main")
                    local ProximityPrompt = Sell_Btn:FindFirstChild("ProximityPrompt")
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if Sell_Btn and ProximityPrompt and hrp then
                        if ProximityPrompt.HoldDuration ~= .1 then ProximityPrompt.HoldDuration = .1 end
                        local cf = Sell_Btn.CFrame * CFrame.new(0,1.3,-3)
                        hrp.CFrame = cf
                        fireproximityprompt(ProximityPrompt)
                    end
                end
            end
        end
    end)
end

local Dragon_list = {}
for _,v in ipairs(ReplicatedStorage.Assets.Dragons:GetChildren()) do
    if v:IsA("Model") then
        local Dragon_name = tostring(v.Name)
        if not table.find(Dragon_list,Dragon_name) then
            table.insert(Dragon_list,tostring(v.Name))
        end
    end
end