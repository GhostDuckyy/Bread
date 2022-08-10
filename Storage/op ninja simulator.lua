--// Wait game loaded
while true do
    if game:IsLoaded() then break; end
    wait(.005)
end

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/Kavo/source.lua"))()
local w = Library.CreateLib("Bread🍞","BloodTheme")

--// Service
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = game:GetService("Workspace").CurrentCamera

local TweenService = game:GetService("TweenService")

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
--local PathfindingService = game:GetService("PathfindingService")

--// Setting
getgenv().Setting = {
    Auto_swing = false,
    whitescreen = false,
    WS = 16,
    JP = 50,
    Gravity = 196.2,
}
getgenv().Hitbox = {
    Enabled = false,
    Size = 3,
    Transparency = 0.5,
    Color = Color3.new(1,1,1)
}
getgenv().Charms = {
    Enabled = false,
    Teamcolor = false,
    color = Color3.new(1,1,1),
    outline = Color3.new(0,0,0)
}

--// Safe part
local no_part,yes_part = pcall(function()
    assert(not getgenv().Safe_part,"Already has safe part")
    getgenv().Safe_part = true;
    getgenv().Part = Instance.new("Part",game:GetService("Workspace"))
    getgenv().Part.Anchored = true
    getgenv().Part.Size = Vector3.new(150,1,150)
    local random = math.random(5000,500)
    local cf = CFrame.new(9999,9999,9999) + CFrame.new(random,random,random)
    getgenv().Part.CFrame = cf
    getgenv().Part.Material = Enum.Material.ForceField

    RunService.RenderStepped:Connect(function()
        getgenv().Part.Name = HttpService:GenerateGUID(false)
        getgenv().Part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end)
end)

if no_part and not yes_part then
    print("Client created safe part")
end
if yes_part then
    print("Client has safe part already")
end

--// Script
local main = w:NewTab("Main")
local plrs = w:NewTab("Players")
local visual = w:NewTab("Visual")
local misc = w:NewTab("Misc")

local auto = main:NewSection("Automation")
local _Client = plrs:NewSection("Client")
local other_plr = plrs:NewSection("Other players")
local _visual = visual:NewSection("Visual")
local other = misc:NewSection("Other")
local credit = misc:NewSection("Credit")

auto:NewToggle("Auto swing katana","Auto equip&swing katana",function(x)
    getgenv().Setting.Auto_swing = x;
    if x then
        spawn(function()
            while wait(.1) do
                if getgenv().Setting.Auto_swing ~= true then break; end
                if LocalPlayer.Character then
                    local Humanoid = LocalPlayer.Character.Humanoid
                    local ktn = get_Katana()
                    if ktn ~= nil then
                        if ktn.Parent == LocalPlayer.Character then
                            ktn:Activate()
                        elseif ktn.Parent == LocalPlayer.Backpack then
                            Humanoid:EquipTool(ktn)
                        end
                    end
                end
            end
        end)
    end
end)
function get_Katana()
    for i,v in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name ~= "Shuriken" and v.Name ~= "InvisibilityTool" and v.Name ~= "ShadowCloneTool" and v.Name ~= "TeleportTool" then
            return v
        end
    end
    for i,v in ipairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") then
            if v.Name ~= "Shuriken" and v.Name ~= "InvisibilityTool" and v.Name ~= "ShadowCloneTool" and v.Name ~= "TeleportTool" then
                return v
            end
        end
    end
    return nil
end

auto:NewButton("Teleport to a safe place","Tween/Teleport to a safe place",function()
    if LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local cf = getgenv().Part.CFrame * CFrame.new(0,1,0)
            hrp.CFrame = cf
            -- FastTween(hrp,{CFrame = cf},{15})
        end
    end
end)

if firesignal then
    getgenv().upgrade = {
        [1] = {name = "sword",bool = false},
        [2] = {name = "shuriken",bool = false},
        [3] = {name = "class",bool = false},
        [4] = {name = "realm",bool = false},
    }
    auto:NewLabel("Auto upgrade")
    for i,v in pairs(getgenv().upgrade) do
        auto:NewToggle(tostring(v.name),tostring("Auto upgrade "..v.name),function(x)
            v.bool = x;
        end)
    end
    spawn(function()
        while wait(.35) do
            if LocalPlayer.PlayerGui.MainGui:FindFirstChild("UpgradeF") then
                local path = LocalPlayer.PlayerGui.MainGui:FindFirstChild("UpgradeF")

                local sword = path["SwordF"]:FindFirstChild("SwordImgBtn")
                local shuriken = path["ShurikenF"]:FindFirstChild("ShurikenImgBtn")
                local class = path["ClassF"]:FindFirstChild("ClassImgBtn")
                local realm = path["AscendF"]:FindFirstChild("AscendImgBtn")

                for i,v in next, getgenv().upgrade do
                    if i == 1 then
                        if sword and v.bool then
                            firesignal(sword.MouseButton1Down)
                        end
                    end
                    if i == 2 then
                        if shuriken and v.bool then
                            firesignal(shuriken.MouseButton1Down)
                        end
                    end
                    if i == 3 then
                        if class and v.bool then
                            firesignal(class.MouseButton1Down)
                        end
                    end
                    if i == 4 then
                        if realm and v.bool then
                            firesignal(realm.MouseButton1Down)
                        end
                    end
                end
            end
        end
    end)
end

auto:NewLabel("Hitbox expander")
auto:NewToggle("Enabled/Disable","none desc",function(x)
    getgenv().Hitbox.Enabled = x;
end)
auto:NewSlider("Size","Set hithox size",150,3,function(x)
    getgenv().Hitbox.Size = tonumber(x);
end)
auto:NewColorPicker("Hitbox colors","Set hitbox colors to selected",getgenv().Hitbox.Color,function(x)
    getgenv().Hitbox.Color = x;
    if x then
        for i,v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                if v.Character then
                    Hitbox_expander(v.Character)
                end
            end
        end
    end
end)

function Hitbox_expander(char)
    if char:FindFirstChild("HumanoidRootPart") then
        local z = Players:GetPlayerFromCharacter(char)
        local RS = RunService.Stepped:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local number = tonumber(getgenv().Hitbox.Size)
            if hrp then
                if getgenv().Hitbox.Enabled == true then
                    hrp.Size = Vector3.new(number,number,number)
                    hrp.Transparency = tonumber(getgenv().Hitbox.Transparency)
                    hrp.Color = getgenv().Hitbox.Color
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(3,3,3)
                    hrp.Transparency = 1
                    hrp.CanCollide = true
                end
            end
        end)
        z.CharacterRemoving:Connect(function()
            RS:Disconnect()
        end)
    end
end

for i,v in ipairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        v.CharacterAdded:Connect(function(char)
            Hitbox_expander(char)
        end)
    end
end
Players.PlayerAdded:Connect(function(v)
    if v.Character then
        Hitbox_expander(v.Character)
    end
    v.CharacterAdded:Connect(function(char)
        Hitbox_expander(char)
    end)
end)


_Client:NewSlider("Walk speed","Change your character walk speed",500,16,function(x)
    getgenv().Setting.WS = tonumber(x);
end)

_Client:NewSlider("Jump height","Change your character jump height",500,50,function(x)
    getgenv().Setting.JP = tonumber(x);
end)
_Client:NewSlider("Jump height","Change your character jump height",196.2,1,function(x)
    getgenv().Setting.Gravity = tonumber(x);
end)

RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = getgenv().Setting.WS
            Humanoid.JumpPower = getgenv().Setting.JP
            if Humanoid.UseJumpPower ~= true then Humanoid.UseJumpPower = true end
        end
        if workspace then
            workspace.Gravity = getgenv().Setting.Gravity
        end
    end
end)

local plr_Table = {}
local Target_plr = nil;
table.clear(plr_Table)
for i,v in ipairs(Players:GetPlayers()) do
    if v.DisplayName then
        if not table.find(plr_Table,tostring(v.DisplayName)) then
            table.insert(plr_Table,tostring(v.DisplayName))
        end
    else
        if not table.find(plr_Table,tostring(v.Name)) then
            table.insert(plr_Table,tostring(v.Name))
        end
    end
end
Players.PlayerAdded:Connect(function(v)
    if v.DisplayName then
        if not table.find(plr_Table,tostring(v.DisplayName)) then
            table.insert(plr_Table,tostring(v.DisplayName))
        end
    else
        if not table.find(plr_Table,tostring(v.Name)) then
            table.insert(plr_Table,tostring(v.Name))
        end
    end
end)
Players.PlayerRemoving:Connect(function(v)
    if table.find(plr_Table,tostring(v.DisplayName)) then
        table.remove(plr_Table,table.find(plr_Table,tostring(v.DisplayName)))
    elseif table.find(plr_Table,tostring(v.Name)) then
        table.remove(plr_Table,table.find(plr_Table,tostring(v.Name)))
    end
end)
function get_plr(name)
    for i,v in ipairs(Players:GetPlayers()) do
        if tostring(v.DisplayName) == tostring(name) or tostring(v.Name) == tostring(name) then
            return v
        end
    end
    return nil
end

local plr_dropdown = other_plr:NewDropdown("Players List","Pick a player in list",plr_Table,function(x)
    Target_plr = tostring(x);
end)
other_plr:NewButton("Refresh List","Refresh the players list",function()
    plr_dropdown:Refresh(plr_Table);
end)
other_plr:NewButton("Teleport to player","Tween/Teleport to behind selected player",function()
    local plr = get_plr(Target_plr)
    if plr ~= nil and plr.Character then
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local cf = hrp.CFrame * CFrame.new(0,0,-.35)
            FastTween(LocalPlayer.Character.HumanoidRootPart,{CFrame = cf},{20})
        end
    end
end)
other_plr:NewToggle("Spectate player","Spectate selected player",function(x)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and CurrentCamera then
        if x then
            local plr = get_plr(Target_plr)
            local char = plr.Character
            local human = char:FindFirstChild("Humanoid")
            if char and human then
                CurrentCamera.CameraSubject = human
            end
        else
            CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end
end)

_visual:NewToggle("Enabled/Disable charms","none desc",function(x)
    getgenv().Charms.Enabled = x;
    if x then
        for i,v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                if v.Character then
                    Players_charms(v.Character)
                end
            end
        end
    end
end)
_visual:NewToggle("Team colors","Set charms colors to team colors",function(x)
    getgenv().Charms.Teamcolor = x;
end)

_visual:NewColorPicker("Main colors","Set charms colors to selected colors",getgenv().Charms.color,function(color)
    getgenv().Charms.color = color;
end)
_visual:NewColorPicker("Outline colors","Set charms outline colors to selected colors",getgenv().Charms.outline,function(color)
    getgenv().Charms.outline = color;
end)


function Players_charms(character)
    if not character:FindFirstChildOfClass("Highlight") then
        local Highlight = Instance.new("Highlight",character)
        Highlight.Name = HttpService:GenerateGUID(false);
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
        local Stepped;
        Stepped = RunService.Stepped:Connect(function()
            local getPlrformChr = Players:GetPlayerFromCharacter(character)
            if Highlight then
                Highlight.Enabled = getgenv().Charms.Enabled;
                Highlight.Name = HttpService:GenerateGUID(false);
                if getgenv().Charms.Teamcolor ~= true then
                    Highlight.FillColor = getgenv().Charms.color;
                    Highlight.OutlineColor = getgenv().Charms.outline;
                else
                    pcall(function()
                        local getTeam = getPlrformChr.Team
                        if getTeam then
                            local _Team = getPlrformChr.TeamColor
                            local TeamColors = _Team.Color
                            Highlight.FillColor = TeamColors;
                            Highlight.OutlineColor = TeamColors;
                        else
                            Highlight.FillColor = Color3.new(1,1,1)
                            Highlight.OutlineColor = Color3.new(0,0,0)
                        end
                    end)
                end
            end
        end)
        Highlight.Destroying:Connect(function()
            Stepped:Disconnect()
        end)
        return Highlight;
    else
        return character:FindFirstChildOfClass("Highlight");
    end
end

for i,v in ipairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        v.CharacterAdded:Connect(function(char)
            Players_charms(char)
        end)
    end
end
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        Players_charms(char)
    end)
end)

other:NewButton("Anti afk","Anti kick you when idled 20 mins",function()
    if getconnections then
        local s = pcall(function()
            for i,v in pairs(getconnections(LocalPlayer.Idled)) do
                v:Disable()
            end
        end)
        if s then
            warn("Anti AFK success loaded")
        end
    else
        local s = pcall(function()
            LocalPlayer.Idled:Connect(function()
                VirtualUser.Button2Down(Vector2.new(0,0),CurrentCamera)
                wait(.5)
                VirtualUser.Button2Up(Vector2.new(0,0),CurrentCamera)
            end)
        end)
        if s then
            warn("Anti AFK success loaded")
        end
    end
end)
other:NewButton("Remove nametag","Remove nametag form character",function()
    if LocalPlayer.Character then
        local tag = LocalPlayer.Character:FindFirstChild("NameBbGui")
        if tag then tag:Destroy() end
    end
end)
other:NewButton("Remove classtag","Remove classtag form character",function()
    if LocalPlayer.Character then
        local tag = LocalPlayer.Character:FindFirstChild("ClassBbGui")
        if tag then tag:Destroy() end
    end
end)
other:NewButton("Remove ranktag","Remove ranktag form character",function()
    if LocalPlayer.Character then
        local tag = LocalPlayer.Character:FindFirstChild("RankBbGui")
        if tag then tag:Destroy() end
    end
end)

credit:NewLabel("UI: Kavo ui library | xHeptc#2255")
credit:NewLabel("Scripting: Ghost-Ducky#7698")
credit:NewButton("Copy discord invite","Join discord :)",function()
    if setclipboard then
        local x,y = pcall(function()setclipboard("https://discord.gg/TFUeFEESVv")end)
        if x then warn("Success copied discord invite link") end
    end
end)

--// Spoof value
local completed,errors = pcall(function()
    local raw = getrawmetatable(game)
    local old_index = raw.__index
    local spoof_walkspeed = 16
    local spoof_jumppower = 50
    local spoof_gravity = 196.2
    setreadonly(raw, false)
    raw.__index = newcclosure(function(self,value)
        if tostring(value):lower() == "walkspeed" then
            return spoof_walkspeed
        end
        if tostring(value):lower() == "jumppower" then
            return spoof_jumppower
        end
        if tostring(value):lower() == "gravity" then
            return spoof_gravity
        end
        return old_index(self,value)
    end)
    setreadonly(raw, true)
end)
do
    if completed then
        print("Success spoof value")
    end
    if errors then
        print("Failed spoof value")
    end
end

--// Fast&Smooth tween
function FastTween(instance, property, tweenInfo, delayTime)
    if LocalPlayer.Character then
        if type(instance) ~= "table" then
            instance = { instance }
        end
        local TTable = {}
        local Easing_Style;
        local EasingDirection;
        for i, v in ipairs(instance) do
            local carpet = Instance.new("Part",game:GetService("Workspace"))
            carpet.Anchored = true
            carpet.Size = Vector3.new(15,.5,15)
            carpet.Material = Enum.Material.ForceField

            if tweenInfo == nil then
            tweenInfo = { 1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out }
            else
                if tweenInfo[2] == nil then
                    tweenInfo[2] = Enum.EasingStyle.Sine
                elseif type(tweenInfo[2]) == "string" then
                    if string.lower(tweenInfo[2]) == "expo" then
                        tweenInfo[2] = Enum.EasingStyle.Exponential
                    else
                        Easing_Style = tweenInfo[2]
                        tweenInfo[2] = Enum.EasingStyle[Easing_Style]
                    end;
                end;
                if tweenInfo[3] == nil then
                    tweenInfo[3] = Enum.EasingDirection.InOut
                elseif type(tweenInfo[3]) == "string" then
                    EasingDirection = tweenInfo[3]
                    tweenInfo[3] = Enum.EasingDirection[EasingDirection]
                end
            end

            local Tween = TweenService:Create(v, TweenInfo.new(unpack(tweenInfo)), property)
            coroutine.wrap(function()
                LocalPlayer.Character.Humanoid.Died:Connect(function()
                    Tween:Cancel()
                end)
                local RS = RunService.RenderStepped:Connect(function()
                    carpet.Name = HttpService:GenerateGUID(false)
                    carpet.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-4,0)
                    carpet.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    if Tween.PlaybackState == Enum.PlaybackState.Completed or Tween.PlaybackState == Enum.PlaybackState.Cancelled then
                        if carpet then
                            carpet:Destroy()
                        end
                    end
                end)
                carpet.Destroying:Connect(function()
                    RS:Disconnect()
                end)

                if delayTime then
                    wait(delayTime)
                end

                Tween:Play()
            end)()
            table.insert(TTable, Tween)
        end
        return unpack(TTable)
    end
end


--// Setup


