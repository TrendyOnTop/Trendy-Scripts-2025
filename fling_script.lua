local function send(text)
	local StarterGui = game:GetService("StarterGui")
	StarterGui:SetCore("SendNotification",{
		Title = "Fling by danya23131", -- You can remove this, idc
		Text = text,
		Duration = 5
	})
end
local fakepart = Instance.new("Part", workspace)
local att1 = Instance.new("Attachment", fakepart)
local att2 = Instance.new("Attachment", game.Players.LocalPlayer.Character.HumanoidRootPart)
local body = Instance.new("AlignPosition", fakepart)
local mouse = game.Players.LocalPlayer:GetMouse()
body.Attachment0 = att2
body.Attachment1 = att1
body.RigidityEnabled = true
body.Responsiveness = math.huge
body.MaxForce = math.huge
body.MaxVelocity = math.huge
body.MaxAxesForce = Vector3.new(math.huge,math.huge,math.huge)
body.Visible = true
body.Mode = Enum.PositionAlignmentMode.TwoAttachment
game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.StrafingNoPhysics)
send("Please wait")
local oldcf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,40000000,0)) * CFrame.fromEulerAnglesXYZ(math.rad(180),0,0)
game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,1000000,0)
task.wait(3)
game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcf
task.wait(.2)	
local power = 100
local attack = 5
fakepart.Anchored = true
fakepart.Size = Vector3.new(5,5,5)
fakepart.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
fakepart.CanCollide = false
fakepart.Transparency = 0.5
fakepart.Material = Enum.Material.ForceField
for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
	if v:IsA("BasePart") then
		if v.Name ~= "HumanoidRootPart" then
			v.Transparency = .75
			v.Material = Enum.Material.Neon
		end
	elseif v:IsA("Decal") then
		v:Remove()
	end
end
local partic = Instance.new("ParticleEmitter", fakepart)
partic.Texture = "rbxassetid://15273937357"
partic.SpreadAngle = Vector2.new(-180,180)
partic.Rate = 45
partic.Size = NumberSequence.new(1,0)
partic.Transparency = NumberSequence.new(0.9)
partic.Lifetime = NumberRange.new(0.7,1)
partic.RotSpeed = NumberRange.new(-45,45)
workspace.CurrentCamera.CameraSubject = fakepart
spawn(function()
	while true do
		task.wait()
		for i = 0,1,0.01 do
			task.wait()
			fakepart.Color = Color3.fromHSV(i,1,1)
			partic.Color = ColorSequence.new(Color3.fromHSV(i,1,1))
		end
	end
end)
spawn(function()
	while true do
		game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(math.random(-500,50),math.random(-500,500) * power,math.random(-5,5))
		task.wait(math.random(0,attack)/50)	
	end
end)

local w = false
local a = false
local s = false
local d = false
local isMoving = false
mouse.KeyDown:Connect(function(key)
	if key == "w" then
		w = true
		isMoving = true
	end
	if key == "a" then
		a = true
		isMoving = true
	end
	if key == "s" then
		s = true
		isMoving = true
	end
	if key == "d" then
		d = true
		isMoving = true
	end
end)
mouse.KeyUp:Connect(function(key)
	if key == "w" then
		w = false
	end
	if key == "a" then
		a = false
	end
	if key == "s" then
		s = false
	end
	if key == "d" then
		d = false
	end
	isMoving = (w or a or s or d)
end)

-- Movement system that allows walking
game:GetService("RunService").Heartbeat:Connect(function()
	local humanoid = game.Players.LocalPlayer.Character.Humanoid
	local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
	
	-- Update fakepart position based on movement keys
	if w then
		fakepart.Position = fakepart.Position + workspace.CurrentCamera.CFrame.LookVector * 2
	end
	if a then
		fakepart.Position = fakepart.Position - workspace.CurrentCamera.CFrame.RightVector * 2
	end
	if s then
		fakepart.Position = fakepart.Position - workspace.CurrentCamera.CFrame.LookVector * 2
	end
	if d then
		fakepart.Position = fakepart.Position + workspace.CurrentCamera.CFrame.RightVector * 2
	end
	
	-- Toggle AlignPosition based on movement state
	if isMoving then
		-- Disable alignment to allow normal movement
		body.MaxForce = 0
		humanoid.PlatformStand = false
		-- Update fakepart to follow character
		fakepart.Position = rootPart.Position
	else
		-- Re-enable alignment for fling effects
		body.MaxForce = math.huge
		humanoid.PlatformStand = true
	end
end)

-- Auto-look at closest player (optional, can be disabled)
spawn(function()
	while true do
		local players = game.Players:GetPlayers()
		local closest = nil
		local shortestDistance = math.huge
		local localPlayer = game.Players.LocalPlayer
		local localRootPart = localPlayer.Character.HumanoidRootPart

		for _, player in pairs(players) do
			if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local targetRootPart = player.Character.HumanoidRootPart
				local distance = (localRootPart.Position - targetRootPart.Position).magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closest = player
				end
			end
		end

		if closest and not isMoving then
			local targetRootPart = closest.Character.HumanoidRootPart
			local direction = (targetRootPart.Position - localRootPart.Position).unit
			local lookAtCFrame = CFrame.lookAt(localRootPart.Position, Vector3.new(targetRootPart.Position.X,localRootPart.Position.Y,targetRootPart.Position.Z))
			localRootPart.CFrame = lookAtCFrame
		end

		fakepart.Rotation = localRootPart.Rotation
		task.wait()
	end
end)

local isdown = false
mouse.Button1Down:Connect(function()
	isdown = true
end)
mouse.Button1Up:Connect(function()
	isdown = false
end)
game:GetService("RunService").Heartbeat:Connect(function()
	if isdown then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(math.random(-5,5)/5,math.random(0,8)/2,math.random(-5,5)/5)) * CFrame.fromEulerAnglesXYZ(0,math.rad(45),0)
		game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(10000,9999,-9999)
		game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(-17.7,500,17.7)
	end
end)

-- State cycling (only when not moving)
spawn(function()
	while true do
		if not isMoving then
			game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
			task.wait(.5)
			game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			task.wait(.5)
		else
			task.wait(.1)
		end
	end
end)

-- Modified main loop that allows walking
while true do
	local humanoid = game.Players.LocalPlayer.Character.Humanoid
	local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
	
	fakepart.Rotation = rootPart.Rotation
	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	
	-- Only apply fling effects when not actively moving
	if not isMoving and not isdown then
		-- Apply random jumping
		if math.random(0,1)==1 then
			humanoid.Jump = true
		else
			humanoid.Jump = false
		end
		
		-- Sync character position with fakepart when not moving
		rootPart.CFrame = fakepart.CFrame
		
		-- Apply random velocities for fling effect
		rootPart.Velocity = Vector3.new(math.random(-250,250),math.random(-500,500),math.random(-250,250))
	else
		-- When moving, let humanoid control movement naturally
		-- Fakepart will follow via the Heartbeat connection above
		-- Don't override CFrame or Velocity when moving
	end
	
	task.wait()
end
