if ShaguScan.disabled then return end

local utils = ShaguScan.utils

local settings = {}

SLASH_SHAGUSCAN1, SLASH_SHAGUSCAN2, SLASH_SHAGUSCAN3 = "/scan", "/sscan", "/shaguscan"

SlashCmdList["SHAGUSCAN"] = function(input)
  local caption = input and input ~= '' and input or "Scanner"
  settings.OpenConfig(caption)
end

settings.backdrop = {
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
  tile = true, tileSize = 16, edgeSize = 12,
  insets = { left = 2, right = 2, top = 2, bottom = 2 }
}

settings.textborder = {
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
  tile = true, tileSize = 16, edgeSize = 8,
  insets = { left = 2, right = 2, top = 2, bottom = 2 }
}

settings.CreateLabel = function(parent, text)
  local label = parent:CreateFontString(nil, 'HIGH', 'GameFontWhite')
  label:SetFont(STANDARD_TEXT_FONT, 9)
  label:SetText(text)
  label:SetHeight(18)
  return label
end

settings.CreateTextBox = function(parent, text)
  local textbox = CreateFrame("EditBox", nil, parent)
  textbox.ShowTooltip = settings.ShowTooltip

  textbox:SetTextColor(1,.8,.2,1)
  textbox:SetJustifyH("RIGHT")
  textbox:SetTextInsets(5,5,5,5)
  textbox:SetBackdrop(settings.textborder)
  textbox:SetBackdropColor(.1,.1,.1,1)
  textbox:SetBackdropBorderColor(.2,.2,.2,1)

  textbox:SetHeight(18)

  textbox:SetFontObject(GameFontNormal)
  textbox:SetFont(STANDARD_TEXT_FONT, 9)
  textbox:SetAutoFocus(false)
  textbox:SetText((text or ""))

  textbox:SetScript("OnEscapePressed", function(self)
    this:ClearFocus()
  end)

  return textbox
end

settings.ShowTooltip = function(parent, strings)
  GameTooltip:SetOwner(parent, "ANCHOR_RIGHT")
  for id, entry in pairs(strings) do
    if type(entry) == "table" then
      GameTooltip:AddDoubleLine(entry[1], entry[2])
    else
      GameTooltip:AddLine(entry)
    end
  end
  GameTooltip:Show()
end

settings.OpenConfig = function(caption)
  -- Toggle Existing Dialog
  local existing = getglobal("ShaguScanConfigDialog"..caption)
  if existing then
    if existing:IsShown() then existing:Hide() else existing:Show() end
    return
  end

  -- Create defconfig if new config
  if not ShaguScan_db.config[caption] then
    ShaguScan_db.config[caption] = {
      filter = "npc,infight,alive",
      scale = 1, anchor = "CENTER", x = 0, y = 0, width = 75, height = 12, spacing = 4, maxrow = 20
    }
  end

  -- Main Dialog
  local dialog = CreateFrame("Frame", "ShaguScanConfigDialog"..caption, UIParent)
  table.insert(UISpecialFrames, "ShaguScanConfigDialog"..caption)

  -- Save Shortcuts
  local config = ShaguScan_db.config[caption]
  local caption = caption

  dialog:SetFrameStrata("DIALOG")
  dialog:SetPoint("CENTER", 0, 0)
  dialog:SetWidth(264)
  dialog:SetHeight(264)

  dialog:EnableMouse(true)
  dialog:RegisterForDrag("LeftButton")
  dialog:SetMovable(true)
  dialog:SetScript("OnDragStart", function() this:StartMoving() end)
  dialog:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)

  dialog:SetBackdrop(settings.backdrop)
  dialog:SetBackdropColor(.2, .2, .2, 1)
  dialog:SetBackdropBorderColor(.2, .2, .2, 1)

  -- Assign functions to dialog
  dialog.CreateTextBox = settings.CreateTextBox
  dialog.CreateLabel = settings.CreateLabel

  -- Save & Reload
  dialog.save = CreateFrame("Button", nil, dialog, "GameMenuButtonTemplate")
  dialog.save:SetWidth(96)
  dialog.save:SetHeight(18)
  dialog.save:SetFont(STANDARD_TEXT_FONT, 10)
  dialog.save:SetPoint("BOTTOMRIGHT", dialog, "BOTTOMRIGHT", -8, 8)
  dialog.save:SetText("Save")
  dialog.save:SetScript("OnClick", function()
    local new_caption = dialog.caption:GetText()

    local filter = dialog.filter:GetText()
    local width = dialog.width:GetText()
    local height = dialog.height:GetText()
    local spacing = dialog.spacing:GetText()
    local maxrow = dialog.maxrow:GetText()
    local anchor = dialog.anchor:GetText()
    local scale = dialog.scale:GetText()
    local x = dialog.x:GetText()
    local y = dialog.y:GetText()

    -- build new config
    local new_config = {
      filter = filter,
      width = tonumber(width) or config.width,
      height = tonumber(height) or config.height,
      spacing = tonumber(spacing) or config.spacing,
      maxrow = tonumber(maxrow) or config.maxrow,
      anchor = utils.IsValidAnchor(anchor) and anchor or config.anchor,
      scale = tonumber(scale) or config.scale,
      x = tonumber(x) or config.x,
      y = tonumber(y) or config.y,
    }

    ShaguScan_db.config[caption] = nil
    ShaguScan_db.config[new_caption] = new_config
    this:GetParent():Hide()
  end)

  -- Delete
  dialog.delete = CreateFrame("Button", nil, dialog, "GameMenuButtonTemplate")
  dialog.delete:SetWidth(96)
  dialog.delete:SetHeight(18)
  dialog.delete:SetFont(STANDARD_TEXT_FONT, 10)
  dialog.delete:SetPoint("BOTTOMLEFT", dialog, "BOTTOMLEFT", 8, 8)
  dialog.delete:SetText("Delete")
  dialog.delete:SetScript("OnClick", function()
    ShaguScan_db.config[caption] = nil
    this:GetParent():Hide()
  end)

  dialog.close = CreateFrame("Button", nil, dialog, "UIPanelCloseButton")
  dialog.close:SetWidth(20)
  dialog.close:SetHeight(20)
  dialog.close:SetPoint("TOPRIGHT", dialog, "TOPRIGHT", 0, 0)
  dialog.close:SetScript("OnClick", function()
    this:GetParent():Hide()
  end)

  -- Caption (Title)
  dialog.caption = dialog:CreateTextBox(caption)
  dialog.caption:SetPoint("TOPLEFT", dialog, "TOPLEFT", 8, -18)
  dialog.caption:SetPoint("TOPRIGHT", dialog, "TOPRIGHT", -8, -18)
  dialog.caption:SetFont(STANDARD_TEXT_FONT, 10)
  dialog.caption:SetJustifyH("CENTER")
  dialog.caption:SetHeight(20)

  -- Backdrop
  local backdrop = CreateFrame("Frame", nil, dialog)
  backdrop:SetBackdrop(settings.backdrop)
  backdrop:SetBackdropBorderColor(.2,.2,.2,1)
  backdrop:SetBackdropColor(.2,.2,.2,1)

  backdrop:SetPoint("TOPLEFT", dialog, "TOPLEFT", 8, -40)
  backdrop:SetPoint("BOTTOMRIGHT", dialog, "BOTTOMRIGHT", -8, 28)

  backdrop.CreateTextBox = settings.CreateTextBox
  backdrop.CreateLabel = settings.CreateLabel

  backdrop.pos = 8

  -- Filter
  local caption = backdrop:CreateLabel("Filter:")
  caption:SetPoint("TOPLEFT", backdrop, 10, -backdrop.pos)

  dialog.filter = backdrop:CreateTextBox(config.filter)
  dialog.filter:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 60, -backdrop.pos)
  dialog.filter:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", -8, -backdrop.pos)
  dialog.filter:SetScript("OnEnter", function()
    dialog.filter:ShowTooltip({
      "Unit Filters",
      "|cffaaaaaaA comma separated list of filters.",
      " ",
      { "|cffffffffplayer", "Player Characters" },
      { "|cffffffffnpc", "NPC Units" },
      { "|cffffffffinfight", "Infight Units" },
      { "|cffffffffdead", "Dead Units" },
      { "|cffffffffalive", "Living Units" },
      { "|cffffffffhorde", "Horde Units" },
      { "|cffffffffalliance", "Alliance Units" },
      { "|cffffffffhardcore", "Hardcore Players" },
      { "|cffffffffpve", "PvE Units" },
      { "|cffffffffpvp", "PvP Enabled Units" },
      { "|cfffffffficon", "Units With Raid Icons" },
      " ",
      "|cffffffffA complete list of filters can be found in the README."
    })
  end)

  dialog.filter:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  backdrop.pos = backdrop.pos + 18

  -- Spacer
  backdrop.pos = backdrop.pos + 9

  -- Width
  local caption = backdrop:CreateLabel("Width:")
  caption:SetPoint("TOPLEFT", backdrop, 10, -backdrop.pos)

  dialog.width = backdrop:CreateTextBox(config.width)
  dialog.width:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 60, -backdrop.pos)
  dialog.width:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", -8, -backdrop.pos)
  dialog.width:SetScript("OnEnter", function()
    dialog.width:ShowTooltip({
      "Health Bar Width",
      "|cffaaaaaaAn Integer Value in Pixels"
    })
  end)

  dialog.width:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)
  backdrop.pos = backdrop.pos + 18

  -- Height
  local caption = backdrop:CreateLabel("Height:")
  caption:SetPoint("TOPLEFT", backdrop, 10, -backdrop.pos)

  dialog.height = backdrop:CreateTextBox(config.height)
  dialog.height:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 60, -backdrop.pos)
  dialog.height:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", -8, -backdrop.pos)
  dialog.height:SetScript("OnEnter", function()
    dialog.height:ShowTooltip({
      "Health Bar Height",
      "|cffaaaaaaAn Integer Value in Pixels"
    })
  end)

  dialog.height:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  backdrop.pos = backdrop.pos + 18

  -- Spacing
  local caption = backdrop:CreateLabel("Spacing:")
  caption:SetPoint("TOPLEFT", backdrop, 10, -backdrop.pos)

  dialog.spacing = backdrop:CreateTextBox(config.spacing)
  dialog.spacing:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 60, -backdrop.pos)
  dialog.spacing:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", -8, -backdrop.pos)
  dialog.spacing:SetScript("OnEnter", function()
    dialog.spacing:ShowTooltip({
      "Spacing Between Health Bars",
      "|cffaaaaaaAn Integer Value in Pixels"
    })
  end)

  dialog.spacing:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  backdrop.pos = backdrop.pos + 18

  -- Max per Row
  local caption = backdrop:CreateLabel("Max-Row:")
  caption:SetPoint("TOPLEFT", backdrop, 10, -backdrop.pos)

  dialog.maxrow = backdrop:CreateTextBox(config.maxrow)
  dialog.maxrow:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 60, -backdrop.pos)
  dialog.maxrow:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", -8, -backdrop.pos)
  dialog.maxrow:SetScript("OnEnter", function()
    dialog.maxrow:ShowTooltip({
      "Maximum Entries Per Column",
      "|cffaaaaaaA new column will be created once exceeded"
    })
  end)

  dialog.maxrow:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  backdrop.pos = backdrop.pos + 18

  -- Spacer
  backdrop.pos = backdrop.pos + 9

  -- Anchor
  local caption = backdrop:CreateLabel("Anchor:")
  caption:SetPoint("TOPLEFT", backdrop, 10, -backdrop.pos)

  dialog.anchor = backdrop:CreateTextBox(config.anchor)
  dialog.anchor:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 60, -backdrop.pos)
  dialog.anchor:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", -8, -backdrop.pos)
  dialog.anchor:SetScript("OnEnter", function()
    dialog.anchor:ShowTooltip({
      "Window Anchor",
      "|cffaaaaaaThe Anchor From Where Positions Are Calculated.",
      " ",
      {"TOP", "TOPLEFT"},
      {"TOPRIGHT", "CENTER"},
      {"LEFT", "RIGHT"},
      {"BOTTOM", "BOTTOMLEFT"},
      {"BOTTOMRIGHT", ""}
    })
  end)

  dialog.anchor:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  backdrop.pos = backdrop.pos + 18

  -- Scale
  local caption = backdrop:CreateLabel("Scale:")
  caption:SetPoint("TOPLEFT", backdrop, 10, -backdrop.pos)

  dialog.scale = backdrop:CreateTextBox(utils.round(config.scale, 2))
  dialog.scale:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 60, -backdrop.pos)
  dialog.scale:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", -8, -backdrop.pos)
  dialog.scale:SetScript("OnEnter", function()
    dialog.scale:ShowTooltip({
      "Window Scale",
      "|cffaaaaaaA floating point number, 1 equals 100%"
    })
  end)

  dialog.scale:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  backdrop.pos = backdrop.pos + 18

  -- Position-X
  local caption = backdrop:CreateLabel("X-Position:")
  caption:SetPoint("TOPLEFT", backdrop, 10, -backdrop.pos)

  dialog.x = backdrop:CreateTextBox(utils.round(config.x, 2))
  dialog.x:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 60, -backdrop.pos)
  dialog.x:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", -8, -backdrop.pos)
  dialog.x:SetScript("OnEnter", function()
    dialog.x:ShowTooltip({
      "X-Position of Window",
      "|cffaaaaaaA Number in Pixels"
    })
  end)

  dialog.x:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  backdrop.pos = backdrop.pos + 18

  -- Position-Y
  local caption = backdrop:CreateLabel("Y-Position:")
  caption:SetPoint("TOPLEFT", backdrop, 10, -backdrop.pos)

  dialog.y = backdrop:CreateTextBox(utils.round(config.y, 2))
  dialog.y:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 60, -backdrop.pos)
  dialog.y:SetPoint("TOPRIGHT", backdrop, "TOPRIGHT", -8, -backdrop.pos)
  dialog.y:SetScript("OnEnter", function()
    dialog.y:ShowTooltip({
      "Y-Position of Window",
      "|cffaaaaaaA Number in Pixels"
    })
  end)

  dialog.y:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)
  backdrop.pos = backdrop.pos + 18
end

ShaguScan.settings = settings
