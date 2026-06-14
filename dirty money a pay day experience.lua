--[[
    Dirty Money: A PAYDAY® Experience
    MADE BY NEDELCU — V1.0.0
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Parent GUI (compatibil cu majoritatea executorilor)
local function getGuiParent()
    if gethui then
        return gethui()
    end
    if syn and syn.protect_gui then
        local core = game:GetService("CoreGui")
        return core
    end
    return game:GetService("CoreGui")
end

local guiParent = getGuiParent()

-- ═══════════════════════════════════════
--  UTILITARE
-- ═══════════════════════════════════════

local function tween(obj, props, duration, style, dir)
    local info = TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function makeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function makeStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(0, 255, 255)
    s.Thickness = thickness or 2
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local UI = {
    MARGIN = 10,
    LABEL_H = 22,
    ROW_H = 28,
    KEYBIND_W = 72,
    ICON_BTN = 28,
    SECTION_TEXT = 12,
    LABEL_TEXT = 13,
    BTN_TEXT = 11,
    INPUT_TEXT = 11,
    BG = Color3.fromRGB(25, 25, 32),
    TEXT_MUTED = Color3.fromRGB(200, 200, 210),
    TEXT_DIM = Color3.fromRGB(160, 160, 170),
    CORNER = 6,
}

local function makeKeybindRow(parent, labelText, y)
    local row = Instance.new("Frame")
    row.Name = "KeybindRow"
    row.Size = UDim2.new(1, -(UI.MARGIN * 2), 0, UI.ROW_H)
    row.Position = UDim2.new(0, UI.MARGIN, 0, y)
    row.BackgroundTransparency = 1
    row.ZIndex = 3
    row.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, UI.KEYBIND_W, 1, 0)
    btn.Position = UDim2.new(1, -UI.KEYBIND_W, 0, 0)
    btn.BackgroundColor3 = UI.BG
    btn.TextSize = UI.BTN_TEXT
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 3
    btn.Parent = row
    makeCorner(btn, UI.CORNER)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -(UI.KEYBIND_W + 8), 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = UI.TEXT_MUTED
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextWrapped = true
    label.ZIndex = 3
    label.Parent = row

    return btn, label
end

local function makeSectionLabel(parent, text, y, widthOffset)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, widthOffset or -(UI.KEYBIND_W + UI.MARGIN + 8), UI.LABEL_H, 0)
    label.Position = UDim2.new(0, UI.MARGIN, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = UI.TEXT_MUTED
    label.TextSize = UI.LABEL_TEXT
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    label.Parent = parent
    return label
end

local function makeKeybindButton(parent, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, UI.KEYBIND_W, 0, UI.ROW_H)
    btn.Position = UDim2.new(1, -(UI.KEYBIND_W + UI.MARGIN), 0, y - 2)
    btn.BackgroundColor3 = UI.BG
    btn.TextSize = UI.BTN_TEXT
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 3
    btn.Parent = parent
    makeCorner(btn, UI.CORNER)
    return btn
end

local function makePanelButton(parent, text, size, position)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = position
    btn.BackgroundColor3 = UI.BG
    btn.Text = text
    btn.TextSize = UI.BTN_TEXT
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 3
    btn.Parent = parent
    makeCorner(btn, UI.CORNER)
    return btn
end

-- ═══════════════════════════════════════
--  SPLASH SCREEN
-- ═══════════════════════════════════════

local splashGui = Instance.new("ScreenGui")
splashGui.Name = "DM_Splash"
splashGui.ResetOnSpawn = false
splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
splashGui.IgnoreGuiInset = true
splashGui.Parent = guiParent

if syn and syn.protect_gui then
    syn.protect_gui(splashGui)
end

-- Fundal negru full-screen
local splashBg = Instance.new("Frame")
splashBg.Name = "Background"
splashBg.Size = UDim2.new(1, 0, 1, 0)
splashBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
splashBg.BorderSizePixel = 0
splashBg.ZIndex = 1
splashBg.Parent = splashGui

-- Titlu
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 500, 0, 60)
titleLabel.Position = UDim2.new(0.5, -250, 0.5, -120)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MAYA : MADE BY NEDELCU"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 36
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1
titleLabel.ZIndex = 3
titleLabel.Parent = splashBg

tween(titleLabel, { TextTransparency = 0 }, 1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Buton START (oval, alb, glow intens)
local btnContainer = Instance.new("Frame")
btnContainer.Name = "StartContainer"
btnContainer.Size = UDim2.new(0, 220, 0, 56)
btnContainer.Position = UDim2.new(0.5, -110, 0.5, -20)
btnContainer.BackgroundTransparency = 1
btnContainer.BorderSizePixel = 0
btnContainer.ZIndex = 4
btnContainer.Parent = splashBg

local glowLayers = {}
local glowConfig = {
    { padX = 10, padY = 8,  radius = 32, hoverAlpha = 0.15 },
    { padX = 28, padY = 20, radius = 40, hoverAlpha = 0.30 },
    { padX = 50, padY = 36, radius = 52, hoverAlpha = 0.45 },
    { padX = 76, padY = 54, radius = 64, hoverAlpha = 0.58 },
}

for i, cfg in ipairs(glowConfig) do
    local glow = Instance.new("Frame")
    glow.Name = "Glow" .. i
    glow.Size = UDim2.new(1, cfg.padX, 1, cfg.padY)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 0
    glow.ZIndex = i
    makeCorner(glow, cfg.radius)
    glow.Parent = btnContainer
    glowLayers[i] = { frame = glow, hoverAlpha = cfg.hoverAlpha, padX = cfg.padX, padY = cfg.padY }
end

local startBtn = Instance.new("TextButton")
startBtn.Name = "StartButton"
startBtn.Size = UDim2.new(1, 0, 1, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
startBtn.Text = "START"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextSize = 26
startBtn.Font = Enum.Font.GothamBold
startBtn.AutoButtonColor = false
startBtn.BorderSizePixel = 0
startBtn.ZIndex = 5
startBtn.Parent = btnContainer

makeCorner(startBtn, 28)

local function setButtonGlow(active)
    for _, layer in ipairs(glowLayers) do
        tween(layer.frame, {
            BackgroundTransparency = active and layer.hoverAlpha or 1,
            Size = UDim2.new(1, active and layer.padX + 12 or layer.padX, 1, active and layer.padY + 8 or layer.padY),
        }, 0.25)
    end
    tween(startBtn, {
        BackgroundColor3 = active and Color3.fromRGB(45, 45, 50) or Color3.fromRGB(25, 25, 28),
        TextColor3 = Color3.fromRGB(255, 255, 255),
    }, 0.25)
end

startBtn.MouseEnter:Connect(function()
    setButtonGlow(true)
end)

startBtn.MouseLeave:Connect(function()
    setButtonGlow(false)
end)

-- ═══════════════════════════════════════
--  MAIN PANEL (dupa START)
-- ═══════════════════════════════════════

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "DM_Main"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.Enabled = false
mainGui.Parent = guiParent

if syn and syn.protect_gui then
    syn.protect_gui(mainGui)
end

local TAB_WIDTH = 66
local TAB_PADDING = 8
local TAB_BAR_MARGIN = 20
local tabNames = { "PLAYER", "ESP", "TP", "SETTINGS", "INFO" }

local MIN_W = #tabNames * TAB_WIDTH + (#tabNames - 1) * TAB_PADDING + TAB_BAR_MARGIN
local MIN_H = 200
local PANEL_W = math.max(400, MIN_W)
local PANEL_H = 320

local settings = {
    toggleKey = Enum.KeyCode.K,
    deathTpKey = Enum.KeyCode.T,
    espKey = Enum.KeyCode.H,
    flyKey = Enum.KeyCode.G,
    accentColor = Color3.fromRGB(235, 235, 240),
    menuOpacity = 0.8,
    flyEnabled = false,
    flySpeed = 50,
    noclipEnabled = false,
    clickTeleportEnabled = false,
    espEnabled = false,
    espBox = true,
    espName = true,
    espHp = true,
    espDistance = true,
    espAfk = true,
}

local COLOR_PRESETS = {
    Color3.fromRGB(255, 55, 55),    -- Roșu
    Color3.fromRGB(255, 130, 40),   -- Portocaliu
    Color3.fromRGB(255, 215, 50),   -- Galben
    Color3.fromRGB(120, 255, 70),   -- Lime
    Color3.fromRGB(50, 220, 100),   -- Verde
    Color3.fromRGB(0, 255, 255),    -- Cyan
    Color3.fromRGB(55, 175, 255),   -- Albastru deschis
    Color3.fromRGB(55, 95, 255),    -- Albastru
    Color3.fromRGB(155, 75, 255),   -- Mov
    Color3.fromRGB(210, 55, 230),   -- Magenta
    Color3.fromRGB(255, 95, 175),   -- Roz
    Color3.fromRGB(235, 235, 240),  -- Alb
}

local function blendColor(color, factor)
    return Color3.new(
        math.clamp(color.R * factor, 0, 1),
        math.clamp(color.G * factor, 0, 1),
        math.clamp(color.B * factor, 0, 1)
    )
end

local function lerpColor(a, b, t)
    t = math.clamp(t, 0, 1)
    return Color3.new(
        a.R + (b.R - a.R) * t,
        a.G + (b.G - a.G) * t,
        a.B + (b.B - a.B) * t
    )
end

local function getAccentHoverTextColor(accent)
    if accent.R > 0.85 and accent.G > 0.85 and accent.B > 0.85 then
        return Color3.fromRGB(25, 25, 32)
    end
    return Color3.fromRGB(255, 255, 255)
end

local themeTargets = {}
local waitingForKeybind = nil
local keybindBtn
local deathTpKeyBtn
local espKeyBtn
local espToggleBtn
local espFeatureButtons = {}
local flyKeyBtn
local flyToggleBtn
local flySpeedFill
local flySpeedKnob
local flySpeedLabel
local flySpeedSliderTrack
local playerFeatureButtons = {}
local playerStatusLabel
local colorButtons = {}
local opacityFill
local opacityKnob
local opacityLabel
local opacitySliderTrack
local sliderDragging = false
local flySpeedDragging = false
local playerScrollFrame
local playerContentContainer
local playerListLayout
local updatePlayerScrollSize
local espScrollFrame
local espContentContainer
local espListLayout
local updateEspScrollSize

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Panel"
mainFrame.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
mainFrame.Position = UDim2.new(0.5, -PANEL_W / 2, 0.5, -PANEL_H / 2)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Parent = mainGui

makeCorner(mainFrame, 12)
local mainStroke = makeStroke(mainFrame, Color3.fromRGB(0, 200, 220), 1.5, 0.4)
themeTargets.mainStroke = mainStroke

local panelBody = Instance.new("Frame")
panelBody.Name = "PanelBody"
panelBody.Size = UDim2.new(1, 0, 1, 0)
panelBody.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
panelBody.BorderSizePixel = 0
panelBody.ZIndex = 1
panelBody.Parent = mainFrame
makeCorner(panelBody, 12)
themeTargets.panelBody = panelBody

-- Drag bar (titlu + mutare) — fara fundal dublu
local dragBar = Instance.new("Frame")
dragBar.Name = "DragBar"
dragBar.Size = UDim2.new(1, 0, 0, 36)
dragBar.BackgroundTransparency = 1
dragBar.BorderSizePixel = 0
dragBar.ZIndex = 3
dragBar.Parent = mainFrame
themeTargets.dragBar = dragBar

local headerLine = Instance.new("Frame")
headerLine.Name = "HeaderLine"
headerLine.Size = UDim2.new(1, -20, 0, 1)
headerLine.Position = UDim2.new(0, 10, 1, -1)
headerLine.BackgroundColor3 = Color3.fromRGB(80, 80, 95)
headerLine.BackgroundTransparency = 0.55
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 3
headerLine.Parent = dragBar
themeTargets.headerLine = headerLine

-- Titlu panel
local panelTitle = Instance.new("TextLabel")
panelTitle.Name = "PanelTitle"
panelTitle.Size = UDim2.new(1, -48, 1, 0)
panelTitle.Position = UDim2.new(0, 8, 0, 0)
panelTitle.BackgroundTransparency = 1
panelTitle.Text = "MAYA : Dirty Money A PAYDAY® Experience"
panelTitle.TextColor3 = Color3.fromRGB(0, 230, 255)
panelTitle.TextSize = 14
panelTitle.Font = Enum.Font.GothamBold
panelTitle.TextXAlignment = Enum.TextXAlignment.Center
panelTitle.ZIndex = 3
panelTitle.Parent = dragBar
themeTargets.panelTitle = panelTitle

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -28, 0.5, -10)
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 25)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 4
closeBtn.Parent = dragBar
makeCorner(closeBtn, 4)

closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, {
        BackgroundColor3 = Color3.fromRGB(180, 40, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255),
    }, 0.15)
end)

closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, {
        BackgroundColor3 = Color3.fromRGB(35, 20, 25),
        TextColor3 = Color3.fromRGB(255, 90, 90),
    }, 0.15)
end)

local function closeScript()
    if cleanupPlayerFeatures then
        cleanupPlayerFeatures()
    end
    if espFolder and espFolder.Parent then
        espFolder:Destroy()
    end
    if mainGui and mainGui.Parent then
        mainGui:Destroy()
    end
    if splashGui and splashGui.Parent then
        splashGui:Destroy()
    end
end

closeBtn.MouseButton1Click:Connect(closeScript)

-- Tab bar (5 casute)
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, -TAB_BAR_MARGIN, 0, 34)
tabBar.Position = UDim2.new(0, 10, 0, 44)
tabBar.BackgroundTransparency = 1
tabBar.ZIndex = 2
tabBar.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Padding = UDim.new(0, TAB_PADDING)
tabLayout.Parent = tabBar

local tabButtons = {}
local tabContents = {}
local activeTab = 1

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -20, 1, -92)
contentArea.Position = UDim2.new(0, 10, 0, 86)
contentArea.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
contentArea.BackgroundTransparency = 0.35
contentArea.BorderSizePixel = 0
contentArea.ZIndex = 2
contentArea.Parent = mainFrame
makeCorner(contentArea, 8)
local contentStroke = makeStroke(contentArea, Color3.fromRGB(60, 60, 70), 1, 0.65)
themeTargets.contentArea = contentArea
themeTargets.contentStroke = contentStroke

local function updateTabColors(index, animated)
    if index then
        activeTab = index
    end

    local accent = settings.accentColor
    local activeBg = blendColor(accent, 0.32)
    local activeText = accent
    local inactiveBg = Color3.fromRGB(25, 25, 32)
    local inactiveText = Color3.fromRGB(140, 140, 150)

    for i, btn in ipairs(tabButtons) do
        local active = i == activeTab
        local props = {
            BackgroundColor3 = active and activeBg or inactiveBg,
            TextColor3 = active and activeText or inactiveText,
        }

        if animated then
            tween(btn, props, 0.15)
        else
            btn.BackgroundColor3 = props.BackgroundColor3
            btn.TextColor3 = props.TextColor3
        end
    end
end

local function switchTab(index)
    for i, content in ipairs(tabContents) do
        content.Visible = i == index
    end
    updateTabColors(index, true)
end

local OPACITY_BASE = {
    panel = 0,
    content = 0.15,
    stroke = 0.25,
}

local function transparencyForOpacity(base, opacity)
    local t = math.clamp((opacity - 0.1) / 0.9, 0, 1)
    return 1 - t * (1 - base)
end

local function applyMenuOpacity(value)
    settings.menuOpacity = math.clamp(value, 0.1, 1)
    local opacity = settings.menuOpacity
    local visual = (opacity - 0.1) / 0.9
    local percent = math.floor(opacity * 100 + 0.5)

    if opacityLabel then
        opacityLabel.Text = percent .. "%"
    end
    if opacityFill then
        opacityFill.Size = UDim2.new(visual, 0, 1, 0)
    end
    if opacityKnob then
        opacityKnob.Position = UDim2.new(visual, 0, 0.5, 0)
    end

    mainFrame.BackgroundTransparency = 1

    if panelBody then
        panelBody.BackgroundTransparency = transparencyForOpacity(OPACITY_BASE.panel, opacity)
    end
    if contentArea then
        contentArea.BackgroundTransparency = transparencyForOpacity(OPACITY_BASE.content, opacity)
    end
    if themeTargets.contentStroke then
        themeTargets.contentStroke.Transparency = transparencyForOpacity(0.55, opacity)
    end
    if mainStroke then
        mainStroke.Transparency = transparencyForOpacity(OPACITY_BASE.stroke, opacity)
    end
end

local function setOpacityFromX(x)
    if not opacitySliderTrack then
        return
    end

    local trackPos = opacitySliderTrack.AbsolutePosition.X
    local trackSize = opacitySliderTrack.AbsoluteSize.X
    if trackSize <= 0 then
        return
    end

    local alpha = math.clamp((x - trackPos) / trackSize, 0, 1)
    applyMenuOpacity(0.1 + alpha * 0.9)
end

local FLY_SPEED_MIN = 10
local FLY_SPEED_MAX = 200

local function applyFlySpeed(value)
    settings.flySpeed = math.clamp(value, FLY_SPEED_MIN, FLY_SPEED_MAX)
    local visual = (settings.flySpeed - FLY_SPEED_MIN) / (FLY_SPEED_MAX - FLY_SPEED_MIN)

    if flySpeedLabel then
        flySpeedLabel.Text = math.floor(settings.flySpeed + 0.5)
    end
    if flySpeedFill then
        flySpeedFill.Size = UDim2.new(visual, 0, 1, 0)
    end
    if flySpeedKnob then
        flySpeedKnob.Position = UDim2.new(visual, 0, 0.5, 0)
    end
end

local function setFlySpeedFromX(x)
    if not flySpeedSliderTrack then
        return
    end

    local trackPos = flySpeedSliderTrack.AbsolutePosition.X
    local trackSize = flySpeedSliderTrack.AbsoluteSize.X
    if trackSize <= 0 then
        return
    end

    local alpha = math.clamp((x - trackPos) / trackSize, 0, 1)
    applyFlySpeed(FLY_SPEED_MIN + alpha * (FLY_SPEED_MAX - FLY_SPEED_MIN))
end

local function applyTheme()
    local accent = settings.accentColor

    mainStroke.Color = blendColor(accent, 0.85)

    if panelBody then
        panelBody.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    end
    panelTitle.TextColor3 = blendColor(accent, 0.92)
    contentArea.BackgroundColor3 = blendColor(accent, 0.05)

    if themeTargets.contentStroke then
        themeTargets.contentStroke.Color = blendColor(accent, 0.45)
    end

    if themeTargets.headerLine then
        themeTargets.headerLine.BackgroundColor3 = blendColor(accent, 0.55)
        themeTargets.headerLine.BackgroundTransparency = 0.45
    end

    if themeTargets.resizeDot then
        themeTargets.resizeDot.BackgroundColor3 = blendColor(accent, 0.85)
    end
    if opacityFill then
        opacityFill.BackgroundColor3 = blendColor(accent, 0.85)
    end
    if flySpeedFill then
        flySpeedFill.BackgroundColor3 = blendColor(accent, 0.85)
    end
    if flyKeyBtn and waitingForKeybind ~= "fly" then
        flyKeyBtn.TextColor3 = accent
    end
    if themeTargets.flyKeyStroke and waitingForKeybind ~= "fly" then
        themeTargets.flyKeyStroke.Color = blendColor(accent, 0.85)
    end
    if flyToggleBtn then
        if settings.flyEnabled then
            flyToggleBtn.BackgroundColor3 = accent
            flyToggleBtn.TextColor3 = getAccentHoverTextColor(accent)
        else
            flyToggleBtn.BackgroundColor3 = UI.BG
            flyToggleBtn.TextColor3 = accent
        end
    end
    for _, btn in ipairs(playerFeatureButtons) do
        if btn and btn.Parent then
            if btn:GetAttribute("PlayerFeatureOn") then
                btn.BackgroundColor3 = accent
                btn.TextColor3 = getAccentHoverTextColor(accent)
            else
                btn.BackgroundColor3 = UI.BG
                btn.TextColor3 = accent
            end
        end
    end
    if keybindBtn and waitingForKeybind ~= "menu" then
        keybindBtn.TextColor3 = accent
    end
    if themeTargets.keybindStroke then
        themeTargets.keybindStroke.Color = blendColor(accent, 0.85)
    end
    if themeTargets.infoTitle then
        themeTargets.infoTitle.TextColor3 = accent
    end

    updateTabColors(nil, false)

    for i, btn in ipairs(colorButtons) do
        local selected = COLOR_PRESETS[i] == settings.accentColor
        local preset = COLOR_PRESETS[i]
        local isLight = preset.R > 0.9 and preset.G > 0.9 and preset.B > 0.9
        btn.UIStroke.Thickness = selected and 2 or 0
        btn.UIStroke.Transparency = selected and 0 or 1
        btn.UIStroke.Color = isLight and Color3.fromRGB(90, 90, 100) or Color3.fromRGB(255, 255, 255)
    end

    if deathTpKeyBtn and waitingForKeybind ~= "deathTp" then
        deathTpKeyBtn.TextColor3 = accent
    end
    if themeTargets.deathTpStroke and waitingForKeybind ~= "deathTp" then
        themeTargets.deathTpStroke.Color = blendColor(accent, 0.85)
    end
    if espKeyBtn and waitingForKeybind ~= "esp" then
        espKeyBtn.TextColor3 = accent
    end
    if themeTargets.espKeyStroke and waitingForKeybind ~= "esp" then
        themeTargets.espKeyStroke.Color = blendColor(accent, 0.85)
    end
    if espToggleBtn then
        if settings.espEnabled then
            espToggleBtn.BackgroundColor3 = accent
            espToggleBtn.TextColor3 = getAccentHoverTextColor(accent)
        else
            espToggleBtn.BackgroundColor3 = UI.BG
            espToggleBtn.TextColor3 = accent
        end
    end
    for _, btn in ipairs(espFeatureButtons) do
        if btn and btn.Parent then
            if btn:GetAttribute("EspFeatureOn") then
                btn.BackgroundColor3 = accent
                btn.TextColor3 = getAccentHoverTextColor(accent)
            else
                btn.BackgroundColor3 = UI.BG
                btn.TextColor3 = accent
            end
        end
    end
    for _, btn in ipairs(themeTargets.tpAccentButtons or {}) do
        if btn and btn.Parent then
            if btn:GetAttribute("LocationSaved") then
                btn.BackgroundColor3 = accent
                btn.TextColor3 = getAccentHoverTextColor(accent)
            else
                btn.TextColor3 = accent
            end
        end
    end

    for _, title in ipairs(themeTargets.tpSectionTitles or {}) do
        if title and title.Parent then
            title.TextColor3 = accent
        end
    end

    for _, line in ipairs(themeTargets.tpDividers or {}) do
        if line and line.Parent then
            line.BackgroundColor3 = blendColor(accent, 0.55)
        end
    end

    for _, stroke in ipairs(themeTargets.tpPlayerRowStrokes or {}) do
        if stroke and stroke.Parent then
            stroke.Color = blendColor(accent, 0.45)
        end
    end

    for _, item in ipairs(themeTargets.tpLocationInputs or {}) do
        if item.input and item.input.Parent then
            item.input.TextColor3 = blendColor(accent, 0.9)
            item.input.PlaceholderColor3 = blendColor(accent, 0.55)
        end
        if item.stroke and item.stroke.Parent then
            item.stroke.Color = blendColor(accent, 0.7)
        end
    end

    applyMenuOpacity(settings.menuOpacity)

    if refreshEspColors then
        refreshEspColors()
    end
end

-- ═══════════════════════════════════════
--  TELEPORT
-- ═══════════════════════════════════════

local lastDeathCFrame = nil
themeTargets.tpAccentButtons = {}
themeTargets.tpLocationInputs = {}
themeTargets.tpSectionTitles = {}
themeTargets.tpDividers = {}
themeTargets.tpPlayerRowStrokes = {}

local function getCharacterRoot()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function teleportToCFrame(cf)
    if not cf then
        return
    end

    local root = getCharacterRoot()
    if root then
        root.CFrame = cf + Vector3.new(0, 3, 0)
    end
end

local function teleportToDeath()
    teleportToCFrame(lastDeathCFrame)
end

local function hookDeathTracking(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then
        return
    end

    humanoid.Died:Connect(function()
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            lastDeathCFrame = root.CFrame
        end
    end)
end

if LocalPlayer.Character then
    task.spawn(hookDeathTracking, LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(character)
    hookDeathTracking(character)
end)

local function addAccentButtonHover(btn)
    btn.MouseEnter:Connect(function()
        if btn:GetAttribute("LocationSaved") then
            return
        end
        tween(btn, {
            BackgroundColor3 = settings.accentColor,
            TextColor3 = getAccentHoverTextColor(settings.accentColor),
        }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        if btn:GetAttribute("LocationSaved") then
            return
        end
        tween(btn, {
            BackgroundColor3 = UI.BG,
            TextColor3 = settings.accentColor,
        }, 0.15)
    end)
end

local function setSaveBtnSaved(saveBtn, saved)
    saveBtn:SetAttribute("LocationSaved", saved)
    saveBtn.Active = not saved
    if saved then
        saveBtn.Text = "LOCATION SUCCESSFULLY SET"
        saveBtn.TextSize = 9
        saveBtn.BackgroundColor3 = settings.accentColor
        saveBtn.TextColor3 = getAccentHoverTextColor(settings.accentColor)
    else
        saveBtn.Text = "SAVE LOCATION"
        saveBtn.TextSize = UI.BTN_TEXT
        saveBtn.BackgroundColor3 = UI.BG
        saveBtn.TextColor3 = settings.accentColor
    end
end

local function styleTpAccentButton(btn)
    btn.BackgroundColor3 = UI.BG
    btn.TextColor3 = settings.accentColor
    btn.TextSize = UI.BTN_TEXT
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    makeCorner(btn, UI.CORNER)
    addAccentButtonHover(btn)
    table.insert(themeTargets.tpAccentButtons, btn)
    return btn
end

local TP_PLAYER_TP_W = 68

local function makeTpSection(parent, layoutOrder)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundTransparency = 1
    section.LayoutOrder = layoutOrder
    section.ZIndex = 3
    section.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = section

    return section, layout
end

local function makeTpSectionTitle(parent, text, layoutOrder)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = settings.accentColor
    label.TextSize = UI.SECTION_TEXT
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.LayoutOrder = layoutOrder
    label.ZIndex = 3
    label.Parent = parent
    table.insert(themeTargets.tpSectionTitles, label)
    return label
end

local function makeTpDivider(parent, layoutOrder)
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.BackgroundColor3 = blendColor(settings.accentColor, 0.55)
    line.BackgroundTransparency = 0.55
    line.BorderSizePixel = 0
    line.LayoutOrder = layoutOrder
    line.ZIndex = 3
    line.Parent = parent
    table.insert(themeTargets.tpDividers, line)
    return line
end

local function makeTpKeybindRow(parent, labelText, layoutOrder)
    local row = Instance.new("Frame")
    row.Name = "KeybindRow"
    row.Size = UDim2.new(1, 0, 0, UI.ROW_H)
    row.BackgroundTransparency = 1
    row.LayoutOrder = layoutOrder
    row.ZIndex = 3
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -(UI.KEYBIND_W + 8), 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = UI.TEXT_MUTED
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextWrapped = true
    label.ZIndex = 3
    label.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, UI.KEYBIND_W, 1, 0)
    btn.Position = UDim2.new(1, -UI.KEYBIND_W, 0, 0)
    btn.BackgroundColor3 = UI.BG
    btn.TextSize = UI.BTN_TEXT
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 3
    btn.Parent = row
    makeCorner(btn, UI.CORNER)

    return btn, label, row
end

local function makeTpFullWidthButton(parent, text, layoutOrder)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, UI.ROW_H)
    wrap.BackgroundTransparency = 1
    wrap.LayoutOrder = layoutOrder
    wrap.ZIndex = 3
    wrap.Parent = parent

    local btn = makePanelButton(wrap, text, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
    styleTpAccentButton(btn)
    return btn, wrap
end

local LOCATION_INPUT_H = UI.ROW_H
local LOCATION_GAP = 6
local LOCATION_ENTRY_H = LOCATION_INPUT_H + LOCATION_GAP + UI.ROW_H + 6
local locationEntries = {}

local function makeTpLocationInput(parent)
    local accent = settings.accentColor
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, 0, 0, LOCATION_INPUT_H)
    input.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    input.Text = ""
    input.PlaceholderText = "NAME YOUR LOCATION"
    input.TextColor3 = blendColor(accent, 0.9)
    input.PlaceholderColor3 = blendColor(accent, 0.55)
    input.TextSize = UI.INPUT_TEXT
    input.Font = Enum.Font.GothamBold
    input.ClearTextOnFocus = false
    input.TextXAlignment = Enum.TextXAlignment.Center
    input.TextYAlignment = Enum.TextYAlignment.Center
    input.BorderSizePixel = 0
    input.ZIndex = 3
    input.Parent = parent
    makeCorner(input, UI.CORNER)
    local stroke = makeStroke(input, blendColor(accent, 0.7), 1, 0.3)
    table.insert(themeTargets.tpLocationInputs, { input = input, stroke = stroke })
    return input
end

local function relayoutLocationEntries(listContainer)
    local totalH = math.max(0, #locationEntries * LOCATION_ENTRY_H)
    for idx, entry in ipairs(locationEntries) do
        entry.frame.Position = UDim2.new(0, 0, 0, (idx - 1) * LOCATION_ENTRY_H)
    end
    listContainer.Size = UDim2.new(1, 0, 0, totalH)
    if updateTpScrollSize then
        updateTpScrollSize()
    end
end

local function createLocationEntry(listContainer)
    local entryFrame = Instance.new("Frame")
    entryFrame.Name = "LocationEntry"
    entryFrame.Size = UDim2.new(1, 0, 0, LOCATION_ENTRY_H)
    entryFrame.BackgroundTransparency = 1
    entryFrame.ZIndex = 3
    entryFrame.Parent = listContainer

    local nameInput = makeTpLocationInput(entryFrame)
    nameInput.Position = UDim2.new(0, 0, 0, 0)

    local btnGap = 6
    local saveBtn = makePanelButton(
        entryFrame,
        "SAVE LOCATION",
        UDim2.new(0.5, -btnGap / 2, 0, UI.ROW_H),
        UDim2.new(0, 0, 0, LOCATION_INPUT_H + LOCATION_GAP)
    )
    styleTpAccentButton(saveBtn)

    local tpBtn = makePanelButton(
        entryFrame,
        "TP",
        UDim2.new(0.5, -btnGap / 2, 0, UI.ROW_H),
        UDim2.new(0.5, btnGap / 2, 0, LOCATION_INPUT_H + LOCATION_GAP)
    )
    styleTpAccentButton(tpBtn)

    local entry = {
        frame = entryFrame,
        nameInput = nameInput,
        saveBtn = saveBtn,
        savedCFrame = nil,
        saved = false,
    }

    saveBtn.MouseButton1Click:Connect(function()
        if entry.saved then
            return
        end

        local root = getCharacterRoot()
        if root then
            entry.savedCFrame = root.CFrame
            entry.saved = true
            setSaveBtnSaved(saveBtn, true)
        end
    end)

    tpBtn.MouseButton1Click:Connect(function()
        teleportToCFrame(entry.savedCFrame)
    end)

    table.insert(locationEntries, entry)
    relayoutLocationEntries(listContainer)
    return entry
end

local function removeLastLocationEntry(listContainer)
    if #locationEntries == 0 then
        return
    end

    local entry = table.remove(locationEntries)
    if entry.nameInput then
        for idx, item in ipairs(themeTargets.tpLocationInputs) do
            if item.input == entry.nameInput then
                table.remove(themeTargets.tpLocationInputs, idx)
                break
            end
        end
    end
    entry.frame:Destroy()
    relayoutLocationEntries(listContainer)
end

local PLAYER_ROW_H = UI.ROW_H + 4
local playerListRows = {}
local playerListContainer
local tpScrollFrame
local tpContentContainer
local tpListLayout
local updateTpScrollSize
local playerListBuilt = false

local function getPlayerRoot(player)
    local character = player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function teleportToPlayer(player)
    if not player or player == LocalPlayer then
        return
    end

    local root = getPlayerRoot(player)
    if root then
        teleportToCFrame(root.CFrame)
    end
end

local function getDistanceToPlayer(player)
    local myRoot = getCharacterRoot()
    local theirRoot = getPlayerRoot(player)
    if myRoot and theirRoot then
        return (myRoot.Position - theirRoot.Position).Magnitude
    end
    return nil
end

local function getPlayerStatsText(player)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hpText = "HP: N/A"
    if humanoid then
        hpText = string.format("HP: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
    end

    local dist = getDistanceToPlayer(player)
    local distText = dist and string.format("%dm", math.floor(dist + 0.5)) or "DIST: N/A"
    return hpText .. "  |  " .. distText
end

updateTpScrollSize = function()
    if tpListLayout and tpScrollFrame and tpContentContainer then
        local h = tpListLayout.AbsoluteContentSize.Y + 16
        tpContentContainer.Size = UDim2.new(1, -4, 0, h)
        tpScrollFrame.CanvasSize = UDim2.new(0, 0, 0, h)
    end
end

local settingsScrollFrame
local settingsContentContainer
local settingsListLayout

local function updateSettingsScrollSize()
    if settingsListLayout and settingsScrollFrame and settingsContentContainer then
        local h = settingsListLayout.AbsoluteContentSize.Y + 16
        settingsContentContainer.Size = UDim2.new(1, -4, 0, h)
        settingsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, h)
    end
end

local function relayoutPlayerList()
    if not playerListContainer then
        return
    end

    local count = 0
    for _, row in ipairs(playerListRows) do
        if row.player then
            count = count + 1
        end
    end

    local totalH = count > 0 and (count * PLAYER_ROW_H) or 28
    playerListContainer.Size = UDim2.new(1, 0, 0, totalH)
    updateTpScrollSize()
end

local function createPlayerRow(player, index)
    local row = Instance.new("Frame")
    row.Name = "PlayerRow_" .. player.Name
    row.Size = UDim2.new(1, 0, 0, PLAYER_ROW_H)
    row.Position = UDim2.new(0, 0, 0, (index - 1) * PLAYER_ROW_H)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    row.BackgroundTransparency = 0.2
    row.BorderSizePixel = 0
    row.ZIndex = 3
    row.Parent = playerListContainer
    makeCorner(row, UI.CORNER)
    local rowStroke = makeStroke(row, blendColor(settings.accentColor, 0.45), 1, 0.7)
    table.insert(themeTargets.tpPlayerRowStrokes, rowStroke)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.34, -6, 1, 0)
    nameLbl.Position = UDim2.new(0, 8, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = player.DisplayName
    nameLbl.TextColor3 = UI.TEXT_MUTED
    nameLbl.TextSize = 10
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextYAlignment = Enum.TextYAlignment.Center
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.ZIndex = 4
    nameLbl.Parent = row

    local statsLbl = Instance.new("TextLabel")
    statsLbl.Size = UDim2.new(0.36, -4, 1, 0)
    statsLbl.Position = UDim2.new(0.34, 0, 0, 0)
    statsLbl.BackgroundTransparency = 1
    statsLbl.Text = getPlayerStatsText(player)
    statsLbl.TextColor3 = UI.TEXT_DIM
    statsLbl.TextSize = 9
    statsLbl.Font = Enum.Font.Gotham
    statsLbl.TextXAlignment = Enum.TextXAlignment.Left
    statsLbl.TextYAlignment = Enum.TextYAlignment.Center
    statsLbl.ZIndex = 4
    statsLbl.Parent = row

    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0, TP_PLAYER_TP_W, 0, UI.ROW_H - 6)
    tpBtn.Position = UDim2.new(1, -(TP_PLAYER_TP_W + 6), 0.5, -(UI.ROW_H - 6) / 2)
    tpBtn.BackgroundColor3 = UI.BG
    tpBtn.Text = "TELEPORT"
    tpBtn.TextSize = 9
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.AutoButtonColor = false
    tpBtn.BorderSizePixel = 0
    tpBtn.ZIndex = 4
    tpBtn.Parent = row
    styleTpAccentButton(tpBtn)

    tpBtn.MouseButton1Click:Connect(function()
        teleportToPlayer(player)
    end)

    return { frame = row, player = player, nameLbl = nameLbl, statsLbl = statsLbl, tpBtn = tpBtn }
end

local function rebuildPlayerList()
    if not playerListContainer then
        return
    end

    for _, row in ipairs(playerListRows) do
        if row.frame then
            row.frame:Destroy()
        end
    end
    playerListRows = {}

    local index = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            index = index + 1
            table.insert(playerListRows, createPlayerRow(player, index))
        end
    end

    if index == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 28)
        empty.BackgroundTransparency = 1
        empty.Text = "No other players in server"
        empty.TextColor3 = UI.TEXT_DIM
        empty.TextSize = 10
        empty.Font = Enum.Font.Gotham
        empty.TextXAlignment = Enum.TextXAlignment.Center
        empty.TextYAlignment = Enum.TextYAlignment.Center
        empty.ZIndex = 3
        empty.Parent = playerListContainer
        table.insert(playerListRows, { frame = empty, player = nil })
    end

    relayoutPlayerList()
end

local function updatePlayerListStats()
    for _, row in ipairs(playerListRows) do
        if row.player and row.player.Parent and row.statsLbl and row.statsLbl.Parent then
            row.statsLbl.Text = getPlayerStatsText(row.player)
        end
    end
end

local function initPlayerListListeners()
    if playerListBuilt then
        return
    end
    playerListBuilt = true

    Players.PlayerAdded:Connect(function()
        task.defer(rebuildPlayerList)
    end)

    Players.PlayerRemoving:Connect(function()
        task.defer(rebuildPlayerList)
    end)

    task.spawn(function()
        while playerListContainer and playerListContainer.Parent do
            updatePlayerListStats()
            task.wait(0.3)
        end
    end)
end

-- ═══════════════════════════════════════
--  ESP
-- ═══════════════════════════════════════

local espFolder = Instance.new("Folder")
espFolder.Name = "DM_ESP"
espFolder.Parent = workspace

local espObjects = {}
local playerActivity = {}
local refreshEspColors

local ESP_RED = Color3.fromRGB(255, 55, 55)

local function getEspHealthColor(humanoid)
    local accent = settings.accentColor
    if not humanoid or humanoid.MaxHealth <= 0 then
        return accent
    end

    local ratio = humanoid.Health / humanoid.MaxHealth
    if ratio >= 0.35 then
        return accent
    end

    return lerpColor(ESP_RED, accent, ratio / 0.35)
end

local function trackPlayerActivity(player, character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end

    local track = playerActivity[player]
    if not track then
        track = { lastMove = tick(), lastPos = hrp.Position }
        playerActivity[player] = track
    else
        if (hrp.Position - track.lastPos).Magnitude > 0.08 then
            track.lastMove = tick()
            track.lastPos = hrp.Position
        end
    end
end

local function isPlayerAfk(player)
    if player == LocalPlayer then
        return not UserInputService.WindowFocused
    end

    local track = playerActivity[player]
    if not track then
        return false
    end

    return (tick() - track.lastMove) >= 3
end

local function getDistanceToCharacter(character)
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local theirRoot = character and character:FindFirstChild("HumanoidRootPart")
    if myRoot and theirRoot then
        return math.floor((myRoot.Position - theirRoot.Position).Magnitude + 0.5)
    end
    return nil
end

local function clearEsp(player)
    local data = espObjects[player]
    if not data then
        return
    end

    if data.highlight then
        data.highlight:Destroy()
    end
    if data.box then
        data.box:Destroy()
    end
    if data.billboard then
        data.billboard:Destroy()
    end
    if data.folder then
        data.folder:Destroy()
    end

    espObjects[player] = nil
end

local function updateEspBillboard(data, player, character, humanoid, color)
    if not data.billboard then
        return
    end

    local lines = {}
    if settings.espName then
        table.insert(lines, player.DisplayName)
    end
    if settings.espHp and humanoid then
        table.insert(lines, string.format("HP: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth)))
    end
    if settings.espDistance then
        local dist = getDistanceToCharacter(character)
        if dist then
            table.insert(lines, dist .. "m")
        end
    end
    if settings.espAfk and isPlayerAfk(player) then
        table.insert(lines, "AFK")
    end

    data.billboard.Enabled = #lines > 0
    for i, label in ipairs(data.labels) do
        local text = lines[i]
        if text then
            label.Visible = true
            label.Text = text
            if text == "AFK" then
                label.TextColor3 = ESP_RED
            else
                label.TextColor3 = color
            end
        else
            label.Visible = false
        end
    end
end

local function updateEspForPlayer(player)
    local data = espObjects[player]
    local character = player.Character

    if not character then
        return
    end

    if not data or data.character ~= character then
        if character:FindFirstChildOfClass("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
            setupEspForPlayer(player)
        end
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then
        return
    end

    trackPlayerActivity(player, character)

    local color = getEspHealthColor(humanoid)
    local active = settings.espEnabled
    local _, size = character:GetBoundingBox()

    if data.highlight and data.highlight.Parent then
        data.highlight.Enabled = active
        data.highlight.Adornee = character
        data.highlight.OutlineColor = color
        data.highlight.FillColor = color
    end

    if data.box and data.box.Parent then
        data.box.Visible = active and settings.espBox
        data.box.Color3 = color
        data.box.Size = size
    end

    if data.billboard and data.billboard.Parent then
        data.billboard.Adornee = hrp
        data.billboard.StudsOffset = Vector3.new(0, -(size.Y / 2 + 1.2), 0)
    end

    updateEspBillboard(data, player, character, humanoid, color)
end

local function setupEspForPlayer(player)
    clearEsp(player)

    if not settings.espEnabled or player == LocalPlayer then
        return
    end

    local character = player.Character
    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then
        return
    end

    local _, size = character:GetBoundingBox()

    local folder = Instance.new("Folder")
    folder.Name = "ESP_" .. player.Name
    folder.Parent = espFolder

    local color = getEspHealthColor(humanoid)

    local highlight = Instance.new("Highlight")
    highlight.Name = "Wallhack"
    highlight.Adornee = character
    highlight.FillTransparency = 0.78
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.OutlineColor = color
    highlight.FillColor = color
    highlight.Parent = character

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "Box"
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = size
    box.Color3 = color
    box.Transparency = 0.65
    box.Parent = hrp

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Info"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 140, 0, 64)
    billboard.StudsOffset = Vector3.new(0, -(size.Y / 2 + 1.2), 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = hrp

    local list = Instance.new("UIListLayout")
    list.FillDirection = Enum.FillDirection.Vertical
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.VerticalAlignment = Enum.VerticalAlignment.Center
    list.Padding = UDim.new(0, 1)
    list.Parent = billboard

    local labels = {}
    for _ = 1, 4 do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 12)
        label.BackgroundTransparency = 1
        label.TextSize = 11
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 0.4
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Visible = false
        label.Parent = billboard
        table.insert(labels, label)
    end

    espObjects[player] = {
        folder = folder,
        character = character,
        highlight = highlight,
        box = box,
        billboard = billboard,
        labels = labels,
    }

    updateEspForPlayer(player)
end

local function refreshAllEsp()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if settings.espEnabled then
                if player.Character then
                    if not espObjects[player] or espObjects[player].character ~= player.Character then
                        setupEspForPlayer(player)
                    else
                        updateEspForPlayer(player)
                    end
                else
                    clearEsp(player)
                end
            else
                clearEsp(player)
            end
        end
    end
end

refreshEspColors = function()
    for player in pairs(espObjects) do
        updateEspForPlayer(player)
    end
end

local function setEspEnabled(enabled)
    settings.espEnabled = enabled
    if espToggleBtn then
        espToggleBtn.Text = enabled and "ESP · ON" or "ESP · OFF"
    end
    applyTheme()
    refreshAllEsp()
end

local function toggleEsp()
    setEspEnabled(not settings.espEnabled)
end

local function setEspFeatureBtn(btn, key, active)
    settings[key] = active
    btn:SetAttribute("EspFeatureOn", active)
    if active then
        btn.BackgroundColor3 = settings.accentColor
        btn.TextColor3 = getAccentHoverTextColor(settings.accentColor)
    else
        btn.BackgroundColor3 = UI.BG
        btn.TextColor3 = settings.accentColor
    end
    refreshAllEsp()
end

local function makeEspFeatureButton(parent, text, settingKey, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, UI.ROW_H)
    btn.BackgroundColor3 = UI.BG
    btn.Text = text
    btn.TextSize = UI.BTN_TEXT
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = layoutOrder
    btn.ZIndex = 3
    btn.Parent = parent
    makeCorner(btn, UI.CORNER)

    setEspFeatureBtn(btn, settingKey, settings[settingKey])
    table.insert(espFeatureButtons, btn)

    btn.MouseButton1Click:Connect(function()
        setEspFeatureBtn(btn, settingKey, not settings[settingKey])
    end)

    return btn
end

local function hookEspPlayer(player)
    if player == LocalPlayer then
        return
    end

    player.CharacterAdded:Connect(function(character)
        task.spawn(function()
            character:WaitForChild("Humanoid", 10)
            character:WaitForChild("HumanoidRootPart", 10)
            if settings.espEnabled then
                setupEspForPlayer(player)
            else
                clearEsp(player)
            end
        end)
    end)

    player.CharacterRemoving:Connect(function()
        clearEsp(player)
    end)

    if settings.espEnabled and player.Character then
        task.defer(function()
            setupEspForPlayer(player)
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    playerActivity[player] = nil
    hookEspPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
    clearEsp(player)
    playerActivity[player] = nil
end)

for _, player in ipairs(Players:GetPlayers()) do
    hookEspPlayer(player)
end

RunService.Heartbeat:Connect(function()
    if not settings.espEnabled then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character then
                updateEspForPlayer(player)
            else
                clearEsp(player)
            end
        end
    end
end)

UserInputService.WindowFocused:Connect(function()
    if settings.espEnabled then
        refreshEspColors()
    end
end)

UserInputService.WindowFocusReleased:Connect(function()
    if settings.espEnabled then
        refreshEspColors()
    end
end)

-- ═══════════════════════════════════════
--  PLAYER
-- ═══════════════════════════════════════

local flyBodyVelocity
local flyBodyGyro
local flyConnection
local noclipConnection

local function getHumanoid()
    local character = LocalPlayer.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function cleanupFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.PlatformStand = false
    end
end

local function getFlyMoveVector()
    local camera = Workspace.CurrentCamera
    if not camera then
        return Vector3.zero
    end

    local move = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        move += camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        move -= camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        move -= camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        move += camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        move += Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        move -= Vector3.new(0, 1, 0)
    end

    if move.Magnitude > 0 then
        return move.Unit * settings.flySpeed
    end
    return Vector3.zero
end

local function startFly()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = getHumanoid()
    if not hrp or not humanoid then
        return
    end

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end

    humanoid.PlatformStand = true

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Name = "DM_FlyVelocity"
    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVelocity.Velocity = Vector3.zero
    flyBodyVelocity.Parent = hrp

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.Name = "DM_FlyGyro"
    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBodyGyro.P = 10000
    flyBodyGyro.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        if not settings.flyEnabled then
            return
        end

        local root = getCharacterRoot()
        local hum = getHumanoid()
        local cam = Workspace.CurrentCamera
        if not root or not hum or not cam or not flyBodyVelocity or not flyBodyGyro then
            return
        end

        if flyBodyVelocity.Parent ~= root then
            flyBodyVelocity.Parent = root
        end
        if flyBodyGyro.Parent ~= root then
            flyBodyGyro.Parent = root
        end

        flyBodyVelocity.Velocity = getFlyMoveVector()
        flyBodyGyro.CFrame = cam.CFrame
    end)
end

local function setFlyEnabled(enabled)
    settings.flyEnabled = enabled
    if flyToggleBtn then
        flyToggleBtn.Text = enabled and "FLY · ON" or "FLY · OFF"
    end
    if enabled then
        startFly()
    else
        cleanupFly()
    end
    applyTheme()
end

local function toggleFly()
    setFlyEnabled(not settings.flyEnabled)
end

local function setNoclipEnabled(enabled)
    settings.noclipEnabled = enabled
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if not character then
                return
            end
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function performClickTeleport()
    if not settings.clickTeleportEnabled then
        return
    end
    if not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and not UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
        return
    end

    local camera = Workspace.CurrentCamera
    if not camera then
        return
    end

    local mousePos = UserInputService:GetMouseLocation()
    local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local character = LocalPlayer.Character
    params.FilterDescendantsInstances = character and { character } or {}

    local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    if result then
        teleportToCFrame(CFrame.new(result.Position))
    end
end

local function setPlayerFeatureBtn(btn, key, active)
    settings[key] = active
    btn:SetAttribute("PlayerFeatureOn", active)

    if key == "noclipEnabled" then
        setNoclipEnabled(active)
    elseif key == "clickTeleportEnabled" then
        settings.clickTeleportEnabled = active
    end

    applyTheme()
end

local function makePlayerFeatureButton(parent, text, settingKey, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, UI.ROW_H)
    btn.BackgroundColor3 = UI.BG
    btn.Text = text
    btn.TextSize = UI.BTN_TEXT
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = layoutOrder
    btn.ZIndex = 3
    btn.Parent = parent
    makeCorner(btn, UI.CORNER)

    setPlayerFeatureBtn(btn, settingKey, settings[settingKey])
    table.insert(playerFeatureButtons, btn)

    btn.MouseButton1Click:Connect(function()
        setPlayerFeatureBtn(btn, settingKey, not settings[settingKey])
    end)

    return btn
end

local function hookPlayerCharacter(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then
        return
    end

    if settings.flyEnabled then
        task.defer(startFly)
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    local wasFlying = settings.flyEnabled
    cleanupFly()

    if wasFlying then
        task.defer(function()
            hookPlayerCharacter(character)
        end)
    end
end)

function cleanupPlayerFeatures()
    cleanupFly()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

updatePlayerScrollSize = function()
    if playerListLayout and playerScrollFrame and playerContentContainer then
        local h = playerListLayout.AbsoluteContentSize.Y + 16
        playerContentContainer.Size = UDim2.new(1, -4, 0, h)
        playerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, h)
    end
end

updateEspScrollSize = function()
    if espListLayout and espScrollFrame and espContentContainer then
        local h = espListLayout.AbsoluteContentSize.Y + 16
        espContentContainer.Size = UDim2.new(1, -4, 0, h)
        espScrollFrame.CanvasSize = UDim2.new(0, 0, 0, h)
    end
end

for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab" .. i
    tabBtn.Size = UDim2.new(0, TAB_WIDTH, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(140, 140, 150)
    tabBtn.TextSize = 11
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.AutoButtonColor = false
    tabBtn.BorderSizePixel = 0
    tabBtn.ZIndex = 3
    tabBtn.Parent = tabBar
    makeCorner(tabBtn, 6)

    tabButtons[i] = tabBtn

    local content = Instance.new("Frame")
    content.Name = "Content" .. i
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = i == 1
    content.ZIndex = 2
    content.Parent = contentArea
    tabContents[i] = content

    if i == 1 then
        -- PLAYER tab
        playerScrollFrame = Instance.new("ScrollingFrame")
        playerScrollFrame.Name = "PlayerScroll"
        playerScrollFrame.Size = UDim2.new(1, 0, 1, 0)
        playerScrollFrame.BackgroundTransparency = 1
        playerScrollFrame.BorderSizePixel = 0
        playerScrollFrame.ScrollBarThickness = 4
        playerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        playerScrollFrame.ZIndex = 3
        playerScrollFrame.Parent = content

        playerContentContainer = Instance.new("Frame")
        playerContentContainer.Name = "PlayerContainer"
        playerContentContainer.Size = UDim2.new(1, -4, 0, 0)
        playerContentContainer.BackgroundTransparency = 1
        playerContentContainer.ZIndex = 3
        playerContentContainer.Parent = playerScrollFrame

        playerListLayout = Instance.new("UIListLayout")
        playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        playerListLayout.Padding = UDim.new(0, 12)
        playerListLayout.Parent = playerContentContainer

        local playerPadding = Instance.new("UIPadding")
        playerPadding.PaddingLeft = UDim.new(0, UI.MARGIN)
        playerPadding.PaddingRight = UDim.new(0, UI.MARGIN)
        playerPadding.PaddingTop = UDim.new(0, 6)
        playerPadding.PaddingBottom = UDim.new(0, 10)
        playerPadding.Parent = playerContentContainer

        playerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updatePlayerScrollSize)

        local profileSection = makeTpSection(playerContentContainer, 1)
        makeTpSectionTitle(profileSection, "PROFILE", 1)
        makeTpDivider(profileSection, 2)

        local profileWrap = Instance.new("Frame")
        profileWrap.Size = UDim2.new(1, 0, 0, 108)
        profileWrap.BackgroundTransparency = 1
        profileWrap.LayoutOrder = 3
        profileWrap.ZIndex = 3
        profileWrap.Parent = profileSection

        local avatarFrame = Instance.new("Frame")
        avatarFrame.Size = UDim2.new(0, 76, 0, 76)
        avatarFrame.Position = UDim2.new(0.5, -38, 0, 0)
        avatarFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        avatarFrame.BorderSizePixel = 0
        avatarFrame.ZIndex = 3
        avatarFrame.Parent = profileWrap
        makeCorner(avatarFrame, UI.CORNER)
        makeStroke(avatarFrame, blendColor(settings.accentColor, 0.45), 1, 0.5)

        local avatarImage = Instance.new("ImageLabel")
        avatarImage.Size = UDim2.new(1, -6, 1, -6)
        avatarImage.Position = UDim2.new(0, 3, 0, 3)
        avatarImage.BackgroundTransparency = 1
        avatarImage.ScaleType = Enum.ScaleType.Fit
        avatarImage.ZIndex = 4
        avatarImage.Parent = avatarFrame
        makeCorner(avatarImage, UI.CORNER)

        playerStatusLabel = Instance.new("TextLabel")
        playerStatusLabel.Size = UDim2.new(1, 0, 0, 18)
        playerStatusLabel.Position = UDim2.new(0, 0, 1, -18)
        playerStatusLabel.BackgroundTransparency = 1
        playerStatusLabel.Text = "STATUS: ACTIVE"
        playerStatusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
        playerStatusLabel.TextSize = 11
        playerStatusLabel.Font = Enum.Font.GothamBold
        playerStatusLabel.TextXAlignment = Enum.TextXAlignment.Center
        playerStatusLabel.ZIndex = 3
        playerStatusLabel.Parent = profileWrap

        task.spawn(function()
            local ok, url = pcall(function()
                return Players:GetUserThumbnailAsync(
                    LocalPlayer.UserId,
                    Enum.ThumbnailType.AvatarThumbnail,
                    Enum.ThumbnailSize.Size150x150
                )
            end)
            if ok and avatarImage.Parent then
                avatarImage.Image = url
            end
        end)

        local flySection = makeTpSection(playerContentContainer, 2)
        makeTpSectionTitle(flySection, "FLY", 1)
        makeTpDivider(flySection, 2)

        flyKeyBtn = makeTpKeybindRow(flySection, "TOGGLE FLY : KEYBIND", 3)
        flyKeyBtn.Name = "FlyKeybind"
        flyKeyBtn.Text = settings.flyKey.Name
        flyKeyBtn.TextColor3 = settings.accentColor
        themeTargets.flyKeyStroke = makeStroke(flyKeyBtn, blendColor(settings.accentColor, 0.85), 1, 0.5)

        flyKeyBtn.MouseButton1Click:Connect(function()
            waitingForKeybind = "fly"
            flyKeyBtn.Text = "..."
            flyKeyBtn.TextColor3 = Color3.fromRGB(255, 200, 80)
        end)

        flyToggleBtn = makeTpFullWidthButton(
            flySection,
            settings.flyEnabled and "FLY · ON" or "FLY · OFF",
            4
        )
        flyToggleBtn.Name = "FlyToggle"
        for idx, btn in ipairs(themeTargets.tpAccentButtons) do
            if btn == flyToggleBtn then
                table.remove(themeTargets.tpAccentButtons, idx)
                break
            end
        end
        flyToggleBtn.MouseButton1Click:Connect(function()
            toggleFly()
        end)

        local flySpeedWrap = Instance.new("Frame")
        flySpeedWrap.Size = UDim2.new(1, 0, 0, 32)
        flySpeedWrap.BackgroundTransparency = 1
        flySpeedWrap.LayoutOrder = 5
        flySpeedWrap.ZIndex = 3
        flySpeedWrap.Parent = flySection

        local flySpeedTitle = Instance.new("TextLabel")
        flySpeedTitle.Size = UDim2.new(1, -40, 0, 14)
        flySpeedTitle.Position = UDim2.new(0, 0, 0, 0)
        flySpeedTitle.BackgroundTransparency = 1
        flySpeedTitle.Text = "FLY SPEED"
        flySpeedTitle.TextColor3 = UI.TEXT_DIM
        flySpeedTitle.TextSize = 11
        flySpeedTitle.Font = Enum.Font.Gotham
        flySpeedTitle.TextXAlignment = Enum.TextXAlignment.Left
        flySpeedTitle.ZIndex = 4
        flySpeedTitle.Parent = flySpeedWrap

        flySpeedLabel = Instance.new("TextLabel")
        flySpeedLabel.Size = UDim2.new(0, 36, 0, 14)
        flySpeedLabel.Position = UDim2.new(1, -36, 0, 0)
        flySpeedLabel.BackgroundTransparency = 1
        flySpeedLabel.Text = tostring(settings.flySpeed)
        flySpeedLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
        flySpeedLabel.TextSize = 11
        flySpeedLabel.Font = Enum.Font.Gotham
        flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Right
        flySpeedLabel.ZIndex = 4
        flySpeedLabel.Parent = flySpeedWrap

        local flySpeedTrack = Instance.new("TextButton")
        flySpeedTrack.Name = "FlySpeedTrack"
        flySpeedTrack.Size = UDim2.new(1, 0, 0, 16)
        flySpeedTrack.Position = UDim2.new(0, 0, 1, -16)
        flySpeedTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        flySpeedTrack.Text = ""
        flySpeedTrack.AutoButtonColor = false
        flySpeedTrack.BorderSizePixel = 0
        flySpeedTrack.Active = true
        flySpeedTrack.ZIndex = 3
        flySpeedTrack.Parent = flySpeedWrap
        makeCorner(flySpeedTrack, 4)

        local flySpeedBar = Instance.new("Frame")
        flySpeedBar.Size = UDim2.new(1, 0, 0, 8)
        flySpeedBar.Position = UDim2.new(0, 0, 0.5, -4)
        flySpeedBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        flySpeedBar.BorderSizePixel = 0
        flySpeedBar.Active = true
        flySpeedBar.ZIndex = 3
        flySpeedBar.Parent = flySpeedTrack
        makeCorner(flySpeedBar, 4)

        flySpeedFill = Instance.new("Frame")
        flySpeedFill.Name = "FlySpeedFill"
        flySpeedFill.BackgroundColor3 = blendColor(settings.accentColor, 0.85)
        flySpeedFill.BorderSizePixel = 0
        flySpeedFill.ZIndex = 4
        flySpeedFill.Parent = flySpeedBar
        makeCorner(flySpeedFill, 4)

        flySpeedKnob = Instance.new("Frame")
        flySpeedKnob.Name = "FlySpeedKnob"
        flySpeedKnob.Size = UDim2.new(0, 12, 0, 12)
        flySpeedKnob.AnchorPoint = Vector2.new(0.5, 0.5)
        flySpeedKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        flySpeedKnob.BorderSizePixel = 0
        flySpeedKnob.ZIndex = 5
        flySpeedKnob.Parent = flySpeedBar
        makeCorner(flySpeedKnob, 50)

        flySpeedSliderTrack = flySpeedTrack
        applyFlySpeed(settings.flySpeed)

        flySpeedTrack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                flySpeedDragging = true
                setFlySpeedFromX(input.Position.X)
            end
        end)

        flySpeedBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                flySpeedDragging = true
                setFlySpeedFromX(input.Position.X)
            end
        end)

        local modifiersSection = makeTpSection(playerContentContainer, 3)
        makeTpSectionTitle(modifiersSection, "MODIFIERS", 1)
        makeTpDivider(modifiersSection, 2)

        local modifiersList = Instance.new("Frame")
        modifiersList.Name = "ModifiersList"
        modifiersList.Size = UDim2.new(1, 0, 0, 0)
        modifiersList.AutomaticSize = Enum.AutomaticSize.Y
        modifiersList.BackgroundTransparency = 1
        modifiersList.LayoutOrder = 3
        modifiersList.ZIndex = 3
        modifiersList.Parent = modifiersSection

        local modifiersLayout = Instance.new("UIListLayout")
        modifiersLayout.SortOrder = Enum.SortOrder.LayoutOrder
        modifiersLayout.Padding = UDim.new(0, 4)
        modifiersLayout.Parent = modifiersList

        local playerFeatures = {
            { "NOCLIP", "noclipEnabled" },
            { "CLICK TELEPORT", "clickTeleportEnabled" },
        }

        for fi, feat in ipairs(playerFeatures) do
            makePlayerFeatureButton(modifiersList, feat[1], feat[2], fi)
        end

        applyTheme()
        task.defer(updatePlayerScrollSize)
    elseif i == 5 then
        -- INFO tab (always centered)
        local infoBody = Instance.new("Frame")
        infoBody.Name = "InfoBody"
        infoBody.Size = UDim2.new(1, 0, 1, -28)
        infoBody.BackgroundTransparency = 1
        infoBody.ZIndex = 3
        infoBody.Parent = content

        local infoLayout = Instance.new("UIListLayout")
        infoLayout.FillDirection = Enum.FillDirection.Vertical
        infoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        infoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        infoLayout.Padding = UDim.new(0, 10)
        infoLayout.Parent = infoBody

        local infoPadding = Instance.new("UIPadding")
        infoPadding.PaddingLeft = UDim.new(0, 12)
        infoPadding.PaddingRight = UDim.new(0, 12)
        infoPadding.Parent = infoBody

        local function makeInfoLabel(text, textSize, color, font, wrapped)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 0)
            label.AutomaticSize = Enum.AutomaticSize.Y
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = color
            label.TextSize = textSize
            label.Font = font or Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Center
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.TextWrapped = wrapped or false
            label.ZIndex = 3
            label.Parent = infoBody
            return label
        end

        local infoTitle = makeInfoLabel("MAYA : MADE BY NEDELCU", 22, settings.accentColor)
        themeTargets.infoTitle = infoTitle

        makeInfoLabel("V1.0.0", 16, UI.TEXT_DIM, Enum.Font.Gotham, false)

        makeInfoLabel(
            "THIS SCRIPT IS COMPLETELY FREE. IF YOU PAID FOR IT, YOU WERE SCAMMED.",
            11,
            Color3.fromRGB(255, 100, 100),
            Enum.Font.GothamBold,
            true
        )

        local infoIg = Instance.new("TextLabel")
        infoIg.Size = UDim2.new(1, 0, 0, 18)
        infoIg.Position = UDim2.new(0, 0, 1, -24)
        infoIg.BackgroundTransparency = 1
        infoIg.Text = "ig:@nedelcuthegoat"
        infoIg.TextColor3 = Color3.fromRGB(130, 130, 140)
        infoIg.TextSize = 10
        infoIg.Font = Enum.Font.Gotham
        infoIg.TextXAlignment = Enum.TextXAlignment.Center
        infoIg.TextYAlignment = Enum.TextYAlignment.Center
        infoIg.ZIndex = 3
        infoIg.Parent = content
    elseif i == 2 then
        -- ESP tab
        espScrollFrame = Instance.new("ScrollingFrame")
        espScrollFrame.Name = "EspScroll"
        espScrollFrame.Size = UDim2.new(1, 0, 1, 0)
        espScrollFrame.BackgroundTransparency = 1
        espScrollFrame.BorderSizePixel = 0
        espScrollFrame.ScrollBarThickness = 4
        espScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        espScrollFrame.ZIndex = 3
        espScrollFrame.Parent = content

        espContentContainer = Instance.new("Frame")
        espContentContainer.Name = "EspContainer"
        espContentContainer.Size = UDim2.new(1, -4, 0, 0)
        espContentContainer.BackgroundTransparency = 1
        espContentContainer.ZIndex = 3
        espContentContainer.Parent = espScrollFrame

        espListLayout = Instance.new("UIListLayout")
        espListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        espListLayout.Padding = UDim.new(0, 12)
        espListLayout.Parent = espContentContainer

        local espPad = Instance.new("UIPadding")
        espPad.PaddingLeft = UDim.new(0, UI.MARGIN)
        espPad.PaddingRight = UDim.new(0, UI.MARGIN)
        espPad.PaddingTop = UDim.new(0, 6)
        espPad.PaddingBottom = UDim.new(0, 10)
        espPad.Parent = espContentContainer

        espListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateEspScrollSize)

        local keySection = makeTpSection(espContentContainer, 1)
        makeTpSectionTitle(keySection, "ESP", 1)
        makeTpDivider(keySection, 2)

        espKeyBtn = makeTpKeybindRow(keySection, "SET ESP : KEYBIND", 3)
        espKeyBtn.Name = "EspKeybind"
        espKeyBtn.Text = settings.espKey.Name
        espKeyBtn.TextColor3 = settings.accentColor
        themeTargets.espKeyStroke = makeStroke(espKeyBtn, blendColor(settings.accentColor, 0.85), 1, 0.5)

        espKeyBtn.MouseButton1Click:Connect(function()
            waitingForKeybind = "esp"
            espKeyBtn.Text = "..."
            espKeyBtn.TextColor3 = Color3.fromRGB(255, 200, 80)
        end)

        espToggleBtn = makeTpFullWidthButton(
            keySection,
            settings.espEnabled and "ESP · ON" or "ESP · OFF",
            4
        )
        espToggleBtn.Name = "EspToggle"
        for idx, btn in ipairs(themeTargets.tpAccentButtons) do
            if btn == espToggleBtn then
                table.remove(themeTargets.tpAccentButtons, idx)
                break
            end
        end
        espToggleBtn.MouseButton1Click:Connect(function()
            toggleEsp()
        end)

        local optionsSection = makeTpSection(espContentContainer, 2)
        makeTpSectionTitle(optionsSection, "DISPLAY", 1)
        makeTpDivider(optionsSection, 2)

        local featuresList = Instance.new("Frame")
        featuresList.Name = "FeaturesList"
        featuresList.Size = UDim2.new(1, 0, 0, 0)
        featuresList.AutomaticSize = Enum.AutomaticSize.Y
        featuresList.BackgroundTransparency = 1
        featuresList.LayoutOrder = 3
        featuresList.ZIndex = 3
        featuresList.Parent = optionsSection

        local featureLayout = Instance.new("UIListLayout")
        featureLayout.SortOrder = Enum.SortOrder.LayoutOrder
        featureLayout.Padding = UDim.new(0, 4)
        featureLayout.Parent = featuresList

        local espFeatures = {
            { "BOX", "espBox" },
            { "NAME", "espName" },
            { "HP", "espHp" },
            { "DISTANCE", "espDistance" },
            { "AFK", "espAfk" },
        }

        for fi, feat in ipairs(espFeatures) do
            makeEspFeatureButton(featuresList, feat[1], feat[2], fi)
        end

        applyTheme()
        task.defer(updateEspScrollSize)
    elseif i == 3 then
        -- TP tab
        tpScrollFrame = Instance.new("ScrollingFrame")
        tpScrollFrame.Name = "TpScroll"
        tpScrollFrame.Size = UDim2.new(1, 0, 1, 0)
        tpScrollFrame.BackgroundTransparency = 1
        tpScrollFrame.BorderSizePixel = 0
        tpScrollFrame.ScrollBarThickness = 4
        tpScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tpScrollFrame.ZIndex = 3
        tpScrollFrame.Parent = content

        tpContentContainer = Instance.new("Frame")
        tpContentContainer.Name = "TpContainer"
        tpContentContainer.Size = UDim2.new(1, -4, 0, 0)
        tpContentContainer.BackgroundTransparency = 1
        tpContentContainer.ZIndex = 3
        tpContentContainer.Parent = tpScrollFrame

        tpListLayout = Instance.new("UIListLayout")
        tpListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tpListLayout.Padding = UDim.new(0, 12)
        tpListLayout.Parent = tpContentContainer

        local tpPadding = Instance.new("UIPadding")
        tpPadding.PaddingLeft = UDim.new(0, UI.MARGIN)
        tpPadding.PaddingRight = UDim.new(0, UI.MARGIN)
        tpPadding.PaddingTop = UDim.new(0, 6)
        tpPadding.PaddingBottom = UDim.new(0, 10)
        tpPadding.Parent = tpContentContainer

        tpListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTpScrollSize)

        -- Section 1: Death point
        local deathSection = makeTpSection(tpContentContainer, 1)
        makeTpSectionTitle(deathSection, "DEATH POINT", 1)
        makeTpDivider(deathSection, 2)

        deathTpKeyBtn = makeTpKeybindRow(deathSection, "TELEPORT TO DEATH POINT : KEYBIND", 3)
        deathTpKeyBtn.Name = "DeathTpKeybind"
        deathTpKeyBtn.Text = settings.deathTpKey.Name
        deathTpKeyBtn.TextColor3 = settings.accentColor
        themeTargets.deathTpStroke = makeStroke(deathTpKeyBtn, blendColor(settings.accentColor, 0.85), 1, 0.5)

        deathTpKeyBtn.MouseButton1Click:Connect(function()
            waitingForKeybind = "deathTp"
            deathTpKeyBtn.Text = "..."
            deathTpKeyBtn.TextColor3 = Color3.fromRGB(255, 200, 80)
        end)

        local deathTpBtn = makeTpFullWidthButton(deathSection, "TELEPORT TO DEATH POINT", 4)
        deathTpBtn.MouseButton1Click:Connect(function()
            teleportToDeath()
        end)

        -- Section 2: Save location
        local saveSection = makeTpSection(tpContentContainer, 2)
        themeTargets.saveLocationTitle = makeTpSectionTitle(saveSection, "SAVE YOUR LOCATION", 1)
        makeTpDivider(saveSection, 2)

        local btnRow = Instance.new("Frame")
        btnRow.Size = UDim2.new(1, 0, 0, UI.ICON_BTN)
        btnRow.BackgroundTransparency = 1
        btnRow.LayoutOrder = 3
        btnRow.ZIndex = 3
        btnRow.Parent = saveSection

        local btnRowLayout = Instance.new("UIListLayout")
        btnRowLayout.FillDirection = Enum.FillDirection.Horizontal
        btnRowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        btnRowLayout.Padding = UDim.new(0, 8)
        btnRowLayout.Parent = btnRow

        local addLocationBtn = Instance.new("TextButton")
        addLocationBtn.Name = "AddLocation"
        addLocationBtn.Size = UDim2.new(0, UI.ICON_BTN, 0, UI.ICON_BTN)
        addLocationBtn.BackgroundColor3 = UI.BG
        addLocationBtn.Text = "+"
        addLocationBtn.TextColor3 = settings.accentColor
        addLocationBtn.TextSize = 18
        addLocationBtn.Font = Enum.Font.GothamBold
        addLocationBtn.AutoButtonColor = false
        addLocationBtn.BorderSizePixel = 0
        addLocationBtn.ZIndex = 3
        addLocationBtn.Parent = btnRow
        makeCorner(addLocationBtn, UI.CORNER)
        addAccentButtonHover(addLocationBtn)
        table.insert(themeTargets.tpAccentButtons, addLocationBtn)

        local removeLocationBtn = Instance.new("TextButton")
        removeLocationBtn.Name = "RemoveLocation"
        removeLocationBtn.Size = UDim2.new(0, UI.ICON_BTN, 0, UI.ICON_BTN)
        removeLocationBtn.BackgroundColor3 = UI.BG
        removeLocationBtn.Text = "-"
        removeLocationBtn.TextColor3 = settings.accentColor
        removeLocationBtn.TextSize = 18
        removeLocationBtn.Font = Enum.Font.GothamBold
        removeLocationBtn.AutoButtonColor = false
        removeLocationBtn.BorderSizePixel = 0
        removeLocationBtn.ZIndex = 3
        removeLocationBtn.Parent = btnRow
        makeCorner(removeLocationBtn, UI.CORNER)
        addAccentButtonHover(removeLocationBtn)
        table.insert(themeTargets.tpAccentButtons, removeLocationBtn)

        local locationListContainer = Instance.new("Frame")
        locationListContainer.Name = "LocationListContainer"
        locationListContainer.Size = UDim2.new(1, 0, 0, 0)
        locationListContainer.BackgroundTransparency = 1
        locationListContainer.LayoutOrder = 4
        locationListContainer.ZIndex = 3
        locationListContainer.Parent = saveSection

        addLocationBtn.MouseButton1Click:Connect(function()
            createLocationEntry(locationListContainer)
        end)

        removeLocationBtn.MouseButton1Click:Connect(function()
            removeLastLocationEntry(locationListContainer)
        end)

        -- Section 3: Player list
        local playerSection = makeTpSection(tpContentContainer, 3)
        themeTargets.playerListTitle = makeTpSectionTitle(playerSection, "PLAYER LIST", 1)
        makeTpDivider(playerSection, 2)

        playerListContainer = Instance.new("Frame")
        playerListContainer.Name = "PlayerListContainer"
        playerListContainer.Size = UDim2.new(1, 0, 0, 0)
        playerListContainer.BackgroundTransparency = 1
        playerListContainer.LayoutOrder = 3
        playerListContainer.ZIndex = 3
        playerListContainer.Parent = playerSection

        rebuildPlayerList()
        initPlayerListListeners()
        task.defer(updateTpScrollSize)
    elseif i == 4 then
        -- SETTINGS tab
        settingsScrollFrame = Instance.new("ScrollingFrame")
        settingsScrollFrame.Name = "SettingsScroll"
        settingsScrollFrame.Size = UDim2.new(1, 0, 1, 0)
        settingsScrollFrame.BackgroundTransparency = 1
        settingsScrollFrame.BorderSizePixel = 0
        settingsScrollFrame.ScrollBarThickness = 4
        settingsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        settingsScrollFrame.ZIndex = 3
        settingsScrollFrame.Parent = content

        settingsContentContainer = Instance.new("Frame")
        settingsContentContainer.Name = "SettingsContainer"
        settingsContentContainer.Size = UDim2.new(1, -4, 0, 0)
        settingsContentContainer.BackgroundTransparency = 1
        settingsContentContainer.ZIndex = 3
        settingsContentContainer.Parent = settingsScrollFrame

        settingsListLayout = Instance.new("UIListLayout")
        settingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        settingsListLayout.Padding = UDim.new(0, 12)
        settingsListLayout.Parent = settingsContentContainer

        local settingsPadding = Instance.new("UIPadding")
        settingsPadding.PaddingLeft = UDim.new(0, UI.MARGIN)
        settingsPadding.PaddingRight = UDim.new(0, UI.MARGIN)
        settingsPadding.PaddingTop = UDim.new(0, 6)
        settingsPadding.PaddingBottom = UDim.new(0, 10)
        settingsPadding.Parent = settingsContentContainer

        settingsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSettingsScrollSize)

        -- Section 1: Menu keybind
        local keybindSection = makeTpSection(settingsContentContainer, 1)
        makeTpSectionTitle(keybindSection, "MENU KEYBIND", 1)
        makeTpDivider(keybindSection, 2)

        keybindBtn = makeTpKeybindRow(keybindSection, "OPEN/CLOSE MENU : KEYBIND", 3)
        keybindBtn.Name = "KeybindButton"
        keybindBtn.Text = settings.toggleKey.Name
        keybindBtn.TextColor3 = settings.accentColor
        themeTargets.keybindStroke = makeStroke(keybindBtn, blendColor(settings.accentColor, 0.85), 1, 0.5)

        keybindBtn.MouseButton1Click:Connect(function()
            waitingForKeybind = "menu"
            keybindBtn.Text = "..."
            keybindBtn.TextColor3 = Color3.fromRGB(255, 200, 80)
        end)

        -- Section 2: Menu color
        local colorSection = makeTpSection(settingsContentContainer, 2)
        makeTpSectionTitle(colorSection, "MENU COLOR", 1)
        makeTpDivider(colorSection, 2)

        local SWATCH_SIZE = 20
        local SWATCH_PAD = 5
        local COLORS_PER_ROW = 6
        local colorRows = math.ceil(#COLOR_PRESETS / COLORS_PER_ROW)
        local gridW = COLORS_PER_ROW * SWATCH_SIZE + (COLORS_PER_ROW - 1) * SWATCH_PAD
        local gridH = colorRows * SWATCH_SIZE + (colorRows - 1) * SWATCH_PAD

        local colorRowWrap = Instance.new("Frame")
        colorRowWrap.Size = UDim2.new(1, 0, 0, gridH)
        colorRowWrap.BackgroundTransparency = 1
        colorRowWrap.LayoutOrder = 3
        colorRowWrap.ZIndex = 3
        colorRowWrap.Parent = colorSection

        local colorRow = Instance.new("Frame")
        colorRow.Size = UDim2.new(0, gridW, 0, gridH)
        colorRow.AnchorPoint = Vector2.new(0.5, 0)
        colorRow.Position = UDim2.new(0.5, 0, 0, 0)
        colorRow.BackgroundTransparency = 1
        colorRow.ZIndex = 3
        colorRow.Parent = colorRowWrap

        for ci, color in ipairs(COLOR_PRESETS) do
            local row = math.floor((ci - 1) / COLORS_PER_ROW)
            local col = (ci - 1) % COLORS_PER_ROW

            local swatch = Instance.new("TextButton")
            swatch.Name = "Color" .. ci
            swatch.Size = UDim2.new(0, SWATCH_SIZE, 0, SWATCH_SIZE)
            swatch.Position = UDim2.new(0, col * (SWATCH_SIZE + SWATCH_PAD), 0, row * (SWATCH_SIZE + SWATCH_PAD))
            swatch.BackgroundColor3 = color
            swatch.Text = ""
            swatch.AutoButtonColor = false
            swatch.BorderSizePixel = 0
            swatch.ZIndex = 3
            swatch.Parent = colorRow
            makeCorner(swatch, 50)

            makeStroke(swatch, Color3.fromRGB(255, 255, 255), 2, 1)
            colorButtons[ci] = swatch

            swatch.MouseButton1Click:Connect(function()
                settings.accentColor = color
                applyTheme()
            end)
        end

        -- Section 3: Opacity
        local opacitySection = makeTpSection(settingsContentContainer, 3)
        makeTpSectionTitle(opacitySection, "OPACITY", 1)
        makeTpDivider(opacitySection, 2)

        local opacityWrap = Instance.new("Frame")
        opacityWrap.Size = UDim2.new(1, 0, 0, 32)
        opacityWrap.BackgroundTransparency = 1
        opacityWrap.LayoutOrder = 3
        opacityWrap.ZIndex = 3
        opacityWrap.Parent = opacitySection

        opacityLabel = Instance.new("TextLabel")
        opacityLabel.Size = UDim2.new(1, 0, 0, 14)
        opacityLabel.Position = UDim2.new(0, 0, 0, 0)
        opacityLabel.BackgroundTransparency = 1
        opacityLabel.Text = "80%"
        opacityLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
        opacityLabel.TextSize = 11
        opacityLabel.Font = Enum.Font.Gotham
        opacityLabel.TextXAlignment = Enum.TextXAlignment.Right
        opacityLabel.ZIndex = 4
        opacityLabel.Parent = opacityWrap

        local sliderTrack = Instance.new("TextButton")
        sliderTrack.Name = "OpacityTrack"
        sliderTrack.Size = UDim2.new(1, 0, 0, 16)
        sliderTrack.Position = UDim2.new(0, 0, 1, -16)
        sliderTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        sliderTrack.Text = ""
        sliderTrack.AutoButtonColor = false
        sliderTrack.BorderSizePixel = 0
        sliderTrack.Active = true
        sliderTrack.ZIndex = 3
        sliderTrack.Parent = opacityWrap
        makeCorner(sliderTrack, 4)

        local sliderBar = Instance.new("Frame")
        sliderBar.Name = "OpacityBar"
        sliderBar.Size = UDim2.new(1, 0, 0, 8)
        sliderBar.Position = UDim2.new(0, 0, 0.5, -4)
        sliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        sliderBar.BorderSizePixel = 0
        sliderBar.Active = true
        sliderBar.ZIndex = 3
        sliderBar.Parent = sliderTrack
        makeCorner(sliderBar, 4)

        opacityFill = Instance.new("Frame")
        opacityFill.Name = "OpacityFill"
        opacityFill.Size = UDim2.new(0.8, 0, 1, 0)
        opacityFill.BackgroundColor3 = Color3.fromRGB(0, 200, 220)
        opacityFill.BorderSizePixel = 0
        opacityFill.ZIndex = 4
        opacityFill.Parent = sliderBar
        makeCorner(opacityFill, 4)

        opacityKnob = Instance.new("Frame")
        opacityKnob.Name = "OpacityKnob"
        opacityKnob.Size = UDim2.new(0, 12, 0, 12)
        opacityKnob.Position = UDim2.new(0.8, 0, 0.5, 0)
        opacityKnob.AnchorPoint = Vector2.new(0.5, 0.5)
        opacityKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        opacityKnob.BorderSizePixel = 0
        opacityKnob.ZIndex = 5
        opacityKnob.Parent = sliderBar
        makeCorner(opacityKnob, 50)

        opacitySliderTrack = sliderTrack

        sliderTrack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliderDragging = true
                setOpacityFromX(input.Position.X)
            end
        end)

        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliderDragging = true
                setOpacityFromX(input.Position.X)
            end
        end)

        task.defer(updateSettingsScrollSize)
    end

    tabBtn.MouseButton1Click:Connect(function()
        switchTab(i)
    end)
end

-- Resize handle (bulina de tras in colt)
local resizeHandle = Instance.new("TextButton")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -16, 1, -16)
resizeHandle.AnchorPoint = Vector2.new(1, 1)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Text = ""
resizeHandle.AutoButtonColor = false
resizeHandle.BorderSizePixel = 0
resizeHandle.ZIndex = 5
resizeHandle.Parent = mainFrame

local resizeDot = Instance.new("Frame")
resizeDot.Name = "ResizeDot"
resizeDot.Size = UDim2.new(0, 8, 0, 8)
resizeDot.Position = UDim2.new(0.5, 0, 0.5, 0)
resizeDot.AnchorPoint = Vector2.new(0.5, 0.5)
resizeDot.BackgroundColor3 = blendColor(settings.accentColor, 0.85)
resizeDot.BorderSizePixel = 0
resizeDot.ZIndex = 6
resizeDot.Parent = resizeHandle
makeCorner(resizeDot, 50)
themeTargets.resizeDot = resizeDot

resizeHandle.MouseEnter:Connect(function()
    local accent = settings.accentColor
    tween(resizeDot, {
        Size = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = accent,
    }, 0.15)
end)

resizeHandle.MouseLeave:Connect(function()
    local accent = settings.accentColor
    tween(resizeDot, {
        Size = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = blendColor(accent, 0.85),
    }, 0.15)
end)

-- Drag + resize logic
local dragging = false
local resizing = false
local dragStart, startPos
local resizeStart, startSize

local function getMaxPanelSize()
    local camera = workspace.CurrentCamera
    if camera then
        local viewport = camera.ViewportSize
        return viewport.X - 40, viewport.Y - 40
    end
    return 1200, 800
end

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        startSize = mainFrame.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    if dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    elseif resizing then
        local delta = input.Position - resizeStart
        local maxW, maxH = getMaxPanelSize()
        local newW = math.clamp(startSize.X.Offset + delta.X, MIN_W, maxW)
        local newH = math.clamp(startSize.Y.Offset + delta.Y, MIN_H, maxH)
        mainFrame.Size = UDim2.new(0, newW, 0, newH)
    elseif sliderDragging then
        setOpacityFromX(input.Position.X)
    elseif flySpeedDragging then
        setFlySpeedFromX(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        resizing = false
        sliderDragging = false
        flySpeedDragging = false
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if waitingForKeybind then
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
            if waitingForKeybind == "menu" then
                settings.toggleKey = input.KeyCode
                if keybindBtn then
                    keybindBtn.Text = input.KeyCode.Name
                    keybindBtn.TextColor3 = settings.accentColor
                end
            elseif waitingForKeybind == "deathTp" then
                settings.deathTpKey = input.KeyCode
                if deathTpKeyBtn then
                    deathTpKeyBtn.Text = input.KeyCode.Name
                    deathTpKeyBtn.TextColor3 = settings.accentColor
                end
            elseif waitingForKeybind == "esp" then
                settings.espKey = input.KeyCode
                if espKeyBtn then
                    espKeyBtn.Text = input.KeyCode.Name
                    espKeyBtn.TextColor3 = settings.accentColor
                end
            elseif waitingForKeybind == "fly" then
                settings.flyKey = input.KeyCode
                if flyKeyBtn then
                    flyKeyBtn.Text = input.KeyCode.Name
                    flyKeyBtn.TextColor3 = settings.accentColor
                end
            end
            waitingForKeybind = nil
        end
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 and not processed then
        if settings.clickTeleportEnabled then
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                if not sliderDragging and not flySpeedDragging and not dragging and not resizing then
                    performClickTeleport()
                end
            end
        end
    end

    if processed then
        return
    end
    if input.KeyCode == settings.toggleKey then
        mainGui.Enabled = not mainGui.Enabled
    elseif input.KeyCode == settings.deathTpKey then
        teleportToDeath()
    elseif input.KeyCode == settings.espKey then
        toggleEsp()
    elseif input.KeyCode == settings.flyKey then
        toggleFly()
    end
end)

-- ═══════════════════════════════════════
--  START -> inchide splash, deschide panel
-- ═══════════════════════════════════════

startBtn.MouseButton1Click:Connect(function()
    tween(splashBg, { BackgroundTransparency = 0 }, 0.4)
    tween(titleLabel, { TextTransparency = 1 }, 0.4)
    tween(startBtn, { BackgroundTransparency = 1, TextTransparency = 1 }, 0.4)
    for _, layer in ipairs(glowLayers) do
        tween(layer.frame, { BackgroundTransparency = 1 }, 0.4)
    end

    task.wait(0.45)
    splashGui:Destroy()
    mainGui.Enabled = true

    mainFrame.Position = UDim2.new(0.5, -PANEL_W / 2, 0.5, -PANEL_H / 2)
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    tween(mainFrame, {
        Size = UDim2.new(0, PANEL_W, 0, PANEL_H),
        Position = UDim2.new(0.5, -PANEL_W / 2, 0.5, -PANEL_H / 2),
    }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

applyTheme()

print("[Dirty Money] Loaded — Press " .. settings.toggleKey.Name .. " to toggle menu")
