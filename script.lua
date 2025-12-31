-- ============================================
-- SETTINGS TABLE
-- ============================================
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
    network = false,
    LockType = "Namecall"
}

local GrenadeTP = false
local RocketTP = false
getgenv().Desync = false
getgenv().AntiLockType = "Behind"
getgenv().Direction = Vector3.new(0, 0, -1)

-- Script Locals
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
        HitEffect = {},
        Gun = {
            PreviousGun = nil,
            PreviousAmmo = 999,
            Shotguns = {"[Double-Barrel SG]", "[TacticalShotgun]", "[Shotgun]"}
        },
        PlayerHealth = {},
        JumpOffset = 0,
        BulletPath = {},
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

-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Stas = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Script initialization check
print("[Aimbot Script] Starting initialization...")

-- Target Variables
local TargBindEnabled = false
local TargetPlr = nil
local Highlight = false

-- ============================================
-- CUSTOM UI SYSTEM
-- ============================================

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- UI State
local UIEnabled = true
local LockEnabled = false
local CurrentTab = "Combat"

-- Create Main ScreenGui
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "CustomAimbotUI"
MainGui.Parent = CoreGui
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.ResetOnSpawn = false

-- Create Floating UI Toggle Button (Always Visible)
local FloatingUIToggle = Instance.new("TextButton")
FloatingUIToggle.Name = "FloatingUIToggle"
FloatingUIToggle.Parent = MainGui
FloatingUIToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
FloatingUIToggle.BorderSizePixel = 0
FloatingUIToggle.Size = UDim2.new(0, 60, 0, 35)
FloatingUIToggle.Position = UDim2.new(1, -70, 0, 10)
FloatingUIToggle.Font = Enum.Font.GothamBold
FloatingUIToggle.Text = "UI"
FloatingUIToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingUIToggle.TextSize = 14
FloatingUIToggle.Active = true
FloatingUIToggle.Draggable = true
FloatingUIToggle.ZIndex = 10

local FloatingUIToggleCorner = Instance.new("UICorner")
FloatingUIToggleCorner.CornerRadius = UDim.new(0, 6)
FloatingUIToggleCorner.Parent = FloatingUIToggle

local FloatingUIToggleStroke = Instance.new("UIStroke")
FloatingUIToggleStroke.Parent = FloatingUIToggle
FloatingUIToggleStroke.Color = Color3.fromRGB(40, 40, 60)
FloatingUIToggleStroke.Thickness = 2

-- Create Floating Lock Toggle Button (Always Visible)
local FloatingLockToggle = Instance.new("TextButton")
FloatingLockToggle.Name = "FloatingLockToggle"
FloatingLockToggle.Parent = MainGui
FloatingLockToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FloatingLockToggle.BorderSizePixel = 0
FloatingLockToggle.Size = UDim2.new(0, 60, 0, 35)
FloatingLockToggle.Position = UDim2.new(1, -70, 0, 55)
FloatingLockToggle.Font = Enum.Font.GothamBold
FloatingLockToggle.Text = "Lock"
FloatingLockToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
FloatingLockToggle.TextSize = 14
FloatingLockToggle.Active = true
FloatingLockToggle.Draggable = true
FloatingLockToggle.ZIndex = 10

local FloatingLockToggleCorner = Instance.new("UICorner")
FloatingLockToggleCorner.CornerRadius = UDim.new(0, 6)
FloatingLockToggleCorner.Parent = FloatingLockToggle

local FloatingLockToggleStroke = Instance.new("UIStroke")
FloatingLockToggleStroke.Parent = FloatingLockToggle
FloatingLockToggleStroke.Color = Color3.fromRGB(40, 40, 60)
FloatingLockToggleStroke.Thickness = 2

-- Create Main Frame (Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.Active = true
MainFrame.Draggable = true

-- Corner
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Stroke
local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(60, 60, 80)
MainStroke.Thickness = 2

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.Position = UDim2.new(0, 0, 0, 0)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Size = UDim2.new(1, -200, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "Aimbot Settings"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- UI Toggle Button
local UIToggleBtn = Instance.new("TextButton")
UIToggleBtn.Name = "UIToggleBtn"
UIToggleBtn.Parent = TitleBar
UIToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
UIToggleBtn.BorderSizePixel = 0
UIToggleBtn.Size = UDim2.new(0, 50, 0, 32)
UIToggleBtn.Position = UDim2.new(1, -110, 0.5, -16)
UIToggleBtn.Font = Enum.Font.GothamBold
UIToggleBtn.Text = "UI"
UIToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UIToggleBtn.TextSize = 13

local UIToggleCorner = Instance.new("UICorner")
UIToggleCorner.CornerRadius = UDim.new(0, 6)
UIToggleCorner.Parent = UIToggleBtn

-- Lock Toggle Button
local LockToggleBtn = Instance.new("TextButton")
LockToggleBtn.Name = "LockToggleBtn"
LockToggleBtn.Parent = TitleBar
LockToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
LockToggleBtn.BorderSizePixel = 0
LockToggleBtn.Size = UDim2.new(0, 50, 0, 32)
LockToggleBtn.Position = UDim2.new(1, -55, 0.5, -16)
LockToggleBtn.Font = Enum.Font.GothamBold
LockToggleBtn.Text = "Lock"
LockToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
LockToggleBtn.TextSize = 13

local LockToggleCorner = Instance.new("UICorner")
LockToggleCorner.CornerRadius = UDim.new(0, 6)
LockToggleCorner.Parent = LockToggleBtn

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TabContainer.BorderSizePixel = 0
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 45)

local TabContainerCorner = Instance.new("UICorner")
TabContainerCorner.CornerRadius = UDim.new(0, 0)
TabContainerCorner.Parent = TabContainer

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
ContentFrame.Size = UDim2.new(1, -20, 1, -95)
ContentFrame.Position = UDim2.new(0, 10, 0, 90)
ContentFrame.ScrollBarThickness = 6
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y

-- UI List Layout
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Function to create tab button
local TabButtons = {}
local function CreateTab(name, text)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name
    TabBtn.Parent = TabContainer
    TabBtn.BackgroundColor3 = CurrentTab == name and Color3.fromRGB(50, 100, 200) or Color3.fromRGB(30, 30, 40)
    TabBtn.BorderSizePixel = 0
    TabBtn.Size = UDim2.new(0, 100, 1, 0)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.Text = text
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.TextSize = 14
    
    TabBtn.MouseButton1Click:Connect(function()
        CurrentTab = name
        -- Update all tab buttons
        for tabName, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = CurrentTab == tabName and Color3.fromRGB(50, 100, 200) or Color3.fromRGB(30, 30, 40)
        end
        BuildUI()
    end)
    
    TabButtons[name] = TabBtn
    return TabBtn
end

-- Function to create toggle
local function CreateToggle(parent, name, text, defaultValue, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "Toggle"
    ToggleBtn.Parent = ToggleFrame
    ToggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Size = UDim2.new(0, 60, 0, 25)
    ToggleBtn.Position = UDim2.new(1, -70, 0.5, -12.5)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Text = defaultValue and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 11
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(0, 5)
    ToggleBtnCorner.Parent = ToggleBtn
    
    local state = defaultValue
    
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
        ToggleBtn.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
    
    return ToggleFrame
end

-- Function to create slider
local function CreateSlider(parent, name, text, min, max, defaultValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "Label"
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = text .. ": " .. string.format("%.3f", defaultValue)
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 12
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "Track"
    SliderTrack.Parent = SliderFrame
    SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Size = UDim2.new(1, -20, 0, 5)
    SliderTrack.Position = UDim2.new(0, 10, 0, 30)
    
    local SliderTrackCorner = Instance.new("UICorner")
    SliderTrackCorner.CornerRadius = UDim.new(0, 2)
    SliderTrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.Parent = SliderTrack
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 2)
    SliderFillCorner.Parent = SliderFill
    
    local value = defaultValue
    local dragging = false
    
    local function updateValue(newValue)
        value = math.clamp(newValue, min, max)
        local percent = (value - min) / (max - min)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderLabel.Text = text .. ": " .. string.format("%.3f", value)
        if callback then callback(value) end
    end
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local mousePos = UIS:GetMouseLocation()
            local trackPos = SliderTrack.AbsolutePosition.X
            local trackSize = SliderTrack.AbsoluteSize.X
            local percent = math.clamp((mousePos.X - trackPos) / trackSize, 0, 1)
            updateValue(min + (max - min) * percent)
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UIS:GetMouseLocation()
            local trackPos = SliderTrack.AbsolutePosition.X
            local trackSize = SliderTrack.AbsoluteSize.X
            local percent = math.clamp((mousePos.X - trackPos) / trackSize, 0, 1)
            updateValue(min + (max - min) * percent)
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return SliderFrame
end

-- Function to create textbox
local function CreateTextBox(parent, name, text, defaultValue, callback)
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = name
    TextBoxFrame.Parent = parent
    TextBoxFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.Size = UDim2.new(1, 0, 0, 45)
    
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 6)
    TextBoxCorner.Parent = TextBoxFrame
    
    local TextBoxLabel = Instance.new("TextLabel")
    TextBoxLabel.Name = "Label"
    TextBoxLabel.Parent = TextBoxFrame
    TextBoxLabel.BackgroundTransparency = 1
    TextBoxLabel.Size = UDim2.new(1, -20, 0, 20)
    TextBoxLabel.Position = UDim2.new(0, 10, 0, 5)
    TextBoxLabel.Font = Enum.Font.Gotham
    TextBoxLabel.Text = text
    TextBoxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBoxLabel.TextSize = 12
    TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextBoxInput = Instance.new("TextBox")
    TextBoxInput.Name = "Input"
    TextBoxInput.Parent = TextBoxFrame
    TextBoxInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TextBoxInput.BorderSizePixel = 0
    TextBoxInput.Size = UDim2.new(1, -20, 0, 20)
    TextBoxInput.Position = UDim2.new(0, 10, 0, 22)
    TextBoxInput.Font = Enum.Font.Gotham
    TextBoxInput.Text = tostring(defaultValue)
    TextBoxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBoxInput.TextSize = 12
    TextBoxInput.PlaceholderText = "Enter value..."
    
    local TextBoxInputCorner = Instance.new("UICorner")
    TextBoxInputCorner.CornerRadius = UDim.new(0, 4)
    TextBoxInputCorner.Parent = TextBoxInput
    
    TextBoxInput.FocusLost:Connect(function()
        if callback then callback(TextBoxInput.Text) end
    end)
    
    return TextBoxFrame
end

-- Function to create section
local function CreateSection(parent, title)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = title .. "Section"
    SectionFrame.Parent = parent
    SectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    SectionFrame.BorderSizePixel = 0
    SectionFrame.Size = UDim2.new(1, 0, 0, 0)
    SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = SectionFrame
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "Title"
    SectionTitle.Parent = SectionFrame
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Size = UDim2.new(1, -20, 0, 25)
    SectionTitle.Position = UDim2.new(0, 10, 0, 5)
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.Text = title
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextSize = 14
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local SectionContent = Instance.new("Frame")
    SectionContent.Name = "Content"
    SectionContent.Parent = SectionFrame
    SectionContent.BackgroundTransparency = 1
    SectionContent.Size = UDim2.new(1, -20, 0, 0)
    SectionContent.Position = UDim2.new(0, 10, 0, 30)
    SectionContent.AutomaticSize = Enum.AutomaticSize.Y
    
    local SectionLayout = Instance.new("UIListLayout")
    SectionLayout.Parent = SectionContent
    SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionLayout.Padding = UDim.new(0, 5)
    
    return SectionFrame, SectionContent
end

-- Build UI Function
local function BuildUI()
    -- Clear content
    for _, child in pairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if CurrentTab == "Combat" then
        local MainSection, MainContent = CreateSection(ContentFrame, "Main")
        CreateToggle(MainContent, "Enabled", "Enabled", Settings.Combat.Enabled, function(val)
            Settings.Combat.Enabled = val
            getgenv().Sentinel.Enabled = val
        end)
        CreateToggle(MainContent, "LookAt", "Look At", Settings.Combat.LookAt, function(val)
            Settings.Combat.LookAt = val
            getgenv().Sentinel.LookAt = val
        end)
        CreateToggle(MainContent, "AutoAir", "Auto Air", getgenv().Sentinel.AutoAir, function(val)
            getgenv().Sentinel.AutoAir = val
        end)
        CreateToggle(MainContent, "Resolver", "Resolver", Settings.Combat.Resolver.Enabled, function(val)
            Settings.Combat.Resolver.Enabled = val
            getgenv().Sentinel.ResolverEnabled = val
        end)
        CreateToggle(MainContent, "NearestPart", "Nearest Part", getgenv().Sentinel.NearestPart, function(val)
            getgenv().Sentinel.NearestPart = val
        end)
        CreateToggle(MainContent, "ESP", "ESP", Settings.Combat.ESP, function(val)
            Settings.Combat.ESP = val
        end)
        CreateToggle(MainContent, "Silent", "Silent", Settings.Combat.Silent, function(val)
            Settings.Combat.Silent = val
        end)
        CreateToggle(MainContent, "BetaAirshot", "Beta Airshot", Settings.Combat.BetaAirshot, function(val)
            Settings.Combat.BetaAirshot = val
        end)
        CreateToggle(MainContent, "TargetInfo", "Target Info", Settings.Combat.TargetInfo, function(val)
            Settings.Combat.TargetInfo = val
        end)
        CreateToggle(MainContent, "Alerts", "Alerts", Settings.Combat.Alerts, function(val)
            Settings.Combat.Alerts = val
        end)
        CreateToggle(MainContent, "PingBased", "Ping Based", Settings.Combat.PingBased, function(val)
            Settings.Combat.PingBased = val
        end)
        CreateToggle(MainContent, "UseIndex", "Use Index", Settings.Combat.UseIndex, function(val)
            Settings.Combat.UseIndex = val
        end)
        CreateToggle(MainContent, "AntiAimViewer", "Anti Aim Viewer", Settings.Combat.AntiAimViewer, function(val)
            Settings.Combat.AntiAimViewer = val
        end)
        
        local TriggerBotSection, TriggerBotContent = CreateSection(ContentFrame, "Trigger Bot")
        CreateToggle(TriggerBotContent, "TriggerBot", "Enabled", Settings.Combat.TriggerBot.Enabled, function(val)
            Settings.Combat.TriggerBot.Enabled = val
        end)
        CreateSlider(TriggerBotContent, "TriggerDelay", "Delay", 0, 1, Settings.Combat.TriggerBot.Delay, function(val)
            Settings.Combat.TriggerBot.Delay = val
        end)
        CreateToggle(TriggerBotContent, "TriggerTargetOnly", "Target Only", Settings.Combat.TriggerBot.TargeyOnly, function(val)
            Settings.Combat.TriggerBot.TargeyOnly = val
        end)
        CreateToggle(TriggerBotContent, "TriggerFOVShow", "Show FOV", Settings.Combat.TriggerBot.FOV.Show, function(val)
            Settings.Combat.TriggerBot.FOV.Show = val
        end)
        CreateSlider(TriggerBotContent, "TriggerFOVSize", "FOV Size", 0, 200, Settings.Combat.TriggerBot.FOV.Size, function(val)
            Settings.Combat.TriggerBot.FOV.Size = val
        end)
        
        local AutoSelectSection, AutoSelectContent = CreateSection(ContentFrame, "Auto Select")
        CreateToggle(AutoSelectContent, "AutoSelect", "Enabled", Settings.Combat.AutoSelect.Enabled, function(val)
            Settings.Combat.AutoSelect.Enabled = val
        end)
        CreateToggle(AutoSelectContent, "AutoSelectCooldown", "Cooldown", Settings.Combat.AutoSelect.Cooldown.Enabled, function(val)
            Settings.Combat.AutoSelect.Cooldown.Enabled = val
        end)
        CreateSlider(AutoSelectContent, "AutoSelectCooldownAmount", "Cooldown Amount", 0, 5, Settings.Combat.AutoSelect.Cooldown.Amount, function(val)
            Settings.Combat.AutoSelect.Cooldown.Amount = val
        end)
        
        local ChecksSection, ChecksContent = CreateSection(ContentFrame, "Checks")
        CreateToggle(ChecksContent, "ChecksEnabled", "Enabled", Settings.Combat.Checks.Enabled, function(val)
            Settings.Combat.Checks.Enabled = val
        end)
        CreateToggle(ChecksContent, "CheckKnocked", "Knocked", Settings.Combat.Checks.Knocked, function(val)
            Settings.Combat.Checks.Knocked = val
        end)
        CreateToggle(ChecksContent, "CheckCrew", "Crew", Settings.Combat.Checks.Crew, function(val)
            Settings.Combat.Checks.Crew = val
        end)
        CreateToggle(ChecksContent, "CheckWall", "Wall", Settings.Combat.Checks.Wall, function(val)
            Settings.Combat.Checks.Wall = val
        end)
        CreateToggle(ChecksContent, "CheckGrabbed", "Grabbed", Settings.Combat.Checks.Grabbed, function(val)
            Settings.Combat.Checks.Grabbed = val
        end)
        CreateToggle(ChecksContent, "CheckVehicle", "Vehicle", Settings.Combat.Checks.Vehicle, function(val)
            Settings.Combat.Checks.Vehicle = val
        end)
        
        local SmoothingSection, SmoothingContent = CreateSection(ContentFrame, "Smoothing")
        CreateSlider(SmoothingContent, "SmoothHorizontal", "Horizontal", 0, 10, Settings.Combat.Smoothing.Horizontal, function(val)
            Settings.Combat.Smoothing.Horizontal = val
        end)
        CreateSlider(SmoothingContent, "SmoothVertical", "Vertical", 0, 10, Settings.Combat.Smoothing.Vertical, function(val)
            Settings.Combat.Smoothing.Vertical = val
        end)
        
        local PredictionSection, PredictionContent = CreateSection(ContentFrame, "Prediction")
        CreateToggle(PredictionContent, "AutoPrediction", "Auto Prediction", getgenv().Sentinel.AutoPrediction, function(val)
            getgenv().Sentinel.AutoPrediction = val
        end)
        CreateSlider(PredictionContent, "HorizontalPrediction", "Horizontal", 0, 1, Settings.Combat.Prediction.Horizontal, function(val)
            Settings.Combat.Prediction.Horizontal = val
            getgenv().Sentinel.HorizontalPrediction = val
        end)
        CreateSlider(PredictionContent, "VerticalPrediction", "Vertical", 0, 1, Settings.Combat.Prediction.Vertical, function(val)
            Settings.Combat.Prediction.Vertical = val
            getgenv().Sentinel.VerticalPrediction = val
        end)
        
        local ResolverSection, ResolverContent = CreateSection(ContentFrame, "Resolver")
        CreateSlider(ResolverContent, "ResolverRefreshRate", "Refresh Rate", 0, 500, Settings.Combat.Resolver.RefreshRate, function(val)
            Settings.Combat.Resolver.RefreshRate = val
        end)
        
        local FOVSection, FOVContent = CreateSection(ContentFrame, "FOV")
        CreateToggle(FOVContent, "FOVVisualize", "Visualize", Settings.Combat.Fov.Visualize.Enabled, function(val)
            Settings.Combat.Fov.Visualize.Enabled = val
        end)
        CreateSlider(FOVContent, "FOVRadius", "Radius", 0, 500, Settings.Combat.Fov.Radius, function(val)
            Settings.Combat.Fov.Radius = val
        end)
        
        local VisualsCombatSection, VisualsCombatContent = CreateSection(ContentFrame, "Combat Visuals")
        CreateToggle(VisualsCombatContent, "CombatVisuals", "Enabled", Settings.Combat.Visuals.Enabled, function(val)
            Settings.Combat.Visuals.Enabled = val
        end)
        CreateToggle(VisualsCombatContent, "Tracer", "Tracer", Settings.Combat.Visuals.Tracer.Enabled, function(val)
            Settings.Combat.Visuals.Tracer.Enabled = val
        end)
        CreateSlider(VisualsCombatContent, "TracerThickness", "Tracer Thickness", 0, 10, Settings.Combat.Visuals.Tracer.Thickness, function(val)
            Settings.Combat.Visuals.Tracer.Thickness = val
        end)
        CreateToggle(VisualsCombatContent, "Dot", "Dot", Settings.Combat.Visuals.Dot.Enabled, function(val)
            Settings.Combat.Visuals.Dot.Enabled = val
        end)
        CreateSlider(VisualsCombatContent, "DotSize", "Dot Size", 0, 20, Settings.Combat.Visuals.Dot.Size, function(val)
            Settings.Combat.Visuals.Dot.Size = val
        end)
        CreateToggle(VisualsCombatContent, "DotFilled", "Dot Filled", Settings.Combat.Visuals.Dot.Filled, function(val)
            Settings.Combat.Visuals.Dot.Filled = val
        end)
        CreateToggle(VisualsCombatContent, "Chams", "Chams", Settings.Combat.Visuals.Chams.Enabled, function(val)
            Settings.Combat.Visuals.Chams.Enabled = val
        end)
        CreateSlider(VisualsCombatContent, "ChamsFillTransparency", "Chams Fill Transparency", 0, 1, Settings.Combat.Visuals.Chams.Fill.Transparency, function(val)
            Settings.Combat.Visuals.Chams.Fill.Transparency = val
        end)
        CreateSlider(VisualsCombatContent, "ChamsOutlineTransparency", "Chams Outline Transparency", 0, 1, Settings.Combat.Visuals.Chams.Outline.Transparency, function(val)
            Settings.Combat.Visuals.Chams.Outline.Transparency = val
        end)
        
        local AirSection, AirContent = CreateSection(ContentFrame, "Air")
        CreateToggle(AirContent, "AirEnabled", "Enabled", Settings.Combat.Air.Enabled, function(val)
            Settings.Combat.Air.Enabled = val
        end)
        CreateToggle(AirContent, "AirAimPart", "Air Aim Part", Settings.Combat.Air.AirAimPart.Enabled, function(val)
            Settings.Combat.Air.AirAimPart.Enabled = val
        end)
        CreateTextBox(AirContent, "AirHitPart", "Hit Part", Settings.Combat.Air.AirAimPart.HitPart, function(val)
            Settings.Combat.Air.AirAimPart.HitPart = val
        end)
        CreateToggle(AirContent, "JumpOffset", "Jump Offset", Settings.Combat.Air.JumpOffset.Enabled, function(val)
            Settings.Combat.Air.JumpOffset.Enabled = val
        end)
        CreateSlider(AirContent, "JumpOffsetAmount", "Jump Offset Amount", -5, 5, Settings.Combat.Air.JumpOffset.Offset, function(val)
            Settings.Combat.Air.JumpOffset.Offset = val
        end)
        
        local CameraSection, CameraContent = CreateSection(ContentFrame, "Camera")
        CreateToggle(CameraContent, "Camera", "Enabled", getgenv().Sentinel.Camera, function(val)
            getgenv().Sentinel.Camera = val
        end)
        CreateSlider(CameraContent, "Smoothness", "Smoothness", 0, 1, getgenv().Sentinel.smoothness, function(val)
            getgenv().Sentinel.smoothness = val
        end)
        CreateTextBox(CameraContent, "EasingStyle", "Easing Style", Settings.Combat.EasingStyle, function(val)
            Settings.Combat.EasingStyle = val
            getgenv().Sentinel.easingStyle = val
        end)
        CreateTextBox(CameraContent, "EasingDirection", "Easing Direction", Settings.Combat.EasingDirection, function(val)
            Settings.Combat.EasingDirection = val
            getgenv().Sentinel.easingDirection = val
        end)
        
        local HitPartSection, HitPartContent = CreateSection(ContentFrame, "Hit Part")
        CreateTextBox(HitPartContent, "SelectedPart", "Body Part", getgenv().Sentinel.SelectedPart, function(val)
            getgenv().Sentinel.SelectedPart = val
        end)
        CreateTextBox(HitPartContent, "AimPart", "Aim Part", Settings.Combat.AimPart, function(val)
            Settings.Combat.AimPart = val
        end)
        
    elseif CurrentTab == "Visuals" then
        local BacktrackSection, BacktrackContent = CreateSection(ContentFrame, "Backtrack")
        CreateToggle(BacktrackContent, "Backtrack", "Enabled", Settings.Visuals.Backtrack.Enabled, function(val)
            Settings.Visuals.Backtrack.Enabled = val
        end)
        CreateSlider(BacktrackContent, "BacktrackTransparency", "Transparency", 0, 1, Settings.Visuals.Backtrack.Transparency, function(val)
            Settings.Visuals.Backtrack.Transparency = val
        end)
        CreateTextBox(BacktrackContent, "BacktrackMethod", "Method", Settings.Visuals.Backtrack.Method, function(val)
            Settings.Visuals.Backtrack.Method = val
        end)
        CreateTextBox(BacktrackContent, "BacktrackMaterial", "Material", Settings.Visuals.Backtrack.Material, function(val)
            Settings.Visuals.Backtrack.Material = val
        end)
        
        local TracersSection, TracersContent = CreateSection(ContentFrame, "Bullet Tracers")
        CreateToggle(TracersContent, "BulletTracers", "Enabled", Settings.Visuals.BulletTracers.Enabled, function(val)
            Settings.Visuals.BulletTracers.Enabled = val
        end)
        CreateSlider(TracersContent, "TracerDuration", "Duration", 0, 10, Settings.Visuals.BulletTracers.Duration, function(val)
            Settings.Visuals.BulletTracers.Duration = val
        end)
        CreateToggle(TracersContent, "TracerFade", "Fade", Settings.Visuals.BulletTracers.Fade.Enabled, function(val)
            Settings.Visuals.BulletTracers.Fade.Enabled = val
        end)
        CreateSlider(TracersContent, "TracerFadeDuration", "Fade Duration", 0, 5, Settings.Visuals.BulletTracers.Fade.Duration, function(val)
            Settings.Visuals.BulletTracers.Fade.Duration = val
        end)
        
        local ImpactsSection, ImpactsContent = CreateSection(ContentFrame, "Bullet Impacts")
        CreateToggle(ImpactsContent, "BulletImpacts", "Enabled", Settings.Visuals.BulletImpacts.Enabled, function(val)
            Settings.Visuals.BulletImpacts.Enabled = val
        end)
        CreateSlider(ImpactsContent, "ImpactDuration", "Duration", 0, 10, Settings.Visuals.BulletImpacts.Duration, function(val)
            Settings.Visuals.BulletImpacts.Duration = val
        end)
        CreateSlider(ImpactsContent, "ImpactSize", "Size", 0, 10, Settings.Visuals.BulletImpacts.Size, function(val)
            Settings.Visuals.BulletImpacts.Size = val
        end)
        CreateTextBox(ImpactsContent, "ImpactMaterial", "Material", Settings.Visuals.BulletImpacts.Material, function(val)
            Settings.Visuals.BulletImpacts.Material = val
        end)
        CreateToggle(ImpactsContent, "ImpactFade", "Fade", Settings.Visuals.BulletImpacts.Fade.Enabled, function(val)
            Settings.Visuals.BulletImpacts.Fade.Enabled = val
        end)
        CreateSlider(ImpactsContent, "ImpactFadeDuration", "Fade Duration", 0, 5, Settings.Visuals.BulletImpacts.Fade.Duration, function(val)
            Settings.Visuals.BulletImpacts.Fade.Duration = val
        end)
        
        local OnHitSection, OnHitContent = CreateSection(ContentFrame, "On Hit")
        CreateToggle(OnHitContent, "OnHitEnabled", "Enabled", Settings.Visuals.OnHit.Enabled, function(val)
            Settings.Visuals.OnHit.Enabled = val
        end)
        CreateToggle(OnHitContent, "OnHitEffect", "Effect", Settings.Visuals.OnHit.Effect.Enabled, function(val)
            Settings.Visuals.OnHit.Effect.Enabled = val
        end)
        CreateToggle(OnHitContent, "OnHitSound", "Sound", Settings.Visuals.OnHit.Sound.Enabled, function(val)
            Settings.Visuals.OnHit.Sound.Enabled = val
        end)
        CreateSlider(OnHitContent, "OnHitSoundVolume", "Sound Volume", 0, 10, Settings.Visuals.OnHit.Sound.Volume, function(val)
            Settings.Visuals.OnHit.Sound.Volume = val
        end)
        CreateTextBox(OnHitContent, "OnHitSoundValue", "Sound Value", Settings.Visuals.OnHit.Sound.Value, function(val)
            Settings.Visuals.OnHit.Sound.Value = val
        end)
        CreateToggle(OnHitContent, "OnHitChams", "Chams", Settings.Visuals.OnHit.Chams.Enabled, function(val)
            Settings.Visuals.OnHit.Chams.Enabled = val
        end)
        CreateSlider(OnHitContent, "OnHitChamsDuration", "Chams Duration", 0, 10, Settings.Visuals.OnHit.Chams.Duration, function(val)
            Settings.Visuals.OnHit.Chams.Duration = val
        end)
        CreateTextBox(OnHitContent, "OnHitChamsMaterial", "Chams Material", Settings.Visuals.OnHit.Chams.Material.Name, function(val)
            Settings.Visuals.OnHit.Chams.Material = Enum.Material[val] or Enum.Material.ForceField
        end)
        
        local WorldSection, WorldContent = CreateSection(ContentFrame, "World")
        CreateToggle(WorldContent, "WorldEnabled", "Enabled", Settings.Visuals.World.Enabled, function(val)
            Settings.Visuals.World.Enabled = val
        end)
        CreateToggle(WorldContent, "Fog", "Fog", Settings.Visuals.World.Fog.Enabled, function(val)
            Settings.Visuals.World.Fog.Enabled = val
        end)
        CreateSlider(WorldContent, "FogStart", "Fog Start", 0, 50000, Settings.Visuals.World.Fog.Start, function(val)
            Settings.Visuals.World.Fog.Start = val
        end)
        CreateSlider(WorldContent, "FogEnd", "Fog End", 0, 50000, Settings.Visuals.World.Fog.End, function(val)
            Settings.Visuals.World.Fog.End = val
        end)
        CreateToggle(WorldContent, "Ambient", "Ambient", Settings.Visuals.World.Ambient.Enabled, function(val)
            Settings.Visuals.World.Ambient.Enabled = val
        end)
        CreateToggle(WorldContent, "Brightness", "Brightness", Settings.Visuals.World.Brightness.Enabled, function(val)
            Settings.Visuals.World.Brightness.Enabled = val
        end)
        CreateSlider(WorldContent, "BrightnessValue", "Brightness Value", -5, 5, Settings.Visuals.World.Brightness.Value, function(val)
            Settings.Visuals.World.Brightness.Value = val
        end)
        CreateToggle(WorldContent, "ClockTime", "Clock Time", Settings.Visuals.World.ClockTime.Enabled, function(val)
            Settings.Visuals.World.ClockTime.Enabled = val
        end)
        CreateSlider(WorldContent, "ClockTimeValue", "Clock Time Value", 0, 24, Settings.Visuals.World.ClockTime.Value, function(val)
            Settings.Visuals.World.ClockTime.Value = val
        end)
        CreateToggle(WorldContent, "WorldExposure", "World Exposure", Settings.Visuals.World.WorldExposure.Enabled, function(val)
            Settings.Visuals.World.WorldExposure.Enabled = val
        end)
        CreateSlider(WorldContent, "WorldExposureValue", "World Exposure Value", -5, 5, Settings.Visuals.World.WorldExposure.Value, function(val)
            Settings.Visuals.World.WorldExposure.Value = val
        end)
        
        local CrosshairSection, CrosshairContent = CreateSection(ContentFrame, "Crosshair")
        CreateToggle(CrosshairContent, "Crosshair", "Enabled", Settings.Visuals.Crosshair.Enabled, function(val)
            Settings.Visuals.Crosshair.Enabled = val
        end)
        CreateToggle(CrosshairContent, "CrosshairStickToTarget", "Stick To Target", Settings.Visuals.Crosshair.StickToTarget, function(val)
            Settings.Visuals.Crosshair.StickToTarget = val
        end)
        CreateSlider(CrosshairContent, "CrosshairSize", "Size", 0, 50, Settings.Visuals.Crosshair.Size, function(val)
            Settings.Visuals.Crosshair.Size = val
        end)
        CreateSlider(CrosshairContent, "CrosshairGap", "Gap", 0, 20, Settings.Visuals.Crosshair.Gap, function(val)
            Settings.Visuals.Crosshair.Gap = val
        end)
        CreateToggle(CrosshairContent, "CrosshairRotation", "Rotation", Settings.Visuals.Crosshair.Rotation.Enabled, function(val)
            Settings.Visuals.Crosshair.Rotation.Enabled = val
        end)
        CreateSlider(CrosshairContent, "CrosshairRotationSpeed", "Rotation Speed", 0, 10, Settings.Visuals.Crosshair.Rotation.Speed, function(val)
            Settings.Visuals.Crosshair.Rotation.Speed = val
        end)
        
    elseif CurrentTab == "AntiAim" then
        local DesyncSection, DesyncContent = CreateSection(ContentFrame, "Desync")
        CreateToggle(DesyncContent, "DaCoolBoyDesync", "Da Cool Boy Desync", Settings.AntiAim.DaCoolBoyDesync, function(val)
            Settings.AntiAim.DaCoolBoyDesync = val
        end)
        CreateToggle(DesyncContent, "DaCoolBoyDesync2", "Da Cool Boy Desync 2", Settings.AntiAim.DaCoolBoyDesync2, function(val)
            Settings.AntiAim.DaCoolBoyDesync2 = val
        end)
        CreateToggle(DesyncContent, "DaCoolBoyDesync3", "Da Cool Boy Desync 3", Settings.AntiAim.DaCoolBoyDesync3, function(val)
            Settings.AntiAim.DaCoolBoyDesync3 = val
        end)
        CreateToggle(DesyncContent, "Desync", "Enabled", getgenv().Desync, function(val)
            getgenv().Desync = val
        end)
        CreateTextBox(DesyncContent, "AntiLockType", "Anti Lock Type", getgenv().AntiLockType, function(val)
            getgenv().AntiLockType = val
        end)
        
        local VelocitySpooferSection, VelocitySpooferContent = CreateSection(ContentFrame, "Velocity Spoofer")
        CreateToggle(VelocitySpooferContent, "VelocitySpoofer", "Enabled", Settings.AntiAim.VelocitySpoofer.Enabled, function(val)
            Settings.AntiAim.VelocitySpoofer.Enabled = val
        end)
        CreateToggle(VelocitySpooferContent, "VelocitySpooferVisualize", "Visualize", Settings.AntiAim.VelocitySpoofer.Visualize.Enabled, function(val)
            Settings.AntiAim.VelocitySpoofer.Visualize.Enabled = val
        end)
        CreateSlider(VelocitySpooferContent, "VelocitySpooferPrediction", "Prediction", 0, 1, Settings.AntiAim.VelocitySpoofer.Visualize.Prediction, function(val)
            Settings.AntiAim.VelocitySpoofer.Visualize.Prediction = val
        end)
        CreateTextBox(VelocitySpooferContent, "VelocitySpooferType", "Type", Settings.AntiAim.VelocitySpoofer.Type, function(val)
            Settings.AntiAim.VelocitySpoofer.Type = val
        end)
        CreateSlider(VelocitySpooferContent, "VelocitySpooferRoll", "Roll", -180, 180, Settings.AntiAim.VelocitySpoofer.Roll, function(val)
            Settings.AntiAim.VelocitySpoofer.Roll = val
        end)
        CreateSlider(VelocitySpooferContent, "VelocitySpooferPitch", "Pitch", -180, 180, Settings.AntiAim.VelocitySpoofer.Pitch, function(val)
            Settings.AntiAim.VelocitySpoofer.Pitch = val
        end)
        CreateSlider(VelocitySpooferContent, "VelocitySpooferYaw", "Yaw", -180, 180, Settings.AntiAim.VelocitySpoofer.Yaw, function(val)
            Settings.AntiAim.VelocitySpoofer.Yaw = val
        end)
        
        local CSyncSection, CSyncContent = CreateSection(ContentFrame, "CSync")
        CreateToggle(CSyncContent, "CSync", "Enabled", Settings.AntiAim.CSync.Enabled, function(val)
            Settings.AntiAim.CSync.Enabled = val
        end)
        CreateToggle(CSyncContent, "CSyncSpoof", "Spoof", Settings.AntiAim.CSync.Spoof, function(val)
            Settings.AntiAim.CSync.Spoof = val
        end)
        CreateTextBox(CSyncContent, "CSyncType", "Type", Settings.AntiAim.CSync.Type, function(val)
            Settings.AntiAim.CSync.Type = val
        end)
        CreateToggle(CSyncContent, "CSyncVisualize", "Visualize", Settings.AntiAim.CSync.Visualize.Enabled, function(val)
            Settings.AntiAim.CSync.Visualize.Enabled = val
        end)
        CreateSlider(CSyncContent, "CSyncRandomDistance", "Random Distance", 0, 50, Settings.AntiAim.CSync.RandomDistance, function(val)
            Settings.AntiAim.CSync.RandomDistance = val
        end)
        CreateSlider(CSyncContent, "CSyncCustomX", "Custom X", -50, 50, Settings.AntiAim.CSync.Custom.X, function(val)
            Settings.AntiAim.CSync.Custom.X = val
        end)
        CreateSlider(CSyncContent, "CSyncCustomY", "Custom Y", -50, 50, Settings.AntiAim.CSync.Custom.Y, function(val)
            Settings.AntiAim.CSync.Custom.Y = val
        end)
        CreateSlider(CSyncContent, "CSyncCustomZ", "Custom Z", -50, 50, Settings.AntiAim.CSync.Custom.Z, function(val)
            Settings.AntiAim.CSync.Custom.Z = val
        end)
        CreateSlider(CSyncContent, "CSyncTargetStrafeSpeed", "Target Strafe Speed", 0, 50, Settings.AntiAim.CSync.TargetStrafe.Speed, function(val)
            Settings.AntiAim.CSync.TargetStrafe.Speed = val
        end)
        CreateSlider(CSyncContent, "CSyncTargetStrafeDistance", "Target Strafe Distance", 0, 50, Settings.AntiAim.CSync.TargetStrafe.Distance, function(val)
            Settings.AntiAim.CSync.TargetStrafe.Distance = val
        end)
        CreateSlider(CSyncContent, "CSyncTargetStrafeHeight", "Target Strafe Height", 0, 50, Settings.AntiAim.CSync.TargetStrafe.Height, function(val)
            Settings.AntiAim.CSync.TargetStrafe.Height = val
        end)
        
        local NetworkSection, NetworkContent = CreateSection(ContentFrame, "Network")
        CreateToggle(NetworkContent, "Network", "Enabled", Settings.AntiAim.Network.Enabled, function(val)
            Settings.AntiAim.Network.Enabled = val
            getgenv().Sentinel.network = val
        end)
        CreateToggle(NetworkContent, "NetworkWalkingCheck", "Walking Check", Settings.AntiAim.Network.WalkingCheck, function(val)
            Settings.AntiAim.Network.WalkingCheck = val
        end)
        CreateSlider(NetworkContent, "NetworkAmount", "Amount", 0, 1, Settings.AntiAim.Network.Amount, function(val)
            Settings.AntiAim.Network.Amount = val
        end)
        
        local VelocityDesyncSection, VelocityDesyncContent = CreateSection(ContentFrame, "Velocity Desync")
        CreateToggle(VelocityDesyncContent, "VelocityDesync", "Enabled", Settings.AntiAim.VelocityDesync.Enabled, function(val)
            Settings.AntiAim.VelocityDesync.Enabled = val
        end)
        CreateSlider(VelocityDesyncContent, "VelocityDesyncRange", "Range", 0, 10, Settings.AntiAim.VelocityDesync.Range, function(val)
            Settings.AntiAim.VelocityDesync.Range = val
        end)
        
        local FFlagDesyncSection, FFlagDesyncContent = CreateSection(ContentFrame, "FFlag Desync")
        CreateToggle(FFlagDesyncContent, "FFlagDesync", "Enabled", Settings.AntiAim.FFlagDesync.Enabled, function(val)
            Settings.AntiAim.FFlagDesync.Enabled = val
        end)
        CreateToggle(FFlagDesyncContent, "FFlagDesyncSetNew", "Set New", Settings.AntiAim.FFlagDesync.SetNew, function(val)
            Settings.AntiAim.FFlagDesync.SetNew = val
        end)
        CreateSlider(FFlagDesyncContent, "FFlagDesyncAmount", "Amount", 0, 10, Settings.AntiAim.FFlagDesync.Amount, function(val)
            Settings.AntiAim.FFlagDesync.Amount = val
        end)
        CreateSlider(FFlagDesyncContent, "FFlagDesyncSetNewAmount", "Set New Amount", 0, 10, Settings.AntiAim.FFlagDesync.SetNewAmount, function(val)
            Settings.AntiAim.FFlagDesync.SetNewAmount = val
        end)
        
    elseif CurrentTab == "Misc" then
        local MovementSection, MovementContent = CreateSection(ContentFrame, "Movement")
        CreateToggle(MovementContent, "Speed", "Speed", Settings.Misc.Movement.Speed.Enabled, function(val)
            Settings.Misc.Movement.Speed.Enabled = val
        end)
        CreateSlider(MovementContent, "SpeedAmount", "Speed Amount", 0, 10, Settings.Misc.Movement.Speed.Amount, function(val)
            Settings.Misc.Movement.Speed.Amount = val
            getgenv().Sentinel.speedvalue = val
        end)
        
        local MacroSection, MacroContent = CreateSection(ContentFrame, "Macro")
        CreateToggle(MacroContent, "Macro", "Enabled", Settings.Misc.Movement.Macro.Enabled, function(val)
            Settings.Misc.Movement.Macro.Enabled = val
        end)
        CreateSlider(MacroContent, "MacroSpeed", "Speed", 0, 1, Settings.Misc.Movement.Macro.Speed, function(val)
            Settings.Misc.Movement.Macro.Speed = val
            getgenv().Sentinel.MacroSpeed = val
        end)
        
        local ExploitsSection, ExploitsContent = CreateSection(ContentFrame, "Exploits")
        CreateToggle(ExploitsContent, "NoRecoil", "No Recoil", Settings.Misc.Exploits.NoRecoil, function(val)
            Settings.Misc.Exploits.NoRecoil = val
        end)
        CreateToggle(ExploitsContent, "NoJumpCooldown", "No Jump Cooldown", Settings.Misc.Exploits.NoJumpCooldown, function(val)
            Settings.Misc.Exploits.NoJumpCooldown = val
        end)
        CreateToggle(ExploitsContent, "NoSlowDown", "No Slow Down", Settings.Misc.Exploits.NoSlowDown, function(val)
            Settings.Misc.Exploits.NoSlowDown = val
        end)
        
        local TeleportSection, TeleportContent = CreateSection(ContentFrame, "Teleports")
        CreateToggle(TeleportContent, "GrenadeTP", "Grenade TP", Script.Locals.GrenadeTP.Enabled, function(val)
            Script.Locals.GrenadeTP.Enabled = val
        end)
        CreateToggle(TeleportContent, "RocketTP", "Rocket TP", Script.Locals.RocketTP.Enabled, function(val)
            Script.Locals.RocketTP.Enabled = val
        end)
        CreateToggle(TeleportContent, "GunTP", "Gun TP", Script.Locals.GunTP.Enabled, function(val)
            Script.Locals.GunTP.Enabled = val
        end)
        
        local PredictionBreakerSection, PredictionBreakerContent = CreateSection(ContentFrame, "Prediction Breaker")
        CreateToggle(PredictionBreakerContent, "JumpBreak", "Jump Break", getgenv().Sentinel.JumpBreak, function(val)
            getgenv().Sentinel.JumpBreak = val
        end)
    end
    
    -- Update canvas size after layout updates
    local function updateCanvasSize()
        local totalHeight = UIListLayout.AbsoluteContentSize.Y
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight + 20, 100))
    end
    
    -- Wait for layout to update
    task.spawn(function()
        task.wait(0.1)
        updateCanvasSize()
    end)
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
end

-- Create Tabs
CreateTab("Combat", "Combat")
CreateTab("Visuals", "Visuals")
CreateTab("AntiAim", "AntiAim")
CreateTab("Misc", "Misc")

-- UI Toggle Functionality (Show/Hide UI)
local function ToggleUI()
    UIEnabled = not UIEnabled
    MainFrame.Visible = UIEnabled
    UIToggleBtn.BackgroundColor3 = UIEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
    UIToggleBtn.Text = UIEnabled and "UI ON" or "UI OFF"
    FloatingUIToggle.BackgroundColor3 = UIEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
    FloatingUIToggle.Text = UIEnabled and "UI ON" or "UI OFF"
end

UIToggleBtn.MouseButton1Click:Connect(ToggleUI)
FloatingUIToggle.MouseButton1Click:Connect(ToggleUI)

-- Lock Toggle Functionality
local function SigmaOhioPlayer()
    local closestPlayer
    local shortestDistance = math.huge
    local player = game.Players.LocalPlayer
    local CC = game:GetService("Workspace").CurrentCamera
    local screenCenter = Vector2.new(CC.ViewportSize.X / 2, CC.ViewportSize.Y / 2)
    local fovRadius = 250
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

-- Lock Toggle Functionality (Target Lock/Camlock)
local function ToggleLock()
    LockEnabled = not LockEnabled
    TargBindEnabled = LockEnabled
    
    if LockEnabled then
        local closest = SigmaOhioPlayer()
        TargetPlr = closest
        if TargetPlr then
            LockToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            LockToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            LockToggleBtn.Text = "LOCKED"
            FloatingLockToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            FloatingLockToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            FloatingLockToggle.Text = "LOCKED"
        else
            LockEnabled = false
            TargBindEnabled = false
            LockToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            LockToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
            LockToggleBtn.Text = "Lock"
            FloatingLockToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            FloatingLockToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
            FloatingLockToggle.Text = "Lock"
        end
    else
        TargetPlr = nil
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        LockToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        LockToggleBtn.Text = "Lock"
        FloatingLockToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        FloatingLockToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        FloatingLockToggle.Text = "Lock"
    end
end

LockToggleBtn.MouseButton1Click:Connect(ToggleLock)
FloatingLockToggle.MouseButton1Click:Connect(ToggleLock)

-- Initial UI Build (with error handling)
task.spawn(function()
    local success, err = pcall(function()
        BuildUI()
        print("[Aimbot Script] UI Loaded Successfully!")
    end)
    if not success then
        warn("[Aimbot Script] UI Build Error: " .. tostring(err))
    end
end)

-- ============================================
-- FEATURE CODE IMPLEMENTATIONS
-- ============================================

-- Prediction Table
local predictionTable = {
    {20, 0.08960952},
    {30, 0.11252476},
    {50, 0.13544},
    {65, 0.1264236},
    {70, 0.12533},
    {80, 0.139340},
    {100, 0.141987},
    {110, 0.144634},
    {120, 0.147281},
    {130, 0.149928},
    {140, 0.152575},
    {150, 0.155222},
    {160, 0.157869},
    {170, 0.160516},
    {180, 0.163163},
    {190, 0.165810},
    {200, 0.168457},
    {210, 0.171104},
    {220, 0.173751},
    {230, 0.176398},
    {240, 0.179045},
    {250, 0.181692},
    {260, 0.184339},
    {270, 0.186986},
    {280, 0.189633},
    {290, 0.192280},
    {300, 0.194927}
}

-- Update Prediction Value
local function updatePredictionValue()
    if getgenv().Sentinel.AutoPrediction then
        pcall(function()
            local pingValue = Stas.Network.ServerStatsItem["Data Ping"]:GetValueString()
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
        end)
    end
end

-- Look At Player
function LookAtPlayer(Target)
    pcall(function()
        local localChar = LocalPlayer.Character
        if not localChar then return end
        
        local localHumanoidRootPart = localChar:FindFirstChild("HumanoidRootPart")
        if not localHumanoidRootPart then return end

        if getgenv().Sentinel and getgenv().Sentinel.LookAt then
            if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                local targetHumanoidRootPart = Target.Character.HumanoidRootPart
                local targetPosition = targetHumanoidRootPart.Position
                local localPosition = localHumanoidRootPart.Position
                local horizontalDirection = Vector3.new(targetPosition.X - localPosition.X, 0, targetPosition.Z - localPosition.Z).unit
                localHumanoidRootPart.CFrame = CFrame.new(localPosition, localPosition + horizontalDirection)
                if localChar:FindFirstChild("Humanoid") then
                    localChar.Humanoid.AutoRotate = false
                end
            end
        else
            if localChar:FindFirstChild("Humanoid") then
                localChar.Humanoid.AutoRotate = true
            end
        end
        
        if not (Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart")) then
            if localChar:FindFirstChild("Humanoid") then
                localChar.Humanoid.AutoRotate = true
            end
        end
    end)
end

-- Nearest Part
local function NearestPart(TargetPlr)
    pcall(function()
        local BodyParts = {
            "Head", "UpperTorso", "LowerTorso", 
            "LeftUpperArm", "LeftLowerArm", "LeftHand", 
            "RightUpperArm", "RightLowerArm", "RightHand", 
            "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", 
            "RightUpperLeg", "RightLowerLeg", "RightFoot"
        }

        local selectedPartName = getgenv().Sentinel.SelectedPart
        local localChar = LocalPlayer.Character

        if TargetPlr and TargetPlr.Character and localChar and localChar:FindFirstChild("HumanoidRootPart") then
            if getgenv().Sentinel.NearestPart then
                local minDistance = math.huge
                local nearestPart = nil
                
                for _, partName in pairs(BodyParts) do
                    local part = TargetPlr.Character:FindFirstChild(partName)
                    if part then
                        local distance = (part.Position - localChar.HumanoidRootPart.Position).Magnitude
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
    end)
end

-- In Air Check
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

-- Predicted Position
local function predictedposition()
    local selectedPart = getgenv().Sentinel.SelectedPart
    if not TargetPlr or not TargetPlr.Character then return nil end
    
    local targetPart = TargetPlr.Character:FindFirstChild(selectedPart)
    if not targetPart then return nil end

    local velocity
    if not getgenv().Sentinel.ResolverEnabled then
        velocity = targetPart.Velocity
    else
        if TargetPlr.Character:FindFirstChild("Humanoid") then
            velocity = TargetPlr.Character.Humanoid.MoveDirection * TargetPlr.Character.Humanoid.WalkSpeed
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

-- Camera Smoothing
RunService.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().Sentinel.Camera and TargetPlr and TargetPlr.Character and getgenv().Sentinel.SelectedPart then
            local camera = Workspace.CurrentCamera
            if not camera then return end
            
            local selectedPart = getgenv().Sentinel.SelectedPart
            local targetPart = TargetPlr.Character:FindFirstChild(selectedPart)

            if targetPart then
                local velocity = targetPart.Velocity
                local jumpOffset = getgenv().Sentinel.jumpoffset or 0
                local horizontalPrediction = getgenv().Sentinel.HorizontalPrediction
                local verticalPrediction = getgenv().Sentinel.VerticalPrediction

                local targetPosition = Vector3.new(
                    targetPart.Position.X + (velocity.X * horizontalPrediction),
                    targetPart.Position.Y + (velocity.Y * verticalPrediction) + jumpOffset,
                    targetPart.Position.Z + (velocity.Z * horizontalPrediction)
                )

                local smoothness = getgenv().Sentinel.smoothness or 0.1
                local easingStyle = Enum.EasingStyle[getgenv().Sentinel.easingStyle] or Enum.EasingStyle.Quad
                local easingDirection = Enum.EasingDirection[getgenv().Sentinel.easingDirection] or Enum.EasingDirection.In

                camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, targetPosition), smoothness, easingStyle, easingDirection)
            end
        end
    end)
end)

-- Main Stepped Loop
RunService.Stepped:Connect(function()
    pcall(function()
        updatePredictionValue()
        LookAtPlayer(TargetPlr)
        NearestPart(TargetPlr)
        inAir()
        if not getgenv().Sentinel.AutoPrediction then
            getgenv().Sentinel.HorizontalPrediction2 = getgenv().Sentinel.HorizontalPrediction
            getgenv().Sentinel.VerticalPrediction = getgenv().Sentinel.HorizontalPrediction2
        end
    end)
end)

-- Grenade TP
RunService.Heartbeat:Connect(function()
    pcall(function()
        if Script.Locals.GrenadeTP.Enabled and TargetPlr and TargetPlr.Character and workspace:FindFirstChild("Ignored") then
            if workspace.Ignored:FindFirstChild("Handle") then
                local selectedPart = getgenv().Sentinel.SelectedPart
                local targetPart = TargetPlr.Character:FindFirstChild(selectedPart)
                if targetPart then
                    workspace.Ignored.Handle.Position = targetPart.Position + (targetPart.Velocity * getgenv().Sentinel.HorizontalPrediction)
                end
            end
        end
    end)
end)

-- Rocket TP
if workspace:FindFirstChild("Ignored") then
    workspace.Ignored.ChildAdded:Connect(function(object)
        if Script.Locals.RocketTP.Enabled and TargetPlr and TargetPlr.Character then
            if object.Name == "Model" or object.Name == "GrenadeLauncherAmmo" then
                local SkibidiGrenadeLauncher = object.Name == "GrenadeLauncherAmmo"
                local part = SkibidiGrenadeLauncher and object:WaitForChild("Main", 5) or object:WaitForChild("Launcher", 5)
                
                if part then
                    part.CFrame = CFrame.new(1, 1, 1)
                    
                    if not SkibidiGrenadeLauncher then
                        if part:FindFirstChild("BodyVelocity") then part.BodyVelocity:Destroy() end
                        if part:FindFirstChild("TouchInterest") then part.TouchInterest:Destroy() end
                    end
                    
                    local connection
                    connection = RunService.PostSimulation:Connect(function()
                        if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("HumanoidRootPart") then
                            part.CFrame = TargetPlr.Character.HumanoidRootPart.CFrame
                            part.Velocity = Vector3.new(0, 0.001, 0)
                        end
                    end)
                    
                    object.Destroying:Connect(function()
                        if connection then connection:Disconnect() end
                    end)
                end
            end
        end
    end)
end

-- Jump Break
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").StateChanged:Connect(function(old, new)
        if getgenv().Sentinel.JumpBreak and new == Enum.HumanoidStateType.Freefall then
            task.wait(0.27)
            if character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.Velocity = Vector3.new(0, -15, 0)
            end
        end
    end)
end)

-- Desync
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().Desync == true and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local abc = LocalPlayer.Character.HumanoidRootPart.Velocity

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
        
        LocalPlayer.Character.HumanoidRootPart.Velocity = getgenv().Direction * (2^16)
        game:GetService("RunService").RenderStepped:Wait()
        LocalPlayer.Character.HumanoidRootPart.Velocity = abc
    end
end)

-- Network Anti
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if getgenv().Sentinel and getgenv().Sentinel.network then
            sethiddenproperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", true)
            task.wait()
            sethiddenproperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", false)
            setfflag("S2PhysicsSenderRate", 2)
        else
            setfflag("S2PhysicsSenderRate", 13)
            sethiddenproperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", false)
        end
    end
end)

-- Speed Hack
RunService.Heartbeat:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if Settings.Misc.Movement.Speed.Enabled then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16 * Settings.Misc.Movement.Speed.Amount
            else
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end)
end)

-- Spectate
RunService.RenderStepped:Connect(function()
    pcall(function()
        local camera = Workspace.CurrentCamera
        if not camera then return end
        
        if Settings.Combat.Spectate and TargetPlr and TargetPlr.Character then
            local targetHumanoid = TargetPlr.Character:FindFirstChild("Humanoid")
            if targetHumanoid then
                camera.CameraSubject = targetHumanoid
            end
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                camera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end
    end)
end)

-- Success message
task.spawn(function()
    task.wait(1)
    print("============================================")
    print("Custom UI Script Loaded Successfully!")
    print("UI Toggle: Click 'UI' button to show/hide")
    print("Lock Toggle: Click 'Lock' button to lock/unlock target")
    print("============================================")
end)
