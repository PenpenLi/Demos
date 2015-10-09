--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.

]]

require "main.model.UserDataAccumulateProxy";

UserDataAccumulateInitialize=class(Command);

function UserDataAccumulateInitialize:ctor()
	self.class=UserDataAccumulateInitialize;
end

function UserDataAccumulateInitialize:execute()
	--UserDataAccumulateProxy
  local dataAccumulateProxy=UserDataAccumulateProxy.new();
  self:registerProxy(dataAccumulateProxy:getProxyName(),dataAccumulateProxy);
end