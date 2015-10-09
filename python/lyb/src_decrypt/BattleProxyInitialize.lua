--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.

]]

require "main.model.BattleProxy"

BattleProxyInitialize=class(Command);

function BattleProxyInitialize:ctor()
	self.class=BattleProxyInitialize;
end

function BattleProxyInitialize:execute()
    local battleProxy = BattleProxy.new()
    self:registerProxy(battleProxy:getProxyName(),battleProxy)
end