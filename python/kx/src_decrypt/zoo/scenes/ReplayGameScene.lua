ReplayGameScene = class(GamePlaySceneUI)
function ReplayGameScene:create(levelId, replayRecords)
	local s = ReplayGameScene.new()
	s:init(levelId, replayRecords)
	return s
end

function ReplayGameScene:loadExtraResource( levelId, callback )
	-- body
	local levelMeta = LevelMapManager.getInstance():getMeta(levelId)
	if not levelMeta then 
		local testConfStr = DevTestLevelMapManager.getInstance():getConfig("test1.json")
		local testConf = table.deserialize(testConfStr)
		testConf.totalLevel = levelId
		LevelMapManager:getInstance():addDevMeta(testConf)
	end
	local levelConfig = LevelDataManager.sharedLevelData():getLevelConfigByID(levelId)
	levelConfig.randomSeed = self.replayRecords.randomSeed
	local fileList = levelConfig:getDependingSpecialAssetsList()
	local loader = FrameLoader.new()
	local function callback_afterResourceLoader()
		loader:removeAllEventListeners()
		callback()
	end
	for i,v in ipairs(fileList) do loader:add(v, kFrameLoaderType.plist) end
	loader:addEventListener(Events.kComplete, callback_afterResourceLoader)
	loader:load()
end

function ReplayGameScene:usePropCallback(propId, usePropType, isRequireConfirm, ...)
	self.usePropType = usePropType

	local realItemId = propId
	if self.usePropType == UsePropsType.EXPIRE then  realItemId = ItemType:getRealIdByTimePropId(propId) end
	
	if not isRequireConfirm then -- use directly
		local function sendUseMsgSuccessCallback()
			self.propList:confirm(propId)
			self.gameBoardView:useProp(realItemId, isRequireConfirm)
			self.useItem = true
		end
		sendUseMsgSuccessCallback()
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

function ReplayGameScene:confirmPropUsed(pos, ...)

	-- Previous Must Recorded The Used Prop
	assert(self.needConfirmPropId)

	-- Send Server User This Prop Message
	local function onUsePropSuccess()
		self.propList:confirm(self.needConfirmPropId, pos)
		self.needConfirmPropId 			= false
		-- self.needConfirmPropIsTempProperty 	= false
		self.useItem = true
	end
	onUsePropSuccess()
end

function ReplayGameScene:checkPropEnough(usePropType, propId)
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
		return true
	end

	return false
end

function ReplayGameScene:addTmpPropNum( ... )
	-- body
	self.propList:addFakeAllProp(999)
end

function ReplayGameScene:init( levelId, replayRecords )
	-- body
	self.replayRecords = replayRecords
	levelType =  LevelType:getLevelTypeByLevelId(levelId) or GameLevelType.kMainLevel
	
	local function callback( ... )
		-- body
		GamePlaySceneUI.init(self, levelId, levelType, replayRecords.selectedItemsData or {}, GamePlaySceneUIType.kReplay)
		self.propList:addFakeAllProp(999)
		self:setReplay()
	end 
	self:loadExtraResource(levelId, callback)
end

function ReplayGameScene:setReplay( )
	-- body
	local records = self.replayRecords
	self.gameBoardLogic.replaySteps = records.replaySteps
	self.gameBoardLogic:ReplayStart()
	self.gameBoardLogic:onGameInit()
	self.gameBoardLogic:setWriteReplayOff()
end

function ReplayGameScene:onPauseBtnTapped(...)
	assert(#{...} == 0)
	self:pause()
	local function onQuitCallback()
		if __use_low_effect then 
			FrameLoader:unloadImageWithPlists(self.fileList, true)
		end
		Director:sharedDirector():popScene()
	end

	local function onClosePanelBtnTappedCallback()
		self.quitDcData = nil
		self:continue()
		if self.quitDcData then self.quitDcData = nil end
	end

	local function onReplayCallback()
		onQuitCallback()
		local scene = ReplayGameScene:create(self.levelId, self.replayRecords)
		Director:sharedDirector():pushScene(scene)
	end

	local mode = QuitPanelMode.QUIT_LEVEL
	if self.levelType == GameLevelType.kMayDay then
		mode = QuitPanelMode.NO_REPLAY
	end
	local quitPanel = QuitPanel:create(mode)
	quitPanel:setOnReplayBtnTappedCallback(onReplayCallback)
	quitPanel:setOnQuitGameBtnTappedCallback(onQuitCallback)
	quitPanel:setOnClosePanelBtnTapped(onClosePanelBtnTappedCallback)
	PopoutManager:sharedInstance():add(quitPanel, false, false)
end

function ReplayGameScene:passLevel(levelId, score, star, stageTime, coin, targetCount, opLog, bossCount, ...)
	self:replayEnd()
end

function ReplayGameScene:failLevel(levelId, score, star, stageTime, coin, targetCount, opLog, isTargetReached, failReason, ...)
	self:replayEnd()
end

function ReplayGameScene:replayEnd( ... )
	-- body
	local function onQuitCallback()
		if __use_low_effect then 
			FrameLoader:unloadImageWithPlists(self.fileList, true)
		end
		Director:sharedDirector():popScene()
	end

	local function onReplayCallback()
		onQuitCallback()
		local scene = ReplayGameScene:create(self.levelId, self.replayRecords)
		Director:sharedDirector():pushScene(scene)
	end

	local mode = QuitPanelMode.QUIT_LEVEL
	if self.levelType == GameLevelType.kMayDay then
		mode = QuitPanelMode.NO_REPLAY
	end
	local quitPanel = QuitPanel:create(mode)
	quitPanel:setOnReplayBtnTappedCallback(onReplayCallback)
	quitPanel:setOnQuitGameBtnTappedCallback(onQuitCallback)
	quitPanel:setOnClosePanelBtnTapped(onQuitCallback)
	PopoutManager:sharedInstance():add(quitPanel, false, false)
end

function ReplayGameScene:addStep(levelId, score, star, isTargetReached, isAddStepCallback, ...)
	
	local scheduleId 
	local function callback( ... )
		-- body
		if scheduleId then 
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scheduleId)
		end

		if self.gameBoardLogic.replayStep <= #self.gameBoardLogic.replaySteps then 
			isAddStepCallback(true)
			self:setPauseBtnEnable(true)
		else
			isAddStepCallback(false)
		end
	end
	scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(callback, 0, false)
end

-------------------------
--显示加时间面板
-------------------------
function ReplayGameScene:showAddTimePanel(levelId, score, star, isTargetReached, addTimeCallback, ...)
	self:addStep(levelId, score, star, isTargetReached, addTimeCallback)
end

-------------------------
--显示加兔兔导弹面板
-------------------------
function ReplayGameScene:showAddRabbitMissilePanel( levelId, score, star, isTargetReached, isAddPropCallback )
	-- body
	self:addStep( levelId, score, star, isTargetReached, isAddPropCallback)
end

function ReplayGameScene:addTemporaryItem(itemId, itemNum, fromGlobalPosition, ...)
	self.propList:addTemporaryItem(itemId, itemNum, fromGlobalPosition)
end