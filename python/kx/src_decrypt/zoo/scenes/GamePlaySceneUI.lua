
require "hecore.display.CocosObject"
require "hecore.display.Scene"
require "hecore.display.Director"
require "hecore.ui.LayoutBuilder"
require "hecore.ui.Button"

require "zoo.scenes.component.gameplayScene.ScoreProgressBar"
require "zoo.scenes.AnimationScene"
require "zoo.data.LevelMapManager"
require "zoo.data.MetaManager"
require "zoo.data.UserManager"
require "zoo.config.LevelConfig"
require "zoo.gamePlay.GameBoardLogic"
require "zoo.gamePlay.GameBoardView"
require "zoo.panel.StopGamePanel"
require "zoo.scenes.component.gameplayScene.MoveOrTimeCounter"
require "zoo.panelBusLogic.PassLevelLogic"
require "zoo.animation.PropListAnimation"
require "zoo.panel.QuitPanel"
require "zoo.panel.BuyPropPanel"
require "zoo.gameGuide.GameGuide"
require "zoo.panelBusLogic.IngamePaymentLogic"
require "zoo.animation.UFOAnimation"
require "zoo.panel.EndGamePropShowPanel"
require "zoo.panel.PrePropRemindPanel"
require 'zoo.config.RabbitWeeklyConfig'
require "zoo.model.PropsModel"
require "zoo.animation.TileSquirrel"

assert(not GamePlaySceneUI)
assert(Scene)
GamePlaySceneUI = class(Scene)
local visibleSize = CCDirector:sharedDirector():getVisibleSize()

GamePlaySceneUIType = table.const{
	kNormal = 1,
	kDev    = 2, 
	kReplay = 3,
}
function GamePlaySceneUI:init(levelId, levelType, selectedItemsData, gamePlaySceneUiType,  ...)
	assert(type(levelId)			== "number")
	assert(type(selectedItemsData)		== "table")
	assert(#{...} == 0)

	--------------
	--- Init Base Class
	------------------
	Scene.initScene(self)
	self.gamePlaySceneUiType = gamePlaySceneUiType or GamePlaySceneUIType.kNormal
	-------------
	--- Get Data
	--------------
	self.levelId		= levelId
	self.levelType 		= levelType
	self.selectedItemsData		= selectedItemsData
	self.name			= "GamePlaySceneUI"
	self.gameInit = false

	self.disposResourceCache = true          ------是否在游戏结束时删除缓存的贴图 ，replay的时候置为false

	he_log_warning("use MetaModel, replace it with MetaManager !")
	self.metaModel			= MetaModel:sharedInstance()
	self.metaManager		= MetaManager.getInstance()

	self.levelModeTypeId 		= self.metaModel:getLevelModeTypeId(self.levelId)
	assert(self.levelModeTypeId)
	self.curLevelScoreTarget 	= MetaModel:sharedInstance():getLevelTargetScores(self.levelId)


	assert(self.curLevelScoreTarget)
	assert(self.curLevelScoreTarget[1])
	assert(self.curLevelScoreTarget[2])
	assert(self.curLevelScoreTarget[3])

	-- ------------------
	-- Data About Level
	-- -------------------
	local levelMeta = LevelMapManager.getInstance():getMeta(self.levelId)
	local gameData = levelMeta.gameData

	self.levelModeType = gameData.gameModeName
	assert(self.levelModeType)
	self.gamePlayType = LevelMapManager.getInstance():getLevelGameModeByName(gameData.gameModeName)

	-- Time Limit
	self.timeLimit = false
	self.moveLimit = false
	if self.levelModeType == "Classic" then
		self.timeLimit = tonumber(gameData.timeLimit)
		self.moveOrTimeCount = tonumber(gameData.timeLimit)
		assert(self.timeLimit)
	else

		if self.gamePlayType == GamePlayType.kRabbitWeekly then
			self.moveLimit = RabbitWeeklyConfig.stageInitEnd
			self.moveOrTimeCount = RabbitWeeklyConfig.stageInitEnd
		else
			-- Move Step Limit
			self.moveLimit = tonumber(gameData.moveLimit)
			self.moveOrTimeCount = tonumber(gameData.moveLimit)
			assert(self.moveLimit)
		end
	end

	--- Other Data
	local visibleSize 	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local winSize = CCDirector:sharedDirector():getVisibleSize()

	---------------
	--- Create UI
	----------------

	-- Background
	local game_bg = Sprite:createWithSpriteFrameName("game_bg.png")
	game_bg:setPosition(ccp(visibleSize.width/2,visibleSize.height/2))
	self:addChild(game_bg)

	-- Top Right Leaves
	local topRightLeaves = ResourceManager:sharedInstance():buildGroup("rightLeaves")
	self:addChild(topRightLeaves)
	
	-- -----------------------
	-- Move Or Time Counter
	-- ------------------------
	self.moveOrTimeCounter = false

	if self.levelModeType == "Classic" then
		self.moveOrTimeCounter = MoveOrTimeCounter:create(self.levelId, MoveOrTimeCounterType.TIME_COUNT, self.timeLimit)
	else
		self.moveOrTimeCounter = MoveOrTimeCounter:create(self.levelId, MoveOrTimeCounterType.MOVE_COUNT, self.moveLimit)
	end

	self:addChild(self.moveOrTimeCounter)

	-- ------------------------
	-- Create Game Play Scene
	-- ------------------------
	local gamePlayScene	= GamePlayScene:create(self.levelId, self.gamePlaySceneUiType)
	self.gamePlayScene	= gamePlayScene
	self:addChild(gamePlayScene)

	local gameBoardLogic = gamePlayScene.mygameboardlogic
	gameBoardLogic.selectedItemsData = self.selectedItemsData
	self.gameBoardLogic = gameBoardLogic
	local gameBoardView = gamePlayScene.mygameboardview
	self.gameBoardView = gameBoardView
	assert(gameBoardLogic)
	gameBoardLogic.PlayUIDelegate = self
	gameBoardView.PlayUIDelegate = self

	-- -------------------
	-- Score Progress Bar
	-- ------------------
	local star1Score = self.curLevelScoreTarget[1]
	local star2Score = self.curLevelScoreTarget[2]
	local star3Score = self.curLevelScoreTarget[3]

	-- supporting 4-star levels
	local star4Score = self.curLevelScoreTarget[4]

	if star4Score then 
		self.scoreProgressBar = ScoreProgressBar:create(star1Score, star2Score, star3Score, star4Score)
	else	
		self.scoreProgressBar = ScoreProgressBar:create(star1Score, star2Score, star3Score)
	end
	
	self:addChild(self.scoreProgressBar)

	-- Top Left Leaves
	local topLeftLeaves = ResourceManager:sharedInstance():buildGroup("leftLeaves")
	self:addChild(topLeftLeaves)

	-- Pause Btn
	local pauseBtn	= topLeftLeaves:getChildByName("pauseBtn")
	self.pauseBtn	= pauseBtn
	assert(pauseBtn)

	-- Create Level Label Number
	local fntFile			= "fnt/titles.fnt"
	local diguanWidth		= 40
	local diguanHeight		= 40
	local levelNumberWidth		= 210
	local levelNumberHeight		= 40
	local manualAdjustInterval	= -10
	

	local levelDisplayName
	local levelNumberLabel
	if self.levelType == GameLevelType.kDigWeekly or self.levelType == GameLevelType.kRabbitWeekly then
		local day = (tonumber(os.date('%w', Localhost:time() / 1000)) - 1 + 7) % 7
		levelDisplayName = Localization:getInstance():getText('weekly.race.play.scene.name', {num = day})
		local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
		levelNumberLabel = PanelTitleLabel:createWithString(levelDisplayName, len)
		levelNumberLabel:setScale(0.7)
	elseif self.levelType == GameLevelType.kMayDay then
		levelDisplayName = Localization:getInstance():getText('activity.christmas.start.panel.title')
		local len = math.ceil(string.len(levelDisplayName) / 3)
		levelNumberLabel = PanelTitleLabel:createWithString(levelDisplayName, len)
		levelNumberLabel:setScale(0.7)
	elseif self.levelType == GameLevelType.kTaskForRecall or self.levelType == GameLevelType.kTaskForUnlockArea then
		levelDisplayName = Localization:getInstance():getText('recall_text_5')
		local len = math.ceil(string.len(levelDisplayName) / 3)
		levelNumberLabel = PanelTitleLabel:createWithString(levelDisplayName, len)
		levelNumberLabel:setScale(0.7)
	else 
		levelDisplayName = LevelMapManager.getInstance():getLevelDisplayName(self.levelId)
		levelNumberLabel = PanelTitleLabel:create(levelDisplayName, diguanWidth, diguanHeight, levelNumberWidth, levelNumberHeight, manualAdjustInterval)
	end

	if _isQixiLevel then -- qixi
		print('qixi setVisible')
		levelNumberLabel:setVisible(false)
	end

	local contentSize	= levelNumberLabel:getContentSize()
	self:addChild(levelNumberLabel)
	levelNumberLabel:ignoreAnchorPointForPosition(false)
	levelNumberLabel:setAnchorPoint(ccp(0,1))

	local effectLayer = CocosObject:create()
	self.effectLayer = effectLayer
	self:addChild(effectLayer)

	local otherElementsLayer = CocosObject:create()
	self.otherElementsLayer = otherElementsLayer
	self:addChild(otherElementsLayer)


	-- Format For Used By PropListAnimation
	-- Example Format
	--{
	--	{itemId=10001, itemNum=1, temporary=0},
	--	{itemId=10003, itemNum=3, temporary=1},
	--},
	PropsModel.instance():init(self.levelId, selectedItemsData, gameBoardLogic:hasOctopus())
	-- -----------
	-- Prop List
	-- -----------

	self.propList = PropListAnimation:create(self.levelId, self.levelModeType)
	-- self.propList:setLevelModeType(self.levelModeType)
	self.propList:show(PropsModel.instance().addToBarProps)
	self:addChild(self.propList.layer)

	local function usePropCallback(propId, usePropType, isRequireConfirm, ...)
		assert(type(propId) == "number")
		assert(type(usePropType) == "number")
		assert(type(isRequireConfirm) == "boolean")
		assert(#{...} == 0)
		return self:usePropCallback(propId, usePropType, isRequireConfirm)
	end

	local function cancelPropUseCallback(propId, ...)
		assert(type(propId) == "number")
		assert(#{...} == 0)

		self:cancelPropUseCallback(propId)
	end

	local function buyPropCallback(propId, ...)
		assert(type(propId) == "number")
		assert(#{...} == 0)

		self:buyPropCallback(propId)
	end

	self.propList.controller:registerUsePropCallback(usePropCallback)
	self.propList.controller:registerCancelPropUseCallback(cancelPropUseCallback)
	self.propList.controller:registerBuyPropCallback(buyPropCallback)
	self.propList.controller:registerSpringItemCallback(function () self:useSpringItemCallback() end)

	local levelTargetLayer 	= CocosObject:create()
	self.levelTargetLayer	= levelTargetLayer
	self:addChild(levelTargetLayer)

	local guideLayer = CocosObject:create()
	self.guideLayer = guideLayer
	self:addChild(guideLayer)

	local wSize = Director:sharedDirector():getWinSize()
	self.mask = LayerColor:create()
	self.mask:changeWidthAndHeight(wSize.width, wSize.height)
	self.mask:setOpacity(0)
	self.mask:setPosition(ccp(0, 0))
	self.mask:setTouchEnabled(true, 0, true)
	self:addChild(self.mask)
	
	-----------------
	-- Pause Btn
	-- ------------
	pauseBtn:setTouchEnabled(true)
	pauseBtn:setAnchorPointCenterWhileStayOrigianlPosition()
	pauseBtn:setButtonMode(true)

	local function onPauseBtnTapped()
		self:onPauseBtnTapped()
	end
	pauseBtn:addEventListener(DisplayEvents.kTouchTap, onPauseBtnTapped)

	-- ----------------------
	-- Step Or Time Counter
	-- ---------------------
	local counterSize = self.moveOrTimeCounter:getGroupBounds().size
	local counterX	= visibleOrigin.x + visibleSize.width - counterSize.width/2 - 20
	local counterY	= visibleOrigin.y + visibleSize.height + 25
	self.moveOrTimeCounter:setPosition(ccp(counterX, counterY))

	-- Top Left Leaves Position
	local topLeftLeavesX = visibleOrigin.x - 77.40
	local topLeftLeavesY = visibleOrigin.y + visibleSize.height + 22.95
	topLeftLeaves:setPosition(ccp(topLeftLeavesX, topLeftLeavesY))

	-- Top Right Leaves Position
	local topRightLeavesSize = topRightLeaves:getGroupBounds().size
	local topRightLeavesX = visibleOrigin.x + visibleSize.width - topRightLeavesSize.width + 16
	local topRightLeavesY = visibleOrigin.y + visibleSize.height + 16
	topRightLeaves:setPosition(ccp(topRightLeavesX, topRightLeavesY))

	-- Level Number Label
	local levelNumberLabelPosX = 4
	local levelNumberLabelPosY = visibleOrigin.y + visibleSize.height - 8.4

	levelNumberLabel:setPosition(ccp(levelNumberLabelPosX, levelNumberLabelPosY))

	-- Score Progress Bar
	local scoreProgressBarX = visibleOrigin.x - 17 + 10
	local scoreProgressBarY = visibleOrigin.y + visibleSize.height - 15
	self.scoreProgressBar:setPosition(ccp(scoreProgressBarX, scoreProgressBarY))


	if gamePlayType == GamePlayType.kNone then
		assert(false)
	elseif gamePlayType == GamePlayType.kClassicMoves or
		gamePlayType == GamePlayType.kClassic then

		local function onScoreChangeCallback(newScore)
			self:onScoreChangeCallback(newScore)
		end

		self.scoreProgressBar:setOnScoreChangeCallback(onScoreChangeCallback)
	end

	------------------------
	-- Get Data About Level Target
	-- --------------------------
	local orderList		= gameBoardLogic.theOrderList
	assert(orderList)

	self.targetType = false

	local function onTimeModeStart()
		self:onTimeModeStart()
	end

	------------------------
	-- Init The Level Target Panel In Time Mode
	-- ---------------------------------------
	if gamePlayType == GamePlayType.kClassic then
		self.gamePlayScene:setGameStop()
	end

	---------------------
	-- Register Script Handler
	-- ---------------------
	local function onEnterHandler(event)
		self:onEnterHandler(event)
	end
	self:registerScriptHandler(onEnterHandler)

	self.useItem = false

	if StartupConfig:getInstance():isLocalDevelopMode() then
	    -- 掉落逻辑调试信息显示
		if gameBoardLogic.dropBuffLogic and gameBoardLogic.dropBuffLogic.canBeTriggered then
			-- dropBuffLogic debug panel
			local dropStatLayer = LayerColor:create()
			dropStatLayer:setColor(ccc3(0, 0, 0))
			dropStatLayer:setOpacity(255 * 0.6)
			dropStatLayer:changeWidthAndHeight(visibleSize.width, 120)
			dropStatLayer:setPosition(ccp(visibleOrigin.x, gameBoardView:getPosition().y + 720))
			self:addChild(dropStatLayer)

			gameBoardLogic.dropBuffLogic:setDropStatDisplayLayer( dropStatLayer )
		end
	end

	DcUtil:logStageStart(self.levelId)
end

function GamePlaySceneUI:checkPropEnough(usePropType, propId)
	-- 临时道具
	if usePropType == UsePropsType.TEMP then
		return true
	end
	-- 限时道具
	if usePropType == UsePropsType.EXPIRE then
		local uNum = UserManager:getInstance():getUserTimePropNumber(propId)
		local sNum = UserService:getInstance():getUserTimePropNumber(propId)
		if uNum > 0 and sNum > 0 then
			return true
		end
		return false
	end
	-- 普通道具
	if usePropType == UsePropsType.NORMAL then 
		local uNum = UserManager:getInstance():getUserPropNumber(propId)
		local sNum = UserService:getInstance():getUserPropNumber(propId)
		if uNum > 0 and sNum > 0 then
			return true
		end
		return false
	end

	return false
end

function GamePlaySceneUI:usePropCallback(propId, usePropType, isRequireConfirm, ...)
	assert(type(propId) == "number")
	assert(type(usePropType) == "number")
	assert(type(isRequireConfirm) == "boolean")
	assert(#{...} == 0)

	print("GamePlaySceneUI:usePropCallback", isRequireConfirm, usePropType)
	self.usePropType = usePropType

	local realItemId = propId
	if self.usePropType == UsePropsType.EXPIRE then  realItemId = ItemType:getRealIdByTimePropId(propId) end
	
	if not isRequireConfirm then -- use directly
		local function sendUseMsgSuccessCallback()
			self.propList:confirm(propId)
			self.gameBoardView:useProp(realItemId, isRequireConfirm)
			self.useItem = true
		end
		local function sendUseMsgFailCallback(evt)
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)))
		end
		self:sendUsePropMessage(propId, usePropType, sendUseMsgSuccessCallback, sendUseMsgFailCallback)
		return true
	else -- can be canceled, must kill the process before use
		
		if self:checkPropEnough(usePropType, propId) then
			self.needConfirmPropId = propId
			-- self.needConfirmPropIsTempProperty = true
			self.gameBoardView:useProp(realItemId, isRequireConfirm)
			return true
		else
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(730311)))
			return false
		end
	end
end

function GamePlaySceneUI:cancelPropUseCallback(propId, ...)
	assert(type(propId) == "number")
	assert(#{...} == 0)

	self.needConfirmPropId 			= false
	-- self.needConfirmPropIsTempProperty 	= false

	self.gameBoardView:usePropCancelled(propId)
end

function GamePlaySceneUI:sendUsePropMessage(itemType, usePropType, sendMsgSuccessCallback, sendMsgFailCallback, ...)
	assert(type(itemType) == "number")
	assert(type(usePropType) == "number")
	assert(sendMsgSuccessCallback == false or type(sendMsgSuccessCallback) == "function")
	assert(#{...} == 0)
	
	local function successCallback()
		if sendMsgSuccessCallback then
			sendMsgSuccessCallback()
		end
	end

	local logic = UsePropsLogic:create(usePropType, self.levelId, 0, {itemType})
	logic:setSuccessCallback(successCallback)
	logic:setFailedCallback(sendMsgFailCallback)
	logic:start()
end

function GamePlaySceneUI:convertToLevelTargetAnimationOrderType(key1, ...)
	assert(key1)
	assert(#{...} == 0)

	local targetType = false

	if key1 == GameItemOrderType.kNone then
		assert(false)
	elseif key1 == GameItemOrderType.kAnimal then
		targetType = "order1"
	elseif key1 == GameItemOrderType.kSpecialBomb then
		targetType = "order2"
	elseif key1 == GameItemOrderType.kSpecialSwap then
		targetType = "order3"
	elseif key1 == GameItemOrderType.kSpecialTarget then
		targetType = "order4"
	elseif key1 == GameItemOrderType.kOthers then 
		targetType = "order5"
	elseif key1 == GameItemOrderType.kSeaAnimal then
		targetType = 'order6'
	else

		assert(false)
	end

	return targetType
end

function GamePlaySceneUI:setTargetNumber(key1, key2, number, worldPos, rotation, ...)
	assert(type(key1) == "number")
	assert(type(key2) == "number")
	assert(type(number)	== "number")
	assert(type(worldPos)	== "userdata")
	assert(#{...} == 0)

	local targetType = false
	local id = 1

	if self.targetType == "order" then
		targetType = self:convertToLevelTargetAnimationOrderType(key1)
		id = key2
	elseif self.targetType == kLevelTargetType.dig_move_endless_mayday then
		targetType = self.targetType
		id = key2
	else
		targetType = self.targetType
	end

	if targetType == 'order6' then -- 海洋模式必须传入转动的角度
		self.levelTargetPanel:setTargetNumber(targetType, id, number, true, worldPos, rotation)
	else
		self.levelTargetPanel:setTargetNumber(targetType, id, number, true, worldPos)
	end
end

function GamePlaySceneUI:revertTargetNumber(key1, key2, number,...)
	assert(type(key1) == "number")
	assert(type(key2) == "number")
	assert(type(number)	== "number")
	assert(#{...} == 0)

	local targetType = false
	local id = 1

	if self.targetType == "order" then
		targetType = self:convertToLevelTargetAnimationOrderType(key1)
		id = key2
	elseif self.targetType == kLevelTargetType.dig_move_endless_mayday then
		targetType = self.targetType
		id = key2
	else
		targetType = self.targetType
	end

	self.levelTargetPanel:revertTargetNumber(targetType, id, number)
end

function GamePlaySceneUI:buildBackground(...)
	assert(#{...} == 0)

	local background = LayerColor:create()
	background:changeWidthAndHeight(self.visibleSize.width, self.visibleSize.height)
	background:setColor(ccc3(255, 255, 255))

	background:setPosition(ccp(self.visibleOrigin.x, self.visibleOrigin.y))
	self:addChild(background)
end

function GamePlaySceneUI:onKeyBackClicked(...)
	assert(#{...} == 0)
	if self.mask or (self.guideLayer and self.guideLayer:getChildrenList() and #self.guideLayer:getChildrenList() > 0) or not self.pauseBtn:isTouchEnabled() then return end
	self:onPauseBtnTapped()
end

function GamePlaySceneUI:sendQuitLevelMessage(levelId, totalScore, starLevel, stageTime, destroyCoin, targetCount, opLog)
	local passLevelLogic = PassLevelLogic:create(levelId, totalScore, starLevel, stageTime, destroyCoin, targetCount, opLog, self.levelType, nil)
	passLevelLogic:start()
end

function GamePlaySceneUI:onPauseBtnTapped(...)


	assert(#{...} == 0)
	
	self:pause()

	local dcLevelType = {
		[GamePlayType.kNone] = "null",
		[GamePlayType.kClassicMoves] = "step",
		[GamePlayType.kClassic] = "time",
		[GamePlayType.kDropDown] = "drop",
		[GamePlayType.kLightUp] = "ice",
		[GamePlayType.kDigTime] = "time_land",
		[GamePlayType.kDigMove] = "step_land",
		[GamePlayType.kOrder] = "clear_up",
		[GamePlayType.kDigMoveEndless] = "endless_land",
		[GamePlayType.kRabbitWeekly] = "rabbit_weekly",
		[GamePlayType.kChristmasEndless] = "christmas",
		[GamePlayType.kMaydayEndless] = "mayday",
		[GamePlayType.kWorldCUP] = "worldcup",
		[GamePlayType.kSeaOrder] = "sea_order",
	    [GamePlayType.kHalloween] = "halloween",
	}

	local dcData = {
		current_stage = self.levelId,
		stage_first = 1,
		results = 0,
		stage_mode = dcLevelType[self.gamePlayType],
		stage_objective = 0,
		stage_finish = 0,
		use_item = self.useItem,
	}
	local scoreRef = UserService:getInstance():getUserScore(self.levelId)
	if scoreRef then
		if scoreRef.star < 1 then dcData.stage_first = 2
		else dcData.stage_first = 3 end
	end
	if self.timeLimit then
		dcData.stage_objective = self.timeLimit
	elseif self.moveLimit then
		if self.gamePlayType == GamePlayType.kRabbitWeekly then
			local stage = self.gameBoardLogic:getStageIndex()
			local moveLimit = self.gameBoardLogic:getStageMoveLimit()
			dcData.stage_objective = moveLimit
			dcData.stage_rabbit = stage
		else
			dcData.stage_objective = self.moveLimit
			dcData.stage_rabbit = 0
		end
	end
	dcData.stage_finish = self.moveOrTimeCount
	self.quitDcData = dcData

	local function onQuitCallback()
		if __use_low_effect then 
			FrameLoader:unloadImageWithPlists(self.fileList, true)
		end

		-- 退出游戏也要发送pass level
		if self.levelType == GameLevelType.kRabbitWeekly then
			self.gameBoardLogic:quitLevel()
		end
		
		if self.levelType == GameLevelType.kMainLevel
		     	or self.levelType == GameLevelType.kHiddenLevel then		
			HomeScene:sharedInstance():setEnterFromGamePlay(self.levelId)
		end

		if self.gamePlayType == GamePlayType.kMaydayEndless and 
				self.gameBoardLogic and self.gameBoardLogic.isFullFirework then
			--（五一)关卡结束技能未使用
	        DcUtil:UserTrack({ category='activity', sub_category='labourday_no_click_skill', quit_level = true })
		end

		dcData.results = 3
		Director:sharedDirector():popScene()
		DcUtil:logStageQuit(self.levelId, 0)
	end

	local function onClosePanelBtnTappedCallback()
		print('onClosePanelBtnTappedCallback')
		self.quitDcData = nil
		self:continue()
		if self.quitDcData then self.quitDcData = nil end
	end

	local function onReplayCallback()
		dcData.results = 4
		if not _isQixiLevel then
			if self.levelType == GameLevelType.kDigWeekly
				and WeeklyRaceManager:sharedInstance():getRemainingPlayCount() <= 0 then
				CommonTip:showTip(Localization:getInstance():getText('weekly.race.replay.tip'), 'negative', nil, 3)
				onClosePanelBtnTappedCallback()
				return
			end

			if self.levelType == GameLevelType.kRabbitWeekly then
				local rabbitMgr = RabbitWeeklyManager:sharedInstance()
				if rabbitMgr:getRemainingPlayCount() <= 0 then -- 没有可玩次数了
					if not rabbitMgr.mainLevelItemCompleted then
						CommonTip:showTip(Localization:getInstance():getText('weekly.race.rabbit.replay.tip1'), 'negative', nil, 3)
					elseif not rabbitMgr.shareItemCompleted then
						CommonTip:showTip(Localization:getInstance():getText('weekly.race.rabbit.replay.tip2'), 'negative', nil, 3)
					elseif rabbitMgr:getRemainingPayCount() > 0 then
						CommonTip:showTip(Localization:getInstance():getText('weekly.race.rabbit.replay.tip3'), 'negative', nil, 3)
					else
						CommonTip:showTip(Localization:getInstance():getText('weekly.race.replay.tip'), 'negative', nil, 3)
					end
					onClosePanelBtnTappedCallback()
					return
				end
			end

			if self.levelType == GameLevelType.kTaskForRecall then 
				local levelId = RecallManager.getInstance():getAreTaskLevelId()
				local selectedItemsData = {}
				local levelType = LevelType:getLevelTypeByLevelId(levelId)
				if levelId%2==0 then 
					DcUtil:UserTrack({category = "recall", sub_category = "push_start_task", id = 5})
				else
					DcUtil:UserTrack({category = "recall", sub_category = "push_start_task", id = 3})
				end
				local startLevelLogic = StartLevelLogic:create(self, levelId, levelType, selectedItemsData, true)
				startLevelLogic:start(true)
				return
			end

			-- 重玩也要发送pass level
			local function replayStartGameCallback()
				self.gameBoardLogic:quitLevel()
			end

			local startGamePanel = StartGamePanel:create(self.levelId, self.levelType)

			-- 重玩也要发送pass level
			if self.levelType == GameLevelType.kRabbitWeekly then
				startGamePanel:setReplayCallback(replayStartGameCallback)
			end

			startGamePanel:setOnClosePanelCallback(onClosePanelBtnTappedCallback)
			startGamePanel:popout(false)
			DcUtil:logStageQuit(self.levelId, 1)
		else
			local panel = QixiPanel:create()
			panel:setOnClosePanelCallback(onClosePanelBtnTappedCallback)
			panel:popout()
		end
	end

	local mode = QuitPanelMode.QUIT_LEVEL
	if self.levelType == GameLevelType.kMayDay then
		mode = QuitPanelMode.NO_REPLAY
	end

	local quitPanel = QuitPanel:create(mode)
	quitPanel:setOnReplayBtnTappedCallback(onReplayCallback)
	quitPanel:setOnQuitGameBtnTappedCallback(onQuitCallback)
	quitPanel:setOnClosePanelBtnTapped(onClosePanelBtnTappedCallback)

	-- -- 请不要随意在代码里面加上测试代码然后提交，如果一定需要提交测试代码，请加上__TEST的判断，然后这个变量可以在launcher的时候设置
	-- if true then
	-- 	--si xing guan ka ce shi
	-- 	quitPanel:setOnPassLevelTappedCallback(function()
	-- 		local tab = {20, 25, 45, 108, 112, 118, 119, 144, 227}
	-- 		local levelConfig = LevelDataManager.sharedLevelData():getLevelConfigByID(self.levelId)
	-- 		local starLevel = 3
	-- 		local targetCount = 300
	-- 		for k, v in ipairs(tab) do if self.levelId == v then starLevel = 4 break end end
	-- 		self:passLevel(self.levelId, levelConfig.scoreTargets[starLevel] + 10, starLevel, 100, 0, targetCount, nil, 5)
	-- 	end)
	-- 	quitPanel:setAddScoreTappedCallback(function()
	-- 		self.scoreProgressBar:addScore(50000, ccp(0, 0))
	-- 	end)
	-- end
	
	PopoutManager:sharedInstance():add(quitPanel, false, false)
end

function GamePlaySceneUI:getStarLevelFromScore(score, ...)
	assert(score)
	assert(#{...} == 0)

	local result = false

	if score < self.curLevelScoreTarget[1] then
		result = 0
	elseif score >= self.curLevelScoreTarget[1] and score < self.curLevelScoreTarget[2] then
		result = 1
	elseif score >= self.curLevelScoreTarget[2] and score < self.curLevelScoreTarget[3] then
		result = 2
	elseif score >= self.curLevelScoreTarget[3] then
		result = 3
	end

	return result
end


function GamePlaySceneUI:create(levelId, levelType, selectedItemsData, ...)
	assert(type(levelId)			== "number")
	assert(type(selectedItemsData)		== "table")
	assert(#{...} == 0)

	local scene = GamePlaySceneUI.new()
	scene:init(levelId, levelType, selectedItemsData)

	local function testCall()
		scene:passLevel(1, 99999999, 3, 0, 0)
		--scene:failLevel(1, 0, 0, 0, 0, false)
	end
	--setTimeOut(testCall, 3)

	return scene
end

function GamePlaySceneUI:passLevel(levelId, score, star, stageTime, coin, targetCount, opLog, bossCount, ...)
	assert(type(levelId)	== "number")
	assert(type(score)	== "number")
	assert(type(star)	== "number")
	assert(type(stageTime)	== "number")
	assert(type(coin)	== "number")
	assert(#{...} == 0)

	DcUtil:logStageEnd(levelId, score, star, 0)

	-- ----------------------------------
	-- Ensure Only Call This Func Once
	-- ----------------------------------
	assert(not self.levelFinished, "only call this function one time !")
	if not self.levelFinished then
		self.levelFinished = true
	end

	local levelType = self.levelType

	if self.gamePlayType == GamePlayType.kMaydayEndless and 
			self.gameBoardLogic and self.gameBoardLogic.isFullFirework then
		--（五一)关卡结束技能未使用
        DcUtil:UserTrack({ category='activity', sub_category='labourday_no_click_skill', quit_level = false })
	end
	------------------------
	--- Success Callback
	------------------------
	local function onSendPassLevelMessageSuccessCallback(levelId, score, rewardItems, ...)
		assert(type(levelId)	== "number")
		assert(type(score)	== "number")
		assert(rewardItems)
		assert(#{...} == 0)

		-- insert digged gems as the first reward
		if levelType == GameLevelType.kDigWeekly then
			local tmp = {}
			table.insert(tmp, {itemId = ItemType.GEM, num = targetCount})
			table.insert(tmp, rewardItems[1])
			table.insert(tmp, rewardItems[2])
			rewardItems = tmp
		elseif levelType == GameLevelType.kMayDay then
			local tmp = {}
			-- table.insert(tmp, {itemId = ItemType.XMAS_BOSS, num = bossCount})
			table.insert(tmp, {itemId = ItemType.XMAS_BELL, num = targetCount})
			table.insert(tmp, rewardItems[1])
			rewardItems = tmp
		elseif levelType == GameLevelType.kRabbitWeekly then
			local tmp = {}
			table.insert(tmp, {itemId = ItemType.WEEKLY_RABBIT, num = targetCount})
			table.insert(tmp, rewardItems[1])
			table.insert(tmp, rewardItems[2])
			rewardItems = tmp
		elseif levelType == GameLevelType.kTaskForRecall then
			rewardItems = {}
		end

		-----------------------------
		-- Popout Game Success Panel
		-- --------------------------
		local levelSuccessPanel = LevelSuccessPanel:create(levelId, levelType, score, rewardItems, coin)

		-- Set The Star Pop Position And Star Size
		local bigStarSize	= self.scoreProgressBar:getBigStarSize()
		local bigStarPosTable	= self.scoreProgressBar:getBigStarPosInWorldSpace()

		for index = 1,#bigStarPosTable do
			local posX = bigStarPosTable[index].x
			local posY = bigStarPosTable[index].y
			levelSuccessPanel:setStarInitialPosInWorldSpace(index, ccp(bigStarPosTable[index].x, bigStarPosTable[index].y))
		end

		for index = 1,#bigStarPosTable do
			levelSuccessPanel:setStarInitialSize(index, bigStarSize.width, bigStarSize.height)
		end

		-- Set The Hide Star Callback
		local function hideScoreProgressBarStarCallback(starIndex, ...)
			assert(type(starIndex) == "number")
			assert(#{...} == 0)

			self.scoreProgressBar:setBigStarVisible(starIndex, false)
		end
		levelSuccessPanel:registerHideScoreProgressBarStarCallback(hideScoreProgressBarStarCallback)

		levelSuccessPanel:popout()
		--ShareManager:onPassLevel(levelId, score, levelType)
	end

	local isNewBranchUnlock = self:checkHiddenAreaUnlockAchievement(levelId, levelType, star)
	self:checkScoreAndCompleteAchievement(score)

	PrePropRemindPanelModel:resetCounter()
	local passLevelLogic = PassLevelLogic:create(levelId,
							score,
							star,
							stageTime,
							coin,
							targetCount, 
							opLog,
							levelType,
							onSendPassLevelMessageSuccessCallback)
	passLevelLogic:start()

	print("---------------------------------------------------"..ShareManager.ConditionType.UNLOCK_HIDEN_LEVEL)
	ShareManager:setShareData(ShareManager.ConditionType.UNLOCK_HIDEN_LEVEL, isNewBranchUnlock)
	ShareManager:shareWithID(ShareManager.UNLOCK_HIDEN_LEVEL)

end

function GamePlaySceneUI:checkHiddenAreaUnlockAchievement(levelId, levelType, newStar)
	local result = false
	local originLevelScore = UserManager:getInstance():getUserScore(levelId)
	if originLevelScore then
		UserManager:getInstance():removeUserScore(originLevelScore.levelId)
	end

	local newLevelScore = ScoreRef.new()
	newLevelScore.levelId = levelId
	newLevelScore.star = newStar
	UserManager:getInstance():addUserScore(newLevelScore)


	if not originLevelScore or originLevelScore.star < newStar then
		if levelType == GameLevelType.kMainLevel then
			local branchId = MetaModel:sharedInstance():getHiddenBranchIdByNormalLevelId(levelId)
			if branchId and not MetaModel:sharedInstance():isHiddenBranchUnlock(branchId) 
				and MetaModel:sharedInstance():isHiddenBranchCanOpen(branchId) then
				result = true
			end
		end
	end

	UserManager:getInstance():removeUserScore(levelId)
	if originLevelScore then
		UserManager:getInstance():addUserScore(originLevelScore)
	end

	return result
end

function GamePlaySceneUI:checkScoreAndCompleteAchievement(score)
	local oldScore = UserManager:getInstance():getUserScore(self.levelId)
	local maxTopLevel = MetaManager.getInstance():getMaxNormalLevelByLevelArea()
	local topLevelId = UserManager:getInstance():getUserRef():getTopLevelId()
	local function onCompleteSuccess(evt)
		if self.isDisposed then return end
		local num = 10000
		if evt.data and evt.data.passNum  then
			num = evt.data.passNum
		end
		setTimeOut(function()
				if not self.isDisposed then 
					ShareManager:setShareData(ShareManager.ConditionType.PASS_NUM, num)
					ShareManager:shareWithID(ShareManager.HIGHEST_LEVEL)
				 end
			end, 1 / 60)
	end
	local function onRankSuccess(evt)
		if self.isDisposed then return end

		local share = false

		if evt.data and evt.data.share then
			share = evt.data.share
		end

		setTimeOut(function()
				if not self.isDisposed then 
					ShareManager:setShareData(ShareManager.ConditionType.OVER_SELF_RANK, share)
					ShareManager:shareWithID(ShareManager.OVER_SELF_RANK)
				 end
			end, 1 / 60)
	end
	local completeRequest = self.levelId == maxTopLevel and self.levelId == topLevelId and (not oldScore or not oldScore.score)
	local rankRequest = not oldScore or not oldScore.score or oldScore.score < score
	if completeRequest and rankRequest then ConnectionManager:block() end
	if completeRequest then
		local completeHttp = GetPassNumHttp.new()
		completeHttp:addEventListener(Events.kComplete, onCompleteSuccess)
		completeHttp:load(self.levelId)
	else
		onCompleteSuccess({})
	end

	--服务端优化，在pass level之后获取之前的排名
	ShareManager.preLevel = self.levelId
	if oldScore then
		ShareManager.preScore = oldScore.score
	end

	-- if rankRequest then
	-- 	local rankHttp = GetShareRankHttp.new()
	-- 	rankHttp:addEventListener(Events.kComplete, onRankSuccess)
	-- 	rankHttp:load(self.levelId, score)
	-- else
	-- 	onRankSuccess({})
	-- end
	if completeRequest and rankRequest then ConnectionManager:flush() end
end

function GamePlaySceneUI:onTimeModeStart(...)
	assert(#{...} == 0)
	-- self.gamePlayScene:setGameStart()
end

function GamePlaySceneUI:failLevel(levelId, score, star, stageTime, coin, targetCount, opLog, isTargetReached, failReason, ...)
	assert(type(levelId) 	== "number")
	assert(type(score)	== "number")
	assert(type(star)	== "number")
	assert(type(stageTime))
	assert(type(coin))
	assert(type(isTargetReached)	== "boolean")
	assert(#{...} == 0)

	local levelType = self.levelType
	-- ----------------------------------
	-- Ensure Only Call This Func Once
	-- ----------------------------------
	assert(not self.levelFinished, "only call this function one time !")
	if not self.levelFinished then
		self.levelFinished = true
	end

	if levelType == GameLevelType.kMayDay and star > 0 then
		GamePlayEvents.dispatchPassLevelEvent(
			{
				levelType=self.levelType, 
				levelId=self.levelId, 
				rewardsIdAndPos={{itemId = 11, num = targetCount}}, 
				isPlayNextLevel=false
			})
	end

	local function onPassLevelMsgSuccess(event)
		assert(event)
		assert(event.name == Events.kComplete)
		assert(event.data)

		SyncManager:getInstance():sync()
		local levelFailPanel = LevelFailPanel:create(levelId, levelType, score, star, isTargetReached, failReason)
		levelFailPanel:popout(false)
		ShareManager:onFailLevel(levelId, score)
	end

	local function onPassLevelMsgFailed()
		--assert(false)

		local levelFailPanel = LevelFailPanel:create(levelId, levelType, score, star, isTargetReached, failReason)
		levelFailPanel:popout(false)
		ShareManager:onFailLevel(levelId, score)
	end

	PrePropRemindPanelModel:sharedInstance():increaseCounter(self.levelId)
	local http = PassLevelHttp.new()
	http:addEventListener(Events.kComplete, onPassLevelMsgSuccess)
	http:addEventListener(Events.kError, onPassLevelMsgFailed)
	http:load(levelId, score, star, stageTime, coin, targetCount, opLog, levelType)

	--关卡失败 刷新推送召回功能的相关数据
	if self.levelType == GameLevelType.kMainLevel then 
		RecallManager.getInstance():updateRecallInfo()
		LocalNotificationManager.getInstance():pocessRecallNotification()
	end
end

function GamePlaySceneUI:pause(...)
	assert(#{...} == 0)

	self.gamePlayScene:setGameStop()
end


function GamePlaySceneUI:continue(...)
	assert(#{...} == 0)

	self.gamePlayScene:setGameRemuse()
end

-- This Function Is Called By Game Board Locig
function GamePlaySceneUI:addStep(levelId, score, star, isTargetReached, isAddStepCallback, ...)
	assert(type(levelId) 	== "number")
	assert(type(score)	== "number")
	assert(type(star)	== "number")
	assert(type(isTargetReached)	== "boolean")
	assert(type(isAddStepCallback)	== "function")
	assert(#{...} == 0)

	local addStep5Number = UserManager:getInstance():getUserPropNumber(ItemType.ADD_FIVE_STEP)
	local function onUseBtnTapped(propId, propType)
		isAddStepCallback(true)

		self.propList:setItemNumber(ItemType.ADD_FIVE_STEP, addStep5Number)
		self.propList:useItemWithType(propId, propType)
		self.propList:hideAddMoveItem()

		-- Re Enable Pause Btn
		self:setPauseBtnEnable(true)
	end

	local function onCancelBtnTapped()
		isAddStepCallback(false)
	end

	local addStepPanel = EndGamePropShowPanel:create(self.levelId, self.levelType, ItemType.ADD_FIVE_STEP)
	addStepPanel:setOnUseTappedCallback(onUseBtnTapped)
	addStepPanel:setOnCancelTappedCallback(onCancelBtnTapped)
	addStepPanel:popout()
end

-------------------------
--显示加时间面板
-------------------------
function GamePlaySceneUI:showAddTimePanel(levelId, score, star, isTargetReached, addTimeCallback, ...)
	assert(type(levelId) 	== "number")
	assert(type(score)	== "number")
	assert(type(star)	== "number")
	assert(type(isTargetReached)	== "boolean")
	assert(type(addTimeCallback)	== "function")
	assert(#{...} == 0)
	local function onUseBtnTapped(propId, propType)
		addTimeCallback(true)

		-- Re Enable Pause Btn
		self:setPauseBtnEnable(true)
	end

	local function onCancelBtnTapped()
		addTimeCallback(false)
	end

	local addStepPanel = EndGamePropShowPanel:create(self.levelId, self.levelType, ItemType.ADD_TIME)
	addStepPanel:setOnUseTappedCallback(onUseBtnTapped)
	addStepPanel:setOnCancelTappedCallback(onCancelBtnTapped)
	addStepPanel:popout()
end

-------------------------
--显示加兔兔导弹面板
-------------------------
function GamePlaySceneUI:showAddRabbitMissilePanel( levelId, score, star, isTargetReached, isAddPropCallback )
	-- body
	local propsNumber = UserManager:getInstance():getUserPropNumber(ItemType.RABBIT_MISSILE)
	local function onUseBtnTapped(propId, propType)
		isAddPropCallback(true)
		self:setPauseBtnEnable(true)
	end

	local function onCancelBtnTapped()
		print("lyhtest-----------GamePlaySceneUI:showAddRabbitMissilePanel:onCancelBtnTapped")
		isAddPropCallback(false)
	end

	local addPropPanel = EndGamePropShowPanel:create(self.levelId, self.levelType, ItemType.RABBIT_MISSILE)
	addPropPanel:setOnUseTappedCallback(onUseBtnTapped)
	addPropPanel:setOnCancelTappedCallback(onCancelBtnTapped)
	addPropPanel:popout()
end

function GamePlaySceneUI:addTemporaryItem(itemId, itemNum, fromGlobalPosition, ...)
	assert(#{...} == 0)

	local function onSuccessCallback()
		self.propList:addTemporaryItem(itemId, itemNum, fromGlobalPosition)
	end

	local function onFailedCallback()
	end

	local http = OpenGiftBlockerHttp.new()
	http:addEventListener(Events.kComplete, onSuccessCallback)
	http:load(self.levelId, {itemId})
end

function GamePlaySceneUI:addTimeProp(propId, num, fromGlobalPosition, activityId)
	local function onSuccessCallback()
		local propMeta = MetaManager:getInstance():getPropMeta(propId)
		assert(propMeta)
		if propMeta and propMeta.expireTime then
			local expireTime = os.time() * 1000 + propMeta.expireTime
			self.propList:addTimeProp(propId, num, expireTime, fromGlobalPosition)
		end
	end

	local http = GetPropsInGameHttp.new()
	http:addEventListener(Events.kComplete, onSuccessCallback)
	http:load(self.levelId, {propId}, activityId)
end

function GamePlaySceneUI:setItemTouchEnabled(enable)
	self.propList:setItemTouchEnabled(enable)
end

function GamePlaySceneUI:setPropState(itemId, reasonType, enable)
	-- type: 1. game init 2. has used in this round
	self.propList:setPropState(itemId, reasonType, enable)
	-- self.propList:setRevertPropDisable(GamePropsType.kBack_b, reasonType)
end

-- -----------------------------------------------------------------
-- Used To Confirm The Property Is Used, For Hammer Like Property
-- ----------------------------------------------------------------

function GamePlaySceneUI:confirmPropUsed(pos, ...)

	-- Previous Must Recorded The Used Prop
	assert(self.needConfirmPropId)

	-- Send Server User This Prop Message
	local function onUsePropSuccess()
		self.propList:confirm(self.needConfirmPropId, pos)
		self.needConfirmPropId 			= false
		-- self.needConfirmPropIsTempProperty 	= false
		self.useItem = true
	end
	local function onUsePropFail(evt)
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)))
	end
	self:sendUsePropMessage(self.needConfirmPropId, self.usePropType, onUsePropSuccess, onUsePropFail)
end

function GamePlaySceneUI:setPauseBtnEnable(enable, ...)
	assert(type(enable) == "boolean")
	assert(#{...} == 0)

	if enable then
		self.pauseBtn:setTouchEnabled(true)
		self.pauseBtn:setButtonMode(true)
	else
		-- Disable
		self.pauseBtn:setTouchEnabled(false)
		self.pauseBtn:setButtonMode(false)
	end
end

function GamePlaySceneUI:playPreGamePropAddStepAnim(itemData, animationCallback, ...)
	assert(itemData)
	assert(#{...} == 0)

	--这里的判断 用来加一些不在开始面板上显示的临时道具
	if not itemData.destXInWorldSpace then 
		self.gameBoardLogic:preGameProp(itemData.id) 
		return 
	end

	assert(itemData.destXInWorldSpace)
	assert(itemData.destYInWorldSpace)
	
	local destX = itemData.destXInWorldSpace
	local destY = itemData.destYInWorldSpace

	local function flyFinishedCallback()
		self.gameBoardLogic:preGameProp(itemData.id)
	end

	local function onAnimationFinish()
		animationCallback()
	end 

	local icon = PropListAnimation:createIcon(itemData.id)
	local iconSize		= icon:getGroupBounds()

	local animation = PrefixPropAnimation:createAddMoveAnimation(icon, 0, flyFinishedCallback, onAnimationFinish, ccp(destX, destY))
	self:addChild(animation)
end

function GamePlaySceneUI:playPreGamePropTakeEffectInBoard(itemData, pos1, pos2, flyFinishedCallback, animFinishCallback, ...)
	assert(itemData)
	if not PublishActUtil:isGroundPublish() then 
		assert(pos1)
		assert(pos2)
	
		assert(flyFinishedCallback)
		assert(#{...} == 0)

		assert(itemData.destXInWorldSpace)
		assert(itemData.destYInWorldSpace)
	end
	local destX = itemData.destXInWorldSpace
	local destY = itemData.destYInWorldSpace

	local function onFlyFinishedCallback()
		flyFinishedCallback()
	end

	local function onAnimationFinish()
		if animFinishCallback then 
			animFinishCallback()
		end
	end 

	local positionA = pos1
	local positionB = pos2
	local icon = PropListAnimation:createIcon(itemData.id)
	local iconSize		= icon:getGroupBounds()

	local animation = PrefixPropAnimation:createChangePropAnimation(icon, 0, positionA, positionB, onFlyFinishedCallback, onAnimationFinish, ccp(destX, destY))
	self:addChild(animation)
end

function GamePlaySceneUI:onEnterHandler(event, ...)
	assert(event)
	assert(#{...} == 0)
	print('today debug onEnterHandler')

	if event == "enter" then
		if not self.gameInit then
			self.gameInit = true
			-- Play Background Music
			GamePlayMusicPlayer:getInstance():playGameSceneBgMusic()
			local function useCallback(itemIds) self:useRemindPrepropCallback(itemIds) end
			local function finishCallback() self.gameBoardLogic:onGameInit() end
			if (not self.selectedItemsData or #self.selectedItemsData == 0) and PrePropRemindPanelModel:sharedInstance():checkCounter(self.levelId) then
				PrePropRemindPanelModel:resetCounter()
				local panel = PrePropRemindPanel:create(self.levelId, finishCallback,useCallback)
				if panel then panel:popout() else self.gameBoardLogic:onGameInit() end
			else self.gameBoardLogic:onGameInit() end
		end
	end
end

function GamePlaySceneUI:onEnterForeGround()
	print('today debug GamePlaySceneUI:onEnterForeGround')
	if self._isBuyPropPause == true then
		print('today debug _isBuyPropPause == true')
		self.gamePlayScene:setGameRemuse()
		self._isBuyPropPause = false
	end
end

function GamePlaySceneUI:useRemindPrepropCallback(itemIds)
	for k, v in ipairs(itemIds) do
		local tmpItem = {}
		tmpItem.id = tonumber(v.itemId)
		tmpItem.destXInWorldSpace = tonumber(v.destXInWorldSpace)
		tmpItem.destYInWorldSpace = tonumber(v.destYInWorldSpace)
		table.insert(self.selectedItemsData, tmpItem)
	end
end

local tipPanelHasPop = false
function GamePlaySceneUI:playPrePropAnimation(completeCallback)
	-- Ensure Only Called Once
	if self.enterGameAnimPlayed then return end
	if not self.enterGameAnimPlayed then
		self.enterGameAnimPlayed = true
	end
	
	local hasPrePropAnim = false

	local max_pre_prop = 0
	local current_pre_prop = 0
	local function allPrePropFinishCallback( ... )
		-- body
		current_pre_prop = current_pre_prop + 1
		if current_pre_prop >= max_pre_prop then 
			if RecallManager.getInstance():getRecallLevelState(self.levelId) then
				if not tipPanelHasPop then 
					tipPanelHasPop = true
					self:runTopLevelHint(completeCallback)
				else
					completeCallback()
				end
			else
				completeCallback()
			end	
		end
	end

	for k,v in pairs(self.selectedItemsData) do
		local preGamePropType = ItemType:getPrePropType(v.id)
		if PrePropType.ADD_STEP == preGamePropType then
			self:playPreGamePropAddStepAnim(v, allPrePropFinishCallback)
			max_pre_prop = max_pre_prop + 1
			self.useItem = true
		elseif PrePropType.TAKE_EFFECT_IN_BOARD == preGamePropType then
			-- Called By Game Logic
			local function playPreGamePropTakeEffectInBoardCallback( pos1, pos2, animFinishCallback)
				self:playPreGamePropTakeEffectInBoard(v, pos1, pos2, animFinishCallback, allPrePropFinishCallback)
			end
			max_pre_prop = max_pre_prop + 1
			self.gameBoardLogic:preGameProp(v.id, playPreGamePropTakeEffectInBoardCallback)
			self.useItem = true
		elseif PrePropType.ADD_TO_BAR == preGamePropType then
			local pos = ccp(v.destXInWorldSpace, v.destYInWorldSpace)
			max_pre_prop = max_pre_prop + 1
			self.propList:flushTemporaryProps(pos, allPrePropFinishCallback)
		else
			assert(false)
		end
	end

	-- ------
	-- Delay
	-- ------
	if current_pre_prop >= max_pre_prop then
		if completeCallback and type(completeCallback) == "function" then
			completeCallback()
		end
	end
end

function GamePlaySceneUI:playUFOReFlyInotAnimation( completeCallback)
	-- body
	if not self.ufo then return end
	local function callback( ... )
		-- body
		if completeCallback then completeCallback() end
	end
	local toPosition = GameExtandPlayLogic:getUFOPosition(self.gameBoardLogic)
	self.ufo:playAnimation_reFlyin(toPosition, callback)
end

function GamePlaySceneUI:playUFOFlyIntoAnimation( completeCallback, ufotype )
	-- body
	local ufo_sprite = UFOAnimation:create(ufotype)
	self.effectLayer:addChild(ufo_sprite)
	local toPosition = GameExtandPlayLogic:getUFOPosition(self.gameBoardLogic)
	ufo_sprite:playAnimation_firstFlyin(toPosition , completeCallback)
	self.ufo = ufo_sprite
end

function GamePlaySceneUI:playUFOPullAnimation(isPull)
	-- body
	if not self.ufo then return end
	local function callback( ... )
		if isPull then
			self.ufo:playAnimation_pull()
		end
	end

	local action = CCMoveTo:create(0.1, GameExtandPlayLogic:getUFOPosition(self.gameBoardLogic))
	self.ufo:runAction(CCSequence:createWithTwoActions(action, CCCallFunc:create(callback)))
end

function GamePlaySceneUI:playChangePeriodAnimation(periodNum, callback)
	assert(type(periodNum) == 'number')
	local txt = Sprite:createWithSpriteFrameName('rabbit_text'..periodNum..' instance 1')
	txt.dispose = function(_self) print('*********** disposing txt') Sprite.dispose(_self) end
	local function localCB()
		if txt and not txt.isDisposed then
			txt:removeFromParentAndCleanup(true)
		end
		callback()	
	end
	local a = CCArray:create()
	a:addObject(CCEaseExponentialOut:create(CCSpawn:createWithTwoActions(CCFadeIn:create(0.5), CCScaleTo:create(0.5, 1))))
	a:addObject(CCDelayTime:create(2))
	a:addObject(CCEaseExponentialOut:create(CCSpawn:createWithTwoActions(CCFadeOut:create(0.5), CCScaleTo:create(0.5, 1.3, 0.9))))
	a:addObject(CCCallFunc:create(localCB))
	local action = CCSequence:create(a)
	txt:runAction(action)
	Director:sharedDirector():getRunningScene():addChild(txt)
	local vo = Director:sharedDirector():getVisibleOrigin()
	local vs = Director:sharedDirector():getVisibleSize()
	txt:setPosition(ccp(vo.x + vs.width / 2, vo.y + vs.height / 2 + 70))

end

function GamePlaySceneUI:playUFOFlyawayAnimation( completeCallback )
	-- body
	if not self.ufo then return end
	self.ufo:playAnimation_flyOut(completeCallback)
end

function GamePlaySceneUI:playLevelTargetPanelAnim(completeCallback)
	self.levelTargetPanel = LevelTargetAnimation:create(200)

	local function onLevelTargetAnimationFinish()
		self:onGameAnimOver()
		completeCallback()
	end

	local function setDropDownMode(targetType)
		local levelMapManager = LevelMapManager.getInstance()
		local levelMeta		= levelMapManager:getMeta(self.levelId)
		assert(levelMeta)
		local gameData		= levelMeta.gameData
		assert(gameData)

		local ingredients	= gameData.ingredients
		assert(ingredients)

		local target = {{type=targetType, id=0, num=ingredients[1]}}
		self.targetType = targetType
		self.levelTargetPanel:setTargets(target, onLevelTargetAnimationFinish, onTimeModeStart)
	end


	local gamePlayType = self.gamePlayType
	-- Level Target Based On Level Type
	if gamePlayType == GamePlayType.kNone then
		assert(false)
	elseif gamePlayType == GamePlayType.kClassicMoves then
		local target = {{ type="move", id=0, num=self.curLevelScoreTarget[1]}}
		he_log_warning("move ?")
		self.targetType = "move"
		self.levelTargetPanel:setTargets(target, onLevelTargetAnimationFinish, onTimeModeStart)
	elseif gamePlayType == GamePlayType.kClassic then
		local target = {{ type="time", id=0, num=self.curLevelScoreTarget[1]}}
		self.targetType = "time"
		self.levelTargetPanel:setTargets(target, onLevelTargetAnimationFinish, onTimeModeStart)

	elseif gamePlayType == GamePlayType.kDropDown then
		-- Get The Gredients Number
		setDropDownMode("drop")
	elseif gamePlayType == GamePlayType.kUnlockAreaDropDown then
		setDropDownMode("acorn")
	elseif gamePlayType == GamePlayType.kLightUp then
		local iceNumber = self.gameBoardLogic.kLightUpTotal

		local target = {{type="ice", id=1, num=iceNumber}}
		self.targetType = "ice"
		self.levelTargetPanel:setTargets(target, onLevelTargetAnimationFinish, onTimeModeStart)
	elseif gamePlayType == GamePlayType.kDigTime then
		assert(false, "not implemented !")
	elseif gamePlayType == GamePlayType.kOrder
	    or gamePlayType == GamePlayType.kSeaOrder then
		self.targetType = "order"

		local targetTable = {}

		local orderList		= self.gameBoardLogic.theOrderList
		for index,orderData in ipairs(orderList) do

			local targetType	= false
			local id		= false
			local num		= false

			-- Get The Target Type
			targetType = self:convertToLevelTargetAnimationOrderType(orderData.key1)

			-- Get The Id
			id = orderData.key2

			-- Get The Number
			num = orderData.v1

			local target = {type = targetType, id = id, num = num}
			table.insert(targetTable, target)
		end

		self.levelTargetPanel:setTargets(targetTable, onLevelTargetAnimationFinish, onTimeModeStart)
	elseif gamePlayType == GamePlayType.kDigMoveEndless then

		if _isQixiLevel then
			local jewelNum = math.pow(2, 32) - 1
			local target = {{type="dig_move_endless_qixi", id=1, num=0}}	
			self.targetType = "dig_move_endless_qixi"
			self.levelTargetPanel:setTargets(target, onLevelTargetAnimationFinish, onTimeModeStart)
		
		else

			local jewelNum = math.pow(2, 32) - 1
			local target = {{type="dig_move_endless", id=1, num=0}}	
			self.targetType = "dig_move_endless"
			self.levelTargetPanel:setTargets(target, onLevelTargetAnimationFinish, onTimeModeStart)
		end
	elseif gamePlayType == GamePlayType.kDigMove then
		local jewelNum = self.gameBoardLogic.digJewelLeftCount
		local target = {{type="dig_move", id=1, num=jewelNum}}	
		self.targetType = "dig_move"
		self.levelTargetPanel:setTargets(target, onLevelTargetAnimationFinish, onTimeModeStart)
		-- 感恩节和mayday一模一样，只是替换素材
	elseif gamePlayType == GamePlayType.kMaydayEndless or gamePlayType == GamePlayType.kHalloween then
		local jewelNum = math.pow(2, 32) - 1
		local target = {{type= "dig_move_endless_mayday", id=1, num=0},
						{type= "dig_move_endless_mayday", id=2, num =0}}	
		self.targetType = "dig_move_endless_mayday"
		self.levelTargetPanel:setTargets(target, onLevelTargetAnimationFinish, onTimeModeStart)
	elseif gamePlayType == GamePlayType.kRabbitWeekly then
		local target = {{type="rabbit_weekly", id=1, num=0}}	
		self.targetType = "rabbit_weekly"
		self.levelTargetPanel:setTargets(target, onLevelTargetAnimationFinish, onTimeModeStart)
	else
		assert(false)
	end

	-- -----------------------
	-- Center The Target Panel
	-- -----------------------
	local alignLeftX	= 84
	local counterSize = self.moveOrTimeCounter:getGroupBounds().size
	local alignRightX	= self.moveOrTimeCounter:getPositionX() - counterSize.width/2
	local targetPanelSize	= self.levelTargetPanel:getTopContentSize()

	local deltaWidth	= alignRightX - alignLeftX - targetPanelSize.width
	local halfDeltaWidth	= deltaWidth / 2
	local centerPosX	= alignLeftX + halfDeltaWidth
	self.levelTargetPanel:setPosX(centerPosX)
	self.levelTargetLayer:addChild(self.levelTargetPanel.layer)
end

local goodsId = {
  [10001] = 1, [10002] = 2, [10003] = 3,
  [10004] = 4, [10005] = 5, [10010] = 7,
  [10052] = 148,
  [10055] = 151,
  [10056] = 153,
}

local function getGoodsId(propId)
	if propId == 10052 then
		local buyed = UserManager:getInstance():getDailyBoughtGoodsNumById(148) -- 打折
		print('buyed', buyed)
		if buyed > 0 then
			-- 买过打折的啦，只能买不打折的啦
			return 147 
		else 
			return 148
		end
	else
		return goodsId[propId]
	end
end

function GamePlaySceneUI:buyPropCallback(propId, ...)
	assert(type(propId) == "number")
	assert(#{...} == 0)

	print("GamePlaySceneUI:buyPropCallback Called !")
	print("propId: " .. propId)

	if PublishActUtil:isGroundPublish() then
		CommonTip:showTip(Localization:getInstance():getText("本轮游戏只能使用该道具5次哦！"), "positive")
	else
		self.gamePlayScene:setGameStop()
		self._isBuyPropPause = true

		local function onBoughtCallback(propId, propNum)
			print("onBoughtCallback", propId, propNum)
			self:onBoughtCallback(propId, propNum)
			self.propList:setItemTouchEnabled(true)
			self.gamePlayScene:setGameRemuse()
			self._isBuyPropPause = false
		end
		local function onExitCallback()
			print("onExitCallback")
			self.propList:setItemTouchEnabled(true)
			self.gamePlayScene:setGameRemuse()
			self._isBuyPropPause = false
		end

		if __ANDROID then -- ANDROID
			print("android", propId)
			local logic = IngamePaymentLogic:create(getGoodsId(propId))
			local function onSuccess()
				onBoughtCallback(propId, 1)
			end
			self.propList:setItemTouchEnabled(false)
			logic:buy(onSuccess, onExitCallback, onExitCallback)
		else -- else, on IOS and PC we use gold!
			self.propList:setItemTouchEnabled(false)
			local panel = BuyPropPanel:create(getGoodsId(propId))
			if panel then
				panel:setBoughtCallback(onBoughtCallback)
				panel:setExitCallback(onExitCallback)
				panel:popout()
			end
		end
	end
end

function GamePlaySceneUI:setMoveOrTimeCountCallback(count, playAnim, skipFiveAnim, ...)
	assert(type(count) == "number")
	assert(#{...} == 0)

	self.propList:onGameMoveChange(count, playAnim)
	self.moveOrTimeCounter:setCount(count, playAnim)
	self.moveOrTimeCount = count
	
	if not skipFiveAnim then
		if count > 0 and count <= 5 then
			if self.moveOrTimeCounter.counterType == MoveOrTimeCounterType.TIME_COUNT then
				if count == 5 then -- 时间关只在时间为5秒时震动一次，少于5秒时不再执行，防止打断动画
					self.moveOrTimeCounter:stopShaking()
					self.moveOrTimeCounter:shake()
				end
			else
				self.moveOrTimeCounter:stopShaking()
				self.moveOrTimeCounter:shake()
			end

			local function anim() self.moveOrTimeCounter:updateView(true) end
			self.moveOrTimeCounter:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCCallFunc:create(anim), CCDelayTime:create(1))))
		else
			self.moveOrTimeCounter:stopShaking()
		end
	end
end

function GamePlaySceneUI:setInfiniteMoveCallback()
	self.moveOrTimeCounter:setInfinite()
end


function GamePlaySceneUI:onBoughtCallback(propId, propNum, ...)
	assert(type(propId) == "number")
	assert(type(propNum) == "number")
	assert(#{...} == 0)

	print("GamePlaySceneUI:onBoughtCallback Called !")
	print("propId: " .. propId)
	print("propNum: " .. propNum)

	self.propList:addItemNumber(propId, propNum)
end

function GamePlaySceneUI:onScoreChangeCallback(newScore, ...)
	assert(type(newScore) == "number")
	assert(#{...} == 0)

	print("-------------------- New Score: " .. newScore .. " ---------------------------")
	self:setTargetNumber(0, 0, newScore, ccp(0,0))
end

function GamePlaySceneUI:onGameInit(levelId)
	print("*****GamePlaySceneUI:onGameInit")
	if GameGuide then
		return GameGuide:sharedInstance():onGameInit(levelId) or false
	else
		return false
	end
end

function GamePlaySceneUI:runTopLevelHint(endCallBack)
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local vSize = Director:sharedDirector():getVisibleSize()
	local anim = CommonSkeletonAnimation:createTutorialMoveIn()
	local sprite = Sprite:createEmpty()
	sprite:setScaleX(-1)
	sprite:setPositionXY(180, vOrigin.y + 460)
	local function animPlay() sprite:addChild(anim) end
	sprite:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(animPlay)))
	local panel = GameGuideRunner:createPanelMini("")
	local pText = panel.ui:getChildByName("text")
	local dimension = pText:getPreferredSize()
	local text = TextField:create("", nil, 32, dimension, kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	text:setString(Localization:getInstance():getText("recall_text_2"))
	text:setColor(ccc3(0, 0, 0))
	text:setAnchorPoint(ccp(0, 1))
	text:setPositionXY(pText:getPositionX(), pText:getPositionY())
	panel.ui:addChild(text)
	pText:removeFromParentAndCleanup(true)
	panel:setPosition(ccp(-600, self:getRowPosY(8)))
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(1))
	local function animStop() anim:pause() end
	array:addObject(CCEaseBackOut:create(CCMoveTo:create(0.2, ccp(180, self:getRowPosY(8)))))
	array:addObject(CCDelayTime:create(2.4))
	array:addObject(CCCallFunc:create(animStop))
	array:addObject(CCDelayTime:create(1.9))
	local function animContinue() anim:resume() end
	array:addObject(CCCallFunc:create(animContinue))
	array:addObject(CCDelayTime:create(0.2))

	local function panFadeOut()
		if panel and not panel.isDisposed then
			local childrenList = {}
			panel:getVisibleChildrenList(childrenList)
			for __, v in pairs(childrenList) do
				v:runAction(CCFadeOut:create(0.5))
			end
		end
	end
	array:addObject(CCCallFunc:create(panFadeOut))
	array:addObject(CCDelayTime:create(0.5))
	local function onComplete() 
		self.guideLayer:removeChildren(true)
		if endCallBack then 
			endCallBack()
		end 
	end
	array:addObject(CCCallFunc:create(onComplete))
	panel:runAction(CCSequence:create(array))

	self.guideLayer:addChild(sprite)
	self.guideLayer:addChild(panel)
end

function GamePlaySceneUI:onGameAnimOver()
	print("*****GamePlaySceneUI:onGameAnimOver")
	local res
	if GameGuide then
		res = GameGuide:sharedInstance():onGameAnimOver()
	end
	if self.mask then
		self.mask:removeFromParentAndCleanup(true)
		self.mask = nil
	end

	print("any guide is running?", res)
	if not res and self.levelId < 10000 then	
		local gpt = self.gameBoardLogic.theGamePlayType
		if gpt == GamePlayType.kClassicMoves 
			or gpt == GamePlayType.kDropDown 
			or gpt == GamePlayType.kLightUp 
			or gpt == GamePlayType.kOrder then
				GameGuide:sharedInstance():tryIngameBuyPropsGuide()
		end
	end

	return res
end

function GamePlaySceneUI:onGameSwap(from, to)
	print("*****GamePlaySceneUI:onGameSwap")
	if GameGuide then
		return GameGuide:sharedInstance():onGameSwap(from, to)
	end
end

function GamePlaySceneUI:onGetItem(itemType)
	print("*****GamePlaySceneUI:onGetItem")
	if GameGuide then
		return GameGuide:sharedInstance():onGetGameItem(itemType)
	end
end

function GamePlaySceneUI:onGameStable(hasGift)
	if GameGuide then
		return GameGuide:sharedInstance():onGameStable(hasGift)
	end
end

function GamePlaySceneUI:onExitGame()
	print("*****GamePlaySceneUI:onExitGame")
	if GameGuide then
		return GameGuide:sharedInstance():onExitGame()
	end
end

function GamePlaySceneUI:gameGuideMask(opacity, array, allow)
	print(allow)
	return self.gameBoardView:maskWithFewTouch(opacity, array, allow)
end

function GamePlaySceneUI:getPositionFromTo(from, to)
	return self.gameBoardView:getPositionFromTo(from, to)
end

function GamePlaySceneUI:getRowPosY(row)
	return self.gameBoardLogic:getGameItemPosInView(row, 5).y
end

function GamePlaySceneUI:getMoveCountPos()
	return self.gameBoardView.moveCountPos
end

function GamePlaySceneUI:getPositionByIndex(index)
	return self.propList:getPositionByIndex(index)
end

function GamePlaySceneUI:getGlobalPositionUnit(r, c)
	return self.gameBoardLogic:getGameItemPosInView(r, c)
end

function GamePlaySceneUI:dispose()
	if self.disposResourceCache and self.fileList ~= nil then
		if __use_low_effect then 
			FrameLoader:unloadImageWithPlists( self.fileList, true )
		end

		-- local function checkPngIsUnload( ... )
		-- 	-- body
		-- 	CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
		-- end
		-- CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(checkPngIsUnload, 10, false)
	end
	print('*******************GamePlaySceneUI:dispose')
	print('_isQixiLevel = false')
	if self.quitDcData then
		DcUtil:newLogUserStageQuit(self.quitDcData)
	end
	_isQixiLevel = false -- qixi
	self:onExitGame()
	Scene.dispose(self)
end

function GamePlaySceneUI:onApplicationHandleOpenURL(launchURL)
	print("*****************************************************")
	print("GamePlaySceneUI:onApplicationHandleOpenURL", launchURL)
	if launchURL and string.len(launchURL) > 0 then
		local res = UrlParser:parseUrlScheme(launchURL)
		if not res.method or string.lower(res.method) ~= "addfriend" then return end
		if res.para and res.para.invitecode and res.para.uid then
			local function onSuccess()
				local home = HomeScene:sharedInstance()
				if home and not home.isDisposed then
					home:checkDataChange()
					if home.coinButton and not home.coinButton.isDisposed then
					home.coinButton:updateView()
				end
				end
				CommonTip:showTip(Localization:getInstance():getText("url.scheme.add.friend"), "positive")
			end
			local function onUserHasLogin()
				local logic = InvitedAndRewardLogic:create(false)
				logic:start(res.para.invitecode, res.para.uid, onSuccess)
			end
			RequireNetworkAlert:callFuncWithLogged(onUserHasLogin, nil, kRequireNetworkAlertAnimation.kNoAnimation)
		end
	end
end

function GamePlaySceneUI:setMoveOrTimeStage(stageNumber)
	self.moveOrTimeCounter:setStageNumber(stageNumber)
end

function GamePlaySceneUI:promptBackProp()
	-- 把回退道具拖到屏幕中间，然后才去取坐标
	self.propList.controller:onTouchMove({globalPosition = ccp(400, 0)})
	local backProp, index = self.propList:findItemByItemID(10002)
	if not backProp then return end
	if not backProp.prop then return end
	if backProp.prop.usedTimes >= backProp.prop.maxUsetime then return end
	print(index, backProp.item:getPositionX(), backProp.item:getPositionY())
	-- local pos = backProp.item:getParent():convertToWorldSpace(backProp.item:getPosition())
	local vs = Director:sharedDirector():getVisibleSize()
	local vo = Director:sharedDirector():getVisibleOrigin()
	local node = CommonSkeletonAnimation:createTutorialMoveIn()
	local scene = Director:sharedDirector():getRunningScene()
	posArmature = ccp(vs.width - 200, vo.y + 250)
	node:setPosition(posArmature)
	scene:addChild(node)
	node:setAnimationScale(0.3)
	backProp.animator:hint(1)
	-- CommonTip:showTip(Localization:getInstance():getText('no.venom.tips'), "positive", nil, 5)
	local builder = InterfaceBuilder:create("flash/scenes/homeScene/homeScene.json")
	-- local tip = builder:buildGroup('homeScene_infiniteEnergyTip')
	local tip = GameGuideRunner:createPanelMini('no.venom.tips')
	-- tip:getChildByName('txt'):setString(Localization:getInstance():getText('no.venom.tips'))
	-- tip:getChildByName('bg'):setScaleX(-1)
	-- tip:getChildByName('bg'):setAnchorPoint(ccp(1, 1))
	local posTip = ccp(vo.x + vs.width / 2 - tip:getGroupBounds().size.width / 2, posArmature.y + 110)
	local tipStartPos = ccp(vs.width + 300, posTip.y)
	tip:setPosition(tipStartPos)
	tip:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCEaseExponentialOut:create(CCMoveTo:create(0.3, posTip))))
	scene:addChild(tip)
	local function remove()
		if node and node.refCocosObj then node:runAction(
				CCSequence:createWithTwoActions(
					CCDelayTime:create(0.5),
					CCCallFunc:create(
						function () 
							if node and node.refCocosObj then 
								node:removeFromParentAndCleanup(true) 
							end 
						end)
				)
			)  
		end
		if tip and tip.refCocosObj then 
			tip:runAction(CCSequence:createWithTwoActions(
				CCEaseExponentialIn:create(CCMoveTo:create(0.3, tipStartPos)),
				CCCallFunc:create(
					function () 
						if tip and tip.refCocosObj then 
							tip:removeFromParentAndCleanup(true) 
						end
					end))
			)  
		end
	end
	setTimeOut(remove, 5)

end

function GamePlaySceneUI:setFireworkEnergy(energy)
	self.propList:setSpringItemEnergy(energy)
end

function GamePlaySceneUI:setFireworkPercent(percent)
	self.propList:setSpringItemPercent(percent)
end

function GamePlaySceneUI:useSpringItemCallback()
	self.gameBoardLogic:useFirecracker()
end

function GamePlaySceneUI:playSpringCollectEffect(itemPosition)
	local targetPosition = self.propList:getSpringItemGlobalPosition()
	local r = 16 + math.random() * 10
	local batch = self
	local localPosition = batch:convertToNodeSpace(itemPosition)
	for i = 1, 20 do	
		if math.random() > 0.6 then
			local angle = i * 36 * 3.1415926 / 180
			local x = localPosition.x + math.cos(angle) * r
			local y = localPosition.y + math.sin(angle) * r
			local sprite = SpriteColorAdjust:createWithSpriteFrameName("game_collect_small_star0000")
			-- sprite:adjustColor(1, 1,-0.05,0.1)
   --      	sprite:applyAdjustColorShader()
			sprite:setPosition(ccp(localPosition.x, localPosition.y))
			sprite:setScale(math.random()*1.5 + 1)
			sprite:setOpacity(0)
			local moveTime = 0.3 + math.random() * 0.64
			local moveTo = CCMoveTo:create(moveTime, ccp(targetPosition.x + math.random(1, 10), targetPosition.y + math.random(1, 10)))
			local function onMoveFinished( ) sprite:removeFromParentAndCleanup(true) end
			local moveIn = CCEaseElasticOut:create(CCMoveTo:create(0.25, ccp(x, y)))
			local array = CCArray:create()
			array:addObject(CCSpawn:createWithTwoActions(moveIn, CCFadeIn:create(0.25)))
			array:addObject(CCEaseSineIn:create(moveTo))
			array:addObject(CCFadeOut:create(0.2))
			array:addObject(CCCallFunc:create(onMoveFinished))
			sprite:runAction(CCSequence:create(array))
			batch:addChild(sprite)
		end
	end
end

function GamePlaySceneUI:tryFirstFullFirework()
	if GameGuide then
		local pos = self.propList:getSpringItemGlobalPosition()
        GameGuide:sharedInstance():tryFirstFullFirework(pos)
    end
end

function GamePlaySceneUI:onShowFullFireworkTip()
	if GameGuide then
		local pos = self.propList:getSpringItemGlobalPosition()
        GameGuide:sharedInstance():onShowFullFireworkTip(pos)
    end
end

function GamePlaySceneUI:playFirstShowFireworkGuide()
	if GameGuide then
        local pos = self.propList:getSpringItemGlobalPosition()
        GameGuide:sharedInstance():onFirstShowFirework(pos)
    end
end

function GamePlaySceneUI:tryFirstQuestionMark(mainLogic)
	if GameGuide then
		GameGuide:sharedInstance():tryFirstQuestionMark(mainLogic)
	end
end

function GamePlaySceneUI:addSquirrelAnimation( ... )
	-- body
	local squirrel = TileSquirrel:create()
	self.otherElementsLayer:addChild(squirrel)
	local toPosition = self.gameBoardLogic:getGameItemPosInView(9, 5)
	squirrel:setPosition(toPosition)
	self.squirrel = squirrel
	self.squirrel.old_c = 5
end

function GamePlaySceneUI:playSquirrelGotAcronAnimation( pos_c )
	-- body
	if self.squirrelGettingAcorn then return end

	self.squirrelGettingAcorn = true
	local function callback( ... )
		-- body
		self.squirrelGettingAcorn = false
	end

	local function actionFunc( ... )
		-- body
		self.squirrel:playGetAnimation(callback)
	end
	self.squirrel:stopAllActions()
	local pos = self.gameBoardLogic:getGameItemPosInView(9, pos_c)
	local action_move = CCMoveTo:create(0.1, pos)
	local action_func = CCCallFunc:create(actionFunc)
	self.squirrel.old_c = pos_c
	self.squirrel:runAction(CCSequence:createWithTwoActions(action_move, action_func))	
end

function GamePlaySceneUI:playSquirrelMoveAnimation( isReachEndCondition )
	-- body
	if self.squirrelGettingAcorn then return end

	local x = self.squirrel:getPositionX()
	local now_c, isDangerous = GameExtandPlayLogic:getSquirrelPosYinBoard(self.gameBoardLogic, self.squirrel.old_c)
	local pos = self.gameBoardLogic:getGameItemPosInView(9, now_c)
	if now_c == self.squirrel.old_c then 
		self.squirrel:playExcitingAnimation(false)
	else
		local function callback( ... )
		-- body
			local random_count = math.random(10)
			if isDangerous or random_count <= 9 then
				self.squirrel:playNormalAnimation()
			else
				self.squirrel:playDozeAnimation()
			end
		end
		self.squirrel.old_c = now_c
		self.squirrel:stopAllActions()
		local time = math.floor(math.abs(x - pos.x) / 70) * 0.6
		local action_delay = CCDelayTime:create(0.2)
		local action_move = CCMoveTo:create(time, pos)
		local action_func = CCCallFunc:create(callback)
		local arr = CCArray:create()
		arr:addObject(action_delay)
		arr:addObject(action_move)
		arr:addObject(action_func)
		self.squirrel:runAction(CCSequence:create(arr))

		self.squirrel:playMoveAnimation()
	end
end

function GamePlaySceneUI:playSquirrelGiveKeyAnimation( callback )
	-- body
	local pos = self.gameBoardLogic:getGameItemPosInView(5, 5)
	local move_to = CCJumpTo:create(0.5, pos, 300, 1)
	local scale_to = CCScaleTo:create(0.5, 1)

	local move_action = CCSpawn:createWithTwoActions(move_to, scale_to)


	local function animationCallback( ... )
		-- body
		self.squirrel:runAction(CCDelayTime:create(0.5), CCCallFunc:create(callback))
		
	end
	local function playAnimation( ... )
		-- body
		self.squirrel:play(callback)
	end

	local pos = self.squirrel:getPosition()
	local x, y = pos.x, pos.y
	self.squirrel:removeFromParentAndCleanup(true)
	local squirrel_2 = TileSquirrelAndKey:create()
	squirrel_2:setPosition(ccp(x, y))
	self.otherElementsLayer:addChild(squirrel_2)
	squirrel_2:play(callback)

	self.squirrel = squirrel_2

	local call_func = CCCallFunc:create(playAnimation)
	self.squirrel:runAction(CCSequence:createWithTwoActions( move_action, call_func))
end

function GamePlaySceneUI:playSquirrelAnimation( ... )
	-- body
	if self.squirrel then 
		self.squirrel:playDozeAnimation()
	end
end