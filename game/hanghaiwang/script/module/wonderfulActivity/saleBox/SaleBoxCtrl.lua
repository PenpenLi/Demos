-- FileName: SaleBoxCtrl.lua
-- Author: lvnanchun
-- Date: 2015-08-20
-- Purpose: 限时宝箱控制器
--[[TODO List]]

module("SaleBoxCtrl", package.seeall)
require "script/module/wonderfulActivity/saleBox/SaleBoxModel"
require "script/module/wonderfulActivity/saleBox/SaleBoxView"

-- UI variable --

-- module local variable --

local function init(...)

end

function destroy(...)
    package.loaded["SaleBoxCtrl"] = nil
end

function moduleName()
    return "SaleBoxCtrl"
end

function create(...)
	local tbBtnEvent = {}

	local function onBuyBtn( btnIndex , sender )
		require "script/model/user/UserModel"
		local infoIndex = "cellInfo" .. tostring(btnIndex)
		local tbOneCellInfo = SaleBoxModel.getCellInfo()[infoIndex]
		local nPrice = tonumber(tbOneCellInfo.discount)
		local function buyBoxCallBack( cbFlag, dictData, bRet )
			if (bRet) then
				UserModel.addGoldNumber(-nPrice)
				SaleBoxView:playRewardDlg(dictData.ret)
				SaleBoxModel.setReaminTime(btnIndex)
				SaleBoxView:refreshRemainTime(btnIndex)
				-- 应策划需求不现实红点
--				local mainActivity = WonderfulActModel.tbBtnActList.saleBox
--				mainActivity:setVisible(true)
--				local numRedPoint = SaleBoxModel.nGetRedPointNum()
--				mainActivity.LABN_TIP_EAT:setStringValue(numRedPoint)
--				if (numRedPoint == 0) then 
--					mainActivity.IMG_TIP:setVisible(false)
--				end
			end
		end 
		if (UserModel.getGoldNumber() < nPrice) then
			AudioHelper.playCommonEffect()
			LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
		else
			AudioHelper.playBtnEffect("buttonbuy.mp3")
			RequestCenter.chest_buyChest(buyBoxCallBack , Network.argsHandler(btnIndex))
		end
	end
		
	tbBtnEvent.onBuy1 = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			--AudioHelper.playBtnEffect("buttonbuy.mp3")
			onBuyBtn(1)
		end
	end

	tbBtnEvent.onBuy2 = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			--AudioHelper.playBtnEffect("buttonbuy.mp3")
			onBuyBtn(2)
		end
	end

	tbBtnEvent.onBuy3 = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			--AudioHelper.playBtnEffect("buttonbuy.mp3")
			onBuyBtn(3)
		end
	end

	local instanceView = SaleBoxView:new()
	MainWonderfulActCtrl.addLayChild(instanceView:create(tbBtnEvent))
end

