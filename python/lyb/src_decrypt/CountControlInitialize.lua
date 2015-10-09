--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-22

	yanchuan.xie@happyelements.com
]]

require "main.model.CountControlProxy";

CountControlInitialize=class(Command);

function CountControlInitialize:ctor()
	self.class=CountControlInitialize;
end

function CountControlInitialize:execute()
	--CountControlProxy
  local countControlProxy=CountControlProxy.new();
  self:registerProxy(countControlProxy:getProxyName(),countControlProxy);
end