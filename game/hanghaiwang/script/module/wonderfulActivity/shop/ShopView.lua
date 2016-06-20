-- FileName: ShopView.lua
-- Author: liweidong
-- Date: 2014-04-00
-- Purpose: 购买贝利ui显示
--[[TODO List]]

module("ShopView", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local json = "ui/activity_belly.json"
local dialogjson = "ui/activity_belly_tip.json"
local m_fnGetWidget = g_fnGetWidgetByName --读取UI组件方法
local m_mainWidget 
local m_tbEvent -- 按钮事件
local m_haveBuyCount --进入本页面后累计的购买次数，每次进入重新初始化为0
local m_buyRecord  --数组存放购买的十条记录列表
local m_i18n = gi18n

local function init(...)
	m_haveBuyCount=0
	m_buyRecord={}
end

function destroy(...)
	package.loaded["ShopView"] = nil
end

function moduleName()
    return "ShopView"
end

--创建购买记录面板
function loadBuyRecord( ... )
	for i=1,10,1 do
		local buyInfo = m_fnGetWidget(m_mainWidget, "LAY_BELLY_INFO"..i)
		buyInfo:setVisible(false)
		m_buyRecord[i]=buyInfo
	end
end

--[[desc:插入新的购买记录
    arg1: belly：获得的贝里数，storm：暴击倍数
    return: nil
—]]
function insertNewBuyRecord(belly,storm)
	if (m_haveBuyCount>=10) then
		m_haveBuyCount=10
		for i=1,9,1 do
			local curbelly = m_fnGetWidget(m_buyRecord[i], "TFD_GAIN_BELLY")
			local nextbelly = m_fnGetWidget(m_buyRecord[i+1], "TFD_GAIN_BELLY")
			curbelly:setText(nextbelly:getStringValue())

			local curstorm = m_fnGetWidget(m_buyRecord[i], "TFD_CRITICAL")
			local nextstorm = m_fnGetWidget(m_buyRecord[i+1], "TFD_CRITICAL")
			curstorm:setText(nextstorm:getStringValue())
			curstorm:setColor(nextstorm:getColor())
		end

	else
		m_haveBuyCount=m_haveBuyCount+1
		m_buyRecord[m_haveBuyCount]:setVisible(true)
	end

	local bellyLb = m_fnGetWidget(m_buyRecord[m_haveBuyCount], "TFD_GAIN_BELLY")
	bellyLb:setText(m_i18n[2237]..belly.. m_i18n[1520]) --TODO

	local stormLb = m_fnGetWidget(m_buyRecord[m_haveBuyCount], "TFD_CRITICAL")
	if (storm>1) then
		stormLb:setText(m_i18n[4386]..storm) --TODO
		local txtcolor = ccc3(0x4d,0xec,0x15)
		txtcolor= (storm>=4 and storm <=5) and ccc3(0x1f,0xd7,0xff) or txtcolor
		txtcolor= (storm>=6 and storm <=7) and ccc3(0xee,0x46,0xec) or txtcolor
		txtcolor= (storm>=8 and storm <=10) and ccc3(0xff,0x42,0x00) or txtcolor
		-- stormLb:setColor(txtcolor)
	else
		stormLb:setText("")
	end
end
function showBuyBellyDialog( showinfo )
	local m_dialog = g_fnLoadUI(dialogjson)
	LayerManager.addLayout(m_dialog)

	--关闭按钮
	local function closeEvent()
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
	end
	local BTN_CLOSE = m_fnGetWidget(m_dialog, "BTN_CLOSE")
	BTN_CLOSE:addTouchEventListener(closeEvent)
	local BTN_CANCEL = m_fnGetWidget(m_dialog, "BTN_CANCEL")
	UIHelper.titleShadow(BTN_CANCEL)
	BTN_CANCEL:addTouchEventListener(closeEvent)
	--确认按钮
	local BTN_CONFIRM = m_fnGetWidget(m_dialog, "BTN_CONFIRM")
	UIHelper.titleShadow(BTN_CONFIRM)
	BTN_CONFIRM:addTouchEventListener(showinfo.callback)

	local buyInfo = m_fnGetWidget(m_dialog, "TFD_BUY_INO")
	buyInfo:setText(string.format(m_i18n[4387],showinfo.times))
	local buygold = m_fnGetWidget(m_dialog, "TFD_TOTAL_GOLD_NUM")
	buygold:setText(showinfo.gold)
	
end
function lodaUI(  )
	
	updateUI()
	--加载购买记录UI
	loadBuyRecord()
	--购买按钮
	local BTN_BUY1 = m_fnGetWidget(m_mainWidget, "BTN_BUY1")
	BTN_BUY1:addTouchEventListener(m_tbEvent.onPower1) --注册按钮事件
	UIHelper.titleShadow(BTN_BUY1)

	local BTN_BUY10 = m_fnGetWidget(m_mainWidget, "BTN_BUY10")
	BTN_BUY10:addTouchEventListener(m_tbEvent.onPower10) --注册按钮事件
	UIHelper.titleShadow(BTN_BUY10)

	local imgStar = m_fnGetWidget(m_mainWidget, "IMG_STAR_EFFECT") 
	local imgLight = m_fnGetWidget(m_mainWidget, "IMG_LIGHT_EFFECT")

	local anStar = UIHelper.createArmatureNode({
		filePath = "images/effect/belly_star/belly_star.ExportJson",
		animationName = "belly_star",
		--loop = -1,
	})
	imgStar:addNode(anStar,100)
	schedule(m_mainWidget,function()
			anStar:getAnimation():play("belly_star")
		end,
		2.0
		)

	local anLight = UIHelper.createArmatureNode({
		filePath = "images/effect/shop_recruit/zhao3.ExportJson",
		animationName = "zhao3",
		loop = -1,
	})
	imgLight:addNode(anLight,100)
end

function updateUI( )
	if (m_mainWidget==nil) then
		return
	end
	local belly = m_fnGetWidget(m_mainWidget, "TFD_BELLY_NUM")
	belly:setText(UserModel.getSilverNumber())
	local gold = m_fnGetWidget(m_mainWidget, "TFD_GOLD_NUM")
	gold:setText(UserModel.getGoldNumber())

	require "script/module/shop/ShopUtil"
	local curgold = m_fnGetWidget(m_mainWidget, "TFD_GOLD")
	curgold:setText(ShopUtil.getSiliverPriceBy( ShopUtil.getBuyNumBy(11)+1 ))
	
	local maxLimitNum = ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(), 11)
	local remaincount = maxLimitNum-ShopUtil.getBuyNumBy(11)
	remaincount=remaincount>0 and remaincount or 0

	local buylimit1 = m_fnGetWidget(m_mainWidget, "TFD_CANBUY_NUM1")
	local buylimit2 = m_fnGetWidget(m_mainWidget, "TFD_CANBUY_NUM2")
	buylimit1:setText(tostring(remaincount))
	buylimit2:setText(tostring(maxLimitNum))

	local bellyNum = m_fnGetWidget(m_mainWidget, "TFD_BELLY_BASE")
	local m_goodsData = DB_Goods.getDataById(11)
	local haveBuyTime=ShopUtil.getBuyNumBy(11) -- 当前购买次数
	local factor1,factor2,factor3 = ShopUtil.getBuySiliverProperty()
	local getBelly=m_goodsData.buy_siliver_num+UserModel.getHeroLevel()*factor1
	getBelly = getBelly + math.min(haveBuyTime,factor3) *factor2
	bellyNum:setText(getBelly)

	require "script/module/shop/ShopUtil"
	local price = ShopUtil.getSiliverPriceBy( ShopUtil.getBuyNumBy(11)+1 )
	if (WonderfulActModel.tbBtnActList.buyMoney and tonumber(price)==0) then
		WonderfulActModel.tbBtnActList.buyMoney:setVisible(true)
		local numberLab = g_fnGetWidgetByName(WonderfulActModel.tbBtnActList.buyMoney,"LABN_TIP_EAT")
		numberLab:setStringValue("1")
	else
		WonderfulActModel.tbBtnActList.buyMoney:setVisible(false)
	end
end
--国际化
function setUIStyleAndI18n(base)
	UIHelper.labelNewStroke( base.TFD_DESC, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.tfd_own, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.tfd_gold_txt, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.tfd_belly_txt, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_GOLD_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_BELLY_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_GOLD, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_BELLY_BASE, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.tfd_can_buy, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_CANBUY_NUM1, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_SLANT, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_CANBUY_NUM2, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.tfd_ge, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.tfd_vip_info, ccc3(0x28,0x00,0x00), 2 )
end
function create(tbEvent)
	m_tbEvent = tbEvent
	init()
	m_mainWidget = g_fnLoadUI(json)
	UIHelper.registExitAndEnterCall(m_mainWidget,
			function()
				m_mainWidget=nil
			end,
			function()
			end
		)
	setUIStyleAndI18n(m_mainWidget)
	m_mainWidget:setSize(g_winSize)
	local img_bg = m_fnGetWidget(m_mainWidget, "img_bg")
	img_bg:setScale(g_fScaleX)
	lodaUI()
	return m_mainWidget
end
