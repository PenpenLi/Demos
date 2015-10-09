BagPopupNotifications={BAG_ITEM_CHANGE_PLACE="bagItemChangePlace",
                       BAG_ITEM_SELL="bagItemSell",
                       BAG_ITEM_TRIM="bagItemTrim",
                       BAG_OPEN_PLACE="bagOpenPlace",
                       AVATAR_EQUIP_ON_OFF="avatarEquipOnOff",
                       BAG_PROP_USE="bagPropUse",
                       BAG_PROP_SYNTHETIC="bagPropSynthetic",
                       BAG_TO_AUTOGUIDE="bagToAutoGuide",
                       BAG_BATCH_SELL="bagBatchSell",
                       BAG_CLOSE="bagClose"};

BagPopupNotification=class(Notification);

function BagPopupNotification:ctor(type_string, data)
	self.class = BagPopupNotification;
	self.type = type_string;
  self.data=data;
end

function BagPopupNotification:getData()
  return self.data;
end