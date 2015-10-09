MonthCardNotifications={MONTH_CARD="Month_Card",
                   MONTH_CARD_CLOSE="MonthCard_CLOSE",
 
      
  };

MonthCardNotification=class(Notification);

function MonthCardNotification:ctor(type_string, data)
	self.class = MonthCardNotification;
	self.type = type_string;
	self.data = data;
end