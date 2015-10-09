--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

BuddyDeletedRefreshCommand=class(Command);

function BuddyDeletedRefreshCommand:ctor()
	self.class=BuddyDeletedRefreshCommand;
end

function BuddyDeletedRefreshCommand:execute(notification)
  local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
  if mainSceneMediator then
  	mainSceneMediator:refreshChatNumberByBuddyDelete(notification:getData().ChatNumber+notification:getData().ChatBuddyNumber);
  end

  local chatPopupMediator=self:retrieveMediator(ChatPopupMediator.name);
  if chatPopupMediator then
  	chatPopupMediator:buddyDeletedRefreshPannelTip(notification:getData().ChatNumber,notification:getData().ChatBuddyNumber);
  end
end