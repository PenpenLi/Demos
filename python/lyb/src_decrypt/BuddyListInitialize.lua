--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

require "main.model.BuddyListProxy";

BuddyListInitialize=class(Command);

function BuddyListInitialize:ctor()
	self.class=BuddyListInitialize;
end

function BuddyListInitialize:execute()
	--BuddyListProxy
  local buddyListProxy=BuddyListProxy.new();
  self:registerProxy(buddyListProxy:getProxyName(),buddyListProxy);
end