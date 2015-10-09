--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-20

	yanchuan.xie@happyelements.com
]]

require "main.model.EquipmentInfoProxy";

EquipmentInitialize=class(Command);

function EquipmentInitialize:ctor()
	self.class=EquipmentInitialize;
end

function EquipmentInitialize:execute()
	--EquipmentInfoProxy
  local equipmentInfoProxy=EquipmentInfoProxy.new();
  self:registerProxy(equipmentInfoProxy:getProxyName(),equipmentInfoProxy);
end