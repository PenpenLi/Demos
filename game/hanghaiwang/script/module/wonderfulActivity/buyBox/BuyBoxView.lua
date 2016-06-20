-- FileName: BuyBoxView.lua
-- Author: zhangjunwu
-- Date: 2014-08-22
-- Purpose: 购买宝箱 界面
--[[TODO List]]

module("BuyBoxView", package.seeall)

-- UI控件引用变量 --
local m_mainWidget = nil
local btnHelp = nil
local TFD_Gold = nil

local LABN_GOLDKEY_NUM 		= nil 			--拥有金钥匙的数量文本
local LABN_SILVERKEY_NUM 		= nil 			--拥有银钥匙的数量文本
local LABN_GREENKEY_NUM 		= nil 			--拥有铜钥匙的数量文本
-- 模块局部变量 --
local json = "ui/activity_box.json"
local m_fnGetWidget = g_fnGetWidgetByName --读取UI组件方法
local m_i18nString = gi18nString
local m_tbEvent -- 按钮事件


local function init(...)

end

function destroy(...)
	package.loaded["BuyBoxView"] = nil
end

function moduleName()
	return "BuyBoxView"
end

--更新处理
 function updateDarKCellLable(layParent)
 	if(layParent == nil) then
 		layParent = m_mainWidget
 	end
 	
	local LAY_MORE = m_fnGetWidget(layParent,"LAY_MORE")
	local LAY_THIS_TIME = m_fnGetWidget(layParent,"LAY_THIS_TIME")

	LAY_MORE.TFD_MORE:setText(m_i18nString(4023))
	LAY_MORE.TFD_CI:setText(m_i18nString(4024))
	LAY_MORE.TFD_ORANGE:setText(m_i18nString(1744))

	LAY_THIS_TIME.TFD_THIS_TIME:setText(m_i18nString(4025))
	LAY_THIS_TIME.TFD_ORANGE2:setText(m_i18nString(1744))


	LAY_MORE:setEnabled(false)
	LAY_THIS_TIME:setEnabled(false)
	local  normConfig = DB_Normal_config.getDataById(1)
	local nDarkCell =  normConfig.gold_box_change
	nDarkCell = tonumber(nDarkCell)
	logger:debug(nDarkCell)
	local nOpenedCount = BuyBoxData.getOpenedBoxNum() or 0
	logger:debug(nOpenedCount)
	local nNeedCount = (nDarkCell - nOpenedCount%nDarkCell) -1
	logger:debug(nOpenedCount)
	logger:debug(nNeedCount)
	if(nNeedCount == 0) then
		LAY_THIS_TIME:setEnabled(true)
	else
		LAY_MORE:setEnabled(true)
		LAY_MORE.TFD_TIMES:setText("" .. nNeedCount)
	end


end


--[[desc:更新所有箱子和钥匙的数量
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function updateUI()

	LABN_GOLDKEY_NUM:setText("" .. BuyBoxData.getKeyNumByTid(LABN_GOLDKEY_NUM:getTag()))
	LABN_SILVERKEY_NUM:setText("" .. BuyBoxData.getKeyNumByTid(LABN_SILVERKEY_NUM:getTag()))
	LABN_GREENKEY_NUM:setText("" .. BuyBoxData.getKeyNumByTid(LABN_GREENKEY_NUM:getTag()))

	updateDarKCellLable(m_mainWidget)

	--设置按钮的文字
	local nGoldKeyNum = BuyBoxData.getKeyNumByTid(LABN_GOLDKEY_NUM:getTag())
	local nSilverKeyNum = BuyBoxData.getKeyNumByTid(LABN_SILVERKEY_NUM:getTag())
	logger:debug(nGoldKeyNum)
	logger:debug(nSilverKeyNum)
	if(nGoldKeyNum < 10 and nGoldKeyNum >0)then
		UIHelper.titleShadow(m_mainWidget.BTN_OPEN10_BOX1,m_i18nString(4022))
	else
		UIHelper.titleShadow(m_mainWidget.BTN_OPEN10_BOX1,m_i18nString(4002))
	end

	if(nSilverKeyNum < 10 and nSilverKeyNum >0)then
		UIHelper.titleShadow(m_mainWidget.BTN_OPEN10_BOX2,m_i18nString(4022))
	else
		UIHelper.titleShadow(m_mainWidget.BTN_OPEN10_BOX2,m_i18nString(4002))
	end

	--

	local LAY_OPEN10_BOX1 = m_mainWidget.LAY_OPEN10_BOX1   		--金宝箱开启十次需要的金币 父节点 
	local LAY_OPEN1_BOX1 = m_mainWidget.LAY_OPEN1_BOX1    		--金钥匙开启1次需要的金币 父节点 
	LAY_OPEN10_BOX1:setEnabled(false)
	LAY_OPEN1_BOX1:setEnabled(false)

	local LAY_OPEN1_BOX2 = m_mainWidget.LAY_OPEN1_BOX2   		--银宝箱开启十次需要的金币 父节点 
	local LAY_OPEN10_BOX2 = m_mainWidget.LAY_OPEN10_BOX2    	--银钥匙开启1次需要的金币 父节点 
	LAY_OPEN1_BOX2:setEnabled(false)
	LAY_OPEN10_BOX2:setEnabled(false)

	if(nGoldKeyNum == 0) then
		UIHelper.titleShadow(m_mainWidget.BTN_OPEN10_BOX1,"")
		UIHelper.titleShadow(m_mainWidget.BTN_OPEN_BOX1,"")
		LAY_OPEN10_BOX1:setEnabled(true)
		LAY_OPEN1_BOX1:setEnabled(true)

		local maxNum = BuyBoxData.getKeyAddBuyTimeBy(UserModel.getVipLevel(), BuyBoxData.T_GOLD_BOX)
		logger:debug(maxNum)
		local boughtNum = BuyBoxData.getKeyBoughtNumByTid(BuyBoxData.T_GOLD_BOX)
		local nOneKeyPrice = 	BuyBoxData.getNeedGoldByMoreGoods( BuyBoxData.T_GOLD_BOX,boughtNum + 1, 1)
		local nTenKeyPrice = 	BuyBoxData.getNeedGoldByMoreGoods( BuyBoxData.T_GOLD_BOX,boughtNum + 1, 10)
		m_mainWidget.TFD_SPEND1_1:setText(nOneKeyPrice)
		m_mainWidget.TFD_SPEND10_1:setText(nTenKeyPrice)

	end
	if(nSilverKeyNum == 0) then
		UIHelper.titleShadow(m_mainWidget.BTN_OPEN10_BOX2,"")
		UIHelper.titleShadow(m_mainWidget.BTN_OPEN_BOX2,"")
		LAY_OPEN1_BOX2:setEnabled(true)
		LAY_OPEN10_BOX2:setEnabled(true)

		local maxNum = BuyBoxData.getKeyAddBuyTimeBy(UserModel.getVipLevel(), BuyBoxData.T_SILVER_BOX)
		logger:debug(maxNum)
		local boughtNum = BuyBoxData.getKeyBoughtNumByTid(BuyBoxData.T_SILVER_BOX)
		local nOneKeyPrice = 	BuyBoxData.getNeedGoldByMoreGoods( BuyBoxData.T_SILVER_BOX,boughtNum + 1, 1)
		local nTenKeyPrice = 	BuyBoxData.getNeedGoldByMoreGoods( BuyBoxData.T_SILVER_BOX,boughtNum + 1, 10)
		m_mainWidget.TFD_SPEND1_2:setText(nOneKeyPrice)
		m_mainWidget.TFD_SPEND10_2:setText(nTenKeyPrice)
	end
end

function resetBuyBoxInfo( )
	if(m_mainWidget) then
		-- 购买宝箱的网络后端回调
		local	function getBoxinfoCall( cbFlag, dictData, bRet )
			if(bRet) then
				BuyBoxData.setBoxInfo(dictData.ret)
				--重新计算钥匙的价格
				BuyBoxCtrl.getTotlePrice()
				BuyBoxTip.resetBuyBoxTip()
			else
				logger:debug("获取钥匙信息失败")
			end
		end

		RequestCenter.shop_getBoxInfo(getBoxinfoCall, nil)
	else
		logger:debug("m_mainWidget  not running")

	end
end


function create(tbEvent)
	m_tbEvent = tbEvent
	init()
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)

	UIHelper.registExitAndEnterCall(
		m_mainWidget, 
		function ( ... )
			m_mainWidget = nil
			PreRequest.removeBagDataChangedDelete()
			GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, moduleName() .. "_RemoveUILoading")
			GlobalNotify.removeObserver(GlobalNotify.TREAS_FRAG_CHANGED, GlobalNotify.TREAS_FRAG_CHANGED)
			logger:debug("registExitrCall buyboxCtruye")

		end,


		function (...)
			GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function ( ... )

												RequestCenter.bag_bagInfo(function (  cbFlag, dictData, bRet  )
													PreRequest.preBagInfoCallback(cbFlag, dictData, bRet)
													BuyBoxView.updateUI()
												end)

												LayerManager.begainRemoveUILoading()
									end, 
			nil, moduleName() .. "_RemoveUILoading")
			logger:debug("registEnterCall buyboxCtruye")


		end
	)


	btnHelp = m_fnGetWidget(m_mainWidget,"BTN_HELP")
	btnHelp:addTouchEventListener(m_tbEvent.onHelp) --注册按钮事件

	local BTN_BACK = m_fnGetWidget(m_mainWidget,"BTN_BACK")
	BTN_BACK:addTouchEventListener(m_tbEvent.onClose) --注册按钮事件

	local img_bg = m_fnGetWidget(m_mainWidget,"img_bg")
	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	img_bg:setScale(fScale)
	
	LABN_GOLDKEY_NUM = m_fnGetWidget(m_mainWidget,"TFD_KEY1")
	LABN_SILVERKEY_NUM = m_fnGetWidget(m_mainWidget,"TFD_KEY2")
	LABN_GREENKEY_NUM = m_fnGetWidget(m_mainWidget,"TFD_KEY3")

	LABN_GOLDKEY_NUM:setTag(BuyBoxData.T_GOLD_BOX)
	LABN_SILVERKEY_NUM:setTag(BuyBoxData.T_SILVER_BOX)
	LABN_GREENKEY_NUM:setTag(BuyBoxData.T_BRONZE_BOX)


	local BTN_OPEN_GOLDBOX_ONCE = m_fnGetWidget(m_mainWidget,"BTN_OPEN_BOX1")   --黄金宝箱开启一次按钮
	local BTN_OPEN_SILVERBOX_ONCE = m_fnGetWidget(m_mainWidget,"BTN_OPEN_BOX2") --白银宝箱开启一次按钮
	local BTN_OPEN_BRONZENBOX_ONCE = m_fnGetWidget(m_mainWidget,"BTN_OPEN_BOX3") --青铜宝箱开启一次 按钮
	local BTN_OPEN_GOLDBOX_TEN = m_fnGetWidget(m_mainWidget,"BTN_OPEN10_BOX1") 	----黄金宝箱开启10次按钮
	local BTN_OPEN_SILVERBOX_TEN= m_fnGetWidget(m_mainWidget,"BTN_OPEN10_BOX2")	--白银宝箱开启10次按钮
	local BTN_OPEN_BRONZEBOX_TEN = m_fnGetWidget(m_mainWidget,"BTN_OPEN10_BOX3")--青铜宝箱开启10次 按钮


	local LAY_CLOSE = m_fnGetWidget(m_mainWidget,"LAY_CLOSE")
	local LAY_OPEN = m_fnGetWidget(m_mainWidget,"LAY_OPEN")
	local IMG_BOX1_BG = m_fnGetWidget(m_mainWidget,"IMG_BOX1_BG")

	--如果还没有开启黄金宝箱的功能节点
	local isOpen,openLV,openVipLv = BuyBoxData.canOpenGoldBox()
	if( isOpen == false) then
		LAY_CLOSE:setEnabled(true)
		LAY_OPEN:setEnabled(false)
		local TFD_LEVEL = m_fnGetWidget(m_mainWidget,"TFD_LEVEL")
		TFD_LEVEL:setText(m_i18nString(4016,openLV,openVipLv))  --	[1204] = "%s级开启",
		UIHelper.labelNewStroke(TFD_LEVEL,ccc3(0x28,0x00,0x00), 2)
	else
		LAY_CLOSE:setEnabled(false)
		LAY_OPEN:setEnabled(true)
		BTN_OPEN_GOLDBOX_ONCE:addTouchEventListener(m_tbEvent.onOpenBox) --注册按钮事件
		BTN_OPEN_GOLDBOX_TEN:addTouchEventListener(m_tbEvent.onOpenBox) --注册按钮事件
		
		-- UIHelper.setWidgetGray(IMG_BOX1_BG,false)
	end

	UIHelper.titleShadow(BTN_OPEN_GOLDBOX_ONCE,m_i18nString(4001))
	UIHelper.titleShadow(BTN_OPEN_SILVERBOX_ONCE,m_i18nString(4001))
	UIHelper.titleShadow(BTN_OPEN_BRONZENBOX_ONCE,m_i18nString(4001))
	UIHelper.titleShadow(BTN_OPEN_GOLDBOX_TEN,m_i18nString(4002))
	UIHelper.titleShadow(BTN_OPEN_SILVERBOX_TEN,m_i18nString(4002))
	UIHelper.titleShadow(BTN_OPEN_BRONZEBOX_TEN,m_i18nString(4002))


	UIHelper.labelShadowWithText(m_mainWidget.TFD_OPEN10_BOX1,m_i18nString(4002))
	UIHelper.labelShadowWithText(m_mainWidget.TFD_OPEN1_BOX1,m_i18nString(4001))
	UIHelper.labelShadowWithText(m_mainWidget.TFD_OPEN1_BOX2,m_i18nString(4001))
	UIHelper.labelShadowWithText(m_mainWidget.TFD_OPEN10_BOX2,m_i18nString(4002))

	-- UIHelper.labelNewStroke(m_mainWidget.TFD_SPEND1_1)
	-- UIHelper.labelNewStroke(m_mainWidget.TFD_SPEND10_1)
	-- UIHelper.labelNewStroke(m_mainWidget.TFD_SPEND1_2)
	-- UIHelper.labelNewStroke(m_mainWidget.TFD_SPEND10_2)

	updateUI()

	BTN_OPEN_GOLDBOX_ONCE:setTag(BuyBoxData.OpenBoxType.OpenGoldOnce)
	BTN_OPEN_SILVERBOX_ONCE:setTag(BuyBoxData.OpenBoxType.OpenSilverOnce)
	BTN_OPEN_BRONZENBOX_ONCE:setTag(BuyBoxData.OpenBoxType.OpenBronzeOnce)

	BTN_OPEN_GOLDBOX_TEN:setTag(BuyBoxData.OpenBoxType.OpenGoldTen)
	BTN_OPEN_SILVERBOX_TEN:setTag(BuyBoxData.OpenBoxType.OpenSilverTen)
	BTN_OPEN_BRONZEBOX_TEN:setTag(BuyBoxData.OpenBoxType.OpenBronzeTen)

	BTN_OPEN_SILVERBOX_ONCE:addTouchEventListener(m_tbEvent.onOpenBox) --注册按钮事件
	BTN_OPEN_BRONZENBOX_ONCE:addTouchEventListener(m_tbEvent.onOpenBox) --注册按钮事件

	BTN_OPEN_SILVERBOX_TEN:addTouchEventListener(m_tbEvent.onOpenBox) --注册按钮事件
	BTN_OPEN_BRONZEBOX_TEN:addTouchEventListener(m_tbEvent.onOpenBox) --注册按钮事件

	return m_mainWidget
end
