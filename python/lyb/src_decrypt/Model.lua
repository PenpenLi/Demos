--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-30

	yanchuan.xie@happyelements.com
]]

require "core.mvc.pattern.Proxy";

Model=class(Object);

function Model:ctor()
	self.class=Model;
	self.proxies={};
end

function Model:hasProxy(proxy_name_string)
	return nil~=self.proxies[proxy_name_string];
end

function Model:registerProxy(proxy_name_string, proxy)
	if nil==proxy then
		error("wrong invoke" .. proxy_name_string);
	end
	
	if proxy:is(Proxy) then
		
	else
		error("wrong invoke" .. proxy_name_string);
	end
	
	if nil==self.proxies[proxy_name_string] then
		self.proxies[proxy_name_string]=proxy;
		return;
	end
	error("wrong invoke" .. proxy_name_string);
end

function Model:removeProxy(proxy_name_string)
	if self:hasProxy(proxy_name_string) then
		self.proxies[proxy_name_string]:onRemove();
		self.proxies[proxy_name_string]=nil;
	end
end

function Model:stop()
	for k,v in pairs(self.proxies) do
		self:removeProxy(k);
	end
end

function Model:retrieveProxy(proxy_name_string)
	return self.proxies[proxy_name_string];
end