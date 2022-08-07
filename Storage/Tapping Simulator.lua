--// Wait game loaded
while true do
    if game:IsLoaded() then break; end
    wait(.005)
end

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Design/Libraries/main/Revenant.lua", true))()
local Flags = Library.Flags
Library.DefaultColor =Color3.fromRGB(65, 143, 232);

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
    AFK = false,
    Auto_Tap = false,
    Rebirth = {
        bool = false,
        value = nil,
    },
    Pets = {
        EquipBest = false,
    }
}


--// Script
local main = Library:Window({Text = "Bread"})
local tp = Library:Window({Text = "Teleport"})
local misc = Library:Window({Text = "Misc"})

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

main:Toggle({Text = "White screen",Flag = nil,Callback = function(x)
    getgenv().Setting.AFK = x;
end})
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    if getgenv().Setting.AFK then
        RunService:Set3dRenderingEnabled(false);
    end
end)
game:GetService("UserInputService").WindowFocused:Connect(function()
    if getgenv().Setting.AFK then
        RunService:Set3dRenderingEnabled(true);
    end
end)

main:Label({Text = "Character", Color = Color3.new(1,1,1)})
getgenv().WS = 16;getgenv().JP = 50;
main:Slider({Text = "Walk speed",Flag = false,Postfix = " value",Default = 16,Minimum = 0,Maximum = 500,Callback = function(x)
    getgenv().WS = tonumber(x);
end})
main:Slider({Text = "Jump power",Flag = false,Postfix = " value",Default = 50,Minimum = 0,Maximum = 500,Callback = function(x)
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
main:Button({Text = "Infinite double jumps",Callback = function()
    if Self_data then
        Self_data.jumps = 999e9;
    else
        Self_data = getData(LocalPlayer);
    end
end})

misc:Button({Text = "Unlock all portals",Callback = function()
    if Self_data then
        local list = {"Mine","Coral","Beach","Forest","Magma","Swamp","Snow","Desert","Death","Flower","Darkheart","Dominus","Cloud","Molten","Blue Magma","Purple Magma",}
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

misc:Button({Text = "Inf world boost (visual)",Callback = function()
    for i,v in next, getgc(false) do
        if type(v) == "function" and not isexecutorclosure(v) then
            if tostring(debug.getinfo(v).name):lower() == tostring("updateZoneMultiplier"):lower() then
                wait(.5)
                v("Hacked by Bread","Imagine if real",math.huge)
            end
        end
    end
end})

misc:Keybind({Text = "Toggle UI",Default = Enum.KeyCode.RightControl,Callback = function()
    Library:Toggle()
end})
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