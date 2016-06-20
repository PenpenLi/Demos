-- FileName: WelfareShopView.lua
-- Author: Xufei
-- Date: 2015-12-22
-- Purpose: 福利商店
--[[TODO List]]

WelfareShopView = class("WelfareShopView")

-- UI控件引用变量 --
WelfareShopView._layMain = nil
local _i18n = gi18n
WelfareShopView._welfareModelIns = nil
-- 模块局部变量 --
local TITTLE_PIC_PATH = "images/wonderfullAct/"

WelfareShopView._dynOrSta = nil


function WelfareShopView:onBuy( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- body
		local tag = sender:getTag()
		local listViewData = self._welfareModelIns:getListViewData()
		logger:debug({nowTouchedCellData = listViewData[tag]})
		local nowTouchedCellData = listViewData[tag]

		local function buyBtnCallback( goodsId, num, selectId )
			local selectedId = selectId or 0
			if (not self._welfareModelIns:getIsNowShowedActivityOpen()) then 											-- 判断本轮活动是否结束
				ShowNotice.showShellInfo("活动已结束！")  				--TODO
			else
				function welFareShopBuyCallback( cbFlag, dictData, bRet )
					if (bRet) then
						if (dictData.ret.ret == "ok") then
							if (selectedId~=0) then
								LayerManager.removeLayout()										-- 如果select不为零，去掉选择层
							end
							self._welfareModelIns:updateBuyData(dictData.ret.goodsInfo, nowTouchedCellData.itemID) --更新数据
							UserModel.addGoldNumber(-tonumber(nowTouchedCellData.itemDB.current_price))		-- 扣钱
							GlobalNotify.postNotify("welfareShopRefreshViewNotify")  --刷新活动界面

							if (selectedId == 0) then -- 如果是不能选的
								UIHelper.createGetRewardInfoDlg(nil, RewardUtil.parseRewards(nowTouchedCellData.itemDB.items, true) )	--弹出奖励弹窗
							else
								local waitChooseItems = lua_string_split(nowTouchedCellData.itemDB.items, ",")
								UIHelper.createGetRewardInfoDlg(nil, RewardUtil.parseRewards(waitChooseItems[selectedId], true) )
							end
						elseif (dictData.ret.ret == "limit") then 									-- 说明全服购买人数超限
							self._welfareModelIns:updateBuyData(dictData.ret.goodsInfo, nowTouchedCellData.itemID) -- 刷新数据
							GlobalNotify.postNotify("welfareShopRefreshViewNotify")  --刷新活动界面
							ShowNotice.showShellInfo("全服限购已超限")  				--TODO
						end
					end
				end	
				--welFareShopBuyCallback( 1, {  ret = {ret = "ok", goodsInfo = {selfBuy = 1, global = 2} } }, 1 ) ---
				--welFareShopBuyCallback( 1, {  ret = {ret = "limit"} }, 1 ) ---
				AudioHelper.playBuyGoods()
				local tbArgs = Network.argsHandlerOfTable({goodsId, num, selectId})
				if (self._dynOrSta == "static") then
					RequestCenter.welfareShop_buyItem(welFareShopBuyCallback, tbArgs)
				elseif (self._dynOrSta == "dynamic") then
					RequestCenter.dynamic_welfareshop_buyItem(welFareShopBuyCallback, tbArgs)
				end
			end
		end

		if (nowTouchedCellData.itemDB.current_price > UserModel.getGoldNumber()) then 	-- 判断金币足够
			AudioHelper.playCommonEffect()
			LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
		elseif (not self._welfareModelIns:getIsNowShowedActivityOpen()) then 	-- 判断本轮活动是否结束
			ShowNotice.showShellInfo("活动已结束！")  					--TODO
		else
			if (nowTouchedCellData.type == "single") then
				buyBtnCallback( nowTouchedCellData.itemID, 1 )
			elseif (nowTouchedCellData.type == "selectOne") then
				AudioHelper.playCommonEffect()
				ChooseItemCtrl.create(nowTouchedCellData.itemDB.items, ChooseItemCtrl.kTYPE_BUY, function ( index )
					buyBtnCallback(nowTouchedCellData.itemID, 1, index+1)
				end)
			end
		end
	end
end




function WelfareShopView:dealWithDiscountNumber( limit, haveBuy )
	return tonumber(limit) - (tonumber(haveBuy) or 0)
end
function WelfareShopView:dealWithDiscountColor( limit, haveBuy )
	if ( tonumber(limit) - (tonumber(haveBuy) or 0) == 0 ) then
		return ccc3(0xd8, 0x14, 0x00)
	else
		return ccc3(0x00, 0x8a, 0x00)
	end
end

function WelfareShopView:showListView( ... )
	local listViewData = self._welfareModelIns:getListViewData()
	local nIdx,cell
	_listView:removeAllItems()
	for k,v in ipairs (listViewData) do
		_listView:pushBackDefaultItem()
		nIdx = k - 1
		cell = _listView:getItem(nIdx)
		local goodsListView = cell.LSV_GOODS_LIST
		local orCell = cell.LAY_CELL_OR
		UIHelper.initListView(goodsListView)
		goodsListView:removeAllItems()
		local index = 0
		if (v.type == "single") then -- 按照不能选的来
			for k1,v1 in ipairs (v.items) do
				goodsListView:pushBackDefaultItem()
				local goodCell = goodsListView:getItem(k1-1)
				goodCell.LAY_ICON:addChild(v1[1].icon)
				v1[1].icon:setPosition(ccp(goodCell.LAY_ICON:getContentSize().width/2, goodCell.LAY_ICON:getContentSize().height/2))
				goodCell.TFD_NAME:setColor(g_QulityColor[v1[1].quality])
				goodCell.TFD_NAME:setText(v1[1].name)
			end
		elseif (v.type == "selectOne") then -- 按照能选的来
			for k1,v1 in ipairs (v.items) do
				goodsListView:pushBackDefaultItem()
				index = index + 1
				local goodCell = goodsListView:getItem(index-1)
				goodCell.LAY_ICON:addChild(v1[1].icon)
				v1[1].icon:setPosition(ccp(goodCell.LAY_ICON:getContentSize().width/2, goodCell.LAY_ICON:getContentSize().height/2))
				goodCell.TFD_NAME:setColor(g_QulityColor[v1[1].quality])
				goodCell.TFD_NAME:setText(v1[1].name)
				local cloneORCell = orCell:clone()
				goodsListView:pushBackCustomItem(cloneORCell)
				index = index + 1
			end
			goodsListView:removeLastItem()
		end
		UIHelper.setSliding(goodsListView)

		cell.LAY_YUANJIA.TFD_GOLD_NUM:setText(v.itemDB.original_price)
		cell.LAY_TEJIA.TFD_GOLD_NUM:setText(v.itemDB.current_price)

		local zhekouNum = intPercent( tonumber(v.itemDB.current_price), tonumber(v.itemDB.original_price) )
		-- local zhekouNum = string.format("%.1f", tonumber(v.itemDB.current_price)/tonumber(v.itemDB.original_price)*10)
		-- if (string.sub(zhekouNum, -2, -1) == ".0") then
		-- 	zhekouNum = string.sub(zhekouNum, 1, -3)
		-- end
		cell.tfd_zhekou_num:setText( zhekouNum/10 )

		cell.lay_all_limit:setVisible(v.itemDB.global_limit ~= 0)
		cell.lay_personal_limit:setVisible(v.itemDB.global_limit ~= 0)
		cell.lay_sale_limit:setVisible((v.itemDB.global_limit == 0) and (v.itemDB.self_limit ~= 0))


		local isCanBuy = nil
		if ((v.itemDB.global_limit == 0) and (v.itemDB.self_limit ~= 0)) then -- 只有个人限购
			local layLimit = cell.lay_sale_limit
			layLimit.TFD_RIGHT:setText(v.itemDB.self_limit)
			layLimit.TFD_LEFT:setText(self:dealWithDiscountNumber(v.itemDB.self_limit, v.personBuyTime))
			layLimit.TFD_LEFT:setColor(self:dealWithDiscountColor(v.itemDB.self_limit, v.personBuyTime))
			isCanBuy = (tonumber(v.personBuyTime or "0")<tonumber(v.itemDB.self_limit))
		elseif ((v.itemDB.global_limit ~= 0) and (v.itemDB.self_limit ~= 0)) then -- 均限购
			cell.lay_all_limit.TFD_RIGHT:setText(v.itemDB.global_limit)
			cell.lay_all_limit.TFD_LEFT:setText(self:dealWithDiscountNumber(v.itemDB.global_limit, v.globalBuyTime))
			cell.lay_all_limit.TFD_LEFT:setColor(self:dealWithDiscountColor(v.itemDB.global_limit, v.globalBuyTime))
			cell.lay_personal_limit.TFD_RIGHT:setText(v.itemDB.self_limit)
			cell.lay_personal_limit.TFD_LEFT:setText(self:dealWithDiscountNumber(v.itemDB.self_limit, v.personBuyTime))
			cell.lay_personal_limit.TFD_LEFT:setColor(self:dealWithDiscountColor(v.itemDB.self_limit, v.personBuyTime))
			local isSelfEnough = (tonumber(v.globalBuyTime or "0")<tonumber(v.itemDB.global_limit))
			local isGlobalEnough = (tonumber(v.personBuyTime or "0")<tonumber(v.itemDB.self_limit))
			isCanBuy = isGlobalEnough and isSelfEnough
		elseif ((v.itemDB.global_limit == 0) and (v.itemDB.self_limit == 0)) then -- 不限购
			isCanBuy = true
		end

		cell.img_outof_sale:setEnabled(not isCanBuy)
		cell.BTN_BUY:setEnabled(isCanBuy)

		cell.BTN_BUY:setTag(k)
		cell.BTN_BUY:addTouchEventListener(function ( ... )
			self:onBuy(...)
		end)

		UIHelper.titleShadow(cell.BTN_BUY, _i18n[1319])

		cell:setSize(CCSizeMake(cell:getSize().width * g_fScaleX, cell:getSize().height * g_fScaleX))
		cell.IMG_CELL:setScaleX(g_fScaleX)
		cell.IMG_CELL:setScaleY(g_fScaleX)
	end
	UIHelper.setSliding(_listView)
end



function WelfareShopView:init(...)
	local _listView = nil
end

function WelfareShopView:destroy(...)
	package.loaded["WelfareShopView"] = nil
end

function WelfareShopView:moduleName()
    return "WelfareShopView"
end

function WelfareShopView:ctor()
	self._layMain = g_fnLoadUI("ui/activity_sale_store.json")
end

function WelfareShopView:create(setNewCellNil, modelIns, dynOrStaFlag )
	self._welfareModelIns = modelIns
	self._dynOrSta = dynOrStaFlag
	--倒计时
	local function updateActivityTime()
		self._layMain.tfd_time_num:setText(self._welfareModelIns:getCountDownTime())
	end

	UIHelper.registExitAndEnterCall(self._layMain,
		function()
			GlobalScheduler.removeCallback("updateWelfareShopActivityTime")
			GlobalNotify.removeObserver("welfareShopRefreshViewNotify", "welfareShopRefreshViewNotify")
			setNewCellNil()
			self:destroy()
		end,
		function()
			self:init()
			GlobalScheduler.addCallback("updateWelfareShopActivityTime", updateActivityTime)
			GlobalNotify.addObserver("welfareShopRefreshViewNotify", function ()
				self:showListView()
			end, false, "welfareShopRefreshViewNotify") 
		end
	)

	self._layMain.img_main_bg:setScaleX(g_fScaleX)	--背景适配屏幕
	self._layMain.img_chunjie_middle:setScale(g_fScaleX)
	self._layMain.img_chunjie_top:setScale(g_fScaleX)
	self._layMain.img_chunjie_bg:setScale(g_fScaleX)
	
	self._layMain.tfd_time_num:setText(self._welfareModelIns:getCountDownTime())
	self._layMain.img_title:loadTexture(TITTLE_PIC_PATH..self._welfareModelIns:getWelActNameBigPic())

	UIHelper.labelNewStroke( self._layMain.tfd_time_num )
	UIHelper.labelNewStroke( self._layMain.tfd_time )

	_listView = self._layMain.LSV_TOTAL
	UIHelper.initListView(_listView)

	self:showListView()

	return self._layMain
end
