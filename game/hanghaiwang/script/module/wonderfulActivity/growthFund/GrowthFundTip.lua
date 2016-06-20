-- FileName: GrowthFundTip.lua
-- Author: lvnanchun and xufei
-- Date: 2015-06-19
-- Purpose: 成长基金的确认购买提示窗
--[[TODO List]]

module("GrowthFundTip", package.seeall)
require "script/module/wonderfulActivity/growthFund/GrowthFundModel"
require "script/module/wonderfulActivity/growthFund/EveryoneWelfareModel"

-- UI控件引用变量 --
local _btnBuy
local _fnFreshCells
local _listMain
local _layTab
local _layEveryoneWelfare

-- 模块局部变量 --
local _i18n = gi18n
local _coinsNeeded

function destroy(...)
	package.loaded["GrowthFundTip"] = nil
end

function moduleName()
    return "GrowthFundTip"
end

--[[desc:将传来的组件赋值给模块内的局部变量，便于在按钮事件中调用
    arg1: buyBtn购买的按钮，_listMainView是cell列表，refreshCells是刷新列表的函数
    return: 无 
—]]
function refreshCellAndButton( buyBtn, listMainView, refreshCells )
	_btnBuy = buyBtn
	_fnFreshCells = refreshCells or nil
	_listMain = listMainView or nil
end

--[[desc:按钮事件回调函数
    arg1: 略
    return: 无 
—]]
local function btnSureCallBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBuyGoods()

		function activateGrowthFund( cbFlag, dictData, bRet )
			logger:debug({activateGrowthFund = dictData})

			if (bRet) then 
				if (dictData.ret == 'ok') then
					ShowNotice.showShellInfo(_i18n[1343]) 

					UserModel.addGoldNumber(-_coinsNeeded)

					GrowthFundModel.setBuyTime()

					UIHelper.titleShadow( _btnBuy, _i18n[1452] )
					_btnBuy:setTouchEnabled(false)
					UIHelper.setWidgetGray(_btnBuy,true)

					if (_listMain) then
						_listMain:removeAllItems()
					end

					if (_fnFreshCells and type(_fnFreshCells) == "function") then
						_fnFreshCells()
					end

					LayerManager.removeLayout()

					_layTab.IMG_FUND_TIP:setVisible(GrowthFundModel.getUnprizedNumByTime() ~= 0)

					

					
					EveryoneWelfareModel.refreshBoughtNum({layWelfare = _layEveryoneWelfare, layTab = _layTab})
					
					
				end
			end
		end
		RequestCenter.growUp_activation(activateGrowthFund)
	end
end

function create(layTab, layEveryoneWelfare)
	_layTab = layTab
	_layEveryoneWelfare = layEveryoneWelfare
	_coinsNeeded = GrowthFundModel.coinsNeeded()
	local sumOfCoins = GrowthFundModel.countSumOfCoins()

	local layMain = g_fnLoadUI("ui/growth_fund_tip.json")

	local imgBg = layMain.img_bg 

	local btnSure = imgBg.BTN_CONFIRM
	UIHelper.titleShadow(btnSure, _i18n[1029])
	btnSure:addTouchEventListener(btnSureCallBack)

	local btnCancel = imgBg.BTN_CANCEL
	UIHelper.titleShadow(btnCancel, _i18n[1325])
	btnCancel:addTouchEventListener(UIHelper.onClose)

	imgBg.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	imgBg.lay_fit1.tfd_confirm:setText(_i18n[5707])
	imgBg.lay_fit1.TFD_GOLD_NUM:setText(_coinsNeeded)
	imgBg.lay_fit1.tfd_buy:setText(_i18n[5708])
	imgBg.lay_fit2.tfd_canget:setText(_i18n[5709])
	imgBg.lay_fit2.TFD_GOLD_TOTAL:setText(sumOfCoins)

	return layMain
end
