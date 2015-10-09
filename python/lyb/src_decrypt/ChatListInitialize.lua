--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

require "main.model.ChatListProxy";

ChatListInitialize=class(Command);

function ChatListInitialize:ctor()
	self.class=ChatListInitialize;
end

function ChatListInitialize:execute()
	--ChatListProxy
  local chatListProxy=ChatListProxy.new();
  self:registerProxy(chatListProxy:getProxyName(),chatListProxy);
end