-- FileName: RechargeBackView.lua
-- Author: Xufei
-- Date: 2015-07-01
-- Purpose: 充值回馈 界面模块
--[[TODO List]]

RechargeBackView = class("RechargeBackView")
require "script/module/wonderfulActivity/rechargeBack/RechargeBackModel"

-- UI控件引用变量 --
local _mainLayer = nil
local _listView = nil

-- 模块局部变量 --
local _i18n = gi18n
local _tbInfo = {}

--desc:跳转到第一个没领取的行
function RechargeBackView:scrollRechargeBack()
	local nIdxOfBtn = RechargeBackModel.getScrollLine()
	logger:debug({nIdxOfBtn = nIdxOfBtn})
	local colGap = _listView:getItemsMargin() -- 行cell间隔
	local szRowCell = _listView.LAY_CELL:getSize()
	local hScrollTo = (szRowCell.height + colGap) * nIdxOfBtn
	local szInner = _listView:getInnerContainerSize()
	local szView = _listView:getSize()
	local totalHeight = (szRowCell.height + colGap) * RechargeBackModel.getRewardNum()
	_listView:setInnerContainerSize(CCSizeMake(szInner.width, totalHeight))
	local percent = (hScrollTo/(szInner.height - szView.height)) * 100 --出现过(szInner.height - szView.height == 0)的情况，后来恢复正常，没找出原因
	--local percent = (hScrollTo/(475)) * 100 --在出现(szInner.height - szView.height == 0)时临时代替
	_listView:jumpToPercentVertical(percent)
end

--desc:向服务器传递领取的Id的回调函数
local function receiveCallback(btnGetReward, imgRecieved, tbRewardStr)
	logger:debug({receiveDataInReceiveCallBack = tbRewardStr})
	btnGetReward:setEnabled(false)
	imgRecieved:setVisible(true)
	local tbItem = RewardUtil.parseRewards(tbRewardStr, true)
	local layReward = UIHelper.createGetRewardInfoDlg(_i18n[5730], tbItem)  --TODO
	LayerManager.addLayout(layReward)
	--更新保存的后端数据
	RechargeBackModel.updateRechargeBackInfo( btnGetReward:getTag() + 1 )
	--更新红点数
	WonderfulActModel.tbBtnActList.rechargeBack:setVisible(true)
	local numberLab = WonderfulActModel.tbBtnActList.rechargeBack.LABN_TIP_EAT
	numberLab:setStringValue(RechargeBackModel.getCanReceiveNum())
	local imgTip = WonderfulActModel.tbBtnActList.rechargeBack.IMG_TIP
	if(RechargeBackModel.getCanReceiveNum() == 0) then
		imgTip:setEnabled(false)
	end
end

--desc:领取按钮回调函数
local function btnGetCallBack( btnGetSender , imgRecieved, selectedIndex)
	local numRewardIndex = btnGetSender:getTag() + 1       --tag比rewardId小1
	local tbRewardStr = RechargeBackModel.getRewardDataByTag(numRewardIndex)
	if (selectedIndex) then
		tbRewardStr  =  lua_string_split(tbRewardStr, "," )[selectedIndex]
	end
	logger:debug({numRewardIndex = numRewardIndex})
	logger:debug({tbRewardData = tbRewardStr})
	-- 判断背包是否已满
	for k,v in pairs( RewardUtil.getItemsDataByStr(tbRewardStr) ) do
		if (tonumber(v.tid) ~= 0 and ItemUtil.bagIsFullWithTid(v.tid, true)) then
			AudioHelper.playCommonEffect()
			return
		end
	end
	local function receiveRechargeBack( cbFlag, dictData, bRet )
		logger:debug("点击了领取奖励.." .. numRewardIndex)
		if (bRet) then 
			if (dictData.ret == 'ok') then 
				receiveCallback(btnGetSender, imgRecieved, tbRewardStr)
			end
		end
	end
	local nIdxArray
	if (selectedIndex) then
		nIdxArray = Network.argsHandlerOfTable({numRewardIndex, selectedIndex})
	else
		nIdxArray = Network.argsHandlerOfTable({numRewardIndex})
	end
	AudioHelper.playTansuo02()
	RequestCenter.recharge_gainReward(receiveRechargeBack, nIdxArray)
end

--desc:初始化每行中的每个奖励图标
function RechargeBackView:initRowCell( tbRowData, colCell )
	logger:debug({ tbRowData = tbRowData })
	colCell.IMG_GOODS:addChild(tbRowData.icon)
	colCell.TFD_GOODS_NAME:setColor(g_QulityColor[tbRowData.quality])
	colCell.TFD_GOODS_NAME:setText(tbRowData.name)
end

--desc:刷新显示listView中的每一行
function RechargeBackView:refreshListView()
	local nIdx,cell
	_listView:removeAllItems()
	for k,v in ipairs(_tbInfo) do
		logger:debug({vTbInfo = v})

		_listView:pushBackDefaultItem()
		nIdx = k - 1 --cell索引从0开始
		logger:debug({refreshnIdx = nIdx})
		--获得此行的cell
		cell = _listView:getItem(nIdx)	

		cell:setSize(CCSizeMake(cell:getSize().width * g_fScaleX, cell:getSize().height * g_fScaleX))
		cell.IMG_CELL:setScaleX(g_fScaleX)
		cell.IMG_CELL:setScaleY(g_fScaleX)
		--显示每个cell顶部的文字
		local numCoin = v.gold
		local numSpend = tonumber(RechargeBackModel.getRechargeGolds())
		cell.TFD_CELL_3:setText(numCoin .. _i18n[2220])		-- 金币
		cell.TFD_CELL_2:setText("(" .. numSpend .. "/" .. numCoin ..")")
		if ( numSpend < numCoin ) then
			cell.TFD_CELL_2:setColor(ccc3(216,20,0))		--TODO:颜色数值需要确认
		end

		--显示cell中的每个物品
		local goodsListView = cell.LSV_FORTBV
		local orCell = cell.LAY_OR
		UIHelper.initListView(goodsListView)
		goodsListView:removeAllItems()
		local index = 0

		if (v.type == "1") then -- 按照不能选的来
			for k1,v1 in ipairs (v.reward) do
				goodsListView:pushBackDefaultItem()
				local goodCell = goodsListView:getItem(k1-1)
				self:initRowCell(v1, goodCell)
			end
		elseif (v.type == "2") then -- 按照能选的来
			for k1,v1 in ipairs (v.reward) do
				goodsListView:pushBackDefaultItem()
				index = index + 1
				local goodCell = goodsListView:getItem(index-1)
				self:initRowCell(v1, goodCell)
				local cloneORCell = orCell:clone()
				goodsListView:pushBackCustomItem(cloneORCell)
				index = index + 1
			end
			goodsListView:removeLastItem()
		end

		UIHelper.setSliding(goodsListView)

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
						if (RechargeBackModel.isInTime()) then
							if (v.type == "1") then
								btnGetCallBack(sender, imgAlreadyGet)
							elseif  (v.type == "2") then
								AudioHelper.playCommonEffect()
								ChooseItemCtrl.create(v.rewardStr, ChooseItemCtrl.kTYPE_GAIN, function ( index )
									btnGetCallBack(sender, imgAlreadyGet, index+1)
								end)
							end
						else
							AudioHelper.playCommonEffect()
							ShowNotice.showShellInfo(_i18n[5739])  --TODO  
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
	UIHelper.setSliding(_listView)
end

function RechargeBackView:destroy()
	package.loaded["RechargeBackView"] = nil
end

function RechargeBackView:moduleName()
    return "RechargeBackView"
end

function RechargeBackView:ctor(fnCloseCallback)
	_mainLayer = g_fnLoadUI("ui/activity_recharge.json")
end

--[[desc:显示消费累积活动的主界面
    arg1: table: {	1 = {status =  , gold =  , reward = { 1 = {type = "", quantity = "", id = ""},
    													  2 = {...}, ...}},
    				2 = {...}, ...} 
—]]
function RechargeBackView:create(tbArgs)
	UIHelper.registExitAndEnterCall(_mainLayer,
		function()
			_mainLayer = nil
			RechargeBackCtrl.destroy()
		end
	)
	table.hcopy(tbArgs, _tbInfo)
	logger:debug({_tbInfo = _tbInfo})
	local labTimeName = _mainLayer.tfd_time
	labTimeName:setText(_i18n[5740])				--TODO
	UIHelper.labelNewStroke(labTimeName, ccc3(0x28, 0x00, 0x00))
	_mainLayer.img_main_bg:setScaleX(g_fScaleX)	--背景适配屏幕
	_mainLayer.tfd_activity:setText(_i18n[5731])
	_mainLayer.tfd_recharge:setText(_i18n[5733])
	_mainLayer.tfd_recharge_num:setText(_i18n[5734])
	_mainLayer.tfd_recharge_reward:setText(_i18n[5735])
	_mainLayer.tfd_cell_1:setText(_i18n[5737])
	_mainLayer.tfd_cell_4:setText(_i18n[5738])

	require "script/utils/NewTimeUtil"
	local timeFrom = lua_string_split(RechargeBackModel.getActivityTime(), '-')[1]
	local timeTo = lua_string_split(RechargeBackModel.getActivityTime(), '-')[2]
	local LabTime = _mainLayer.tfd_time_num
	LabTime:setText(NewTimeUtil.getTimeFormatYMDHMdot(timeFrom) .. " — " .. NewTimeUtil.getTimeFormatYMDHMdot(timeTo))
	UIHelper.labelNewStroke(LabTime, ccc3(0x28, 0x00, 0x00))
	_listView = _mainLayer.LSV_TOTAL
	UIHelper.initListView(_listView)
	_listView:setTouchEnabled(true)
	--performWithDelay(_mainLayer, function ()
		self:refreshListView()
		self:scrollRechargeBack()
	--end, 1/60)
	return _mainLayer
end