# Mobile UI Integration Guide

## Overview
This guide explains how to integrate the mobile UI system into your Psalms.Tech script.

## Integration Steps

1. **Add Mobile UI Wrapper**
   - Include the `mobile_ui_wrapper.lua` file at the beginning of your script
   - Or copy the MobileUISystem code directly into your script

2. **Initialize Mobile UI**
   - After Library is loaded, initialize the mobile UI:
   ```lua
   local MobileUI = require(mobile_ui_wrapper) -- or include the code directly
   MobileUI:Create()
   MobileUI.TabContents = {}
   ```

3. **Create Tabs**
   - Create tabs for Main, Rage, Visuals, Settings
   - Each tab should have its own content frame

4. **Populate Features**
   - Use the MobileUI helper functions to create UI elements:
     - `MobileUI:CreateToggle()` - For toggles
     - `MobileUI:CreateSlider()` - For sliders
     - `MobileUI:CreateTextBox()` - For text inputs
     - `MobileUI:CreateDropdown()` - For dropdowns
     - `MobileUI:CreateButton()` - For buttons
     - `MobileUI:CreateColorPicker()` - For color pickers
     - `MobileUI:CreateSection()` - For organizing sections

5. **Lock Button Functionality**
   - The lock button automatically handles target locking/unlocking
   - It locks both target aim and camera lock when enabled

6. **Toggle UI Button**
   - The toggle button shows/hides the entire UI
   - Useful for mobile devices

## Features Included

### Mobile-Optimized UI
- ✅ Draggable interface (touch-friendly)
- ✅ Lock button for camlock/target aim
- ✅ Toggle UI button to show/hide
- ✅ Tabbed interface for organization
- ✅ All UI elements (toggles, sliders, textboxes, dropdowns, buttons, colorpickers)
- ✅ Touch-optimized controls
- ✅ Responsive layout

### All Original Features Accessible
- Silent/Target Aim
- Camera Lock
- ESP (Box, Skeleton, Chams, Text)
- Hit Detection (Effects, Sounds, Chams)
- CSync
- Prediction Settings
- Checks (KO, Wall, Friend, Team, Vehicle)
- Visuals (Skybox, Fog, Environment)
- Settings (Config, Watermark, Accent)

## Usage Example

```lua
-- After Library is loaded
local MobileUI = MobileUISystem
MobileUI:Create()

-- Create tabs
local tabs = {"Main", "Rage", "Visuals", "Settings"}
for _, tabName in ipairs(tabs) do
    local tabButton = MobileUI:CreateTabButton(tabName, MobileUI.UI.TabsFrame)
    
    local tabContent = Instance.new("Frame")
    tabContent.Name = tabName .. "Content"
    tabContent.Parent = MobileUI.UI.ContentFrame
    tabContent.BackgroundTransparency = 1
    tabContent.Size = UDim2.new(1, 0, 0, 0)
    tabContent.Visible = tabName == "Main"
    
    MobileUI.TabContents[tabName] = tabContent
    
    tabButton.MouseButton1Click:Connect(function()
        MobileUI:SwitchTab(tabName)
    end)
end

-- Populate Main tab
local mainContent = MobileUI.TabContents["Main"]
local silentSection = MobileUI:CreateSection("Silent/Target", mainContent)
MobileUI:CreateToggle("Enabled", Psalms.Tech.Enabled, function(v) 
    Psalms.Tech.Enabled = v 
end, silentSection)
-- ... add more features
```

## Notes

- The mobile UI is designed specifically for mobile/touch devices
- All controls are touch-optimized with larger hitboxes
- The UI is fully draggable by touching the title bar
- Lock button provides quick access to lock/unlock targets
- Toggle button allows hiding the UI when not needed
