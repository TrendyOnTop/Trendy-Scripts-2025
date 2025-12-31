-- Roblox Advanced Camera Lock System
-- Features: Smooth camera locking, prediction, FOV circle, pathfinding, auto-reload, auto-jump, dodging
-- Mobile Compatible UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local GuiService = game:GetService("GuiService")

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

-- Detect if mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local isTablet = UserInputService.TouchEnabled and UserInputService.KeyboardEnabled

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

-- Mobile UI sizing
local function GetUIScale()
    if isMobile then
        return math.min(Camera.ViewportSize.X / 1920, Camera.ViewportSize.Y / 1080) * 1.2
    elseif isTablet then
        return math.min(Camera.ViewportSize.X / 1920, Camera.ViewportSize.Y / 1080) * 1.1
    else
        return 1
    end
end

-- Create FOV Circle (Always visible when camera lock is enabled)
local function CreateFOVCircle()
    if FOVCircle then
        FOVCircle.ScreenGui:Destroy()
        FOVCircle = nil
    end
    
    if not Settings.CameraLockEnabled then
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
        while FOVCircle and Settings.CameraLockEnabled do
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

-- Mobile-friendly button click handler
local function ConnectButton(button, callback)
    button.MouseButton1Click:Connect(callback)
    if isMobile or isTablet then
        button.TouchTap:Connect(callback)
    end
end

-- Create UI Toggle Button (Mobile Compatible)
local function CreateUIToggleButton()
    if UIButton then
        UIButton.Parent:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UIToggleButton"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local buttonSize = isMobile and 60 or 50
    local button = Instance.new("TextButton")
    button.Name = "UIToggle"
    button.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    button.Position = UDim2.new(1, -(buttonSize + 10), 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Text = "⚙"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = isMobile and 28 or 24
    button.Font = Enum.Font.GothamBold
    button.Active = true
    button.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    ConnectButton(button, function()
        Settings.UIEnabled = not Settings.UIEnabled
        if MainUI then
            MainUI.Visible = Settings.UIEnabled
        end
    end)
    
    UIButton = button
end

-- Create UI (Mobile Compatible)
local function CreateUI()
    if MainUI then
        MainUI.Parent:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CameraLockUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local uiScale = GetUIScale()
    local baseWidth = isMobile and 350 or 320
    local baseHeight = isMobile and 550 or 500
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, baseWidth * uiScale, 0, baseHeight * uiScale)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = Settings.UIEnabled
    mainFrame.Active = true
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Drop shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/ImageSet/Shadow.png"
    shadow.ImageTransparency = 0.5
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, isMobile and 50 or 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Camera Lock Settings"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = isMobile and 20 or 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Camera Lock Toggle Button
    local buttonHeight = isMobile and 45 or 40
    local cameraToggleButton = Instance.new("TextButton")
    cameraToggleButton.Name = "CameraToggleButton"
    cameraToggleButton.Size = UDim2.new(1, -20, 0, buttonHeight)
    cameraToggleButton.Position = UDim2.new(0, 10, 0, titleBar.Size.Y.Offset + 10)
    cameraToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    cameraToggleButton.BorderSizePixel = 0
    cameraToggleButton.Text = "CAMERA LOCK: OFF"
    cameraToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cameraToggleButton.TextSize = isMobile and 16 or 14
    cameraToggleButton.Font = Enum.Font.GothamBold
    cameraToggleButton.Active = true
    cameraToggleButton.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = cameraToggleButton
    
    ConnectButton(cameraToggleButton, function()
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
    pathfindingToggleButton.Size = UDim2.new(1, -20, 0, buttonHeight)
    pathfindingToggleButton.Position = UDim2.new(0, 10, 0, titleBar.Size.Y.Offset + buttonHeight + 20)
    pathfindingToggleButton.BackgroundColor3 = Settings.PathfindingEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    pathfindingToggleButton.BorderSizePixel = 0
    pathfindingToggleButton.Text = Settings.PathfindingEnabled and "PATHFINDING: ON" or "PATHFINDING: OFF"
    pathfindingToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    pathfindingToggleButton.TextSize = isMobile and 16 or 14
    pathfindingToggleButton.Font = Enum.Font.GothamBold
    pathfindingToggleButton.Active = true
    pathfindingToggleButton.Parent = mainFrame
    
    local pathfindingCorner = Instance.new("UICorner")
    pathfindingCorner.CornerRadius = UDim.new(0, 8)
    pathfindingCorner.Parent = pathfindingToggleButton
    
    ConnectButton(pathfindingToggleButton, function()
        Settings.PathfindingEnabled = not Settings.PathfindingEnabled
        pathfindingToggleButton.Text = Settings.PathfindingEnabled and "PATHFINDING: ON" or "PATHFINDING: OFF"
        pathfindingToggleButton.BackgroundColor3 = Settings.PathfindingEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)
    
    -- Scrolling Frame (Mobile Compatible)
    local scrollStartY = titleBar.Size.Y.Offset + buttonHeight * 2 + 30
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -20, 1, -scrollStartY - 10)
    scrollFrame.Position = UDim2.new(0, 10, 0, scrollStartY)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = isMobile and 10 or 8
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ScrollingEnabled = true
    scrollFrame.Parent = mainFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, isMobile and 8 or 5)
    listLayout.Parent = scrollFrame
    
    -- Settings UI Helper Functions
    local function CreateSlider(name, min, max, current, callback)
        local container = Instance.new("Frame")
        container.Name = name .. "Container"
        container.Size = UDim2.new(1, 0, 0, isMobile and 70 or 60)
        container.BackgroundTransparency = 1
        container.Parent = scrollFrame
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, isMobile and 25 or 20)
        label.BackgroundTransparency = 1
        label.Text = name .. ": " .. string.format("%.2f", current)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = isMobile and 16 or 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local slider = Instance.new("Frame")
        slider.Name = "Slider"
        slider.Size = UDim2.new(1, 0, 0, isMobile and 8 or 6)
        slider.Position = UDim2.new(0, 0, 0, isMobile and 30 or 25)
        slider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        slider.BorderSizePixel = 0
        slider.Parent = container
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 4)
        sliderCorner.Parent = slider
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        fill.BorderSizePixel = 0
        fill.Parent = slider
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 4)
        fillCorner.Parent = fill
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.Active = true
        button.Parent = slider
        
        local isDragging = false
        local dragConnection = nil
        
        local function updateSlider(input)
            local sliderPos = slider.AbsolutePosition
            local sliderSize = slider.AbsoluteSize
            local inputPos = input.Position.X
            local relativeX = math.clamp((inputPos - sliderPos.X) / sliderSize.X, 0, 1)
            local value = min + (max - min) * relativeX
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            label.Text = name .. ": " .. string.format("%.2f", value)
            callback(value)
        end
        
        button.MouseButton1Down:Connect(function(input)
            isDragging = true
            updateSlider(input)
            dragConnection = RunService.Heartbeat:Connect(function()
                if not isDragging then
                    dragConnection:Disconnect()
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
        end)
        
        if isMobile or isTablet then
            button.TouchTap:Connect(function(input)
                isDragging = true
                updateSlider(input)
                dragConnection = RunService.Heartbeat:Connect(function()
                    if not isDragging then
                        dragConnection:Disconnect()
                        return
                    end
                    local touchPos = UserInputService:GetMouseLocation()
                    local sliderPos = slider.AbsolutePosition
                    local sliderSize = slider.AbsoluteSize
                    local relativeX = math.clamp((touchPos.X - sliderPos.X) / sliderSize.X, 0, 1)
                    local value = min + (max - min) * relativeX
                    fill.Size = UDim2.new(relativeX, 0, 1, 0)
                    label.Text = name .. ": " .. string.format("%.2f", value)
                    callback(value)
                end)
            end)
        end
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
                if dragConnection then
                    dragConnection:Disconnect()
                    dragConnection = nil
                end
            end
        end)
        
        return container
    end
    
    local function CreateToggle(name, current, callback)
        local container = Instance.new("Frame")
        container.Name = name .. "Container"
        container.Size = UDim2.new(1, 0, 0, isMobile and 45 or 40)
        container.BackgroundTransparency = 1
        container.Parent = scrollFrame
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = isMobile and 16 or 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local toggle = Instance.new("TextButton")
        toggle.Name = "Toggle"
        toggle.Size = UDim2.new(0, isMobile and 60 or 50, 0, isMobile and 30 or 25)
        toggle.Position = UDim2.new(1, -(isMobile and 60 or 50), 0.5, -(isMobile and 15 or 12.5))
        toggle.BackgroundColor3 = current and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 70)
        toggle.BorderSizePixel = 0
        toggle.Text = ""
        toggle.Active = true
        toggle.Parent = container
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 15)
        toggleCorner.Parent = toggle
        
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, isMobile and 24 or 20, 0, isMobile and 24 or 20)
        indicator.Position = current and UDim2.new(1, -(isMobile and 27 or 22.5), 0.5, -(isMobile and 12 or 10)) or UDim2.new(0, isMobile and 3 or 2.5, 0.5, -(isMobile and 12 or 10))
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.BorderSizePixel = 0
        indicator.Parent = toggle
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, 12)
        indicatorCorner.Parent = indicator
        
        ConnectButton(toggle, function()
            current = not current
            toggle.BackgroundColor3 = current and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 70)
            local tween = TweenService:Create(
                indicator,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = current and UDim2.new(1, -(isMobile and 27 or 22.5), 0.5, -(isMobile and 12 or 10)) or UDim2.new(0, isMobile and 3 or 2.5, 0.5, -(isMobile and 12 or 10))}
            )
            tween:Play()
            callback(current)
        end)
        
        return container
    end
    
    -- Create all settings (FOV always visible)
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
    
    CreateSlider("FOV Transparency", 0, 1, Settings.FOVCircleTransparency, function(val)
        Settings.FOVCircleTransparency = val
        if FOVCircle then
            FOVCircle.Stroke.Transparency = val
            FOVCircle.Circle.BackgroundTransparency = val + 0.3
            FOVCircle.Gradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, val),
                NumberSequenceKeypoint.new(0.5, val + 0.3),
                NumberSequenceKeypoint.new(1, val)
            })
        end
    end)
    
    CreateToggle("Auto Reload", Settings.AutoReload, function(val)
        Settings.AutoReload = val
    end)
    
    CreateToggle("Dodging Mode", Settings.DodgingEnabled, function(val)
        Settings.DodgingEnabled = val
    end)
    
    -- Update scroll frame size
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
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

print("Camera Lock System Loaded! Mobile Compatible: " .. tostring(isMobile))
