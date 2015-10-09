--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

RankListCloseCommand=class(Command);

function RankListCloseCommand:ctor()
	self.class=RankListCloseCommand;
end

function RankListCloseCommand:execute(notification)
  self:removeMediator(RankListMediator.name);
  self:removeCommand(RankListNotifications.RANK_LIST_REQUEST_DATA,RankListRequestDataCommand);
  self:removeCommand(RankListNotifications.RANK_LIST_CLOSE,RankListCloseCommand);
  self:unobserve(RankListCloseCommand);

  
end