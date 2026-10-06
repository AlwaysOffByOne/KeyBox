-- KeyBox_Input.lua
-- Keyboard input tracking and trigger-key capture

local _, KeyBox = ...
local L = KeyBox.L
local KeyBoxInput = {}

local MODIFIER_KEYS = {
    LSHIFT = "SHIFT",
    RSHIFT = "SHIFT",
    LCTRL = "CTRL",
    RCTRL = "CTRL",
    LALT = "ALT",
    RALT = "ALT",
}

local MODIFIER_DISPLAY_NAMES = {
    SHIFT = L.KEY_SHIFT,
    CTRL = L.KEY_CTRL,
    ALT = L.KEY_ALT,
}

local captureCallback

local listener = CreateFrame("Frame")
listener:SetFrameStrata("DIALOG")
listener:EnableKeyboard(false)
listener:SetPropagateKeyboardInput(true)

local function NormalizeKey(key)
    if type(key) ~= "string" then
        return nil
    end
    return MODIFIER_KEYS[key] or key
end

listener:SetScript("OnKeyDown", function(self, key)
    if captureCallback then
        local callback = captureCallback
        captureCallback = nil
        self:EnableKeyboard(false)
        if key == "ESCAPE" then
            callback(nil)
        else
            callback(NormalizeKey(key))
        end
    end
end)

function KeyBoxInput.IsTriggerDown(triggerKey)
    local normalizedTrigger = NormalizeKey(triggerKey)
    if not normalizedTrigger then
        return false
    end

    if normalizedTrigger == "SHIFT" then
        return IsShiftKeyDown()
    elseif normalizedTrigger == "CTRL" then
        return IsControlKeyDown()
    elseif normalizedTrigger == "ALT" then
        return IsAltKeyDown()
    end

    return IsKeyDown(normalizedTrigger, true) or false
end

function KeyBoxInput.CaptureNextKey(callback)
    captureCallback = callback
    listener:EnableKeyboard(true)
end

function KeyBoxInput.CancelCapture()
    captureCallback = nil
    listener:EnableKeyboard(false)
end

function KeyBoxInput.GetKeyDisplayName(key)
    local normalizedKey = NormalizeKey(key)
    if not normalizedKey then
        return L.NOT_SET
    end

    if MODIFIER_DISPLAY_NAMES[normalizedKey] then
        return MODIFIER_DISPLAY_NAMES[normalizedKey]
    end

    local displayName = GetBindingText(normalizedKey, "KEY_", false)
    if displayName and displayName ~= "" then
        return displayName
    end
    return normalizedKey
end

_G.KeyBoxInput = KeyBoxInput
