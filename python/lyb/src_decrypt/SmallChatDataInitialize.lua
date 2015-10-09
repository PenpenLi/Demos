--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-20

	yanchuan.xie@happyelements.com
]]

require "main.model.SmallChatProxy";

SmallChatDataInitialize=class(Command);

function SmallChatDataInitialize:ctor()
	self.class=SmallChatDataInitialize;
end

function SmallChatDataInitialize:execute()
	--SmallChatProxy
  local smallChatProxy=SmallChatProxy.new();
  self:registerProxy(smallChatProxy:getProxyName(),smallChatProxy);
end