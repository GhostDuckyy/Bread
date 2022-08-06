--// Waiting game loaded
while true do
    if game:IsLoaded() then
        break;
    end
    wait(.005)
end

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/uwuware/source.lua",true))()
local w = Library:CreateWindow("Bread")

--// Service
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Click_remote = game:GetService("ReplicatedStorage").Events:FindFirstChild("Click3")
--// Setting
getgenv().Setting = {
    Auto_click = false,
    Teleports = {
        Selected = nil,
        Islands = {},
    },
}


--// Script
local main = w:AddFolder("Main")
local tp = w:AddFolder("Teleport")
local misc = w:AddFolder("Misc")

main:AddToggle({text = "Auto click",state = false,callback = function(x)
    getgenv().Setting.Auto_click = x;
    if x then
        Auto_click()
    end
end})

function Auto_click()
    spawn(function()
        while wait(.01) do
            if getgenv().Setting.Auto_click ~= true then break; end
            if Click_remote then
                Click_remote:FireServer()
            end
        end
    end)
end

main:AddButton({text = "Best world boost",callback = function()
    local World_Boost = game:GetService("ReplicatedStorage").Events:FindFirstChild("WorldBoost")
    local Stored_World_Boost = game:GetService("ReplicatedStorage").Events:FindFirstChild("StoreWorldBoost")
    if World_Boost and Stored_World_Boost then
        World_Boost:FireServer("Neon")
        Stored_World_Boost:FireServer("Neon")
    end
end})

main:AddButton({text = "Unlock all gamepases", function()
    if LocalPlayer:FindFirstChild("Passes") then
        for i,v in ipairs(LocalPlayer["Passes"]:GetChildren()) do
            if v:IsA("BoolValue") then
                if v.Value ~= true then
                    v.Value = true
                end
            end
        end
    end
end})

main:AddButton({text = "Unlock all portal",callback = function()
    local path = game:GetService("Workspace").Scripts.Portals
    for i,v in ipairs(path:GetDescendants()) do
        if v:IsA("Model") then
            if v:FindFirstChild("Unlocked") and v["Unlocked"].Value ~= true then
                if v:FindFirstChild("LabelUI") then
                    v:FindFirstChild("LabelUI"):Destroy()
                end
                v["Unlocked"].Value = true
            end
        end
        if v:IsA("Part") and tostring(v.Name):lower() == "volcano" then
            v:Destroy()
        end
    end
end})

if workspace:WaitForChild("Scripts") and workspace["Scripts"]:WaitForChild("TeleportTo") then
    for i,v in ipairs(workspace.Scripts.TeleportTo:GetChildren()) do
        if v:IsA("Part") then
            if not table.find(getgenv().Setting.Teleports.Islands,tostring(v.Name)) then
                table.insert(getgenv().Setting.Teleports.Islands, tostring(v.Name))
            end
        end
    end
    tp:AddList({
        text = "Selected",
        value = nil,
        values = getgenv().Setting.Teleports.Islands,
        callback = function(x)
            getgenv().Setting.Teleports.Selected = x;
        end
    })
    tp:AddButton({
        text = "Teleport",
        callback = function()
            if getgenv().Setting.Teleports.Selected ~= nil then
                if Character then
                    if workspace:WaitForChild("Scripts") and workspace["Scripts"]:WaitForChild("TeleportTo") then
                        local World_Boost = game:GetService("ReplicatedStorage").Events:FindFirstChild("WorldBoost")
                        local Stored_World_Boost = game:GetService("ReplicatedStorage").Events:FindFirstChild("StoreWorldBoost")
                        for i,v in ipairs(workspace.Scripts.TeleportTo:GetChildren()) do
                            if tostring(v.Name):lower() == tostring(getgenv().Setting.Teleports.Selected):lower() and v:IsA("Part") then
                                local cf = v.CFrame * CFrame.new(0,.5,0)
                                Character.HumanoidRootPart.CFrame = cf
                                wait(.1)
                                if World_Boost and Stored_World_Boost then
                                    World_Boost:FireServer(tostring(v.Name))
                                    Stored_World_Boost:FireServer(tostring(v.Name))
                                end
                            end
                        end
                    end
                end
            end
        end
    })
end

misc:AddBind({
    text = "Toggle UI",
    key = Enum.KeyCode.RightControl,
    callback = function()
        Library:Close()
    end
})

--// Init
local screengui = Library:Init()
while true do
    if screengui then
        screengui.Name = HttpService:GenerateGUID(false)
    end
    wait(.5)
end