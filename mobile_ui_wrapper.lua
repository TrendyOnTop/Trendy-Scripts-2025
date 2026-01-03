-- Mobile UI Wrapper for Psalms.Tech
-- This file contains the complete mobile UI system that should be integrated into the main script

-- Mobile UI System
local MobileUISystem = {}

-- Mobile UI Variables
MobileUISystem.Visible = true
MobileUISystem.Dragging = false
MobileUISystem.Locked = false
MobileUISystem.CurrentTab = "Main"
MobileUISystem.UI = nil

-- Create Mobile UI
function MobileUISystem:Create()
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
    MainFrame.Size = UDim2.new(0, 420, 0, 650)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -325)
    MainFrame.Active = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Color = Library.Accent
    UIStroke.Thickness = 2.5
    UIStroke.Transparency = 0
    
    -- Title Bar (Draggable Area)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 55)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 15)
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "Psalms.Tech"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 22
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle UI Button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = TitleBar
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Size = UDim2.new(0, 45, 0, 45)
    ToggleButton.Position = UDim2.new(1, -100, 0, 5)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "─"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 28
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleButton
    
    -- Lock Button
    local LockButton = Instance.new("TextButton")
    LockButton.Name = "LockButton"
    LockButton.Parent = TitleBar
    LockButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    LockButton.BorderSizePixel = 0
    LockButton.Size = UDim2.new(0, 45, 0, 45)
    LockButton.Position = UDim2.new(1, -50, 0, 5)
    LockButton.Font = Enum.Font.GothamBold
    LockButton.Text = "🔒"
    LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LockButton.TextSize = 24
    
    local LockCorner = Instance.new("UICorner")
    LockCorner.CornerRadius = UDim.new(0, 10)
    LockCorner.Parent = LockButton
    
    -- Tabs Container
    local TabsFrame = Instance.new("ScrollingFrame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Parent = MainFrame
    TabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Size = UDim2.new(1, 0, 0, 55)
    TabsFrame.Position = UDim2.new(0, 0, 0, 55)
    TabsFrame.ScrollBarThickness = 0
    TabsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.Parent = TabsFrame
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabsLayout.Padding = UDim.new(0, 8)
    
    -- Content Scrolling Frame
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Size = UDim2.new(1, -15, 1, -120)
    ContentFrame.Position = UDim2.new(0, 7.5, 0, 110)
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = ContentFrame
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 12)
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Drag functionality
    local dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos = MainFrame.Position
            MobileUISystem.Dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if MobileUISystem.Dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            MobileUISystem.Dragging = false
        end
    end)
    
    -- Toggle UI
    ToggleButton.MouseButton1Click:Connect(function()
        MobileUISystem.Visible = not MobileUISystem.Visible
        MainFrame.Visible = MobileUISystem.Visible
    end)
    
    -- Lock functionality
    LockButton.MouseButton1Click:Connect(function()
        MobileUISystem.Locked = not MobileUISystem.Locked
        if MobileUISystem.Locked then
            LockButton.Text = "🔓"
            LockButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            -- Lock target/camlock
            if TargetAimbot.Enabled then
                if not TargBindEnabled then
                    local Closest = GetClosestToMouse()
                    if Closest then
                        TargBindEnabled = true
                        TargetPlr = Closest
                        if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
                            targetHealth = TargetPlr.Character.Humanoid.Health
                        end
                    end
                end
            end
            if not Psalms.Tech.Camera then
                Psalms.Tech.Camera = true
            end
        else
            LockButton.Text = "🔒"
            LockButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            -- Unlock
            TargBindEnabled = false
            TargetPlr = nil
            targetHealth = nil
        end
    end)
    
    -- Store references
    self.UI = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentFrame = ContentFrame,
        TabsFrame = TabsFrame,
        TitleBar = TitleBar,
        ToggleButton = ToggleButton,
        LockButton = LockButton
    }
    
    return self.UI
end

-- Create Tab Button
function MobileUISystem:CreateTabButton(name, parent)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Parent = parent
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(0, 0, 0, 45)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 15
    TabButton.TextWrapped = true
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabButton
    
    local TextSizeConstraint = Instance.new("UITextSizeConstraint")
    TextSizeConstraint.Parent = TabButton
    TextSizeConstraint.MaxTextSize = 15
    
    -- Auto-size based on text
    TabButton:GetPropertyChangedSignal("TextBounds"):Connect(function()
        TabButton.Size = UDim2.new(0, math.max(70, TabButton.TextBounds.X + 20), 0, 45)
    end)
    TabButton.Size = UDim2.new(0, math.max(70, TabButton.TextBounds.X + 20), 0, 45)
    
    return TabButton
end

-- Create Section
function MobileUISystem:CreateSection(name, parent)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = name .. "Section"
    SectionFrame.Parent = parent
    SectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SectionFrame.BorderSizePixel = 0
    SectionFrame.Size = UDim2.new(1, 0, 0, 0)
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 10)
    SectionCorner.Parent = SectionFrame
    
    local SectionStroke = Instance.new("UIStroke")
    SectionStroke.Parent = SectionFrame
    SectionStroke.Color = Color3.fromRGB(60, 60, 60)
    SectionStroke.Thickness = 1
    SectionStroke.Transparency = 0.5
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Parent = SectionFrame
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Size = UDim2.new(1, -20, 0, 35)
    SectionTitle.Position = UDim2.new(0, 15, 0, 5)
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.Text = name
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextSize = 17
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = SectionFrame
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionFrame.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 45)
    end)
    
    return SectionFrame
end

-- Create Toggle
function MobileUISystem:CreateToggle(name, defaultValue, callback, parent)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Size = UDim2.new(1, -20, 0, 45)
    ToggleFrame.Position = UDim2.new(0, 10, 0, 0)
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 15
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.TextWrapped = true
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Size = UDim2.new(0, 60, 0, 30)
    ToggleButton.Position = UDim2.new(1, -65, 0, 7.5)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = defaultValue and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 13
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 15)
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
function MobileUISystem:CreateSlider(name, min, max, default, suffix, decimals, callback, parent)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "Slider"
    SliderFrame.Parent = parent
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Size = UDim2.new(1, -20, 0, 65)
    SliderFrame.Position = UDim2.new(0, 10, 0, 0)
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Size = UDim2.new(1, 0, 0, 25)
    SliderLabel.Position = UDim2.new(0, 0, 0, 0)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = name .. ": " .. string.format("%." .. (decimals or 0) .. "f", default) .. (suffix or "")
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Parent = SliderFrame
    SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Size = UDim2.new(1, 0, 0, 10)
    SliderTrack.Position = UDim2.new(0, 0, 0, 30)
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 5)
    TrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderTrack
    SliderFill.BackgroundColor3 = Library.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 5)
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
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pos = input.Position.X - SliderTrack.AbsolutePosition.X
            local percent = math.clamp(pos / SliderTrack.AbsoluteSize.X, 0, 1)
            updateValue(min + (max - min) * percent)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local pos = input.Position.X - SliderTrack.AbsolutePosition.X
            local percent = math.clamp(pos / SliderTrack.AbsoluteSize.X, 0, 1)
            updateValue(min + (max - min) * percent)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return SliderFrame, function() return currentValue end
end

-- Create TextBox
function MobileUISystem:CreateTextBox(name, default, callback, parent)
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = name .. "TextBox"
    TextBoxFrame.Parent = parent
    TextBoxFrame.BackgroundTransparency = 1
    TextBoxFrame.Size = UDim2.new(1, -20, 0, 55)
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
    TextBox.Size = UDim2.new(1, 0, 0, 35)
    TextBox.Position = UDim2.new(0, 0, 0, 20)
    TextBox.Font = Enum.Font.Gotham
    TextBox.Text = tostring(default)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 15
    TextBox.PlaceholderText = "Enter value..."
    TextBox.ClearTextOnFocus = false
    
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 8)
    TextBoxCorner.Parent = TextBox
    
    local TextBoxPadding = Instance.new("UIPadding")
    TextBoxPadding.Parent = TextBox
    TextBoxPadding.PaddingLeft = UDim.new(0, 10)
    TextBoxPadding.PaddingRight = UDim.new(0, 10)
    
    TextBox.FocusLost:Connect(function()
        if callback then callback(TextBox.Text) end
    end)
    
    return TextBoxFrame
end

-- Create Dropdown
function MobileUISystem:CreateDropdown(name, options, default, callback, parent)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name .. "Dropdown"
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Size = UDim2.new(1, -20, 0, 55)
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
    DropdownButton.Size = UDim2.new(1, 0, 0, 35)
    DropdownButton.Position = UDim2.new(0, 0, 0, 20)
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Text = default or options[1]
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.TextSize = 14
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownButton
    
    local DropdownPadding = Instance.new("UIPadding")
    DropdownPadding.Parent = DropdownButton
    DropdownPadding.PaddingLeft = UDim.new(0, 10)
    DropdownPadding.PaddingRight = UDim.new(0, 10)
    
    local currentSelection = default or options[1]
    local open = false
    
    local OptionsFrame = Instance.new("ScrollingFrame")
    OptionsFrame.Parent = DropdownFrame
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 0, 55)
    OptionsFrame.Visible = false
    OptionsFrame.ScrollBarThickness = 4
    OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.Parent = OptionsFrame
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Padding = UDim.new(0, 3)
    
    for _, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = OptionsFrame
        OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        OptionButton.BorderSizePixel = 0
        OptionButton.Size = UDim2.new(1, -10, 0, 35)
        OptionButton.Position = UDim2.new(0, 5, 0, 0)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 13
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 6)
        OptionCorner.Parent = OptionButton
        
        local OptionPadding = Instance.new("UIPadding")
        OptionPadding.Parent = OptionButton
        OptionPadding.PaddingLeft = UDim.new(0, 10)
        
        OptionButton.MouseButton1Click:Connect(function()
            currentSelection = option
            DropdownButton.Text = option
            OptionsFrame.Visible = false
            open = false
            DropdownFrame.Size = UDim2.new(1, -20, 0, 55)
            if callback then callback(option) end
        end)
    end
    
    OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, OptionsLayout.AbsoluteContentSize.Y)
        OptionsFrame.Size = UDim2.new(1, 0, 0, math.min(OptionsLayout.AbsoluteContentSize.Y, 180))
    end)
    
    DropdownButton.MouseButton1Click:Connect(function()
        open = not open
        OptionsFrame.Visible = open
        if open then
            DropdownFrame.Size = UDim2.new(1, -20, 0, 55 + math.min(OptionsLayout.AbsoluteContentSize.Y, 180))
        else
            DropdownFrame.Size = UDim2.new(1, -20, 0, 55)
        end
    end)
    
    return DropdownFrame, function() return currentSelection end
end

-- Create Button
function MobileUISystem:CreateButton(name, callback, parent)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Button"
    Button.Parent = parent
    Button.BackgroundColor3 = Library.Accent
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, -20, 0, 45)
    Button.Position = UDim2.new(0, 10, 0, 0)
    Button.Font = Enum.Font.GothamBold
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 15
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return Button
end

-- Create ColorPicker
function MobileUISystem:CreateColorPicker(name, default, callback, parent)
    local ColorFrame = Instance.new("Frame")
    ColorFrame.Name = name .. "ColorPicker"
    ColorFrame.Parent = parent
    ColorFrame.BackgroundTransparency = 1
    ColorFrame.Size = UDim2.new(1, -20, 0, 55)
    ColorFrame.Position = UDim2.new(0, 10, 0, 0)
    
    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Parent = ColorFrame
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Size = UDim2.new(1, -70, 0, 20)
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
    ColorButton.Size = UDim2.new(0, 60, 0, 35)
    ColorButton.Position = UDim2.new(1, -65, 0, 20)
    ColorButton.Text = ""
    
    local ColorCorner = Instance.new("UICorner")
    ColorCorner.CornerRadius = UDim.new(0, 8)
    ColorCorner.Parent = ColorButton
    
    local ColorStroke = Instance.new("UIStroke")
    ColorStroke.Parent = ColorButton
    ColorStroke.Color = Color3.fromRGB(255, 255, 255)
    ColorStroke.Thickness = 2
    
    ColorButton.MouseButton1Click:Connect(function()
        -- Simple color picker - opens color picker dialog
        local currentColor = ColorButton.BackgroundColor3
        if callback then callback(currentColor) end
    end)
    
    return ColorFrame
end

-- Switch Tab
function MobileUISystem:SwitchTab(tabName)
    -- Hide all content
    for _, content in pairs(self.TabContents or {}) do
        if content and content.Parent then
            content.Visible = false
        end
    end
    
    -- Show selected tab content
    if self.TabContents and self.TabContents[tabName] then
        self.TabContents[tabName].Visible = true
        self.CurrentTab = tabName
    end
    
    -- Update tab button colors
    if self.UI and self.UI.TabsFrame then
        for _, tab in ipairs(self.UI.TabsFrame:GetChildren()) do
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
end

return MobileUISystem
