-- FileName: OpenServerCtrl.lua
-- Author: yucong
-- Date: 2015-08-11
-- Purpose: 开服7日活动controller,管理主页面和三个子页面
--[[TODO List]]

module("OpenServerCtrl", package.seeall)
require "script/module/newServerReward/OpenServerView"
require "script/module/newServerReward/OpenServerModel"

local _pInstance	= nil
local _dModel = OpenServerModel

------------------------- 后端回调 -------------------------
-- 获取开服奖励
function onGetInfo( cbFlag, dictData, bRet )
	if (bRet) then
		local data = dictData.ret
		logger:debug(dictData)
		OpenServerModel.setStatusData(data)
		if (_pInstance == nil) then
			_pInstance = OpenServerView:new()
			_pInstance:setDelegate(OpenServerCtrl)
			LayerManager.changeModule(_pInstance:create(), moduleName(), {1, 3}, true)
			PlayerPanel.addForPartnerStrength()
		else
			GlobalNotify.postNotify(_dModel.MSG.CB_RELOAD)
		end
	end
end

-- 领取开服奖励
function onGainReward( cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug(dictData.ret)
		GlobalNotify.postNotify(_dModel.MSG.CB_GAIN_REWARD)
	end
end

-- 购买物品
function onBuy( cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug(dictData)
		if (dictData.ret.ret == "limit") then
			ShowNotice.showShellInfo(gi18n[6818])
			local data = _dModel.getDataByDay(_dModel.getDay())
			data.tShop.remainNum = tonumber(dictData.ret.remainNum)
			GlobalNotify.postNotify(_dModel.MSG.CB_BUY_FAILED)
		else
			local data = _dModel.getDataByDay(_dModel.getDay())
			data.tShop.buyFlag = 1
			data.tShop.remainNum = tonumber(dictData.ret.remainNum)
			GlobalNotify.postNotify(_dModel.MSG.CB_BUY_OK)
		end
	end
end

------------------- 请求后端接口 -----------------------
-- 领取分享奖励
-- @param forceValue 战斗力
function getInfo( forceValue )
	RequestCenter.weekweal_getInfo(onGetInfo, Network.argsHandlerOfTable({forceValue}))
end

-- 领取分享奖励
function gainReward( dutyId )
	RequestCenter.weekweal_obtainReward(onGainReward, Network.argsHandlerOfTable({dutyId}))
end

-- 购买物品
function buy( day )
	RequestCenter.weekweal_buy(onBuy, Network.argsHandlerOfTable({day}))
end

local function init(...)

end

function destroy(...)
	_pInstance = nil
	package.loaded["OpenServerCtrl"] = nil
end

function moduleName()
    return "OpenServerCtrl"
end

function create(...)
	getInfo(UserModel.getFightForceValue())
	-- _pInstance = OpenServerView:new()
	-- _pInstance:setDelegate(OpenServerCtrl)
	-- LayerManager.changeModule(_pInstance:create(), moduleName(), {1, 3}, true)
end
