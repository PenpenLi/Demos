--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-25

	yanchuan.xie@happyelements.com
]]

require "main.model.UserCurrencyProxy";

UserCurrencyInitialize=class(Command);

function UserCurrencyInitialize:ctor()
	self.class=UserCurrencyInitialize;
end

function UserCurrencyInitialize:execute()
	--UserCurrencyProxy
  local userCurrencyProxy=UserCurrencyProxy.new();
  self:registerProxy(userCurrencyProxy:getProxyName(),userCurrencyProxy);
end