--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-20

	yanchuan.xie@happyelements.com
]]

RankListNotifications={RANK_LIST_REQUEST_DATA="rankListRequestData",
					   RANK_LIST_CLOSE="rankListClose"};

RankListNotification=class(Notification);

function RankListNotification:ctor(type_string, data)
	self.class = RankListNotification;
	self.type = type_string;
  self.data=data;
end

function RankListNotification:getData()
  return self.data;
end