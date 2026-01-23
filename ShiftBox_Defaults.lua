-- ShiftBox_Defaults.lua
-- Default settings and constants for ShiftBox addon

local ShiftBoxDefaults = {}

-- Default box settings
ShiftBoxDefaults.BOX = {
    posX = 0,
    posY = 0,
    width = 200,
    height = 200,
    borderWidth = 2,
}

-- Default color settings (Red)
ShiftBoxDefaults.COLOR = {
    r = 1,
    g = 0,
    b = 0,
    alpha = 0.5,
}

-- Preset colors for the editor
ShiftBoxDefaults.PRESET_COLORS = {
    { name = "Red", r = 1, g = 0, b = 0 },
    { name = "Green", r = 0, g = 1, b = 0 },
    { name = "Blue", r = 0, g = 0, b = 1 },
    { name = "Yellow", r = 1, g = 1, b = 0 },
    { name = "Purple", r = 1, g = 0, b = 1 },
    { name = "Cyan", r = 0, g = 1, b = 1 },
    { name = "White", r = 1, g = 1, b = 1 },
    { name = "Orange", r = 1, g = 0.5, b = 0 },
    { name = "Pink", r = 1, g = 0.75, b = 0.8 },
    { name = "Gray", r = 0.5, g = 0.5, b = 0.5 },
}

-- UI Element Sizes
ShiftBoxDefaults.UI = {
    editorWidth = 350,
    editorHeight = 360,
    buttonWidth = 80,
    buttonHeight = 25,
    inputWidth = 80,
    inputHeight = 20,
}

-- Constraints
ShiftBoxDefaults.CONSTRAINTS = {
    minWidth = 50,
    minHeight = 50,
    minBorder = 1,
    maxAlpha = 1,
    minAlpha = 0,
    maxColor = 1,
    minColor = 0,
}

-- Combine all defaults into a single settings table
function ShiftBoxDefaults.GetDefaultSettings()
    return {
        posX = ShiftBoxDefaults.BOX.posX,
        posY = ShiftBoxDefaults.BOX.posY,
        width = ShiftBoxDefaults.BOX.width,
        height = ShiftBoxDefaults.BOX.height,
        borderWidth = ShiftBoxDefaults.BOX.borderWidth,
        r = ShiftBoxDefaults.COLOR.r,
        g = ShiftBoxDefaults.COLOR.g,
        b = ShiftBoxDefaults.COLOR.b,
        alpha = ShiftBoxDefaults.COLOR.alpha,
    }
end

-- Make it global so other modules can access it
_G.ShiftBoxDefaults = ShiftBoxDefaults
