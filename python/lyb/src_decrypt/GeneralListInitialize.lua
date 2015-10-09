--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-4

	yanchuan.xie@happyelements.com
]]

require "main.model.GeneralListProxy";

GeneralListInitialize=class(Command);

function GeneralListInitialize:ctor()
	self.class=GeneralListInitialize;
end

function GeneralListInitialize:execute()
	--GeneralListInitialize
  local generalListProxy=GeneralListProxy.new();
  self:registerProxy(generalListProxy:getProxyName(),generalListProxy);
end