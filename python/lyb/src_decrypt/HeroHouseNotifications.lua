--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-14

]]

HeroHouseNotifications={
						HEROHOUSE_CLOSE="HEROHOUSE_CLOSE",
						HEROJINJIE_CLOSE="HEROJINJIE_CLOSE",
						HEROPRO_CLOSE="HEROPRO_CLOSE",
						HEROSHENGJI_CLOSE="HEROSHENGJI_CLOSE",
						HEROSKILL_CLOSE="HEROSKILL_CLOSE",
						HEROTEAMMAIN_CLOSE="HEROTEAMMAIN_CLOSE",
						HEROTEAMSUB_CLOSE="HEROTEAMSUB_CLOSE",
						HEROHOUSE_INIT="HEROHOUSE_INIT",
						HEROHOUSE_JOINWAR="HEROHOUSE_JOINWAR",
						HEROHOUSE_QUITWAR="HEROHOUSE_QUITWAR",
						HEROHOUSE_CHECKCARD="HEROHOUSE_CHECKCARD",
						HEROCHANGEEQUIPE_CLOSE="HEROCHANGEEQUIPE_CLOSE",
						HEROEQUIPE_PUTON="HEROEQUIPE_PUTON",
						HEROEQUIPE_PUTOFF="HEROEQUIPE_PUTOFF",
						HERO_RED_DOT_REFRESH="HERO_RED_DOT_REFRESH"
						};

HeroHouseNotification=class(Notification);

function HeroHouseNotification:ctor(type_string, data)
	self.class = HeroHouseNotification;
	self.type = type_string;
  	self.data=data;
end

function HeroHouseNotification:getData()
  return self.data;
end