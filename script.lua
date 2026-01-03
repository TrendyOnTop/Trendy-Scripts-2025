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
LPH_NO_VIRTUALIZE  = function(...) return ... end
end


local getcustom = string.find(identifyexecutor(), "Delta")

local  Library

local assetsupport = string.find(identifyexecutor(), "Wave") or string.find(identifyexecutor(), "Seliware") or string.find(identifyexecutor(), "AWP") or string.find(identifyexecutor(), "Argon") or string.find(identifyexecutor(), "Swift")



if assetsupport then
    Library = loadstring(game:HttpGet("https://pastebin.com/raw/LixdnWjB", true))()
else
    Library  = loadstring(game:HttpGet("https://gist.githubusercontent.com/CongoOhioDog/35476decfcca390e13120470a8907d26/raw/ec47708b7c28850ea497567972fee63c91f5a893/lol",true))()
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
    }
}

Psalms.Tech.SelectedPart = Psalms.Tech.RealPart




local Sleeping = false

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
    HighlightColor1 =Color3.fromRGB(255, 255, 255),
    HighlightColor2 =Color3.fromRGB(255, 255, 255),
    Stats = false, 
    UseFov = false,
    HitEffect = false,
    HitEffectType = "Coom", --  {{ Nova, Crescent Slash, Coom, Cosmic Explosion, Slash, Atomic Slash, Aura Burst }}
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
   SkeleColor = Color3.fromRGB(155, 0, 155)

}

local  Highlight = false

-- Mobile UI Variables
local MobileUI = {
    Visible = true,
    Dragging = false,
    DragStart = nil,
    StartPos = nil,
    Locked = false
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Mobile UI
local function CreateMobileUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PsalmsMobileUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main Container (Draggable)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(0, 400, 0, 600)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
    MainFrame.Active = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Color = Library.Accent
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0
    
    -- Title Bar (Draggable Area)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "Psalms.Tech"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle UI Button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = TitleBar
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Size = UDim2.new(0, 40, 0, 40)
    ToggleButton.Position = UDim2.new(1, -90, 0, 5)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "─"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 24
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleButton
    
    -- Lock Button
    local LockButton = Instance.new("TextButton")
    LockButton.Name = "LockButton"
    LockButton.Parent = TitleBar
    LockButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    LockButton.BorderSizePixel = 0
    LockButton.Size = UDim2.new(0, 40, 0, 40)
    LockButton.Position = UDim2.new(1, -45, 0, 5)
    LockButton.Font = Enum.Font.GothamBold
    LockButton.Text = "🔒"
    LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LockButton.TextSize = 20
    
    local LockCorner = Instance.new("UICorner")
    LockCorner.CornerRadius = UDim.new(0, 8)
    LockCorner.Parent = LockButton
    
    -- Tabs Container
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Parent = MainFrame
    TabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Size = UDim2.new(1, 0, 0, 50)
    TabsFrame.Position = UDim2.new(0, 0, 0, 50)
    
    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.Parent = TabsFrame
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabsLayout.Padding = UDim.new(0, 5)
    
    -- Content Scrolling Frame
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Size = UDim2.new(1, -20, 1, -110)
    ContentFrame.Position = UDim2.new(0, 10, 0, 100)
    ContentFrame.ScrollBarThickness = 8
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = ContentFrame
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    
    -- Drag functionality
    local dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = MainFrame.Position
            MobileUI.Dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if MobileUI.Dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            MobileUI.Dragging = false
        end
    end)
    
    -- Toggle UI
    ToggleButton.MouseButton1Click:Connect(function()
        MobileUI.Visible = not MobileUI.Visible
        MainFrame.Visible = MobileUI.Visible
    end)
    
    -- Lock functionality
    LockButton.MouseButton1Click:Connect(function()
        MobileUI.Locked = not MobileUI.Locked
        if MobileUI.Locked then
            LockButton.Text = "🔓"
            LockButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            -- Lock target/camlock
            if TargetAimbot.Enabled and TargetPlr then
                TargBindEnabled = true
            end
            if Psalms.Tech.Camera then
                Psalms.Tech.Camera = true
            end
        else
            LockButton.Text = "🔒"
            LockButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            -- Unlock
            TargBindEnabled = false
            TargetPlr = nil
        end
    end)
    
    -- Store references
    MobileUI.ScreenGui = ScreenGui
    MobileUI.MainFrame = MainFrame
    MobileUI.ContentFrame = ContentFrame
    MobileUI.TabsFrame = TabsFrame
    
    return MobileUI
end

-- Create Tab Button
local function CreateTabButton(name, parent)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Parent = parent
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(0, 80, 0, 40)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    return TabButton
end

-- Create Section
local function CreateSection(name, parent)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = name .. "Section"
    SectionFrame.Parent = parent
    SectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SectionFrame.BorderSizePixel = 0
    SectionFrame.Size = UDim2.new(1, -10, 0, 0)
    SectionFrame.Position = UDim2.new(0, 5, 0, 0)
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = SectionFrame
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Parent = SectionFrame
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Size = UDim2.new(1, -20, 0, 30)
    SectionTitle.Position = UDim2.new(0, 10, 0, 5)
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.Text = name
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextSize = 16
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = SectionFrame
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 5)
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionFrame.Size = UDim2.new(1, -10, 0, ContentLayout.AbsoluteContentSize.Y + 40)
    end)
    
    return SectionFrame
end

-- Create Toggle
local function CreateToggle(name, defaultValue, callback, parent)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.Position = UDim2.new(0, 10, 0, 0)
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -55, 0, 7.5)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = defaultValue and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleButton
    
    local state = defaultValue
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        ToggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
        ToggleButton.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
    
    return ToggleFrame, function() return state end
end

-- Create Slider
local function CreateSlider(name, min, max, default, suffix, decimals, callback, parent)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "Slider"
    SliderFrame.Parent = parent
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Size = UDim2.new(1, -20, 0, 60)
    SliderFrame.Position = UDim2.new(0, 10, 0, 0)
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.Position = UDim2.new(0, 0, 0, 0)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = name .. ": " .. tostring(default) .. (suffix or "")
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Parent = SliderFrame
    SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Size = UDim2.new(1, 0, 0, 8)
    SliderTrack.Position = UDim2.new(0, 0, 0, 25)
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 4)
    TrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderTrack
    SliderFill.BackgroundColor3 = Library.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 4)
    FillCorner.Parent = SliderFill
    
    local currentValue = default
    local dragging = false
    
    local function updateValue(value)
        currentValue = math.clamp(value, min, max)
        local percent = (currentValue - min) / (max - min)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderLabel.Text = name .. ": " .. string.format("%." .. (decimals or 0) .. "f", currentValue) .. (suffix or "")
        if callback then callback(currentValue) end
    end
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local pos = input.Position.X - SliderTrack.AbsolutePosition.X
            local percent = math.clamp(pos / SliderTrack.AbsoluteSize.X, 0, 1)
            updateValue(min + (max - min) * percent)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position.X - SliderTrack.AbsolutePosition.X
            local percent = math.clamp(pos / SliderTrack.AbsoluteSize.X, 0, 1)
            updateValue(min + (max - min) * percent)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return SliderFrame, function() return currentValue end
end

-- Create TextBox
local function CreateTextBox(name, default, callback, parent)
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = name .. "TextBox"
    TextBoxFrame.Parent = parent
    TextBoxFrame.BackgroundTransparency = 1
    TextBoxFrame.Size = UDim2.new(1, -20, 0, 50)
    TextBoxFrame.Position = UDim2.new(0, 10, 0, 0)
    
    local TextBoxLabel = Instance.new("TextLabel")
    TextBoxLabel.Parent = TextBoxFrame
    TextBoxLabel.BackgroundTransparency = 1
    TextBoxLabel.Size = UDim2.new(1, 0, 0, 20)
    TextBoxLabel.Position = UDim2.new(0, 0, 0, 0)
    TextBoxLabel.Font = Enum.Font.Gotham
    TextBoxLabel.Text = name
    TextBoxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBoxLabel.TextSize = 14
    TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = TextBoxFrame
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.BorderSizePixel = 0
    TextBox.Size = UDim2.new(1, 0, 0, 30)
    TextBox.Position = UDim2.new(0, 0, 0, 20)
    TextBox.Font = Enum.Font.Gotham
    TextBox.Text = tostring(default)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 14
    TextBox.PlaceholderText = "Enter value..."
    
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 6)
    TextBoxCorner.Parent = TextBox
    
    TextBox.FocusLost:Connect(function()
        if callback then callback(TextBox.Text) end
    end)
    
    return TextBoxFrame
end

-- Create Dropdown
local function CreateDropdown(name, options, default, callback, parent)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name .. "Dropdown"
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Size = UDim2.new(1, -20, 0, 50)
    DropdownFrame.Position = UDim2.new(0, 10, 0, 0)
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Parent = DropdownFrame
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
    DropdownLabel.Position = UDim2.new(0, 0, 0, 0)
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.Text = name
    DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownLabel.TextSize = 14
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Parent = DropdownFrame
    DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Size = UDim2.new(1, 0, 0, 30)
    DropdownButton.Position = UDim2.new(0, 0, 0, 20)
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Text = default or options[1]
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.TextSize = 14
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = DropdownButton
    
    local currentSelection = default or options[1]
    local open = false
    
    local OptionsFrame = Instance.new("ScrollingFrame")
    OptionsFrame.Parent = DropdownFrame
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 0, 50)
    OptionsFrame.Visible = false
    OptionsFrame.ScrollBarThickness = 4
    OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.Parent = OptionsFrame
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    for _, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = OptionsFrame
        OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        OptionButton.BorderSizePixel = 0
        OptionButton.Size = UDim2.new(1, -10, 0, 30)
        OptionButton.Position = UDim2.new(0, 5, 0, 0)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 12
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 4)
        OptionCorner.Parent = OptionButton
        
        OptionButton.MouseButton1Click:Connect(function()
            currentSelection = option
            DropdownButton.Text = option
            OptionsFrame.Visible = false
            open = false
            DropdownFrame.Size = UDim2.new(1, -20, 0, 50)
            if callback then callback(option) end
        end)
    end
    
    OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, OptionsLayout.AbsoluteContentSize.Y)
        OptionsFrame.Size = UDim2.new(1, 0, 0, math.min(OptionsLayout.AbsoluteContentSize.Y, 150))
    end)
    
    DropdownButton.MouseButton1Click:Connect(function()
        open = not open
        OptionsFrame.Visible = open
        if open then
            DropdownFrame.Size = UDim2.new(1, -20, 0, 50 + math.min(OptionsLayout.AbsoluteContentSize.Y, 150))
        else
            DropdownFrame.Size = UDim2.new(1, -20, 0, 50)
        end
    end)
    
    return DropdownFrame, function() return currentSelection end
end

-- Create Button
local function CreateButton(name, callback, parent)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Button"
    Button.Parent = parent
    Button.BackgroundColor3 = Library.Accent
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, 0)
    Button.Font = Enum.Font.GothamBold
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return Button
end

-- Create ColorPicker
local function CreateColorPicker(name, default, callback, parent)
    local ColorFrame = Instance.new("Frame")
    ColorFrame.Name = name .. "ColorPicker"
    ColorFrame.Parent = parent
    ColorFrame.BackgroundTransparency = 1
    ColorFrame.Size = UDim2.new(1, -20, 0, 50)
    ColorFrame.Position = UDim2.new(0, 10, 0, 0)
    
    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Parent = ColorFrame
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Size = UDim2.new(1, -60, 0, 20)
    ColorLabel.Position = UDim2.new(0, 0, 0, 0)
    ColorLabel.Font = Enum.Font.Gotham
    ColorLabel.Text = name
    ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorLabel.TextSize = 14
    ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ColorButton = Instance.new("TextButton")
    ColorButton.Parent = ColorFrame
    ColorButton.BackgroundColor3 = default
    ColorButton.BorderSizePixel = 0
    ColorButton.Size = UDim2.new(0, 50, 0, 30)
    ColorButton.Position = UDim2.new(1, -55, 0, 20)
    ColorButton.Text = ""
    
    local ColorCorner = Instance.new("UICorner")
    ColorCorner.CornerRadius = UDim.new(0, 6)
    ColorCorner.Parent = ColorButton
    
    ColorButton.MouseButton1Click:Connect(function()
        -- Simple color picker - you can enhance this
        local currentColor = ColorButton.BackgroundColor3
        if callback then callback(currentColor) end
    end)
    
    return ColorFrame
end

-- Initialize Mobile UI
local MobileUI = CreateMobileUI()
local CurrentTab = nil
local TabContents = {}

-- Function to switch tabs
local function SwitchTab(tabName)
    -- Hide all content
    for name, content in pairs(TabContents) do
        content.Visible = false
    end
    
    -- Show selected tab content
    if TabContents[tabName] then
        TabContents[tabName].Visible = true
        CurrentTab = tabName
    end
    
    -- Update tab button colors
    for _, tab in ipairs(MobileUI.TabsFrame:GetChildren()) do
        if tab:IsA("TextButton") then
            if tab.Name == tabName .. "Tab" then
                tab.BackgroundColor3 = Library.Accent
                tab.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                tab.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end
end

-- Create all tabs and populate with features
local function SetupMobileUI()
    local tabs = {"Main", "Rage", "Visuals", "Settings"}
    
    for _, tabName in ipairs(tabs) do
        -- Create tab button
        local tabButton = CreateTabButton(tabName, MobileUI.TabsFrame)
        
        -- Create tab content
        local tabContent = Instance.new("Frame")
        tabContent.Name = tabName .. "Content"
        tabContent.Parent = MobileUI.ContentFrame
        tabContent.BackgroundTransparency = 1
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.Visible = tabName == "Main"
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Parent = tabContent
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.Padding = UDim.new(0, 10)
        
        tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
            MobileUI.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
        end)
        
        TabContents[tabName] = tabContent
        
        -- Tab click handler
        tabButton.MouseButton1Click:Connect(function()
            SwitchTab(tabName)
        end)
        
        -- Populate tab content based on tab name
        if tabName == "Main" then
            -- Silent/Target Section
            local silentSection = CreateSection("Silent/Target", tabContent)
            CreateToggle("Enabled", Psalms.Tech.Enabled, function(v) Psalms.Tech.Enabled = v end, silentSection)
            CreateToggle("Look At", Psalms.Tech.LookAt, function(v) Psalms.Tech.LookAt = v end, silentSection)
            CreateToggle("View", Psalms.Tech.ViewAt, function(v) Psalms.Tech.ViewAt = v end, silentSection)
            CreateToggle("Anti Aim Viewer", Psalms.Tech.AntiAimViewer, function(v) Psalms.Tech.AntiAimViewer = v end, silentSection)
            CreateToggle("Auto Air", Psalms.Tech.AutoAir, function(v) Psalms.Tech.AutoAir = v end, silentSection)
            CreateTextBox("Auto Air Delay", Psalms.Tech.ShootDelay, function(v) targetSigm99928 = tonumber(v) end, silentSection)
            CreateDropdown("Lock Method", {"Index", "Namecall"}, Psalms.Tech.LockType, function(v) Psalms.Tech.LockType = v end, silentSection)
            
            -- Hit Part Section
            local hitPartSection = CreateSection("Hit Part", tabContent)
            CreateDropdown("BodyPart", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}, Psalms.Tech.RealPart, function(v) Psalms.Tech.RealPart = v end, hitPartSection)
            CreateDropdown("AirPart", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}, Psalms.Tech.AirPart, function(v) Psalms.Tech.AirPart = v end, hitPartSection)
            
            -- Prediction Section
            local predictionSection = CreateSection("Prediction", tabContent)
            CreateToggle("Division", Psalms.Tech.UseVertical, function(v) Psalms.Tech.UseVertical = v end, predictionSection)
            CreateTextBox("Horizontal Prediction", Psalms.Tech.HorizontalPrediction2, function(v) Psalms.Tech.HorizontalPrediction2 = tonumber(v) or 0.1; Psalms.Tech.HorizontalPrediction = Psalms.Tech.HorizontalPrediction2 end, predictionSection)
            CreateTextBox("Vertical Prediction", Psalms.Tech.VerticalPrediction2, function(v) Psalms.Tech.VerticalPrediction2 = tonumber(v) or 0.1; Psalms.Tech.VerticalPrediction = Psalms.Tech.VerticalPrediction2 end, predictionSection)
            CreateTextBox("Jump Offset", Psalms.Tech.jumpoffset2, function(v) Psalms.Tech.jumpoffset2 = tonumber(v) end, predictionSection)
            CreateTextBox("Fall Offset", Psalms.Tech.jumpoffset3, function(v) Psalms.Tech.jumpoffset3 = tonumber(v) end, predictionSection)
            CreateToggle("Visualize", Psalms.Tech.VelocityDot, function(v) Psalms.Tech.VelocityDot = v end, predictionSection)
            CreateToggle("Resolver", Psalms.Tech.ResolverEnabled, function(v) Psalms.Tech.ResolverEnabled = v end, predictionSection)
            CreateToggle("Auto Prediction", Psalms.Tech.AutoPrediction, function(v) Psalms.Tech.AutoPrediction = v end, predictionSection)
            CreateDropdown("Auto Prediction Mode", {"Default", "Math Based", "Sets Based", "Calculate"}, Psalms.Tech.APMODE, function(v) Psalms.Tech.APMODE = v end, predictionSection)
            CreateDropdown("Resolver Method", {"Recalculate", "MoveDirection", "LookVector"}, "MoveDirection", function(v) Psalms.Tech.RESOLVER = v end, predictionSection)
            
            -- Checks Section
            local checksSection = CreateSection("Checks", tabContent)
            CreateToggle("KnockOut", Psalms.Tech.KOCheck, function(v) Psalms.Tech.KOCheck = v end, checksSection)
            CreateToggle("Wall", Psalms.Tech.WallCheck, function(v) Psalms.Tech.WallCheck = v end, checksSection)
            CreateToggle("Friend", Psalms.Tech.FriendCheck, function(v) Psalms.Tech.FriendCheck = v end, checksSection)
            CreateToggle("Vehicle", Psalms.Tech.SeatedCheck, function(v) Psalms.Tech.SeatedCheck = v end, checksSection)
            CreateToggle("Team", Psalms.Tech.TeamCheck, function(v) Psalms.Tech.TeamCheck = v end, checksSection)
            
        elseif tabName == "Rage" then
            -- Camera Section
            local cameraSection = CreateSection("Camera", tabContent)
            CreateToggle("Enabled", Psalms.Tech.Camera, function(v) Psalms.Tech.Camera = v end, cameraSection)
            CreateToggle("Flick", Flick, function(v) Flick = v end, cameraSection)
            CreateToggle("Division", Psalms.Tech.UseExternal, function(v) Psalms.Tech.UseExternal = v end, cameraSection)
            CreateToggle("Resolver", Psalms.Tech.CamResolverEnabled, function(v) Psalms.Tech.CamResolverEnabled = v end, cameraSection)
            CreateSlider("Smoothness", 0, 1, Psalms.Tech.smoothness, "", 2, function(v) Psalms.Tech.smoothness = v end, cameraSection)
            CreateDropdown("Easing Style", {"Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Exponential", "Circular", "Back", "Bounce", "Elastic"}, Psalms.Tech.easingStyle, function(v) Psalms.Tech.easingStyle = v end, cameraSection)
            CreateDropdown("Easing Direction", {"In", "Out", "InOut"}, Psalms.Tech.easingDirection, function(v) Psalms.Tech.easingDirection = v end, cameraSection)
            
            -- Camera Prediction Section
            local camPredSection = CreateSection("Camera Prediction", tabContent)
            CreateTextBox("Horizontal Prediction", camgay2, function(v) camgay2 = tonumber(v) or 0.1; Psalms.Tech.CamPrediction1 = camgay2 end, camPredSection)
            CreateTextBox("Vertical Prediction", camgay, function(v) camgay = tonumber(v) or 0.1; Psalms.Tech.CamPrediction2 = camgay end, camPredSection)
            CreateToggle("AutoPred", Psalms.Tech.CamAutoprediction, function(v) Psalms.Tech.CamAutoprediction = v end, camPredSection)
            
            -- CSync Section
            local csyncSection = CreateSection("CSync", tabContent)
            CreateToggle("Enabled", TargetAimbot.CSync.Enabled, function(v) TargetAimbot.CSync.Enabled = v end, csyncSection)
            CreateToggle("Spoof", TargetAimbot.CSync.Visualize, function(v) TargetAimbot.CSync.Visualize = v end, csyncSection)
            CreateDropdown("Type", {"Orbit", "Random", "Spiral", "Spherical", "Attach"}, TargetAimbot.CSync.Type, function(v) TargetAimbot.CSync.Type = v end, csyncSection)
            CreateSlider("Distance", 0, 100, TargetAimbot.CSync.Distance, "", 1, function(v) TargetAimbot.CSync.Distance = v end, csyncSection)
            CreateSlider("Height", 0, 100, TargetAimbot.CSync.Height, "", 1, function(v) TargetAimbot.CSync.Height = v end, csyncSection)
            CreateSlider("Speed", 0, 100, TargetAimbot.CSync.Speed, "", 1, function(v) TargetAimbot.CSync.Speed = v end, csyncSection)
            CreateSlider("Random Amount", 0, 100, TargetAimbot.CSync.RandomAmount, "", 1, function(v) TargetAimbot.CSync.RandomAmount = v end, csyncSection)
            
        elseif tabName == "Visuals" then
            -- ESP Section
            local espSection = CreateSection("ESP", tabContent)
            CreateToggle("Box Enabled", getgenv().esp.BoxEnabled, function(v) getgenv().esp.BoxEnabled = v end, espSection)
            CreateToggle("Box Corners", getgenv().esp.BoxCorners, function(v) getgenv().esp.BoxCorners = v end, espSection)
            CreateToggle("Box Dynamic", getgenv().esp.BoxDynamic, function(v) getgenv().esp.BoxDynamic = v end, espSection)
            CreateSlider("Box Width", 0.1, 3, getgenv().esp.BoxStaticXFactor, "X", 2, function(v) getgenv().esp.BoxStaticXFactor = v end, espSection)
            CreateSlider("Box Height", 0.1, 3, getgenv().esp.BoxStaticYFactor, "Y", 2, function(v) getgenv().esp.BoxStaticYFactor = v end, espSection)
            CreateToggle("Skeleton Enabled", getgenv().esp.SkeletonEnabled, function(v) getgenv().esp.SkeletonEnabled = v end, espSection)
            CreateToggle("Chams Enabled", getgenv().esp.ChamsEnabled, function(v) getgenv().esp.ChamsEnabled = v end, espSection)
            CreateToggle("Text Enabled", getgenv().esp.TextEnabled, function(v) getgenv().esp.TextEnabled = v end, espSection)
            
            -- Target Visual Section
            local targetVisualSection = CreateSection("Target Visual", tabContent)
            CreateToggle("Highlight", Highlight, function(v) Highlight = v end, targetVisualSection)
            CreateToggle("Animate Highlight", AChams, function(v) AChams = v end, targetVisualSection)
            CreateColorPicker("Color", TargetAimbot.HighlightColor1, function(v) TargetAimbot.HighlightColor1 = v end, targetVisualSection)
            CreateColorPicker("Color2", TargetAimbot.HighlightColor2, function(v) TargetAimbot.HighlightColor2 = v end, targetVisualSection)
            
            -- Hit Detection Section
            local hitDetectionSection = CreateSection("Hit Detection", tabContent)
            CreateToggle("Hit Effect", TargetAimbot.HitEffect, function(v) TargetAimbot.HitEffect = v end, hitDetectionSection)
            CreateToggle("Hit Sound", TargetAimbot.HitSounds, function(v) TargetAimbot.HitSounds = v end, hitDetectionSection)
            CreateToggle("Notify", Hitnotify, function(v) Hitnotify = v end, hitDetectionSection)
            CreateDropdown("Effect Type", {"Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", "AuraBurst", "Thunder"}, TargetAimbot.HitEffectType, function(v) TargetAimbot.HitEffectType = v end, hitDetectionSection)
            CreateDropdown("Sound Type", {"RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", "Gamesense", "Rust", "BlackPencil", "UWU", "Plooh", "Moan", "Hentai", "Bruh", "BoneBreakage", "Fein", "Unicorn", "Kitty", "Bird", "BirthdayCake", "KenCarson"}, TargetAimbot.HitSound, function(v) TargetAimbot.HitSound = v end, hitDetectionSection)
            CreateColorPicker("Hit Effect Color", TargetAimbot.HitEffectColor, function(v) TargetAimbot.HitEffectColor = v end, hitDetectionSection)
            
            -- Hit Chams Section
            local hitChamsSection = CreateSection("Hit Chams", tabContent)
            CreateToggle("Hit Cham", TargetAimbot.HitChams, function(v) TargetAimbot.HitChams = v end, hitChamsSection)
            CreateColorPicker("Color", TargetAimbot.HitChamsColor, function(v) TargetAimbot.HitChamsColor = v end, hitChamsSection)
            CreateToggle("Hit Skeleton", TargetAimbot.HitSkele, function(v) TargetAimbot.HitSkele = v end, hitChamsSection)
            CreateColorPicker("Skeleton Color", TargetAimbot.SkeleColor, function(v) TargetAimbot.SkeleColor = v end, hitChamsSection)
            CreateSlider("Duration", 0, 10, TargetAimbot.HitChamsDuration, "", 1, function(v) TargetAimbot.HitChamsDuration = v end, hitChamsSection)
            CreateSlider("Transparency", 0, 1, TargetAimbot.HitChamsTransparency, "", 3, function(v) TargetAimbot.HitChamsTransparency = v end, hitChamsSection)
            
        elseif tabName == "Settings" then
            -- Config Section
            local configSection = CreateSection("Config", tabContent)
            CreateButton("Save Config", function() Library:SaveConfig() end, configSection)
            CreateButton("Load Config", function() Library:LoadConfig() end, configSection)
            CreateColorPicker("Accent Color", Library.Accent, function(v) Library:ChangeAccent(v) end, configSection)
            CreateToggle("Show Watermark", true, function(v) Watermark:SetVisible(v) end, configSection)
    end
end

-- Continue with rest of original script functionality...
-- [All the original script code continues here - hit effects, sounds, ESP, etc.]

-- Initialize UI after everything is loaded
SetupMobileUI()

end
end

-- Rest of original script continues...
-- [Include all the original functionality code here]

if game.PlaceId == 9825515356 then
    -- Original game-specific code
    cooked(true)
else
    cooked(true)
end
