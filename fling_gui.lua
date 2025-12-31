-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Fling GUI Start --

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "FlingGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 200)
frame.Position = UDim2.new(0.5, -160, 0.5, -100)
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
title.Text = "⚡ Fling GUI (Auto Mode)"
title.ZIndex = 4

-- Status label
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
statusLabel.Size = UDim2.new(0.8, 0, 0.4, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextSize = 16
statusLabel.Text = "🔄 Auto-Flinging Active\nAll players are being flung!"
statusLabel.TextWrapped = true
statusLabel.ZIndex = 3

-- AGGRESSIVE Fling function
local function aggressiveFling(target)
    local char = LocalPlayer.Character
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
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame
            thr.Location = target.Character.HumanoidRootPart.Position
        end
        RunService.Heartbeat:Wait()
    until not target.Character or not target.Character:FindFirstChild("Head") or not gui or not gui.Parent
    
    thr:Destroy()
end

-- Auto-fling all players
local function autoFlingPlayers()
    spawn(function()
        while gui and gui.Parent do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        aggressiveFling(player)
                    end
                end
            end
            wait(0.1)
        end
    end)
end

-- Start auto-flinging
autoFlingPlayers()

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
    Text = "Auto-Fling Active ✔ - Created by Axrex",
    Icon = "rbxassetid://7734068321",
    Duration = 5
})
