--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-20

	yanchuan.xie@happyelements.com
]]

require "main.model.ActivityProxy";

ActivityDataInitialize=class(Command);

function ActivityDataInitialize:ctor()
	self.class=ActivityDataInitialize;
end

function ActivityDataInitialize:execute()
	--ActivityProxy
  local activityProxy=ActivityProxy.new();
  self:registerProxy(activityProxy:getProxyName(),activityProxy);
end