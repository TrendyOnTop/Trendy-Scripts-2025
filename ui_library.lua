-- Modern UI Library from Scratch
local UI = {}
UI.__index = UI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- UI Colors
UI.Colors = {
    Background = Color3.fromRGB(20, 20, 30),
    Secondary = Color3.fromRGB(30, 30, 45),
    Accent = Color3.fromRGB(98, 0, 67),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Border = Color3.fromRGB(40, 40, 60),
    Success = Color3.fromRGB(0, 255, 0),
    Error = Color3.fromRGB(255, 0, 0)
}

-- Create Main ScreenGui
function UI.new()
    local self = setmetatable({}, UI)
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CactusUI"
    self.ScreenGui.Parent = game:GetService("CoreGui")
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.BackgroundColor3 = UI.Colors.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Size = UDim2.new(0, 500, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Parent = self.MainFrame
    stroke.Color = UI.Colors.Border
    stroke.Thickness = 2
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Parent = self.MainFrame
    self.TitleBar.BackgroundColor3 = UI.Colors.Secondary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.TitleBar
    
    -- Title Text
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.Parent = self.TitleBar
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.Text = "Cactus.GG [khen.cc]"
    self.TitleLabel.TextColor3 = UI.Colors.Text
    self.TitleLabel.TextSize = 16
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Parent = self.TitleBar
    self.CloseButton.BackgroundColor3 = UI.Colors.Error
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -35, 0, 5)
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = UI.Colors.Text
    self.CloseButton.TextSize = 20
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = self.CloseButton
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Parent = self.MainFrame
    self.TabContainer.BackgroundColor3 = UI.Colors.Secondary
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Size = UDim2.new(1, 0, 0, 40)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 40)
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Parent = self.TabContainer
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabListLayout.Padding = UDim.new(0, 5)
    
    -- Content Frame
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Parent = self.MainFrame
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Size = UDim2.new(1, -20, 1, -100)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 90)
    self.ContentFrame.ScrollBarThickness = 4
    self.ContentFrame.ScrollBarImageColor3 = UI.Colors.Accent
    self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local contentListLayout = Instance.new("UIListLayout")
    contentListLayout.Parent = self.ContentFrame
    contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentListLayout.Padding = UDim.new(0, 10)
    
    -- Variables
    self.Tabs = {}
    self.CurrentTab = nil
    self.Visible = true
    self.Notifications = {}
    
    -- Close button functionality
    self.CloseButton.MouseButton1Click:Connect(function()
        self:SetVisible(false)
    end)
    
    -- Update canvas size
    contentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, contentListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    return self
end

-- Set visibility
function UI:SetVisible(visible)
    self.Visible = visible
    self.MainFrame.Visible = visible
end

-- Create Tab
function UI:Tab(name)
    local tab = {}
    tab.Name = name
    tab.Buttons = {}
    tab.Containers = {}
    
    -- Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Parent = self.TabContainer
    tabButton.BackgroundColor3 = UI.Colors.Background
    tabButton.BorderSizePixel = 0
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.Font = Enum.Font.Gotham
    tabButton.Text = name
    tabButton.TextColor3 = UI.Colors.TextSecondary
    tabButton.TextSize = 14
    
    local tabButtonCorner = Instance.new("UICorner")
    tabButtonCorner.CornerRadius = UDim.new(0, 6)
    tabButtonCorner.Parent = tabButton
    
    tab.Button = tabButton
    
    -- Tab Content
    local tabContent = Instance.new("Frame")
    tabContent.Name = name .. "Content"
    tabContent.Parent = self.ContentFrame
    tabContent.BackgroundTransparency = 1
    tabContent.Size = UDim2.new(1, 0, 0, 0)
    tabContent.Visible = false
    
    local tabContentListLayout = Instance.new("UIListLayout")
    tabContentListLayout.Parent = tabContent
    tabContentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabContentListLayout.Padding = UDim.new(0, 10)
    
    tabContentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.Size = UDim2.new(1, 0, 0, tabContentListLayout.AbsoluteContentSize.Y)
    end)
    
    tab.Content = tabContent
    
    -- Tab click
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    
    self.Tabs[name] = tab
    
    -- Set as current if first tab
    if not self.CurrentTab then
        self:SwitchTab(name)
    end
    
    return tab
end

-- Switch Tab
function UI:SwitchTab(name)
    if not self.Tabs[name] then return end
    
    -- Hide all tabs
    for tabName, tab in pairs(self.Tabs) do
        tab.Content.Visible = false
        tab.Button.BackgroundColor3 = UI.Colors.Background
        tab.Button.TextColor3 = UI.Colors.TextSecondary
    end
    
    -- Show selected tab
    self.Tabs[name].Content.Visible = true
    self.Tabs[name].Button.BackgroundColor3 = UI.Colors.Accent
    self.Tabs[name].Button.TextColor3 = UI.Colors.Text
    
    self.CurrentTab = name
end

-- Create Container
function UI:Container(tabName, containerName, side)
    local tab = self.Tabs[tabName]
    if not tab then return nil end
    
    local container = {}
    container.Name = containerName
    
    -- Container Frame
    local containerFrame = Instance.new("Frame")
    containerFrame.Name = containerName
    containerFrame.Parent = tab.Content
    containerFrame.BackgroundColor3 = UI.Colors.Secondary
    containerFrame.BorderSizePixel = 0
    containerFrame.Size = UDim2.new(0.48, -5, 0, 0)
    containerFrame.LayoutOrder = #tab.Containers + 1
    
    if side == "Left" then
        containerFrame.Position = UDim2.new(0, 0, 0, 0)
    elseif side == "Right" then
        containerFrame.Position = UDim2.new(0.52, 0, 0, 0)
    else
        containerFrame.Size = UDim2.new(1, 0, 0, 0)
    end
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = containerFrame
    
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Parent = containerFrame
    containerStroke.Color = UI.Colors.Border
    containerStroke.Thickness = 1
    
    -- Container Title
    local containerTitle = Instance.new("TextLabel")
    containerTitle.Name = "Title"
    containerTitle.Parent = containerFrame
    containerTitle.BackgroundTransparency = 1
    containerTitle.Size = UDim2.new(1, -20, 0, 30)
    containerTitle.Position = UDim2.new(0, 10, 0, 5)
    containerTitle.Font = Enum.Font.GothamBold
    containerTitle.Text = containerName
    containerTitle.TextColor3 = UI.Colors.Text
    containerTitle.TextSize = 14
    containerTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Container Content
    local containerContent = Instance.new("Frame")
    containerContent.Name = "Content"
    containerContent.Parent = containerFrame
    containerContent.BackgroundTransparency = 1
    containerContent.Size = UDim2.new(1, -20, 0, 0)
    containerContent.Position = UDim2.new(0, 10, 0, 35)
    
    local containerListLayout = Instance.new("UIListLayout")
    containerListLayout.Parent = containerContent
    containerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerListLayout.Padding = UDim.new(0, 8)
    
    containerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        containerContent.Size = UDim2.new(1, 0, 0, containerListLayout.AbsoluteContentSize.Y)
        containerFrame.Size = UDim2.new(containerFrame.Size.X.Scale, containerFrame.Size.X.Offset, 0, containerListLayout.AbsoluteContentSize.Y + 45)
    end)
    
    container.Frame = containerFrame
    container.Content = containerContent
    container.Controls = {}
    
    table.insert(tab.Containers, container)
    
    return container
end

-- CheckBox
function UI:CheckBox(tabName, containerName, label, defaultValue, callback)
    local container = self:GetContainer(tabName, containerName)
    if not container then return end
    
    local checkBox = Instance.new("Frame")
    checkBox.Name = label
    checkBox.Parent = container.Content
    checkBox.BackgroundTransparency = 1
    checkBox.Size = UDim2.new(1, 0, 0, 30)
    checkBox.LayoutOrder = #container.Controls + 1
    
    local checkBoxLabel = Instance.new("TextLabel")
    checkBoxLabel.Name = "Label"
    checkBoxLabel.Parent = checkBox
    checkBoxLabel.BackgroundTransparency = 1
    checkBoxLabel.Size = UDim2.new(1, -40, 1, 0)
    checkBoxLabel.Position = UDim2.new(0, 0, 0, 0)
    checkBoxLabel.Font = Enum.Font.Gotham
    checkBoxLabel.Text = label
    checkBoxLabel.TextColor3 = UI.Colors.Text
    checkBoxLabel.TextSize = 13
    checkBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local checkBoxButton = Instance.new("TextButton")
    checkBoxButton.Name = "Button"
    checkBoxButton.Parent = checkBox
    checkBoxButton.BackgroundColor3 = defaultValue and UI.Colors.Accent or UI.Colors.Background
    checkBoxButton.BorderSizePixel = 0
    checkBoxButton.Size = UDim2.new(0, 25, 0, 25)
    checkBoxButton.Position = UDim2.new(1, -30, 0, 2.5)
    checkBoxButton.Font = Enum.Font.GothamBold
    checkBoxButton.Text = defaultValue and "✓" or ""
    checkBoxButton.TextColor3 = UI.Colors.Text
    checkBoxButton.TextSize = 16
    
    local checkBoxCorner = Instance.new("UICorner")
    checkBoxCorner.CornerRadius = UDim.new(0, 4)
    checkBoxCorner.Parent = checkBoxButton
    
    local checkBoxStroke = Instance.new("UIStroke")
    checkBoxStroke.Parent = checkBoxButton
    checkBoxStroke.Color = UI.Colors.Border
    checkBoxStroke.Thickness = 1
    
    local value = defaultValue
    
    checkBoxButton.MouseButton1Click:Connect(function()
        value = not value
        checkBoxButton.BackgroundColor3 = value and UI.Colors.Accent or UI.Colors.Background
        checkBoxButton.Text = value and "✓" or ""
        if callback then callback(value) end
    end)
    
    table.insert(container.Controls, checkBox)
    
    return checkBox
end

-- TextBox
function UI:TextBox(tabName, containerName, label, placeholder, callback)
    local container = self:GetContainer(tabName, containerName)
    if not container then return end
    
    local textBoxFrame = Instance.new("Frame")
    textBoxFrame.Name = label
    textBoxFrame.Parent = container.Content
    textBoxFrame.BackgroundTransparency = 1
    textBoxFrame.Size = UDim2.new(1, 0, 0, 50)
    textBoxFrame.LayoutOrder = #container.Controls + 1
    
    local textBoxLabel = Instance.new("TextLabel")
    textBoxLabel.Name = "Label"
    textBoxLabel.Parent = textBoxFrame
    textBoxLabel.BackgroundTransparency = 1
    textBoxLabel.Size = UDim2.new(1, 0, 0, 20)
    textBoxLabel.Position = UDim2.new(0, 0, 0, 0)
    textBoxLabel.Font = Enum.Font.Gotham
    textBoxLabel.Text = label
    textBoxLabel.TextColor3 = UI.Colors.Text
    textBoxLabel.TextSize = 13
    textBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Parent = textBoxFrame
    textBox.BackgroundColor3 = UI.Colors.Background
    textBox.BorderSizePixel = 0
    textBox.Size = UDim2.new(1, 0, 0, 25)
    textBox.Position = UDim2.new(0, 0, 0, 25)
    textBox.Font = Enum.Font.Gotham
    textBox.Text = placeholder
    textBox.PlaceholderText = placeholder
    textBox.TextColor3 = UI.Colors.Text
    textBox.PlaceholderColor3 = UI.Colors.TextSecondary
    textBox.TextSize = 13
    
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 4)
    textBoxCorner.Parent = textBox
    
    local textBoxStroke = Instance.new("UIStroke")
    textBoxStroke.Parent = textBox
    textBoxStroke.Color = UI.Colors.Border
    textBoxStroke.Thickness = 1
    
    textBox.FocusLost:Connect(function(enterPressed)
        if callback then callback(textBox.Text) end
    end)
    
    table.insert(container.Controls, textBoxFrame)
    
    return textBoxFrame
end

-- ComboBox
function UI:ComboBox(tabName, containerName, label, defaultValue, options, callback)
    local container = self:GetContainer(tabName, containerName)
    if not container then return end
    
    local comboBoxFrame = Instance.new("Frame")
    comboBoxFrame.Name = label
    comboBoxFrame.Parent = container.Content
    comboBoxFrame.BackgroundTransparency = 1
    comboBoxFrame.Size = UDim2.new(1, 0, 0, 50)
    comboBoxFrame.LayoutOrder = #container.Controls + 1
    
    local comboBoxLabel = Instance.new("TextLabel")
    comboBoxLabel.Name = "Label"
    comboBoxLabel.Parent = comboBoxFrame
    comboBoxLabel.BackgroundTransparency = 1
    comboBoxLabel.Size = UDim2.new(1, 0, 0, 20)
    comboBoxLabel.Position = UDim2.new(0, 0, 0, 0)
    comboBoxLabel.Font = Enum.Font.Gotham
    comboBoxLabel.Text = label
    comboBoxLabel.TextColor3 = UI.Colors.Text
    comboBoxLabel.TextSize = 13
    comboBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local comboBoxButton = Instance.new("TextButton")
    comboBoxButton.Name = "Button"
    comboBoxButton.Parent = comboBoxFrame
    comboBoxButton.BackgroundColor3 = UI.Colors.Background
    comboBoxButton.BorderSizePixel = 0
    comboBoxButton.Size = UDim2.new(1, 0, 0, 25)
    comboBoxButton.Position = UDim2.new(0, 0, 0, 25)
    comboBoxButton.Font = Enum.Font.Gotham
    comboBoxButton.Text = defaultValue or options[1] or ""
    comboBoxButton.TextColor3 = UI.Colors.Text
    comboBoxButton.TextSize = 13
    
    local comboBoxCorner = Instance.new("UICorner")
    comboBoxCorner.CornerRadius = UDim.new(0, 4)
    comboBoxCorner.Parent = comboBoxButton
    
    local comboBoxStroke = Instance.new("UIStroke")
    comboBoxStroke.Parent = comboBoxButton
    comboBoxStroke.Color = UI.Colors.Border
    comboBoxStroke.Thickness = 1
    
    local currentValue = defaultValue or options[1]
    local dropdownOpen = false
    
    -- Dropdown Frame
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown"
    dropdownFrame.Parent = comboBoxFrame
    dropdownFrame.BackgroundColor3 = UI.Colors.Background
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    dropdownFrame.Position = UDim2.new(0, 0, 0, 50)
    dropdownFrame.Visible = false
    dropdownFrame.ZIndex = 10
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    dropdownCorner.Parent = dropdownFrame
    
    local dropdownStroke = Instance.new("UIStroke")
    dropdownStroke.Parent = dropdownFrame
    dropdownStroke.Color = UI.Colors.Border
    dropdownStroke.Thickness = 1
    
    local dropdownListLayout = Instance.new("UIListLayout")
    dropdownListLayout.Parent = dropdownFrame
    dropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    dropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        dropdownFrame.Size = UDim2.new(1, 0, 0, dropdownListLayout.AbsoluteContentSize.Y)
    end)
    
    local function createOption(option)
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option
        optionButton.Parent = dropdownFrame
        optionButton.BackgroundColor3 = UI.Colors.Secondary
        optionButton.BorderSizePixel = 0
        optionButton.Size = UDim2.new(1, -10, 0, 25)
        optionButton.Position = UDim2.new(0, 5, 0, 0)
        optionButton.Font = Enum.Font.Gotham
        optionButton.Text = option
        optionButton.TextColor3 = UI.Colors.Text
        optionButton.TextSize = 12
        
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 4)
        optionCorner.Parent = optionButton
        
        optionButton.MouseButton1Click:Connect(function()
            currentValue = option
            comboBoxButton.Text = option
            dropdownFrame.Visible = false
            dropdownOpen = false
            if callback then callback(option) end
        end)
        
        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundColor3 = UI.Colors.Accent
        end)
        
        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundColor3 = UI.Colors.Secondary
        end)
    end
    
    for _, option in ipairs(options) do
        createOption(option)
    end
    
    comboBoxButton.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        dropdownFrame.Visible = dropdownOpen
    end)
    
    table.insert(container.Controls, comboBoxFrame)
    
    return comboBoxFrame
end

-- Slider
function UI:Slider(tabName, containerName, label, min, max, defaultValue, suffix, decimals, callback)
    local container = self:GetContainer(tabName, containerName)
    if not container then return end
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = label
    sliderFrame.Parent = container.Content
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.LayoutOrder = #container.Controls + 1
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Parent = sliderFrame
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Text = label .. ": " .. tostring(defaultValue) .. (suffix or "")
    sliderLabel.TextColor3 = UI.Colors.Text
    sliderLabel.TextSize = 13
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.Parent = sliderFrame
    sliderTrack.BackgroundColor3 = UI.Colors.Background
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Size = UDim2.new(1, 0, 0, 5)
    sliderTrack.Position = UDim2.new(0, 0, 0, 30)
    
    local sliderTrackCorner = Instance.new("UICorner")
    sliderTrackCorner.CornerRadius = UDim.new(0, 2)
    sliderTrackCorner.Parent = sliderTrack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Parent = sliderTrack
    sliderFill.BackgroundColor3 = UI.Colors.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 2)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "Button"
    sliderButton.Parent = sliderTrack
    sliderButton.BackgroundColor3 = UI.Colors.Text
    sliderButton.BorderSizePixel = 0
    sliderButton.Size = UDim2.new(0, 15, 0, 15)
    sliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -7.5, 0, -5)
    sliderButton.Text = ""
    
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0, 7)
    sliderButtonCorner.Parent = sliderButton
    
    local value = defaultValue
    local dragging = false
    
    local function updateValue(newValue)
        value = math.clamp(newValue, min, max)
        local percent = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, -7.5, 0, -5)
        
        local displayValue = decimals and math.floor(value * (10 ^ decimals)) / (10 ^ decimals) or math.floor(value)
        sliderLabel.Text = label .. ": " .. tostring(displayValue) .. (suffix or "")
        
        if callback then callback(value) end
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = sliderTrack.AbsolutePosition
            local trackSize = sliderTrack.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            local newValue = min + (relativeX * (max - min))
            updateValue(newValue)
        end
    end)
    
    table.insert(container.Controls, sliderFrame)
    
    return sliderFrame
end

-- ColorPicker
function UI:ColorPicker(tabName, containerName, label, defaultValue, transparency, callback)
    local container = self:GetContainer(tabName, containerName)
    if not container then return end
    
    local colorPickerFrame = Instance.new("Frame")
    colorPickerFrame.Name = label
    colorPickerFrame.Parent = container.Content
    colorPickerFrame.BackgroundTransparency = 1
    colorPickerFrame.Size = UDim2.new(1, 0, 0, 50)
    colorPickerFrame.LayoutOrder = #container.Controls + 1
    
    local colorPickerLabel = Instance.new("TextLabel")
    colorPickerLabel.Name = "Label"
    colorPickerLabel.Parent = colorPickerFrame
    colorPickerLabel.BackgroundTransparency = 1
    colorPickerLabel.Size = UDim2.new(1, -60, 0, 20)
    colorPickerLabel.Position = UDim2.new(0, 0, 0, 0)
    colorPickerLabel.Font = Enum.Font.Gotham
    colorPickerLabel.Text = label
    colorPickerLabel.TextColor3 = UI.Colors.Text
    colorPickerLabel.TextSize = 13
    colorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local colorPickerButton = Instance.new("TextButton")
    colorPickerButton.Name = "Button"
    colorPickerButton.Parent = colorPickerFrame
    colorPickerButton.BackgroundColor3 = defaultValue or Color3.fromRGB(255, 255, 255)
    colorPickerButton.BorderSizePixel = 0
    colorPickerButton.Size = UDim2.new(0, 50, 0, 25)
    colorPickerButton.Position = UDim2.new(1, -55, 0, 25)
    colorPickerButton.Text = ""
    
    local colorPickerCorner = Instance.new("UICorner")
    colorPickerCorner.CornerRadius = UDim.new(0, 4)
    colorPickerCorner.Parent = colorPickerButton
    
    local colorPickerStroke = Instance.new("UIStroke")
    colorPickerStroke.Parent = colorPickerButton
    colorPickerStroke.Color = UI.Colors.Border
    colorPickerStroke.Thickness = 1
    
    -- Simple color picker (you can enhance this)
    colorPickerButton.MouseButton1Click:Connect(function()
        -- For now, just cycle through some colors
        -- In a full implementation, you'd create a proper color picker UI
        local colors = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(98, 0, 67)
        }
        local currentIndex = 1
        for i, color in ipairs(colors) do
            if color == colorPickerButton.BackgroundColor3 then
                currentIndex = i
                break
            end
        end
        local nextColor = colors[(currentIndex % #colors) + 1]
        colorPickerButton.BackgroundColor3 = nextColor
        if callback then callback(nextColor, transparency or 0) end
    end)
    
    table.insert(container.Controls, colorPickerFrame)
    
    return colorPickerFrame
end

-- Button
function UI:Button(tabName, containerName, label, callback)
    local container = self:GetContainer(tabName, containerName)
    if not container then return end
    
    local button = Instance.new("TextButton")
    button.Name = label
    button.Parent = container.Content
    button.BackgroundColor3 = UI.Colors.Accent
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 0, 35)
    button.LayoutOrder = #container.Controls + 1
    button.Font = Enum.Font.GothamBold
    button.Text = label
    button.TextColor3 = UI.Colors.Text
    button.TextSize = 13
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(118, 0, 80)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = UI.Colors.Accent
    end)
    
    table.insert(container.Controls, button)
    
    return button
end

-- Hotkey
function UI:Hotkey(tabName, containerName, label, defaultKey, callback)
    local container = self:GetContainer(tabName, containerName)
    if not container then return end
    
    local hotkeyFrame = Instance.new("Frame")
    hotkeyFrame.Name = label
    hotkeyFrame.Parent = container.Content
    hotkeyFrame.BackgroundTransparency = 1
    hotkeyFrame.Size = UDim2.new(1, 0, 0, 50)
    hotkeyFrame.LayoutOrder = #container.Controls + 1
    
    local hotkeyLabel = Instance.new("TextLabel")
    hotkeyLabel.Name = "Label"
    hotkeyLabel.Parent = hotkeyFrame
    hotkeyLabel.BackgroundTransparency = 1
    hotkeyLabel.Size = UDim2.new(1, -100, 0, 20)
    hotkeyLabel.Position = UDim2.new(0, 0, 0, 0)
    hotkeyLabel.Font = Enum.Font.Gotham
    hotkeyLabel.Text = label
    hotkeyLabel.TextColor3 = UI.Colors.Text
    hotkeyLabel.TextSize = 13
    hotkeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local hotkeyButton = Instance.new("TextButton")
    hotkeyButton.Name = "Button"
    hotkeyButton.Parent = hotkeyFrame
    hotkeyButton.BackgroundColor3 = UI.Colors.Background
    hotkeyButton.BorderSizePixel = 0
    hotkeyButton.Size = UDim2.new(0, 90, 0, 25)
    hotkeyButton.Position = UDim2.new(1, -95, 0, 25)
    hotkeyButton.Font = Enum.Font.Gotham
    hotkeyButton.Text = defaultKey and defaultKey.Name or "None"
    hotkeyButton.TextColor3 = UI.Colors.Text
    hotkeyButton.TextSize = 12
    
    local hotkeyCorner = Instance.new("UICorner")
    hotkeyCorner.CornerRadius = UDim.new(0, 4)
    hotkeyCorner.Parent = hotkeyButton
    
    local hotkeyStroke = Instance.new("UIStroke")
    hotkeyStroke.Parent = hotkeyButton
    hotkeyStroke.Color = UI.Colors.Border
    hotkeyStroke.Thickness = 1
    
    local listening = false
    
    hotkeyButton.MouseButton1Click:Connect(function()
        listening = true
        hotkeyButton.Text = "..."
        hotkeyButton.BackgroundColor3 = UI.Colors.Accent
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and not gameProcessed then
            listening = false
            local key = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
            hotkeyButton.Text = key.Name
            hotkeyButton.BackgroundColor3 = UI.Colors.Background
            if callback then callback(key) end
        end
    end)
    
    table.insert(container.Controls, hotkeyFrame)
    
    return hotkeyFrame
end

-- Notify
function UI:Notify(message, duration)
    duration = duration or 3
    
    local notify = Instance.new("Frame")
    notify.Name = "Notify"
    notify.Parent = self.ScreenGui
    notify.BackgroundColor3 = UI.Colors.Background
    notify.BorderSizePixel = 0
    notify.Size = UDim2.new(0, 300, 0, 60)
    notify.Position = UDim2.new(1, 10, 0, 10 + (#self.Notifications * 70))
    notify.ZIndex = 100
    
    local notifyCorner = Instance.new("UICorner")
    notifyCorner.CornerRadius = UDim.new(0, 6)
    notifyCorner.Parent = notify
    
    local notifyStroke = Instance.new("UIStroke")
    notifyStroke.Parent = notify
    notifyStroke.Color = UI.Colors.Accent
    notifyStroke.Thickness = 2
    
    local notifyLabel = Instance.new("TextLabel")
    notifyLabel.Name = "Label"
    notifyLabel.Parent = notify
    notifyLabel.BackgroundTransparency = 1
    notifyLabel.Size = UDim2.new(1, -20, 1, 0)
    notifyLabel.Position = UDim2.new(0, 10, 0, 0)
    notifyLabel.Font = Enum.Font.Gotham
    notifyLabel.Text = message
    notifyLabel.TextColor3 = UI.Colors.Text
    notifyLabel.TextSize = 13
    notifyLabel.TextWrapped = true
    notifyLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    table.insert(self.Notifications, notify)
    
    -- Animate in
    notify.Position = UDim2.new(1, 310, 0, 10 + ((#self.Notifications - 1) * 70))
    local tweenIn = TweenService:Create(notify, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -310, 0, 10 + ((#self.Notifications - 1) * 70))
    })
    tweenIn:Play()
    
    -- Remove after duration
    task.delay(duration, function()
        local tweenOut = TweenService:Create(notify, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 310, 0, 10 + ((#self.Notifications - 1) * 70))
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notify:Destroy()
            for i, n in ipairs(self.Notifications) do
                if n == notify then
                    table.remove(self.Notifications, i)
                    break
                end
            end
        end)
    end)
end

-- Helper function to get container
function UI:GetContainer(tabName, containerName)
    local tab = self.Tabs[tabName]
    if not tab then return nil end
    
    for _, container in ipairs(tab.Containers) do
        if container.Name == containerName then
            return container
        end
    end
    
    return nil
end

-- Set Title
function UI:SetTitle(title)
    if self.TitleLabel then
        self.TitleLabel.Text = title
    end
end

-- Set Size
function UI:SetSize(width, height)
    self.MainFrame.Size = UDim2.new(0, width, 0, height)
    self.MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
end

-- Init (for compatibility)
function UI:Init()
    -- Already initialized
end

return UI
