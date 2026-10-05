-- ShiftBox_Settings.lua
-- Layered account and character settings persistence

local ShiftBoxSettingsManager = {}

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

function ShiftBoxSettingsManager.Copy(settings)
    return CopySettings(settings)
end

function ShiftBoxSettingsManager.Replace(target, source)
    for key in pairs(target) do
        target[key] = nil
    end
    for key, value in pairs(source) do
        target[key] = value
    end
end

function ShiftBoxSettingsManager.LoadAccount(baseSettings)
    return MergeSettings(baseSettings, ShiftBoxAccountSettings)
end

function ShiftBoxSettingsManager.Load(baseSettings)
    return MergeSettings(ShiftBoxSettingsManager.LoadAccount(baseSettings), ShiftBoxCharacterSettings)
end

function ShiftBoxSettingsManager.SaveCharacter(settings)
    ShiftBoxCharacterSettings = CopySettings(settings)
end

function ShiftBoxSettingsManager.SaveAccount(settings)
    ShiftBoxAccountSettings = CopySettings(settings)
end

function ShiftBoxSettingsManager.ClearCharacter()
    ShiftBoxCharacterSettings = nil
end

function ShiftBoxSettingsManager.ClearAccount()
    ShiftBoxAccountSettings = nil
end

_G.ShiftBoxSettingsManager = ShiftBoxSettingsManager
