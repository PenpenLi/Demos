-- FileName: CCommonView.lua
-- Author: yucong
-- Date: 2016-02-20
-- Purpose: 通用的view，添加通知、计时器
--[[TODO List]]

CCommonView = class("CCommonView")

CCommonView._gi18n				= gi18n
CCommonView._mainLayer 	= nil

-- 加载通知项
function CCommonView:notifications( ... )
	return {
		--[CB_GET_SHARE_REWARD]	= function () self:fnMSG_CB_GET_SHARE_REWARD() end,
	}
end

-- 适配项
function CCommonView:adaptItems( ... )
	return {
	}
end

-- 计时器
function CCommonView:fnUpdate( ... )
	
end

-- 重连成功
function CCommonView:reconnect_OK( ... )
	
end

-- 重连失败
function CCommonView:reconnect_Failed( ... )
	
end

----------------------------------------------------

function CCommonView:ctor()
	logger:debug("self.__cname:"..self.__cname.." ctor()")
end

function CCommonView:registExitAndEnterCall( onExit, onEnter )
	assert(self._mainLayer, "_mainLayer is NULL!!")
	-- 注册onExit()
	UIHelper.registExitAndEnterCall(self._mainLayer, function ( ... )
		logger:debug("self.__cname:"..self.__cname.." onExit()")
		if (onExit) then
			onExit()
		end
		self:removeObserver()
		self:unschedule()
    end, function ( ... )
    	logger:debug("self.__cname:"..self.__cname.." onEnter()")
    	if (onEnter) then
    		onEnter()
    	end
    	self:schedule()
		self:addObserver()
		self:setAdapt()
    end)
end

function CCommonView:addObserver( ... )
	if (self.notifications) then
		for msg, func in pairs(self:notifications()) do
			GlobalNotify.addObserver(msg, func, false, self.__cname)
		end
	end
	if (self.reconnect_OK) then
		GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function ( ... )
			self:reconnect_OK()
		end, false, self.__cname)
	end
	if (self.reconnect_Failed) then
		GlobalNotify.addObserver(GlobalNotify.NETWORK_FAILED, function ( ... )
			self:reconnect_Failed()
		end, false, self.__cname)
	end
end

function CCommonView:removeObserver( ... )
	if (self.notifications) then
		for msg, func in pairs(self:notifications()) do
			GlobalNotify.removeObserver(msg, self.__cname)
		end
	end
	GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, self.__cname)
	GlobalNotify.removeObserver(GlobalNotify.NETWORK_FAILED, self.__cname)
end

function CCommonView:schedule( ... )
	-- 开启计时器
	GlobalScheduler.addCallback(self.__cname, function ( ... )
		if (self.fnUpdate) then
			self:fnUpdate()
		end
	end)
end

function CCommonView:unschedule( ... )
	GlobalScheduler.removeCallback(self.__cname)
end

function CCommonView:setAdapt( ... )
	if (self.adaptItems) then
		for k, widget in pairs(self:adaptItems()) do
			widget:setScale(g_fScaleX)
		end
	end
end

function CCommonView:i18n( id )
	return self._gi18n[id]
end

function CCommonView:i18nFormat( id, ... )
	return gi18nString(id, ...)
end
