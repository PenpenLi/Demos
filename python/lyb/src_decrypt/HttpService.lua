--=======================================
-- Http请求服务
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  HttpService.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/05/20
-- descrip:   处理Http请求
--=======================================

HttpService = class();

-- 构造函数
function HttpService:ctor()
	self.class = HttpService;
	self.service = CCHttpService:create();
	self.service:retain();
end

-- 销毁对象
function HttpService:dispose()
	--HttpService.superclass.dispose(self);
	self.service:release();
	self.service = nil;
end

-- 设置URL地址
function HttpService:setUrl(url)
	self.service:setUrl(url);
end

-- 设置请求类型（默认为GET）
function HttpService:setRequestType(type)
	self.service:setRequestType(type);
end

-- 设置请求参数
function HttpService:setRequestData(buffer)
	self.service:setRequestData(buffer);
end

-- 设置HTTP请求响应回调方法
function HttpService:setResponseCallback(handler)
	self.service:setResponseScriptCallback(handler);
end

-- 设置HTTP请求错误回调方法
function HttpService:setErrorCallback(handler)
	self.service:setErrorScriptCallback(handler);
end

-- 发送请求
function HttpService:send()
	self.service:send();
end