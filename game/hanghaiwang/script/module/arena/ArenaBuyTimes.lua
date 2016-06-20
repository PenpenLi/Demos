-- FileName: ArenaBuyTimes.lua
-- Author: huxiaozhou
-- Date: 2015-04-10
-- Purpose: 购买竞技场挑战次数
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("ArenaBuyTimes", package.seeall)

-- UI控件引用变量 --
local m_mainWidget
-- 模块局部变量 --
local json = "ui/arena_buy_times.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString
local function init(...)
	m_mainWidget = nil
end

function destroy(...)
	package.loaded["ArenaBuyTimes"] = nil
end

function moduleName()
    return "ArenaBuyTimes"
end

function create(fndelegate)
	m_mainWidget = g_fnLoadUI(json)
	local gold = ArenaData.getNeedGoldByBuyNum()
	local times = ArenaData.getBuyAddTimes()
	local tfd_spend = m_fnGetWidget(m_mainWidget, "tfd_spend") 
	tfd_spend:setText(m_i18n[2244])
	local tfd_canbuy = m_fnGetWidget(m_mainWidget, "tfd_canbuy")
	tfd_canbuy:setText(m_i18n[1435])
	local TFD_GOLD = m_fnGetWidget(m_mainWidget, "TFD_GOLD")
	TFD_GOLD:setText(gold)
	local TFD_BUY_TIMES = m_fnGetWidget(m_mainWidget, "TFD_BUY_TIMES")
	TFD_BUY_TIMES:setText(times)
	local TFD_CONFIRM = m_fnGetWidget(m_mainWidget, "TFD_CONFIRM")
	TFD_CONFIRM:setText(m_i18n[2275] .. m_i18n[1436])

	m_mainWidget.TFD_IS:setText(m_i18n[6926])

	local tfd_desc = m_fnGetWidget(m_mainWidget, "tfd_desc")
	tfd_desc:setText(m_i18n[2265])

	local btnClose = m_fnGetWidget(m_mainWidget, "BTN_CLOSE")
	btnClose:addTouchEventListener(UIHelper.onClose)
	local BTN_ENSURE = m_fnGetWidget(m_mainWidget, "BTN_ENSURE")
	local BTN_CANCEL = m_fnGetWidget(m_mainWidget, "BTN_CANCEL")
	UIHelper.titleShadow(BTN_ENSURE, m_i18n[1324])
	UIHelper.titleShadow(BTN_CANCEL, m_i18n[1325])

	BTN_CANCEL:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)

	BTN_ENSURE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if gold>UserModel.getGoldNumber() then
				AudioHelper.playCommonEffect()
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
				return
			end

			AudioHelper.playBtnEffect("buttonbuy.mp3")
			local args = CCArray:create()
			args:addObject(CCInteger:create(1))
			RequestCenter.arena_buyArenaNum(function (cbFlag, dictData, bRet)
				if dictData.ret == "ok" then
					ShowNotice.showShellInfo(m_i18nString(2268,times))
					UserModel.addGoldNumber(-gold) -- 扣除金币
				 	ArenaData.addBuyTimes(1) -- 增加一次购买次数
				 	ArenaData.addTodayChallengeNum(times) -- 增加今日可挑战次数
				 	LayerManager.removeLayout()
				 	if fndelegate then
				 		fndelegate()
				 	end
				end
			 end,args)
		end
	end)

	return m_mainWidget
end
