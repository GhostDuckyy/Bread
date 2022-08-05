--// Wating game loaded
while true do
    if game:IsLoaded() then
        break;
    end
    wait(.005)
end

--// uwuware ui Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/uwuware/source.lua",true))()
local w = Library:CreateWindow("Bread")

--// Notif ui
local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
local Notify = AkaliNotif.Notify;

--// Service
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Attack_Remote = ReplicatedStorage:WaitForChild('Sonsho');
local Rebirt_Remote = ReplicatedStorage:WaitForChild('Daigo');

--// Setting
local Building_list = {
    "tower",
    "tree",
    "ttower",
    "apartments",
    "store",
    "house",
    "casino",
    "stower",
    "school",
    "station",
    "supermarket",
    "gasstation",
    "car",
    "hay",
    "silo",
    "bench",
    "barn",
    "stoplight",
    "oilrig",
}
getgenv().AutoFarm = false; getgenv().Selected_Building = nil;
getgenv().AutoRebirth = false; getgenv().Rebirth_Value = 10;
getgenv().noclip = false;

--// Script
local main = w:AddFolder("Main")
local chr = w:AddFolder("Character")
local misc = w:AddFolder("Misc")

main:AddList({
    text = "Building",
    value = "none",
    values = Building_list,
    callback = function(x)
        getgenv().Selected_Building = x;
    end
})
main:AddToggle({
    text = "Auto farm",
    state = false,
    callback = function(x)
        getgenv().AutoFarm = x;
        if x then
            farm_building()
        end
    end
})

function farm_building()
    spawn(function()
        while true do
            if getgenv().AutoFarm ~= true then getgenv().noclip = false; break; end
            if getgenv().AutoFarm then
                if getgenv().Selected_Building ~= nil then
                    if Character then
                        local building = nil;
                        while wait(.1) do
                            building = get_Building()
                            if building ~= nil then break; end
                        end
                        while true do
                            if tostring(building["Stage"].Value):lower() == "dead" then building["Main"].Transparency = 1 break; end
                            if getgenv().AutoFarm ~= true then getgenv().noclip = false; building["Main"].Transparency = 1 break; end
                            if getgenv().noclip ~= true then getgenv().noclip = true; end
                            building["Main"].Transparency = .5;
                            building["Main"].Size = Vector3.new(15,15,15)
                            if building["Main"].CanCollide == true then building["Main"].CanCollide = false end
                            Character.HumanoidRootPart.CFrame = building["Main"].CFrame;
                            Attack_Remote:FireServer(building["Main"])
                            wait(.05)
                        end
                    end
                else
                    Make_notify("Error","Select an building",10)
                    while true do
                        if getgenv().AutoFarm ~= true then break; end
                        if getgenv().Selected_Building ~= nil then break; end
                        wait(.1)
                    end
                end
            end
            wait(1.5)
        end
    end)
end

function get_Building()
    if workspace:FindFirstChild("Interactables") then
        for i,v in ipairs(workspace["Interactables"]:GetChildren()) do
            if v:IsA("Model") then
                if string.match(tostring(v.Name):lower(),tostring(getgenv().Selected_Building):lower()) then
                    if v:FindFirstChild("Stage") and tostring(v["Stage"].Value):lower() ~= "dead" then
                        if v:FindFirstChild("Main") then
                            return v
                        end
                    end
                end
            end
        end
    end
    return nil
end

main:AddSlider({
    text = "Rebirth target",
    value = 10,
    min = 10,
    max = 100,
    callback = function(x)
        getgenv().Rebirth_Value = x;
    end
})
main:AddToggle({
    text = "Auto rebirth",
    state = false,
    callback = function(x)
        getgenv().AutoRebirth = x;
        if x then
            auto_Rebirth()
        end
    end
})

function auto_Rebirth()
    spawn(function()
        while true do
            if getgenv().AutoRebirth ~= true then break; end
            if getgenv().AutoRebirth then
                local size = nil;
                size = get_Size();
                if size ~= nil then
                    if size.Value > getgenv().Rebirth_Value or size.Value == getgenv().Rebirth_Value then
                        Rebirt_Remote:FireServer()
                    end
                end
            end
            wait(.1)
        end
    end)
end

function get_Size()
    if ReplicatedStorage:FindFirstChild("DataBag") then
        for i,v in ipairs(ReplicatedStorage["DataBag"]:GetChildren()) do
            if v:IsA("Folder") and tostring(v.Name):lower() == tostring(LocalPlayer.Name):lower() then
                for _,x in ipairs(v:GetChildren()) do
                    if x:IsA("NumberValue") and tostring(x.Name):lower() == "size" then
                        return x
                    end
                end
            end
        end
    end
    return nil
end

getgenv().WS = 16;getgenv().JP = 50;
chr:AddSlider({
    text = "Walk speed",
    value = 16,
    min = 0,
    max = 500,
    callback = function(x)
        getgenv().WS = x;
    end
})
chr:AddSlider({
    text = "Jump height",
    value = 50,
    min = 0,
    max = 500,
    callback = function(x)
        getgenv().JP = x;
    end
})
RunService.RenderStepped:Connect(function()
    if Character then
        if Character:FindFirstChild("Humanoid") then
            pcall(function()
                Character.Humanoid.WalkSpeed = tonumber(getgenv().WS);
                Character.Humanoid.JumpPower = tonumber(getgenv().JP);
                if Character.Humanoid.UseJumpPower ~= true then Character.Humanoid.UseJumpPower = true end
            end)
        end
    end
end)

misc:AddBind({
    text = "Toggle UI",
    key = Enum.KeyCode.RightControl,
    callback = function()
        Library:Close()
    end
})

--// Bypass basic anti-cheat
do
    local get_rawmt = getrawmetatable(game)
    local old_index = get_rawmt.__index;
    setreadonly(get_rawmt, false)
    get_rawmt.__index = newcclosure(function(self,value)
        if tostring(value):lower() == "walkspeed" then
            return 16
        end
        if tostring(value):lower() == "jumppower" then
            return 50
        end
        return old_index(self,value)
    end)
    setreadonly(get_rawmt, true)
end

--// Noclip
RunService.Stepped:Connect(function()
    if getgenv().noclip then
        if Character then
            if Character:FindFirstChild("HumanoidRootPart") then
                Character["HumanoidRootPart"].CanCollide = false;
            end
            if Character:FindFirstChild("LowerTorso") then
                Character["LowerTorso"].CanCollide = false;
            end
            if Character:FindFirstChild("UpperTorso") then
                Character["UpperTorso"].CanCollide = false;
            end
        end
    end
end)

--// Notif function
function Make_notify(title,desc,time)
    if title ~= nil then
        Notify({
            Title = title,
            Description = desc,
            Duration = time or 5
        })
    else
        Notify({
            Description = desc,
            Duration = time or 5
        })
    end
end
--// Init
local screengui = Library:Init()
while true do
    if screengui then
        screengui.Name = game:GetService("HttpService"):GenerateGUID(false)
    end
    wait(.5)
end
