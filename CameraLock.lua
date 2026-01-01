-- Roblox Advanced Camera Lock System - FIXED VERSION
-- Features: Smooth camera locking, prediction, FOV circle, pathfinding, auto-reload, auto-jump, dodging, tabs, collapsible sections

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Detect if mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local isTablet = UserInputService.TouchEnabled and UserInputService.KeyboardEnabled

-- Settings
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
    FOVCircleTransparency = 0.3,
    FOVCircleThickness = 3,
    DodgingEnabled = false,
    DodgingSpeed = 16,
    DodgingIntensity = 5,
    JumpPower = 50
}

-- Walk Speed Settings
if not getgenv().walkSpeedSettings then
    getgenv().walkSpeedSettings = {
        WalkSpeed = {
            Enabled = true,
            Speed = 300,
        },
        Activation = {
            WalkSpeedToggleKey = "T",
        }
    }
end

-- State variables
local Character = nil
local Humanoid = nil
local HumanoidRootPart = nil
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
local isSpeedEnabled = false
local defaultSpeed = 16
local speedConnection = nil

-- Initialize character references
local function InitializeCharacter()
    if LocalPlayer.Character then
        Character = LocalPlayer.Character
        Humanoid = Character:WaitForChild("Humanoid", 10)
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 10)
        
        if Humanoid and HumanoidRootPart then
            if Humanoid.UseJumpPower then
                Humanoid.JumpPower = Settings.JumpPower
            end
            defaultSpeed = Humanoid.WalkSpeed
            return true
        end
    end
    return false
end

-- Walk Speed System
local function updateSpeed()
    if not Character or not Humanoid then return end
    
    -- Don't override if pathfinding is managing walkspeed
    if Settings.PathfindingEnabled then
        return
    end
    
    if isSpeedEnabled and getgenv().walkSpeedSettings.WalkSpeed.Enabled then
        Humanoid.WalkSpeed = getgenv().walkSpeedSettings.WalkSpeed.Speed
    elseif not isSpeedEnabled then
        Humanoid.WalkSpeed = defaultSpeed
    end
end

-- Handle character respawning
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid", 10)
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart", 10)
    
    if Humanoid and HumanoidRootPart then
        if Humanoid.UseJumpPower then
            Humanoid.JumpPower = Settings.JumpPower
        end
        defaultSpeed = Humanoid.WalkSpeed
        
        Target = nil
        TargetHumanoid = nil
        TargetHumanoidRootPart = nil
        PathfindingPath = nil
        CurrentWaypointIndex = 1
        LastPathfindingUpdate = 0
        
        if IsShooting and ShootingConnection then
            ShootingConnection:Disconnect()
            ShootingConnection = nil
            IsShooting = false
        end
        
        -- Reset walkspeed based on current state
        if Settings.PathfindingEnabled then
            Humanoid.WalkSpeed = 500
        else
            updateSpeed()
        end
    end
end)

-- Walk Speed Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode[getgenv().walkSpeedSettings.Activation.WalkSpeedToggleKey] then
        -- Don't allow walk speed toggle when pathfinding is enabled
        if Settings.PathfindingEnabled then
            return
        end
        
        isSpeedEnabled = not isSpeedEnabled
        if Character and Humanoid then
            if isSpeedEnabled then
                Humanoid.WalkSpeed = getgenv().walkSpeedSettings.WalkSpeed.Speed
            else
                Humanoid.WalkSpeed = defaultSpeed
            end
        end
    end
end)

-- Create FOV Circle
local function CreateFOVCircle()
    if FOVCircle then
        pcall(function()
            FOVCircle.ScreenGui:Destroy()
        end)
        FOVCircle = nil
    end
    
    if not Settings.CameraLockEnabled then
        return
    end
    
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    end
    if not playerGui then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FOVCircleGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
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
    
    -- Main stroke with glow effect
    local stroke = Instance.new("UIStroke")
    stroke.Color = Settings.FOVCircleColor
    stroke.Transparency = Settings.FOVCircleTransparency
    stroke.Thickness = Settings.FOVCircleThickness
    stroke.Parent = circle
    
    -- Outer glow stroke
    local glowStroke = Instance.new("UIStroke")
    glowStroke.Color = Settings.FOVCircleColor
    glowStroke.Transparency = Settings.FOVCircleTransparency + 0.2
    glowStroke.Thickness = Settings.FOVCircleThickness + 4
    glowStroke.Parent = circle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0.5, 0)
    circleCorner.Parent = circle
    
    circle.BackgroundColor3 = Settings.FOVCircleColor
    circle.BackgroundTransparency = Settings.FOVCircleTransparency + 0.4
    
    -- Animated gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    gradient.Rotation = 0
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, Settings.FOVCircleTransparency),
        NumberSequenceKeypoint.new(0.5, Settings.FOVCircleTransparency + 0.2),
        NumberSequenceKeypoint.new(1, Settings.FOVCircleTransparency)
    })
    gradient.Parent = circle
    
    -- Inner glow circle
    local innerGlow = Instance.new("Frame")
    innerGlow.Name = "InnerGlow"
    innerGlow.Size = UDim2.new(0.85, 0, 0.85, 0)
    innerGlow.Position = UDim2.new(0.075, 0, 0.075, 0)
    innerGlow.BackgroundColor3 = Settings.FOVCircleColor
    innerGlow.BackgroundTransparency = 0.7
    innerGlow.BorderSizePixel = 0
    innerGlow.Parent = circle
    
    local innerGlowCorner = Instance.new("UICorner")
    innerGlowCorner.CornerRadius = UDim.new(0.5, 0)
    innerGlowCorner.Parent = innerGlow
    
    local innerGlowGradient = Instance.new("UIGradient")
    innerGlowGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
    })
    innerGlowGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    innerGlowGradient.Parent = innerGlow
    
    FOVCircle = {
        ScreenGui = screenGui,
        Circle = circle,
        Gradient = gradient,
        Stroke = stroke,
        GlowStroke = glowStroke,
        InnerGlow = innerGlow,
        InnerGlowGradient = innerGlowGradient
    }
    
    -- Beautiful rotating animation
    task.spawn(function()
        local rotationSpeed = 1
        while FOVCircle and Settings.CameraLockEnabled do
            for i = 0, 360, rotationSpeed do
                if not FOVCircle or not Settings.CameraLockEnabled then break end
                FOVCircle.Gradient.Rotation = i
                FOVCircle.InnerGlowGradient.Rotation = -i * 0.5
                -- Pulse effect
                local pulse = math.sin(math.rad(i)) * 0.1 + 1
                FOVCircle.Circle.Size = UDim2.new(0, Settings.FOV * 2 * pulse, 0, Settings.FOV * 2 * pulse)
                FOVCircle.Circle.Position = UDim2.new(0.5, -Settings.FOV * pulse, 0.5, -Settings.FOV * pulse)
                task.wait(0.016)
            end
        end
    end)
    
    -- Glow pulse animation
    task.spawn(function()
        while FOVCircle and Settings.CameraLockEnabled do
            local tween1 = TweenService:Create(
                glowStroke,
                TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Transparency = Settings.FOVCircleTransparency + 0.2}
            )
            local tween2 = TweenService:Create(
                glowStroke,
                TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Transparency = Settings.FOVCircleTransparency + 0.5}
            )
            tween1:Play()
            tween2:Play()
            task.wait(1.6)
        end
    end)
end

-- Find nearest target (for camera lock - requires visibility)
local function FindNearestTarget()
    if not HumanoidRootPart or not Camera then
        return nil
    end
    
    local nearestPlayer = nil
    local nearestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                local success, distance = pcall(function()
                    return (HumanoidRootPart.Position - rootPart.Position).Magnitude
                end)
                
                if success and distance then
                    local screenSuccess, screenPoint, onScreen = pcall(function()
                        return Camera:WorldToViewportPoint(rootPart.Position)
                    end)
                    
                    if screenSuccess and screenPoint and onScreen then
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
    end
    
    return nearestPlayer
end

-- Find nearest target for pathfinding (can find targets behind walls)
local function FindNearestTargetForPathfinding()
    if not HumanoidRootPart then
        return nil
    end
    
    local nearestPlayer = nil
    local nearestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                local success, distance = pcall(function()
                    return (HumanoidRootPart.Position - rootPart.Position).Magnitude
                end)
                
                if success and distance and distance < 500 then
                    if distance < nearestDistance then
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
        if not Settings.PathfindingEnabled then
            Target = nil
            TargetHumanoid = nil
            TargetHumanoidRootPart = nil
        end
        return
    end
    
    if Target and Target.Character then
        local humanoid = Target.Character:FindFirstChild("Humanoid")
        local rootPart = Target.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart and humanoid.Health > 0 then
            local distance = (HumanoidRootPart.Position - rootPart.Position).Magnitude
            if distance < 500 then
                TargetHumanoid = humanoid
                TargetHumanoidRootPart = rootPart
                return
            end
        end
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
        WaypointSpacing = 4,
        Costs = {
            Water = 10,
            Danger = 20
        }
    })
    
    local success, err = pcall(function()
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

-- Check if target is visible
local function IsTargetVisible()
    if not TargetHumanoidRootPart or not Camera then return false end
    local success, screenPoint, onScreen = pcall(function()
        return Camera:WorldToViewportPoint(TargetHumanoidRootPart.Position)
    end)
    return success and onScreen or false
end

-- Dodging movement
local function ApplyDodgingMovement()
    if not Settings.DodgingEnabled or not TargetHumanoidRootPart then
        return Vector3.new(0, 0, 0)
    end
    
    local targetVisible = IsTargetVisible()
    local distanceToTarget = (HumanoidRootPart.Position - TargetHumanoidRootPart.Position).Magnitude
    
    if not targetVisible or distanceToTarget > 50 then
        return Vector3.new(0, 0, 0)
    end
    
    local currentTime = tick()
    local dodgeMovement = Vector3.new(0, 0, 0)
    
    if currentTime - LastDodgeChange > 0.3 + math.random() * 0.4 then
        DodgingDirection = -DodgingDirection
        LastDodgeChange = currentTime
    end
    
    local rightVector = Camera.CFrame.RightVector
    dodgeMovement = dodgeMovement + rightVector * DodgingDirection * Settings.DodgingSpeed * Settings.DodgingIntensity
    
    RandomMovementTimer = RandomMovementTimer + (1/60)
    if RandomMovementTimer > 0.2 + math.random() * 0.3 then
        RandomMovementTimer = 0
        local randomX = (math.random() - 0.5) * 1.5
        local randomZ = (math.random() - 0.5) * 1.5
        dodgeMovement = dodgeMovement + Vector3.new(randomX, 0, randomZ) * Settings.DodgingSpeed * 0.4
    end
    
    return dodgeMovement
end

-- Move to target (Fixed stuttering)
local function MoveToTarget()
    if not Settings.PathfindingEnabled or not TargetHumanoidRootPart or not HumanoidRootPart or not Humanoid then
        return
    end
    
    -- Set walk speed to 500 when pathfinding is enabled (pathfinding takes priority over walk speed toggle)
    if Humanoid then
        Humanoid.WalkSpeed = 500
        if Humanoid.UseJumpPower then
            Humanoid.JumpPower = Settings.JumpPower
        end
    end
    
    -- Auto-shoot when pathfinding enabled
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
                    UserInputService:FireInputBegan({
                        UserInputType = Enum.UserInputType.MouseButton1,
                        UserInputState = Enum.UserInputState.Begin
                    })
                end)
            end)
        end
    elseif not Settings.PathfindingEnabled and IsShooting and not Settings.CameraLockEnabled then
        if ShootingConnection then
            ShootingConnection:Disconnect()
            ShootingConnection = nil
        end
        IsShooting = false
    end
    
    local currentTime = tick()
    local distanceToTarget = (HumanoidRootPart.Position - TargetHumanoidRootPart.Position).Magnitude
    
    -- Update pathfinding less frequently to prevent stuttering (only when far or path invalid)
    local shouldUpdate = false
    if not PathfindingPath then
        shouldUpdate = true
    elseif PathfindingPath.Status ~= Enum.PathStatus.Success then
        shouldUpdate = true
    elseif distanceToTarget > 100 then
        shouldUpdate = true
    else
        local success, waypoints = pcall(function()
            return PathfindingPath:GetWaypoints()
        end)
        if success and waypoints then
            if CurrentWaypointIndex > #waypoints then
                shouldUpdate = true
            end
        else
            shouldUpdate = true
        end
    end
    
    if shouldUpdate and (currentTime - LastPathfindingUpdate > 1) then
        UpdatePathfinding()
        LastPathfindingUpdate = currentTime
    end
    
    local targetPosition = TargetHumanoidRootPart.Position
    local targetVisible = IsTargetVisible()
    
    -- Use pathfinding to navigate around obstacles
    if PathfindingPath and PathfindingPath.Status == Enum.PathStatus.Success then
        local success, waypoints = pcall(function()
            return PathfindingPath:GetWaypoints()
        end)
        
        if success and waypoints and #waypoints > 1 and CurrentWaypointIndex <= #waypoints then
            local currentWaypoint = waypoints[CurrentWaypointIndex]
            local distanceToWaypoint = (HumanoidRootPart.Position - currentWaypoint.Position).Magnitude
            
            -- Handle jump waypoints
            if currentWaypoint.Action == Enum.PathWaypointAction.Jump then
                Humanoid.Jump = true
            end
            
            -- Check for obstacles and jump over them
            if distanceToWaypoint > 3 then
                local directionToWaypoint = (currentWaypoint.Position - HumanoidRootPart.Position)
                if directionToWaypoint.Magnitude > 0 then
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    raycastParams.FilterDescendantsInstances = {Character}
                    
                    local raycast = workspace:Raycast(HumanoidRootPart.Position + Vector3.new(0, 2, 0), directionToWaypoint.Unit * 8, raycastParams)
                    if raycast and raycast.Instance then
                        -- Obstacle detected, jump over it
                        Humanoid.Jump = true
                    end
                end
            end
            
            -- Move to waypoint (increased threshold to prevent stuttering)
            if distanceToWaypoint < 6 then
                CurrentWaypointIndex = CurrentWaypointIndex + 1
                -- If we've reached the last waypoint, target the actual target position
                if CurrentWaypointIndex > #waypoints then
                    targetPosition = TargetHumanoidRootPart.Position
                else
                    targetPosition = waypoints[CurrentWaypointIndex].Position
                end
            else
                targetPosition = currentWaypoint.Position
            end
        else
            -- Reached end of path or no waypoints, move directly to target
            targetPosition = TargetHumanoidRootPart.Position
        end
    else
        -- No pathfinding path, move directly to target
        targetPosition = TargetHumanoidRootPart.Position
    end
    
    -- Calculate direction to move
    local direction = (targetPosition - HumanoidRootPart.Position)
    direction = Vector3.new(direction.X, 0, direction.Z)
    local distance = direction.Magnitude
    
    if distance > 2 then
        direction = direction.Unit
        
        -- Apply movement using Humanoid:Move() for proper physics - smooth continuous movement
        if targetVisible and distanceToTarget < 50 and Settings.DodgingEnabled then
            -- Dodging mode when close and visible
            local dodgingMove = ApplyDodgingMovement()
            if dodgingMove.Magnitude > 0 then
                local finalDirection = direction + dodgingMove.Unit * 0.3
                finalDirection = finalDirection.Unit
                Humanoid:Move(finalDirection, false)
            else
                Humanoid:Move(direction, false)
            end
            
            if math.random() < Settings.JumpProbability * 2 then
                Humanoid.Jump = true
            end
        else
            -- Normal pathfinding movement - smooth continuous run
            Humanoid:Move(direction, false)
            
            -- Check for obstacles ahead and jump if needed
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {Character}
            
            local raycast = workspace:Raycast(HumanoidRootPart.Position + Vector3.new(0, 2, 0), direction * 6, raycastParams)
            if raycast and raycast.Instance then
                -- Obstacle detected, jump over it
                Humanoid.Jump = true
            elseif math.random() < Settings.JumpProbability * 0.5 then
                -- Less frequent random jumps to prevent stuttering
                Humanoid.Jump = true
            end
        end
    else
        -- Very close to target, slow down smoothly
        if distance > 0.5 then
            Humanoid:Move(direction * 0.5, false)
        else
            Humanoid:Move(Vector3.new(0, 0, 0), false)
        end
    end
end

-- Camera lock
local function LockCamera()
    if not Settings.CameraLockEnabled or not TargetHumanoidRootPart or not Camera then
        return
    end
    
    local success, targetPosition = pcall(function()
        return TargetHumanoidRootPart.Position
    end)
    
    if not success or not targetPosition then
        return
    end
    
    if TargetHumanoid then
        local velSuccess, vel = pcall(function()
            return TargetHumanoidRootPart.AssemblyLinearVelocity
        end)
        
        if velSuccess and vel then
            targetPosition = targetPosition + Vector3.new(
                vel.X * Settings.PredictionX,
                vel.Y * Settings.PredictionY,
                vel.Z * Settings.PredictionX
            )
        end
    end
    
    local cameraPosition = Camera.CFrame.Position
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.lookAt(cameraPosition, targetPosition)
    local newCFrame = currentCFrame:Lerp(targetCFrame, Settings.SmoothnessX)
    Camera.CFrame = newCFrame
end

-- Auto reload
local function AutoReload()
    if not Settings.AutoReload or not Settings.CameraLockEnabled then
        return
    end
    
    local currentTime = tick()
    if currentTime - LastReloadTime >= Settings.AutoReloadInterval then
        pcall(function()
            UserInputService:FireInputBegan({
                KeyCode = Enum.KeyCode.R,
                UserInputState = Enum.UserInputState.Begin
            })
        end)
        LastReloadTime = currentTime
    end
end

-- Update shooting
local function UpdateShooting()
    if not Settings.CameraLockEnabled or not TargetHumanoid then
        if IsShooting then
            pcall(function()
                UserInputService:FireInputEnded({
                    UserInputType = Enum.UserInputType.MouseButton1,
                    UserInputState = Enum.UserInputState.End
                })
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
                UserInputService:FireInputBegan({
                    UserInputType = Enum.UserInputType.MouseButton1,
                    UserInputState = Enum.UserInputState.Begin
                })
            end)
        end)
    elseif not shouldShoot and IsShooting then
        if ShootingConnection then
            ShootingConnection:Disconnect()
            ShootingConnection = nil
        end
        pcall(function()
            UserInputService:FireInputEnded({
                UserInputType = Enum.UserInputType.MouseButton1,
                UserInputState = Enum.UserInputState.End
            })
        end)
        IsShooting = false
    end
end

-- Create Center Buttons
local function CreateCornerButtons()
    for _, btn in pairs(CornerButtons) do
        if btn and btn.Parent then
            pcall(function()
                btn.Parent:Destroy()
            end)
        end
    end
    CornerButtons = {}
    
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    end
    if not playerGui then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CornerButtons"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    local buttonSize = isMobile and 80 or 70
    local buttonSpacing = 20
    
    -- Camera Lock Button
    local btn1 = Instance.new("TextButton")
    btn1.Name = "CameraLockToggle"
    btn1.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    btn1.Position = UDim2.new(0.5, -(buttonSize + buttonSpacing/2), 0.5, -buttonSize/2)
    btn1.BackgroundColor3 = Settings.CameraLockEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(20, 0, 0)
    btn1.BackgroundTransparency = Settings.CameraLockEnabled and 0.2 or 0.5
    btn1.BorderSizePixel = 2
    btn1.BorderColor3 = Color3.fromRGB(255, 0, 0)
    btn1.Text = Settings.CameraLockEnabled and "🔒\nLOCKED" or "🔓\nUNLOCKED"
    btn1.TextColor3 = Color3.fromRGB(255, 50, 50)
    btn1.TextSize = isMobile and 16 or 14
    btn1.Font = Enum.Font.GothamBold
    btn1.TextWrapped = true
    btn1.Active = true
    btn1.Parent = screenGui
    
    local corner1 = Instance.new("UICorner")
    corner1.CornerRadius = UDim.new(0, 12)
    corner1.Parent = btn1
    
    -- Button hover animation
    btn1.MouseEnter:Connect(function()
        TweenService:Create(btn1, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = btn1.BackgroundTransparency - 0.1,
            Size = UDim2.new(0, buttonSize + 4, 0, buttonSize + 4)
        }):Play()
    end)
    btn1.MouseLeave:Connect(function()
        TweenService:Create(btn1, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = Settings.CameraLockEnabled and 0.2 or 0.5,
            Size = UDim2.new(0, buttonSize, 0, buttonSize)
        }):Play()
    end)
    
    local function toggleCameraLock()
        Settings.CameraLockEnabled = not Settings.CameraLockEnabled
        btn1.Text = Settings.CameraLockEnabled and "🔒\nLOCKED" or "🔓\nUNLOCKED"
        
        -- Animated toggle
        TweenService:Create(btn1, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundColor3 = Settings.CameraLockEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(20, 0, 0),
            BackgroundTransparency = Settings.CameraLockEnabled and 0.2 or 0.5,
            Size = UDim2.new(0, buttonSize + 6, 0, buttonSize + 6)
        }):Play()
        
        task.wait(0.15)
        TweenService:Create(btn1, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, buttonSize, 0, buttonSize)
        }):Play()
        
        if Settings.CameraLockEnabled then
            CreateFOVCircle()
        else
            if FOVCircle then
                pcall(function()
                    FOVCircle.ScreenGui:Destroy()
                end)
                FOVCircle = nil
            end
            if ShootingConnection then
                ShootingConnection:Disconnect()
                ShootingConnection = nil
            end
            IsShooting = false
            if not Settings.PathfindingEnabled then
                Target = nil
                TargetHumanoid = nil
                TargetHumanoidRootPart = nil
            end
        end
    end
    
    local btn1Dragging = false
    btn1.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local dragStart = input.Position
            local startPos = btn1.Position
            btn1Dragging = false
            
            local dragConnection
            dragConnection = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput == input then
                    local moved = (moveInput.Position - dragStart).Magnitude
                    if moved > 20 then
                        btn1Dragging = true
                        local delta = moveInput.Position - dragStart
                        btn1.Position = UDim2.new(
                            startPos.X.Scale,
                            startPos.X.Offset + delta.X,
                            startPos.Y.Scale,
                            startPos.Y.Offset + delta.Y
                        )
                    end
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if dragConnection then
                        dragConnection:Disconnect()
                    end
                    if not btn1Dragging then
                        toggleCameraLock()
                    end
                    btn1Dragging = false
                end
            end)
        end
    end)
    
    -- Settings Button
    local btn2 = Instance.new("TextButton")
    btn2.Name = "UIToggle"
    btn2.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    btn2.Position = UDim2.new(0.5, buttonSpacing/2, 0.5, -buttonSize/2)
    btn2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn2.BackgroundTransparency = 0.5
    btn2.BorderSizePixel = 2
    btn2.BorderColor3 = Color3.fromRGB(255, 0, 0)
    btn2.Text = "⚙\nSETTINGS"
    btn2.TextColor3 = Color3.fromRGB(255, 50, 50)
    btn2.TextSize = isMobile and 16 or 14
    btn2.Font = Enum.Font.GothamBold
    btn2.TextWrapped = true
    btn2.Active = true
    btn2.Parent = screenGui
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 12)
    corner2.Parent = btn2
    
    -- Button hover animation
    btn2.MouseEnter:Connect(function()
        TweenService:Create(btn2, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, buttonSize + 4, 0, buttonSize + 4)
        }):Play()
    end)
    btn2.MouseLeave:Connect(function()
        TweenService:Create(btn2, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.5,
            Size = UDim2.new(0, buttonSize, 0, buttonSize)
        }):Play()
    end)
    
    local function toggleSettings()
        Settings.UIEnabled = not Settings.UIEnabled
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local uiGui = playerGui:FindFirstChild("CameraLockUI")
            if uiGui then
                local mainFrame = uiGui:FindFirstChild("MainFrame")
                if mainFrame then
                    if Settings.UIEnabled then
                        mainFrame.Visible = true
                        local viewportSize = Camera.ViewportSize
                        local targetWidth = math.min(viewportSize.X * 0.8, isMobile and 550 or 500)
                        local targetHeight = math.min(viewportSize.Y * 0.7, isMobile and 500 or 450)
                        mainFrame.Size = UDim2.new(0, 0, 0, 0)
                        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            Size = UDim2.new(0, targetWidth, 0, targetHeight)
                        }):Play()
                    else
                        local currentSize = mainFrame.AbsoluteSize
                        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Size = UDim2.new(0, 0, 0, 0)
                        }):Play()
                        task.wait(0.3)
                        mainFrame.Visible = false
                        mainFrame.Size = UDim2.new(0, currentSize.X, 0, currentSize.Y)
                    end
                end
            end
        end
        
        -- Animate button
        TweenService:Create(btn2, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, buttonSize + 6, 0, buttonSize + 6)
        }):Play()
        task.wait(0.1)
        btn2.Text = Settings.UIEnabled and "⚙\nCLOSE" or "⚙\nSETTINGS"
        TweenService:Create(btn2, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, buttonSize, 0, buttonSize)
        }):Play()
    end
    
    local btn2Dragging = false
    btn2.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local dragStart = input.Position
            local startPos = btn2.Position
            btn2Dragging = false
            
            local dragConnection
            dragConnection = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput == input then
                    local moved = (moveInput.Position - dragStart).Magnitude
                    if moved > 20 then
                        btn2Dragging = true
                        local delta = moveInput.Position - dragStart
                        btn2.Position = UDim2.new(
                            startPos.X.Scale,
                            startPos.X.Offset + delta.X,
                            startPos.Y.Scale,
                            startPos.Y.Offset + delta.Y
                        )
                    end
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if dragConnection then
                        dragConnection:Disconnect()
                    end
                    if not btn2Dragging then
                        toggleSettings()
                    end
                    btn2Dragging = false
                end
            end)
        end
    end)
    
    CornerButtons = {btn1, btn2}
end

-- Create UI with Tabs (simplified version - full UI code would be too long, keeping essential parts)
local function CreateUI()
    if MainUI then
        pcall(function()
            MainUI.Parent:Destroy()
        end)
    end
    
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    end
    if not playerGui then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CameraLockUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    -- Use responsive sizing based on screen size
    local viewportSize = Camera.ViewportSize
    local baseWidth = math.min(viewportSize.X * 0.8, isMobile and 550 or 500)
    local baseHeight = math.min(viewportSize.Y * 0.7, isMobile and 500 or 450)
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, baseWidth, 0, baseHeight)
    mainFrame.Position = UDim2.new(0.5, -baseWidth/2, 0.5, -baseHeight/2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    mainFrame.Visible = Settings.UIEnabled
    mainFrame.Active = true
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, isMobile and 45 or 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    titleBar.BackgroundTransparency = 0.2
    titleBar.BorderSizePixel = 0
    titleBar.Active = true
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🎯 Camera Lock Settings"
    title.TextColor3 = Color3.fromRGB(255, 100, 100)
    title.TextSize = isMobile and 18 or 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Make title bar draggable with screen bounds
    local draggingUI = false
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local dragStart = input.Position
            local startPos = mainFrame.Position
            draggingUI = false
            
            local moveConnection
            moveConnection = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput == input then
                    local moved = (moveInput.Position - dragStart).Magnitude
                    if moved > 5 then
                        draggingUI = true
                        local delta = moveInput.Position - dragStart
                        local newX = startPos.X.Offset + delta.X
                        local newY = startPos.Y.Offset + delta.Y
                        
                        -- Keep UI within screen bounds
                        local viewportSize = Camera.ViewportSize
                        local frameSize = mainFrame.AbsoluteSize
                        newX = math.clamp(newX, 0, viewportSize.X - frameSize.X)
                        newY = math.clamp(newY, 0, viewportSize.Y - frameSize.Y)
                        
                        mainFrame.Position = UDim2.new(0, newX, 0, newY)
                    end
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if moveConnection then
                        moveConnection:Disconnect()
                    end
                    draggingUI = false
                end
            end)
        end
    end)
    
    MainUI = mainFrame
end

-- Main update loop
RunService.Heartbeat:Connect(function()
    if not Character or not Humanoid or not HumanoidRootPart then
        return
    end
    
    if Settings.CameraLockEnabled then
        UpdateTarget()
        if TargetHumanoidRootPart then
            LockCamera()
            UpdateShooting()
            AutoReload()
        end
    else
        if not Settings.PathfindingEnabled then
            if Target then
                Target = nil
                TargetHumanoid = nil
                TargetHumanoidRootPart = nil
            end
        end
        if IsShooting and not Settings.PathfindingEnabled then
            if ShootingConnection then
                ShootingConnection:Disconnect()
                ShootingConnection = nil
            end
            IsShooting = false
        end
    end
    
    if Settings.PathfindingEnabled then
        if not TargetHumanoidRootPart then
            local newTarget = FindNearestTargetForPathfinding()
            if newTarget and newTarget.Character then
                Target = newTarget
                TargetHumanoid = newTarget.Character:FindFirstChild("Humanoid")
                TargetHumanoidRootPart = newTarget.Character:FindFirstChild("HumanoidRootPart")
            end
        end
        
        if TargetHumanoidRootPart then
            MoveToTarget()
        end
    else
        -- Reset pathfinding state
        PathfindingPath = nil
        CurrentWaypointIndex = 1
        -- Stop movement
        if Humanoid then
            Humanoid:Move(Vector3.new(0, 0, 0), false)
        end
    end
    
    -- Update walkspeed
    updateSpeed()
end)

-- Initialize walkspeed connection
speedConnection = RunService.RenderStepped:Connect(updateSpeed)

-- Initialize
task.spawn(function()
    -- Wait for character to load
    if not InitializeCharacter() then
        LocalPlayer.CharacterAdded:Wait()
        task.wait(1)
        InitializeCharacter()
    end
    
    -- Wait a bit for everything to load
    task.wait(0.5)
    
    -- Create UI elements
    CreateCornerButtons()
    CreateUI()
    
    print("Camera Lock System Loaded!")
    print("Mobile Compatible: " .. tostring(isMobile))
    print("Walk Speed Toggle: Press " .. getgenv().walkSpeedSettings.Activation.WalkSpeedToggleKey)
end)
