--// Wait game loaded
while true do
    if game:IsLoaded() then break; end
    wait(.005)
end

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Design/Libraries/main/Revenant.lua", true))()
local Flags = Library.Flags
Library.DefaultColor =Color3.fromHex("#FF3131");

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

--// event
local Tap_event = ReplicatedStorage["Events"]:WaitForChild("Tap")
local Rebirth_event = ReplicatedStorage["Events"]:WaitForChild("Rebirth")
local TP_event = ReplicatedStorage["Events"]:WaitForChild("Teleport")
local Hatch_event = ReplicatedStorage["Events"]:WaitForChild("HatchEgg")
local Remove_pets_event = ReplicatedStorage["Events"]:WaitForChild("RemovePet")
local Claim_Achievements_event = ReplicatedStorage["Events"]:WaitForChild("ClaimRankReward")

--// module
local Data_module = require(ReplicatedStorage["Classes"]:WaitForChild("Player")).players
function getData(target)
    if target ~= nil then
        for i,v in next, (Data_module) do
            if i == target then
                return v.data
            end
        end
    end
    return nil
end
local Self_data = getData(LocalPlayer);

--// Setting
getgenv().Setting = {
    whitescreen = false,
    Auto_Tap = false,
    EquipBest = false,
    Auto_Claim_Achievement = false,
    Rebirth = {
        bool = false,
        value = nil,
    },
    Eggs = {
        List = {},
        Type = nil,
        Hatch = false,
        value = 1,
    },
}


--// Script
local main = Library:Window({Text = "Bread"})
local plrs = Library:Window({Text = "Players"})
local pets = Library:Window({Text = "Pets"})
local tp = Library:Window({Text = "Teleport"})
local misc = Library:Window({Text = "Misc"})

plrs:Label({Text = "Character", Color = Color3.new(1,1,1)})
getgenv().WS = 16;getgenv().JP = 50;
plrs:Slider({Text = "Walk speed",Flag = false,Postfix = " value",Default = 16,Minimum = 0,Maximum = 500,Callback = function(x)
    getgenv().WS = tonumber(x);
end})
plrs:Slider({Text = "Jump height",Flag = false,Postfix = " value",Default = 50,Minimum = 0,Maximum = 500,Callback = function(x)
    getgenv().JP = tonumber(x);
end})
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local chr = LocalPlayer.Character
        if chr:FindFirstChild("Humanoid") then
            chr["Humanoid"].WalkSpeed = getgenv().WS;
            chr["Humanoid"].JumpPower = getgenv().JP;
            if chr["Humanoid"].UseJumpPower ~= true then chr["Humanoid"].UseJumpPower = true end
        end
    end
end)
plrs:Button({Text = "Infinite double jumps",Callback = function()
    if Self_data then
        Self_data.jumps = math.huge;
    else
        Self_data = getData(LocalPlayer);
    end
end})

local table_plr = {}
local target_plr = nil;
table.clear(table_plr)
for i,v in ipairs(Players:GetPlayers()) do
    if v.DisplayName then
        if not table.find(table_plr,tostring(v.DisplayName)) then
            table.insert(table_plr,tostring(v.DisplayName))
        end
    else
        if not table.find(table_plr,tostring(v.Name)) then
            table.insert(table_plr,tostring(v.Name))
        end
    end
end
--[[
    Players.PlayerAdded:Connect(function(v)
    if v.DisplayName then
        if not table.find(table_plr,tostring(v.DisplayName)) then
            table.insert(table_plr,tostring(v.DisplayName))
        end
    else
        if not table.find(table_plr,tostring(v.Name)) then
            table.insert(table_plr,tostring(v.Name))
        end
    end
end)
Players.PlayerRemoving:Connect(function(v)
    if table.find(table_plr,tostring(v.DisplayName)) then
        table.remove(table_plr,table.find(table_plr,tostring(v.DisplayName)))
    elseif table.find(table_plr,tostring(v.Name)) then
        table.remove(table_plr,table.find(table_plr,tostring(v.Name)))
    end
end)
]]
plrs:Label({Text = "Other players",Color = Color3.new(1,1,1)})
plrs:Dropdown({Text = "Select a players",List = table_plr,Callback = function(x)
    target_plr = tostring(x);
end})
plrs:Button({Text = "Teleport to players",Callback = function()
    local p = nil;
    for i,v in ipairs(Players:GetPlayers()) do
        if tostring(v.DisplayName) == target_plr or tostring(v.Name) == target_plr then
            p = v;
        end
    end
    if LocalPlayer.Character and p.Character then
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local cf = hrp.CFrame * CFrame.new(0,0,-3)
            Teleport(cf)
        end
    end
end})


if firesignal then
    pets:Toggle({Text = "Equip best pets",Flag = nil,Callback = function(x)
        getgenv().Setting.EquipBest  = x;
        if x then
            Equip_Best()
        end
    end})
    function Equip_Best()
        spawn(function()
            while wait(.5) do
                if getgenv().Setting.EquipBest ~= true then break; end
                if LocalPlayer.PlayerGui:FindFirstChild("UI") and LocalPlayer.PlayerGui["UI"]:FindFirstChild("Inventory") then
                    local path = LocalPlayer.PlayerGui["UI"]["Inventory"]["Buttons"]:FindFirstChild("Equip")
                    pcall(function()
                        if path then
                            firesignal(path.Activated)
                        end
                    end)
                end
            end
        end)
    end
end
for i,v in pairs(workspace["Shops"]:GetChildren()) do
    if v:IsA("Model") then
        if not table.find(getgenv().Setting.Eggs.List,tostring(v.Name)) then
            table.insert(getgenv().Setting.Eggs.List,tostring(v.Name))
        end
    end
end
pets:Dropdown({Text = "Select Egg",List = getgenv().Setting.Eggs.List,Callback = function(x)
    getgenv().Setting.Eggs.Type = x;
end})
pets:Toggle({Text = "Auto hatch",Flag = nil,Callback = function(x)
    getgenv().Setting.Eggs.Hatch = x;
    if x then
        Auto_hatch()
    end
end})
pets:Toggle({Text = "Triple hatch",Flag = nil,Callback = function(x)
    if x then
        getgenv().Setting.Eggs.value = 3
    else
        getgenv().Setting.Eggs.value = 1
    end
end})
function Auto_hatch()
    spawn(function()
        while wait(.1) do
            if getgenv().Setting.Eggs.Hatch ~= true then break; end
            if Hatch_event then
                if getgenv().Setting.Eggs.Type ~= nil then
                    local tables = {}
                    local egg = tostring(getgenv().Setting.Eggs.Type)
                    local number = tonumber(getgenv().Setting.Eggs.value)
                    Hatch_event:InvokeServer(tables,egg,number)
                else
                    make_notif("Select egg to hatch",nil,Color3.new(1,0.3,0))
                    while wait(.1) do
                        if getgenv().Setting.Eggs.Hatch ~= true then break; end
                        if getgenv().Setting.Eggs.Type ~= nil then break; end
                    end
                end
            end
        end
    end)
end

main:Label({Text = "Main", Color = Color3.new(1,1,1)})
main:Toggle({Text = "Auto tap",Flag = nil,Callback = function(x)
    getgenv().Setting.Auto_Tap = x;
    if x then
        Tap()
    end
end})
function Tap()
    spawn(function()
        while wait(.1) do
            if getgenv().Setting.Auto_Tap ~= true then break; end
            if Tap_event then
                Tap_event:FireServer()
            end
        end
    end)
end
do
    local rebirth_table = {}
    local auto_Rebirth = getgenv().Setting.Rebirth
    if Self_data then
        for i,v in ipairs(Self_data.rebirthButtons) do
            if not table.find(rebirth_table,v) then
                table.insert(rebirth_table,v)
            end
        end
        main:Dropdown({Text = "Rebirth list",List = rebirth_table,Callback = function(x)
            auto_Rebirth.value = x;
        end})
        main:Toggle({Text = "Auto rebirth",Flag = nil,Callback = function(x)
            auto_Rebirth.bool = x;
            if x then
                Rebirth()
            end
        end})
    else
        Self_data(LocalPlayer)
    end
    function Rebirth()
        spawn(function()
            while wait(.1) do
                if auto_Rebirth.bool ~= true then break; end
                if auto_Rebirth.value ~= nil then
                    if Rebirth_event then
                        Rebirth_event:FireServer(tonumber(auto_Rebirth.value))
                    end
                else
                    make_notif("Select a target for rebirth",10)
                    while wait(.1) do
                        if auto_Rebirth.bool ~= true then break; end
                        if auto_Rebirth.value ~= nil then break; end
                    end
                end
            end
        end)
    end
end

main:Toggle({Text = "Auto clam achievements",Flag = nil,Callback = function(x)
    getgenv().Setting.Auto_Claim_Achievement = x;
    if x then
        spawn(function()
            while wait(.1) do
                if getgenv().Setting.Auto_Claim_Achievement ~= true then break; end
                if Claim_Achievements_event then
                    Claim_Achievements_event:FireServer()
                end
            end
        end)
    end
end})

main:Toggle({Text = "White screen",Flag = nil,Callback = function(x)
    getgenv().Setting.whitescreen = x;
end})
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    if getgenv().Setting.whitescreen then
        RunService:Set3dRenderingEnabled(false);
    end
end)
game:GetService("UserInputService").WindowFocused:Connect(function()
    if getgenv().Setting.whitescreen then
        RunService:Set3dRenderingEnabled(true);
    end
end)

local Teleport_List = {
    [1] = {Name = "Spawn",pos = CFrame.new(-74.69972229003906, 16.553403854370117, -476.1826477050781)},
    [2] = {Name = "Forest island",pos = CFrame.new(-163.98446655273438, 977.2182006835938, -403.33941650390625)},
    [3] = {Name = "Flower island",pos = CFrame.new(-179.51564025878906, 1514.4530029296875, -682.4987182617188)},
    [4] = {Name = "Swamp island",pos = CFrame.new(-264.35888671875, 2113.3935546875, -694.6613159179688)},
    [5] = {Name = "Snow island",pos = CFrame.new(-201.77197265625, 2934.2529296875, -470.40875244140625)},
    [6] = {Name = "Desert island",pos = CFrame.new(-166.28515625, 4225.35107421875, -779.1531372070312)},
    [7] = {Name = "Death island",pos = CFrame.new(-276.2012634277344, 5415.24609375, -480.28778076171875)},
    [8] = {Name = "Beach island",pos = CFrame.new(-140.3450927734375, 6872.287109375, -495.68212890625)},
    [9] = {Name = "Mines island",pos = CFrame.new(-243.2586669921875, 8365.88671875, -483.8897705078125)},
    [10] = {Name = "Cloud island",pos = CFrame.new(-253.30348205566406, 11250.62890625, -237.8885955810547)},
    [11] = {Name = "Coral island",pos = CFrame.new(-511.0211181640625, 13801.7646484375, -543.2418212890625)},
    [12] = {Name = "Darkheart island",pos = CFrame.new(-408.697509765625, 17169.822265625, -552.0464477539062)},
    [13] = {Name = "Flamelands world",pos = CFrame.new(1152.3616943359375, 148.96311950683594, -2859.748046875)},
    [14] = {Name = "Molten island",pos = CFrame.new(1280.5958251953125, 2183.499267578125, -2885.144287109375)},
    [15] = {Name = "Blue Magma island",pos = CFrame.new(1401.12939453125, 5230.490234375, -2953.919677734375)},
    [16] = {Name = "Purple Magma island",pos = CFrame.new(1319.7027587890625, 7651.8984375, -2958.0576171875)},
    [17] = {Name = "Yellow Magma island", pos = CFrame.new(1403.5440673828125, 10391.9912109375, -2903.138427734375)},
    [18] = {Name = "Red Magma island",pos = CFrame.new(1426.2127685546875, 13344.337890625, -2900.90087890625)}
}

for i,v in ipairs(Teleport_List) do
    if v.Name and v.pos then
        local name = v.Name
        local cf = v.pos
        tp:Button({Text = tostring(name),Callback = function()
            Teleport(cf)
        end})
    end
end

misc:Button({Text = "Unlock all portals",Callback = function()
    if Self_data then
        local list = {"Mine","Coral","Beach","Forest","Magma","Swamp","Snow","Desert","Death","Flower","Darkheart","Dominus","Cloud","Molten","Blue Magma","Purple Magma","Yellow Magma","Red Magma"}
        local portals_Table = nil;
        for i,v in next, (Self_data) do
            if tostring(i):lower() == tostring("unlockedPortals"):lower() then
                if type(v) == "table" then
                    portals_Table = v;
                end
            end
        end

        if portals_Table ~= nil and type(portals_Table) == "table" then
            for _,world in next, (list) do
                if not table.find(portals_Table,tostring(world)) then
                    table.insert(portals_Table,tostring(world))
                end
            end
            make_notif("You can purchase portal without coins",10,Color3.new(0.5,1,0))
        end
    else
        Self_data = getData(LocalPlayer)
    end
end})

misc:Keybind({
    Text = "Toggle UI",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        Library:Toggle()
    end
})
misc:Prompt({
    Text = "Copy discord invite",
    OnConfirm = function(x)
        make_notif("Copied invite link",10,Color3.new(0.1,0.9,0))
        setclipboard("https://discord.gg/TFUeFEESVv")
    end
})

misc:Label({Text = "Ui: Revenant UI Library",Color = Color3.new(0.1,0.9,0)})
misc:Label({Text = "Scripting: Ghost-Ducky#7698",Color = Color3.new(0.1,0.9,0)})

--// Spoof walkspeed & jumppower
local completed,errors = pcall(function()
    local raw = getrawmetatable(game)
    local old_index = raw.__index
    local spoof_walkspeed = 16
    local spoof_jumppower = 50
    setreadonly(raw, false)
    raw.__index = newcclosure(function(self,value)
        if tostring(value):lower() == "walkspeed" then
            return spoof_walkspeed
        end
        if tostring(value):lower() == "jumppower" then
            return spoof_jumppower
        end
        return old_index(self,value)
    end)
    setreadonly(raw, true)
end)
do
    if completed then
        print("Success spoof walkspeed & jumppower")
    end
    if errors then
        print("Failed spoof walkspeed & jumppower")
    end
end

--// Teleport function
function Teleport(arg)
    local value = arg;
    if TP_event then
        if typeof(value) == "CFrame" then
            TP_event:FireServer(value)
        elseif typeof(value) == "Instance" then
            TP_event:FireServer(value.CFrame)
        end
    end
end

--// Notify function
function make_notif(msg,time,color)
    Library:Notification({
        Text = tostring(msg) or "nil",
        Duration = tonumber(time) or 5,
        Color = color or Color3.fromRGB(65, 143, 232),
    })
end

--// setup
make_notif("Right control to toggle ui",10,nil)