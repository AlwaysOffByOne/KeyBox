-- KeyBox Addon - Main File
-- A simple addon that displays a box while a configured key is pressed

local addonName, KeyBox = ...
local L = KeyBox.L

-- Settings will be loaded from defaults when addon loads
local DEFAULT_SETTINGS = KeyBoxDefaults.GetDefaultSettings()

-- Settings will be loaded when addon loads
local settings

-- Create the main frame for the addon
local KeyBoxFrame = CreateFrame("Frame", "KeyBoxMainFrame", UIParent)
KeyBoxFrame:RegisterEvent("ADDON_LOADED")

local box = KeyBoxBox.Create(DEFAULT_SETTINGS)

-- Function to show the editor panel
local function ShowEditorPanel()
    box:Show()
    KeyBoxEdit.ShowEditorPanel(box, settings, DEFAULT_SETTINGS)
end

SLASH_KEYBOX1 = "/keybox"
SlashCmdList["KEYBOX"] = function()
    ShowEditorPanel()
end

KeyBoxFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        settings = KeyBoxSettingsManager.Load(DEFAULT_SETTINGS)
        KeyBoxBox.ApplySettings(box, settings)
        KeyBoxUtils.Print(L.ADDON_LOADED)
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

local visibilityUpdater = CreateFrame("Frame")
visibilityUpdater:SetScript("OnUpdate", function()
    if not settings then
        return
    end

    local triggerPressed = KeyBoxInput.IsTriggerDown(settings.triggerKey)
    local shouldShow = triggerPressed or KeyBoxEdit.IsEditorOpen()
    if shouldShow ~= box:IsShown() then
        if shouldShow then
            box:Show()
        else
            box:Hide()
        end
    end
end)