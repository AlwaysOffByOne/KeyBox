-- KeyBox_Utils.lua
-- Utility and helper functions for KeyBox addon

local KeyBoxUtils = {}

function KeyBoxUtils.Clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

-- Print a formatted message with KeyBox prefix
function KeyBoxUtils.Print(msg, color)
    color = color or "|cffFFFF00"  -- Default yellow
    print(color .. "[KeyBox]|r " .. msg)
end

-- Make it global so other modules can access it
_G.KeyBoxUtils = KeyBoxUtils
