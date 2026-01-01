-- New UI System - No external Menu library needed


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
            FFlags = {
      }
            ,OriginalVelocity = {},
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
-- COMPLETELY NEW UI SYSTEM FROM SCRATCH
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Blur Effect
local Blur = Instance.new("BlurEffect", game:GetService("Lighting"))
Blur.Enabled = false
Blur.Size = 20

-- UI State
local UI = {
    Enabled = false,
    CurrentTab = "Main",
    Dragging = false,
    DragStart = nil,
    StartPos = nil
}

-- Create Main GUI
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "CactusUI"
MainGui.Parent = game.CoreGui
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.ResetOnSpawn = false

-- Toggle Button
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "Toggle"
ToggleBtn.Parent = MainGui
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(1, -55, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Image = "rbxassetid://126818107683779"
ToggleBtn.ImageTransparency = 0
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

-- Main Window
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Parent = MainGui
Window.Size = UDim2.new(0, 420, 0, 380)
Window.Position = UDim2.new(0.5, -210, 0.5, -190)
Window.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Window.BorderSizePixel = 0
Window.Visible = false
local WinCorner = Instance.new("UICorner")
WinCorner.CornerRadius = UDim.new(0, 6)
WinCorner.Parent = Window
local WinStroke = Instance.new("UIStroke")
WinStroke.Parent = Window
WinStroke.Color = Color3.fromRGB(45, 45, 45)
WinStroke.Thickness = 1

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = Window
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TitleBar.BorderSizePixel = 0
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Cactus.GG"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -26, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 3)
CloseCorner.Parent = CloseBtn

-- Tabs
local TabsFrame = Instance.new("Frame")
TabsFrame.Name = "Tabs"
TabsFrame.Parent = Window
TabsFrame.Size = UDim2.new(1, 0, 0, 32)
TabsFrame.Position = UDim2.new(0, 0, 0, 32)
TabsFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
TabsFrame.BorderSizePixel = 0
local TabsLayout = Instance.new("UIListLayout")
TabsLayout.Parent = TabsFrame
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.Padding = UDim.new(0, 3)

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "Content"
ContentFrame.Parent = Window
ContentFrame.Size = UDim2.new(1, -12, 1, -68)
ContentFrame.Position = UDim2.new(0, 6, 0, 64)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 2
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentFrame
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
end)

-- UI Helper Functions
local function CreateTab(name)
    local tab = Instance.new("TextButton")
    tab.Name = name .. "Tab"
    tab.Parent = TabsFrame
    tab.Size = UDim2.new(0, 75, 1, 0)
    tab.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(180, 180, 180)
    tab.TextSize = 12
    tab.Font = Enum.Font.Gotham
    tab.BorderSizePixel = 0
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 3)
    tabCorner.Parent = tab
    
    tab.MouseButton1Click:Connect(function()
        UI.CurrentTab = name
        for _, child in pairs(TabsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                if child == tab then
                    child.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    child.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    child.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                    child.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
        end
        for _, child in pairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") and child.Name:find("_") then
                child.Visible = child.Name:find("^" .. name .. "_") ~= nil
            end
        end
    end)
    
    return tab
end

local function CreateSection(name, tabName, order)
    local section = Instance.new("Frame")
    section.Name = tabName .. "_" .. name
    section.Parent = ContentFrame
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    section.BorderSizePixel = 0
    section.Visible = UI.CurrentTab == tabName
    section.LayoutOrder = order
    local secCorner = Instance.new("UICorner")
    secCorner.CornerRadius = UDim.new(0, 4)
    secCorner.Parent = section
    local secStroke = Instance.new("UIStroke")
    secStroke.Parent = section
    secStroke.Color = Color3.fromRGB(38, 38, 38)
    secStroke.Thickness = 1
    
    local secTitle = Instance.new("TextLabel")
    secTitle.Parent = section
    secTitle.Size = UDim2.new(1, -12, 0, 20)
    secTitle.Position = UDim2.new(0, 6, 0, 4)
    secTitle.BackgroundTransparency = 1
    secTitle.Text = name
    secTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    secTitle.TextSize = 13
    secTitle.Font = Enum.Font.GothamBold
    secTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local secContent = Instance.new("Frame")
    secContent.Name = "Items"
    secContent.Parent = section
    secContent.Size = UDim2.new(1, -12, 0, 0)
    secContent.Position = UDim2.new(0, 6, 0, 24)
    secContent.BackgroundTransparency = 1
    secContent.BorderSizePixel = 0
    
    local secLayout = Instance.new("UIListLayout")
    secLayout.Parent = secContent
    secLayout.Padding = UDim.new(0, 6)
    secLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.Size = UDim2.new(1, 0, 0, secContent.AbsoluteContentSize.Y + 30)
    end)
    
    return secContent
end

local function CreateCheckbox(parent, text, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1, 0, 0, 20)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    
    local box = Instance.new("TextButton")
    box.Parent = frame
    box.Size = UDim2.new(0, 16, 0, 16)
    box.Position = UDim2.new(0, 0, 0, 2)
    box.BackgroundColor3 = defaultValue and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(45, 45, 45)
    box.Text = ""
    box.BorderSizePixel = 0
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 2)
    boxCorner.Parent = box
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, -22, 1, 0)
    label.Position = UDim2.new(0, 20, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local state = defaultValue
    box.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(45, 45, 45)
        if callback then callback(state) end
    end)
    
    return frame
end

local function CreateSlider(parent, text, min, max, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1, 0, 0, 28)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 0, 14)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(defaultValue)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local track = Instance.new("Frame")
    track.Parent = frame
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0, 16)
    track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    track.BorderSizePixel = 0
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 2)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Parent = track
    fill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = fill
    
    local button = Instance.new("TextButton")
    button.Parent = track
    button.Size = UDim2.new(0, 8, 0, 8)
    button.Position = UDim2.new(fill.Size.X.Scale, -4, 0, -2)
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = ""
    button.BorderSizePixel = 0
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button
    
    local dragging = false
    button.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = track.AbsolutePosition
            local trackSize = track.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            local value = math.floor((min + (max - min) * relativeX) * 100) / 100
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            button.Position = UDim2.new(relativeX, -4, 0, -2)
            label.Text = text .. ": " .. tostring(value)
            if callback then callback(value) end
        end
    end)
    
    return frame
end

local function CreateDropdown(parent, text, options, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1, 0, 0, 20)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.48, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local button = Instance.new("TextButton")
    button.Parent = frame
    button.Size = UDim2.new(0.52, 0, 1, 0)
    button.Position = UDim2.new(0.48, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.Text = defaultValue or options[1]
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 11
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 2)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        local currentIndex = 1
        for i, option in ipairs(options) do
            if option == button.Text then
                currentIndex = i
                break
            end
        end
        local nextIndex = (currentIndex % #options) + 1
        button.Text = options[nextIndex]
        if callback then callback(options[nextIndex]) end
    end)
    
    return frame
end

local function CreateTextBox(parent, text, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1, 0, 0, 20)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.38, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local box = Instance.new("TextBox")
    box.Parent = frame
    box.Size = UDim2.new(0.62, 0, 1, 0)
    box.Position = UDim2.new(0.38, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    box.Text = tostring(defaultValue)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 11
    box.Font = Enum.Font.Gotham
    box.BorderSizePixel = 0
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 2)
    boxCorner.Parent = box
    
    box.FocusLost:Connect(function()
        if callback then callback(box.Text) end
    end)
    
    return frame
end

local function CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(1, 0, 0, 22)
    button.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 2)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return button
end

-- Toggle UI
local function ToggleUI()
    UI.Enabled = not UI.Enabled
    Window.Visible = UI.Enabled
    Blur.Enabled = UI.Enabled
    
    if UI.Enabled then
        for _, child in pairs(TabsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Name == "MainTab" then
                    child.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    child.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    child.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                    child.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
        end
        for _, child in pairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") and child.Name:find("_") then
                child.Visible = child.Name:find("^Main_") ~= nil
            end
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(ToggleUI)
CloseBtn.MouseButton1Click:Connect(ToggleUI)

-- Dragging
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        UI.Dragging = true
        UI.DragStart = input.Position
        UI.StartPos = Window.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if UI.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - UI.DragStart
        Window.Position = UDim2.new(UI.StartPos.X.Scale, UI.StartPos.X.Offset + delta.X, UI.StartPos.Y.Scale, UI.StartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        UI.Dragging = false
    end
end)

player.CharacterAdded:Connect(function()
    MainGui.Parent = game.CoreGui
end) 

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
    HighlightColor1 =Color3.fromRGB(255, 255, 255),
    HighlightColor2 =Color3.fromRGB(255, 255, 255),
    Stats = false, 
    UseFov = false,
    HitEffect = true,
    HitEffectType = "Coom", -- Nova, Crescent Slash, Coom, Cosmic Explosion, Slash, Atomic Slash
    HitEffectColor = Color3.fromRGB(255, 255, 255),
    HitSounds = true,
    HitSound = "Bameware",
    HitChams = true,
    HitChamsMaterial = Enum.Material.Neon,
    HitChamsDuration = 1,
    HitChamsColor = Color3.fromRGB(173, 216, 230)
}

local  Highlight = false

local Players = game:GetService("Players")
local Attachment = Instance.new("Attachment")

-- Spike Aura ------
    local SPIKES = Instance.new("ParticleEmitter")
    SPIKES.Name = "SPIKES"
    SPIKES.Acceleration = Vector3.new(0, 100, 0)
    SPIKES.Color = ColorSequence.new(Color3.new(0, 1, 0), Color3.new(0, 1, 0))
    SPIKES.Drag = 3
    SPIKES.EmissionDirection = Enum.NormalId.Right
    SPIKES.Lifetime = NumberRange.new(0.25, 0.5)
    SPIKES.LightEmission = 1
    SPIKES.Orientation = Enum.ParticleOrientation.VelocityParallel
    SPIKES.Rate = 100
    SPIKES.Rotation = NumberRange.new(-90, -90)
    SPIKES.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2, 0),
        NumberSequenceKeypoint.new(0.25, 3, 0.25),
        NumberSequenceKeypoint.new(0.653846, 2.0625, 0.164957),
        NumberSequenceKeypoint.new(1, 0, 0)
    })
    SPIKES.Speed = NumberRange.new(10, 25)
    SPIKES.SpreadAngle = Vector2.new(0, 180)
    SPIKES.Squash = NumberSequence.new({
        NumberSequenceKeypoint.new(0, -0.25),
        NumberSequenceKeypoint.new(1, 0.5),
        NumberSequenceKeypoint.new(1, 0.25)
    })
    SPIKES.Texture = "rbxassetid://7451697448"
    SPIKES.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.25, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    SPIKES.Enabled = false
    SPIKES.Parent = Attachment

    local SPECKS = Instance.new("ParticleEmitter")
    SPECKS.Name = "SPECKS"
    SPECKS.Acceleration = Vector3.new(0, -25, 0)
    SPECKS.Brightness = 2
    SPECKS.Color = ColorSequence.new(Color3.new(0, 1, 0), Color3.new(0, 1, 0))
    SPECKS.Drag = 5
    SPECKS.Lifetime = NumberRange.new(0.375, 0.625)
    SPECKS.LightEmission = 1
    SPECKS.Rate = 100
    SPECKS.RotSpeed = NumberRange.new(-45, 45)
    SPECKS.Rotation = NumberRange.new(-360, 360)
    SPECKS.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.25),
        NumberSequenceKeypoint.new(1, 0)
    })
    SPECKS.Speed = NumberRange.new(25, 50)
    SPECKS.SpreadAngle = Vector2.new(45, 45)
    SPECKS.Squash = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    SPECKS.Texture = "rbxassetid://4509687978"
    SPECKS.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.25, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    SPECKS.Enabled = false
    SPECKS.Parent = Attachment

    local GLOW = Instance.new("ParticleEmitter")
    GLOW.Name = "GLOW"
    GLOW.Acceleration = Vector3.new(0, 5, 0)
    GLOW.Color = ColorSequence.new(Color3.new(0, 1, 0), Color3.new(0, 1, 0))
    GLOW.Lifetime = NumberRange.new(0.5, 1)
    GLOW.LightEmission = 1
    GLOW.Rate = 50
    GLOW.Rotation = NumberRange.new(-360, 360)
    GLOW.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 8),
        NumberSequenceKeypoint.new(1, 3)
    })
    GLOW.Speed = NumberRange.new(10, 25)
    GLOW.Texture = "rbxassetid://4509687978"
    GLOW.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.95),
        NumberSequenceKeypoint.new(1, 1)
    })
    GLOW.ZOffset = -1
    GLOW.Enabled = false
    GLOW.Parent = Attachment



-- Electric --------------
    local ELECTRIC1 = Instance.new('ParticleEmitter')
    ELECTRIC1.Name = "ELECTRIC1"
    ELECTRIC1.Brightness = 5
    ELECTRIC1.Color = ColorSequence.new(Color3.fromRGB(0, 134, 199))
    ELECTRIC1.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8
    ELECTRIC1.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
    ELECTRIC1.Lifetime = NumberRange.new(1)
    ELECTRIC1.LightEmission = 1
    ELECTRIC1.Rate = 5
    ELECTRIC1.Size = NumberSequence.new(2)
    ELECTRIC1.Speed = NumberRange.new(0)
    ELECTRIC1.SpreadAngle = Vector2.new(-360, 360)
    ELECTRIC1.Texture = "http://www.roblox.com/asset/?id=12390063093"
    ELECTRIC1.Transparency = NumberSequence.new(0, 1)
    ELECTRIC1.Enabled = false
    ELECTRIC1.Parent = Attachment

    local ELECTRIC2 = Instance.new('ParticleEmitter')
    ELECTRIC2.Name = "ELECTRIC2"
    ELECTRIC2.Color = ColorSequence.new(Color3.fromRGB(0, 134, 199))
    ELECTRIC2.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8
    ELECTRIC2.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
    ELECTRIC2.Lifetime = NumberRange.new(0.25, 0.5)
    ELECTRIC2.LightEmission = 1
    ELECTRIC2.Rate = 25
    ELECTRIC2.Rotation = NumberRange.new(-360, 360)
    ELECTRIC2.Size = NumberSequence.new(2)
    ELECTRIC2.Speed = NumberRange.new(0)
    ELECTRIC2.SpreadAngle = Vector2.new(-360, 360)
    ELECTRIC2.Texture = "http://www.roblox.com/asset/?id=12390081661"
    ELECTRIC2.Transparency = NumberSequence.new(0, 1)
    ELECTRIC2.Enabled = false
    ELECTRIC2.Parent = Attachment

    local ELECTRIC3 = Instance.new('ParticleEmitter')
    ELECTRIC3.Name = "ELECTRIC3"
    ELECTRIC3.Color = ColorSequence.new(Color3.fromRGB(0, 134, 199))
    ELECTRIC3.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8
    ELECTRIC3.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
    ELECTRIC3.Lifetime = NumberRange.new(0.25, 0.5)
    ELECTRIC3.LightEmission = 1
    ELECTRIC3.Rate = 25
    ELECTRIC3.Rotation = NumberRange.new(-360, 360)
    ELECTRIC3.Size = NumberSequence.new(2)
    ELECTRIC3.Speed = NumberRange.new(0)
    ELECTRIC3.SpreadAngle = Vector2.new(-360, 360)
    ELECTRIC3.Texture = "http://www.roblox.com/asset/?id=12390081661"
    ELECTRIC3.Transparency = NumberSequence.new(0, 1)
    ELECTRIC3.Enabled = false
    ELECTRIC3.Parent = Attachment

    local Wave1 = Instance.new('ParticleEmitter')
    Wave1.Name = "Wave1"
    Wave1.Brightness = 10
    Wave1.Color = ColorSequence.new(Color3.fromRGB(0, 170, 255))
    Wave1.Lifetime = NumberRange.new(1)
    Wave1.LightEmission = 0.4
    Wave1.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
    Wave1.Rate = 10
    Wave1.RotSpeed = NumberRange.new(200, 400)
    Wave1.Rotation = NumberRange.new(-180, 180)
    Wave1.Size = NumberSequence.new(3)
    Wave1.Speed = NumberRange.new(1, 3)
    Wave1.SpreadAngle = Vector2.new(10, -10)
    Wave1.Texture = "rbxassetid://8047533775"
    Wave1.Transparency = NumberSequence.new(0, 1)
    Wave1.Enabled = false
    Wave1.Parent = Attachment

    local ELECTRIC4 = Instance.new('ParticleEmitter')
    ELECTRIC4.Name = "ELECTRIC4"
    ELECTRIC4.Color = ColorSequence.new(Color3.fromRGB(0, 134, 199))
    ELECTRIC4.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8
    ELECTRIC4.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
    ELECTRIC4.Lifetime = NumberRange.new(0.25, 0.5)
    ELECTRIC4.LightEmission = 1
    ELECTRIC4.Rate = 25
    ELECTRIC4.Rotation = NumberRange.new(-360, 360)
    ELECTRIC4.Size = NumberSequence.new(2)
    ELECTRIC4.Speed = NumberRange.new(0)
    ELECTRIC4.SpreadAngle = Vector2.new(-360, 360)
    ELECTRIC4.Texture = "http://www.roblox.com/asset/?id=12390081661"
    ELECTRIC4.Transparency = NumberSequence.new(0, 1)
    ELECTRIC4.Enabled = false
    ELECTRIC4.Parent = Attachment


-- Swirl ------
local swirl = Instance.new("ParticleEmitter")
swirl.Name = "swirl"
swirl.Color = ColorSequence.new(Color3.fromRGB(66, 60, 255), Color3.fromRGB(66, 60, 255)) 
swirl.Lifetime = NumberRange.new(2, 2)
swirl.LightEmission = 1
swirl.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
swirl.Rate = 150
swirl.RotSpeed = NumberRange.new(200, 200)
swirl.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 7),
    NumberSequenceKeypoint.new(1, 7)
})
swirl.Speed = NumberRange.new(0.01, 0.01)
swirl.SpreadAngle = Vector2.new(-360, 360)
swirl.Squash = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.163934, 1),
    NumberSequenceKeypoint.new(1, 0)
})
swirl.Texture = "rbxassetid://10558425570"
swirl.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.500623, 0.5),
    NumberSequenceKeypoint.new(1, 1)
})
swirl.ZOffset = -1
swirl.Enabled = false
swirl.Parent = Attachment



-- aura burst ------ ass
local auraburst2 = Instance.new("ParticleEmitter")
auraburst2.Name = "auraburst2"
auraburst2.Brightness = 25
auraburst2.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0))
})
auraburst2.EmissionDirection = Enum.NormalId.Top
auraburst2.Enabled = false
auraburst2.FlipbookFramerate = NumberRange.new(289.311, 289.311)
auraburst2.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
auraburst2.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
auraburst2.Lifetime = NumberRange.new(0.500, 0.500)
auraburst2.LightEmission = 1
auraburst2.LightInfluence = 0.15
auraburst2.Orientation = Enum.ParticleOrientation.VelocityParallel
auraburst2.Rate = 6.615
auraburst2.Rotation = NumberRange.new(360, 360)
auraburst2.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 8.7832),
    NumberSequenceKeypoint.new(1, 8.7832)
})
auraburst2.Speed = NumberRange.new(0.00973265, 0.00973265)
auraburst2.Squash = NumberSequence.new({
    NumberSequenceKeypoint.new(0, -0.5),
    NumberSequenceKeypoint.new(1, -0.5)
})
auraburst2.Texture = "rbxassetid://17282066926"
auraburst2.ZOffset = -1
auraburst2.Parent = Attachment




local Players = game:GetService("Players")

local HitEffectModule = {
Locals = {
HitEffect = {
Type = {}
}
}
}


HitEffectModule.Locals.HitEffect.Type["Skibidi RedRizz"] = Attachment

local MainColor = Color3.fromRGB(143, 48, 167)

local emitter = Instance.new('ParticleEmitter')
emitter.Name = "emitter"
emitter.LightEmission = 3
emitter.Transparency = NumberSequence.new(0)
emitter.Color = ColorSequence.new(MainColor)
emitter.Size = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 6, 1.2)}
emitter.Rotation = NumberRange.new(0)
emitter.RotSpeed = NumberRange.new(0)
emitter.Enabled = false
emitter.Rate = 50
emitter.Lifetime = NumberRange.new(0.25)
emitter.Speed = NumberRange.new(0.1)
emitter.Squash = NumberSequence.new(0)
emitter.ZOffset = 1
emitter.Texture = "rbxassetid://2916153928"
emitter.Orientation = Enum.ParticleOrientation.VelocityParallel
emitter.Shape = 'Box'
emitter.ShapeInOut = 'Outward'
emitter.ShapeStyle = 'Volume'
emitter.Parent = Attachment

local skum = Instance.new('ParticleEmitter')
skum.Name = "skum"
skum.LightEmission = 3
skum.Transparency = NumberSequence.new(0)
skum.Color = ColorSequence.new(MainColor)
skum.Size = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 6, 1.2)}
skum.Rotation = NumberRange.new(0)
skum.RotSpeed = NumberRange.new(0)
skum.Enabled = false
skum.Rate = 50
skum.Lifetime = NumberRange.new(0.25)
skum.Speed = NumberRange.new(0.1)
skum.Squash = NumberSequence.new(0)
skum.ZOffset = 1
skum.Texture = "rbxassetid://1084991215"
skum.Orientation = Enum.ParticleOrientation.VelocityParallel
skum.Shape = 'Box'
skum.ShapeInOut = 'Outward'
skum.ShapeStyle = 'Volume'
skum.Parent = Attachment

local Shards = Instance.new("ParticleEmitter")
Shards.Name = "Shards"
Shards.Lifetime = NumberRange.new(0.19, 0.7)
Shards.SpreadAngle = Vector2.new(-90, 90)
Shards.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
Shards.Drag = 10
Shards.VelocitySpread = -90
Shards.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
Shards.Speed = NumberRange.new(97.7530136, 146.9970093)
Shards.Brightness = 4
Shards.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
Shards.Enabled = false
Shards.Acceleration = Vector3.new(0, -56.961341857910156, 0)
Shards.ZOffset = 0.5705321
Shards.Rate = 50
Shards.Texture = "rbxassetid://8030734851"
Shards.Rotation = NumberRange.new(90, 90)
Shards.Orientation = Enum.ParticleOrientation.VelocityParallel
Shards.Parent = Attachment

local ShardsDark = Instance.new("ParticleEmitter")
ShardsDark.Name = "ShardsDark"
ShardsDark.Lifetime = NumberRange.new(0.19, 0.35)
ShardsDark.SpreadAngle = Vector2.new(-90, 90)
ShardsDark.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
ShardsDark.Drag = 10
ShardsDark.VelocitySpread = -90
ShardsDark.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
ShardsDark.Speed = NumberRange.new(97.7530136, 146.9970093)
ShardsDark.Brightness = 4
ShardsDark.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.290774, 0.6734411, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
ShardsDark.Enabled = false
ShardsDark.ZOffset = 0.5705321
ShardsDark.Rate = 50
ShardsDark.Texture = "rbxassetid://8030734851"
ShardsDark.Rotation = NumberRange.new(90, 90)
ShardsDark.Orientation = Enum.ParticleOrientation.VelocityParallel
ShardsDark.Parent = Attachment

local large_shard = Instance.new("ParticleEmitter")
large_shard.Name = "large_shard"
large_shard.Lifetime = NumberRange.new(0.19, 0.28)
large_shard.SpreadAngle = Vector2.new(-90, 90)
large_shard.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
large_shard.Drag = 10
large_shard.VelocitySpread = -90
large_shard.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
large_shard.Speed = NumberRange.new(97.7530136, 146.9970093)
large_shard.Brightness = 4
large_shard.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.260774, 3.515605, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
large_shard.Enabled = false
large_shard.ZOffset = 0.5705321
large_shard.Rate = 50
large_shard.Texture = "rbxassetid://8030734851"
large_shard.Rotation = NumberRange.new(90, 90)
large_shard.Orientation = Enum.ParticleOrientation.VelocityParallel
large_shard.Parent = Attachment

local Crescents = Instance.new("ParticleEmitter")
Crescents.Name = "Crescents"
Crescents.Lifetime = NumberRange.new(0.19, 0.38)
Crescents.SpreadAngle = Vector2.new(-360, 360)
Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
Crescents.LightEmission = 1
Crescents.Color = ColorSequence.new(Color3.fromRGB(92, 161, 252))
Crescents.VelocitySpread = -360
Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
Crescents.Brightness = 20
Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
Crescents.Enabled = false
Crescents.ZOffset = 0.4542207
Crescents.Rate = 50
Crescents.Texture = "rbxassetid://12509373457"
Crescents.RotSpeed = NumberRange.new(800, 1000)
Crescents.Rotation = NumberRange.new(-360, 360)
Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Crescents.Parent = Attachment




-- Create Tabs
CreateTab("Main")
CreateTab("HvH")
CreateTab("Visuals")
CreateTab("Misc")

-- Main Tab Sections
local targetAimSection = CreateSection("Target Aim", "Main", 1)
CreateCheckbox(targetAimSection, "Enabled", getgenv().Sentinel.Enabled, function(a) getgenv().Sentinel.Enabled = a end)
CreateCheckbox(targetAimSection, "Look At", getgenv().Sentinel.LookAt, function(a) getgenv().Sentinel.LookAt = a end)
CreateCheckbox(targetAimSection, "Highlight", false, function(a) Highlight = a end)
CreateCheckbox(targetAimSection, "Auto Air", getgenv().Sentinel.AutoAir, function(a) getgenv().Sentinel.AutoAir = a end)
CreateCheckbox(targetAimSection, "Resolver", getgenv().Sentinel.ResolverEnabled, function(a) getgenv().Sentinel.ResolverEnabled = a end)

local hitPartSection = CreateSection("Hit Part", "Main", 2)
CreateCheckbox(hitPartSection, "NearestPart", getgenv().Sentinel.NearestPart, function(a) getgenv().Sentinel.NearestPart = a end)
CreateDropdown(hitPartSection, "Body Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}, getgenv().Sentinel.SelectedPart, function(a) getgenv().Sentinel.SelectedPart = a end)

local predictionSection = CreateSection("Prediction", "Main", 3)
CreateCheckbox(predictionSection, "Auto Prediction", getgenv().Sentinel.AutoPrediction, function(a) getgenv().Sentinel.AutoPrediction = a end)
CreateDropdown(predictionSection, "Lock Type", {"Namecall", "Index"}, getgenv().Sentinel.LockType or "Namecall", function(a) getgenv().Sentinel.LockType = a end)
CreateTextBox(predictionSection, "Horizontal", getgenv().Sentinel.HorizontalPrediction, function(a) getgenv().Sentinel.HorizontalPrediction2 = tonumber(a) or 0.045 end)

local cameraSection = CreateSection("Camera", "Main", 4)
CreateCheckbox(cameraSection, "Enabled", getgenv().Sentinel.Camera, function(a) getgenv().Sentinel.Camera = a end)
CreateTextBox(cameraSection, "Smoothness", getgenv().Sentinel.smoothness, function(a) getgenv().Sentinel.smoothness = tonumber(a) or 0.9 end)
CreateDropdown(cameraSection, "Easing Style", {"Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Exponential", "Circular", "Back", "Bounce", "Elastic"}, getgenv().Sentinel.easingStyle, function(a) getgenv().Sentinel.easingStyle = a end)
CreateDropdown(cameraSection, "Easing Direction", {"In", "Out", "InOut"}, getgenv().Sentinel.easingDirection, function(a) getgenv().Sentinel.easingDirection = a end)

-- HvH Tab Sections
local teleportSection = CreateSection("Teleports", "HvH", 1)
CreateCheckbox(teleportSection, "Grenade Tp", GrenadeTP, function(a) Script.Locals.GrenadeTP.Enabled = a end)
CreateCheckbox(teleportSection, "Rocket Tp", RocketTP, function(a) Script.Locals.RocketTP.Enabled = a end)

local bulletTPSection = CreateSection("Bullet-TP", "HvH", 2)
CreateCheckbox(bulletTPSection, "Bullet Gyatt", RocketTP, function(a) Script.Locals.GunTP.Enabled = a end)
CreateCheckbox(bulletTPSection, "Anchor", RocketTP, function(a) Script.Locals.GunTP.Anchor = a end)
CreateTextBox(bulletTPSection, "X Offset", Script.Locals.GunTP.Offset[1], function(a) Script.Locals.GunTP.Offset[1] = tonumber(a) or 0 end)
CreateTextBox(bulletTPSection, "Y Offset", Script.Locals.GunTP.Offset[2], function(a) Script.Locals.GunTP.Offset[2] = tonumber(a) or -1 end)
CreateTextBox(bulletTPSection, "Z Offset", Script.Locals.GunTP.Offset[3], function(a) Script.Locals.GunTP.Offset[3] = tonumber(a) or 0 end)

local cSyncSection = CreateSection("CSync", "HvH", 3)
CreateCheckbox(cSyncSection, "Enabled", TargetAimbot.CSync.Enabled, function(a) TargetAimbot.CSync.Enabled = a end)
CreateDropdown(cSyncSection, "Type", {"Orbit", "Random"}, TargetAimbot.CSync.Type, function(a) TargetAimbot.CSync.Type = a end)
CreateSlider(cSyncSection, "Distance", 0, 20, TargetAimbot.CSync.Distance, function(a) TargetAimbot.CSync.Distance = a end)
CreateSlider(cSyncSection, "Height", 0, 10, TargetAimbot.CSync.Height, function(a) TargetAimbot.CSync.Height = a end)
CreateSlider(cSyncSection, "Speed", 0, 20, TargetAimbot.CSync.Speed, function(a) TargetAimbot.CSync.Speed = a end)
CreateSlider(cSyncSection, "Random Amount", 0, 20, TargetAimbot.CSync.RandomAmount, function(a) TargetAimbot.CSync.RandomAmount = a end)

-- Visuals Tab Sections
local hitDetectionSection = CreateSection("Hit Detection", "Visuals", 1)
local Hitnotify = false
CreateCheckbox(hitDetectionSection, "Hit Effect", TargetAimbot.HitEffect, function(a) TargetAimbot.HitEffect = a end)
CreateCheckbox(hitDetectionSection, "Hit Sound", TargetAimbot.HitSounds, function(a) TargetAimbot.HitSounds = a end)
CreateCheckbox(hitDetectionSection, "Notify", false, function(a) Hitnotify = a end)
CreateDropdown(hitDetectionSection, "Effect Type", {"Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", "Circle Shot", "Bolt", "Aura", "Electric", "Shock", "Thunder"}, TargetAimbot.HitEffectType, function(a) TargetAimbot.HitEffectType = a end)
CreateDropdown(hitDetectionSection, "Sound Type", {"RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", "Gamesense", "Rust", "BlackPencil"}, TargetAimbot.HitSound, function(a) TargetAimbot.HitSound = a end)

local hitChamsSection = CreateSection("Hit Chams", "Visuals", 2)
CreateCheckbox(hitChamsSection, "Enabled", TargetAimbot.HitChams, function(a) TargetAimbot.HitChams = a end)
CreateDropdown(hitChamsSection, "Material", {"Neon", "SmoothPlastic"}, TargetAimbot.HitChamsMaterial.Name, function(a) TargetAimbot.HitChamsMaterial = Enum.Material[a] end)
CreateSlider(hitChamsSection, "Duration", 0, 5, TargetAimbot.HitChamsDuration, function(a) TargetAimbot.HitChamsDuration = a end)

-- Misc Tab Sections
local predictionBreakerSection = CreateSection("Prediction Breaker", "Misc", 1)
CreateCheckbox(predictionBreakerSection, "Jump Prediction", getgenv().Sentinel.JumpBreak, function(a) getgenv().Sentinel.JumpBreak = a end)
CreateCheckbox(predictionBreakerSection, "Enable Anti Lock", getgenv().Desync, function(a) getgenv().Desync = a end)
CreateDropdown(predictionBreakerSection, "Anti Lock Type", {"Behind", "Down", "ForWard", "Left", "One", "Right", "Up", "Zero"}, getgenv().AntiLockType, function(a) getgenv().AntiLockType = a end)

local cframeSpeedSection = CreateSection("CFrame Speed", "Misc", 2)
CreateCheckbox(cframeSpeedSection, "Enabled", false, function(a) getgenv().Sentinel.cframespeedtoggle = a end)
CreateSlider(cframeSpeedSection, "Speed", 0, 10, getgenv().Sentinel.speedvalue, function(a) getgenv().Sentinel.speedvalue = a end)

local macroSection = CreateSection("Macro", "Misc", 3)
local MacroAlreadLoaded = false
CreateButton(macroSection, "Load Macro", function()
    if MacroAlreadLoaded then
        print("Macro already loaded")
        return
    end
    MacroAlreadLoaded = true
    
    local players = game:GetService("Players")
    local runservice = game:GetService("RunService")
    local player = players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    local humanoid = character.Humanoid
    local camera = workspace.CurrentCamera
    local MAX_LENGTH = 900000
    local active = false
    local ENABLED_OFFSET = CFrame.new(0, 0, 0)
    local DISABLED_OFFSET = CFrame.new(0, 0, 0)
    local rootPos = Vector3.new(0, 0, 0)

    local function UpdatePos()
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").RootPart then
            rootPos = player.Character:FindFirstChildOfClass("Humanoid").RootPart.Position
        end
    end

    local function UpdateAutoRotate(BOOL)
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").AutoRotate = BOOL
        end
    end

    local function GetUpdatedCameraCFrame()
        if game:GetService("Workspace").CurrentCamera then
            return CFrame.new(rootPos, Vector3.new(game:GetService("Workspace").CurrentCamera.CFrame.LookVector.X * MAX_LENGTH, rootPos.Y, game:GetService("Workspace").CurrentCamera.CFrame.LookVector.Z * MAX_LENGTH))
        end
    end

    local function EnableShiftlock()
        UpdatePos()
        UpdateAutoRotate(false)
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").RootPart then
            player.Character:FindFirstChildOfClass("Humanoid").RootPart.CFrame = GetUpdatedCameraCFrame()
        end
        if game:GetService("Workspace").CurrentCamera then
            game:GetService("Workspace").CurrentCamera.CFrame = camera.CFrame * ENABLED_OFFSET
        end
    end

    local function DisableShiftlock()
        UpdatePos()
        UpdateAutoRotate(true)
        if game:GetService("Workspace").CurrentCamera then
            game:GetService("Workspace").CurrentCamera.CFrame = camera.CFrame * DISABLED_OFFSET
        end
        pcall(function()
            if active then
                active:Disconnect()
                active = nil
            end
        end)
    end

    local MCenabled = false
    function ShiftLock()
        if MCenabled then
            if not active then
                active = runservice.RenderStepped:Connect(function()
                    EnableShiftlock()
                end)
            else
                DisableShiftlock()
            end
        end
    end

    task.spawn(function()
        while task.wait(getgenv().Sentinel.MacroSpeed) do
            ShiftLock()
        end
    end)
end)
CreateTextBox(macroSection, "Speed", getgenv().Sentinel.MacroSpeed, function(a) getgenv().Sentinel.MacroSpeed = tonumber(a) or 0.1 end)

local networkAntiSection = CreateSection("Network Anti", "Misc", 4)
CreateCheckbox(networkAntiSection, "Enabled", getgenv().Sentinel.network, function(a) getgenv().Sentinel.network = a end)

-- Notification
task.spawn(function()
    task.wait(0.5)
    print("Script Loaded - Cactus.GG [khen.cc]")
end)
