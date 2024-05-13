if ShaguScan.disabled then return end

local core = CreateFrame("Frame", nil, WorldFrame)

core.guids = {}

core.add = function(unit)
  local _, guid = UnitExists(unit)

  if guid then
    core.guids[guid] = GetTime()
  end
end

-- unitstr
core:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
core:RegisterEvent("PLAYER_TARGET_CHANGED")
core:RegisterEvent("PLAYER_ENTERING_WORLD")

-- arg1
core:RegisterEvent("UNIT_COMBAT")
core:RegisterEvent("UNIT_HAPPINESS")
core:RegisterEvent("UNIT_MODEL_CHANGED")
core:RegisterEvent("UNIT_PORTRAIT_UPDATE")
core:RegisterEvent("UNIT_FACTION")
core:RegisterEvent("UNIT_FLAGS")
core:RegisterEvent("UNIT_AURA")
core:RegisterEvent("UNIT_HEALTH")
core:RegisterEvent("UNIT_CASTEVENT")

core:SetScript("OnEvent", function()
  if event == "UPDATE_MOUSEOVER_UNIT" then
    this.add("mouseover")
  elseif event == "PLAYER_ENTERING_WORLD" then
    this.add("player")
  elseif event == "PLAYER_TARGET_CHANGED" then
    this.add("target")
  else
    this.add(arg1)
  end
end)

ShaguScan.core = core
