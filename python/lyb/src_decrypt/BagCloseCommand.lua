BagCloseCommand=class(Command);

function BagCloseCommand:ctor()
	self.class=BagCloseCommand;
end

function BagCloseCommand:execute(notification)
  self:removeMediator(BagPopupMediator.name);
  self:removeCommand(BagPopupNotifications.BAG_ITEM_CHANGE_PLACE,BagItemChangePlaceCommand);
  self:removeCommand(BagPopupNotifications.BAG_ITEM_SELL,BagItemSellCommand);
  self:removeCommand(BagPopupNotifications.BAG_ITEM_TRIM,BagItemTrimCommand);
  self:removeCommand(BagPopupNotifications.BAG_OPEN_PLACE,BagOpenPlaceCommand);
  self:removeCommand(BagPopupNotifications.AVATAR_EQUIP_ON_OFF,AvatarEquipOnOffCommand);
  self:removeCommand(BagPopupNotifications.BAG_PROP_USE,BagPropUseCommand);
  self:removeCommand(BagPopupNotifications.BAG_PROP_SYNTHETIC,BagPropSyntheticCommand);
  self:removeCommand(BagPopupNotifications.BAG_BATCH_SELL,BagBatchSellCommand);
  self:removeCommand(BagPopupNotifications.BAG_CLOSE,BagCloseCommand);
  self:unobserve(BagCloseCommand);
end