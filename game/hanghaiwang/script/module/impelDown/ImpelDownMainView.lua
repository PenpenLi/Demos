-- FileName: ImpelDownMainView.lua
-- Author: Xufei
-- Date: 2015-09-09
-- Purpose: 深海监狱主界面 UI
--[[TODO List]]

ImpelDownMainView = class("ImpelDownMainView")

-- UI控件引用变量 --
local _layMain

-- 模块局部变量 --
local _i18n = gi18n
local _i18nString = gi18nString
local _tbBtnEvent
local _fnGetWidget = g_fnGetWidgetByName
local HERO_HEAD_PATH = "images/base/hero/head_icon/"
local HERO_BODY_PATH = "images/base/hero/body_img/"
local HERO_HEAD_FRAME_PATH = "images/copy/ncopy/fortpotential/"
local ANIMATION_PATH = "images/effect/"
local IMPEL_BG_PATH = "images/impel/bg/"
local IMPEL_ANI_PATH = "images/effect/impel/prison/"

local TAG_OPENBOXANI = 547915

local doShowDownEffectTag = 0
local doShowFlipDownEffectTag = 0

local prisonNameNoticeTag = 18457
local difficultyNoticeTag = 18458

-- 国际化和描边效果
function ImpelDownMainView:setI18nAndEffect( ... )

	UIHelper.labelNewStroke( _layMain.TFD_BOX_DESC, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( _layMain.TFD_BELLY_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( _layMain.TFD_PRISON_NUM, ccc3(0x28,0x00,0x00), 2 )

	_layMain.TFD_BOX_DESC:setText(_i18n[7015])

	UIHelper.labelNewStroke( _layMain.TFD_RESET_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( _layMain.TFD_FINISH_GOLD, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( _layMain.TFD_SWEEP_TIME, ccc3(0x28,0x00,0x00), 2 )

	for i=1,3 do
		local layPlace = _fnGetWidget(_layMain, "lay_place_" .. i)
		UIHelper.labelNewStroke( layPlace.TFD_HERO_LAYER, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke( layPlace.TFD_HERO_NAME, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke( layPlace.TFD_STRONGHOLD_LAYER, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke( layPlace.TFD_STRONGHOLD_NAME, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke( layPlace.TFD_BOX_LAYER, ccc3(0x28,0x00,0x00), 2 )
	end

	UIHelper.titleShadow(_layMain.BTN_BACK, _i18n[1019])
	UIHelper.titleShadow(_layMain.BTN_RESET) --此处国际化在后面showResetButton中
	UIHelper.titleShadow(_layMain.BTN_FINISH, _i18n[7008])

end

-- 购买挑战次数
function ImpelDownMainView:buyFightTimes( monsterInfo )
	local haveBoughtTimes = ImpelDownMainModel.getBuyChanceTimes() + ImpelDownMainModel.getFreeLoseTimes() + 1
	local boughtCost = tonumber(ImpelDownMainModel.getBuyChanceCostByLoseTimes(haveBoughtTimes))
	local strText = _i18nString(7017, boughtCost)
	local function dlgCallback( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			local function buyDefeatNumCallback( cbFlag, dictData, bRet )
				if (bRet) then
					if (dictData.ret == "ok") then
						ImpelDownMainModel.updateDataWhenBuyFightTimes()
						UserModel.addGoldNumber(-boughtCost)
						LayerManager.removeLayout()
						self:initRemainChanceRedPoint()
					end
				end
			end
			if (UserModel.getGoldNumber()>=boughtCost) then
				AudioHelper.playBuyGoods()
				local tbRpcArgs = {tonumber(boughtCost)}
				RequestCenter.impelDown_buyDefeatNum(buyDefeatNumCallback, Network.argsHandlerOfTable(tbRpcArgs))
			else
				AudioHelper.playCommonEffect()
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
			end 
		end
	end

	local layDlg = UIHelper.createCommonDlg(strText,nil,dlgCallback)
	LayerManager.addLayout(layDlg)
end

-- 自动停止扫荡并领奖
function ImpelDownMainView:autoStopSweep( ... )
	local nowLayerId = ImpelDownMainModel.getLayerSweepEndBy()
	local startLayer = ImpelDownMainModel.getLayerSweepStartOn()
	GlobalScheduler.removeCallback("UPDATE_IMPEL_SWEEP_COUNTDOWN")
	ImpelDownMainModel.updateDataWhenStopSweepAuto()
	doShowDownEffectTag = 0
	doShowFlipDownEffectTag = 0
	self:initView()
	self:initSweepRewardView(startLayer, nowLayerId)
end

-- 手动停止扫荡并领奖
function ImpelDownMainView:manualStopSweep( ... )
	local nowLayerId
	local startLayer = ImpelDownMainModel.getLayerSweepStartOn()

	if (startLayer<ImpelDownMainModel.getTotalNumOfLayer()) then
		GlobalScheduler.removeCallback("UPDATE_IMPEL_SWEEP_COUNTDOWN")
		local function endSweepCallback( cbFlag, dictData, bRet )
			if (bRet) then
				logger:debug({looknowlayer = dictData.ret })
				nowLayerId = tonumber( dictData.ret )
				logger:debug({nowLayerId = nowLayerId})
				logger:debug({startLayer = startLayer})
				if (nowLayerId < startLayer) then
					ShowNotice.showShellInfo(_i18n[7018])
					ImpelDownMainModel.updateDataWhenSweepNotEnoughTime()
					doShowDownEffectTag = 0
					doShowFlipDownEffectTag = 0
					self:initView()
				else
					ImpelDownMainModel.updateDataWhenStopSweep(nowLayerId)
					doShowDownEffectTag = 0
					doShowFlipDownEffectTag = 0
					self:initView()
					self:initSweepRewardView(startLayer, nowLayerId)
				end

			end
		end
		--endSweepCallback(nil, {ret = "ok"}, 1)---
		local tbRpcArgs = {tonumber(nowLayerId)}
		RequestCenter.impelDown_endSweep(endSweepCallback, Network.argsHandlerOfTable(tbRpcArgs))
	end
end

-- 扫荡结算面板
function ImpelDownMainView:initSweepRewardView(startLayer, nowLayerId)
	require "script/module/impelDown/ImpelDownSweepReward"
	local instanceImpelDownSweepRewardView = ImpelDownSweepReward:new()
	local sweepRewardView = instanceImpelDownSweepRewardView:create(startLayer, nowLayerId)
	LayerManager.addLayoutNoScale(sweepRewardView)
end

-- 开始扫荡
function ImpelDownMainView:startSweep( ... )
	local maxLayer = ImpelDownMainModel.getTopGrade()
	local layerName = ImpelDownMainModel.getEndSweepLayerName(maxLayer)
	local strText = _i18nString(7019, layerName) ---需要改i18n
	local layDlg = UIHelper.createCommonDlg(strText,nil,function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			local function starSweepCallback( cbFlag, dictData, bRet )
				if (bRet) then
					LayerManager.removeLayout()
					ImpelDownMainModel.updateDataWhenStartSweep(dictData.ret)
					
					local nowTowerLayerId = ImpelDownMainModel.getNowTowerLayerId()
					local endSweepLayerId = ImpelDownMainModel.getLayerSweepEndBy()
					if not ( ((endSweepLayerId)%3 == 0) and (nowTowerLayerId == endSweepLayerId) ) then
						logger:debug({endSweepLayerId = endSweepLayerId, nowTowerLayerId = nowTowerLayerId})
						ShowNotice.showShellInfo(_i18n[7020]) 
					end
					
					self:initScheduler()
					doShowDownEffectTag = 0
					doShowFlipDownEffectTag = 0
					self:initView()
				end
			end
			RequestCenter.impelDown_sweep(starSweepCallback)
		end
	end)
	LayerManager.addLayout(layDlg)
end

function ImpelDownMainView:resetGame( ... )
	local function resetGameCallback( cbFlag, dictData, bRet )
		if (bRet) then
			ImpelDownMainModel.updateResetGameData()
			ShowNotice.showShellInfo(_i18n[7021])
			doShowDownEffectTag = 1
			doShowFlipDownEffectTag = 1
			self:initView()
			GlobalNotify.postNotify("IMPEL_DOWN_UPDATE_TIP")
		end
	end
	RequestCenter.impelDown_resetTower(resetGameCallback)
end

-- 按钮点击事件
function ImpelDownMainView:setButtonEvents( ... )
	-- 返回按钮
	_layMain.BTN_BACK:addTouchEventListener(_tbBtnEvent.onBack)
	-- 商店按钮
	_layMain.BTN_SHOP:addTouchEventListener(_tbBtnEvent.onShop)
	-- 重置按钮
	_layMain.BTN_RESET:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (ImpelDownMainModel.getRemainCanResetTimes() <= 0) then
				AudioHelper.playCommonEffect()
				ShowNotice.showShellInfo(_i18n[7022])
			else
				if (ImpelDownMainModel.getNowTowerLayerId() == 1) then
					if (ImpelDownMainModel.getRemainChance()<=0) then
						AudioHelper.playCommonEffect()
						local strText = _i18n[7023]
						local layDlg = UIHelper.createCommonDlg(strText,nil,function ( sender, eventType )
							if (eventType == TOUCH_EVENT_ENDED) then
								LayerManager.removeLayout()
								local goldNum = ImpelDownMainModel.getResetCostByTimes(ImpelDownMainModel.getNumDailyCanReset() - ImpelDownMainModel.getRemainCanResetTimes() + 1)
								if (UserModel.getGoldNumber()>=goldNum) then
									AudioHelper.playBuyGoods()
									UserModel.addGoldNumber(-goldNum)
									self:resetGame()
								else
									AudioHelper.playCommonEffect()
									LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
								end
							end
						end)
						LayerManager.addLayout(layDlg)
					else
						AudioHelper.playCommonEffect()
						ShowNotice.showShellInfo(_i18n[7024])
					end
				else
					AudioHelper.playCommonEffect()
					local strText = _i18n[7025]
					local layDlg = UIHelper.createCommonDlg(strText,nil,function ( sender, eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							LayerManager.removeLayout()
							local goldNum = ImpelDownMainModel.getResetCostByTimes(ImpelDownMainModel.getNumDailyCanReset() - ImpelDownMainModel.getRemainCanResetTimes() + 1)
							if (UserModel.getGoldNumber()>=goldNum) then
								AudioHelper.playBuyGoods()
								UserModel.addGoldNumber(-goldNum)
								self:resetGame()
							else
								AudioHelper.playCommonEffect()
								LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
							end
						end
					end)
					LayerManager.addLayout(layDlg)
				end
			end
		end
	end)

	-- 扫荡按钮
	_layMain.BTN_SWEEP:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (ImpelDownMainModel.isSweeping()) then
				-- 停止扫荡
				self:manualStopSweep()
			else
				if (ImpelDownMainModel.getNowTowerLayerId()>ImpelDownMainModel.getTopGrade()) then
					if (ImpelDownMainModel.getNowTowerLayerId() == 1) then
						ShowNotice.showShellInfo(_i18n[7026])
					else
						ShowNotice.showShellInfo(_i18n[7027])
					end
				elseif (ImpelDownMainModel.getIfAllHaveDone()) then
					ShowNotice.showShellInfo(_i18n[7027])
				else
					-- 开始扫荡
					self:startSweep()
				end
			end
		end
	end)

	-- 立即完成按钮
	_layMain.BTN_FINISH:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			local function initImmediateView( ... )
				local goldNum = ImpelDownMainModel.getImmediateFinishCost()
				local layerNum = ImpelDownMainModel.getTopGrade()
				-- local layerNumFightId
				-- if (ImpelDownMainModel.isBoxLayerById(layerNum)) then
				-- 	layerNumFightId = ImpelDownMainModel.getFightLayerIdByNormalId(layerNum-1)
				-- else
				-- 	layerNumFightId = ImpelDownMainModel.getFightLayerIdByNormalId(layerNum)
				-- end
				local strText = _i18nString(7028, goldNum)
				local function dlgConfirmCallback( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						local function immediateFinishCallback( cbFlag, dictData, bRet )
							if (bRet) then
								if (dictData.ret) then
									LayerManager.removeLayout()
									GlobalNotify.removeObserver("UPDATE_IMPEL_TOWER_LEVEL", "UPDATE_IMPEL_TOWER_IMMEDIATE_FINISH_GOLD")
									self:autoStopSweep()
									UserModel.addGoldNumber(- tonumber(dictData.ret))
									--self:initView()
								end
							end
						end
						if (UserModel.getGoldNumber() >= goldNum) then
							AudioHelper.playBuyGoods()
							RequestCenter.impelDown_sweepByGold(immediateFinishCallback)
						else
							AudioHelper.playCommonEffect()
							LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
						end
					end
				end

				local layDlg = UIHelper.createCommonDlg(strText,nil, dlgConfirmCallback, nil, function ( ... )
					GlobalNotify.removeObserver("UPDATE_IMPEL_TOWER_LEVEL", "UPDATE_IMPEL_TOWER_IMMEDIATE_FINISH_GOLD")
				end)
				layDlg:setName("layoutDlgImpelImmediate")
				LayerManager.addLayout(layDlg)
			end

			initImmediateView()

			local function refreshImmediateFInishView( ... )
				LayerManager.removeLayout()
				initImmediateView()
			end
			GlobalNotify.addObserver("UPDATE_IMPEL_TOWER_LEVEL", refreshImmediateFInishView, false, "UPDATE_IMPEL_TOWER_IMMEDIATE_FINISH_GOLD")
		end
	end)

end

-- 显示重置按钮
function ImpelDownMainView:showResetButton( ... )
	_layMain.BTN_FINISH:setEnabled(false)
	_layMain.BTN_RESET:setEnabled(true)
	_layMain.TFD_RESET_NUM:setVisible(true)
	local remainCanResetTimes = ImpelDownMainModel.getRemainCanResetTimes()
	if (remainCanResetTimes == ImpelDownMainModel.getNumDailyCanReset()) then
		UIHelper.titleShadow(_layMain.BTN_RESET, _i18n[7009])
		_layMain.BTN_RESET.img_reset_gold:setVisible(false)
		_layMain.BTN_RESET.TFD_RESET_GOLD:setVisible(false)
	elseif (remainCanResetTimes>0) then
		_layMain.BTN_RESET.img_reset_gold:setVisible(true)
		_layMain.BTN_RESET.TFD_RESET_GOLD:setVisible(true)
		UIHelper.titleShadow(_layMain.BTN_RESET, _i18nString(7010, " "))
		local usedResetTimes = ImpelDownMainModel.getNumDailyCanReset() - remainCanResetTimes
		_layMain.BTN_RESET.TFD_RESET_GOLD:setText(tostring(ImpelDownMainModel.getResetCostByTimes(usedResetTimes+1)))
	else
		_layMain.BTN_RESET.img_reset_gold:setVisible(false)
		_layMain.BTN_RESET.TFD_RESET_GOLD:setVisible(false)
		UIHelper.titleShadow(_layMain.BTN_RESET, _i18n[7011])
	end
	_layMain.TFD_RESET_NUM:setText(_i18n[7014] .. remainCanResetTimes)
end

-- 显示立即完成按钮
function ImpelDownMainView:showImmediateButton( ... )
	_layMain.BTN_FINISH:setEnabled(true)
	_layMain.BTN_RESET:setEnabled(false)
	_layMain.TFD_RESET_NUM:setVisible(false)
	_layMain.img_finish_gold:setVisible(true)
	local ImmediateFinishCost = ImpelDownMainModel.getImmediateFinishCost()
	_layMain.TFD_FINISH_GOLD:setText(tostring(ImmediateFinishCost))
end

-- 屏蔽据点点击
function ImpelDownMainView:blockClickOfStrongHolds( ... )
	for i=1,3 do
		local layPlace = _fnGetWidget(_layMain, "lay_place_" .. i)
		layPlace.BTN_HERO:setTouchEnabled(false)
		layPlace.BTN_IN:setTouchEnabled(false)
		layPlace.BTN_BOX_CLOSE:setTouchEnabled(false)
		layPlace.BTN_GOLD_OPEN:setTouchEnabled(false)
		layPlace.BTN_GOLD_EMPTY:setTouchEnabled(false)
	end
end

-- 解屏蔽据点点击
function ImpelDownMainView:unBlockClickOfStrongHolds( ... )
	for i=1,3 do
		local layPlace = _fnGetWidget(_layMain, "lay_place_" .. i)
		layPlace.BTN_HERO:setTouchEnabled(true)
		layPlace.BTN_IN:setTouchEnabled(true)
		layPlace.BTN_BOX_CLOSE:setTouchEnabled(true)
		layPlace.BTN_GOLD_OPEN:setTouchEnabled(true)
		layPlace.BTN_GOLD_EMPTY:setTouchEnabled(true)
	end
end

-- 初始化按钮
function ImpelDownMainView:initButton( ... )
	if (ImpelDownMainModel.isSweeping()) then
		self:showImmediateButton()
		UIHelper.titleShadow(_layMain.BTN_SWEEP, _i18n[7012])
		self:blockClickOfStrongHolds()
		_layMain.TFD_SWEEP_TIME:setVisible(true)
	else
		self:showResetButton()
		UIHelper.titleShadow(_layMain.BTN_SWEEP, _i18n[7013])
		self:unBlockClickOfStrongHolds()
		_layMain.TFD_SWEEP_TIME:setVisible(false)
	end
end

-- 更新背景图片
function ImpelDownMainView:refreshBg( ... )
	local nowTowerLayerId = ImpelDownMainModel.getNowTowerLayerId()
	local nowBgName = ImpelDownMainModel.getBgNameById(nowTowerLayerId)
	logger:debug({changebg= IMPEL_BG_PATH..nowBgName})
	logger:debug({changebgnowTowerLayerId= nowTowerLayerId})
	_layMain.img_bg:loadTexture(IMPEL_BG_PATH..nowBgName)
end

-- 显示挑战次数红点
function ImpelDownMainView:initRemainChanceRedPoint( ... )
	local remainChance = ImpelDownMainModel.getRemainChance()
	local totalChance = ImpelDownMainModel.getFreeLoseTimes()
	for i=1,totalChance do
		if (i<=remainChance) then
			local chanceRedPoint = _fnGetWidget(_layMain, "img_num_" .. i)
			chanceRedPoint:setGray(false)
		else
			local chanceRedPoint = _fnGetWidget(_layMain, "img_num_" .. i)
			chanceRedPoint:setGray(true)
		end
	end
end

-- 显示通关奖励信息面板
function ImpelDownMainView:initPassRewardPanel( ... )
	local nowTowerLayerId = ImpelDownMainModel.getNowTowerLayerId()
	local nowTowerInfo = ImpelDownMainModel.getTowerDataByLevel(nowTowerLayerId)
	if (nowTowerInfo.type == 1) then
		_layMain.lay_reward:setVisible(true)
		_layMain.lay_box:setVisible(false)
		_layMain.img_desc_bg.TFD_BELLY_NUM:setText(nowTowerInfo.belly)
		_layMain.img_desc_bg.TFD_PRISON_NUM:setText(nowTowerInfo.prison)
	elseif (nowTowerInfo.type == 2) then
		_layMain.lay_reward:setVisible(false)
		_layMain.lay_box:setVisible(true)
	end
end

-- 重建视图
function ImpelDownMainView:updateViewAfterBattle( ... )
	ImpelDownMainModel.setNowTowerLayerId()
	doShowDownEffectTag = 0
	doShowFlipDownEffectTag = 1
	self:initView()
end

-- 战斗后翻页
function ImpelDownMainView:pageTurnAfterBattle( value, img )
	if (value.index ~= 3) then
		self:updateViewAfterBattle()
	elseif (value.info.id == ImpelDownMainModel.getTotalNumOfLayer()) then -- 如果是在最高层了，则不播放翻页动画
		LayerManager.removeLayoutByName("layForImpelDown_box_2")
		doShowDownEffectTag = 0
		doShowFlipDownEffectTag = 0
       	self:initView()
	else
		local layerBlock = Layout:create()
		layerBlock:setName("layerBlockImpleFight")
		LayerManager.addLayoutNoScale(layerBlock)

		if (img) then
			UIHelper.setWidgetGray(img, true)
		end

		local action1 = CCFadeOut:create(0.7) --渐变
		local action2 = CCDelayTime:create(0.3) --停留
		local action3 = CCFadeIn:create(0) --出现
		local action4 = CCCallFunc:create(function ( ... ) --翻页
			doShowDownEffectTag = 1
			doShowFlipDownEffectTag = 1
       		self:initView()
   		end)
   		local action5 = CCCallFunc:create(function ( ... ) -- 删除
       		_layMain:removeNode(layer)
       		LayerManager.removeLayoutByName("layerBlockImpleFight")
       		LayerManager.removeLayoutByName("layForImpelDown_box_2")
   		end)
   		local action6 = CCDelayTime:create(0.5) --置灰后停留
	    local actionArray = CCArray:create()
	    actionArray:addObject(action6)
	    actionArray:addObject(action3)
	    actionArray:addObject(action2)
	    actionArray:addObject(action4)
	    actionArray:addObject(action1)
	    actionArray:addObject(action5)		    
	    local action = CCSequence:create(actionArray)
		local layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
		layer:setPosition(ccp(0, 0))
		_layMain:addNode(layer, 100000)
		layer:runAction(action)
	end
end

-- 难度切换提示飘字
function ImpelDownMainView:showDifficulty()
	local prisonId, diffLv = ImpelDownMainModel.getDifficultyNoticeInfo()
	local diffName
	if (diffLv == 1) then
		diffName = "impel_down_level"
	elseif (diffLv == 2) then
		diffName = "impel_down_level_02"
	elseif (diffLv == 3) then
		diffName = "impel_down_level_03"
	end

	if (_layMain:getChildByTag(prisonNameNoticeTag)) then
		_layMain:getChildByTag(prisonNameNoticeTag):removeFromParentAndCleanup(true)
	end
	
	if (_layMain:getChildByTag(difficultyNoticeTag)) then
		_layMain:getChildByTag(difficultyNoticeTag):removeFromParentAndCleanup(true)
	end

	local posiHeight
	local posiWidth

	local aniPrisonName 
	local aniDifficult



	aniPrisonName = UIHelper.createArmatureNode({
		filePath = IMPEL_ANI_PATH .. "impel_down" .. prisonId .. ".ExportJson",
		animationName = "impel_down" .. prisonId,
		fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
			logger:debug({currentFrameIndex=currentFrameIndex})
			if ( frameEventName == "1" ) then
				aniDifficult = UIHelper.createArmatureNode({
					filePath = IMPEL_ANI_PATH .. "impel_down_level.ExportJson",
					animationName = diffName,
					fnMovementCall = function ( sender, MovementEventType , frameEventName)
						if (MovementEventType == EVT_COMPLETE) then
							performWithDelay(_layMain, function ( ... )
			  					aniDifficult:removeFromParentAndCleanup(true)
								aniPrisonName:removeFromParentAndCleanup(true)
			  				end, 1)
						end
					end,
				})
				aniDifficult:setPosition(ccp(posiWidth,posiHeight))
				_layMain:addNode(aniDifficult,101,difficultyNoticeTag)
			end
		end,
	})

	posiHeight = g_winSize.height-g_winSize.height*32/100-aniPrisonName:getContentSize().height/2
	posiWidth = g_winSize.width/2
	aniPrisonName:setPosition(ccp(posiWidth,posiHeight))
	_layMain:addNode(aniPrisonName,100,prisonNameNoticeTag)
end

-- 显示据点的图标
function ImpelDownMainView:initStrongHoldsView( ... )
	local nowTowerLayerId = ImpelDownMainModel.getNowTowerLayerId()
	logger:debug({nowlayer = nowTowerLayerId})
	local normalViewInfo = ImpelDownMainModel.getNowViewInfo(nowTowerLayerId)

	local function showGhost( key, value )
		local layGhost = _fnGetWidget(_layMain, "lay_place_" .. value.index)
		layGhost.lay_hero:setEnabled(false)
		layGhost.lay_box:setEnabled(false)
		layGhost.lay_stronghold:setEnabled(false)
		layGhost.lay_dead:setEnabled(true)

		local tbParams1 = {
			filePath = "images/effect/impel/die_1.ExportJson",
			animationName = "die_1_1",
			fnMovementCall = function ( sender, MovementEventType , frameEventName)
				if (MovementEventType == EVT_COMPLETE) then
					sender:removeFromParentAndCleanup(true)
					local tbParams3 = {
						filePath = "images/effect/impel/die_1.ExportJson",
						animationName = "die_1_2",
					}
					local aniGhost3 = UIHelper.createArmatureNode(tbParams3)
					layGhost.lay_dead:removeAllChildrenWithCleanup(true)
					layGhost.lay_dead:addNode(aniGhost3)
					aniGhost3:setPosition(ccp(layGhost.lay_dead:getContentSize().width/2, layGhost.lay_dead:getContentSize().height/2))
				end
			end,
		}
		local aniGhost1 = UIHelper.createArmatureNode(tbParams1)

		local tbParams2 = {
			filePath = "images/effect/impel/die_1.ExportJson",
			animationName = "die_1_2",
		}
		local aniGhost2 = UIHelper.createArmatureNode(tbParams2)
		
		if (value.info.id+1 == nowTowerLayerId) then
			layGhost.lay_dead:removeAllNodes()	
			layGhost.lay_dead:addNode(aniGhost1)
			aniGhost1:setPosition(ccp(layGhost.lay_dead:getContentSize().width/2, layGhost.lay_dead:getContentSize().height/2))
		else
			layGhost.lay_dead:removeAllNodes()	
			layGhost.lay_dead:addNode(aniGhost2)
			aniGhost2:setPosition(ccp(layGhost.lay_dead:getContentSize().width/2, layGhost.lay_dead:getContentSize().height/2))
		end
	end

	local function showHeadIcon( key, value )
		local layHeadIcon = _fnGetWidget(_layMain, "lay_place_" .. value.index)
		layHeadIcon.lay_dead:setEnabled(false)
		layHeadIcon.lay_box:setEnabled(false)
		layHeadIcon.lay_hero:setEnabled(false)
		layHeadIcon.lay_stronghold:setEnabled(true)

		UIHelper.setWidgetGray(layHeadIcon, false)

		local imgHead = layHeadIcon.IMG_HEAD
		imgHead:loadTexture(HERO_HEAD_PATH .. value.info.monsterModel)
		layHeadIcon.IMG_PHOTO_BG:loadTexture(HERO_HEAD_FRAME_PATH .. "stronghold_bg_n.png")
		--点击据点内容，开始战斗准备界面
		local toBattle = function ( sender, eventType )
		GuideCtrl.removeGuideView()
			local bFocus = sender:isFocused()
			if (bFocus) then
				imgHead:setScale(0.85)
				layHeadIcon.IMG_PHOTO_BG:loadTexture(HERO_HEAD_FRAME_PATH .. "stronghold_bg_h.png")
			else
				imgHead:setScale(1)
				layHeadIcon.IMG_PHOTO_BG:loadTexture(HERO_HEAD_FRAME_PATH .. "stronghold_bg_n.png")
			end
			if (eventType == TOUCH_EVENT_ENDED) then
				logger:debug ({valueinHeadBattleCallback = value})---
				if (value.isNowLayer == 1) then
					if (ImpelDownMainModel.getRemainChance()>0) then
						AudioHelper.playBtnEffect("start_fight.mp3") --进入战斗音效
						local strongHoldId = sender:getTag()
						local strongHoldInfo = ImpelDownMainModel.getTowerDataByLevel(strongHoldId)
						local battleData = {towerLevel = strongHoldId}	
						local function battleStartCallback( cbFlag, dictData, bRet )
							if (bRet) then
								require "script/battle/BattleModule"
								BattleModule.playImpelBattle( strongHoldInfo.stronghold , nil , dictData.ret.fightRet , function (ret,isWin,ext)
									logger:debug({walawalayinglemei = isWin})
									if (isWin) then
										ImpelDownMainModel.updateDataWhenWinBattle()
									else
										ImpelDownMainModel.updateDataWhenLoseBattle()
									end
									AudioHelper.playSceneMusic("copy1.mp3")
									if (GuideModel.getGuideClass() == ksGuideImpelDown and GuideImpelDownView.guideStep == 3) then  
        								GuideCtrl.createImpelDownGuide(4) 
   									end 
									if (ImpelDownMainModel.getCanRefreshView()) then
										if (isWin) then
											self:pageTurnAfterBattle(value, layHeadIcon.IMG_PHOTO_BG)
										else
											self:updateViewAfterBattle()
										end
									end
								end , battleData , ImpelDownMainModel.ifThisLayerCanJump(strongHoldId))
							end
						end
						local tbRpcArgs = {tonumber(strongHoldId)}
						RequestCenter.impelDown_defeatMonster(battleStartCallback, Network.argsHandlerOfTable(tbRpcArgs))
					else
						AudioHelper.playCommonEffect()
						self:buyFightTimes(value.info.id)
					end
				else
					local layerName = ImpelDownMainModel.getLayerNameById(value.info.id-1)
					if (layerName) then
						AudioHelper.playCommonEffect()
						ShowNotice.showShellInfo(_i18nString(7029, layerName))
					-- else
					-- 	ShowNotice.showShellInfo("领取宝箱可挑战") --TODO
					end
				end
			end
		end
		layHeadIcon.BTN_IN:setTag(value.info.id)
		layHeadIcon.BTN_IN:addTouchEventListener(toBattle)

		layHeadIcon.BTN_IN:loadTextureNormal(HERO_HEAD_FRAME_PATH .. value.info.monsterQuality .. ".png")
		layHeadIcon.BTN_IN:loadTexturePressed(HERO_HEAD_FRAME_PATH .. value.info.monsterQuality .. "_pressed.png")
		layHeadIcon.BTN_IN:setPositionType(POSITION_ABSOLUTE)
		if (tonumber(value.info.monsterQuality)==1) then
			layHeadIcon.BTN_IN:setPosition(ccp(0, -10))
		elseif  (tonumber(value.info.monsterQuality)==2) then
			layHeadIcon.BTN_IN:setPosition(ccp(0, -5))
		else
			layHeadIcon.BTN_IN:setPosition(ccp(0, 1))
		end

		layHeadIcon.TFD_STRONGHOLD_LAYER:setText(value.info.name)
		layHeadIcon.TFD_STRONGHOLD_NAME:setText(value.info.layerName)

		if (value.isDead == 1) then
			layHeadIcon.BTN_IN:setTouchEnabled(false)
			UIHelper.setWidgetGray(layHeadIcon.IMG_PHOTO_BG, true)
		end
	end

	local function showFullBody( key, value )
		local layFullBody = _fnGetWidget(_layMain, "lay_place_" .. value.index)
		layFullBody.lay_stronghold:setEnabled(false)
		layFullBody.lay_box:setEnabled(false)
		layFullBody.lay_dead:setEnabled(false)
		layFullBody.lay_hero:setEnabled(true)

		UIHelper.setWidgetGray(layFullBody, false)

		layFullBody.BTN_HERO:loadTextureNormal(HERO_BODY_PATH .. value.info.monsterModel)
		layFullBody.BTN_HERO:loadTexturePressed(HERO_BODY_PATH .. value.info.monsterModel)

		layFullBody.BTN_HERO:setScale(value.info.monsterSmall / 100)

		--呼吸特效
		UIHelper.fnPlayHuxiAni(layFullBody.BTN_HERO)
		
		layFullBody.TFD_HERO_LAYER:setText(value.info.name)
		layFullBody.TFD_HERO_NAME:setText(value.info.layerName)

		--点击据点内容，开始战斗准备界面
		local toBattle = function ( sender, eventType )

			if (eventType == TOUCH_EVENT_ENDED) then
				sender:setScale(value.info.monsterSmall / 100)
				UIHelper.fnPlayHuxiAni(layFullBody.BTN_HERO)
				logger:debug ({valueinHeadBattleCallback = value})---
				if (value.isNowLayer == 1) then
					if (ImpelDownMainModel.getRemainChance()>0) then
						AudioHelper.playBtnEffect("start_fight.mp3") --进入战斗音效
						local strongHoldId = sender:getTag()
						local strongHoldInfo = ImpelDownMainModel.getTowerDataByLevel(strongHoldId)
						local battleData = {towerLevel = strongHoldId}
						local function battleStartCallback( cbFlag, dictData, bRet )
							if (bRet) then
								require "script/battle/BattleModule"
								BattleModule.playImpelBattle( strongHoldInfo.stronghold , nil , dictData.ret.fightRet , function (ret,isWin,ext)
									logger:debug({walawalayinglemei = isWin})
									if (isWin) then
										ImpelDownMainModel.updateDataWhenWinBattle()
									else
										ImpelDownMainModel.updateDataWhenLoseBattle()
									end
									AudioHelper.playSceneMusic("copy1.mp3")
									if (ImpelDownMainModel.getCanRefreshView()) then
										if (isWin) then
											self:pageTurnAfterBattle(value, layFullBody.BTN_HERO)
										else
											self:updateViewAfterBattle()
										end
									end
								end , battleData , ImpelDownMainModel.ifThisLayerCanJump(strongHoldId))
							end
						end
						local tbRpcArgs = {tonumber(strongHoldId)}
						RequestCenter.impelDown_defeatMonster(battleStartCallback, Network.argsHandlerOfTable(tbRpcArgs))
					else
						self:buyFightTimes(value.info.id)
					end
				else
					local layerName = ImpelDownMainModel.getLayerNameById(value.info.id-1)
					if (layerName) then
						AudioHelper.playCommonEffect()
						ShowNotice.showShellInfo(_i18nString(7029, layerName))
					-- else
					-- 	ShowNotice.showShellInfo("领取宝箱可挑战") --TODO
					end
				end
			elseif (eventType == TOUCH_EVENT_BEGAN) then
				layFullBody.BTN_HERO:stopAllActions()
				sender:setScale(value.info.monsterSmall / 100 * 1.2)
			elseif (eventType == TOUCH_EVENT_CANCELED) then
				sender:setScale(value.info.monsterSmall / 100)
				UIHelper.fnPlayHuxiAni(layFullBody.BTN_HERO)
			end
		end
		layFullBody.BTN_HERO:setTag(value.info.id)
		layFullBody.BTN_HERO:addTouchEventListener(toBattle)

		if (value.isDead == 1) then
			layFullBody.BTN_HERO:setTouchEnabled(false)
			layFullBody.BTN_HERO:stopAllActions()
			UIHelper.setWidgetGray(layFullBody.BTN_HERO, true)
		end
	end

	local function showMonsterView( key, value )
		if (value.info.monsterType == 1) then
			showHeadIcon(key, value)
		elseif (value.info.monsterType == 2) then
			showFullBody(key, value)
		end
	end

	local function showBoxView( key, value )
		local layBox = _fnGetWidget(_layMain, "lay_place_" .. value.index)
		layBox.lay_hero:setEnabled(false)
		layBox.lay_stronghold:setEnabled(false)
		layBox.lay_dead:setEnabled(false)
		layBox.lay_box:setEnabled(true)

		UIHelper.setWidgetGray(layBox, false)

		if (ImpelDownMainModel.getIfAllHaveDone()) then
			layBox.BTN_BOX_CLOSE:setEnabled(false)
			layBox.BTN_GOLD_EMPTY:setEnabled(true)

			layBox.BTN_GOLD_OPEN:removeAllNodes()
			layBox.BTN_GOLD_OPEN:setEnabled(false)
		else
			if (value.isNowLayer == 1) then
				layBox.BTN_BOX_CLOSE:setEnabled(false)
				layBox.BTN_GOLD_EMPTY:setEnabled(false)
				layBox.BTN_GOLD_OPEN:setEnabled(true)

				local aniOpenBox = UIHelper.createArmatureNode({
					imagePath = ANIMATION_PATH .. "impel/prison_box_nor0.png",
					plistPath = ANIMATION_PATH .. "impel/prison_box_nor0.plist",
					filePath = ANIMATION_PATH .. "impel/prison_box_nor.ExportJson",
					animationName = "prison_box_nor_17",
					loop = -1,
				})
				layBox.BTN_GOLD_OPEN:removeAllNodes()
				aniOpenBox:setTag(TAG_OPENBOXANI)
				layBox.BTN_GOLD_OPEN:addNode(aniOpenBox)
			elseif (value.isNowLayer == 0) then
				layBox.BTN_GOLD_OPEN:setEnabled(false)
				layBox.BTN_GOLD_EMPTY:setEnabled(false)
				layBox.BTN_BOX_CLOSE:setEnabled(true)
			end

			local function onGetReward( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					if (value.isNowLayer == 1) then
						AudioHelper.playBackEffect()
						local function obtainBoxCallback( cbFlag, dictData, bRet )
							if (bRet) then
								if (dictData.ret == "ok") then

									AudioHelper.playSpecialEffect("texiao_prison_baoxiang.mp3")

									local aniObtainBox = UIHelper.createArmatureNode({
										filePath = ANIMATION_PATH .. "impel/prison_box_open.ExportJson",
										animationName = "prison_box_open",
										loop = -1,
										fnMovementCall = function ( sender, MovementEventType , frameEventName)
											if (MovementEventType == EVT_COMPLETE) then
												LayerManager.removeLayoutByName("layForImpelDown_box_1")
												require "script/module/public/RewardUtil"
												UIHelper.createGetRewardInfoDlg( nil, RewardUtil.parseRewards(ImpelDownMainModel.getRewardString(value.info.items), true), function ( ... )
													AudioHelper.playCloseEffect()
													LayerManager.removeLayout()
													ImpelDownMainModel.updateDataWhenGetBox()
													doShowDownEffectTag = 0
													doShowFlipDownEffectTag = 1

													local layout = Layout:create()
													layout:setName("layForImpelDown_box_2")
													LayerManager.addLayoutNoScale(layout)

													self:pageTurnAfterBattle(value)

												end )
											end
										end,
									})

									local layout = Layout:create()
									layout:setName("layForImpelDown_box_1")
									LayerManager.addLayoutNoScale(layout)
									--sender:setTouchEnabled(false)
									sender:removeNodeByTag(TAG_OPENBOXANI)
									sender:addNode(aniObtainBox)

								end
							end
						end
						
						local tbRewardData = RewardUtil.getItemsDataByStr(ImpelDownMainModel.getRewardString(value.info.items))
						logger:debug({tbRewardData = tbRewardData})
						-- 判断背包是否已满
						for k,v in pairs(tbRewardData) do
							if (tonumber(v.tid) ~= 0 and ItemUtil.bagIsFullWithTid(v.tid, true)) then
								return
							end
						end

						local tbRpcArgs = {tonumber(value.info.id)}
						RequestCenter.impelDown_obtainBoxReward(obtainBoxCallback, Network.argsHandlerOfTable(tbRpcArgs))
					end 
				end
			end
			layBox.BTN_GOLD_OPEN:addTouchEventListener(onGetReward)

			local function onCantGetReward( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					local layerName = ImpelDownMainModel.getLayerNameById(value.info.id-1)
					if (layerName) then
						AudioHelper.playCommonEffect()
						ShowNotice.showShellInfo(_i18nString(7030, layerName))
					end
				end
			end
			layBox.BTN_BOX_CLOSE:addTouchEventListener(onCantGetReward)
		end

		layBox.TFD_BOX_LAYER:setText(value.info.name)
	end

	local showNowLayerEffect = function ( key, value )
		if (not ImpelDownMainModel.getIfAllHaveDone()) then
			if (value.info.type == 1) then
				local aniAttack = UIHelper.createArmatureNode({
					filePath = ANIMATION_PATH .. "mubiao/mubiao.ExportJson",
					animationName = "mubiao",
					loop = -1,
				})
				local layPlace = _fnGetWidget(_layMain, "lay_place_" .. value.index)
				if (value.info.monsterType == 1) then
					layPlace.img_stronghold_effect:removeAllNodes()
					layPlace.img_stronghold_effect:addNode(aniAttack)
				elseif (value.info.monsterType == 2) then
					layPlace.img_hero_effect:removeAllNodes()
					layPlace.img_hero_effect:addNode(aniAttack)
				end
			elseif (value.info.type == 2) then 
				local aniAttack = UIHelper.createArmatureNode({
					filePath = ANIMATION_PATH .. "impel/prison_box_arrow.ExportJson",
					animationName = "prison_box_arrow",
					loop = -1,
				})
				local layPlace = _fnGetWidget(_layMain, "lay_place_" .. value.index)
				layPlace.img_box_effect:removeAllNodes()
				layPlace.img_box_effect:addNode(aniAttack)
			end
		end
	end

	local cleanNowLayerEffect = function ( key, value )
		if (value.info.type == 1) then
			local layPlace = _fnGetWidget(_layMain, "lay_place_" .. value.index)
			if (value.info.monsterType == 1) then
				layPlace.img_stronghold_effect:removeAllNodes()
			elseif (value.info.monsterType == 2) then
				layPlace.img_hero_effect:removeAllNodes()
			end
		elseif (value.info.type == 2) then 
			local layPlace = _fnGetWidget(_layMain, "lay_place_" .. value.index)
			layPlace.img_box_effect:removeAllNodes()
		end
	end

	for k,v in ipairs (normalViewInfo) do
		if (v.info.type == 1) then
			cleanNowLayerEffect(k,v)
			showMonsterView(k,v)
		elseif (v.info.type == 2) then
			cleanNowLayerEffect(k,v)
			showBoxView(k,v)
		end
	end

	local function setDownEffect( showTargetEffect, showNowLayerEffect, cleanNowLayerEffect, normalViewInfo, needShowDifficultyNotice )
		local layPlace
		for i = 1, 3 do
			layPlace = _fnGetWidget(_layMain, "lay_place_" .. i)
			local prePositionX = layPlace:getPositionX()
			local prePositionY = layPlace:getPositionY()
			layPlace:setPositionType(POSITION_ABSOLUTE)
			layPlace:setPosition(ccp(prePositionX ,prePositionY+g_winSize.height/3*2))
			local moveByPos = CCMoveBy:create(0.5, ccp(0,-g_winSize.height/3*2))
			local easeSine = CCEaseExponentialIn:create(moveByPos)
			local easeMove = CCEaseElasticOut:create(CCMoveBy:create(0.3, ccp(0,0)))
			local array = CCArray:create()
			array:addObject(easeSine)
			array:addObject(easeMove)
			if (i == 3) then
				array:addObject(CCCallFunc:create(function ( ... )
					showTargetEffect(normalViewInfo)
				end))
			end
			local action = CCSequence:create(array)
			layPlace:runAction(action)
		end
		if (needShowDifficultyNotice) then
			self:showDifficulty()
		end
	end

	local showTargetEffect = function( normalViewInfo )
		for k,v in ipairs (normalViewInfo) do
			if (v.info.type == 1) then
				cleanNowLayerEffect(k,v)
			elseif (v.info.type == 2) then
				cleanNowLayerEffect(k,v)
			end
			if (v.isNowLayer == 1) then
				showNowLayerEffect(k,v)
			end
		end
	end

	if (normalViewInfo[1].isNowLayer==1 and doShowFlipDownEffectTag == 1) then           -- 翻页的掉落
		if (ImpelDownMainModel.isNeedShowDifficultyNotice()) then
			logger:debug({showlema = ImpelDownMainModel.isNeedShowDifficultyNotice()})
			setDownEffect( showTargetEffect, showNowLayerEffect, cleanNowLayerEffect, normalViewInfo, true)
		else
			setDownEffect( showTargetEffect, showNowLayerEffect, cleanNowLayerEffect, normalViewInfo)
		end
	elseif(doShowDownEffectTag == 1) then            -- 进页面的掉落
		if (ImpelDownMainModel.isNoGainSweepReward()) then
			showTargetEffect(normalViewInfo)
		else
			setDownEffect( showTargetEffect, showNowLayerEffect, cleanNowLayerEffect, normalViewInfo, true)
		end
	else
		showTargetEffect(normalViewInfo)
	end

	doShowDownEffectTag = 0
	doShowFlipDownEffectTag = 0

end

-- 扫荡时的倒计时刷新
function ImpelDownMainView:initScheduler( ... )
	local function updateImpelSweepCountdownCallback( ... )
		if (ImpelDownMainModel.isSweeping()) then
			local timeString, timeRemain = ImpelDownMainModel.getCountdownString()
			
			_layMain.TFD_SWEEP_TIME:setText(_i18n[7016] .. timeString)
			local ImmediateFinishCost = ImpelDownMainModel.getImmediateFinishCost()
			_layMain.TFD_FINISH_GOLD:setText(tostring(ImmediateFinishCost))
			if (timeRemain <= 0) then
				LayerManager.removeLayoutByName("layoutDlgImpelImmediate")
				self:autoStopSweep()
			else
				ImpelDownMainModel.setNowTowerLayerId()
			end
		else
			self:autoStopSweep()
		end
	end
	if (ImpelDownMainModel.isSweeping()) then
		local timeString, timeRemain = ImpelDownMainModel.getCountdownString()
		_layMain.TFD_SWEEP_TIME:setText(_i18n[7016] .. timeString) --TODO
		GlobalScheduler.addCallback("UPDATE_IMPEL_SWEEP_COUNTDOWN", updateImpelSweepCountdownCallback)
	end
end

-- 退出界面时，开始检查是否需要显示红点的调度器
function ImpelDownMainView:initCheckRedPointScheduler( ... )
	local function checkImpelDownRedPoint( ... )
		require "script/utils/TimeUtil"
		local nowServerTime = TimeUtil.getSvrTimeByOffset()
		if (ImpelDownMainModel.getWhenEndSweep() < nowServerTime) then
			ImpelDownMainModel.updateDataWhenStopSweepAuto()
			ImpelDownMainModel.updateDataWhenReceiveSweepEndPush()
			GlobalNotify.postNotify("IMPEL_DOWN_UPDATE_TIP")
			logger:debug("stop checkImpelDownRedPoint impelView begin")
			GlobalScheduler.removeCallback("checkImpelDownRedPoint")
			logger:debug("stop checkImpelDownRedPoint impelView end")
		end
	end
	if (ImpelDownMainModel.isSweeping()) then
		logger:debug("start checkImpelDownRedPoint impelView begin")
		GlobalScheduler.addCallback("checkImpelDownRedPoint", checkImpelDownRedPoint)
		logger:debug("start checkImpelDownRedPoint impelView end")
	end
end

-- 扫荡时刷新页面的通知
function ImpelDownMainView:initRefreshNotify( ... )
	local function refreshImpelViewCallback( ... )
		local nowTowerLayerId = ImpelDownMainModel.getNowTowerLayerId()
		local endSweepLayerId = ImpelDownMainModel.getLayerSweepEndBy()
		--local nowViewInfo = ImpelDownMainModel.getNowViewInfo(nowTowerLayerId)
		local function startNotice( ... )
			if (ImpelDownMainModel.isSweeping() and nowTowerLayerId~=1) then
				local layerName = ImpelDownMainModel.getLayerNameById(nowTowerLayerId)
				if (layerName) then
					ShowNotice.showShellInfo(_i18nString(7031, layerName))
				end
			end
		end
		if ((nowTowerLayerId-1)%3 == 0) then
			local action1 = CCFadeOut:create(0.7) --渐变
			local action2 = CCDelayTime:create(0.3) --停留
			local action3 = CCFadeIn:create(0) --出现
			local action4 = CCCallFunc:create(function ( ... ) --翻页
	
				-- 2015-11-11 如果是扫荡最后停止在翻页，且已经扫荡到最后，则不显示翻页掉落特效
				if ( ((endSweepLayerId)%3 == 0) and (nowTowerLayerId == endSweepLayerId+1) )then
					doShowFlipDownEffectTag = 0
					doShowDownEffectTag = 0
				else
					doShowFlipDownEffectTag = 1
					doShowDownEffectTag = 1
				end
				
           		self:initView()
       		end)
       		local action5 = CCCallFunc:create(function ( ... ) -- 删除
           		_layMain:removeNode(layer)
				
           		if not ( ((endSweepLayerId)%3 == 0) and (nowTowerLayerId == endSweepLayerId+1) ) then
				   logger:debug({endSweepLayerId = endSweepLayerId, nowTowerLayerId = nowTowerLayerId})
  	         		startNotice()
  	         	end
				   
       		end)
		    local actionArray = CCArray:create()
		    actionArray:addObject(action3)
		    actionArray:addObject(action2)
		    actionArray:addObject(action4)
		    actionArray:addObject(action1)
		    actionArray:addObject(action5)		    
		    local action = CCSequence:create(actionArray)
			local layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
			layer:setPosition(ccp(0, 0))
			_layMain:addNode(layer, 100000)
			layer:runAction(action)
		else
			doShowDownEffectTag = 0
			doShowFlipDownEffectTag = 0
			self:initView()
			if not ( ((endSweepLayerId)%3 == 0) and (nowTowerLayerId == endSweepLayerId+1) ) then
				logger:debug({endSweepLayerId = endSweepLayerId, nowTowerLayerId = nowTowerLayerId})
				startNotice()
			end
		end
	end
	GlobalNotify.addObserver("UPDATE_IMPEL_TOWER_LEVEL", refreshImpelViewCallback, false, "UPDATE_IMPEL_TOWER_LEVEL")
end

function ImpelDownMainView:initView( ... )
	-- 更新当前层数
	ImpelDownMainModel.setNowTowerLayerId()
	-- 更新背景图片
	self:refreshBg()
	-- 显示红心
	self:initRemainChanceRedPoint()
	-- 显示按钮
	self:initButton()
	-- 显示据点
	self:initStrongHoldsView()
	-- 显示通关奖励
	self:initPassRewardPanel()
	-- 显示扫荡领奖面板（若有未领的奖励）
	if (ImpelDownMainModel.isNoGainSweepReward()) then
		performWithDelay(_layMain,function ( ... )
			self:initSweepRewardView(ImpelDownMainModel.getSweepRewardStartLv(), ImpelDownMainModel.getSweepRewardEndlv())
		end, 1/60)
		
	end
end

-------------------------------------
function ImpelDownMainView:destroy(...)
	package.loaded["ImpelDownMainView"] = nil
end

function ImpelDownMainView:moduleName()
    return "ImpelDownMainView"
end

function ImpelDownMainView:ctor()
	self.layMain = g_fnLoadUI("ui/impel_down_main.json")
end

function ImpelDownMainView:create( tbBtnEvent )
	_layMain = self.layMain
	UIHelper.registExitAndEnterCall(_layMain,
		function()
			self:initCheckRedPointScheduler()
			self.layMain=nil
			GlobalScheduler.removeCallback("UPDATE_IMPEL_SWEEP_COUNTDOWN")
			GlobalNotify.removeObserver("UPDATE_IMPEL_TOWER_LEVEL", "UPDATE_IMPEL_TOWER_IMMEDIATE_FINISH_GOLD")
			GlobalNotify.removeObserver("UPDATE_IMPEL_TOWER_LEVEL", "UPDATE_IMPEL_TOWER_LEVEL")
			GlobalNotify.removeObserver("IMPEL_DOWN_BACK_MUSIC", "IMPEL_DOWN_BACK_MUSIC")
		end,
		function()
			--logger:debug("bofangyinxiao")
			--AudioHelper.playSceneMusic("copy1.mp3")
			self:initScheduler()
			self:initRefreshNotify()
			GlobalScheduler.removeCallback("checkImpelDownRedPoint")
			GlobalNotify.addObserver("IMPEL_DOWN_BACK_MUSIC", function ( ... )
				AudioHelper.playSceneMusic("copy1.mp3")
			end, false, "IMPEL_DOWN_BACK_MUSIC")
		end
	)
	_tbBtnEvent = tbBtnEvent
	
	self:setButtonEvents()

	local imgBackGround = g_fnGetWidgetByName( _layMain ,"img_bg")
	imgBackGround:setScale(g_fScaleX)

	doShowDownEffectTag = 1
	doShowFlipDownEffectTag = 0
	self:initView()

	self:setI18nAndEffect()

	if (GuideModel.getGuideClass() == ksGuideImpelDown and GuideImpelDownView.guideStep == 2) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createImpelDownGuide(3) 
    end   

    _layMain.BTN_STRATEGY:addTouchEventListener(MainImpelDownCtrl.getBtnOnStrategy())

	return _layMain
end
