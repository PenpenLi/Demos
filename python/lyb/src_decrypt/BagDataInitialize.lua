--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-20

	yanchuan.xie@happyelements.com
]]

require "main.model.BagProxy";

BagDataInitialize=class(Command);

function BagDataInitialize:ctor()
	self.class=BagDataInitialize;
end

function BagDataInitialize:execute()
	--BagProxy
  local bagProxy=BagProxy.new();
  self:registerProxy(bagProxy:getProxyName(),bagProxy);
end