-- FileName: GrabBuyCtrl.lua
-- Author: zhangjunwu
-- Date: 2015-04-09
-- Purpose: 购买夺宝次数 模块
--[[TODO List]]

module("GrabBuyCtrl", package.seeall)
require "script/module/shop/ShopUtil"
require "script/module/grabTreasure/TreasureData"
require "script/network/PreRequest"
require "db/DB_Loot"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
-- 模块局部变量 --
local m_pillId = 10042

local m_fnDelegate
local n_CostGold = 0
local m_updateStaminaCallback -- zhangqi, 2014-12-29, 保存刷新其他UI上体力值的回调方法
local m_updateGoldCallback

local function init(...)

end

function destroy(...)
	package.loaded["GrabBuyCtrl"] = nil
end

function moduleName()
	return "GrabBuyCtrl"
end


--开启宝箱的花费金币数为
function getGoldByTimes()
	--购买的次数,
	local buyTimes = TreasureData.getbuySeizeNum()
	logger:debug({buyTimes = buyTimes})
	local lootData = DB_Loot.getDataById(1)

	local per_arr = string.split(lootData.buyNeedGold, ",")
	local c_price = 0
	if(per_arr)then
		local tmp1 = string.split(per_arr[1],"|")
		local prekey,preval = tonumber(tmp1[1]),tonumber(tmp1[2])


		for _,val in pairs(per_arr) do
			local tmp = string.split(val,"|")
			if (tonumber(buyTimes)<tonumber(tmp[1])) then
				c_price = tmp[2]
				break
			end
		end

	else
		logger:debug("没有配置夺宝购买次数的金币配置")
	end

	return tonumber(c_price)
end


local function onBuy( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()

	end
end

function create(...)
	local buyTimesView  = g_fnLoadUI("ui/buy_grab.json")

	local btnCancel 	= m_fnGetWidget(buyTimesView,"BTN_CANCEL")
	local btnconfirm	= m_fnGetWidget(buyTimesView,"BTN_CONFIRM")
	local btnClose	    = m_fnGetWidget(buyTimesView,"BTN_CLOSE")

	UIHelper.titleShadow(btnconfirm, m_i18n[1324])
	UIHelper.titleShadow(btnCancel, m_i18n[1325])

	local TFD_DESC	    = m_fnGetWidget(buyTimesView,"TFD_DESC")
	local TFD_TXT	    = m_fnGetWidget(buyTimesView,"TFD_PROMPT_TXT")


	n_CostGold = getGoldByTimes()
	local nTimes = TreasureData.getGrabMaxNum()

	TFD_TXT:setText(m_i18nString(2454,n_CostGold,nTimes))
	TFD_DESC:setText(m_i18n[2453])

	btnClose:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager:removeLayout()
		end
	end)

	btnCancel:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			LayerManager:removeLayout()
		end
	end)

	btnconfirm:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			fnBuy()
		end
	end)

	LayerManager.addLayout(buyTimesView)
end

function fnBuy()
	--已经购买的次数
	local nTimesBought = tonumber(TreasureData.getbuySeizeNum())
	--当前玩家vip可购买的次数
	local nTimeVipCanBuy  =  tonumber(DB_Vip.getDataById(tonumber(UserModel.getVipLevel())+1).grab_num)
	--当前购买所需要的金币
	local nPriceCost = getGoldByTimes()
	logger:debug("已经购买的次数:%s | 当前玩家vip可购买的次数:%s | 当前购买所需要的金币%s:" ,nTimesBought,nTimeVipCanBuy,nPriceCost)
	if(nTimesBought >= nTimeVipCanBuy) then
		-- ShowNotice.showShellInfo("已达到当前vip允许购买的次数限制")
		ShowNotice.showShellInfo(m_i18n[1928])
		return
	end

	if(nPriceCost > UserModel.getGoldNumber()) then
		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
		LayerManager.addLayout(noGoldAlert)
		return
	end


	local function fnBuySeizeNumCallback( cbFlag, dictData, bRet )
		if(bRet) then
			UserModel.addGoldNumber(-nPriceCost)
			TreasureData.setbuySeizeNum()
			-- 			TreasureData.setCurGrabNum()
			-- 			PlayerPanel.updateGrabNum()
			updateInfoBar() -- 新信息条统一更新方法
			LayerManager.removeLayout()
		end
	end

	RequestCenter.fragseize_buySeizeNum(fnBuySeizeNumCallback,nil)
end



