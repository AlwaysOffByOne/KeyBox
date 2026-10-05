-- ShiftBox_Utils.lua
-- Utility and helper functions for ShiftBox addon

local ShiftBoxUtils = {}

local function CopySettings(source)
    local copy = {}
    for key, value in pairs(source or {}) do
        copy[key] = value
    end
    return copy
end

local function MergeSettings(base, overrides)
    local merged = CopySettings(base)
    for key, value in pairs(overrides or {}) do
        merged[key] = value
    end
    return merged
end

local function MigrateLegacySettings()
    if ShiftBoxSettings then
        if not ShiftBoxAccountSettings then
            ShiftBoxAccountSettings = CopySettings(ShiftBoxSettings)
        end
        ShiftBoxSettings = nil
    end
end

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

function ShiftBoxUtils.ReplaceSettings(target, source)
    for key in pairs(target) do
        target[key] = nil
    end
    for key, value in pairs(source) do
        target[key] = value
    end
end

function ShiftBoxUtils.LoadAccountSettings(defaultSettings)
    MigrateLegacySettings()
    return MergeSettings(defaultSettings, ShiftBoxAccountSettings)
end

function ShiftBoxUtils.LoadSettings(defaultSettings)
    local accountSettings = ShiftBoxUtils.LoadAccountSettings(defaultSettings)
    return MergeSettings(accountSettings, ShiftBoxCharacterSettings)
end

function ShiftBoxUtils.SaveCharacterSettings(settings)
    ShiftBoxCharacterSettings = CopySettings(settings)
end

function ShiftBoxUtils.SaveAccountSettings(settings)
    ShiftBoxAccountSettings = CopySettings(settings)
end

function ShiftBoxUtils.ClearCharacterSettings()
    ShiftBoxCharacterSettings = nil
end

function ShiftBoxUtils.ClearAccountSettings()
    ShiftBoxAccountSettings = nil
    ShiftBoxSettings = nil
end

-- Make it global so other modules can access it
_G.ShiftBoxUtils = ShiftBoxUtils
