--// Wait game loaded
while true do
    if game:IsLoaded() then break; end
    wait(.005)
end

--// Service
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = game:GetService("Workspace").CurrentCamera
function WorldToViewportPoint(v)
    return CurrentCamera:WorldToViewportPoint(v.Position)
end

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
local rebirth_function = game:GetService("ReplicatedStorage").RemoteFunctions.Rebirth

--// Setting
getgenv().Setting = {
    auto_Farm = {Enabled = false,Range = 1000},
    auto_Sell = false,
    rebirth = false,
    mega_rebirth = false,
    harvest_aura = {Enabled = false,slow_mode = false},
    Pet = {
        Selected = nil;
        name = false,
        name_color = Color3.new(1,1,1),

    }
}

local tab_1 = w:Category("Main")

local auto = tab_1:Sector("Automatic")
local pet = tab_1:Sector("Pet")
local misc = tab_1:Sector("Misc")
local credit = tab_1:Sector("Credit")

auto:Cheat("Checkbox","Slow harvest",function(x)
    getgenv().Setting.harvest_aura.slow_mode = x;
end)
auto:Cheat("Checkbox","Harvest aura",function(x)
    getgenv().Setting.harvest_aura.Enabled = x;
    if x then
        harvest_aura()
    end
end)

function getNearest()
    local wheat = {}
    if LocalPlayer.Character then
        for i,v in ipairs(workspace:GetChildren()) do
            if v:IsA("Model") and tostring(v.Name):lower():find("wheat") then
                local hitbox = v:FindFirstChild("Hitbox")
                local value = v:FindFirstChildOfClass("Vector3Value")
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                if hitbox and value and hrp then
                    local mag = (hrp.Position - hitbox.Position).Magnitude
                    if mag < 110 or mag <= 110 then
                        local Duckyy = {
                            [1] = workspace[tostring(v.Name)][tostring(value.Name)]
                        }
                        table.insert(wheat,Duckyy)
                    end
                end
            end
        end
        return wheat
    else
        return nil;
    end
    return nil
end
function harvest_aura()
    spawn(function()
        while getgenv().Setting.harvest_aura.Enabled and task.wait() do
            if not getgenv().Setting.harvest_aura.slow_mode  then
                if LocalPlayer.Character then
                    for i,v in ipairs(workspace:GetChildren()) do
                        if v:IsA("Model") and tostring(v.Name):lower():find("wheat") then
                            local hitbox = v:FindFirstChild("Hitbox")
                            local value = v:FindFirstChildOfClass("Vector3Value")
                            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                            if hitbox and value and hrp then
                                local mag = (hrp.Position - hitbox.Position).Magnitude
                                if mag < 100 or mag <= 100 then
                                    local Duckyy = {
                                        [1] = workspace[tostring(v.Name)][tostring(value.Name)]
                                    }
                                    harvest_event:FireServer(Duckyy)
                                end
                            end
                        end
                    end
                end
                task.wait(3)
            else
                local wheat = getNearest()
                if wheat ~= nil then
                    for i,v in next, (wheat) do
                        harvest_event:FireServer(v)
                        task.wait()
                    end
                end
                task.wait(3)
            end
        end
    end)
end

auto:Cheat("Checkbox","Tween farm",function(x)
    getgenv().Setting.auto_Farm.Enabled = x;
    if x then
        auto_Farm()
    end
end)
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
                    wheat = getRandom(range)
                end
            end
        end
    end)
end
function getRandom(distance)
    local value = distance or 800;
    if value then
        value = tonumber(distance)
        for i,v in next, (workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChildOfClass("Vector3Value") and tostring(v.Name):lower():find("wheat") then
                local part = v:FindFirstChild("Hitbox")
                if part then
                    local mag = (LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude
                    if value > mag and mag > 100 then
                        return v;
                    end
                end
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

auto:Cheat("Checkbox","Auto Rebirth",function(x)
    getgenv().Setting.rebirth = x;
    if x then
        rebirth()
    end
end)
function rebirth()
    spawn(function()
        while getgenv().Setting.rebirth and task.wait(.1) do
            InvokeServer(rebirth_function,{})
        end
    end)
end

auto:Cheat("Checkbox","Auto Mega rebirth",function(x)
    getgenv().Setting.mega_rebirth = x;
    if x then
        mega_rebirth()
    end
end)
function mega_rebirth()
    spawn(function()
        while getgenv().Setting.mega_rebirth and task.wait(.1) do
            InvokeServer(rebirth_function,{[1] = true})
        end
    end)
end

local pets_List = {};
for i,v in next, (game:GetService("ReplicatedStorage")["Pets"]:GetChildren()) do
    local name = tostring(v.Name)
    if not table.find(pets_List,name) then
        table.insert(pets_List,name)
    end
end

pet:Cheat("Checkbox","Show name",function(x)
    getgenv().Setting.Pet.name = x;
end)

pet:Cheat("color","Pick name color", function(x)
    getgenv().Setting.Pet.name_color = x;
end)

function Drawing_name(model)
    if model:FindFirstChild("HumanoidRootPart") then
        local label = Drawing.new("Text")
        label.Text = tostring(model.Name)
        label.Font = Drawing.Fonts["UI"]
        label.Size = 18
        label.Center = true

        label.Visible = false

        label.Color = getgenv().Setting.Pet.name_color
        label.Outline = true
        label.OutlineColor = Color3.new(0,0,0)


        local RS = RunService.RenderStepped:Connect(function()
            local root = model:FindFirstChild("HumanoidRootPart")
            if model ~= nil and root then
                local root_vector,onScreen = WorldToViewportPoint(root)

                if onScreen then
                    label.Position = Vector2.new(root_vector.X, root_vector.Y - 10)
                    label.Size = 1000 / root_vector.Z + 8
                    label.Text = tostring(model.Name)
                    label.Color = getgenv().Setting.Pet.name_color

                    if getgenv().Setting.Pet.name then
                        label.Visible = true
                    else
                        label.Visible = false
                    end
                else
                    label.Visible = false
                end
            else
                label.Visible = false
            end
        end)

        model.Destroying:Connect(function()
            RS:Disconnect()
            task.wait(.1)
            label:Remove()
        end)
    end
end

do
    for i,v in ipairs(workspace:GetChildren()) do
        if not tostring(v.Name):lower():find("wheat") and v:IsA("Model") then
            if table.find(pets_List,tostring(v.Name)) then
                Drawing_name(v)
            end
        end
    end
    workspace.ChildAdded:Connect(function(v)
        task.wait(1)
        if not tostring(v.Name):lower():find("wheat") and v:IsA("Model") then
            if table.find(pets_List,tostring(v.Name)) then
                Drawing_name(v)
            end
        end
    end)
end

function get_Allpets()
    local list = {};
    table.clear(list);
    -- task.wait(.1)
    for i,v in ipairs(workspace:GetChildren()) do
        local name = tostring(v.Name)

        if not name:lower():find("wheat") and v:IsA("Model") then
            if table.find(pets_List,name) then
                table.insert(list,v)
            end
        end
    end
    return list
end

local pet_dropdown = pet:Cheat("Dropdown","Available pets in workspace",function(x)
    getgenv().Setting.Pet.Selected = x;
end,{options = {"None"};})
pet:Cheat("Button","Pets dropdown",function()
    local t_1 = pet_dropdown:GetOption()
    local t_2 = get_Allpets()
    for i,v in next, (t_1) do
        if v ~= "None" then
            pet_dropdown:RemoveOption(v)
        end
    end
    task.wait(.5)
    for i,v in next, (t_2) do
        pet_dropdown:AddOption(v.Name)
    end
end,{text = "Refresh"})
pet:Cheat("Button","Goto pets",function()
    if getgenv().Setting.Pet.Selected ~= nil and getgenv().Setting.Pet.Selected ~= "None" and typeof(getgenv().Setting.Pet.Selected) == "string" then
        local Selected = getgenv().Setting.Pet.Selected
        local t = get_Allpets()
        local pet_ = nil;
        for i,v in ipairs(workspace:GetChildren()) do
            if not tostring(v.Name):lower():find("wheat") and v:IsA("Model") and tostring(v.Name):lower() == tostring(Selected):lower() then
                pet_ = v;
            end
        end
        if pet_ ~= nil then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local pet_hrp = pet_:FindFirstChild("HumanoidRootPart")
            if hrp and pet then
                local cf = pet_hrp.CFrame * CFrame.new(0,3.5,0)
                hrp.CFrame = cf
            end
        else
            game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Bread",Text = string.format("%s is nil in workspace",Selected),Duration = 5})
            game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Bread",Text = "Refresh dropdown!",Duration = 5})
        end
    end
end,{text = "Teleport"})


getgenv().WS = 16;getgenv().JP = 50;
misc:Cheat("Slider","Walk speed",function(val)
    getgenv().WS = val;
end,{min = 16,max = 500,suffix = " value"})

misc:Cheat("Slider","Jump height",function(val)
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
end,{text = "Redeem"})
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
credit:Cheat("Button","Discord invite",function()
    if setclipboard then
        local x,y = pcall(function()setclipboard("https://discord.gg/TFUeFEESVv")end)
        if x then game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Bread",Text = "Success copyied discord invite",Duration = 5}) end
    end
end,{text = "Copy"})
credit:Cheat("Button","Destroy GUI",function()
    if game:GetService("CoreGui"):FindFirstChild("FinityUI") then
        game:GetService("CoreGui"):FindFirstChild("FinityUI"):Destroy()
    end
end,{text = "Destroy"})

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