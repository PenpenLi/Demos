--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-20

	yanchuan.xie@happyelements.com
]]

require "main.model.RankListProxy";

RankListDataInitialize=class(Command);

function RankListDataInitialize:ctor()
	self.class=RankListDataInitialize;
end

function RankListDataInitialize:execute()
	--RankListProxy
  local rankListProxy=RankListProxy.new();
  self:registerProxy(rankListProxy:getProxyName(),rankListProxy);
end