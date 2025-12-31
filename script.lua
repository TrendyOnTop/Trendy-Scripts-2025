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
    },
    AuraIgnoreFolder = Instance.new("Folder", game:GetService("Workspace"))
}

-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Stas = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Target Variables
local TargBindEnabled = false
local TargetPlr = nil
local Highlight = false

-- ============================================
-- CUSTOM UI SYSTEM
-- ============================================

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
MainFrame.Visible = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

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
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Tab Buttons Storage
local TabButtons = {}

-- Function to create tab button
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
    local percent = math.clamp((defaultValue - min) / (max - min), 0, 1)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    
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
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = SliderTrack.AbsolutePosition.X
            local trackSize = SliderTrack.AbsoluteSize.X
            local percent = math.clamp((mousePos.X - trackPos) / trackSize, 0, 1)
            updateValue(min + (max - min) * percent)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = SliderTrack.AbsolutePosition.X
            local trackSize = SliderTrack.AbsoluteSize.X
            local percent = math.clamp((mousePos.X - trackPos) / trackSize, 0, 1)
            updateValue(min + (max - min) * percent)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
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
        if child:IsA("Frame") and child.Name ~= "ContentFrame" then
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
        
        local CameraSection, CameraContent = CreateSection(ContentFrame, "Camera")
        CreateToggle(CameraContent, "Camera", "Enabled", getgenv().Sentinel.Camera, function(val)
            getgenv().Sentinel.Camera = val
        end)
        CreateSlider(CameraContent, "Smoothness", "Smoothness", 0, 1, getgenv().Sentinel.smoothness, function(val)
            getgenv().Sentinel.smoothness = val
        end)
        
        local HitPartSection, HitPartContent = CreateSection(ContentFrame, "Hit Part")
        CreateTextBox(HitPartContent, "SelectedPart", "Body Part", getgenv().Sentinel.SelectedPart, function(val)
            getgenv().Sentinel.SelectedPart = val
        end)
        
    elseif CurrentTab == "Visuals" then
        local BacktrackSection, BacktrackContent = CreateSection(ContentFrame, "Backtrack")
        CreateToggle(BacktrackContent, "Backtrack", "Enabled", Settings.Visuals.Backtrack.Enabled, function(val)
            Settings.Visuals.Backtrack.Enabled = val
        end)
        
        local TracersSection, TracersContent = CreateSection(ContentFrame, "Bullet Tracers")
        CreateToggle(TracersContent, "BulletTracers", "Enabled", Settings.Visuals.BulletTracers.Enabled, function(val)
            Settings.Visuals.BulletTracers.Enabled = val
        end)
        
        local OnHitSection, OnHitContent = CreateSection(ContentFrame, "On Hit")
        CreateToggle(OnHitContent, "OnHitEffect", "Effect", Settings.Visuals.OnHit.Effect.Enabled, function(val)
            Settings.Visuals.OnHit.Effect.Enabled = val
        end)
        CreateToggle(OnHitContent, "OnHitSound", "Sound", Settings.Visuals.OnHit.Sound.Enabled, function(val)
            Settings.Visuals.OnHit.Sound.Enabled = val
        end)
        CreateToggle(OnHitContent, "OnHitChams", "Chams", Settings.Visuals.OnHit.Chams.Enabled, function(val)
            Settings.Visuals.OnHit.Chams.Enabled = val
        end)
        
    elseif CurrentTab == "AntiAim" then
        local CSyncSection, CSyncContent = CreateSection(ContentFrame, "CSync")
        CreateToggle(CSyncContent, "CSync", "Enabled", Settings.AntiAim.CSync.Enabled, function(val)
            Settings.AntiAim.CSync.Enabled = val
        end)
        CreateSlider(CSyncContent, "CSyncDistance", "Distance", 0, 20, Settings.AntiAim.CSync.RandomDistance, function(val)
            Settings.AntiAim.CSync.RandomDistance = val
        end)
        
        local NetworkSection, NetworkContent = CreateSection(ContentFrame, "Network")
        CreateToggle(NetworkContent, "Network", "Enabled", Settings.AntiAim.Network.Enabled, function(val)
            Settings.AntiAim.Network.Enabled = val
            getgenv().Sentinel.network = val
        end)
        
        local DesyncSection, DesyncContent = CreateSection(ContentFrame, "Desync")
        CreateToggle(DesyncContent, "Desync", "Enabled", getgenv().Desync, function(val)
            getgenv().Desync = val
        end)
        CreateTextBox(DesyncContent, "AntiLockType", "Anti Lock Type", getgenv().AntiLockType, function(val)
            getgenv().AntiLockType = val
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
    
    -- Update canvas size
    task.spawn(function()
        task.wait(0.1)
        local totalHeight = UIListLayout.AbsoluteContentSize.Y
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight + 20, 100))
    end)
end

-- Create Tabs
CreateTab("Combat", "Combat")
CreateTab("Visuals", "Visuals")
CreateTab("AntiAim", "AntiAim")
CreateTab("Misc", "Misc")

-- UI Toggle Functionality
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
    local player = LocalPlayer
    local CC = Workspace.CurrentCamera
    if not CC then return nil end
    
    local screenCenter = Vector2.new(CC.ViewportSize.X / 2, CC.ViewportSize.Y / 2)
    local fovRadius = 250
    local viewportSize = CC.ViewportSize

    for i, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") 
           and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = CC:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            
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

-- Initial UI Build
BuildUI()

-- Success message
print("============================================")
print("Custom UI Script Loaded Successfully!")
print("UI Toggle: Click 'UI' button to show/hide")
print("Lock Toggle: Click 'Lock' button to lock/unlock target")
print("============================================")
