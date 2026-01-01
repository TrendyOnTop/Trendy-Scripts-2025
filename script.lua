-- Load Menu Library
local Menu = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/library/refs/heads/main/cuh.txt",true))()

-- Create new Window
local Window = Menu:CreateWindow({
    Name = "New UI",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Please wait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NewUIConfig",
        FileName = "config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
    Key = "",
    MaxKeys = 50
})

-- Create Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Create Sections
local ButtonSection = MainTab:CreateSection("Buttons")
local ToggleSection = MainTab:CreateSection("Toggles")
local SliderSection = MainTab:CreateSection("Sliders")
local TextboxSection = MainTab:CreateSection("Textboxes")

-- Buttons
local Button1 = ButtonSection:CreateButton({
    Name = "Button 1",
    Callback = function()
        print("Button 1 clicked!")
    end
})

local Button2 = ButtonSection:CreateButton({
    Name = "Button 2",
    Callback = function()
        print("Button 2 clicked!")
    end
})

local Button3 = ButtonSection:CreateButton({
    Name = "Button 3",
    Callback = function()
        print("Button 3 clicked!")
    end
})

-- Toggles
local Toggle1 = ToggleSection:CreateToggle({
    Name = "Toggle 1",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        print("Toggle 1:", Value)
    end
})

local Toggle2 = ToggleSection:CreateToggle({
    Name = "Toggle 2",
    CurrentValue = false,
    Flag = "Toggle2",
    Callback = function(Value)
        print("Toggle 2:", Value)
    end
})

local Toggle3 = ToggleSection:CreateToggle({
    Name = "Toggle 3",
    CurrentValue = true,
    Flag = "Toggle3",
    Callback = function(Value)
        print("Toggle 3:", Value)
    end
})

-- Sliders
local Slider1 = SliderSection:CreateSlider({
    Name = "Slider 1",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "Slider1",
    Callback = function(Value)
        print("Slider 1:", Value)
    end
})

local Slider2 = SliderSection:CreateSlider({
    Name = "Slider 2",
    Range = {0, 1000},
    Increment = 10,
    Suffix = "",
    CurrentValue = 500,
    Flag = "Slider2",
    Callback = function(Value)
        print("Slider 2:", Value)
    end
})

local Slider3 = SliderSection:CreateSlider({
    Name = "Slider 3",
    Range = {1, 10},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 5,
    Flag = "Slider3",
    Callback = function(Value)
        print("Slider 3:", Value)
    end
})

-- Textboxes
local Textbox1 = TextboxSection:CreateInput({
    Name = "Textbox 1",
    PlaceholderText = "Enter text here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        print("Textbox 1:", Text)
    end
})

local Textbox2 = TextboxSection:CreateInput({
    Name = "Textbox 2",
    PlaceholderText = "Enter number...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        print("Textbox 2:", Text)
    end
})

local Textbox3 = TextboxSection:CreateInput({
    Name = "Textbox 3",
    PlaceholderText = "Enter command...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        print("Textbox 3:", Text)
    end
})

-- Create Additional Tab for More Features
local SettingsTab = Window:CreateTab("Settings", 4483362458)

local SettingsSection = SettingsTab:CreateSection("Settings")

local SettingsToggle = SettingsSection:CreateToggle({
    Name = "Enable Settings",
    CurrentValue = false,
    Flag = "SettingsToggle",
    Callback = function(Value)
        print("Settings enabled:", Value)
    end
})

local SettingsSlider = SettingsSection:CreateSlider({
    Name = "Settings Value",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 0,
    Flag = "SettingsSlider",
    Callback = function(Value)
        print("Settings value:", Value)
    end
})

-- Note: Original UI code has been removed
-- All source code is preserved above with the new UI implementation
