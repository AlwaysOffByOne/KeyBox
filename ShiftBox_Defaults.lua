-- ShiftBox_Defaults.lua
-- Default settings and constants for ShiftBox addon

local ShiftBoxDefaults = {}

ShiftBoxDefaults.BOX_TEXTURE = "Interface\\ChatFrame\\ChatFrameBackground"

ShiftBoxDefaults.SETTINGS = {
    triggerKey = "SHIFT",
    posX = 0,
    posY = 0,
    width = 200,
    height = 200,
    borderWidth = 2,
    r = 1,
    g = 0,
    b = 0,
    alpha = 0.5,
}

-- UI Element Sizes
ShiftBoxDefaults.UI = {
    editorWidth = 350,
    editorHeight = 360,
    editorScreenMargin = 20,
    editorPreferredOffsetX = 300,
    wideButtonWidth = 140,
    buttonHeight = 25,
    inputWidth = 80,
    inputHeight = 20,
    colorSwatchWidth = 40,
    tabWidth = 80,
    tabHeight = 22,
}

-- Constraints
ShiftBoxDefaults.CONSTRAINTS = {
    minWidth = 50,
    minHeight = 50,
    minBorder = 1,
    maxAlpha = 1,
    minAlpha = 0,
}

function ShiftBoxDefaults.GetDefaultSettings()
    local settings = {}
    for key, value in pairs(ShiftBoxDefaults.SETTINGS) do
        settings[key] = value
    end
    return settings
end

-- Make it global so other modules can access it
_G.ShiftBoxDefaults = ShiftBoxDefaults
