CheckPlayScene = class(GamePlaySceneUI)

CheckPlaySceneEvents = {
	kSwapFail = "CheckPlaySceneEvents.kSwapFail",
}

local CheckPlayCrashListener = nil

function CheckPlayScene:ctor()
	self.isCheckReplayScene = true
	self.isCheckReplay = false
	self.onReplayEndHandler = nil
end

function CheckPlayScene:create(levelId, replayRecords)
	local s = CheckPlayScene.new()
	-- body
	local levelMeta = LevelMapManager.getInstance():getMeta(levelId)
	if not levelMeta then 
		local testConfStr = DevTestLevelMapManager.getInstance():getConfig("test1.json")
		local testConf = table.deserialize(testConfStr)
		testConf.totalLevel = levelId
		LevelMapManager:getInstance():addDevMeta(testConf)
	end
	local levelConfig = LevelDataManager.sharedLevelData():getLevelConfigByID(levelId)

	s:init(levelConfig, replayRecords)
	return s
end

function CheckPlayScene:createWithLevelConfig(levelConfig, replayRecords)
	local s = CheckPlayScene.new()
	s:init(levelConfig, replayRecords)
	return s
end

function CheckPlayScene:init( levelConfig, replayRecords )
	-- body
	assert(levelConfig)
	assert(replayRecords)

	self.replayRecords = replayRecords
	levelConfig.randomSeed = self.replayRecords.randomSeed

	local levelId = levelConfig.level
	local levelType =  LevelType:getLevelTypeByLevelId(levelId) or GameLevelType.kMainLevel
	
	local function callback( ... )
		-- body
		GamePlaySceneUI.init(self, levelId, levelType, replayRecords.selectedItemsData or {}, GamePlaySceneUIType.kReplay)
		self.propList:addFakeAllProp(999)
		self:setReplay()
	end 
	self:loadExtraResource(levelConfig, callback)

	local function onReplayErrorOccurred(evt)
		local errorData = evt and evt.data or nil
		self:onReplayErrorOccurred(CheckPlay.RESULT_ID.kSwapFail, errorData)
	end
	self:ad("replay_error", onReplayErrorOccurred)

	if CheckPlayCrashListener then
		GlobalEventDispatcher:getInstance():removeEventListener("lua_crash", CheckPlayCrashListener)
		CheckPlayCrashListener = nil
	end
	CheckPlayCrashListener = function(evt)
		self:onReplayErrorOccurred(CheckPlay.RESULT_ID.kCrash, {msg="lua_crash"})
	end
	GlobalEventDispatcher:getInstance():addEventListener("lua_crash", CheckPlayCrashListener)
end

function CheckPlayScene:startReplay()
	Director:sharedDirector():pushScene(self)
end

function CheckPlayScene:startCheckReplay()
	self.isCheckReplay = true
	self.onReplayEndHandler = function()

		local function endReplay()
			self:endReplay()
			if self.isCheckReplay and CheckPlay then
				CheckPlay:checkResult(CheckPlay.RESULT_ID.kNotEnd, {})
			end
		end
		setTimeOut(endReplay, 0.1)
		-- self.gameBoardLogic:setGamePlayStatus(GamePlayStatus.kEnd)
	end
	Director:sharedDirector():pushScene(self)
end

function CheckPlayScene:loadExtraResource( levelConfig, callback )
	-- body
	local fileList = levelConfig:getDependingSpecialAssetsList()
	self.fileList = fileList
	local loader = FrameLoader.new()
	local function callback_afterResourceLoader()
		loader:removeAllEventListeners()
		callback()
	end
	for i,v in ipairs(fileList) do loader:add(v, kFrameLoaderType.plist) end
	loader:addEventListener(Events.kComplete, callback_afterResourceLoader)
	loader:load()
end

function CheckPlayScene:usePropCallback(propId, usePropType, isRequireConfirm, ...)
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

function CheckPlayScene:confirmPropUsed(pos, successCallback)

	-- Previous Must Recorded The Used Prop
	assert(self.needConfirmPropId)

	-- Send Server User This Prop Message
	local function onUsePropSuccess()
		self.propList:confirm(self.needConfirmPropId, pos)
		self.needConfirmPropId 			= false
		self.useItem = true
		if successCallback and type(successCallback) == 'function' then
			successCallback()
		end
	end
	onUsePropSuccess()
end

function CheckPlayScene:checkPropEnough(usePropType, propId)
	return true
end

function CheckPlayScene:addTmpPropNum( ... )
	-- body
	-- self.propList:addFakeAllProp(999)
end

function CheckPlayScene:setReplay( )
	-- body
	local records = self.replayRecords
	self.gameBoardLogic.replaySteps = records.replaySteps
	self.gameBoardLogic:ReplayStart()
	self.gameBoardLogic:onGameInit()
	self.gameBoardLogic:setWriteReplayOff()
end

function CheckPlayScene:onPauseBtnTapped(...)
	assert(#{...} == 0)
	self:pause()
	local function onQuitCallback()
		self:endReplay()
	end

	local function onClosePanelBtnTappedCallback()
		self.quitDcData = nil
		self:continue()
		if self.quitDcData then self.quitDcData = nil end
	end

	local function onReplayCallback()
		onQuitCallback()
		local scene = CheckPlayScene:create(self.levelId, self.replayRecords)
		scene:startReplay()
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

function CheckPlayScene:passLevel(levelId, score, star, stageTime, coin, targetCount, opLog, bossCount, ...)
	self:replayResult(levelId, score, star, coin, targetCount, bossCount)
end

function CheckPlayScene:failLevel(levelId, score, star, stageTime, coin, targetCount, opLog, isTargetReached, failReason, ...)
	self:replayResult(levelId, score, star, coin, targetCount, bossCount)
end

function CheckPlayScene:onReplayErrorOccurred(errorId, error)
	print(">> onReplayErrorOccurred:", table.tostring(error))
	if self.isCheckReplay then
		self.gameBoardLogic.replayError = error
		local function endReplay()
			self:endReplay()
			if self.isCheckReplay and CheckPlay then
				CheckPlay:checkResult(errorId, {})
			end
		end
		setTimeOut(endReplay, 0.1)
	end
end

function CheckPlayScene:endReplay()
	local runningScene = Director:sharedDirector():getRunningScene()
	if runningScene == self then
		if __use_low_effect then 
			FrameLoader:unloadImageWithPlists(self.fileList, true)
		end
		Director:sharedDirector():popScene()
	end
end

function CheckPlayScene:onReplayEnd()
	if type(self.onReplayEndHandler) == "function" then
		self.onReplayEndHandler()
	end
end

function CheckPlayScene:replayResult( levelId, score, star, coin, targetCount, bossCount )
	local ret = {}
	ret.levelId = levelId
	ret.totalScore = score
	ret.star = star
	ret.coin = coin
	ret.bossCount = bossCount or 0
	ret.targetCount = targetCount or 0

	print("=====================Check Play Result=====================")
	print(table.tostring(ret))
	print("===========================================================")

	local function endReplay()
		self:endReplay()

		if self.isCheckReplay and CheckPlay then
			CheckPlay:checkResult(CheckPlay.RESULT_ID.kSuccess, ret)
		end
	end
	setTimeOut(endReplay, 0.1)
end

function CheckPlayScene:addStep(levelId, score, star, isTargetReached, isAddStepCallback, ...)
	
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
function CheckPlayScene:showAddTimePanel(levelId, score, star, isTargetReached, addTimeCallback, ...)
	self:addStep(levelId, score, star, isTargetReached, addTimeCallback)
end

-------------------------
--显示加兔兔导弹面板
-------------------------
function CheckPlayScene:showAddRabbitMissilePanel( levelId, score, star, isTargetReached, isAddPropCallback )
	-- body
	self:addStep( levelId, score, star, isTargetReached, isAddPropCallback)
end

function CheckPlayScene:addTemporaryItem(itemId, itemNum, fromGlobalPosition, ...)
	self.propList:addTemporaryItem(itemId, itemNum, fromGlobalPosition)
end

function CheckPlayScene:dispose()
	if CheckPlayCrashListener then
		GlobalEventDispatcher:getInstance():removeEventListener("lua_crash", CheckPlayCrashListener)
		CheckPlayCrashListener = nil
	end
	GamePlaySceneUI.dispose(self)
end