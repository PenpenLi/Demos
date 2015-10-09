--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-20

	yanchuan.xie@happyelements.com
]]

require "main.model.ItemUseQueueProxy";

ItemUseQueueInitialize=class(Command);

function ItemUseQueueInitialize:ctor()
	self.class=ItemUseQueueInitialize;
end

function ItemUseQueueInitialize:execute()
	--ItemUseQueueProxy
  local itemUseQueueProxy=ItemUseQueueProxy.new();
  self:registerProxy(itemUseQueueProxy:getProxyName(),itemUseQueueProxy);
end