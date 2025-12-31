-- Roblox Advanced Camera Lock System
-- Features: Smooth camera locking, prediction, FOV circle, pathfinding, auto-reload, auto-jump, dodging
-- Mobile Compatible UI with Corner Toggle Buttons

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

-- Settings (All turned off by default - must be enabled manually)
local Settings = {
    CameraLockEnabled = false,
    PathfindingEnabled = false,
    UIEnabled = false,
    SmoothnessX = 0.15,
    SmoothnessY = 0.15,
    PredictionX = 0.5,
    PredictionY = 0.5,
    FOV = 100,
    WalkSpeed = 200,
    JumpProbability = 0.02,
    AutoReload = false,
    AutoReloadInterval = 2.3,
    AutoStopShootingHP = 10,
    FOVCircleColor = Color3.fromRGB(255, 0, 0),
    FOVCircleTransparency = 0.5,
    FOVCircleThickness = 2,
    DodgingEnabled = false,
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
local CornerButtons = {}
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

-- Update target (Sticks to current target, only switches if current is invalid)
local function UpdateTarget()
    if not Settings.CameraLockEnabled then
        Target = nil
        TargetHumanoid = nil
        TargetHumanoidRootPart = nil
        return
    end
    
    -- If we have a current target, check if it's still valid
    if Target and Target.Character then
        local humanoid = Target.Character:FindFirstChild("Humanoid")
        local rootPart = Target.Character:FindFirstChild("HumanoidRootPart")
        
        -- Check if target is still alive and valid
        if humanoid and rootPart and humanoid.Health > 0 then
            -- Check if target is still within reasonable range (not too far)
            local distance = (HumanoidRootPart.Position - rootPart.Position).Magnitude
            if distance < 500 then -- Max lock distance
                TargetHumanoid = humanoid
                TargetHumanoidRootPart = rootPart
                return -- Keep current target
            end
        end
    end
    
    -- Current target is invalid or too far, find new one
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

-- Check if target is visible on screen
local function IsTargetVisible()
    if not TargetHumanoidRootPart then return false end
    
    local screenPoint, onScreen = Camera:WorldToViewportPoint(TargetHumanoidRootPart.Position)
    return onScreen
end

-- Dodging movement - Improved with approach then strafe
local function ApplyDodgingMovement()
    if not Settings.DodgingEnabled or not TargetHumanoidRootPart then
        return Vector3.new(0, 0, 0)
    end
    
    local targetVisible = IsTargetVisible()
    local distanceToTarget = (HumanoidRootPart.Position - TargetHumanoidRootPart.Position).Magnitude
    
    -- If target is not visible or too far, approach first
    if not targetVisible or distanceToTarget > 50 then
        return Vector3.new(0, 0, 0) -- No dodging, just approach
    end
    
    -- Target is visible and close - start strafing with human movements
    local currentTime = tick()
    local dodgeMovement = Vector3.new(0, 0, 0)
    
    -- Side to side strafing movement
    if currentTime - LastDodgeChange > 0.3 + math.random() * 0.4 then
        DodgingDirection = -DodgingDirection
        LastDodgeChange = currentTime
    end
    
    -- Get right vector relative to target
    local toTarget = (TargetHumanoidRootPart.Position - HumanoidRootPart.Position)
    local rightVector = Camera.CFrame.RightVector
    
    -- Side to side strafing
    dodgeMovement = dodgeMovement + rightVector * DodgingDirection * Settings.DodgingSpeed * Settings.DodgingIntensity
    
    -- Random human-like movements (forward/back, slight variations)
    RandomMovementTimer = RandomMovementTimer + (1/60)
    if RandomMovementTimer > 0.2 + math.random() * 0.3 then
        RandomMovementTimer = 0
        -- Add small random movements
        local randomX = (math.random() - 0.5) * 1.5
        local randomZ = (math.random() - 0.5) * 1.5
        dodgeMovement = dodgeMovement + Vector3.new(randomX, 0, randomZ) * Settings.DodgingSpeed * 0.4
    end
    
    return dodgeMovement
end

-- Move to target using pathfinding with approach then strafe behavior
local function MoveToTarget()
    if not Settings.PathfindingEnabled or not TargetHumanoidRootPart or not HumanoidRootPart then
        return
    end
    
    -- Auto-shoot when pathfinding is enabled and target is visible (only if camera lock shooting is not active)
    if Settings.PathfindingEnabled and TargetHumanoid and TargetHumanoid.Health > Settings.AutoStopShootingHP and not Settings.CameraLockEnabled then
        if not IsShooting then
            IsShooting = true
            if ShootingConnection then
                ShootingConnection:Disconnect()
            end
            ShootingConnection = RunService.Heartbeat:Connect(function()
                if not Settings.PathfindingEnabled or Settings.CameraLockEnabled or not TargetHumanoid or TargetHumanoid.Health < Settings.AutoStopShootingHP then
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
        end
    elseif not Settings.PathfindingEnabled and IsShooting and not Settings.CameraLockEnabled then
        -- Stop shooting if pathfinding is disabled
        if ShootingConnection then
            ShootingConnection:Disconnect()
            ShootingConnection = nil
        end
        IsShooting = false
    end
    
    -- Update pathfinding periodically
    local currentTime = tick()
    if currentTime - LastPathfindingUpdate > 1 then
        UpdatePathfinding()
        LastPathfindingUpdate = currentTime
    end
    
    local targetPosition = TargetHumanoidRootPart.Position
    local moveVector = Vector3.new(0, 0, 0)
    local targetVisible = IsTargetVisible()
    local distanceToTarget = (HumanoidRootPart.Position - TargetHumanoidRootPart.Position).Magnitude
    
    -- Use pathfinding if available and target is not visible or far away
    if PathfindingPath and PathfindingPath.Status == Enum.PathStatus.Success and (not targetVisible or distanceToTarget > 30) then
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
    
    -- If target is visible and close, prioritize strafing over approaching
    if targetVisible and distanceToTarget < 50 then
        -- Strafe mode - move side to side with human movements
        local dodgingMove = ApplyDodgingMovement()
        moveVector = dodgingMove
        
        -- Add slight forward movement to maintain distance
        local forwardComponent = direction * Settings.WalkSpeed * 0.3
        moveVector = moveVector + forwardComponent
        
        -- More frequent jumping when strafing
        if math.random() < Settings.JumpProbability * 2 then
            Humanoid.Jump = true
        end
    else
        -- Approach mode - run directly to target
        moveVector = direction * Settings.WalkSpeed
        
        -- Add dodging movement if enabled (but less when approaching)
        if Settings.DodgingEnabled then
            local dodgingMove = ApplyDodgingMovement()
            moveVector = moveVector + dodgingMove * 0.5
        end
        
        -- Random jumping while approaching
        if math.random() < Settings.JumpProbability then
            Humanoid.Jump = true
        end
    end
    
    -- Apply movement using CFrame
    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + moveVector * (1/60)
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

-- Create Center Toggle Buttons (Completely Fixed Version)
local function CreateCornerButtons()
    -- Clean up old buttons
    for _, btn in pairs(CornerButtons) do
        if btn and btn.Parent then
            btn.Parent:Destroy()
        end
    end
    CornerButtons = {}
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CornerButtons"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local buttonSize = isMobile and 80 or 70
    local buttonSpacing = 20
    
    -- Button 1: Camera Lock Toggle (Center Left) - FIXED VERSION
    local btn1 = Instance.new("TextButton")
    btn1.Name = "CameraLockToggle"
    btn1.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    btn1.Position = UDim2.new(0.5, -(buttonSize + buttonSpacing/2), 0.5, -buttonSize/2)
    btn1.BackgroundColor3 = Settings.CameraLockEnabled and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 0, 0)
    btn1.BackgroundTransparency = Settings.CameraLockEnabled and 0.3 or 0.5
    btn1.BorderSizePixel = 2
    btn1.BorderColor3 = Color3.fromRGB(255, 255, 0)
    btn1.Text = Settings.CameraLockEnabled and "🔒\nLOCKED" or "🔓\nUNLOCKED"
    btn1.TextColor3 = Color3.fromRGB(255, 255, 0)
    btn1.TextSize = isMobile and 16 or 14
    btn1.Font = Enum.Font.GothamBold
    btn1.TextWrapped = true
    btn1.Active = true
    btn1.Parent = screenGui
    
    local corner1 = Instance.new("UICorner")
    corner1.CornerRadius = UDim.new(0, 12)
    corner1.Parent = btn1
    
    -- Camera lock toggle function - SIMPLE AND DIRECT
    local function toggleCameraLock()
        print("Camera Lock Toggle Clicked! Current state:", Settings.CameraLockEnabled)
        Settings.CameraLockEnabled = not Settings.CameraLockEnabled
        print("New state:", Settings.CameraLockEnabled)
        
        -- Update button appearance immediately
        btn1.Text = Settings.CameraLockEnabled and "🔒\nLOCKED" or "🔓\nUNLOCKED"
        btn1.BackgroundColor3 = Settings.CameraLockEnabled and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 0, 0)
        btn1.BackgroundTransparency = Settings.CameraLockEnabled and 0.3 or 0.5
        
        if Settings.CameraLockEnabled then
            print("Enabling camera lock...")
            CreateFOVCircle()
        else
            print("Disabling camera lock...")
            -- Clean up when disabling
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
    end
    
    -- Simple drag handling - separate from clicks
    local btn1Dragging = false
    local btn1DragStart = nil
    local btn1StartPos = nil
    
    btn1.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btn1DragStart = input.Position
            btn1StartPos = btn1.Position
            btn1Dragging = false
            
            local dragConnection
            dragConnection = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput == input and btn1DragStart then
                    local moved = (moveInput.Position - btn1DragStart).Magnitude
                    if moved > 20 then
                        btn1Dragging = true
                        local delta = moveInput.Position - btn1DragStart
                        btn1.Position = UDim2.new(
                            btn1StartPos.X.Scale,
                            btn1StartPos.X.Offset + delta.X,
                            btn1StartPos.Y.Scale,
                            btn1StartPos.Y.Offset + delta.Y
                        )
                    end
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragConnection:Disconnect()
                    if not btn1Dragging then
                        -- It was a click, toggle camera lock
                        toggleCameraLock()
                    end
                    btn1Dragging = false
                    btn1DragStart = nil
                end
            end)
        end
    end)
    
    -- Button 2: Settings UI Toggle (Center Right) - FIXED VERSION
    local btn2 = Instance.new("TextButton")
    btn2.Name = "UIToggle"
    btn2.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    btn2.Position = UDim2.new(0.5, buttonSpacing/2, 0.5, -buttonSize/2)
    btn2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn2.BackgroundTransparency = 0.5
    btn2.BorderSizePixel = 2
    btn2.BorderColor3 = Color3.fromRGB(255, 255, 0)
    btn2.Text = Settings.UIEnabled and "⚙\nCLOSE" or "⚙\nSETTINGS"
    btn2.TextColor3 = Color3.fromRGB(255, 255, 0)
    btn2.TextSize = isMobile and 16 or 14
    btn2.Font = Enum.Font.GothamBold
    btn2.TextWrapped = true
    btn2.Active = true
    btn2.Parent = screenGui
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 12)
    corner2.Parent = btn2
    
    -- Settings toggle function - SIMPLE AND DIRECT
    local function toggleSettings()
        Settings.UIEnabled = not Settings.UIEnabled
        
        -- Find and update MainUI visibility
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local uiGui = playerGui:FindFirstChild("CameraLockUI")
        if uiGui then
            local mainFrame = uiGui:FindFirstChild("MainFrame")
            if mainFrame then
                mainFrame.Visible = Settings.UIEnabled
            end
        end
        
        -- Update button text
        btn2.Text = Settings.UIEnabled and "⚙\nCLOSE" or "⚙\nSETTINGS"
    end
    
    -- Simple drag handling - separate from clicks
    local btn2Dragging = false
    local btn2DragStart = nil
    local btn2StartPos = nil
    
    btn2.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btn2DragStart = input.Position
            btn2StartPos = btn2.Position
            btn2Dragging = false
            
            local dragConnection
            dragConnection = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput == input and btn2DragStart then
                    local moved = (moveInput.Position - btn2DragStart).Magnitude
                    if moved > 20 then
                        btn2Dragging = true
                        local delta = moveInput.Position - btn2DragStart
                        btn2.Position = UDim2.new(
                            btn2StartPos.X.Scale,
                            btn2StartPos.X.Offset + delta.X,
                            btn2StartPos.Y.Scale,
                            btn2StartPos.Y.Offset + delta.Y
                        )
                    end
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragConnection:Disconnect()
                    if not btn2Dragging then
                        -- It was a click, toggle settings
                        toggleSettings()
                    end
                    btn2Dragging = false
                    btn2DragStart = nil
                end
            end)
        end
    end)
    
    CornerButtons = {btn1, btn2}
end

-- Create UI (Bigger and Mobile Compatible)
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
    -- Much wider UI
    local baseWidth = isMobile and 750 or 700
    local baseHeight = isMobile and 650 or 600
    
    -- Main Frame (Black/Yellow theme with transparency)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, baseWidth * uiScale, 0, baseHeight * uiScale)
    mainFrame.Position = UDim2.new(0.5, -(baseWidth * uiScale / 2), 0.5, -(baseHeight * uiScale / 2))
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Black
    mainFrame.BackgroundTransparency = 0.2 -- Transparent
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 0) -- Yellow border
    mainFrame.Visible = Settings.UIEnabled or false
    mainFrame.Active = true
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
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
    
    -- Title Bar (Draggable) - Yellow theme with transparency
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, isMobile and 55 or 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow
    titleBar.BackgroundTransparency = 0.3 -- Transparent
    titleBar.BorderSizePixel = 0
    titleBar.Active = true
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🎯 Camera Lock Settings"
    title.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow text
    title.TextSize = isMobile and 22 or 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Make title bar draggable (moves the whole UI)
    local draggingUI = false
    local dragInputUI = nil
    local dragStartUI = nil
    local startPosUI = nil
    
    local function updateUIPosition(input)
        if not dragStartUI then return end
        local delta = input.Position - dragStartUI
        local newPos = UDim2.new(
            startPosUI.X.Scale,
            startPosUI.X.Offset + delta.X,
            startPosUI.Y.Scale,
            startPosUI.Y.Offset + delta.Y
        )
        mainFrame.Position = newPos
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStartUI = input.Position
            startPosUI = mainFrame.Position
            draggingUI = false
            
            local moveConnection
            moveConnection = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput == input and dragStartUI then
                    local moved = (moveInput.Position - dragStartUI).Magnitude
                    if moved > 5 then
                        draggingUI = true
                        updateUIPosition(moveInput)
                    end
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    moveConnection:Disconnect()
                    draggingUI = false
                    dragStartUI = nil
                end
            end)
        end
    end)
    
    -- Scrolling Frame (Bigger)
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -20, 1, -titleBar.Size.Y.Offset - 20)
    scrollFrame.Position = UDim2.new(0, 10, 0, titleBar.Size.Y.Offset + 10)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = isMobile and 12 or 10
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 0) -- Yellow scrollbar
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ScrollingEnabled = true
    scrollFrame.Parent = mainFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, isMobile and 4 or 3)
    listLayout.Parent = scrollFrame
    
    -- Create section divider/box with collapse functionality
    local function CreateSection(title)
        local isCollapsed = false
        local sectionContainer = Instance.new("Frame")
        sectionContainer.Name = title .. "Section"
        sectionContainer.Size = UDim2.new(1, 0, 0, 0) -- Height will be auto
        sectionContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
        sectionContainer.BackgroundTransparency = 0.4 -- Transparent
        sectionContainer.BorderSizePixel = 2
        sectionContainer.BorderColor3 = Color3.fromRGB(255, 255, 0) -- Yellow border
        sectionContainer.Parent = scrollFrame
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 10)
        sectionCorner.Parent = sectionContainer
        
        -- Section header with collapse button
        local header = Instance.new("Frame")
        header.Name = "Header"
        header.Size = UDim2.new(1, 0, 0, isMobile and 32 or 28)
        header.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow header
        header.BackgroundTransparency = 0.3 -- Transparent
        header.BorderSizePixel = 0
        header.Parent = sectionContainer
        
        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 10)
        headerCorner.Parent = header
        
        -- Collapse button (arrow)
        local collapseButton = Instance.new("TextButton")
        collapseButton.Name = "CollapseButton"
        collapseButton.Size = UDim2.new(0, isMobile and 28 or 24, 0, isMobile and 28 or 24)
        collapseButton.Position = UDim2.new(0, 5, 0.5, -(isMobile and 14 or 12))
        collapseButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        collapseButton.BackgroundTransparency = 0.5
        collapseButton.BorderSizePixel = 0
        collapseButton.Text = "▼"
        collapseButton.TextColor3 = Color3.fromRGB(255, 255, 0)
        collapseButton.TextSize = isMobile and 14 or 12
        collapseButton.Font = Enum.Font.GothamBold
        collapseButton.Active = true
        collapseButton.Parent = header
        
        local collapseCorner = Instance.new("UICorner")
        collapseCorner.CornerRadius = UDim.new(0, 6)
        collapseCorner.Parent = collapseButton
        
        -- Divider line under header
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.Size = UDim2.new(1, -10, 0, 2)
        divider.Position = UDim2.new(0, 5, 1, -2)
        divider.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow divider
        divider.BackgroundTransparency = 0.5 -- Transparent
        divider.BorderSizePixel = 0
        divider.Parent = header
        
        local headerLabel = Instance.new("TextLabel")
        headerLabel.Name = "Title"
        headerLabel.Size = UDim2.new(1, -(isMobile and 40 or 35), 1, 0)
        headerLabel.Position = UDim2.new(0, isMobile and 35 or 30, 0, 0)
        headerLabel.BackgroundTransparency = 1
        headerLabel.Text = title
        headerLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow text
        headerLabel.TextSize = isMobile and 15 or 14
        headerLabel.Font = Enum.Font.GothamBold
        headerLabel.TextXAlignment = Enum.TextXAlignment.Left
        headerLabel.Parent = header
        
        -- Content frame with padding
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = "Content"
        contentFrame.Size = UDim2.new(1, -16, 0, 0)
        contentFrame.Position = UDim2.new(0, 8, 0, header.Size.Y.Offset + 5)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Visible = true
        contentFrame.Parent = sectionContainer
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, isMobile and 4 or 3)
        contentLayout.Parent = contentFrame
        
        -- Toggle collapse function
        local function toggleCollapse()
            isCollapsed = not isCollapsed
            contentFrame.Visible = not isCollapsed
            collapseButton.Text = isCollapsed and "▶" or "▼"
            
            if isCollapsed then
                sectionContainer.Size = UDim2.new(1, 0, 0, header.Size.Y.Offset)
            else
                sectionContainer.Size = UDim2.new(1, 0, 0, header.Size.Y.Offset + contentLayout.AbsoluteContentSize.Y + 15)
            end
        end
        
        -- Collapse button click handlers
        collapseButton.MouseButton1Click:Connect(toggleCollapse)
        collapseButton.Activated:Connect(toggleCollapse)
        if isMobile or isTablet then
            collapseButton.TouchTap:Connect(toggleCollapse)
        end
        
        -- Update section height when content changes
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if not isCollapsed then
                sectionContainer.Size = UDim2.new(1, 0, 0, header.Size.Y.Offset + contentLayout.AbsoluteContentSize.Y + 15)
            end
        end)
        
        return contentFrame, sectionContainer
    end
    
    -- Settings UI Helper Functions
    local function CreateSlider(name, min, max, current, callback, parent)
        local container = Instance.new("Frame")
        container.Name = name .. "Container"
        container.Size = UDim2.new(1, 0, 0, isMobile and 38 or 32)
        container.BackgroundTransparency = 1
        container.Parent = parent or scrollFrame
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(0.35, 0, 0, isMobile and 16 or 14)
        label.BackgroundTransparency = 1
        label.Text = name .. ":"
        label.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow text
        label.TextSize = isMobile and 12 or 11
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "ValueLabel"
        valueLabel.Size = UDim2.new(0, 50, 0, isMobile and 16 or 14)
        valueLabel.Position = UDim2.new(0.37, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = string.format("%.2f", current)
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 100) -- Light yellow
        valueLabel.TextSize = isMobile and 12 or 11
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left
        valueLabel.Parent = container
        
        local slider = Instance.new("Frame")
        slider.Name = "Slider"
        slider.Size = UDim2.new(0.6, 0, 0, isMobile and 6 or 5)
        slider.Position = UDim2.new(0.37, 0, 0, isMobile and 18 or 16)
        slider.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
        slider.BackgroundTransparency = 0.5 -- Transparent
        slider.BorderSizePixel = 0
        slider.Parent = container
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 5)
        sliderCorner.Parent = slider
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow fill
        fill.BackgroundTransparency = 0.2 -- Slightly transparent
        fill.BorderSizePixel = 0
        fill.Parent = slider
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 5)
        fillCorner.Parent = fill
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.Active = true
        button.Parent = slider
        
        local isDragging = false
        local dragConnection = nil
        
        -- Update slider value function - FIXED for mobile touch
        local function updateSliderValue(inputPosition)
            local sliderPos = slider.AbsolutePosition
            local sliderSize = slider.AbsoluteSize
            local relativeX = math.clamp((inputPosition.X - sliderPos.X) / sliderSize.X, 0, 1)
            local value = min + (max - min) * relativeX
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            valueLabel.Text = string.format("%.2f", value)
            callback(value)
        end
        
        -- Mouse/Touch input handling - FIXED VERSION
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                updateSliderValue(input.Position)
                
                -- Continuous update while dragging
                if dragConnection then
                    dragConnection:Disconnect()
                end
                dragConnection = RunService.Heartbeat:Connect(function()
                    if not isDragging then
                        if dragConnection then
                            dragConnection:Disconnect()
                            dragConnection = nil
                        end
                        return
                    end
                    
                    -- Get current input position
                    local currentInput = UserInputService:GetMouseLocation()
                    updateSliderValue(currentInput)
                end)
            end
        end)
        
        -- Stop dragging when input ends
        UserInputService.InputEnded:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
                isDragging = false
                if dragConnection then
                    dragConnection:Disconnect()
                    dragConnection = nil
                end
            end
        end)
        
        -- Also handle input changed for better mobile support
        UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSliderValue(input.Position)
            end
        end)
        
        return container
    end
    
    local function CreateToggle(name, settingKey, callback, parent)
        local current = Settings[settingKey]
        local container = Instance.new("Frame")
        container.Name = name .. "Container"
        container.Size = UDim2.new(1, 0, 0, isMobile and 28 or 24)
        container.BackgroundTransparency = 1
        container.Parent = parent or scrollFrame
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow text
        label.TextSize = isMobile and 12 or 11
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local toggle = Instance.new("TextButton")
        toggle.Name = "Toggle"
        toggle.Size = UDim2.new(0, isMobile and 42 or 38, 0, isMobile and 20 or 18)
        toggle.Position = UDim2.new(1, -(isMobile and 42 or 38), 0.5, -(isMobile and 10 or 9))
        toggle.BackgroundColor3 = current and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 0, 0) -- Yellow when on, black when off
        toggle.BackgroundTransparency = current and 0.3 or 0.5 -- More transparent when off
        toggle.BorderSizePixel = 0
        toggle.Text = ""
        toggle.Active = true
        toggle.Parent = container
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 10)
        toggleCorner.Parent = toggle
        
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, isMobile and 16 or 14, 0, isMobile and 16 or 14)
        indicator.Position = current and UDim2.new(1, -(isMobile and 18 or 16), 0.5, -(isMobile and 8 or 7)) or UDim2.new(0, isMobile and 2 or 2, 0.5, -(isMobile and 8 or 7))
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow indicator
        indicator.BorderSizePixel = 0
        indicator.Parent = toggle
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, 8)
        indicatorCorner.Parent = indicator
        
            -- Toggle function - FIXED VERSION
        local function toggleSwitch()
            local currentValue = Settings[settingKey]
            local newValue = not currentValue
            
            print("Toggling", name, "from", currentValue, "to", newValue)
            
            -- Update settings immediately
            Settings[settingKey] = newValue
            
            -- Update visual appearance
            toggle.BackgroundColor3 = newValue and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 0, 0)
            toggle.BackgroundTransparency = newValue and 0.3 or 0.5
            
            -- Animate indicator
            local tween = TweenService:Create(
                indicator,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = newValue and UDim2.new(1, -(isMobile and 18 or 16), 0.5, -(isMobile and 8 or 7)) or UDim2.new(0, isMobile and 2 or 2, 0.5, -(isMobile and 8 or 7))}
            )
            tween:Play()
            
            -- Call callback if provided
            if callback then
                callback(newValue)
            end
        end
        
        -- Click handlers - Multiple methods for reliability
        toggle.MouseButton1Click:Connect(toggleSwitch)
        toggle.Activated:Connect(toggleSwitch)
        
        if isMobile or isTablet then
            toggle.TouchTap:Connect(toggleSwitch)
        end
        
        return container
    end
    
    -- Create text box input
    local function CreateTextBox(name, current, callback, placeholder, parent)
        local container = Instance.new("Frame")
        container.Name = name .. "Container"
        container.Size = UDim2.new(1, 0, 0, isMobile and 28 or 24)
        container.BackgroundTransparency = 1
        container.Parent = parent or scrollFrame
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name .. ":"
        label.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow text
        label.TextSize = isMobile and 12 or 11
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local textBox = Instance.new("TextBox")
        textBox.Name = "TextBox"
        textBox.Size = UDim2.new(0, isMobile and 100 or 90, 0, isMobile and 22 or 20)
        textBox.Position = UDim2.new(0.45, 0, 0.5, -(isMobile and 11 or 10))
        textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
        textBox.BackgroundTransparency = 0.5 -- Transparent
        textBox.BorderSizePixel = 0
        textBox.Text = tostring(current)
        textBox.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow text
        textBox.TextSize = isMobile and 12 or 11
        textBox.Font = Enum.Font.Gotham
        textBox.PlaceholderText = placeholder or "Enter value"
        textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        textBox.ClearTextOnFocus = false
        textBox.Parent = container
        
        local textBoxCorner = Instance.new("UICorner")
        textBoxCorner.CornerRadius = UDim.new(0, 5)
        textBoxCorner.Parent = textBox
        
        textBox.FocusLost:Connect(function(enterPressed)
            local numValue = tonumber(textBox.Text)
            if numValue then
                callback(numValue)
                textBox.Text = tostring(numValue) -- Update with clamped value
            else
                textBox.Text = tostring(current)
            end
        end)
        
        return container
    end
    
    -- Create all settings organized into sections
    
    -- Section 1: Camera Lock (Camera Lock toggle, Smoothness, Prediction)
    local camLockSection, camLockBox = CreateSection("Camera Lock")
    
    CreateToggle("Camera Lock", "CameraLockEnabled", function(val)
        Settings.CameraLockEnabled = val -- Ensure it's set
        
        if val then
            CreateFOVCircle()
        else
            -- Clean up when disabling
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
        
        -- Update center button (btn1) if it exists
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local cornerGui = playerGui:FindFirstChild("CornerButtons")
        if cornerGui then
            local centerBtn = cornerGui:FindFirstChild("CameraLockToggle")
            if centerBtn then
                centerBtn.Text = val and "🔒\nLOCKED" or "🔓\nUNLOCKED"
                centerBtn.BackgroundColor3 = val and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 0, 0)
                centerBtn.BackgroundTransparency = val and 0.3 or 0.5
            end
        end
    end, camLockSection)
    
    CreateSlider("Smoothness X", 0.01, 1, Settings.SmoothnessX, function(val)
        Settings.SmoothnessX = val
    end, camLockSection)
    
    CreateSlider("Smoothness Y", 0.01, 1, Settings.SmoothnessY, function(val)
        Settings.SmoothnessY = val
    end, camLockSection)
    
    CreateSlider("Prediction X", 0, 2, Settings.PredictionX, function(val)
        Settings.PredictionX = val
    end, camLockSection)
    
    CreateSlider("Prediction Y", 0, 2, Settings.PredictionY, function(val)
        Settings.PredictionY = val
    end, camLockSection)
    
    -- Section 2: FOV Settings
    local fovSection, fovBox = CreateSection("FOV Settings")
    
    CreateSlider("FOV", 50, 200, Settings.FOV, function(val)
        Settings.FOV = val
        if FOVCircle then
            FOVCircle.Circle.Size = UDim2.new(0, val * 2, 0, val * 2)
            FOVCircle.Circle.Position = UDim2.new(0.5, -val, 0.5, -val)
        end
    end, fovSection)
    
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
    end, fovSection)
    
    -- Section 3: Movement
    local movementSection, movementBox = CreateSection("Movement")
    
    CreateToggle("Pathfinding", "PathfindingEnabled", function(val)
        -- Pathfinding toggle works automatically
    end, movementSection)
    
    CreateTextBox("Walk Speed", Settings.WalkSpeed, function(val)
        Settings.WalkSpeed = math.clamp(val, 0, 300)
    end, "0-300", movementSection)
    
    CreateTextBox("Jump Probability", Settings.JumpProbability, function(val)
        Settings.JumpProbability = math.clamp(val, 0, 0.1)
    end, "0-0.1", movementSection)
    
    -- Section 4: Combat
    local combatSection, combatBox = CreateSection("Combat")
    
    CreateToggle("Auto Reload", "AutoReload", function(val)
        -- Auto reload toggle works automatically
    end, combatSection)
    
    CreateTextBox("Reload Interval", Settings.AutoReloadInterval, function(val)
        Settings.AutoReloadInterval = math.clamp(val, 1, 5)
    end, "1-5", combatSection)
    
    CreateTextBox("Stop Shooting HP", Settings.AutoStopShootingHP, function(val)
        Settings.AutoStopShootingHP = math.clamp(val, 0, 100)
    end, "0-100", combatSection)
    
    -- Section 5: Dodging
    local dodgingSection, dodgingBox = CreateSection("Dodging")
    
    CreateToggle("Dodging Mode", "DodgingEnabled", function(val)
        -- Dodging toggle works automatically
    end, dodgingSection)
    
    CreateTextBox("Dodging Speed", Settings.DodgingSpeed, function(val)
        Settings.DodgingSpeed = math.clamp(val, 0, 50)
    end, "0-50", dodgingSection)
    
    CreateTextBox("Dodging Intensity", Settings.DodgingIntensity, function(val)
        Settings.DodgingIntensity = math.clamp(val, 0, 10)
    end, "0-10", dodgingSection)
    
    -- Update scroll frame size
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end)
    
    MainUI = mainFrame
end

-- Main update loop - FIXED to prevent camera lock when disabled
RunService.Heartbeat:Connect(function()
    if Settings.CameraLockEnabled then
        UpdateTarget() -- Automatically locks onto nearest target
        if TargetHumanoidRootPart then
            LockCamera()
            UpdateShooting()
            AutoReload()
        end
    else
        -- When camera lock is disabled, clear target and stop shooting
        if Target then
            Target = nil
            TargetHumanoid = nil
            TargetHumanoidRootPart = nil
        end
        if IsShooting then
            if ShootingConnection then
                ShootingConnection:Disconnect()
                ShootingConnection = nil
            end
            IsShooting = false
        end
    end
    
    -- Pathfinding runs independently (only if enabled and has target)
    if Settings.PathfindingEnabled and TargetHumanoidRootPart and Settings.CameraLockEnabled then
        MoveToTarget()
    end
end)

-- Initialize
CreateCornerButtons()
CreateUI()

print("Camera Lock System Loaded! Mobile Compatible: " .. tostring(isMobile))
print("Center Toggle Buttons (Draggable): Left (Camera Lock), Right (Settings)")
print("All settings are OFF by default - enable manually through buttons or settings panel")
