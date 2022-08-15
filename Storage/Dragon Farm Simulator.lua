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
local SellDragon_event = ReplicatedStorage.Remotes.SellDragon

--// Script
local info = w.New({Title = "info"})
local status = info.Button({Text = "Status: wait player claim tycoon",Callback = function() return end})
info.Button({Text = "Copy discord invite",Callback = function() if setclipboard then local x,y = pcall(function()setclipboard("https://discord.gg/TFUeFEESVv")end) if x then game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Bread",Text = "Copied discord invite",Icon = "rbxassetid://10599406889",Duration = 5,}) end end end})
info.Button({Text = "Scripting: Ghost-Ducky#7698"})
info.Button({Text = "UI: Material Lua"})

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
    Nest = {},
    select_nest = nil,
}

local main = w.New({Title = "main"})
local sell = w.New({Title = "sell"})
local misc = w.New({Title = "misc"})

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
    Text = "Auto sell eggs",
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

do
    local Floor1 = Tycoon.Buttons.Dragon:FindFirstChild("Floor1")
    local Floor2 = Tycoon.Buttons.Dragon:FindFirstChild("Floor2")
    if Floor1 then
        for i,v in ipairs(Floor1:GetChildren()) do
            if v:IsA("Model") and not v:FindFirstChild("Button") then
                table.insert(getgenv().Setting.Nest,v.Name)
            end
            if v:IsA("Model") and v:FindFirstChild("Button") then
                if table.find(getgenv().Setting.Nest,v.Name) then
                    table.remove(getgenv().Setting.Nest,table.find(getgenv().Setting.Nest,v.Name))
                end
            end
        end
    end
    if Floor2 then
        for i,v in ipairs(Floor2:GetChildren()) do
            if v:IsA("Model") and not v:FindFirstChild("Button") then
                table.insert(getgenv().Setting.Nest,v.Name)
            end
            if v:IsA("Model") and v:FindFirstChild("Button") then
                if table.find(getgenv().Setting.Nest,v.Name) then
                    table.remove(getgenv().Setting.Nest,table.find(getgenv().Setting.Nest,v.Name))
                end
            end
        end
    end
end

local nest_list = sell.Dropdown({
    Text = "Select nest",
    Callback = function(x)
        getgenv().select_nest = x;
        local z = getNest(getgenv().select_nest)
        local y = nil;
        for _,drg in ipairs(z:GetChildren()) do
            if drg:IsA("Model") and tostring(drg.Name):lower() ~= "nest" then
                y = tostring(drg.Name)
            end
        end
        local Text;
        if z and y then
            Text = tostring("Nest: %s / Dragon: %s"):format(tostring(z.Name),y)
            getgenv().Nest_info:SetText(Text)
        end
    end,
    Options = getgenv().Setting.Nest,
})
sell.Button({Text = "Refresh",Callback = function()
    nest_list:SetOptions({})
    do
        local Floor1 = Tycoon.Buttons.Dragon:FindFirstChild("Floor1")
        local Floor2 = Tycoon.Buttons.Dragon:FindFirstChild("Floor2")
        if Floor1 then
            for i,v in ipairs(Floor1:GetChildren()) do
                if not table.find(getgenv().Setting.Nest,v.Name) and v:IsA("Model") and not v:FindFirstChild("Button") then
                    table.insert(getgenv().Setting.Nest,v.Name)
                end
                if v:IsA("Model") and v:FindFirstChild("Button") then
                    if table.find(getgenv().Setting.Nest,v.Name) then
                        table.remove(getgenv().Setting.Nest,table.find(getgenv().Setting.Nest,v.Name))
                    end
                end
            end
        end
        if Floor2 then
            for i,v in ipairs(Floor2:GetChildren()) do
                if not table.find(getgenv().Setting.Nest,v.Name) and v:IsA("Model") and not v:FindFirstChild("Button") then
                    table.insert(getgenv().Setting.Nest,v.Name)
                end
                if v:IsA("Model") and v:FindFirstChild("Button") then
                    if table.find(getgenv().Setting.Nest,v.Name) then
                        table.remove(getgenv().Setting.Nest,table.find(getgenv().Setting.Nest,v.Name))
                    end
                end
            end
        end
    end
    wait(.2)
    nest_list:SetOptions(getgenv().Setting.Nest)
end})
getgenv().Nest_info = sell.Button({Text = "Nest: nil / Dragon: nil"})
sell.Button({Text = "Sell dragon", Callback = function()
    local nest = getNest(getgenv().select_nest)
    local dragon = nil;
    if nest then
        for _,drg in ipairs(nest:GetChildren()) do
            if drg:IsA("Model") and tostring(drg.Name):lower() ~= "nest" then
                dragon = tostring(drg.Name)
            end
        end
        FireServer(SellDragon_event,{[1] = nest,[2] = dragon})
    end
end})
function getNest(str)
    local nest = tostring(str):lower()
    local Floor1 = Tycoon.Buttons.Dragon:FindFirstChild("Floor1")
    local Floor2 = Tycoon.Buttons.Dragon:FindFirstChild("Floor2")
    if Floor1 then
        for i,v in ipairs(Floor1:GetChildren()) do
            if tostring(v.Name):lower() == nest then
                return v
            end
        end
    end
    if Floor2 then
        for i,v in ipairs(Floor2:GetChildren()) do
            if tostring(v.Name):lower() == nest then
                return v
            end
        end
    end
    return nil
end

misc.Button({Text = "Character"})
local ws = misc.Slider({
    Text = "walk speed",
    Min = 16,
    Max = 500,
    Def = 16,
    Callback = function(x)
        getgenv().walk = x;
    end
})
local jp = misc.Slider({
    Text = "jump height",
    Min = 16,
    Max = 500,
    Def = 16,
    Callback = function(x)
        getgenv().jump = x;
    end
})
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local l = tonumber(getgenv().walk)
        local ll = tonumber(getgenv().jump)
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = l;
            Humanoid.JumpPower = ll;
        end
    end
end)

--[[
local Dragon_list = {}
for _,v in ipairs(ReplicatedStorage.Assets.Dragons:GetChildren()) do
    if v:IsA("Model") then
        local Dragon_name = tostring(v.Name)
        if not table.find(Dragon_list,Dragon_name) then
            table.insert(Dragon_list,tostring(v.Name))
        end
    end
end
wait(.5)
main.Dropdown({
    Text = "Select dragon",
    Options = Dragon_list,
    Callback = function(x)
        getgenv().Setting.Dragon = x;
    end
})
main.Toggle({
    Text = "Auto buy dragon",
    Callback = function(x)
        getgenv().Setting.Buy_dragon = x;
        if x then
            auto_Buy()
        end
    end
})
function auto_Buy()
    spawn(function()
        while getgenv().Setting.Buy_dragon and task.wait(.5) do
            local Dragon_Type = getgenv().Setting.Dragon
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if Dragon_Type ~= nil and LocalPlayer.Character then
                if Tycoon:FindFirstChild("Buttons") and Tycoon["Buttons"]:FindFirstChild("Dragon") then
                    local Floor1 = Tycoon["Buttons"]["Dragon"]:FindFirstChild("Floor1")
                    local Floor2 = Tycoon["Buttons"]["Dragon"]:FindFirstChild("Floor2")
                    local Floor3 = Tycoon["Buttons"]["Dragon"]:FindFirstChild("Floor3")
                    if Floor1 then
                        for _,btn in ipairs(Floor1:GetDescendants()) do
                            if btn.Parent and tostring(btn.Name):lower() == tostring("Button"):lower() then
                                firetouchinterest(hrp, btn, 1)
                                wait(.2)
                                firetouchinterest(hrp, btn, 0)
                                InvokeServer(BuyDragon_function,{btn.Parent.Name, Dragon_Type})
                            end
                        end
                    end
                    if Floor2 then
                        for _,btn in ipairs(Floor2:GetDescendants()) do
                            if btn.Parent and tostring(btn.Name):lower() == tostring("Button"):lower() then
                                firetouchinterest(hrp, btn, 1)
                                wait(.2)
                                firetouchinterest(hrp, btn, 0)
                                InvokeServer(BuyDragon_function,{btn.Parent.Name, Dragon_Type})
                            end
                        end
                    end
                    if Floor3 then
                        for _,btn in ipairs(Floor3:GetDescendants()) do
                            if btn.Parent and tostring(btn.Name):lower() == tostring("Button"):lower() then
                                firetouchinterest(hrp, btn, 1)
                                wait(.2)
                                firetouchinterest(hrp, btn, 0)
                                InvokeServer(BuyDragon_function,{btn.Parent.Name, Dragon_Type})
                            end
                        end
                    end
                end
            end
        end
    end)
end]]