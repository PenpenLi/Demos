--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-13

	yanchuan.xie@happyelements.com
]]

require "main.model.StrengthenProxy";

StrengthenDataInitialize=class(Command);

function StrengthenDataInitialize:ctor()
	self.class=StrengthenDataInitialize;
end

function StrengthenDataInitialize:execute()
	--StrengthenProxy
  local strengthenProxy=StrengthenProxy.new();
  self:registerProxy(strengthenProxy:getProxyName(),strengthenProxy);
end