local a_name, a_env = ...

-- [AUTOLOCAL START]
local CreateFrame = CreateFrame
local IsInJailersTower = IsInJailersTower
local UnitAura = UnitAura
local wipe = wipe
-- [AUTOLOCAL END]

local active_maw_buffs = {}
a_env.a_export.active_maw_buffs = active_maw_buffs

local function active_maw_buffs_update()
   for idx = 1, 200 do
      local _, icon, count, _, _, _, _, _, _, spellID = UnitAura("player", idx, "MAW")
      if spellID then
         active_maw_buffs[spellID] = count
      else
         break -- watch out if early break always work correctly, Blizzard doesn't use it
      end
   end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
   if (event == "PLAYER_ENTERING_WORLD") then
      wipe(active_maw_buffs)
      if IsInJailersTower() then
         active_maw_buffs_update()
         frame:RegisterUnitEvent("UNIT_AURA", "player")
      else
         frame:UnregisterEvent("UNIT_AURA")
      end
   elseif (event == "UNIT_AURA") then
      wipe(active_maw_buffs)
      active_maw_buffs_update()
   end

end)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
