ShaguScan = {}

-- load translation tables
--ShaguScan.L = (ShaguScan_locale[GetLocale()] or ShaguScan_locale["enUS"])
ShaguScan.T = (ShaguScan_translation[GetLocale()] or ShaguScan_translation["enUS"])

-- use table index key as translation fallback
ShaguScan.T = setmetatable(ShaguScan.T, { __index = function(tab,key)
  local value = tostring(key)
  rawset(tab, key, value)
  return value
end})

local T = ShaguScan.T

ShaguScan_db = {
  config = {
    [T["Infight NPCs"]] = {
      filter = "npc,infight",
      scale = 1, anchor = "CENTER", x = -240, y = 120, width = 100, height = 14, spacing = 4, maxrow = 20
    },

    [T["Raid Targets"]] = {
      filter = "icon,alive",
      scale = 1, anchor = "CENTER", x = 240, y = 120, width = 100, height = 14, spacing = 4, maxrow = 20
    }
  }
}

if not GetPlayerBuffID or not CombatLogAdd or not SpellInfo then
  local notify = CreateFrame("Frame", nil, UIParent)
  notify:SetScript("OnUpdate", function()
    DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffScan:|cffffaaaa " .. T["Couldn't detect SuperWoW."])
    this:Hide()
  end)

  ShaguScan.disabled = true
end