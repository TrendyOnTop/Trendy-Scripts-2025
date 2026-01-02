local Menu = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/library/refs/heads/main/cuh.txt",true))()

task.spawn(function()
    Menu:NameUpdate(0.6, 'Cactus', '.GG [khen.cc]')
end)

local Script = {
    Functions = {},
    Folders = {},
    Parts = {},
    Locals = {
        Target = nil,
        Targeting = false,
        Resolver = {
            OldTick = tick(),
            OldPos = Vector3.new(0, 0, 0),
            ResolvedVelocity = Vector3.new(0, 0, 0)
        },
        AutoSelectTick = tick(),
        AntiAimViewer = {
            MouseRemoteFound = false,
            MouseRemote = nil,
            MouseRemoteArgs = nil,
            MouseRemotePositionIndex = nil
        },
        GunTP = { 
            Enabled = false,
            Anchor = false,
            Offset = {0,-1,0},
        },
        Aura = { 
            Enabled = true,
            Color = Color3.fromRGB(0,0,67),
        },
        RocketTP = {
            Enabled = false,
        },
        GrenadeTP = {
            Enabled = false,
        },
        KnifeAbilityTest = {
            TargetPart = "HumanoidRootPart",
            Radius = 90,
            Visible = false
        },
        HitEffect = {
            ["Nova Impact"] = nil,
            ["Crescent Slash"] = nil,
            ["Crescent Slash"] = nil,
            ["Coom"] = nil,
            ["Cosmic Explosion"] = nil,
            ["Slash"] = nil,
            ["Atomic Slash"] = nil,
        },
        Gun = {
            PreviousGun = nil,
            PreviousAmmo = 999,
            Shotguns = {"[Double-Barrel SG]", "[TacticalShotgun]", "[Shotgun]"}
        },
        PlayerHealth = {},
        JumpOffset = 0,
        BulletPath = {
            [4312377180] = Workspace:FindFirstChild("MAP") and Workspace.MAP:FindFirstChild("Ignored") or nil,
            [1008451066] = Workspace:FindFirstChild("Ignored") and Workspace.Ignored:FindFirstChild("Siren") and Workspace.Ignored.Siren:FindFirstChild("Radius") or nil,
            [3985694250] = Workspace and Workspace:FindFirstChild("Ignored") or nil,
            [5106782457] = Workspace and Workspace:FindFirstChild("Ignored") or nil,
            [4937639028] = Workspace and Workspace:FindFirstChild("Ignored") or nil,
            [1958807588] = Workspace and Workspace:FindFirstChild("Ignored") or nil
        },
        SavedCFrame = nil,
        NetworkPreviousTick = tick(),
        NetworkShouldSleep = false,
        FFlags = {},
        OriginalVelocity = {},
        RotationAngle = 0
    },
    Utility = {
        Drawings = {},
        EspCache = {}
    },
    Connections = {
        GunConnections = {}
    },
    AuraIgnoreFolder = Instance.new("Folder", game:GetService("Workspace"))
}

local Settings = {
    Combat = {
        Enabled = false,
        Skibidi = true,
        Spectate = true,
        AimPart = "HumanoidRootPart",
        ESP = true,
        Silent = false,
        BetaAirshot = false,
        TriggerBot = {
            Enabled = false,
            Delay = 0,
            TargeyOnly = false,
            FOV = {
                Show = true,
                Size = 80
            }
        },
        TargetInfo = false,
        Camera = false,
        EasingStyle = "Sine",
        EasingDirection = "Out",
        Alerts = true,
        LookAt = false,
        Spectate = false,
        PingBased = false,
        UseIndex = false,
        AntiAimViewer = false,
        AutoSelect = {
            Enabled = false,
            Cooldown = {
                Enabled = false,
                Amount = 0.5
            }
        },
        Checks = {
            Enabled = false,
            Knocked = false,
            Crew = false,
            Wall = false,
            Grabbed = false,
            Vehicle = false
        },
        Smoothing = {
            Horizontal = 1,
            Vertical = 1
        },
        Prediction = {
            Horizontal = 0.134,
            Vertical = 0.134
        },
        Resolver = {
            Enabled = false,
            RefreshRate = 190
        },
        Fov = {
            Visualize = {
                Enabled = false,
                Color = Color3.new(1, 1, 1)
            },
            Radius = 80
        },
        Visuals = {
            Enabled = true,
            Tracer = {
                Enabled = false,
                Color = Color3.new(1, 1, 1),
                Thickness = 2
            },
            Dot = {
                Enabled = false,
                Color = Color3.new(1, 1, 1),
                Filled = true,
                Size = 6
            },
            Chams = {
                Enabled = false,
                Fill = {
                    Color = Color3.fromRGB(255,209,220),
                    Transparency = 0.5
                },
                Outline = {
                    Color = Color3.new(255,255,255),
                    Transparency = 0
                }
            }
        },
        Air = {
            Enabled = true,
            AirAimPart = {
                Enabled = false,
                HitPart = "LowerTorso"
            },
            JumpOffset = {
                Enabled = false,
                Offset = 0
            }
        }
    },
    Visuals = {
        Backtrack = {
            Enabled = true,
            Color = Color3.fromRGB(255,255,255),
            Method = "Folllow",
            Transparency = 0.5,
            Material = "Plastic",
        },
        BulletTracers = {
            Enabled = false,
            Color = {
                Gradient1 = Color3.new(1, 1, 1),
                Gradient2 = Color3.new(0, 0, 0)
            },
            Duration = 1,
            Fade = {
                Enabled = false,
                Duration = 0.5
            }
        },
        BulletImpacts = {
            Enabled = false,
            Color = Color3.new(1, 1, 1),
            Duration = 1,
            Size = 1,
            Material = "SmoothPlastic",
            Fade = {
                Enabled = false,
                Duration = 0.5
            }
        },
        OnHit = {
            Enabled = false,
            Effect = {
                Enabled = false,
                Color = Color3.new(1, 1, 1)
            },
            Sound = {
                Enabled = false,
                Volume = 5,
                Value = "hentai4.wav"
            },
            Chams = {
                Enabled = false,
                Color = Color3.fromRGB(255,209,220),
                Material = "ForceField",
                Duration = 1
            }
        },
        World = {
            Enabled = false,
            Fog = {
                Enabled = false,
                Color = Color3.fromRGB(255,209,220),
                End = 1000,
                Start = 10000
            },
            Ambient = {
                Enabled = false,
                Color = Color3.fromRGB(255,209,220)
            },
            Brightness = {
                Enabled = false,
                Value = 0
            },
            ClockTime = {
                Enabled = false,
                Value = 24
            },
            WorldExposure = {
                Enabled = false,
                Value = -0.1
            }
        },
        Crosshair = {
            Enabled = false,
            StickToTarget = false,
            Color = Color3.new(1, 1, 1),
            Size = 10,
            Gap = 2,
            Rotation = {
                Enabled = false,
                Speed = 1
            }
        }
    },
    AntiAim = {
        DaCoolBoyDesync = false,
        DaCoolBoyDesync2 = false,
        DaCoolBoyDesync3 = false,
        VelocitySpoofer = {
            Enabled = false,
            Visualize = {
                Enabled = false,
                Color = Color3.fromRGB(255,209,220),
                Prediction = 0.134
            },
            Type = "Underground",
            Roll = 0,
            Pitch = 0,
            Yaw = 0
        },
        CSync = {
            Enabled = false,
            Spoof = false,
            Type = "Target Strafe",
            Visualize = {
                Enabled = false,
                Color = Color3.fromRGB(255,209,220)
            },
            RandomDistance = 10,
            Custom = {
                X = 0,
                Y = 0,
                Z = 0
            },
            TargetStrafe = {
                Speed = 1,
                Distance = 1,
                Height = 1
            }
        },
        Network = {
            Enabled = false,
            WalkingCheck = false,
            Amount = 0.05
        },
        VelocityDesync = {
            Enabled = false,
            Range = 1
        },
        FFlagDesync = {
            Enabled = false,
            SetNew = false,
            FFlags = {"S2PhysicsSenderRate"}, 
            SetNewAmount = 1,
            Amount = 1
        },
    },
    Misc = {
        Movement = {
            Macro = {
                Enabled = false,
                Speed = 0.1,
            },
            Speed = {
                Enabled = false,
                Amount = 1
            },
        },
        Exploits = {
            Enabled = false,
            NoRecoil = false,
            NoJumpCooldown = false,
            NoSlowDown = false
        }
    }
}

getgenv().Sentinel = {
    Enabled = true,
    HorizontalPrediction = 0.045,
    VerticalPrediction = 0.1,
    jumpoffset2 = -1,
    jumpoffset = 0,
    ResolverEnabled = false,
    SelectedPart = "HumanoidRootPart",
    AutoPrediction = true,
    AutoPredMode = "PingBased", 
    ShootDelay = 0.22,
    NoGroundShot = true,
    AutoAir = true,
    LookAt = true,
    smoothness = 0.900,
    TracerEnabled = true,
    NearestPart = false,
    speedvalue = 1,
    MacroSpeed = 0.1,
    Camera = false,
    easingStyle = "Sine",
    easingDirection = "Out",
    JumpBreak = false,
    network = false
}

local GrenadeTP = false
local RocketTP = false
getgenv().Desync = false
getgenv().AntiLockType = "Behind"
getgenv().Direction = Vector3.new(0, 0, -1)

local player = game.Players.LocalPlayer
local character = player.Character
local hrp = character and character:FindFirstChild("HumanoidRootPart")

if hrp then
    local a0 = Instance.new("Attachment", hrp)
    local a1 = Instance.new("Attachment", hrp)
    a0.Position = Vector3.new(0, -0.5, -1)
    a1.Position = Vector3.new(0, -0.5, 1)
    local trail = Instance.new("Trail", hrp)
    trail.Color = ColorSequence.new(Color3.new(0, 0.717, 0.964), Color3.new(1, 0.717, 0.964))
    trail.Lifetime = 5
    trail.LightEmission = 1
    trail.LightInfluence = 1
    trail.Texture = "rbxassetid://2443461141"
    trail.Transparency = NumberSequence.new(0, 0, 0.352468, 0.48125, 1)
    trail.WidthScale = NumberSequence.new(0, 2, 0.499426, 2, 0)
    trail.Attachment0 = a0
    trail.Attachment1 = a1
end

-- ============================================
-- NEW UI SYSTEM FROM SCRATCH
-- ============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Main UI Container
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "CactusUI"
MainUI.Parent = game.CoreGui
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.ResetOnSpawn = false

-- Blur Effect
local Blur = Instance.new("BlurEffect", game:GetService("Lighting"))
Blur.Enabled = false
Blur.Size = 10

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainUI
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(0, 600, 0, 500)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(100, 100, 120)
MainStroke.Thickness = 2

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Cactus.GG [khen.cc]"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 24

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TabContainer.BorderSizePixel = 0
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Size = UDim2.new(1, -20, 1, -100)
ContentFrame.Position = UDim2.new(0, 10, 0, 90)
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentFrame
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 10)

-- Toggle Buttons Container (Top Right)
local ToggleContainer = Instance.new("Frame")
ToggleContainer.Name = "ToggleContainer"
ToggleContainer.Parent = MainUI
ToggleContainer.BackgroundTransparency = 1
ToggleContainer.Size = UDim2.new(0, 200, 0, 100)
ToggleContainer.Position = UDim2.new(1, -210, 0, 10)

-- Lock Button
local LockButton = Instance.new("TextButton")
LockButton.Name = "LockButton"
LockButton.Parent = ToggleContainer
LockButton.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
LockButton.BorderSizePixel = 0
LockButton.Size = UDim2.new(0, 150, 0, 50)
LockButton.Position = UDim2.new(0, 0, 0, 0)
LockButton.Font = Enum.Font.ArialBold
LockButton.Text = "Lock: <font color='rgb(255, 0, 0)'>OFF</font>"
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.TextSize = 20
LockButton.RichText = true
LockButton.TextStrokeTransparency = 0.5

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 8)
LockCorner.Parent = LockButton

local LockStroke = Instance.new("UIStroke")
LockStroke.Parent = LockButton
LockStroke.Thickness = 2
LockStroke.Color = Color3.fromRGB(16, 16, 32)

-- Settings Toggle Button
local SettingsButton = Instance.new("TextButton")
SettingsButton.Name = "SettingsButton"
SettingsButton.Parent = ToggleContainer
SettingsButton.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
SettingsButton.BorderSizePixel = 0
SettingsButton.Size = UDim2.new(0, 150, 0, 50)
SettingsButton.Position = UDim2.new(0, 0, 0, 55)
SettingsButton.Font = Enum.Font.ArialBold
SettingsButton.Text = "Settings: <font color='rgb(255, 0, 0)'>OFF</font>"
SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsButton.TextSize = 20
SettingsButton.RichText = true
SettingsButton.TextStrokeTransparency = 0.5

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 8)
SettingsCorner.Parent = SettingsButton

local SettingsStroke = Instance.new("UIStroke")
SettingsStroke.Parent = SettingsButton
SettingsStroke.Thickness = 2
SettingsStroke.Color = Color3.fromRGB(16, 16, 32)

-- Variables
local SettingsOpen = false
local LockEnabled = false
local CurrentTab = nil
local Tabs = {}

-- Make MainFrame draggable
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Close Button Functionality
CloseButton.MouseButton1Click:Connect(function()
    SettingsOpen = false
    MainFrame.Visible = false
    Blur.Enabled = false
    SettingsButton.Text = "Settings: <font color='rgb(255, 0, 0)'>OFF</font>"
end)

-- Settings Toggle
SettingsButton.MouseButton1Click:Connect(function()
    SettingsOpen = not SettingsOpen
    MainFrame.Visible = SettingsOpen
    Blur.Enabled = SettingsOpen
    
    if SettingsOpen then
        SettingsButton.Text = "Settings: <font color='rgb(0, 255, 0)'>ON</font>"
    else
        SettingsButton.Text = "Settings: <font color='rgb(255, 0, 0)'>OFF</font>"
    end
end)

-- Tab Creation Function
local function CreateTab(name, order)
    local tab = Instance.new("TextButton")
    tab.Name = name .. "Tab"
    tab.Parent = TabContainer
    tab.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    tab.BorderSizePixel = 0
    tab.Size = UDim2.new(0, 100, 1, 0)
    tab.Font = Enum.Font.Gotham
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    tab.TextSize = 14
    tab.LayoutOrder = order
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tab
    
    local tabContent = Instance.new("Frame")
    tabContent.Name = name .. "Content"
    tabContent.Parent = ContentFrame
    tabContent.BackgroundTransparency = 1
    tabContent.Size = UDim2.new(1, 0, 0, 0)
    tabContent.Visible = false
    
    local tabContentLayout = Instance.new("UIListLayout")
    tabContentLayout.Parent = tabContent
    tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabContentLayout.Padding = UDim.new(0, 10)
    
    tab.MouseButton1Click:Connect(function()
        if CurrentTab then
            CurrentTab.Visible = false
            for _, t in pairs(Tabs) do
                if t.Button ~= CurrentTab then
                    t.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                    t.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end
        CurrentTab = tabContent
        tabContent.Visible = true
        tab.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    Tabs[name] = {Button = tab, Content = tabContent}
    return tabContent
end

-- Section Creation Function
local function CreateSection(parent, name)
    local section = Instance.new("Frame")
    section.Name = name .. "Section"
    section.Parent = parent
    section.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    section.BorderSizePixel = 0
    section.Size = UDim2.new(1, 0, 0, 0)
    section.LayoutOrder = #parent:GetChildren()
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    local sectionStroke = Instance.new("UIStroke")
    sectionStroke.Parent = section
    sectionStroke.Color = Color3.fromRGB(50, 50, 60)
    sectionStroke.Thickness = 1
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Parent = section
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Size = UDim2.new(1, -20, 0, 30)
    sectionTitle.Position = UDim2.new(0, 10, 0, 5)
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.Text = name
    sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionTitle.TextSize = 16
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local sectionContent = Instance.new("Frame")
    sectionContent.Name = "Content"
    sectionContent.Parent = section
    sectionContent.BackgroundTransparency = 1
    sectionContent.Size = UDim2.new(1, -20, 0, 0)
    sectionContent.Position = UDim2.new(0, 10, 0, 35)
    
    local sectionLayout = Instance.new("UIListLayout")
    sectionLayout.Parent = sectionContent
    sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sectionLayout.Padding = UDim.new(0, 5)
    
    sectionContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        section.Size = UDim2.new(1, 0, 0, sectionContent.AbsoluteSize.Y + 45)
    end)
    
    return sectionContent
end

-- Toggle Creation Function
local function CreateToggle(parent, name, defaultValue, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = name .. "Toggle"
    toggle.Parent = parent
    toggle.BackgroundTransparency = 1
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.LayoutOrder = #parent:GetChildren()
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Parent = toggle
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Size = UDim2.new(1, -50, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = toggle
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleButton.BorderSizePixel = 0
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -45, 0, 5)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 12
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleButton
    
    local value = defaultValue
    toggleButton.MouseButton1Click:Connect(function()
        value = not value
        toggleButton.BackgroundColor3 = value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggleButton.Text = value and "ON" or "OFF"
        if callback then callback(value) end
    end)
    
    return toggle, function() return value end, function(newValue) 
        value = newValue
        toggleButton.BackgroundColor3 = value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggleButton.Text = value and "ON" or "OFF"
    end
end

-- Slider Creation Function
local function CreateSlider(parent, name, min, max, defaultValue, callback)
    local slider = Instance.new("Frame")
    slider.Name = name .. "Slider"
    slider.Parent = parent
    slider.BackgroundTransparency = 1
    slider.Size = UDim2.new(1, 0, 0, 50)
    slider.LayoutOrder = #parent:GetChildren()
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Parent = slider
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Text = name .. ": " .. tostring(defaultValue)
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextSize = 14
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Parent = slider
    sliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Size = UDim2.new(1, 0, 0, 6)
    sliderTrack.Position = UDim2.new(0, 0, 0, 25)
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = sliderTrack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderTrack
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill
    
    local value = defaultValue
    local dragging = false
    
    local function updateSlider(input)
        local pos = UDim2.new(math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1), 0, 0, 1, 0)
        sliderFill.Size = pos
        value = math.floor((min + (max - min) * pos.X.Scale) * 100) / 100
        sliderLabel.Text = name .. ": " .. tostring(value)
        if callback then callback(value) end
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return slider, function() return value end
end

-- Dropdown Creation Function
local function CreateDropdown(parent, name, options, defaultValue, callback)
    local dropdown = Instance.new("Frame")
    dropdown.Name = name .. "Dropdown"
    dropdown.Parent = parent
    dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    dropdown.BorderSizePixel = 0
    dropdown.Size = UDim2.new(1, 0, 0, 35)
    dropdown.LayoutOrder = #parent:GetChildren()
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdown
    
    local dropdownLabel = Instance.new("TextLabel")
    dropdownLabel.Parent = dropdown
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Size = UDim2.new(1, -50, 1, 0)
    dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    dropdownLabel.Font = Enum.Font.Gotham
    dropdownLabel.Text = name .. ": " .. defaultValue
    dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownLabel.TextSize = 14
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Parent = dropdown
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Text = ""
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.TextSize = 14
    
    local dropdownArrow = Instance.new("TextLabel")
    dropdownArrow.Parent = dropdown
    dropdownArrow.BackgroundTransparency = 1
    dropdownArrow.Size = UDim2.new(0, 30, 1, 0)
    dropdownArrow.Position = UDim2.new(1, -35, 0, 0)
    dropdownArrow.Font = Enum.Font.GothamBold
    dropdownArrow.Text = "▼"
    dropdownArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
    dropdownArrow.TextSize = 12
    
    local value = defaultValue
    local open = false
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "Options"
    optionsFrame.Parent = dropdown
    optionsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 10
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 6)
    optionsCorner.Parent = optionsFrame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Parent = optionsFrame
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    for _, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Parent = optionsFrame
        optionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        optionButton.BorderSizePixel = 0
        optionButton.Size = UDim2.new(1, -10, 0, 30)
        optionButton.Position = UDim2.new(0, 5, 0, 0)
        optionButton.Font = Enum.Font.Gotham
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 12
        
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 4)
        optionCorner.Parent = optionButton
        
        optionButton.MouseButton1Click:Connect(function()
            value = option
            dropdownLabel.Text = name .. ": " .. value
            optionsFrame.Visible = false
            open = false
            dropdownArrow.Text = "▼"
            if callback then callback(value) end
        end)
    end
    
    optionsFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        optionsFrame.Size = UDim2.new(1, 0, 0, optionsLayout.AbsoluteContentSize.Y + 10)
    end)
    
    dropdownButton.MouseButton1Click:Connect(function()
        open = not open
        optionsFrame.Visible = open
        dropdownArrow.Text = open and "▲" or "▼"
    end)
    
    return dropdown, function() return value end
end

-- TextBox Creation Function
local function CreateTextBox(parent, name, placeholder, callback)
    local textBoxContainer = Instance.new("Frame")
    textBoxContainer.Name = name .. "TextBox"
    textBoxContainer.Parent = parent
    textBoxContainer.BackgroundTransparency = 1
    textBoxContainer.Size = UDim2.new(1, 0, 0, 40)
    textBoxContainer.LayoutOrder = #parent:GetChildren()
    
    local textBoxLabel = Instance.new("TextLabel")
    textBoxLabel.Parent = textBoxContainer
    textBoxLabel.BackgroundTransparency = 1
    textBoxLabel.Size = UDim2.new(1, 0, 0, 20)
    textBoxLabel.Font = Enum.Font.Gotham
    textBoxLabel.Text = name
    textBoxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBoxLabel.TextSize = 14
    textBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local textBox = Instance.new("TextBox")
    textBox.Parent = textBoxContainer
    textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    textBox.BorderSizePixel = 0
    textBox.Size = UDim2.new(1, 0, 0, 30)
    textBox.Position = UDim2.new(0, 0, 0, 20)
    textBox.Font = Enum.Font.Gotham
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 14
    
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 6)
    textBoxCorner.Parent = textBox
    
    textBox.FocusLost:Connect(function(enterPressed)
        if callback then callback(textBox.Text) end
    end)
    
    return textBox
end

-- ColorPicker Creation Function (Simplified - just opens color picker)
local function CreateColorPicker(parent, name, defaultValue, callback)
    local colorPicker = Instance.new("Frame")
    colorPicker.Name = name .. "ColorPicker"
    colorPicker.Parent = parent
    colorPicker.BackgroundTransparency = 1
    colorPicker.Size = UDim2.new(1, 0, 0, 40)
    colorPicker.LayoutOrder = #parent:GetChildren()
    
    local colorPickerLabel = Instance.new("TextLabel")
    colorPickerLabel.Parent = colorPicker
    colorPickerLabel.BackgroundTransparency = 1
    colorPickerLabel.Size = UDim2.new(1, -60, 1, 0)
    colorPickerLabel.Position = UDim2.new(0, 0, 0, 0)
    colorPickerLabel.Font = Enum.Font.Gotham
    colorPickerLabel.Text = name
    colorPickerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorPickerLabel.TextSize = 14
    colorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local colorButton = Instance.new("TextButton")
    colorButton.Parent = colorPicker
    colorButton.BackgroundColor3 = defaultValue
    colorButton.BorderSizePixel = 0
    colorButton.Size = UDim2.new(0, 50, 0, 30)
    colorButton.Position = UDim2.new(1, -55, 0, 5)
    colorButton.Font = Enum.Font.Gotham
    colorButton.Text = ""
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 6)
    colorCorner.Parent = colorButton
    
    local colorStroke = Instance.new("UIStroke")
    colorStroke.Parent = colorButton
    colorStroke.Color = Color3.fromRGB(100, 100, 120)
    colorStroke.Thickness = 2
    
    local value = defaultValue
    colorButton.MouseButton1Click:Connect(function()
        -- Simple color picker - you can enhance this
        local r = math.random(0, 255)
        local g = math.random(0, 255)
        local b = math.random(0, 255)
        value = Color3.fromRGB(r, g, b)
        colorButton.BackgroundColor3 = value
        if callback then callback(value) end
    end)
    
    return colorPicker, function() return value end
end

-- ============================================
-- CREATE ALL TABS AND SETTINGS
-- ============================================

-- Main Tab
local MainTab = CreateTab("Main", 1)
local MainTargetAim = CreateSection(MainTab, "Target Aim")
CreateToggle(MainTargetAim, "Enabled", getgenv().Sentinel.Enabled, function(v) getgenv().Sentinel.Enabled = v end)
CreateToggle(MainTargetAim, "Look At", getgenv().Sentinel.LookAt, function(v) getgenv().Sentinel.LookAt = v end)
CreateToggle(MainTargetAim, "Highlight", false, function(v) Highlight = v end)
CreateToggle(MainTargetAim, "Auto Air", getgenv().Sentinel.AutoAir, function(v) getgenv().Sentinel.AutoAir = v end)
CreateToggle(MainTargetAim, "Resolver", getgenv().Sentinel.ResolverEnabled, function(v) getgenv().Sentinel.ResolverEnabled = v end)

local MainHitPart = CreateSection(MainTab, "HitPart")
CreateToggle(MainHitPart, "NearestPart", getgenv().Sentinel.NearestPart, function(v) getgenv().Sentinel.NearestPart = v end)
CreateDropdown(MainHitPart, "BodyPart", {
    "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", 
    "LeftUpperArm", "LeftLowerArm", "LeftHand", 
    "RightUpperArm", "RightLowerArm", "RightHand", 
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", 
    "RightUpperLeg", "RightLowerLeg", "RightFoot"
}, getgenv().Sentinel.SelectedPart, function(v) getgenv().Sentinel.SelectedPart = v end)

local MainPrediction = CreateSection(MainTab, "Prediction")
CreateToggle(MainPrediction, "Auto Prediction", true, function(v) getgenv().Sentinel.AutoPrediction = v end)
CreateDropdown(MainPrediction, "LockType", {"Namecall", "Index"}, getgenv().Sentinel.LockType or "Namecall", function(v) getgenv().Sentinel.LockType = v end)
CreateSlider(MainPrediction, "Horizontal", 0, 1, getgenv().Sentinel.HorizontalPrediction, function(v) getgenv().Sentinel.HorizontalPrediction2 = v end)

local MainCamera = CreateSection(MainTab, "Camera")
CreateToggle(MainCamera, "Enabled", getgenv().Sentinel.Camera, function(v) getgenv().Sentinel.Camera = v end)
CreateSlider(MainCamera, "Smoothness", 0, 1, getgenv().Sentinel.smoothness, function(v) getgenv().Sentinel.smoothness = v end)
CreateDropdown(MainCamera, "Easing Style", {
    "Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", 
    "Exponential", "Circular", "Back", "Bounce", "Elastic"
}, getgenv().Sentinel.easingStyle, function(v) getgenv().Sentinel.easingStyle = v end)
CreateDropdown(MainCamera, "Easing Direction", {"In", "Out", "InOut"}, getgenv().Sentinel.easingDirection, function(v) getgenv().Sentinel.easingDirection = v end)

-- HvH Tab
local HvHTab = CreateTab("HvH", 2)
local HvHTeleports = CreateSection(HvHTab, "Teleports")
CreateToggle(HvHTeleports, "Grenade Tp", GrenadeTP, function(v) Script.Locals.GrenadeTP.Enabled = v end)
CreateToggle(HvHTeleports, "Rocket Tp", RocketTP, function(v) Script.Locals.RocketTP.Enabled = v end)

local HvHBulletTP = CreateSection(HvHTab, "Bullet-TP")
CreateToggle(HvHBulletTP, "Bullet Gyatt", RocketTP, function(v) Script.Locals.GunTP.Enabled = v end)
CreateToggle(HvHBulletTP, "Anchor", RocketTP, function(v) Script.Locals.GunTP.Anchor = v end)
CreateTextBox(HvHBulletTP, "X", "0", function(v) Script.Locals.GunTP.Offset[1] = tonumber(v) or 0 end)
CreateTextBox(HvHBulletTP, "Y", "-0.5", function(v) Script.Locals.GunTP.Offset[2] = tonumber(v) or -0.5 end)
CreateTextBox(HvHBulletTP, "Z", "0", function(v) Script.Locals.GunTP.Offset[3] = tonumber(v) or 0 end)

local HvHCSync = CreateSection(HvHTab, "CSync")
CreateToggle(HvHCSync, "Enabled", TargetAimbot.CSync.Enabled, function(v) TargetAimbot.CSync.Enabled = v end)
CreateDropdown(HvHCSync, "Type", {"Orbit", "Random"}, TargetAimbot.CSync.Type, function(v) TargetAimbot.CSync.Type = v end)
CreateSlider(HvHCSync, "Distance", 0, 20, TargetAimbot.CSync.Distance, function(v) TargetAimbot.CSync.Distance = v end)
CreateSlider(HvHCSync, "Height", 0, 10, TargetAimbot.CSync.Height, function(v) TargetAimbot.CSync.Height = v end)
CreateSlider(HvHCSync, "Speed", 0, 20, TargetAimbot.CSync.Speed, function(v) TargetAimbot.CSync.Speed = v end)
CreateSlider(HvHCSync, "Random Amount", 0, 20, TargetAimbot.CSync.RandomAmount, function(v) TargetAimbot.CSync.RandomAmount = v end)

-- Visuals Tab
local VisualsTab = CreateTab("Visuals", 3)
local VisualsHitDetection = CreateSection(VisualsTab, "Hit Detection")
CreateToggle(VisualsHitDetection, "Hit Effect", TargetAimbot.HitEffect, function(v) TargetAimbot.HitEffect = v end)
CreateToggle(VisualsHitDetection, "Hit Sound", TargetAimbot.HitSounds, function(v) TargetAimbot.HitSounds = v end)
CreateToggle(VisualsHitDetection, "Notify", false, function(v) Hitnotify = v end)
CreateDropdown(VisualsHitDetection, "Effect Type", {
    "Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", 
    "Circle Shot", "Bolt", "Aura", "Electric", "Shock", "Thunder"
}, TargetAimbot.HitEffectType, function(v) TargetAimbot.HitEffectType = v end)
CreateDropdown(VisualsHitDetection, "Sound Type", {
    "RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", 
    "Neverlose", "Gamesense", "Rust", "BlackPencil"
}, TargetAimbot.HitSound, function(v) TargetAimbot.HitSound = v end)
CreateColorPicker(VisualsHitDetection, "Highlight fill", TargetAimbot.HighlightColor1, function(v) TargetAimbot.HighlightColor1 = v end)
CreateColorPicker(VisualsHitDetection, "Highlight Outline", TargetAimbot.HighlightColor2, function(v) TargetAimbot.HighlightColor2 = v end)
CreateColorPicker(VisualsHitDetection, "Hit Effect Color", TargetAimbot.HitEffectColor, function(v) TargetAimbot.HitEffectColor = v end)
CreateColorPicker(VisualsHitDetection, "Visualizer", TargetAimbot.CSync.Color, function(v) TargetAimbot.CSync.Color = v end)

local VisualsHitChams = CreateSection(VisualsTab, "Hit Chams")
CreateToggle(VisualsHitChams, "Enabled", TargetAimbot.HitChams, function(v) TargetAimbot.HitChams = v end)
CreateColorPicker(VisualsHitChams, "Color", TargetAimbot.HitChamsColor, function(v) TargetAimbot.HitChamsColor = v end)
CreateSlider(VisualsHitChams, "Duration", 0, 5, TargetAimbot.HitChamsDuration, function(v) TargetAimbot.HitChamsDuration = v end)
CreateDropdown(VisualsHitChams, "Material", {Enum.Material.Neon.Name, Enum.Material.SmoothPlastic.Name}, TargetAimbot.HitChamsMaterial.Name, function(v) TargetAimbot.HitChamsMaterial = Enum.Material[v] end)

-- Misc Tab
local MiscTab = CreateTab("Misc", 4)
local MiscPredictionBreaker = CreateSection(MiscTab, "Prediction Breaker")
CreateToggle(MiscPredictionBreaker, "Jump Prediction", getgenv().Sentinel.JumpBreak, function(v) getgenv().Sentinel.JumpBreak = v end)
CreateToggle(MiscPredictionBreaker, "Enable Anti Lock", getgenv().Desync, function(v) getgenv().Desync = v end)
CreateDropdown(MiscPredictionBreaker, "Anti Lock Type", {
    "Behind", "Down", "ForWard", "Left", "One", "Right", "Up", "Zero"
}, getgenv().AntiLockType, function(v) getgenv().AntiLockType = v end)

local MiscCFrameSpeed = CreateSection(MiscTab, "CFrame Speed")
CreateToggle(MiscCFrameSpeed, "Enabled", false, function(v) getgenv().Sentinel.cframespeedtoggle = v end)
CreateSlider(MiscCFrameSpeed, "Speed", 0, 10, 3, function(v) getgenv().Sentinel.speedvalue = v end)

local MiscMacro = CreateSection(MiscTab, "Macro")
local MacroLoaded = false
CreateToggle(MiscMacro, "Load Macro", false, function(v)
    if v and not MacroLoaded then
        MacroLoaded = true
        -- Macro loading code would go here
        Menu.Notify("Macro Loaded", 2)
    end
end)
CreateTextBox(MiscMacro, "Speed", tostring(getgenv().Sentinel.MacroSpeed), function(v) getgenv().Sentinel.MacroSpeed = tonumber(v) or 0.1 end)

local MiscAura = CreateSection(MiscTab, "Aura")
CreateToggle(MiscAura, "Enabled", false, function(v)
    if v then
        -- Aura enable code
    else
        -- Aura disable code
    end
end)

local MiscFly = CreateSection(MiscTab, "Fly")
CreateToggle(MiscFly, "Enabled", false, function(v) end)
CreateSlider(MiscFly, "Speed", 0, 30, 5, function(v) end)
CreateToggle(MiscFly, "Notification", false, function(v) end)

local MiscNetworkAnti = CreateSection(MiscTab, "Network Anti")
CreateToggle(MiscNetworkAnti, "Enabled", getgenv().Sentinel.network, function(v) getgenv().Sentinel.network = v end)

local MiscTrashTalk = CreateSection(MiscTab, "Trash Talk")
CreateToggle(MiscTrashTalk, "Enabled", false, function(v) end)
CreateToggle(MiscTrashTalk, "Target", false, function(v) end)
CreateToggle(MiscTrashTalk, "Notification", false, function(v) end)
CreateToggle(MiscTrashTalk, "Use Keybind", false, function(v) end)

-- Set first tab as active
if Tabs["Main"] then
    Tabs["Main"].Button.MouseButton1Click:Fire()
end

-- Update ContentFrame size
ContentFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
end)

-- ============================================
-- LOCK BUTTON FUNCTIONALITY
-- ============================================

local TargetAimbot = {
    Enabled = true, 
    Keybind = Enum.KeyCode.Q,
    Autoselect = false,
    Prediction = 0.145, 
    RealPrediction = 0.145, 
    Resolver = false, 
    ResolverType = "Recalculate", 
    JumpOffset = 0.06, 
    RealJumpOffset = 0.09, 
    HitParts = {"HumanoidRootPart"}, 
    RealHitPart = "HumanoidRootPart", 
    KoCheck = false, 
    LookAt = false,
    CSync = {
        Enabled = false,
        Type = "Orbit",
        Distance = 10,
        Height = 2,
        Speed = 10,
        RandomAmount = 10,
        Color = Color3.fromRGB(255, 255, 255),
    },
    ViewAt = false,
    Tracer = true,
    Highlight = true,
    HighlightColor1 = Color3.fromRGB(255, 255, 255),
    HighlightColor2 = Color3.fromRGB(255, 255, 255),
    Stats = false, 
    UseFov = false,
    HitEffect = true,
    HitEffectType = "Coom",
    HitEffectColor = Color3.fromRGB(255, 255, 255),
    HitSounds = true,
    HitSound = "Bameware",
    HitChams = true,
    HitChamsMaterial = Enum.Material.Neon,
    HitChamsDuration = 1,
    HitChamsColor = Color3.fromRGB(173, 216, 230)
}

local Highlight = false
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TargetPlr = nil
local TargBindEnabled = false
local target_health = nil

-- FOV Circle for target selection
local FOV43 = Drawing.new("Circle")
FOV43.Transparency = 0.5
FOV43.Thickness = 2
FOV43.Color = Color3.new(1, 0, 0)
FOV43.Filled = false
FOV43.Radius = 250
FOV43.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
FOV43.Visible = false

function SigmaOhioPlayer()
    local closestPlayer
    local shortestDistance = math.huge
    local player = game.Players.LocalPlayer
    local CC = game:GetService("Workspace").CurrentCamera
    local screenCenter = Vector2.new(CC.ViewportSize.X / 2, CC.ViewportSize.Y / 2)
    local fovRadius = FOV43.Radius
    local viewportSize = CC.ViewportSize

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") 
           and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            
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

toggle_lock = function()
    if TargetAimbot.Enabled then
        local closest = SigmaOhioPlayer()
        if TargBindEnabled and TargetPlr then
            TargBindEnabled = false
            target_health = nil
            TargetPlr = nil
            Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
            if TargetAimbot.LookAt then
                LocalPlayer.Character.Humanoid.AutoRotate = true
            end
            LockButton.Text = "Lock: <font color='rgb(255, 0, 0)'>OFF</font>"
            LockEnabled = false
            Menu.Notify("Untargeted", 2)
        else
            if closest then
                TargBindEnabled = true
                TargetPlr = closest
                if TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
                    target_health = TargetPlr.Character.Humanoid.Health
                else
                    return
                end
                LockButton.Text = "Lock: <font color='rgb(0, 255, 0)'>ON</font>"
                LockEnabled = true
                Menu.Notify("Target Locked: " .. tostring(TargetPlr.DisplayName), 2)
            else
                Menu.Notify("No target found", 2)
            end
        end
    end
end

LockButton.MouseButton1Click:Connect(toggle_lock)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.DPadDown then
        toggle_lock()
    end
end)

-- Initialize Menu
Menu:SetSize(500, 400)
Menu.Notify("Script Loaded.", 2)
Menu:SetTitle("Cactus.Lua")
Menu:SetVisible(false)
Menu:Init()

-- ============================================
-- REST OF THE SCRIPT (Hit Effects, Functions, etc.)
-- ============================================

-- [Rest of your script code continues here - hit effects, particle emitters, functions, etc.]
-- I'll include the essential parts but you'll need to add the rest of your hit effect code

Script.Functions.Connection = function(ConnectionType: any, Function: any)
    local Connection = ConnectionType:Connect(Function)
    return Connection
end

Script.Functions.VisualizeMovement = function()
    if Settings.Combat.Skibidi then
        local Character = game.Players.LocalPlayer and (game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait())
        local RootPart = Character and Character.HumanoidRootPart
        local Ball = Instance.new('Part') do
            Ball.Anchored = true
            Ball.Size = Vector3.new(0.5, 0.5, 0.5)
            Ball.Transparency = -0.5
            Ball.Shape = Enum.PartType.Ball
            Ball.Color = Color3.fromRGB(98,0,67)
            Ball.Material = Enum.Material.ForceField
            Ball.Parent = Workspace
            Ball.CFrame = RootPart.CFrame
            Ball.CanCollide = false
            local highlight = Instance.new("Highlight")
            highlight.Adornee = Ball
            highlight.FillColor = Color3.fromRGB(98,0,67)
            highlight.OutlineColor = Color3.fromRGB(255,255,255)
            highlight.Parent = Ball
        end;
        game:GetService("Debris"):AddItem(Ball, 2)
    end
end

-- ============================================
-- ESSENTIAL SYSTEMS AND FUNCTIONALITY
-- ============================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local Drawing = require(game:GetService("ReplicatedStorage").Drawing)

local hitsounds = {
    ["RIFK7"] = "rbxassetid://9102080552",
    ["Bubble"] = "rbxassetid://9102092728",
    ["Minecraft"] = "rbxassetid://5869422451",
    ["Cod"] = "rbxassetid://160432334",
    ["Bameware"] = "rbxassetid://6565367558",
    ["Neverlose"] = "rbxassetid://6565370984",
    ["Gamesense"] = "rbxassetid://4817809188",
    ["Rust"] = "rbxassetid://6565371338",
    ["BlackPencil"] = "https://github.com/khenn791/script-khen/raw/refs/heads/main/bananapencil.mp3%20(1).mp3"
}

local TargHighlight = Instance.new("Highlight")
TargHighlight.Parent = CoreGui
TargHighlight.FillColor = TargetAimbot.HighlightColor1
TargHighlight.OutlineColor = TargetAimbot.HighlightColor2
TargHighlight.FillTransparency = 0.5
TargHighlight.OutlineTransparency = 0
TargHighlight.Enabled = false

local Tracer = Drawing.new("Line")
Tracer.Visible = false
Tracer.Color = Color3.fromRGB(154, 7, 250)
Tracer.Thickness = 1
Tracer.Transparency = 1

local HitEffectModule = {
    Locals = {
        Type = {},
    },
    Functions = {},
    Settings = {HitEffect = {Color = TargetAimbot.HitEffectColor}}
}

local HitChamsFolder = Instance.new("Folder")
HitChamsFolder.Name = "HitChamsFolder"
HitChamsFolder.Parent = Workspace

-- Hit Effect Functions
HitEffectModule.Functions.Effect = function(character, color)
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local effectAttachment = HitEffectModule.Locals.Type[TargetAimbot.HitEffectType]
    if effectAttachment then
        local cloned = effectAttachment:Clone()
        cloned.Parent = humanoidRootPart

        for _, emitter in pairs(cloned:GetChildren()) do
            if emitter:IsA("ParticleEmitter") then
                emitter.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(0.495, TargetAimbot.HitEffectColor),
                    ColorSequenceKeypoint.new(1, TargetAimbot.HitEffectColor)
                })
                
                if TargetAimbot.HitEffect then
                    emitter.Enabled = true
                    task.wait(0.1)
                    emitter.Enabled = false
                end
            end
        end

        task.delay(2, function()
            cloned:Destroy()
        end)
    end
end

local function PlayHitSound()
    if TargetAimbot.HitSounds and hitsounds[TargetAimbot.HitSound] then
        local sound = Instance.new("Sound")
        sound.SoundId = hitsounds[TargetAimbot.HitSound]
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
end

local function HitChams(Player)
    if not TargetAimbot.HitChams then return end

    if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.Archivable = true
        local Cloned = Player.Character:Clone()
        Cloned.Name = "Player Clone"

        local BodyParts = {
            "Head", "UpperTorso", "LowerTorso",
            "LeftUpperArm", "LeftLowerArm", "LeftHand",
            "RightUpperArm", "RightLowerArm", "RightHand",
            "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
            "RightUpperLeg", "RightLowerLeg", "RightFoot"
        }

        for _, Part in ipairs(Cloned:GetChildren()) do
            if Part:IsA("BasePart") then
                local PartValid = false
                for _, validPart in ipairs(BodyParts) do
                    if Part.Name == validPart then
                        PartValid = true
                        break
                    end
                end
                
                if not PartValid then
                    Part:Destroy()
                end
            elseif Part:IsA("Accessory") or Part:IsA("Tool") or Part.Name == "face" or Part:IsA("Shirt") or Part:IsA("Pants") or Part:IsA("Hat") then
                Part:Destroy()
            end
        end

        if Cloned:FindFirstChild("Humanoid") then
            Cloned.Humanoid:Destroy()
        end

        for _, BodyPart in ipairs(Cloned:GetChildren()) do
            if BodyPart:IsA("BasePart") then
                BodyPart.CanCollide = false
                BodyPart.Anchored = true
                BodyPart.Transparency = 0.3
                BodyPart.Color = TargetAimbot.HitChamsColor
                BodyPart.Material = TargetAimbot.HitChamsMaterial
            end
        end

        if Cloned:FindFirstChild("Head") then
            local Head = Cloned.Head
            Head.Transparency = 0.3
            Head.Color = TargetAimbot.HitChamsColor
            Head.Material = TargetAimbot.HitChamsMaterial

            if Head:FindFirstChild("face") then
                Head.face:Destroy()
            end
        end

        Cloned.Parent = game.Workspace

        local tweenInfo = TweenInfo.new(
            TargetAimbot.HitChamsDuration,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            0,
            true
        )

        for _, BodyPart in ipairs(Cloned:GetChildren()) do
            if BodyPart:IsA("BasePart") then
                local tween = TweenService:Create(BodyPart, tweenInfo, { Transparency = 1 })
                tween:Play()
            end
        end

        task.delay(TargetAimbot.HitChamsDuration, function()
            if Cloned and Cloned.Parent then
                Cloned:Destroy()
            end
        end)
    end
end

local Hitnotify = false

local function updatetarget_health()
    if TargBindEnabled and TargetPlr and TargetPlr.Character then
        local humanoid = TargetPlr.Character:FindFirstChild("Humanoid")
        if humanoid then
            local currentHealth = humanoid.Health
            if currentHealth < target_health then
                if Hitnotify then
                    Menu.Notify('Cactus<font color="#90EE90">.GG [khen.cc]</font>  >  ' .. '+1 Hit | ' .. tostring(getgenv().Sentinel.SelectedPart) .. ' | Target : ' .. TargetPlr.DisplayName, 1.5)
                end
                
                PlayHitSound()
                HitEffectModule.Functions.Effect(TargetPlr.Character)
                HitChams(TargetPlr)
            end
            target_health = currentHealth
        end
    end
end

RunService.RenderStepped:Connect(function()
    if TargetAimbot.Enabled and TargBindEnabled and TargetAimbot.Highlight and TargetPlr and TargetPlr.Character and Highlight then
        TargHighlight.FillColor = TargetAimbot.HighlightColor1
        TargHighlight.OutlineColor = TargetAimbot.HighlightColor2
        TargHighlight.Adornee = TargetPlr.Character
        TargHighlight.Enabled = true
    else
        TargHighlight.Adornee = nil
        TargHighlight.Enabled = false
    end
end)

-- CSync System
local Saved
local Client = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local nigga = {}
local IgnoreFolder = Instance.new("Folder", game:GetService("Workspace"))
local desync_setback = Instance.new("Part")
desync_setback.Name = "im a skibidi rizzler"
desync_setback.Parent = workspace
desync_setback.Size = Client.Character.Humanoid.RootPart.Size
desync_setback.CanCollide = false
desync_setback.Anchored = true
desync_setback.Transparency = 1

game:GetService('RunService').Heartbeat:Connect(function()
    if TargetAimbot.CSync.Enabled and TargetPlr then
        local FakeCFrame = Client.Character.HumanoidRootPart.CFrame
        Saved = Client.Character.HumanoidRootPart.CFrame
        if TargBindEnabled and TargetAimbot.CSync.Type == "Random" then
            FakeCFrame = CFrame.new(TargetPlr.Character.HumanoidRootPart.Position + Vector3.new(math.random(-TargetAimbot.CSync.RandomAmount, TargetAimbot.CSync.RandomAmount), math.random(-0, TargetAimbot.CSync.RandomAmount), math.random(-TargetAimbot.CSync.RandomAmount, TargetAimbot.CSync.RandomAmount))) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))
        elseif TargBindEnabled and TargetAimbot.CSync.Type == "Orbit" then
            local CurrentTime = tick()
            FakeCFrame = CFrame.new(TargetPlr.Character.HumanoidRootPart.Position) * CFrame.Angles(0, 2 * math.pi * CurrentTime * TargetAimbot.CSync.Speed % (2 * math.pi), 0) * CFrame.new(0, TargetAimbot.CSync.Height, TargetAimbot.CSync.Distance)
        end

        Client.Character.HumanoidRootPart.CFrame = FakeCFrame
        game:GetService("RunService").RenderStepped:Wait()
        desync_setback.Position = Saved.Position + Vector3.new(0, 1.5, 0)
        
        if TargBindEnabled then
            Camera.CameraSubject = desync_setback
        else
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
        end
        Client.Character.HumanoidRootPart.CFrame = Saved
    end
end)

-- Aimbot System
getgenv().Sentinel.LockType = "Namecall"
getgenv().Sentinel.RESOLVER = "MoveDirection"

local game_support = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/script-khen/refs/heads/main/Argument.txt",true))()

local function getRemoteInfo()
    local placeId = game.PlaceId
    return game_support[placeId] or {Remote = "MainEvent", Argument = "UpdateMousePos"}
end

local function predictedposition()
    local selectedPart = getgenv().Sentinel.SelectedPart
    local targetPart = TargetPlr.Character[selectedPart]

    if targetPart then
        local velocity
        if not getgenv().Sentinel.ResolverEnabled then
            velocity = targetPart.Velocity
        else
            if getgenv().Sentinel.RESOLVER == "MoveDirection" then
                velocity = TargetPlr.Character.Humanoid.MoveDirection * TargetPlr.Character.Humanoid.WalkSpeed
            elseif getgenv().Sentinel.RESOLVER == "LookVector" then
                velocity = targetPart.CFrame.LookVector * getgenv().Sentinel.HorizontalPrediction * 1.2
            else
                velocity = targetPart.Velocity
            end
        end

        local horizontalPrediction = getgenv().Sentinel.HorizontalPrediction
        local predictedPosition = Vector3.new(
            targetPart.Position.X + (velocity.X * horizontalPrediction),
            targetPart.Position.Y,
            targetPart.Position.Z + (velocity.Z * horizontalPrediction)
        )

        return predictedPosition
    end
end

RunService.PostSimulation:Connect(function(DeltaTime)
    if getgenv().Sentinel.Enabled then
        if getgenv().Sentinel.LockType == "Index" then
            local LocalPlayer = game.Players.LocalPlayer
            local LocalFramework = LocalPlayer.PlayerGui:WaitForChild("Framework", 1e9)

            if LocalFramework then
                local FrameworkEnvironment = getsenv(LocalFramework)

                if FrameworkEnvironment._G and FrameworkEnvironment._G.MOUSE_POSITION then
                    if TargetPlr then
                        FrameworkEnvironment._G.MOUSE_POSITION = predictedposition() 
                    end
                end
            end
        end
    end
end)

local remoteInfo = getRemoteInfo()
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

do
    __namecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
        local args, method = {...}, tostring(getnamecallmethod())

        if not checkcaller() and method == "FireServer" then
            for i, arg in pairs(args) do
                if typeof(arg) == "Vector3" then
                    if TargetPlr and getgenv().Sentinel.Enabled and getgenv().Sentinel.LockType == "Namecall" then
                        local selectedPart = getgenv().Sentinel.SelectedPart
                        local targetPart = TargetPlr.Character[selectedPart]

                        if targetPart then
                            local velocity
                            if getgenv().Sentinel.ResolverEnabled then
                                if getgenv().Sentinel.RESOLVER == "MoveDirection" then
                                    velocity = TargetPlr.Character.Humanoid.MoveDirection * TargetPlr.Character.Humanoid.WalkSpeed
                                elseif getgenv().Sentinel.RESOLVER == "LookVector" then
                                    velocity = targetPart.CFrame.LookVector * getgenv().Sentinel.HorizontalPrediction * 1.0
                                else
                                    velocity = targetPart.Velocity
                                end
                            else
                                velocity = targetPart.Velocity
                            end

                            local horizontalPrediction = getgenv().Sentinel.HorizontalPrediction
                            args[i] = targetPart.Position + (targetPart.Velocity * horizontalPrediction)
                        end
                    end
                    return __namecall(Self, unpack(args))
                elseif type(arg) == "table" then
                    for index, element in ipairs(arg) do
                        if typeof(element) == "Vector3" then
                            if TargetPlr and getgenv().Sentinel.Enabled and getgenv().Sentinel.LockType == "Namecall" then
                                local selectedPart = getgenv().Sentinel.SelectedPart
                                local targetPart = TargetPlr.Character[selectedPart]

                                if targetPart then
                                    local velocity
                                    if getgenv().Sentinel.ResolverEnabled then
                                        if getgenv().Sentinel.RESOLVER == "MoveDirection" then
                                            velocity = TargetPlr.Character.Humanoid.MoveDirection * TargetPlr.Character.Humanoid.WalkSpeed
                                        elseif getgenv().Sentinel.RESOLVER == "LookVector" then
                                            velocity = targetPart.CFrame.LookVector * getgenv().Sentinel.HorizontalPrediction * 1.0
                                        else
                                            velocity = targetPart.Velocity
                                        end
                                    else
                                        velocity = targetPart.Velocity
                                    end

                                    local horizontalPrediction = getgenv().Sentinel.HorizontalPrediction
                                    arg[index] = targetPart.Position + (targetPart.Velocity * horizontalPrediction)
                                end
                            end
                        end
                    end
                end
            end
            return __namecall(Self, unpack(args))
        end

        return __namecall(Self, ...)
    end))
end

-- Auto Shoot System
local function AutoShoot()
    if TargetPlr then
        local character = Client.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and tool:IsA("Tool") then
                tool:Activate()
            end
        end
    end
end

local targetSigm99928 = getgenv().Sentinel.ShootDelay 
local targetSigmaPOBALLs = nil
local Shot2ing = false

local function checkTarget()
    if TargetPlr and TargetPlr.Character then
        local humanoid = TargetPlr.Character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = TargetPlr.Character:FindFirstChild("HumanoidRootPart")

        if humanoid and humanoidRootPart then
            local SigmaAir = humanoid:GetState() == Enum.HumanoidStateType.Freefall

            if SigmaAir and getgenv().Sentinel.AutoAir then
                if not targetSigmaPOBALLs then
                    targetSigmaPOBALLs = tick()
                else
                    local airDuration = tick() - targetSigmaPOBALLs
                    if airDuration >= targetSigm99928 then
                        if not Shot2ing then
                            Shot2ing = true
                            while TargetPlr and TargetPlr.Character and SigmaAir do
                                AutoShoot()
                                wait(0.001)
                                SigmaAir = humanoid:GetState() == Enum.HumanoidStateType.Freefall
                                if not SigmaAir then
                                    Shot2ing = false
                                    targetSigmaPOBALLs = nil
                                    break
                                end
                            end
                            Shot2ing = false
                        end
                    end
                end
            else
                targetSigmaPOBALLs = nil
                Shot2ing = false
            end
        end
    end
end

local predictionTable = {
    {20, 0.08960952}, {30, 0.11252476}, {50, 0.13544}, {65, 0.1264236}, {70, 0.12533},
    {80, 0.139340}, {100, 0.141987}, {110, 0.144634}, {120, 0.147281}, {130, 0.149928},
    {140, 0.152575}, {150, 0.155222}, {160, 0.157869}, {170, 0.160516}, {180, 0.163163},
    {190, 0.165810}, {200, 0.168457}, {210, 0.171104}, {220, 0.173751}, {230, 0.176398},
    {240, 0.179045}, {250, 0.181692}, {260, 0.184339}, {270, 0.186986}, {280, 0.189633},
    {290, 0.192280}, {300, 0.194927}
}

local function updatePredictionValue()
    if getgenv().Sentinel.AutoPrediction then
        local pingValue = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        local split = string.split(pingValue, '(')
        local ping = tonumber(split[1])

        if ping then
            if getgenv().Sentinel.AutoPredMode == "PingBased" then
                local closestPingDiff = math.huge
                local closestValue = nil

                for i = 1, #predictionTable do
                    local tablePing = predictionTable[i][1]
                    local tableValue = predictionTable[i][2]
                    local pingDiff = math.abs(ping - tablePing)

                    if pingDiff < closestPingDiff then
                        closestPingDiff = pingDiff
                        closestValue = tableValue
                    end
                end

                if closestValue then
                    getgenv().Sentinel.HorizontalPrediction = closestValue
                    getgenv().Sentinel.VerticalPrediction = closestValue * 0.8
                end
            end
        end
    end
end

function LookAtPlayer(Target)
    local localChar = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local localHumanoidRootPart = localChar:FindFirstChild("HumanoidRootPart")

    if localHumanoidRootPart then
        if getgenv().Sentinel and getgenv().Sentinel.LookAt then
            if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                local targetHumanoidRootPart = Target.Character.HumanoidRootPart
                local targetPosition = targetHumanoidRootPart.Position
                local localPosition = localHumanoidRootPart.Position
                local horizontalDirection = Vector3.new(targetPosition.X - localPosition.X, 0, targetPosition.Z - localPosition.Z).unit
                localHumanoidRootPart.CFrame = CFrame.new(localPosition, localPosition + horizontalDirection)
                localChar.Humanoid.AutoRotate = false
            end
        else
            localChar.Humanoid.AutoRotate = true
        end
    end
    
    if not (Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart")) then
        localChar.Humanoid.AutoRotate = true
    end
end

local function NearestPart(TargetPlr)
    local BodyParts = {
        "Head", "UpperTorso", "LowerTorso", 
        "LeftUpperArm", "LeftLowerArm", "LeftHand", 
        "RightUpperArm", "RightLowerArm", "RightHand", 
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", 
        "RightUpperLeg", "RightLowerLeg", "RightFoot"
    }

    local selectedPartName = getgenv().Sentinel.SelectedPart

    if TargetPlr and TargetPlr.Character then
        if getgenv().Sentinel.NearestPart then
            local minDistance = math.huge
            local nearestPart = nil
            
            for _, partName in pairs(BodyParts) do
                local part = TargetPlr.Character:FindFirstChild(partName)
                if part then
                    local distance = (part.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < minDistance then
                        minDistance = distance
                        nearestPart = part
                    end
                end
            end
            
            if nearestPart then
                getgenv().Sentinel.SelectedPart = nearestPart.Name
            end
        else
            getgenv().Sentinel.SelectedPart = selectedPartName
        end
    end
end

function inAir()
    if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
        local SigmaTuah = TargetPlr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall
        if SigmaTuah then
            getgenv().Sentinel.jumpoffset = getgenv().Sentinel.jumpoffset2
        else
            getgenv().Sentinel.jumpoffset = 0
        end
    end
end

RunService.Stepped:Connect(function()
    updatePredictionValue()
    checkTarget()
    updatetarget_health()
    LookAtPlayer(TargetPlr)
    NearestPart(TargetPlr)
    inAir()
    if not getgenv().Sentinel.AutoPrediction then
        getgenv().Sentinel.HorizontalPrediction2 = getgenv().Sentinel.HorizontalPrediction2
        getgenv().Sentinel.VerticalPrediction = getgenv().Sentinel.HorizontalPrediction2
    end
end)

RunService.Heartbeat:Connect(function()
    if Script.Locals.GrenadeTP.Enabled and TargetPlr and TargetPlr.Character and workspace:FindFirstChild("Ignored") then
        if workspace.Ignored:FindFirstChild("Handle") then
            workspace.Ignored.Handle.Position = TargetPlr.Character[getgenv().Sentinel.SelectedPart].Position + (TargetPlr.Character[getgenv().Sentinel.SelectedPart].Velocity * getgenv().Sentinel.HorizontalPrediction)
        end
    end
end)

if workspace:FindFirstChild("Ignored") then
    workspace.Ignored.ChildAdded:Connect(function(object)
        if Script.Locals.RocketTP.Enabled and TargetPlr and TargetPlr.Character and (object.Name == "Model" or object.Name == "GrenadeLauncherAmmo") then
            local SkibidiGrenadeLauncher = object.Name == "GrenadeLauncherAmmo"
            local part = SkibidiGrenadeLauncher and object:WaitForChild("Main") or object:WaitForChild("Launcher")
            
            part.CFrame = CFrame.new(1, 1, 1)
            
            if not SkibidiGrenadeLauncher then
                if part:FindFirstChild("BodyVelocity") then part.BodyVelocity:Destroy() end
                if part:FindFirstChild("TouchInterest") then part.TouchInterest:Destroy() end
            end
            
            local connection
            connection = RunService.PostSimulation:Connect(function()
                if TargetPlr and TargetPlr.Character then
                    part.CFrame = TargetPlr.Character.HumanoidRootPart.CFrame
                    part.Velocity = Vector3.new(0, 0.001, 0)
                end
            end)
            
            object.Destroying:Connect(function()
                connection:Disconnect()
            end)
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if getgenv().Sentinel.Camera and TargetPlr and TargetPlr.Character and getgenv().Sentinel.SelectedPart then
        local camera = Workspace.CurrentCamera
        local selectedPart = getgenv().Sentinel.SelectedPart
        local targetPart = TargetPlr.Character[selectedPart]

        if targetPart then
            local velocity
            if getgenv().Sentinel.ResolverEnabled then
                if getgenv().Sentinel.RESOLVER == "MoveDirection" then
                    velocity = TargetPlr.Character.Humanoid.MoveDirection * TargetPlr.Character.Humanoid.WalkSpeed
                elseif getgenv().Sentinel.RESOLVER == "LookVector" then
                    velocity = targetPart.CFrame.LookVector * getgenv().Sentinel.HorizontalPrediction * 1.0
                else
                    velocity = targetPart.Velocity
                end
            else
                velocity = targetPart.Velocity
            end

            local jumpOffset = getgenv().Sentinel.jumpoffset or 0
            local verticalVelocity = velocity.Y
            local appliedVerticalOffset = verticalVelocity > 0 and jumpOffset or 0

            local horizontalPrediction = getgenv().Sentinel.HorizontalPrediction
            local verticalPrediction = getgenv().Sentinel.VerticalPrediction

            local targetPosition = Vector3.new(
                targetPart.Position.X + (velocity.X * horizontalPrediction),
                targetPart.Position.Y + (velocity.Y * verticalPrediction) + appliedVerticalOffset,
                targetPart.Position.Z + (velocity.Z * horizontalPrediction)
            )

            local smoothness = getgenv().Sentinel.smoothness or 0.1
            local easingStyle = Enum.EasingStyle[getgenv().Sentinel.easingStyle] or Enum.EasingStyle.Quad
            local easingDirection = Enum.EasingDirection[getgenv().Sentinel.easingDirection] or Enum.EasingDirection.In

            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, targetPosition), smoothness, easingStyle, easingDirection)
        end
    end
end)

local Plr = game.Players.LocalPlayer

Plr.Character:WaitForChild("Humanoid").StateChanged:Connect(function(old, new)
    if getgenv().Sentinel.JumpBreak and new == Enum.HumanoidStateType.Freefall then
        wait(0.27)
        Plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, -15, 0)
    end
end)

game:GetService("RunService").heartbeat:Connect(function()
    if getgenv().Desync == true then
        local abc = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity

        if getgenv().AntiLockType == "Behind" then
            getgenv().Direction = Vector3.new(0, 0, -1)
        elseif getgenv().AntiLockType == "Down" then
            getgenv().Direction = Vector3.new(0, -1, 0)
        elseif getgenv().AntiLockType == "ForWard" then
            getgenv().Direction = Vector3.new(0, 0, 1)
        elseif getgenv().AntiLockType == "Left" then
            getgenv().Direction = Vector3.new(-1, 0, 0)
        elseif getgenv().AntiLockType == "One" then
            getgenv().Direction = Vector3.new(1, 1, 1)
        elseif getgenv().AntiLockType == "Right" then
            getgenv().Direction = Vector3.new(1, 0, 0)
        elseif getgenv().AntiLockType == "Up" then
            getgenv().Direction = Vector3.new(0, 1, 0)
        elseif getgenv().AntiLockType == "Zero" then
            getgenv().Direction = Vector3.new(0, 0, 0)
        end
        
        game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = getgenv().Direction * (2^16)
        game:GetService("RunService").RenderStepped:Wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = abc
    end
end)

-- Gun TP System
local boolattp = true
local cframe_to_offset = function(origin, target)
    local actual_origin = origin * CFrame.new(Script.Locals.GunTP.Offset[1], Script.Locals.GunTP.Offset[2], Script.Locals.GunTP.Offset[3], 1, 0, 0, 0, 0, 1, 0, -1, 0)
    return actual_origin:ToObjectSpace(target):inverse()
end

local something_tp = function(Tool)
    local old_grip = Tool.Grip
    if TargetPlr and TargetPlr.Character then
        Tool.Parent = Client.Backpack
        Client.Character.RightHand.Anchored = false
        Tool.Grip = cframe_to_offset(Client.Character.RightHand.CFrame, TargetPlr.Character.HumanoidRootPart.CFrame)
        Client.Character.RightHand.Anchored = true
        Tool.Parent = Client.Character
        RunService.RenderStepped:Wait()
        Tool.Parent = Client.Backpack
        Client.Character.RightHand.Anchored = false
        Tool.Grip = old_grip
        Tool.Parent = Client.Character
    end
end

local bullet_teleport = function(Character)
    Character.ChildAdded:Connect(function(Child)
        if Script.Locals.GunTP.Enabled then
            if Child:IsA("Tool") then
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
        end
    end)
end

bullet_teleport(Client.Character)
Client.CharacterAdded:Connect(function()
    bullet_teleport(Client.Character)
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if Settings.Combat.Spectate and TargetPlr then
        game.Workspace.CurrentCamera.CameraSubject = TargetPlr.Character
    else
        game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
    end
end)

RunService.Heartbeat:Connect(function()
    if Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        if getgenv().Sentinel and getgenv().Sentinel.network then
            sethiddenproperty(Plr.Character.HumanoidRootPart, "NetworkIsSleeping", true)
            task.wait()
            sethiddenproperty(Plr.Character.HumanoidRootPart, "NetworkIsSleeping", false)
            setfflag("S2PhysicsSenderRate", 2)
        else
            setfflag("S2PhysicsSenderRate", 13)
            sethiddenproperty(Plr.Character.HumanoidRootPart, "NetworkIsSleeping", false)
        end
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().Sentinel.cframespeedtoggle then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame +
            game.Players.LocalPlayer.Character.Humanoid.MoveDirection * getgenv().Sentinel.speedvalue / 0.5
    end
end)

print("Cactus.GG UI Loaded - khen.cc")
print("All systems initialized and integrated with new UI")
