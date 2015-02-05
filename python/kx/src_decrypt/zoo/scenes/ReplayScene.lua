require "hecore.display.TextField"
require "zoo.config.LevelConfig"

require "zoo.gamePlay.GameBoardLogic"
require "zoo.gamePlay.GameBoardView"
require "zoo.gamePlay.GamePlayConfig"

ReplayScene = class(Scene)
function ReplayScene:ctor()
	self.backButton = nil
	self.replayButton = nil
	self.replayMode = false
	self.gamelevel = 0;

	self.mygameboardlogic = nil;
	self.mygameboardview = nil;
	self.initScheduler = nil;
end
function ReplayScene:dispose()
	if not self.replayMode then
		self.mygameboardlogic:WriteReplay("test.rep")
	end
	if self.backButton then self.backButton:removeAllEventListeners() end
	if self.replayButton then self.replayButton:removeAllEventListeners() end
	self.backButton = nil
	self.replayButton = nil
	self.gamelevel = nil

	self.mygameboardlogic = nil;
	self.mygameboardview = nil;
	self.initScheduler = nil;
	Scene.dispose(self)
end

--function ReplayScene:create()
--	local s = ReplayScene.new()
--	s:initScene()
--	return s
--end

function ReplayScene:create(level, replayRecords)
	local s = ReplayScene.new()
	s.gamelevel = level;
	s.replayRecords = replayRecords
	s:loadExtraResource();
	-- s:initScene()
	return s
end

function ReplayScene:loadExtraResource( ... )
	-- body
	local levelConfig = LevelDataManager.sharedLevelData():getLevelConfigByID(self.gamelevel)
	local fileList = levelConfig:getDependingSpecialAssetsList()
	local loader = FrameLoader.new()
	local function callback_afterResourceLoader()
		loader:removeAllEventListeners()
		self:initScene();
		self:setReplay(self.replayRecords)
	end
	for i,v in ipairs(fileList) do loader:add(v, kFrameLoaderType.plist) end
	loader:addEventListener(Events.kComplete, callback_afterResourceLoader)
	loader:load()
end

function ReplayScene:onInit()
	local winSize = CCDirector:sharedDirector():getWinSize()

	local context = self
	local function onTouchBackLabel(evt)
		Director:sharedDirector():popScene()
	end
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
	self.backButton = buildLabelButton("Back Home", 0, winSize.height-100, onTouchBackLabel)
	self.replayButton = buildLabelButton("Replay", 0, winSize.height - 200, onGameReplay)

	local levelconfig = LevelDataManager.sharedLevelData():getLevelConfigByID(self.gamelevel);
	--he_log_info(string.format("self.gamelevel = %d",self.gamelevel));
	levelconfig.randomSeed = self.replayRecords.randomSeed
	self.mygameboardlogic = GameBoardLogic:create()
	self.mygameboardlogic:initByConfig(self.gamelevel, levelconfig);
	--获取处理完之后的map，进行view的初始化
	self.mygameboardview = GameBoardView:createByGameBoardLogic(self.mygameboardlogic);
	self:addChild(self.mygameboardview)
	self.mygameboardview:setScaleX(GamePlayConfig_Tile_ScaleX)
	self.mygameboardview:setScaleY(GamePlayConfig_Tile_ScaleY)
end

function ReplayScene:setReplay(records)
	self.replayMode = true
	self.mygameboardlogic.replaySteps = records.replaySteps
	self.mygameboardlogic:ReplayStart()
	self.mygameboardlogic:onGameInit()
end

function ReplayScene:getGameBoardLogic(...)
	assert(#{...} == 0)

	return self.mygameboardlogic
end

-------初始化整个游戏---进入暂时暂停的状态
function ReplayScene:setGameInit()
	local context = self;

	local function _updateGame(dt)
		context:_Inner_GameInit()
	end
	local time_cd = 0
	self.initScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(_updateGame, time_cd, false)
end

function ReplayScene:_Inner_GameInit()	
	if self.mygameboardlogic then
		self.mygameboardlogic.isWaitingOperation = false;
	end
	if self.mygameboardview then
		self.mygameboardview.isPaused = true;
	end
	Director:getScheduler():unscheduleScriptEntry(self.initScheduler)
end

-------开始游戏
function ReplayScene:setGameStart()
	if self.mygameboardlogic then
		self.mygameboardlogic.isWaitingOperation = true;
	end
	if self.mygameboardview then
		self.mygameboardview.isPaused = false;
	end
end

function ReplayScene:setGameStop()
	if self.mygameboardlogic then
		self.mygameboardlogic.isWaitingOperation = false;
	end
	if self.mygameboardview then
		self.mygameboardview.isPaused = true;
	end
end

function ReplayScene:setGameRemuse()
	if self.mygameboardlogic then
		self.mygameboardlogic.isWaitingOperation = true;
	end
	if self.mygameboardview then
		self.mygameboardview.isPaused = false;
	end
end
