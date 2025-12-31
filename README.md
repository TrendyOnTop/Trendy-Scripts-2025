# Trendy-Scripts-2025

## Camera Lock Script

A comprehensive Roblox camera lock system with advanced features.

### Features:
- ✅ Smooth camera locking onto target's HumanoidRootPart
- ✅ Customizable smoothness and prediction values for X and Y axes
- ✅ Moving gradient FOV circle visualization
- ✅ CFrameWalkSpeed movement with pathfinding to target
- ✅ Random automatic jumping
- ✅ Toggle button for easy enable/disable
- ✅ Fully customizable settings UI with scroll
- ✅ Auto reload (presses R key every 2.3 seconds)
- ✅ Auto stop shooting when target is under 10 HP
- ✅ Auto lock back onto target when they are over 10 HP

### Usage:
1. Copy the contents of `CameraLock.lua`
2. Execute it in your Roblox executor
3. Use the UI that appears in the top-left corner to configure settings
4. Click the toggle button to enable/disable the camera lock

### Settings:
- **Smoothness X/Y**: Controls how smoothly the camera moves horizontally/vertically (0.01-1.0)
- **Prediction X/Y**: Predicts target movement for better tracking (0-2.0)
- **FOV**: Field of view circle size (50-200)
- **Walk Speed**: Movement speed towards target (0-50)
- **Jump Probability**: Chance of jumping per frame (0-0.1)
- **Auto Reload Interval**: Time between auto reloads in seconds (1-5)
- **Auto Stop Shooting HP**: Health threshold to stop shooting (0-100)
- **Auto Reload**: Toggle auto reload feature
- **Show FOV Circle**: Toggle FOV circle visualization

### Notes:
- The script automatically handles character respawning
- Input simulation methods may need adjustment based on your executor
- The FOV circle uses a gradient effect that rotates continuously
- Pathfinding updates every second for optimal performance
