--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-30

	yanchuan.xie@happyelements.com
]]

Proxy=class(Object);

function Proxy:ctor()
	self.class=Proxy;
end

rawset(Proxy,"name","Proxy");

function Proxy:getProxyName()
		return self.class.name;
end

function Proxy:onRemove()

end