-- KeyBox_Settings.lua
-- Layered account and character settings persistence

local KeyBoxSettingsManager = {}

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

function KeyBoxSettingsManager.Copy(settings)
    return CopySettings(settings)
end

function KeyBoxSettingsManager.Replace(target, source)
    for key in pairs(target) do
        target[key] = nil
    end
    for key, value in pairs(source) do
        target[key] = value
    end
end

function KeyBoxSettingsManager.LoadAccount(baseSettings)
    return MergeSettings(baseSettings, KeyBoxAccountSettings)
end

function KeyBoxSettingsManager.Load(baseSettings)
    return MergeSettings(KeyBoxSettingsManager.LoadAccount(baseSettings), KeyBoxCharacterSettings)
end

function KeyBoxSettingsManager.SaveCharacter(settings)
    KeyBoxCharacterSettings = CopySettings(settings)
end

function KeyBoxSettingsManager.SaveAccount(settings)
    KeyBoxAccountSettings = CopySettings(settings)
end

function KeyBoxSettingsManager.ClearCharacter()
    KeyBoxCharacterSettings = nil
end

function KeyBoxSettingsManager.ClearAccount()
    KeyBoxAccountSettings = nil
end

_G.KeyBoxSettingsManager = KeyBoxSettingsManager
