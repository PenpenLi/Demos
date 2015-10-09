--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-20

	yanchuan.xie@happyelements.com
]]

require "main.model.FamilyProxy";

FamilyDataInitialize=class(Command);

function FamilyDataInitialize:ctor()
	self.class=FamilyDataInitialize;
end

function FamilyDataInitialize:execute()
	--FamilyProxy
  local familyProxy=FamilyProxy.new();
  self:registerProxy(familyProxy:getProxyName(),familyProxy);
end