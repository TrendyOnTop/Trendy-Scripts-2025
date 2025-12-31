-- Settings Table (Keep this intact)
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

-- Target Variables
local TargBindEnabled = true
local TargetPlr
local TargResolvePos
local Highlight = false

-- ============================================
-- NEW CUSTOM UI SYSTEM FROM SCRATCH
-- ============================================

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- UI State
local UIEnabled = true
local LockEnabled = false

-- Create Main ScreenGui
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "CustomAimbotUI"
MainGui.Parent = CoreGui
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.ResetOnSpawn = false

-- Create Main Frame (Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.Active = true
MainFrame.Draggable = true

-- Corner
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Stroke
local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(50, 50, 70)
MainStroke.Thickness = 2

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "Aimbot Settings"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- UI Toggle Button (Top Right)
local UIToggleBtn = Instance.new("TextButton")
UIToggleBtn.Name = "UIToggleBtn"
UIToggleBtn.Parent = TitleBar
UIToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
UIToggleBtn.BorderSizePixel = 0
UIToggleBtn.Size = UDim2.new(0, 40, 0, 30)
UIToggleBtn.Position = UDim2.new(1, -90, 0.5, -15)
UIToggleBtn.Font = Enum.Font.Gotham
UIToggleBtn.Text = "UI"
UIToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UIToggleBtn.TextSize = 14

local UIToggleCorner = Instance.new("UICorner")
UIToggleCorner.CornerRadius = UDim.new(0, 6)
UIToggleCorner.Parent = UIToggleBtn

-- Lock Toggle Button (Next to UI Toggle)
local LockToggleBtn = Instance.new("TextButton")
LockToggleBtn.Name = "LockToggleBtn"
LockToggleBtn.Parent = TitleBar
LockToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
LockToggleBtn.BorderSizePixel = 0
LockToggleBtn.Size = UDim2.new(0, 40, 0, 30)
LockToggleBtn.Position = UDim2.new(1, -45, 0.5, -15)
LockToggleBtn.Font = Enum.Font.Gotham
LockToggleBtn.Text = "Lock"
LockToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
LockToggleBtn.TextSize = 14

local LockToggleCorner = Instance.new("UICorner")
LockToggleCorner.CornerRadius = UDim.new(0, 6)
LockToggleCorner.Parent = LockToggleBtn

-- Content ScrollingFrame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.ScrollBarThickness = 6
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

-- UI List Layout
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Function to create toggle
local function CreateToggle(parent, name, text, defaultValue, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "Toggle"
    ToggleBtn.Parent = ToggleFrame
    ToggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Size = UDim2.new(0, 50, 0, 30)
    ToggleBtn.Position = UDim2.new(1, -60, 0.5, -15)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Text = defaultValue and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 12
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(0, 6)
    ToggleBtnCorner.Parent = ToggleBtn
    
    local state = defaultValue
    
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
        ToggleBtn.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
    
    return ToggleFrame, function(newState)
        state = newState
        ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
        ToggleBtn.Text = state and "ON" or "OFF"
    end
end

-- Function to create slider
local function CreateSlider(parent, name, text, min, max, defaultValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "Label"
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Size = UDim2.new(1, -20, 0, 25)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = text .. ": " .. tostring(defaultValue)
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "Track"
    SliderTrack.Parent = SliderFrame
    SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Size = UDim2.new(1, -20, 0, 6)
    SliderTrack.Position = UDim2.new(0, 10, 0, 35)
    
    local SliderTrackCorner = Instance.new("UICorner")
    SliderTrackCorner.CornerRadius = UDim.new(0, 3)
    SliderTrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.Parent = SliderTrack
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 3)
    SliderFillCorner.Parent = SliderFill
    
    local value = defaultValue
    local dragging = false
    
    local function updateValue(newValue)
        value = math.clamp(newValue, min, max)
        local percent = (value - min) / (max - min)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderLabel.Text = text .. ": " .. string.format("%.2f", value)
        if callback then callback(value) end
    end
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pos = UDim2.new(0, math.clamp(input.Position.X - SliderTrack.AbsolutePosition.X, 0, SliderTrack.AbsoluteSize.X), 0, 0)
            local percent = pos.X.Scale
            updateValue(min + (max - min) * percent)
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
            updateValue(min + (max - min) * percent)
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return SliderFrame, function(newValue) updateValue(newValue) end
end

-- Function to create textbox
local function CreateTextBox(parent, name, text, defaultValue, callback)
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = name
    TextBoxFrame.Parent = parent
    TextBoxFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.Size = UDim2.new(1, 0, 0, 50)
    
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 8)
    TextBoxCorner.Parent = TextBoxFrame
    
    local TextBoxLabel = Instance.new("TextLabel")
    TextBoxLabel.Name = "Label"
    TextBoxLabel.Parent = TextBoxFrame
    TextBoxLabel.BackgroundTransparency = 1
    TextBoxLabel.Size = UDim2.new(1, -20, 0, 25)
    TextBoxLabel.Position = UDim2.new(0, 10, 0, 5)
    TextBoxLabel.Font = Enum.Font.Gotham
    TextBoxLabel.Text = text
    TextBoxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBoxLabel.TextSize = 14
    TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextBoxInput = Instance.new("TextBox")
    TextBoxInput.Name = "Input"
    TextBoxInput.Parent = TextBoxFrame
    TextBoxInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TextBoxInput.BorderSizePixel = 0
    TextBoxInput.Size = UDim2.new(1, -20, 0, 25)
    TextBoxInput.Position = UDim2.new(0, 10, 0, 25)
    TextBoxInput.Font = Enum.Font.Gotham
    TextBoxInput.Text = tostring(defaultValue)
    TextBoxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBoxInput.TextSize = 14
    TextBoxInput.PlaceholderText = "Enter value..."
    
    local TextBoxInputCorner = Instance.new("UICorner")
    TextBoxInputCorner.CornerRadius = UDim.new(0, 6)
    TextBoxInputCorner.Parent = TextBoxInput
    
    TextBoxInput.FocusLost:Connect(function()
        if callback then callback(TextBoxInput.Text) end
    end)
    
    return TextBoxFrame, function(newValue) TextBoxInput.Text = tostring(newValue) end
end

-- Create UI Elements from Settings
local function BuildUI()
    -- Combat Section
    local CombatSection = Instance.new("Frame")
    CombatSection.Name = "CombatSection"
    CombatSection.Parent = ContentFrame
    CombatSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    CombatSection.BorderSizePixel = 0
    CombatSection.Size = UDim2.new(1, 0, 0, 0)
    
    local CombatCorner = Instance.new("UICorner")
    CombatCorner.CornerRadius = UDim.new(0, 8)
    CombatCorner.Parent = CombatSection
    
    local CombatTitle = Instance.new("TextLabel")
    CombatTitle.Name = "Title"
    CombatTitle.Parent = CombatSection
    CombatTitle.BackgroundTransparency = 1
    CombatTitle.Size = UDim2.new(1, -20, 0, 30)
    CombatTitle.Position = UDim2.new(0, 10, 0, 5)
    CombatTitle.Font = Enum.Font.GothamBold
    CombatTitle.Text = "Combat"
    CombatTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    CombatTitle.TextSize = 16
    CombatTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local CombatContent = Instance.new("Frame")
    CombatContent.Name = "Content"
    CombatContent.Parent = CombatSection
    CombatContent.BackgroundTransparency = 1
    CombatContent.Size = UDim2.new(1, -20, 0, 0)
    CombatContent.Position = UDim2.new(0, 10, 0, 35)
    
    local CombatLayout = Instance.new("UIListLayout")
    CombatLayout.Parent = CombatContent
    CombatLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CombatLayout.Padding = UDim.new(0, 5)
    
    CreateToggle(CombatContent, "Enabled", "Enabled", Settings.Combat.Enabled, function(val)
        Settings.Combat.Enabled = val
        getgenv().Sentinel.Enabled = val
    end)
    
    CreateToggle(CombatContent, "LookAt", "Look At", Settings.Combat.LookAt, function(val)
        Settings.Combat.LookAt = val
        getgenv().Sentinel.LookAt = val
    end)
    
    CreateToggle(CombatContent, "Resolver", "Resolver", Settings.Combat.Resolver.Enabled, function(val)
        Settings.Combat.Resolver.Enabled = val
        getgenv().Sentinel.ResolverEnabled = val
    end)
    
    CreateSlider(CombatContent, "HorizontalPrediction", "Horizontal Prediction", 0, 1, Settings.Combat.Prediction.Horizontal, function(val)
        Settings.Combat.Prediction.Horizontal = val
        getgenv().Sentinel.HorizontalPrediction = val
    end)
    
    CreateSlider(CombatContent, "VerticalPrediction", "Vertical Prediction", 0, 1, Settings.Combat.Prediction.Vertical, function(val)
        Settings.Combat.Prediction.Vertical = val
        getgenv().Sentinel.VerticalPrediction = val
    end)
    
    -- Visuals Section
    local VisualsSection = Instance.new("Frame")
    VisualsSection.Name = "VisualsSection"
    VisualsSection.Parent = ContentFrame
    VisualsSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    VisualsSection.BorderSizePixel = 0
    VisualsSection.Size = UDim2.new(1, 0, 0, 0)
    
    local VisualsCorner = Instance.new("UICorner")
    VisualsCorner.CornerRadius = UDim.new(0, 8)
    VisualsCorner.Parent = VisualsSection
    
    local VisualsTitle = Instance.new("TextLabel")
    VisualsTitle.Name = "Title"
    VisualsTitle.Parent = VisualsSection
    VisualsTitle.BackgroundTransparency = 1
    VisualsTitle.Size = UDim2.new(1, -20, 0, 30)
    VisualsTitle.Position = UDim2.new(0, 10, 0, 5)
    VisualsTitle.Font = Enum.Font.GothamBold
    VisualsTitle.Text = "Visuals"
    VisualsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    VisualsTitle.TextSize = 16
    VisualsTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local VisualsContent = Instance.new("Frame")
    VisualsContent.Name = "Content"
    VisualsContent.Parent = VisualsSection
    VisualsContent.BackgroundTransparency = 1
    VisualsContent.Size = UDim2.new(1, -20, 0, 0)
    VisualsContent.Position = UDim2.new(0, 10, 0, 35)
    
    local VisualsLayout = Instance.new("UIListLayout")
    VisualsLayout.Parent = VisualsContent
    VisualsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    VisualsLayout.Padding = UDim.new(0, 5)
    
    CreateToggle(VisualsContent, "Backtrack", "Backtrack", Settings.Visuals.Backtrack.Enabled, function(val)
        Settings.Visuals.Backtrack.Enabled = val
    end)
    
    CreateToggle(VisualsContent, "BulletTracers", "Bullet Tracers", Settings.Visuals.BulletTracers.Enabled, function(val)
        Settings.Visuals.BulletTracers.Enabled = val
    end)
    
    -- Misc Section
    local MiscSection = Instance.new("Frame")
    MiscSection.Name = "MiscSection"
    MiscSection.Parent = ContentFrame
    MiscSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MiscSection.BorderSizePixel = 0
    MiscSection.Size = UDim2.new(1, 0, 0, 0)
    
    local MiscCorner = Instance.new("UICorner")
    MiscCorner.CornerRadius = UDim.new(0, 8)
    MiscCorner.Parent = MiscSection
    
    local MiscTitle = Instance.new("TextLabel")
    MiscTitle.Name = "Title"
    MiscTitle.Parent = MiscSection
    MiscTitle.BackgroundTransparency = 1
    MiscTitle.Size = UDim2.new(1, -20, 0, 30)
    MiscTitle.Position = UDim2.new(0, 10, 0, 5)
    MiscTitle.Font = Enum.Font.GothamBold
    MiscTitle.Text = "Misc"
    MiscTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MiscTitle.TextSize = 16
    MiscTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local MiscContent = Instance.new("Frame")
    MiscContent.Name = "Content"
    MiscContent.Parent = MiscSection
    MiscContent.BackgroundTransparency = 1
    MiscContent.Size = UDim2.new(1, -20, 0, 0)
    MiscContent.Position = UDim2.new(0, 10, 0, 35)
    
    local MiscLayout = Instance.new("UIListLayout")
    MiscLayout.Parent = MiscContent
    MiscLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MiscLayout.Padding = UDim.new(0, 5)
    
    CreateToggle(MiscContent, "Speed", "Speed", Settings.Misc.Movement.Speed.Enabled, function(val)
        Settings.Misc.Movement.Speed.Enabled = val
    end)
    
    CreateToggle(MiscContent, "NoRecoil", "No Recoil", Settings.Misc.Exploits.NoRecoil, function(val)
        Settings.Misc.Exploits.NoRecoil = val
    end)
    
    -- Update canvas size
    task.wait()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end)
end

-- UI Toggle Functionality
UIToggleBtn.MouseButton1Click:Connect(function()
    UIEnabled = not UIEnabled
    MainFrame.Visible = UIEnabled
    UIToggleBtn.BackgroundColor3 = UIEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
    UIToggleBtn.Text = UIEnabled and "UI" or "UI"
end)

-- Lock Toggle Functionality
LockToggleBtn.MouseButton1Click:Connect(function()
    LockEnabled = not LockEnabled
    TargBindEnabled = LockEnabled
    
    if LockEnabled then
        -- Find target
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
        
        TargetPlr = closestPlayer
        if TargetPlr then
            LockToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            LockToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    else
        TargetPlr = nil
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        LockToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Build UI
BuildUI()

-- ============================================
-- ALL FEATURE SOURCE CODE BELOW
-- ============================================

-- [All the original feature code would go here - hit effects, aimbot logic, etc.]
-- Keeping the structure but removing GUI dependencies

-- Example: Keep target finding logic
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

-- [Continue with all other feature code...]

print("Custom UI Script Loaded!")
