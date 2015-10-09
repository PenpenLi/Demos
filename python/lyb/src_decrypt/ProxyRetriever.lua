--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-30

	yanchuan.xie@happyelements.com
]]

ProxyRetriever=class(Object);

function ProxyRetriever:ctor()
	self.class=ProxyRetriever;
end

function ProxyRetriever:retrieveProxy(proxy_name_string)
  return Facade.getInstance():retrieveProxy(proxy_name_string);
end