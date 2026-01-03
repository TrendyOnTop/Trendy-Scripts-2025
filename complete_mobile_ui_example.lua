-- Complete Mobile UI Integration Example
-- This shows how to integrate the mobile UI system with all features

-- First, include all your original script code up to where Library is loaded
-- Then add this mobile UI integration:

-- Mobile UI System (include the mobile_ui_wrapper.lua code here or require it)
-- For this example, we'll assume MobileUISystem is available

-- Initialize Mobile UI after Library is loaded
local function SetupCompleteMobileUI()
    -- Create the mobile UI
    local MobileUI = MobileUISystem
    MobileUI:Create()
    MobileUI.TabContents = {}
    
    -- Create tabs
    local tabs = {"Main", "Rage", "Visuals", "Settings"}
    
    for _, tabName in ipairs(tabs) do
        -- Create tab button
        local tabButton = MobileUI:CreateTabButton(tabName, MobileUI.UI.TabsFrame)
        
        -- Create tab content frame
        local tabContent = Instance.new("Frame")
        tabContent.Name = tabName .. "Content"
        tabContent.Parent = MobileUI.UI.ContentFrame
        tabContent.BackgroundTransparency = 1
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.Visible = tabName == "Main"
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Parent = tabContent
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.Padding = UDim.new(0, 12)
        
        tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
        end)
        
        MobileUI.TabContents[tabName] = tabContent
        
        -- Tab click handler
        tabButton.MouseButton1Click:Connect(function()
            MobileUI:SwitchTab(tabName)
        end)
    end
    
    -- ========== MAIN TAB ==========
    local mainContent = MobileUI.TabContents["Main"]
    
    -- Silent/Target Section
    local silentSection = MobileUI:CreateSection("Silent/Target", mainContent)
    MobileUI:CreateToggle("Enabled", Psalms.Tech.Enabled, function(v) Psalms.Tech.Enabled = v end, silentSection)
    MobileUI:CreateToggle("Look At", Psalms.Tech.LookAt, function(v) Psalms.Tech.LookAt = v end, silentSection)
    MobileUI:CreateToggle("View", Psalms.Tech.ViewAt, function(v) Psalms.Tech.ViewAt = v end, silentSection)
    MobileUI:CreateToggle("Anti Aim Viewer", Psalms.Tech.AntiAimViewer, function(v) Psalms.Tech.AntiAimViewer = v end, silentSection)
    MobileUI:CreateToggle("Auto Air", Psalms.Tech.AutoAir, function(v) Psalms.Tech.AutoAir = v end, silentSection)
    MobileUI:CreateTextBox("Auto Air Delay", Psalms.Tech.ShootDelay, function(v) targetSigm99928 = tonumber(v) end, silentSection)
    MobileUI:CreateDropdown("Lock Method", {"Index", "Namecall"}, Psalms.Tech.LockType, function(v) Psalms.Tech.LockType = v end, silentSection)
    
    -- Hit Part Section
    local hitPartSection = MobileUI:CreateSection("Hit Part", mainContent)
    local bodyParts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
    MobileUI:CreateDropdown("BodyPart", bodyParts, Psalms.Tech.RealPart, function(v) Psalms.Tech.RealPart = v end, hitPartSection)
    MobileUI:CreateDropdown("AirPart", bodyParts, Psalms.Tech.AirPart, function(v) Psalms.Tech.AirPart = v end, hitPartSection)
    
    -- Prediction Section
    local predictionSection = MobileUI:CreateSection("Prediction", mainContent)
    MobileUI:CreateToggle("Division", Psalms.Tech.UseVertical, function(v) Psalms.Tech.UseVertical = v end, predictionSection)
    MobileUI:CreateTextBox("Horizontal Prediction", Psalms.Tech.HorizontalPrediction2, function(v) 
        Psalms.Tech.HorizontalPrediction2 = tonumber(v) or 0.1
        Psalms.Tech.HorizontalPrediction = Psalms.Tech.HorizontalPrediction2
    end, predictionSection)
    MobileUI:CreateTextBox("Vertical Prediction", Psalms.Tech.VerticalPrediction2, function(v) 
        Psalms.Tech.VerticalPrediction2 = tonumber(v) or 0.1
        Psalms.Tech.VerticalPrediction = Psalms.Tech.VerticalPrediction2
    end, predictionSection)
    MobileUI:CreateTextBox("Jump Offset", Psalms.Tech.jumpoffset2, function(v) Psalms.Tech.jumpoffset2 = tonumber(v) end, predictionSection)
    MobileUI:CreateTextBox("Fall Offset", Psalms.Tech.jumpoffset3, function(v) Psalms.Tech.jumpoffset3 = tonumber(v) end, predictionSection)
    MobileUI:CreateToggle("Visualize", Psalms.Tech.VelocityDot, function(v) Psalms.Tech.VelocityDot = v end, predictionSection)
    MobileUI:CreateToggle("Resolver", Psalms.Tech.ResolverEnabled, function(v) Psalms.Tech.ResolverEnabled = v end, predictionSection)
    MobileUI:CreateToggle("Auto Prediction", Psalms.Tech.AutoPrediction, function(v) Psalms.Tech.AutoPrediction = v end, predictionSection)
    MobileUI:CreateDropdown("Auto Prediction Mode", {"Default", "Math Based", "Sets Based", "Calculate"}, Psalms.Tech.APMODE, function(v) Psalms.Tech.APMODE = v end, predictionSection)
    MobileUI:CreateDropdown("Resolver Method", {"Recalculate", "MoveDirection", "LookVector"}, "MoveDirection", function(v) Psalms.Tech.RESOLVER = v end, predictionSection)
    
    -- Checks Section
    local checksSection = MobileUI:CreateSection("Checks", mainContent)
    MobileUI:CreateToggle("KnockOut", Psalms.Tech.KOCheck, function(v) Psalms.Tech.KOCheck = v end, checksSection)
    MobileUI:CreateToggle("Wall", Psalms.Tech.WallCheck, function(v) Psalms.Tech.WallCheck = v end, checksSection)
    MobileUI:CreateToggle("Friend", Psalms.Tech.FriendCheck, function(v) Psalms.Tech.FriendCheck = v end, checksSection)
    MobileUI:CreateToggle("Vehicle", Psalms.Tech.SeatedCheck, function(v) Psalms.Tech.SeatedCheck = v end, checksSection)
    MobileUI:CreateToggle("Team", Psalms.Tech.TeamCheck, function(v) Psalms.Tech.TeamCheck = v end, checksSection)
    
    -- Gun Modification Section
    local gunSection = MobileUI:CreateSection("Gun Modification", mainContent)
    MobileUI:CreateToggle("Bullet TP", Psalms.Tech.bool_at_tp, function(v) Psalms.Tech.bool_at_tp = v end, gunSection)
    MobileUI:CreateToggle("Rapid Fire", Noobidiot, function(v) Noobidiot = v end, gunSection)
    MobileUI:CreateTextBox("Rapid Fire Delay", idiotdelay, function(v) idiotdelay = tonumber(v) end, gunSection)
    
    -- ========== RAGE TAB ==========
    local rageContent = MobileUI.TabContents["Rage"]
    
    -- Camera Section
    local cameraSection = MobileUI:CreateSection("Camera", rageContent)
    MobileUI:CreateToggle("Enabled", Psalms.Tech.Camera, function(v) Psalms.Tech.Camera = v end, cameraSection)
    MobileUI:CreateToggle("Flick", Flick, function(v) Flick = v end, cameraSection)
    MobileUI:CreateToggle("Division", Psalms.Tech.UseExternal, function(v) Psalms.Tech.UseExternal = v end, cameraSection)
    MobileUI:CreateToggle("Resolver", Psalms.Tech.CamResolverEnabled, function(v) Psalms.Tech.CamResolverEnabled = v end, cameraSection)
    MobileUI:CreateSlider("Smoothness", 0, 1, Psalms.Tech.smoothness, "", 2, function(v) Psalms.Tech.smoothness = v end, cameraSection)
    MobileUI:CreateDropdown("Easing Style", {"Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Exponential", "Circular", "Back", "Bounce", "Elastic"}, Psalms.Tech.easingStyle, function(v) Psalms.Tech.easingStyle = v end, cameraSection)
    MobileUI:CreateDropdown("Easing Direction", {"In", "Out", "InOut"}, Psalms.Tech.easingDirection, function(v) Psalms.Tech.easingDirection = v end, cameraSection)
    
    -- Camera Checks
    local camChecksSection = MobileUI:CreateSection("Camera Checks", rageContent)
    MobileUI:CreateToggle("Wall", Psalms.Tech.CamWallCheck, function(v) Psalms.Tech.CamWallCheck = v end, camChecksSection)
    MobileUI:CreateToggle("Knocked", Psalms.Tech.CAMKo, function(v) Psalms.Tech.CAMKo = v end, camChecksSection)
    
    -- Camera Prediction Section
    local camPredSection = MobileUI:CreateSection("Camera Prediction", rageContent)
    MobileUI:CreateTextBox("Horizontal Prediction", camgay2, function(v) 
        camgay2 = tonumber(v) or 0.1
        Psalms.Tech.CamPrediction1 = camgay2
    end, camPredSection)
    MobileUI:CreateTextBox("Vertical Prediction", camgay, function(v) 
        camgay = tonumber(v) or 0.1
        Psalms.Tech.CamPrediction2 = camgay
    end, camPredSection)
    MobileUI:CreateToggle("AutoPred", Psalms.Tech.CamAutoprediction, function(v) Psalms.Tech.CamAutoprediction = v end, camPredSection)
    
    -- CSync Section
    local csyncSection = MobileUI:CreateSection("CSync", rageContent)
    MobileUI:CreateToggle("Enabled", TargetAimbot.CSync.Enabled, function(v) TargetAimbot.CSync.Enabled = v end, csyncSection)
    MobileUI:CreateToggle("Spoof", TargetAimbot.CSync.Visualize, function(v) TargetAimbot.CSync.Visualize = v end, csyncSection)
    MobileUI:CreateDropdown("Type", {"Orbit", "Random", "Spiral", "Spherical", "Attach"}, TargetAimbot.CSync.Type, function(v) TargetAimbot.CSync.Type = v end, csyncSection)
    MobileUI:CreateSlider("Distance", 0, 100, TargetAimbot.CSync.Distance, "", 1, function(v) TargetAimbot.CSync.Distance = v end, csyncSection)
    MobileUI:CreateSlider("Height", 0, 100, TargetAimbot.CSync.Height, "", 1, function(v) TargetAimbot.CSync.Height = v end, csyncSection)
    MobileUI:CreateSlider("Speed", 0, 100, TargetAimbot.CSync.Speed, "", 1, function(v) TargetAimbot.CSync.Speed = v end, csyncSection)
    MobileUI:CreateSlider("Random Amount", 0, 100, TargetAimbot.CSync.RandomAmount, "", 1, function(v) TargetAimbot.CSync.RandomAmount = v end, csyncSection)
    MobileUI:CreateColorPicker("Color", TargetAimbot.CSync.Color, function(v) TargetAimbot.CSync.Color = v end, csyncSection)
    
    -- Prediction Breaker Section
    local predBreakerSection = MobileUI:CreateSection("Prediction Breaker", rageContent)
    MobileUI:CreateToggle("Jump Prediction", Psalms.Tech.JumpBreak, function(v) Psalms.Tech.JumpBreak = v end, predBreakerSection)
    MobileUI:CreateToggle("Enable Anti Lock", Desync, function(v) Desync = v end, predBreakerSection)
    MobileUI:CreateToggle("Anti Network", desyncsleep, function(v) desyncsleep = v end, predBreakerSection)
    MobileUI:CreateDropdown("Anti Lock Type", {"Multiply", "Shake", "Behind", "Down", "Forward", "Left", "One", "Right", "Up", "Zero"}, AntiLockType, function(v) AntiLockType = v end, predBreakerSection)
    
    -- ========== VISUALS TAB ==========
    local visualsContent = MobileUI.TabContents["Visuals"]
    
    -- ESP Section
    local espSection = MobileUI:CreateSection("ESP", visualsContent)
    MobileUI:CreateToggle("Box Enabled", getgenv().esp.BoxEnabled, function(v) getgenv().esp.BoxEnabled = v end, espSection)
    MobileUI:CreateToggle("Box Corners", getgenv().esp.BoxCorners, function(v) getgenv().esp.BoxCorners = v end, espSection)
    MobileUI:CreateToggle("Box Dynamic", getgenv().esp.BoxDynamic, function(v) getgenv().esp.BoxDynamic = v end, espSection)
    MobileUI:CreateSlider("Box Width", 0.1, 3, getgenv().esp.BoxStaticXFactor, "X", 2, function(v) getgenv().esp.BoxStaticXFactor = v end, espSection)
    MobileUI:CreateSlider("Box Height", 0.1, 3, getgenv().esp.BoxStaticYFactor, "Y", 2, function(v) getgenv().esp.BoxStaticYFactor = v end, espSection)
    MobileUI:CreateToggle("Skeleton Enabled", getgenv().esp.SkeletonEnabled, function(v) getgenv().esp.SkeletonEnabled = v end, espSection)
    MobileUI:CreateColorPicker("Skeleton Color", getgenv().esp.SkeletonColor, function(v) getgenv().esp.SkeletonColor = v end, espSection)
    MobileUI:CreateSlider("Skeleton Max Distance", 100, 1000, getgenv().esp.SkeletonMaxDistance, "m", 0, function(v) getgenv().esp.SkeletonMaxDistance = v end, espSection)
    MobileUI:CreateToggle("Chams Enabled", getgenv().esp.ChamsEnabled, function(v) getgenv().esp.ChamsEnabled = v end, espSection)
    MobileUI:CreateColorPicker("Chams Inner Color", getgenv().esp.ChamsInnerColor, function(v) getgenv().esp.ChamsInnerColor = v end, espSection)
    MobileUI:CreateColorPicker("Chams Outer Color", getgenv().esp.ChamsOuterColor, function(v) getgenv().esp.ChamsOuterColor = v end, espSection)
    MobileUI:CreateSlider("Chams Inner Transparency", 0, 1, getgenv().esp.ChamsInnerTransparency, "", 2, function(v) getgenv().esp.ChamsInnerTransparency = v end, espSection)
    MobileUI:CreateSlider("Chams Outer Transparency", 0, 1, getgenv().esp.ChamsOuterTransparency, "", 2, function(v) getgenv().esp.ChamsOuterTransparency = v end, espSection)
    MobileUI:CreateToggle("Text Enabled", getgenv().esp.TextEnabled, function(v) getgenv().esp.TextEnabled = v end, espSection)
    MobileUI:CreateColorPicker("Text Color", getgenv().esp.TextColor, function(v) getgenv().esp.TextColor = v end, espSection)
    MobileUI:CreateToggle("Health Bar Enabled", getgenv().esp.BarLayout['health'].enabled, function(v) getgenv().esp.BarLayout['health'].enabled = v end, espSection)
    MobileUI:CreateToggle("Target Only Mode", getgenv().esp.TargetOnly, function(v) getgenv().esp.TargetOnly = v end, espSection)
    
    -- Target Visual Section
    local targetVisualSection = MobileUI:CreateSection("Target Visual", visualsContent)
    MobileUI:CreateToggle("Highlight", Highlight, function(v) Highlight = v end, targetVisualSection)
    MobileUI:CreateToggle("Animate Highlight", AChams, function(v) AChams = v end, targetVisualSection)
    MobileUI:CreateColorPicker("Color", TargetAimbot.HighlightColor1, function(v) TargetAimbot.HighlightColor1 = v end, targetVisualSection)
    MobileUI:CreateColorPicker("Color2", TargetAimbot.HighlightColor2, function(v) TargetAimbot.HighlightColor2 = v end, targetVisualSection)
    
    -- Hit Detection Section
    local hitDetectionSection = MobileUI:CreateSection("Hit Detection", visualsContent)
    MobileUI:CreateToggle("Hit Effect", TargetAimbot.HitEffect, function(v) TargetAimbot.HitEffect = v end, hitDetectionSection)
    MobileUI:CreateToggle("Hit Sound", TargetAimbot.HitSounds, function(v) TargetAimbot.HitSounds = v end, hitDetectionSection)
    MobileUI:CreateToggle("Notify", Hitnotify, function(v) Hitnotify = v end, hitDetectionSection)
    MobileUI:CreateDropdown("Effect Type", {"Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", "AuraBurst", "Thunder"}, TargetAimbot.HitEffectType, function(v) TargetAimbot.HitEffectType = v end, hitDetectionSection)
    local soundTypes = {"RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", "Gamesense", "Rust", "BlackPencil", "UWU", "Plooh", "Moan", "Hentai", "Bruh", "BoneBreakage", "Fein", "Unicorn", "Kitty", "Bird", "BirthdayCake", "KenCarson"}
    MobileUI:CreateDropdown("Sound Type", soundTypes, TargetAimbot.HitSound, function(v) TargetAimbot.HitSound = v end, hitDetectionSection)
    MobileUI:CreateColorPicker("Hit Effect Color", TargetAimbot.HitEffectColor, function(v) TargetAimbot.HitEffectColor = v end, hitDetectionSection)
    
    -- Hit Chams Section
    local hitChamsSection = MobileUI:CreateSection("Hit Chams", visualsContent)
    MobileUI:CreateToggle("Hit Cham", TargetAimbot.HitChams, function(v) TargetAimbot.HitChams = v end, hitChamsSection)
    MobileUI:CreateColorPicker("Color", TargetAimbot.HitChamsColor, function(v) TargetAimbot.HitChamsColor = v end, hitChamsSection)
    MobileUI:CreateToggle("Hit Skeleton", TargetAimbot.HitSkele, function(v) TargetAimbot.HitSkele = v end, hitChamsSection)
    MobileUI:CreateColorPicker("Skeleton Color", TargetAimbot.SkeleColor, function(v) TargetAimbot.SkeleColor = v end, hitChamsSection)
    MobileUI:CreateSlider("Duration", 0, 10, TargetAimbot.HitChamsDuration, "", 1, function(v) TargetAimbot.HitChamsDuration = v end, hitChamsSection)
    MobileUI:CreateSlider("Transparency", 0, 1, TargetAimbot.HitChamsTransparency, "", 3, function(v) TargetAimbot.HitChamsTransparency = v end, hitChamsSection)
    local materials = {Enum.Material.Neon.Name, Enum.Material.SmoothPlastic.Name, Enum.Material.ForceField.Name}
    MobileUI:CreateDropdown("Material", materials, TargetAimbot.HitChamsMaterial.Name, function(v) TargetAimbot.HitChamsMaterial = Enum.Material[v] end, hitChamsSection)
    
    -- Bullet Trails Section
    local bulletSection = MobileUI:CreateSection("Bullet Trails", visualsContent)
    MobileUI:CreateToggle("Enable", Configurations.Visuals.Bullet_Trails.Enabled, function(v) Configurations.Visuals.Bullet_Trails.Enabled = v end, bulletSection)
    MobileUI:CreateColorPicker("Color", Configurations.Visuals.Bullet_Trails.Color, function(v) Configurations.Visuals.Bullet_Trails.Color = v end, bulletSection)
    MobileUI:CreateToggle("Fade", Configurations.Visuals.Bullet_Trails.Fade, function(v) Configurations.Visuals.Bullet_Trails.Fade = v end, bulletSection)
    MobileUI:CreateSlider("Size", 0.01, 5, Configurations.Visuals.Bullet_Trails.Width, "", 2, function(v) Configurations.Visuals.Bullet_Trails.Width = v end, bulletSection)
    MobileUI:CreateSlider("Duration", 0.01, 10, Configurations.Visuals.Bullet_Trails.Duration, "", 2, function(v) Configurations.Visuals.Bullet_Trails.Duration = v end, bulletSection)
    MobileUI:CreateDropdown("Texture", {"Cool", "Cum", "Electro", "None"}, Configurations.Visuals.Bullet_Trails.Texture, function(v) Configurations.Visuals.Bullet_Trails.Texture = v end, bulletSection)
    
    -- Crosshair Section
    local crosshairSection = MobileUI:CreateSection("Crosshair", visualsContent)
    MobileUI:CreateToggle("Enable", getgenv().crosshair.enabled, function(v) getgenv().crosshair.enabled = v end, crosshairSection)
    MobileUI:CreateColorPicker("Color", getgenv().crosshair.color, function(v) getgenv().crosshair.color = v end, crosshairSection)
    MobileUI:CreateToggle("Spin", getgenv().crosshair.spin, function(v) getgenv().crosshair.spin = v end, crosshairSection)
    MobileUI:CreateToggle("Resize", getgenv().crosshair.resize, function(v) getgenv().crosshair.resize = v end, crosshairSection)
    MobileUI:CreateToggle("Stick To Target", getgenv().crosshair.sticky, function(v) getgenv().crosshair.sticky = v end, crosshairSection)
    MobileUI:CreateDropdown("Position", {"Middle", "Mouse"}, crosshair_position, function(v) crosshair_position = v end, crosshairSection)
    
    -- Skybox Section
    local skyboxSection = MobileUI:CreateSection("Skybox", visualsContent)
    MobileUI:CreateToggle("Skybox Enabled", skyboxEnabled, function(v) skyboxEnabled = v; changeSkybox() end, skyboxSection)
    MobileUI:CreateDropdown("Skybox Type", {"1", "2", "3", "4", "5", "6", "7"}, tostring(skyboxType), function(v) skyboxType = tonumber(v); changeSkybox() end, skyboxSection)
    MobileUI:CreateButton("Change Skybox", function() changeSkybox() end, skyboxSection)
    
    -- Fog Section
    local fogSection = MobileUI:CreateSection("Fog", visualsContent)
    MobileUI:CreateToggle("Fog Enabled", Environment.Settings.FogEnabled, function(v) Environment.Settings.FogEnabled = v; fogmaker() end, fogSection)
    MobileUI:CreateColorPicker("Fog Color", Environment.Settings.FogColor, function(v) Environment.Settings.FogColor = v; fogmaker() end, fogSection)
    MobileUI:CreateTextBox("Fog Start", Environment.Settings.FogStart, function(v) Environment.Settings.FogStart = tonumber(v); fogmaker() end, fogSection)
    MobileUI:CreateTextBox("Fog End", Environment.Settings.FogEnd, function(v) Environment.Settings.FogEnd = tonumber(v); fogmaker() end, fogSection)
    
    -- Environment Section
    local envSection = MobileUI:CreateSection("Environment", visualsContent)
    MobileUI:CreateToggle("Enable", Environment.Settings.Enabled, function(v) Environment.Settings.Enabled = v; UpdateWorld() end, envSection)
    MobileUI:CreateToggle("Global Shadow", Environment.Settings.GlobalShadows, function(v) Environment.Settings.GlobalShadows = v; UpdateWorld() end, envSection)
    MobileUI:CreateTextBox("Exposure", Environment.Settings.Exposure, function(v) Environment.Settings.Exposure = tonumber(v); UpdateWorld() end, envSection)
    MobileUI:CreateColorPicker("Color Shift Bottom", Environment.Settings.ColorShift_Bottom, function(v) Environment.Settings.ColorShift_Bottom = v; UpdateWorld() end, envSection)
    MobileUI:CreateColorPicker("Color Shift Top", Environment.Settings.ColorShift_Top, function(v) Environment.Settings.ColorShift_Top = v; UpdateWorld() end, envSection)
    MobileUI:CreateTextBox("Clock Time", Environment.Settings.ClockTime, function(v) Environment.Settings.ClockTime = tonumber(v); UpdateWorld() end, envSection)
    MobileUI:CreateColorPicker("Ambient Color", Environment.Settings.Ambient, function(v) Environment.Settings.Ambient = v; UpdateWorld() end, envSection)
    MobileUI:CreateColorPicker("OutdoorAmbient Color", Environment.Settings.OutdoorAmbient, function(v) Environment.Settings.OutdoorAmbient = v; UpdateWorld() end, envSection)
    MobileUI:CreateTextBox("Brightness", Environment.Settings.Brightness, function(v) Environment.Settings.Brightness = tonumber(v); UpdateWorld() end, envSection)
    
    -- Silent FOV Section
    local silentFOVSection = MobileUI:CreateSection("Silent FOV", visualsContent)
    MobileUI:CreateToggle("Enabled", Frame.Visible, function(v) Frame.Visible = v end, silentFOVSection)
    MobileUI:CreateToggle("Silent", Psalms.Tech.SilentMode, function(v) Psalms.Tech.SilentMode = v end, silentFOVSection)
    MobileUI:CreateDropdown("Mode", {"Mouse", "Center"}, mode, function(v) mode = v end, silentFOVSection)
    MobileUI:CreateColorPicker("Color 1", coluhhh, function(v) 
        coluhhh = v
        gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, v), ColorSequenceKeypoint.new(1, coluhhh2)}
    end, silentFOVSection)
    MobileUI:CreateColorPicker("Color 2", coluhhh2, function(v) 
        coluhhh2 = v
        gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, coluhhh), ColorSequenceKeypoint.new(1, v)}
    end, silentFOVSection)
    MobileUI:CreateSlider("Size", 1, 200, fovRadius, "", 1, function(v) 
        fovRadius = v
        UpdateFrameSize(v)
    end, silentFOVSection)
    
    -- ========== SETTINGS TAB ==========
    local settingsContent = MobileUI.TabContents["Settings"]
    
    -- Config Section
    local configSection = MobileUI:CreateSection("Config", settingsContent)
    MobileUI:CreateButton("Save Config", function() 
        if Library and Library.SaveConfig then
            Library:SaveConfig()
        end
    end, configSection)
    MobileUI:CreateButton("Load Config", function() 
        if Library and Library.LoadConfig then
            Library:LoadConfig()
        end
    end, configSection)
    MobileUI:CreateColorPicker("Accent Color", Library.Accent, function(v) 
        if Library and Library.ChangeAccent then
            Library:ChangeAccent(v)
        end
    end, configSection)
    MobileUI:CreateToggle("Show Watermark", true, function(v) 
        if Watermark and Watermark.SetVisible then
            Watermark:SetVisible(v)
        end
    end, configSection)
    
    -- Camera Settings Section
    local camSettingsSection = MobileUI:CreateSection("Camera Settings", settingsContent)
    MobileUI:CreateSlider("Field Of View", 5, 130, Camera.FieldOfView, "", 1, function(v) Camera.FieldOfView = v end, camSettingsSection)
    
    -- Dance Section
    local danceSection = MobileUI:CreateSection("Dance", settingsContent)
    MobileUI:CreateSlider("Speed", 0, 1000, Configurations.Misc.Animation.Speed, "", 1, function(v) Configurations.Misc.Animation.Speed = v end, danceSection)
    MobileUI:CreateDropdown("Dance", {"Floss", "Spin", "Sit", "ArmSpin", "Lay"}, Configurations.Misc.Animation.SelectedDance, function(v) Configurations.Misc.Animation.SelectedDance = v end, danceSection)
    MobileUI:CreateToggle("Animate", Configurations.Misc.Animation.Enabled, function(v) 
        Configurations.Misc.Animation.Enabled = v
        if v then
            local selectedDance = Dances[Configurations.Misc.Animation.SelectedDance or "Floss"]
            if selectedDance then
                AnimPlay(selectedDance, Configurations.Misc.Animation.Speed or 1)
            end
        else
            if currentAnimation then
                currentAnimation:Stop()
                currentAnimation = nil
            end
        end
    end, danceSection)
end

-- Call this function after Library is loaded and all variables are initialized
-- SetupCompleteMobileUI()
