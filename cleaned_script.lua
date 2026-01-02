local Menu = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/library/refs/heads/main/cuh.txt",true))()

task.spawn(function()
    Menu:NameUpdate(0.6, 'Cactus', '.GG [khen.cc]')
end)

getgenv().Sentinel = {
    Enabled = true,
    HorizontalPrediction = 0.145,
    SelectedPart = "HumanoidRootPart",
    LockType = "Namecall",
    ResolverEnabled = false,
    RESOLVER = "MoveDirection"
}

local TargetAimbot = {
    Enabled = true,
    Keybind = Enum.KeyCode.Q,
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local TargBindEnabled = false
local TargetPlr = nil

Menu:SetSize(500, 400)
Menu.Notify("Script Loaded.", 2)

local CombatTab = Menu.Tab("Main")
local TargetAimSection = Menu.Container("Main", "Target Aim", "Left") do
    Menu.CheckBox("Main", "Target Aim", "Enabled", getgenv().Sentinel.Enabled, function(a)
        getgenv().Sentinel.Enabled = a
    end)
end

local HitPartSection = Menu.Container("Main", "HitPart", "Left") do
    Menu.ComboBox("Main", "HitPart", "BodyPart", "Body Part", {
        "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", 
        "LeftUpperArm", "LeftLowerArm", "LeftHand", 
        "RightUpperArm", "RightLowerArm", "RightHand", 
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", 
        "RightUpperLeg", "RightLowerLeg", "RightFoot"
    }, function(a)
        getgenv().Sentinel.SelectedPart = a
    end)
end

local PredictionSection = Menu.Container("Main", "Prediction", "Left") do
    Menu.TextBox("Main", "Prediction", "Horizontal", tostring(getgenv().Sentinel.HorizontalPrediction), function(a)
        getgenv().Sentinel.HorizontalPrediction = tonumber(a)
    end)
    Menu.ComboBox("Main", "Prediction", "LockType", getgenv().Sentinel.LockType, {"Namecall", "Index"}, function(a)
        getgenv().Sentinel.LockType = a
    end)
end

Menu:SetTitle("Nigger.Lua")
Menu:SetVisible(true)
Menu:Init()

-- FOV Circle for target selection
local FOV43 = Drawing.new("Circle")
FOV43.Transparency = 0.5
FOV43.Thickness = 2
FOV43.Color = Color3.new(1, 0, 0)
FOV43.Filled = false
FOV43.Radius = 250
FOV43.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
FOV43.Visible = false

-- Lock Button
local Sigmaballs = Instance.new("ScreenGui")
Sigmaballs.Name = "Sigmaballs"
Sigmaballs.Parent = game.CoreGui
Sigmaballs.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Sigmaballs.ResetOnSpawn = false

local Button = Instance.new("TextButton")
Button.Name = "FlyButton"
Button.Parent = Sigmaballs
Button.Active = true
Button.Draggable = true
Button.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
Button.BackgroundTransparency = 0
Button.BorderSizePixel = 0
Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0.5, -75, 0.5, -25)
Button.Font = Enum.Font.ArialBold
Button.Text = "Lock: " .. "<font color='rgb(255, 0, 0)'>OFF</font>"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 25
Button.RichText = true
Button.TextStrokeTransparency = 0.5

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Button

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = Button
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(16, 16, 32)

local stk = Instance.new("UIStroke")
stk.Parent = Button
stk.Thickness = 3
stk.Color = Color3.fromRGB(16, 16, 32)
stk.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Target finding function
function SigmaOhioPlayer()
    local closestPlayer
    local shortestDistance = math.huge
    local player = game.Players.LocalPlayer
    local CC = game:GetService("Workspace").CurrentCamera
    local screenCenter = Vector2.new(CC.ViewportSize.X / 2, CC.ViewportSize.Y / 2)
    local fovRadius = FOV43.Radius
    local viewportSize = CC.ViewportSize

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") 
           and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            
            if onScreen and pos.X > 0 and pos.Y > 0 
               and pos.X < viewportSize.X and pos.Y < viewportSize.Y then
                local magnitude = (Vector2.new(pos.X, pos.Y) - screenCenter).magnitude
                if magnitude < fovRadius and magnitude < shortestDistance then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
    end
    
    return closestPlayer
end

-- Toggle lock function
toggle_lock = function()
    if TargetAimbot.Enabled then
        local closest = SigmaOhioPlayer()
        if TargBindEnabled and TargetPlr then
            TargBindEnabled = false
            TargetPlr = nil
            Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
            Button.Text = "Lock: " .. "<font color='rgb(255, 0, 0)'>OFF</font>"
            Menu.Notify("Untargeted", 2)
        else
            if closest then
                TargBindEnabled = true
                TargetPlr = closest
                Button.Text = "Lock: " .. "<font color='rgb(0, 255, 0)'>ON</font>"
                Menu.Notify("Target Locked: " .. tostring(TargetPlr.DisplayName), 2)
            else
                Menu.Notify("No target found", 2)
            end
        end
    end
end

Button.MouseButton1Click:Connect(toggle_lock)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.DPadDown then
        toggle_lock()
    end
end)

-- Get remote info for aiming
local game_support = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/script-khen/refs/heads/main/Argument.txt",true))()

local function getRemoteInfo()
    local placeId = game.PlaceId
    return game_support[placeId] or {Remote = "MainEvent", Argument = "UpdateMousePos"}
end

local remoteInfo = getRemoteInfo()

-- Aiming method via __namecall hook
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

do -- // Hooking
    __namecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
        local args, method = {...}, tostring(getnamecallmethod())

        if not checkcaller() and method == "FireServer" then
            for i, arg in pairs(args) do
                if typeof(arg) == "Vector3" then
                    if TargetPlr and getgenv().Sentinel.Enabled and getgenv().Sentinel.LockType == "Namecall" then
                        local selectedPart = getgenv().Sentinel.SelectedPart
                        local targetPart = TargetPlr.Character[selectedPart]

                        if targetPart then
                            local velocity
                            if getgenv().Sentinel.ResolverEnabled then
                                if getgenv().Sentinel.RESOLVER == "MoveDirection" then
                                    velocity = TargetPlr.Character.Humanoid.MoveDirection * TargetPlr.Character.Humanoid.WalkSpeed
                                elseif getgenv().Sentinel.RESOLVER == "LookVector" then
                                    velocity = targetPart.CFrame.LookVector * getgenv().Sentinel.HorizontalPrediction * 1.0
                                else
                                    velocity = targetPart.Velocity
                                end
                            else
                                velocity = targetPart.Velocity
                            end

                            local horizontalPrediction = getgenv().Sentinel.HorizontalPrediction
                            args[i] = targetPart.Position + (velocity * horizontalPrediction)
                        end
                    end
                    return __namecall(Self, unpack(args))
                elseif type(arg) == "table" then
                    for index, element in ipairs(arg) do
                        if typeof(element) == "Vector3" then
                            if TargetPlr and getgenv().Sentinel.Enabled and getgenv().Sentinel.LockType == "Namecall" then
                                local selectedPart = getgenv().Sentinel.SelectedPart
                                local targetPart = TargetPlr.Character[selectedPart]

                                if targetPart then
                                    local velocity
                                    if getgenv().Sentinel.ResolverEnabled then
                                        if getgenv().Sentinel.RESOLVER == "MoveDirection" then
                                            velocity = TargetPlr.Character.Humanoid.MoveDirection * TargetPlr.Character.Humanoid.WalkSpeed
                                        elseif getgenv().Sentinel.RESOLVER == "LookVector" then
                                            velocity = targetPart.CFrame.LookVector * getgenv().Sentinel.HorizontalPrediction * 1.0
                                        else
                                            velocity = targetPart.Velocity
                                        end
                                    else
                                        velocity = targetPart.Velocity
                                    end

                                    local horizontalPrediction = getgenv().Sentinel.HorizontalPrediction
                                    arg[index] = targetPart.Position + (velocity * horizontalPrediction)
                                end
                            end
                        end
                    end
                end
            end
            return __namecall(Self, unpack(args))
        end

        return __namecall(Self, ...)
    end))
end

-- Index method for aiming
RunService.PostSimulation:Connect(function(DeltaTime)
    if getgenv().Sentinel.Enabled then
        if getgenv().Sentinel.LockType == "Index" then
            local LocalPlayer = game.Players.LocalPlayer
            local LocalFramework = LocalPlayer.PlayerGui:WaitForChild("Framework", 1e9)

            if LocalFramework then
                local FrameworkEnvironment = getsenv(LocalFramework)

                if FrameworkEnvironment._G and FrameworkEnvironment._G.MOUSE_POSITION then
                    if TargetPlr then
                        local selectedPart = getgenv().Sentinel.SelectedPart
                        local targetPart = TargetPlr.Character[selectedPart]

                        if targetPart then
                            local velocity
                            if getgenv().Sentinel.ResolverEnabled then
                                if getgenv().Sentinel.RESOLVER == "MoveDirection" then
                                    velocity = TargetPlr.Character.Humanoid.MoveDirection * TargetPlr.Character.Humanoid.WalkSpeed
                                elseif getgenv().Sentinel.RESOLVER == "LookVector" then
                                    velocity = targetPart.CFrame.LookVector * getgenv().Sentinel.HorizontalPrediction * 1.0
                                else
                                    velocity = targetPart.Velocity
                                end
                            else
                                velocity = targetPart.Velocity
                            end

                            local horizontalPrediction = getgenv().Sentinel.HorizontalPrediction
                            FrameworkEnvironment._G.MOUSE_POSITION = targetPart.Position + (velocity * horizontalPrediction)
                        end
                    end
                end
            end
        end
    end
end)
