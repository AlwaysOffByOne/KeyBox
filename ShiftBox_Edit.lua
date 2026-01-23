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

-- Function to set box color
function ShiftBoxEdit.SetBoxColor(settings, r, g, b, alpha, textures, box)
    settings.r = tonumber(r) or settings.r
    settings.g = tonumber(g) or settings.g
    settings.b = tonumber(b) or settings.b
    settings.alpha = tonumber(alpha) or settings.alpha
    ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
    ShiftBoxUtils.Print(string.format("Color set to R:%.1f G:%.1f B:%.1f A:%.1f", settings.r, settings.g, settings.b, settings.alpha))
end

-- Function to set box size
function ShiftBoxEdit.SetBoxSize(settings, width, height, textures, box)
    settings.width = tonumber(width) or settings.width
    settings.height = tonumber(height) or settings.height
    ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
    ShiftBoxUtils.Print(string.format("Size set to %d x %d", settings.width, settings.height))
end

-- Create the size editor UI window
function ShiftBoxEdit.CreateSizeEditorWindow(box, settings, textures)
    -- Check if window already exists
    if ShiftBoxSizeEditor then
        return ShiftBoxSizeEditor
    end
    
    -- Create main frame
    local frame = CreateFrame("Frame", "ShiftBoxSizeEditor", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(300, 240)
    frame:SetPoint("CENTER", UIParent, "CENTER", 300, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    
    frame.TitleBg:SetHeight(25)
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOPLEFT", frame.TitleBg, "TOPLEFT", 8, -3)
    frame.title:SetText("ShiftBox Size Editor")
    
    -- Width label and input
    local widthLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    widthLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -40)
    widthLabel:SetText("Width:")
    
    local widthInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    widthInput:SetSize(80, 20)
    widthInput:SetPoint("LEFT", widthLabel, "RIGHT", 10, 0)
    widthInput:SetText(tostring(settings.width))
    widthInput:SetAutoFocus(false)
    
    -- Height label and input
    local heightLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heightLabel:SetPoint("TOPLEFT", widthLabel, "BOTTOMLEFT", 0, -25)
    heightLabel:SetText("Height:")
    
    local heightInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    heightInput:SetSize(80, 20)
    heightInput:SetPoint("LEFT", heightLabel, "RIGHT", 10, 0)
    heightInput:SetText(tostring(settings.height))
    heightInput:SetAutoFocus(false)
    
    -- Border width label and input
    local borderLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    borderLabel:SetPoint("TOPLEFT", heightLabel, "BOTTOMLEFT", 0, -25)
    borderLabel:SetText("Border:")
    
    local borderInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    borderInput:SetSize(80, 20)
    borderInput:SetPoint("LEFT", borderLabel, "RIGHT", 10, 0)
    borderInput:SetText(tostring(settings.borderWidth))
    borderInput:SetAutoFocus(false)
    
    -- Update preview on text change
    local function UpdatePreview()
        local w = tonumber(widthInput:GetText()) or settings.width
        local h = tonumber(heightInput:GetText()) or settings.height
        local bw = tonumber(borderInput:GetText()) or settings.borderWidth
        w = math.max(50, w)
        h = math.max(50, h)
        bw = math.max(1, bw)
        settings.width = w
        settings.height = h
        settings.borderWidth = bw
        ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
    end
    
    widthInput:SetScript("OnTextChanged", UpdatePreview)
    heightInput:SetScript("OnTextChanged", UpdatePreview)
    borderInput:SetScript("OnTextChanged", UpdatePreview)
    
    -- Apply button
    local applyButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    applyButton:SetSize(80, 25)
    applyButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 15, 10)
    applyButton:SetText("Apply")
    applyButton:SetScript("OnClick", function()
        local w = tonumber(widthInput:GetText()) or settings.width
        local h = tonumber(heightInput:GetText()) or settings.height
        local bw = tonumber(borderInput:GetText()) or settings.borderWidth
        settings.width = math.max(50, w)
        settings.height = math.max(50, h)
        settings.borderWidth = math.max(1, bw)
        ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
        ShiftBoxUtils.Print(string.format("Size set to %d x %d, Border: %d", settings.width, settings.height, settings.borderWidth))
        ShiftBoxUtils.SaveSettings(settings)
        frame:Hide()
    end)
    
    -- Cancel button
    local cancelButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    cancelButton:SetSize(80, 25)
    cancelButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -15, 10)
    cancelButton:SetText("Cancel")
    cancelButton:SetScript("OnClick", function()
        widthInput:SetText(tostring(settings.width))
        heightInput:SetText(tostring(settings.height))
        borderInput:SetText(tostring(settings.borderWidth))
        ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
        frame:Hide()
    end)
    
    return frame
end

-- Show the size editor window
function ShiftBoxEdit.ShowSizeEditor(box, settings, textures)
    local frame = ShiftBoxEdit.CreateSizeEditorWindow(box, settings, textures)
    frame:Show()
end

-- Create comprehensive editor panel with all controls
function ShiftBoxEdit.CreateEditorPanel(box, settings, textures, defaultSettings)
    -- Check if panel already exists
    if ShiftBoxEditorPanel then
        return ShiftBoxEditorPanel
    end
    
    -- Define preset colors
    local PRESET_COLORS = {
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
    
    -- Create main frame
    local frame = CreateFrame("Frame", "ShiftBoxEditorPanel", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(350, 360)
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
    widthInput:SetSize(80, 20)
    widthInput:SetPoint("LEFT", widthLabel, "RIGHT", 10, 0)
    widthInput:SetText(tostring(settings.width))
    widthInput:SetAutoFocus(false)
    
    yOffset = yOffset - 30
    
    -- Height section
    local heightLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heightLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, yOffset)
    heightLabel:SetText("Height:")
    
    local heightInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    heightInput:SetSize(80, 20)
    heightInput:SetPoint("LEFT", heightLabel, "RIGHT", 10, 0)
    heightInput:SetText(tostring(settings.height))
    heightInput:SetAutoFocus(false)
    
    yOffset = yOffset - 30
    
    -- Border width section
    local borderLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    borderLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, yOffset)
    borderLabel:SetText("Border:")
    
    local borderInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    borderInput:SetSize(80, 20)
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
    alphaInput:SetSize(80, 20)
    alphaInput:SetPoint("LEFT", alphaLabel, "RIGHT", 10, 0)
    alphaInput:SetText(string.format("%.2f", settings.alpha))
    alphaInput:SetAutoFocus(false)
    
    -- Update preview on text change
    local function UpdatePreview()
        local w = tonumber(widthInput:GetText()) or settings.width
        local h = tonumber(heightInput:GetText()) or settings.height
        local bw = tonumber(borderInput:GetText()) or settings.borderWidth
        local a = tonumber(alphaInput:GetText()) or settings.alpha
        
        w = math.max(50, w)
        h = math.max(50, h)
        bw = math.max(1, bw)
        a = math.max(0, math.min(1, a))
        
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
    saveButton:SetSize(80, 25)
    saveButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 15, 10)
    saveButton:SetText("Save")
    saveButton:SetScript("OnClick", function()
        local w = tonumber(widthInput:GetText()) or settings.width
        local h = tonumber(heightInput:GetText()) or settings.height
        local bw = tonumber(borderInput:GetText()) or settings.borderWidth
        local a = tonumber(alphaInput:GetText()) or settings.alpha
        
        settings.width = math.max(50, w)
        settings.height = math.max(50, h)
        settings.borderWidth = math.max(1, bw)
        settings.alpha = math.max(0, math.min(1, a))
        
        ShiftBoxEdit.UpdateBoxVisuals(box, settings, textures)
        ShiftBoxUtils.Print("Settings saved!")
        ShiftBoxUtils.SaveSettings(settings)
    end)
    
    -- Reset button
    local resetButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    resetButton:SetSize(80, 25)
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
    closeButton:SetSize(80, 25)
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

-- Function to toggle edit mode
function ShiftBoxEdit.ToggleEditMode(editMode, box, editOverlay, resizeHandle, settings, isResizing, textures)
    editMode = not editMode
    
    if editMode then
        box:Show()
        editOverlay:Show()
        resizeHandle:Show()
        box:SetUserPlaced(false)
        box:EnableMouse(true)
        box:SetMovable(true)
        box:RegisterForDrag("LeftButton")
        
        box:SetScript("OnDragStart", function(self)
            if not isResizing then
                self:StartMoving()
            end
        end)
        
        box:SetScript("OnDragStop", function(self)
            if not isResizing then
                self:StopMovingOrSizing()
                -- Save position relative to center
                local centerX = (self:GetLeft() + self:GetRight()) / 2 - UIParent:GetWidth() / 2
                local centerY = (self:GetTop() - self:GetBottom()) / 2 - UIParent:GetHeight() / 2
                settings.posX = centerX
                settings.posY = centerY
            end
        end)
        
        ShiftBoxUtils.Print("Edit mode ENABLED.")
        ShiftBoxUtils.Print("Drag box to move | Use /shiftbox size to open size editor | /shiftbox color to change color", "|cff00FF00")
    else
        editOverlay:Hide()
        resizeHandle:Hide()
        box:EnableMouse(false)
        box:SetMovable(false)
        ShiftBoxUtils.SaveSettings(settings)
        ShiftBoxUtils.Print("Edit mode DISABLED.")
    end
    
    return editMode
end

-- Make it global so the main addon can access it
_G.ShiftBoxEdit = ShiftBoxEdit
