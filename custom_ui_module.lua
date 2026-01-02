--[[
    Custom Draggable UI System for Cactus.GG
    Replace the Menu loading line with: local Menu = loadstring(readfile("custom_ui_module.lua"))()
]]

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- UI Theme
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
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
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

-- Create UI
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

Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainWindow)
MainStroke.Color = Theme.Border
MainStroke.Thickness = 2

-- Title Bar (Draggable)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainWindow
TitleBar.BackgroundColor3 = Theme.Secondary
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

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
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)

MakeDraggable(MainWindow, TitleBar)

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainWindow
TabContainer.BackgroundTransparency = 1
TabContainer.Size = UDim2.new(1, -20, 0, 40)
TabContainer.Position = UDim2.new(0, 10, 0, 45)

local TabLayout = Instance.new("UIListLayout", TabContainer)
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

local ContentLayout = Instance.new("UIListLayout", ContentContainer)
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
Instance.new("UICorner", ToggleUI).CornerRadius = UDim.new(0, 20)
local ToggleStroke = Instance.new("UIStroke", ToggleUI)
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
Instance.new("UICorner", LockButton).CornerRadius = UDim.new(0, 8)
local LockStroke = Instance.new("UIStroke", LockButton)
LockStroke.Color = Theme.Border
LockStroke.Thickness = 2

MakeDraggable(LockButton, LockButton)

-- UI State
local CurrentTab = nil
local Tabs = {}
local Containers = {}

-- Helper Functions
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
    Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 8)
    
    local Container = Instance.new("Frame")
    Container.Name = Name .. "Container"
    Container.Parent = ContentContainer
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.Visible = false
    
    local ContainerLayout = Instance.new("UIListLayout", Container)
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
    Section.Position = Side == "Left" and UDim2.new(0, 0, 0, 0) or UDim2.new(0.52, 0, 0, 0)
    Instance.new("UICorner", Section).CornerRadius = UDim.new(0, 8)
    local SectionStroke = Instance.new("UIStroke", Section)
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
    Instance.new("UICorner", SectionTitle).CornerRadius = UDim.new(0, 8)
    
    local SectionContent = Instance.new("Frame")
    SectionContent.Name = "Content"
    SectionContent.Parent = Section
    SectionContent.BackgroundTransparency = 1
    SectionContent.Size = UDim2.new(1, -10, 1, -35)
    SectionContent.Position = UDim2.new(0, 5, 0, 35)
    
    local ContentLayout = Instance.new("UIListLayout", SectionContent)
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
    Instance.new("UICorner", Checkbox).CornerRadius = UDim.new(0, 4)
    
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
    
    return {Get = function() return State end, Set = function(val) 
        State = val
        Checkbox.BackgroundColor3 = State and Theme.Success or Theme.Secondary
        Checkbox.Text = State and "✓" or ""
        if Callback then Callback(State) end
    end}
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
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(0, 2)
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Theme.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 2)
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderBar
    SliderButton.BackgroundColor3 = Theme.Text
    SliderButton.BorderSizePixel = 0
    SliderButton.Size = UDim2.new(0, 15, 0, 15)
    SliderButton.Position = UDim2.new((Default - Min) / (Max - Min), -7.5, 0.5, -7.5)
    SliderButton.Text = ""
    Instance.new("UICorner", SliderButton).CornerRadius = UDim.new(0, 7)
    
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
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)
    local BoxStroke = Instance.new("UIStroke", TextBox)
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
    Instance.new("UICorner", ComboButton).CornerRadius = UDim.new(0, 6)
    local ComboStroke = Instance.new("UIStroke", ComboButton)
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
    Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)
    
    local DropdownLayout = Instance.new("UIListLayout", Dropdown)
    DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local open = false
    ComboButton.MouseButton1Click:Connect(function()
        open = not open
        Dropdown.Visible = open
        Dropdown.Size = UDim2.new(1, 0, 0, open and #Options * 25 or 0)
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
    Instance.new("UICorner", ColorButton).CornerRadius = UDim.new(0, 6)
    local ColorStroke = Instance.new("UIStroke", ColorButton)
    ColorStroke.Color = Theme.Border
    ColorStroke.Thickness = 2
    
    local colors = {
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255), Color3.fromRGB(144, 238, 144)
    }
    
    ColorButton.MouseButton1Click:Connect(function()
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
    
    return {Get = function() return ColorButton.BackgroundColor3 end, Set = function(val) 
        ColorButton.BackgroundColor3 = val
        if Callback then Callback(val) end
    end}
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
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    
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
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 8)
    local NotifStroke = Instance.new("UIStroke", Notif)
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
end)

CloseButton.MouseButton1Click:Connect(function()
    UIOpen = false
    MainWindow.Visible = false
end)

-- Initialize tabs
CreateTab("Main", 1)
CreateTab("HvH", 2)
CreateTab("Visuals", 3)
CreateTab("Misc", 4)
Tabs["Main"].MouseButton1Click:Fire()

-- Export Menu API (compatible with your existing code)
return {
    Tab = function(name) return Containers[name] end,
    Container = function(tab, name, side) 
        local container = Containers[tab]
        if not container then return end
        local section = container:FindFirstChild(name)
        if section then return section.Content end
        return CreateSection(container, name, side)
    end,
    CheckBox = function(tab, container, name, default, callback) 
        local cont = Containers[tab]:FindFirstChild(container)
        return cont and CreateCheckbox(cont.Content, name, default, callback) or nil
    end,
    Slider = function(tab, container, name, min, max, default, suffix, decimals, callback) 
        local cont = Containers[tab]:FindFirstChild(container)
        return cont and CreateSlider(cont.Content, name, min, max, default, suffix, decimals, callback) or nil
    end,
    TextBox = function(tab, container, name, placeholder, callback) 
        local cont = Containers[tab]:FindFirstChild(container)
        return cont and CreateTextBox(cont.Content, name, placeholder, callback) or nil
    end,
    ComboBox = function(tab, container, name, default, options, callback) 
        local cont = Containers[tab]:FindFirstChild(container)
        return cont and CreateComboBox(cont.Content, name, default, options, callback) or nil
    end,
    ColorPicker = function(tab, container, name, default, transparency, callback) 
        local cont = Containers[tab]:FindFirstChild(container)
        return cont and CreateColorPicker(cont.Content, name, default, transparency, callback) or nil
    end,
    Button = function(tab, container, name, callback) 
        local cont = Containers[tab]:FindFirstChild(container)
        return cont and CreateButton(cont.Content, name, callback) or nil
    end,
    Notify = Notify,
    SetVisible = function(visible) 
        MainWindow.Visible = visible
        UIOpen = visible
    end,
    SetSize = function(x, y) 
        MainWindow.Size = UDim2.new(0, x, 0, y)
    end,
    SetTitle = function(title) 
        TitleText.Text = title
    end,
    Init = function() 
        Notify("Script Loaded.", 2)
    end,
    NameUpdate = function(duration, name, subtitle)
        -- Compatibility function
        task.spawn(function()
            task.wait(duration)
            TitleText.Text = name .. " " .. subtitle
        end)
    end
}
