-- FileName: EveryoneWelfareView.lua
-- Author: Xufei
-- Date: 2015-08-10
-- Purpose: 全民福利 视图
--[[TODO List]]

EveryoneWelfareView = class("EveryoneWelfareView")
require "script/module/wonderfulActivity/growthFund/EveryoneWelfareModel"
require "script/module/wonderfulActivity/growthFund/GrowthFundTabView"

-- UI控件引用变量 --
local _layMain
local _listView
local _layTabView

-- 模块局部变量 --
local _i18n = gi18n

function EveryoneWelfareView:scrollGrowthFundView()
	local nIdxOfBtn = EveryoneWelfareModel.getNumOfFirstStillCanReceive()

	logger:debug({nIdxOfBtn = nIdxOfBtn})

	local colGap = _listView:getItemsMargin() -- 行cell间隔

	local szRowCell = _listView.LAY_CELL:getSize()
	local hScrollTo = (szRowCell.height + colGap) * nIdxOfBtn

	local szInner = _listView:getInnerContainerSize()
	local szView = _listView:getSize()

	local totalHeight = (szRowCell.height + colGap) * EveryoneWelfareModel.getSumRewardNum()
	_listView:setInnerContainerSize(CCSizeMake(szInner.width, totalHeight))

	if (szInner.height == szView.height) then
		return
	end
	local percent = (hScrollTo/(szInner.height - szView.height)) * 100

	_listView:jumpToPercentVertical(percent)
end

function EveryoneWelfareView:dealWithI18nAndEffect( )
	_layMain.tfd_dadao:setText(_i18n[6403])
	_layMain.tfd_can_get:setText(_i18n[6404])
	
	_layMain.IMG_ALREADY_GET:setVisible(false)
end

function EveryoneWelfareView:receiveCallback( btnGetSender, imgRecieved, rewardString)
	btnGetSender:setEnabled(false)
	imgRecieved:setVisible(true)
	UIHelper.createGetRewardInfoDlg( _i18n[6406], 
		RewardUtil.parseRewards(rewardString, true) )
	-- 更新保存的后端数据
	EveryoneWelfareModel.updateInfo(btnGetSender:getTag())
	-- 刷新红点
	local mainActivity = WonderfulActModel.tbBtnActList.growthfund
	mainActivity:setVisible(true)
	local numRedPoint = GrowthFundModel.getUnprizedNumByTime() + EveryoneWelfareModel.getNumStillCanReceive()
	mainActivity.LABN_TIP_EAT:setStringValue(numRedPoint)
	if (numRedPoint == 0) then 
		mainActivity.IMG_TIP:setVisible(false)
	end
	if (EveryoneWelfareModel.getNumStillCanReceive() == 0) then
		_layTabView.IMG_ALL_PEOPLE:setVisible(false)
	end
end

function EveryoneWelfareView:btnGetCallBack( btnGetSender, imgRecieved, rewardInfo)
	local indexReward = btnGetSender:getTag()
	require "script/module/public/RewardUtil"
	if(tonumber(rewardInfo.rewardId)~=0 and ItemUtil.bagIsFullWithTid(rewardInfo.rewardId, true)) then
		return
	end
	local function requestCallBack( cbFlag, dictData, bRet )
		logger:debug("点击了领取奖励" .. indexReward)
		if (bRet) then
			if (dictData.ret == "ok") then
				self:receiveCallback( btnGetSender, imgRecieved, rewardInfo.rewardString )
			end
		end
	end
	local nIdxArray = Network.argsHandlerOfTable({indexReward,2})	-- 2 代表领取的是全民福利
	RequestCenter.growUp_receive(requestCallBack, nIdxArray)
end

function EveryoneWelfareView:initListView()
	local nIdx, cell
	_listView:removeAllItems()
	local tbListViewData = EveryoneWelfareModel.getDataForView()
	for k,v in ipairs(tbListViewData) do
		_listView:pushBackDefaultItem()
		nIdx = k-1
		cell = _listView:getItem(nIdx)
		local btnGet = cell.BTN_GET
		UIHelper.titleShadow(btnGet, _i18n[2628])
		btnGet:setTag(nIdx)
		btnGet:setEnabled(false)
		local imgAlreadyGet = cell.IMG_ALREADY_GET
		-- 显示图标
		if (v.rewardType == '1') then
			local btnGoods = UIHelper.getItemIcon(v.rewardType, v.rewardNum)
			local layGoods = cell.LAY_ITEM
			btnGoods:setPosition(ccp(layGoods:getContentSize().width / 2 , layGoods:getContentSize().height / 2))
			layGoods:addChild(btnGoods)
			cell.TFD_ITEM_NAME:setText(v.rewardNum .. _i18n[1520]) -- 贝里
		elseif (v.rewardType == '3') then
			local btnGoods = UIHelper.getItemIcon(v.rewardType, v.rewardNum)
			local layGoods = cell.LAY_ITEM
			btnGoods:setPosition(ccp(layGoods:getContentSize().width / 2 , layGoods:getContentSize().height / 2))
			layGoods:addChild(btnGoods)
			cell.TFD_ITEM_NAME:setText(v.rewardNum .. _i18n[2220]) -- 金币
		else
			local btnGoods = UIHelper.getItemIcon(v.rewardType, v.rewardId .. "|" .. v.rewardNum)
			local layGoods = cell.LAY_ITEM
			btnGoods:setPosition(ccp(layGoods:getContentSize().width / 2 , layGoods:getContentSize().height / 2))
			layGoods:addChild(btnGoods)
			local desc = ItemUtil.getItemById(v.rewardId)
			logger:debug({ descIs = desc })
			if (desc) then
				cell.TFD_ITEM_NAME:setText(desc[2] .. "*" .. v.rewardNum)
			end
		end
		cell.TFD_NEED_LV:setText(v.numPeople)
		--处理领取按钮
		if (v.status == 0) then
			btnGet:setEnabled(true)
			btnGet:setBright(false)
			local function getRewardFailCallBack( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					--AudioHelper.playTansuo02()
					ShowNotice.showShellInfo(_i18n[6403] .. v.numPeople .. _i18n[6407])
				end
			end
			btnGet:addTouchEventListener(getRewardFailCallBack)
		elseif (v.status == 1) then
			btnGet:setEnabled(true)
			local function getRewardCallBack( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playTansuo02()
					self:btnGetCallBack(sender, imgAlreadyGet , v)
				end
			end
			btnGet:addTouchEventListener(getRewardCallBack)
		elseif (v.status == 2) then
			imgAlreadyGet:setVisible(true)
		end
	end

end

function EveryoneWelfareView:destroy(...)
	package.loaded["EveryoneWelfareView"] = nil
end

function EveryoneWelfareView:moduleName()
    return "EveryoneWelfareView"
end

function EveryoneWelfareView:ctor()
	self.layMain = g_fnLoadUI("ui/activity_fund_allpeople.json")
end

function EveryoneWelfareView:create(...)
	_layMain = self.layMain
	UIHelper.registExitAndEnterCall(_layMain,
		function()
			_layMain=nil
			GrowthFundCtrl.destroy()
		end,
		function()
		end
	) 
	self:dealWithI18nAndEffect()
	_layMain.img_bg:setScaleX(g_fScaleX)
	_layMain.img_bg:setScaleY(g_fScaleY)

	-- 已购买人数
	local stringBuyNumOfPeople = tostring(EveryoneWelfareModel.getNumBought())
	if (tonumber(stringBuyNumOfPeople)>9999) then
		stringBuyNumOfPeople = tostring(9999)
	end
	local stringLen = string.len(stringBuyNumOfPeople)
	logger:debug({buypeople = stringBuyNumOfPeople})
	logger:debug({stringlen = stringLen})
	_layMain.TFD_QIAN:setText("0")
	_layMain.TFD_BAI:setText("0")
	_layMain.TFD_SHI:setText("0")
	_layMain.TFD_GE:setText("0")
	for i=0, stringLen-1 do
		if (i == 0) then
			_layMain.TFD_GE:setText(string.sub(stringBuyNumOfPeople,stringLen-i,stringLen-i))
		elseif (i == 1) then
			_layMain.TFD_SHI:setText(string.sub(stringBuyNumOfPeople,stringLen-i,stringLen-i))
		elseif (i == 2) then
			_layMain.TFD_BAI:setText(string.sub(stringBuyNumOfPeople,stringLen-i,stringLen-i))
		elseif (i == 3) then
			_layMain.TFD_QIAN:setText(string.sub(stringBuyNumOfPeople,stringLen-i,stringLen-i))
		end						
	end 

	-- 我也要买按钮
	local btnBuy = _layMain.BTN_BUY
	local numVipNeeded = GrowthFundModel.getVipLevelNeeded()
	local function btnBuyCallBack( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/wonderfulActivity/growthFund/GrowthFundTip"

			if (GrowthFundModel.isVipEnough()) then
				if (GrowthFundModel.isGoldEnough()) then 
					LayerManager.addLayout(GrowthFundTip.create(_layTabView, _layMain))
					GrowthFundTip.refreshCellAndButton(btnBuy)
				else 
					LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
				end
			else
				ShowNotice.showShellInfo(_i18n[2117] .. numVipNeeded .. _i18n[5705])  
			end
		end
	end
	_layMain.BTN_BUY:addTouchEventListener(btnBuyCallBack)

	if (GrowthFundModel.buyTime() == 0) then  -- 没买过
		UIHelper.titleShadow( btnBuy, _i18n[5751])  ---TODO
	else
		UIHelper.titleShadow( btnBuy, _i18n[1452] ) 
	end
	btnBuy:setTouchEnabled(GrowthFundModel.buyTime() == 0)
	UIHelper.setWidgetGray(btnBuy,GrowthFundModel.buyTime() ~= 0)

	local mainActivity = WonderfulActModel.tbBtnActList.growthfund
	mainActivity:setVisible(true)
	local numRedPoint = GrowthFundModel.getUnprizedNumByTime() + EveryoneWelfareModel.getNumStillCanReceive()
				logger:debug({refreshhongdianafterinit = numRedPoint})
	mainActivity.LABN_TIP_EAT:setStringValue(numRedPoint)
	if (numRedPoint == 0) then 
		mainActivity.IMG_TIP:setVisible(false)
	end

	_listView = _layMain.LSV_MAIN
	UIHelper.initListView(_listView)
	self:initListView()

	local layTabInstanceView = GrowthFundTabView:new()
	_layTabView = layTabInstanceView:create(2)
	_layMain:addChild(_layTabView)

	MainWonderfulActCtrl.addLayChild(_layMain)
	self:scrollGrowthFundView()
end
