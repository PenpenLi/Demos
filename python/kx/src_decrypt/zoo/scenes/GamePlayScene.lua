require "hecore.display.TextField"
require "zoo.config.LevelConfig"

require "zoo.gamePlay.GameBoardLogic"
require "zoo.gamePlay.GameBoardView"
require "zoo.gamePlay.GamePlayConfig"

GamePlayScene = class(Scene)
function GamePlayScene:ctor()
	self.backButton = nil
	self.replayButton = nil
	self.replayMode = false
	self.gamelevel = 0;

	self.mygameboardlogic = nil;
	self.mygameboardview = nil;
	self.clippingnode = nil
	self.initScheduler = nil;
end
function GamePlayScene:dispose()
	if self.playSceneUIType == GamePlaySceneUIType.kNormal and (not isLocalDevelopMode) then
		self.mygameboardlogic:WriteReplay("test.rep")
	end
	if self.mygameboardlogic then self.mygameboardlogic:dispose() end
	if self.backButton then self.backButton:removeAllEventListeners() end
	if self.replayButton then self.replayButton:removeAllEventListeners() end
	self.backButton = nil
	self.replayButton = nil
	self.gamelevel = nil

	self.mygameboardlogic = nil;
	self.mygameboardview = nil;
	self.clippingnode = nil
	self.initScheduler = nil;
	Scene.dispose(self)
end

function GamePlayScene:create(level, playSceneUIType)
	local s = GamePlayScene.new()
	s.gamelevel = level;
	s.playSceneUIType = playSceneUIType
	s:initScene()
	return s
end

function GamePlayScene:onInit()
	local winSize = CCDirector:sharedDirector():getWinSize()
	CommonEffect:reset()

	local context = self
	local function onGameReplay(evt)
		local levelconfig = LevelDataManager.sharedLevelData():getLevelConfigByID(self.mygameboardlogic.level)
		self.mygameboardlogic:ReplayStart(levelconfig)
		self.mygameboardview:reInitByGameBoardLogic(self.mygameboardlogic);
	end
	
	local function buildLabelButton( label, x, y, func )
		local width = 250
		local height = 80
		local labelLayer = LayerColor:create()
		labelLayer:changeWidthAndHeight(width, height)
		labelLayer:setColor(ccc3(255, 0, 0))
		labelLayer:setPosition(ccp(x - width / 2, y - height / 2))
		labelLayer:setTouchEnabled(true, p, true)
		labelLayer:addEventListener(DisplayEvents.kTouchTap, func)
		self:addChild(labelLayer)

		local textLabel = TextField:create(label, nil, 32)
		textLabel:setPosition(ccp(width/2, height/2))
		textLabel:setAnchorPoint(ccp(0,0))
		labelLayer:addChild(textLabel)

		return labelLayer
	end 

	print("after create button",os.date())
	local levelconfig = LevelDataManager.sharedLevelData():getLevelConfigByID(self.gamelevel);
	if GameGuide and self.playSceneUIType and self.playSceneUIType == GamePlaySceneUIType.kNormal then
		levelconfig.randomSeed = GameGuide:sharedInstance():onGameInit(self.gamelevel)
	end
	self.mygameboardlogic = GameBoardLogic:create();
	self.mygameboardlogic:initByConfig(self.gamelevel, levelconfig);
	--获取处理完之后的map，进行view的初始化
	local pos, width, height
	self.mygameboardview, pos, width, height = GameBoardView:createByGameBoardLogic(self.mygameboardlogic)
	self:addChild(self.mygameboardview)
	he_log_info("auto_test_enter_play_scene")
end

-- function GamePlayScene:setReplay(table)
-- 	self.replayMode = true
-- 	local levelconfig = LevelDataManager.sharedLevelData():getLevelConfigByID(self.mygameboardlogic.level)
-- 	self.mygameboardlogic.randomSeed = table.randomSeed
-- 	self.mygameboardlogic.replaySteps = table.replaySteps
-- 	self.mygameboardlogic:ReplayStart(levelconfig)
-- 	self.mygameboardview:reInitByGameBoardLogic(self.mygameboardlogic);
-- end

function GamePlayScene:getGameBoardLogic(...)
	assert(#{...} == 0)

	return self.mygameboardlogic
end

-------初始化整个游戏---进入暂时暂停的状态
function GamePlayScene:setGameInit()
	local context = self;

	local function _updateGame(dt)
		context:_Inner_GameInit()
	end
	local time_cd = 0
	self.initScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(_updateGame, time_cd, false)
end

function GamePlayScene:_Inner_GameInit()	
	if self.mygameboardlogic then
		self.mygameboardlogic.isWaitingOperation = false;
	end
	if self.mygameboardview then
		self.mygameboardview.isPaused = true;
	end
	Director:getScheduler():unscheduleScriptEntry(self.initScheduler)
end

function GamePlayScene:setGameStop()
	if self.mygameboardview then
		self.mygameboardview.isPaused = true;
		self.mygameboardlogic:onWaitingOperationChanged()
	end
end

function GamePlayScene:setGameRemuse()
	if self.mygameboardview then
		self.mygameboardview.isPaused = false;
		self.mygameboardlogic:onWaitingOperationChanged()
	end
end
