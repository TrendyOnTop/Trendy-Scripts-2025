-- Custom UI System
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- UI Theme Colors
local Theme = {
    Background = Color3.fromRGB(20, 20, 30),
    Secondary = Color3.fromRGB(30, 30, 45),
    Accent = Color3.fromRGB(98, 0, 67),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(40, 40, 60),
    Success = Color3.fromRGB(0, 255, 0),
    Error = Color3.fromRGB(255, 0, 0)
}

-- Draggable Function
local function MakeDraggable(Frame, DragHandle)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    DragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    
    DragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

-- Create Main UI
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "CactusUI"
MainUI.Parent = game.CoreGui
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.ResetOnSpawn = false

-- Main Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Parent = MainUI
MainWindow.BackgroundColor3 = Theme.Background
MainWindow.BorderSizePixel = 0
MainWindow.Position = UDim2.new(0.5, -300, 0.5, -250)
MainWindow.Size = UDim2.new(0, 600, 0, 500)
MainWindow.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainWindow

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainWindow
MainStroke.Color = Theme.Border
MainStroke.Thickness = 2

-- Title Bar (Draggable)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainWindow
TitleBar.BackgroundColor3 = Theme.Secondary
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "Cactus.GG [khen.cc]"
TitleText.TextColor3 = Theme.Text
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Theme.Error
CloseButton.BorderSizePixel = 0
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Theme.Text
CloseButton.TextSize = 24

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

MakeDraggable(MainWindow, TitleBar)

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainWindow
TabContainer.BackgroundTransparency = 1
TabContainer.Size = UDim2.new(1, -20, 0, 40)
TabContainer.Position = UDim2.new(0, 10, 0, 45)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 5)

-- Content Container
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainWindow
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.Size = UDim2.new(1, -20, 1, -90)
ContentContainer.Position = UDim2.new(0, 10, 0, 90)
ContentContainer.ScrollBarThickness = 5
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentContainer
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 10)

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
end)

-- Toggle UI Button (Draggable)
local ToggleUI = Instance.new("ImageButton")
ToggleUI.Name = "ToggleUI"
ToggleUI.Parent = game.CoreGui
ToggleUI.BackgroundColor3 = Theme.Background
ToggleUI.BackgroundTransparency = 0.3
ToggleUI.Size = UDim2.new(0, 90, 0, 90)
ToggleUI.Position = UDim2.new(1, -95, 0, 5)
ToggleUI.Image = "rbxassetid://126818107683779"

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 20)
ToggleCorner.Parent = ToggleUI

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Parent = ToggleUI
ToggleStroke.Color = Theme.Border
ToggleStroke.Thickness = 2

MakeDraggable(ToggleUI, ToggleUI)

-- Lock Button (Draggable)
local LockButton = Instance.new("TextButton")
LockButton.Name = "LockButton"
LockButton.Parent = game.CoreGui
LockButton.BackgroundColor3 = Theme.Background
LockButton.BorderSizePixel = 0
LockButton.Size = UDim2.new(0, 150, 0, 50)
LockButton.Position = UDim2.new(0.5, -75, 0.5, -25)
LockButton.Font = Enum.Font.GothamBold
LockButton.Text = "Lock: OFF"
LockButton.TextColor3 = Theme.Error
LockButton.TextSize = 20

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 8)
LockCorner.Parent = LockButton

local LockStroke = Instance.new("UIStroke")
LockStroke.Parent = LockButton
LockStroke.Color = Theme.Border
LockStroke.Thickness = 2

MakeDraggable(LockButton, LockButton)

-- UI Functions
local CurrentTab = nil
local Tabs = {}
local Containers = {}

local function CreateTab(Name, Order)
    local Tab = Instance.new("TextButton")
    Tab.Name = Name
    Tab.Parent = TabContainer
    Tab.BackgroundColor3 = Theme.Secondary
    Tab.BorderSizePixel = 0
    Tab.Size = UDim2.new(0, 100, 0, 35)
    Tab.Font = Enum.Font.Gotham
    Tab.Text = Name
    Tab.TextColor3 = Theme.Text
    Tab.TextSize = 14
    Tab.LayoutOrder = Order
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = Tab
    
    local Container = Instance.new("Frame")
    Container.Name = Name .. "Container"
    Container.Parent = ContentContainer
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.Visible = false
    
    local ContainerLayout = Instance.new("UIListLayout")
    ContainerLayout.Parent = Container
    ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContainerLayout.Padding = UDim.new(0, 10)
    
    ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.Size = UDim2.new(1, 0, 0, ContainerLayout.AbsoluteContentSize.Y)
    end)
    
    Tab.MouseButton1Click:Connect(function()
        if CurrentTab then
            Containers[CurrentTab].Visible = false
            Tabs[CurrentTab].BackgroundColor3 = Theme.Secondary
        end
        CurrentTab = Name
        Container.Visible = true
        Tab.BackgroundColor3 = Theme.Accent
    end)
    
    Tabs[Name] = Tab
    Containers[Name] = Container
    
    return Container
end

local function CreateSection(Container, Name, Side)
    local Section = Instance.new("Frame")
    Section.Name = Name
    Section.Parent = Container
    Section.BackgroundColor3 = Theme.Secondary
    Section.BorderSizePixel = 0
    Section.Size = UDim2.new(0.48, -5, 0, 0)
    
    if Side == "Left" then
        Section.Position = UDim2.new(0, 0, 0, 0)
    else
        Section.Position = UDim2.new(0.52, 0, 0, 0)
    end
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionStroke = Instance.new("UIStroke")
    SectionStroke.Parent = Section
    SectionStroke.Color = Theme.Border
    SectionStroke.Thickness = 1
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Parent = Section
    SectionTitle.BackgroundColor3 = Theme.Accent
    SectionTitle.BorderSizePixel = 0
    SectionTitle.Size = UDim2.new(1, 0, 0, 30)
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.Text = Name
    SectionTitle.TextColor3 = Theme.Text
    SectionTitle.TextSize = 14
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = SectionTitle
    
    local SectionContent = Instance.new("Frame")
    SectionContent.Name = "Content"
    SectionContent.Parent = Section
    SectionContent.BackgroundTransparency = 1
    SectionContent.Size = UDim2.new(1, -10, 1, -35)
    SectionContent.Position = UDim2.new(0, 5, 0, 35)
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = SectionContent
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 5)
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.Size = UDim2.new(Section.Size.X.Scale, Section.Size.X.Offset, 0, ContentLayout.AbsoluteContentSize.Y + 40)
    end)
    
    return SectionContent
end

local function CreateCheckbox(Container, Name, Default, Callback)
    local CheckboxFrame = Instance.new("Frame")
    CheckboxFrame.Name = Name
    CheckboxFrame.Parent = Container
    CheckboxFrame.BackgroundTransparency = 1
    CheckboxFrame.Size = UDim2.new(1, 0, 0, 30)
    CheckboxFrame.LayoutOrder = #Container:GetChildren()
    
    local Checkbox = Instance.new("TextButton")
    Checkbox.Parent = CheckboxFrame
    Checkbox.BackgroundColor3 = Default and Theme.Success or Theme.Secondary
    Checkbox.BorderSizePixel = 0
    Checkbox.Size = UDim2.new(0, 20, 0, 20)
    Checkbox.Position = UDim2.new(0, 0, 0.5, -10)
    Checkbox.Font = Enum.Font.GothamBold
    Checkbox.Text = Default and "✓" or ""
    Checkbox.TextColor3 = Theme.Text
    Checkbox.TextSize = 14
    
    local CheckCorner = Instance.new("UICorner")
    CheckCorner.CornerRadius = UDim.new(0, 4)
    CheckCorner.Parent = Checkbox
    
    local CheckLabel = Instance.new("TextLabel")
    CheckLabel.Parent = CheckboxFrame
    CheckLabel.BackgroundTransparency = 1
    CheckLabel.Size = UDim2.new(1, -30, 1, 0)
    CheckLabel.Position = UDim2.new(0, 30, 0, 0)
    CheckLabel.Font = Enum.Font.Gotham
    CheckLabel.Text = Name
    CheckLabel.TextColor3 = Theme.Text
    CheckLabel.TextSize = 14
    CheckLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local State = Default
    Checkbox.MouseButton1Click:Connect(function()
        State = not State
        Checkbox.BackgroundColor3 = State and Theme.Success or Theme.Secondary
        Checkbox.Text = State and "✓" or ""
        if Callback then Callback(State) end
    end)
    
    return {Get = function() return State end, Set = function(val) State = val; Checkbox.BackgroundColor3 = State and Theme.Success or Theme.Secondary; Checkbox.Text = State and "✓" or ""; if Callback then Callback(State) end end}
end

local function CreateSlider(Container, Name, Min, Max, Default, Suffix, Decimals, Callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = Name
    SliderFrame.Parent = Container
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.LayoutOrder = #Container:GetChildren()
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = Name .. ": " .. tostring(Default) .. Suffix
    SliderLabel.TextColor3 = Theme.Text
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Theme.Secondary
    SliderBar.BorderSizePixel = 0
    SliderBar.Size = UDim2.new(1, 0, 0, 5)
    SliderBar.Position = UDim2.new(0, 0, 0, 25)
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 2)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Theme.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 2)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderBar
    SliderButton.BackgroundColor3 = Theme.Text
    SliderButton.BorderSizePixel = 0
    SliderButton.Size = UDim2.new(0, 15, 0, 15)
    SliderButton.Position = UDim2.new((Default - Min) / (Max - Min), -7.5, 0.5, -7.5)
    SliderButton.Text = ""
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 7)
    ButtonCorner.Parent = SliderButton
    
    local dragging = false
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UIS:GetMouseLocation()
            local barPos = SliderBar.AbsolutePosition.X
            local barSize = SliderBar.AbsoluteSize.X
            local relativePos = math.clamp((mousePos.X - barPos) / barSize, 0, 1)
            local value = math.floor((Min + (Max - Min) * relativePos) * (10^Decimals)) / (10^Decimals)
            
            SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            SliderButton.Position = UDim2.new(relativePos, -7.5, 0.5, -7.5)
            SliderLabel.Text = Name .. ": " .. tostring(value) .. Suffix
            if Callback then Callback(value) end
        end
    end)
    
    return {Get = function() return Default end, Set = function(val) 
        local relativePos = (val - Min) / (Max - Min)
        SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
        SliderButton.Position = UDim2.new(relativePos, -7.5, 0.5, -7.5)
        SliderLabel.Text = Name .. ": " .. tostring(val) .. Suffix
        if Callback then Callback(val) end
    end}
end

local function CreateTextBox(Container, Name, Placeholder, Callback)
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = Name
    TextBoxFrame.Parent = Container
    TextBoxFrame.BackgroundTransparency = 1
    TextBoxFrame.Size = UDim2.new(1, 0, 0, 40)
    TextBoxFrame.LayoutOrder = #Container:GetChildren()
    
    local TextBoxLabel = Instance.new("TextLabel")
    TextBoxLabel.Parent = TextBoxFrame
    TextBoxLabel.BackgroundTransparency = 1
    TextBoxLabel.Size = UDim2.new(1, 0, 0, 20)
    TextBoxLabel.Font = Enum.Font.Gotham
    TextBoxLabel.Text = Name
    TextBoxLabel.TextColor3 = Theme.Text
    TextBoxLabel.TextSize = 14
    TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = TextBoxFrame
    TextBox.BackgroundColor3 = Theme.Secondary
    TextBox.BorderSizePixel = 0
    TextBox.Size = UDim2.new(1, 0, 0, 25)
    TextBox.Position = UDim2.new(0, 0, 0, 15)
    TextBox.Font = Enum.Font.Gotham
    TextBox.PlaceholderText = Placeholder
    TextBox.Text = Placeholder
    TextBox.TextColor3 = Theme.Text
    TextBox.TextSize = 14
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = TextBox
    
    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Parent = TextBox
    BoxStroke.Color = Theme.Border
    BoxStroke.Thickness = 1
    
    TextBox.FocusLost:Connect(function()
        if Callback then Callback(TextBox.Text) end
    end)
    
    return {Get = function() return TextBox.Text end, Set = function(val) TextBox.Text = tostring(val) end}
end

local function CreateComboBox(Container, Name, Default, Options, Callback)
    local ComboFrame = Instance.new("Frame")
    ComboFrame.Name = Name
    ComboFrame.Parent = Container
    ComboFrame.BackgroundTransparency = 1
    ComboFrame.Size = UDim2.new(1, 0, 0, 40)
    ComboFrame.LayoutOrder = #Container:GetChildren()
    
    local ComboLabel = Instance.new("TextLabel")
    ComboLabel.Parent = ComboFrame
    ComboLabel.BackgroundTransparency = 1
    ComboLabel.Size = UDim2.new(1, 0, 0, 20)
    ComboLabel.Font = Enum.Font.Gotham
    ComboLabel.Text = Name
    ComboLabel.TextColor3 = Theme.Text
    ComboLabel.TextSize = 14
    ComboLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ComboButton = Instance.new("TextButton")
    ComboButton.Parent = ComboFrame
    ComboButton.BackgroundColor3 = Theme.Secondary
    ComboButton.BorderSizePixel = 0
    ComboButton.Size = UDim2.new(1, 0, 0, 25)
    ComboButton.Position = UDim2.new(0, 0, 0, 15)
    ComboButton.Font = Enum.Font.Gotham
    ComboButton.Text = Default
    ComboButton.TextColor3 = Theme.Text
    ComboButton.TextSize = 14
    
    local ComboCorner = Instance.new("UICorner")
    ComboCorner.CornerRadius = UDim.new(0, 6)
    ComboCorner.Parent = ComboButton
    
    local ComboStroke = Instance.new("UIStroke")
    ComboStroke.Parent = ComboButton
    ComboStroke.Color = Theme.Border
    ComboStroke.Thickness = 1
    
    local Dropdown = Instance.new("Frame")
    Dropdown.Parent = ComboFrame
    Dropdown.BackgroundColor3 = Theme.Background
    Dropdown.BorderSizePixel = 0
    Dropdown.Size = UDim2.new(1, 0, 0, 0)
    Dropdown.Position = UDim2.new(0, 0, 1, 5)
    Dropdown.Visible = false
    Dropdown.ZIndex = 10
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = Dropdown
    
    local DropdownLayout = Instance.new("UIListLayout")
    DropdownLayout.Parent = Dropdown
    DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local open = false
    ComboButton.MouseButton1Click:Connect(function()
        open = not open
        Dropdown.Visible = open
        if open then
            Dropdown.Size = UDim2.new(1, 0, 0, #Options * 25)
        else
            Dropdown.Size = UDim2.new(1, 0, 0, 0)
        end
    end)
    
    for i, option in ipairs(Options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = Dropdown
        OptionButton.BackgroundColor3 = Theme.Secondary
        OptionButton.BorderSizePixel = 0
        OptionButton.Size = UDim2.new(1, -10, 0, 20)
        OptionButton.Position = UDim2.new(0, 5, 0, (i-1) * 25)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = Theme.Text
        OptionButton.TextSize = 12
        OptionButton.LayoutOrder = i
        
        OptionButton.MouseButton1Click:Connect(function()
            ComboButton.Text = option
            open = false
            Dropdown.Visible = false
            Dropdown.Size = UDim2.new(1, 0, 0, 0)
            if Callback then Callback(option) end
        end)
    end
    
    return {Get = function() return ComboButton.Text end, Set = function(val) ComboButton.Text = tostring(val) end}
end

local function CreateColorPicker(Container, Name, Default, Transparency, Callback)
    local ColorFrame = Instance.new("Frame")
    ColorFrame.Name = Name
    ColorFrame.Parent = Container
    ColorFrame.BackgroundTransparency = 1
    ColorFrame.Size = UDim2.new(1, 0, 0, 40)
    ColorFrame.LayoutOrder = #Container:GetChildren()
    
    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Parent = ColorFrame
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Size = UDim2.new(1, -50, 0, 20)
    ColorLabel.Font = Enum.Font.Gotham
    ColorLabel.Text = Name
    ColorLabel.TextColor3 = Theme.Text
    ColorLabel.TextSize = 14
    ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ColorButton = Instance.new("TextButton")
    ColorButton.Parent = ColorFrame
    ColorButton.BackgroundColor3 = Default
    ColorButton.BorderSizePixel = 0
    ColorButton.Size = UDim2.new(0, 40, 0, 25)
    ColorButton.Position = UDim2.new(1, -40, 0, 15)
    ColorButton.Text = ""
    
    local ColorCorner = Instance.new("UICorner")
    ColorCorner.CornerRadius = UDim.new(0, 6)
    ColorCorner.Parent = ColorButton
    
    local ColorStroke = Instance.new("UIStroke")
    ColorStroke.Parent = ColorButton
    ColorStroke.Color = Theme.Border
    ColorStroke.Thickness = 2
    
    -- Simple color picker (you can enhance this)
    ColorButton.MouseButton1Click:Connect(function()
        -- For now, just cycle through some preset colors
        local colors = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(144, 238, 144)
        }
        local currentIndex = 1
        for i, col in ipairs(colors) do
            if math.abs(col.R - Default.R) < 0.1 and math.abs(col.G - Default.G) < 0.1 and math.abs(col.B - Default.B) < 0.1 then
                currentIndex = i
                break
            end
        end
        currentIndex = (currentIndex % #colors) + 1
        ColorButton.BackgroundColor3 = colors[currentIndex]
        if Callback then Callback(colors[currentIndex]) end
    end)
    
    return {Get = function() return ColorButton.BackgroundColor3 end, Set = function(val) ColorButton.BackgroundColor3 = val; if Callback then Callback(val) end end}
end

local function CreateButton(Container, Name, Callback)
    local Button = Instance.new("TextButton")
    Button.Name = Name
    Button.Parent = Container
    Button.BackgroundColor3 = Theme.Accent
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Font = Enum.Font.GothamBold
    Button.Text = Name
    Button.TextColor3 = Theme.Text
    Button.TextSize = 14
    Button.LayoutOrder = #Container:GetChildren()
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        if Callback then Callback() end
    end)
    
    return Button
end

-- Notification System
local function Notify(Message, Duration)
    Duration = Duration or 3
    local Notif = Instance.new("Frame")
    Notif.Parent = MainUI
    Notif.BackgroundColor3 = Theme.Background
    Notif.BorderSizePixel = 0
    Notif.Size = UDim2.new(0, 300, 0, 60)
    Notif.Position = UDim2.new(1, 10, 0, 10)
    Notif.ZIndex = 100
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = Notif
    
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Parent = Notif
    NotifStroke.Color = Theme.Border
    NotifStroke.Thickness = 2
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Parent = Notif
    NotifText.BackgroundTransparency = 1
    NotifText.Size = UDim2.new(1, -20, 1, 0)
    NotifText.Position = UDim2.new(0, 10, 0, 0)
    NotifText.Font = Enum.Font.Gotham
    NotifText.Text = Message
    NotifText.TextColor3 = Theme.Text
    NotifText.TextSize = 14
    NotifText.TextWrapped = true
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    
    TweenService:Create(Notif, TweenInfo.new(0.3), {Position = UDim2.new(1, -310, 0, 10)}):Play()
    task.wait(Duration)
    TweenService:Create(Notif, TweenInfo.new(0.3), {Position = UDim2.new(1, 10, 0, 10), Transparency = 1}):Play()
    task.wait(0.3)
    Notif:Destroy()
end

-- Toggle UI
local UIOpen = false
ToggleUI.MouseButton1Click:Connect(function()
    UIOpen = not UIOpen
    MainWindow.Visible = UIOpen
    if UIOpen then
        TweenService:Create(MainWindow, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 500)}):Play()
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    UIOpen = false
    MainWindow.Visible = false
end)

-- Initialize first tab
local MainTab = CreateTab("Main", 1)
local HvHTab = CreateTab("HvH", 2)
local VisualsTab = CreateTab("Visuals", 3)
local MiscTab = CreateTab("Misc", 4)

Tabs["Main"].MouseButton1Click:Fire()

-- Export UI API
local Menu = {
    Tab = function(name) return Containers[name] end,
    Container = function(tab, name, side) return CreateSection(Containers[tab], name, side) end,
    CheckBox = function(tab, container, name, default, callback) return CreateCheckbox(Containers[tab]:FindFirstChild(container).Content, name, default, callback) end,
    Slider = function(tab, container, name, min, max, default, suffix, decimals, callback) return CreateSlider(Containers[tab]:FindFirstChild(container).Content, name, min, max, default, suffix, decimals, callback) end,
    TextBox = function(tab, container, name, placeholder, callback) return CreateTextBox(Containers[tab]:FindFirstChild(container).Content, name, placeholder, callback) end,
    ComboBox = function(tab, container, name, default, options, callback) return CreateComboBox(Containers[tab]:FindFirstChild(container).Content, name, default, options, callback) end,
    ColorPicker = function(tab, container, name, default, transparency, callback) return CreateColorPicker(Containers[tab]:FindFirstChild(container).Content, name, default, transparency, callback) end,
    Button = function(tab, container, name, callback) return CreateButton(Containers[tab]:FindFirstChild(container).Content, name, callback) end,
    Notify = Notify,
    SetVisible = function(visible) MainWindow.Visible = visible; UIOpen = visible end,
    SetSize = function(x, y) MainWindow.Size = UDim2.new(0, x, 0, y) end,
    SetTitle = function(title) TitleText.Text = title end,
    Init = function() Notify("Script Loaded.", 2) end
}

-- Continue with your original script code below...
-- (All your existing script code goes here, but replace Menu calls with the new Menu API)

-- Rest of your script...
task.spawn(function()
    Menu:SetTitle("Cactus.GG [khen.cc]")
end)

-- Your Script table and Settings remain the same...
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
butj.Parent = game.CoreGui
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

ToggleUI.MouseButton1Click:Connect(function()
    Open = not Open
    print("khen.cc")
    ToggleMenu()
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

-- [Rest of your particle emitters and effects code would go here...]
-- I'm including the essential UI setup code, but you'll need to add all your particle effects, 
-- hit detection, aimbot logic, etc. from your original script

-- Setup UI Elements
Menu:SetSize(600, 500)
Menu:Init()

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

local TeleportSection = Menu.Container("HvH", "Teleports", "Left")
Menu.CheckBox("HvH", "Teleports", "Grenade Tp", GrenadeTP, function(a)
    Script.Locals.GrenadeTP.Enabled = a
end)

Menu.CheckBox("HvH", "Teleports", "Rocket Tp", RocketTP, function(a)
    Script.Locals.RocketTP.Enabled = a
end)

local BulletTaP = Menu.Container("HvH", "Bullet-TP", "Left")
Menu.CheckBox("HvH", "Bullet-TP", "Bullet Gyatt", RocketTP, function(a) 
    Script.Locals.GunTP.Enabled = a
end)

Menu.CheckBox("HvH", "Bullet-TP", "Anchor", RocketTP, function(a) 
    Script.Locals.GunTP.Anchor = a
end)

Menu.TextBox("HvH", "Bullet-TP", "X", "0", function(a) Script.Locals.GunTP.Offset[1] = a end)
Menu.TextBox("HvH", "Bullet-TP", "Y", "-0.5", function(a) Script.Locals.GunTP.Offset[2] = a end)
Menu.TextBox("HvH", "Bullet-TP", "Z", "0", function(a) Script.Locals.GunTP.Offset[3] = a end)

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

local Hitnotify = false
local PredictionSection = Menu.Container("Main", "Prediction", "Left")
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

local CameraContainer = Menu.Container("Main", "Camera", "Right")
Menu.CheckBox("Main", "Camera", "Enabled", getgenv().Sentinel.Camera, function(a)
    getgenv().Sentinel.Camera = a
end)

Menu.TextBox("Main", "Camera", "Smoothness", tostring(getgenv().Sentinel.smoothness), function(a)
    getgenv().Sentinel.smoothness= tonumber(a)
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

local HitDetectionSection = Menu.Container("Visuals", "Hit Detection", "Left")
Menu.CheckBox("Visuals", "Hit Detection", "Hit Effect", TargetAimbot.HitEffect, function(a) 
    TargetAimbot.HitEffect = a
end)

Menu.CheckBox("Visuals", "Hit Detection", "Hit Sound", TargetAimbot.HitSounds, function(a)
    TargetAimbot.HitSounds = a
end)

Menu.CheckBox("Visuals", "Hit Detection", "Notify", false, function(a) 
    Hitnotify = a
end)

Menu.ComboBox("Visuals", "Hit Detection", "Effect Type", TargetAimbot.HitEffectType, {
    "Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", 
    "Circle Shot", "Bolt","Aura","Electric","Shock","Thunder"
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

local MTSection2 = Menu.Container("Misc", "CFrame Speed", "Right")
Menu.CheckBox("Misc", "CFrame Speed", "Enabled", false, function(a)
    getgenv().Sentinel.cframespeedtoggle = a
end)

Menu.Slider("Misc", "CFrame Speed", "Speed", 0, 10, 3, '%', 1, function(a)
    getgenv().Sentinel.speedvalue = a
end)

local MTSectionS = Menu.Container("Misc", "Macro", "Right")
Menu.Button("Misc", "Macro", "Load Macro", function()
    -- Your macro code here
    Menu.Notify("Macro Loaded", 2)
end)

Menu.TextBox("Misc", "Macro", "Speed", tostring(getgenv().Sentinel.MacroSpeed), function(a)
    getgenv().Sentinel.MacroSpeed = tonumber(a)
end)

local aurasec2 = Menu.Container("Misc", "Aura", "Right")
Menu.CheckBox("Misc", "Aura", "Enabled", false, function(y)
    -- Your aura code here
end)

local MTSection3 = Menu.Container("Misc", "Fly", "Right")
Menu.CheckBox("Misc", "Fly", "Enabled", false, function(a)
    -- Fly code
end)

local MTSection4 = Menu.Container("Misc", "Network Anti", "Left")
Menu.CheckBox("Misc", "Network Anti", "Enabled", getgenv().Sentinel.network, function(a)
    getgenv().Sentinel.network = a
end)

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
    Enum.Material.Neon.Name, Enum.Material.SmoothPlastic.Name
}, function(a)
    TargetAimbot.HitChamsMaterial = Enum.Material[a]
end)

-- Lock Button Functionality
local TargBindEnabled = true
local TargetPlr = nil
local target_health = nil

local function toggle_lock()
    if TargetAimbot.Enabled then
        -- Your target selection logic here
        if TargBindEnabled and TargetPlr then
            TargBindEnabled = false
            target_health = nil
            TargetPlr = nil
            LockButton.Text = "Lock: OFF"
            LockButton.TextColor3 = Theme.Error
            Menu.Notify("Untargeted", 2)
        else
            TargBindEnabled = true
            -- Set target logic
            LockButton.Text = "Lock: ON"
            LockButton.TextColor3 = Theme.Success
            Menu.Notify("Target Locked", 2)
        end
    end
end

LockButton.MouseButton1Click:Connect(toggle_lock)

-- [Add all your remaining script logic here - aimbot, hit detection, effects, etc.]

print("Custom UI Loaded Successfully!")
