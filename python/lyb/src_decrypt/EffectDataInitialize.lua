--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-9-10

	yanchuan.xie@happyelements.com
]]

require "main.model.EffectProxy";

EffectDataInitialize=class(Command);

function EffectDataInitialize:ctor()
	self.class=EffectDataInitialize;
end

function EffectDataInitialize:execute()
	--EffectProxy
  local effectProxy=EffectProxy.new();
  self:registerProxy(effectProxy:getProxyName(),effectProxy);
end