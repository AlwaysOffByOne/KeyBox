-- ShiftBox_Box.lua
-- Box creation, rendering, positioning, and dragging

local ShiftBoxBox = {}

function ShiftBoxBox.Create(settings)
    local box = CreateFrame("Frame", "ShiftBox", UIParent, "BackdropTemplate")
    box:SetMovable(true)
    box:SetSize(settings.width, settings.height)
    box:SetPoint("CENTER", UIParent, "CENTER", settings.posX, settings.posY)
    box:Hide()
    return box
end

function ShiftBoxBox.UpdateVisuals(box, settings)
    box:SetBackdrop({
        bgFile = ShiftBoxDefaults.BOX_TEXTURE,
        edgeFile = ShiftBoxDefaults.BOX_TEXTURE,
        edgeSize = settings.borderWidth,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })
    box:SetBackdropColor(0, 0, 0, 0)
    box:SetBackdropBorderColor(settings.r, settings.g, settings.b, settings.alpha)
    box:SetSize(settings.width, settings.height)
end

function ShiftBoxBox.UpdatePosition(box, settings)
    box:ClearAllPoints()
    box:SetPoint("CENTER", UIParent, "CENTER", settings.posX, settings.posY)
end

function ShiftBoxBox.CapturePosition(box, settings)
    local boxCenterX, boxCenterY = box:GetCenter()
    local uiCenterX, uiCenterY = UIParent:GetCenter()
    settings.posX = boxCenterX - uiCenterX
    settings.posY = boxCenterY - uiCenterY
end

function ShiftBoxBox.ApplySettings(box, settings)
    ShiftBoxBox.UpdateVisuals(box, settings)
    ShiftBoxBox.UpdatePosition(box, settings)
end

function ShiftBoxBox.EnableDragging(box, settings)
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
        ShiftBoxBox.CapturePosition(self, settings)
        ShiftBoxBox.UpdatePosition(self, settings)
    end)
end

function ShiftBoxBox.DisableDragging(box)
    box:EnableMouse(false)
end

_G.ShiftBoxBox = ShiftBoxBox
