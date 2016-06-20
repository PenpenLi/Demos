-- FileName: TreaShopView.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 宝物商店显示UI
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("TreaShopView", package.seeall)
local _tbEvent
local _mainWidget
local json = "ui/special_shop.json"

local m_i18n = gi18n
local m_i18nString = gi18nString

local tagIcon = 100

function create(tbEvent)
	_tbEvent = tbEvent
	_mainWidget = g_fnLoadUI(json)
	_mainWidget:setSize(g_winSize)
	local img_bg =_mainWidget.img_bg
	img_bg:setScale(g_fScaleX)

	_mainWidget.BTN_BACK:addTouchEventListener(tbEvent.onBack)
	UIHelper.titleShadow(_mainWidget.BTN_BACK, m_i18n[1019])
	initListView(false)
	updateRfrLab()
	return _mainWidget
end

function initListView(bAni)
	local tbGoodsData = TreaShopData.getGoodsListData()
	local btnGet = _mainWidget.BTN_FENJIE
	btnGet:addTouchEventListener(_tbEvent.onGet)
	local lsv = _mainWidget.LSV_CELL
	UIHelper.initListView(lsv)
	local cell, nIdx
	for i,itemInfo in ipairs(tbGoodsData or {}) do
		if i%2 == 1 then
			lsv:pushBackDefaultItem()
		end
		nIdx = math.ceil(i/2)- 1
    	cell = lsv:getItem(nIdx)  -- cell 索引从 0 开始
		loadCell(cell,itemInfo,i, bAni or false)
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


function loadCell( cell, tbData, tag, bAction)
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

	logger:debug({tbData = tbData})
	local layGoods = layCell.LAY_GOODS -- 物品图标LAYOUT
	layGoods:removeChildByTag(tagIcon, true)
	local  itemIcon,tbItemInfo = ItemUtil.createBtnByTemplateIdAndNumber(tbData.tid,tbData.num, function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			require "script/module/public/PublicInfoCtrl"
			PublicInfoCtrl.createItemInfoViewByTid(tbData.tid,tbData.num)    
		end
	end)
	layGoods:addChild(itemIcon,-1,tagIcon)
	itemIcon:setPosition(ccp(layGoods:getSize().width*.5,layGoods:getSize().height*.5))

	local tfdName = layCell.TFD_NAME -- 物品名称
	tfdName:setText(tbItemInfo.name)
	tfdName:setColor(g_QulityColor[tonumber(tbItemInfo.quality)])

	local layFit = layCell.lay_fit

	local tfdNumOwn = layCell.TFD_NUM_OWN   -- 物品当前数量
	local tfdNumNeed = layCell.TFD_NUM_NEED
	local treasureId = nil
	if tbItemInfo.isSpeTreasureFragment then
		treasureId = DB_Item_exclusive_fragment.getDataById(tbData.tid).treasureId
		layFit:setEnabled(true)
		require "script/module/specialBag/SBListModel"
		local num, max = SBListModel.getFragNumAndMaxByTid(tbData.tid)
		tfdNumOwn:setText(num)
		tfdNumNeed:setText(max)
		if tonumber(num)<tonumber(max) then
			tfdNumOwn:setColor(ccc3(0xd8, 0x14, 0x00))
		else
			tfdNumOwn:setColor(ccc3(0x00, 0x8a, 0x00))
		end
	elseif tbItemInfo.isTreasureFragment then
		layFit:setEnabled(true)
		num, max = tbItemInfo.nOwn, tbItemInfo.nMax
		tfdNumOwn:setText(num)
		tfdNumNeed:setText(max)
		if tonumber(num)<tonumber(max) then
			tfdNumOwn:setColor(ccc3(0xd8, 0x14, 0x00))
		else
			tfdNumOwn:setColor(ccc3(0x00, 0x8a, 0x00))
		end
	else
		if tbItemInfo.isSpeTreasure then
			treasureId = tbData.tid
		end
		layFit:setEnabled(false)
	end

	local imgHaiHun = layCell.IMG_HAIHUN
	local imgGold = layCell.IMG_GOLD
	imgHaiHun:setEnabled(true)
	imgGold:setEnabled(true)

	if tbData.costType==1 then
		imgGold:setEnabled(false)
	else		
		imgHaiHun:setEnabled(false)
	end

	local labCostNum = layCell.TFD_COST_NUM
	labCostNum:setText(tbData.costNum)
	local i18nBTN_EXCHANGE = layCell.BTN_EXCHANGE --兑换按钮
	local i18nLabExchange = layCell.TFD_EXCHANGE
	i18nBTN_EXCHANGE:setGray(false)
	i18nBTN_EXCHANGE:setTouchEnabled(true)
	i18nBTN_EXCHANGE:addTouchEventListener(_tbEvent.onBuy)
	i18nBTN_EXCHANGE.tData = tbData
	i18nBTN_EXCHANGE.tItem = tbItemInfo
	UIHelper.labelShadowWithText(i18nLabExchange,gi18nString(2203))
	if tbData.canBuyNum <= 0 then
		i18nBTN_EXCHANGE:setGray(true)
		i18nBTN_EXCHANGE:setTouchEnabled(false)
	end
	local texture = UIHelper.getSpecialShopRecommendType({tid = treasureId, recommended = tbData.recommended})
	layCell.IMG_RECOMMAND:loadTexture(texture or "")
	layCell.IMG_RECOMMAND:setEnabled(texture and true)

end

function updateRfrLab( ... )
	local layItem = _mainWidget.LAY_ITEM
	local layGold = _mainWidget.LAY_GOLD
	local layFree = _mainWidget.LAY_FREE
	local layNoTimes = _mainWidget.LAY_NOTIMES

	layItem:setEnabled(false)
	layGold:setEnabled(false) 
	layFree:setEnabled(false)
	layNoTimes:setEnabled(false)

	_mainWidget.tfd_refresh_vip:setText(m_i18n[2065])

	UIHelper.labelNewStroke(_mainWidget.tfd_refresh_vip, ccc3(0x28,0x00,0x00))

	local BTN_REFRESH = _mainWidget.BTN_REFRESH --刷新按钮
	UIHelper.titleShadow(BTN_REFRESH,m_i18nString(6929,TreaShopData.getLastRfrTimes()+TreaShopData.getFreeTimes()))
	BTN_REFRESH:addTouchEventListener(_tbEvent.onRfr)
	BTN_REFRESH:setGray(false)


	_mainWidget.tfd_own:setText(m_i18n[2089])
	_mainWidget.tfd_treasure_jiejing:setText(m_i18n[6921] .. ":")
	_mainWidget.TFD_DAIBI_NUM:setText(UserModel.getRimeNum())

	UIHelper.labelNewStroke(_mainWidget.tfd_own, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(_mainWidget.tfd_treasure_jiejing, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(_mainWidget.TFD_DAIBI_NUM, ccc3(0x28,0x00,0x00))

	local max = TreaShopData.getFreeLimit()

	_mainWidget.tfd_refresh:setText(m_i18n[2064])
	UIHelper.labelNewStroke(_mainWidget.tfd_refresh, ccc3(0x28,0x00,0x00))
	_mainWidget.TFD_REFRESH_TIME:setText(TimeUtil.getTimeString(TreaShopData.getRefreshCdTime()))
	UIHelper.labelNewStroke(_mainWidget.TFD_REFRESH_TIME, ccc3(0x28,0x00,0x00))
	local function updateTime( )
		local cd = TreaShopData.getRefreshCdTime()
		if cd<=0 or TreaShopData.getFreeTimes() >= max then
			if TreaShopData.getFreeTimes() >= max then
				_mainWidget.tfd_refresh:setEnabled(false)
				_mainWidget.TFD_REFRESH_TIME:setEnabled(false)
				layFree.TFD_LIMIT:setEnabled(true)
			elseif cd<=0 then
				TreaShopData.addFreeTimes()
				TreaShopData.setRfrCdTime()
				updateUI()
			end
		else
			_mainWidget.tfd_refresh:setEnabled(true)
			_mainWidget.TFD_REFRESH_TIME:setEnabled(true)
			layFree.TFD_LIMIT:setEnabled(false)
		end
		_mainWidget.TFD_REFRESH_TIME:setText(TimeUtil.getTimeString(cd))
	end

	UIHelper.registExitAndEnterCall(_mainWidget.TFD_REFRESH_TIME, function ( ... )
		GlobalScheduler.removeCallback("updateTimeTreasShop")
	end, function ( ... )
		GlobalScheduler.removeCallback("updateTimeTreasShop")
		GlobalScheduler.addCallback("updateTimeTreasShop", updateTime)
	end)

	
	if TreaShopData.getFreeTimes() > 0 then
		layFree:setEnabled(true)
		updateTime()
		layFree.TFD_FREE:setText(m_i18n[2070])
		layFree.TFD_LIMIT:setText(m_i18n[6928])
		local freeNum = TreaShopData.getFreeTimes()
		layFree.TFD_FREE_NUM:setText(freeNum .. "/" .. max)
		UIHelper.labelNewStroke(layFree.TFD_FREE, ccc3(0x28,0x00,0x00))
		UIHelper.labelNewStroke(layFree.TFD_LIMIT, ccc3(0x28,0x00,0x00))
		UIHelper.labelNewStroke(layFree.TFD_FREE_NUM, ccc3(0x28,0x00,0x00))
		return
	end

	if TreaShopData.getItemNum() > 0 then
		layItem:setEnabled(true)
		layItem.TFD_ITEM:setText(m_i18n[6923])
		layItem.TFD_ITEM_NUM:setText(UIHelper.longToShortNum(TreaShopData.getItemNum(), 6))
		UIHelper.labelNewStroke(layItem.TFD_ITEM, ccc3(0x28,0x00,0x00))
		UIHelper.labelNewStroke(layItem.TFD_ITEM_NUM, ccc3(0x28,0x00,0x00))
		return
	end

	if not TreaShopData.isRfrMax() then
		layGold:setEnabled(true)
		layGold.TFD_GOLD:setText(m_i18n[2072])
		logger:debug("needGold = %s", TreaShopData.getRfrGoldNum())
		layGold.TFD_GOLD_NUM:setText(TreaShopData.getRfrGoldNum())
		UIHelper.titleShadow(BTN_REFRESH,m_i18nString(6929,TreaShopData.getLastRfrTimes()))
		UIHelper.labelNewStroke(layGold.TFD_GOLD, ccc3(0x28,0x00,0x00))
		UIHelper.labelNewStroke(layGold.TFD_GOLD_NUM, ccc3(0x28,0x00,0x00))
		return
	end

	BTN_REFRESH:setGray(true)

	layNoTimes:setEnabled(true)
	layNoTimes.TFD_NOTIMES:setText(m_i18n[6930])
	UIHelper.labelNewStroke(layNoTimes.TFD_NOTIMES, ccc3(0x28,0x00,0x00))

end

function updateUI( ... )
	initListView()
	updateRfrLab()
end
