-- KeyBox_Box.lua
-- Box creation, rendering, positioning, and dragging

local KeyBoxBox = {}

function KeyBoxBox.Create(settings)
    local box = CreateFrame("Frame", "KeyBox", UIParent, "BackdropTemplate")
    box:SetMovable(true)
    box:SetSize(settings.width, settings.height)
    box:SetPoint("CENTER", UIParent, "CENTER", settings.posX, settings.posY)
    box:Hide()
    return box
end

function KeyBoxBox.UpdateVisuals(box, settings)
    box:SetBackdrop({
        bgFile = KeyBoxDefaults.BOX_TEXTURE,
        edgeFile = KeyBoxDefaults.BOX_TEXTURE,
        edgeSize = settings.borderWidth,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })
    box:SetBackdropColor(0, 0, 0, 0)
    box:SetBackdropBorderColor(settings.r, settings.g, settings.b, settings.alpha)
    box:SetSize(settings.width, settings.height)
end

function KeyBoxBox.UpdatePosition(box, settings)
    box:ClearAllPoints()
    box:SetPoint("CENTER", UIParent, "CENTER", settings.posX, settings.posY)
end

function KeyBoxBox.CapturePosition(box, settings)
    local boxCenterX, boxCenterY = box:GetCenter()
    local uiCenterX, uiCenterY = UIParent:GetCenter()
    settings.posX = boxCenterX - uiCenterX
    settings.posY = boxCenterY - uiCenterY
end

function KeyBoxBox.ApplySettings(box, settings)
    KeyBoxBox.UpdateVisuals(box, settings)
    KeyBoxBox.UpdatePosition(box, settings)
end

function KeyBoxBox.EnableDragging(box, settings)
    if box:IsMouseEnabled() then
        return
    end

    box:EnableMouse(true)
    box:RegisterForDrag("LeftButton")
    box:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    box:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        KeyBoxBox.CapturePosition(self, settings)
        KeyBoxBox.UpdatePosition(self, settings)
    end)
end

function KeyBoxBox.DisableDragging(box)
    box:EnableMouse(false)
end

_G.KeyBoxBox = KeyBoxBox
