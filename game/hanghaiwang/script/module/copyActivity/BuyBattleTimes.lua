-- FileName: BuyBattleTimes.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("BuyBattleTimes", package.seeall)

-- UI控件引用变量 --
local layoutMain
-- 模块局部变量 --
local copyId=nil --

local function init(...)

end

function destroy(...)
	package.loaded["BuyBattleTimes"] = nil
end

function moduleName()
    return "BuyBattleTimes"
end
--购买次数返回
function onBuyCallBack(cbFlag, dictData, bRet)
	if(dictData.ret~=nil and dictData.err=="ok")then
		local needGold = MainCopyModel.getBuyTimesGold(copyId)
		UserModel.addGoldNumber(-needGold)
		MainCopyModel.addBattleTimes(copyId)
		LayerManager.removeLayout()
		MainCopyCtrl.updateUI()  --更新UI
	end
end
--更新UI
function updateUI()
	if (layoutMain==nil) then
		return
	end
	local goldLb = g_fnGetWidgetByName(layoutMain, "LABN_GOLD_NUM")
	goldLb:setStringValue(MainCopyModel.getBuyTimesGold(copyId))

	local vipLb = g_fnGetWidgetByName(layoutMain, "LABN_VIP")
	vipLb:setStringValue(UserModel.getVipLevel())

	local canBuyLb = g_fnGetWidgetByName(layoutMain, "TFD_CANBUY_NUM")
	canBuyLb:setText(MainCopyModel.getBuyTimesRemainNum(copyId))
end
function create(id)
	copyId=id
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
		local mainLayout = g_fnLoadUI("ui/activity_buy_times.json")
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)

		local backBtn = g_fnGetWidgetByName(layoutMain, "BTN_CLOSE")
		backBtn:addTouchEventListener(UIHelper.onClose)

		local cancelBtn = g_fnGetWidgetByName(layoutMain, "BTN_CANCEL")
		cancelBtn:addTouchEventListener(UIHelper.onClose)

		--初始化贝利奖励
		local db=DB_Activitycopy.getDataById(id)
		
		local goldLb = g_fnGetWidgetByName(layoutMain, "TFD_GOLD_NUM")
		goldLb:setText(MainCopyModel.getBuyTimesGold(id))

		local vipLb = g_fnGetWidgetByName(layoutMain, "LABN_VIP")
		vipLb:setStringValue(UserModel.getVipLevel())

		local canBuyLb = g_fnGetWidgetByName(layoutMain, "TFD_CANBUY_NUM")
		canBuyLb:setText(MainCopyModel.getBuyTimesRemainNum(id))

		local copyLb = g_fnGetWidgetByName(layoutMain, "TFD_COPY")
		copyLb:setText(string.format(gi18n[4312],db.name))--"购买一次%s副本次数？"

		--购买
		local function onBuy(sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				
				if (MainCopyModel.getBuyTimesRemainNum(id)<=0) then
					ShowNotice.showShellInfo(gi18n[4313])--"今日购买次数已用完，请明天再来购买吧"
					return
				end
				--判断剩余次数
				if (MainCopyModel.getRemainAtackTimes(id)<=0) then
					local needGold = MainCopyModel.getBuyTimesGold(id)
					if (needGold ~= nil) then
						if(UserModel.getGoldNumber() >= needGold ) then
							--访问购买接口
							local arr = CCArray:create()
							arr:addObject(CCInteger:create(id))
							RequestCenter.buyActivityCopyTimes(onBuyCallBack,arr)
							AudioHelper.playBtnEffect("buttonbuy.mp3")
						else
							--ShowNotice.showShellInfo(gi18n[1950])
							local noGoldAlert = UIHelper.createNoGoldAlertDlg()
							LayerManager.addLayout(noGoldAlert)
							AudioHelper.playCommonEffect() 
						end
					end
				else
					ShowNotice.showShellInfo(gi18n[4320]) --"剩余次数用完才可以购买"
					AudioHelper.playCommonEffect() 
				end

				
			end
		end
		local sureBtn = g_fnGetWidgetByName(layoutMain, "BTN_ENSURE")
		sureBtn:addTouchEventListener(onBuy)
		
	end
	LayerManager.addLayout(layoutMain)
end
