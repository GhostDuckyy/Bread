while task.wait() do
    if game:IsLoaded() then break; end
end

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/Project%20%20Finity/source.lua", true))();
local w = Library.new(true,"Bread | Ghost-Ducky#7698")
w.ChangeToggleKey(Enum.KeyCode.RightControl)

--// Service
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = workspace.CurrentCamera

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

--// remote
local mine_event = game:GetService("ReplicatedStorage").Remotes.Mining.MineBlock

--// Setting
getgenv().Setting = {
    auto_mine = false,
    mine_target = "Random",
    x_ray = {boolean = false,transparency = 0.5}
}

--// script
local tab_1 = w:Category("Main")
local tab_2 = w:Category("Teleports")
local credit = w:Category("Credit")

local auto = tab_1:Sector("Automatic")
local client = tab_1:Sector("Client")
local infomation = credit:Sector("Infomation")

auto:Cheat("Dropdown","Mine Target",function(x)
    getgenv().Setting.mine_target = x;
end,{
    options = {"Random","Ore only"},
})

auto:Cheat("Toggle","Auto mine",function(x)
    getgenv().Setting.auto_mine = x;
    if x then
        auto_mine()
    end
end)
function auto_mine()
    spawn(function()
        while getgenv().Setting.auto_mine and task.wait(.5) do
            local list = getrenv()._G.blockList or false
            if list ~= false then
                if tostring(getgenv().Setting.mine_target):lower() == "random" then
                    for i,v in next, list do
                        if getgenv().Setting.auto_mine ~= true then break; end
                        mine_event:FireServer(tostring(i))
                    end
                elseif tostring(getgenv().Setting.mine_target):lower() == "ore only" then
                    for i,v in next, list do
                        for x,y in next, v do
                            if tostring(y):lower():find("ore") or tostring(y):lower():find("lucky block") then
                                if getgenv().Setting.auto_mine ~= true then break; end
                                mine_event:FireServer(tostring(i))
                            end
                        end
                    end
                end
            else
                for i,v in next, getrenv()._G do
                    if tostring(i):lower() == "blocklist" and type(v) == "table" then
                        list = v;
                    end
                end
            end
        end
    end)
end

getgenv().WS = 20;getgenv().JP = 55;
client:Cheat("Slider","Walk speed", function(x)
    getgenv().WS = x;
end,{min = 16,max = 500, suffix = " value"})
client:Cheat("Slider","Jump Height", function(x)
    getgenv().JP = x;
end,{min = 50,max = 500, suffix = " value"})

client:Cheat("Toggle","X-ray",function(x)
    getgenv().Setting.x_ray.boolean = x;
    if x then
        x_ray()
    else
        for i,v in ipairs(workspace["Blocks"]:GetChildren()) do
            local block = v:FindFirstChild("Block")
            if block then
                block.Transparency = 0
            end
        end
    end
end)
client:Cheat("Slider","Transparency",function(x)
    getgenv().Setting.x_ray.transparency = x;
end,{min = 0,max = 1,suffix = " value",precise = true})

function x_ray()
    for i,v in ipairs(workspace["Blocks"]:GetChildren()) do
        local block = v:FindFirstChild("Block")
        if block then
            task.spawn(function()
                while task.wait(.1) do
                    if getgenv().Setting.x_ray.boolean ~= true then break; end
                    local transparency = tonumber(getgenv().Setting.x_ray.transparency) or 0.5
                    block.Transparency = transparency
                end
            end)
        end
    end
    local added;
    added = workspace["Blocks"].ChildAdded:Connect(function(v)
        task.wait(.1)
        if getgenv().Setting.x_ray.boolean then
            local block = v:FindFirstChild("Block")
            if block then
                task.spawn(function()
                    while task.wait(.1) do
                        if getgenv().Setting.x_ray.boolean ~= true then break; end
                        local transparency = tonumber(getgenv().Setting.x_ray.transparency) or 0.5
                        block.Transparency = transparency
                    end
                end)
            end
        end
    end)
    while task.wait() do
        if getgenv().Setting.x_ray.boolean ~= true then added:Disconnect() break; end
    end
end

RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = tonumber(getgenv().WS)
            Humanoid.JumpPower = tonumber(getgenv().JP)
            if Humanoid.UseJumpPower ~= true then Humanoid.UseJumpPower = true end
        end
    end
end)

--// teleport
do
    local tp_zone = tab_2:Sector("Zone")
    local tp_shop = tab_2:Sector("Shop")
    local tp_other = tab_2:Sector("Machine & Rewards")
    local tp_eggs = tab_2:Sector("Eggs")

    local zones = workspace:FindFirstChild("Zones")
    local shop = workspace:FindFirstChild("ShopTeleport")
    local chest = workspace:FindFirstChild("Chests")
    local other = workspace:FindFirstChild("Regions")
    local eggs = workspace["Prompts"]:FindFirstChild("Eggs")

    if shop then
        tp_zone:Cheat("button","Shop",function()
            if LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local cf = shop.CFrame * CFrame.new(0,1,0)
                if hrp then
                    hrp.CFrame = cf
                end
            end
        end,{text = "Teleport"})
    end

    if zones then
        for i,v in ipairs(zones:GetChildren()) do
            if v:IsA("Folder") and v:FindFirstChild("SurfaceTeleport") then
                tp_zone:Cheat("button",tostring(v.Name),function()
                    if LocalPlayer.Character then
                        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local cf = v["SurfaceTeleport"].CFrame * CFrame.new(0,5,0)
                        if hrp then
                            hrp.CFrame = cf
                        end
                    end
                end,{text = "Teleport"})
            end
        end
    end

    if chest then
        local chest_list = {}
        local chest_select = nil;
        for i,v in ipairs(chest:GetChildren()) do
            if v:IsA("MeshPart") then
                if not table.find(chest_list,tostring(v.Name)) then
                    table.insert(chest_list,tostring(v.Name))
                end
            end
        end

        tp_shop:Cheat("Dropdown","Chest list",function(x)
            chest_select = x;
        end,{options = chest_list})
        tp_shop:Cheat("button","Goto chest",function()
            if chest_select ~= nil then
                local v = chest:FindFirstChild(chest_select)
                if v and LocalPlayer.Character then
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local cf = v.CFrame * CFrame.new(0,5,0)
                    if hrp then
                        hrp.CFrame = cf
                    end
                end
            end
        end,{text = "Teleport"})
    end

    if other then
        for i,v in ipairs(other:GetChildren()) do
            if v:IsA("Part") then
                tp_other:Cheat("button",tostring(v.Name),function()
                    if LocalPlayer.Character then
                        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local cf = v.CFrame * CFrame.new(0,5,0)
                        if hrp then
                            hrp.CFrame = cf
                        end
                    end
                end,{text = "Teleport"})
            end
        end
    end

    if eggs then
        local eggs_list = {}
        local eggs_select = nil;
        for i,v in ipairs(eggs:GetChildren()) do
            if v:IsA("Part") then
                if not table.find(eggs_list,tostring(v.Name)) then
                    table.insert(eggs_list,tostring(v.Name))
                end
            end
        end

        tp_eggs:Cheat("Dropdown","Eggs list", function(x)
            eggs_select = x;
        end, {options = eggs_list})
        tp_eggs:Cheat("button","Goto eggs",function()
            if eggs_select ~= nil then
                local v = eggs:FindFirstChild(eggs_select)
                if v and LocalPlayer.Character then
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local cf = v.CFrame * CFrame.new(0,5,0)
                    if hrp then
                        hrp.CFrame = cf
                    end
                end
            end
        end)
    end

end

--// credit
infomation:Cheat("Label", "Made by Ghost-Ducky#7698")
infomation:Cheat("Label","Ui: Project Finity")
infomation:Cheat("button","Discord Invite",function()
    if setclipboard then setclipboard("https://discord.gg/TFUeFEESVv") end
end,{text = "Copy"})

--// setup