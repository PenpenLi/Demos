-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê10ÔÂ28ÈÕ  19:18:09
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- StartLevelLogic
---------------------------------------------------
StartLevelLogic = class()

-----------------------------------------------
-- startGameDelegate(Delegate) 所有方法均为optional
-- Delegate:onStartLevelLogicSuccess()
-- Delegate:onStartLevelLogicFailed(err)
-- Delegate:onEnergyNotEnough()		精力不足的处理
-- Delegate:playEnergyAnim(onAnimFinish, selectedItemsData) 播放精力消耗的动画
-- Delegate:onWillEnterPlayScene()	进入GamePlayScene之前执行的逻辑
-- Delegate:onDidEnterPlayScene(gamePlayScene)	进入GamePlayScene之后执行的逻辑
---------
-- notConsumeEnergy 是否消耗精力
-----------------------------------------------
function StartLevelLogic:init(startGameDelegate, levelId, levelType, itemList, notConsumeEnergy, ...)
	self.levelId		= levelId
	self.levelType		= levelType
	self.itemList		= itemList
	self.useInfiniteEnergy 	= false
	--处理可能相关的召回关卡需求
	self:pocessRecall()

	self.notConsumeEnergy = notConsumeEnergy
	self.delegate = startGameDelegate or {}
end

function StartLevelLogic:pocessRecall()
	if RecallManager.getInstance():getRecallLevelState(self.levelId) then
		local winSize = CCDirector:sharedDirector():getWinSize()
		for i,v in ipairs(RecallManager.getInstance():getRecallItems()) do
			local itemData = {}
			itemData.id = v
			itemData.destXInWorldSpace = winSize.width/2 
			itemData.destYInWorldSpace = winSize.height/2
			itemData.isForRecall = true

			if not self:checkRecallItemDuplicate(v) then
				table.insert(self.itemList,itemData)
			end
		end
	end
end

function StartLevelLogic:checkRecallItemDuplicate(itemId)
	if self.itemList then 
		for i,v in ipairs(self.itemList) do
			if v.id == itemId then 
				return true
			end
		end
	end
	return false
end

function StartLevelLogic:create(startGameDelegate, levelId, levelType, itemList, notConsumeEnergy, ...)
	assert(startGameDelegate ~= nil)
	assert(type(levelId) == "number")
	assert(type(levelType) == "number")
	assert(type(itemList) == "table")
	assert(#{...} == 0)

	local newStartLevelLogic = StartLevelLogic.new()
	newStartLevelLogic:init(startGameDelegate, levelId, levelType, itemList, notConsumeEnergy)
	return newStartLevelLogic
end

function StartLevelLogic:start(popWaitTip, ...)
	print("type:" .. type(popWaitTip))
	assert(type(popWaitTip) == "boolean")
	assert(#{...} == 0)

	-- -------------
	-- Check Energy
	-- ------------
	if self.notConsumeEnergy then -- don't need energy
		self:startLevelWithoutEnergy(popWaitTip)
		return
	end

	-- Get Energy State
	local energyState = UserEnergyRecoverManager:sharedInstance():getEnergyState()
	if energyState == UserEnergyState.INFINITE then
		self.useInfiniteEnergy = true
		self:startLevelWithoutEnergy(popWaitTip)
	elseif energyState == UserEnergyState.COUNT_DOWN_TO_RECOVER then
		self.useInfiniteEnergy = false
		self:startLevelWithEnergy(popWaitTip)
	else
		assert(false)
	end
end

function StartLevelLogic:startLevelWithoutEnergy( popWaitTip )
	local function sendStartLevelMessage(callback)
		self:sendStartLevelMessage(popWaitTip, callback)
	end

	-- On Success
	local function onSendStartLevelMsgSuccess()
		self:onSendStartLevelMsgSuccess()
	end

	local chain = CallbackChain:create()
	chain:appendFunc(sendStartLevelMessage)
	chain:appendFunc(onSendStartLevelMsgSuccess)
	chain:call()
end

function StartLevelLogic:startLevelWithEnergy( popWaitTip )
	local energyConsumedPerLevel = MetaManager.getInstance().global.user_energy_level_consume
	assert(energyConsumedPerLevel)

	UserManager:getInstance():refreshEnergy()
	local curEnergy = UserManager.getInstance().user:getEnergy()
	assert(curEnergy)

	if curEnergy < energyConsumedPerLevel then
		-- Energy Is Not Enough
		if self.delegate.onEnergyNotEnough then
			self.delegate:onEnergyNotEnough()
		end
	else
		-- Send Server Start Level Message
		local function sendStartLevelMessage(callback)
			self:sendStartLevelMessage(popWaitTip, callback)
		end

		-- On Success
		local function onSendStartLevelMsgSuccess()
			-- Subtract The Energy
			local newEnergy = curEnergy - energyConsumedPerLevel
			UserManager.getInstance().user:setEnergy(newEnergy)

			self:onSendStartLevelMsgSuccess()
		end

		local chain = CallbackChain:create()
		chain:appendFunc(sendStartLevelMessage)
		chain:appendFunc(onSendStartLevelMsgSuccess)
		chain:call()
	end
end

function StartLevelLogic:onSendStartLevelMsgSuccess()
	if self.delegate.onStartLevelLogicSuccess then
		self.delegate:onStartLevelLogicSuccess(self.useInfiniteEnergy)
	end	

	if not self.useInfiniteEnergy and self.delegate.playEnergyAnim then
		local function onEnergyConsumeAnimFinish()
			self:startGamePlayScene()
		end
		self.delegate:playEnergyAnim(onEnergyConsumeAnimFinish, self.itemList)
	else
		self:startGamePlayScene()
	end
end

function StartLevelLogic:sendStartLevelMessage(popWaitTip, onSuccessCallback, ...)
	assert(type(onSuccessCallback) == "function")
	assert(#{...} == 0)

	local levelId	= self.levelId
	local useInfiniteEnergy = self.useInfiniteEnergy
	local selectedItemIds = {}

	if self.itemList then
		--推送召回功能特殊处理
		local itemTable = {}
		if RecallManager.getInstance():getRecallLevelState(self.levelId) then
			for k,v in pairs(self.itemList) do
				if not v.isForRecall then 
					table.insert(itemTable,v)
				end
			end
		else
			itemTable = self.itemList
		end

		for k,v in pairs(itemTable) do
			table.insert(selectedItemIds, v.id)
		end
	end

	local function onSuccess()
		if onSuccessCallback then onSuccessCallback() end
	end

	local function onFailed(event)
		assert(event)
		assert(event.name == Events.kError)

		local err = event.data

		local errorMessage = "LevelInfoPanel:sendStartLevelMessage Failed !!\n"
		errorMessage = "errorMessage:" .. err
		print(errorMessage)
		
		if self.delegate.onStartLevelLogicFailed then
			self.delegate:onStartLevelLogicFailed(err)
		end
	end

	local http = StartLevelHttp.new(popWaitTip)
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFailed)
	--http:addEventListener(Events.kError, onSuccess)
	
	http:load(levelId, selectedItemIds, useInfiniteEnergy, self.levelType)
end

function StartLevelLogic:createGamePlayScene(fileList)
	local runningScene = Director:sharedDirector():getRunningScene()
	if runningScene.name == "GamePlaySceneUI" then
		runningScene.disposResourceCache = false
		Director:sharedDirector():popScene(true)
	end

	local selectedItemsData = self.itemList or {}
	local gamePlayScene	= GamePlaySceneUI:create(self.levelId, self.levelType, selectedItemsData)
	assert(gamePlayScene)
	gamePlayScene.fileList = fileList

	Director:sharedDirector():pushScene(gamePlayScene)

    if self.delegate.onDidEnterPlayScene then 
    	self.delegate:onDidEnterPlayScene(gamePlayScene)
    end
    --clear share data 
    if ShareManager then
    	ShareManager:cleanData()
    end
end

function StartLevelLogic:loadLevelConfig(onLoadFinish)
	local levelConfig = LevelDataManager.sharedLevelData():getLevelConfigByID(self.levelId)
	local fileList = levelConfig:getDependingSpecialAssetsList()
	
	local loader = FrameLoader.new()
	local function onFrameLoadComplete( evt )
		loader:removeAllEventListeners()
		if onLoadFinish then onLoadFinish(fileList) end
	end 
   
	for i,v in ipairs(fileList) do loader:add(v, kFrameLoaderType.plist) end
	loader:addEventListener(Events.kComplete, onFrameLoadComplete)
	loader:load()
end

function StartLevelLogic:startGamePlayScene()
	local function onLevelConfigLoadFinish(fileList)
        if self.delegate.onWillEnterPlayScene then 
        	self.delegate:onWillEnterPlayScene()
        end
        self:createGamePlayScene(fileList)
    end
    
    self:loadLevelConfig(onLevelConfigLoadFinish)
end
