-- KeyBox_Edit.lua
-- Functions for editing the trigger, box size, color, and positioning

local KeyBoxEdit = {}

local editorPanel

local function UpdateEditorLayout(frame)
    local ui = KeyBoxDefaults.UI
    local availableWidth = math.max(1, UIParent:GetWidth() - ui.editorScreenMargin * 2)
    local availableHeight = math.max(1, UIParent:GetHeight() - ui.editorScreenMargin * 2)
    local scale = math.min(
        1,
        availableWidth / ui.editorWidth,
        availableHeight / ui.editorHeight
    )

    frame:SetSize(ui.editorWidth, ui.editorHeight)
    frame:SetScale(scale)
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", ui.editorPreferredOffsetX, 0)
end

local function CreateLabeledInput(frame, labelText, yOffset, value)
    local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, yOffset)
    label:SetText(labelText)

    local input = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    input:SetSize(KeyBoxDefaults.UI.inputWidth, KeyBoxDefaults.UI.inputHeight)
    input:SetPoint("LEFT", label, "RIGHT", 10, 0)
    input:SetText(value)
    input:SetAutoFocus(false)
    return input
end

local function ApplyInputSettings(settings, inputs)
    settings.width = math.max(KeyBoxDefaults.CONSTRAINTS.minWidth, tonumber(inputs.width:GetText()) or settings.width)
    settings.height = math.max(KeyBoxDefaults.CONSTRAINTS.minHeight, tonumber(inputs.height:GetText()) or settings.height)
    settings.borderWidth = math.max(KeyBoxDefaults.CONSTRAINTS.minBorder, tonumber(inputs.border:GetText()) or settings.borderWidth)
    local opacityPercent = tonumber(inputs.opacity:GetText()) or settings.alpha * 100
    settings.alpha = KeyBoxUtils.Clamp(
        opacityPercent,
        KeyBoxDefaults.CONSTRAINTS.minAlpha * 100,
        KeyBoxDefaults.CONSTRAINTS.maxAlpha * 100
    ) / 100
end

local function CreateButton(frame, text, width, point, relativePoint, x, y, onClick)
    local button = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    button:SetSize(width, KeyBoxDefaults.UI.buttonHeight)
    button:SetPoint(point, frame, relativePoint, x, y)
    button:SetText(text)
    button:SetScript("OnClick", onClick)
    return button
end

-- Create comprehensive editor panel with all controls
function KeyBoxEdit.CreateEditorPanel(box, settings, defaultSettings)
    if editorPanel then
        return editorPanel
    end

    -- Create main frame
    local frame = CreateFrame("Frame", "KeyBoxEditorPanel", UIParent, "BasicFrameTemplateWithInset")
    editorPanel = frame
    frame:Hide()
    frame:SetClampedToScreen(true)
    UpdateEditorLayout(frame)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    UIParent:HookScript("OnSizeChanged", function()
        if frame:IsShown() then
            UpdateEditorLayout(frame)
        end
    end)

    frame.TitleBg:SetHeight(25)
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOPLEFT", frame.TitleBg, "TOPLEFT", 8, -3)
    frame.title:SetText("KeyBox Editor")

    local settingsPanel = CreateFrame("Frame", nil, frame)
    settingsPanel:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -32)
    settingsPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 32)

    local resetsPanel = CreateFrame("Frame", nil, frame)
    resetsPanel:SetAllPoints(settingsPanel)

    local helpPanel = CreateFrame("Frame", nil, frame)
    helpPanel:SetAllPoints(settingsPanel)

    local tabs = {}
    local selectedTab

    local function StyleTab(tab, isHovered)
        if tab:GetID() == selectedTab then
            tab:SetBackdropColor(0.18, 0.18, 0.18, 1)
            tab:SetBackdropBorderColor(0.8, 0.65, 0.2, 1)
            tab.label:SetTextColor(1, 0.82, 0, 1)
        elseif isHovered then
            tab:SetBackdropColor(0.12, 0.12, 0.12, 1)
            tab:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
            tab.label:SetTextColor(1, 1, 1, 1)
        else
            tab:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
            tab:SetBackdropBorderColor(0.25, 0.25, 0.25, 1)
            tab.label:SetTextColor(0.7, 0.7, 0.7, 1)
        end
    end

    local function SelectTab(tabID)
        selectedTab = tabID
        settingsPanel:SetShown(tabID == 1)
        resetsPanel:SetShown(tabID == 2)
        helpPanel:SetShown(tabID == 3)
        for _, tab in ipairs(tabs) do
            StyleTab(tab, false)
        end
    end

    local function CreateEditorTab(tabID, text)
        local tab = CreateFrame("Button", nil, frame, "BackdropTemplate")
        tab:SetID(tabID)
        tab:SetSize(KeyBoxDefaults.UI.tabWidth, KeyBoxDefaults.UI.tabHeight)
        tab:SetBackdrop({
            bgFile = KeyBoxDefaults.BOX_TEXTURE,
            edgeFile = KeyBoxDefaults.BOX_TEXTURE,
            edgeSize = 1,
        })
        tab.label = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        tab.label:SetPoint("CENTER")
        tab.label:SetText(text)
        tab:SetScript("OnClick", function(self) SelectTab(self:GetID()) end)
        tab:SetScript("OnEnter", function(self) StyleTab(self, true) end)
        tab:SetScript("OnLeave", function(self) StyleTab(self, false) end)
        table.insert(tabs, tab)
        return tab
    end

    local settingsTab = CreateEditorTab(1, "Settings")
    settingsTab:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 12, 5)

    local resetsTab = CreateEditorTab(2, "Resets")
    resetsTab:SetPoint("LEFT", settingsTab, "RIGHT", 4, 0)

    local helpTab = CreateEditorTab(3, "Help")
    helpTab:SetPoint("LEFT", resetsTab, "RIGHT", 4, 0)

    SelectTab(1)

    local yOffset = -15

    local triggerLabel = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    triggerLabel:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT", 15, yOffset)
    triggerLabel:SetText("Trigger key:")

    local triggerButton = CreateFrame("Button", nil, settingsPanel, "GameMenuButtonTemplate")
    triggerButton:SetSize(KeyBoxDefaults.UI.wideButtonWidth, KeyBoxDefaults.UI.buttonHeight)
    triggerButton:SetPoint("LEFT", triggerLabel, "RIGHT", 10, 0)
    triggerButton:SetText(KeyBoxInput.GetKeyDisplayName(settings.triggerKey))
    triggerButton:SetScript("OnClick", function(self)
        self:SetText("Press a key...")
        KeyBoxInput.CaptureNextKey(function(key)
            if key then
                settings.triggerKey = key
            end
            self:SetText(KeyBoxInput.GetKeyDisplayName(settings.triggerKey))
        end)
    end)
    yOffset = yOffset - 35

    local widthInput = CreateLabeledInput(settingsPanel, "Width (px):", yOffset, tostring(settings.width))
    yOffset = yOffset - 30

    local heightInput = CreateLabeledInput(settingsPanel, "Height (px):", yOffset, tostring(settings.height))
    yOffset = yOffset - 30

    local borderInput = CreateLabeledInput(settingsPanel, "Border (px):", yOffset, tostring(settings.borderWidth))
    yOffset = yOffset - 35

    -- Color section
    local colorLabel = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    colorLabel:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT", 15, yOffset)
    colorLabel:SetText("Color:")

    local colorButton = CreateFrame("Button", nil, settingsPanel, "BackdropTemplate")
    colorButton:SetSize(KeyBoxDefaults.UI.colorSwatchWidth, KeyBoxDefaults.UI.inputHeight)
    colorButton:SetPoint("LEFT", colorLabel, "RIGHT", 10, 0)
    colorButton:SetBackdrop({
        bgFile = KeyBoxDefaults.BOX_TEXTURE,
        edgeFile = KeyBoxDefaults.BOX_TEXTURE,
        edgeSize = 1,
    })
    colorButton:SetBackdropBorderColor(1, 1, 1, 1)

    local function UpdateColorSwatch()
        colorButton:SetBackdropColor(settings.r, settings.g, settings.b, 1)
    end

    colorButton:SetScript("OnClick", function()
        local previousColor = {
            r = settings.r,
            g = settings.g,
            b = settings.b,
        }

        local function PreviewColor()
            settings.r, settings.g, settings.b = ColorPickerFrame:GetColorRGB()
            UpdateColorSwatch()
            KeyBoxBox.UpdateVisuals(box, settings)
        end

        ColorPickerFrame:SetupColorPickerAndShow({
            r = settings.r,
            g = settings.g,
            b = settings.b,
            hasOpacity = false,
            swatchFunc = PreviewColor,
            cancelFunc = function()
                settings.r = previousColor.r
                settings.g = previousColor.g
                settings.b = previousColor.b
                UpdateColorSwatch()
                KeyBoxBox.UpdateVisuals(box, settings)
            end,
        })
    end)
    UpdateColorSwatch()

    yOffset = yOffset - 30

    local opacityInput = CreateLabeledInput(settingsPanel, "Opacity (%):", yOffset, string.format("%.0f", settings.alpha * 100))
    local inputs = {
        width = widthInput,
        height = heightInput,
        border = borderInput,
        opacity = opacityInput,
    }
    local isRefreshing = false
    local sessionBaseline

    -- Update preview on text change
    local function UpdatePreview()
        if isRefreshing then
            return
        end
        ApplyInputSettings(settings, inputs)
        KeyBoxBox.UpdateVisuals(box, settings)
    end

    local function RefreshInputs()
        isRefreshing = true
        widthInput:SetText(tostring(settings.width))
        heightInput:SetText(tostring(settings.height))
        borderInput:SetText(tostring(settings.borderWidth))
        opacityInput:SetText(string.format("%.0f", settings.alpha * 100))
        triggerButton:SetText(KeyBoxInput.GetKeyDisplayName(settings.triggerKey))
        UpdateColorSwatch()
        isRefreshing = false
    end

    local function LoadIntoEditor(source)
        KeyBoxSettingsManager.Replace(settings, source)
        RefreshInputs()
        KeyBoxBox.ApplySettings(box, settings)
    end

    local function CommitEditorState()
        sessionBaseline = KeyBoxSettingsManager.Copy(settings)
    end

    frame:SetScript("OnShow", function(self)
        UpdateEditorLayout(self)
        RefreshInputs()
        CommitEditorState()
        KeyBoxBox.EnableDragging(box, settings)
    end)
    frame:SetScript("OnHide", function()
        KeyBoxInput.CancelCapture()
        if ColorPickerFrame:IsShown() then
            ColorPickerFrame:Hide()
        end
        if sessionBaseline then
            KeyBoxSettingsManager.Replace(settings, sessionBaseline)
            KeyBoxBox.ApplySettings(box, settings)
            sessionBaseline = nil
        end
        KeyBoxBox.DisableDragging(box)
    end)

    widthInput:SetScript("OnTextChanged", UpdatePreview)
    heightInput:SetScript("OnTextChanged", UpdatePreview)
    borderInput:SetScript("OnTextChanged", UpdatePreview)
    opacityInput:SetScript("OnTextChanged", UpdatePreview)

    CreateButton(settingsPanel, "Save Character", KeyBoxDefaults.UI.wideButtonWidth, "BOTTOMLEFT", "BOTTOMLEFT", 15, 10, function()
        UpdatePreview()
        KeyBoxBox.CapturePosition(box, settings)
        KeyBoxSettingsManager.SaveCharacter(settings)
        CommitEditorState()
        KeyBoxUtils.Print("Character settings saved!")
    end)

    CreateButton(settingsPanel, "Save Account", KeyBoxDefaults.UI.wideButtonWidth, "BOTTOMRIGHT", "BOTTOMRIGHT", -15, 10, function()
        UpdatePreview()
        KeyBoxBox.CapturePosition(box, settings)
        KeyBoxSettingsManager.SaveAccount(settings)
        CommitEditorState()
        KeyBoxUtils.Print("Account default saved; character overrides were preserved.")
    end)

    local function CreateResetAction(title, description, y, buttonText, onClick)
        local titleText = resetsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        titleText:SetPoint("TOPLEFT", resetsPanel, "TOPLEFT", 15, y)
        titleText:SetText(title)

        local actionButton = CreateButton(
            resetsPanel,
            buttonText,
            KeyBoxDefaults.UI.wideButtonWidth,
            "TOPRIGHT",
            "TOPRIGHT",
            -15,
            y - 5,
            onClick
        )

        local descriptionText = resetsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        descriptionText:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -4)
        descriptionText:SetPoint("RIGHT", actionButton, "LEFT", -12, 0)
        descriptionText:SetJustifyH("LEFT")
        descriptionText:SetText(description)
    end

    CreateResetAction(
        "Character override",
        "Return this character to the account default.",
        -20,
        "Reset Character",
        function()
            KeyBoxSettingsManager.ClearCharacter()
            LoadIntoEditor(KeyBoxSettingsManager.LoadAccount(defaultSettings))
            CommitEditorState()
            KeyBoxUtils.Print("Character override cleared; using the account default.")
        end
    )

    CreateResetAction(
        "Account default",
        "Remove the account default while preserving character overrides.",
        -100,
        "Reset Account",
        function()
            KeyBoxSettingsManager.ClearAccount()
            LoadIntoEditor(KeyBoxSettingsManager.Load(defaultSettings))
            CommitEditorState()
            KeyBoxUtils.Print("Account default cleared; character overrides were preserved.")
        end
    )

    CreateResetAction(
        "Base settings",
        "Load a clean starting configuration without saving it.",
        -180,
        "Load Base Settings",
        function()
            LoadIntoEditor(defaultSettings)
            KeyBoxUtils.Print("Base settings loaded. Save them to the desired scope.")
        end
    )

    local function CreateHelpSection(title, description, y)
        local titleText = helpPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        titleText:SetPoint("TOPLEFT", helpPanel, "TOPLEFT", 15, y)
        titleText:SetText(title)

        local descriptionText = helpPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        descriptionText:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -4)
        descriptionText:SetPoint("RIGHT", helpPanel, "RIGHT", -15, 0)
        descriptionText:SetJustifyH("LEFT")
        descriptionText:SetText(description)
    end

    CreateHelpSection(
        "Showing and editing",
        "Hold the configured trigger key to show the box. Click Trigger key to choose a new key; Escape cancels key capture.",
        -20
    )
    CreateHelpSection(
        "Saving",
        "Save Character creates an override for this character. Save Account sets the default for characters without an override.",
        -90
    )
    CreateHelpSection(
        "Resetting",
        "Reset Character returns to the account default. Reset Account removes the shared default but preserves character overrides.",
        -170
    )
    CreateHelpSection(
        "Closing",
        "The title-bar X discards previews made after the most recent save or reset action.",
        -250
    )

    return frame
end

-- Show the editor panel
function KeyBoxEdit.ShowEditorPanel(box, settings, defaultSettings)
    local frame = KeyBoxEdit.CreateEditorPanel(box, settings, defaultSettings)
    frame:Show()
    KeyBoxBox.EnableDragging(box, settings)
end

function KeyBoxEdit.IsEditorOpen()
    return editorPanel and editorPanel:IsShown() or false
end

-- Make it global so the main addon can access it
_G.KeyBoxEdit = KeyBoxEdit
