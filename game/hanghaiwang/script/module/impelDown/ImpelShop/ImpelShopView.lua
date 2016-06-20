-- FileName: ImpelShopView.lua
-- Author: LvNanchun
-- Date: 2015-09-09
-- Purpose: function description of module
--[[TODO List]]

ImpelShopView = class("ImpelShopView")
require "script/module/impelDown/ImpelShop/ImpelShopModel"

-- UI variable --
local _layMain

-- module local variable --
local _preList = 1
local _fnGetWidget = g_fnGetWidgetByName
local _scaleX = g_fScaleX
local _scaleY = g_fScaleY
local _i18n = gi18n
local ICON_TAG = 999

function ImpelShopView:moduleName()
    return "ImpelShopView"
end

--[[desc:刷新listView
    arg1: listView需要的信息table
    return: 无
—]]
function ImpelShopView:reloadListView( tbGoodInfo )
	local listView = _layMain.LSV_CELL

	revmoeFrameNode(_layMain)
	UIHelper.initListWithNumAndCell(listView, #tbGoodInfo)
	local tbGoodInfoCopy = tbGoodInfo
--	listView:removeAllItems()

	for k,v in pairs(tbGoodInfo) do 
--		listView:pushBackDefaultItem()

		local cell = listView:getItem(k-1)

		cell:setVisible(false)

		local function setOneCellInfo( cellWidget, cellIndex, cellInfo )
			local iconChild = cellWidget.lay_icon:getChildByTag(ICON_TAG)
			if (iconChild) then
				iconChild:removeFromParentAndCleanup(true)
			end
			cellWidget.lay_icon:addChild(cellInfo.icon, 1, ICON_TAG)
			cellInfo.icon:release()
			cellInfo.icon:setPosition(ccp(cellWidget.lay_icon:getContentSize().width/2, cellWidget.lay_icon:getContentSize().height/2))
			cellWidget.TFD_NAME:setText(cellInfo.name)
			cellWidget.TFD_NAME:setColor(cellInfo.color)
			ImpelShopModel.setTipDataById( cellIndex , "color" , cellInfo.color )
			cellWidget.TFD_PRICE_NUM:setText(cellInfo.cost)
			if (cellInfo.isRecommend) then
				cellWidget.img_tip:setVisible(true)
			else
				cellWidget.img_tip:setVisible(false)
			end
	
			local prisonCoinNum = UserModel.getImpelDownNum()
	
			if (cellInfo.nowNum) then
				cellWidget.lay_buy_num:setVisible(true)
				cellWidget.TFD_TODAY_NUM:setText(tostring(cellInfo.nowNum))
				if (cellInfo.isForever) then
					cellWidget.tfd_today_buy:setText(_i18n[7001])
				else
					cellWidget.tfd_today_buy:setText(_i18n[3810])
				end
				cellWidget.tfd_unit:setText(_i18n[4909])
	
				if ((math.floor(prisonCoinNum / (tonumber(cellInfo.cost)))) > tonumber(cellInfo.nowNum)) then
					ImpelShopModel.setTipDataById( cellIndex , "maxNum" , tonumber(cellInfo.nowNum))
					ImpelShopModel.setTipDataById( cellIndex , "limitType" , "num")
				else
					ImpelShopModel.setTipDataById( cellIndex , "maxNum" , (math.floor(prisonCoinNum / (tonumber(cellInfo.cost)))))
					ImpelShopModel.setTipDataById( cellIndex , "limitType" , "gold")
				end
			else
				cellWidget.lay_buy_num:setVisible(false)
				ImpelShopModel.setTipDataById( cellIndex , "maxNum" , math.floor(prisonCoinNum / (tonumber(cellInfo.cost))) )
				ImpelShopModel.setTipDataById( cellIndex , "limitType" , "gold")
			end
	
			if (cellInfo.isFragment) then
				cellWidget.TFD_OWN_NUM:setText(tostring(cellInfo.ownNum))
				cellWidget.tfd_need:setText("/" .. tostring(cellInfo.maxNum) .. "）")
				if (tonumber(cellInfo.ownNum) < tonumber(cellInfo.maxNum)) then
					cellWidget.TFD_OWN_NUM:setColor(ccc3(0xd8 , 0x14 , 0x00))
				else
					cellWidget.TFD_OWN_NUM:setColor(ccc3(0x00 , 0x8a , 0x00))
				end
			else
				cellWidget.lay_num:setVisible(false)
			end
	
			if (cellInfo.nowNum == 0) then
				cellWidget.BTN_BUY:setVisible(false) 
				cellWidget.BTN_BUY:setTouchEnabled(false)
				cellWidget.img_sold_out:setVisible(true)
				-- 2015-12-10 策划表示所有物品都是卖没了就不显示今日可购买那句话
				cellWidget.lay_buy_num:setVisible(false)
			else
				cellWidget.BTN_BUY:setVisible(true) 
				cellWidget.BTN_BUY:setTouchEnabled(true)
				cellWidget.img_sold_out:setVisible(false)
			end
	
			if (cellInfo.isFragment) then
				ImpelShopModel.setTipDataById( cellIndex , "itemName" , cellInfo.name .. _i18n[2448] )
			else
				ImpelShopModel.setTipDataById( cellIndex , "itemName" , cellInfo.name )
			end
			ImpelShopModel.setTipDataById( cellIndex , "ownNum" , cellInfo.ownNum )
			ImpelShopModel.setTipDataById( cellIndex , "itemPirce" , cellInfo.cost )
			
			local btnSureCallBack =  function ( itemNum )
				local function buyGoodsCallBack( cbFlag, dictData, bRet )
					if (bRet) then
						-- 增加监狱币数量，必须在下面的getImpelDownNum之前，才可以起到修改获得的最大数量的作用。
						UserModel.addImpelDownNum(-tonumber(cellInfo.cost) * itemNum)
						if (cellInfo.nowNum) then
							ImpelShopModel.setBoughtNumById(tonumber(cellInfo.id) , itemNum)
							local nowNum = ImpelShopModel.getNowNumById(cellInfo.id)
							cellWidget.TFD_TODAY_NUM:setText(tostring(nowNum))
							
							if (nowNum == 0) then
								cellWidget.BTN_BUY:setVisible(false) 
								cellWidget.BTN_BUY:setTouchEnabled(false)
								cellWidget.img_sold_out:setVisible(true)
								-- 2015-12-10 策划表示所有物品都是卖没了就不显示今日可购买那句话
							--	if (v.isForever) then
									cellWidget.lay_buy_num:setVisible(false)
							--	end
							end
						end
						ImpelShopModel.refreshAllMaxNum(tbGoodInfo)
						-- 创建奖励界面
--						local tbPrize = RewardUtil.getItemsDataByStr(v.item)
--						tbPrize[1].num = itemNum
--						LayerManager.addLayoutNoScale(UIHelper.createRewardDlg(RewardUtil.parseRewardsByTb(tbPrize)))
						-- 不用奖励框了，改成文字提示
						ShowNotice.showShellInfo(gi18nString(6931, cellInfo.name, itemNum))
	
						-- 增加model中的拥有的总数，并更改显示在商店界面和购买提示界面的数字
						ImpelShopModel.setOwnNumByIndex( cellIndex , itemNum )
						local ownNumNow = ImpelShopModel.getOwnNumByIndex(cellIndex)
						ImpelShopModel.setTipDataById( cellIndex , "ownNum" , ownNumNow )
						cellWidget.TFD_OWN_NUM:setText(tostring(ownNumNow))
						cellWidget.TFD_OWN_NUM:setPositionX(cellWidget.tfd_brackets:getPositionX()+cellWidget.TFD_OWN_NUM:getContentSize().width)
						cellWidget.tfd_need:setPositionX(cellWidget.TFD_OWN_NUM:getPositionX()+cellWidget.tfd_need:getContentSize().width)
	
						if (cellInfo.isFragment) then
							if (tonumber(ownNumNow) < tonumber(cellInfo.maxNum)) then
								cellWidget.TFD_OWN_NUM:setColor(ccc3(0xd8 , 0x14 , 0x00))
							else
								cellWidget.TFD_OWN_NUM:setColor(ccc3(0x00 , 0x8a , 0x00))
							end
						end
					end
				end
				LayerManager.removeLayout()
				require "script/network/Network"
				require "script/module/public/ItemUtil"
				if (not ItemUtil.bagIsFullWithTid(cellInfo.itemId , true)) then
					RequestCenter.impelDown_buyTowerGood(buyGoodsCallBack, Network.argsHandler(cellInfo.id, itemNum))
				end
			end
	
			ImpelShopModel.setTipDataById( cellIndex , "sureCallBack" , btnSureCallBack )
	
			UIHelper.titleShadow(cellWidget.BTN_BUY)
			require "script/module/impelDown/ImpelDownMainModel"
--			logger:debug({impelShopTopGrade = ImpelDownMainModel.getFightLayerIdByNormalId(ImpelDownMainModel.getTopGrade())})
			local nTopGrade = ImpelShopModel.getMaxLevel()
			local nFightLayer = ImpelDownMainModel.getFightLayerIdByNormalId(nTopGrade)
			if not (nFightLayer) then
				nFightLayer = ImpelDownMainModel.getFightLayerIdByNormalId(nTopGrade - 1)
			end
	
			if (nFightLayer < tonumber(cellInfo.levelLimit)) then
				cellWidget.BTN_BUY:setGray(true)
				cellWidget.lay_buy_num:setVisible(true)
				cellWidget.TFD_TODAY_NUM:setText("")
				cellWidget.tfd_today_buy:setText(_i18n[7002] .. tostring(cellInfo.levelLimit) .. _i18n[7003])
				cellWidget.tfd_unit:setText("")
				cellWidget.BTN_BUY:setTouchEnabled(false)
				--cellWidget.BTN_BUY:addTouchEventListener(function ( sender, eventType )
				--	if (eventType == TOUCH_EVENT_ENDED) then
				--		AudioHelper.playCommonEffect()
				--		require "script/module/public/ShowNotice"
				--		ShowNotice.showShellInfo(_i18n[7002] .. tostring(cellInfo.levelLimit) .. _i18n[7003])
				--	end
				--end)
			else
				cellWidget.BTN_BUY:setGray(false)
				cellWidget.BTN_BUY:setTouchEnabled(true)
				local function btnBuyCallBack( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCommonEffect()
						if (UserModel.getImpelDownNum() >= tonumber(cellInfo.cost)) then
							require "script/module/impelDown/ImpelShop/ImpelShopTipView"
							local tipViewInstance = ImpelShopTipView:new()
							LayerManager.addLayoutNoScale(tipViewInstance:create(ImpelShopModel.getTipDataById(cellIndex)))
						else 
							ShowNotice.showShellInfo(_i18n[7004])
							require "script/module/public/PublicInfoCtrl"
							PublicInfoCtrl.createItemDropInfoViewByTid(60031, nil, true)     -- 装备结晶的掉落途径提示
						end
					end
				end
				cellWidget.BTN_BUY:addTouchEventListener(btnBuyCallBack)
			end

			cellWidget:setVisible(true)
		end

--		if (k > 5) then
			performWithDelayFrame(_layMain, function (  )
				local itemListView = _fnGetWidget(_layMain, "LSV_CELL")
				if (UIHelper.isGood(itemListView)) then
     				setOneCellInfo(itemListView:getItem(k-1), k, tbGoodInfo[k])
     			end
     		end, k)
--		else
--			setOneCellInfo(cell, k, v)
--		end
		
	end
end

--[[desc:更换列表
    arg1: 列表的索引，1，2，3
    return: 无  
—]]
function ImpelShopView:changeList( listIndex )
	if (_preList ~= listIndex) then
		local preBtn = _fnGetWidget(_layMain , "BTN_TAB_" .. tostring(_preList))
		preBtn:setFocused(false)
		preBtn:setTouchEnabled(true)
		local btnTTF1 = tolua.cast(preBtn:getTitleTTF() , "CCLabelTTF")
		btnTTF1:setColor(ccc3(0xbf , 0x93 , 0x67))
	end
	local nowBtn = _fnGetWidget(_layMain , "BTN_TAB_" .. tostring(listIndex))
	nowBtn:setFocused(true)
	nowBtn:setTouchEnabled(false)
	local btnTTF2 = tolua.cast(nowBtn:getTitleTTF() , "CCLabelTTF")
	btnTTF2:setColor(ccc3(0xff , 0xff , 0xff))

	TimeUtil.timeStart("impelShop1")
	local listViewInfo = ImpelShopModel.getGoodsInfoByIndex(listIndex)
	TimeUtil.timeEnd("impelShop1")
	TimeUtil.timeStart("impelShop2")
	self:reloadListView(listViewInfo)
	_layMain.LSV_CELL:jumpToTop()
	TimeUtil.timeEnd("impelShop2")
	_preList = listIndex
end

function ImpelShopView:ctor(...)
	_layMain = g_fnLoadUI("ui/impel_down_shop.json")
	_preList = 1
end

function ImpelShopView:create( tbData )
	_layMain.LSV_CELL.img_cell_bg:setScale(_scaleX)
	_layMain.LSV_CELL.lay_cell_bg:setSize(CCSizeMake(_layMain.LSV_CELL.lay_cell_bg:getSize().width*_scaleX, _layMain.LSV_CELL.lay_cell_bg:getSize().height*_scaleX ))
	_layMain.LSV_CELL.lay_cell_bg.img_tip:loadTexture(UIHelper.getImpelShopRecommendType())
	UIHelper.initListView(_layMain.LSV_CELL)
	_layMain.img_bg:setScaleX(_scaleX)
	_layMain.img_bg:setScaleY(_scaleY)
	_layMain.img_chain:setScaleX(_scaleX)
	_layMain.img_chain:setScaleY(_scaleY)
	_layMain.img_small_bg:setScaleX(_scaleX)
	_layMain.img_small_bg:setScaleY(_scaleY)
	self:changeList(_preList)

	-- 获取到达过的最大等级，之后判断是否可以切标签
	local nTopGrade = ImpelShopModel.getMaxLevel()
	local nFightLayer = ImpelDownMainModel.getFightLayerIdByNormalId(nTopGrade)
	if not (nFightLayer) then
		nFightLayer = ImpelDownMainModel.getFightLayerIdByNormalId(nTopGrade - 1)
	end

	_layMain.BTN_TAB_1:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			self:changeList(1)
		end
	end)
	_layMain.BTN_TAB_2:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			local nLimitLevel = ImpelShopModel.getTabLimitLevelById(2)
			if (nFightLayer >= nLimitLevel) then
				self:changeList(2)
			else
				ShowNotice.showShellInfo(gi18nString(7040, tostring(nLimitLevel)))
			end
		end
	end)
	_layMain.BTN_TAB_3:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			local nLimitLevel = ImpelShopModel.getTabLimitLevelById(3)
			if (nFightLayer >= nLimitLevel) then
				self:changeList(3)
			else
				ShowNotice.showShellInfo(gi18nString(7040, tostring(nLimitLevel)))
			end
		end
	end)
	_layMain.BTN_BACK:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (tbData and tbData.from) then
				tbData.from()
			else
				require "script/module/impelDown/MainImpelDownCtrl"
				LayerManager.changeModule(MainImpelDownCtrl.create(), MainImpelDownCtrl.moduleName(), {1,3}, true)
			end
		end
	end)
	UIHelper.titleShadow(_layMain.BTN_BACK)

	UIHelper.registExitAndEnterCall(_layMain, function ( )		
		GlobalScheduler.removeCallback("impelDownDayTimer")
    end , function ( )
    	GlobalScheduler.addCallback("impelDownDayTimer" , function ( ... )
    		local tbNowTime = NewTimeUtil.getServerDateTime()
    		logger:debug({impelDownTbNowTime = tbNowTime})
    		if (tbNowTime.hour+tbNowTime.min+tbNowTime.sec == 0) then
    			ImpelShopModel.resetBoughtEveryDay()
    			self:changeList(_preList)
    		end
    	end)
    end)

	if (GuideModel.getGuideClass() == ksGuideImpelDown and GuideImpelDownView.guideStep == 4) then  
		GuideCtrl.createImpelDownGuide(5,nil,nil, function (  )
			GuideCtrl.removeGuide()
		end) 
	end 

	return _layMain
end

