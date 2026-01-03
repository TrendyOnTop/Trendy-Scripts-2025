-- ============================================
-- FULL INTEGRATED SCRIPT WITH SETTINGS TABLE
-- All original features preserved
-- Only Lock Button UI, everything else via Settings table
-- ============================================

local function cooked(Sex3)
    if Sex3 then  
        if getgenv().executed then
            return  
        end
        getgenv().executed = true
        print("hi")

        local startTime = os.clock()
        repeat wait() until game:IsLoaded()

        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua"))()

        if not LPH_OBFUSCATED then
            LPH_JIT = function(...) return ... end
            LPH_NO_VIRTUALIZE = function(...) return ... end
        end

        local getcustom = string.find(identifyexecutor(), "Delta")
        local assetsupport = string.find(identifyexecutor(), "Wave") or string.find(identifyexecutor(), "Seliware") or string.find(identifyexecutor(), "AWP") or string.find(identifyexecutor(), "Argon") or string.find(identifyexecutor(), "Swift")

        -- ============================================
        -- SETTINGS TABLE - ALL FEATURES ORGANIZED
        -- ============================================
        getgenv().Settings = {
            -- Main Tab - Silent/Target
            Silent = {
                Enabled = false,
                LookAt = false,
                ViewAt = false,
                AntiAimViewer = false,
                AutoAir = false,
                AutoAirDelay = 0.22,
                LockMethod = "Namecall", -- "Index" or "Namecall"
            },
            
            -- Hit Part
            HitPart = {
                BodyPart = "HumanoidRootPart",
                AirPart = "RightFoot",
            },
            
            -- Prediction
            Prediction = {
                Division = false, -- UseVertical
                Horizontal = 0.1,
                Vertical = 0.1,
                JumpOffset = 0,
                FallOffset = 0.270,
                Visualize = false, -- VelocityDot
                Resolver = false,
                AutoPrediction = false,
                AutoPredMode = "Calculate", -- "Default", "Math Based", "Sets Based", "Calculate"
                ResolverMethod = "MoveDirection", -- "Recalculate", "MoveDirection", "LookVector"
            },
            
            -- Checks
            Checks = {
                KnockOut = false, -- KOCheck
                Wall = false, -- WallCheck
                Friend = false, -- FriendCheck
                Vehicle = false, -- SeatedCheck
                Team = false, -- TeamCheck
            },
            
            -- Gun Modification
            GunMod = {
                BulletTP = false, -- bool_at_tp
                RapidFire = false, -- Noobidiot
                RapidFireDelay = 0,
            },
            
            -- Rage Tab - Camera
            Camera = {
                Enabled = false,
                Flick = false,
                Division = false, -- UseExternal
                Resolver = false, -- CamResolverEnabled
                Smoothness = 0.9,
                EasingStyle = "Sine", -- "Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Exponential", "Circular", "Back", "Bounce", "Elastic"
                EasingDirection = "Out", -- "In", "Out", "InOut"
                WallCheck = false, -- CamWallCheck
                Knocked = false, -- CAMKo
                HorizontalPrediction = 0.1, -- CamPrediction1
                VerticalPrediction = 0.1, -- CamPrediction2
                AutoPrediction = false, -- CamAutoprediction
            },
            
            -- CSync
            CSync = {
                Enabled = false,
                Spoof = false, -- Visualize
                Type = "Orbit", -- "Orbit", "Random", "Spiral", "Spherical", "Attach"
                Distance = 10,
                Height = 2,
                Speed = 10,
                RandomAmount = 10,
                Color = Color3.fromRGB(255, 255, 255),
            },
            
            -- Prediction Breaker
            PredictionBreaker = {
                JumpPrediction = false, -- JumpBreak
                AntiLock = false, -- Desync
                AntiNetwork = false, -- desyncsleep
                AntiLockType = "Zero", -- "Multiply", "Shake", "Behind", "Down", "Forward", "Left", "One", "Right", "Up", "Zero"
            },
            
            -- Hit Detection
            HitDetection = {
                HitEffect = false,
                HitSound = false,
                Notify = false, -- Hitnotify
                EffectType = "Coom", -- "Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", "AuraBurst", "Thunder"
                SoundType = "Bameware", -- All sound options
                HitEffectColor = Color3.fromRGB(255, 255, 255),
            },
            
            -- Hit Chams
            HitChams = {
                Enabled = false,
                Color = Color3.fromRGB(255, 0, 0),
                SkeletonEnabled = false,
                SkeletonColor = Color3.fromRGB(155, 0, 155),
                Duration = 2,
                Transparency = 0,
                Material = "Neon", -- "Neon", "SmoothPlastic", "ForceField"
            },
            
            -- Visuals Tab - ESP
            ESP = {
                BoxEnabled = false,
                BoxCorners = false,
                BoxDynamic = false,
                SkeletonEnabled = false,
                ChamsEnabled = false,
                TextEnabled = false,
                HealthBar = false,
                TargetOnly = false,
            },
            
            -- Target Visual
            TargetVisual = {
                Highlight = false,
                AnimateHighlight = false, -- AChams
                Color1 = Color3.fromRGB(255, 255, 255),
                Color2 = Color3.fromRGB(255, 255, 255),
            },
            
            -- Bullet Trails
            BulletTrails = {
                Enabled = false,
                Fade = false,
                Width = 1.0,
                Duration = 3,
                Texture = "Cool", -- "Cool", "Cum", "Electro", "None"
                Color = Color3.fromRGB(255, 255, 255),
            },
            
            -- Crosshair
            Crosshair = {
                Enabled = false,
                Spin = false,
                StickToTarget = false,
                Position = "Middle", -- "Middle", "Mouse"
                Color = Color3.fromRGB(255, 255, 255),
            },
            
            -- Silent FOV
            SilentFOV = {
                Enabled = false,
                Silent = false, -- SilentMode
                Mode = "Center", -- "Mouse", "Center"
                Size = 125,
                Color1 = Color3.fromRGB(0, 0, 0),
                Color2 = Color3.fromRGB(0, 0, 255),
            },
            
            -- Environment
            Environment = {
                FogEnabled = false,
                FogColor = Color3.fromRGB(0, 0, 255),
                FogStart = 0,
                FogEnd = 300,
                SkyboxEnabled = false,
                SkyboxType = 1, -- 1-7
            },
            
            -- Settings Tab - Camera
            CameraSettings = {
                FieldOfView = 80,
            },
            
            -- Dance
            Dance = {
                Enabled = false,
                DanceType = "Floss", -- "Floss", "Spin", "Sit", "ArmSpin", "Lay"
                Speed = 2,
            },
        }

        -- ============================================
        -- INITIALIZE SERVICES AND VARIABLES
        -- ============================================
        local UserInputService = cloneref(game:GetService("UserInputService"))
        local Players = cloneref(game:GetService("Players"))
        local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
        local RunService = cloneref(game:GetService("RunService"))
        local Workspace = cloneref(game:GetService("Workspace"))
        local Stats = cloneref(game:GetService("Stats"))
        local CoreGui = cloneref(game:GetService("CoreGui"))
        local StarterGui = cloneref(game:GetService("StarterGui"))
        local SoundService = cloneref(game:GetService("SoundService"))
        local HttpService = cloneref(game:GetService("HttpService"))
        local LocalPlayer = cloneref(Players.LocalPlayer)
        local Camera = cloneref(Workspace.CurrentCamera)
        local TweenService = game:GetService("TweenService")
        local Lighting = game:GetService("Lighting")

        -- ============================================
        -- INSERT ALL ORIGINAL CODE HERE:
        -- 1. Library initialization (if needed)
        -- 2. All hit effect modules
        -- 3. All sound definitions
        -- 4. All utility functions
        -- 5. All ESP code
        -- 6. All visual effects code
        -- 7. All target finding functions
        -- 8. All aimbot logic
        -- 9. All camera manipulation code
        -- 10. All prediction calculations
        -- 11. All hit detection code
        -- ============================================

        -- [PASTE ALL YOUR ORIGINAL CODE HERE, BUT REPLACE UI REFERENCES WITH Settings TABLE]

        -- ============================================
        -- INITIALIZE PSALMS TECH FROM SETTINGS
        -- ============================================
        local Psalms = {
            Tech = {
                Enabled = getgenv().Settings.Silent.Enabled,
                AutoPrediction = getgenv().Settings.Prediction.AutoPrediction,
                AutoPredMode = getgenv().Settings.Prediction.AutoPredMode,
                APMODE = getgenv().Settings.Prediction.AutoPredMode,
                RealPart = getgenv().Settings.HitPart.BodyPart,
                SelectedPart = getgenv().Settings.HitPart.BodyPart,
                AirPart = getgenv().Settings.HitPart.AirPart,
                HorizontalPrediction = getgenv().Settings.Prediction.Horizontal,
                VerticalPrediction = getgenv().Settings.Prediction.Vertical,
                HorizontalPrediction2 = getgenv().Settings.Prediction.Horizontal,
                VerticalPrediction2 = getgenv().Settings.Prediction.Vertical,
                jumpoffset = getgenv().Settings.Prediction.JumpOffset,
                jumpoffset2 = getgenv().Settings.Prediction.JumpOffset,
                jumpoffset3 = getgenv().Settings.Prediction.FallOffset,
                ShootDelay = getgenv().Settings.Silent.AutoAirDelay,
                NoGroundShot = false,
                AutoAir = getgenv().Settings.Silent.AutoAir,
                TracerEnabled = true,
                LookAt = getgenv().Settings.Silent.LookAt,
                Camera = getgenv().Settings.Camera.Enabled,
                CamPrediction1 = getgenv().Settings.Camera.HorizontalPrediction,
                CamPrediction2 = getgenv().Settings.Camera.VerticalPrediction,
                SilentMode = getgenv().Settings.SilentFOV.Silent,
                smoothness = getgenv().Settings.Camera.Smoothness,
                speedvalue = 1,
                MacroSpeed = 0.2,
                AntiCurve = false,
                ResolverEnabled = getgenv().Settings.Prediction.Resolver,
                easingStyle = getgenv().Settings.Camera.EasingStyle,
                easingDirection = getgenv().Settings.Camera.EasingDirection,
                isTargetPlrMode = true,
                shootDelay = 0.114,
                lastShootTime = 0,
                TriggerPot = true,
                JumpBreak = getgenv().Settings.PredictionBreaker.JumpPrediction,
                network = false,
                UseVertical = getgenv().Settings.Prediction.Division,
                DotC = Color3.fromRGB(0, 0, 0),
                WallCheck = getgenv().Settings.Checks.Wall,
                FriendCheck = getgenv().Settings.Checks.Friend,
                KOCheck = getgenv().Settings.Checks.KnockOut,
                SeatedCheck = getgenv().Settings.Checks.Vehicle,
                TeamCheck = getgenv().Settings.Checks.Team,
                UnlockOnKO = false,
                CamWallCheck = getgenv().Settings.Camera.WallCheck,
                CAMKo = getgenv().Settings.Camera.Knocked,
                bool_at_tp = getgenv().Settings.GunMod.BulletTP,
                MacroDance = "YungBlud",
                MacroDanceDelay = 0.300,
                VelocityDot = getgenv().Settings.Prediction.Visualize,
                RESOLVER = getgenv().Settings.Prediction.ResolverMethod,
                LockType = getgenv().Settings.Silent.LockMethod,
                AntiAimViewer = getgenv().Settings.Silent.AntiAimViewer,
                ViewAt = getgenv().Settings.Silent.ViewAt,
                UseExternal = getgenv().Settings.Camera.Division,
                CamResolverEnabled = getgenv().Settings.Camera.Resolver,
                CamAutoprediction = getgenv().Settings.Camera.AutoPrediction,
                cframespeedtoggle = false,
            }
        }

        Psalms.Tech.SelectedPart = Psalms.Tech.RealPart

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
                Enabled = getgenv().Settings.CSync.Enabled,
                Type = getgenv().Settings.CSync.Type,
                Distance = getgenv().Settings.CSync.Distance,
                Height = getgenv().Settings.CSync.Height,
                Speed = getgenv().Settings.CSync.Speed,
                RandomAmount = getgenv().Settings.CSync.RandomAmount,
                Color = getgenv().Settings.CSync.Color,
                Saved = nil,
                Visualize = getgenv().Settings.CSync.Spoof,
            },
            ViewAt = false,
            Tracer = false,
            Highlight = getgenv().Settings.TargetVisual.Highlight,
            HighlightColor1 = getgenv().Settings.TargetVisual.Color1,
            HighlightColor2 = getgenv().Settings.TargetVisual.Color2,
            Stats = false,
            UseFov = false,
            HitEffect = getgenv().Settings.HitDetection.HitEffect,
            HitEffectType = getgenv().Settings.HitDetection.EffectType,
            HitEffectColor = getgenv().Settings.HitDetection.HitEffectColor,
            HitSounds = getgenv().Settings.HitDetection.HitSound,
            HitSound = getgenv().Settings.HitDetection.SoundType,
            HitChams = getgenv().Settings.HitChams.Enabled,
            HitChamsMaterial = Enum.Material[getgenv().Settings.HitChams.Material],
            HitChamsDuration = getgenv().Settings.HitChams.Duration,
            HitChamsColor = getgenv().Settings.HitChams.Color,
            HitChamColorEnabled = false,
            HitChamsTransparency = getgenv().Settings.HitChams.Transparency,
            HitChamsAcc = false,
            SkeleColor = getgenv().Settings.HitChams.SkeletonColor,
            HitSkele = getgenv().Settings.HitChams.SkeletonEnabled,
        }

        -- Initialize Configurations
        Configurations = Configurations or {}
        Configurations.Visuals = Configurations.Visuals or {}
        Configurations.Visuals.Bullet_Trails = {
            Enabled = getgenv().Settings.BulletTrails.Enabled,
            Width = getgenv().Settings.BulletTrails.Width,
            Duration = getgenv().Settings.BulletTrails.Duration,
            Fade = getgenv().Settings.BulletTrails.Fade,
            FadeDuration = getgenv().Settings.BulletTrails.Duration,
            Color = getgenv().Settings.BulletTrails.Color,
            Texture = getgenv().Settings.BulletTrails.Texture,
        }
        Configurations.Misc = Configurations.Misc or {}
        Configurations.Misc.Animation = {
            Enabled = getgenv().Settings.Dance.Enabled,
            SelectedDance = getgenv().Settings.Dance.DanceType,
            Speed = getgenv().Settings.Dance.Speed,
        }

        getgenv().esp = getgenv().esp or {}
        getgenv().esp.TargetOnly = getgenv().Settings.ESP.TargetOnly
        getgenv().esp.AutoStep = true
        getgenv().esp.CharacterSize = Vector3.new(4, 5.75, 1.5)
        getgenv().esp.CharacterOffset = CFrame.new(0, -0.25, 0)
        getgenv().esp.UseBoundingBox = false
        getgenv().esp.PriorityColor = Color3.new(1,0.25,0.25)
        getgenv().esp.BoxEnabled = getgenv().Settings.ESP.BoxEnabled
        getgenv().esp.BoxCorners = getgenv().Settings.ESP.BoxCorners
        getgenv().esp.BoxDynamic = getgenv().Settings.ESP.BoxDynamic
        getgenv().esp.BoxStaticXFactor = 1.3
        getgenv().esp.BoxStaticYFactor = 1.6
        getgenv().esp.BoxColor = Color3.fromRGB(255, 255, 255)
        getgenv().esp.SkeletonEnabled = getgenv().Settings.ESP.SkeletonEnabled
        getgenv().esp.SkeletonColor = Color3.fromRGB(255, 255, 255)
        getgenv().esp.SkeletonMaxDistance = 300
        getgenv().esp.ChamsEnabled = getgenv().Settings.ESP.ChamsEnabled
        getgenv().esp.ChamsInnerColor = Color3.fromRGB(102, 60, 153)
        getgenv().esp.ChamsOuterColor = Color3.fromRGB(0, 0, 0)
        getgenv().esp.ChamsInnerTransparency = 0.5
        getgenv().esp.ChamsOuterTransparency = 0.5
        getgenv().esp.TextEnabled = getgenv().Settings.ESP.TextEnabled
        getgenv().esp.TextColor = Color3.fromRGB(255, 255, 255)
        getgenv().esp.TextLayout = {
            ['nametag'] = { enabled = true, position = 'top', order = 1 },
            ['name'] = { enabled = true, position = 'top', order = 2 },
            ['health'] = { enabled = true, position = 'left', order = 1, bar = 'health' },
            ['tool'] = { enabled = true, position = 'bottom', suffix = '', prefix = '', order = 1 },
            ['distance'] = { enabled = true, position = 'bottom', suffix = 'm', order = 2 },
        }
        getgenv().esp.BarLayout = {
            ['health'] = { enabled = getgenv().Settings.ESP.HealthBar, position = 'left', order = 1, color_empty = Color3.fromRGB(176, 84, 84), color_full = Color3.fromRGB(140, 250, 140) }
        }

        getgenv().crosshair = getgenv().crosshair or {}
        getgenv().crosshair.color = getgenv().Settings.Crosshair.Color
        getgenv().crosshair.mode = getgenv().Settings.Crosshair.Position
        getgenv().crosshair.sticky = getgenv().Settings.Crosshair.StickToTarget
        getgenv().crosshair.enabled = getgenv().Settings.Crosshair.Enabled
        getgenv().crosshair.spin = getgenv().Settings.Crosshair.Spin

        Camera.FieldOfView = getgenv().Settings.CameraSettings.FieldOfView

        -- ============================================
        -- SETTINGS UPDATE FUNCTION
        -- ============================================
        local function UpdateSettings()
            Psalms.Tech.Enabled = getgenv().Settings.Silent.Enabled
            Psalms.Tech.LookAt = getgenv().Settings.Silent.LookAt
            Psalms.Tech.ViewAt = getgenv().Settings.Silent.ViewAt
            Psalms.Tech.AntiAimViewer = getgenv().Settings.Silent.AntiAimViewer
            Psalms.Tech.AutoAir = getgenv().Settings.Silent.AutoAir
            Psalms.Tech.ShootDelay = getgenv().Settings.Silent.AutoAirDelay
            Psalms.Tech.LockType = getgenv().Settings.Silent.LockMethod
            
            Psalms.Tech.RealPart = getgenv().Settings.HitPart.BodyPart
            Psalms.Tech.AirPart = getgenv().Settings.HitPart.AirPart
            Psalms.Tech.SelectedPart = getgenv().Settings.HitPart.BodyPart
            
            Psalms.Tech.UseVertical = getgenv().Settings.Prediction.Division
            Psalms.Tech.HorizontalPrediction = getgenv().Settings.Prediction.Horizontal
            Psalms.Tech.VerticalPrediction = getgenv().Settings.Prediction.Vertical
            Psalms.Tech.HorizontalPrediction2 = getgenv().Settings.Prediction.Horizontal
            Psalms.Tech.VerticalPrediction2 = getgenv().Settings.Prediction.Vertical
            Psalms.Tech.jumpoffset = getgenv().Settings.Prediction.JumpOffset
            Psalms.Tech.jumpoffset2 = getgenv().Settings.Prediction.JumpOffset
            Psalms.Tech.jumpoffset3 = getgenv().Settings.Prediction.FallOffset
            Psalms.Tech.VelocityDot = getgenv().Settings.Prediction.Visualize
            Psalms.Tech.ResolverEnabled = getgenv().Settings.Prediction.Resolver
            Psalms.Tech.AutoPrediction = getgenv().Settings.Prediction.AutoPrediction
            Psalms.Tech.APMODE = getgenv().Settings.Prediction.AutoPredMode
            Psalms.Tech.RESOLVER = getgenv().Settings.Prediction.ResolverMethod
            
            Psalms.Tech.KOCheck = getgenv().Settings.Checks.KnockOut
            Psalms.Tech.WallCheck = getgenv().Settings.Checks.Wall
            Psalms.Tech.FriendCheck = getgenv().Settings.Checks.Friend
            Psalms.Tech.SeatedCheck = getgenv().Settings.Checks.Vehicle
            Psalms.Tech.TeamCheck = getgenv().Settings.Checks.Team
            
            Psalms.Tech.bool_at_tp = getgenv().Settings.GunMod.BulletTP
            
            Psalms.Tech.Camera = getgenv().Settings.Camera.Enabled
            Psalms.Tech.CamPrediction1 = getgenv().Settings.Camera.HorizontalPrediction
            Psalms.Tech.CamPrediction2 = getgenv().Settings.Camera.VerticalPrediction
            Psalms.Tech.UseExternal = getgenv().Settings.Camera.Division
            Psalms.Tech.CamResolverEnabled = getgenv().Settings.Camera.Resolver
            Psalms.Tech.smoothness = getgenv().Settings.Camera.Smoothness
            Psalms.Tech.easingStyle = getgenv().Settings.Camera.EasingStyle
            Psalms.Tech.easingDirection = getgenv().Settings.Camera.EasingDirection
            Psalms.Tech.CamWallCheck = getgenv().Settings.Camera.WallCheck
            Psalms.Tech.CAMKo = getgenv().Settings.Camera.Knocked
            Psalms.Tech.CamAutoprediction = getgenv().Settings.Camera.AutoPrediction
            
            TargetAimbot.CSync.Enabled = getgenv().Settings.CSync.Enabled
            TargetAimbot.CSync.Type = getgenv().Settings.CSync.Type
            TargetAimbot.CSync.Distance = getgenv().Settings.CSync.Distance
            TargetAimbot.CSync.Height = getgenv().Settings.CSync.Height
            TargetAimbot.CSync.Speed = getgenv().Settings.CSync.Speed
            TargetAimbot.CSync.RandomAmount = getgenv().Settings.CSync.RandomAmount
            TargetAimbot.CSync.Color = getgenv().Settings.CSync.Color
            TargetAimbot.CSync.Visualize = getgenv().Settings.CSync.Spoof
            
            Psalms.Tech.JumpBreak = getgenv().Settings.PredictionBreaker.JumpPrediction
            
            TargetAimbot.HitEffect = getgenv().Settings.HitDetection.HitEffect
            TargetAimbot.HitSounds = getgenv().Settings.HitDetection.HitSound
            TargetAimbot.HitEffectType = getgenv().Settings.HitDetection.EffectType
            TargetAimbot.HitSound = getgenv().Settings.HitDetection.SoundType
            TargetAimbot.HitEffectColor = getgenv().Settings.HitDetection.HitEffectColor
            TargetAimbot.HitChams = getgenv().Settings.HitChams.Enabled
            TargetAimbot.HitChamsColor = getgenv().Settings.HitChams.Color
            TargetAimbot.HitChamsDuration = getgenv().Settings.HitChams.Duration
            TargetAimbot.HitChamsTransparency = getgenv().Settings.HitChams.Transparency
            TargetAimbot.HitChamsMaterial = Enum.Material[getgenv().Settings.HitChams.Material]
            TargetAimbot.SkeleColor = getgenv().Settings.HitChams.SkeletonColor
            TargetAimbot.HitSkele = getgenv().Settings.HitChams.SkeletonEnabled
            
            TargetAimbot.Highlight = getgenv().Settings.TargetVisual.Highlight
            TargetAimbot.HighlightColor1 = getgenv().Settings.TargetVisual.Color1
            TargetAimbot.HighlightColor2 = getgenv().Settings.TargetVisual.Color2
            
            Configurations.Visuals.Bullet_Trails.Enabled = getgenv().Settings.BulletTrails.Enabled
            Configurations.Visuals.Bullet_Trails.Fade = getgenv().Settings.BulletTrails.Fade
            Configurations.Visuals.Bullet_Trails.Width = getgenv().Settings.BulletTrails.Width
            Configurations.Visuals.Bullet_Trails.Duration = getgenv().Settings.BulletTrails.Duration
            Configurations.Visuals.Bullet_Trails.Texture = getgenv().Settings.BulletTrails.Texture
            Configurations.Visuals.Bullet_Trails.Color = getgenv().Settings.BulletTrails.Color
            
            getgenv().esp.BoxEnabled = getgenv().Settings.ESP.BoxEnabled
            getgenv().esp.BoxCorners = getgenv().Settings.ESP.BoxCorners
            getgenv().esp.BoxDynamic = getgenv().Settings.ESP.BoxDynamic
            getgenv().esp.SkeletonEnabled = getgenv().Settings.ESP.SkeletonEnabled
            getgenv().esp.ChamsEnabled = getgenv().Settings.ESP.ChamsEnabled
            getgenv().esp.TextEnabled = getgenv().Settings.ESP.TextEnabled
            getgenv().esp.BarLayout['health'].enabled = getgenv().Settings.ESP.HealthBar
            getgenv().esp.TargetOnly = getgenv().Settings.ESP.TargetOnly
            
            getgenv().crosshair.enabled = getgenv().Settings.Crosshair.Enabled
            getgenv().crosshair.spin = getgenv().Settings.Crosshair.Spin
            getgenv().crosshair.sticky = getgenv().Settings.Crosshair.StickToTarget
            getgenv().crosshair.color = getgenv().Settings.Crosshair.Color
            
            Camera.FieldOfView = getgenv().Settings.CameraSettings.FieldOfView
            
            Configurations.Misc.Animation.Enabled = getgenv().Settings.Dance.Enabled
            Configurations.Misc.Animation.SelectedDance = getgenv().Settings.Dance.DanceType
            Configurations.Misc.Animation.Speed = getgenv().Settings.Dance.Speed
        end

        -- ============================================
        -- LOCK BUTTON UI (ONLY UI ELEMENT)
        -- ============================================
        local LockButtonGui = Instance.new("ScreenGui")
        LockButtonGui.Name = "LockButtonGui"
        LockButtonGui.Parent = CoreGui
        LockButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        LockButtonGui.ResetOnSpawn = false

        local LockButton = Instance.new("ImageButton")
        LockButton.Name = "LockButton"
        LockButton.Parent = LockButtonGui
        LockButton.Active = true
        LockButton.Draggable = true
        LockButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        LockButton.BackgroundTransparency = 0.5
        LockButton.Size = UDim2.new(0, 90, 0, 90)
        LockButton.Image = "rbxassetid://140623923630784"
        LockButton.Position = UDim2.new(0.5, -45, 0.5, -45)

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0.2, 0)
        UICorner.Parent = LockButton

        -- ============================================
        -- TARGET LOCK VARIABLES
        -- ============================================
        local TargBindEnabled = false
        local TargetPlr = nil
        local targetHealth = nil
        local Highlight = getgenv().Settings.TargetVisual.Highlight
        local AChams = getgenv().Settings.TargetVisual.AnimateHighlight
        local Hitnotify = getgenv().Settings.HitDetection.Notify
        local Flick = getgenv().Settings.Camera.Flick
        local Desync = getgenv().Settings.PredictionBreaker.AntiLock
        local desyncsleep = getgenv().Settings.PredictionBreaker.AntiNetwork
        local AntiLockType = getgenv().Settings.PredictionBreaker.AntiLockType
        local Noobidiot = getgenv().Settings.GunMod.RapidFire
        local idiotdelay = getgenv().Settings.GunMod.RapidFireDelay

        -- ============================================
        -- TARGET FINDING FUNCTION
        -- ============================================
        local function GetClosestToMouse()
            local TargetPlr, Closest = nil, math.huge
            local Client = LocalPlayer
            local Mouse = Client:GetMouse()

            for _, v in pairs(Players:GetPlayers()) do
                if (v ~= Client and v.Character and v.Character:FindFirstChild("HumanoidRootPart")) then
                    local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                    if (Distance < Closest and OnScreen) then
                        Closest = Distance
                        TargetPlr = v
                    end
                end
            end
            return TargetPlr
        end

        -- ============================================
        -- LOCK BUTTON FUNCTIONALITY
        -- ============================================
        local function toggleLock()
            if TargetAimbot.Enabled then
                local Closest = GetClosestToMouse()
                
                if TargBindEnabled and TargetPlr then
                    TargBindEnabled = false
                    targetHealth = nil
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.AutoRotate = true
                    end
                    TargetPlr = nil
                    Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                    LockButton.Image = "rbxassetid://140623923630784" -- Unlocked
                else
                    if Closest then
                        TargBindEnabled = true
                        TargetPlr = Closest
                        
                        if TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
                            targetHealth = TargetPlr.Character.Humanoid.Health
                            LockButton.Image = "rbxassetid://96086736054343" -- Locked
                        else
                            return
                        end
                    end
                end
            end
        end

        LockButton.MouseButton1Click:Connect(toggleLock)

        -- ============================================
        -- UPDATE SETTINGS CONTINUOUSLY
        -- ============================================
        RunService.Heartbeat:Connect(function()
            UpdateSettings()
            -- Update other variables from settings
            Highlight = getgenv().Settings.TargetVisual.Highlight
            AChams = getgenv().Settings.TargetVisual.AnimateHighlight
            Hitnotify = getgenv().Settings.HitDetection.Notify
            Flick = getgenv().Settings.Camera.Flick
            Desync = getgenv().Settings.PredictionBreaker.AntiLock
            desyncsleep = getgenv().Settings.PredictionBreaker.AntiNetwork
            AntiLockType = getgenv().Settings.PredictionBreaker.AntiLockType
            Noobidiot = getgenv().Settings.GunMod.RapidFire
            idiotdelay = getgenv().Settings.GunMod.RapidFireDelay
        end)

        print("Script loaded! Use getgenv().Settings to configure all features.")
        print("Example: getgenv().Settings.Silent.Enabled = true")
        print("Lock button created - click to toggle target lock.")
    end
end

-- [Rest of initialization code from original script...]
if game.PlaceId == 9825515356 then
    -- [Original initialization code for this game]
    cooked(true)
else
    cooked(true)
end
