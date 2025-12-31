-- Roblox Advanced Camera Lock System
-- Features: Smooth camera locking, prediction, FOV circle, pathfinding, auto-reload, auto-jump, dodging

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Character handling
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Handle character respawning
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

-- Settings
local Settings = {
    CameraLockEnabled = false,
    PathfindingEnabled = true,
    UIEnabled = true,
    SmoothnessX = 0.15,
    SmoothnessY = 0.15,
    PredictionX = 0.5,
    PredictionY = 0.5,
    FOV = 100,
    WalkSpeed = 200,
    JumpProbability = 0.02,
    AutoReload = true,
    AutoReloadInterval = 2.3,
    AutoStopShootingHP = 10,
    ShowFOVCircle = true,
    FOVCircleColor = Color3.fromRGB(255, 0, 0),
    FOVCircleTransparency = 0.5,
    FOVCircleThickness = 2,
    DodgingEnabled = true,
    DodgingSpeed = 16,
    DodgingIntensity = 5
}

-- State
local Target = nil
local TargetHumanoid = nil
local TargetHumanoidRootPart = nil
local LastReloadTime = 0
local IsShooting = false
local PathfindingPath = nil
local FOVCircle = nil
local MainUI = nil
local UIButton = nil
local ShootingConnection = nil
local LastPathfindingUpdate = 0
local CurrentWaypointIndex = 1
local DodgingDirection = 1
local LastDodgeChange = 0
local RandomMovementTimer = 0

-- Create FOV Circle
local function CreateFOVCircle()
    if FOVCircle then
        FOVCircle.ScreenGui:Destroy()
        FOVCircle = nil
    end
    
    if not Settings.ShowFOVCircle or not Settings.CameraLockEnabled then
        return
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FOVCircleGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = screenGui
    
    local circle = Instance.new("Frame")
    circle.Name = "FOVCircle"
    circle.Size = UDim2.new(0, Settings.FOV * 2, 0, Settings.FOV * 2)
    circle.Position = UDim2.new(0.5, -Settings.FOV, 0.5, -Settings.FOV)
    circle.BackgroundTransparency = 1
    circle.BorderSizePixel = 0
    circle.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Settings.FOVCircleColor
    stroke.Transparency = Settings.FOVCircleTransparency
    stroke.Thickness = Settings.FOVCircleThickness
    stroke.Parent = circle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0.5, 0)
    circleCorner.Parent = circle
    
    circle.BackgroundColor3 = Settings.FOVCircleColor
    circle.BackgroundTransparency = Settings.FOVCircleTransparency + 0.3
    
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 0
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, Settings.FOVCircleTransparency),
        NumberSequenceKeypoint.new(0.5, Settings.FOVCircleTransparency + 0.3),
        NumberSequenceKeypoint.new(1, Settings.FOVCircleTransparency)
    })
    gradient.Parent = circle
    
    FOVCircle = {
        ScreenGui = screenGui,
        Circle = circle,
        Gradient = gradient,
        Stroke = stroke
    }
    
    -- Animate gradient rotation
    spawn(function()
        while FOVCircle and Settings.ShowFOVCircle and Settings.CameraLockEnabled do
            for i = 0, 360, 2 do
                if not FOVCircle or not Settings.CameraLockEnabled then break end
                FOVCircle.Gradient.Rotation = i
                task.wait(0.03)
            end
        end
    end)
end

-- Find nearest target
local function FindNearestTarget()
    local nearestPlayer = nil
    local nearestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                local distance = (HumanoidRootPart.Position - rootPart.Position).Magnitude
                
                -- Check if target is within FOV
                local screenPoint, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local centerX = Camera.ViewportSize.X / 2
                    local centerY = Camera.ViewportSize.Y / 2
                    local distanceFromCenter = math.sqrt(
                        math.pow(screenPoint.X - centerX, 2) + 
                        math.pow(screenPoint.Y - centerY, 2)
                    )
                    
                    if distanceFromCenter <= Settings.FOV and distance < nearestDistance then
                        nearestDistance = distance
                        nearestPlayer = player
                    end
                end
            end
        end
    end
    
    return nearestPlayer
end

-- Update target
local function UpdateTarget()
    if not Settings.CameraLockEnabled then
        Target = nil
        TargetHumanoid = nil
        TargetHumanoidRootPart = nil
        return
    end
    
    local newTarget = FindNearestTarget()
    
    if newTarget and newTarget.Character then
        Target = newTarget
        TargetHumanoid = newTarget.Character:FindFirstChild("Humanoid")
        TargetHumanoidRootPart = newTarget.Character:FindFirstChild("HumanoidRootPart")
    else
        Target = nil
        TargetHumanoid = nil
        TargetHumanoidRootPart = nil
    end
end

-- Update pathfinding
local function UpdatePathfinding()
    if not Settings.PathfindingEnabled or not TargetHumanoidRootPart or not HumanoidRootPart then
        PathfindingPath = nil
        CurrentWaypointIndex = 1
        return
    end
    
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 4
    })
    
    local success, errorMessage = pcall(function()
        path:ComputeAsync(HumanoidRootPart.Position, TargetHumanoidRootPart.Position)
    end)
    
    if success and path.Status == Enum.PathStatus.Success then
        PathfindingPath = path
        CurrentWaypointIndex = 1
    else
        PathfindingPath = nil
        CurrentWaypointIndex = 1
    end
end

-- Dodging movement
local function ApplyDodgingMovement()
    if not Settings.DodgingEnabled or not TargetHumanoidRootPart then
        return Vector3.new(0, 0, 0)
    end
    
    local currentTime = tick()
    local dodgeMovement = Vector3.new(0, 0, 0)
    
    -- Side to side movement
    if currentTime - LastDodgeChange > 0.5 + math.random() * 0.5 then
        DodgingDirection = -DodgingDirection
        LastDodgeChange = currentTime
    end
    
    -- Get right vector relative to target
    local toTarget = (TargetHumanoidRootPart.Position - HumanoidRootPart.Position)
    local rightVector = Camera.CFrame.RightVector
    
    -- Side to side dodging
    dodgeMovement = dodgeMovement + rightVector * DodgingDirection * Settings.DodgingSpeed * Settings.DodgingIntensity
    
    -- Random human-like movements
    RandomMovementTimer = RandomMovementTimer + (1/60)
    if RandomMovementTimer > 0.3 then
        RandomMovementTimer = 0
        -- Add small random movements
        local randomX = (math.random() - 0.5) * 2
        local randomZ = (math.random() - 0.5) * 2
        dodgeMovement = dodgeMovement + Vector3.new(randomX, 0, randomZ) * Settings.DodgingSpeed * 0.5
    end
    
    return dodgeMovement
end

-- Move to target using pathfinding
local function MoveToTarget()
    if not Settings.PathfindingEnabled or not TargetHumanoidRootPart or not HumanoidRootPart then
        return
    end
    
    -- Update pathfinding periodically
    local currentTime = tick()
    if currentTime - LastPathfindingUpdate > 1 then
        UpdatePathfinding()
        LastPathfindingUpdate = currentTime
    end
    
    local targetPosition = TargetHumanoidRootPart.Position
    local moveVector = Vector3.new(0, 0, 0)
    
    -- Use pathfinding if available
    if PathfindingPath and PathfindingPath.Status == Enum.PathStatus.Success then
        local waypoints = PathfindingPath:GetWaypoints()
        
        if #waypoints > 1 then
            -- Check if we've reached the current waypoint
            if CurrentWaypointIndex <= #waypoints then
                local currentWaypoint = waypoints[CurrentWaypointIndex]
                local distanceToWaypoint = (HumanoidRootPart.Position - currentWaypoint.Position).Magnitude
                
                if distanceToWaypoint < 4 then
                    CurrentWaypointIndex = CurrentWaypointIndex + 1
                end
                
                if CurrentWaypointIndex <= #waypoints then
                    targetPosition = waypoints[CurrentWaypointIndex].Position
                else
                    targetPosition = TargetHumanoidRootPart.Position
                end
            end
        end
    end
    
    -- Calculate direction to target
    local direction = (targetPosition - HumanoidRootPart.Position)
    direction = Vector3.new(direction.X, 0, direction.Z).Unit
    
    -- Apply walk speed
    moveVector = direction * Settings.WalkSpeed
    
    -- Add dodging movement if target is visible
    if TargetHumanoidRootPart then
        local dodgingMove = ApplyDodgingMovement()
        moveVector = moveVector + dodgingMove
    end
    
    -- Apply movement using CFrame
    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + moveVector * (1/60)
    
    -- Random jumping
    if math.random() < Settings.JumpProbability then
        Humanoid.Jump = true
    end
end

-- Camera lock function
local function LockCamera()
    if not Settings.CameraLockEnabled or not TargetHumanoidRootPart then
        return
    end
    
    local targetPosition = TargetHumanoidRootPart.Position
    
    -- Apply prediction
    if TargetHumanoid then
        local velocity = TargetHumanoidRootPart.AssemblyLinearVelocity
        targetPosition = targetPosition + Vector3.new(
            velocity.X * Settings.PredictionX,
            velocity.Y * Settings.PredictionY,
            velocity.Z * Settings.PredictionX
        )
    end
    
    -- Calculate camera direction
    local cameraPosition = Camera.CFrame.Position
    local direction = (targetPosition - cameraPosition)
    
    -- Smooth camera movement
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.lookAt(cameraPosition, targetPosition)
    
    local newCFrame = currentCFrame:Lerp(targetCFrame, Settings.SmoothnessX)
    Camera.CFrame = newCFrame
end

-- Auto reload function
local function AutoReload()
    if not Settings.AutoReload or not Settings.CameraLockEnabled then
        return
    end
    
    local currentTime = tick()
    if currentTime - LastReloadTime >= Settings.AutoReloadInterval then
        -- Simulate pressing R key
        pcall(function()
            local keyCode = Enum.KeyCode.R
            for _, connection in pairs(getconnections(UserInputService.InputBegan)) do
                pcall(function()
                    connection:Fire(keyCode, false, false)
                end)
            end
        end)
        
        LastReloadTime = currentTime
    end
end

-- Auto shooting control
local function UpdateShooting()
    if not Settings.CameraLockEnabled or not TargetHumanoid then
        if IsShooting then
            pcall(function()
                local inputObject = {
                    UserInputType = Enum.UserInputType.MouseButton1,
                    UserInputState = Enum.UserInputState.End
                }
                UserInputService.InputEnded:Fire(inputObject)
            end)
            IsShooting = false
            if ShootingConnection then
                ShootingConnection:Disconnect()
                ShootingConnection = nil
            end
        end
        return
    end
    
    local targetHP = TargetHumanoid.Health
    local shouldShoot = targetHP >= Settings.AutoStopShootingHP
    
    if shouldShoot and not IsShooting then
        IsShooting = true
        ShootingConnection = RunService.Heartbeat:Connect(function()
            if not Settings.CameraLockEnabled or not TargetHumanoid or TargetHumanoid.Health < Settings.AutoStopShootingHP then
                if ShootingConnection then
                    ShootingConnection:Disconnect()
                    ShootingConnection = nil
                end
                IsShooting = false
                return
            end
            
            pcall(function()
                local inputObject = {
                    UserInputType = Enum.UserInputType.MouseButton1,
                    UserInputState = Enum.UserInputState.Begin
                }
                UserInputService.InputBegan:Fire(inputObject)
            end)
        end)
    elseif not shouldShoot and IsShooting then
        if ShootingConnection then
            ShootingConnection:Disconnect()
            ShootingConnection = nil
        end
        pcall(function()
            local inputObject = {
                UserInputType = Enum.UserInputType.MouseButton1,
                UserInputState = Enum.UserInputState.End
            }
            UserInputService.InputEnded:Fire(inputObject)
        end)
        IsShooting = false
    end
end

-- Create UI Toggle Button
local function CreateUIToggleButton()
    if UIButton then
        UIButton:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UIToggleButton"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local button = Instance.new("TextButton")
    button.Name = "UIToggle"
    button.Size = UDim2.new(0, 50, 0, 50)
    button.Position = UDim2.new(1, -60, 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Text = "⚙"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 24
    button.Font = Enum.Font.GothamBold
    button.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        Settings.UIEnabled = not Settings.UIEnabled
        if MainUI then
            MainUI.Visible = Settings.UIEnabled
        end
    end)
    
    UIButton = button
end

-- Create UI
local function CreateUI()
    if MainUI then
        MainUI:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CameraLockUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 320, 0, 500)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = Settings.UIEnabled
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    title.BorderSizePixel = 0
    title.Text = "Camera Lock Settings"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    
    -- Camera Lock Toggle Button
    local cameraToggleButton = Instance.new("TextButton")
    cameraToggleButton.Name = "CameraToggleButton"
    cameraToggleButton.Size = UDim2.new(1, -20, 0, 40)
    cameraToggleButton.Position = UDim2.new(0, 10, 0, 50)
    cameraToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    cameraToggleButton.BorderSizePixel = 0
    cameraToggleButton.Text = "CAMERA LOCK: OFF"
    cameraToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cameraToggleButton.TextSize = 14
    cameraToggleButton.Font = Enum.Font.GothamBold
    cameraToggleButton.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = cameraToggleButton
    
    cameraToggleButton.MouseButton1Click:Connect(function()
        Settings.CameraLockEnabled = not Settings.CameraLockEnabled
        cameraToggleButton.Text = Settings.CameraLockEnabled and "CAMERA LOCK: ON" or "CAMERA LOCK: OFF"
        cameraToggleButton.BackgroundColor3 = Settings.CameraLockEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        
        if Settings.CameraLockEnabled then
            CreateFOVCircle()
        else
            if FOVCircle then
                FOVCircle.ScreenGui:Destroy()
                FOVCircle = nil
            end
            if ShootingConnection then
                ShootingConnection:Disconnect()
                ShootingConnection = nil
            end
            IsShooting = false
            Target = nil
            TargetHumanoid = nil
            TargetHumanoidRootPart = nil
        end
    end)
    
    -- Pathfinding Toggle Button
    local pathfindingToggleButton = Instance.new("TextButton")
    pathfindingToggleButton.Name = "PathfindingToggleButton"
    pathfindingToggleButton.Size = UDim2.new(1, -20, 0, 40)
    pathfindingToggleButton.Position = UDim2.new(0, 10, 0, 100)
    pathfindingToggleButton.BackgroundColor3 = Settings.PathfindingEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    pathfindingToggleButton.BorderSizePixel = 0
    pathfindingToggleButton.Text = Settings.PathfindingEnabled and "PATHFINDING: ON" or "PATHFINDING: OFF"
    pathfindingToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    pathfindingToggleButton.TextSize = 14
    pathfindingToggleButton.Font = Enum.Font.GothamBold
    pathfindingToggleButton.Parent = mainFrame
    
    local pathfindingCorner = Instance.new("UICorner")
    pathfindingCorner.CornerRadius = UDim.new(0, 6)
    pathfindingCorner.Parent = pathfindingToggleButton
    
    pathfindingToggleButton.MouseButton1Click:Connect(function()
        Settings.PathfindingEnabled = not Settings.PathfindingEnabled
        pathfindingToggleButton.Text = Settings.PathfindingEnabled and "PATHFINDING: ON" or "PATHFINDING: OFF"
        pathfindingToggleButton.BackgroundColor3 = Settings.PathfindingEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)
    
    -- Scrolling Frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -20, 1, -160)
    scrollFrame.Position = UDim2.new(0, 10, 0, 150)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = mainFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollFrame
    
    -- Settings UI Helper Functions
    local function CreateSlider(name, min, max, current, callback)
        local container = Instance.new("Frame")
        container.Name = name .. "Container"
        container.Size = UDim2.new(1, 0, 0, 60)
        container.BackgroundTransparency = 1
        container.Parent = scrollFrame
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = name .. ": " .. string.format("%.2f", current)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local slider = Instance.new("Frame")
        slider.Name = "Slider"
        slider.Size = UDim2.new(1, 0, 0, 6)
        slider.Position = UDim2.new(0, 0, 0, 25)
        slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        slider.BorderSizePixel = 0
        slider.Parent = container
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 3)
        sliderCorner.Parent = slider
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        fill.BorderSizePixel = 0
        fill.Parent = slider
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 3)
        fillCorner.Parent = fill
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.Parent = slider
        
        local isDragging = false
        button.MouseButton1Down:Connect(function()
            isDragging = true
            local connection
            connection = RunService.Heartbeat:Connect(function()
                if not isDragging then
                    connection:Disconnect()
                    return
                end
                local mousePos = UserInputService:GetMouseLocation()
                local sliderPos = slider.AbsolutePosition
                local sliderSize = slider.AbsoluteSize
                local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                local value = min + (max - min) * relativeX
                fill.Size = UDim2.new(relativeX, 0, 1, 0)
                label.Text = name .. ": " .. string.format("%.2f", value)
                callback(value)
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)
        end)
        
        return container
    end
    
    local function CreateToggle(name, current, callback)
        local container = Instance.new("Frame")
        container.Name = name .. "Container"
        container.Size = UDim2.new(1, 0, 0, 40)
        container.BackgroundTransparency = 1
        container.Parent = scrollFrame
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local toggle = Instance.new("TextButton")
        toggle.Name = "Toggle"
        toggle.Size = UDim2.new(0, 50, 0, 25)
        toggle.Position = UDim2.new(1, -50, 0.5, -12.5)
        toggle.BackgroundColor3 = current and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
        toggle.BorderSizePixel = 0
        toggle.Text = ""
        toggle.Parent = container
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 12)
        toggleCorner.Parent = toggle
        
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 20, 0, 20)
        indicator.Position = current and UDim2.new(1, -22.5, 0.5, -10) or UDim2.new(0, 2.5, 0.5, -10)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.BorderSizePixel = 0
        indicator.Parent = toggle
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, 10)
        indicatorCorner.Parent = indicator
        
        toggle.MouseButton1Click:Connect(function()
            current = not current
            toggle.BackgroundColor3 = current and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
            local tween = TweenService:Create(
                indicator,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = current and UDim2.new(1, -22.5, 0.5, -10) or UDim2.new(0, 2.5, 0.5, -10)}
            )
            tween:Play()
            callback(current)
        end)
        
        return container
    end
    
    -- Create all settings
    CreateSlider("Smoothness X", 0.01, 1, Settings.SmoothnessX, function(val)
        Settings.SmoothnessX = val
    end)
    
    CreateSlider("Smoothness Y", 0.01, 1, Settings.SmoothnessY, function(val)
        Settings.SmoothnessY = val
    end)
    
    CreateSlider("Prediction X", 0, 2, Settings.PredictionX, function(val)
        Settings.PredictionX = val
    end)
    
    CreateSlider("Prediction Y", 0, 2, Settings.PredictionY, function(val)
        Settings.PredictionY = val
    end)
    
    CreateSlider("FOV", 50, 200, Settings.FOV, function(val)
        Settings.FOV = val
        if FOVCircle then
            FOVCircle.Circle.Size = UDim2.new(0, val * 2, 0, val * 2)
            FOVCircle.Circle.Position = UDim2.new(0.5, -val, 0.5, -val)
        end
    end)
    
    CreateSlider("Walk Speed", 0, 300, Settings.WalkSpeed, function(val)
        Settings.WalkSpeed = val
    end)
    
    CreateSlider("Jump Probability", 0, 0.1, Settings.JumpProbability, function(val)
        Settings.JumpProbability = val
    end)
    
    CreateSlider("Dodging Speed", 0, 50, Settings.DodgingSpeed, function(val)
        Settings.DodgingSpeed = val
    end)
    
    CreateSlider("Dodging Intensity", 0, 10, Settings.DodgingIntensity, function(val)
        Settings.DodgingIntensity = val
    end)
    
    CreateSlider("Auto Reload Interval", 1, 5, Settings.AutoReloadInterval, function(val)
        Settings.AutoReloadInterval = val
    end)
    
    CreateSlider("Auto Stop Shooting HP", 0, 100, Settings.AutoStopShootingHP, function(val)
        Settings.AutoStopShootingHP = val
    end)
    
    CreateToggle("Auto Reload", Settings.AutoReload, function(val)
        Settings.AutoReload = val
    end)
    
    CreateToggle("Show FOV Circle", Settings.ShowFOVCircle, function(val)
        Settings.ShowFOVCircle = val
        if val and Settings.CameraLockEnabled then
            CreateFOVCircle()
        elseif FOVCircle then
            FOVCircle.ScreenGui:Destroy()
            FOVCircle = nil
        end
    end)
    
    CreateToggle("Dodging Mode", Settings.DodgingEnabled, function(val)
        Settings.DodgingEnabled = val
    end)
    
    -- Update scroll frame size
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)
    
    MainUI = mainFrame
end

-- Main update loop
RunService.Heartbeat:Connect(function()
    if Settings.CameraLockEnabled then
        UpdateTarget()
        if TargetHumanoidRootPart then
            LockCamera()
            UpdateShooting()
            AutoReload()
        end
    end
    
    if Settings.PathfindingEnabled and TargetHumanoidRootPart then
        MoveToTarget()
    end
end)

-- Initialize
CreateUIToggleButton()
CreateUI()

print("Camera Lock System Loaded!")
