require "main.view.tip.ui.ItemTip";
require "main.view.tip.ui.EquipTip";

TipMediator=class(Mediator);

function TipMediator:ctor()
  self.class = TipMediator;
  self.equipTip = EquipTip.new();
  self.itemTip = ItemTip.new();
end

rawset(TipMediator,"name","TipMediator");

function TipMediator:initialize(skeleton, userProxy, generalListProxy)
  self.equipTip:initialize(skeleton, userProxy, generalListProxy);
  local selfSize = self.equipTip:getContentSize();
    self.equipTip:setPositionXY((GameConfig.STAGE_WIDTH - selfSize.width)/2, (GameConfig.STAGE_HEIGHT - selfSize.height)/2);
  self.itemTip:initialize(skeleton, userProxy, generalListProxy);
  local selfSize = self.itemTip:getContentSize();
    self.itemTip:setPositionXY((GameConfig.STAGE_WIDTH - selfSize.width)/2, (GameConfig.STAGE_HEIGHT - selfSize.height)/2);
end

function TipMediator:onRegister()
  self.equipTip:addEventListener("REMOVE_EQUIP_TIP", self.removeEquipTip, self);
  self.itemTip:addEventListener("REMOVE_ITEM_TIP", self.removeItemTip, self);
end

--道具
function TipMediator:setItemTip(item, callBack, showButton,count)
  self.itemTip:setItemTip(item, callBack, showButton,count)
end
--装备
function TipMediator:setEquipTip(item,callBack, showButton,count)
 self.equipTip:setEquipTip(item,callBack, showButton,count);
end
function TipMediator:onRemove()
  if self.itemTip and self.itemTip.parent then
	 self.itemTip.parent:removeChild(self.itemTip)
  end
  if self.equipTip and self.equipTip.parent then
    self.equipTip.parent:removeChild(self.equipTip)
  end
end

function TipMediator:removeEquipTip()
  self:sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND))
end
function TipMediator:removeItemTip()
  self:sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND))
end


