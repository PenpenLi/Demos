--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-31

	yanchuan.xie@happyelements.com
]]

require "main.view.bag.BagPopupMediator";

MainSceneToBagCommand=class(Command);

function MainSceneToBagCommand:ctor()
	self.class=MainSceneToBagCommand;
end

function MainSceneToBagCommand:execute()
  self:require();
  --BagPopupMediator
  self.bagPopupMediator=self:retrieveMediator(BagPopupMediator.name);
  if self.bagPopupMediator then
    return;
  end
  if nil==self.bagPopupMediator then
    self.bagPopupMediator=BagPopupMediator.new();
    self:registerMediator(self.bagPopupMediator:getMediatorName(),self.bagPopupMediator);
    self:registerBagCommands();
  end
  self:observe(BagCloseCommand);
  LayerManager:addLayerPopable(self.bagPopupMediator:getViewComponent());
  hecDC(3,2,1);
end

function MainSceneToBagCommand:registerBagCommands()
  self:registerCommand(BagPopupNotifications.BAG_ITEM_CHANGE_PLACE,BagItemChangePlaceCommand);
  self:registerCommand(BagPopupNotifications.BAG_ITEM_SELL,BagItemSellCommand);
  self:registerCommand(BagPopupNotifications.BAG_ITEM_TRIM,BagItemTrimCommand);
  self:registerCommand(BagPopupNotifications.BAG_OPEN_PLACE,BagOpenPlaceCommand);
  self:registerCommand(BagPopupNotifications.AVATAR_EQUIP_ON_OFF,AvatarEquipOnOffCommand);
  self:registerCommand(BagPopupNotifications.BAG_PROP_USE,BagPropUseCommand);
  self:registerCommand(BagPopupNotifications.BAG_PROP_SYNTHETIC,BagPropSyntheticCommand);
  self:registerCommand(BagPopupNotifications.BAG_TO_AUTOGUIDE,BagAutoGuideCommand);
  self:registerCommand(BagPopupNotifications.BAG_BATCH_SELL,BagBatchSellCommand);
  self:registerCommand(BagPopupNotifications.BAG_CLOSE,BagCloseCommand);
end

function MainSceneToBagCommand:require()
  require "main.controller.command.bagPopup.BagItemChangePlaceCommand";
  require "main.controller.command.bagPopup.BagItemSellCommand";
  require "main.controller.command.bagPopup.BagItemTrimCommand";
  require "main.controller.command.bagPopup.BagOpenPlaceCommand";
  require "main.controller.command.bagPopup.AvatarEquipOnOffCommand";
  require "main.controller.command.bagPopup.BagPropUseCommand";
  require "main.controller.command.bagPopup.BagPropSyntheticCommand";
  require "main.controller.command.bagPopup.BagCloseCommand";
  require "main.controller.notification.BagPopupNotification";
  require "main.controller.command.bagPopup.BagAutoGuideCommand";
  require "main.controller.command.bagPopup.BagBatchSellCommand";
end