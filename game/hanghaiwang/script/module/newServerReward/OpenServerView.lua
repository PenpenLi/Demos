-- FileName: OpenServerView.lua
-- Author: yucong
-- Date: 2015-08-11
-- Purpose: 开服7日主view
--[[TODO List]]

OpenServerView = class("OpenServerView")

require "script/module/public/GlobalNotify"
require "script/module/public/RewardUtil"
require "script/module/newServerReward/OpenServerModel"

-- 模块局部变量 --
local m_i18n	= gi18n
local m_fnGetWidget = g_fnGetWidgetByName
local _dModel	= OpenServerModel

local _mainLayer = nil
local _curBtnDay = nil
local _curBtnTab = nil
local _delegate = nil
local _nGainRid = 0
local _lsvOrignX = 0

function OpenServerView:notifications( ... )
	return {
		[_dModel.MSG.CB_GAIN_REWARD]	= function () self:fnMSG_GAIN_REWARD() end,
		[_dModel.MSG.CB_RELOAD]			= function () self:fnMSG_RELOAD() end,
		["PUSHCHARGEOK"]				= function () self:fnMSG_CHARGEOK() end,
		[_dModel.MSG.CB_BUY_OK]			= function (...) self:fnMSG_CB_BUY_OK(...) end,
		[_dModel.MSG.CB_BUY_FAILED]		= function () self:fnMSG_CB_BUY_FAILED() end,
	}
end

function OpenServerView:fnUpdate( ... )
	self:reload_Time()
end

function OpenServerView:reload_Time( ... )
	local data = _dModel.getDataByDay(_dModel.getDay())	-- 取当前选择的天数据
	local deadDays = tonumber(data.deadline) - 1	-- 活动结束天数
	local closeDays = tonumber(data.close_day) - 1	-- 活动关闭天数(领奖结束)
	-- local strDeadTime = TimeUtil.getTimeDesByInterval(deadInterval)
	-- local strCloseTime = TimeUtil.getTimeDesByInterval(closeInterval)
	local strDeadTime = _dModel.getCountdown(_dModel.getDeadDay(), true) --(deadDays)
	local strCloseTime = _dModel.getCountdown(_dModel.getCloseDay(), true) --(closeDays)
	_mainLayer.tfd_over_time:setText(strDeadTime)
	_mainLayer.tfd_reward_time:setText(strCloseTime)
end

function OpenServerView:ctor()
	_mainLayer = nil
	_curBtnDay = nil
	_curBtnTab = nil
	_delegate = nil
	_nGainRid = 0
end

function OpenServerView:create( ... )
	_mainLayer = g_fnLoadUI("ui/activity_seven_day.json")
	_mainLayer.img_main_bg:setScaleX(g_fScaleX) -- 背景图适配
	_mainLayer.img_main_bg:setScaleX(g_fScaleX)

	-- 注册onExit()
	local function onExit( ... )
		_curBtnDay = nil 
		_curBtnTab = nil
		_delegate = nil
		for msg, func in pairs(self:notifications()) do
			GlobalNotify.removeObserver(msg, msg.."OpenServerView")
		end
		GlobalScheduler.removeCallback("SCHEDULE_OPENSERVER")
	end
	local function onEnter( ... )
		-- 开启计时器
		GlobalScheduler.addCallback("SCHEDULE_OPENSERVER", function ( ... )
			self:fnUpdate()
		end)
	end
	UIHelper.registExitAndEnterCall(_mainLayer, onExit, onEnter)
	-- 初始化数据
	_dModel.setTab(1)
	_dModel.initDatas()
	-- 添加监听
    self:addObserver()
    -- 创建界面
    self:createFrame()
    -- 切换到那一天显示
    self:switchDay(_dModel.getCurDay())
    -- 检测时间
    _dModel.checkTime()

	return _mainLayer
end

function OpenServerView:addObserver( ... )
	for msg, func in pairs(self:notifications()) do
		GlobalNotify.addObserver(msg, func, false, msg.."OpenServerView")
	end
end

function OpenServerView:createFrame( ... )
	self:initLsv()
	for i = 1, 7 do
		local btn = g_fnGetWidgetByName(_mainLayer, "BTN_DAY_"..i)
		btn:setTag(i)
		--UIHelper.titleShadow(btn, m_i18n[5408]..i..m_i18n[1937])
		btn.tfd_desc:setText(m_i18n[5408])
		btn.tfd_day:setText(m_i18n[1937])
		btn:addTouchEventListener(function ( sender, eventType )
			self:onBtnDay(sender, eventType)
		end)
		btn.IMG_RED:addNode(UIHelper.createRedTipAnimination())
		btn.IMG_RED:setVisible(false)
		-- if (_dModel.getTipCountWithDay(i) > 0) then
			
		-- end
	end

	for i = 1, 4 do
		local btn = g_fnGetWidgetByName(_mainLayer, "BTN_TAB"..i)
		btn:setTag(i)
		btn:addTouchEventListener(function ( sender, eventType )
			self:onBtnTab(sender, eventType)
		end)
		btn.IMG_RED:addNode(UIHelper.createRedTipAnimination())
		btn.IMG_RED:setVisible(false)
		btn:setVisible(true)
	end

	_mainLayer.tfd_over:setText(m_i18n[6601])--"活动结束时间："
	_mainLayer.tfd_reward:setText(m_i18n[5742])--"领奖结束时间："
	--UIHelper.labelNewStroke(_mainLayer.tfd_over, ccc3(0x28, 0x00, 0x00), 2)
	UIHelper.labelNewStroke(_mainLayer.tfd_reward, ccc3(0x28, 0x00, 0x00), 2)
	--UIHelper.labelNewStroke(_mainLayer.tfd_over_time, ccc3(0x28, 0x00, 0x00), 2)
	UIHelper.labelNewStroke(_mainLayer.tfd_reward_time, ccc3(0x28, 0x00, 0x00), 2)

	_mainLayer.tfd_n_price:setText(m_i18n[4352])
	_mainLayer.tfd_b_price:setText(m_i18n[1470])
	_mainLayer.BTN_TAB4:setTitleText(m_i18n[6816])	-- 开服抢购
	_mainLayer.BTN_BUY:addTouchEventListener(function ( ... )
		self:onBtnBuy(...)
	end)
	_mainLayer.BTN_BUY:setTitleText(m_i18n[1319])
	UIHelper.titleShadow(_mainLayer.BTN_BUY)
	_mainLayer.img_buy_bg:setScale(g_fScaleX)
end

function OpenServerView:setDelegate( delegate )
	_delegate = delegate
end

function OpenServerView:initLsv( ... )
	local lsv = _mainLayer.LSV_CELL
	UIHelper.initListView(lsv)
	lsv:setBounceEnabled(true)
	lsv:setClippingEnabled(true)

	lsv = _mainLayer.LSV_BUY_CELL
	UIHelper.initListView(lsv)
	lsv:setBounceEnabled(true)
	lsv:setClippingEnabled(true)	
	_lsvOrignX = lsv:getPositionX()
end

function OpenServerView:onBtnDay( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local day = sender:getTag()
		local data = _dModel.getDataByDay(day)
		if (not data.tShop) then
			ShowNotice.showShellInfo(m_i18n[5743])--"活动未开启"
			return
		end
		self:switchDay(day)
		-- require "script/consoleExe/ConsolePirate"
		-- ConsolePirate.create(_mainLayer)
	end
end

function OpenServerView:onBtnTab( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playTabEffect()
		self:switchTab(sender:getTag())
	end
end

-- 切换day
function OpenServerView:switchDay( day )
	logger:debug("day:"..day)
	if (_dModel.getCurDay() < day) then
		ShowNotice.showShellInfo(m_i18n[5743])--"活动未开启"
		return
	end
	day = math.min(day, 7)
	if (_curBtnDay) then
		_curBtnDay:setFocused(false)
		_curBtnDay:setTouchEnabled(true)
		_curBtnDay = nil
	end
	_curBtnDay = g_fnGetWidgetByName(_mainLayer, "BTN_DAY_"..day)
	_curBtnDay:setFocused(true)
	_curBtnDay:setTouchEnabled(false)

	-- 设置选中的天
	_dModel.setDay(day)
	-- 重置tab
	self:reload_Tab()
	-- 选中默认tab
	self:switchTab(1)
	-- 重置倒计时
	self:reload_Time()
	-- 重置红点
	self:reload_Tips()
end

-- 切换tab
function OpenServerView:switchTab( tab )
	if (_curBtnTab) then
		local label = _dModel.getBtnLabel(_curBtnTab)
		label:setColor(ccc3(0xbf, 0x93, 0x67))
		_curBtnTab:setFocused(false)
		_curBtnTab:setTouchEnabled(true)
		_curBtnTab = nil
	end
	_curBtnTab = g_fnGetWidgetByName(_mainLayer, "BTN_TAB"..tab)
	local label = _dModel.getBtnLabel(_curBtnTab)
	label:setColor(ccc3(0xff, 0xff, 0xff))
	_curBtnTab:setFocused(true)
	_curBtnTab:setTouchEnabled(false)

	-- 设置选中的tab
	_dModel.setTab(tab)
	if (tab < 4) then
		-- 处理该tab中的数据
		_dModel.handleDatas()
		-- 刷新listview
		self:reload_lsv()
		-- 隐藏新tab
		_mainLayer.img_buy:setVisible(false)
		_mainLayer.img_buy:setEnabled(false)
		_mainLayer.img_bg:setVisible(true)
		_mainLayer.img_bg:setEnabled(true)
	else
		self:reload_lsv_buy()
		self:reload_buy()
		-- 隐藏新tab
		_mainLayer.img_buy:setVisible(true)
		_mainLayer.img_buy:setEnabled(true)
		_mainLayer.img_bg:setVisible(false)
		_mainLayer.img_bg:setEnabled(false)
	end
end

-- 领取回调
function OpenServerView:onBtnGain( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		_nGainRid = sender:getTag()
		if (_dModel.isClosed()) then
			AudioHelper.playCommonEffect()
			ShowNotice.showShellInfo(m_i18n[5744])--"活动已结束，无法领取奖励。"
			return
		end
		AudioHelper.playTansuo02()
		-- 取当前选择的天数据
		local data = _dModel.getDataByDay(_dModel.getDay())
		-- 取当前天下面的页签数据
		local tabInfo = data.tTabs[_dModel.getTab()]

		for k, info in pairs(tabInfo.achiveInfo) do
			if (tonumber(info.id) == _nGainRid) then
				-- 创建奖励界面
				local tItem = RewardUtil.getItemsDataByStr(info.reward)
				for k1, rInfo in pairs(tItem) do
					 if (tonumber(rInfo.tid) ~= 0 and ItemUtil.bagIsFullWithTid(rInfo.tid, true)) then
					 	return
					 end
				end
				break
			end
		end
		_delegate.gainReward(_nGainRid)
	end
end

-- 前往回调
function OpenServerView:onBtnGo( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local rid = sender:getTag()
		-- 跳转类型
		local goType = _dModel.getTurnWithRid(rid)
		if (goType ~= 0) then
			_dModel.changeModule(goType)
		else
			_dModel.changeModuleWithTypeid(_dModel.getTypeIdWithRid(rid))
		end
	end
end

function OpenServerView:onBtnBuy( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("onBtnBuy:"..sender:getTag().."day")
		local day = sender:getTag()
		local data = _dModel.getDataByDay(day)
		if (UserModel.getGoldNumber() < tonumber(data.now_price)) then
			AudioHelper.playCommonEffect()
			-- 金币不足
			-- PublicInfoCtrl.createItemDropInfoViewByTid(60316,nil,true)  -- 贝里掉落界面
			--LayerManager.addLayout(IAPCtrl.create())
			LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
            --ShowNotice.showShellInfo(m_i18n[1342])
			return
		end
		-- 取当前选择的天数据
		local data = _dModel.getDataByDay(_dModel.getDay())

		-- 创建奖励界面
		local tItem = RewardUtil.getItemsDataByStr(data.goods)
		for k, rInfo in pairs(tItem) do
			 if (tonumber(rInfo.tid) ~= 0 and ItemUtil.bagIsFullWithTid(rInfo.tid, true)) then
			 	AudioHelper.playCommonEffect()
			 	return
			 end
		end

		AudioHelper.playBuyGoods()
		_delegate.buy(sender:getTag())
		--self:fnMSG_CB_BUY_OK()
	end
end

function OpenServerView:reload( ... )
	logger:debug("OpenServerView reload")
	_dModel.initDatas()
	-- 刷新tab显示
	self:reload_Tab()
	-- 刷新红点
	self:reload_Tips()
	if (_dModel.getTab() < 4) then
		-- 刷新listview
		self:reload_lsv()
	else
		self:reload_lsv_buy()

		self:reload_buy()
	end
end

function OpenServerView:reload_Tips( ... )
	for i = 1, 7 do
		local btn = g_fnGetWidgetByName(_mainLayer, "BTN_DAY_"..i)
		if (_dModel.getTipCountWithDay(i) > 0) then
			btn.IMG_RED:setVisible(true)
		else
			btn.IMG_RED:setVisible(false)
		end
	end

	-- 取当前选择的天数据
	local data = _dModel.getDataByDay(_dModel.getDay())

	for i = 1, 4 do
		local btn = g_fnGetWidgetByName(_mainLayer, "BTN_TAB"..i)
		if (data.tTips[i] > 0) then
			btn.IMG_RED:setVisible(true)
		else
			btn.IMG_RED:setVisible(false)
		end
	end
end

-- 刷新tab显示
function OpenServerView:reload_Tab( ... )
	local data = _dModel.getDataByDay(_dModel.getDay()) 
	for i = 1, 3 do
		local btn = g_fnGetWidgetByName(_mainLayer, "BTN_TAB"..i)
		--UIHelper.titleShadow(btn, data.tTabs[i].name)
		local label = _dModel.getBtnLabel(btn)
		label:setString(data.tTabs[i].name)
	end
end

-- 刷新listview
function OpenServerView:reload_lsv( ... )
	_mainLayer.LSV_CELL:removeAllItems()

	-- 取当前选择的天数据
	local data = _dModel.getDataByDay(_dModel.getDay())
	-- 取当前天下面的页签数据
	local tabInfo = data.tTabs[_dModel.getTab()]
	--logger:debug({tabInfo = tabInfo})
	-- 遍历页签包含的成就组
	local index = 0
	for k, info in pairs(tabInfo.achiveInfo) do
		logger:debug(info)
		local rid = tonumber(info.id)
		_mainLayer.LSV_CELL:pushBackDefaultItem()
		local cell = _mainLayer.LSV_CELL:getItem(index)
		cell:setSize(CCSizeMake(cell:getSize().width * g_fScaleX, cell:getSize().height * g_fScaleX))
		cell.IMG_CELL:setScaleX(g_fScaleX)
		cell.IMG_CELL:setScaleY(g_fScaleX)
		-- 描述
		cell.tfd_name:setText(info.desc)
		-- 奖励图标
		local iconInfo = RewardUtil.parseRewards(info.reward)
		UIHelper.initListView(cell.LSV_FORTBV)
		cell.LSV_FORTBV:removeAllItems()
		for k1,v in pairs(iconInfo) do
			cell.LSV_FORTBV:pushBackDefaultItem()
			local rcell = cell.LSV_FORTBV:getItem(tonumber(k1) - 1)
			rcell.IMG_GOODS:addChild(v.icon)
			rcell.TFD_GOODS_NAME:setText(v.name)
		end

		-- 进度
		cell.TFD_PROGRESS:setText("（"..info.finishnum.."/"..info.maxnum.."）")

		-- 领取按钮
		cell.BTN_GET_REWARD:setTag(rid)
		UIHelper.titleShadow(cell.BTN_GET_REWARD, m_i18n[2628])	-- "领取"	
		cell.BTN_GET_REWARD:addTouchEventListener(function ( sender, eventType )
			self:onBtnGain(sender, eventType)
		end)
		cell.BTN_GET_REWARD:setVisible(false)
		cell.BTN_GET_REWARD:setTouchEnabled(false)
		-- 前往按钮
		cell.BTN_GO:setTag(rid)
		--UIHelper.titleShadow(cell.BTN_GO, m_i18n[4388])	-- "前往"
		cell.BTN_GO:addTouchEventListener(function ( sender, eventType )
			self:onBtnGo(sender, eventType)
		end)
		cell.BTN_GO:setVisible(false)
		cell.BTN_GO:setTouchEnabled(false)
		cell.IMG_RECIEVED:setVisible(false)

		-- 未完成
		if (info.status == 0) then
			--if (tonumber(info.turn) ~= 0) then 	-- 配置了跳转的才显示跳转按钮
				cell.BTN_GO:setVisible(true)
				cell.BTN_GO:setTouchEnabled(true)
			-- else
			-- 	cell.BTN_GET_REWARD:setVisible(true)
			-- 	cell.BTN_GET_REWARD:setGray(true)
			-- end
		-- 已完成
		elseif (info.status == 1) then
			cell.BTN_GET_REWARD:setVisible(true)
			cell.BTN_GET_REWARD:setTouchEnabled(true)
		-- 已领奖
		elseif (info.status == 2) then
			cell.IMG_RECIEVED:setVisible(true)
		end

		index = index + 1
	end
end

function OpenServerView:reload_lsv_buy( ... )
	_mainLayer.LSV_BUY_CELL:removeAllItems()
	-- 取当前选择的天数据
	local data = _dModel.getDataByDay(_dModel.getDay())
	local rewards = RewardUtil.parseRewards(data.goods)
	for k, reward in pairs(rewards) do
		_mainLayer.LSV_BUY_CELL:pushBackDefaultItem()
		local cell = _mainLayer.LSV_BUY_CELL:getItem(k - 1)
		cell.IMG_ICON:addChild(reward.icon)
		cell.TFD_BUY_NAME:setText(reward.name)
		cell.TFD_BUY_NAME:setColor(g_QulityColor[reward.quality])
	end
	-- local cell = _mainLayer.LSV_BUY_CELL:getItem(0)
	-- local cellSize = cell.lay_buy_bg:getSize()
	-- local lsvSize = _mainLayer.LSV_BUY_CELL:getViewSize()
	-- local cellNum = math.floor(lsvSize.width / cellSize.width)
	-- logger:debug("lsvSize:"..lsvSize.width.." cellSize:"..cellSize.width.." cellNum:"..cellNum)
	-- if (#rewards <= cellNum) then
	-- 	_mainLayer.LSV_BUY_CELL:setBounceEnabled(false)
	-- 	_mainLayer.LSV_BUY_CELL:setClippingEnabled(false)
	-- 	_mainLayer.LSV_BUY_CELL:setPositionX(_lsvOrignX + (cellNum - #rewards) * cellSize.width / 2)
	-- else
	-- 	_mainLayer.LSV_BUY_CELL:setBounceEnabled(true)
	-- 	_mainLayer.LSV_BUY_CELL:setClippingEnabled(true)
	-- 	_mainLayer.LSV_BUY_CELL:setPositionX(_lsvOrignX)
	-- end
	UIHelper.setSliding(_mainLayer.LSV_BUY_CELL, true)
	-- _mainLayer.LSV_BUY_CELL:setJumpOffset(ccp(300, 0))
end

function OpenServerView:reload_buy( ... )
	local data = _dModel.getDataByDay(_dModel.getDay())
	_mainLayer.TFD_N_NUM:setText(data.now_price)
	_mainLayer.TFD_B_NUM:setText(data.before_price)
	_mainLayer.tfd_people_num:setText(gi18nString(6817, data.limited_num, data.tShop.remainNum))--(string.format("仅限前%d人购买(剩余%d件)", data.limited_num, data.tShop.remainNum))
	-- 按钮
	_mainLayer.img_sold_out:setVisible(false)
	_mainLayer.img_already_buy:setVisible(false)
	_mainLayer.BTN_BUY:setTag(_dModel.getDay())
	_mainLayer.BTN_BUY:setTouchEnabled(false)
	_mainLayer.BTN_BUY:setVisible(false)
	if (data.tShop.remainNum <= 0) then 	-- 已售罄
		_mainLayer.img_sold_out:setVisible(true)
		-- _mainLayer.BTN_BUY:setTouchEnabled(true)
		-- _mainLayer.BTN_BUY:setVisible(true)
	elseif (data.tShop.buyFlag == 1) then	-- 已购买
		_mainLayer.img_already_buy:setVisible(true)
	elseif (data.tShop.buyFlag == 0) then	-- 未购买
		_mainLayer.BTN_BUY:setTouchEnabled(true)
		_mainLayer.BTN_BUY:setVisible(true)
	end
	local discount = tonumber(data.now_price) / tonumber(data.before_price) * 10
	_mainLayer.TFD_TIMES_NUM:setText(string.format("%.1f", discount))
end

--------------------- notifications ---------------------
-- 领奖成功后
function OpenServerView:fnMSG_GAIN_REWARD( ... )
	logger:debug("fnMSG_GAIN_REWARD")
	if (_nGainRid ~= 0) then
		-- 刷新状态
		_dModel.itemCompleteWithRid(_nGainRid)
		_dModel.sortDatas()
		self:reload_Tips()
		self:reload_lsv()

		-- 取当前选择的天数据
		local data = _dModel.getDataByDay(_dModel.getDay())
		-- 取当前天下面的页签数据
		local tabInfo = data.tTabs[_dModel.getTab()]

		for k, info in pairs(tabInfo.achiveInfo) do
			if (tonumber(info.id) == _nGainRid) then
				-- 创建奖励界面
				local tItem = RewardUtil.parseRewards(info.reward, true)
				LayerManager.addLayoutNoScale(UIHelper.createRewardDlg(tItem))
				break
			end
		end
		_nGainRid = 0
	end
end

-- 刷新所有
function OpenServerView:fnMSG_RELOAD( ... )
	self:reload()
end

-- 充值成功
function OpenServerView:fnMSG_CHARGEOK( ... )
	_delegate.getInfo(UserModel.getFightForceValue())
end

-- 购买成功
function OpenServerView:fnMSG_CB_BUY_OK( dutyId )
	self:reload()
	-- 取当前选择的天数据
	local data = _dModel.getDataByDay(_dModel.getDay())
	UserModel.addGoldNumber(-tonumber(data.now_price))

	-- 创建奖励界面
	local tItem = RewardUtil.parseRewards(data.goods, true)
	LayerManager.addLayoutNoScale(UIHelper.createRewardDlg(tItem))
end

function OpenServerView:fnMSG_CB_BUY_FAILED( ... )
	self:reload()
end