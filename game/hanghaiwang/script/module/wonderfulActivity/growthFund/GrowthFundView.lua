-- FileName: GrowthFundView.lua
-- Author: LvNanchun and XuFei
-- Date: 2015-06-17
-- Purpose: 成长基金UI显示
--[[TODO List]]

-- module("GrowthFundView", package.seeall)
GrowthFundView = class("GrowthFundView")
require "script/module/wonderfulActivity/growthFund/GrowthFundModel"
require "script/model/user/UserModel"
require "script/module/wonderfulActivity/growthFund/GrowthFundTabView"

-- UI控件引用变量 --
local _layMain
local _listView
local _layTabView
-- 模块局部变量 --
local _i18n = gi18n
local _tbListViewRe = {}
local _szRowCell
local _ifBuy

function GrowthFundView:destroy(...)
	package.loaded["GrowthFundView"] = nil
end

function GrowthFundView:moduleName()
    return "GrowthFundView"
end

--设置充值后刷新的vip值
function GrowthFundView:setVipNow()
	_layMain.LABN_VIP_NOW:setStringValue(UserModel.getVipLevel())
end

--[[desc:跳转到第一个没领取的
    arg1: 第一个没领取的行数
    return: 无
—]]
function GrowthFundView:scrollGrowthFund()
	local nIdxOfBtn = 0
	for k,v in pairs(_tbListViewRe) do 
		if (v.color == 2) then 
			nIdxOfBtn = nIdxOfBtn + 1
		else
			break
		end
	end

	logger:debug({nIdxOfBtn = nIdxOfBtn})

	local colGap = _listView:getItemsMargin() -- 行cell间隔

	local hScrollTo = (_szRowCell.height + colGap) * nIdxOfBtn

	local szInner = _listView:getInnerContainerSize()
	local szView = _listView:getSize()

	local totalHeight = (_szRowCell.height + colGap) * #_tbListViewRe
	_listView:setInnerContainerSize(CCSizeMake(szInner.width, totalHeight))
	local percent = (hScrollTo/(szInner.height - szView.height)) * 100

	logger:debug({listViewPercent = percent})

	_listView:jumpToPercentVertical(percent)
end

--[[desc:领取按钮的回调函数
    arg1: 按钮本身
    return: 无
—]]
local function btnGetCallBack( btnGetSender )
	local btnIndex = btnGetSender:getTag()
	GrowthFundModel.setPrizedArrayById(btnIndex) 
	logger:debug({btnIndex = btnIndex})
	local numCoins = _tbListViewRe[btnIndex + 1].coins
	--处理红点
	local mainActivity = WonderfulActModel.tbBtnActList.growthfund
	mainActivity:setVisible(true)
	local numRedPoint = GrowthFundModel.getUnprizedNumByTime() + EveryoneWelfareModel.getNumStillCanReceive()	
	mainActivity.LABN_TIP_EAT:setStringValue(numRedPoint)
	if (numRedPoint == 0) then 
		mainActivity.IMG_TIP:setVisible(false)
	end
	if (GrowthFundModel.getUnprizedNumByTime() == 0) then
		_layTabView.IMG_FUND_TIP:setVisible(false)
	end
	local function receiveGrowthFund( cbFlag, dictData, bRet )
		logger:debug({receiveGrowthFundDictData = dictData})
		if (bRet == true) then 
			if (dictData.ret == 'ok') then 
				UserModel.addGoldNumber(numCoins)
				local layReward = UIHelper.createGetRewardInfoDlg(_i18n[3739],{{icon = ItemUtil.getGoldIconByNum(numCoins), name = _i18n[2220], quality = 5}})
				LayerManager.addLayout(layReward)
			end
		end
	end

	local nIdxArray = Network.argsHandlerOfTable({btnIndex,1})	-- 1 代表领取的是成长基金
	RequestCenter.growUp_receive(receiveGrowthFund, nIdxArray)
end

--[[desc:显示listView中的cell
    arg1: 无
    return: 无
—]]
function GrowthFundView:refreshListView(  )
	local nIdx,cell

	logger:debug({_tbListViewRe = _tbListViewRe})

	--local numUnprized = GrowthFundModel.getUnprizedNumByLevel()
	_listView:removeAllItems()
	for k,v in pairs(_tbListViewRe) do 
		_listView:pushBackDefaultItem()

		nIdx = k - 1
		logger:debug({nIdx = nIdx})

		cell = _listView:getItem(nIdx)

		cell.img_cell_bg.TFD_GOLD_NUM:setText(tostring(v.coins) .. _i18n[2220])
		imgInfoBg = cell.img_cell_bg.img_info_bg

		imgInfoBg.tfd_can_get:setText(_i18n[1314])
		imgInfoBg.tfd_dadao:setText(_i18n[1313])
		imgInfoBg.TFD_NEED_LV:setText( tostring(v.level) .. _i18n[3643])

		local layGoldIcon = ItemUtil.getGoldIconByNum(v.coins)
		local layGoldCell = cell.img_cell_bg.LAY_GOLD
		layGoldIcon:setPosition(ccp(layGoldCell:getContentSize().width / 2 , layGoldCell:getContentSize().height / 2))
		layGoldCell:addChild(layGoldIcon)

		local btnGet = cell.img_cell_bg.BTN_GET
		UIHelper.titleShadow(btnGet, _i18n[2628])
		btnGet:setTag(nIdx)
		
		local imgAlreadyGet = cell.img_cell_bg.IMG_ALREADY_GET
		
		if (_ifBuy == 0) then 
			imgAlreadyGet:setVisible(false)
			btnGet:setVisible(true)
			btnGet:setBright(false)
			btnGet:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then 
					--AudioHelper.playTansuo02()
					ShowNotice.showShellInfo(_i18n[5706])         
				end
			end)
		elseif (v.color == 2) then
			btnGet:removeFromParentAndCleanup(true)
			imgAlreadyGet:setVisible(true)
		elseif (v.color == 1) then
			imgAlreadyGet:setVisible(false)
			btnGet:setVisible(true)
			btnGet:setBright(false)
			btnGet:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then 
					--AudioHelper.playTansuo02()
					ShowNotice.showShellInfo(_i18n[1313] .. string.format(_i18n[2504] , v.level))
				end
			end)
		elseif (v.color == 0) then
			imgAlreadyGet:setVisible(false)
			btnGet:setVisible(true)
			btnGet:setBright(true)
			local function getCoinsCallBack( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then 
					AudioHelper.playTansuo02()
					btnGetCallBack(sender)
					imgAlreadyGet:setVisible(true)
					btnGet:removeFromParentAndCleanup(true)

					-- local mainActivity = WonderfulActModel.tbBtnActList.growthfund
					-- mainActivity:setVisible(true)
					-- mainActivity.LABN_TIP_EAT:setStringValue(numUnprized - 1)
				
					--if(numUnprized - 1) == 0 then
					--	mainActivity.IMG_TIP:setEnabled(false)
					--end

					--numUnprized = numUnprized - 1 
				end
			end 
			btnGet:addTouchEventListener(getCoinsCallBack)
		end
	end
end

--[[desc:处理CTRL传来的数据并返回数据
    arg1: 无
    return:包含按钮状态的table{level= , coins = , color = }
—]]
function GrowthFundView:dealWithData()
	local tbCoinAndLevel = GrowthFundModel.getCoinsAndLevel()
	local tbPrized = GrowthFundModel.prizedArray()

--color取值为0，1，2。分别表示按钮亮，按钮暗和按钮为绿色图片--
	logger:debug({tbCoinAndLevel = tbCoinAndLevel})

	for k,v in pairs(tbCoinAndLevel) do 
		_tbListViewRe[k] = {}
		_tbListViewRe[k]['level'] = v.level
		_tbListViewRe[k]['coins'] = v.coins
		_tbListViewRe[k]['color'] = 0
	end

	for k,v in pairs(tbPrized) do
		_tbListViewRe[v + 1]['color'] = 2
	end

	for k,v in pairs(_tbListViewRe) do
		if (k > GrowthFundModel.maxPrizeLevel()) then
			_tbListViewRe[k]['color'] = 1
		end
	end

	logger:debug({_tbListViewRe = _tbListViewRe})
end


function GrowthFundView:ctor()
	self.layMain = g_fnLoadUI("ui/activity_growth_fund.json")
end

--[[desc:功能简介
    arg1: 无
    return: 是否有返回值，返回值说明  
—]]
function GrowthFundView:create()
	local numVipNeeded = GrowthFundModel.getVipLevelNeeded()
	local numVipNow = UserModel.getVipLevel()

	_layMain = self.layMain
	UIHelper.registExitAndEnterCall(_layMain,
		function()
			GlobalNotify.removeObserver("PUSHCHARGEOK", "PUSHCHARGEOK_Growth")
			_layMain=nil
			GrowthFundCtrl.destroy()
		end,
		function()
			GlobalNotify.addObserver("PUSHCHARGEOK", function ()
				self:setVipNow()
			end, false, "PUSHCHARGEOK_Growth")
		end
	) 
	

	_layMain.img_bg:setScaleX(g_fScaleX)
	_layMain.img_bg:setScaleY(g_fScaleY)
	_layMain.LABN_VIP_NUM:setStringValue(numVipNeeded)
	_layMain.IMG_LSV_BG.tfd_canbuy:setText(_i18n[2263])
	_layMain.IMG_LSV_BG.tfd_reach:setText(_i18n[1313])
	_layMain.tfd_now:setText(_i18n[5704])               
	UIHelper.labelNewStroke(_layMain.tfd_now,ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(_layMain.IMG_LSV_BG.tfd_canbuy,ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(_layMain.IMG_LSV_BG.tfd_reach,ccc3(0x28,0x00,0x00))
	_layMain.LABN_VIP_NOW:setStringValue(numVipNow)

	local btnBuy = _layMain.IMG_LSV_BG.BTN_BUY

	_ifBuy = GrowthFundModel.buyTime()

	if (_ifBuy == 0) then
		UIHelper.titleShadow( btnBuy, _i18n[5750] )  ---TODO
	else
		UIHelper.titleShadow( btnBuy, _i18n[1452] )
	end
	btnBuy:setTouchEnabled(_ifBuy == 0)
	UIHelper.setWidgetGray(btnBuy,_ifBuy ~= 0)

	_listView = _layMain.IMG_LSV_BG.LSV_MAIN

	local function btnBuyCallBack( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/wonderfulActivity/growthFund/GrowthFundTip"

			if (GrowthFundModel.isVipEnough()) then
				if (GrowthFundModel.isGoldEnough()) then 
					LayerManager.addLayout(GrowthFundTip.create(_layTabView))
					_ifBuy = 1
					GrowthFundTip.refreshCellAndButton(btnBuy, _listView ,self.refreshListView )
				else 
					LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
				end
			else
				if (numVipNow < numVipNeeded) then
					ShowNotice.showShellInfo(_i18n[2117] .. numVipNeeded .. _i18n[5705])  
				end
			end
		end
	end
	btnBuy:addTouchEventListener(btnBuyCallBack)

	_szRowCell = _listView.LAY_CELL:getSize()

	UIHelper.initListView(_listView)

	self:dealWithData()
	self:refreshListView()

	local layTabInstanceView = GrowthFundTabView:new()
	_layTabView = layTabInstanceView:create(1)
	_layMain:addChild(_layTabView)

	return _layMain
end

