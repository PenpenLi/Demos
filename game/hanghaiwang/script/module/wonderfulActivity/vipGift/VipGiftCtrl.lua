-- FileName: VipGiftCtrl.lua
-- Author: lvnanchun
-- Date: 2015-08-12
-- Purpose: vip礼包控制器
--[[TODO List]]

module("VipGiftCtrl", package.seeall)
require "script/module/wonderfulActivity/vipGift/VipGiftView"
require "script/module/wonderfulActivity/vipGift/VipGiftModel"
require "script/network/RequestCenter"

-- UI variable --

-- module local variable --
local _instanceView

local function init(...)

end

function destroy(...)
    package.loaded["VipGiftCtrl"] = nil
end

function moduleName()
    return "VipGiftCtrl"
end

function create(...)
	local function vipGiftInfoCallBack( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug({dictData = dictData})
			_instanceView = VipGiftView:new()
			MainWonderfulActCtrl.addLayChild(_instanceView:create(dictData.ret))
		end
	end
	RequestCenter.vipBonus_getInfo(vipGiftInfoCallBack)
end

--[[desc:刷新界面显示
    arg1: 对应的界面，不传都刷
    return: 无  
—]]
function refreshLay( layType )
	if (layType == "day") then
		_instanceView:setLayDay()
	elseif (layType == "week") then
		_instanceView:setLayWeek()
	elseif (layType == "sale") then
		_instanceView:setLaySale()
	else
		_instanceView:setLayDay()
		_instanceView:setLayWeek()
		_instanceView:setLaySale()
	end
end

