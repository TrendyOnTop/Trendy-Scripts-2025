# Integration Guide - Settings Table Refactor

## Overview
This guide explains how to integrate your original script with the new Settings table system.

## Settings Table Structure

All features are now controlled through `getgenv().Settings` table:

```lua
getgenv().Settings = {
    Silent = { ... },
    HitPart = { ... },
    Prediction = { ... },
    Checks = { ... },
    GunMod = { ... },
    Camera = { ... },
    CSync = { ... },
    PredictionBreaker = { ... },
    HitDetection = { ... },
    HitChams = { ... },
    ESP = { ... },
    TargetVisual = { ... },
    BulletTrails = { ... },
    Crosshair = { ... },
    SilentFOV = { ... },
    Environment = { ... },
    CameraSettings = { ... },
    Dance = { ... },
}
```

## How to Use

### Example: Enable Silent Aim
```lua
getgenv().Settings.Silent.Enabled = true
```

### Example: Change Hit Part
```lua
getgenv().Settings.HitPart.BodyPart = "Head"
```

### Example: Adjust Prediction
```lua
getgenv().Settings.Prediction.Horizontal = 0.15
getgenv().Settings.Prediction.Vertical = 0.15
```

## Integration Points

### 1. Insert Original Code Sections

In `complete_refactored.lua`, you need to insert all original code sections at these locations:

#### After Settings Table Initialization:
- All hit effect modules (Nova, Crescent Slash, Coom, etc.)
- All sound definitions
- All utility functions
- All ESP code
- All visual effects code

#### After Lock Button Creation:
- All target finding functions
- All aimbot logic
- All camera manipulation code
- All prediction calculations
- All hit detection code

### 2. Replace UI References

Wherever the original code references UI elements like:
- `TargetAimSection:Toggle(...)` → Use `getgenv().Settings.Silent.Enabled`
- `PredictionSection:Textbox(...)` → Use `getgenv().Settings.Prediction.Horizontal`
- etc.

### 3. Update Functions

All functions that read settings should use:
```lua
local value = getgenv().Settings.Category.Setting
```

Instead of reading from UI elements.

## Lock Button

The lock button is the ONLY UI element. It toggles target lock on/off.

- Click to lock/unlock target
- Draggable
- Shows locked/unlocked state via icon

## Settings Update Function

The `UpdateSettings()` function runs continuously to sync Settings table with internal variables. All your original code should read from the Settings table or the synced variables.

## Complete Integration Checklist

- [ ] Insert all hit effect modules
- [ ] Insert all sound definitions  
- [ ] Insert all utility functions
- [ ] Insert ESP code
- [ ] Insert visual effects code
- [ ] Insert target finding logic
- [ ] Insert aimbot logic
- [ ] Insert camera code
- [ ] Insert prediction code
- [ ] Insert hit detection code
- [ ] Replace all UI references with Settings table
- [ ] Test all features work via Settings table
- [ ] Verify lock button works

## Notes

- Settings are updated every frame via `RunService.Heartbeat`
- All original functionality is preserved
- Only the UI is removed (except lock button)
- Everything is controlled through Settings table
