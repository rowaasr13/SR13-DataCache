local a_name, a_env = ...

-- [AUTOLOCAL START]
local C_AzeriteEmpoweredItem_GetAllTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem
local C_AzeriteEmpoweredItem_IsPowerSelected = C_AzeriteEmpoweredItem.IsPowerSelected
local GetInventoryItemID = GetInventoryItemID
local ItemLocation = ItemLocation
local pairs = pairs
local wipe = wipe
-- [AUTOLOCAL END]

local azerite_slot_map = {}
for _, invslot in pairs({ INVSLOT_HEAD, INVSLOT_SHOULDER, INVSLOT_CHEST }) do
   azerite_slot_map[invslot] = ItemLocation:CreateFromEquipmentSlot(invslot)
end

local active_azerite_powers = {}
a_env.a_export.active_azerite_powers = active_azerite_powers

local function active_azerite_powers_update()
   wipe(active_azerite_powers)
   for invslot, item_location in pairs(azerite_slot_map) do
      if GetInventoryItemID("player", invslot) and C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem(item_location) then
         local all_tier_info = C_AzeriteEmpoweredItem_GetAllTierInfo(item_location)
         for tier_idx, tier_info in pairs(all_tier_info) do
            for _, power_id in pairs(tier_info.azeritePowerIDs) do
               if C_AzeriteEmpoweredItem_IsPowerSelected(item_location, power_id) then
                  local current_powers = active_azerite_powers[power_id] or 0
                  active_azerite_powers[power_id] = current_powers + 1
                  break -- only one selected power per tier
               end
            end
         end
      end
   end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
   if (event == "PLAYER_EQUIPMENT_CHANGED") then
      local slot_id = ...
      if not azerite_slot_map[slot_id] then return end
   end

   active_azerite_powers_update()
end)
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
