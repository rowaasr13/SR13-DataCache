local a_name, a_env = ...

-- [AUTOLOCAL START]
local CreateFrame = CreateFrame
local GetActiveSpecGroup = GetActiveSpecGroup
local GetTalentInfo = GetTalentInfo
local MAX_TALENT_TIERS = MAX_TALENT_TIERS
local NUM_TALENT_COLUMNS = NUM_TALENT_COLUMNS
local _G = _G
local pairs = pairs
local wipe = wipe
-- [AUTOLOCAL END]

local active_talents = {}
a_env.a_export.active_talents = active_talents

local function UpdateTalentCache()
   wipe(active_talents)
   local talentGroup = GetActiveSpecGroup(false)
   for tier = 1, MAX_TALENT_TIERS do
      for column = 1, NUM_TALENT_COLUMNS do
         local talentID, local_name, iconTexture, selected, available, spellId = GetTalentInfo(tier, column, talentGroup)
         if local_name and selected then
            active_talents[local_name] = tier
            active_talents[spellId] = tier
            active_talents[tier] = local_name
         end
      end
   end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", UpdateTalentCache)
frame:RegisterEvent('PLAYER_TALENT_UPDATE')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
