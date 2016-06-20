-- FileName: MysteryCastleView.lua
-- Author: huxiaozhou
-- Date: 2014-05-19
-- Purpose: 神秘城堡主显示界面🐷
--[[TODO List]]

module("MysteryCastleView", package.seeall)
require "script/model/utils/HeroUtil"
require "script/module/public/UIHelper"


-- UI控件引用变量 --
local m_LSV_View
local m_LAY_CELL 
local TFD_HAIHUN_NUM 

-- 模块局部变量 --
local json = "ui/mystery_shop.json"
local m_fnGetWidget = g_fnGetWidgetByName --读取UI组件方法
local m_mainWidget 
local m_tbEvent -- 按钮事件
local tbGoodsData

local function init(...)
	m_LSV_View = nil
	m_LAY_CELL = nil
end

function destroy(...)
	package.loaded["MysteryCastleView"] = nil
end

function moduleName()
    return "MysteryCastleView"
end


function updateUIWidget(  )
	local img_bg = m_fnGetWidget(m_mainWidget, "img_bg")
	img_bg:setScale(g_fScaleX)

	local IMG_MOLIYA = m_fnGetWidget(m_mainWidget, "IMG_MOLIYA")
	IMG_MOLIYA:setScale(g_fScaleX)

	local LAY_ARROW_UP = m_fnGetWidget(m_mainWidget, "LAY_ARROW_UP")
	local LAY_ARROW_BOTTOM = m_fnGetWidget(m_mainWidget, "LAY_ARROW_BOTTOM")
	
	sprArrowUp = CCSprite:create("images/common/mystical_shop_arrow_up.png")
	LAY_ARROW_UP:addNode(sprArrowUp)
	sprArrowUp:setAnchorPoint(ccp(0, 0))
	arrowAction(sprArrowUp)

	sprArrowDown = CCSprite:create("images/common/mystical_shop_arrow_bottom.png")
	LAY_ARROW_BOTTOM:addNode(sprArrowDown)
	sprArrowDown:setAnchorPoint(ccp(0, 0))
	arrowAction(sprArrowDown)

	sprArrowUp:setVisible(false)
	sprArrowDown:setVisible(true)

	local i18nBTN_FENJIE = m_fnGetWidget(m_mainWidget,"BTN_FENJIE") -- 分解按钮
	UIHelper.titleShadow(i18nBTN_FENJIE,gi18nString(2063)) -- 去分解按钮阴影

	local tfd_refresh_vip = m_mainWidget.tfd_refresh_vip
	tfd_refresh_vip:setEnabled(true)
	UIHelper.labelNewStroke(tfd_refresh_vip,ccc3(0x28,0x00,0x00))
	-- zhangjunwu, 2014-09-03, tfd 改为数字标签 2015-08-14  数字标签改回 tfd 呵呵坑爹
	local layTop = m_mainWidget.LAY_TOP

	
	UIHelper.labelAddNewStroke(layTop.TFD_DESC, gi18n[2060], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(layTop.tfd_own, gi18n[2089], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(layTop.tfd_haihun_txt, gi18n[2061], ccc3(0x28,0x00,0x00))


	TFD_HAIHUN_NUM = m_fnGetWidget(layTop,"TFD_HAIHUN_NUM") -- 拥有海魂数
	-- zhangjunwu, 2014-09-03, tfd 改为数字标签
	UIHelper.labelAddNewStroke(TFD_HAIHUN_NUM, "0", ccc3(0x28,0x00,0x00))



	local i18ntfd_refresh = m_fnGetWidget(m_mainWidget,"tfd_refresh") -- 距离下次刷新时间。。。
	UIHelper.labelAddNewStroke(i18ntfd_refresh,gi18nString(2064),ccc3(0x28,0x00,0x00))

	local TFD_REFRESH_TIME = m_fnGetWidget(m_mainWidget,"TFD_REFRESH_TIME") -- 倒计时 －－ 免费刷新次数获得时间：
	UIHelper.labelNewStroke(TFD_REFRESH_TIME,ccc3(0x28,0x00,0x00))

	i18ntfd_refresh:setEnabled(true)
	TFD_REFRESH_TIME:setEnabled(true)
	local TFD_LIMIT = m_mainWidget.TFD_LIMIT
	UIHelper.labelNewStroke(TFD_LIMIT,ccc3(0x28,0x00,0x00))
	local BTN_REFRESH = m_fnGetWidget(m_mainWidget,"BTN_REFRESH") --刷新按钮
	


	local i18nTFD_ITEM = m_fnGetWidget(m_mainWidget,"TFD_ITEM") -- 道具刷新
	local i18nFTD_GOLD = m_fnGetWidget(m_mainWidget,"TFD_GOLD") -- 金币刷新
	local TFD_FREE = m_fnGetWidget(m_mainWidget,"TFD_FREE") -- 免费刷新：
	UIHelper.labelAddNewStroke(TFD_FREE,gi18nString(2070),ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(i18nTFD_ITEM,gi18nString(2071),ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(i18nFTD_GOLD,gi18nString(2072),ccc3(0x28,0x00,0x00))


	local TFD_GOLD_NUM = m_fnGetWidget(m_mainWidget,"TFD_GOLD_NUM") -- 金币数量
	local TFD_ITEM_NUM = m_fnGetWidget(m_mainWidget,"TFD_ITEM_NUM") --道具数量
	local TFD_FREE_NUM = m_fnGetWidget(m_mainWidget,"TFD_FREE_NUM") -- 免费刷新次数
	
	UIHelper.labelNewStroke(TFD_GOLD_NUM,ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(TFD_ITEM_NUM,ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(TFD_FREE_NUM,ccc3(0x28,0x00,0x00))


	local IMG_REFRESH_ITEM = m_fnGetWidget(m_mainWidget, "IMG_REFRESH_ITEM") --道具图标
	local IMG_GOLD_2 = m_fnGetWidget(m_mainWidget, "IMG_GOLD_2") --金币图标


	m_LSV_View = m_fnGetWidget(m_mainWidget,"LSV_CELL") --listview
	m_LAY_CELL = m_fnGetWidget(m_mainWidget,"LAY_CELL")	

	TFD_HAIHUN_NUM:setText(UserModel.getJewelNum())  --zhangjunwu 2014-09-04
	TFD_REFRESH_TIME:setText(TimeUtil.getTimeString(MysteryCastleData.getRefreshCdTime()))

	local layFree = m_mainWidget.LAY_FREE
	local layItem = m_mainWidget.LAY_ITEM
	local layGold = m_mainWidget.LAY_GOLD
	local layNoTimes = m_mainWidget.LAY_NOTIMES
	layNoTimes.TFD_NOTIMES:setText(gi18n[6930])
	UIHelper.labelNewStroke(layNoTimes.TFD_NOTIMES,ccc3(0x28,0x00,0x00))
	layFree:setEnabled(false)
	layItem:setEnabled(false)
	layGold:setEnabled(false)
	layNoTimes:setEnabled(false)
	local itemNum = MysteryCastleData.getItemNum()
	local freeNum = MysteryCastleData.getFreeTimes()
	local max = DB_Vip.getDataById(tonumber(UserModel.getVipLevel())).mysicalShopAddTime
	if(tonumber(freeNum) >0) then

		layFree:setEnabled(true)

		TFD_FREE_NUM:setText(freeNum .. "/" .. max)
		if (tonumber(freeNum) >= tonumber(max) ) then
			i18ntfd_refresh:setEnabled(false)
			TFD_LIMIT:setEnabled(true)
		else 
			TFD_LIMIT:setEnabled(false)
		end

		UIHelper.titleShadow(BTN_REFRESH,gi18nString(6929,MysteryCastleData.getLastRfrTimes()))
	else 
		if (itemNum<=0 and not MysteryCastleData.isRfrMax()) then
			TFD_GOLD_NUM:setText(MysteryCastleData.getRfrGoldNum())
			layGold:setEnabled(true)
		elseif(MysteryCastleData.isRfrMax()) then
			logger:debug("layNoTimes:setEnabled(true)")
			layNoTimes:setEnabled(true)
		else
			layItem:setEnabled(true)
			TFD_ITEM_NUM:setText(UIHelper.longToShortNum(itemNum, 6))
		end
		UIHelper.titleShadow(BTN_REFRESH,gi18nString(6929,MysteryCastleData.getLastRfrTimes()))
	end


	

	-- 更新倒计时
	local function updateRfrTime()
		local freeNum = MysteryCastleData.getFreeTimes()
		if (tonumber(freeNum) < tonumber(max)) then 
			i18ntfd_refresh:setEnabled(true)
			TFD_REFRESH_TIME:setEnabled(true)
			if (MysteryCastleData.getRefreshCdTime() <= 0) then 
				logger:debug("here here2")
				MysteryCastleData.resetSysRefreshTimes()
				MysteryCastleData.setFreeTimes()
				updateUIWidget()
			else 
				--logger:debug("here here3")
				TFD_REFRESH_TIME:setText(TimeUtil.getTimeString(MysteryCastleData.getRefreshCdTime()))
			end
		else
			logger:debug("here here1")
			i18ntfd_refresh:setEnabled(false)
			TFD_REFRESH_TIME:setEnabled(false)
		end

	end



	if (tonumber(freeNum) < tonumber(max)) then 
	-- 启动定时器
		logger:debug("here here5")
		if( MysteryCastleData.castleScheduleId ~= nil )then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(MysteryCastleData.castleScheduleId)
   			MysteryCastleData.castleScheduleId = nil
		end
		MysteryCastleData.castleScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateRfrTime, 1, false)

	else 
		logger:debug("here here4")
		i18ntfd_refresh:setEnabled(false)
		TFD_REFRESH_TIME:setEnabled(false)
		TFD_LIMIT:setEnabled(true)
	end

	--liweidong 改成UIHelper调用
	UIHelper.registExitAndEnterCall(m_mainWidget,function()
			if (MysteryCastleData.castleScheduleId ~= nil) then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(MysteryCastleData.castleScheduleId)
				MysteryCastleData.castleScheduleId = nil
			end
		end)
	
	
	BTN_REFRESH:addTouchEventListener(m_tbEvent.onRfr)
	i18nBTN_FENJIE:addTouchEventListener(m_tbEvent.onResolve)
	m_mainWidget.BTN_BCAK:addTouchEventListener(m_tbEvent.onBack)

end

function onHeroIcon( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onHeroIcon")
			require "script/module/public/PublicInfoCtrl"
			local goods = tbGoodsData[sender:getTag()]
			PublicInfoCtrl.createHeroInfoView(goods.tid)
	end
end



function updateGoldAndHaihun(  )
	TFD_HAIHUN_NUM:setText(UserModel.getJewelNum())  --zhangjunwu 2014-09-04
end


function loadCell( cell,_tbData,tag, bAction)
	local layCell
	local pos = ccp(0,0)
	if tag%2 ==0 then
		layCell = cell.LAY_CELL1
		pos = ccp(700,0)
	else
		layCell = cell.LAY_CELL
		pos = ccp(-400,0)
	end

	local posDes = ccp(layCell:getPosition())
	if bAction then
		cellActionIn(layCell,math.ceil(tag/2), function()  end, pos, posDes)
	end


	local layNum = layCell.LAY_NUM
	local itemData = ItemUtil.getItemById(_tbData.tid)
	layNum:setEnabled(itemData.isHeroFragment or itemData.isTreasureFragment)
	if itemData.isHeroFragment then
		local num = tonumber(itemData.nOwn)
		local max = tonumber(itemData.nMax)
		local tfdNumOwn = layCell.TFD_NUM_OWN   -- 物品当前数量
		local tfdNumNeed = layCell.TFD_NUM_NEED
		tfdNumOwn:setText(num)
		tfdNumNeed:setText(max)
		if tonumber(num)<tonumber(max) then
			tfdNumOwn:setColor(ccc3(0xd8, 0x14, 0x00))
		else
			tfdNumOwn:setColor(ccc3(0x00, 0x8a, 0x00))
		end
	elseif itemData.isTreasureFragment then
		local num, max = itemData.nOwn, itemData.nMax
		local tfdNumOwn = layCell.TFD_NUM_OWN   -- 物品当前数量
		local tfdNumNeed = layCell.TFD_NUM_NEED
		tfdNumOwn:setText(num)
		tfdNumNeed:setText(max)
		if tonumber(num)<tonumber(max) then
			tfdNumOwn:setColor(ccc3(0xd8, 0x14, 0x00))
		else
			tfdNumOwn:setColor(ccc3(0x00, 0x8a, 0x00))
		end
	end
	

	local LAY_GOODS = m_fnGetWidget(layCell,"LAY_GOODS") -- 物品图标LAYOUT
	local IMG_CLASS2 = m_fnGetWidget(layCell,"IMG_CLASS2")
	local TFD_NAME = m_fnGetWidget(layCell,"TFD_NAME") -- 物品名称
	UIHelper.labelEffect(TFD_NAME)

	local IMG_HAIHUN = m_fnGetWidget(layCell,"IMG_HAIHUN") -- 海魂图标
	local IMG_GOLD = m_fnGetWidget(layCell,"IMG_GOLD")  --金币图标
	IMG_HAIHUN:setEnabled(true)
	IMG_GOLD:setEnabled(true)
	local TFD_COST_NUM = m_fnGetWidget(layCell,"TFD_COST_NUM") -- 花费数量
	UIHelper.labelEffect(TFD_COST_NUM)

	local i18nBTN_EXCHANGE = m_fnGetWidget(layCell,"BTN_EXCHANGE") --兑换按钮
	local i18nLabExchange = m_fnGetWidget(layCell, "TFD_EXCHANGE")
	UIHelper.labelShadowWithText(i18nLabExchange,gi18nString(2203))
	local itemIcon,tbItemInfo
	if(_tbData.type == 1) then
			itemIcon,tbItemInfo = ItemUtil.createBtnByTemplateIdAndNumber(_tbData.tid,_tbData.num,function ( sender,eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
					require "script/module/public/PublicInfoCtrl"
					PublicInfoCtrl.createItemInfoViewByTid(_tbData.tid,_tbData.num)
			end
		end)
	elseif(_tbData.type== 2) then
		itemIcon,tbItemInfo= HeroUtil.createHeroIconBtnByHtid(_tbData.tid,nil,onHeroIcon) 
		itemIcon:setTag(tag)
		IMG_CLASS2:setEnabled(false)
	elseif(_tbData.type ==3) then
		 itemIcon,tbItemInfo = ItemUtil.createBtnByTemplateIdAndNumber(_tbData.tid, _tbData.num, function ( sender,eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
					require "script/module/public/PublicInfoCtrl"
					PublicInfoCtrl.createItemInfoViewByTid(_tbData.tid,_tbData.num)
			end
		end)

	end

	local tGoods = {}
	tGoods.recommended = _tbData.recommended
  	if (tbItemInfo.isHeroFragment)then
  		tGoods.isHeroFragment = true
  		tGoods.tid = tbItemInfo.aimItem
	elseif(tbItemInfo.isFragment) then
		IMG_CLASS2:setEnabled(false)
	
  	elseif(tbItemInfo.isTreasureFragment) then
  		tGoods.isTreasureFragment = true
  		tGoods.tid = tbItemInfo.treasureId
	else
		IMG_CLASS2:setEnabled(false)
	end
	LAY_GOODS:removeChildByTag(10, true)
	LAY_GOODS:addChild(itemIcon,-1,10)
	itemIcon:setPosition(ccp(LAY_GOODS:getSize().width*.5,LAY_GOODS:getSize().height*.5))
	local texteure = UIHelper.getMysteryShopRecommendType(tGoods)
	LAY_GOODS.IMG_RECOMMAND:setEnabled( texteure and true)
	LAY_GOODS.IMG_RECOMMAND:loadTexture(texteure or "")
	local color =  g_QulityColor[tonumber(tbItemInfo.quality)]

	TFD_NAME:setText(tbItemInfo.name)
	if(color ~= nil) then
		TFD_NAME:setColor(color)
	end

	--显示花费  1：花费类型为魂玉 , 2：花费类型为金币
	IMG_GOLD:setVisible(false)
	IMG_HAIHUN:setVisible(false)
	TFD_COST_NUM:setText(_tbData.costNum)
	if (_tbData.costType == 1) then
		IMG_HAIHUN:setVisible(true)
		i18nBTN_EXCHANGE:setTitleText(gi18n[2203])
	else
		
		IMG_GOLD:setVisible(true)
		i18nBTN_EXCHANGE:setTitleText(gi18n[1319])
	end
	i18nBTN_EXCHANGE:addTouchEventListener(m_tbEvent.onBuy)
	i18nBTN_EXCHANGE:setTag(tag)
	 i18nBTN_EXCHANGE:setGray(false)
	 i18nBTN_EXCHANGE:setTouchEnabled(true)
	if(_tbData.canBuyNum<=0) then

        i18nBTN_EXCHANGE:setGray(true)
		i18nBTN_EXCHANGE:setTouchEnabled(false)

		if _tbData.costType == 1 then
			i18nBTN_EXCHANGE:setTitleText(gi18n[2076])
		else
			i18nBTN_EXCHANGE:setTitleText(gi18n[2077])
		end
	end

end

-- 箭头的动画
function arrowAction( arrow)
	local arrActions_2 = CCArray:create()
	arrActions_2:addObject(CCFadeOut:create(1))
	arrActions_2:addObject(CCFadeIn:create(1))
	local sequence_2 = CCSequence:create(arrActions_2)
	local action_2 = CCRepeatForever:create(sequence_2)
	arrow:runAction(action_2)
end

function getCellItemById( nIdx )
	local index = math.ceil(nIdx/2)- 1
	return	m_LSV_View:getItem(index)
end


function updateArrow( )
		-- 检测是不是滑动到底部 和 顶部
		local offset = m_LSV_View:getContentOffset()
		local lisvSizeH = m_LSV_View:getSize().height
		local lisvContainerH = m_LSV_View:getInnerContainerSize().height 
		if (offset - lisvSizeH < 1) then
			sprArrowUp:setVisible(false)
		else
			sprArrowUp:setVisible(true)
		end

		if(offset- lisvContainerH <0) then
			sprArrowDown:setVisible(true)
		else
			sprArrowDown:setVisible(false)
		end
	
end


function cellActionIn( layCell, animatedIndex,fnCallback, pos, posDes)
	layCell:setPosition(pos)
	local moveto = CCMoveTo:create(g_cellAnimateDuration * (animatedIndex), posDes)
	local func = CCCallFunc:create(fnCallback)
	local actionArray = CCArray:create()
	actionArray:addObject(moveto)
	actionArray:addObject(func)
	local seq = CCSequence:create(actionArray)
	layCell:runAction(seq)
end

function createView(  )
	TimeUtil.timeStart("createView")
	tbGoodsData = MysteryCastleData.getGoodsListData()

	UIHelper.initListView(m_LSV_View)
	local cell, nIdx
	for i,itemInfo in ipairs(tbGoodsData or {}) do
		if i%2 == 1 then
			m_LSV_View:pushBackDefaultItem()
		end
		nIdx = math.ceil(i/2)- 1
    	cell = m_LSV_View:getItem(nIdx)  -- cell 索引从 0 开始
    	TimeUtil.timeStart("loadCell")
		loadCell(cell,itemInfo,i, false)
		TimeUtil.timeEnd("loadCell")
	end
	TimeUtil.timeEnd("createView")
end


function create(tbEvent)
	m_tbEvent = tbEvent
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	init()
	updateUIWidget()
	createView()
	--------------------------- new guide begin ---------------------------
	
    require "script/module/guide/GuideModel"
    require "script/module/guide/GuideDecomView"
    if (GuideModel.getGuideClass() == ksGuideResolve and GuideDecomView.guideStep == 3) then 
        require "script/module/guide/GuideCtrl"
    	GuideCtrl.createDecomGuide(4,nil,function ( )
    		GuideCtrl.removeGuide()
    	end)
    end
	
	--------------------------- new guide end ---------------------------------
	return m_mainWidget
end


function updateUI(  )
	TimeUtil.timeStart("updateUI")
	init()
	updateUIWidget()
	createView()
	updateGoldAndHaihun()
	TimeUtil.timeEnd("updateUI")
end

