local filter = { }

filter.player = function(unit)
  return UnitIsPlayer(unit) and true or false
end

filter.npc = function(unit)
  return not UnitIsPlayer(unit) and true or false
end

filter.infight = function(unit)
  return UnitAffectingCombat(unit) and true or false
end

filter.dead = function(unit)
  return UnitIsDead(unit) and true or false
end

filter.alive = function(unit)
  return not UnitIsDead(unit) and true or false
end

filter.horde = function(unit)
  return UnitFactionGroup(unit) == "Horde" and true or false
end

filter.alliance = function(unit)
  return UnitFactionGroup(unit) == "Alliance" and true or false
end

filter.hardcore = function(unit)
  return string.find(UnitPVPName(unit), "Still Alive") and true or false
end

filter.pve = function(unit)
  return not UnitIsPVP(unit) and true or false
end

filter.pvp = function(unit)
  return UnitIsPVP(unit) and true or false
end

filter.icon = function(unit)
  return GetRaidTargetIndex(unit) and true or false
end

filter.normal = function(unit)
  local elite = UnitClassification(unit)
  return elite == "normal" and true or false
end

filter.elite = function(unit)
  local elite = UnitClassification(unit)
  return (elite == "elite" or elite == "rareelite") and true or false
end

filter.rare = function(unit)
  local elite = UnitClassification(unit)
  return (elite == "rare" or elite == "rareelite") and true or false
end

filter.rareelite = function(unit)
  local elite = UnitClassification(unit)
  return elite == "rareelite" and true or false
end

filter.worldboss = function(unit)
  local elite = UnitClassification(unit)
  return elite == "worldboss" and true or false
end

filter.hostile = function(unit)
  return UnitIsEnemy("player", unit) and true or false
end

filter.neutral = function(unit)
  return not UnitIsEnemy("player", unit) and not UnitIsFriend("player", unit) and true or false
end

filter.friendly = function(unit)
  return UnitIsFriend("player", unit) and true or false
end

filter.attack = function(unit)
  return UnitCanAttack("player", unit) and true or false
end

filter.noattack = function(unit)
  return not UnitCanAttack("player", unit) and true or false
end

filter.pet = function(unit)
  local player = UnitIsPlayer(unit) and true or false
  local controlled = UnitPlayerControlled(unit) and true or false
  local pet = not player and controlled and true or false
  return pet and true or false
end

filter.nopet = function(unit)
  local player = UnitIsPlayer(unit) and true or false
  local controlled = UnitPlayerControlled(unit) and true or false
  local pet = not player and controlled and true or false
  return not pet and true or false
end

ShaguScan.filter = filter
