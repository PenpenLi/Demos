-- FileName: ShareCtrl.lua
-- Author: yucong
-- Date: 2015-07-03
-- Purpose: 每日分享controller
--[[TODO List]]

module("ShareCtrl", package.seeall)

require "script/module/wonderfulActivity/share/ShareView"
require "script/module/wonderfulActivity/share/ShareModel"

local _pInstance	= nil

------------------------- 后端回调 -------------------------
-- 领取分享奖励
function onGetShareReward( cbFlag, dictData, bRet )
	if (bRet) then
		GlobalNotify.postNotify(ShareModel.MSG.CB_GET_SHARE_REWARD)
	end
end

-- 获取分享奖励信息
function onGetDailyShareInfo( cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug({dictData = dictData})
		local data = dictData.ret
		ShareModel.setStatus_handle(data)
		if (_pInstance == nil) then
			changeLayer()
		else
			GlobalNotify.postNotify(ShareModel.MSG.CB_SHARE_RELOAD)
		end
	end
end

-- 获取成就信息
function onGetAchieveInfo( cbFlag, dictData, bRet )
	if (bRet) then
		ShareModel.setAchieveInfo(dictData.ret)
		
		getShareInfo()
	end
end

------------------- 请求后端接口 -----------------------
-- 领取分享奖励
function getShareReward( id )
	logger:debug("getShareReward:"..tostring(id))
	RequestCenter.share_share(onGetShareReward, Network.argsHandlerOfTable({id}))
end

-- 获取分享奖励信息
function getShareInfo( ... )
	RequestCenter.share_getShareInfo(onGetDailyShareInfo)
end

-- 获取成就信息
function getAchieveInfo( ... )
	RequestCenter.getAchieInfo(onGetAchieveInfo)
end

------------------- 方法 -----------------------

function changeLayer( ... )
	_pInstance = ShareView:new()
	_pInstance:setDelegate(ShareCtrl)
	MainWonderfulActCtrl.addLayChild(_pInstance:create()) 
end

local function init(...)

end

function destroy(...)
	logger:debug("ShareCtrl:destroy")
	_pInstance = nil
	ShareModel.destroy()
	package.loaded["ShareCtrl"] = nil
end

function moduleName()
    return "ShareCtrl"
end

function create(...)
	logger:debug("ShareCtrl:create")
	--getShareInfo()
	getAchieveInfo()
end
