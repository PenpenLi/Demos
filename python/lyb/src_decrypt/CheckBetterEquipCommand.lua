require "main.controller.notification.BagPopupNotification";
CheckBetterEquipCommand = class(MacroCommand);

function CheckBetterEquipCommand:execute()

  self:refreshBetterEquip();
end


function CheckBetterEquipCommand:refreshBetterEquip()
  local equips=BetterEquipManager.betterEquips;
  if 0==table.getn(equips) then
    return;
  end

  local bagProxy=self:retrieveProxy(BagProxy.name);
  local equipmentInfoProxy=self:retrieveProxy(EquipmentInfoProxy.name);
  local generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  local userProxy=self:retrieveProxy(UserProxy.name);

  for k,v in pairs(equips) do
    local itemData=bagProxy:getItemData(v);
    local equipmentInfo=equipmentInfoProxy:getEquipmentInfo(v);
    local userItemIDUse=bagProxy:getUserItemIDUseByCategory(itemData.ItemId);
    local occupation=analysis("Zhuangbei_Zhuangbeibiao",itemData.ItemId,"occupation");
    local lv=analysis("Zhuangbei_Zhuangbeibiao",itemData.ItemId,"lv");

    if (not equipmentInfoProxy:getEquipmentInfo(userItemIDUse)) or
       equipmentInfoProxy:getEquipmentInfo(userItemIDUse).Zhanli<equipmentInfo.Zhanli then
      if occupation==userProxy:getCareer() or 5==occupation then
        if lv<=generalListProxy:getLevel() then
          BetterEquipManager:push(bagProxy:getSkeleton(),itemData,self,self.onEquip,equipmentInfoProxy);
        end
      end
    end
  end
  BetterEquipManager.betterEquips={};
end

function CheckBetterEquipCommand:onEquip(itemData)
  local data={GeneralId=self:retrieveProxy(UserProxy.name):getUserID(),
              UserEquipmentId=itemData.UserItemId,
              Place=0,
              BooleanValue=1};
  self:addSubCommand(AvatarEquipOnOffCommand);
  self:complete(BagPopupNotification.new(BagPopupNotifications.AVATAR_EQUIP_ON_OFF,data));
end

CheckBetterEquipCommand.new():execute();