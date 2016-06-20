-- FileName: WelfareShopCtrl.lua
-- Author: Xufei
-- Date: 2015-12-22
-- Purpose: 福利商店
--[[TODO List]]

module("WelfareShopCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _welfareShopViewInstance = nil
local sPath = "images/wonderfullAct/"
local _btnEvent = {}


local function init(...)

end

function destroy(...)
	WelfareShopModel.setCell(nil)
	package.loaded["WelfareShopCtrl"] = nil
end

function moduleName()
    return "WelfareShopCtrl"
end

function removeNew( ... )
	-- 移除new
	local listCell = WelfareShopModel.getCell()
	if (listCell) then
		listCell:removeNodeByTag(100)
	end
	WelfareShopModel.setNewAniState( 1 )
end

function getWelShopBackendAndShow( ... )
	local iconAct, iconName = WelfareShopModel.getIconActAndName()
	iconAct:loadTexture(sPath .. WelfareShopModel.getWelActIcon())
	iconName:loadTexture(sPath .. WelfareShopModel.getWelActNamePic())
	function getWelfareShopInfoCallback( cbFlag, dictData, bRet )
		if (bRet) then
			if (WelfareShopModel.getIsActivityOn()) then
				logger:debug("is_on_and_got_data_in_GetIsActivityAndShow")
				WelfareShopModel.setWelfareShopInfo(dictData.ret)
				_welfareShopViewInstance = WelfareShopView:new()
				removeNew()
				MainWonderfulActCtrl.addLayChild(_welfareShopViewInstance:create(_btnEvent))
			else
				ShowNotice.showShellInfo("活动已结束！") -- TODO
			end
		end
	end			
	RequestCenter.welfareShop_getInfo(getWelfareShopInfoCallback)
end

function create(...)
	if (not WelfareShopModel.getIsActivityOn()) then
		ShowNotice.showShellInfo("活动已结束！")	-- TODO
	elseif (WelfareShopModel.getIsNotPullBackend()) then
		logger:debug("dont_have_data_GetIsActivityAndShow")
		getWelShopBackendAndShow()
	elseif (not WelfareShopModel.getIsNowShowedActivityOpen()) then
		logger:debug("data_is_old_GetIsActivityAndShow")
		getWelShopBackendAndShow()
	else
		logger:debug("is_is_not_old_just_show")
		-- _welfareShopViewInstance = WelfareShopView:new()
		-- removeNew()
		-- MainWonderfulActCtrl.addLayChild(_welfareShopViewInstance:create(_btnEvent))
		getWelShopBackendAndShow()
	end
end
