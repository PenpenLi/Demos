-- FileName: WABetView.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: function description of module
--[[TODO List]]

WABetView = class("WABetView")

-- UI控件引用变量 --

-- 模块局部变量 --

local _fnGetWidget = g_fnGetWidgetByName
local _isBetOver = false

function WABetView:updateCellCommon( lsv,idx )
	local betInfo, betAtThis = WABetModel.getNowTabInfo()
	local tbData = betInfo[idx+1]
	local cell = lsv:getItem(idx).item

	-- tbData.rank_type~=nil表示这一条是被自己押注的
	-- betAtThis~=nil表示这个列表中已经押过注了
	local isMyBet = (tbData.rank_type~=nil)
	local hasBetThisList = (betAtThis~=nil)

	cell.img_bet_already:setVisible(isMyBet)

	cell.BTN_GOLD_BET:setVisible(not isMyBet)
	cell.BTN_GOLD_BET:setGray(((not isMyBet) and (hasBetThisList)) or _isBetOver)
	cell.BTN_GOLD_BET:setZOrder(999)	
	cell.BTN_GOLD_BET:setTouchEnabled((not hasBetThisList) and (not _isBetOver))

	cell.BTN_SILVER_BET:setVisible(not isMyBet)
	cell.BTN_SILVER_BET:setGray(((not isMyBet) and (hasBetThisList)) or _isBetOver)
	cell.BTN_SILVER_BET:setZOrder(999)	
	cell.BTN_SILVER_BET:setTouchEnabled((not hasBetThisList) and (not _isBetOver))

	cell.img_bet_belly:setVisible((isMyBet) and tonumber(tbData.bet_type)==1)
	cell.TFD_BELLY_NUM:setVisible((isMyBet) and tonumber(tbData.bet_type)==1)
	cell.img_bet_gold:setVisible((isMyBet) and tonumber(tbData.bet_type)==2)
	cell.TFD_GOLD_NUM:setVisible((isMyBet) and tonumber(tbData.bet_type)==2)

	cell.TFD_SERVER:setText("S."..tbData.server_id)
	cell.TFD_PLAYER_NAME:setText(tbData.uname)
	cell.TFD_ZHANDOULI_NUM:setText(tbData.fight_force)
	
	local color = UserModel.getPotentialColor({htid = tbData.figure})
	cell.TFD_PLAYER_NAME:setColor(color)
	cell.TFD_SERVER:setColor(color)
	local icon = HeroUtil.createHeroIconBtnByHtid(tonumber(tbData.figure))
	cell.LAY_PLAYER_ICON:removeAllChildrenWithCleanup(true)
	icon:setPosition(ccp(cell.LAY_PLAYER_ICON:getContentSize().width/2, cell.LAY_PLAYER_ICON:getContentSize().height/2))
	cell.LAY_PLAYER_ICON:addChild(icon)

	UIHelper.titleShadow( cell.BTN_GOLD_BET )
	UIHelper.titleShadow( cell.BTN_SILVER_BET )
end

function WABetView:showContiBet()
	local betInfo, betAtThis = WABetModel.getNowTabInfo()
	local function updateCellByIdex( lsv, idx )
		self:updateCellCommon( lsv,idx )
		local tbData = betInfo[idx+1]
		local cell = lsv:getItem(idx).item

		if (tbData.rank_type~=nil) then 					-- 是被押注的
			if (tonumber(tbData.bet_type)==1) then
				cell.TFD_BELLY_NUM:setText(tbData.bet_num)
			else
				cell.TFD_GOLD_NUM:setText(tbData.bet_num)
			end
			if (tonumber(tbData.rank)==0) then
				cell.TFD_RANK_NUM:setText("未上榜")			-- TODO
			else
				cell.TFD_RANK_NUM:setText(tbData.rank)
			end
			cell.TFD_BET_NUM:setText(tbData.beted_num)
		else												-- 不是被押注的
			if (tonumber(tbData.conti_rank)==0) then
				cell.TFD_RANK_NUM:setText("未上榜")			-- TODO
			else
				cell.TFD_RANK_NUM:setText(tbData.conti_rank)
			end
			cell.TFD_BET_NUM:setText(tbData.conti_beted_num)
		end
				
		cell.BTN_GOLD_BET:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				local tbArgs = {}
				tbArgs.serverId = tbData.server_id
				tbArgs.pid = tbData.pid
				tbArgs.rankType = "2"			-- '1'击杀排行/'2'连杀排行/'3'名次排行
				tbArgs.type = "2"				-- '1'银币押注/'2'金币押注
				tbArgs.num = 0
				local betTipIns = WABetTip:new()
				LayerManager.addLayout(betTipIns:create(tbArgs))
			end
		end)
		cell.BTN_SILVER_BET:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				local tbArgs = {}
				tbArgs.serverId = tbData.server_id
				tbArgs.pid = tbData.pid
				tbArgs.rankType = "2"			-- '1'击杀排行/'2'连杀排行/'3'名次排行
				tbArgs.type = "1"				-- '1'银币押注/'2'金币押注
				tbArgs.num = 0
				local betTipIns = WABetTip:new()
				LayerManager.addLayout(betTipIns:create(tbArgs))
			end
		end)
	end
	UIHelper.reloadListView(self.listView,#betInfo,updateCellByIdex)
end

function WABetView:showKillBet()
	local betInfo, betAtThis = WABetModel.getNowTabInfo()
	local function updateCellByIdex( lsv, idx )
		self:updateCellCommon( lsv,idx )
		local tbData = betInfo[idx+1]
		local cell = lsv:getItem(idx).item		

		if (tbData.rank_type~=nil) then 					-- 是被押注的
			if (tonumber(tbData.bet_type)==1) then
				cell.TFD_BELLY_NUM:setText(tbData.bet_num)
			else
				cell.TFD_GOLD_NUM:setText(tbData.bet_num)
			end
			if (tonumber(tbData.rank)==0) then
				cell.TFD_RANK_NUM:setText("未上榜")			-- TODO
			else
				cell.TFD_RANK_NUM:setText(tbData.rank)
			end
			cell.TFD_BET_NUM:setText(tbData.beted_num)
		else												-- 不是被押注的
			if (tonumber(tbData.kill_rank)==0) then
				cell.TFD_RANK_NUM:setText("未上榜")			-- TODO
			else
				cell.TFD_RANK_NUM:setText(tbData.kill_rank)
			end
			cell.TFD_BET_NUM:setText(tbData.kill_beted_num)
		end

		cell.BTN_GOLD_BET:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				local tbArgs = {}
				tbArgs.serverId = tbData.server_id
				tbArgs.pid = tbData.pid
				tbArgs.rankType = "1"			-- '1'击杀排行/'2'连杀排行/'3'名次排行
				tbArgs.type = "2"				-- '1'银币押注/'2'金币押注
				tbArgs.num = 0
				local betTipIns = WABetTip:new()
				LayerManager.addLayout(betTipIns:create(tbArgs))
			end
		end)
		cell.BTN_SILVER_BET:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				local tbArgs = {}
				tbArgs.serverId = tbData.server_id
				tbArgs.pid = tbData.pid
				tbArgs.rankType = "1"			-- '1'击杀排行/'2'连杀排行/'3'名次排行
				tbArgs.type = "1"				-- '1'银币押注/'2'金币押注
				tbArgs.num = 0
				local betTipIns = WABetTip:new()
				LayerManager.addLayout(betTipIns:create(tbArgs))
			end
		end)
	end
	UIHelper.reloadListView(self.listView,#betInfo,updateCellByIdex)
end

function WABetView:showPosBet()
	local betInfo, betAtThis = WABetModel.getNowTabInfo()
	local function updateCellByIdex( lsv, idx )
		self:updateCellCommon( lsv,idx )
		local tbData = betInfo[idx+1]
		local cell = lsv:getItem(idx).item	

		if (tbData.rank_type~=nil) then 					-- 是被押注的
			if (tonumber(tbData.bet_type)==1) then
				cell.TFD_BELLY_NUM:setText(tbData.bet_num)
			else
				cell.TFD_GOLD_NUM:setText(tbData.bet_num)
			end
			if (tonumber(tbData.rank)==0) then
				cell.TFD_RANK_NUM:setText("未上榜")			-- TODO
			else
				cell.TFD_RANK_NUM:setText(tbData.rank)
			end
			cell.TFD_BET_NUM:setText(tbData.beted_num)
		else												-- 不是被押注的
			if (tonumber(tbData.pos_rank)==0) then
				cell.TFD_RANK_NUM:setText("未上榜")			-- TODO
			else
				cell.TFD_RANK_NUM:setText(tbData.pos_rank)
			end
			cell.TFD_BET_NUM:setText(tbData.pos_beted_num)
		end		
			
		cell.BTN_GOLD_BET:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				local tbArgs = {}
				tbArgs.serverId = tbData.server_id
				tbArgs.pid = tbData.pid
				tbArgs.rankType = "3"			-- '1'击杀排行/'2'连杀排行/'3'名次排行
				tbArgs.type = "2"				-- '1'银币押注/'2'金币押注
				tbArgs.num = 0

				local betTipIns = WABetTip:new()
				LayerManager.addLayout(betTipIns:create(tbArgs))
			end
		end)
		cell.BTN_SILVER_BET:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				local tbArgs = {}
				tbArgs.serverId = tbData.server_id
				tbArgs.pid = tbData.pid
				tbArgs.rankType = "3"			-- '1'击杀排行/'2'连杀排行/'3'名次排行
				tbArgs.type = "1"				-- '1'银币押注/'2'金币押注
				tbArgs.num = 0
				local betTipIns = WABetTip:new()
				LayerManager.addLayout(betTipIns:create(tbArgs))
			end
		end)
	end
	UIHelper.reloadListView(self.listView,#betInfo,updateCellByIdex)
end

function WABetView:showBetView( ... )
	local tabNum = WABetModel.getTabNum()
	for i = 1, 3 do
		local btnTab = _fnGetWidget(self.layMain, "BTN_BET"..i)
		btnTab:setFocused(i == tonumber(tabNum))
		btnTab:setTouchEnabled(i ~= tonumber(tabNum))
		btnTab:setTag(i)
		btnTab:addTouchEventListener(WABetCtrl.getBtnFunByName("onChooseTab"))
	end

	self.listView:removeAllItems()
	if (tonumber(tabNum)==1) then
		self:showContiBet()
	elseif (tonumber(tabNum)==2) then
		self:showKillBet()
	elseif (tonumber(tabNum)==3) then
		self:showPosBet()
	end
	self.listView:jumpToPercentVertical(0)
	UIHelper.setSliding( self.listView )
end

function WABetView:setBtnEvent( ... )
	self.layMain.BTN_CLOSE:addTouchEventListener(WABetCtrl.getBtnFunByName("onClose"))
	self.layMain.BTN_CONFIRM:addTouchEventListener(WABetCtrl.getBtnFunByName("onConfirm"))	
end

function WABetView:init(...)
	self.layMain = nil
	_isBetOver = false
end

function WABetView:destroy(...)
	package.loaded["WABetView"] = nil
end

function WABetView:moduleName()
    return "WABetView"
end

function WABetView:ctor( ... )
	self:init()
	self.layMain = g_fnLoadUI("ui/bet_list.json")
end

function WABetView:create(...)
	self.listView = self.layMain.LSV_LIST
	self.listView.BTN_PLAYER_BG:setTouchEnabled(false)
	UIHelper.initListViewCell(self.listView)

	local configData = WorldArenaModel.getworldArenaConfig()
	local multipleNum = tonumber(configData.multiple_num)/10000
	self.layMain.tfd_activity_explain:setText("押注的玩家进入相应榜单的前3名，即可在发奖阶段获得押注金额的"..
		multipleNum..
		"倍返还。每个榜单只可押注1人！") --TODO

	local endBetTime = WABetModel.getEndBetTime()

	local nowTime = tonumber(TimeUtil.getSvrTimeByOffset())
	if (nowTime>=endBetTime) then
		self.layMain.tfd_desc:setText("押注已结束")
		self.layMain.TFD_TIME:setVisible(false)
		_isBetOver = true
		GlobalNotify.postNotify("WABetView_SET_BUTTON_FALSE")
	else
		self.layMain.tfd_desc:setText("押注结束倒计时：")
		self.layMain.TFD_TIME:setText(TimeUtil.getTimeDesByInterval(endBetTime-nowTime))
		self.layMain.LAY_COUNTDOWN:updateSizeAndPosition()
		_isBetOver = false
	end

	local scheduleAct = schedule(self.layMain,function ( ... )
		local nowTime = tonumber(TimeUtil.getSvrTimeByOffset())
		if (nowTime>=endBetTime) then
			self.layMain.tfd_desc:setText("押注已结束")
			self.layMain.TFD_TIME:setVisible(false)
			_isBetOver = true
			GlobalNotify.postNotify("WABetView_SET_BUTTON_FALSE")
			self.layMain:getActionManager():removeAction(scheduleAct)
		else
			self.layMain.tfd_desc:setText("押注结束倒计时：")
			self.layMain.TFD_TIME:setVisible(true)
			self.layMain.TFD_TIME:setText(TimeUtil.getTimeDesByInterval(endBetTime-nowTime))
			self.layMain.LAY_COUNTDOWN:updateSizeAndPosition()
			_isBetOver = false
		end
	end,1.0)

	UIHelper.titleShadow( self.layMain.BTN_CONFIRM )

	self:showBetView()
	self:setBtnEvent()

	UIHelper.registExitAndEnterCall(self.layMain,
		function()
			logger:debug("test_exit_BetView")
			GlobalNotify.removeObserver("WABetView_SET_BUTTON_FALSE", "WABETVIEW")
			self.layMain = nil
		end,
		function()
			logger:debug("test_enter_BetView")
			GlobalNotify.addObserver("WABetView_SET_BUTTON_FALSE", function ( ... )
				self:showBetView()
			end, true, "WABETVIEW")
		end
	)
	return self.layMain	
end
