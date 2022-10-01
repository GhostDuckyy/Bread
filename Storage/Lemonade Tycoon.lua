while task.wait() do
    if game:IsLoaded() then break; end
end

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Taurus/main/UI/Elerium%20V2.lua"))()
local Window,Unknown = Library:AddWindow("Taurus",{
    main_color = Color3.fromRGB(30, 65, 175),
    min_size = Vector2.new(550, 450),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = false,
})

--// Service
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// Remote
local Harvest_event = game:GetService("ReplicatedStorage").Events.Remotes.Harvest

--// Script
getgenv().Setting = {
    Harvest = false,
}

local main = Window:AddTab("Main")
local misc = Window:AddTab("Misc")

local ownTycoon = nil
local Tree = {}

while task.wait(.5) do
    if ownTycoon == nil then
        for i,v in ipairs(workspace.Tycoons:GetDescendants()) do
            if v.Parent and v.Parent:IsA("Folder") and tostring(v.Parent.Name):lower():find("tycoon") and v:IsA("ObjectValue") then
                if v.Value == LocalPlayer then ownTycoon = v.Parent end
            end
        end
    else
        break;
    end
end

main:AddSwitch("Auto Harvest", function(x)
    Setting.Harvest = x
    if x then
        Harvest()
    end
end)

--// Function
for i,v in ipairs(ownTycoon.Purchases:GetChildren()) do
    if v:IsA("Model") and tostring(v.Name):lower():find("tree") then
        if not table.find(Tree,v.Name) then
            table.insert(Tree,v.Name)
        end
    end
end

ownTycoon.Purchases.ChildAdded:Connect(function(v)
    if v:IsA("Model") and tostring(v.Name):lower():find("tree") then
        if not table.find(Tree,v.Name) then
            table.insert(Tree,v.Name)
        end
    end
end)

function Harvest()
    spawn(function()
        while Setting.Harvest == true do
            for i,v in next, Tree do
                Harvest_event:FireServer(ownTycoon.Purchases[v])
            end
            task.wait(.1)
        end
    end)
end