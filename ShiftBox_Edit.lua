-- ShiftBox_Edit.lua
-- Functions for editing box size, color, and positioning

local ShiftBoxEdit = {}

-- Reference to utilities (loaded globally by ShiftBox_Utils.lua)
-- We'll call ShiftBoxUtils directly to avoid issues with loading order

-- Function to update box visuals
function ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
    textures.bg:SetColorTexture(0, 0, 0, 0)  -- Keep background transparent
    textures.topTexture:SetColorTexture(settings.r, settings.g, settings.b, settings.alpha)
    textures.bottomTexture:SetColorTexture(settings.r, settings.g, settings.b, settings.alpha)
    textures.leftTexture:SetColorTexture(settings.r, settings.g, settings.b, settings.alpha)
    textures.rightTexture:SetColorTexture(settings.r, settings.g, settings.b, settings.alpha)
    box:SetSize(settings.width, settings.height)
    
    -- Update border widths
    if textures.topBorder then
        textures.topBorder:SetHeight(settings.borderWidth)
    end
    if textures.bottomBorder then
        textures.bottomBorder:SetHeight(settings.borderWidth)
    end
    if textures.leftBorder then
        textures.leftBorder:SetWidth(settings.borderWidth)
    end
    if textures.rightBorder then
        textures.rightBorder:SetWidth(settings.borderWidth)
    end
end

-- Function to set box color via command
function ShiftBoxEdit.SetBoxColor(settings, r, g, b, alpha, textures, box)
    settings.r = tonumber(r) or settings.r
    settings.g = tonumber(g) or settings.g
    settings.b = tonumber(b) or settings.b
    settings.alpha = tonumber(alpha) or settings.alpha
    ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
    ShiftBoxUtils.Print(string.format("Color set to R:%.1f G:%.1f B:%.1f A:%.1f", settings.r, settings.g, settings.b, settings.alpha))
end

-- Create comprehensive editor panel with all controls
function ShiftBoxEdit.CreateEditorPanel(box, settings, textures, defaultSettings)
    -- Check if panel already exists
    if ShiftBoxEditorPanel then
        return ShiftBoxEditorPanel
    end
    
    -- Use preset colors from defaults
    local PRESET_COLORS = ShiftBoxDefaults.PRESET_COLORS
    
    -- Create main frame
    local frame = CreateFrame("Frame", "ShiftBoxEditorPanel", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(ShiftBoxDefaults.UI.editorWidth, ShiftBoxDefaults.UI.editorHeight)
    frame:SetPoint("CENTER", UIParent, "CENTER", 300, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    
    frame.TitleBg:SetHeight(25)
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOPLEFT", frame.TitleBg, "TOPLEFT", 8, -3)
    frame.title:SetText("ShiftBox Editor")
    
    local yOffset = -40
    
    -- Width section
    local widthLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    widthLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, yOffset)
    widthLabel:SetText("Width:")
    
    local widthInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    widthInput:SetSize(ShiftBoxDefaults.UI.inputWidth, ShiftBoxDefaults.UI.inputHeight)
    widthInput:SetPoint("LEFT", widthLabel, "RIGHT", 10, 0)
    widthInput:SetText(tostring(settings.width))
    widthInput:SetAutoFocus(false)
    
    yOffset = yOffset - 30
    
    -- Height section
    local heightLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heightLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, yOffset)
    heightLabel:SetText("Height:")
    
    local heightInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    heightInput:SetSize(ShiftBoxDefaults.UI.inputWidth, ShiftBoxDefaults.UI.inputHeight)
    heightInput:SetPoint("LEFT", heightLabel, "RIGHT", 10, 0)
    heightInput:SetText(tostring(settings.height))
    heightInput:SetAutoFocus(false)
    
    yOffset = yOffset - 30
    
    -- Border width section
    local borderLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    borderLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, yOffset)
    borderLabel:SetText("Border:")
    
    local borderInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    borderInput:SetSize(ShiftBoxDefaults.UI.inputWidth, ShiftBoxDefaults.UI.inputHeight)
    borderInput:SetPoint("LEFT", borderLabel, "RIGHT", 10, 0)
    borderInput:SetText(tostring(settings.borderWidth))
    borderInput:SetAutoFocus(false)
    
    yOffset = yOffset - 35
    
    -- Color section
    local colorLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    colorLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, yOffset)
    colorLabel:SetText("Color:")
    
    local colorDropdown = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate")
    colorDropdown:SetPoint("LEFT", colorLabel, "RIGHT", 10, 3)
    
    -- Find current color name
    local currentColorName = "Custom"
    for _, color in ipairs(PRESET_COLORS) do
        if math.abs(color.r - settings.r) < 0.01 and 
           math.abs(color.g - settings.g) < 0.01 and 
           math.abs(color.b - settings.b) < 0.01 then
            currentColorName = color.name
            break
        end
    end
    
    UIDropDownMenu_SetWidth(colorDropdown, 100)
    UIDropDownMenu_SetButtonWidth(colorDropdown, 120)
    UIDropDownMenu_SetText(colorDropdown, currentColorName)
    
    local function SetupColorDropdown()
        local info = UIDropDownMenu_CreateInfo()
        for _, color in ipairs(PRESET_COLORS) do
            info.text = color.name
            info.func = function()
                settings.r = color.r
                settings.g = color.g
                settings.b = color.b
                ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
                UIDropDownMenu_SetText(colorDropdown, color.name)
            end
            UIDropDownMenu_AddButton(info)
        end
    end
    
    colorDropdown.initialize = SetupColorDropdown
    
    yOffset = yOffset - 30
    
    -- Alpha section
    local alphaLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    alphaLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, yOffset)
    alphaLabel:SetText("Alpha:")
    
    local alphaInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    alphaInput:SetSize(ShiftBoxDefaults.UI.inputWidth, ShiftBoxDefaults.UI.inputHeight)
    alphaInput:SetPoint("LEFT", alphaLabel, "RIGHT", 10, 0)
    alphaInput:SetText(string.format("%.2f", settings.alpha))
    alphaInput:SetAutoFocus(false)
    
    -- Update preview on text change
    local function UpdatePreview()
        local w = tonumber(widthInput:GetText()) or settings.width
        local h = tonumber(heightInput:GetText()) or settings.height
        local bw = tonumber(borderInput:GetText()) or settings.borderWidth
        local a = tonumber(alphaInput:GetText()) or settings.alpha
        
        w = math.max(ShiftBoxDefaults.CONSTRAINTS.minWidth, w)
        h = math.max(ShiftBoxDefaults.CONSTRAINTS.minHeight, h)
        bw = math.max(ShiftBoxDefaults.CONSTRAINTS.minBorder, bw)
        a = math.max(ShiftBoxDefaults.CONSTRAINTS.minAlpha, math.min(ShiftBoxDefaults.CONSTRAINTS.maxAlpha, a))
        
        settings.width = w
        settings.height = h
        settings.borderWidth = bw
        settings.alpha = a
        
        ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
    end
    
    widthInput:SetScript("OnTextChanged", UpdatePreview)
    heightInput:SetScript("OnTextChanged", UpdatePreview)
    borderInput:SetScript("OnTextChanged", UpdatePreview)
    alphaInput:SetScript("OnTextChanged", UpdatePreview)
    
    -- Save button
    local saveButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    saveButton:SetSize(ShiftBoxDefaults.UI.buttonWidth, ShiftBoxDefaults.UI.buttonHeight)
    saveButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 15, 10)
    saveButton:SetText("Save")
    saveButton:SetScript("OnClick", function()
        local w = tonumber(widthInput:GetText()) or settings.width
        local h = tonumber(heightInput:GetText()) or settings.height
        local bw = tonumber(borderInput:GetText()) or settings.borderWidth
        local a = tonumber(alphaInput:GetText()) or settings.alpha
        
        settings.width = math.max(ShiftBoxDefaults.CONSTRAINTS.minWidth, w)
        settings.height = math.max(ShiftBoxDefaults.CONSTRAINTS.minHeight, h)
        settings.borderWidth = math.max(ShiftBoxDefaults.CONSTRAINTS.minBorder, bw)
        settings.alpha = math.max(ShiftBoxDefaults.CONSTRAINTS.minAlpha, math.min(ShiftBoxDefaults.CONSTRAINTS.maxAlpha, a))
        
        ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
        ShiftBoxUtils.Print("Settings saved!")
        ShiftBoxUtils.SaveSettings(settings)
    end)
    
    -- Reset button
    local resetButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    resetButton:SetSize(ShiftBoxDefaults.UI.buttonWidth, ShiftBoxDefaults.UI.buttonHeight)
    resetButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10)
    resetButton:SetText("Reset")
    resetButton:SetScript("OnClick", function()
        settings.posX = defaultSettings.posX
        settings.posY = defaultSettings.posY
        settings.width = defaultSettings.width
        settings.height = defaultSettings.height
        settings.r = defaultSettings.r
        settings.g = defaultSettings.g
        settings.b = defaultSettings.b
        settings.alpha = defaultSettings.alpha
        settings.borderWidth = defaultSettings.borderWidth
        
        widthInput:SetText(tostring(settings.width))
        heightInput:SetText(tostring(settings.height))
        borderInput:SetText(tostring(settings.borderWidth))
        alphaInput:SetText(string.format("%.2f", settings.alpha))
        UIDropDownMenu_SetText(colorDropdown, "Red")
        
        ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
        ShiftBoxUtils.Print("Settings reset to defaults!")
    end)
    
    -- Close button
    local closeButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    closeButton:SetSize(ShiftBoxDefaults.UI.buttonWidth, ShiftBoxDefaults.UI.buttonHeight)
    closeButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -15, 10)
    closeButton:SetText("Close")
    closeButton:SetScript("OnClick", function()
        -- Call the registered close handler to reset editor state
        if ShiftBoxEditorOnClose then
            ShiftBoxEditorOnClose()
        end
        frame:Hide()
    end)
    
    return frame
end

-- Show the editor panel
function ShiftBoxEdit.ShowEditorPanel(box, settings, textures, defaultSettings)
    local frame = ShiftBoxEdit.CreateEditorPanel(box, settings, textures, defaultSettings)
    frame:Show()
    
    -- Enable dragging the box during edit
    if not box:IsMouseEnabled() then
        box:EnableMouse(true)
        box:SetMovable(true)
        box:RegisterForDrag("LeftButton")
        box:SetScript("OnDragStart", function(self) self:StartMoving() end)
        box:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
            -- Save position relative to center
            local centerX = (self:GetLeft() + self:GetRight()) / 2 - UIParent:GetWidth() / 2
            local centerY = (self:GetTop() - self:GetBottom()) / 2 - UIParent:GetHeight() / 2
            settings.posX = centerX
            settings.posY = centerY
        end)
    end
    
    -- Register callback for when editor closes
    _G.ShiftBoxEditorOnClose = function()
        _G.ShiftBoxEditorOpen = false
    end
    _G.ShiftBoxEditorOpen = true
end

-- Make it global so the main addon can access it
_G.ShiftBoxEdit = ShiftBoxEdit
