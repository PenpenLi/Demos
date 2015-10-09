--
	-- Copyright @2009-2013 www.happyelements.com, all rights reserved.
	-- Create date: 2013-2-20

	-- yanchuan.xie@happyelements.com


OfficialServerNotifications={OPEN_OFFICIAL_SERVER="openOfficialServer",
							 CLOSE_OFFICIAL_SERVER="closeOfficialServer"};

OfficialServerNotification=class(Notification);

function OfficialServerNotification:ctor(type_string, data)
	self.class = OfficialServerNotification;
	self.type = type_string;
  self.data=data;
end

function OfficialServerNotification:getData()
  return self.data;
end