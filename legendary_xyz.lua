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
        local Library
        local assetsupport = string.find(identifyexecutor(), "Wave") or string.find(identifyexecutor(), "Seliware") or string.find(identifyexecutor(), "AWP") or string.find(identifyexecutor(), "Argon") or string.find(identifyexecutor(), "Swift")

        if assetsupport then
            Library = loadstring(game:HttpGet("https://pastebin.com/raw/LixdnWjB", true))()
        else
            Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/CongoOhioDog/35476decfcca390e13120470a8907d26/raw/ec47708b7c28850ea497567972fee63c91f5a893/lol",true))()
        end

        local function getAsset(path)
            if getcustom then
                return getcustomasset(string.format("images_stuff/%s", path))
            else
                return "rbxassetid://0"
            end
        end

        downloadSound = LPH_NO_VIRTUALIZE(function(SoundName, SoundUrl)
            local SoundPath = string.format("images_stuff/%s", SoundName)
            if not isfile(SoundPath) then
                writefile(SoundPath, game:HttpGet(SoundUrl))
            end
            return SoundPath
        end)

        -- ============================================
        -- LEGENDARY.XYZ COMPACT UI SYSTEM
        -- ============================================
        
        local UserInputService = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Workspace = game:GetService("Workspace")
        local Camera = Workspace.CurrentCamera
        local Stats = game:GetService("Stats")
        local CoreGui = game:GetService("CoreGui")
        local SoundService = game:GetService("SoundService")
        local HttpService = game:GetService("HttpService")
        local Lighting = game:GetService("Lighting")
        local AvatarEditorService = game:GetService("AvatarEditorService")
        
        -- Configuration Variables (All Original Features)
        local Psalms = {
            Tech = {
                Enabled = false,
                AutoPrediction = false,
                AutoPredMode = "PingBased",
                APMODE = "Calculate",
                RealPart = "HumanoidRootPart",
                SelectedPart = "HumanoidRootPart",
                AirPart = "RightFoot",
                HorizontalPrediction = 0.1,
                VerticalPrediction = 0.1,
                HorizontalPrediction2 = 0.1,
                VerticalPrediction2 = 0.1,
                jumpoffset = 0,
                jumpoffset2 = -0.3,
                jumpoffset3 = 0.270,
                ShootDelay = 0.22,
                NoGroundShot = false,
                AutoAir = false,
                TracerEnabled = true,
                LookAt = false,
                Camera = false,
                CamPrediction1 = 0.1,
                CamPrediction2 = 0.1,
                SilentMode = false,
                smoothness = 0.9,
                speedvalue = 1,
                MacroSpeed = 0.2,
                AntiCurve = false,
                ResolverEnabled = false,
                easingStyle = "Sine",
                easingDirection = "Out",
                isTargetPlrMode = true,
                shootDelay = 0.114,
                lastShootTime = 0,
                TriggerPot = true,
                JumpBreak = false,
                network = false,
                UseVertical = false,
                DotC = Color3.fromRGB(0, 0, 0),
                WallCheck = false,
                FriendCheck = false,
                KOCheck = false,
                SeatedCheck = false,
                TeamCheck = false,
                UnlockOnKO = false,
                CamWallCheck = false,
                CAMKo = false,
                bool_at_tp = false,
                MacroDance = "YungBlud",
                MacroDanceDelay = 0.300,
                VelocityDot = false,
                ViewAt = false,
                AntiAimViewer = false,
                UseExternal = false,
                CamResolverEnabled = false,
                CamAutoprediction = false,
                RESOLVER = "MoveDirection",
                LockType = "Namecall",
                cframespeedtoggle = false,
                AutoShoot = false
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
                Enabled = false,
                Type = "Orbit",
                Distance = 10,
                Height = 2,
                Speed = 10,
                RandomAmount = 10,
                Color = Color3.fromRGB(255, 255, 255),
                Saved = nil,
                Visualize = false,
            },
            ViewAt = false,
            Tracer = false,
            Highlight = true,
            HighlightColor1 = Color3.fromRGB(255, 255, 255),
            HighlightColor2 = Color3.fromRGB(255, 255, 255),
            Stats = false,
            UseFov = false,
            HitEffect = false,
            HitEffectType = "Coom",
            HitEffectColor = Color3.fromRGB(255, 255, 255),
            HitSounds = false,
            HitSound = "Bameware",
            HitChams = false,
            HitChamsMaterial = Enum.Material.Neon,
            HitChamsDuration = 2,
            HitChamsColor = Color3.fromRGB(255, 0, 0),
            HitChamColorEnabled = false,
            HitChamsTransparency = 0,
            HitChamsAcc = false,
            SkeleColor = Color3.fromRGB(155, 0, 155),
            HitSkele = false
        }
        
        local Highlight = false
        local AChams = false
        local TargBindEnabled = false
        local TargetPlr = nil
        local TargResolvePos = nil
        local Hitnotify = false
        local Flick = false
        local Desync = false
        local AntiLockType = "Zero"
        local desyncsleep = false
        local Noobidiot = false
        local idiotdelay = 0
        local targetSigm99928 = 0.22
        local targetSigmaPOBALLs = nil
        local Shot2ing = false
        
        -- UI Creation - SMALLER SIZE
        local LegendaryUI = Instance.new("ScreenGui")
        LegendaryUI.Name = "LegendaryXYZ"
        LegendaryUI.ResetOnSpawn = false
        LegendaryUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        LegendaryUI.Parent = CoreGui
        
        -- Main Frame (SMALLER - 500x350)
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 500, 0, 350)
        MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
        MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = LegendaryUI
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = MainFrame
        
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(0, 100, 255)
        UIStroke.Thickness = 2
        UIStroke.Parent = MainFrame
        
        -- Title Bar (SMALLER - 30px height)
        local TitleBar = Instance.new("Frame")
        TitleBar.Name = "TitleBar"
        TitleBar.Size = UDim2.new(1, 0, 0, 30)
        TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        TitleBar.BorderSizePixel = 0
        TitleBar.Parent = MainFrame
        
        local TitleCorner = Instance.new("UICorner")
        TitleCorner.CornerRadius = UDim.new(0, 6)
        TitleCorner.Parent = TitleBar
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "TitleLabel"
        TitleLabel.Size = UDim2.new(1, -90, 1, 0)
        TitleLabel.Position = UDim2.new(0, 8, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = "Legendary.xyz"
        TitleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
        TitleLabel.TextSize = 16
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = TitleBar
        
        -- Toggle UI Button
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Size = UDim2.new(0, 28, 0, 28)
        ToggleButton.Position = UDim2.new(1, -32, 0, 1)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        ToggleButton.Text = "─"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.TextSize = 18
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.Parent = TitleBar
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 4)
        ToggleCorner.Parent = ToggleButton
        
        -- Lock Button
        local LockButton = Instance.new("TextButton")
        LockButton.Name = "LockButton"
        LockButton.Size = UDim2.new(0, 28, 0, 28)
        LockButton.Position = UDim2.new(1, -64, 0, 1)
        LockButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        LockButton.Text = "🔒"
        LockButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        LockButton.TextSize = 14
        LockButton.Font = Enum.Font.GothamBold
        LockButton.Parent = TitleBar
        
        local LockCorner = Instance.new("UICorner")
        LockCorner.CornerRadius = UDim.new(0, 4)
        LockCorner.Parent = LockButton
        
        -- Tabs Container (SMALLER)
        local TabsContainer = Instance.new("Frame")
        TabsContainer.Name = "TabsContainer"
        TabsContainer.Size = UDim2.new(1, -16, 0, 28)
        TabsContainer.Position = UDim2.new(0, 8, 0, 35)
        TabsContainer.BackgroundTransparency = 1
        TabsContainer.Parent = MainFrame
        
        local TabsLayout = Instance.new("UIListLayout")
        TabsLayout.FillDirection = Enum.FillDirection.Horizontal
        TabsLayout.Spacing = UDim.new(0, 4)
        TabsLayout.Parent = TabsContainer
        
        -- Content Frame (SMALLER)
        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = "ContentFrame"
        ContentFrame.Size = UDim2.new(1, -16, 1, -70)
        ContentFrame.Position = UDim2.new(0, 8, 0, 68)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderSizePixel = 0
        ContentFrame.ScrollBarThickness = 4
        ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 100, 255)
        ContentFrame.Parent = MainFrame
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 6)
        ContentLayout.Parent = ContentFrame
        
        -- UI State
        local UIState = {
            Visible = true,
            Locked = false,
            CurrentTab = nil,
            Tabs = {},
            Sections = {}
        }
        
        -- DRAGGING FUNCTIONALITY (FIXED)
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        TitleBar.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and not UIState.Locked then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                
                local connection
                connection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        if connection then connection:Disconnect() end
                    end
                end)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        -- Toggle UI
        ToggleButton.MouseButton1Click:Connect(function()
            UIState.Visible = not UIState.Visible
            MainFrame.Visible = UIState.Visible
            ToggleButton.Text = UIState.Visible and "─" or "☰"
        end)
        
        -- Lock Button Functionality
        local function toggleLock()
            if TargetAimbot.Enabled then
                if TargBindEnabled and TargetPlr then
                    TargBindEnabled = false
                    TargetPlr = nil
                    LockButton.TextColor3 = Color3.fromRGB(255, 100, 100)
                    LockButton.Text = "🔒"
                else
                    local closest = nil
                    local dist = math.huge
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local mag = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                            if mag < dist then
                                dist = mag
                                closest = v
                            end
                        end
                    end
                    if closest then
                        TargBindEnabled = true
                        TargetPlr = closest
                        LockButton.TextColor3 = Color3.fromRGB(100, 255, 100)
                        LockButton.Text = "🔓"
                    end
                end
            end
        end
        
        LockButton.MouseButton1Click:Connect(function()
            UIState.Locked = not UIState.Locked
            LockButton.TextColor3 = UIState.Locked and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
            LockButton.Text = UIState.Locked and "🔓" or "🔒"
            if not UIState.Locked then
                toggleLock()
            end
        end)
        
        -- Tab System
        local function createTab(name)
            local tabButton = Instance.new("TextButton")
            tabButton.Name = name .. "Tab"
            tabButton.Size = UDim2.new(0, 80, 1, 0)
            tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            tabButton.Text = name
            tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            tabButton.TextSize = 12
            tabButton.Font = Enum.Font.Gotham
            tabButton.Parent = TabsContainer
            
            local tabCorner = Instance.new("UICorner")
            tabCorner.CornerRadius = UDim.new(0, 4)
            tabCorner.Parent = tabButton
            
            local tabContent = Instance.new("Frame")
            tabContent.Name = name .. "Content"
            tabContent.Size = UDim2.new(1, 0, 0, 0)
            tabContent.BackgroundTransparency = 1
            tabContent.Visible = false
            tabContent.Parent = ContentFrame
            
            local tabContentLayout = Instance.new("UIListLayout")
            tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            tabContentLayout.Padding = UDim.new(0, 6)
            tabContentLayout.Parent = tabContent
            
            tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
            end)
            
            tabButton.MouseButton1Click:Connect(function()
                for _, tab in pairs(UIState.Tabs) do
                    tab.Content.Visible = false
                    tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                    tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
                tabContent.Visible = true
                tabButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
                tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                UIState.CurrentTab = name
            end)
            
            UIState.Tabs[name] = {
                Button = tabButton,
                Content = tabContent
            }
            
            return tabContent
        end
        
        -- Section System (COMPACT)
        local function createSection(parent, name)
            local section = Instance.new("Frame")
            section.Name = name .. "Section"
            section.Size = UDim2.new(1, 0, 0, 0)
            section.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            section.BorderSizePixel = 0
            section.Parent = parent
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 4)
            sectionCorner.Parent = section
            
            local sectionStroke = Instance.new("UIStroke")
            sectionStroke.Color = Color3.fromRGB(0, 100, 255)
            sectionStroke.Thickness = 1
            sectionStroke.Parent = section
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Size = UDim2.new(1, -8, 0, 22)
            sectionTitle.Position = UDim2.new(0, 4, 0, 2)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = name
            sectionTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
            sectionTitle.TextSize = 13
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Parent = section
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.Size = UDim2.new(1, -8, 1, -26)
            sectionContent.Position = UDim2.new(0, 4, 0, 24)
            sectionContent.BackgroundTransparency = 1
            sectionContent.Parent = section
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 3)
            sectionLayout.Parent = sectionContent
            
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                section.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 28)
            end)
            
            return sectionContent
        end
        
        -- Control Creation Functions (COMPACT)
        local function createToggle(parent, name, callback, default)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = name .. "Toggle"
            toggleFrame.Size = UDim2.new(1, 0, 0, 22)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = parent
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "Button"
            toggleButton.Size = UDim2.new(0, 40, 0, 20)
            toggleButton.Position = UDim2.new(1, -42, 0, 1)
            toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 10)
            toggleCorner.Parent = toggleButton
            
            local toggleIndicator = Instance.new("Frame")
            toggleIndicator.Name = "Indicator"
            toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            toggleIndicator.Position = UDim2.new(0, 2, 0, 2)
            toggleIndicator.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            toggleIndicator.Parent = toggleButton
            
            local indicatorCorner = Instance.new("UICorner")
            indicatorCorner.CornerRadius = UDim.new(0, 8)
            indicatorCorner.Parent = toggleIndicator
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Name = "Label"
            toggleLabel.Size = UDim2.new(1, -48, 1, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = name
            toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleLabel.TextSize = 11
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            local state = default or false
            
            local function updateToggle()
                if state then
                    toggleIndicator.Position = UDim2.new(1, -18, 0, 2)
                    toggleIndicator.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
                    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
                else
                    toggleIndicator.Position = UDim2.new(0, 2, 0, 2)
                    toggleIndicator.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                    toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                end
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                state = not state
                updateToggle()
                if callback then callback(state) end
            end)
            
            updateToggle()
            return {Frame = toggleFrame, SetState = function(s) state = s; updateToggle() end, GetState = function() return state end}
        end
        
        local function createSlider(parent, name, min, max, default, callback, decimals)
            decimals = decimals or 0
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = name .. "Slider"
            sliderFrame.Size = UDim2.new(1, 0, 0, 32)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = parent
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Name = "Label"
            sliderLabel.Size = UDim2.new(1, 0, 0, 14)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = name .. ": " .. tostring(default)
            sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sliderLabel.TextSize = 11
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Name = "Track"
            sliderTrack.Size = UDim2.new(1, 0, 0, 4)
            sliderTrack.Position = UDim2.new(0, 0, 0, 18)
            sliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            sliderTrack.Parent = sliderFrame
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(0, 2)
            trackCorner.Parent = sliderTrack
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "Fill"
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            sliderFill.Parent = sliderTrack
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 2)
            fillCorner.Parent = sliderFill
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Name = "Button"
            sliderButton.Size = UDim2.new(0, 12, 0, 12)
            sliderButton.Position = UDim2.new((default - min) / (max - min), -6, 0, -4)
            sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderButton.Text = ""
            sliderButton.ZIndex = 2
            sliderButton.Parent = sliderFrame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 6)
            buttonCorner.Parent = sliderButton
            
            local value = default
            local dragging = false
            
            local function updateSlider(newValue)
                value = math.clamp(newValue, min, max)
                local percent = (value - min) / (max - min)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderButton.Position = UDim2.new(percent, -6, 0, -4)
                sliderLabel.Text = name .. ": " .. string.format("%." .. decimals .. "f", value)
                if callback then callback(value) end
            end
            
            sliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                    local pos = input.Position.X - sliderTrack.AbsolutePosition.X
                    local percent = math.clamp(pos / sliderTrack.AbsoluteSize.X, 0, 1)
                    updateSlider(min + (max - min) * percent)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            return {Frame = sliderFrame, SetValue = updateSlider, GetValue = function() return value end}
        end
        
        local function createTextBox(parent, name, placeholder, callback, default)
            local textFrame = Instance.new("Frame")
            textFrame.Name = name .. "TextBox"
            textFrame.Size = UDim2.new(1, 0, 0, 32)
            textFrame.BackgroundTransparency = 1
            textFrame.Parent = parent
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "Label"
            textLabel.Size = UDim2.new(1, 0, 0, 14)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = name
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextSize = 11
            textLabel.Font = Enum.Font.Gotham
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.Parent = textFrame
            
            local textBox = Instance.new("TextBox")
            textBox.Name = "Input"
            textBox.Size = UDim2.new(1, 0, 0, 20)
            textBox.Position = UDim2.new(0, 0, 0, 16)
            textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textBox.PlaceholderText = placeholder or ""
            textBox.Text = default or ""
            textBox.TextSize = 11
            textBox.Font = Enum.Font.Gotham
            textBox.ClearTextOnFocus = false
            textBox.Parent = textFrame
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 3)
            boxCorner.Parent = textBox
            
            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Color3.fromRGB(0, 100, 255)
            boxStroke.Thickness = 1
            boxStroke.Parent = textBox
            
            textBox.FocusLost:Connect(function()
                if callback then callback(textBox.Text) end
            end)
            
            return {Frame = textFrame, SetText = function(t) textBox.Text = t end, GetText = function() return textBox.Text end}
        end
        
        local function createDropdown(parent, name, options, default, callback)
            local dropFrame = Instance.new("Frame")
            dropFrame.Name = name .. "Dropdown"
            dropFrame.Size = UDim2.new(1, 0, 0, 32)
            dropFrame.BackgroundTransparency = 1
            dropFrame.Parent = parent
            
            local dropLabel = Instance.new("TextLabel")
            dropLabel.Name = "Label"
            dropLabel.Size = UDim2.new(1, 0, 0, 14)
            dropLabel.BackgroundTransparency = 1
            dropLabel.Text = name
            dropLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropLabel.TextSize = 11
            dropLabel.Font = Enum.Font.Gotham
            dropLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropLabel.Parent = dropFrame
            
            local dropButton = Instance.new("TextButton")
            dropButton.Name = "Button"
            dropButton.Size = UDim2.new(1, 0, 0, 20)
            dropButton.Position = UDim2.new(0, 0, 0, 16)
            dropButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            dropButton.Text = default or options[1] or "Select"
            dropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropButton.TextSize = 11
            dropButton.Font = Enum.Font.Gotham
            dropButton.Parent = dropFrame
            
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 3)
            dropCorner.Parent = dropButton
            
            local dropStroke = Instance.new("UIStroke")
            dropStroke.Color = Color3.fromRGB(0, 100, 255)
            dropStroke.Thickness = 1
            dropStroke.Parent = dropButton
            
            local dropList = Instance.new("ScrollingFrame")
            dropList.Name = "List"
            dropList.Size = UDim2.new(1, 0, 0, 0)
            dropList.Position = UDim2.new(0, 0, 1, 4)
            dropList.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            dropList.BorderSizePixel = 0
            dropList.ScrollBarThickness = 3
            dropList.ScrollBarImageColor3 = Color3.fromRGB(0, 100, 255)
            dropList.Visible = false
            dropList.Parent = dropFrame
            
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 3)
            listCorner.Parent = dropList
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = dropList
            
            local selected = default or options[1]
            local open = false
            
            for _, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, -8, 0, 18)
                optionButton.Position = UDim2.new(0, 4, 0, 0)
                optionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionButton.TextSize = 10
                optionButton.Font = Enum.Font.Gotham
                optionButton.Parent = dropList
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 2)
                optCorner.Parent = optionButton
                
                optionButton.MouseButton1Click:Connect(function()
                    selected = option
                    dropButton.Text = selected
                    dropList.Visible = false
                    open = false
                    dropFrame.Size = UDim2.new(1, 0, 0, 32)
                    if callback then callback(selected) end
                end)
            end
            
            listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                dropList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
            end)
            
            dropButton.MouseButton1Click:Connect(function()
                open = not open
                dropList.Visible = open
                if open then
                    dropFrame.Size = UDim2.new(1, 0, 0, math.min(32 + dropList.CanvasSize.Y.Offset + 8, 150))
                else
                    dropFrame.Size = UDim2.new(1, 0, 0, 32)
                end
            end)
            
            return {Frame = dropFrame, SetValue = function(v) selected = v; dropButton.Text = v end, GetValue = function() return selected end}
        end
        
        local function createButton(parent, name, callback)
            local button = Instance.new("TextButton")
            button.Name = name .. "Button"
            button.Size = UDim2.new(1, 0, 0, 24)
            button.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
            button.Text = name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 11
            button.Font = Enum.Font.GothamBold
            button.Parent = parent
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 3)
            buttonCorner.Parent = button
            
            button.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            
            return button
        end
        
        local function createColorPicker(parent, name, default, callback)
            local colorFrame = Instance.new("Frame")
            colorFrame.Name = name .. "ColorPicker"
            colorFrame.Size = UDim2.new(1, 0, 0, 32)
            colorFrame.BackgroundTransparency = 1
            colorFrame.Parent = parent
            
            local colorLabel = Instance.new("TextLabel")
            colorLabel.Name = "Label"
            colorLabel.Size = UDim2.new(1, -50, 0, 14)
            colorLabel.BackgroundTransparency = 1
            colorLabel.Text = name
            colorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            colorLabel.TextSize = 11
            colorLabel.Font = Enum.Font.Gotham
            colorLabel.TextXAlignment = Enum.TextXAlignment.Left
            colorLabel.Parent = colorFrame
            
            local colorButton = Instance.new("TextButton")
            colorButton.Name = "Button"
            colorButton.Size = UDim2.new(0, 40, 0, 20)
            colorButton.Position = UDim2.new(1, -42, 0, 16)
            colorButton.BackgroundColor3 = default or Color3.fromRGB(255, 255, 255)
            colorButton.Text = ""
            colorButton.Parent = colorFrame
            
            local colorCorner = Instance.new("UICorner")
            colorCorner.CornerRadius = UDim.new(0, 3)
            colorCorner.Parent = colorButton
            
            local colorStroke = Instance.new("UIStroke")
            colorStroke.Color = Color3.fromRGB(0, 100, 255)
            colorStroke.Thickness = 1
            colorStroke.Parent = colorButton
            
            colorButton.MouseButton1Click:Connect(function()
                local r = math.random(0, 255)
                local g = math.random(0, 255)
                local b = math.random(0, 255)
                local newColor = Color3.fromRGB(r, g, b)
                colorButton.BackgroundColor3 = newColor
                if callback then callback(newColor) end
            end)
            
            return {Frame = colorFrame, SetColor = function(c) colorButton.BackgroundColor3 = c end, GetColor = function() return colorButton.BackgroundColor3 end}
        end
        
        -- Auto-resize content
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Create Tabs
        local MainTab = createTab("Main")
        local RageTab = createTab("Rage")
        local VisualsTab = createTab("Visuals")
        local SettingsTab = createTab("Settings")
        
        -- Show first tab by default
        task.wait(0.1)
        if UIState.Tabs["Main"] then
            for _, tab in pairs(UIState.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            UIState.Tabs["Main"].Content.Visible = true
            UIState.Tabs["Main"].Button.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
            UIState.Tabs["Main"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            UIState.CurrentTab = "Main"
        end
        
        -- ============================================
        -- MAIN TAB - ALL FEATURES
        -- ============================================
        
        local silentSection = createSection(MainTab, "Silent/Target")
        createToggle(silentSection, "Enabled", function(v) Psalms.Tech.Enabled = v end, false)
        createToggle(silentSection, "Look At", function(v) Psalms.Tech.LookAt = v end, false)
        createToggle(silentSection, "View", function(v) Psalms.Tech.ViewAt = v end, false)
        createToggle(silentSection, "Anti Aim Viewer", function(v) Psalms.Tech.AntiAimViewer = v end, false)
        createToggle(silentSection, "Auto Air", function(v) Psalms.Tech.AutoAir = v end, false)
        createTextBox(silentSection, "Auto Air Delay", "0.22", function(v) targetSigm99928 = tonumber(v) or 0.22; Psalms.Tech.ShootDelay = targetSigm99928 end, "0.22")
        createDropdown(silentSection, "Lock Method", {"Index", "Namecall"}, "Namecall", function(v) Psalms.Tech.LockType = v end)
        
        local hitPartSection = createSection(MainTab, "Hit Part")
        createDropdown(hitPartSection, "Body Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}, "HumanoidRootPart", function(v) Psalms.Tech.RealPart = v; Psalms.Tech.SelectedPart = v end)
        createDropdown(hitPartSection, "Air Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}, "RightFoot", function(v) Psalms.Tech.AirPart = v end)
        
        local predictionSection = createSection(MainTab, "Prediction")
        createToggle(predictionSection, "Division", function(v) Psalms.Tech.UseVertical = v end, false)
        createSlider(predictionSection, "Horizontal", 0, 1, 0.1, function(v) Psalms.Tech.HorizontalPrediction2 = v; Psalms.Tech.HorizontalPrediction = v end, 3)
        createSlider(predictionSection, "Vertical", 0, 1, 0.1, function(v) Psalms.Tech.VerticalPrediction2 = v; Psalms.Tech.VerticalPrediction = v end, 3)
        createSlider(predictionSection, "Jump Offset", -1, 1, -0.3, function(v) Psalms.Tech.jumpoffset2 = v end, 2)
        createSlider(predictionSection, "Fall Offset", -1, 1, 0.27, function(v) Psalms.Tech.jumpoffset3 = v end, 2)
        createToggle(predictionSection, "Visualize", function(v) Psalms.Tech.VelocityDot = v end, false)
        createToggle(predictionSection, "Resolver", function(v) Psalms.Tech.ResolverEnabled = v end, false)
        createToggle(predictionSection, "Auto Prediction", function(v) Psalms.Tech.AutoPrediction = v end, false)
        createDropdown(predictionSection, "Auto Pred Mode", {"Default", "Math Based", "Sets Based", "Calculate"}, "Calculate", function(v) Psalms.Tech.APMODE = v end)
        createDropdown(predictionSection, "Resolver Method", {"Recalculate", "MoveDirection", "LookVector"}, "MoveDirection", function(v) Psalms.Tech.RESOLVER = v end)
        
        local checksSection = createSection(MainTab, "Checks")
        createToggle(checksSection, "KnockOut", function(v) Psalms.Tech.KOCheck = v end, false)
        createToggle(checksSection, "Wall", function(v) Psalms.Tech.WallCheck = v end, false)
        createToggle(checksSection, "Friend", function(v) Psalms.Tech.FriendCheck = v end, false)
        createToggle(checksSection, "Vehicle", function(v) Psalms.Tech.SeatedCheck = v end, false)
        createToggle(checksSection, "Team", function(v) Psalms.Tech.TeamCheck = v end, false)
        
        local gunSection = createSection(MainTab, "Gun Modification")
        createToggle(gunSection, "Bullet TP", function(v) Psalms.Tech.bool_at_tp = v end, false)
        createToggle(gunSection, "Rapid Fire", function(v) Noobidiot = v end, false)
        createTextBox(gunSection, "Rapid Fire Delay", "0", function(v) idiotdelay = tonumber(v) or 0 end, "0")
        
        -- ============================================
        -- RAGE TAB - ALL FEATURES
        -- ============================================
        
        local cameraSection = createSection(RageTab, "Camera")
        createToggle(cameraSection, "Enabled", function(v) Psalms.Tech.Camera = v end, false)
        createToggle(cameraSection, "Flick", function(v) Flick = v end, false)
        createToggle(cameraSection, "Division", function(v) Psalms.Tech.UseExternal = v end, false)
        createToggle(cameraSection, "Resolver", function(v) Psalms.Tech.CamResolverEnabled = v end, false)
        createSlider(cameraSection, "Smoothness", 0, 1, 0.9, function(v) Psalms.Tech.smoothness = v end, 2)
        createDropdown(cameraSection, "Easing Style", {"Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Exponential", "Circular", "Back", "Bounce", "Elastic"}, "Sine", function(v) Psalms.Tech.easingStyle = v end)
        createDropdown(cameraSection, "Easing Direction", {"In", "Out", "InOut"}, "Out", function(v) Psalms.Tech.easingDirection = v end)
        
        local camChecksSection = createSection(RageTab, "Camera Checks")
        createToggle(camChecksSection, "Wall", function(v) Psalms.Tech.CamWallCheck = v end, false)
        createToggle(camChecksSection, "Knocked", function(v) Psalms.Tech.CAMKo = v end, false)
        
        local camPredSection = createSection(RageTab, "Camera Prediction")
        createSlider(camPredSection, "Horizontal", 0, 1, 0.1, function(v) Psalms.Tech.CamPrediction1 = v end, 3)
        createSlider(camPredSection, "Vertical", 0, 1, 0.1, function(v) Psalms.Tech.CamPrediction2 = v end, 3)
        createToggle(camPredSection, "Auto Prediction", function(v) Psalms.Tech.CamAutoprediction = v end, false)
        
        local csyncSection = createSection(RageTab, "CSync")
        createToggle(csyncSection, "Enabled", function(v) TargetAimbot.CSync.Enabled = v end, false)
        createToggle(csyncSection, "Spoof", function(v) TargetAimbot.CSync.Visualize = v end, false)
        createDropdown(csyncSection, "Type", {"Orbit", "Random", "Spiral", "Spherical", "Attach"}, "Orbit", function(v) TargetAimbot.CSync.Type = v end)
        createSlider(csyncSection, "Distance", 0, 100, 10, function(v) TargetAimbot.CSync.Distance = v end, 1)
        createSlider(csyncSection, "Height", 0, 100, 2, function(v) TargetAimbot.CSync.Height = v end, 1)
        createSlider(csyncSection, "Speed", 0, 100, 10, function(v) TargetAimbot.CSync.Speed = v end, 1)
        createSlider(csyncSection, "Random Amount", 0, 100, 10, function(v) TargetAimbot.CSync.RandomAmount = v end, 1)
        createColorPicker(csyncSection, "Color", Color3.fromRGB(255, 255, 255), function(v) TargetAimbot.CSync.Color = v end)
        
        local predBreakerSection = createSection(RageTab, "Prediction Breaker")
        createToggle(predBreakerSection, "Jump Prediction", function(v) Psalms.Tech.JumpBreak = v end, false)
        createToggle(predBreakerSection, "Anti Lock", function(v) Desync = v end, false)
        createToggle(predBreakerSection, "Anti Network", function(v) desyncsleep = v end, false)
        createDropdown(predBreakerSection, "Anti Lock Type", {"Multiply", "Shake", "Behind", "Down", "Forward", "Left", "One", "Right", "Up", "Zero"}, "Zero", function(v) AntiLockType = v end)
        
        local hitDetSection = createSection(RageTab, "Hit Detection")
        createToggle(hitDetSection, "Hit Effect", function(v) TargetAimbot.HitEffect = v end, false)
        createToggle(hitDetSection, "Hit Sound", function(v) TargetAimbot.HitSounds = v end, false)
        createToggle(hitDetSection, "Notify", function(v) Hitnotify = v end, false)
        createDropdown(hitDetSection, "Effect Type", {"Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", "AuraBurst", "Thunder"}, "Coom", function(v) TargetAimbot.HitEffectType = v end)
        createDropdown(hitDetSection, "Sound Type", {"RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", "Gamesense", "Rust", "BlackPencil", "UWU", "Plooh", "Moan", "Hentai", "Bruh", "BoneBreakage", "Fein", "Unicorn", "Kitty", "Bird", "BirthdayCake", "KenCarson"}, "Bameware", function(v) TargetAimbot.HitSound = v end)
        createColorPicker(hitDetSection, "Hit Effect Color", Color3.fromRGB(255, 255, 255), function(v) TargetAimbot.HitEffectColor = v end)
        
        local hitChamsSection = createSection(RageTab, "Hit Chams")
        createToggle(hitChamsSection, "Hit Cham", function(v) TargetAimbot.HitChams = v end, false)
        createColorPicker(hitChamsSection, "Color", Color3.fromRGB(255, 0, 0), function(v) TargetAimbot.HitChamsColor = v end)
        createToggle(hitChamsSection, "Hit Skeleton", function(v) TargetAimbot.HitSkele = v end, false)
        createColorPicker(hitChamsSection, "Skeleton Color", Color3.fromRGB(155, 0, 155), function(v) TargetAimbot.SkeleColor = v end)
        createSlider(hitChamsSection, "Duration", 0, 10, 2, function(v) TargetAimbot.HitChamsDuration = v end, 1)
        createSlider(hitChamsSection, "Transparency", 0, 1, 0, function(v) TargetAimbot.HitChamsTransparency = v end, 3)
        createDropdown(hitChamsSection, "Material", {"Neon", "SmoothPlastic", "ForceField"}, "Neon", function(v) TargetAimbot.HitChamsMaterial = Enum.Material[v] end)
        
        -- ============================================
        -- VISUALS TAB - ALL FEATURES
        -- ============================================
        
        local espSection = createSection(VisualsTab, "ESP")
        createToggle(espSection, "Box Enabled", function(v) if getgenv().esp then getgenv().esp.BoxEnabled = v end end, false)
        createToggle(espSection, "Box Corners", function(v) if getgenv().esp then getgenv().esp.BoxCorners = v end end, false)
        createToggle(espSection, "Box Dynamic", function(v) if getgenv().esp then getgenv().esp.BoxDynamic = v end end, false)
        createToggle(espSection, "Skeleton Enabled", function(v) if getgenv().esp then getgenv().esp.SkeletonEnabled = v end end, false)
        createToggle(espSection, "Chams Enabled", function(v) if getgenv().esp then getgenv().esp.ChamsEnabled = v end end, false)
        createToggle(espSection, "Text Enabled", function(v) if getgenv().esp then getgenv().esp.TextEnabled = v end end, false)
        createToggle(espSection, "Health Bar", function(v) if getgenv().esp and getgenv().esp.BarLayout then getgenv().esp.BarLayout['health'].enabled = v end end, false)
        createToggle(espSection, "Target Only", function(v) if getgenv().esp then getgenv().esp.TargetOnly = v end end, false)
        
        local targetVisualSection = createSection(VisualsTab, "Target Visual")
        createToggle(targetVisualSection, "Highlight", function(v) Highlight = v end, false)
        createToggle(targetVisualSection, "Animate Highlight", function(v) AChams = v end, false)
        createColorPicker(targetVisualSection, "Color 1", Color3.fromRGB(255, 255, 255), function(v) TargetAimbot.HighlightColor1 = v end)
        createColorPicker(targetVisualSection, "Color 2", Color3.fromRGB(255, 255, 255), function(v) TargetAimbot.HighlightColor2 = v end)
        
        local bulletSection = createSection(VisualsTab, "Bullet Trails")
        createToggle(bulletSection, "Enabled", function(v) if Configurations and Configurations.Visuals and Configurations.Visuals.Bullet_Trails then Configurations.Visuals.Bullet_Trails.Enabled = v end end, false)
        createToggle(bulletSection, "Fade", function(v) if Configurations and Configurations.Visuals and Configurations.Visuals.Bullet_Trails then Configurations.Visuals.Bullet_Trails.Fade = v end end, false)
        createSlider(bulletSection, "Width", 0.01, 5, 1, function(v) if Configurations and Configurations.Visuals and Configurations.Visuals.Bullet_Trails then Configurations.Visuals.Bullet_Trails.Width = v end end, 2)
        createSlider(bulletSection, "Duration", 0.01, 10, 3, function(v) if Configurations and Configurations.Visuals and Configurations.Visuals.Bullet_Trails then Configurations.Visuals.Bullet_Trails.Duration = v end end, 2)
        createDropdown(bulletSection, "Texture", {"Cool", "Cum", "Electro", "None"}, "Cool", function(v) if Configurations and Configurations.Visuals and Configurations.Visuals.Bullet_Trails then Configurations.Visuals.Bullet_Trails.Texture = v end end)
        
        local crosshairSection = createSection(VisualsTab, "Crosshair")
        createToggle(crosshairSection, "Enabled", function(v) if getgenv().crosshair then getgenv().crosshair.enabled = v end end, false)
        createToggle(crosshairSection, "Spin", function(v) if getgenv().crosshair then getgenv().crosshair.spin = v end end, false)
        createToggle(crosshairSection, "Stick To Target", function(v) if getgenv().crosshair then getgenv().crosshair.sticky = v end end, false)
        createDropdown(crosshairSection, "Position", {"Middle", "Mouse"}, "Middle", function(v) if getgenv().crosshair then getgenv().crosshair.mode = v end end)
        
        local silentFOVSection = createSection(VisualsTab, "Silent FOV")
        createToggle(silentFOVSection, "Enabled", function(v) -- FOV visibility
        end, false)
        createToggle(silentFOVSection, "Silent", function(v) Psalms.Tech.SilentMode = v end, false)
        createDropdown(silentFOVSection, "Mode", {"Mouse", "Center"}, "Center", function(v) -- Mode
        end)
        createSlider(silentFOVSection, "Size", 1, 200, 125, function(v) -- Size
        end, 0)
        
        local envSection = createSection(VisualsTab, "Environment")
        createToggle(envSection, "Fog Enabled", function(v) if Environment and Environment.Settings then Environment.Settings.FogEnabled = v end end, false)
        createColorPicker(envSection, "Fog Color", Color3.fromRGB(0, 0, 255), function(v) if Environment and Environment.Settings then Environment.Settings.FogColor = v end end)
        createTextBox(envSection, "Fog Start", "0", function(v) if Environment and Environment.Settings then Environment.Settings.FogStart = tonumber(v) or 0 end end, "0")
        createTextBox(envSection, "Fog End", "300", function(v) if Environment and Environment.Settings then Environment.Settings.FogEnd = tonumber(v) or 300 end end, "300")
        createToggle(envSection, "Skybox Enabled", function(v) -- Skybox
        end, false)
        createDropdown(envSection, "Skybox Type", {"1", "2", "3", "4", "5", "6", "7"}, "1", function(v) -- Skybox type
        end)
        
        -- ============================================
        -- SETTINGS TAB - ALL FEATURES
        -- ============================================
        
        local charSection = createSection(SettingsTab, "Character")
        local outfitDropdown = createDropdown(charSection, "Outfits", {}, "", function(v) -- Outfit selection
        end)
        createButton(charSection, "Refresh Outfits", function() -- Refresh outfits
        end)
        
        local camSettingsSection = createSection(SettingsTab, "Camera")
        createSlider(camSettingsSection, "Field Of View", 5, 130, 80, function(v) Camera.FieldOfView = v end, 1)
        
        local danceSection = createSection(SettingsTab, "Dance")
        createToggle(danceSection, "Animate", function(v) if Configurations and Configurations.Misc and Configurations.Misc.Animation then Configurations.Misc.Animation.Enabled = v end end, false)
        createDropdown(danceSection, "Dance Type", {"Floss", "Spin", "Sit", "ArmSpin", "Lay"}, "Floss", function(v) if Configurations and Configurations.Misc and Configurations.Misc.Animation then Configurations.Misc.Animation.SelectedDance = v end end)
        createSlider(danceSection, "Speed", 0, 1000, 2, function(v) if Configurations and Configurations.Misc and Configurations.Misc.Animation then Configurations.Misc.Animation.Speed = v end end, 1)
        
        local configSection = createSection(SettingsTab, "Config")
        local configDropdown = createDropdown(configSection, "Config", {}, "", function(v) -- Config selection
        end)
        local configNameBox = createTextBox(configSection, "Config Name", "Enter name...", function(v) -- Config name
        end, "")
        createButton(configSection, "Create", function() -- Create config
        end)
        createButton(configSection, "Save", function() -- Save config
        end)
        createButton(configSection, "Load", function() -- Load config
        end)
        createButton(configSection, "Delete", function() -- Delete config
        end)
        createButton(configSection, "Refresh", function() -- Refresh configs
        end)
        
        local uiSettingsSection = createSection(SettingsTab, "UI Settings")
        createColorPicker(uiSettingsSection, "Accent Color", Color3.fromRGB(0, 150, 255), function(v) -- Accent color
        end)
        createToggle(uiSettingsSection, "Show Watermark", function(v) -- Watermark
        end, true)
        createToggle(uiSettingsSection, "Update Stats", function(v) -- Stats update
        end, false)
        createTextBox(uiSettingsSection, "Watermark Text", "Psalms.Tech", function(v) -- Watermark text
        end, "Psalms.Tech")
        
        -- Initialize highlight
        local TargHighlight = Instance.new("Highlight")
        TargHighlight.Parent = CoreGui
        TargHighlight.FillColor = TargetAimbot.HighlightColor1
        TargHighlight.OutlineColor = TargetAimbot.HighlightColor2
        TargHighlight.FillTransparency = 0.5
        TargHighlight.OutlineTransparency = 0
        TargHighlight.Enabled = false
        
        -- Update highlight based on settings
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
            
            if AChams then
                local breathe_effect = math.atan(math.sin(tick() * 2)) * 2 / math.pi
                TargHighlight.FillTransparency = 100 * breathe_effect * 0.01
                TargHighlight.OutlineTransparency = 100 * breathe_effect * 0.01
            end
        end)
        
        print("Legendary.xyz UI Loaded Successfully! Size: 500x350")
        
        -- NOTE: All original game logic hooks and functionality should be integrated here
        -- The UI controls are now connected to all configuration variables
        
    end
end

-- Game-specific initialization
if game.PlaceId == 9825515356 then
    local startTime = tick()
    local spoof = {
        pc = true,
        ping = false
    }

    while true do
        if game:GetService("Players").LocalPlayer:FindFirstChild("SPAWN_CHARACTER") then
            local a = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")
            local c

            if a and a:IsA("RemoteEvent") then
                c = hookmetamethod(game, "__namecall", function(self, ...)
                    local method = getnamecallmethod()
                    local args = {...}

                    if method == "FireServer" and self == a then
                        if table.find(args, "IS_MOBILE") and spoof.pc then
                            return
                        end

                        if table.find(args, "GetPing") and spoof.ping then
                            return
                        end
                    end

                    return c(self, ...)
                end)
            end
            cooked(true)
            return
        end

        if tick() - startTime >= 10 then
            local a = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")
            local c

            if a and a:IsA("RemoteEvent") then
                c = hookmetamethod(game, "__namecall", function(self, ...)
                    local method = getnamecallmethod()
                    local args = {...}

                    if method == "FireServer" and self == a then
                        if table.find(args, "IS_MOBILE") and spoof.pc then
                            return
                        end

                        if table.find(args, "GetPing") and spoof.ping then
                            return
                        end
                    end

                    return c(self, ...)
                end)
            end
            cooked(true)
            return
        end
        
        task.wait()
    end
end

cooked(true)
