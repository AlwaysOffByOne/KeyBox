-- ShiftBox Addon - Main File
-- A simple addon that displays a box when you press Shift

local addonName = ...

-- Settings will be loaded from defaults when addon loads
local DEFAULT_SETTINGS = ShiftBoxDefaults.GetDefaultSettings()

-- Settings will be loaded when addon loads
local settings

-- Create the main frame for the addon
local ShiftBoxFrame = CreateFrame("Frame", "ShiftBoxMainFrame", UIParent)
ShiftBoxFrame:RegisterEvent("ADDON_LOADED")

local box = ShiftBoxBox.Create(DEFAULT_SETTINGS)

-- Track if Shift is currently pressed
local isShiftPressed = false
local debugEnabled = false

-- Function to show the editor panel
local function ShowEditorPanel()
    box:Show()
    ShiftBoxEdit.ShowEditorPanel(box, settings, DEFAULT_SETTINGS)
end

-- Function to toggle debug mode
local function ToggleDebugMode()
    debugEnabled = not debugEnabled
    if debugEnabled then
        ShiftBoxUtils.Print("Debug mode ENABLED", "|cff00FF00")
    else
        ShiftBoxUtils.Print("Debug mode DISABLED")
    end
end

-- ShiftBox command handler
SLASH_SHIFTBOX1 = "/shiftbox"
SlashCmdList["SHIFTBOX"] = function(msg)
    local parts = {}
    for part in msg:gmatch("%S+") do
        table.insert(parts, part)
    end
    local command = parts[1] or "edit"

    if command == "edit" then
        ShowEditorPanel()
    elseif command == "debug" then
        ToggleDebugMode()
    elseif command == "help" then
        ShiftBoxUtils.Print("Commands:")
        ShiftBoxUtils.Print("/shiftbox - Open the editor panel")
        ShiftBoxUtils.Print("/shiftbox edit - Open the editor panel (size, border, color, position)")
        ShiftBoxUtils.Print("/shiftbox debug - Toggle debug messages")
        ShiftBoxUtils.Print("/shiftbox help - Show this message")
    else
        ShiftBoxUtils.Print("Unknown command. Use /shiftbox help")
    end
end

-- Addon load/save events
ShiftBoxFrame:SetScript("OnEvent", function(self, event, arg1)
    ShiftBoxUtils.DebugPrint("Event triggered: " .. tostring(event) .. " (addonName: " .. tostring(addonName) .. ")", debugEnabled)
    
    if event == "ADDON_LOADED" and arg1 == addonName then
        -- Load settings after addon is loaded
        settings = ShiftBoxSettingsManager.Load(DEFAULT_SETTINGS)
        ShiftBoxUtils.DebugPrint("ShiftBox addon successfully loaded!", debugEnabled)
        ShiftBoxBox.ApplySettings(box, settings)
        ShiftBoxUtils.Print("Addon loaded! Use |cff00FF00/shiftbox help|r for commands.")
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

-- Create a frame to listen for key press/release events
local keyListener = CreateFrame("Frame")
keyListener:SetScript("OnUpdate", function(self)
    if not settings then
        return
    end

    local shiftPressed = IsShiftKeyDown()
    if shiftPressed ~= isShiftPressed then
        local message = shiftPressed
            and "Shift pressed! Showing box. Width: " .. settings.width .. ", Height: " .. settings.height
            or "Shift released! Hiding box."
        ShiftBoxUtils.DebugPrint(message, debugEnabled)
        isShiftPressed = shiftPressed
    end

    local shouldShow = shiftPressed or ShiftBoxEdit.IsEditorOpen()
    if shouldShow ~= box:IsShown() then
        if shouldShow then
            box:Show()
        else
            box:Hide()
        end
    end
end)