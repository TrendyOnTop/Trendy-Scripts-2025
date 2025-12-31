-- Camera Lock System by eternity.win
-- Features: Target lock, gradient FOV, prediction, smoothness, settings UI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Settings
local Settings = {
	Enabled = false,
	Target = nil,
	PredictionX = 0.15,
	PredictionY = 0.15,
	Smoothness = 0.15,
	CFrameWalkSpeed = 16,
	FOV = 70,
	FOVSpeed = 2,
	ShowSettings = false
}

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CameraLockUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Lock Button
local LockButton = Instance.new("TextButton")
LockButton.Name = "LockButton"
LockButton.Size = UDim2.new(0, 120, 0, 40)
LockButton.Position = UDim2.new(0, 10, 0, 10)
LockButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
LockButton.BorderSizePixel = 0
LockButton.Text = "eternity.win"
LockButton.TextColor3 = Color3.fromRGB(0, 0, 0)
LockButton.TextSize = 14
LockButton.Font = Enum.Font.Gotham
LockButton.Parent = ScreenGui

-- Settings Toggle Button
local SettingsToggle = Instance.new("TextButton")
SettingsToggle.Name = "SettingsToggle"
SettingsToggle.Size = UDim2.new(0, 100, 0, 30)
SettingsToggle.Position = UDim2.new(0, 10, 0, 60)
SettingsToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SettingsToggle.BorderSizePixel = 0
SettingsToggle.Text = "Settings"
SettingsToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsToggle.TextSize = 12
SettingsToggle.Font = Enum.Font.Gotham
SettingsToggle.Parent = ScreenGui

-- Settings Frame
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Size = UDim2.new(0, 300, 0, 400)
SettingsFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SettingsFrame.BorderSizePixel = 0
SettingsFrame.Visible = false
SettingsFrame.Parent = ScreenGui

local UICorner1 = Instance.new("UICorner")
UICorner1.CornerRadius = UDim.new(0, 8)
UICorner1.Parent = SettingsFrame

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Name = "SettingsTitle"
SettingsTitle.Size = UDim2.new(1, 0, 0, 40)
SettingsTitle.Position = UDim2.new(0, 0, 0, 0)
SettingsTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SettingsTitle.BorderSizePixel = 0
SettingsTitle.Text = "Camera Lock Settings"
SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsTitle.TextSize = 18
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.Parent = SettingsFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = SettingsTitle

-- Prediction X Slider
local function createSlider(name, labelText, defaultValue, minVal, maxVal, yPos, callback)
	local container = Instance.new("Frame")
	container.Name = name
	container.Size = UDim2.new(1, -20, 0, 60)
	container.Position = UDim2.new(0, 10, 0, yPos)
	container.BackgroundTransparency = 1
	container.Parent = SettingsFrame
	
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "ValueLabel"
	valueLabel.Size = UDim2.new(0, 60, 0, 20)
	valueLabel.Position = UDim2.new(1, -60, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(defaultValue)
	valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	valueLabel.TextSize = 12
	valueLabel.Font = Enum.Font.Gotham
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = container
	
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = "SliderFrame"
	sliderFrame.Size = UDim2.new(1, 0, 0, 20)
	sliderFrame.Position = UDim2.new(0, 0, 0, 30)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	sliderFrame.BorderSizePixel = 0
	sliderFrame.Parent = container
	
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = sliderFrame
	
	local fillFrame = Instance.new("Frame")
	fillFrame.Name = "FillFrame"
	fillFrame.Size = UDim2.new((defaultValue - minVal) / (maxVal - minVal), 0, 1, 0)
	fillFrame.Position = UDim2.new(0, 0, 0, 0)
	fillFrame.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	fillFrame.BorderSizePixel = 0
	fillFrame.Parent = sliderFrame
	
	local UICorner2 = Instance.new("UICorner")
	UICorner2.CornerRadius = UDim.new(0, 4)
	UICorner2.Parent = fillFrame
	
	local dragging = false
	
	sliderFrame.InputBegan:Connect(function(input)
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
		if dragging and input.UserInputType == Enum.UserInputType.MousePosition then
			local mousePos = UserInputService:GetMouseLocation()
			local sliderPos = sliderFrame.AbsolutePosition
			local sliderSize = sliderFrame.AbsoluteSize
			local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
			local value = minVal + (relativeX * (maxVal - minVal))
			value = math.floor(value * 100) / 100
			
			fillFrame.Size = UDim2.new(relativeX, 0, 1, 0)
			valueLabel.Text = tostring(value)
			callback(value)
		end
	end)
	
	return container
end

-- Create sliders
createSlider("PredictionXSlider", "Prediction X:", Settings.PredictionX, 0, 1, 50, function(val)
	Settings.PredictionX = val
end)

createSlider("PredictionYSlider", "Prediction Y:", Settings.PredictionY, 0, 1, 120, function(val)
	Settings.PredictionY = val
end)

createSlider("SmoothnessSlider", "Smoothness:", Settings.Smoothness, 0.01, 1, 190, function(val)
	Settings.Smoothness = val
end)

createSlider("WalkSpeedSlider", "CFrame Walk Speed:", Settings.CFrameWalkSpeed, 1, 50, 260, function(val)
	Settings.CFrameWalkSpeed = val
end)

createSlider("FOVSpeedSlider", "FOV Speed:", Settings.FOVSpeed, 0.1, 10, 330, function(val)
	Settings.FOVSpeed = val
end)

-- Button Events
LockButton.MouseButton1Click:Connect(function()
	Settings.Enabled = not Settings.Enabled
	if Settings.Enabled then
		LockButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		-- Find nearest target
		local nearest = nil
		local nearestDist = math.huge
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
				if dist < nearestDist then
					nearestDist = dist
					nearest = player
				end
			end
		end
		Settings.Target = nearest
	else
		LockButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
		Settings.Target = nil
	end
end)

SettingsToggle.MouseButton1Click:Connect(function()
	Settings.ShowSettings = not Settings.ShowSettings
	SettingsFrame.Visible = Settings.ShowSettings
end)

-- Target finding function
local function findTarget()
	if not Settings.Enabled then return nil end
	
	local nearest = nil
	local nearestDist = math.huge
	local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	
	if not myPos then return nil end
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local targetPart = player.Character.HumanoidRootPart
			local dist = (myPos.Position - targetPart.Position).Magnitude
			if dist < nearestDist and dist < 1000 then
				nearestDist = dist
				nearest = player
			end
		end
	end
	
	return nearest
end

-- Prediction calculation
local function calculatePrediction(target)
	if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
		return Vector3.new()
	end
	
	local targetRoot = target.Character.HumanoidRootPart
	local targetVelocity = targetRoot.AssemblyLinearVelocity
	
	return Vector3.new(
		targetVelocity.X * Settings.PredictionX,
		targetVelocity.Y * Settings.PredictionY,
		targetVelocity.Z * Settings.PredictionX
	)
end

-- Gradient FOV calculation
local fovTime = 0
local function updateFOV()
	fovTime = fovTime + (Settings.FOVSpeed * 0.01)
	
	-- Pink to Yellow gradient
	local t = (math.sin(fovTime) + 1) / 2 -- Normalize to 0-1
	local pink = Color3.fromRGB(255, 20, 147)
	local yellow = Color3.fromRGB(255, 255, 0)
	local gradientColor = pink:lerp(yellow, t)
	
	-- Apply FOV with slight variation
	local baseFOV = Settings.FOV
	local fovVariation = math.sin(fovTime * 2) * 5
	Camera.FieldOfView = baseFOV + fovVariation
	
	-- Update lock button color with gradient
	if Settings.Enabled then
		LockButton.BackgroundColor3 = gradientColor
	end
end

-- Camera lock function
local lastCFrame = nil
local function lockCamera()
	if not Settings.Enabled then
		lastCFrame = nil
		return
	end
	
	local target = Settings.Target or findTarget()
	if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
		Settings.Target = nil
		return
	end
	
	Settings.Target = target
	
	local targetRoot = target.Character.HumanoidRootPart
	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	
	if not myRoot then return end
	
	-- Calculate prediction
	local prediction = calculatePrediction(target)
	local targetPosition = targetRoot.Position + prediction
	
	-- Calculate direction
	local direction = (targetPosition - myRoot.Position).Unit
	
	-- Create CFrame
	local newCFrame = CFrame.lookAt(myRoot.Position, targetPosition)
	
	-- Apply smoothness
	if lastCFrame then
		newCFrame = lastCFrame:Lerp(newCFrame, Settings.Smoothness)
	end
	
	-- Apply to camera
	Camera.CFrame = newCFrame
	lastCFrame = newCFrame
end

-- Main loop
RunService.Heartbeat:Connect(function()
	updateFOV()
	lockCamera()
end)

-- Update target periodically
spawn(function()
	while true do
		wait(0.5)
		if Settings.Enabled and (not Settings.Target or not Settings.Target.Character or not Settings.Target.Character:FindFirstChild("HumanoidRootPart")) then
			Settings.Target = findTarget()
		end
	end
end)

print("Camera Lock System loaded - eternity.win")
