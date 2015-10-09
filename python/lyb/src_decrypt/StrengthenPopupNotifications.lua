--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-14

	yanchuan.xie@happyelements.com
]]

StrengthenPopupNotifications={STRENGTHEN_LEVELUP="strengthenLevelup",
                              STRENGTHEN_LEVELUP_MAX="strengthenLevelupMax",
                              STRENGTHEN_DEGRADE="strengthenDegrade",
                              STRENGTHEN_STARADD="strengthenStarAdd",
                              STRENGTHEN_FORGE="strengthenForge",
                              STRENGTHEN_TRACK="strengthenTrack",
                              STRENGTHEN_CLOSE="strengthenClose"};

StrengthenPopupNotification=class(Notification);

function StrengthenPopupNotification:ctor(type_string, data)
	self.class = StrengthenPopupNotification;
	self.type = type_string;
  self.data=data;
end

function StrengthenPopupNotification:getData()
  return self.data;
end