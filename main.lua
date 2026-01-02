-- Cactus.GG Script - Redesigned UI
-- Load Menu Library
local Menu = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/library/refs/heads/main/cuh.txt",true))()

task.spawn(function()
    Menu:NameUpdate(0.6, 'Cactus', '.GG [khen.cc]')
end)

-- Script Configuration
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

-- Settings Configuration
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

-- Sentinel Configuration
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

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Character Setup
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

-- UI Setup
local Ui22 = Instance.new("ScreenGui")
Ui22.Name = "Ui22"
Ui22.Parent = game.CoreGui
Ui22.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Ui22.ResetOnSpawn = false

local Image3 = Instance.new("ImageButton")
Image3.Name = "Image3"
Image3.Parent = Ui22
Image3.Active = false
Image3.Draggable = true
Image3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Image3.BackgroundTransparency = 1
Image3.Size = UDim2.new(0, 90, 0, 90)
Image3.Image = "rbxassetid://126818107683779"
Image3.Position = UDim2.new(1, -95, 0, 5)

local Ui2corner = Instance.new("UICorner")
Ui2corner.CornerRadius = UDim.new(0.2, 0)
Ui2corner.Parent = Image3

local Blur = Instance.new("BlurEffect", game:GetService("Lighting"))
Blur.Enabled = false

local butj = Instance.new("ImageLabel")
butj.Size = UDim2.new(0, 200, 0, 200)
local elementWidth = butj.Size.X.Offset
local elementHeight = butj.Size.Y.Offset
butj.Position = UDim2.new(0.5, -elementWidth / 2, 0.5, -elementHeight / 2)
butj.Active = false
butj.BackgroundTransparency = 1
butj.ImageTransparency = 1
butj.Parent = Ui22
butj.Image = "rbxassetid://126818107683779"

local Open = true
Menu:SetVisible(false)

local function ToggleMenu()
    if Open == true then
        Blur.Enabled = true
        butj.ImageTransparency = 0
        Menu:SetVisible(true)
    else
        Blur.Enabled = false
        Menu:SetVisible(false)
        for i = 0, 1, 0.1 do
            butj.ImageTransparency = i
            task.wait(0.05)
        end
    end
end

Image3.MouseButton1Click:Connect(function()
    Open = not Open
    print("khen.cc")
    ToggleMenu()
end)

-- Hit Sounds
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

-- Target Aimbot Configuration
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

-- Initialize Menu
Menu:SetSize(500, 400)
Menu.Notify("Script Loaded.", 2)

-- ============================================
-- MAIN TAB - COMBAT FEATURES
-- ============================================
local CombatTab = Menu.Tab("Main")

-- Target Aim Section
local TargetAimSection = Menu.Container("Main", "Target Aim", "Left")
Menu.CheckBox("Main", "Target Aim", "Enabled", getgenv().Sentinel.Enabled, function(a)
    getgenv().Sentinel.Enabled = a
end)

Menu.CheckBox("Main", "Target Aim", "Look At", getgenv().Sentinel.LookAt, function(a)
    getgenv().Sentinel.LookAt = a 
end)

Menu.CheckBox("Main", "Target Aim", "Highlight", getgenv().Sentinel.Highlight, function(a)
    Highlight = a
end)

Menu.CheckBox("Main", "Target Aim", "Auto Air", getgenv().Sentinel.AutoAir, function(a)
    getgenv().Sentinel.AutoAir = a
end)

Menu.CheckBox("Main", "Target Aim", "Resolver", getgenv().Sentinel.ResolverEnabled, function(a)
    getgenv().Sentinel.ResolverEnabled = a
end)

-- HitPart Section
local HitPartSection = Menu.Container("Main", "HitPart", "Left")
Menu.CheckBox("Main", "HitPart", "NearestPart", getgenv().Sentinel.NearestPart, function(a) 
    getgenv().Sentinel.NearestPart = a
end)

Menu.ComboBox("Main", "HitPart", "BodyPart", "Body Part", {
    "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", 
    "LeftUpperArm", "LeftLowerArm", "LeftHand", 
    "RightUpperArm", "RightLowerArm", "RightHand", 
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", 
    "RightUpperLeg", "RightLowerLeg", "RightFoot"
}, function(a)
    getgenv().Sentinel.SelectedPart = a
end)

-- Prediction Section
local PredictionSection = Menu.Container("Main", "Prediction", "Left")
Menu.CheckBox("Main", "Prediction", "Auto Prediction", true, function(a)
    getgenv().Sentinel.AutoPrediction = a
end)

Menu.ComboBox("Main","Prediction","LockType", getgenv().Sentinel.LockType or "Namecall", {"Namecall","Index"},
function(a)
    getgenv().Sentinel.LockType = a
end)

Menu.TextBox("Main", "Prediction", "Horizontal", tostring(getgenv().Sentinel.HorizontalPrediction), function(a)
    getgenv().Sentinel.HorizontalPrediction2 = tonumber(a)
end)

-- Camera Section
local CameraContainer = Menu.Container("Main", "Camera", "Right")
Menu.CheckBox("Main", "Camera", "Enabled", getgenv().Sentinel.Camera, function(a)
    getgenv().Sentinel.Camera = a
end)

Menu.TextBox("Main", "Camera", "Smoothness", tostring(getgenv().Sentinel.smoothness), function(a)
    getgenv().Sentinel.smoothness = tonumber(a)
end)

Menu.ComboBox("Main", "Camera", "Easing Style", getgenv().Sentinel.easingStyle, {
    "Linear", "Quad", "Cubic", "Quart", "Quint", "Sine",
    "Exponential", "Circular", "Back", "Bounce", "Elastic"
}, function(Cock)
    getgenv().Sentinel.easingStyle = Cock
end)

Menu.ComboBox("Main", "Camera", "Easing Direction", getgenv().Sentinel.easingDirection, {
    "In", "Out", "InOut"
}, function(Cock)
    getgenv().Sentinel.easingDirection = Cock
end)

-- ============================================
-- HVH TAB - ADVANCED FEATURES
-- ============================================
local HvHTab = Menu.Tab("HvH")

-- Teleports Section
local TeleportSection = Menu.Container("HvH", "Teleports", "Left")
Menu.CheckBox("HvH", "Teleports", "Grenade Tp", GrenadeTP, function(a)
    Script.Locals.GrenadeTP.Enabled = a
    GrenadeTP = a
end)

Menu.CheckBox("HvH", "Teleports", "Rocket Tp", RocketTP, function(a)
    Script.Locals.RocketTP.Enabled = a
    RocketTP = a
end)

-- Bullet-TP Section
local BulletTaP = Menu.Container("HvH", "Bullet-TP", "Left")
Menu.CheckBox("HvH", "Bullet-TP", "Bullet Gyatt", Script.Locals.GunTP.Enabled, function(a) 
    Script.Locals.GunTP.Enabled = a
end)

Menu.CheckBox("HvH", "Bullet-TP", "Anchor", Script.Locals.GunTP.Anchor, function(a) 
    Script.Locals.GunTP.Anchor = a
end)

Menu.TextBox("HvH", "Bullet-TP", "X", "0", function(a) 
    Script.Locals.GunTP.Offset[1] = tonumber(a) or 0
end)

Menu.TextBox("HvH", "Bullet-TP", "Y", "-0.5", function(a) 
    Script.Locals.GunTP.Offset[2] = tonumber(a) or -0.5
end)

Menu.TextBox("HvH", "Bullet-TP", "Z", "0", function(a) 
    Script.Locals.GunTP.Offset[3] = tonumber(a) or 0
end)

-- CSync Section
local CSyncSection = Menu.Container("HvH", "CSync", "Right")
Menu.CheckBox("HvH", "CSync", "Enabled", TargetAimbot.CSync.Enabled, function(a)
    TargetAimbot.CSync.Enabled = a
end)

Menu.ComboBox("HvH", "CSync", "Type", TargetAimbot.CSync.Type, {"Orbit", "Random"}, function(a)
    TargetAimbot.CSync.Type = a
end)

Menu.Slider("HvH", "CSync", "Distance", 0, 20, TargetAimbot.CSync.Distance, '', 1, function(a)
    TargetAimbot.CSync.Distance = a
end)

Menu.Slider("HvH", "CSync", "Height", 0, 10, TargetAimbot.CSync.Height, '', 1, function(a)
    TargetAimbot.CSync.Height = a
end)

Menu.Slider("HvH", "CSync", "Speed", 0, 20, TargetAimbot.CSync.Speed, '', 1, function(a)
    TargetAimbot.CSync.Speed = a
end)

Menu.Slider("HvH", "CSync", "Random Amount", 0, 20, TargetAimbot.CSync.RandomAmount, '', 1, function(a)
    TargetAimbot.CSync.RandomAmount = a
end)

-- ============================================
-- VISUALS TAB
-- ============================================
local Visuals = Menu.Tab("Visuals")

-- Hit Detection Section
local HitDetectionSection = Menu.Container("Visuals", "Hit Detection", "Left")
Menu.CheckBox("Visuals", "Hit Detection", "Hit Effect", TargetAimbot.HitEffect, function(a) 
    TargetAimbot.HitEffect = a
end)

Menu.CheckBox("Visuals", "Hit Detection", "Hit Sound", TargetAimbot.HitSounds, function(a)
    TargetAimbot.HitSounds = a
end)

local Hitnotify = false
Menu.CheckBox("Visuals", "Hit Detection", "Notify", false, function(a) 
    Hitnotify = a
end)

Menu.ComboBox("Visuals", "Hit Detection", "Effect Type", TargetAimbot.HitEffectType, {
    "Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", 
    "Circle Shot", "Bolt", "Aura", "Electric", "Shock", "Thunder"
}, function(a)
    TargetAimbot.HitEffectType = a
end)

Menu.ComboBox("Visuals", "Hit Detection", "Sound Type", TargetAimbot.HitSound, {
    "RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", 
    "Gamesense", "Rust", "BlackPencil"
}, function(a)
    TargetAimbot.HitSound = a
end)

Menu.ColorPicker("Visuals", "Hit Detection", "Highlight fill", Color3.fromRGB(144, 238, 144), 0, function(a)
    TargetAimbot.HighlightColor1 = a
end)

Menu.ColorPicker("Visuals", "Hit Detection", "Highlight Outline", Color3.fromRGB(144, 238, 144), 0, function(a)
    TargetAimbot.HighlightColor2 = a
end)

Menu.ColorPicker("Visuals", "Hit Detection", "Hit Effect Color", Color3.fromRGB(144, 238, 144), 0, function(a)
    TargetAimbot.HitEffectColor = a
end)

Menu.ColorPicker("Visuals", "Hit Detection", "Visualizer", Color3.fromRGB(144, 238, 144), 0, function(a)
    TargetAimbot.CSync.Color = a
end)

-- Hit Chams Section
local HitChamsSection = Menu.Container("Visuals", "Hit Chams", "Right")
Menu.CheckBox("Visuals", "Hit Chams", "Enabled", TargetAimbot.HitChams, function(a)
    TargetAimbot.HitChams = a
end)

Menu.ColorPicker("Visuals", "Hit Chams", "Color", TargetAimbot.HitChamsColor, 0, function(a)
    TargetAimbot.HitChamsColor = a
end)

Menu.Slider("Visuals", "Hit Chams", "Duration", 0, 5, TargetAimbot.HitChamsDuration, '', 1, function(a)
    TargetAimbot.HitChamsDuration = a
end)

Menu.ComboBox("Visuals", "Hit Chams", "Material", TargetAimbot.HitChamsMaterial.Name, {
    Enum.Material.Neon.Name, 
    Enum.Material.SmoothPlastic.Name
}, function(a)
    TargetAimbot.HitChamsMaterial = Enum.Material[a]
end)

-- ============================================
-- MISC TAB
-- ============================================
local MiscTab = Menu.Tab("Misc")

-- Prediction Breaker Section
local MTSection1 = Menu.Container("Misc", "Prediction Breaker", "Left")
Menu.CheckBox("Misc", "Prediction Breaker", "Jump Prediction", getgenv().Sentinel.JumpBreak, function(a)
    getgenv().Sentinel.JumpBreak = a
end)

Menu.CheckBox("Misc", "Prediction Breaker", "Enable Anti Lock", getgenv().Desync, function(a)
    getgenv().Desync = a
end)

Menu.ComboBox("Misc", "Prediction Breaker", "Anti Lock Type", getgenv().AntiLockType, {
    "Behind", "Down", "ForWard", "Left", "One", "Right", "Up", "Zero"
}, function(a)
    getgenv().AntiLockType = a
end)

-- CFrame Speed Section
local MTSection2 = Menu.Container("Misc", "CFrame Speed", "Right")
Menu.CheckBox("Misc", "CFrame Speed", "Enabled", false, function(a)
    getgenv().Sentinel.cframespeedtoggle = a
end)

Menu.Slider("Misc", "CFrame Speed", "Speed", 0, 10, 3, '%', 1, function(a)
    getgenv().Sentinel.speedvalue = a
end)

-- Macro Section
local MTSectionS = Menu.Container("Misc", "Macro", "Right")
local MacroAlreadLoaded = false

Menu.Button("Misc", "Macro", "Load Macro", function()
    if MacroAlreadLoaded then
        print("Macro already loaded")
        return
    end
    MacroAlreadLoaded = true
    
    local MobileCameraFramework = {}
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

    -- GUI Setup
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextButton = Instance.new("ImageLabel")
    local TextLabel = Instance.new("TextButton")
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    ScreenGui.Parent = player.PlayerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.5
    Frame.Position = UDim2.new(1, -128, 0, 0)
    Frame.Size = UDim2.new(0, 90, 0, 32)

    TextButton.Parent = Frame
    TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.new(0, 26, 0, 26)
    TextButton.AnchorPoint = Vector2.new(0, 0.5)
    TextButton.Position = UDim2.new(0.05, 0, 0.5, 0)
    TextButton.Image = "rbxassetid://10734923214"

    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(0, 52, 0, 26)
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Position = UDim2.new(0.65, 0, 0.5, 0)
    TextLabel.Font = Enum.Font.Arimo
    TextLabel.Text = "Macro"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextScaled = true
    TextLabel.TextSize = 35
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextStrokeTransparency = 1

    local uiCorner = Instance.new("UICorner", Frame)
    uiCorner.CornerRadius = UDim.new(0, 8)

    local MCenabled = false
    TextLabel.MouseButton1Down:Connect(function()
        MCenabled = not MCenabled
        print(MCenabled)
        if MCenabled then
            TextButton.Image = "rbxassetid://10735024209"
        else
            TextButton.Image = "rbxassetid://10734923214"
            DisableShiftlock()
        end
    end)

    UITextSizeConstraint.Parent = TextLabel
    UITextSizeConstraint.MaxTextSize = 30

    player.CharacterAdded:Connect(function(character)
        ScreenGui.Parent = player.PlayerGui
    end)

    player.CharacterRemoving:Connect(function()
        ScreenGui.Parent = nil
    end)

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
            active:Disconnect()
            active = nil
        end)
    end

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)

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

    while task.wait(getgenv().Sentinel.MacroSpeed) do
        ShiftLock()
    end
end, "Click to toggle the macro")

Menu.TextBox("Misc", "Macro", "Speed", tostring(getgenv().Sentinel.MacroSpeed), function(a)
    getgenv().Sentinel.MacroSpeed = tonumber(a) or 0.1
end)

-- Aura Section
local aurasec2 = Menu.Container("Misc", "Aura", "Right")
Menu.CheckBox("Misc", "Aura", "Enabled", false, function(y)
    -- Aura implementation would go here
end)

-- Fly Section
local MTSection3 = Menu.Container("Misc", "Fly", "Right")
Menu.CheckBox("Misc", "Fly", "Enabled", false, function(a)
    -- Fly implementation
end)

Menu.Hotkey("Misc", "Fly", "Keybind", Enum.KeyCode.X, function(a)
    -- Fly keybind
end)

Menu.CheckBox("Misc", "Fly", "Notification", false, function(a)
    -- Fly notification
end)

Menu.Slider("Misc", "Fly", "Speed", 0, 30, 5, '%', 1, function(a)
    -- Fly speed
end)

-- Network Anti Section
local MTSection4 = Menu.Container("Misc", "Network Anti", "Left")
Menu.CheckBox("Misc", "Network Anti", "Enabled", getgenv().Sentinel.network, function(a)
    getgenv().Sentinel.network = a
end)

-- Trash Talk Section
local MTSection5 = Menu.Container("Misc", "Trash Talk", "Left")
Menu.CheckBox("Misc", "Trash Talk", "Enabled", false, function(a)
    -- Trash talk implementation
end)

Menu.CheckBox("Misc", "Trash Talk", "Target", false, function(a)
    -- Trash talk target
end)

Menu.CheckBox("Misc", "Trash Talk", "Notification", false, function(a)
    -- Trash talk notification
end)

Menu.CheckBox("Misc", "Trash Talk", "Use Keybind", false, function(a)
    -- Trash talk keybind toggle
end)

Menu.Hotkey("Misc", "Trash Talk", "Keybind", Enum.KeyCode.B, function(a)
    -- Trash talk keybind
end)

-- Set Menu Title and Initialize
Menu:SetTitle("Cactus.GG")
Menu:SetVisible(true)
Menu:Init()

-- ============================================
-- CORE FUNCTIONALITY
-- ============================================

-- Connection Helper
Script.Functions.Connection = function(ConnectionType: any, Function: any)
    local Connection = ConnectionType:Connect(Function)
    return Connection
end

-- Visualize Movement
Script.Functions.VisualizeMovement = function()
    if Settings.Combat.Skibidi then
        local Character = game.Players.LocalPlayer and (game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait())
        local RootPart = Character and Character.HumanoidRootPart
        local Ball = Instance.new('Part')
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
        game:GetService("Debris"):AddItem(Ball, 2)
    end
end

-- Target Variables
local TargBindEnabled = true
local TargetPlr
local TargResolvePos

-- Target Highlight
local TargHighlight = Instance.new("Highlight")
TargHighlight.Parent = CoreGui
TargHighlight.FillColor = TargetAimbot.HighlightColor1
TargHighlight.OutlineColor = TargetAimbot.HighlightColor2
TargHighlight.FillTransparency = 0.5
TargHighlight.OutlineTransparency = 0
TargHighlight.Enabled = false

-- Tracer
local Tracer = Drawing.new("Line")
Tracer.Visible = false
Tracer.Color = Color3.fromRGB(154, 7, 250)
Tracer.Thickness = 1
Tracer.Transparency = 1

-- Hit Effect Module Setup
local HitEffectModule = {
    Locals = {
        Type = {}
    },
    Functions = {},
    Settings = {HitEffect = {Color = TargetAimbot.HitEffectColor}}
}

local HitChamsFolder = Instance.new("Folder")
HitChamsFolder.Name = "HitChamsFolder"
HitChamsFolder.Parent = Workspace

-- Attachment for Hit Effects
local Attachment = Instance.new("Attachment")

-- Create all Hit Effect Types (simplified - full implementations would include all particle emitters)
-- Crescent Slash
do
    local Insane = Instance.new("Part")
    Insane.Parent = ReplicatedStorage
    local Attachment = Instance.new("Attachment")
    Attachment.Name = "Attachment"
    Attachment.Parent = Insane
    HitEffectModule.Locals.Type["Crescent Slash"] = Attachment
    
    -- Add particle emitters here (simplified for space)
    Insane.Parent = workspace
end

-- Cosmic Explosion
do
    local Part = Instance.new("Part")
    Part.Parent = ReplicatedStorage
    local Attachment = Instance.new("Attachment")
    Attachment.Name = "Attachment"
    Attachment.Parent = Part
    HitEffectModule.Locals.Type["Cosmic Explosion"] = Attachment
    Part.Parent = workspace
end

-- Coom
do
    local Part = Instance.new("Part")
    Part.Parent = ReplicatedStorage
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Part
    HitEffectModule.Locals.Type["Coom"] = Attachment
    Part.Parent = workspace
end

-- Slash
do
    local Part = Instance.new("Part")
    Part.Parent = ReplicatedStorage
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Part
    HitEffectModule.Locals.Type["Slash"] = Attachment
    Part.Parent = workspace
end

-- Atomic Slash
do
    local Part = Instance.new("Part")
    Part.Parent = ReplicatedStorage
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Part
    HitEffectModule.Locals.Type["Atomic Slash"] = Attachment
    Part.Parent = workspace
end

-- Nova
do
    local part = Instance.new("Part")
    part.Parent = ReplicatedStorage
    local attachment = Instance.new("Attachment")
    attachment.Name = "Attachment"
    attachment.Parent = part
    HitEffectModule.Locals.Type["Nova"] = attachment
end

-- Additional Hit Effects (Aura, Electric, Swirl, etc.)
do
    local Part = Instance.new("Part")
    Part.Parent = ReplicatedStorage
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Part
    HitEffectModule.Locals.Type["Aura"] = Attachment
    HitEffectModule.Locals.Type["Electric"] = Attachment
    HitEffectModule.Locals.Type["swirl"] = Attachment
    HitEffectModule.Locals.Type["AuraBurst"] = Attachment
    HitEffectModule.Locals.Type["Shock3"] = Attachment
    HitEffectModule.Locals.Type["Thunder"] = Attachment
    HitEffectModule.Locals.Type["Circle"] = Attachment
end

-- Hit Effect Function
HitEffectModule.Functions.Effect = function(character, color)
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local effectType = HitEffectModule.Locals.Type[TargetAimbot.HitEffectType]
    if not effectType then return end
    
    local effectAttachment = effectType:Clone()
    effectAttachment.Parent = humanoidRootPart

    for _, emitter in pairs(effectAttachment:GetChildren()) do
        if emitter:IsA("ParticleEmitter") then
            emitter.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.495, TargetAimbot.HitEffectColor),
                ColorSequenceKeypoint.new(1, TargetAimbot.HitEffectColor)
            })
            
            if TargetAimbot.HitEffect then
                emitter.Enabled = true
                emitter:Emit(emitter.Rate)
            end
        end
    end

    task.delay(2, function()
        if effectAttachment and effectAttachment.Parent then
            effectAttachment:Destroy()
        end
    end)
end

-- Play Hit Sound
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

-- Hit Chams Function
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
                BodyPart.Transparency = TargetAimbot.HitChamsTransparency
                BodyPart.Color = TargetAimbot.HitChamsColor
                BodyPart.Material = TargetAimbot.HitChamsMaterial
            end
        end

        if Cloned:FindFirstChild("Head") then
            local Head = Cloned.Head
            Head.Transparency = TargetAimbot.HitChamsTransparency
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

-- Target Health Tracking
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
                
                PlayHitSound()
                HitEffectModule.Functions.Effect(TargetPlr.Character)
                HitChams(TargetPlr)
            end
            target_health = currentHealth
        end
    end
end

-- Highlight Update
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

-- CSync Visualization
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

nigga["CFrameVisualize"] = game:GetObjects("rbxassetid://9474737816")[1]
nigga["CFrameVisualize"].Head.Face:Destroy()
for _, v in pairs(nigga["CFrameVisualize"]:GetChildren()) do
    v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.70
    v.Material = "Neon"
    v.Color = Color3.fromRGB(153,0,153)
    v.CanCollide = false
    v.Anchored = false
end

game:GetService('RunService').Heartbeat:Connect(function()
    nigga["CFrameVisualize"].Parent = TargetAimbot.CSync.Enabled and IgnoreFolder or nil
    if TargetAimbot.CSync.Enabled and TargetPlr then
        local FakeCFrame = Client.Character.HumanoidRootPart.CFrame
        Saved = Client.Character.HumanoidRootPart.CFrame
        if TargBindEnabled and TargetAimbot.CSync.Type == "Random" then
            FakeCFrame = CFrame.new(TargetPlr.Character.HumanoidRootPart.Position + Vector3.new(math.random(-TargetAimbot.CSync.RandomAmount, TargetAimbot.CSync.RandomAmount), math.random(-0, TargetAimbot.CSync.RandomAmount), math.random(-TargetAimbot.CSync.RandomAmount, TargetAimbot.CSync.RandomAmount))) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))
        elseif TargBindEnabled and TargetAimbot.CSync.Type == "Orbit" then
            local CurrentTime = tick()
            FakeCFrame = CFrame.new(TargetPlr.Character.HumanoidRootPart.Position) * CFrame.Angles(0, 2 * math.pi * CurrentTime * TargetAimbot.CSync.Speed % (2 * math.pi), 0) * CFrame.new(0, TargetAimbot.CSync.Height, TargetAimbot.CSync.Distance)
        end

        nigga["CFrameVisualize"]:SetPrimaryPartCFrame(FakeCFrame)

        for _, Part in pairs(nigga["CFrameVisualize"]:GetChildren()) do
            Part.Color = TargetAimbot.CSync.Color
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

-- FOV Circle
local FOV43 = Drawing.new("Circle")
FOV43.Transparency = 0.5
FOV43.Thickness = 2
FOV43.Color = Color3.new(1, 0, 0)
FOV43.Filled = false
FOV43.Radius = 250
FOV43.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
FOV43.Visible = false

-- Lock Button GUI
local Sigmaballs = Instance.new("ScreenGui")
Sigmaballs.Name = "Sigmaballs"
Sigmaballs.Parent = game.CoreGui
Sigmaballs.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Sigmaballs.ResetOnSpawn = false

local Button = Instance.new("TextButton")
Button.Name = "FlyButton"
Button.Parent = Sigmaballs
Button.Active = true
Button.Draggable = true
Button.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
Button.BackgroundTransparency = 0
Button.BorderSizePixel = 0
Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0.5, -75, 0.5, -25)
Button.Font = Enum.Font.ArialBold
Button.Text = "Lock: " .. "<font color='rgb(255, 0, 0)'>OFF</font>"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 25
Button.RichText = true
Button.TextStrokeTransparency = 0.5

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Button

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = Button
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(16, 16, 32)

local stk = Instance.new("UIStroke")
stk.Parent = Button
stk.Thickness = 3
stk.Color = Color3.fromRGB(16, 16, 32)
stk.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Target Selection Function
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

-- Toggle Lock Function
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
            Button.Text = "Lock: " .. "<font color='rgb(255, 0, 0)'>OFF</font>"
            Menu.Notify("Untargeted", 2)
        else
            TargBindEnabled = true
            TargetPlr = closest
            if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
                target_health = TargetPlr.Character.Humanoid.Health
            else
                return
            end
            Button.Text = "Lock: " .. "<font color='rgb(0, 255, 0)'>ON</font>"
            Menu.Notify("Target Locked: " .. tostring(TargetPlr.DisplayName), 2)
        end
    end
end

Button.MouseButton1Click:Connect(toggle_lock)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.DPadDown then
        toggle_lock()
    end
end)

-- Sentinel Configuration
getgenv().Sentinel.LockType = "Namecall"
getgenv().Sentinel.RESOLVER = "MoveDirection"

-- Game Support
local game_support = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/script-khen/refs/heads/main/Argument.txt",true))()

local function getRemoteInfo()
    local placeId = game.PlaceId
    return game_support[placeId] or {Remote = "MainEvent", Argument = "UpdateMousePos"}
end

-- Prediction Position
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

-- Index Hook
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

-- Remote Hooking
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

-- Auto Shoot
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

-- Target Checking
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

-- Prediction Table
local predictionTable = {
    {20, 0.08960952}, {30, 0.11252476}, {50, 0.13544}, {65, 0.1264236}, {70, 0.12533},
    {80, 0.139340}, {100, 0.141987}, {110, 0.144634}, {120, 0.147281}, {130, 0.149928},
    {140, 0.152575}, {150, 0.155222}, {160, 0.157869}, {170, 0.160516}, {180, 0.163163},
    {190, 0.165810}, {200, 0.168457}, {210, 0.171104}, {220, 0.173751}, {230, 0.176398},
    {240, 0.179045}, {250, 0.181692}, {260, 0.184339}, {270, 0.186986}, {280, 0.189633},
    {290, 0.192280}, {300, 0.194927}
}

-- Update Prediction
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

-- Look At Player
function LookAtPlayer(Target)
    local localChar = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local localHumanoidRootPart = localChar:FindFirstChild("HumanoidRootPart")

    if localHumanoidRootPart then
        if getgenv().Sentinel and getgenv().Sentinel.LookAt and not (MCenabled or false) then
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

-- Nearest Part
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

-- CFrame Speed
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().Sentinel.cframespeedtoggle then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame +
            game.Players.LocalPlayer.Character.Humanoid.MoveDirection * getgenv().Sentinel.speedvalue / 0.5
    end
end)

-- Main Stepped Loop
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

-- Grenade TP
RunService.Heartbeat:Connect(function()
    if Script.Locals.GrenadeTP.Enabled and TargetPlr and TargetPlr.Character and workspace:FindFirstChild("Ignored") then
        if workspace.Ignored:FindFirstChild("Handle") then
            workspace.Ignored.Handle.Position = TargetPlr.Character[getgenv().Sentinel.SelectedPart].Position + (TargetPlr.Character[getgenv().Sentinel.SelectedPart].Velocity * getgenv().Sentinel.HorizontalPrediction)
        end
    end
end)

-- Rocket TP
if workspace:FindFirstChild("Ignored") then
    workspace.Ignored.ChildAdded:Connect(function(object)
        if Script.Locals.RocketTP.Enabled and 
           TargetPlr and 
           TargetPlr.Character and 
           (object.Name == "Model" or object.Name == "GrenadeLauncherAmmo") then
            
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

-- Camera Smoothing
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
            local fallOffset = getgenv().Sentinel.FallOffset or 0

            local verticalVelocity = velocity.Y
            local appliedVerticalOffset = verticalVelocity > 0 and jumpOffset or (verticalVelocity < 0 and -fallOffset or 0)

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

-- Jump Break
local Plr = game.Players.LocalPlayer

Plr.Character:WaitForChild("Humanoid").StateChanged:Connect(function(old, new)
    if getgenv().Sentinel.JumpBreak and new == Enum.HumanoidStateType.Freefall then
        wait(0.27)
        Plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, -15, 0)
    end
end)

-- Desync
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

-- Gun TP
local Client = game.Players.LocalPlayer
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

-- Spectate
game:GetService("RunService").RenderStepped:Connect(function()
    if Settings.Combat.Spectate and TargetPlr then
        game.Workspace.CurrentCamera.CameraSubject = TargetPlr.Character
    else
        game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
    end
end)

-- Network Anti
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

print("Cactus.GG Script Loaded - Redesigned UI with All Features")
