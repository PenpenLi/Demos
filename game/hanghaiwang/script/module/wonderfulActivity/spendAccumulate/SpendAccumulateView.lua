-- FileName: SpendAccumulateView.lua
-- Author: Xufei
-- Date: 2015-06-25
-- Purpose: 消费累积 界面模块
--[[TODO List]]

SpendAccumulateView = class("SpendAccumulateView")
require "script/module/wonderfulActivity/spendAccumulate/SpendAccumulateModel"

-- UI控件引用变量 --
local _mainLayer = nil
local _listView = nil

-- 模块局部变量 --
local _i18n = gi18n

--desc:跳转到第一个没领取的行
function SpendAccumulateView:scrollSpendAccumulate()
	local nIdxOfBtn = SpendAccumulateModel.getScrollLine()
	logger:debug({nIdxOfBtn = nIdxOfBtn})
	local colGap = _listView:getItemsMargin() -- 行cell间隔
	local szRowCell = _listView.LAY_CELL:getSize()
	local hScrollTo = (szRowCell.height + colGap) * nIdxOfBtn
	local szInner = _listView:getInnerContainerSize()
	local szView = _listView:getSize()
	local totalHeight = (szRowCell.height + colGap) * SpendAccumulateModel.getRewardNum()
	_listView:setInnerContainerSize(CCSizeMake(szInner.width, totalHeight))
	local percent = (hScrollTo/(szInner.height - szView.height)) * 100
	logger:debug({height = szInner.height - szView.height})
	logger:debug({listViewPercent = percent})
	_listView:jumpToPercentVertical(percent)
end

--desc:向服务器传递领取的Id的回调函数
local function receiveCallback(btnGetReward, imgRecieved, tbRewardData)
	logger:debug({receiveDataInReceiveCallBack = tbRewardData})
	btnGetReward:setEnabled(false)
	imgRecieved:setVisible(true)
	local tbItem = {}
	for k,v in pairs(tbRewardData) do 
		local tb = {}
		logger:debug({valueofRewardData = v})	
		if (v.type == '1') then
			tb.icon = UIHelper.getItemIconAndUpdate(v.type,v.quantity)
			tb.name = _i18n[1520] -- "贝里" 
			tb.quality = 5
			table.insert(tbItem,tb)
		elseif (v.type == '3') then
			tb.icon = UIHelper.getItemIconAndUpdate(v.type,v.quantity)
			tb.name = _i18n[2220] -- "金币"
			tb.quality = 5
			table.insert(tbItem,tb)
		else
			tb.icon = UIHelper.getItemIconAndUpdate(v.type, v.id .. '|' .. v.quantity)
			tb.name = ItemUtil.getItemById(v.id)[2]
			tb.quality = ItemUtil.getItemById(v.id)[7]
			table.insert(tbItem,tb)
		end
	end
	local layReward = UIHelper.createGetRewardInfoDlg(_i18n[5729],tbItem)  --TODO
	LayerManager.addLayout(layReward)
	--更新保存的后端数据
	SpendAccumulateModel.updateSpendAccInfo( btnGetReward:getTag() + 1 )
	--更新红点数
	WonderfulActModel.tbBtnActList.spendAccumulate:setVisible(true)
	local numberLab = WonderfulActModel.tbBtnActList.spendAccumulate.LABN_TIP_EAT
	numberLab:setStringValue(SpendAccumulateModel.getCanReceiveNum())
	local imgTip = WonderfulActModel.tbBtnActList.spendAccumulate.IMG_TIP
	if(SpendAccumulateModel.getCanReceiveNum() == 0) then
		imgTip:setEnabled(false)
	end
end

--desc:领取按钮回调函数
local function btnGetCallBack( btnGetSender , imgRecieved)
	local numRewardIndex = btnGetSender:getTag() + 1       --tag比rewardId小1
	local tbRewardData = SpendAccumulateModel.getRewardDataByTag(numRewardIndex)
	logger:debug({numRewardIndex = numRewardIndex})
	logger:debug({tbRewardData = tbRewardData})
	-- 判断背包是否已满
	for k,v in pairs(tbRewardData) do
		if (tonumber(v.id) ~= 0 and ItemUtil.bagIsFullWithTid(v.id, true)) then
			return
		end
	end
	local function receiveSpendAccumulate( cbFlag, dictData, bRet )
		logger:debug("点击了领取奖励" .. numRewardIndex)
		if (bRet) then 
			if (dictData.ret == 'ok') then 
				receiveCallback(btnGetSender, imgRecieved, tbRewardData)
			end
		end
	end
	local nIdxArray = Network.argsHandlerOfTable({numRewardIndex})    
	RequestCenter.spend_gainReward(receiveSpendAccumulate, nIdxArray)
end

--[[desc:初始化每行中的每个奖励图标
    arg1: 每行奖励的数据表，奖励图标
—]]
function SpendAccumulateView:initRowCell( tbRowData, colCell )
	logger:debug({ tbRowData = tbRowData })
	colCell.IMG_GOODS:addChild(tbRowData.icon)
	colCell.TFD_GOODS_NAME:setColor(g_QulityColor[tbRowData.quality])
	colCell.TFD_GOODS_NAME:setText(tbRowData.name)
end

--desc:刷新显示listView中的每一行
function SpendAccumulateView:refreshListView()
	local listViewData =  SpendAccumulateModel.getSpendListViewData()
	local nIdx,cell
	_listView:removeAllItems()
	for k,v in ipairs(listViewData) do
		logger:debug({vTbInfo = v})
		_listView:pushBackDefaultItem()
		--cell索引从0开始
		nIdx = k - 1
		logger:debug({nIdx = nIdx})
		--获得此行的cell
		cell = _listView:getItem(nIdx)

		cell:setSize(CCSizeMake(cell:getSize().width * g_fScaleX, cell:getSize().height * g_fScaleX))
		cell.IMG_CELL:setScaleX(g_fScaleX)
		cell.IMG_CELL:setScaleY(g_fScaleX)

		--显示每个cell顶部的文字
		local numCoin = v.gold
		local numSpend = tonumber(SpendAccumulateModel.getExpenseGolds())
		cell.TFD_CELL_3:setText(numCoin .. _i18n[2220])		-- 金币
		cell.TFD_CELL_2:setText("(" .. numSpend .. "/" .. numCoin ..")")
		if ( numSpend < numCoin ) then
			cell.TFD_CELL_2:setColor(ccc3(216,20,0))		--TODO:颜色数值需要确认
		end
		--显示cell中的每个物品
		local layGoodsFrame = cell.LSV_FORTBV
		UIHelper.initListView(layGoodsFrame)

		local tbGoodsData = v.reward
		for i, colData in ipairs(tbGoodsData) do
			layGoodsFrame:pushBackDefaultItem()
			local colCell = layGoodsFrame:getItem(i-1)
			--performWithDelay(_mainLayer, function ()
				self:initRowCell(colData, colCell)
			--end, (i+k)/60)
		end
		--处理领取按钮,v.status=0是未领取，等于1是已经领取
		local btnGet = cell.BTN_GET_REWARD
		UIHelper.titleShadow(btnGet, _i18n[2628])
		btnGet:setTag(nIdx)
		local imgAlreadyGet = cell.IMG_RECIEVED
		if (v.status == 0) then
			if (numSpend >= numCoin) then                             --可以领取
				imgAlreadyGet:setVisible(false)
				btnGet:setVisible(true)
				btnGet:setBright(true)
				local function getRewardCallBack( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then 
						if (SpendAccumulateModel.isInTime()) then
							AudioHelper.playTansuo02()
							btnGetCallBack(sender, imgAlreadyGet)
						else
							AudioHelper.playCommonEffect()
							ShowNotice.showShellInfo(_i18n[5739])    -- 活动已结束，无法领取奖励
						end
					end
				end 
				btnGet:addTouchEventListener(getRewardCallBack)
			else                                                      --不能领取
				imgAlreadyGet:setVisible(false)
				btnGet:setVisible(true)
				btnGet:setBright(false)
			end
		elseif (v.status == 1) then    								  --已经领过
			imgAlreadyGet:setVisible(true)
			btnGet:removeFromParentAndCleanup(true)
		end
	end
end

function SpendAccumulateView:destroy()
	package.loaded["SpendAccumulateView"] = nil
end

function SpendAccumulateView:moduleName()
    return "SpendAccumulateView"
end

function SpendAccumulateView:ctor(fnCloseCallback)
	_mainLayer = g_fnLoadUI("ui/activity_spending.json")
end

--[[desc:显示消费累积活动的主界面
    arg1: table: {	1 = {status =  , gold =  , reward = { 1 = {type = "", quantity = "", id = ""},
    													  2 = {...}, ...}},
    				2 = {...}, ...}
    return: 是否有返回值，返回值说明  
—]]
function SpendAccumulateView:create()
	UIHelper.registExitAndEnterCall(_mainLayer,
		function()
			GlobalNotify.removeObserver("SpendAccRefreshViewInView", "SpendAccRefreshView")
			_mainLayer = nil
			SpendAccumulateCtrl.destroy()
		end
	)
	require "script/module/wonderfulActivity/spendAccumulate/SpendAccumulateCtrl"
	GlobalNotify.addObserver("SpendAccRefreshViewInView", function ()
		logger:debug("notify callback log")
		SpendAccumulateCtrl.refreshView()
		end, false, "SpendAccRefreshView")
	_mainLayer.img_main_bg:setScaleX(g_fScaleX)	--背景适配屏幕
	_mainLayer.tfd_time:setText(_i18n[5740])
	UIHelper.labelNewStroke(_mainLayer.tfd_time, ccc3(0x28, 0x00, 0x00))
	_mainLayer.tfd_activity:setText(_i18n[5731])
	_mainLayer.tfd_recharge:setText(_i18n[5732])
	_mainLayer.tfd_recharge_num:setText(_i18n[5734])
	_mainLayer.tfd_recharge_reward:setText(_i18n[5735])
	_mainLayer.tfd_cell_1:setText(_i18n[5736])
	_mainLayer.tfd_cell_4:setText(_i18n[5738])

	require "script/utils/NewTimeUtil"
	local timeFrom = lua_string_split(SpendAccumulateModel.getActivityTime(), '-')[1]
	local timeTo = lua_string_split(SpendAccumulateModel.getActivityTime(), '-')[2]
	_mainLayer.tfd_time_num:setText(NewTimeUtil.getTimeFormatYMDHMdot(timeFrom) .. " — " .. NewTimeUtil.getTimeFormatYMDHMdot(timeTo))
	UIHelper.labelNewStroke(_mainLayer.tfd_time_num, ccc3(0x28, 0x00, 0x00))
	_listView = _mainLayer.LSV_TOTAL
	UIHelper.initListView(_listView)
	_listView:setTouchEnabled(true)
	--performWithDelay(_mainLayer, function ()
		self:refreshListView()
		self:scrollSpendAccumulate()
	--end, 1/60)
	return _mainLayer
end
