-- FileName: ExplorTimesCtrl.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: 购买探索次数
--[[TODO List]]

module("ExplorTimesCtrl", package.seeall)

-- UI控件引用变量 --
local layoutMain = nil
local mainLayer = nil
-- 模块局部变量 --

local function init(...)
	local goldNum = g_fnGetWidgetByName(mainLayer, "LABN_GOLD")
	goldNum:setStringValue(ExplorData.getCurBuyGoldNumber())
	local addNum = g_fnGetWidgetByName(mainLayer, "TFD_ADD_TIMES")
	addNum:setText(ExplorData.getBuyOneAddExploreTimes())

	local itemNum = g_fnGetWidgetByName(mainLayer, "LABN_NUM_TIP")
	itemNum:setStringValue(ExplorData.getExploreItemNum())

	local goldLab = g_fnGetWidgetByName(mainLayer, "LABN_GOLD_COST_TXT")
	goldLab:setStringValue(ExplorData.getCurBuyGoldNumber())

	local remainTimes = g_fnGetWidgetByName(mainLayer, "LABN_BUY_NUM")
	remainTimes:setStringValue(ExplorData.getUserBuyMaxTimes()-ExplorData.getUseGoldTimes())

	local totleTimes = g_fnGetWidgetByName(mainLayer, "LABN_TODAY_NUM")
	totleTimes:setStringValue(ExplorData.getUserBuyMaxTimes())
end

function destroy(...)
	package.loaded["ExplorTimesCtrl"] = nil
end

function moduleName()
    return "ExplorTimesCtrl"
end
--发送请求购买
--buyType 0道具购买，1金币购买
function reqBuyTimes(buyType)
	local function reqBuyCallback(cbFlag, dictData, bRet)
		if(dictData.err=="ok")then
			LayerManager.removeLayout()
			if buyType==1 then
				-- ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝减少金币
				UserModel.addGoldNumber(-ExplorData.getCurBuyGoldNumber())
				ExplorData.addGoldBuyTimes()
			end
			local addnum = buyType==0 and ExplorData.getUseItemAddExploreTimes() or ExplorData.getBuyOneAddExploreTimes()
			ExplorData.addExploreTimesEvent(addnum)
			--已经不需要的界面 不需要国际化
			--ShowNotice.showShellInfo(string.format("恭喜增加%d次探索次数",tonumber(addnum)) )
			ExplorMainCtrl.updateExploreTimes()
		end
	end
	local reqArr = CCArray:create()
	reqArr:addObject(CCInteger:create(buyType))
	RequestCenter.buyExploreTimeReq(reqBuyCallback,reqArr)
end
--点击探索令购买
function onItemBuyCallbcak(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect()
	--探索次数
	local timeInfo = ExplorData.getExploreTimeInfo()
	if timeInfo.lastTime>0 then
		ShowNotice.showShellInfo(gi18n[4303])
		return
	end
	if ExplorData.getExploreItemNum()<=0 then
		--ShowNotice.showShellInfo("道具不足") --已经不需要的界面 不需要国际化
		return
	end
	reqBuyTimes(0)
end
--点击金币购买探索次数
function onGoldBuyCallback(sender,eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect()
	--探索次数
	local timeInfo = ExplorData.getExploreTimeInfo()
	if timeInfo.lastTime>0 then
		LayerManager.removeLayout()
		ShowNotice.showShellInfo(gi18n[4303])
		return
	end
	if ExplorData.getUserBuyMaxTimes()-ExplorData.getUseGoldTimes()<=0 then
		ShowNotice.showShellInfo(gi18n[4302])
		return
	end
	if(ExplorData.getCurBuyGoldNumber() > UserModel.getGoldNumber()) then
		LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
		return
	end
	reqBuyTimes(1)
end
function create(...)
	--主背景UI
	layoutMain = Layout:create()
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
				end,
				function()
				end
			)
		--副本标签
		mainLayer = g_fnLoadUI("ui/add_explore_num.json")
		mainLayer:setSize(g_winSize)
		layoutMain:addChild(mainLayer)

		local closeBtn = g_fnGetWidgetByName(mainLayer, "BTN_CLOSE")
		closeBtn:addTouchEventListener(
			function(sender, eventType)
				if (eventType ~= TOUCH_EVENT_ENDED) then
					return
				end
				AudioHelper.playCommonEffect()
				LayerManager.removeLayout()
			end
			)
		local itemBuyBtn = g_fnGetWidgetByName(mainLayer, "BTN_EXPLORE")
		itemBuyBtn:addTouchEventListener(onItemBuyCallbcak)
		local goldBuyBtn = g_fnGetWidgetByName(mainLayer, "BTN_GOLD")
		goldBuyBtn:addTouchEventListener(onGoldBuyCallback)
		
		init()
	end
	return layoutMain
end
