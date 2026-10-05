-- ShiftBox Addon - Main File
-- A simple addon that displays a box while a configured key is pressed

local addonName = ...

-- Settings will be loaded from defaults when addon loads
local DEFAULT_SETTINGS = ShiftBoxDefaults.GetDefaultSettings()

-- Settings will be loaded when addon loads
local settings

-- Create the main frame for the addon
local ShiftBoxFrame = CreateFrame("Frame", "ShiftBoxMainFrame", UIParent)
ShiftBoxFrame:RegisterEvent("ADDON_LOADED")

local box = ShiftBoxBox.Create(DEFAULT_SETTINGS)

-- Function to show the editor panel
local function ShowEditorPanel()
    box:Show()
    ShiftBoxEdit.ShowEditorPanel(box, settings, DEFAULT_SETTINGS)
end

SLASH_SHIFTBOX1 = "/shiftbox"
SlashCmdList["SHIFTBOX"] = function()
    ShowEditorPanel()
end

ShiftBoxFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        settings = ShiftBoxSettingsManager.Load(DEFAULT_SETTINGS)
        ShiftBoxBox.ApplySettings(box, settings)
        ShiftBoxUtils.Print("Addon loaded! Use |cff00FF00/shiftbox|r to open the editor.")
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

local visibilityUpdater = CreateFrame("Frame")
visibilityUpdater:SetScript("OnUpdate", function()
    if not settings then
        return
    end

    local triggerPressed = ShiftBoxInput.IsTriggerDown(settings.triggerKey)
    local shouldShow = triggerPressed or ShiftBoxEdit.IsEditorOpen()
    if shouldShow ~= box:IsShown() then
        if shouldShow then
            box:Show()
        else
            box:Hide()
        end
    end
end)