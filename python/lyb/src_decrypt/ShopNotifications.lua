--[[

  ]]
ShopNotifications={OPEN_SHOP_UI="OPEN_SHOP_UI",
                   SHOP_UI_CLOSE="SHOP_UI_CLOSE",
                   ITEM_BUY="ITEM_BUY",

  };

ShopNotification=class(Notification);

function ShopNotification:ctor(type_string, data)
	self.class = ShopNotification;
	self.type = type_string;
	self.data = data;
end