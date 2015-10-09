--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-30

	yanchuan.xie@happyelements.com
]]

require "core.utils.class";

Object=class();

function Object:ctor()
	self.class=Object;
end

function Object:dispose()
	self:removeSelf();
end

function Object:is(compareClass)
	if not compareClass then
		return false
	end

	local rawClass = self.class;
	while rawClass do
		if rawClass == compareClass then
			return true;
		end
		rawClass = rawClass.super;
	end

	return false;
end

function Object:removeSelf()
	self.class = nil;
end

function Object:toString()
	return "Object";
end