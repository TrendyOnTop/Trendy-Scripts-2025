-- Simplified Script - Target Aim, Camlock, CSync, Bullet TP
local Menu = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/library/refs/heads/main/cuh.txt",true))()

task.spawn(function()
    Menu:NameUpdate(0.6, 'Cactus', '.GG [khen.cc]')
end)

-- Settings Table
local Settings = {
    TargetAim = {
        Enabled = false,
        LookAt = true,
        SelectedPart = "HumanoidRootPart",
        HorizontalPrediction = 0.145,
        ResolverEnabled = false,
        AutoAir = true,
        JumpOffset = 0.06,
        Smoothness = 0.900,
        Camera = false,
        EasingStyle = "Sine",
        EasingDirection = "Out"
    },
    CSync = {
        Enabled = true, -- Always on
        Spoof = false,
        Type = "Orbit",
        Distance = 10,
        Height = 2,
        Speed = 10,
        RandomAmount = 10,
        Color = Color3.fromRGB(255, 255, 255),
        Visualize = {
            Enabled = false,
            Color = Color3.fromRGB(255, 255, 255)
        }
    },
    BulletTP = {
        Enabled = true, -- Always on
        Anchor = false,
        Offset = {0, -1, 0},
        Prediction = 0.145,
        UsePrediction = true,
        TeleportOnActivate = true
    },
    TargetHighlight = {
        Enabled = true,
        FillColor = Color3.fromRGB(255, 255, 255),
        OutlineColor = Color3.fromRGB(255, 255, 255),
        FillTransparency = 0.5,
        OutlineTransparency = 0
    }
}

-- Locals
local LocalPlayer = game.Players.LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

local TargetPlr = nil
local TargBindEnabled = false
local target_health = nil

-- Target Highlight
local TargHighlight = Instance.new("Highlight")
TargHighlight.Parent = game.CoreGui
TargHighlight.FillColor = Settings.TargetHighlight.FillColor
TargHighlight.OutlineColor = Settings.TargetHighlight.OutlineColor
TargHighlight.FillTransparency = Settings.TargetHighlight.FillTransparency
TargHighlight.OutlineTransparency = Settings.TargetHighlight.OutlineTransparency
TargHighlight.Enabled = false

-- CSync Visualization
local IgnoreFolder = Instance.new("Folder", Workspace)
local desync_setback = Instance.new("Part")
desync_setback.Name = "desync_setback"
desync_setback.Parent = Workspace
desync_setback.Size = Vector3.new(2, 2, 2)
desync_setback.CanCollide = false
desync_setback.Anchored = true
desync_setback.Transparency = 1

local CFrameVisualize = game:GetObjects("rbxassetid://9474737816")[1]
CFrameVisualize.Head.Face:Destroy()
for _, v in pairs(CFrameVisualize:GetChildren()) do
    v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.70
    v.Material = "Neon"
    v.Color = Color3.fromRGB(153, 0, 153)
    v.CanCollide = false
    v.Anchored = false
end

-- Simple Draggable Settings UI
local SettingsGui = Instance.new("ScreenGui")
SettingsGui.Name = "SettingsGui"
SettingsGui.Parent = game.CoreGui
SettingsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SettingsGui.ResetOnSpawn = false

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Parent = SettingsGui
SettingsFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
SettingsFrame.BorderSizePixel = 0
SettingsFrame.Size = UDim2.new(0, 300, 0, 400)
SettingsFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
SettingsFrame.Active = true
SettingsFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = SettingsFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = SettingsFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(16, 16, 32)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = SettingsFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Font = Enum.Font.ArialBold
TitleLabel.Text = "Settings"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = SettingsFrame
ScrollFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Toggle Settings UI Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleSettings"
ToggleButton.Parent = SettingsGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
ToggleButton.BorderSizePixel = 0
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(1, -130, 0, 10)
ToggleButton.Font = Enum.Font.ArialBold
ToggleButton.Text = "Settings"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Parent = ToggleButton
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(16, 16, 32)

local SettingsVisible = false
ToggleButton.MouseButton1Click:Connect(function()
    SettingsVisible = not SettingsVisible
    SettingsFrame.Visible = SettingsVisible
end)
SettingsFrame.Visible = false

-- Lock Button
local LockButton = Instance.new("TextButton")
LockButton.Name = "LockButton"
LockButton.Parent = SettingsGui
LockButton.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
LockButton.BorderSizePixel = 0
LockButton.Size = UDim2.new(0, 150, 0, 50)
LockButton.Position = UDim2.new(0.5, -75, 0.5, -25)
LockButton.Font = Enum.Font.ArialBold
LockButton.Text = "Lock: <font color='rgb(255, 0, 0)'>OFF</font>"
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.TextSize = 20
LockButton.RichText = true
LockButton.Active = true
LockButton.Draggable = true

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 8)
LockCorner.Parent = LockButton

local LockStroke = Instance.new("UIStroke")
LockStroke.Parent = LockButton
LockStroke.Thickness = 2
LockStroke.Color = Color3.fromRGB(16, 16, 32)

-- Function to create setting controls
local function CreateColorPicker(parent, text, color, callback)
    local ColorFrame = Instance.new("Frame")
    ColorFrame.Parent = parent
    ColorFrame.BackgroundTransparency = 1
    ColorFrame.Size = UDim2.new(1, 0, 0, 30)
    
    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Parent = ColorFrame
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ColorLabel.Position = UDim2.new(0, 0, 0, 0)
    ColorLabel.Font = Enum.Font.Arial
    ColorLabel.Text = text
    ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorLabel.TextSize = 14
    ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ColorBtn = Instance.new("TextButton")
    ColorBtn.Parent = ColorFrame
    ColorBtn.Size = UDim2.new(0, 50, 0, 25)
    ColorBtn.Position = UDim2.new(1, -55, 0, 2.5)
    ColorBtn.BackgroundColor3 = color
    ColorBtn.BorderSizePixel = 0
    ColorBtn.Font = Enum.Font.ArialBold
    ColorBtn.Text = ""
    ColorBtn.TextSize = 12
    
    local ColorBtnCorner = Instance.new("UICorner")
    ColorBtnCorner.CornerRadius = UDim.new(0, 5)
    ColorBtnCorner.Parent = ColorBtn
    
    ColorBtn.MouseButton1Click:Connect(function()
        -- Simple color picker - you can enhance this with a proper color picker UI
        local r = math.random(0, 255)
        local g = math.random(0, 255)
        local b = math.random(0, 255)
        local newColor = Color3.fromRGB(r, g, b)
        ColorBtn.BackgroundColor3 = newColor
        callback(newColor)
    end)
    
    return ColorFrame
end

local function CreateToggle(parent, text, value, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
    ToggleLabel.Font = Enum.Font.Arial
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = ToggleFrame
    ToggleBtn.Size = UDim2.new(0, 50, 0, 25)
    ToggleBtn.Position = UDim2.new(1, -55, 0, 2.5)
    ToggleBtn.BackgroundColor3 = value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Font = Enum.Font.ArialBold
    ToggleBtn.Text = value and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 12
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(0, 5)
    ToggleBtnCorner.Parent = ToggleBtn
    
    ToggleBtn.MouseButton1Click:Connect(function()
        value = not value
        ToggleBtn.BackgroundColor3 = value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        ToggleBtn.Text = value and "ON" or "OFF"
        callback(value)
    end)
    
    return ToggleFrame
end

local function CreateSlider(parent, text, min, max, value, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.Font = Enum.Font.Arial
    SliderLabel.Text = text .. ": " .. tostring(value)
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = SliderFrame
    SliderBar.Size = UDim2.new(1, 0, 0, 5)
    SliderBar.Position = UDim2.new(0, 0, 0, 25)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderBar.BorderSizePixel = 0
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(0, 2)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderFill.BorderSizePixel = 0
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 2)
    SliderFillCorner.Parent = SliderFill
    
    local dragging = false
    SliderBar.InputBegan:Connect(function(input)
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
            local pos = input.Position.X - SliderBar.AbsolutePosition.X
            local percent = math.clamp(pos / SliderBar.AbsoluteSize.X, 0, 1)
            local newValue = min + (max - min) * percent
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderLabel.Text = text .. ": " .. string.format("%.2f", newValue)
            callback(newValue)
        end
    end)
    
    return SliderFrame
end

local function CreateTextBox(parent, text, value, callback)
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Parent = parent
    TextBoxFrame.BackgroundTransparency = 1
    TextBoxFrame.Size = UDim2.new(1, 0, 0, 30)
    
    local TextBoxLabel = Instance.new("TextLabel")
    TextBoxLabel.Parent = TextBoxFrame
    TextBoxLabel.BackgroundTransparency = 1
    TextBoxLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TextBoxLabel.Font = Enum.Font.Arial
    TextBoxLabel.Text = text
    TextBoxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBoxLabel.TextSize = 14
    TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = TextBoxFrame
    TextBox.Size = UDim2.new(0.45, 0, 0, 25)
    TextBox.Position = UDim2.new(0.5, 5, 0, 2.5)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.BorderSizePixel = 0
    TextBox.Font = Enum.Font.Arial
    TextBox.Text = tostring(value)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 14
    
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 5)
    TextBoxCorner.Parent = TextBox
    
    TextBox.FocusLost:Connect(function()
        callback(tonumber(TextBox.Text) or value)
    end)
    
    return TextBoxFrame
end

local function CreateDropdown(parent, text, options, current, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Parent = DropdownFrame
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Size = UDim2.new(0.5, 0, 1, 0)
    DropdownLabel.Font = Enum.Font.Arial
    DropdownLabel.Text = text
    DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownLabel.TextSize = 14
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Parent = DropdownFrame
    DropdownBtn.Size = UDim2.new(0.45, 0, 0, 25)
    DropdownBtn.Position = UDim2.new(0.5, 5, 0, 2.5)
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownBtn.BorderSizePixel = 0
    DropdownBtn.Font = Enum.Font.Arial
    DropdownBtn.Text = current
    DropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownBtn.TextSize = 14
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 5)
    DropdownCorner.Parent = DropdownBtn
    
    DropdownBtn.MouseButton1Click:Connect(function()
        local currentIndex = 1
        for i, v in ipairs(options) do
            if v == current then
                currentIndex = i
                break
            end
        end
        currentIndex = (currentIndex % #options) + 1
        current = options[currentIndex]
        DropdownBtn.Text = current
        callback(current)
    end)
    
    return DropdownFrame
end

-- Create Settings UI
CreateToggle(ScrollFrame, "Target Aim Enabled", Settings.TargetAim.Enabled, function(val)
    Settings.TargetAim.Enabled = val
end)

CreateToggle(ScrollFrame, "Look At Target", Settings.TargetAim.LookAt, function(val)
    Settings.TargetAim.LookAt = val
end)

CreateToggle(ScrollFrame, "Camera Lock", Settings.TargetAim.Camera, function(val)
    Settings.TargetAim.Camera = val
end)

CreateToggle(ScrollFrame, "Resolver", Settings.TargetAim.ResolverEnabled, function(val)
    Settings.TargetAim.ResolverEnabled = val
end)

CreateToggle(ScrollFrame, "Auto Air", Settings.TargetAim.AutoAir, function(val)
    Settings.TargetAim.AutoAir = val
end)

CreateDropdown(ScrollFrame, "Hit Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}, Settings.TargetAim.SelectedPart, function(val)
    Settings.TargetAim.SelectedPart = val
end)

CreateSlider(ScrollFrame, "Horizontal Prediction", 0, 1, Settings.TargetAim.HorizontalPrediction, function(val)
    Settings.TargetAim.HorizontalPrediction = val
end)

CreateSlider(ScrollFrame, "Smoothness", 0, 1, Settings.TargetAim.Smoothness, function(val)
    Settings.TargetAim.Smoothness = val
end)

CreateSlider(ScrollFrame, "Jump Offset", -1, 1, Settings.TargetAim.JumpOffset, function(val)
    Settings.TargetAim.JumpOffset = val
end)

CreateDropdown(ScrollFrame, "Easing Style", {"Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Exponential", "Circular", "Back", "Bounce", "Elastic"}, Settings.TargetAim.EasingStyle, function(val)
    Settings.TargetAim.EasingStyle = val
end)

CreateDropdown(ScrollFrame, "Easing Direction", {"In", "Out", "InOut"}, Settings.TargetAim.EasingDirection, function(val)
    Settings.TargetAim.EasingDirection = val
end)

-- CSync Settings (Always Enabled)
CreateSlider(ScrollFrame, "CSync Distance", 0, 20, Settings.CSync.Distance, function(val)
    Settings.CSync.Distance = val
end)

CreateSlider(ScrollFrame, "CSync Height", 0, 10, Settings.CSync.Height, function(val)
    Settings.CSync.Height = val
end)

CreateSlider(ScrollFrame, "CSync Speed", 0, 20, Settings.CSync.Speed, function(val)
    Settings.CSync.Speed = val
end)

CreateDropdown(ScrollFrame, "CSync Type", {"Orbit", "Random"}, Settings.CSync.Type, function(val)
    Settings.CSync.Type = val
end)

-- CSync Spoof Setting
CreateToggle(ScrollFrame, "CSync Spoof", Settings.CSync.Spoof, function(val)
    Settings.CSync.Spoof = val
end)

CreateToggle(ScrollFrame, "CSync Visualize", Settings.CSync.Visualize.Enabled, function(val)
    Settings.CSync.Visualize.Enabled = val
end)

CreateColorPicker(ScrollFrame, "CSync Color", Settings.CSync.Visualize.Color, function(val)
    Settings.CSync.Visualize.Color = val
end)

-- Target Highlight Settings
CreateToggle(ScrollFrame, "Target Highlight", Settings.TargetHighlight.Enabled, function(val)
    Settings.TargetHighlight.Enabled = val
end)

CreateColorPicker(ScrollFrame, "Highlight Fill", Settings.TargetHighlight.FillColor, function(val)
    Settings.TargetHighlight.FillColor = val
end)

CreateColorPicker(ScrollFrame, "Highlight Outline", Settings.TargetHighlight.OutlineColor, function(val)
    Settings.TargetHighlight.OutlineColor = val
end)

CreateSlider(ScrollFrame, "Fill Transparency", 0, 1, Settings.TargetHighlight.FillTransparency, function(val)
    Settings.TargetHighlight.FillTransparency = val
end)

CreateSlider(ScrollFrame, "Outline Transparency", 0, 1, Settings.TargetHighlight.OutlineTransparency, function(val)
    Settings.TargetHighlight.OutlineTransparency = val
end)

-- Bullet TP Settings (Always Enabled)
CreateToggle(ScrollFrame, "Bullet TP Anchor", Settings.BulletTP.Anchor, function(val)
    Settings.BulletTP.Anchor = val
end)

CreateToggle(ScrollFrame, "Use Prediction", Settings.BulletTP.UsePrediction, function(val)
    Settings.BulletTP.UsePrediction = val
end)

CreateToggle(ScrollFrame, "Teleport On Activate", Settings.BulletTP.TeleportOnActivate, function(val)
    Settings.BulletTP.TeleportOnActivate = val
end)

CreateTextBox(ScrollFrame, "Offset X", Settings.BulletTP.Offset[1], function(val)
    Settings.BulletTP.Offset[1] = val
end)

CreateTextBox(ScrollFrame, "Offset Y", Settings.BulletTP.Offset[2], function(val)
    Settings.BulletTP.Offset[2] = val
end)

CreateTextBox(ScrollFrame, "Offset Z", Settings.BulletTP.Offset[3], function(val)
    Settings.BulletTP.Offset[3] = val
end)

CreateSlider(ScrollFrame, "Bullet TP Prediction", 0, 1, Settings.BulletTP.Prediction, function(val)
    Settings.BulletTP.Prediction = val
end)

-- Update ScrollFrame CanvasSize
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- Target Finding Function
local function FindClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local player = LocalPlayer
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local fovRadius = 250
    local viewportSize = Camera.ViewportSize

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") 
           and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            
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

-- Lock Toggle Function
local function ToggleLock()
    if Settings.TargetAim.Enabled then
        if TargBindEnabled and TargetPlr then
            TargBindEnabled = false
            target_health = nil
            TargetPlr = nil
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
            if Settings.TargetAim.LookAt then
                LocalPlayer.Character.Humanoid.AutoRotate = true
            end
            LockButton.Text = "Lock: <font color='rgb(255, 0, 0)'>OFF</font>"
        else
            local closest = FindClosestTarget()
            if closest then
                TargBindEnabled = true
                TargetPlr = closest
                if TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
                    target_health = TargetPlr.Character.Humanoid.Health
                end
                LockButton.Text = "Lock: <font color='rgb(0, 255, 0)'>ON</font>"
            end
        end
    end
end

LockButton.MouseButton1Click:Connect(ToggleLock)

-- Target Aim Logic
local function predictedposition()
    if not TargetPlr or not TargetPlr.Character then return nil end
    
    local selectedPart = Settings.TargetAim.SelectedPart
    local targetPart = TargetPlr.Character[selectedPart]
    if not targetPart then return nil end

    local velocity
    if Settings.TargetAim.ResolverEnabled then
        velocity = TargetPlr.Character.Humanoid.MoveDirection * TargetPlr.Character.Humanoid.WalkSpeed
    else
        velocity = targetPart.Velocity
    end

    local horizontalPrediction = Settings.TargetAim.HorizontalPrediction
    local jumpOffset = Settings.TargetAim.JumpOffset

    local predictedPosition = Vector3.new(
        targetPart.Position.X + (velocity.X * horizontalPrediction),
        targetPart.Position.Y + jumpOffset,
        targetPart.Position.Z + (velocity.Z * horizontalPrediction)
    )

    return predictedPosition
end

-- Namecall Hook for Target Aim
local remoteInfo = {Remote = "MainEvent", Argument = "UpdateMousePos"}
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

__namecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local args, method = {...}, tostring(getnamecallmethod())

    if not checkcaller() and method == "FireServer" and Settings.TargetAim.Enabled and TargBindEnabled and TargetPlr then
        for i, arg in pairs(args) do
            if typeof(arg) == "Vector3" then
                local predictedPos = predictedposition()
                if predictedPos then
                    args[i] = predictedPos
                end
            elseif type(arg) == "table" then
                for index, element in ipairs(arg) do
                    if typeof(element) == "Vector3" then
                        local predictedPos = predictedposition()
                        if predictedPos then
                            arg[index] = predictedPos
                        end
                    end
                end
            end
        end
        return __namecall(Self, unpack(args))
    end

    return __namecall(Self, ...)
end))

-- Look At Function
local function LookAtPlayer(Target)
    if not Settings.TargetAim.LookAt or not TargBindEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.AutoRotate = true
        end
        return
    end
    
    local localChar = LocalPlayer.Character
    if not localChar then return end
    
    local localHumanoidRootPart = localChar:FindFirstChild("HumanoidRootPart")
    if not localHumanoidRootPart then return end

    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
        local targetHumanoidRootPart = Target.Character.HumanoidRootPart
        local targetPosition = targetHumanoidRootPart.Position
        local localPosition = localHumanoidRootPart.Position
        local horizontalDirection = Vector3.new(targetPosition.X - localPosition.X, 0, targetPosition.Z - localPosition.Z).unit
        localHumanoidRootPart.CFrame = CFrame.new(localPosition, localPosition + horizontalDirection)
        localChar.Humanoid.AutoRotate = false
    else
        if localChar:FindFirstChild("Humanoid") then
            localChar.Humanoid.AutoRotate = true
        end
    end
end

-- Camera Lock
RunService.Heartbeat:Connect(function()
    if Settings.TargetAim.Camera and TargBindEnabled and TargetPlr and TargetPlr.Character then
        local selectedPart = Settings.TargetAim.SelectedPart
        local targetPart = TargetPlr.Character[selectedPart]
        if not targetPart then return end

        local velocity = targetPart.Velocity
        local horizontalPrediction = Settings.TargetAim.HorizontalPrediction
        local jumpOffset = Settings.TargetAim.JumpOffset

        local targetPosition = Vector3.new(
            targetPart.Position.X + (velocity.X * horizontalPrediction),
            targetPart.Position.Y + jumpOffset,
            targetPart.Position.Z + (velocity.Z * horizontalPrediction)
        )

        local smoothness = Settings.TargetAim.Smoothness
        local easingStyle = Enum.EasingStyle[Settings.TargetAim.EasingStyle] or Enum.EasingStyle.Sine
        local easingDirection = Enum.EasingDirection[Settings.TargetAim.EasingDirection] or Enum.EasingDirection.Out

        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPosition), smoothness, easingStyle, easingDirection)
    end
end)

-- Target Highlight Update
RunService.RenderStepped:Connect(function()
    if Settings.TargetHighlight.Enabled and TargBindEnabled and TargetPlr and TargetPlr.Character then
        TargHighlight.FillColor = Settings.TargetHighlight.FillColor
        TargHighlight.OutlineColor = Settings.TargetHighlight.OutlineColor
        TargHighlight.FillTransparency = Settings.TargetHighlight.FillTransparency
        TargHighlight.OutlineTransparency = Settings.TargetHighlight.OutlineTransparency
        TargHighlight.Adornee = TargetPlr.Character
        TargHighlight.Enabled = true
    else
        TargHighlight.Adornee = nil
        TargHighlight.Enabled = false
    end
end)

-- CSync (Always Enabled)
RunService.Heartbeat:Connect(function()
    CFrameVisualize.Parent = (Settings.CSync.Enabled and Settings.CSync.Visualize.Enabled) and IgnoreFolder or nil
    
    if Settings.CSync.Enabled and TargetPlr and TargBindEnabled then
        local FakeCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        local Saved = LocalPlayer.Character.HumanoidRootPart.CFrame
        
        if Settings.CSync.Type == "Random" then
            FakeCFrame = CFrame.new(TargetPlr.Character.HumanoidRootPart.Position + Vector3.new(
                math.random(-Settings.CSync.RandomAmount, Settings.CSync.RandomAmount),
                math.random(0, Settings.CSync.RandomAmount),
                math.random(-Settings.CSync.RandomAmount, Settings.CSync.RandomAmount)
            )) * CFrame.Angles(
                math.rad(math.random(0, 360)),
                math.rad(math.random(0, 360)),
                math.rad(math.random(0, 360))
            )
        elseif Settings.CSync.Type == "Orbit" then
            local CurrentTime = tick()
            FakeCFrame = CFrame.new(TargetPlr.Character.HumanoidRootPart.Position) * 
                CFrame.Angles(0, 2 * math.pi * CurrentTime * Settings.CSync.Speed % (2 * math.pi), 0) * 
                CFrame.new(0, Settings.CSync.Height, Settings.CSync.Distance)
        end

        if Settings.CSync.Visualize.Enabled then
            CFrameVisualize:SetPrimaryPartCFrame(FakeCFrame)
            for _, Part in pairs(CFrameVisualize:GetChildren()) do
                if Part:IsA("BasePart") then
                    Part.Color = Settings.CSync.Visualize.Color
                end
            end
        end

        if Settings.CSync.Spoof then
            LocalPlayer.Character.HumanoidRootPart.CFrame = FakeCFrame
            RunService.RenderStepped:Wait()
            desync_setback.Position = Saved.Position + Vector3.new(0, 1.5, 0)
            Camera.CameraSubject = desync_setback
            LocalPlayer.Character.HumanoidRootPart.CFrame = Saved
        else
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    else
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

-- Bullet TP (Always Enabled)
local function cframe_to_offset(origin, target)
    local actual_origin = origin * CFrame.new(Settings.BulletTP.Offset[1], Settings.BulletTP.Offset[2], Settings.BulletTP.Offset[3], 1, 0, 0, 0, 0, 1, 0, -1, 0)
    return actual_origin:ToObjectSpace(target):inverse()
end

local function something_tp(Tool)
    local old_grip = Tool.Grip
    if TargetPlr and TargetPlr.Character and TargBindEnabled and Settings.BulletTP.Enabled then
        Tool.Parent = LocalPlayer.Backpack
        LocalPlayer.Character.RightHand.Anchored = Settings.BulletTP.Anchor
        
        local targetCFrame = TargetPlr.Character.HumanoidRootPart.CFrame
        if Settings.BulletTP.UsePrediction then
            local velocity = TargetPlr.Character.HumanoidRootPart.Velocity
            local predictedPos = TargetPlr.Character.HumanoidRootPart.Position + (velocity * Settings.BulletTP.Prediction)
            targetCFrame = CFrame.new(predictedPos)
        end
        
        Tool.Grip = cframe_to_offset(LocalPlayer.Character.RightHand.CFrame, targetCFrame)
        LocalPlayer.Character.RightHand.Anchored = true
        Tool.Parent = LocalPlayer.Character
        
        if Settings.BulletTP.TeleportOnActivate then
            RunService.RenderStepped:Wait()
        end
        
        Tool.Parent = LocalPlayer.Backpack
        LocalPlayer.Character.RightHand.Anchored = false
        Tool.Grip = old_grip
        Tool.Parent = LocalPlayer.Character
    end
end

local function bullet_teleport(Character)
    Character.ChildAdded:Connect(function(Child)
        if Settings.BulletTP.Enabled and Child:IsA("Tool") then
            local Connection
            Connection = Child.Activated:Connect(function()
                something_tp(Child)
            end)

            Character.ChildRemoved:Connect(function(RemovedChild)
                if RemovedChild == Child then
                    Connection:Disconnect()
                end
            end)
        end
    end)
end

bullet_teleport(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(function()
    bullet_teleport(LocalPlayer.Character)
end)

-- Main Loop
RunService.Stepped:Connect(function()
    LookAtPlayer(TargetPlr)
end)

print("Script loaded successfully!")
