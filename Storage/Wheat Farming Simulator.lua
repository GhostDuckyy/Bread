--// Wait game loaded
while true do
    if game:IsLoaded() then break; end
    wait(.005)
end

--// Service
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = workspace.CurrentCamera

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/Project%20%20Finity/source.lua", true))();
local w = Library.new(true,"Bread | Ghost-Ducky#7698")
w.ChangeToggleKey(Enum.KeyCode.RightControl)

--// Remote
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

local redeem_function = game:GetService("ReplicatedStorage").RemoteFunctions.Redeem
local harvest_event = game:GetService("ReplicatedStorage").RemoteEvents.Harvest

--// Setting
getgenv().Setting = {
    auto_Farm = {Enabled = false,Range = 500},
    auto_Sell = false,
    Hitbox = {
        Transparency = false,
        Size = Vector3.new(4.75, 5, 4.75)
    }
}

local tab_1 = w:Category("Main")

local auto = tab_1:Sector("Automatic")
local misc = tab_1:Sector("Misc")
local credit = tab_1:Sector("Credit")


auto:Cheat("Checkbox","AI farm",function(x)
    getgenv().Setting.auto_Farm.Enabled = x;
    if x then
        auto_Farm()
    end
end)
auto:Cheat("Slider","Range",function(x)
    getgenv().Setting.auto_Farm.Range = x;
end,{min = 150,max = 1000,suffix = " range"})
function auto_Farm()
    spawn(function()
        local wheat = nil;
        while getgenv().Setting.auto_Farm.Enabled and task.wait(.1) do
            if LocalPlayer.Character then
                local range = tonumber(getgenv().Setting.auto_Farm.Range)
                local hrp = LocalPlayer.Character.HumanoidRootPart
                if wheat ~= nil then
                    local Tween = FastTween(hrp,{CFrame = wheat["Hitbox"].CFrame},{10})
                    while task.wait() do
                        if getgenv().Setting.auto_Farm.Enabled then
                            if Tween.PlaybackState == Enum.PlaybackState.Completed or Tween.PlaybackState == Enum.PlaybackState.Cancelled then
                                wheat = nil;
                                break;
                            end
                        else
                            wheat = nil;
                            Tween:Cancel()
                            break;
                        end
                    end
                else
                    wheat = getWheat(range)
                end
            end
        end
    end)
end
function getWheat(distance)
    local value = distance or nil;
    if value ~= nil then
        value = tonumber(distance)
        for i,v in next, (workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChildOfClass("Vector3Value") and tostring(v.Name):lower():find("wheat") then
                local part = v:FindFirstChild("Hitbox")
                if part then
                    local mag = (LocalPlayer.Character.HumanoidRootPart.CFrame.Position - part.CFrame.Position).Magnitude
                    if value > mag then
                        return v;
                    end
                end
            end
        end
    else
        for i,v in next, (workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChildOfClass("Vector3Value") and tostring(v.Name):lower():find("wheat") then
                return v;
            end
        end
    end
    return nil;
end

auto:Cheat("Checkbox","Auto sell",function(x)
    getgenv().Setting.auto_Sell = x;
    if x then
        auto_Sell()
    end
end)
function auto_Sell()
    spawn(function()
        local part = nil;
        while getgenv().Setting.auto_Sell and task.wait(.1) do
            if part ~= nil then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    firetouchinterest(hrp, part, 0)
                    task.wait(.1)
                    firetouchinterest(hrp, part, 1)
                end
            else
                task.wait(.5)
                for i,v in next, (workspace:GetChildren()) do
                    if v:IsA("Part") and v:FindFirstChildOfClass("TouchTransmitter") and tostring(v.Name):lower() == "sell" then
                        part = v;
                    end
                end
            end
        end
    end)
end

getgenv().WS = 16;getgenv().JP = 50;
auto:Cheat("Label","Client")
auto:Cheat("Slider","Walk speed",function(val)
    getgenv().WS = val;
end,{min = 16,max = 500,suffix = " value"})

auto:Cheat("Slider","Jump height",function(val)
    getgenv().JP = val;
end,{min = 50,max = 500,suffix = " value"})
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        local value_1 = tonumber(getgenv().WS)
        local value_2 = tonumber(getgenv().JP)
        if humanoid then
            humanoid.WalkSpeed = value_1
            humanoid.JumpPower = value_2
            if humanoid.UseJumpPower ~= true then humanoid.UseJumpPower = true end
        end
    end
end)

misc:Cheat("Button","Redeem all code",function()
    redeemCode()
end)
function redeemCode()
    local code_list = {
        "PETS",
        "TAMING",
        "MEGAREBIRTH",
        "LAVABEAST",
        "TAMEPETS",
    }
    for i,v in next, (code_list) do
        InvokeServer(redeem_function,{[1] = tostring(v):lower()})
        task.wait(.1)
    end
end

credit:Cheat("Label","Scripting: Ghost-Ducky#7698")
credit:Cheat("Label", "Ui: Project Finity")
credit:Cheat("Button","Copy discord invite",function()
    if setclipboard then
        local x,y = pcall(function()setclipboard("https://discord.gg/TFUeFEESVv")end)
        if x then game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Bread",Text = "Success copyied discord invite",Duration = 5}) end
    end
end)
credit:Cheat("Button","Destroy GUI",function()
    if game:GetService("CoreGui"):FindFirstChild("FinityUI") then
        game:GetService("CoreGui"):FindFirstChild("FinityUI"):Destroy()
    end
end)

--// Fast Tween
function FastTween(instance, property, tweenInfo, delayTime)
    if LocalPlayer.Character then
        if type(instance) ~= "table" then
            instance = { instance }
        end
        local TTable = {}
        local Easing_Style;
        local EasingDirection;
        for i, v in ipairs(instance) do
            local carpet = Instance.new("Part",workspace)
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
do
    local get_rawmt = getrawmetatable(game)
    local old_index = get_rawmt.__index;
    setreadonly(get_rawmt, false)
    get_rawmt.__index = newcclosure(function(self,value)
        if tostring(value):lower() == "walkspeed" then
            return 16;
        end
        if tostring(value):lower() == "jumppower" then
            return 50;
        end
        return old_index(self,value)
    end)
    setreadonly(get_rawmt, true)
end