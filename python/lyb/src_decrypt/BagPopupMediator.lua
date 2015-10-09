require "main.view.bag.ui.BagPopup";

BagPopupMediator=class(Mediator);

function BagPopupMediator:ctor()
  self.class=BagPopupMediator;
	self.viewComponent=BagPopup.new();
end

rawset(BagPopupMediator,"name","BagPopupMediator");

function BagPopupMediator:locateToGridByItemID(itemID)
  return self:getViewComponent():locateToGridByItemID(itemID);
end

--换装
function BagPopupMediator:onAvatarEquipOnOff(event)
  self:sendNotification(BagPopupNotification.new(BagPopupNotifications.AVATAR_EQUIP_ON_OFF,event.data));
end

--移除
function BagPopupMediator:onBagClose(event)
  self:sendNotification(BagPopupNotification.new(BagPopupNotifications.BAG_CLOSE));
end

--整理
function BagPopupMediator:onBagItemTrim(event)
  self:sendNotification(BagPopupNotification.new(BagPopupNotifications.BAG_ITEM_TRIM));
end

--移动物品位置
function BagPopupMediator:onBagItemPlaceChanged(event)
  self:sendNotification(BagPopupNotification.new(BagPopupNotifications.BAG_ITEM_CHANGE_PLACE,event.data));
end

--开格子
function BagPopupMediator:onBagOpenPlace(event)
  self:sendNotification(BagPopupNotification.new(BagPopupNotifications.BAG_OPEN_PLACE,event.data));
end

--道具使用
function BagPopupMediator:onBagPropUse(event)
  self:sendNotification(BagPopupNotification.new(BagPopupNotifications.BAG_PROP_USE,event.data));
end

function BagPopupMediator:onBagPropSynthetic(event)
  self:sendNotification(BagPopupNotification.new(BagPopupNotifications.BAG_PROP_SYNTHETIC,event.data));
end

--道具出售
function BagPopupMediator:onItemSell(event)
  self:sendNotification(BagPopupNotification.new(BagPopupNotifications.BAG_ITEM_SELL,event.data));
end

function BagPopupMediator:onRecharge(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.OPEN_PLATFORM_CHARGE_UI_COMMAND));
end

function BagPopupMediator:onToAutoGuide(event)
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,event.data));
end

function BagPopupMediator:onOpenPrestigeShop(event)
  -- self:sendNotification(AvatarNotification.new(AvatarNotifications.AVATAR_CLOSE));
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{ID = 90, isFromBagUI = true}));
end

--更新道具
function BagPopupMediator:refreshBagData(data, booleanValue)
  self:getViewComponent().bagLayer:refreshBagData(data,booleanValue);
end

function BagPopupMediator:refreshBagDelete(data)
  self:getViewComponent():refreshBagDelete(data);
end

--更新打造道具
function BagPopupMediator:refreshBagDataByForge(userItemId)
  self:getViewComponent():refreshBagDataByForge(userItemId);
end

function BagPopupMediator:onAutoGuide(event)
  self:sendNotification(BagPopupNotification.new(BagPopupNotifications.BAG_TO_AUTOGUIDE, event.data));
end

function BagPopupMediator:onChangeName(event)
  self:sendNotification(BagPopupNotification.new(MainSceneNotifications.MAIN_SCENE_TO_CHANGE_NAME, event.data));
end

function BagPopupMediator:onBagBatchSell(event)
  self:sendNotification(BagPopupNotification.new(BagPopupNotifications.BAG_BATCH_SELL, event.data));
end

function BagPopupMediator:onRegister()
  self:getViewComponent():addEventListener("bagItemChagePlace",self.onBagItemPlaceChanged,self);
  self:getViewComponent():addEventListener("bagItemSell",self.onItemSell,self);
  self:getViewComponent():addEventListener("bagItemTrim",self.onBagItemTrim,self);
  self:getViewComponent():addEventListener("bagOpenPlace",self.onBagOpenPlace,self);
  self:getViewComponent():addEventListener("avatarEquipOnOff",self.onAvatarEquipOnOff,self);
  self:getViewComponent():addEventListener("onBagPropUse",self.onBagPropUse,self);
  self:getViewComponent():addEventListener("bagPropSynthetic",self.onBagPropSynthetic,self);
  self:getViewComponent():addEventListener("vip_recharge",self.onRecharge,self);
  self:getViewComponent():addEventListener("TO_AUTO_GUIDE",self.onToAutoGuide,self);
  self:getViewComponent():addEventListener("bagClose",self.onBagClose,self);
  self:getViewComponent():addEventListener("TUTOR_USE_ITEM",self.onTutorUseItem,self);
  self:getViewComponent():addEventListener("TO_RATINGUI",self.onOpenPrestigeShop,self);
  self:getViewComponent():addEventListener("Auto_Guide_Event",self.onAutoGuide,self);
  self:getViewComponent():addEventListener("UPGRADE_PEERAGE",self.upgradePeerage,self);

  self:getViewComponent():addEventListener(BagPopupNotifications.BAG_BATCH_SELL,self.onBagBatchSell,self);
  self:getViewComponent():addEventListener(MainSceneNotifications.MAIN_SCENE_TO_CHANGE_NAME,self.onChangeName,self);
end

function BagPopupMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end

function BagPopupMediator:upgradePeerage(evt)
  -- print("upgradePeerage")
  sendMessage(3,27);
end

function BagPopupMediator:refreshPeerageLayer()
  self:getViewComponent():refreshPeerageLayer();
end
