require "hecore.display.TextField"

require "zoo.scenes.GamePlayScene"
require "zoo.config.LevelConfig"
require "zoo.data.DevTestLevelMapManager"
require "zoo.scenes.DevTestGamePlayScene"
require "zoo.editor.EditorStartPanel"

local isTestMode = true
local curEditorGameScene
local levelConfigFromAceEditor

local EditorResDic = {"flash/hedgehog_road.png","ui/HalloweenPumpkin.json","ui/HalloweenPumpkin.png", "flash/halloween_2015.png"}
local EditorSkeletonResDic = {"skeleton/christmas_animation", "skeleton/wukong_animation"}
local simplejson = require("cjson")

local recordUrl = "http://10.130.137.97/animal-new-fc/editor.action?method=record&"  -- 存试玩数据地址


----------编辑器关卡内------------------------------EditorGamePlayScene-----------------------------------
local EDITOR_PLAY_RESULT = {
	QUIT = -1,
	SUCCESS = 1,
	FAIL = 0
}

EditorGamePlayScene = class(DevTestGamePlayScene)

function EditorGamePlayScene:create(levelId, levelType, selectedItemsData)
	local scene = EditorGamePlayScene.new()
	scene:init(levelId, levelType, selectedItemsData)
	return scene
end

function EditorGamePlayScene:init( levelId, levelType, selectedItemsData )
	DevTestGamePlayScene.init(self, levelId, levelType, selectedItemsData)
	self.editorPrePropsList = selectedItemsData or {}
end

function EditorGamePlayScene:addUsePropInfo(propID)
	self.propsList[#self.propsList + 1] = propID
end

function EditorGamePlayScene:sendResultData(data)
	local request = HttpRequest:createPost(recordUrl)
	local requestData = "data=" .. simplejson.encode(data)
	request:setPostData(requestData, #requestData)
	local function onCallback(response)
		if response.httpCode and response.httpCode == 200 then
			if response.errorCode == 0 then
				self:onRecordSuccess()
			else
				self:onRecordFail()
			end
		else
			self:onRecordFail()
		end
	end
	HttpClient:getInstance():sendRequest(onCallback, request)
end

function EditorGamePlayScene:onQuitLevel()
	if levelConfigFromAceEditor ~= nil and levelConfigFromAceEditor.record then
		local recordData = self:getRecordData()
		recordData["result"] = EDITOR_PLAY_RESULT.QUIT
		recordData["targetCount"] = 0
		self:sendResultData(recordData)
	end

	DevTestGamePlayScene.onQuitLevel(self)
end

function EditorGamePlayScene:onRecordSuccess()
	CommonTip:showTip("试玩数据保存成功", "positive")
end

function EditorGamePlayScene:onRecordFail()
	CommonTip:showTip("试玩数据保存失败！！！！！", "positive")
end

function EditorGamePlayScene:getRecordData()
	local gameBoardLogic = self.gameBoardLogic
	
	local d = {}
	d["levelUUId"] = levelConfigFromAceEditor.uuID
	d["user"] = levelConfigFromAceEditor.user
	d["gameVersion"] = levelConfigFromAceEditor.version
	d["score"] = gameBoardLogic.totalScore
	d["star"] = gameBoardLogic.gameMode:getScoreStarLevel()
	d["step"] = gameBoardLogic.realCostMove
	d["leftStep"] = gameBoardLogic.leftMoveToWin
	if #self.editorPrePropsList > 0 then
		d["prePropsList"] = {}
		for i=1, #self.editorPrePropsList do
			d["prePropsList"][#d["prePropsList"] + 1] = self.editorPrePropsList[i].id
		end
	end
	if #curEditorGameScene.propsList > 0 then
		d["propsList"] = curEditorGameScene.propsList
	end
	print(table.tostring(d))
	return d
end

function EditorGamePlayScene:failLevel(levelId, score, star, stageTime, coin, targetCount, opLog, isTargetReached, failReason, ...)
	if levelConfigFromAceEditor ~= nil and levelConfigFromAceEditor.record then
		local recordData = self:getRecordData()
		recordData["result"] = EDITOR_PLAY_RESULT.FAIL
		recordData["targetCount"] = targetCount
		self:sendResultData(recordData)
	end
	
	DevTestGamePlayScene.failLevel(self, levelId, score, star, stageTime, coin, targetCount, opLog, isTargetReached, failReason, ...)
end

function EditorGamePlayScene:passLevel(levelId, score, star, stageTime, coin, targetCount, opLog, bossCount, ...)
	if levelConfigFromAceEditor ~= nil and levelConfigFromAceEditor.record then
		local recordData = self:getRecordData()
		recordData["result"] = EDITOR_PLAY_RESULT.SUCCESS
		recordData["targetCount"] = targetCount
		self:sendResultData(recordData)
	end

	DevTestGamePlayScene.passLevel(self, levelId, score, star, stageTime, coin, targetCount, opLog, bossCount, ...)
end


----------编辑器关卡外------------------------------EditorGameScene----------------------------------------
local EditorGameScene = class(Scene)
function EditorGameScene:ctor()
	self.backButton = nil
	self.propsList = {}
end

function EditorGameScene:__getDependingSpecialAssetsList(levelConfig)
	local gameMode = levelConfig.gameMode
	local fileList = {}
	fileList = levelConfig:getDependingSpecialAssetsList() or {}
	local toReplace

	if gameMode == AnimalGameMode.kHalloween then
		toReplace = {"flash/add_five_step_ani.plist", "flash/halloween_2015.plist", "flash/boss_pumpkin.plist", 
					 "flash/boss_pumpkin_die.plist", "flash/boss_pumpkin_ghost_1.plist", "flash/boss_pumpkin_ghost_2.plist"}
	elseif gameMode == AnimalGameMode.kHedgehogDigEndless then
		toReplace = {"flash/hedgehog.plist","flash/hedgehog_road.plist","flash/hedgehog_target.plist","flash/christmas_other.plist", }
	elseif gameMode == AnimalGameMode.kWukongDigEndless then
	end

	if toReplace ~= nil and #toReplace > 0 then
		for i=1,#toReplace do
			local idx = table.indexOf(fileList, toReplace[i])
			if idx ~= nil then
				fileList[idx] = "editorRes/" .. fileList[idx]
			end
		end
	end

	return fileList
end

function EditorGameScene:dispose()
	if self.backButton then self.backButton:removeAllEventListeners() end
	self.backButton = nil
	_G.useDropBuffByEditor = false
	self:assetLoadFallBack()
	Scene.dispose(self)
	curEditorGameScene = nil
end

function EditorGameScene:create()
	local s = EditorGameScene.new()
	s:initScene()
	return s
end

function EditorGameScene:onInit()
	self:assetLoadByEditor()
	self:initDevTestLevel()
end

local backSpriteUtilGetRealResourceName
local backFrameLoaderGetRealResourceName
local backInterfaceBuilderGetRealResourceName

function EditorGameScene:assetLoadByEditor()
	if backSpriteUtilGetRealResourceName == nil then
		backSpriteUtilGetRealResourceName = SpriteUtil.getRealResourceName 
		local function tempSpriteUtilGetRealResourceName( _, fileName )
			if table.indexOf(EditorResDic, fileName) ~= nil then
				fileName = "editorRes/" .. fileName
			end

		    return backSpriteUtilGetRealResourceName(_, fileName)
		end

		SpriteUtil.getRealResourceName = tempSpriteUtilGetRealResourceName

		backFrameLoaderGetRealResourceName = FrameLoader.getRealResourceName
		local function tempFrameLoaderGetRealResourceName( _, fileName )
			if table.indexOf(EditorSkeletonResDic, fileName) ~= nil then
				fileName = "editorRes/" .. fileName
				return fileName
			end
			return backFrameLoaderGetRealResourceName(_, fileName)
		end
		FrameLoader.getRealResourceName = tempFrameLoaderGetRealResourceName

		backInterfaceBuilderGetRealResourceName = InterfaceBuilder.getRealResourceName
		local function tempInterfaceBuilderGetRealResourceName( _, fileName )
			if table.indexOf(EditorResDic, fileName) ~= nil then
				fileName = "editorRes/" .. fileName
			end
		    return backInterfaceBuilderGetRealResourceName(_, fileName)
		end

		InterfaceBuilder.getRealResourceName = tempInterfaceBuilderGetRealResourceName
	end
end

function EditorGameScene:assetLoadFallBack()
	SpriteUtil.getRealResourceName = backSpriteUtilGetRealResourceName
	backSpriteUtilGetRealResourceName = nil

	FrameLoader.getRealResourceName = backFrameLoaderGetRealResourceName
	backFrameLoaderGetRealResourceName = nil

	InterfaceBuilder.getRealResourceName = backInterfaceBuilderGetRealResourceName
	backInterfaceBuilderGetRealResourceName = nil
end

local testLevelId = nil
function EditorGameScene:initDevTestLevel()
	local testConfStr = levelConfigFromAceEditor
	local testData = table.deserialize(testConfStr)
	levelConfigFromAceEditor = testData
	local testConf = testData.levelCfg
	local useDropBuff = testData.useDropBuff
	_G.useDropBuffByEditor = useDropBuff
	testLevelId = testConf.totalLevel

	if not testLevelId then 
		testLevelId = LevelMapManager:getInstance():getMaxLevelId() + 1
	end
	testConf.totalLevel = testLevelId
	testConf.uuID = testConf.id
	levelConfigFromAceEditor.uuID = testConf.id
	local levelType = LevelType:getLevelTypeByLevelId(testConf.totalLevel) or GameLevelType.kMainLevel
	LevelMapManager:getInstance():addDevMeta(testConf)
	local levelMeta = LevelMapManager.getInstance():getMeta(testConf.totalLevel)
	local levelConfig = LevelConfig:create(testConf.totalLevel, levelMeta)
	LevelDataManager.sharedLevelData().levelDatas[testConf.totalLevel] = levelConfig
    local fileList = self:__getDependingSpecialAssetsList(levelConfig)
    print("fileList",fileList)
    local loader = FrameLoader.new()
    local function onFrameLoadComplete( evt )
        loader:removeAllEventListeners()
        local function pushNewScene()
        	if _G.__editorStartPanel ~= nil then 
        		self:removeChild(_G.__editorStartPanel) 
        	end
        	-- debug.debug()
        	local status, result = pcall(function() _G.__editorStartPanel = EditorStartPanel:create(self, testLevelId, levelType, false) end)
        	 if status then
        	 	if _G.__editorStartPanel ~= nil then
   					_G.__editorStartPanel:setPosition(ccp(0, 1300))
   					self:addChild(_G.__editorStartPanel)
   				else
   				end
             else
        		local devTestGPS = EditorGamePlayScene:create(testLevelId, levelType, {})
    			self.devTestGPS = devTestGPS
    			devTestGPS.fileList = fileList
    			self:addChild(devTestGPS)

    			_G.currentEditorLevelScene = devTestGPS
        	 end

   			
        end
       
        AsyncLoader:getInstance():waitingForLoadComplete(pushNewScene)
    end 
   
    for i,v in ipairs(fileList) do loader:add(v, kFrameLoaderType.plist) end
    loader:addEventListener(Events.kComplete, onFrameLoadComplete)
    loader:load()

end

function EditorGameScene:addEditorRecordPropsInfo(itemID)
	self.propsList[#self.propsList + 1] = itemID
end

-- -- TEST PENG 
-- 给编辑器调用的开始游戏方法
function editorStartGame(dataCfg)
	levelConfigFromAceEditor = dataCfg
	if curEditorGameScene == Director:sharedDirector():run() then
		Director:sharedDirector():pop(true)
		curEditorGameScene = nil
	end
	curEditorGameScene = EditorGameScene:create()
	Director:sharedDirector():pushScene(curEditorGameScene) 
	return true
end

