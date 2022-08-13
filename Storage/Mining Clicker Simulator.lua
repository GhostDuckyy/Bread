--// Wait game loaded
while true do
    if game:IsLoaded() then break; end
    wait(.005)
end

--// Library
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Mapple7777/Visual-UI-Library/main/Source.lua'))()
local w = Library:CreateWindow("Bread🍞","Minning Cliker")
local Icons = {
    Folder = "https://www.roblox.com/asset/?id=8668393244",
    Portal = "https://www.roblox.com/asset/?id=8671667006",
    Vision = "https://www.roblox.com/asset/?id=8671664613",
    Automatic = "https://www.roblox.com/asset/?id=10463883625",
    Shield = "https://www.roblox.com/asset/?id=10463868703",
    User_Shield = "https://www.roblox.com/asset/?id=10463878735",
    User_Folder = "https://www.roblox.com/asset/?id=10463880932",
}

function Make_notify(name,desc,time)
    if time ~= nil then
        Library:CreateNotification(tostring(name), tostring(desc), tonumber(time))
    else
        Library:CreateNotification(tostring(name), tostring(desc), tonumber(5))
    end
end

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
local mine_function = ReplicatedStorage.Remotes:WaitForChild("Click")
local bonus_function = ReplicatedStorage.Remotes:WaitForChild("Bonus")
local daily_function = ReplicatedStorage.Remotes:WaitForChild("DailyReward")
local rebirth_event = ReplicatedStorage.Remotes:WaitForChild("Rebirth")

--// script
local main = w:CreateTab("Main",true,Icons.Automatic,Vector2.new(0,0), Vector2.new(0,0))
local misc = w:CreateTab("Misc",true,Icons.Folder,Vector2.new(0,0), Vector2.new(0,0))

local auto = main:CreateSection("Automation")
local other = misc:CreateSection("Others")


getgenv().Setting = {
    auto_mine = false,
    auto_upgrade = false,
    auto_Rebirth = false,
    auto_bonus = false,
}
local s = getgenv().Setting
auto:CreateToggle("Auto mine",false,Color3.new(0.2,.5,1),.25,function(x)
    s.auto_mine = x;
    if x then
        automine()
    end
end)
function automine()
    spawn(function()
        while wait(.1) do
            if s.auto_mine ~= true then break; end
            local tools = getTools()
            InvokeServer(mine_function,nil)
            if tools ~= nil then
                tools:Activate()
            else
                if LocalPlayer.Backpack:FindFirstChildOfClass("Tool") then LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChildOfClass("Tool")) end
            end
        end
    end)
end

auto:CreateToggle("Auto rebirth",false,Color3.new(.2,.5,1),.25,function(x)
    s.auto_Rebirth = x;
    if x then
        autorebirth()
    end
end)
function autorebirth()
    spawn(function()
        while wait(.5) do
            if s.auto_Rebirth ~= true then break; end
            FireServer(rebirth_event,nil)
        end
    end)
end

auto:CreateToggle("Auto bonus",false,Color3.new(.2,.5,1),.25,function(x)
    s.auto_bonus = x;
    if x then
        autobonus()
    end
end)
function autobonus()
    spawn(function()
        while wait(.5) do
            if s.auto_bonus ~= true then break; end
            InvokeServer(bonus_function,nil)
        end
    end)
end

other:CreateButton("Claim daily",function()
    InvokeServer(daily_function,{"Coin"})
end)

other:CreateLabel("UI")
other:CreateKeybind('Toggle UI', 'RightControl', function()
    Library:ToggleUI()
end)
other:CreateButton("Destory UI",function()
    Library:DestroyUI()
end)

other:CreateLabel("Credit")
other:CreateParagraph("Scripting","Ghost-Ducky#7698")
other:CreateParagraph("UI","Visual ui library")

--// function
function getTools()
    if LocalPlayer.Character then
        local tools = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tools then
            return tools
        end
    end
    return nil
end

function FireServer(remote,...)
    if remote and remote:IsA("RemoteEvent") and type(...) == "table" then
        local args = ...
        remote:FireServer(unpack(args))
    end
    if (...) == nil and remote and remote:IsA("RemoteEvent") then
        remote:FireServer()
    end
end
function InvokeServer(remote,...)
    if remote and remote:IsA("RemoteFunction") and type(...) == "table" then
        local args = ...
        remote:InvokeServer(unpack(args))
    end
    if (...) == nil and remote and remote:IsA("RemoteFunction") then
        remote:InvokeServer()
    end
end

--// setup
Make_notify("Notif","Toggle ui is Rightcontrol",10)
