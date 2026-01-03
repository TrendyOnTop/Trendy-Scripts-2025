--[[
    Trendy Scripts 2025
    Comprehensive Combat Script
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Settings
local Settings = {
    -- Target/Silent Aim
    Enabled = false,
    TargetEnabled = false,
    CamLockEnabled = false,
    SilentAim = true,
    HitPart = "Head", -- Head, Torso, HumanoidRootPart
    Prediction = 0.15,
    
    -- Checks
    WallCheck = true,
    TeamCheck = true,
    VisibleCheck = true,
    
    -- Camera
    CameraSmoothness = 0.3,
    CameraFOV = 120,
    SilentFOV = 100,
    ShowFOV = true,
    
    -- CSync
    CSync = true,
    CSyncSpeed = 0.1,
    
    -- Hit Detection
    HitDetection = true,
    HitChams = true,
    HitChamsColor = Color3.fromRGB(255, 0, 0),
    HitChamsTransparency = 0.3,
    
    -- Visuals
    VisualsEnabled = true,
    TargetVisuals = true,
    BulletTrails = true,
    BulletTrailColor = Color3.fromRGB(255, 255, 0),
    Crosshair = true,
    CrosshairColor = Color3.fromRGB(255, 255, 255),
    CrosshairSize = 20,
    
    -- Environment
    EnvironmentEnabled = false,
    Ambient = Color3.fromRGB(100, 100, 100),
    Brightness = 2,
    
    -- Dance
    DanceEnabled = false,
    DanceSpeed = 1,
}

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrendyScripts2025"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.BorderSizePixel = 0
Title.Text = "Trendy Scripts 2025"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollFrame

-- Utility Functions
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Settings.SilentFOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if Settings.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local character = player.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            
            if humanoidRootPart and humanoid and humanoid.Health > 0 then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                
                if onScreen and distance < shortestDistance then
                    if Settings.WallCheck then
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                        
                        local raycast = Workspace:Raycast(Camera.CFrame.Position, (humanoidRootPart.Position - Camera.CFrame.Position).Unit * 1000, raycastParams)
                        
                        if raycast and raycast.Instance:IsDescendantOf(character) then
                            closestPlayer = player
                            shortestDistance = distance
                        end
                    else
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function GetHitPart(character)
    if not character then return nil end
    
    local hitPart = character:FindFirstChild(Settings.HitPart)
    if hitPart then return hitPart end
    
    -- Fallback to HumanoidRootPart
    return character:FindFirstChild("HumanoidRootPart")
end

local function CalculatePrediction(targetPart)
    if not targetPart or not targetPart:FindFirstChild("BodyVelocity") then
        return Vector3.new(0, 0, 0)
    end
    
    local velocity = targetPart.AssemblyLinearVelocity
    return velocity * Settings.Prediction
end

-- Silent Aim
local function SilentAim()
    if not Settings.Enabled or not Settings.SilentAim then return end
    
    local targetPlayer = GetClosestPlayer()
    if not targetPlayer or not targetPlayer.Character then return end
    
    local hitPart = GetHitPart(targetPlayer.Character)
    if not hitPart then return end
    
    local prediction = CalculatePrediction(hitPart)
    local targetPosition = hitPart.Position + prediction
    
    -- Silent aim implementation
    Mouse.Hit = CFrame.new(targetPosition)
end

-- Camera Lock
local CameraLockTarget = nil
local function CameraLock()
    if not Settings.CamLockEnabled then
        CameraLockTarget = nil
        return
    end
    
    if not CameraLockTarget or not CameraLockTarget.Character then
        CameraLockTarget = GetClosestPlayer()
    end
    
    if CameraLockTarget and CameraLockTarget.Character then
        local hitPart = GetHitPart(CameraLockTarget.Character)
        if hitPart then
            local prediction = CalculatePrediction(hitPart)
            local targetPosition = hitPart.Position + prediction
            
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetPosition)
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, Settings.CameraSmoothness)
        end
    end
end

-- CSync
local function CSync()
    if not Settings.CSync or not Settings.Enabled then return end
    
    local targetPlayer = GetClosestPlayer()
    if not targetPlayer or not targetPlayer.Character then return end
    
    local humanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- CSync implementation
    local targetCFrame = CFrame.new(humanoidRootPart.Position)
    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.CSyncSpeed)
end

-- Hit Detection
local HitParts = {}
local function ApplyHitChams(part)
    if not Settings.HitChams then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "HitCham"
    highlight.FillColor = Settings.HitChamsColor
    highlight.FillTransparency = Settings.HitChamsTransparency
    highlight.OutlineColor = Settings.HitChamsColor
    highlight.OutlineTransparency = 0
    highlight.Parent = part
    
    table.insert(HitParts, {part = part, highlight = highlight})
    
    game:GetService("Debris"):AddItem(highlight, 2)
end

local function OnHit(hitPart)
    if not Settings.HitDetection then return end
    
    if hitPart and hitPart.Parent then
        local character = hitPart.Parent
        if character:FindFirstChild("Humanoid") then
            ApplyHitChams(hitPart)
        end
    end
end

-- Visuals
local FOVCircle = nil
local function CreateFOVCircle()
    if FOVCircle then FOVCircle:Destroy() end
    
    FOVCircle = Instance.new("Frame")
    FOVCircle.Name = "FOVCircle"
    FOVCircle.Size = UDim2.new(0, Settings.SilentFOV * 2, 0, Settings.SilentFOV * 2)
    FOVCircle.Position = UDim2.new(0.5, -Settings.SilentFOV, 0.5, -Settings.SilentFOV)
    FOVCircle.BackgroundTransparency = 1
    FOVCircle.BorderSizePixel = 0
    FOVCircle.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = FOVCircle
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0.5
    UIStroke.Parent = FOVCircle
end

local CrosshairFrame = nil
local function CreateCrosshair()
    if CrosshairFrame then CrosshairFrame:Destroy() end
    
    CrosshairFrame = Instance.new("Frame")
    CrosshairFrame.Name = "Crosshair"
    CrosshairFrame.Size = UDim2.new(0, Settings.CrosshairSize, 0, Settings.CrosshairSize)
    CrosshairFrame.Position = UDim2.new(0.5, -Settings.CrosshairSize/2, 0.5, -Settings.CrosshairSize/2)
    CrosshairFrame.BackgroundTransparency = 1
    CrosshairFrame.BorderSizePixel = 0
    CrosshairFrame.Parent = ScreenGui
    
    -- Horizontal line
    local hLine = Instance.new("Frame")
    hLine.Size = UDim2.new(1, 0, 0, 2)
    hLine.Position = UDim2.new(0, 0, 0.5, -1)
    hLine.BackgroundColor3 = Settings.CrosshairColor
    hLine.BorderSizePixel = 0
    hLine.Parent = CrosshairFrame
    
    -- Vertical line
    local vLine = Instance.new("Frame")
    vLine.Size = UDim2.new(0, 2, 1, 0)
    vLine.Position = UDim2.new(0.5, -1, 0, 0)
    vLine.BackgroundColor3 = Settings.CrosshairColor
    vLine.BorderSizePixel = 0
    vLine.Parent = CrosshairFrame
end

local TargetHighlight = nil
local function UpdateTargetVisuals()
    if not Settings.TargetVisuals then
        if TargetHighlight then TargetHighlight:Destroy() TargetHighlight = nil end
        return
    end
    
    local targetPlayer = GetClosestPlayer()
    if targetPlayer and targetPlayer.Character then
        if not TargetHighlight then
            TargetHighlight = Instance.new("Highlight")
            TargetHighlight.Name = "TargetHighlight"
            TargetHighlight.FillColor = Color3.fromRGB(0, 255, 0)
            TargetHighlight.FillTransparency = 0.7
            TargetHighlight.OutlineColor = Color3.fromRGB(0, 255, 0)
            TargetHighlight.OutlineTransparency = 0
        end
        TargetHighlight.Parent = targetPlayer.Character
    else
        if TargetHighlight then TargetHighlight:Destroy() TargetHighlight = nil end
    end
end

-- Bullet Trails
local function CreateBulletTrail(startPos, endPos)
    if not Settings.BulletTrails then return end
    
    local attachment0 = Instance.new("Attachment")
    attachment0.Position = startPos
    attachment0.Parent = Workspace.Terrain
    
    local attachment1 = Instance.new("Attachment")
    attachment1.Position = endPos
    attachment1.Parent = Workspace.Terrain
    
    local trail = Instance.new("Trail")
    trail.Attachment0 = attachment0
    trail.Attachment1 = attachment1
    trail.Color = ColorSequence.new(Settings.BulletTrailColor)
    trail.Transparency = NumberSequence.new(0.5)
    trail.Lifetime = 0.5
    trail.Parent = Workspace.Terrain
    
    game:GetService("Debris"):AddItem(trail, 1)
    game:GetService("Debris"):AddItem(attachment0, 1)
    game:GetService("Debris"):AddItem(attachment1, 1)
end

-- Environment
local function UpdateEnvironment()
    if not Settings.EnvironmentEnabled then return end
    
    local lighting = game:GetService("Lighting")
    lighting.Ambient = Settings.Ambient
    lighting.Brightness = Settings.Brightness
end

-- Dance
local DanceAnimation = nil
local function StartDance()
    if not Settings.DanceEnabled then
        if DanceAnimation then
            DanceAnimation:Stop()
            DanceAnimation = nil
        end
        return
    end
    
    if not DanceAnimation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        local animator = humanoid:FindFirstChildOfClass("Animator")
        
        if animator then
            -- Create dance animation (simplified)
            DanceAnimation = Instance.new("Animation")
            DanceAnimation.AnimationId = "rbxassetid://507771019" -- Default dance
            
            local track = animator:LoadAnimation(DanceAnimation)
            track.Looped = true
            track:Play()
        end
    end
end

-- UI Creation Functions
local function CreateToggle(name, setting, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = ScrollFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -55, 0, 2.5)
    toggleButton.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = Settings[setting] and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 12
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = toggleFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        toggleButton.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggleButton.Text = Settings[setting] and "ON" or "OFF"
        if callback then callback() end
    end)
    
    return toggleFrame
end

local function CreateSlider(name, setting, min, max, step)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Slider"
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = ScrollFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(Settings[setting])
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local slider = Instance.new("Frame")
    slider.Name = "Slider"
    slider.Size = UDim2.new(1, 0, 0, 5)
    slider.Position = UDim2.new(0, 0, 1, -10)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.BorderSizePixel = 0
    slider.Parent = sliderFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 2)
    UICorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((Settings[setting] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 2)
    UICorner2.Parent = fill
    
    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = slider.AbsolutePosition
            local sliderSize = slider.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            local value = math.floor((min + (max - min) * relativeX) / step + 0.5) * step
            value = math.clamp(value, min, max)
            Settings[setting] = value
            label.Text = name .. ": " .. tostring(value)
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        end
    end)
    
    return sliderFrame
end

-- Create UI Elements
CreateToggle("Enable Script", "Enabled", function()
    if Settings.Enabled then
        Settings.TargetEnabled = true
    end
end)

CreateToggle("Target/CamLock", "CamLockEnabled", function()
    if Settings.CamLockEnabled then
        Settings.TargetEnabled = true
    end
end)

CreateToggle("Silent Aim", "SilentAim")
CreateToggle("Wall Check", "WallCheck")
CreateToggle("Team Check", "TeamCheck")
CreateToggle("Visible Check", "VisibleCheck")
CreateToggle("CSync", "CSync")
CreateToggle("Hit Detection", "HitDetection")
CreateToggle("Hit Chams", "HitChams")
CreateToggle("Visuals", "VisualsEnabled")
CreateToggle("Target Visuals", "TargetVisuals")
CreateToggle("Bullet Trails", "BulletTrails")
CreateToggle("Crosshair", "Crosshair", function()
    if Settings.Crosshair then
        CreateCrosshair()
    else
        if CrosshairFrame then CrosshairFrame:Destroy() CrosshairFrame = nil end
    end
end)

CreateToggle("Show FOV", "ShowFOV", function()
    if Settings.ShowFOV then
        CreateFOVCircle()
    else
        if FOVCircle then FOVCircle:Destroy() FOVCircle = nil end
    end
end)

CreateToggle("Environment", "EnvironmentEnabled")
CreateToggle("Dance", "DanceEnabled", function()
    StartDance()
end)

CreateSlider("Prediction", "Prediction", 0, 1, 0.01)
CreateSlider("Camera Smoothness", "CameraSmoothness", 0, 1, 0.01)
CreateSlider("Silent FOV", "SilentFOV", 0, 500, 1)
CreateSlider("Crosshair Size", "CrosshairSize", 5, 50, 1)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if Settings.Enabled then
        SilentAim()
        if Settings.CSync then
            CSync()
        end
    end
    
    if Settings.CamLockEnabled then
        CameraLock()
    end
    
    if Settings.ShowFOV and not FOVCircle then
        CreateFOVCircle()
    elseif not Settings.ShowFOV and FOVCircle then
        FOVCircle:Destroy()
        FOVCircle = nil
    end
    
    if Settings.Crosshair and not CrosshairFrame then
        CreateCrosshair()
    elseif not Settings.Crosshair and CrosshairFrame then
        CrosshairFrame:Destroy()
        CrosshairFrame = nil
    end
    
    if Settings.TargetVisuals then
        UpdateTargetVisuals()
    end
    
    if Settings.EnvironmentEnabled then
        UpdateEnvironment()
    end
    
    if Settings.DanceEnabled then
        StartDance()
    end
end)

-- Update ScrollFrame content size
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- Local function cooked
local function cooked(Sex3)
    -- Custom function implementation
    if Sex3 then
        -- Process Sex3 parameter
        print("Cooked function called with:", Sex3)
    end
end

print("Trendy Scripts 2025 loaded successfully!")
