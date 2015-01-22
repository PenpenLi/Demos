DevTestGamePlayScene = class(GamePlayScene)

function DevTestGamePlayScene:ctor()
	
end

function DevTestGamePlayScene:dispose()
	if self.mygameboardlogic then self.mygameboardlogic:dispose() end
	self.mygameboardlogic = nil;
	self.mygameboardview = nil;
	self.initScheduler = nil;
	Scene.dispose(self)
end

function DevTestGamePlayScene:loadExtraResource( ... )
	-- body
	local fileList = self.mapConf:getDependingSpecialAssetsList()
	local loader = FrameLoader.new()
	local function callback_afterResourceLoader()
		loader:removeAllEventListeners()
		self:initScene();
	end
	for i,v in ipairs(fileList) do loader:add(v, kFrameLoaderType.plist) end
	loader:addEventListener(Events.kComplete, callback_afterResourceLoader)
	loader:load()
end

function DevTestGamePlayScene:create(conf)
	local s = DevTestGamePlayScene.new()
	s.mapConf = conf;
	s:loadExtraResource();
	return s
end

function DevTestGamePlayScene:onInit()
	local winSize = CCDirector:sharedDirector():getWinSize()

	local context = self
	local function onTouchBackLabel(evt)
		Director:sharedDirector():popScene()
	end
	local function onGameReplay(evt)
		self.mygameboardlogic:ReplayStart(self.mapConf)
		self.mygameboardview:reInitByGameBoardLogic(self.mygameboardlogic);
	end
	
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	local game_bg = Sprite:createWithSpriteFrameName("game_bg.png")
	game_bg:setPosition(ccp(visibleSize.width/2,visibleSize.height/2))
	game_bg:setScale(1/0.7)
	self:addChild(game_bg)

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

	-- self.backButton:setVisible(false)
	-- self.replayButton:setVisible(false)
	print("after create button",os.date())
	self.mygameboardlogic = GameBoardLogic:create();
	self.mygameboardlogic:initByConfig(self.gamelevel, self.mapConf);
	--获取处理完之后的map，进行view的初始化
	self.mygameboardview = GameBoardView:createByGameBoardLogic(self.mygameboardlogic);
	self:addChild(self.mygameboardview)
	self.mygameboardview:setScaleX(GamePlayConfig_Tile_ScaleX)
	self.mygameboardview:setScaleY(GamePlayConfig_Tile_ScaleY)	

	self.mygameboardlogic:onGameInit()
end
