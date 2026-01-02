# Custom UI Integration Guide

## What's New
- ✅ Completely custom UI built from scratch
- ✅ Draggable main window (drag by title bar)
- ✅ Draggable toggle button (top-right image button)
- ✅ Draggable lock button (center screen button)
- ✅ Modern, clean design with rounded corners
- ✅ Smooth animations and transitions
- ✅ Compatible with your existing Menu API calls

## How to Use

### Option 1: Replace Menu Loading Line
In your script, replace this line:
```lua
local Menu = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/library/refs/heads/main/cuh.txt",true))()
```

With:
```lua
local Menu = loadstring(readfile("custom_ui_module.lua"))()
```

Or if you want to keep it remote:
```lua
local Menu = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL_TO_custom_ui_module.lua", true))()
```

### Option 2: Direct Integration
Copy the entire contents of `custom_ui_module.lua` and paste it at the beginning of your script, replacing the Menu loading line.

## Features

### Draggable Elements
1. **Main Window**: Click and drag the title bar to move the window
2. **Toggle Button**: Click and drag the image button (top-right) to reposition it
3. **Lock Button**: Click and drag the "Lock: OFF/ON" button to move it anywhere

### UI Components
- **Tabs**: Main, HvH, Visuals, Misc
- **Sections**: Left/Right containers for organizing controls
- **Checkboxes**: Toggle switches with visual feedback
- **Sliders**: Drag to adjust values
- **Text Boxes**: Input fields for text/number values
- **Combo Boxes**: Dropdown menus
- **Color Pickers**: Click to cycle through preset colors
- **Buttons**: Action buttons

### API Compatibility
The Menu API is fully compatible with your existing code:
- `Menu:Tab("TabName")`
- `Menu:Container("Tab", "Section", "Left/Right")`
- `Menu:CheckBox(...)`
- `Menu:Slider(...)`
- `Menu:TextBox(...)`
- `Menu:ComboBox(...)`
- `Menu:ColorPicker(...)`
- `Menu:Button(...)`
- `Menu:Notify("Message", duration)`
- `Menu:SetVisible(true/false)`
- `Menu:SetSize(width, height)`
- `Menu:SetTitle("Title")`
- `Menu:Init()`

## Lock Button Integration

The lock button is already created and draggable. To integrate it with your target system:

```lua
-- Lock Button Functionality (already in your script)
local TargBindEnabled = true
local TargetPlr = nil

local function toggle_lock()
    if TargetAimbot.Enabled then
        if TargBindEnabled and TargetPlr then
            TargBindEnabled = false
            TargetPlr = nil
            LockButton.Text = "Lock: OFF"
            LockButton.TextColor3 = Theme.Error
            Menu.Notify("Untargeted", 2)
        else
            TargBindEnabled = true
            -- Your target selection logic here
            LockButton.Text = "Lock: ON"
            LockButton.TextColor3 = Theme.Success
            Menu.Notify("Target Locked", 2)
        end
    end
end

LockButton.MouseButton1Click:Connect(toggle_lock)
```

## Customization

### Change Theme Colors
Edit the `Theme` table at the top of `custom_ui_module.lua`:
```lua
local Theme = {
    Background = Color3.fromRGB(20, 20, 30),    -- Main background
    Secondary = Color3.fromRGB(30, 30, 45),     -- Secondary elements
    Accent = Color3.fromRGB(98, 0, 67),          -- Accent color (purple)
    Text = Color3.fromRGB(255, 255, 255),        -- Text color
    Border = Color3.fromRGB(40, 40, 60),        -- Border color
    Success = Color3.fromRGB(0, 255, 0),         -- Success/ON color
    Error = Color3.fromRGB(255, 0, 0)            -- Error/OFF color
}
```

### Change Window Size
```lua
MainWindow.Size = UDim2.new(0, 600, 0, 500)  -- Width, Height
```

### Change Initial Positions
```lua
-- Main Window
MainWindow.Position = UDim2.new(0.5, -300, 0.5, -250)  -- Center screen

-- Toggle Button
ToggleUI.Position = UDim2.new(1, -95, 0, 5)  -- Top-right

-- Lock Button
LockButton.Position = UDim2.new(0.5, -75, 0.5, -25)  -- Center screen
```

## Notes
- All UI elements are parented to `game.CoreGui` so they persist across character respawns
- The UI uses modern Roblox UI elements (UICorner, UIStroke, etc.)
- All draggable elements work with both mouse and touch input
- The UI is fully responsive and scrollable
