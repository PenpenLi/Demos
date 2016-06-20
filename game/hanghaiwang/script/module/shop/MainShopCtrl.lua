-- FileName: MainShopCtrl.lua
-- Author:zhangjunwu
-- Date: 2014-04-00
-- Purpose: 酒馆主界面
--[[TODO List]]

module("MainShopCtrl", package.seeall)

-- UI控件引用变量 --
-- 模块局部变量 --
local m_tabSelected  		= nil   -- tab切换是存放tab


require "script/module/shop/Props"
require "script/module/shop/ShopGiftCtrl"
require "script/module/shop/MainShopView"

-- 初始化
local function init()
	m_tabSelected 			= nil
end
function destroy(...)
	package.loaded["MainShopCtrl"] = nil
end

function moduleName()
	return "MainShopCtrl"
end
--[[desc:切换标签
    arg1: 被点击的tab
    return: 返回false表示点击了一个已经被选中的tab，则不再处理点击事件，返回true则表示标签页切换 
—]]
function setTabFocused( sender )
	MainShopView.setAllTabClick()

	sender:setFocused(true)
	sender:setTitleColor(g_TabTitleColor.selected)
	sender:setTouchEnabled(false)
end


function create(_tabIndex)
	init()
	local tbEvents = {}
	--道具tab
	tbEvents.onProps = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			UserModel.recordUsrOperationByCondition("shoponProps", 1) -- 打点记录  用户操作 2016-01-05

			AudioHelper.playTabEffect()

			if(not SwitchModel.getSwitchOpenState(ksSwitchBuyBox,true)) then
				return
			end

			logger:debug("tbBtnEvent.onProps")
			setTabFocused(sender)
			MainShopView.addPropsPage()


			-- 快捷出售界面
			require("script/module/rapidSale/RapidSaleCtrl")
			RapidSaleCtrl.create()


		end
	end
	--礼包tab
	tbEvents.onGifts = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()

			logger:debug("tbBtnEvent.onProps")
			setTabFocused(sender)
			MainShopView.addGiftPage()

		end
	end
	--酒馆tab
	tbEvents.onTavern = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()


			logger:debug("tbBtnEvent.onProps")
			setTabFocused(sender)
			MainShopView.addTavernPage()
		end
	end
	TimeUtil.timeStart("MainShopView.create")
	local layMain = MainShopView.create( tbEvents ,_tabIndex)
	
	TimeUtil.timeEnd("MainShopView.create")
	return layMain
end
