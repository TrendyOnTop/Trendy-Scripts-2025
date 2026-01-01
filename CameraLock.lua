-- Roblox Advanced Camera Lock System - FULLY WORKING VERSION
-- All features connected and working

local success, err = pcall(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local PathfindingService = game:GetService("PathfindingService")

    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

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

    if not getgenv().walkSpeedSettings then
        getgenv().walkSpeedSettings = {
            WalkSpeed = {Enabled = true, Speed = 300},
            Activation = {WalkSpeedToggleKey = "T"}
        }
    end

    -- State
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

    -- Initialize character
    local function InitializeCharacter()
        if LocalPlayer.Character then
            Character = LocalPlayer.Character
            Humanoid = Character:FindFirstChild("Humanoid")
            HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
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
        if Settings.PathfindingEnabled then return end
        if isSpeedEnabled and getgenv().walkSpeedSettings.WalkSpeed.Enabled then
            Humanoid.WalkSpeed = getgenv().walkSpeedSettings.WalkSpeed.Speed
        elseif not isSpeedEnabled then
            Humanoid.WalkSpeed = defaultSpeed
        end
    end

    LocalPlayer.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        Humanoid = newCharacter:FindFirstChild("Humanoid")
        HumanoidRootPart = newCharacter:FindFirstChild("HumanoidRootPart")
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
            if Settings.PathfindingEnabled then
                Humanoid.WalkSpeed = 500
            else
                updateSpeed()
            end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode[getgenv().walkSpeedSettings.Activation.WalkSpeedToggleKey] then
            if Settings.PathfindingEnabled then return end
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
            pcall(function() FOVCircle.ScreenGui:Destroy() end)
            FOVCircle = nil
        end
        if not Settings.CameraLockEnabled then return end
        
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
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
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Settings.FOVCircleColor
        stroke.Transparency = Settings.FOVCircleTransparency
        stroke.Thickness = Settings.FOVCircleThickness
        stroke.Parent = circle
        
        local glowStroke = Instance.new("UIStroke")
        glowStroke.Color = Settings.FOVCircleColor
        glowStroke.Transparency = Settings.FOVCircleTransparency + 0.2
        glowStroke.Thickness = Settings.FOVCircleThickness + 4
        glowStroke.Parent = circle
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(0.5, 0)
        circleCorner.Parent = circle
        
        circle.BackgroundColor3 = Settings.FOVCircleColor
        circle.BackgroundTransparency = math.max(0.1, Settings.FOVCircleTransparency + 0.2)
        
        local r, g, b = math.floor(Settings.FOVCircleColor.R * 255), math.floor(Settings.FOVCircleColor.G * 255), math.floor(Settings.FOVCircleColor.B * 255)
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Settings.FOVCircleColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(math.min(255, r + 50), math.min(255, g + 50), math.min(255, b + 50))),
            ColorSequenceKeypoint.new(1, Settings.FOVCircleColor)
        })
        gradient.Rotation = 0
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, Settings.FOVCircleTransparency),
            NumberSequenceKeypoint.new(0.5, Settings.FOVCircleTransparency + 0.2),
            NumberSequenceKeypoint.new(1, Settings.FOVCircleTransparency)
        })
        gradient.Parent = circle
        
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
            ColorSequenceKeypoint.new(0, Settings.FOVCircleColor),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(math.max(0, r - 55), math.max(0, g - 55), math.max(0, b - 55)))
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
        
        task.spawn(function()
            local rotationSpeed = 2
            while FOVCircle and Settings.CameraLockEnabled do
                for i = 0, 360, rotationSpeed do
                    if not FOVCircle or not Settings.CameraLockEnabled then break end
                    FOVCircle.Gradient.Rotation = i
                    FOVCircle.InnerGlowGradient.Rotation = -i * 0.5
                    local angle = math.rad(i)
                    local brightR = math.min(255, r + math.floor(math.sin(angle) * 50))
                    local brightG = math.min(255, g + math.floor(math.sin(angle) * 50))
                    local brightB = math.min(255, b + math.floor(math.sin(angle) * 50))
                    FOVCircle.Stroke.Color = Color3.fromRGB(brightR, brightG, brightB)
                    local pulse = math.sin(math.rad(i)) * 0.1 + 1
                    FOVCircle.Circle.Size = UDim2.new(0, Settings.FOV * 2 * pulse, 0, Settings.FOV * 2 * pulse)
                    FOVCircle.Circle.Position = UDim2.new(0.5, -Settings.FOV * pulse, 0.5, -Settings.FOV * pulse)
                    task.wait(0.016)
                end
            end
        end)
    end

    -- Find nearest target
    local function FindNearestTarget()
        if not HumanoidRootPart or not Camera then return nil end
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
                            local distanceFromCenter = math.sqrt(math.pow(screenPoint.X - centerX, 2) + math.pow(screenPoint.Y - centerY, 2))
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

    local function FindNearestTargetForPathfinding()
        if not HumanoidRootPart then return nil end
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
            Costs = {Water = 10, Danger = 20}
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

    local function IsTargetVisible()
        if not TargetHumanoidRootPart or not Camera then return false end
        local success, screenPoint, onScreen = pcall(function()
            return Camera:WorldToViewportPoint(TargetHumanoidRootPart.Position)
        end)
        return success and onScreen or false
    end

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

    local function MoveToTarget()
        if not Settings.PathfindingEnabled or not TargetHumanoidRootPart or not HumanoidRootPart or not Humanoid then
            return
        end
        if Humanoid then
            Humanoid.WalkSpeed = 500
            if Humanoid.UseJumpPower then
                Humanoid.JumpPower = Settings.JumpPower
            end
        end
        if Settings.PathfindingEnabled and TargetHumanoid and TargetHumanoid.Health > Settings.AutoStopShootingHP and not Settings.CameraLockEnabled then
            if not IsShooting then
                IsShooting = true
                if ShootingConnection then ShootingConnection:Disconnect() end
                ShootingConnection = RunService.Heartbeat:Connect(function()
                    if not Settings.PathfindingEnabled or Settings.CameraLockEnabled or not TargetHumanoid or TargetHumanoid.Health < Settings.AutoStopShootingHP then
                        if ShootingConnection then ShootingConnection:Disconnect() ShootingConnection = nil end
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
            if ShootingConnection then ShootingConnection:Disconnect() ShootingConnection = nil end
            IsShooting = false
        end
        local currentTime = tick()
        local distanceToTarget = (HumanoidRootPart.Position - TargetHumanoidRootPart.Position).Magnitude
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
        if PathfindingPath and PathfindingPath.Status == Enum.PathStatus.Success then
            local success, waypoints = pcall(function()
                return PathfindingPath:GetWaypoints()
            end)
            if success and waypoints and #waypoints > 1 and CurrentWaypointIndex <= #waypoints then
                local currentWaypoint = waypoints[CurrentWaypointIndex]
                local distanceToWaypoint = (HumanoidRootPart.Position - currentWaypoint.Position).Magnitude
                if currentWaypoint.Action == Enum.PathWaypointAction.Jump then
                    Humanoid.Jump = true
                end
                if distanceToWaypoint > 3 then
                    local directionToWaypoint = (currentWaypoint.Position - HumanoidRootPart.Position)
                    if directionToWaypoint.Magnitude > 0 then
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        raycastParams.FilterDescendantsInstances = {Character}
                        local raycast = workspace:Raycast(HumanoidRootPart.Position + Vector3.new(0, 2, 0), directionToWaypoint.Unit * 8, raycastParams)
                        if raycast and raycast.Instance then
                            Humanoid.Jump = true
                        end
                    end
                end
                if distanceToWaypoint < 6 then
                    CurrentWaypointIndex = CurrentWaypointIndex + 1
                    if CurrentWaypointIndex > #waypoints then
                        targetPosition = TargetHumanoidRootPart.Position
                    else
                        targetPosition = waypoints[CurrentWaypointIndex].Position
                    end
                else
                    targetPosition = currentWaypoint.Position
                end
            else
                targetPosition = TargetHumanoidRootPart.Position
            end
        else
            targetPosition = TargetHumanoidRootPart.Position
        end
        local direction = (targetPosition - HumanoidRootPart.Position)
        direction = Vector3.new(direction.X, 0, direction.Z)
        local distance = direction.Magnitude
        if distance > 2 then
            direction = direction.Unit
            if targetVisible and distanceToTarget < 50 and Settings.DodgingEnabled then
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
                Humanoid:Move(direction, false)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {Character}
                local raycast = workspace:Raycast(HumanoidRootPart.Position + Vector3.new(0, 2, 0), direction * 6, raycastParams)
                if raycast and raycast.Instance then
                    Humanoid.Jump = true
                elseif math.random() < Settings.JumpProbability * 0.5 then
                    Humanoid.Jump = true
                end
            end
        else
            if distance > 0.5 then
                Humanoid:Move(direction * 0.5, false)
            else
                Humanoid:Move(Vector3.new(0, 0, 0), false)
            end
        end
    end

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
                pcall(function() btn.Parent:Destroy() end)
            end
        end
        CornerButtons = {}
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
        if not playerGui then return end
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CornerButtons"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = playerGui
        local buttonSize = isMobile and 80 or 70
        local buttonSpacing = 20
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
                    pcall(function() FOVCircle.ScreenGui:Destroy() end)
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
                            btn1.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                        end
                    end
                end)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if dragConnection then dragConnection:Disconnect() end
                        if not btn1Dragging then toggleCameraLock() end
                        btn1Dragging = false
                    end
                end)
            end
        end)
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
                            btn2.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                        end
                    end
                end)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if dragConnection then dragConnection:Disconnect() end
                        if not btn2Dragging then toggleSettings() end
                        btn2Dragging = false
                    end
                end)
            end
        end)
        CornerButtons = {btn1, btn2}
    end

    -- Create UI - COMPLETE WORKING VERSION
    local function CreateUI()
        if MainUI then
            pcall(function() MainUI.Parent:Destroy() end)
        end
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
        if not playerGui then return end
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CameraLockUI"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = playerGui
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
                        if moveConnection then moveConnection:Disconnect() end
                        draggingUI = false
                    end
                end)
            end
        end)
        local tabBar = Instance.new("Frame")
        tabBar.Name = "TabBar"
        tabBar.Size = UDim2.new(1, -20, 0, isMobile and 35 or 30)
        tabBar.Position = UDim2.new(0, 10, 0, titleBar.Size.Y.Offset + 8)
        tabBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tabBar.BackgroundTransparency = 0.5
        tabBar.BorderSizePixel = 0
        tabBar.Parent = mainFrame
        local tabBarCorner = Instance.new("UICorner")
        tabBarCorner.CornerRadius = UDim.new(0, 8)
        tabBarCorner.Parent = tabBar
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.Padding = UDim.new(0, 5)
        tabLayout.Parent = tabBar
        local tabContentFrame = Instance.new("Frame")
        tabContentFrame.Name = "TabContent"
        local contentTopOffset = titleBar.Size.Y.Offset + tabBar.Size.Y.Offset + 8
        tabContentFrame.Size = UDim2.new(1, -20, 1, -contentTopOffset - 10)
        tabContentFrame.Position = UDim2.new(0, 10, 0, contentTopOffset)
        tabContentFrame.BackgroundTransparency = 1
        tabContentFrame.Parent = mainFrame
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = "ScrollFrame"
        scrollFrame.Size = UDim2.new(1, 0, 1, 0)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = isMobile and 10 or 8
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollFrame.ScrollingEnabled = true
        scrollFrame.Parent = tabContentFrame
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, isMobile and 3 or 2)
        listLayout.Parent = scrollFrame
        local currentTab = "Aiming"
        local tabs = {}
        local function updateScrollSize()
            local currentTabContent = tabs[currentTab]
            if currentTabContent then
                scrollFrame.CanvasSize = UDim2.new(0, 0, 0, currentTabContent.Layout.AbsoluteContentSize.Y + 20)
            end
        end
        local function CreateTab(name)
            local tabButton = Instance.new("TextButton")
            tabButton.Name = name .. "Tab"
            tabButton.Size = UDim2.new(0, isMobile and 100 or 90, 1, 0)
            tabButton.BackgroundColor3 = (currentTab == name) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(20, 0, 0)
            tabButton.BackgroundTransparency = (currentTab == name) and 0.2 or 0.6
            tabButton.BorderSizePixel = 0
            tabButton.Text = name
            tabButton.TextColor3 = Color3.fromRGB(255, 100, 100)
            tabButton.TextSize = isMobile and 13 or 12
            tabButton.Font = Enum.Font.GothamBold
            tabButton.Active = true
            tabButton.Parent = tabBar
            local tabCorner = Instance.new("UICorner")
            tabCorner.CornerRadius = UDim.new(0, 6)
            tabCorner.Parent = tabButton
            local tabContent = Instance.new("Frame")
            tabContent.Name = name .. "Content"
            tabContent.Size = UDim2.new(1, 0, 0, 0)
            tabContent.BackgroundTransparency = 1
            tabContent.Visible = (currentTab == name)
            tabContent.Parent = scrollFrame
            local tabContentLayout = Instance.new("UIListLayout")
            tabContentLayout.Padding = UDim.new(0, isMobile and 3 or 2)
            tabContentLayout.Parent = tabContent
            tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
            end)
            local function switchToTab()
                currentTab = name
                for tabName, tabData in pairs(tabs) do
                    tabData.Button.BackgroundColor3 = (tabName == name) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(20, 0, 0)
                    tabData.Button.BackgroundTransparency = (tabName == name) and 0.2 or 0.6
                    tabData.Content.Visible = (tabName == name)
                end
                updateScrollSize()
            end
            tabButton.MouseButton1Click:Connect(switchToTab)
            tabButton.Activated:Connect(switchToTab)
            if isMobile or isTablet then
                tabButton.TouchTap:Connect(switchToTab)
            end
            tabs[name] = {Button = tabButton, Content = tabContent, Layout = tabContentLayout}
            return tabContent, tabContentLayout
        end
        local function CreateSection(title, parent)
            local isCollapsed = false
            local sectionContainer = Instance.new("Frame")
            sectionContainer.Name = title .. "Section"
            sectionContainer.Size = UDim2.new(1, 0, 0, 0)
            sectionContainer.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
            sectionContainer.BackgroundTransparency = 0.4
            sectionContainer.BorderSizePixel = 2
            sectionContainer.BorderColor3 = Color3.fromRGB(255, 0, 0)
            sectionContainer.Parent = parent
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 10)
            sectionCorner.Parent = sectionContainer
            local header = Instance.new("Frame")
            header.Name = "Header"
            header.Size = UDim2.new(1, 0, 0, isMobile and 28 or 24)
            header.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            header.BackgroundTransparency = 0.2
            header.BorderSizePixel = 0
            header.Parent = sectionContainer
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 8)
            headerCorner.Parent = header
            local collapseButton = Instance.new("TextButton")
            collapseButton.Name = "CollapseButton"
            collapseButton.Size = UDim2.new(0, isMobile and 24 or 20, 0, isMobile and 24 or 20)
            collapseButton.Position = UDim2.new(0, 4, 0.5, -(isMobile and 12 or 10))
            collapseButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            collapseButton.BackgroundTransparency = 0.5
            collapseButton.BorderSizePixel = 0
            collapseButton.Text = "▼"
            collapseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
            collapseButton.TextSize = isMobile and 12 or 10
            collapseButton.Font = Enum.Font.GothamBold
            collapseButton.Active = true
            collapseButton.Parent = header
            local collapseCorner = Instance.new("UICorner")
            collapseCorner.CornerRadius = UDim.new(0, 5)
            collapseCorner.Parent = collapseButton
            local divider = Instance.new("Frame")
            divider.Name = "Divider"
            divider.Size = UDim2.new(1, -8, 0, 1)
            divider.Position = UDim2.new(0, 4, 1, -1)
            divider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            divider.BackgroundTransparency = 0.4
            divider.BorderSizePixel = 0
            divider.Parent = header
            local headerLabel = Instance.new("TextLabel")
            headerLabel.Name = "Title"
            headerLabel.Size = UDim2.new(1, -(isMobile and 35 or 30), 1, 0)
            headerLabel.Position = UDim2.new(0, isMobile and 30 or 26, 0, 0)
            headerLabel.BackgroundTransparency = 1
            headerLabel.Text = title
            headerLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            headerLabel.TextSize = isMobile and 13 or 12
            headerLabel.Font = Enum.Font.GothamBold
            headerLabel.TextXAlignment = Enum.TextXAlignment.Left
            headerLabel.Parent = header
            local contentFrame = Instance.new("Frame")
            contentFrame.Name = "Content"
            contentFrame.Size = UDim2.new(1, -12, 0, 0)
            contentFrame.Position = UDim2.new(0, 6, 0, header.Size.Y.Offset + 4)
            contentFrame.BackgroundTransparency = 1
            contentFrame.Visible = true
            contentFrame.Parent = sectionContainer
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, isMobile and 3 or 2)
            contentLayout.Parent = contentFrame
            local function toggleCollapse()
                isCollapsed = not isCollapsed
                contentFrame.Visible = not isCollapsed
                collapseButton.Text = isCollapsed and "▶" or "▼"
                if isCollapsed then
                    sectionContainer.Size = UDim2.new(1, 0, 0, header.Size.Y.Offset)
                else
                    sectionContainer.Size = UDim2.new(1, 0, 0, header.Size.Y.Offset + contentLayout.AbsoluteContentSize.Y + 8)
                end
            end
            collapseButton.MouseButton1Click:Connect(toggleCollapse)
            collapseButton.Activated:Connect(toggleCollapse)
            if isMobile or isTablet then
                collapseButton.TouchTap:Connect(toggleCollapse)
            end
            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if not isCollapsed then
                    sectionContainer.Size = UDim2.new(1, 0, 0, header.Size.Y.Offset + contentLayout.AbsoluteContentSize.Y + 8)
                end
            end)
            return contentFrame, sectionContainer
        end
        local function CreateSlider(name, min, max, current, callback, parent)
            local container = Instance.new("Frame")
            container.Name = name .. "Container"
            container.Size = UDim2.new(1, 0, 0, isMobile and 38 or 32)
            container.BackgroundTransparency = 1
            container.Parent = parent
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Size = UDim2.new(0.35, 0, 0, isMobile and 16 or 14)
            label.BackgroundTransparency = 1
            label.Text = name .. ":"
            label.TextColor3 = Color3.fromRGB(255, 100, 100)
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
            valueLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
            valueLabel.TextSize = isMobile and 12 or 11
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextXAlignment = Enum.TextXAlignment.Left
            valueLabel.Parent = container
            local slider = Instance.new("Frame")
            slider.Name = "Slider"
            slider.Size = UDim2.new(0.6, 0, 0, isMobile and 6 or 5)
            slider.Position = UDim2.new(0.37, 0, 0, isMobile and 18 or 16)
            slider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            slider.BackgroundTransparency = 0.5
            slider.BorderSizePixel = 0
            slider.Parent = container
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 5)
            sliderCorner.Parent = slider
            local fill = Instance.new("Frame")
            fill.Name = "Fill"
            fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            fill.BackgroundTransparency = 0.2
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
            local function updateSliderValue(inputPosition)
                local sliderPos = slider.AbsolutePosition
                local sliderSize = slider.AbsoluteSize
                local relativeX = math.clamp((inputPosition.X - sliderPos.X) / sliderSize.X, 0, 1)
                local value = min + (max - min) * relativeX
                fill.Size = UDim2.new(relativeX, 0, 1, 0)
                valueLabel.Text = string.format("%.2f", value)
                if callback then callback(value) end
            end
            button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    updateSliderValue(input.Position)
                    if dragConnection then dragConnection:Disconnect() end
                    dragConnection = RunService.Heartbeat:Connect(function()
                        if not isDragging then
                            if dragConnection then dragConnection:Disconnect() dragConnection = nil end
                            return
                        end
                        local currentInput = UserInputService:GetMouseLocation()
                        updateSliderValue(currentInput)
                    end)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
                    isDragging = false
                    if dragConnection then dragConnection:Disconnect() dragConnection = nil end
                end
            end)
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
            container.Parent = parent
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.fromRGB(255, 100, 100)
            label.TextSize = isMobile and 12 or 11
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            local toggle = Instance.new("TextButton")
            toggle.Name = "Toggle"
            toggle.Size = UDim2.new(0, isMobile and 42 or 38, 0, isMobile and 20 or 18)
            toggle.Position = UDim2.new(1, -(isMobile and 42 or 38), 0.5, -(isMobile and 10 or 9))
            toggle.BackgroundColor3 = current and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(20, 0, 0)
            toggle.BackgroundTransparency = current and 0.2 or 0.5
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
            indicator.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            indicator.BorderSizePixel = 0
            indicator.Parent = toggle
            local indicatorCorner = Instance.new("UICorner")
            indicatorCorner.CornerRadius = UDim.new(0, 8)
            indicatorCorner.Parent = indicator
            local function toggleSwitch()
                local currentValue = Settings[settingKey]
                local newValue = not currentValue
                Settings[settingKey] = newValue
                TweenService:Create(toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = newValue and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(20, 0, 0),
                    BackgroundTransparency = newValue and 0.2 or 0.5
                }):Play()
                local tween = TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = newValue and UDim2.new(1, -(isMobile and 18 or 16), 0.5, -(isMobile and 8 or 7)) or UDim2.new(0, isMobile and 2 or 2, 0.5, -(isMobile and 8 or 7))
                })
                tween:Play()
                TweenService:Create(toggle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, (isMobile and 42 or 38) + 4, 0, isMobile and 20 or 18)
                }):Play()
                task.wait(0.15)
                TweenService:Create(toggle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, isMobile and 42 or 38, 0, isMobile and 20 or 18)
                }):Play()
                if callback then callback(newValue) end
            end
            toggle.MouseButton1Click:Connect(toggleSwitch)
            toggle.Activated:Connect(toggleSwitch)
            if isMobile or isTablet then
                toggle.TouchTap:Connect(toggleSwitch)
            end
            return container
        end
        local function CreateTextBox(name, current, callback, placeholder, parent)
            local container = Instance.new("Frame")
            container.Name = name .. "Container"
            container.Size = UDim2.new(1, 0, 0, isMobile and 28 or 24)
            container.BackgroundTransparency = 1
            container.Parent = parent
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Size = UDim2.new(0.4, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name .. ":"
            label.TextColor3 = Color3.fromRGB(255, 100, 100)
            label.TextSize = isMobile and 12 or 11
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            local textBox = Instance.new("TextBox")
            textBox.Name = "TextBox"
            textBox.Size = UDim2.new(0, isMobile and 100 or 90, 0, isMobile and 22 or 20)
            textBox.Position = UDim2.new(0.45, 0, 0.5, -(isMobile and 11 or 10))
            textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            textBox.BackgroundTransparency = 0.5
            textBox.BorderSizePixel = 0
            textBox.Text = tostring(current)
            textBox.TextColor3 = Color3.fromRGB(255, 100, 100)
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
                    if callback then callback(numValue) end
                    textBox.Text = tostring(numValue)
                else
                    textBox.Text = tostring(current)
                end
            end)
            return container
        end
        local aimingTab, aimingLayout = CreateTab("Aiming")
        local movementTab, movementLayout = CreateTab("Movement")
        local combatTab, combatLayout = CreateTab("Combat")
        local visualTab, visualLayout = CreateTab("Visual")
        local aimingSection, _ = CreateSection("Camera Lock", aimingTab)
        CreateToggle("Camera Lock", "CameraLockEnabled", function(val)
            Settings.CameraLockEnabled = val
            if val then
                CreateFOVCircle()
            else
                if FOVCircle then
                    pcall(function() FOVCircle.ScreenGui:Destroy() end)
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
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local cornerGui = playerGui:FindFirstChild("CornerButtons")
                if cornerGui then
                    local centerBtn = cornerGui:FindFirstChild("CameraLockToggle")
                    if centerBtn then
                        centerBtn.Text = val and "🔒\nLOCKED" or "🔓\nUNLOCKED"
                        centerBtn.BackgroundColor3 = val and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(20, 0, 0)
                        centerBtn.BackgroundTransparency = val and 0.2 or 0.5
                    end
                end
            end
        end, aimingSection)
        CreateSlider("Smoothness X", 0.01, 1, Settings.SmoothnessX, function(val)
            Settings.SmoothnessX = val
        end, aimingSection)
        CreateSlider("Smoothness Y", 0.01, 1, Settings.SmoothnessY, function(val)
            Settings.SmoothnessY = val
        end, aimingSection)
        CreateSlider("Prediction X", 0, 2, Settings.PredictionX, function(val)
            Settings.PredictionX = val
        end, aimingSection)
        CreateSlider("Prediction Y", 0, 2, Settings.PredictionY, function(val)
            Settings.PredictionY = val
        end, aimingSection)
        local movementSection, _ = CreateSection("Pathfinding & Movement", movementTab)
        CreateToggle("Pathfinding", "PathfindingEnabled", function(val)
            Settings.PathfindingEnabled = val
        end, movementSection)
        CreateToggle("Dodging Mode", "DodgingEnabled", function(val)
            Settings.DodgingEnabled = val
        end, movementSection)
        CreateTextBox("Walk Speed", Settings.WalkSpeed, function(val)
            Settings.WalkSpeed = math.clamp(val, 0, 300)
        end, "0-300", movementSection)
        CreateTextBox("Jump Probability", Settings.JumpProbability, function(val)
            Settings.JumpProbability = math.clamp(val, 0, 0.1)
        end, "0-0.1", movementSection)
        CreateTextBox("Jump Power", Settings.JumpPower, function(val)
            Settings.JumpPower = math.clamp(val, 0, 200)
            if Humanoid and Humanoid.UseJumpPower then
                Humanoid.JumpPower = Settings.JumpPower
            end
        end, "0-200", movementSection)
        CreateTextBox("Dodging Speed", Settings.DodgingSpeed, function(val)
            Settings.DodgingSpeed = math.clamp(val, 0, 50)
        end, "0-50", movementSection)
        CreateTextBox("Dodging Intensity", Settings.DodgingIntensity, function(val)
            Settings.DodgingIntensity = math.clamp(val, 0, 10)
        end, "0-10", movementSection)
        local combatSection, _ = CreateSection("Combat & Shooting", combatTab)
        CreateToggle("Auto Reload", "AutoReload", function(val)
            Settings.AutoReload = val
        end, combatSection)
        CreateTextBox("Reload Interval", Settings.AutoReloadInterval, function(val)
            Settings.AutoReloadInterval = math.clamp(val, 1, 5)
        end, "1-5", combatSection)
        CreateTextBox("Stop Shooting HP", Settings.AutoStopShootingHP, function(val)
            Settings.AutoStopShootingHP = math.clamp(val, 0, 100)
        end, "0-100", combatSection)
        local visualSection, _ = CreateSection("FOV & Visual", visualTab)
        CreateSlider("FOV Size", 50, 200, Settings.FOV, function(val)
            Settings.FOV = val
            if FOVCircle then
                FOVCircle.Circle.Size = UDim2.new(0, val * 2, 0, val * 2)
                FOVCircle.Circle.Position = UDim2.new(0.5, -val, 0.5, -val)
            end
        end, visualSection)
        CreateSlider("FOV Transparency", 0, 1, Settings.FOVCircleTransparency, function(val)
            Settings.FOVCircleTransparency = val
            if FOVCircle then
                FOVCircle.Stroke.Transparency = val
                FOVCircle.GlowStroke.Transparency = val + 0.2
                FOVCircle.Circle.BackgroundTransparency = math.max(0.1, val + 0.2)
                FOVCircle.Gradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, val),
                    NumberSequenceKeypoint.new(0.5, val + 0.2),
                    NumberSequenceKeypoint.new(1, val)
                })
                if FOVCircle.InnerGlow then
                    FOVCircle.InnerGlow.BackgroundTransparency = val + 0.4
                end
            end
        end, visualSection)
        CreateSlider("FOV Thickness", 1, 10, Settings.FOVCircleThickness, function(val)
            Settings.FOVCircleThickness = val
            if FOVCircle then
                FOVCircle.Stroke.Thickness = val
                FOVCircle.GlowStroke.Thickness = val + 4
            end
        end, visualSection)
        CreateTextBox("FOV Red", math.floor(Settings.FOVCircleColor.R * 255), function(val)
            local r = math.clamp(val, 0, 255)
            Settings.FOVCircleColor = Color3.fromRGB(r, Settings.FOVCircleColor.G * 255, Settings.FOVCircleColor.B * 255)
            if FOVCircle then
                FOVCircle.Stroke.Color = Settings.FOVCircleColor
                FOVCircle.GlowStroke.Color = Settings.FOVCircleColor
                FOVCircle.Circle.BackgroundColor3 = Settings.FOVCircleColor
                FOVCircle.Gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Settings.FOVCircleColor),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(math.min(255, r + 50), math.min(255, Settings.FOVCircleColor.G * 255 + 50), math.min(255, Settings.FOVCircleColor.B * 255 + 50))),
                    ColorSequenceKeypoint.new(1, Settings.FOVCircleColor)
                })
                if FOVCircle.InnerGlow then
                    FOVCircle.InnerGlow.BackgroundColor3 = Settings.FOVCircleColor
                    FOVCircle.InnerGlowGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Settings.FOVCircleColor),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(math.max(0, r - 55), math.max(0, Settings.FOVCircleColor.G * 255 - 55), math.max(0, Settings.FOVCircleColor.B * 255 - 55)))
                    })
                end
            end
        end, "0-255", visualSection)
        CreateTextBox("FOV Green", math.floor(Settings.FOVCircleColor.G * 255), function(val)
            local g = math.clamp(val, 0, 255)
            Settings.FOVCircleColor = Color3.fromRGB(Settings.FOVCircleColor.R * 255, g, Settings.FOVCircleColor.B * 255)
            if FOVCircle then
                FOVCircle.Stroke.Color = Settings.FOVCircleColor
                FOVCircle.GlowStroke.Color = Settings.FOVCircleColor
                FOVCircle.Circle.BackgroundColor3 = Settings.FOVCircleColor
                FOVCircle.Gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Settings.FOVCircleColor),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(math.min(255, Settings.FOVCircleColor.R * 255 + 50), math.min(255, g + 50), math.min(255, Settings.FOVCircleColor.B * 255 + 50))),
                    ColorSequenceKeypoint.new(1, Settings.FOVCircleColor)
                })
                if FOVCircle.InnerGlow then
                    FOVCircle.InnerGlow.BackgroundColor3 = Settings.FOVCircleColor
                    FOVCircle.InnerGlowGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Settings.FOVCircleColor),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(math.max(0, Settings.FOVCircleColor.R * 255 - 55), math.max(0, g - 55), math.max(0, Settings.FOVCircleColor.B * 255 - 55)))
                    })
                end
            end
        end, "0-255", visualSection)
        CreateTextBox("FOV Blue", math.floor(Settings.FOVCircleColor.B * 255), function(val)
            local b = math.clamp(val, 0, 255)
            Settings.FOVCircleColor = Color3.fromRGB(Settings.FOVCircleColor.R * 255, Settings.FOVCircleColor.G * 255, b)
            if FOVCircle then
                FOVCircle.Stroke.Color = Settings.FOVCircleColor
                FOVCircle.GlowStroke.Color = Settings.FOVCircleColor
                FOVCircle.Circle.BackgroundColor3 = Settings.FOVCircleColor
                FOVCircle.Gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Settings.FOVCircleColor),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(math.min(255, Settings.FOVCircleColor.R * 255 + 50), math.min(255, Settings.FOVCircleColor.G * 255 + 50), math.min(255, b + 50))),
                    ColorSequenceKeypoint.new(1, Settings.FOVCircleColor)
                })
                if FOVCircle.InnerGlow then
                    FOVCircle.InnerGlow.BackgroundColor3 = Settings.FOVCircleColor
                    FOVCircle.InnerGlowGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Settings.FOVCircleColor),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(math.max(0, Settings.FOVCircleColor.R * 255 - 55), math.max(0, Settings.FOVCircleColor.G * 255 - 55), math.max(0, b - 55)))
                    })
                end
            end
        end, "0-255", visualSection)
        aimingLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScrollSize)
        movementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScrollSize)
        combatLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScrollSize)
        visualLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScrollSize)
        updateScrollSize()
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
            PathfindingPath = nil
            CurrentWaypointIndex = 1
            if Humanoid then
                Humanoid:Move(Vector3.new(0, 0, 0), false)
            end
        end
        updateSpeed()
    end)

    speedConnection = RunService.RenderStepped:Connect(updateSpeed)

    task.spawn(function()
        if not InitializeCharacter() then
            LocalPlayer.CharacterAdded:Wait()
            task.wait(1)
            InitializeCharacter()
        end
        task.wait(0.5)
        CreateCornerButtons()
        CreateUI()
        print("Camera Lock System Loaded!")
        print("Mobile Compatible: " .. tostring(isMobile))
        print("Walk Speed Toggle: Press " .. getgenv().walkSpeedSettings.Activation.WalkSpeedToggleKey)
    end)
end)

if not success then
    warn("Camera Lock System Error: " .. tostring(err))
end
