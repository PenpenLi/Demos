
require "main.view.strengthen.ui.StrengthenPopup";


StrengthenPopupMediator=class(Mediator);

function StrengthenPopupMediator:ctor(notification)
  self.class=StrengthenPopupMediator;
	self.viewComponent=StrengthenPopup.new();
  self.viewComponent:setNotification(notification);
end

rawset(StrengthenPopupMediator,"name","StrengthenPopupMediator");

function StrengthenPopupMediator:onToAutoGuide(event)
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,event.data));
end

--onDegrade
function StrengthenPopupMediator:onDegrade(event)
  self:sendNotification(StrengthenPopupNotification.new(StrengthenPopupNotifications.STRENGTHEN_DEGRADE,event.data));
end

--onForge
function StrengthenPopupMediator:onForge(event)
  self:sendNotification(StrengthenPopupNotification.new(StrengthenPopupNotifications.STRENGTHEN_FORGE,event.data));
end

function StrengthenPopupMediator:toShop(event)
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,event.data));
end

--onStarAddLayer
function StrengthenPopupMediator:onStarAddLayer(event)
  self:sendNotification(StrengthenPopupNotification.new(StrengthenPopupNotifications.STRENGTHEN_STARADD,event.data));
end

--onStrengthen
function StrengthenPopupMediator:onStrengthen(event)

  self:sendNotification(StrengthenPopupNotification.new(StrengthenPopupNotifications.STRENGTHEN_LEVELUP,event.data));
end

function StrengthenPopupMediator:onStrengthenMax(event)
  self:sendNotification(StrengthenPopupNotification.new(StrengthenPopupNotifications.STRENGTHEN_LEVELUP_MAX,event.data));
end

function StrengthenPopupMediator:onTrack(event)
  self:sendNotification(StrengthenPopupNotification.new(StrengthenPopupNotifications.STRENGTHEN_TRACK,event.data));
end

function StrengthenPopupMediator:onTutorStrengthen(event)

end

--移除
function StrengthenPopupMediator:onStrengthenPopupClose(event)

  self:sendNotification(StrengthenPopupNotification.new(StrengthenPopupNotifications.STRENGTHEN_CLOSE));
end

function StrengthenPopupMediator:onRecharge(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.OPEN_PLATFORM_CHARGE_UI_COMMAND));
end

function StrengthenPopupMediator:refreshStrengthenItem(userEquipmentId)
  -- self:getViewComponent():refreshStrengthenItem(userEquipmentId);
end

function StrengthenPopupMediator:refreshStuffByBags()
  -- self:getViewComponent():refreshStuffByBags();
end

function StrengthenPopupMediator:updateGemPanel()
	self:getViewComponent():updateGemPanel()
end

function StrengthenPopupMediator:changeTab(tabID)
  self:getViewComponent():changeTab(tabID);
end

function StrengthenPopupMediator:getItemPosByItemID(itemID)
  local userItemID = this.bagProxy:getUserItemId(itemID);
  return self:getViewComponent():getItemPosByUserItemID(userItemID);
end

function StrengthenPopupMediator:getItemPosByUserItemID(userItemID)
  return self:getViewComponent():getItemPosByUserItemID(userItemID);
end

function StrengthenPopupMediator:refreshStrengthenOnDouble(preStrengthenValue)
  self:getViewComponent():refreshStrengthenOnDouble(preStrengthenValue);
end

function StrengthenPopupMediator:refreshStrengthen(generalId, itemId, strengthenLevel, param1, param2)
  self:getViewComponent():refreshStrengthen(generalId, itemId, strengthenLevel, param1, param2);
end

function StrengthenPopupMediator:onRegister()
  self:getViewComponent():addEventListener("onDegrade",self.onDegrade,self);
  self:getViewComponent():addEventListener("onForge",self.onForge,self);
  self:getViewComponent():addEventListener("onStarAdd",self.onStarAddLayer,self);
  self:getViewComponent():addEventListener("onStrengthen",self.onStrengthen,self);
  self:getViewComponent():addEventListener("onStrengthenMax",self.onStrengthenMax,self);
  self:getViewComponent():addEventListener("onTrack",self.onTrack,self);
  self:getViewComponent():addEventListener("strengthenClose",self.onStrengthenPopupClose,self);
  self:getViewComponent():addEventListener("TO_AUTO_GUIDE",self.onToAutoGuide,self);
  self:getViewComponent():addEventListener("TUTOR_EQUIPMENT",self.onTutorStrengthen,self);
  self:getViewComponent():addEventListener("vip_recharge",self.onRecharge,self);
  self:getViewComponent():addEventListener(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,self.toShop,self);
end

function StrengthenPopupMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end