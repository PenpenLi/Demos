-- FileName: RouletteView.lua
-- Author: lvnanchun
-- Date: 2015-08-17
-- Purpose: 幸运转盘界面
--[[TODO List]]

RouletteView = class("RouletteView")
require "script/module/wonderfulActivity/roulette/RouletteModel"

-- UI variable --
local _layMain
local _btnStart
local _cellBg
-- 正在亮着的cell，用于在下一个cell亮的时候关闭
local _preCell

-- module local variable --
local _curTime
local _totalCoins
local _i18n = gi18n
local _fnGetWidget = g_fnGetWidgetByName
local _totalTimes


function RouletteView:moduleName()
    return "RouletteView"
end

function RouletteView:ctor(...)
	_layMain = g_fnLoadUI("ui/activity_roulette.json")
end

--[[desc:获取奖励并现实奖励窗口
    arg1: 奖励id
    return: 无
—]]
function RouletteView:getRewardAndShow( nReward )
	local tbReward , nCost = RouletteModel.getRewardByTime(_curTime)
	logger:debug({tbReward_nReward = tbReward[nReward]})
	local nCoinGet = tonumber(tbReward[nReward][1])
	_totalCoins = _totalCoins + nCoinGet
	UserModel.addGoldNumber( nCoinGet - nCost )
	LayerManager.addLayout(UIHelper.createGetRewardInfoDlg(_i18n[3739],{{icon = ItemUtil.getGoldIconByNum(nCoinGet), name = _i18n[2220], quality = 5}},function ( )
		self:refreshView()
		if (_curTime <= _totalTimes) then	
			self:setRouletteText()
		end
		LayerManager.removeLayout()
	end))
end

--[[desc:设置转盘上的信息
    arg1: 无
    return: 无 
—]]
function RouletteView:setRouletteText()
	local tbReward , nCost = RouletteModel.getRewardByTime(_curTime)
	logger:debug({tbReward = tbReward})
	
	_layMain.tfd_cost_gold:setText(tonumber(nCost))
	UIHelper.labelNewStroke(_layMain.tfd_cost_gold , ccc3(0x28, 0x00, 0x00))
	
	_layMain.tfd_high_gold:setText(tbReward[7][1])
	UIHelper.labelNewStroke(_layMain.tfd_high_gold , ccc3(0x28, 0x00, 0x00))

	for i=1,7 do 
		local cell = _fnGetWidget( _cellBg , "img_icon_bg_" .. tostring(i) )
		local tfdNum = _fnGetWidget( cell , "tfd_num_" .. tostring(i) )
		tfdNum:setText(tbReward[i][1])
		if (i == 1 or i == 2) then
			UIHelper.labelNewStroke(tfdNum , ccc3(0x00, 0x3c, 0x48) , 3)
		elseif (i == 3 or i == 4) then
			UIHelper.labelNewStroke(tfdNum , ccc3(0x5f, 0x00, 0x60) , 3)
		elseif (i == 5 or i == 6) then
			UIHelper.labelNewStroke(tfdNum , ccc3(0x67, 0x2e, 0x00) , 3)
		elseif (i == 7) then
			UIHelper.labelNewStroke(tfdNum , ccc3(0xb6, 0x1b, 0x00) , 3)
		end
	end
end

--[[desc:点击领取时刷新已得奖励和剩余次数和当前拥有金币数量
    arg1: 无
    return: 无
—]]
function RouletteView:refreshView(  )	
	_layMain.tfd_get_gold:setText(tostring(_totalCoins))
	UIHelper.labelNewStroke(_layMain.tfd_get_gold , ccc3(0x28, 0x00, 0x00))
	logger:debug({_curTime = _curTime})
	_layMain.tfd_remaining_num:setText(tostring(_totalTimes + 1 - _curTime))
	UIHelper.labelNewStroke(_layMain.tfd_remaining_num , ccc3(0x28, 0x00, 0x00))

	_layMain.tfd_own_gold:setText(tostring(UserModel.getGoldNumber()))
end

--[[desc:计时器回调，刷新时间并设置活动结束
    arg1: 无
    return: 无  
—]]
function RouletteView:refreshTimer()
	local remainTimeStr , bOver = RouletteModel.getRemainTime()

	logger:debug({remainTimeStr = remainTimeStr , bOver = bOver})
	
	_layMain.tfd_time_num:setText( remainTimeStr )
	UIHelper.labelNewStroke(_layMain.tfd_time_num , ccc3(0x28, 0x00, 0x00))
	if (bOver) then
		GlobalScheduler.removeCallback("rouletteTimer")
		_btnStart:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				ShowNotice.showShellInfo(_i18n[6501])   
			end
		end)
	end
end

function RouletteView:create( severData )
	_totalTimes = RouletteModel.getMaxNum()
	local imgBg = _layMain.img_main_bg
	imgBg:setScaleX(g_fScaleX)
	imgBg:setScaleY(g_fScaleY)

	_layMain.tfd_time:setText(_i18n[4351])
	UIHelper.labelNewStroke(_layMain.tfd_time , ccc3(0x28, 0x00, 0x00))
	local remainTimeStr , bOver = RouletteModel.getRemainTime()
	_layMain.tfd_time_num:setText( remainTimeStr )
	UIHelper.labelNewStroke(_layMain.tfd_time_num , ccc3(0x28, 0x00, 0x00))
	_layMain.tfd_remaining:setText(_i18n[4907])
	UIHelper.labelNewStroke(_layMain.tfd_remaining , ccc3(0x28, 0x00, 0x00))
	_layMain.tfd_get:setText(_i18n[6811])
	UIHelper.labelNewStroke(_layMain.tfd_get , ccc3(0x28, 0x00, 0x00))
	_layMain.tfd_cost:setText(_i18n[6812])
	UIHelper.labelNewStroke(_layMain.tfd_cost , ccc3(0x28, 0x00, 0x00))
	_layMain.tfd_high:setText(_i18n[6813])
	UIHelper.labelNewStroke(_layMain.tfd_high , ccc3(0x28, 0x00, 0x00))

	-- 显示玩家当前拥有的金币数量
	_layMain.tfd_own:setText(_i18n[1321])
	UIHelper.labelNewStroke(_layMain.tfd_own, ccc3(0x28, 0x00, 0x00))
	_layMain.tfd_own_gold:setText(tostring(UserModel.getGoldNumber()))
	UIHelper.labelNewStroke(_layMain.tfd_own_gold, ccc3(0x28, 0x00, 0x00))

	_cellBg = _layMain.img_bg

	for i=2,7 do
		_fnGetWidget( _cellBg , "img_high_" .. tostring(i) ):setVisible(false)
	end
	_cellBg.img_high_1:setVisible(true)
	_preCell = _cellBg.img_high_1

	logger:debug({severData = severData})
	RouletteModel.setActivityInfo( severData )

	_totalCoins = tonumber(severData.sum_gold)
	_curTime = tonumber(severData.round_times) + 1
	self:refreshView()
	self:setRouletteText()

	_btnStart = _layMain.BTN_START

	local function onBtnStartCallBack( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			local function startCallBack( cbFlag, dictData, bRet )
				if (bRet) then
					if (_curTime <= _totalTimes) then
						local nRewardGet = tonumber(dictData.ret) + 1
						local flashArray = CCArray:create()
						local actionArray = CCArray:create()

						local layout = Layout:create()
						layout:setName("layForShield")
						LayerManager.addLayout(layout)

						local randomTable = {1,2,3,4,5,6,7}
						local preNum = 0
						for i=1,7 do
							flashArray:addObject(CCDelayTime:create(1/14))
							flashArray:addObject(CCCallFuncN:create(function ( ... )
								AudioHelper.playSpecialEffect("texiao_luckyboard.mp3")
								math.randomseed(tostring(os.time()):reverse():sub(1,6))
								local nCell = math.random(8-i)
								_preCell:setVisible(false)
								_preCell = _fnGetWidget( _cellBg , "img_high_" .. tostring((randomTable[nCell] % 7) + 1) )
								_preCell:setVisible(true)
								if (i == 7) then
									preNum = randomTable[nCell]
								end
								table.remove(randomTable, nCell)
							end))
						end

						local randomTable = {1,2,3,4,5,6}
						for i=1,6 do
							flashArray:addObject(CCDelayTime:create(1/7))
							flashArray:addObject(CCCallFuncN:create(function ( ... )
								AudioHelper.playSpecialEffect("texiao_luckyboard.mp3")
								math.randomseed(tostring(os.time()):reverse():sub(1,6))
								local nCell = math.random(7-i)
								if (i == 1) then
									if (randomTable[nCell] == preNum) then
										if (nCell == 1) then
											nCell = 2
										else
											nCell = nCell - 1
										end
									end
								end
								_preCell:setVisible(false)
								_preCell = _fnGetWidget( _cellBg , "img_high_" .. tostring((randomTable[nCell] % 7) + 1) )
								_preCell:setVisible(true)
								table.remove(randomTable, nCell)
							end))
						end


						for i=0,nRewardGet-1 do
							flashArray:addObject(CCDelayTime:create(1/(8-i)))
							flashArray:addObject(CCCallFuncN:create(function ( ... )
								AudioHelper.playSpecialEffect("texiao_luckyboard.mp3")
								math.randomseed(tostring(os.time()):reverse():sub(1,6))
								_preCell:setVisible(false)
								_preCell = _fnGetWidget( _cellBg , "img_high_" .. tostring((i % 7) + 1) )
								_preCell:setVisible(true)
							end))
						end

						flashArray:addObject(CCDelayTime:create(1/2))

						flashArray:addObject(CCCallFuncN:create(function ( ... )
							LayerManager.removeLayout()
							self:getRewardAndShow( nRewardGet )
							RouletteModel.changeRoundTime(1)
							_curTime = _curTime + 1
--							if (_curTime <= 6) then	
--								self:setRouletteText()
--							end
--							self:refreshView()
							if not (RouletteModel.bShowRedPoint()) then
								local mainActivity = WonderfulActModel.tbBtnActList.roulette
								mainActivity.IMG_TIP:setEnabled(false)
							end
						end))

						local actionSeq = CCSequence:create(flashArray)
						_layMain:runAction(actionSeq)
					end
				end
			end
			if (RouletteModel.bShowRedPoint() and _curTime <= _totalTimes and RouletteModel.bActivityOpen()) then
				RequestCenter.roulette_useTurntable(startCallBack)
			elseif ( _curTime <= _totalTimes and RouletteModel.bActivityOpen()) then
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
			elseif (RouletteModel.bActivityOpen()) then
				if (RouletteModel.getDbSourceType() == 2 and RouletteModel.getVipLevelMaxNum() ~= UserModel.getVipLevel() and RouletteModel.getNextVipLevel() ~= 0) then
					ShowNotice.showShellInfo(gi18nString(7701, RouletteModel.getNextVipLevel()))     
				else
					ShowNotice.showShellInfo(_i18n[6814])
				end
			end
		end
	end

	_btnStart:addTouchEventListener(onBtnStartCallBack)
	UIHelper.titleShadow(_btnStart)

	UIHelper.registExitAndEnterCall(_layMain, function ( )		
		GlobalScheduler.removeCallback("rouletteTimer")
		if (_curTime == _totalTimes + 1) or (not RouletteModel.bActivityOpen()) then
			local listCell , iconBtn
			listCell , iconBtn = RouletteModel.getIcon()
			if (_curTime == _totalTimes + 1) then
				if (RouletteModel.getDbSourceType() == 2 and RouletteModel.getVipLevelMaxNum() ~= UserModel.getVipLevel()) then
					-- 平台拉取的配置以及不是最大vip等级
					-- do nothong
				else
					-- 本地拉取的数据或者是最大的vip等级
					iconBtn:addTouchEventListener(function ( sender, eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							ShowNotice.showShellInfo(_i18n[6814])
						end
					end)
				end
			else
				iconBtn:addTouchEventListener(function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						ShowNotice.showShellInfo(_i18n[6501])
					end
				end)
			end
			local mainActivity = WonderfulActModel.tbBtnActList.roulette
			mainActivity.IMG_TIP:setEnabled(false)
		end
    end , function ( )
    	GlobalScheduler.addCallback("rouletteTimer" , function ( ... )
    		self:refreshTimer()
    	end)
    	logger:debug({getNewAniState = RouletteModel.getNewAniState()})
    	if (RouletteModel.getNewAniState() ~= 1) then
   			RouletteModel.setNewAniState(1)
		end

		local listCell = RouletteModel.getIcon()
   		if (UIHelper.isGood(listCell)) then
   			if (listCell:getNodeByTag(100)) then
				listCell:getNodeByTag(100):removeFromParentAndCleanup(true)
			end
		end
		-- 刷新红点
		if not (RouletteModel.bShowRedPoint()) then
			local mainActivity = WonderfulActModel.tbBtnActList.roulette
			mainActivity.IMG_TIP:setEnabled(false)
		else
			local mainActivity = WonderfulActModel.tbBtnActList.roulette
			mainActivity.IMG_TIP:setEnabled(true)
		end
    end)

	return _layMain
end

