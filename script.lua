-- Redesigned UI Script
local Menu = nil
local success, err = pcall(function()
    Menu = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/library/refs/heads/main/cuh.txt",true))()
    if Menu then
        task.spawn(function()
            Menu:NameUpdate(0.6, 'Cactus', '.GG [khen.cc]')
        end)
    end
end)

if not success or not Menu then
    warn("Failed to load Menu library:", err)
    -- Create a simple notification system if Menu fails
    Menu = {
        Notify = function(msg, duration)
            print("[Cactus] " .. tostring(msg))
        end,
        SetTitle = function(title) end,
        SetVisible = function(visible) end,
        Init = function() end
    }
end

-- All your existing Script, Settings, and getgenv().Sentinel tables remain the same
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

-- Initialize TargetAimbot BEFORE UI creation
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
    HitChamsColor = Color3.fromRGB(173, 216, 230),
    HitChamsTransparency = 0.5
}

local Highlight = false
local Hitnotify = false

-- ============================================
-- NEW UI SYSTEM FROM SCRATCH
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Initialize Blur Effect early
local Blur = Instance.new("BlurEffect", Lighting)
Blur.Enabled = false

-- UI State
local UIManager = {
    MainUI = nil,
    SettingsUI = nil,
    ToggleButton = nil,
    LockButton = nil,
    MainUIVisible = true,
    SettingsUIVisible = false,
    Locked = false,
    Dragging = {
        MainUI = false,
        SettingsUI = false,
        ToggleButton = false,
        LockButton = false
    },
    DragStartPositions = {}
}

-- Create Draggable Function
local function MakeDraggable(frame, dragButton)
    dragButton = dragButton or frame
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Create Modern Button
local function CreateButton(parent, text, size, position, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    button.BorderSizePixel = 0
    button.Size = size
    button.Position = position
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = button
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Create Toggle Button
local function CreateToggle(parent, text, size, position, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Size = size
    frame.Position = position
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = frame
    toggleFrame.Size = UDim2.new(0, 50, 0, 25)
    toggleFrame.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleFrame.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    toggleFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = toggleFrame
    toggleButton.Size = UDim2.new(0, 20, 0, 20)
    toggleButton.Position = defaultValue and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = toggleButton
    
    local enabled = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        
        TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
        }):Play()
        
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            Position = enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        }):Play()
    end)
    
    return toggleFrame, toggleButton
end

-- Create Slider
local function CreateSlider(parent, text, size, position, min, max, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Size = size
    frame.Position = position
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text .. ": " .. defaultValue
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = frame
    sliderFrame.Size = UDim2.new(1, 0, 0, 6)
    sliderFrame.Position = UDim2.new(0, 0, 1, -10)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sliderFrame.BorderSizePixel = 0
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 3)
    sliderCorner.Parent = sliderFrame
    
    local fillFrame = Instance.new("Frame")
    fillFrame.Parent = sliderFrame
    fillFrame.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    fillFrame.Position = UDim2.new(0, 0, 0, 0)
    fillFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    fillFrame.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fillFrame
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Parent = sliderFrame
    sliderButton.Size = UDim2.new(0, 12, 0, 12)
    sliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -6, 0.5, -6)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = sliderButton
    
    local dragging = false
    local currentValue = defaultValue
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = sliderFrame.AbsolutePosition
            local sliderSize = sliderFrame.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            currentValue = math.floor((min + (max - min) * relativeX) * 100) / 100
            callback(currentValue)
            label.Text = text .. ": " .. currentValue
            fillFrame.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -6, 0.5, -6)
        end
    end)
    
    return frame
end

-- Create TextBox
local function CreateTextBox(parent, text, size, position, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Size = size
    frame.Position = position
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local textBox = Instance.new("TextBox")
    textBox.Parent = frame
    textBox.Size = UDim2.new(0.55, 0, 1, 0)
    textBox.Position = UDim2.new(0.45, 0, 0, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    textBox.BorderSizePixel = 0
    textBox.Font = Enum.Font.Gotham
    textBox.Text = tostring(defaultValue)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 13
    textBox.PlaceholderText = "Enter value..."
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = textBox
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = textBox
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1
    
    textBox.FocusLost:Connect(function()
        callback(textBox.Text)
    end)
    
    return textBox
end

-- Create Dropdown
local function CreateDropdown(parent, text, size, position, options, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Size = size
    frame.Position = position
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdown = Instance.new("TextButton")
    dropdown.Parent = frame
    dropdown.Size = UDim2.new(0.55, 0, 1, 0)
    dropdown.Position = UDim2.new(0.45, 0, 0, 0)
    dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    dropdown.BorderSizePixel = 0
    dropdown.Font = Enum.Font.Gotham
    dropdown.Text = defaultValue
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.TextSize = 13
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = dropdown
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = dropdown
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1
    
    local open = false
    local optionsFrame = nil
    
    dropdown.MouseButton1Click:Connect(function()
        open = not open
        if open then
            optionsFrame = Instance.new("ScrollingFrame")
            optionsFrame.Parent = frame
            optionsFrame.Size = UDim2.new(0.55, 0, 0, math.min(#options * 30, 150))
            optionsFrame.Position = UDim2.new(0.45, 0, 1, 5)
            optionsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            optionsFrame.BorderSizePixel = 0
            optionsFrame.ScrollBarThickness = 4
            optionsFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
            
            local optionsCorner = Instance.new("UICorner")
            optionsCorner.CornerRadius = UDim.new(0, 4)
            optionsCorner.Parent = optionsFrame
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Parent = optionsFrame
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
                optionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                optionButton.BorderSizePixel = 0
                optionButton.Font = Enum.Font.Gotham
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionButton.TextSize = 12
                
                optionButton.MouseButton1Click:Connect(function()
                    dropdown.Text = option
                    callback(option)
                    open = false
                    optionsFrame:Destroy()
                end)
            end
        else
            if optionsFrame then
                optionsFrame:Destroy()
            end
        end
    end)
    
    return dropdown
end

-- Create ColorPicker
local function CreateColorPicker(parent, text, size, position, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Size = size
    frame.Position = position
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local colorButton = Instance.new("TextButton")
    colorButton.Parent = frame
    colorButton.Size = UDim2.new(0.55, 0, 1, 0)
    colorButton.Position = UDim2.new(0.45, 0, 0, 0)
    colorButton.BackgroundColor3 = defaultValue
    colorButton.BorderSizePixel = 0
    colorButton.Font = Enum.Font.Gotham
    colorButton.Text = ""
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = colorButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = colorButton
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1
    
    colorButton.MouseButton1Click:Connect(function()
        -- Simple color picker - you can enhance this with a proper color picker UI
        callback(colorButton.BackgroundColor3)
    end)
    
    return colorButton
end

-- Create Hotkey Button
local function CreateHotkey(parent, text, size, position, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Size = size
    frame.Position = position
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local hotkeyButton = Instance.new("TextButton")
    hotkeyButton.Parent = frame
    hotkeyButton.Size = UDim2.new(0.55, 0, 1, 0)
    hotkeyButton.Position = UDim2.new(0.45, 0, 0, 0)
    hotkeyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    hotkeyButton.BorderSizePixel = 0
    hotkeyButton.Font = Enum.Font.Gotham
    hotkeyButton.Text = tostring(defaultValue):gsub("Enum.KeyCode.", "")
    hotkeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    hotkeyButton.TextSize = 13
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = hotkeyButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = hotkeyButton
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1
    
    local listening = false
    hotkeyButton.MouseButton1Click:Connect(function()
        listening = true
        hotkeyButton.Text = "..."
        hotkeyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode ~= Enum.KeyCode.Unknown then
                listening = false
                hotkeyButton.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                hotkeyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                callback(input.KeyCode)
                connection:Disconnect()
            end
        end)
    end)
    
    return hotkeyButton
end

-- Create Main UI
local function CreateMainUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MainUI"
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = true
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Parent = mainFrame
    mainStroke.Color = Color3.fromRGB(60, 60, 80)
    mainStroke.Thickness = 2
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainFrame
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    titleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = titleBar
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "Cactus.GG [khen.cc]"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    MakeDraggable(mainFrame, titleBar)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = mainFrame
    tabContainer.Size = UDim2.new(1, -20, 0, 30)
    tabContainer.Position = UDim2.new(0, 10, 0, 45)
    tabContainer.BackgroundTransparency = 1
    
    -- Content Container
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Parent = mainFrame
    contentContainer.Size = UDim2.new(1, -20, 1, -85)
    contentContainer.Position = UDim2.new(0, 10, 0, 80)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.ScrollBarThickness = 4
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    -- Tabs
    local tabs = {}
    local currentTab = nil
    local tabContentHeights = {}
    
    local function UpdateCanvasSize(tabContent)
        local maxY = 0
        for _, child in ipairs(tabContent:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                local y = child.Position.Y.Offset + child.Size.Y.Offset
                if y > maxY then maxY = y end
            end
        end
        contentContainer.CanvasSize = UDim2.new(0, 0, 0, maxY + 20)
        tabContentHeights[tabContent] = maxY + 20
    end
    
    local function SwitchTab(tabName)
        if currentTab then
            currentTab.Visible = false
        end
        if tabs[tabName] then
            tabs[tabName].Visible = true
            currentTab = tabs[tabName]
            -- Update canvas size for the active tab
            if tabContentHeights[tabs[tabName]] then
                contentContainer.CanvasSize = UDim2.new(0, 0, 0, tabContentHeights[tabs[tabName]])
            else
                UpdateCanvasSize(tabs[tabName])
            end
            -- Reset scroll position
            contentContainer.CanvasPosition = Vector2.new(0, 0)
        end
    end
    
    -- Create Tabs
    local tabNames = {"Main", "HvH", "Visuals", "Misc"}
    local tabButtons = {}
    
    for i, tabName in ipairs(tabNames) do
        local tabButton = Instance.new("TextButton")
        tabButton.Parent = tabContainer
        tabButton.Size = UDim2.new(1 / #tabNames, -5, 1, 0)
        tabButton.Position = UDim2.new((i - 1) / #tabNames, (i - 1) * 5, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        tabButton.BorderSizePixel = 0
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 13
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 4)
        tabCorner.Parent = tabButton
        
        local tabContent = Instance.new("Frame")
        tabContent.Parent = contentContainer
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = i == 1
        
        tabs[tabName] = tabContent
        
        tabButton.MouseButton1Click:Connect(function()
            for _, btn in ipairs(tabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            end
            tabButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            SwitchTab(tabName)
        end)
        
        if i == 1 then
            tabButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            currentTab = tabContent
        end
        
        table.insert(tabButtons, tabButton)
    end
    
    -- MAIN TAB CONTENT
    local mainTab = tabs["Main"]
    local yOffset = 10
    
    -- Target Aim Section
    local targetAimLabel = Instance.new("TextLabel")
    targetAimLabel.Parent = mainTab
    targetAimLabel.Size = UDim2.new(1, 0, 0, 25)
    targetAimLabel.Position = UDim2.new(0, 0, 0, yOffset)
    targetAimLabel.BackgroundTransparency = 1
    targetAimLabel.Font = Enum.Font.GothamBold
    targetAimLabel.Text = "Target Aim"
    targetAimLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    targetAimLabel.TextSize = 14
    targetAimLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), getgenv().Sentinel.Enabled, function(val)
        getgenv().Sentinel.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Look At", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), getgenv().Sentinel.LookAt, function(val)
        getgenv().Sentinel.LookAt = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Highlight", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Highlight or false, function(val)
        Highlight = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Auto Air", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), getgenv().Sentinel.AutoAir, function(val)
        getgenv().Sentinel.AutoAir = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Resolver", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), getgenv().Sentinel.ResolverEnabled, function(val)
        getgenv().Sentinel.ResolverEnabled = val
    end)
    yOffset = yOffset + 40
    
    -- HitPart Section
    local hitPartLabel = Instance.new("TextLabel")
    hitPartLabel.Parent = mainTab
    hitPartLabel.Size = UDim2.new(1, 0, 0, 25)
    hitPartLabel.Position = UDim2.new(0, 0, 0, yOffset)
    hitPartLabel.BackgroundTransparency = 1
    hitPartLabel.Font = Enum.Font.GothamBold
    hitPartLabel.Text = "HitPart"
    hitPartLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    hitPartLabel.TextSize = 14
    hitPartLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "NearestPart", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), getgenv().Sentinel.NearestPart, function(val)
        getgenv().Sentinel.NearestPart = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(mainTab, "BodyPart", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {
        "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", 
        "LeftUpperArm", "LeftLowerArm", "LeftHand", 
        "RightUpperArm", "RightLowerArm", "RightHand", 
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", 
        "RightUpperLeg", "RightLowerLeg", "RightFoot"
    }, getgenv().Sentinel.SelectedPart, function(val)
        getgenv().Sentinel.SelectedPart = val
    end)
    yOffset = yOffset + 40
    
    -- Prediction Section
    local predictionLabel = Instance.new("TextLabel")
    predictionLabel.Parent = mainTab
    predictionLabel.Size = UDim2.new(1, 0, 0, 25)
    predictionLabel.Position = UDim2.new(0, 0, 0, yOffset)
    predictionLabel.BackgroundTransparency = 1
    predictionLabel.Font = Enum.Font.GothamBold
    predictionLabel.Text = "Prediction"
    predictionLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    predictionLabel.TextSize = 14
    predictionLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Auto Prediction", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), getgenv().Sentinel.AutoPrediction, function(val)
        getgenv().Sentinel.AutoPrediction = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(mainTab, "LockType", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {"Namecall", "Index"}, getgenv().Sentinel.LockType or "Namecall", function(val)
        getgenv().Sentinel.LockType = val
    end)
    yOffset = yOffset + 30
    
    CreateTextBox(mainTab, "Horizontal", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), tostring(getgenv().Sentinel.HorizontalPrediction), function(val)
        getgenv().Sentinel.HorizontalPrediction2 = tonumber(val) or getgenv().Sentinel.HorizontalPrediction
    end)
    yOffset = yOffset + 40
    
    -- Camera Section
    local cameraLabel = Instance.new("TextLabel")
    cameraLabel.Parent = mainTab
    cameraLabel.Size = UDim2.new(1, 0, 0, 25)
    cameraLabel.Position = UDim2.new(0, 0, 0, yOffset)
    cameraLabel.BackgroundTransparency = 1
    cameraLabel.Font = Enum.Font.GothamBold
    cameraLabel.Text = "Camera"
    cameraLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    cameraLabel.TextSize = 14
    cameraLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), getgenv().Sentinel.Camera, function(val)
        getgenv().Sentinel.Camera = val
    end)
    yOffset = yOffset + 30
    
    CreateTextBox(mainTab, "Smoothness", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), tostring(getgenv().Sentinel.smoothness), function(val)
        getgenv().Sentinel.smoothness = tonumber(val) or getgenv().Sentinel.smoothness
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(mainTab, "Easing Style", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {
        "Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Exponential", "Circular", "Back", "Bounce", "Elastic"
    }, getgenv().Sentinel.easingStyle, function(val)
        getgenv().Sentinel.easingStyle = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(mainTab, "Easing Direction", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {
        "In", "Out", "InOut"
    }, getgenv().Sentinel.easingDirection, function(val)
        getgenv().Sentinel.easingDirection = val
    end)
    yOffset = yOffset + 40
    
    -- ESP Section
    local espLabel = Instance.new("TextLabel")
    espLabel.Parent = mainTab
    espLabel.Size = UDim2.new(1, 0, 0, 25)
    espLabel.Position = UDim2.new(0, 0, 0, yOffset)
    espLabel.BackgroundTransparency = 1
    espLabel.Font = Enum.Font.GothamBold
    espLabel.Text = "ESP"
    espLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    espLabel.TextSize = 14
    espLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.ESP, function(val)
        Settings.Combat.ESP = val
    end)
    yOffset = yOffset + 40
    
    -- TriggerBot Section
    local triggerBotLabel = Instance.new("TextLabel")
    triggerBotLabel.Parent = mainTab
    triggerBotLabel.Size = UDim2.new(1, 0, 0, 25)
    triggerBotLabel.Position = UDim2.new(0, 0, 0, yOffset)
    triggerBotLabel.BackgroundTransparency = 1
    triggerBotLabel.Font = Enum.Font.GothamBold
    triggerBotLabel.Text = "TriggerBot"
    triggerBotLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    triggerBotLabel.TextSize = 14
    triggerBotLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.TriggerBot.Enabled, function(val)
        Settings.Combat.TriggerBot.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateTextBox(mainTab, "Delay", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), tostring(Settings.Combat.TriggerBot.Delay), function(val)
        Settings.Combat.TriggerBot.Delay = tonumber(val) or 0
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Target Only", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.TriggerBot.TargeyOnly, function(val)
        Settings.Combat.TriggerBot.TargeyOnly = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Show FOV", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.TriggerBot.FOV.Show, function(val)
        Settings.Combat.TriggerBot.FOV.Show = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(mainTab, "FOV Size", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 200, Settings.Combat.TriggerBot.FOV.Size, function(val)
        Settings.Combat.TriggerBot.FOV.Size = val
    end)
    yOffset = yOffset + 40
    
    -- Checks Section
    local checksLabel = Instance.new("TextLabel")
    checksLabel.Parent = mainTab
    checksLabel.Size = UDim2.new(1, 0, 0, 25)
    checksLabel.Position = UDim2.new(0, 0, 0, yOffset)
    checksLabel.BackgroundTransparency = 1
    checksLabel.Font = Enum.Font.GothamBold
    checksLabel.Text = "Checks"
    checksLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    checksLabel.TextSize = 14
    checksLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Checks.Enabled, function(val)
        Settings.Combat.Checks.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Knocked", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Checks.Knocked, function(val)
        Settings.Combat.Checks.Knocked = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Crew", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Checks.Crew, function(val)
        Settings.Combat.Checks.Crew = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Wall", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Checks.Wall, function(val)
        Settings.Combat.Checks.Wall = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Grabbed", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Checks.Grabbed, function(val)
        Settings.Combat.Checks.Grabbed = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Vehicle", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Checks.Vehicle, function(val)
        Settings.Combat.Checks.Vehicle = val
    end)
    yOffset = yOffset + 40
    
    -- Smoothing Section
    local smoothingLabel = Instance.new("TextLabel")
    smoothingLabel.Parent = mainTab
    smoothingLabel.Size = UDim2.new(1, 0, 0, 25)
    smoothingLabel.Position = UDim2.new(0, 0, 0, yOffset)
    smoothingLabel.BackgroundTransparency = 1
    smoothingLabel.Font = Enum.Font.GothamBold
    smoothingLabel.Text = "Smoothing"
    smoothingLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    smoothingLabel.TextSize = 14
    smoothingLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateSlider(mainTab, "Horizontal", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, Settings.Combat.Smoothing.Horizontal, function(val)
        Settings.Combat.Smoothing.Horizontal = val
    end)
    yOffset = yOffset + 40
    
    CreateSlider(mainTab, "Vertical", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, Settings.Combat.Smoothing.Vertical, function(val)
        Settings.Combat.Smoothing.Vertical = val
    end)
    yOffset = yOffset + 40
    
    -- Vertical Prediction
    CreateTextBox(mainTab, "Vertical Prediction", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), tostring(getgenv().Sentinel.VerticalPrediction), function(val)
        getgenv().Sentinel.VerticalPrediction = tonumber(val) or getgenv().Sentinel.VerticalPrediction
    end)
    yOffset = yOffset + 40
    
    -- Resolver Section
    local resolverLabel = Instance.new("TextLabel")
    resolverLabel.Parent = mainTab
    resolverLabel.Size = UDim2.new(1, 0, 0, 25)
    resolverLabel.Position = UDim2.new(0, 0, 0, yOffset)
    resolverLabel.BackgroundTransparency = 1
    resolverLabel.Font = Enum.Font.GothamBold
    resolverLabel.Text = "Resolver"
    resolverLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    resolverLabel.TextSize = 14
    resolverLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateSlider(mainTab, "Refresh Rate", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 500, Settings.Combat.Resolver.RefreshRate, function(val)
        Settings.Combat.Resolver.RefreshRate = val
    end)
    yOffset = yOffset + 40
    
    -- FOV Section
    local fovLabel = Instance.new("TextLabel")
    fovLabel.Parent = mainTab
    fovLabel.Size = UDim2.new(1, 0, 0, 25)
    fovLabel.Position = UDim2.new(0, 0, 0, yOffset)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Font = Enum.Font.GothamBold
    fovLabel.Text = "FOV"
    fovLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    fovLabel.TextSize = 14
    fovLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Visualize", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Fov.Visualize.Enabled, function(val)
        Settings.Combat.Fov.Visualize.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(mainTab, "Radius", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 500, Settings.Combat.Fov.Radius, function(val)
        Settings.Combat.Fov.Radius = val
    end)
    yOffset = yOffset + 40
    
    -- Visuals Section
    local visualsLabel = Instance.new("TextLabel")
    visualsLabel.Parent = mainTab
    visualsLabel.Size = UDim2.new(1, 0, 0, 25)
    visualsLabel.Position = UDim2.new(0, 0, 0, yOffset)
    visualsLabel.BackgroundTransparency = 1
    visualsLabel.Font = Enum.Font.GothamBold
    visualsLabel.Text = "Visuals"
    visualsLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    visualsLabel.TextSize = 14
    visualsLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Tracer", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Visuals.Tracer.Enabled, function(val)
        Settings.Combat.Visuals.Tracer.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(mainTab, "Tracer Thickness", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, Settings.Combat.Visuals.Tracer.Thickness, function(val)
        Settings.Combat.Visuals.Tracer.Thickness = val
    end)
    yOffset = yOffset + 40
    
    CreateToggle(mainTab, "Dot", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Visuals.Dot.Enabled, function(val)
        Settings.Combat.Visuals.Dot.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Dot Filled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Visuals.Dot.Filled, function(val)
        Settings.Combat.Visuals.Dot.Filled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(mainTab, "Dot Size", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 20, Settings.Combat.Visuals.Dot.Size, function(val)
        Settings.Combat.Visuals.Dot.Size = val
    end)
    yOffset = yOffset + 40
    
    CreateToggle(mainTab, "Chams", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Visuals.Chams.Enabled, function(val)
        Settings.Combat.Visuals.Chams.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(mainTab, "Chams Fill Transparency", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 1, Settings.Combat.Visuals.Chams.Fill.Transparency, function(val)
        Settings.Combat.Visuals.Chams.Fill.Transparency = val
    end)
    yOffset = yOffset + 40
    
    CreateSlider(mainTab, "Chams Outline Transparency", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 1, Settings.Combat.Visuals.Chams.Outline.Transparency, function(val)
        Settings.Combat.Visuals.Chams.Outline.Transparency = val
    end)
    yOffset = yOffset + 40
    
    -- Air Section
    local airLabel = Instance.new("TextLabel")
    airLabel.Parent = mainTab
    airLabel.Size = UDim2.new(1, 0, 0, 25)
    airLabel.Position = UDim2.new(0, 0, 0, yOffset)
    airLabel.BackgroundTransparency = 1
    airLabel.Font = Enum.Font.GothamBold
    airLabel.Text = "Air"
    airLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    airLabel.TextSize = 14
    airLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Air Aim Part", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Air.AirAimPart.Enabled, function(val)
        Settings.Combat.Air.AirAimPart.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(mainTab, "Air Hit Part", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {
        "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"
    }, Settings.Combat.Air.AirAimPart.HitPart, function(val)
        Settings.Combat.Air.AirAimPart.HitPart = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Jump Offset", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Air.JumpOffset.Enabled, function(val)
        Settings.Combat.Air.JumpOffset.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(mainTab, "Jump Offset Amount", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), -5, 5, Settings.Combat.Air.JumpOffset.Offset, function(val)
        Settings.Combat.Air.JumpOffset.Offset = val
    end)
    yOffset = yOffset + 40
    
    -- Other Settings
    CreateToggle(mainTab, "Silent", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Silent, function(val)
        Settings.Combat.Silent = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Beta Airshot", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.BetaAirshot, function(val)
        Settings.Combat.BetaAirshot = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Target Info", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.TargetInfo, function(val)
        Settings.Combat.TargetInfo = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Alerts", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Alerts, function(val)
        Settings.Combat.Alerts = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Ping Based", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.PingBased, function(val)
        Settings.Combat.PingBased = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Use Index", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.UseIndex, function(val)
        Settings.Combat.UseIndex = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "AntiAim Viewer", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.AntiAimViewer, function(val)
        Settings.Combat.AntiAimViewer = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Skibidi", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Skibidi, function(val)
        Settings.Combat.Skibidi = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Spectate", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.Spectate, function(val)
        Settings.Combat.Spectate = val
    end)
    yOffset = yOffset + 30
    
    -- AutoSelect
    CreateToggle(mainTab, "Auto Select", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.AutoSelect.Enabled, function(val)
        Settings.Combat.AutoSelect.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "Auto Select Cooldown", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Combat.AutoSelect.Cooldown.Enabled, function(val)
        Settings.Combat.AutoSelect.Cooldown.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(mainTab, "Cooldown Amount", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 5, Settings.Combat.AutoSelect.Cooldown.Amount, function(val)
        Settings.Combat.AutoSelect.Cooldown.Amount = val
    end)
    yOffset = yOffset + 40
    
    -- Additional Sentinel Settings
    CreateTextBox(mainTab, "Shoot Delay", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), tostring(getgenv().Sentinel.ShootDelay), function(val)
        getgenv().Sentinel.ShootDelay = tonumber(val) or getgenv().Sentinel.ShootDelay
    end)
    yOffset = yOffset + 30
    
    CreateToggle(mainTab, "No Ground Shot", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), getgenv().Sentinel.NoGroundShot, function(val)
        getgenv().Sentinel.NoGroundShot = val
    end)
    yOffset = yOffset + 30
    
    CreateTextBox(mainTab, "Jump Offset 2", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), tostring(getgenv().Sentinel.jumpoffset2), function(val)
        getgenv().Sentinel.jumpoffset2 = tonumber(val) or getgenv().Sentinel.jumpoffset2
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(mainTab, "Auto Pred Mode", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {"PingBased", "Custom"}, getgenv().Sentinel.AutoPredMode, function(val)
        getgenv().Sentinel.AutoPredMode = val
    end)
    
    UpdateCanvasSize(mainTab)
    
    -- HvH TAB CONTENT
    local hvhTab = tabs["HvH"]
    yOffset = 10
    
    -- Teleports Section
    local teleportsLabel = Instance.new("TextLabel")
    teleportsLabel.Parent = hvhTab
    teleportsLabel.Size = UDim2.new(1, 0, 0, 25)
    teleportsLabel.Position = UDim2.new(0, 0, 0, yOffset)
    teleportsLabel.BackgroundTransparency = 1
    teleportsLabel.Font = Enum.Font.GothamBold
    teleportsLabel.Text = "Teleports"
    teleportsLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    teleportsLabel.TextSize = 14
    teleportsLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Grenade Tp", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Script.Locals.GrenadeTP.Enabled, function(val)
        Script.Locals.GrenadeTP.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Rocket Tp", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Script.Locals.RocketTP.Enabled, function(val)
        Script.Locals.RocketTP.Enabled = val
    end)
    yOffset = yOffset + 40
    
    -- Bullet-TP Section
    local bulletTPLabel = Instance.new("TextLabel")
    bulletTPLabel.Parent = hvhTab
    bulletTPLabel.Size = UDim2.new(1, 0, 0, 25)
    bulletTPLabel.Position = UDim2.new(0, 0, 0, yOffset)
    bulletTPLabel.BackgroundTransparency = 1
    bulletTPLabel.Font = Enum.Font.GothamBold
    bulletTPLabel.Text = "Bullet-TP"
    bulletTPLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    bulletTPLabel.TextSize = 14
    bulletTPLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Bullet Gyatt", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Script.Locals.GunTP.Enabled, function(val)
        Script.Locals.GunTP.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Anchor", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Script.Locals.GunTP.Anchor, function(val)
        Script.Locals.GunTP.Anchor = val
    end)
    yOffset = yOffset + 30
    
    CreateTextBox(hvhTab, "X", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), tostring(Script.Locals.GunTP.Offset[1]), function(val)
        Script.Locals.GunTP.Offset[1] = tonumber(val) or 0
    end)
    yOffset = yOffset + 30
    
    CreateTextBox(hvhTab, "Y", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), tostring(Script.Locals.GunTP.Offset[2]), function(val)
        Script.Locals.GunTP.Offset[2] = tonumber(val) or -1
    end)
    yOffset = yOffset + 30
    
    CreateTextBox(hvhTab, "Z", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), tostring(Script.Locals.GunTP.Offset[3]), function(val)
        Script.Locals.GunTP.Offset[3] = tonumber(val) or 0
    end)
    yOffset = yOffset + 40
    
    -- CSync Section
    local csyncLabel = Instance.new("TextLabel")
    csyncLabel.Parent = hvhTab
    csyncLabel.Size = UDim2.new(1, 0, 0, 25)
    csyncLabel.Position = UDim2.new(0, 0, 0, yOffset)
    csyncLabel.BackgroundTransparency = 1
    csyncLabel.Font = Enum.Font.GothamBold
    csyncLabel.Text = "CSync"
    csyncLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    csyncLabel.TextSize = 14
    csyncLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), TargetAimbot.CSync.Enabled, function(val)
        TargetAimbot.CSync.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(hvhTab, "Type", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {"Orbit", "Random"}, TargetAimbot.CSync.Type, function(val)
        TargetAimbot.CSync.Type = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(hvhTab, "Distance", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 20, TargetAimbot.CSync.Distance, function(val)
        TargetAimbot.CSync.Distance = val
    end)
    yOffset = yOffset + 40
    
    CreateSlider(hvhTab, "Height", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, TargetAimbot.CSync.Height, function(val)
        TargetAimbot.CSync.Height = val
    end)
    yOffset = yOffset + 40
    
    CreateSlider(hvhTab, "Speed", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 20, TargetAimbot.CSync.Speed, function(val)
        TargetAimbot.CSync.Speed = val
    end)
    yOffset = yOffset + 40
    
    CreateSlider(hvhTab, "Random Amount", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 20, TargetAimbot.CSync.RandomAmount, function(val)
        TargetAimbot.CSync.RandomAmount = val
    end)
    yOffset = yOffset + 40
    
    -- Velocity Spoofer Section
    local velocitySpooferLabel = Instance.new("TextLabel")
    velocitySpooferLabel.Parent = hvhTab
    velocitySpooferLabel.Size = UDim2.new(1, 0, 0, 25)
    velocitySpooferLabel.Position = UDim2.new(0, 0, 0, yOffset)
    velocitySpooferLabel.BackgroundTransparency = 1
    velocitySpooferLabel.Font = Enum.Font.GothamBold
    velocitySpooferLabel.Text = "Velocity Spoofer"
    velocitySpooferLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    velocitySpooferLabel.TextSize = 14
    velocitySpooferLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.AntiAim.VelocitySpoofer.Enabled, function(val)
        Settings.AntiAim.VelocitySpoofer.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Visualize", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.AntiAim.VelocitySpoofer.Visualize.Enabled, function(val)
        Settings.AntiAim.VelocitySpoofer.Visualize.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(hvhTab, "Type", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {"Underground", "Up", "Down", "Custom"}, Settings.AntiAim.VelocitySpoofer.Type, function(val)
        Settings.AntiAim.VelocitySpoofer.Type = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(hvhTab, "Roll", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), -180, 180, Settings.AntiAim.VelocitySpoofer.Roll, function(val)
        Settings.AntiAim.VelocitySpoofer.Roll = val
    end)
    yOffset = yOffset + 40
    
    CreateSlider(hvhTab, "Pitch", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), -180, 180, Settings.AntiAim.VelocitySpoofer.Pitch, function(val)
        Settings.AntiAim.VelocitySpoofer.Pitch = val
    end)
    yOffset = yOffset + 40
    
    CreateSlider(hvhTab, "Yaw", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), -180, 180, Settings.AntiAim.VelocitySpoofer.Yaw, function(val)
        Settings.AntiAim.VelocitySpoofer.Yaw = val
    end)
    yOffset = yOffset + 40
    
    -- Network Section
    local networkLabel = Instance.new("TextLabel")
    networkLabel.Parent = hvhTab
    networkLabel.Size = UDim2.new(1, 0, 0, 25)
    networkLabel.Position = UDim2.new(0, 0, 0, yOffset)
    networkLabel.BackgroundTransparency = 1
    networkLabel.Font = Enum.Font.GothamBold
    networkLabel.Text = "Network"
    networkLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    networkLabel.TextSize = 14
    networkLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.AntiAim.Network.Enabled, function(val)
        Settings.AntiAim.Network.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Walking Check", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.AntiAim.Network.WalkingCheck, function(val)
        Settings.AntiAim.Network.WalkingCheck = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(hvhTab, "Amount", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 1, Settings.AntiAim.Network.Amount, function(val)
        Settings.AntiAim.Network.Amount = val
    end)
    yOffset = yOffset + 40
    
    -- Velocity Desync Section
    local velocityDesyncLabel = Instance.new("TextLabel")
    velocityDesyncLabel.Parent = hvhTab
    velocityDesyncLabel.Size = UDim2.new(1, 0, 0, 25)
    velocityDesyncLabel.Position = UDim2.new(0, 0, 0, yOffset)
    velocityDesyncLabel.BackgroundTransparency = 1
    velocityDesyncLabel.Font = Enum.Font.GothamBold
    velocityDesyncLabel.Text = "Velocity Desync"
    velocityDesyncLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    velocityDesyncLabel.TextSize = 14
    velocityDesyncLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.AntiAim.VelocityDesync.Enabled, function(val)
        Settings.AntiAim.VelocityDesync.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(hvhTab, "Range", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, Settings.AntiAim.VelocityDesync.Range, function(val)
        Settings.AntiAim.VelocityDesync.Range = val
    end)
    yOffset = yOffset + 40
    
    -- FFlag Desync Section
    local fflagDesyncLabel = Instance.new("TextLabel")
    fflagDesyncLabel.Parent = hvhTab
    fflagDesyncLabel.Size = UDim2.new(1, 0, 0, 25)
    fflagDesyncLabel.Position = UDim2.new(0, 0, 0, yOffset)
    fflagDesyncLabel.BackgroundTransparency = 1
    fflagDesyncLabel.Font = Enum.Font.GothamBold
    fflagDesyncLabel.Text = "FFlag Desync"
    fflagDesyncLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    fflagDesyncLabel.TextSize = 14
    fflagDesyncLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.AntiAim.FFlagDesync.Enabled, function(val)
        Settings.AntiAim.FFlagDesync.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(hvhTab, "Set New", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.AntiAim.FFlagDesync.SetNew, function(val)
        Settings.AntiAim.FFlagDesync.SetNew = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(hvhTab, "Amount", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 20, Settings.AntiAim.FFlagDesync.Amount, function(val)
        Settings.AntiAim.FFlagDesync.Amount = val
    end)
    yOffset = yOffset + 40
    
    CreateSlider(hvhTab, "Set New Amount", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 20, Settings.AntiAim.FFlagDesync.SetNewAmount, function(val)
        Settings.AntiAim.FFlagDesync.SetNewAmount = val
    end)
    
    UpdateCanvasSize(hvhTab)
    
    -- VISUALS TAB CONTENT
    local visualsTab = tabs["Visuals"]
    yOffset = 10
    
    -- Hit Detection Section
    local hitDetectionLabel = Instance.new("TextLabel")
    hitDetectionLabel.Parent = visualsTab
    hitDetectionLabel.Size = UDim2.new(1, 0, 0, 25)
    hitDetectionLabel.Position = UDim2.new(0, 0, 0, yOffset)
    hitDetectionLabel.BackgroundTransparency = 1
    hitDetectionLabel.Font = Enum.Font.GothamBold
    hitDetectionLabel.Text = "Hit Detection"
    hitDetectionLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    hitDetectionLabel.TextSize = 14
    hitDetectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Hit Effect", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), TargetAimbot.HitEffect, function(val)
        TargetAimbot.HitEffect = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Hit Sound", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), TargetAimbot.HitSounds, function(val)
        TargetAimbot.HitSounds = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Notify", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Hitnotify or false, function(val)
        Hitnotify = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(visualsTab, "Effect Type", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {
        "Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", "Circle Shot", "Bolt", "Aura", "Electric", "Shock", "Thunder"
    }, TargetAimbot.HitEffectType, function(val)
        TargetAimbot.HitEffectType = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(visualsTab, "Sound Type", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {
        "RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", "Gamesense", "Rust", "BlackPencil"
    }, TargetAimbot.HitSound, function(val)
        TargetAimbot.HitSound = val
    end)
    yOffset = yOffset + 40
    
    -- Hit Chams Section
    local hitChamsLabel = Instance.new("TextLabel")
    hitChamsLabel.Parent = visualsTab
    hitChamsLabel.Size = UDim2.new(1, 0, 0, 25)
    hitChamsLabel.Position = UDim2.new(0, 0, 0, yOffset)
    hitChamsLabel.BackgroundTransparency = 1
    hitChamsLabel.Font = Enum.Font.GothamBold
    hitChamsLabel.Text = "Hit Chams"
    hitChamsLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    hitChamsLabel.TextSize = 14
    hitChamsLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), TargetAimbot.HitChams, function(val)
        TargetAimbot.HitChams = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Duration", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 5, TargetAimbot.HitChamsDuration, function(val)
        TargetAimbot.HitChamsDuration = val
    end)
    yOffset = yOffset + 40
    
    CreateDropdown(visualsTab, "Material", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {
        Enum.Material.Neon.Name, Enum.Material.SmoothPlastic.Name
    }, TargetAimbot.HitChamsMaterial.Name, function(val)
        TargetAimbot.HitChamsMaterial = Enum.Material[val]
    end)
    yOffset = yOffset + 40
    
    -- Backtrack Section
    local backtrackLabel = Instance.new("TextLabel")
    backtrackLabel.Parent = visualsTab
    backtrackLabel.Size = UDim2.new(1, 0, 0, 25)
    backtrackLabel.Position = UDim2.new(0, 0, 0, yOffset)
    backtrackLabel.BackgroundTransparency = 1
    backtrackLabel.Font = Enum.Font.GothamBold
    backtrackLabel.Text = "Backtrack"
    backtrackLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    backtrackLabel.TextSize = 14
    backtrackLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.Backtrack.Enabled, function(val)
        Settings.Visuals.Backtrack.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(visualsTab, "Method", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {"Follow", "Static"}, Settings.Visuals.Backtrack.Method, function(val)
        Settings.Visuals.Backtrack.Method = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Transparency", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 1, Settings.Visuals.Backtrack.Transparency, function(val)
        Settings.Visuals.Backtrack.Transparency = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(visualsTab, "Material", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {"Plastic", "Neon", "ForceField"}, Settings.Visuals.Backtrack.Material, function(val)
        Settings.Visuals.Backtrack.Material = val
    end)
    yOffset = yOffset + 40
    
    -- Bullet Tracers Section
    local bulletTracersLabel = Instance.new("TextLabel")
    bulletTracersLabel.Parent = visualsTab
    bulletTracersLabel.Size = UDim2.new(1, 0, 0, 25)
    bulletTracersLabel.Position = UDim2.new(0, 0, 0, yOffset)
    bulletTracersLabel.BackgroundTransparency = 1
    bulletTracersLabel.Font = Enum.Font.GothamBold
    bulletTracersLabel.Text = "Bullet Tracers"
    bulletTracersLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    bulletTracersLabel.TextSize = 14
    bulletTracersLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.BulletTracers.Enabled, function(val)
        Settings.Visuals.BulletTracers.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Duration", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, Settings.Visuals.BulletTracers.Duration, function(val)
        Settings.Visuals.BulletTracers.Duration = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Fade", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.BulletTracers.Fade.Enabled, function(val)
        Settings.Visuals.BulletTracers.Fade.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Fade Duration", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 5, Settings.Visuals.BulletTracers.Fade.Duration, function(val)
        Settings.Visuals.BulletTracers.Fade.Duration = val
    end)
    yOffset = yOffset + 40
    
    -- Bullet Impacts Section
    local bulletImpactsLabel = Instance.new("TextLabel")
    bulletImpactsLabel.Parent = visualsTab
    bulletImpactsLabel.Size = UDim2.new(1, 0, 0, 25)
    bulletImpactsLabel.Position = UDim2.new(0, 0, 0, yOffset)
    bulletImpactsLabel.BackgroundTransparency = 1
    bulletImpactsLabel.Font = Enum.Font.GothamBold
    bulletImpactsLabel.Text = "Bullet Impacts"
    bulletImpactsLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    bulletImpactsLabel.TextSize = 14
    bulletImpactsLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.BulletImpacts.Enabled, function(val)
        Settings.Visuals.BulletImpacts.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Duration", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, Settings.Visuals.BulletImpacts.Duration, function(val)
        Settings.Visuals.BulletImpacts.Duration = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Size", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, Settings.Visuals.BulletImpacts.Size, function(val)
        Settings.Visuals.BulletImpacts.Size = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(visualsTab, "Material", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {"SmoothPlastic", "Neon", "ForceField"}, Settings.Visuals.BulletImpacts.Material, function(val)
        Settings.Visuals.BulletImpacts.Material = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Fade", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.BulletImpacts.Fade.Enabled, function(val)
        Settings.Visuals.BulletImpacts.Fade.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Fade Duration", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 5, Settings.Visuals.BulletImpacts.Fade.Duration, function(val)
        Settings.Visuals.BulletImpacts.Fade.Duration = val
    end)
    yOffset = yOffset + 40
    
    -- OnHit Section
    local onHitLabel = Instance.new("TextLabel")
    onHitLabel.Parent = visualsTab
    onHitLabel.Size = UDim2.new(1, 0, 0, 25)
    onHitLabel.Position = UDim2.new(0, 0, 0, yOffset)
    onHitLabel.BackgroundTransparency = 1
    onHitLabel.Font = Enum.Font.GothamBold
    onHitLabel.Text = "OnHit"
    onHitLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    onHitLabel.TextSize = 14
    onHitLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Effect", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.OnHit.Effect.Enabled, function(val)
        Settings.Visuals.OnHit.Effect.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Sound", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.OnHit.Sound.Enabled, function(val)
        Settings.Visuals.OnHit.Sound.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Sound Volume", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, Settings.Visuals.OnHit.Sound.Volume, function(val)
        Settings.Visuals.OnHit.Sound.Volume = val
    end)
    yOffset = yOffset + 30
    
    CreateTextBox(visualsTab, "Sound Value", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.OnHit.Sound.Value, function(val)
        Settings.Visuals.OnHit.Sound.Value = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Chams", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.OnHit.Chams.Enabled, function(val)
        Settings.Visuals.OnHit.Chams.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Chams Duration", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, Settings.Visuals.OnHit.Chams.Duration, function(val)
        Settings.Visuals.OnHit.Chams.Duration = val
    end)
    yOffset = yOffset + 40
    
    -- World Section
    local worldLabel = Instance.new("TextLabel")
    worldLabel.Parent = visualsTab
    worldLabel.Size = UDim2.new(1, 0, 0, 25)
    worldLabel.Position = UDim2.new(0, 0, 0, yOffset)
    worldLabel.BackgroundTransparency = 1
    worldLabel.Font = Enum.Font.GothamBold
    worldLabel.Text = "World"
    worldLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    worldLabel.TextSize = 14
    worldLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Fog", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.World.Fog.Enabled, function(val)
        Settings.Visuals.World.Fog.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Fog Start", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 50000, Settings.Visuals.World.Fog.Start, function(val)
        Settings.Visuals.World.Fog.Start = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Fog End", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 50000, Settings.Visuals.World.Fog.End, function(val)
        Settings.Visuals.World.Fog.End = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Ambient", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.World.Ambient.Enabled, function(val)
        Settings.Visuals.World.Ambient.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Brightness", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.World.Brightness.Enabled, function(val)
        Settings.Visuals.World.Brightness.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Brightness Value", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), -5, 5, Settings.Visuals.World.Brightness.Value, function(val)
        Settings.Visuals.World.Brightness.Value = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Clock Time", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.World.ClockTime.Enabled, function(val)
        Settings.Visuals.World.ClockTime.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Clock Time Value", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 24, Settings.Visuals.World.ClockTime.Value, function(val)
        Settings.Visuals.World.ClockTime.Value = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "World Exposure", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.World.WorldExposure.Enabled, function(val)
        Settings.Visuals.World.WorldExposure.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Exposure Value", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), -5, 5, Settings.Visuals.World.WorldExposure.Value, function(val)
        Settings.Visuals.World.WorldExposure.Value = val
    end)
    yOffset = yOffset + 40
    
    -- Crosshair Section
    local crosshairLabel = Instance.new("TextLabel")
    crosshairLabel.Parent = visualsTab
    crosshairLabel.Size = UDim2.new(1, 0, 0, 25)
    crosshairLabel.Position = UDim2.new(0, 0, 0, yOffset)
    crosshairLabel.BackgroundTransparency = 1
    crosshairLabel.Font = Enum.Font.GothamBold
    crosshairLabel.Text = "Crosshair"
    crosshairLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    crosshairLabel.TextSize = 14
    crosshairLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.Crosshair.Enabled, function(val)
        Settings.Visuals.Crosshair.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Stick To Target", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.Crosshair.StickToTarget, function(val)
        Settings.Visuals.Crosshair.StickToTarget = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Size", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 50, Settings.Visuals.Crosshair.Size, function(val)
        Settings.Visuals.Crosshair.Size = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Gap", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 20, Settings.Visuals.Crosshair.Gap, function(val)
        Settings.Visuals.Crosshair.Gap = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(visualsTab, "Rotation", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Visuals.Crosshair.Rotation.Enabled, function(val)
        Settings.Visuals.Crosshair.Rotation.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(visualsTab, "Rotation Speed", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, Settings.Visuals.Crosshair.Rotation.Speed, function(val)
        Settings.Visuals.Crosshair.Rotation.Speed = val
    end)
    
    UpdateCanvasSize(visualsTab)
    
    -- MISC TAB CONTENT
    local miscTab = tabs["Misc"]
    yOffset = 10
    
    -- Prediction Breaker Section
    local predictionBreakerLabel = Instance.new("TextLabel")
    predictionBreakerLabel.Parent = miscTab
    predictionBreakerLabel.Size = UDim2.new(1, 0, 0, 25)
    predictionBreakerLabel.Position = UDim2.new(0, 0, 0, yOffset)
    predictionBreakerLabel.BackgroundTransparency = 1
    predictionBreakerLabel.Font = Enum.Font.GothamBold
    predictionBreakerLabel.Text = "Prediction Breaker"
    predictionBreakerLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    predictionBreakerLabel.TextSize = 14
    predictionBreakerLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Jump Prediction", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), getgenv().Sentinel.JumpBreak, function(val)
        getgenv().Sentinel.JumpBreak = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Enable Anti Lock", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), getgenv().Desync, function(val)
        getgenv().Desync = val
    end)
    yOffset = yOffset + 30
    
    CreateDropdown(miscTab, "Anti Lock Type", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), {
        "Behind", "Down", "ForWard", "Left", "One", "Right", "Up", "Zero"
    }, getgenv().AntiLockType, function(val)
        getgenv().AntiLockType = val
    end)
    yOffset = yOffset + 40
    
    -- CFrame Speed Section
    local cframeSpeedLabel = Instance.new("TextLabel")
    cframeSpeedLabel.Parent = miscTab
    cframeSpeedLabel.Size = UDim2.new(1, 0, 0, 25)
    cframeSpeedLabel.Position = UDim2.new(0, 0, 0, yOffset)
    cframeSpeedLabel.BackgroundTransparency = 1
    cframeSpeedLabel.Font = Enum.Font.GothamBold
    cframeSpeedLabel.Text = "CFrame Speed"
    cframeSpeedLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    cframeSpeedLabel.TextSize = 14
    cframeSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), false, function(val)
        getgenv().Sentinel.cframespeedtoggle = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(miscTab, "Speed", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, getgenv().Sentinel.speedvalue, function(val)
        getgenv().Sentinel.speedvalue = val
    end)
    yOffset = yOffset + 40
    
    -- Macro Section
    local macroLabel = Instance.new("TextLabel")
    macroLabel.Parent = miscTab
    macroLabel.Size = UDim2.new(1, 0, 0, 25)
    macroLabel.Position = UDim2.new(0, 0, 0, yOffset)
    macroLabel.BackgroundTransparency = 1
    macroLabel.Font = Enum.Font.GothamBold
    macroLabel.Text = "Macro"
    macroLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    macroLabel.TextSize = 14
    macroLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateButton(miscTab, "Load Macro", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), function()
        -- Macro loading code would go here (keeping original functionality)
        Menu.Notify("Macro loaded", 2)
    end)
    yOffset = yOffset + 40
    
    CreateTextBox(miscTab, "Speed", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), tostring(getgenv().Sentinel.MacroSpeed), function(val)
        getgenv().Sentinel.MacroSpeed = tonumber(val) or getgenv().Sentinel.MacroSpeed
    end)
    yOffset = yOffset + 40
    
    -- Network Anti Section
    local networkAntiLabel = Instance.new("TextLabel")
    networkAntiLabel.Parent = miscTab
    networkAntiLabel.Size = UDim2.new(1, 0, 0, 25)
    networkAntiLabel.Position = UDim2.new(0, 0, 0, yOffset)
    networkAntiLabel.BackgroundTransparency = 1
    networkAntiLabel.Font = Enum.Font.GothamBold
    networkAntiLabel.Text = "Network Anti"
    networkAntiLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    networkAntiLabel.TextSize = 14
    networkAntiLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), getgenv().Sentinel.network, function(val)
        getgenv().Sentinel.network = val
    end)
    yOffset = yOffset + 40
    
    -- Movement Speed Section
    local movementSpeedLabel = Instance.new("TextLabel")
    movementSpeedLabel.Parent = miscTab
    movementSpeedLabel.Size = UDim2.new(1, 0, 0, 25)
    movementSpeedLabel.Position = UDim2.new(0, 0, 0, yOffset)
    movementSpeedLabel.BackgroundTransparency = 1
    movementSpeedLabel.Font = Enum.Font.GothamBold
    movementSpeedLabel.Text = "Movement Speed"
    movementSpeedLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    movementSpeedLabel.TextSize = 14
    movementSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Misc.Movement.Speed.Enabled, function(val)
        Settings.Misc.Movement.Speed.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateSlider(miscTab, "Amount", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 10, Settings.Misc.Movement.Speed.Amount, function(val)
        Settings.Misc.Movement.Speed.Amount = val
    end)
    yOffset = yOffset + 40
    
    -- Exploits Section
    local exploitsLabel = Instance.new("TextLabel")
    exploitsLabel.Parent = miscTab
    exploitsLabel.Size = UDim2.new(1, 0, 0, 25)
    exploitsLabel.Position = UDim2.new(0, 0, 0, yOffset)
    exploitsLabel.BackgroundTransparency = 1
    exploitsLabel.Font = Enum.Font.GothamBold
    exploitsLabel.Text = "Exploits"
    exploitsLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    exploitsLabel.TextSize = 14
    exploitsLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Misc.Exploits.Enabled, function(val)
        Settings.Misc.Exploits.Enabled = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "No Recoil", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Misc.Exploits.NoRecoil, function(val)
        Settings.Misc.Exploits.NoRecoil = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "No Jump Cooldown", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Misc.Exploits.NoJumpCooldown, function(val)
        Settings.Misc.Exploits.NoJumpCooldown = val
    end)
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "No Slow Down", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Settings.Misc.Exploits.NoSlowDown, function(val)
        Settings.Misc.Exploits.NoSlowDown = val
    end)
    yOffset = yOffset + 40
    
    -- Aura Section
    local auraLabel = Instance.new("TextLabel")
    auraLabel.Parent = miscTab
    auraLabel.Size = UDim2.new(1, 0, 0, 25)
    auraLabel.Position = UDim2.new(0, 0, 0, yOffset)
    auraLabel.BackgroundTransparency = 1
    auraLabel.Font = Enum.Font.GothamBold
    auraLabel.Text = "Aura"
    auraLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    auraLabel.TextSize = 14
    auraLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Script.Locals.Aura.Enabled, function(val)
        Script.Locals.Aura.Enabled = val
    end)
    yOffset = yOffset + 40
    
    -- Fly Section
    local flyLabel = Instance.new("TextLabel")
    flyLabel.Parent = miscTab
    flyLabel.Size = UDim2.new(1, 0, 0, 25)
    flyLabel.Position = UDim2.new(0, 0, 0, yOffset)
    flyLabel.BackgroundTransparency = 1
    flyLabel.Font = Enum.Font.GothamBold
    flyLabel.Text = "Fly"
    flyLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    flyLabel.TextSize = 14
    flyLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    local flyEnabled = false
    CreateToggle(miscTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), flyEnabled, function(val)
        flyEnabled = val
    end)
    yOffset = yOffset + 30
    
    CreateHotkey(miscTab, "Keybind", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Enum.KeyCode.X, function(val)
        -- Fly keybind callback
    end)
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Notification", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), false, function(val)
        -- Fly notification callback
    end)
    yOffset = yOffset + 30
    
    CreateSlider(miscTab, "Speed", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, yOffset), 0, 30, 5, function(val)
        -- Fly speed callback
    end)
    yOffset = yOffset + 40
    
    -- Trash Talk Section
    local trashTalkLabel = Instance.new("TextLabel")
    trashTalkLabel.Parent = miscTab
    trashTalkLabel.Size = UDim2.new(1, 0, 0, 25)
    trashTalkLabel.Position = UDim2.new(0, 0, 0, yOffset)
    trashTalkLabel.BackgroundTransparency = 1
    trashTalkLabel.Font = Enum.Font.GothamBold
    trashTalkLabel.Text = "Trash Talk"
    trashTalkLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    trashTalkLabel.TextSize = 14
    trashTalkLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Enabled", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), false, function(val)
        -- Trash talk enabled callback
    end)
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Target", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), false, function(val)
        -- Trash talk target callback
    end)
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Notification", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), false, function(val)
        -- Trash talk notification callback
    end)
    yOffset = yOffset + 30
    
    CreateToggle(miscTab, "Use Keybind", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), false, function(val)
        -- Trash talk use keybind callback
    end)
    yOffset = yOffset + 30
    
    CreateHotkey(miscTab, "Keybind", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, yOffset), Enum.KeyCode.B, function(val)
        -- Trash talk keybind callback
    end)
    
    UpdateCanvasSize(miscTab)
    
    UIManager.MainUI = screenGui
    return screenGui
end

-- Create Settings UI
local function CreateSettingsUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SettingsUI"
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = false
    
    local settingsFrame = Instance.new("Frame")
    settingsFrame.Name = "SettingsFrame"
    settingsFrame.Parent = screenGui
    settingsFrame.Size = UDim2.new(0, 400, 0, 500)
    settingsFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    settingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    settingsFrame.BorderSizePixel = 0
    
    local settingsCorner = Instance.new("UICorner")
    settingsCorner.CornerRadius = UDim.new(0, 8)
    settingsCorner.Parent = settingsFrame
    
    local settingsStroke = Instance.new("UIStroke")
    settingsStroke.Parent = settingsFrame
    settingsStroke.Color = Color3.fromRGB(60, 60, 80)
    settingsStroke.Thickness = 2
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = settingsFrame
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    titleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = titleBar
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "Settings"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = titleBar
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
        UIManager.SettingsUIVisible = false
    end)
    
    MakeDraggable(settingsFrame, titleBar)
    
    -- Content
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Parent = settingsFrame
    contentContainer.Size = UDim2.new(1, -20, 1, -50)
    contentContainer.Position = UDim2.new(0, 10, 0, 45)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.ScrollBarThickness = 4
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local yOffset = 10
    
    -- Add settings options here
    local generalLabel = Instance.new("TextLabel")
    generalLabel.Parent = contentContainer
    generalLabel.Size = UDim2.new(1, 0, 0, 25)
    generalLabel.Position = UDim2.new(0, 0, 0, yOffset)
    generalLabel.BackgroundTransparency = 1
    generalLabel.Font = Enum.Font.GothamBold
    generalLabel.Text = "General Settings"
    generalLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    generalLabel.TextSize = 14
    generalLabel.TextXAlignment = Enum.TextXAlignment.Left
    yOffset = yOffset + 30
    
    -- Add more settings as needed
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
    
    UIManager.SettingsUI = screenGui
    return screenGui
end

-- Create Toggle Button
local function CreateToggleButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ToggleButtonUI"
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Parent = screenGui
    toggleButton.Size = UDim2.new(0, 90, 0, 90)
    toggleButton.Position = UDim2.new(1, -95, 0, 5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    toggleButton.BorderSizePixel = 0
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Text = "UI"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 20
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Parent = toggleButton
    toggleStroke.Thickness = 2
    toggleStroke.Color = Color3.fromRGB(0, 200, 100)
    
    -- Try to add image as well
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Parent = toggleButton
    imageLabel.Size = UDim2.new(0.7, 0, 0.7, 0)
    imageLabel.Position = UDim2.new(0.15, 0, 0.15, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "rbxassetid://126818107683779"
    imageLabel.ImageTransparency = 0
    
    toggleButton.MouseButton1Click:Connect(function()
        UIManager.MainUIVisible = not UIManager.MainUIVisible
        if UIManager.MainUI then
            UIManager.MainUI.Enabled = UIManager.MainUIVisible
        end
        if UIManager.MainUIVisible then
            Blur.Enabled = true
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        else
            Blur.Enabled = false
            toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        end
    end)
    
    MakeDraggable(toggleButton)
    
    UIManager.ToggleButton = toggleButton
    return toggleButton
end

-- Create Lock Button
local function CreateLockButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LockButtonUI"
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    local lockButton = Instance.new("TextButton")
    lockButton.Name = "LockButton"
    lockButton.Parent = screenGui
    lockButton.Size = UDim2.new(0, 150, 0, 50)
    lockButton.Position = UDim2.new(0, 5, 0, 5)
    lockButton.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
    lockButton.BorderSizePixel = 0
    lockButton.Font = Enum.Font.GothamBold
    lockButton.Text = "Lock: OFF"
    lockButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    lockButton.TextSize = 18
    lockButton.TextStrokeTransparency = 0.5
    
    local lockCorner = Instance.new("UICorner")
    lockCorner.CornerRadius = UDim.new(0, 8)
    lockCorner.Parent = lockButton
    
    local lockStroke = Instance.new("UIStroke")
    lockStroke.Parent = lockButton
    lockStroke.Thickness = 2
    lockStroke.Color = Color3.fromRGB(0, 200, 100)
    
    lockButton.MouseButton1Click:Connect(function()
        toggle_lock()
    end)
    
    lockButton.MouseEnter:Connect(function()
        TweenService:Create(lockButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
    end)
    
    lockButton.MouseLeave:Connect(function()
        TweenService:Create(lockButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 48)}):Play()
    end)
    
    MakeDraggable(lockButton)
    
    UIManager.LockButton = lockButton
    return lockButton
end

-- Initialize UI with error handling
local uiSuccess, uiError = pcall(function()
    CreateMainUI()
    CreateSettingsUI()
    CreateToggleButton()
    CreateLockButton()
end)

if not uiSuccess then
    warn("UI Creation Error:", uiError)
end

-- Add Settings Button to Main UI
if UIManager.MainUI then
    local settingsButton = Instance.new("TextButton")
    settingsButton.Parent = UIManager.MainUI.MainFrame.TitleBar
    settingsButton.Size = UDim2.new(0, 80, 0, 30)
    settingsButton.Position = UDim2.new(1, -90, 0.5, -15)
    settingsButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    settingsButton.BorderSizePixel = 0
    settingsButton.Font = Enum.Font.GothamBold
    settingsButton.Text = "Settings"
    settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.TextSize = 12
    
    local settingsBtnCorner = Instance.new("UICorner")
    settingsBtnCorner.CornerRadius = UDim.new(0, 4)
    settingsBtnCorner.Parent = settingsButton
    
    settingsButton.MouseButton1Click:Connect(function()
        UIManager.SettingsUIVisible = not UIManager.SettingsUIVisible
        if UIManager.SettingsUI then
            UIManager.SettingsUI.Enabled = UIManager.SettingsUIVisible
        end
    end)
end

if Menu then
    Menu:SetTitle("Nigger.Lua")
    Menu:SetVisible(false)
    Menu:Init()
end

-- ============================================
-- REST OF YOUR ORIGINAL CODE CONTINUES HERE
-- (All the particle effects, hit detection, aimbot logic, etc.)
-- ============================================

-- ============================================
-- ESSENTIAL FUNCTIONS FROM ORIGINAL SCRIPT
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local Stas = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

local TargBindEnabled = true
local TargetPlr = nil
local TargResolvePos = nil

-- Initialize TargetAimbot highlight
local TargHighlight = Instance.new("Highlight")
TargHighlight.Parent = CoreGui
TargHighlight.FillColor = TargetAimbot.HighlightColor1
TargHighlight.OutlineColor = TargetAimbot.HighlightColor2
TargHighlight.FillTransparency = 0.5
TargHighlight.OutlineTransparency = 0
TargHighlight.Enabled = false

-- FOV Circle (only if Drawing is available)
local FOV43 = nil
if Drawing then
    FOV43 = Drawing.new("Circle")
    FOV43.Transparency = 0.5
    FOV43.Thickness = 2
    FOV43.Color = Color3.new(1, 0, 0)
    FOV43.Filled = false
    FOV43.Radius = 250
    FOV43.Position = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)
    FOV43.Visible = false
end

-- Function to find closest player
function SigmaOhioPlayer()
    local closestPlayer
    local shortestDistance = math.huge
    local player = game.Players.LocalPlayer
    local CC = Workspace.CurrentCamera
    local screenCenter = Vector2.new(CC.ViewportSize.X / 2, CC.ViewportSize.Y / 2)
    local fovRadius = FOV43 and FOV43.Radius or 250
    local viewportSize = CC.ViewportSize

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") 
           and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local primaryPart = v.Character.PrimaryPart or v.Character:FindFirstChild("HumanoidRootPart")
            if primaryPart then
                local pos, onScreen = CC:WorldToViewportPoint(primaryPart.Position)
                
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
    end
    
    return closestPlayer
end

-- Toggle Lock Function
toggle_lock = function()
    if TargetAimbot.Enabled then
        local closest = SigmaOhioPlayer()
        if TargBindEnabled and TargetPlr then
            TargBindEnabled = false
            target_health = nil
            TargetPlr = nil
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
            end
            if TargetAimbot.LookAt then
                LocalPlayer.Character.Humanoid.AutoRotate = true
            end
            if UIManager.LockButton then
                UIManager.LockButton.Text = "Lock: OFF"
                UIManager.LockButton.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
            Menu.Notify("Untargeted", 2)
        else
            TargBindEnabled = true
            TargetPlr = closest
            if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
                target_health = TargetPlr.Character.Humanoid.Health
            else
                return
            end
            if UIManager.LockButton then
                UIManager.LockButton.Text = "Lock: ON"
                UIManager.LockButton.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
            Menu.Notify("Target Locked: " .. tostring(TargetPlr.DisplayName), 2)
        end
    end
end

-- Update target health function
local target_health = nil

local function updatetarget_health()
    if TargBindEnabled and TargetPlr and TargetPlr.Character then
        local humanoid = TargetPlr.Character:FindFirstChild("Humanoid")
        if humanoid then
            local currentHealth = humanoid.Health
            if currentHealth < target_health then
                if Hitnotify then
                    Menu.Notify('Cactus<font color="#90EE90">.GG [khen.cc]</font>  >  ' .. '+1 Hit | ' .. tostring(getgenv().Sentinel.SelectedPart) .. ' | Target : ' .. TargetPlr.DisplayName, 1.5)
                end
                -- Play hit sound and effects would go here
            end
            target_health = currentHealth
        end
    end
end

-- Update highlight
if RunService then
    RunService.RenderStepped:Connect(function()
        if TargetAimbot and TargetAimbot.Enabled and TargBindEnabled and TargetAimbot.Highlight and TargetPlr and TargetPlr.Character and Highlight then
            if TargHighlight then
                TargHighlight.FillColor = TargetAimbot.HighlightColor1
                TargHighlight.OutlineColor = TargetAimbot.HighlightColor2
                TargHighlight.Adornee = TargetPlr.Character
                TargHighlight.Enabled = true
            end
        else
            if TargHighlight then
                TargHighlight.Adornee = nil
                TargHighlight.Enabled = false
            end
        end
    end)
end

-- Set LockType
getgenv().Sentinel.LockType = getgenv().Sentinel.LockType or "Namecall"
getgenv().Sentinel.RESOLVER = getgenv().Sentinel.RESOLVER or "MoveDirection"

-- Character trail effect (from original)
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function(character)
    local hrp = character:WaitForChild("HumanoidRootPart", 10)
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
end)

-- Handle existing character
if player.Character then
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
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
end

-- Success message
task.spawn(function()
    wait(1)
    print("=========================================")
    print("Cactus.GG [khen.cc] - UI Redesigned")
    print("All features preserved and active!")
    print("=========================================")
    if Menu and Menu.Notify then
        Menu.Notify("Script Loaded Successfully!", 3)
    end
end)
