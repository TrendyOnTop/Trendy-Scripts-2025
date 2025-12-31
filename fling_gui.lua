-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Fling GUI Start --

-- Player finder
local function findPlayer(searchString)
    local strl = searchString:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower() == strl or player.DisplayName:lower() == strl then
            return player
        elseif player.Name:lower():sub(1, #searchString) == strl then
            return player
        end
    end
    return nil
end

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "FlingGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 280)
frame.Position = UDim2.new(0.5, -160, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.ClipsDescendants = true
frame.ZIndex = 2

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Top bar
local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
topBar.BorderSizePixel = 0
topBar.ZIndex = 3

Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "⚡ Fling GUI (Loop Mode)"
title.ZIndex = 4

-- TextBox
local box = Instance.new("TextBox", frame)
box.Position = UDim2.new(0.1, 0, 0.2, 0)
box.Size = UDim2.new(0.8, 0, 0.12, 0)
box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
box.Font = Enum.Font.Gotham
box.PlaceholderText = "Enter player name..."
box.TextColor3 = Color3.new(1, 1, 1)
box.TextSize = 16
box.ZIndex = 3

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

-- Start Button
local startButton = Instance.new("TextButton", frame)
startButton.Position = UDim2.new(0.1, 0, 0.38, 0)
startButton.Size = UDim2.new(0.8, 0, 0.12, 0)
startButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
startButton.Font = Enum.Font.GothamBold
startButton.Text = "▶ Start Flinging"
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.TextSize = 18
startButton.ZIndex = 3

Instance.new("UICorner", startButton).CornerRadius = UDim.new(0, 6)

-- Stop Button
local stopButton = Instance.new("TextButton", frame)
stopButton.Position = UDim2.new(0.1, 0, 0.52, 0)
stopButton.Size = UDim2.new(0.8, 0, 0.12, 0)
stopButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
stopButton.Font = Enum.Font.GothamBold
stopButton.Text = "⏹ Stop Flinging"
stopButton.TextColor3 = Color3.new(1, 1, 1)
stopButton.TextSize = 18
stopButton.ZIndex = 3
stopButton.Visible = false

Instance.new("UICorner", stopButton).CornerRadius = UDim.new(0, 6)

-- Status label
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Position = UDim2.new(0.1, 0, 0.68, 0)
statusLabel.Size = UDim2.new(0.8, 0, 0.25, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 14
statusLabel.Text = "Enter a player name and click Start"
statusLabel.TextWrapped = true
statusLabel.ZIndex = 3

-- Flinging state
local isFlinging = false
local flingTarget = nil

-- Wait for character to respawn
local function waitForCharacter()
    local char = LocalPlayer.Character
    if char then return char end
    
    LocalPlayer.CharacterAdded:Wait()
    return LocalPlayer.Character
end

-- AGGRESSIVE Fling function (single loop iteration)
local function aggressiveFling(target)
    if not isFlinging then return end
    
    local char = LocalPlayer.Character
    if not char then
        char = waitForCharacter()
    end
    
    if not (char and target and target.Character) then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Add BodyThrust
    local thr = Instance.new("BodyThrust")
    thr.Name = "FlingThrust"
    thr.Force = Vector3.new(9999, 9999, 9999)
    thr.Location = hrp.Position
    thr.Parent = hrp

    repeat
        if not isFlinging then break end
        
        -- Check if we died and respawn
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            thr:Destroy()
            char = waitForCharacter()
            hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                thr = Instance.new("BodyThrust")
                thr.Name = "FlingThrust"
                thr.Force = Vector3.new(9999, 9999, 9999)
                thr.Location = hrp.Position
                thr.Parent = hrp
            end
        end
        
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame
            thr.Location = target.Character.HumanoidRootPart.Position
        end
        
        RunService.Heartbeat:Wait()
    until not isFlinging or (not target.Character or not target.Character:FindFirstChild("Head")) or not gui or not gui.Parent
    
    if thr then
        thr:Destroy()
    end
end

-- Continuous fling loop
local function startFlingLoop(target)
    if isFlinging then return end
    
    isFlinging = true
    flingTarget = target
    
    spawn(function()
        while isFlinging and gui and gui.Parent do
            if not target.Parent then
                statusLabel.Text = "❌ Player left the game"
                statusLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
                break
            end
            
            aggressiveFling(target)
            
            -- Small delay before next fling attempt
            wait(0.1)
        end
    end)
end

-- Stop flinging
local function stopFlinging()
    isFlinging = false
    flingTarget = nil
    statusLabel.Text = "⏹ Flinging stopped"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    startButton.Visible = true
    stopButton.Visible = false
end

-- Start button click
startButton.MouseButton1Click:Connect(function()
    local target = findPlayer(box.Text)
    if target and target ~= LocalPlayer then
        statusLabel.Text = "🔄 Flinging: " .. target.Name .. "\nPress Stop to end"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        startButton.Visible = false
        stopButton.Visible = true
        startFlingLoop(target)
    else
        statusLabel.Text = "❌ Player not found!\nEnter a valid player name"
        statusLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
    end
end)

-- Stop button click
stopButton.MouseButton1Click:Connect(function()
    stopFlinging()
end)

-- Draggable GUI
local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Load notice
StarterGui:SetCore("SendNotification", {
    Title = "Fling GUI",
    Text = "Loop Mode Ready ✔ - Created by Axrex",
    Icon = "rbxassetid://7734068321",
    Duration = 5
})
