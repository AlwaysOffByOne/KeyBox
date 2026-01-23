-- ShiftBox Addon - Main File
-- A simple addon that displays a box when you press Shift

local addonName, addon = ...

-- Default settings
local DEFAULT_SETTINGS = {
    posX = 0,
    posY = 0,
    width = 200,
    height = 200,
    r = 1,
    g = 0,
    b = 0,
    alpha = 0.5,
    borderWidth = 2,
}

-- Settings will be loaded when addon loads
local settings

-- Create the main frame for the addon
local ShiftBoxFrame = CreateFrame("Frame", "ShiftBoxMainFrame", UIParent)
ShiftBoxFrame:RegisterEvent("ADDON_LOADED")
ShiftBoxFrame:RegisterEvent("PLAYER_LOGOUT")

-- Create the box that will appear/disappear
local box = CreateFrame("Frame", "ShiftBox", UIParent)
box:SetMovable(true)
box:SetSize(DEFAULT_SETTINGS.width, DEFAULT_SETTINGS.height)
box:SetPoint("CENTER", UIParent, "CENTER", DEFAULT_SETTINGS.posX, DEFAULT_SETTINGS.posY)
box:Hide()

-- Create the box texture/background
local bg = box:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(box)
bg:SetColorTexture(0, 0, 0, 0)  -- Fully transparent

-- Create a yellow dotted border using frame borders
local border = box:CreateTexture(nil, "BORDER")
border:SetAllPoints(box)
border:SetColorTexture(1, 1, 0, 0)  -- Yellow but fully transparent base

-- Create visible yellow borders using thin frames
local borderWidth = DEFAULT_SETTINGS.borderWidth

-- Top border
local topBorder = CreateFrame("Frame", nil, box)
topBorder:SetPoint("TOPLEFT", box, "TOPLEFT", 0, 0)
topBorder:SetPoint("TOPRIGHT", box, "TOPRIGHT", 0, 0)
topBorder:SetHeight(borderWidth)
local topTexture = topBorder:CreateTexture(nil, "OVERLAY")
topTexture:SetAllPoints(topBorder)
topTexture:SetColorTexture(1, 1, 0, 1)  -- Yellow

-- Bottom border
local bottomBorder = CreateFrame("Frame", nil, box)
bottomBorder:SetPoint("BOTTOMLEFT", box, "BOTTOMLEFT", 0, 0)
bottomBorder:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", 0, 0)
bottomBorder:SetHeight(borderWidth)
local bottomTexture = bottomBorder:CreateTexture(nil, "OVERLAY")
bottomTexture:SetAllPoints(bottomBorder)
bottomTexture:SetColorTexture(1, 1, 0, 1)  -- Yellow

-- Left border
local leftBorder = CreateFrame("Frame", nil, box)
leftBorder:SetPoint("TOPLEFT", box, "TOPLEFT", 0, 0)
leftBorder:SetPoint("BOTTOMLEFT", box, "BOTTOMLEFT", 0, 0)
leftBorder:SetWidth(borderWidth)
local leftTexture = leftBorder:CreateTexture(nil, "OVERLAY")
leftTexture:SetAllPoints(leftBorder)
leftTexture:SetColorTexture(1, 1, 0, 1)  -- Yellow

-- Right border
local rightBorder = CreateFrame("Frame", nil, box)
rightBorder:SetPoint("TOPRIGHT", box, "TOPRIGHT", 0, 0)
rightBorder:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", 0, 0)
rightBorder:SetWidth(borderWidth)
local rightTexture = rightBorder:CreateTexture(nil, "OVERLAY")
rightTexture:SetAllPoints(rightBorder)
rightTexture:SetColorTexture(1, 1, 0, 1)  -- Yellow

-- Edit mode overlay (semi-transparent for dragging)
local editOverlay = box:CreateTexture(nil, "OVERLAY")
editOverlay:SetAllPoints(box)
editOverlay:SetColorTexture(1, 1, 1, 0.1)
editOverlay:Hide()

-- Create a resize handle in the bottom-right corner
local resizeHandle = CreateFrame("Frame", "ShiftBoxResizeHandle", box)
resizeHandle:SetSize(20, 20)
resizeHandle:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", 0, 0)
resizeHandle:Hide()
resizeHandle:SetMovable(true)

local handleTexture = resizeHandle:CreateTexture(nil, "OVERLAY")
handleTexture:SetAllPoints(resizeHandle)
handleTexture:SetColorTexture(1, 1, 1, 0.7)

-- Store all textures and borders in a table for easy reference
local textures = {
    bg = bg,
    topTexture = topTexture,
    bottomTexture = bottomTexture,
    leftTexture = leftTexture,
    rightTexture = rightTexture,
    topBorder = topBorder,
    bottomBorder = bottomBorder,
    leftBorder = leftBorder,
    rightBorder = rightBorder,
}

-- Track if Shift is currently pressed
local isShiftPressed = false
local editMode = false
local isResizing = false
local debugEnabled = false
local editorOpen = false

-- Function to update box visuals (includes position, size, and color)
local function UpdateBoxVisuals()
    ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
    box:SetPoint("CENTER", UIParent, "CENTER", settings.posX, settings.posY)
end

-- Function to show the editor panel
local function ShowEditorPanel()
    box:Show()
    ShiftBoxEdit.ShowEditorPanel(box, settings, textures, DEFAULT_SETTINGS)
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
    if msg == "" or msg == "edit" then
        ShowEditorPanel()
    elseif msg == "debug" then
        ToggleDebugMode()
    elseif msg:sub(1, 5) == "color" then
        local parts = {}
        for part in msg:gmatch("%S+") do
            table.insert(parts, part)
        end
        if #parts >= 4 then
            ShiftBoxEdit.SetBoxColor(settings, tonumber(parts[2]), tonumber(parts[3]), tonumber(parts[4]), tonumber(parts[5]) or settings.alpha, textures, box)
        else
            ShiftBoxUtils.Print("Usage: /shiftbox color <r> <g> <b> [alpha]")
            ShiftBoxUtils.Print("Example: /shiftbox color 0.5 1 0 0.7  (Green with 70% alpha)")
        end
    elseif msg == "help" then
        ShiftBoxUtils.Print("Commands:")
        ShiftBoxUtils.Print("/shiftbox edit - Open the editor panel (size, border, color, position)")
        ShiftBoxUtils.Print("/shiftbox color <r> <g> <b> [alpha] - Set box color via command (values 0-1)")
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
        settings = ShiftBoxUtils.LoadSettings(DEFAULT_SETTINGS)
        ShiftBoxUtils.DebugPrint("ShiftBox addon successfully loaded!", debugEnabled)
        UpdateBoxVisuals()
        ShiftBoxUtils.Print("Addon loaded! Use |cff00FF00/shiftbox help|r for commands.")
    elseif event == "PLAYER_LOGOUT" then
        ShiftBoxUtils.SaveSettings(settings)
    end
end)

-- Create a frame to listen for key press/release events
local keyListener = CreateFrame("Frame")
keyListener:SetScript("OnUpdate", function(self)
    -- Check if editor is open using global flag
    editorOpen = _G.ShiftBoxEditorOpen or false
    
    if not editorOpen and not editMode then  -- Only toggle box visibility if not in edit mode or editor
        local shiftPressed = IsShiftKeyDown()
        
        if shiftPressed and not isShiftPressed then
            -- Shift was just pressed
            isShiftPressed = true
            ShiftBoxUtils.DebugPrint("Shift pressed! Showing box. Width: " .. settings.width .. ", Height: " .. settings.height, debugEnabled)
            box:Show()
        elseif not shiftPressed and isShiftPressed then
            -- Shift was just released
            isShiftPressed = false
            ShiftBoxUtils.DebugPrint("Shift released! Hiding box.", debugEnabled)
            box:Hide()
        end
    end
end)