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

-- Make it global so other modules can access it
_G.ShiftBoxUtils = ShiftBoxUtils
