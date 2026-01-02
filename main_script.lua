-- Load custom UI library
local UI = require(script:WaitForChild("ui_library")) or loadstring(readfile("ui_library.lua"))()

-- Initialize Menu
local Menu = UI.new()
Menu:SetTitle("Cactus.GG [khen.cc]")
Menu:SetSize(500, 400)

task.spawn(function()
    Menu:Notify("Script Loaded.", 2)
end)

-- Script variables
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

-- Toggle button setup
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

-- Create Tabs
local CombatTab = Menu:Tab("Main")
local HvHTab = Menu:Tab("HvH")
local VisualsTab = Menu:Tab("Visuals")
local MiscTab = Menu:Tab("Misc")

-- Main Tab Containers
local TargetAimSection = Menu:Container("Main", "Target Aim", "Left")
Menu:CheckBox("Main", "Target Aim", "Enabled", getgenv().Sentinel.Enabled, function(a)
    getgenv().Sentinel.Enabled = a
end)

Menu:CheckBox("Main", "Target Aim", "Look At", getgenv().Sentinel.LookAt, function(a)
    getgenv().Sentinel.LookAt = a 
end)

local Highlight = false
Menu:CheckBox("Main", "Target Aim", "Highlight", false, function(a)
    Highlight = a
end)

Menu:CheckBox("Main", "Target Aim", "Auto Air", getgenv().Sentinel.AutoAir, function(a)
    getgenv().Sentinel.AutoAir = a
end)

Menu:CheckBox("Main", "Target Aim", "Resolver", getgenv().Sentinel.ResolverEnabled, function(a)
    getgenv().Sentinel.ResolverEnabled = a
end)

local HitPartSection = Menu:Container("Main", "HitPart", "Left")
Menu:CheckBox("Main", "HitPart", "NearestPart", getgenv().Sentinel.NearestPart, function(a) 
    getgenv().Sentinel.NearestPart = a
end)

Menu:ComboBox("Main", "HitPart", "BodyPart", "Body Part", {
    "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", 
    "LeftUpperArm", "LeftLowerArm", "LeftHand", 
    "RightUpperArm", "RightLowerArm", "RightHand", 
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", 
    "RightUpperLeg", "RightLowerLeg", "RightFoot"
}, function(a)
    getgenv().Sentinel.SelectedPart = a
end)

local PredictionSection = Menu:Container("Main", "Prediction", "Left")
Menu:CheckBox("Main", "Prediction", "Auto Prediction", true, function(a)
    getgenv().Sentinel.AutoPrediction = a
end)

Menu:ComboBox("Main","Prediction","LockType", "Namecall", {"Namecall","Index"}, function(a)
    getgenv().Sentinel.LockType = a
end)

Menu:TextBox("Main", "Prediction", "Horizontal", tostring(getgenv().Sentinel.HorizontalPrediction), function(a)
    getgenv().Sentinel.HorizontalPrediction2 = tonumber(a)
end)

local CameraContainer = Menu:Container("Main", "Camera", "Right")
Menu:CheckBox("Main", "Camera", "Enabled", getgenv().Sentinel.Camera, function(a)
    getgenv().Sentinel.Camera = a
end)

Menu:TextBox("Main", "Camera", "Smoothness", tostring(getgenv().Sentinel.smoothness), function(a)
    getgenv().Sentinel.smoothness = tonumber(a)
end)

Menu:ComboBox("Main", "Camera", "Easing Style", getgenv().Sentinel.easingStyle, {
    "Linear", "Quad", "Cubic", "Quart", "Quint", "Sine",
    "Exponential", "Circular", "Back", "Bounce", "Elastic"
}, function(Cock)
    getgenv().Sentinel.easingStyle = Cock
end)

Menu:ComboBox("Main", "Camera", "Easing Direction", getgenv().Sentinel.easingDirection, {
    "In", "Out", "InOut"
}, function(Cock)
    getgenv().Sentinel.easingDirection = Cock
end)

-- HvH Tab
local TeleportSection = Menu:Container("HvH", "Teleports", "Left")
Menu:CheckBox("HvH", "Teleports", "Grenade Tp", GrenadeTP, function(a)
    Script.Locals.GrenadeTP.Enabled = a
end)

Menu:CheckBox("HvH", "Teleports", "Rocket Tp", RocketTP, function(a)
    Script.Locals.RocketTP.Enabled = a
end)

local BulletTaP = Menu:Container("HvH", "Bullet-TP", "Left")
Menu:CheckBox("HvH", "Bullet-TP", "Bullet Gyatt", false, function(a) 
    Script.Locals.GunTP.Enabled = a
end)

Menu:CheckBox("HvH", "Bullet-TP", "Anchor", false, function(a) 
    Script.Locals.GunTP.Anchor = a
end)

Menu:TextBox("HvH", "Bullet-TP", "X", "0", function(a) Script.Locals.GunTP.Offset[1] = tonumber(a) or 0 end)
Menu:TextBox("HvH", "Bullet-TP", "Y", "-0.5", function(a) Script.Locals.GunTP.Offset[2] = tonumber(a) or -0.5 end)
Menu:TextBox("HvH", "Bullet-TP", "Z", "0", function(a) Script.Locals.GunTP.Offset[3] = tonumber(a) or 0 end)

local CSyncSection = Menu:Container("HvH", "CSync", "Right")
local TargetAimbot = {
    CSync = {
        Enabled = false,
        Type = "Orbit",
        Distance = 10,
        Height = 2,
        Speed = 10,
        RandomAmount = 10,
        Color = Color3.fromRGB(255, 255, 255),
    }
}

Menu:CheckBox("HvH", "CSync", "Enabled", TargetAimbot.CSync.Enabled, function(a)
    TargetAimbot.CSync.Enabled = a
end)

Menu:ComboBox("HvH", "CSync", "Type", TargetAimbot.CSync.Type, {"Orbit", "Random"}, function(a)
    TargetAimbot.CSync.Type = a
end)

Menu:Slider("HvH", "CSync", "Distance", 0, 20, TargetAimbot.CSync.Distance, '', 1, function(a)
    TargetAimbot.CSync.Distance = a
end)

Menu:Slider("HvH", "CSync", "Height", 0, 10, TargetAimbot.CSync.Height, '', 1, function(a)
    TargetAimbot.CSync.Height = a
end)

Menu:Slider("HvH", "CSync", "Speed", 0, 20, TargetAimbot.CSync.Speed, '', 1, function(a)
    TargetAimbot.CSync.Speed = a
end)

Menu:Slider("HvH", "CSync", "Random Amount", 0, 20, TargetAimbot.CSync.RandomAmount, '', 1, function(a)
    TargetAimbot.CSync.RandomAmount = a
end)

-- Visuals Tab
local HitDetectionSection = Menu:Container("Visuals", "Hit Detection", "Left")
TargetAimbot.HitEffect = true
TargetAimbot.HitSounds = true
TargetAimbot.HitEffectType = "Coom"
TargetAimbot.HitSound = "Bameware"
TargetAimbot.HighlightColor1 = Color3.fromRGB(144, 238, 144)
TargetAimbot.HighlightColor2 = Color3.fromRGB(144, 238, 144)
TargetAimbot.HitEffectColor = Color3.fromRGB(144, 238, 144)

Menu:CheckBox("Visuals", "Hit Detection", "Hit Effect", TargetAimbot.HitEffect, function(a) 
    TargetAimbot.HitEffect = a
end)

Menu:CheckBox("Visuals", "Hit Detection", "Hit Sound", TargetAimbot.HitSounds, function(a)
    TargetAimbot.HitSounds = a
end)

local Hitnotify = false
Menu:CheckBox("Visuals", "Hit Detection", "Notify", false, function(a) 
    Hitnotify = a
end)

Menu:ComboBox("Visuals", "Hit Detection", "Effect Type", TargetAimbot.HitEffectType, {
    "Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", 
    "Circle Shot", "Bolt", "Aura", "Electric", "Shock", "Thunder"
}, function(a)
    TargetAimbot.HitEffectType = a
end)

Menu:ComboBox("Visuals", "Hit Detection", "Sound Type", TargetAimbot.HitSound, {
    "RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", 
    "Gamesense", "Rust", "BlackPencil"
}, function(a)
    TargetAimbot.HitSound = a
end)

Menu:ColorPicker("Visuals", "Hit Detection", "Highlight fill", Color3.fromRGB(144, 238, 144), 0, function(a)
    TargetAimbot.HighlightColor1 = a
end)

Menu:ColorPicker("Visuals", "Hit Detection", "Highlight Outline", Color3.fromRGB(144, 238, 144), 0, function(a)
    TargetAimbot.HighlightColor2 = a
end)

Menu:ColorPicker("Visuals", "Hit Detection", "Hit Effect Color", Color3.fromRGB(144, 238, 144), 0, function(a)
    TargetAimbot.HitEffectColor = a
end)

Menu:ColorPicker("Visuals", "Hit Detection", "Visualizer", Color3.fromRGB(144, 238, 144), 0, function(a)
    TargetAimbot.CSync.Color = a
end)

local HitChamsSection = Menu:Container("Visuals", "Hit Chams", "Right")
TargetAimbot.HitChams = false
TargetAimbot.HitChamsColor = Color3.fromRGB(173, 216, 230)
TargetAimbot.HitChamsDuration = 1
TargetAimbot.HitChamsMaterial = Enum.Material.Neon

Menu:CheckBox("Visuals", "Hit Chams", "Enabled", TargetAimbot.HitChams, function(a)
    TargetAimbot.HitChams = a
end)

Menu:ColorPicker("Visuals", "Hit Chams", "Color", TargetAimbot.HitChamsColor, 0, function(a)
    TargetAimbot.HitChamsColor = a
end)

Menu:Slider("Visuals", "Hit Chams", "Duration", 0, 5, TargetAimbot.HitChamsDuration, '', 1, function(a)
    TargetAimbot.HitChamsDuration = a
end)

Menu:ComboBox("Visuals", "Hit Chams", "Material", TargetAimbot.HitChamsMaterial.Name, {
    Enum.Material.Neon.Name, Enum.Material.SmoothPlastic.Name
}, function(a)
    TargetAimbot.HitChamsMaterial = Enum.Material[a]
end)

-- Misc Tab
local MTSection1 = Menu:Container("Misc", "Prediction Breaker", "Left")
Menu:CheckBox("Misc", "Prediction Breaker", "Jump Prediction", getgenv().Sentinel.JumpBreak, function(a)
    getgenv().Sentinel.JumpBreak = a
end)

Menu:CheckBox("Misc", "Prediction Breaker", "Enable Anti Lock", getgenv().Desync, function(a)
    getgenv().Desync = a
end)

Menu:ComboBox("Misc", "Prediction Breaker", "Anti Lock Type", getgenv().AntiLockType, {
    "Behind", "Down", "ForWard", "Left", "One", "Right", "Up", "Zero"
}, function(a)
    getgenv().AntiLockType = a
end)

local MTSection2 = Menu:Container("Misc", "CFrame Speed", "Right")
Menu:CheckBox("Misc", "CFrame Speed", "Enabled", false, function(a)
    getgenv().Sentinel.cframespeedtoggle = a
end)

Menu:Slider("Misc", "CFrame Speed", "Speed", 0, 10, 3, '%', 1, function(a)
    getgenv().Sentinel.speedvalue = a
end)

local MTSectionS = Menu:Container("Misc", "Macro", "Right")
local MacroAlreadLoaded = false
Menu:Button("Misc", "Macro", "Load Macro", function()
    if MacroAlreadLoaded then
        print("hi")
        return
    end
    MacroAlreadLoaded = true
    -- Macro code would go here
    Menu:Notify("Macro Loaded", 2)
end)

Menu:TextBox("Misc", "Macro", "Speed", tostring(getgenv().Sentinel.MacroSpeed), function(a)
    getgenv().Sentinel.MacroSpeed = tonumber(a)
end)

local MTSection3 = Menu:Container("Misc", "Fly", "Right")
Menu:CheckBox("Misc", "Fly", "Enabled", false, function(a)
    -- Fly functionality
end)

Menu:Hotkey("Misc", "Fly", "Keybind", Enum.KeyCode.X, function(a)
    -- Fly keybind
end)

Menu:CheckBox("Misc", "Fly", "Notification", false, function(a)
    -- Notification toggle
end)

Menu:Slider("Misc", "Fly", "Speed", 0, 30, 5, '%', 1, function(a)
    -- Fly speed
end)

local MTSection4 = Menu:Container("Misc", "Network Anti", "Left")
Menu:CheckBox("Misc", "Network Anti", "Enabled", getgenv().Sentinel.network, function(a)
    getgenv().Sentinel.network = a
end)

local MTSection5 = Menu:Container("Misc", "Trash Talk", "Left")
Menu:CheckBox("Misc", "Trash Talk", "Enabled", false, function(a)
    -- Trash talk enabled
end)

Menu:CheckBox("Misc", "Trash Talk", "Target", false, function(a)
    -- Target only
end)

Menu:CheckBox("Misc", "Trash Talk", "Notification", false, function(a)
    -- Notification
end)

Menu:CheckBox("Misc", "Trash Talk", "Use Keybind", false, function(a)
    -- Use keybind
end)

Menu:Hotkey("Misc", "Trash Talk", "Keybind", Enum.KeyCode.B, function(a)
    -- Keybind
end)

-- Initialize Menu
Menu:Init()
Menu:SetVisible(true)

-- Rest of your script code continues here...
-- (All the hit effects, particle emitters, aimbot logic, etc.)

print("UI Rebuilt from scratch!")
