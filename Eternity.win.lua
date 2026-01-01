-- Eternity.win
-- Custom UI Script with All Features

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Wait for character
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Script Tables
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
    AuraIgnoreFolder = Instance.new("Folder", Workspace)
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
    network = false,
    LockType = "Namecall",
    RESOLVER = "MoveDirection",
    cframespeedtoggle = false
}

local GrenadeTP = false
local RocketTP = false
getgenv().Desync = false
getgenv().AntiLockType = "Behind"
getgenv().Direction = Vector3.new(0, 0, -1)

-- Trail Effect
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
local TargBindEnabled = true
local TargetPlr = nil
local TargResolvePos = nil
local target_health = nil

-- Highlight Setup
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

-- Hit Effect Module
local HitEffectModule = {
    Locals = {
        Type = {
            ["Nova"] = nil,
            ["Crescent Slash"] = nil,
            ["Coom"] = nil,
            ["Cosmic Explosion"] = nil,
            ["Slash"] = nil,
            ["Atomic Slash"] = nil,
        },
    },
    Functions = {},
    Settings = {HitEffect = {Color = TargetAimbot.HitEffectColor}}
}

-- Crescent Slash Effect
do
    local Insane = Instance.new("Part")
    Insane.Parent = ReplicatedStorage
    local Attachment = Instance.new("Attachment")
    Attachment.Name = "Attachment"
    Attachment.Parent = Insane
    HitEffectModule.Locals.Type["Crescent Slash"] = Attachment

    local Glow = Instance.new("ParticleEmitter")
    Glow.Name = "Glow"
    Glow.Lifetime = NumberRange.new(0.16, 0.16)
    Glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)})
    Glow.Color = ColorSequence.new(Color3.fromRGB(91, 177, 252))
    Glow.Speed = NumberRange.new(0, 0)
    Glow.Brightness = 5
    Glow.Size = NumberSequence.new(9.1873131, 16.5032349)
    Glow.Enabled = false
    Glow.ZOffset = -0.0565939
    Glow.Rate = 50
    Glow.Texture = "rbxassetid://8708637750"
    Glow.Parent = Attachment

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

    Insane.Parent = workspace
end

-- Cosmic Explosion Effect
do
    local Part = Instance.new("Part")
    Part.Parent = ReplicatedStorage
    local Attachment = Instance.new("Attachment")
    Attachment.Name = "Attachment"
    Attachment.Parent = Part
    HitEffectModule.Locals.Type["Cosmic Explosion"] = Attachment

    local Glow = Instance.new("ParticleEmitter")
    Glow.Name = "Glow"
    Glow.Lifetime = NumberRange.new(0.16, 0.16)
    Glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)})
    Glow.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
    Glow.Speed = NumberRange.new(0, 0)
    Glow.Brightness = 5
    Glow.Size = NumberSequence.new(9.1873131, 16.5032349)
    Glow.Enabled = false
    Glow.ZOffset = -0.0565939
    Glow.Rate = 50
    Glow.Texture = "rbxassetid://8708637750"
    Glow.Parent = Attachment

    Part.Parent = workspace
end

-- Coom Effect
do
    local Part = Instance.new("Part")
    Part.Parent = ReplicatedStorage
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Part
    HitEffectModule.Locals.Type["Coom"] = Attachment

    local Foam = Instance.new("ParticleEmitter")
    Foam.Name = "Foam"
    Foam.LightInfluence = 0.5
    Foam.Lifetime = NumberRange.new(1, 1)
    Foam.SpreadAngle = Vector2.new(360, -360)
    Foam.VelocitySpread = 360
    Foam.Squash = NumberSequence.new(1)
    Foam.Speed = NumberRange.new(20, 20)
    Foam.Brightness = 2.5
    Foam.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.1016692, 0.6508875, 0.6508875), NumberSequenceKeypoint.new(0.6494689, 1.4201183, 0.4127519), NumberSequenceKeypoint.new(1, 0)})
    Foam.Enabled = false
    Foam.Acceleration = Vector3.new(0, -66.04029846191406, 0)
    Foam.Rate = 100
    Foam.Texture = "rbxassetid://8297030850"
    Foam.Rotation = NumberRange.new(-90, -90)
    Foam.Orientation = Enum.ParticleOrientation.VelocityParallel
    Foam.Parent = Attachment

    Part.Parent = workspace
end

-- Atomic Slash Effect
do
    local Part = Instance.new("Part")
    Part.Parent = ReplicatedStorage
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Part
    HitEffectModule.Locals.Type["Atomic Slash"] = Attachment

    local Crescents = Instance.new("ParticleEmitter")
    Crescents.Name = "Crescents"
    Crescents.Lifetime = NumberRange.new(0.19, 0.38)
    Crescents.SpreadAngle = Vector2.new(-360, 360)
    Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
    Crescents.LightEmission = 10
    Crescents.Color = ColorSequence.new(Color3.fromRGB(160, 96, 255))
    Crescents.VelocitySpread = -360
    Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
    Crescents.Brightness = 4
    Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
    Crescents.Enabled = false
    Crescents.ZOffset = 0.4542207
    Crescents.Rate = 50
    Crescents.Texture = "rbxassetid://12509373457"
    Crescents.RotSpeed = NumberRange.new(800, 1000)
    Crescents.Rotation = NumberRange.new(-360, 360)
    Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
    Crescents.Parent = Attachment

    Part.Parent = workspace
end

-- Nova Effect
do
    local part = Instance.new("Part")
    part.Parent = ReplicatedStorage
    local attachment = Instance.new("Attachment")
    attachment.Name = "Attachment"
    attachment.Parent = part
    HitEffectModule.Locals.Type["Nova"] = attachment

    local function createParticleEmitter(acceleration)
        local emitter = Instance.new("ParticleEmitter")
        emitter.Name = "ParticleEmitter"
        emitter.Acceleration = acceleration
        emitter.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.495, HitEffectModule.Settings.HitEffect.Color),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        })
        emitter.Lifetime = NumberRange.new(0.5, 0.5)
        emitter.LightEmission = 1
        emitter.LockedToPart = true
        emitter.Rate = 1
        emitter.Rotation = NumberRange.new(0, 360)
        emitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 10),
            NumberSequenceKeypoint.new(1, 1)
        })
        emitter.Speed = NumberRange.new(0, 0)
        emitter.Texture = "rbxassetid://1084991215"
        emitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.534, 0.25),
            NumberSequenceKeypoint.new(1, 0.5),
            NumberSequenceKeypoint.new(1, 0)
        })
        emitter.ZOffset = 1
        emitter.Parent = attachment
        return emitter
    end

    createParticleEmitter(Vector3.new(0, 0, 1))
    local perpendicularEmitter = createParticleEmitter(Vector3.new(0, 1, -0.001))
    perpendicularEmitter.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
end

local HitChamsFolder = Instance.new("Folder")
HitChamsFolder.Name = "HitChamsFolder"
HitChamsFolder.Parent = Workspace

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
                emitter:Emit()
            end
        end
    end

    task.delay(2, function()
        if effectAttachment and effectAttachment.Parent then
            effectAttachment:Destroy()
        end
    end)
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

local function updatetarget_health()
    if TargBindEnabled and TargetPlr and TargetPlr.Character then
        local humanoid = TargetPlr.Character:FindFirstChild("Humanoid")
        if humanoid then
            local currentHealth = humanoid.Health
            if target_health and currentHealth < target_health then
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

-- FOV Circle
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
    local CC = workspace.CurrentCamera
    local screenCenter = Vector2.new(CC.ViewportSize.X / 2, CC.ViewportSize.Y / 2)
    local fovRadius = FOV43.Radius
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
        else
            TargBindEnabled = true
            TargetPlr = closest
            if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
                target_health = TargetPlr.Character.Humanoid.Health
            else
                return
            end
        end
    end
end

-- Custom UI Creation with Tabs
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "EternityUI"
MainGui.Parent = game.CoreGui
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(100, 100, 100)
UIStroke.Transparency = 0.5

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Position = UDim2.new(0, 0, 0, 0)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Eternity.win"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = TitleBar
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.BorderSizePixel = 0
ToggleButton.Size = UDim2.new(0, 25, 0, 25)
ToggleButton.Position = UDim2.new(1, -60, 0, 5)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "-"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 5)
ToggleCorner.Parent = ToggleButton

local LockButton = Instance.new("TextButton")
LockButton.Name = "LockButton"
LockButton.Parent = TitleBar
LockButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LockButton.BorderSizePixel = 0
LockButton.Size = UDim2.new(0, 25, 0, 25)
LockButton.Position = UDim2.new(1, -30, 0, 5)
LockButton.Font = Enum.Font.GothamBold
LockButton.Text = "🔒"
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.TextSize = 12

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 5)
LockCorner.Parent = LockButton

-- Tabs Container
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Parent = MainFrame
TabsContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TabsContainer.BorderSizePixel = 0
TabsContainer.Size = UDim2.new(1, 0, 0, 35)
TabsContainer.Position = UDim2.new(0, 0, 0, 35)

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.Parent = TabsContainer
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

-- Content Frame (Scrollable)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Size = UDim2.new(1, -10, 1, -75)
ContentFrame.Position = UDim2.new(0, 5, 0, 70)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- UI Toggle Button (Top Right Corner)
local UIToggleButton = Instance.new("TextButton")
UIToggleButton.Name = "UIToggleButton"
UIToggleButton.Parent = game.CoreGui
UIToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
UIToggleButton.BorderSizePixel = 0
UIToggleButton.Size = UDim2.new(0, 45, 0, 45)
UIToggleButton.Position = UDim2.new(1, -55, 0, 10)
UIToggleButton.Font = Enum.Font.GothamBold
UIToggleButton.Text = "☰"
UIToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UIToggleButton.TextSize = 20

local UIToggleCorner = Instance.new("UICorner")
UIToggleCorner.CornerRadius = UDim.new(0, 8)
UIToggleCorner.Parent = UIToggleButton

local UIToggleStroke = Instance.new("UIStroke")
UIToggleStroke.Parent = UIToggleButton
UIToggleStroke.Thickness = 2
UIToggleStroke.Color = Color3.fromRGB(100, 100, 100)

-- Lock Button for Target Aim (Draggable)
local AimLockButton = Instance.new("TextButton")
AimLockButton.Name = "AimLockButton"
AimLockButton.Parent = game.CoreGui
AimLockButton.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
AimLockButton.BorderSizePixel = 0
AimLockButton.Size = UDim2.new(0, 130, 0, 45)
AimLockButton.Position = UDim2.new(0.5, -65, 1, -60)
AimLockButton.Font = Enum.Font.ArialBold
AimLockButton.Text = "Lock: " .. "<font color='rgb(255, 0, 0)'>OFF</font>"
AimLockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimLockButton.TextSize = 22
AimLockButton.RichText = true
AimLockButton.TextStrokeTransparency = 0.5

local AimLockCorner = Instance.new("UICorner")
AimLockCorner.CornerRadius = UDim.new(0, 8)
AimLockCorner.Parent = AimLockButton

local AimLockStroke = Instance.new("UIStroke")
AimLockStroke.Parent = AimLockButton
AimLockStroke.Thickness = 2
AimLockStroke.Color = Color3.fromRGB(16, 16, 32)

-- Dragging functionality for Main UI
local dragging = false
local dragInput, dragStart, startPos

local function updateMainUI(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not FrameLocked then
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

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateMainUI(input)
    end
end)

-- Dragging functionality for Lock Button
local lockDragging = false
local lockDragInput, lockDragStart, lockStartPos

local function updateLockButton(input)
    local delta = input.Position - lockDragStart
    AimLockButton.Position = UDim2.new(lockStartPos.X.Scale, lockStartPos.X.Offset + delta.X, lockStartPos.Y.Scale, lockStartPos.Y.Offset + delta.Y)
end

AimLockButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        lockDragging = true
        lockDragStart = input.Position
        lockStartPos = AimLockButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                lockDragging = false
            end
        end)
    end
end)

AimLockButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        lockDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == lockDragInput and lockDragging then
        updateLockButton(input)
    end
end)

-- UI Toggle
local FrameLocked = false
local UIMinimized = false

UIToggleButton.MouseButton1Click:Connect(function()
    MainGui.Enabled = not MainGui.Enabled
end)

ToggleButton.MouseButton1Click:Connect(function()
    UIMinimized = not UIMinimized
    if UIMinimized then
        MainFrame.Size = UDim2.new(0, 400, 0, 35)
        ContentFrame.Visible = false
        TabsContainer.Visible = false
        ToggleButton.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 400, 0, 450)
        ContentFrame.Visible = true
        TabsContainer.Visible = true
        ToggleButton.Text = "-"
    end
end)

LockButton.MouseButton1Click:Connect(function()
    FrameLocked = not FrameLocked
    if FrameLocked then
        LockButton.Text = "🔓"
        LockButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        LockButton.Text = "🔒"
        LockButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

AimLockButton.MouseButton1Click:Connect(function()
    toggle_lock()
    if TargBindEnabled then
        AimLockButton.Text = "Lock: " .. "<font color='rgb(0, 255, 0)'>ON</font>"
    else
        AimLockButton.Text = "Lock: " .. "<font color='rgb(255, 0, 0)'>OFF</font>"
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.DPadDown then
        toggle_lock()
        if TargBindEnabled then
            AimLockButton.Text = "Lock: " .. "<font color='rgb(0, 255, 0)'>ON</font>"
        else
            AimLockButton.Text = "Lock: " .. "<font color='rgb(255, 0, 0)'>OFF</font>"
        end
    end
end)

-- Tab System
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Parent = TabsContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(0, 100, 1, 0)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 12
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 5)
    TabCorner.Parent = TabButton
    
    local TabContent = Instance.new("Frame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = ContentFrame
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 0, 0)
    TabContent.Visible = false
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContent
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    
    TabButton.MouseButton1Click:Connect(function()
        -- Hide all tabs
        for _, tab in pairs(Tabs) do
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        -- Show selected tab
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentTab = TabContent
        
        -- Update canvas size
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.Size = UDim2.new(1, 0, 0, TabLayout.AbsoluteContentSize.Y)
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end)
    end)
    
    Tabs[name] = {
        Button = TabButton,
        Content = TabContent,
        Layout = TabLayout
    }
    
    return TabContent
end

-- Helper Functions for UI Elements
local function CreateToggle(parent, name, value, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 28)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 5)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 8, 0, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 12
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local Toggle = Instance.new("TextButton")
    Toggle.Parent = ToggleFrame
    Toggle.BackgroundColor3 = value and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    Toggle.BorderSizePixel = 0
    Toggle.Size = UDim2.new(0, 50, 0, 22)
    Toggle.Position = UDim2.new(1, -58, 0, 3)
    Toggle.Font = Enum.Font.GothamBold
    Toggle.Text = value and "ON" or "OFF"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.TextSize = 11
    
    local ToggleCorner2 = Instance.new("UICorner")
    ToggleCorner2.CornerRadius = UDim.new(0, 5)
    ToggleCorner2.Parent = Toggle
    
    local currentValue = value
    Toggle.MouseButton1Click:Connect(function()
        currentValue = not currentValue
        Toggle.BackgroundColor3 = currentValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        Toggle.Text = currentValue and "ON" or "OFF"
        if callback then callback(currentValue) end
    end)
end

local function CreateSlider(parent, name, min, max, current, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, 0, 0, 40)
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 5)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Size = UDim2.new(1, -10, 0, 18)
    SliderLabel.Position = UDim2.new(0, 8, 0, 2)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = name .. ": " .. tostring(current)
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 11
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Parent = SliderFrame
    SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Size = UDim2.new(1, -16, 0, 4)
    SliderTrack.Position = UDim2.new(0, 8, 0, 22)
    
    local SliderTrackCorner = Instance.new("UICorner")
    SliderTrackCorner.CornerRadius = UDim.new(0, 2)
    SliderTrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderTrack
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 2)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderTrack
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Size = UDim2.new(0, 12, 0, 12)
    SliderButton.Position = UDim2.new((current - min) / (max - min), -6, 0, -4)
    SliderButton.Text = ""
    
    local SliderButtonCorner = Instance.new("UICorner")
    SliderButtonCorner.CornerRadius = UDim.new(0, 6)
    SliderButtonCorner.Parent = SliderButton
    
    local dragging = false
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pos = input.Position.X - SliderTrack.AbsolutePosition.X
            local percent = math.clamp(pos / SliderTrack.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderButton.Position = UDim2.new(percent, -6, 0, -4)
            SliderLabel.Text = name .. ": " .. tostring(value)
            if callback then callback(value) end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - SliderTrack.AbsolutePosition.X
            local percent = math.clamp(pos / SliderTrack.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderButton.Position = UDim2.new(percent, -6, 0, -4)
            SliderLabel.Text = name .. ": " .. tostring(value)
            if callback then callback(value) end
        end
    end)
end

local function CreateDropdown(parent, name, options, current, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Size = UDim2.new(1, 0, 0, 28)
    DropdownFrame.ClipsDescendants = true
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 5)
    DropdownCorner.Parent = DropdownFrame
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Parent = DropdownFrame
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Size = UDim2.new(1, -60, 1, 0)
    DropdownLabel.Position = UDim2.new(0, 8, 0, 0)
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.Text = name .. ": " .. current
    DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownLabel.TextSize = 12
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Parent = DropdownFrame
    DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Size = UDim2.new(0, 50, 0, 22)
    DropdownButton.Position = UDim2.new(1, -58, 0, 3)
    DropdownButton.Font = Enum.Font.GothamBold
    DropdownButton.Text = "▼"
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.TextSize = 10
    
    local DropdownButtonCorner = Instance.new("UICorner")
    DropdownButtonCorner.CornerRadius = UDim.new(0, 5)
    DropdownButtonCorner.Parent = DropdownButton
    
    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Parent = DropdownFrame
    DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownList.BorderSizePixel = 0
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 1, 2)
    DropdownList.Visible = false
    DropdownList.ScrollBarThickness = 4
    
    local DropdownListLayout = Instance.new("UIListLayout")
    DropdownListLayout.Parent = DropdownList
    
    local opened = false
    DropdownButton.MouseButton1Click:Connect(function()
        opened = not opened
        DropdownList.Visible = opened
        DropdownButton.Text = opened and "▲" or "▼"
        
        if opened then
            DropdownList:ClearAllChildren()
            DropdownListLayout:ClearAllChildren()
            
            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Parent = DropdownList
                OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                OptionButton.BorderSizePixel = 0
                OptionButton.Size = UDim2.new(1, 0, 0, 25)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                OptionButton.TextSize = 11
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownLabel.Text = name .. ": " .. option
                    opened = false
                    DropdownList.Visible = false
                    DropdownButton.Text = "▼"
                    if callback then callback(option) end
                end)
            end
            
            DropdownList.Size = UDim2.new(1, 0, 0, math.min(#options * 25, 100))
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, #options * 25)
        end
    end)
end

local function CreateButton(parent, name, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Name = name
    ButtonFrame.Parent = parent
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.Text = name
    ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonFrame.TextSize = 12
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 5)
    ButtonCorner.Parent = ButtonFrame
    
    ButtonFrame.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- Create Tabs
local MainTab = CreateTab("Main")
local VisualsTab = CreateTab("Visuals")
local HvHTab = CreateTab("HvH")
local MiscTab = CreateTab("Misc")

-- Main Tab Settings
CreateToggle(MainTab, "Target Aim", getgenv().Sentinel.Enabled, function(val)
    getgenv().Sentinel.Enabled = val
end)

CreateToggle(MainTab, "Look At", getgenv().Sentinel.LookAt, function(val)
    getgenv().Sentinel.LookAt = val
end)

CreateToggle(MainTab, "Highlight", Highlight, function(val)
    Highlight = val
end)

CreateToggle(MainTab, "Auto Air", getgenv().Sentinel.AutoAir, function(val)
    getgenv().Sentinel.AutoAir = val
end)

CreateToggle(MainTab, "Resolver", getgenv().Sentinel.ResolverEnabled, function(val)
    getgenv().Sentinel.ResolverEnabled = val
end)

CreateToggle(MainTab, "Nearest Part", getgenv().Sentinel.NearestPart, function(val)
    getgenv().Sentinel.NearestPart = val
end)

CreateToggle(MainTab, "Auto Prediction", getgenv().Sentinel.AutoPrediction, function(val)
    getgenv().Sentinel.AutoPrediction = val
end)

CreateSlider(MainTab, "Horizontal Prediction", 0, 200, getgenv().Sentinel.HorizontalPrediction * 1000, function(val)
    getgenv().Sentinel.HorizontalPrediction = val / 1000
end)

CreateSlider(MainTab, "Smoothness", 0, 100, getgenv().Sentinel.smoothness * 100, function(val)
    getgenv().Sentinel.smoothness = val / 100
end)

CreateDropdown(MainTab, "Hit Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm"}, getgenv().Sentinel.SelectedPart, function(val)
    getgenv().Sentinel.SelectedPart = val
end)

CreateDropdown(MainTab, "Lock Type", {"Namecall", "Index"}, getgenv().Sentinel.LockType, function(val)
    getgenv().Sentinel.LockType = val
end)

-- Visuals Tab Settings
CreateToggle(VisualsTab, "Hit Effect", TargetAimbot.HitEffect, function(val)
    TargetAimbot.HitEffect = val
end)

CreateToggle(VisualsTab, "Hit Sound", TargetAimbot.HitSounds, function(val)
    TargetAimbot.HitSounds = val
end)

CreateToggle(VisualsTab, "Hit Chams", TargetAimbot.HitChams, function(val)
    TargetAimbot.HitChams = val
end)

CreateDropdown(VisualsTab, "Hit Effect Type", {"Nova", "Crescent Slash", "Coom", "Cosmic Explosion", "Atomic Slash"}, TargetAimbot.HitEffectType, function(val)
    TargetAimbot.HitEffectType = val
end)

CreateDropdown(VisualsTab, "Hit Sound Type", {"RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", "Gamesense", "Rust", "BlackPencil"}, TargetAimbot.HitSound, function(val)
    TargetAimbot.HitSound = val
end)

CreateSlider(VisualsTab, "Hit Chams Duration", 0, 500, TargetAimbot.HitChamsDuration * 100, function(val)
    TargetAimbot.HitChamsDuration = val / 100
end)

-- HvH Tab Settings
CreateToggle(HvHTab, "Grenade TP", Script.Locals.GrenadeTP.Enabled, function(val)
    Script.Locals.GrenadeTP.Enabled = val
end)

CreateToggle(HvHTab, "Rocket TP", Script.Locals.RocketTP.Enabled, function(val)
    Script.Locals.RocketTP.Enabled = val
end)

CreateToggle(HvHTab, "Bullet TP", Script.Locals.GunTP.Enabled, function(val)
    Script.Locals.GunTP.Enabled = val
end)

CreateToggle(HvHTab, "CSync", TargetAimbot.CSync.Enabled, function(val)
    TargetAimbot.CSync.Enabled = val
end)

CreateDropdown(HvHTab, "CSync Type", {"Orbit", "Random"}, TargetAimbot.CSync.Type, function(val)
    TargetAimbot.CSync.Type = val
end)

CreateSlider(HvHTab, "CSync Distance", 0, 200, TargetAimbot.CSync.Distance * 10, function(val)
    TargetAimbot.CSync.Distance = val / 10
end)

CreateSlider(HvHTab, "CSync Height", 0, 100, TargetAimbot.CSync.Height * 10, function(val)
    TargetAimbot.CSync.Height = val / 10
end)

CreateSlider(HvHTab, "CSync Speed", 0, 200, TargetAimbot.CSync.Speed * 10, function(val)
    TargetAimbot.CSync.Speed = val / 10
end)

-- Misc Tab Settings
CreateToggle(MiscTab, "Camera", getgenv().Sentinel.Camera, function(val)
    getgenv().Sentinel.Camera = val
end)

CreateToggle(MiscTab, "Network Anti", getgenv().Sentinel.network, function(val)
    getgenv().Sentinel.network = val
end)

CreateToggle(MiscTab, "Jump Break", getgenv().Sentinel.JumpBreak, function(val)
    getgenv().Sentinel.JumpBreak = val
end)

CreateToggle(MiscTab, "Anti Lock", getgenv().Desync, function(val)
    getgenv().Desync = val
end)

CreateDropdown(MiscTab, "Anti Lock Type", {"Behind", "Down", "ForWard", "Left", "One", "Right", "Up", "Zero"}, getgenv().AntiLockType, function(val)
    getgenv().AntiLockType = val
end)

CreateSlider(MiscTab, "CFrame Speed", 0, 100, getgenv().Sentinel.speedvalue * 10, function(val)
    getgenv().Sentinel.speedvalue = val / 10
end)

CreateToggle(MiscTab, "CFrame Speed Toggle", getgenv().Sentinel.cframespeedtoggle, function(val)
    getgenv().Sentinel.cframespeedtoggle = val
end)

CreateDropdown(MiscTab, "Easing Style", {"Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Exponential", "Circular", "Back", "Bounce", "Elastic"}, getgenv().Sentinel.easingStyle, function(val)
    getgenv().Sentinel.easingStyle = val
end)

CreateDropdown(MiscTab, "Easing Direction", {"In", "Out", "InOut"}, getgenv().Sentinel.easingDirection, function(val)
    getgenv().Sentinel.easingDirection = val
end)

-- Set first tab as active
if Tabs["Main"] then
    Tabs["Main"].Button.MouseButton1Click:Fire()
end

-- Update canvas size on layout change
for tabName, tab in pairs(Tabs) do
    tab.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.Size = UDim2.new(1, 0, 0, tab.Layout.AbsoluteContentSize.Y)
        if CurrentTab == tab.Content then
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y + 10)
        end
    end)
end

-- Game Support
local game_support = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/script-khen/refs/heads/main/Argument.txt",true))()

local function getRemoteInfo()
    local placeId = game.PlaceId
    return game_support[placeId] or {Remote = "MainEvent", Argument = "UpdateMousePos"}
end

local function predictedposition()
    if not TargetPlr or not TargetPlr.Character then return nil end
    local selectedPart = getgenv().Sentinel.SelectedPart
    local targetPart = TargetPlr.Character:FindFirstChild(selectedPart)
    if not targetPart then return nil end

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

RunService.PostSimulation:Connect(function(DeltaTime)
    if getgenv().Sentinel.Enabled then
        if getgenv().Sentinel.LockType == "Index" then
            local LocalFramework = LocalPlayer.PlayerGui:FindFirstChild("Framework")
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

-- Hooking
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
                        local targetPart = TargetPlr.Character and TargetPlr.Character:FindFirstChild(selectedPart)

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
                            args[i] = targetPart.Position + (velocity * horizontalPrediction)
                        end
                    end
                    return __namecall(Self, unpack(args))
                elseif type(arg) == "table" then
                    for index, element in ipairs(arg) do
                        if typeof(element) == "Vector3" then
                            if TargetPlr and getgenv().Sentinel.Enabled and getgenv().Sentinel.LockType == "Namecall" then
                                local selectedPart = getgenv().Sentinel.SelectedPart
                                local targetPart = TargetPlr.Character and TargetPlr.Character:FindFirstChild(selectedPart)

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
                                    arg[index] = targetPart.Position + (velocity * horizontalPrediction)
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
        local character = LocalPlayer.Character
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
            localChar.Humanoid.AutoRotate = false
        end
    else
        if localChar.Humanoid then
            localChar.Humanoid.AutoRotate = true
        end
    end
    
    if not (Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart")) then
        if localChar.Humanoid then
            localChar.Humanoid.AutoRotate = true
        end
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

    if TargetPlr and TargetPlr.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if getgenv().Sentinel.NearestPart then
            local minDistance = math.huge
            local nearestPart = nil
            
            for _, partName in pairs(BodyParts) do
                local part = TargetPlr.Character:FindFirstChild(partName)
                if part then
                    local distance = (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
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
        if Script.Locals.RocketTP.Enabled and 
           TargetPlr and 
           TargetPlr.Character and 
           (object.Name == "Model" or object.Name == "GrenadeLauncherAmmo") then
            
            local SkibidiGrenadeLauncher = object.Name == "GrenadeLauncherAmmo"
            local part = SkibidiGrenadeLauncher and object:WaitForChild("Main") or object:WaitForChild("Launcher")
            
            if part then
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
                    if connection then connection:Disconnect() end
                end)
            end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if getgenv().Sentinel.Camera and TargetPlr and TargetPlr.Character and getgenv().Sentinel.SelectedPart then
        local camera = Workspace.CurrentCamera
        local selectedPart = getgenv().Sentinel.SelectedPart
        local targetPart = TargetPlr.Character:FindFirstChild(selectedPart)

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

RunService.Heartbeat:Connect(function()
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
        RunService.RenderStepped:Wait()
        LocalPlayer.Character.HumanoidRootPart.Velocity = abc
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").StateChanged:Connect(function(old, new)
        if getgenv().Sentinel.JumpBreak and new == Enum.HumanoidStateType.Freefall then
            wait(0.27)
            if character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.Velocity = Vector3.new(0, -15, 0)
            end
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    if Settings.Combat.Spectate and TargetPlr then
        Workspace.CurrentCamera.CameraSubject = TargetPlr.Character
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end
end)

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

RunService.Heartbeat:Connect(function()
    if getgenv().Sentinel.cframespeedtoggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.HumanoidRootPart.CFrame =
            LocalPlayer.Character.HumanoidRootPart.CFrame +
            LocalPlayer.Character.Humanoid.MoveDirection * getgenv().Sentinel.speedvalue / 0.5
    end
end)

-- Bullet TP
local cframe_to_offset = function(origin, target)
    local actual_origin = origin * CFrame.new(Script.Locals.GunTP.Offset[1], Script.Locals.GunTP.Offset[2], Script.Locals.GunTP.Offset[3], 1, 0, 0, 0, 0, 1, 0, -1, 0)
    return actual_origin:ToObjectSpace(target):inverse();
end

local something_tp = function(Tool)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("RightHand") then return end
    local old_grip = Tool.Grip
    if TargetPlr and TargetPlr.Character then
        Tool.Parent = LocalPlayer.Backpack
        LocalPlayer.Character.RightHand.Anchored = false
        Tool.Grip = cframe_to_offset(LocalPlayer.Character.RightHand.CFrame, TargetPlr.Character.HumanoidRootPart.CFrame)
        LocalPlayer.Character.RightHand.Anchored = true
        Tool.Parent = LocalPlayer.Character
        RunService.RenderStepped:Wait()
        Tool.Parent = LocalPlayer.Backpack
        LocalPlayer.Character.RightHand.Anchored = false
        Tool.Grip = old_grip
        Tool.Parent = LocalPlayer.Character
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
                    if RemovedChild == Child and Connection then
                        Connection:Disconnect()
                    end
                end)
            end
        end
    end)
end

if LocalPlayer.Character then
    bullet_teleport(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function()
    bullet_teleport(LocalPlayer.Character)
end)

print("Eternity.win Loaded Successfully!")
