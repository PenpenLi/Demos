--[[

  ]]
FactionNotifications={
					OPEN_FACTION_UI="OPEN_FACTION_UI",
					TO_TEN_COUNTRY="TO_TEN_COUNTRY",
					TO_SHOP_COMMAND="TO_SHOP_COMMAND",
					TO_TREASURY_COMMAND="TO_TREASURY_COMMAND",
					TO_MEETING_COMMAND="TO_MEETING_COMMAND",
                   	FACTION_UI_CLOSE="FACTION_UI_CLOSE",
                   	FACTION_CURRENCY_UI_CLOSE="FACTION_CURRENCY_UI_CLOSE",
                   	TO_FACTION_CURRENCY_UI="TO_FACTION_CURRENCY_UI"
  };

FactionNotification=class(Notification);

function FactionNotification:ctor(type_string, data)
	self.class = FactionNotification;
	self.type = type_string;
	self.data = data;
end