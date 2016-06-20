-- FileName: VipCardCtrl.lua
-- Author: LvNanchun
-- Date: 2015-07-01
-- Purpose: 月卡功能控制器
--[[TODO List]]

module("VipCardCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["VipCardCtrl"] = nil
end

function moduleName()
    return "VipCardCtrl"
end

function create()
	function vipcardInfoCallBack( cbFlag, dictData, bRet )
		if (bRet) then
			require "script/module/wonderfulActivity/vipcard/VipCardModel"
			VipCardModel.setVipCardInfo()
			local infoRetrun = dictData.ret
			VipCardModel.setVipCardPersonalInfo(infoRetrun)
			logger:debug({infoRetrun = infoRetrun})
			require "script/module/wonderfulActivity/vipcard/VipCardView"
			local _instanceView = VipCardView:new()
			MainWonderfulActCtrl.addLayChild(_instanceView:create())
		end
	end

	RequestCenter.vipCard_getInfo(vipcardInfoCallBack)
end
