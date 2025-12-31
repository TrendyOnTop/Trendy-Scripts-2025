-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Fling GUI Başlangıç --

-- Player finder
local function findPlayers(searchString)
    local foundPlayers = {}
    local strl = searchString:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if strl == "all" or strl == "everyone" then
            table.insert(foundPlayers, player)
        elseif strl == "others" and player ~= LocalPlayer then
            table.insert(foundPlayers, player)
        elseif strl == "me" and player == LocalPlayer then
            table.insert(foundPlayers, player)
        elseif player.Name:lower():sub(1, #searchString) == strl then
            table.insert(foundPlayers, player)
        end
    end
    return foundPlayers
end

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "FlingGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 270)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
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
title.Text = "⚡ Fling GUI (Aggro Mode)"
title.ZIndex = 4

-- TextBox
local box = Instance.new("TextBox", frame)
box.Position = UDim2.new(0.1, 0, 0.25, 0)
box.Size = UDim2.new(0.8, 0, 0.15, 0)
box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
box.Font = Enum.Font.Gotham
box.PlaceholderText = "Enter player name..."
box.TextColor3 = Color3.new(1, 1, 1)
box.TextSize = 16
box.ZIndex = 3

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

-- Button
local button = Instance.new("TextButton", frame)
button.Position = UDim2.new(0.1, 0, 0.45, 0)
button.Size = UDim2.new(0.8, 0, 0.15, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
button.Font = Enum.Font.GothamBold
button.Text = "💥 Fling Hard!"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 18
button.ZIndex = 3

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

-- Notification
local notification = Instance.new("TextLabel", frame)
notification.Position = UDim2.new(0.1, 0, 0.65, 0)
notification.Size = UDim2.new(0.8, 0, 0.2, 0)
notification.BackgroundTransparency = 1
notification.Font = Enum.Font.Gotham
notification.TextColor3 = Color3.fromRGB(255, 255, 255)
notification.TextSize = 14
notification.Text = ""
notification.TextWrapped = true
notification.Visible = false
notification.ZIndex = 3

-- Notification anim
local function showNotice(text, color)
    notification.Text = text
    notification.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    notification.Visible = true
    TweenService:Create(notification, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
    wait(2)
    TweenService:Create(notification, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
    wait(0.3)
    notification.Visible = false
end

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
        if target.Character:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame
            thr.Location = target.Character.HumanoidRootPart.Position
        end
        RunService.Heartbeat:Wait()
    until not target.Character:FindFirstChild("Head") or not gui or not gui.Parent
    thr:Destroy()
end

-- Button click
button.MouseButton1Click:Connect(function()
    local targets = findPlayers(box.Text)
    if #targets > 0 then
        showNotice("🚀 Uçuruluyor...", Color3.fromRGB(0, 255, 0))
        aggressiveFling(targets[1])
    else
        showNotice("❌ Oyuncu bulunamadı!", Color3.fromRGB(255, 75, 75))
    end
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
    Text = "Downloaded ✔ - Created by Axrex",
    Icon = "rbxassetid://7734068321",
    Duration = 5
})
