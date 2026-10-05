-- ShiftBox_Utils.lua
-- Utility and helper functions for ShiftBox addon

local ShiftBoxUtils = {}

function ShiftBoxUtils.Clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

-- Print a formatted message with ShiftBox prefix
function ShiftBoxUtils.Print(msg, color)
    color = color or "|cffFFFF00"  -- Default yellow
    print(color .. "[ShiftBox]|r " .. msg)
end

-- Print a debug message if debug mode is enabled
function ShiftBoxUtils.DebugPrint(msg, debugEnabled)
    if debugEnabled then
        ShiftBoxUtils.Print(msg, "|cff00FF00")
    end
end

-- Make it global so other modules can access it
_G.ShiftBoxUtils = ShiftBoxUtils
