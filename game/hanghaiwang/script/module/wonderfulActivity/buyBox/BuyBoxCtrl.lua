-- FileName: BuyBoxCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-08-22
-- Purpose: 精彩活动 购买宝箱
--[[TODO List]]

module("BuyBoxCtrl", package.seeall)
require "script/module/wonderfulActivity/buyBox/BuyBoxData"
require "script/module/wonderfulActivity/buyBox/BuyBoxView"
require "script/module/wonderfulActivity/MainWonderfulActCtrl"
require "script/module/shop/ShopUtil"
-- UI控件引用变量 --
-- 模块局部变量 --
local  m_nNumNeedBuy 	= 0 		--
local  openType 		= 0     	-- 开启类型，一次黄金箱子，10次黄金箱子，1次白银，10次白银，1次铜，10次铜
local  m_nOpenBoxNum 	= 0 		--开启多少个宝箱
local  nTotlePrice  	= 0  		--一共所需要的金币数量

local m_curKeyNum 		= 0   		--现在拥有的钥匙个数
local nKeyPrice 		= 0    	 	--钥匙花费的金币数量
local bBuyLimit 		= false 	--是否限购
local maxLimitNum 		= 0 		--剩余购买次数

local m_i18n 			= gi18n
local m_i18nString 		= gi18nString
local m_fnGetWidget 	= g_fnGetWidgetByName --读取UI组件方法

local m_bItemBagReding  = false 			--每次进入此模块的时候 吧全局的道具背包红点缓冲起来，用来处理买箱子和钥匙的红点判断

local m_nKeyTid =  0

local function init(...)
	m_nNumNeedBuy 	= 0
	m_curKeyNum 	= 0
	nTotlePrice 	= 0
	nKeyPrice 		= 0
	m_bItemBagReding = g_redPoint.bag.visible
	PreRequest.removeBagDataChangedDelete()
end

function destroy(...)
	package.loaded["BuyBoxCtrl"] = nil
end

function moduleName()
	return "BuyBoxCtrl"
end

--判断是否限购
function isLimitBy()
	bBuyLimit = BuyBoxData.getKeyAddBuyTimeBy(UserModel.getVipLevel(), m_nKeyTid) > 0 and true
	return bBuyLimit
end

--得到剩余的购买次数
function getBuyTimesBy()
	local maxNum = BuyBoxData.getKeyAddBuyTimeBy(UserModel.getVipLevel(), m_nKeyTid)
	logger:debug(maxNum)
	local boughtNum = BuyBoxData.getKeyBoughtNumByTid( m_nKeyTid)
	logger:debug(boughtNum)
	maxLimitNum = maxNum - boughtNum
	if(maxLimitNum < 0) then
		maxLimitNum = 0
	end
	return maxLimitNum
end

--计算需要购买的钥匙个数
local function setBuyBoxAndKeyNum()
	--现在拥有的钥匙个数
	m_curKeyNum = BuyBoxData.getKeyNumByTid(m_nKeyTid) or 0
	--需要购买的钥匙个数
	m_nNumNeedBuy = m_nOpenBoxNum - m_curKeyNum

	if(m_nNumNeedBuy < 0)then
		m_nNumNeedBuy = 0
	end

	fnBuyBoxKeyThenUse()
end

--开启逻辑
local function openLogic( ... )
	--金币充足
	if(nTotlePrice >= 0 and nTotlePrice <= UserModel.getGoldNumber()) then
		LayerManager.addUILoading()
		--购买箱子
		fnOpenBox()

	else
		--金币不足或者不需要购买钥匙，箱子
		require "script/module/public/UIHelper"
		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
		LayerManager.addLayout(noGoldAlert)
		LayerManager.begainRemoveUILoading()
	end
end
--重新计算需要开启的箱子个数，
local function fnSetOpenNum(  )
	m_curKeyNum = BuyBoxData.getKeyNumByTid(m_nKeyTid) or 0
	if(m_curKeyNum >0 and m_curKeyNum < 10) then
		m_nOpenBoxNum = m_curKeyNum
	end
end

--计算总共花费的金币数量
function getTotlePrice( ... )
	nTotlePrice = 0
	nKeyPrice = 0
	if(m_nNumNeedBuy > 0 ) then

		local maxNum = BuyBoxData.getKeyAddBuyTimeBy(UserModel.getVipLevel(), m_nKeyTid)
		logger:debug(maxNum)
		local boughtNum = BuyBoxData.getKeyBoughtNumByTid( m_nKeyTid)

		 nKeyPrice = 	BuyBoxData.getNeedGoldByMoreGoods( m_nKeyTid,boughtNum + 1, m_nNumNeedBuy)

		 logger:debug(nKeyPrice)
		-- nKeyPrice = BuyBoxData.getPriceByNum( m_nNumNeedBuy,m_nKeyTid)

	end
	nTotlePrice =  nKeyPrice

	logger:debug("需要购买的钥匙数量为" .. m_nNumNeedBuy)
	logger:debug("总共需要消费的金币数量为:" .. nTotlePrice)
	return nTotlePrice
end

--提示框点击了确认之后的回调
local  fnConfirmBuyBox = function (  sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		if(nTotlePrice >= 0 and nTotlePrice <= UserModel.getGoldNumber()) then
			AudioHelper.playBuyGoods()
		else
			AudioHelper.playCommonEffect()
		end

		LayerManager.removeLayout()
		openLogic()
	end
end

--购买一个钥匙和一个宝箱
function fnBuyBoxKeyThenUse()
	local keyImage = BuyBoxData.getKeyImgByTid(m_nKeyTid)
	--是否限购
	bBuyLimit = isLimitBy()
	--剩余购买次数
	maxLimitNum = getBuyTimesBy()
	--计算总价格
	getTotlePrice()

	local bIsMaxVip = BuyBoxData.fnIsGetVipTop()
	--现在拥有的钥匙 不足以满足 需要的开启次数
	if(m_nNumNeedBuy > 0 ) then
		--如果是限购的钥匙
		if(bBuyLimit == true) then
			--如果购买次数已经买完了
			if(maxLimitNum <= 0 ) then
				--一个钥匙都没有
				if(m_curKeyNum == 0) then
					--达到vip顶级了，提示无法购买
					if(bIsMaxVip) then
						ShowNotice.showShellInfo(m_i18n[2267])
						return
					else
						--弹出vip充值界面
						local boxName = BuyBoxData.getItemNameBy(m_nKeyTid)
						local tbParams = {}
						local tbParams = {sTitle = m_i18n[4015],
											sUnit = m_i18n[1422],
											sName = boxName,
											nNowBuyNum=BuyBoxData.getKeyAddBuyTimeBy(UserModel.getVipLevel(), m_nKeyTid),
											nNextBuyNum=BuyBoxData.getKeyAddBuyTimeBy(UserModel.getVipLevel() + 1, m_nKeyTid),}

						local layAlert = UIHelper.createVipBoxDlg(tbParams)
						LayerManager.addLayout(layAlert)
						return
					end

				elseif(m_curKeyNum > 0) then
					-- 购买次数没有了，那么就把剩余的都开启了  --还需要一个提示？
					m_nNumNeedBuy = 0
					m_nOpenBoxNum = m_curKeyNum
					nTotlePrice = 0
					logger:debug("就剩这么多钥匙了，你也买不了钥匙了，只能先开这么多")
					openLogic()
					return
				end

			elseif(maxLimitNum < m_nNumNeedBuy) then
				--限购次数小于需要购买的次数，则把限购的次数都买了
				m_nNumNeedBuy = maxLimitNum
				m_nOpenBoxNum = m_curKeyNum + maxLimitNum
			end

		else
			logger:debug("不限购，随便买")
		end

		getTotlePrice()
		
		require "script/module/wonderfulActivity/buyBox/BuyBoxTip"
		local tbInfo = {}
		tbInfo.spentGold = nTotlePrice
		tbInfo.keyNum = m_nNumNeedBuy
		tbInfo.KeyTid = m_nKeyTid
		tbInfo.onSure = fnConfirmBuyBox
		tbInfo.imageKey = keyImage
		tbInfo.onBack = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCloseEffect()
				LayerManager.removeLayout()
			end
		end

		logger:debug(tbInfo)
		local buyTip = BuyBoxTip.create(tbInfo)
		LayerManager.addLayout(buyTip)


	else
		logger:debug("你的背包里钥匙多的很，随便开")
		openLogic()
	end
end

--再开一次  再开十次
local function fnContinue( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then

		AudioHelper.playCommonEffect()

		LayerManager:removeLayout()
		
		local nTag = tonumber(sender:getTag())

		--黄金
		if(m_nKeyTid == BuyBoxData.T_GOLD_BOX) then
			--开启一次
			if(nTag == 1) then
				m_nOpenBoxNum = 1
			--开启十次
			elseif(nTag == 10) then
				m_nOpenBoxNum = 10
				fnSetOpenNum()
			end
		--白银
		elseif(m_nKeyTid == BuyBoxData.T_SILVER_BOX) then
			--开启一次
			if(nTag == 1) then
				m_nOpenBoxNum = 1
			--开启十次
			elseif(nTag == 10)then
				m_nOpenBoxNum = 10
				fnSetOpenNum()
			end
		--青铜		
		elseif(m_nKeyTid == BuyBoxData.T_BRONZE_BOX) then
			--开启一次
			if(nTag == 1) then
				m_nOpenBoxNum = 1
			--开启十次
			elseif(nTag == 10)then
				m_nOpenBoxNum = 10
				fnSetOpenNum()
			end
		end

		--计算需要购买的钥匙和箱子个数
		setBuyBoxAndKeyNum()
	end
end


local function setRewardLayerBtnTitle(alertDLG)

	local btnTenOpen = m_fnGetWidget(alertDLG,"BTN_10")
	local nKeyCount = BuyBoxData.getKeyNumByTid(m_nKeyTid)
	logger:debug({nKeyCount ==  nKeyCount})
	if(nKeyCount < 10 and nKeyCount >0) then
		logger:debug(nKeyCount)
		UIHelper.titleShadow(btnTenOpen,m_i18nString(4022))
		-- UIHelper.titleShadow(btnTenOpen,"m_i18nString(4022)")
	else
		UIHelper.titleShadow(btnTenOpen,m_i18nString(4002))
	end
end


local function setRewardLayerPrice(  alertDLG)
	local LAY_OPEN10_BOX1 = alertDLG.LAY_OPEN1_BOX1   		--金宝箱开启十次需要的金币 父节点 
	local LAY_OPEN1_BOX1 = alertDLG.LAY_OPEN1_BOX10    		--金钥匙开启1次需要的金币 父节点 
	LAY_OPEN10_BOX1:setEnabled(false)
	LAY_OPEN1_BOX1:setEnabled(false)

	local nKeyNum = BuyBoxData.getKeyNumByTid(m_nKeyTid)
	logger:debug(nKeyNum)
	logger:debug(m_nKeyTid)
	if(nKeyNum == 0) then
		LAY_OPEN10_BOX1:setEnabled(true)
		LAY_OPEN1_BOX1:setEnabled(true)

		local maxNum = BuyBoxData.getKeyAddBuyTimeBy(UserModel.getVipLevel(), m_nKeyTid)
		logger:debug(maxNum)
		local boughtNum = BuyBoxData.getKeyBoughtNumByTid(m_nKeyTid)
		local nOneKeyPrice = 	BuyBoxData.getNeedGoldByMoreGoods( m_nKeyTid,boughtNum + 1, 1)
		local nTenKeyPrice = 	BuyBoxData.getNeedGoldByMoreGoods( m_nKeyTid,boughtNum + 1, 10)
		logger:debug(nOneKeyPrice)
		logger:debug(nTenKeyPrice)
		alertDLG.TFD_SPEND1_1:setText(nOneKeyPrice)
		alertDLG.TFD_SPEND10_1:setText(nTenKeyPrice)

	end
end


--用来保存开箱子之后后端返回的数据，方便再背包推送之后调用弹出框的时候用
local  tb_DropInfo = {}
local  m_rewardAlertDlg = nil
--开启箱子
function fnOpenBox( ... )
	tb_DropInfo = {}
	m_rewardAlertDlg = nil
	--展示掉落物品
	local alert = nil
	local function useItemCallback( cbFlag, dictData, bRet )
		if(bRet) then
			logger:debug("useItemCallback")
			logger:debug(nTotlePrice)
			UserModel.addGoldNumber(-nTotlePrice)
			
			BuyBoxData.updateBoxInfo(m_nKeyTid,m_nOpenBoxNum,m_nNumNeedBuy)
			BuyBoxView.updateDarKCellLable()
			tb_DropInfo = dictData
			nTotlePrice = 0
			showItemDly()
		else
			local boxName = BuyBoxData.getItemNameBy(BoxItemTid)
			LayerManager.addLayout(UIHelper.createCommonDlg(m_i18nString(1534, boxName), nil, nil,1))
		end

		LayerManager.begainRemoveUILoading()
	end

	function showItemDly()
		local dlgTitle = m_i18n[1902] -- 面板标题，默认"开启宝箱"

			if ( not table.isEmpty(tb_DropInfo.ret)) then
				local tbDrop = tb_DropInfo.ret

				local tbGifts = ItemDropUtil.getDropItem(tbDrop)
				logger:debug(tbGifts)
				if(table.isEmpty(tbGifts)) then
					logger:debug("掉落的东西为空")
					return
				end
				
				ItemDropUtil.refreshUserInfo(tbGifts) -- zhangjunwu, 2014-12-6, 添加实参 true, 同步更新贝里、金币的缓存
				m_rewardAlertDlg = UIHelper.createRewardDlg(tbGifts, nil, true)
				LayerManager.addLayoutNoScale(m_rewardAlertDlg)
				-- --隐藏确定按钮
				local btnConfirm = m_fnGetWidget(m_rewardAlertDlg,"BTN_SURE")
				logger:debug(btnConfirm)
				btnConfirm:setEnabled(false)				

				local btnclose = m_fnGetWidget(m_rewardAlertDlg,"BTN_CLOSE")
				btnclose:setEnabled(false)
				btnclose:addTouchEventListener(UIHelper.onClose) --注册按钮事件

				--显示在开十次 再开一次按钮
				local LAY_OPEN_BOX = m_fnGetWidget(m_rewardAlertDlg,"lay_open")
				LAY_OPEN_BOX:setEnabled(true)
				LAY_OPEN_BOX:setVisible(true)
				local BTN_1  = m_fnGetWidget(LAY_OPEN_BOX,"BTN_1")
				local BTN_10 = m_fnGetWidget(LAY_OPEN_BOX,"BTN_10")



				BTN_1:setTag(1)
				BTN_10:setTag(10)

				-- --设置奖励面板上的必掉文字
				BuyBoxView.updateDarKCellLable(m_rewardAlertDlg)
				--银宝箱不存在必掉逻辑
				if(m_nKeyTid == BuyBoxData.T_SILVER_BOX) then
					local LAY_MORE = m_fnGetWidget(m_rewardAlertDlg,"LAY_MORE")
					local LAY_THIS_TIME = m_fnGetWidget(m_rewardAlertDlg,"LAY_THIS_TIME")

					LAY_MORE:setEnabled(false)
					LAY_THIS_TIME:setEnabled(false)
				end
				--添加按钮事件
				BTN_1:addTouchEventListener(fnContinue) --注册按钮事件
				BTN_10:addTouchEventListener(fnContinue) --注册按钮事件

				logger:debug("asdfasdf")
				UIHelper.titleShadow(BTN_1,m_i18nString(4008))
				UIHelper.titleShadow(BTN_10,m_i18nString(4009))

				m_bItemBagReding 		= g_redPoint.bag.visible
			end
	end
	--更新界面道具数量
	function openBoxBagDelegete()
		logger:debug("openBoxBagDelegete")
		--设置奖励面板上的必掉文字
		setRewardLayerBtnTitle(m_rewardAlertDlg)
		setRewardLayerPrice(m_rewardAlertDlg)
		BuyBoxView.updateUI()	
	end
	-- 参数
	--背包推送 后更新宝箱数量  2015-5-21由于宝物碎片不走背包推送，所以就在请求回来之后就展示奖励面板
	PreRequest.setBagDataChangedDelete(openBoxBagDelegete)
	GlobalNotify.addObserver(GlobalNotify.TREAS_FRAG_CHANGED, function ( ... )
				setRewardLayerBtnTitle(m_rewardAlertDlg)
				setRewardLayerPrice(m_rewardAlertDlg)
				BuyBoxView.updateUI()
	end, true, GlobalNotify.TREAS_FRAG_CHANGED)

	local params = CCArray:create()
	local nKeyItemId = BuyBoxData.getKeyDBId(m_nKeyTid)
	params:addObject(CCInteger:create(tonumber(nKeyItemId)))
	params:addObject(CCInteger:create(tonumber(m_nOpenBoxNum)))
	RequestCenter.shop_openBox(useItemCallback, params)
end

--设置道具背包红点
function setItemBagRedPoint()
	--由于再背包推送的时候 把全局的visible设置为默认的红点值，但是购买宝箱，钥匙后再使用的话，就应该吧全局的红点值重置
	logger:debug("此时道具背包是否有红点:")
	logger:debug(m_bItemBagReding)
	if(m_bItemBagReding == false) then
		g_redPoint.bag.visible 	= false
		m_bItemBagReding 		= g_redPoint.bag.visible
		require "script/module/main/MainScene"
		MainScene.updateBagPoint()
	end
end


function create(nCopyId, fnCallBack)
	local tbBtnEvent = {}
	-- 帮助按钮
	tbBtnEvent.onHelp = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onHelp")
			-- BuyBoxView.resetBuyBoxInfo()
			AudioHelper.playEffect("audio/effect/renwu.mp3")
			-- AudioHelper.playCommonEffect()
			local layIntroduce = g_fnLoadUI("ui/activity_box_help.json")
			LayerManager.addLayout(layIntroduce)

			local i18nDesc = g_fnGetWidgetByName(layIntroduce, "TFD_DESC1")
			i18nDesc:setText(m_i18nString(4011))
			local i18nDesc2 = g_fnGetWidgetByName(layIntroduce, "TFD_DESC2")
			i18nDesc2:setText(m_i18nString(4012))
			local i18nDesc3 = g_fnGetWidgetByName(layIntroduce, "TFD_DESC3")
			i18nDesc3:setText(m_i18nString(4013))

			local btnClose = g_fnGetWidgetByName(layIntroduce,"BTN_CLOSE")
			btnClose:addTouchEventListener(function ( sender, eventType)
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCloseEffect()
					LayerManager.removeLayout()
				end
			end
			)
		end
	end
	-- 返回
	tbBtnEvent.onClose = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onHelp")
			AudioHelper.playBackEffect()
			
			if(nCopyId) then
				local explorMain = ExplorMainCtrl.create(nCopyId)
				LayerManager.changeModule(explorMain, ExplorMainCtrl.moduleName(), {1,3}, true)
				PlayerPanel.addForExplorNew()
			else
				MainScene.homeCallback()
				local view = AllShopCtrl.create()
				LayerManager.addCommonLayout({wigLayout = view, scale = true, animation = true})
			end
		end
	end

	if fnCallBack then
		tbBtnEvent.onClose = fnCallBack
	end
	-- 开启按钮
	tbBtnEvent.onOpenBox = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			--logger:debug("tbBtnEvent.onOpenBox")
			openType = sender:getTag()

			if(openType == BuyBoxData.OpenBoxType.OpenGoldOnce) then
				m_nKeyTid = BuyBoxData.T_GOLD_BOX
				m_nOpenBoxNum = 1
			elseif (openType == BuyBoxData.OpenBoxType.OpenGoldTen) then
				m_nKeyTid = BuyBoxData.T_GOLD_BOX
				m_nOpenBoxNum = 10
				fnSetOpenNum()
			elseif (openType == BuyBoxData.OpenBoxType.OpenSilverOnce) then
				m_nKeyTid = BuyBoxData.T_SILVER_BOX
				m_nOpenBoxNum = 1
			elseif (openType == BuyBoxData.OpenBoxType.OpenSilverTen) then
				m_nKeyTid = BuyBoxData.T_SILVER_BOX
				m_nOpenBoxNum = 10
				fnSetOpenNum()
			elseif (openType == BuyBoxData.OpenBoxType.OpenBronzeOnce) then
				m_nKeyTid = BuyBoxData.T_BRONZE_BOX
				m_nOpenBoxNum = 1
			elseif (openType == BuyBoxData.OpenBoxType.OpenBronzeTen) then
				m_nKeyTid = BuyBoxData.T_BRONZE_BOX
				m_nOpenBoxNum = 10
				fnSetOpenNum()
				
			end

			setBuyBoxAndKeyNum()
		end
	end

	-- 购买宝箱的网络后端回调
	local	function getBoxinfoCall( cbFlag, dictData, bRet )
		if(bRet) then
			logger:debug(dictData.ret)
			BuyBoxData.setBoxInfo(dictData.ret)

			local buyBoxView = BuyBoxView.create(tbBtnEvent)
			LayerManager.changeModule(buyBoxView, BuyBoxCtrl.moduleName(), {1,3}, true)
			PlayerPanel.addForPublic()

		else
			logger:debug("获取钥匙信息失败")
		end
	end

	RequestCenter.shop_getBoxInfo(getBoxinfoCall, nil)

end
