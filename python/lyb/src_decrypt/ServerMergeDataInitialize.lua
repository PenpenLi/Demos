--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.model.ServerMergeProxy";

ServerMergeDataInitialize=class(Command);

function ServerMergeDataInitialize:ctor()
	self.class=ServerMergeDataInitialize;
end

function ServerMergeDataInitialize:execute()
	--ServerMergeProxy
  local serverMergeProxy=ServerMergeProxy.new();
  self:registerProxy(serverMergeProxy:getProxyName(),serverMergeProxy);
end