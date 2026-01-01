-- Fixed Menu loading - loads from local file instead of remote URL
-- Make sure you have the Menu library file saved locally as "Menu.lua" in the same directory
local Menu = (function()
    -- First, try to load from local file
    local menuFile = loadfile("Menu.lua")
    if menuFile then
        local success, result = pcall(menuFile)
        if success and result then
            return result
        end
    end
    
    -- Fallback: Try loading from remote if local file doesn't exist or failed
    local success, result = pcall(function()
        local httpContent = game:HttpGetAsync("https://raw.githubusercontent.com/khenn791/library/refs/heads/main/cuh.txt", true)
        return load(httpContent)()
    end)
    if success and result then
        return result
    else
        error("Failed to load Menu library. Please ensure Menu.lua exists locally or check your internet connection.")
    end
end)()

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

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

--Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

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




UITextSizeConstraint.Parent = TextButton
UITextSizeConstraint.MaxTextSize = 30

local player = game.Players.LocalPlayer

-- Function to show the GUI when the character respawns
local function onCharacterAdded(character)
    ScreenGui.Parent = player.PlayerGui
end

-- Function to connect character respawn event
local function connectCharacterAdded()
    player.CharacterAdded:Connect(onCharacterAdded)
end


connectCharacterAdded()


player.CharacterRemoving:Connect(function()
    ScreenGui.Parent = nil
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




Menu:SetSize(500, 400)
Menu.Notify("Script Loaded.", 2)

local CombatTab = Menu.Tab("Main")



local TargetAimSection = Menu.Container("Main", "Target Aim", "Left") do

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
end       

local HvHTab = Menu.Tab("HvH")
local TeleportSection = Menu.Container("HvH", "Teleports", "Left") do

Menu.CheckBox("HvH", "Teleports", "Grenade Tp", GrenadeTP, function(a)
        Script.Locals.GrenadeTP.Enabled = a
end)
    Menu.CheckBox("HvH", "Teleports", "Rocket Tp", RocketTP, function(a)
        Script.Locals.RocketTP.Enabled = a
end)
end



    local BulletTaP = Menu.Container("HvH", "Bullet-TP", "Left") do
Menu.CheckBox("HvH", "Bullet-TP", "Bullet Gyatt", RocketTP, function(a) 
Script.Locals.GunTP.Enabled = a
end)

Menu.CheckBox("HvH", "Bullet-TP", "Anchor", RocketTP, function(a) 
Script.Locals.GunTP.Anchor = a
end)


    Menu.TextBox("HvH", "Bullet-TP", "X", "0", function(a) Script.Locals.GunTP.Offset[1] = a end)

    Menu.TextBox("HvH", "Bullet-TP", "Y", "-0.5", function(a) Script.Locals.GunTP.Offset[2] = a end)

    Menu.TextBox("HvH", "Bullet-TP", "Z", "0", function(a) Script.Locals.GunTP.Offset[3] = a end)

    end


    local HitPartSection = Menu.Container("Main", "HitPart", "Left") do
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
    end

    local Hitnotify = false
local PredictionSection = Menu.Container("Main", "Prediction", "Left") do
        Menu.CheckBox("Main", "Prediction", "Auto Prediction", true, function(a)
            getgenv().Sentinel.AutoPrediction = a
        end)
 Menu.ComboBox("Main","Prediction","LockType", getgenv().Sentinel.LockType, {"Namecall","Index"},
function(a)
 getgenv().Sentinel.LockType = a
end)
        Menu.TextBox("Main", "Prediction", "Horizontal", tostring(getgenv().Sentinel.HorizontalPrediction), function(a)
            getgenv().Sentinel.HorizontalPrediction2 = tonumber(a)
        end)

    end

local CameraContainer = Menu.Container("Main", "Camera", "Right") do
Menu.CheckBox("Main", "Camera", "Enabled", getgenv().Sentinel.Camera, function(a)
        getgenv().Sentinel.Camera = a
    end)
Menu.TextBox("Main", "Camera", "Smoothness", tostring(getgenv().Sentinel.smoothness), function(a)
            getgenv().Sentinel.smoothness= tonumber(a)
        end)
Menu.ComboBox("Main", "Camera", "Easing Style", getgenv().Sentinel.easingStyle, {
    "Linear",
    "Quad",
    "Cubic",
    "Quart",
    "Quint",
    "Sine",
    "Exponential",
    "Circular",
    "Back",
    "Bounce",
    "Elastic"
}, function(Cock)
    getgenv().Sentinel.easingStyle = Cock
end)
Menu.ComboBox("Main", "Camera", "Easing Direction", getgenv().Sentinel.easingDirection, {
    "In",
    "Out",
    "InOut"
}, function(Cock)
    getgenv().Sentinel.easingDirection = Cock
end)
end

local Visuals = Menu.Tab("Visuals")
 local HitDetectionSection = Menu.Container("Visuals", "Hit Detection", "Left") do
    Menu.CheckBox("Visuals", "Hit Detection", "Hit Effect", TargetAimbot.HitEffect, function(a) 
        TargetAimbot.HitEffect = a
    end)
    Menu.CheckBox("Visuals", "Hit Detection", "Hit Sound", TargetAimbot.HitSounds, function(a)
        TargetAimbot.HitSounds = a
    end)
    Menu.CheckBox("Visuals", "Hit Detection", "Notify", false, function(a) 
        Hitnotify = a
    end)
    Menu.ComboBox("Visuals", "Hit Detection", "Effect Type", TargetAimbot.HitEffectType, {"Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", "Circle Shot", "Bolt","Aura","Electric","Shock","Thunder"}, function(a)
        TargetAimbot.HitEffectType = a
    end)
    Menu.ComboBox("Visuals", "Hit Detection", "Sound Type", TargetAimbot.HitSound, {"RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", "Gamesense", "Rust", "BlackPencil"}, function(a)
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
end
   
    local CSyncSection = Menu.Container("HvH", "CSync", "Right") do
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
    end
local MiscTab = Menu.Tab("Misc") do
  
 local MTSection1 = Menu.Container("Misc", "Prediction Breaker", "Left") 

Menu.CheckBox("Misc", "Prediction Breaker", "Jump Prediction", getgenv().Sentinel.JumpBreak, function(a)
    getgenv().Sentinel.JumpBreak = a
end)

Menu.CheckBox("Misc", "Prediction Breaker", "Enable Anti Lock", getgenv().Desync, function(a)
    getgenv().Desync = a
end)

Menu.ComboBox("Misc", "Prediction Breaker", "Anti Lock Type", getgenv().AntiLockType, {
    "Behind",
    "Down",
    "ForWard",
    "Left",
    "One",
    "Right",
    "Up",
    "Zero"
}, function(a)
    getgenv().AntiLockType = a
end)

            local MTSection2 = Menu.Container("Misc", "CFrame Speed", "Right") do
                Menu.CheckBox("Misc", "CFrame Speed", "Enabled", false, function(a)
                    getgenv().Sentinel.cframespeedtoggle = a
                end)
                Menu.Slider("Misc", "CFrame Speed", "Speed", 0, 10, 3, '%', 1, function(a)
                getgenv().Sentinel.speedvalue = a
                end)
            end
            
            
            local MTSectionS = Menu.Container("Misc", "Macro", "Right") do
            Menu.Button("Misc", "Macro", "Load Macro", function()
    if MacroAlreadLoaded then
        print("hi")
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
            getgenv().Sentinel.MacroSpeed = tonumber(a)
        end)
    end

local aurasec2 = Menu.Container("Misc", "Aura", "Right") do
Menu.CheckBox("Misc", "Aura", "Enabled", false, function(y)
     if y then
       spawn()
     else 
       disconnect()
     end
local player = game.Players.LocalPlayer

player.CharacterAdded:Connect(function(character)
    if y then
        spawn()
    end
end)
end)
end


            
            local MTSection3 = Menu.Container("Misc", "Fly", "Right") do
                Menu.CheckBox("Misc", "Fly", "Enabled", false, function(a)
                    
                end)
                Menu.Hotkey("Misc", "Fly", "Keybind", Enum.KeyCode.X, function(a)
                    
                end)
                Menu.CheckBox("Misc", "Fly", "Notification", false, function(a)
                    
                end)
                Menu.Slider("Misc", "Fly", "Speed", 0, 30, 5, '%', 1, function(a)
                    
                end)
            end
  
local MTSection4 = Menu.Container("Misc", "Network Anti", "Left") do
                Menu.CheckBox("Misc", "Network Anti", "Enabled", getgenv().Sentinel.network, function(a)
                    getgenv().Sentinel.network = a
                end)
end    
            local MTSection4 = Menu.Container("Misc", "Trash Talk", "Left") do
                Menu.CheckBox("Misc", "Trash Talk", "Enabled", false, function(a)
                    
                end)
                Menu.CheckBox("Misc", "Trash Talk", "Target", false, function(a)
                    
                end)
                Menu.CheckBox("Misc", "Trash Talk", "Notification", false, function(a)
                    
                end)
                Menu.CheckBox("Misc", "Trash Talk", "Use Keybind", false, function(a)
                    
                end)
                Menu.Hotkey("Misc", "Trash Talk", "Keybind", Enum.KeyCode.B, function(a)
                    
                end)
            end

  local HitChamsSection = Menu.Container("Visuals", "Hit Chams", "Right") do
        Menu.CheckBox("Visuals", "Hit Chams", "Enabled", TargetAimbot.HitChams, function(a)
            TargetAimbot.HitChams = a
        end)
        Menu.ColorPicker("Visuals", "Hit Chams", "Color", TargetAimbot.HitChamsColor, 0, function(a)
            TargetAimbot.HitChamsColor = a
        end)
        Menu.Slider("Visuals", "Hit Chams", "Duration", 0, 5, TargetAimbot.HitChamsDuration, '', 1, function(a)
            TargetAimbot.HitChamsDuration = a
        end)
        Menu.ComboBox("Visuals", "Hit Chams", "Material", TargetAimbot.HitChamsMaterial.Name, {Enum.Material.Neon.Name, Enum.Material.SmoothPlastic.Name}, function(a)
            TargetAimbot.HitChamsMaterial = Enum.Material[a]
        end)
    end
end

Menu:SetTitle("Nigger.Lua")
Menu:SetVisible(true)
Menu:Init()
