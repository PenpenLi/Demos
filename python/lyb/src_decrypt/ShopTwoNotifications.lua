ShopTwoNotifications={OPEN_SHOPTWO_UI="OPEN_SHOPTWO_UI",
                   SHOPTWO_UI_CLOSE="SHOPTWO_UI_CLOSE",
                   ITEM_BUY="ITEM_BUY",
      
  };

ShopTwoNotification=class(Notification);

function ShopTwoNotification:ctor(type_string, data)
	self.class = ShopTwoNotification;
	self.type = type_string;
	self.data = data;
end