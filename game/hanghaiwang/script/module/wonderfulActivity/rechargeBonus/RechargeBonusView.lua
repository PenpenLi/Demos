-- FileName: RechargeBonusView.lua
-- Author: Xufei
-- Date: 2015-08-20
-- Purpose: 充值红利 视图
--[[TODO List]]

RechargeBonusView = class("RechargeBonusView")

-- UI控件引用变量 --
local _layMain = nil
local _listView = nil
local _i18n = gi18n

-- 模块局部变量 --

-- 国际化
function RechargeBonusView:dealWithi18n( ... )
	_layMain.tfd_cell_1:setText(_i18n[6602]) -- 累计充值
	_layMain.tfd_cell_3:setText(_i18n[1937]) -- 天
	_layMain.tfd_jindu:setText(_i18n[6603]) -- 进度：
	_layMain.LAY_YUANJIA.tfd_yuanjia:setText(_i18n[1470]) -- 原价：
	_layMain.LAY_TEJIA.tfd_yuanjia:setText(_i18n[6504]) -- 特价：
	_layMain.tfd_time:setText(_i18n[5740]) -- 活动结束时间：

	UIHelper.labelNewStroke(_layMain.tfd_time, ccc3(0x28,0,0))
	UIHelper.labelNewStroke(_layMain.tfd_time_num, ccc3(0x28,0,0))
	

	UIHelper.titleShadow(BTN_GET_REWARD, _i18n[2628])
	UIHelper.titleShadow(BTN_RECHARGE, _i18n[1412])
end

function RechargeBonusView:showIconsOfGoods( cell,goodsData, arrayType )
	logger:debug({goodsOfData = goodsData})

	local tbReward = RewardUtil.parseRewards(goodsData)

	logger:debug({werfawefreward = tbReward,
		arrarytype = arrayType})


	local function addItemsIcon( iconData, iconCell )
		local layIcon = iconData.icon
		local layCell = iconCell.LAY_ICON
		layIcon:setPosition(ccp(layCell:getContentSize().width / 2 , layCell:getContentSize().height / 2))
		layCell:addChild(layIcon)
		iconCell.TFD_REWARD_NAME:setColor(g_QulityColor[iconData.quality])
		iconCell.TFD_REWARD_NAME:setText(iconData.name)
	end

	local goodsListView = cell.LSV_GOODS
	local orCell = cell.LAY_CLONE1
	UIHelper.initListView(goodsListView)
	goodsListView:removeAllItems()
	local index = 0

	if (arrayType == "1") then -- 按照不能选的来
		for k1,v1 in ipairs (tbReward) do
			goodsListView:pushBackDefaultItem()
			local goodCell = goodsListView:getItem(k1-1)
			logger:debug({weishaenasdeaiwerj = v1})
			addItemsIcon(v1, goodCell)
		end
	elseif (arrayType == "2") then -- 按照能选的来
		for k1,v1 in ipairs (tbReward) do
			goodsListView:pushBackDefaultItem()
			index = index + 1
			local goodCell = goodsListView:getItem(index-1)
			addItemsIcon(v1, goodCell)
			local cloneORCell = orCell:clone()
			goodsListView:pushBackCustomItem(cloneORCell)
			index = index + 1
		end
		goodsListView:removeLastItem()
	end

	UIHelper.setSliding(goodsListView)
end

function RechargeBonusView:setRechargeBtbEvent( btn )
	btn:addTouchEventListener(function (sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (RechargeBonusModel.isActivityInTime()) then
				require "script/module/IAP/IAPCtrl"
				LayerManager.addLayout(IAPCtrl.create())
			else
				ShowNotice.showShellInfo(_i18n[6605]) --本活动已结束，谢谢参与！
			end			
		end 
	end)
end

function RechargeBonusView:removeRedPoint( ... )
	local mainActivity = WonderfulActModel.tbBtnActList.rechargeBonus
	if (not RechargeBonusModel.isHaveCanBuy()) then 
		mainActivity.IMG_TIP:setVisible(false)
	end
end

function RechargeBonusView:receiveCallback( indexReward ,goodsData,costGold , selectIndex)
	logger:debug("领取了。。。" .. indexReward )
	--logger:debug("选择了。。。" .. selectIndex )
	RechargeBonusModel.updateBackendData(indexReward+1)
	local goodsStr = goodsData
	if (selectIndex) then
		goodsStr = lua_string_split(goodsData, ",")[selectIndex]
	end
	-- 增加宝物
	local tbReward = RewardUtil.parseRewards(goodsStr,true)
	-- 弹窗
	UIHelper.createGetRewardInfoDlg(_i18n[6604], tbReward) -- 充值红利
	--减去金币
	UserModel.addGoldNumber(-costGold)
	self:initRechargeBonusListView()
	--处理红点
	local mainActivity = WonderfulActModel.tbBtnActList.rechargeBonus
	mainActivity:setVisible(true)
	local numRedPoint = RechargeBonusModel.numRedPoint()
	mainActivity.LABN_TIP_EAT:setStringValue(numRedPoint)
	if (tonumber(numRedPoint) == 0) then 
		mainActivity.IMG_TIP:setVisible(false)
	end
end

function RechargeBonusView:btnBuyCallback( sender , rewardStr,costGold , selectIndex)
	local indexReward = sender:getTag()
	-- local rewardData = RewardUtil.getItemsDataByStr(rewardStr)
	-- logger:debug({asdfaefaw = rewardData})
	-- for k,v in pairs(rewardData) do
	-- 	if(tonumber(v.tid)~=0 and ItemUtil.bagIsFullWithTid(v.tid, true)) then
	-- 		return
	-- 	end
	-- end
	local function requestBuyCallback( cbFlag, dictData, bRet )
		logger:debug("点击了购买。。。" .. indexReward)
		--logger:debug("选择了其中。。。" .. selectIndex)
		if (bRet) then
			if (dictData.ret == "ok") then
				self:receiveCallback( indexReward, rewardStr,costGold , selectIndex)
			end
		end
	end
	local nIdxArray
	if (selectIndex) then
		nIdxArray = Network.argsHandlerOfTable({indexReward+1, selectIndex})
	else
		nIdxArray = Network.argsHandlerOfTable({indexReward+1})
	end
	AudioHelper.playBuyGoods()
	RequestCenter.rechargeBonus_buy(requestBuyCallback,nIdxArray)
	--requestBuyCallback({1,{ret = "ok"},1})
end

function RechargeBonusView:setBuyBtbEvent( btn , rewardStr , costGold, arrayType)
	btn:addTouchEventListener(function (sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			if (tonumber(costGold) > UserModel.getGoldNumber()) then 	-- 判断金币足够
				AudioHelper.playCommonEffect()
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
			else
				if (RechargeBonusModel.isActivityInTime()) then
					if (arrayType == "1") then
						self:btnBuyCallback(sender,rewardStr,costGold)
					elseif (arrayType == "2") then
						AudioHelper.playCommonEffect()
						ChooseItemCtrl.create(rewardStr, ChooseItemCtrl.kTYPE_BUY, function ( index )
							self:btnBuyCallback(sender,rewardStr,costGold,index+1)
						end)
					end
				else
					AudioHelper.playCommonEffect()
					ShowNotice.showShellInfo(_i18n[6605]) --本活动已结束，谢谢参与！
				end
			end
		end 
	end)
end

function RechargeBonusView:initRechargeBonusListView( ... )
	local nIdx, cell
	nIdx = 0
	_listView:removeAllItems()
	local tbListViewData = RechargeBonusModel.getDataForView()
	logger:debug({tbListViewData = tbListViewData})

	local lastData = table.remove(tbListViewData)
	logger:debug({tbListViewDataWithoutLast = tbListViewData})
	for k,v in ipairs(tbListViewData) do
		-- 如果已经购买过，则不显示那一行
		if (v.status ~= 2) then
			_listView:pushBackDefaultItem()
			cell = _listView:getItem(nIdx)
			cell:setSize(CCSizeMake(cell:getSize().width * g_fScaleX, cell:getSize().height * g_fScaleX))
			cell.IMG_CELL:setScaleX(g_fScaleX)
			cell.IMG_CELL:setScaleY(g_fScaleX)
			-- 购买按钮
			local btnBuy = cell.BTN_GET_REWARD
			UIHelper.titleShadow(btnBuy, _i18n[1319]) -- 购买
			btnBuy:setTag(k-1)
			btnBuy:setEnabled(false)
			self:setBuyBtbEvent(btnBuy,v.array,v.discontPrice, v.type)
			-- 充值按钮
			local btnRecharge = cell.BTN_RECHARGE
			UIHelper.titleShadow(btnRecharge, _i18n[1412]) -- 充值
			btnRecharge:setEnabled(false)
			self:setRechargeBtbEvent(btnRecharge)
			-- 显示文字
			cell.TFD_CELL_2:setText(v.rechargeDay)
			cell.TFD_RIGHT:setText(v.rechargeDay)
			cell.TFD_LEFT:setText(RechargeBonusModel.getAccumRechargeDate())
			cell.LAY_TEJIA.TFD_GOLD_NUM:setText(v.discontPrice)
			cell.LAY_YUANJIA.TFD_GOLD_NUM:setText(v.originalCost)
			-- 显示图标
			logger:debug({weiahsdaiwei = v})
			self:showIconsOfGoods(cell,v.array, v.type)
			-- 处理按钮和进度数字颜色
			if (v.status == 1) then
				cell.BTN_GET_REWARD:setEnabled(true)
				cell.TFD_LEFT:setColor(ccc3(0x08,0x8a,0x00))
			elseif (v.status == 0) then
				cell.BTN_RECHARGE:setEnabled(true)
				cell.TFD_LEFT:setColor(ccc3(0xdb,0x14,0x00))
			end
			nIdx = nIdx + 1
		end
	end	

	if (lastData.status ~= 2) then
		_listView:insertDefaultItem(0)
		local cellData = lastData
		local cell = _listView:getItem(0)
		cell:setSize(CCSizeMake(cell:getSize().width * g_fScaleX, cell:getSize().height * g_fScaleX))
		cell.IMG_CELL:setScaleX(g_fScaleX)
		cell.IMG_CELL:setScaleY(g_fScaleX)
		-- 购买按钮
		local btnBuy = cell.BTN_GET_REWARD
		UIHelper.titleShadow(btnBuy, _i18n[1319]) -- 购买
		btnBuy:setTag(cellData.id-1)
		btnBuy:setEnabled(false)
		self:setBuyBtbEvent(btnBuy,cellData.array,cellData.discontPrice, cellData.type)
		-- 充值按钮
		local btnRecharge = cell.BTN_RECHARGE
		UIHelper.titleShadow(btnRecharge, _i18n[1412]) -- 充值
		btnRecharge:setEnabled(false)
		self:setRechargeBtbEvent(btnRecharge)
		-- 显示文字
		cell.TFD_CELL_2:setText(cellData.rechargeDay)
		cell.TFD_RIGHT:setText(cellData.rechargeDay)
		cell.TFD_LEFT:setText(RechargeBonusModel.getAccumRechargeDate())
		cell.LAY_TEJIA.TFD_GOLD_NUM:setText(cellData.discontPrice)
		cell.LAY_YUANJIA.TFD_GOLD_NUM:setText(cellData.originalCost)
		-- 显示图标
		self:showIconsOfGoods(cell,cellData.array, cellData.type)
		-- 处理按钮和进度数字颜色
		if (cellData.status == 1) then
			cell.BTN_GET_REWARD:setEnabled(true)
			cell.TFD_LEFT:setColor(ccc3(0x08,0x8a,0x00))
		elseif (cellData.status == 0) then
			cell.BTN_RECHARGE:setEnabled(true)
			cell.TFD_LEFT:setColor(ccc3(0xdb,0x14,0x00))
		end
	end

	UIHelper.setSliding(_listView)
end

function RechargeBonusView:destroy(...)
	_layMain = nil
	_listView = nil
	package.loaded["RechargeBonusView"] = nil
end

function RechargeBonusView:moduleName()
    return "RechargeBonusView"
end

function RechargeBonusView:ctor()
	_layMain = g_fnLoadUI("ui/activity_recharge_welfare.json")
end

function RechargeBonusView:create(...)

	--国际化
	self:dealWithi18n()
	--时间
	_layMain.tfd_time_num:setText(RechargeBonusModel.getCountDownTime())
	
	local function refreshListView()

		-- 更新充值天数的记录并刷新界面
		RechargeBonusModel.updateChargeDays()
		self:initRechargeBonusListView()
		--处理红点
		local mainActivity = WonderfulActModel.tbBtnActList.rechargeBonus
		mainActivity:setVisible(true)
		local numRedPoint = RechargeBonusModel.numRedPoint()
		mainActivity.LABN_TIP_EAT:setStringValue(numRedPoint)
		if (tonumber(numRedPoint) == 0) then 
			mainActivity.IMG_TIP:setVisible(false)
		end

		-- 直接从新拉取后端的方式
		-- function getRechargeBonusDataCallback( cbFlag, dictData, bRet )
		-- 	if (bRet) then
		-- 		RechargeBonusModel.setBackendInfo(dictData.ret)
		-- 		self:initRechargeBonusListView()
		-- 		--处理红点
		-- 		local mainActivity = WonderfulActModel.tbBtnActList.rechargeBonus
		-- 		mainActivity:setVisible(true)
		-- 		local numRedPoint = RechargeBonusModel.numRedPoint()
		-- 		mainActivity.LABN_TIP_EAT:setStringValue(numRedPoint)
		-- 		if (tonumber(numRedPoint) == 0) then 
		-- 			mainActivity.IMG_TIP:setVisible(false)
		-- 		end
		-- 	end
		-- end
		-- RequestCenter.rechargeBonus_getInfo(getRechargeBonusDataCallback)
	end

	UIHelper.registExitAndEnterCall(_layMain,
		function ()
			self:removeRedPoint()
			--GlobalScheduler.removeCallback("updateRechargeBonusActivityTime")
			GlobalNotify.removeObserver("PUSHCHARGEOK", "PUSHCHARGEOK_RechargeBonus")
			GlobalNotify.addObserver("RECHARGEBONUS", function ()
				return RechargeBonusModel.updateChargeDays()
			end, nil, "RECHARGEBONUS_UPDATE")
			_layMain = nil
			RechargeBonusCtrl.destroy()
		end,
		function ()
			GlobalNotify.addObserver("PUSHCHARGEOK", refreshListView, false, "PUSHCHARGEOK_RechargeBonus")
			--GlobalScheduler.addCallback("updateRechargeBonusActivityTime", updateActivityTime) 
			GlobalNotify.removeObserver("RECHARGEBONUS", "RECHARGEBONUS_UPDATE")
		end
	)

	_layMain.img_main_bg:setScaleX(g_fScaleX)	--背景适配屏幕
	_layMain.img_chunjie_middle:setScale(g_fScaleX)
	_layMain.img_chunjie_top:setScale(g_fScaleX)
	_layMain.img_chunjie_bg:setScale(g_fScaleX)

	-- _layMain.img_chunjie_middle:setScaleY(g_fScaleY)
	-- _layMain.img_chunjie_top:setScaleY(g_fScaleY)
	-- _layMain.img_chunjie_bg:setScaleY(g_fScaleY)
	--初始化list
	_listView = _layMain.LSV_TOTAL
	UIHelper.initListView(_listView)
	self:initRechargeBonusListView()
	return _layMain
end
