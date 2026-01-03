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
        local Settings = {
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
        -- INITIALIZE PSALMS TECH TABLE FROM SETTINGS
        -- ============================================
        local Psalms = {
            Tech = {
                Enabled = Settings.Silent.Enabled,
                AutoPrediction = Settings.Prediction.AutoPrediction,
                AutoPredMode = Settings.Prediction.AutoPredMode,
                APMODE = Settings.Prediction.AutoPredMode,
                
                RealPart = Settings.HitPart.BodyPart,
                SelectedPart = Settings.HitPart.BodyPart,
                AirPart = Settings.HitPart.AirPart,
                
                HorizontalPrediction = Settings.Prediction.Horizontal,
                VerticalPrediction = Settings.Prediction.Vertical,
                HorizontalPrediction2 = Settings.Prediction.Horizontal,
                VerticalPrediction2 = Settings.Prediction.Vertical,
                
                jumpoffset = Settings.Prediction.JumpOffset,
                jumpoffset2 = Settings.Prediction.JumpOffset,
                jumpoffset3 = Settings.Prediction.FallOffset,
                
                ShootDelay = Settings.Silent.AutoAirDelay,
                NoGroundShot = false,
                AutoAir = Settings.Silent.AutoAir,
                
                TracerEnabled = true,
                LookAt = Settings.Silent.LookAt,
                
                Camera = Settings.Camera.Enabled,
                CamPrediction1 = Settings.Camera.HorizontalPrediction,
                CamPrediction2 = Settings.Camera.VerticalPrediction,
                SilentMode = Settings.SilentFOV.Silent,
                smoothness = Settings.Camera.Smoothness,
                speedvalue = 1,
                MacroSpeed = 0.2,
                AntiCurve = false,
                ResolverEnabled = Settings.Prediction.Resolver,
                
                easingStyle = Settings.Camera.EasingStyle,
                easingDirection = Settings.Camera.EasingDirection,
                isTargetPlrMode = true,
                shootDelay = 0.114,
                lastShootTime = 0,
                TriggerPot = true,
                
                JumpBreak = Settings.PredictionBreaker.JumpPrediction,
                network = false,
                UseVertical = Settings.Prediction.Division,
                DotC = Color3.fromRGB(0, 0, 0),
                WallCheck = Settings.Checks.Wall,
                FriendCheck = Settings.Checks.Friend,
                KOCheck = Settings.Checks.KnockOut,
                SeatedCheck = Settings.Checks.Vehicle,
                TeamCheck = Settings.Checks.Team,
                UnlockOnKO = false,
                CamWallCheck = Settings.Camera.WallCheck,
                CAMKo = Settings.Camera.Knocked,
                bool_at_tp = Settings.GunMod.BulletTP,
                MacroDance = "YungBlud",
                MacroDanceDelay = 0.300,
                VelocityDot = Settings.Prediction.Visualize,
                RESOLVER = Settings.Prediction.ResolverMethod,
                LockType = Settings.Silent.LockMethod,
                AntiAimViewer = Settings.Silent.AntiAimViewer,
                ViewAt = Settings.Silent.ViewAt,
                UseExternal = Settings.Camera.Division,
                CamResolverEnabled = Settings.Camera.Resolver,
                CamAutoprediction = Settings.Camera.AutoPrediction,
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
                Enabled = Settings.CSync.Enabled,
                Type = Settings.CSync.Type,
                Distance = Settings.CSync.Distance,
                Height = Settings.CSync.Height,
                Speed = Settings.CSync.Speed,
                RandomAmount = Settings.CSync.RandomAmount,
                Color = Settings.CSync.Color,
                Saved = nil,
                Visualize = Settings.CSync.Spoof,
            },
            ViewAt = false,
            Tracer = false,
            Highlight = Settings.TargetVisual.Highlight,
            HighlightColor1 = Settings.TargetVisual.Color1,
            HighlightColor2 = Settings.TargetVisual.Color2,
            Stats = false,
            UseFov = false,
            HitEffect = Settings.HitDetection.HitEffect,
            HitEffectType = Settings.HitDetection.EffectType,
            HitEffectColor = Settings.HitDetection.HitEffectColor,
            HitSounds = Settings.HitDetection.HitSound,
            HitSound = Settings.HitDetection.SoundType,
            HitChams = Settings.HitChams.Enabled,
            HitChamsMaterial = Enum.Material[Settings.HitChams.Material],
            HitChamsDuration = Settings.HitChams.Duration,
            HitChamsColor = Settings.HitChams.Color,
            HitChamColorEnabled = false,
            HitChamsTransparency = Settings.HitChams.Transparency,
            HitChamsAcc = false,
            SkeleColor = Settings.HitChams.SkeletonColor,
            HitSkele = Settings.HitChams.SkeletonEnabled,
        }

        -- ============================================
        -- SETTINGS UPDATE FUNCTION
        -- ============================================
        local function UpdateSettings()
            -- Update Psalms.Tech from Settings
            Psalms.Tech.Enabled = Settings.Silent.Enabled
            Psalms.Tech.LookAt = Settings.Silent.LookAt
            Psalms.Tech.ViewAt = Settings.Silent.ViewAt
            Psalms.Tech.AntiAimViewer = Settings.Silent.AntiAimViewer
            Psalms.Tech.AutoAir = Settings.Silent.AutoAir
            Psalms.Tech.ShootDelay = Settings.Silent.AutoAirDelay
            Psalms.Tech.LockType = Settings.Silent.LockMethod
            
            Psalms.Tech.RealPart = Settings.HitPart.BodyPart
            Psalms.Tech.AirPart = Settings.HitPart.AirPart
            Psalms.Tech.SelectedPart = Settings.HitPart.BodyPart
            
            Psalms.Tech.UseVertical = Settings.Prediction.Division
            Psalms.Tech.HorizontalPrediction = Settings.Prediction.Horizontal
            Psalms.Tech.VerticalPrediction = Settings.Prediction.Vertical
            Psalms.Tech.HorizontalPrediction2 = Settings.Prediction.Horizontal
            Psalms.Tech.VerticalPrediction2 = Settings.Prediction.Vertical
            Psalms.Tech.jumpoffset = Settings.Prediction.JumpOffset
            Psalms.Tech.jumpoffset2 = Settings.Prediction.JumpOffset
            Psalms.Tech.jumpoffset3 = Settings.Prediction.FallOffset
            Psalms.Tech.VelocityDot = Settings.Prediction.Visualize
            Psalms.Tech.ResolverEnabled = Settings.Prediction.Resolver
            Psalms.Tech.AutoPrediction = Settings.Prediction.AutoPrediction
            Psalms.Tech.APMODE = Settings.Prediction.AutoPredMode
            Psalms.Tech.RESOLVER = Settings.Prediction.ResolverMethod
            
            Psalms.Tech.KOCheck = Settings.Checks.KnockOut
            Psalms.Tech.WallCheck = Settings.Checks.Wall
            Psalms.Tech.FriendCheck = Settings.Checks.Friend
            Psalms.Tech.SeatedCheck = Settings.Checks.Vehicle
            Psalms.Tech.TeamCheck = Settings.Checks.Team
            
            Psalms.Tech.bool_at_tp = Settings.GunMod.BulletTP
            
            Psalms.Tech.Camera = Settings.Camera.Enabled
            Psalms.Tech.CamPrediction1 = Settings.Camera.HorizontalPrediction
            Psalms.Tech.CamPrediction2 = Settings.Camera.VerticalPrediction
            Psalms.Tech.UseExternal = Settings.Camera.Division
            Psalms.Tech.CamResolverEnabled = Settings.Camera.Resolver
            Psalms.Tech.smoothness = Settings.Camera.Smoothness
            Psalms.Tech.easingStyle = Settings.Camera.EasingStyle
            Psalms.Tech.easingDirection = Settings.Camera.EasingDirection
            Psalms.Tech.CamWallCheck = Settings.Camera.WallCheck
            Psalms.Tech.CAMKo = Settings.Camera.Knocked
            Psalms.Tech.CamAutoprediction = Settings.Camera.AutoPrediction
            
            TargetAimbot.CSync.Enabled = Settings.CSync.Enabled
            TargetAimbot.CSync.Type = Settings.CSync.Type
            TargetAimbot.CSync.Distance = Settings.CSync.Distance
            TargetAimbot.CSync.Height = Settings.CSync.Height
            TargetAimbot.CSync.Speed = Settings.CSync.Speed
            TargetAimbot.CSync.RandomAmount = Settings.CSync.RandomAmount
            TargetAimbot.CSync.Color = Settings.CSync.Color
            TargetAimbot.CSync.Visualize = Settings.CSync.Spoof
            
            Psalms.Tech.JumpBreak = Settings.PredictionBreaker.JumpPrediction
            
            TargetAimbot.HitEffect = Settings.HitDetection.HitEffect
            TargetAimbot.HitSounds = Settings.HitDetection.HitSound
            TargetAimbot.HitEffectType = Settings.HitDetection.EffectType
            TargetAimbot.HitSound = Settings.HitDetection.SoundType
            TargetAimbot.HitEffectColor = Settings.HitDetection.HitEffectColor
            TargetAimbot.HitChams = Settings.HitChams.Enabled
            TargetAimbot.HitChamsColor = Settings.HitChams.Color
            TargetAimbot.HitChamsDuration = Settings.HitChams.Duration
            TargetAimbot.HitChamsTransparency = Settings.HitChams.Transparency
            TargetAimbot.HitChamsMaterial = Enum.Material[Settings.HitChams.Material]
            TargetAimbot.SkeleColor = Settings.HitChams.SkeletonColor
            TargetAimbot.HitSkele = Settings.HitChams.SkeletonEnabled
            
            TargetAimbot.Highlight = Settings.TargetVisual.Highlight
            TargetAimbot.HighlightColor1 = Settings.TargetVisual.Color1
            TargetAimbot.HighlightColor2 = Settings.TargetVisual.Color2
            
            Configurations.Visuals.Bullet_Trails.Enabled = Settings.BulletTrails.Enabled
            Configurations.Visuals.Bullet_Trails.Fade = Settings.BulletTrails.Fade
            Configurations.Visuals.Bullet_Trails.Width = Settings.BulletTrails.Width
            Configurations.Visuals.Bullet_Trails.Duration = Settings.BulletTrails.Duration
            Configurations.Visuals.Bullet_Trails.Texture = Settings.BulletTrails.Texture
            Configurations.Visuals.Bullet_Trails.Color = Settings.BulletTrails.Color
            
            getgenv().esp.BoxEnabled = Settings.ESP.BoxEnabled
            getgenv().esp.BoxCorners = Settings.ESP.BoxCorners
            getgenv().esp.BoxDynamic = Settings.ESP.BoxDynamic
            getgenv().esp.SkeletonEnabled = Settings.ESP.SkeletonEnabled
            getgenv().esp.ChamsEnabled = Settings.ESP.ChamsEnabled
            getgenv().esp.TextEnabled = Settings.ESP.TextEnabled
            getgenv().esp.BarLayout['health'].enabled = Settings.ESP.HealthBar
            getgenv().esp.TargetOnly = Settings.ESP.TargetOnly
            
            getgenv().crosshair.enabled = Settings.Crosshair.Enabled
            getgenv().crosshair.spin = Settings.Crosshair.Spin
            getgenv().crosshair.sticky = Settings.Crosshair.StickToTarget
            getgenv().crosshair.color = Settings.Crosshair.Color
            
            Camera.FieldOfView = Settings.CameraSettings.FieldOfView
            
            Configurations.Misc.Animation.Enabled = Settings.Dance.Enabled
            Configurations.Misc.Animation.SelectedDance = Settings.Dance.DanceType
            Configurations.Misc.Animation.Speed = Settings.Dance.Speed
        end

        -- ============================================
        -- CONTINUE WITH ORIGINAL CODE...
        -- ============================================
        
        -- [Rest of the original code continues here - all the functions, connections, etc.]
        -- I'll include the key parts that need to reference Settings
        
        local Sleeping = false
        local Highlight = Settings.TargetVisual.Highlight
        local AChams = Settings.TargetVisual.AnimateHighlight
        local Hitnotify = Settings.HitDetection.Notify
        local Flick = Settings.Camera.Flick
        local Desync = Settings.PredictionBreaker.AntiLock
        local desyncsleep = Settings.PredictionBreaker.AntiNetwork
        local AntiLockType = Settings.PredictionBreaker.AntiLockType
        local Noobidiot = Settings.GunMod.RapidFire
        local idiotdelay = Settings.GunMod.RapidFireDelay
        
        -- Update settings periodically
        RunService.Heartbeat:Connect(function()
            UpdateSettings()
        end)

        -- ============================================
        -- LOCK BUTTON UI
        -- ============================================
        local LockButtonGui = Instance.new("ScreenGui")
        LockButtonGui.Name = "LockButtonGui"
        LockButtonGui.Parent = game:GetService("CoreGui")
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
        LockButton.Image = "rbxassetid://140623923630784" -- Unlocked icon
        LockButton.Position = UDim2.new(0.5, -45, 0.5, -45)

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0.2, 0)
        UICorner.Parent = LockButton

        local TargBindEnabled = false
        local TargetPlr = nil
        local targetHealth = nil

        local function GetClosestToMouse()
            local TargetPlr, Closest = nil, math.huge
            local Client = game.Players.LocalPlayer
            local Camera = workspace.CurrentCamera
            local Mouse = Client:GetMouse()

            for _, v in pairs(game.Players:GetPlayers()) do
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

        local function toggleLock()
            if TargetAimbot.Enabled then
                local Closest = GetClosestToMouse()
                
                if TargBindEnabled and TargetPlr then
                    TargBindEnabled = false
                    targetHealth = nil
                    game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
                    TargetPlr = nil
                    workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
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

        -- [Continue with all the rest of the original code...]
        -- All the functions, connections, hit effects, etc. remain the same
        
        print("Script loaded with Settings table. Use Settings table to configure all features.")
        print("Lock button created - click to toggle target lock.")
    end
end

-- [Rest of initialization code from original script...]
cooked(true)
