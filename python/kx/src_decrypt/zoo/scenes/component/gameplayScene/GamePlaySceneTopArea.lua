GamePlaySceneTopArea = class(CocosObject)

local visibleSize 	= CCDirector:sharedDirector():getVisibleSize()
local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
local winSize = CCDirector:sharedDirector():getWinSize()
require "zoo.scenes.component.gameplayScene.ScoreProgress"
require "zoo.animation.CardinalSpline"
GamePlaySceneTopAreaLayerName = table.const
{
	"kBackground",
	"kItem",
	"kItemBatch",
	"kEffect",
	"kTouchLayer",
}

GamePlaySceneTopAreaType = {}
local itemSpriteIndex = 1
for _,v in ipairs(GamePlaySceneTopAreaLayerName) do
	GamePlaySceneTopAreaType[v] = itemSpriteIndex
	itemSpriteIndex = itemSpriteIndex + 1
end

function GamePlaySceneTopArea:create( levelSkinConfig, gamePlaySceneUI )
	-- body
	local s = GamePlaySceneTopArea.new(CCNode:create())
	s:init(levelSkinConfig, gamePlaySceneUI)
	return s
end

function GamePlaySceneTopArea:init( levelSkinConfig, gamePlaySceneUI )
	-- body
	self.gamePlaySceneUI = gamePlaySceneUI
	self.levelSkinConfig = levelSkinConfig
	
	local displayLayer = {}
	for k = 1, table.size(GamePlaySceneTopAreaType) do 
		if k == GamePlaySceneTopAreaType.kBackground or 
		    k == GamePlaySceneTopAreaType.kItemBatch then
		    local textureName = "flash/scenes/gamePlaySceneUI/gamePlaySceneUI.png"
			local realImageFilePath = SpriteUtil:getRealResourceName(textureName)
			local texture = CCTextureCache:sharedTextureCache():addImage(realImageFilePath)
			displayLayer[k] = SpriteBatchNode:createWithTexture(texture)
		elseif k == GamePlaySceneTopAreaType.kTouchLayer then
			displayLayer[k] = LayerColor:create()
		else
			displayLayer[k] = Layer:create()
		end
		self:addChild(displayLayer[k])
	end
	self.displayLayer = displayLayer

	self:initAllItems()
	self:initTouchLayer()
end

function GamePlaySceneTopArea:initTouchLayer( ... )
	-- body
	local layer = self.displayLayer[GamePlaySceneTopAreaType.kTouchLayer]
	layer:setOpacity(0)
	layer:changeWidthAndHeight(visibleSize.width, visibleSize.height)
	layer:setTouchEnabled(true)
	layer:setPosition(ccp(visibleOrigin.x, visibleOrigin.y))
	local function touchBegin( evt )
		-- body
		self:touchBegin(evt)
	end

	local function touchEnd( evt )
		-- body
		self:touchEnd(evt)
	end

	local function touchTap( evt )
		-- body
		self:touchTap(evt)
	end
	layer:addEventListener(DisplayEvents.kTouchBegin, touchBegin)
	layer:addEventListener(DisplayEvents.kTouchEnd, touchEnd)
	layer:addEventListener(DisplayEvents.kTouchTap, touchTap)
end

function GamePlaySceneTopArea:initAllItems()
	-- body
	self:initTopRightLeaves()
	self:initScoreProgressBar()
	self:initTopLeftLeaves()
	self:initPauseBtn()
	self:initMoveOrTimeCounter()
	self:initOtherNode()
end

function GamePlaySceneTopArea:initTopRightLeaves()
	-- body
	local topRightLeaves = ResourceManager:sharedInstance():buildBatchGroup("sprite", self.levelSkinConfig.topRightLeaves)
	self.displayLayer[GamePlaySceneTopAreaType.kBackground]:addChild(topRightLeaves)
	self.topRightLeaves = topRightLeaves
	local topRightLeavesSize = topRightLeaves:getGroupBounds().size
	local topRightLeavesX = visibleOrigin.x + visibleSize.width - topRightLeavesSize.width + 16
	local topRightLeavesY = visibleOrigin.y + visibleSize.height + 16
	topRightLeaves:setPosition(ccp(topRightLeavesX, topRightLeavesY))
end

function GamePlaySceneTopArea:initScoreProgressBar( ... )
	-- body
	local gamePlaySceneUI = self.gamePlaySceneUI
	local star1Score = gamePlaySceneUI.curLevelScoreTarget[1]
	local star2Score = gamePlaySceneUI.curLevelScoreTarget[2]
	local star3Score = gamePlaySceneUI.curLevelScoreTarget[3]
	local star4Score = gamePlaySceneUI.curLevelScoreTarget[4]
	local starScoreList = {star1Score, star2Score, star3Score, star4Score}
	
	local scoreProgressBarX = visibleOrigin.x - 17 + 10
	local scoreProgressBarY = visibleOrigin.y + visibleSize.height - 15
	self.scoreProgressBar = ScoreProgress:create(self, starScoreList, ccp(scoreProgressBarX, scoreProgressBarY))
	-- self.scoreProgressBar:setPosition(ccp(scoreProgressBarX, scoreProgressBarY))
end

function GamePlaySceneTopArea:initTopLeftLeaves()
	-- body
	local topLeftLeaves = ResourceManager:sharedInstance():buildBatchGroup("sprite",self.levelSkinConfig.topLeftLeaves)
	self.displayLayer[GamePlaySceneTopAreaType.kBackground]:addChild(topLeftLeaves)
	self.topLeftLeaves = topLeftLeaves
	local topLeftLeavesX = visibleOrigin.x - 77.40
	local topLeftLeavesY = visibleOrigin.y + visibleSize.height + 22.95
	topLeftLeaves:setPosition(ccp(topLeftLeavesX, topLeftLeavesY))
end

function GamePlaySceneTopArea:initMoveOrTimeCounter( ... )
	-- body
	levelSkinConfig = self.levelSkinConfig
	local gamePlaySceneUI = self.gamePlaySceneUI
	if gamePlaySceneUI.levelModeType == "Classic" then
		self.moveOrTimeCounter = MoveOrTimeCounter:create(levelSkinConfig.moveOrTimeCounter, gamePlaySceneUI.levelId, MoveOrTimeCounterType.TIME_COUNT, gamePlaySceneUI.timeLimit)
	else
		self.moveOrTimeCounter = MoveOrTimeCounter:create(levelSkinConfig.moveOrTimeCounter,gamePlaySceneUI.levelId, MoveOrTimeCounterType.MOVE_COUNT, gamePlaySceneUI.moveLimit)
	end
	local counterSize = self.moveOrTimeCounter:getGroupBounds().size
	local counterX	= visibleOrigin.x + visibleSize.width - counterSize.width/2 - 20
	local counterY	= visibleOrigin.y + visibleSize.height + 25
	self.moveOrTimeCounter:setPosition(ccp(counterX, counterY))
	self.displayLayer[GamePlaySceneTopAreaType.kEffect]:addChild(self.moveOrTimeCounter)
end

function GamePlaySceneTopArea:getTargetPanel( ... )
	-- body
	return self.levelTargetPanel
end

function GamePlaySceneTopArea:initOtherNode()
	-- body
	levelSkinConfig = self.levelSkinConfig
	local gamePlaySceneUI = self.gamePlaySceneUI
	if gamePlayType == GamePlayType.kNone then
		assert(false)
	elseif gamePlayType == GamePlayType.kClassicMoves or
		gamePlayType == GamePlayType.kClassic then

		local function onScoreChangeCallback(newScore)
			self:onScoreChangeCallback(newScore)
		end

		self.scoreProgressBar:setOnScoreChangeCallback(onScoreChangeCallback)
	end

	local fntFile			= "fnt/titles.fnt"
	local diguanWidth		= 40
	local diguanHeight		= 40
	local levelNumberWidth		= 210
	local levelNumberHeight		= 40
	local manualAdjustInterval	= -10

	local levelDisplayName
	local levelNumberLabel
	if gamePlaySceneUI.levelType == GameLevelType.kDigWeekly or gamePlaySceneUI.levelType == GameLevelType.kRabbitWeekly then
		local day = (tonumber(os.date('%w', Localhost:time() / 1000)) - 1 + 7) % 7
		levelDisplayName = Localization:getInstance():getText('weekly.race.play.scene.name', {num = day})
		local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
		levelNumberLabel = PanelTitleLabel:createWithString(levelDisplayName, len)
		levelNumberLabel:setScale(0.7)
	elseif gamePlaySceneUI.levelType == GameLevelType.kSummerWeekly then
		local day = tonumber(os.date('%w', Localhost:time() / 1000))
		if day == 0 then day = 7 end
		levelDisplayName = Localization:getInstance():getText('weekly.race.play.scene.name', {num = day})
		local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
		levelNumberLabel = PanelTitleLabel:createWithString(levelDisplayName, len)
		levelNumberLabel:setScale(0.7)
	elseif gamePlaySceneUI.levelType == GameLevelType.kMayDay then
		levelDisplayName = Localization:getInstance():getText('activity.christmas.start.panel.title')
		local len = math.ceil(string.len(levelDisplayName) / 3)
		levelNumberLabel = PanelTitleLabel:createWithString(levelDisplayName, len)
		levelNumberLabel:setScale(0.7)
	elseif gamePlaySceneUI.levelType == GameLevelType.kWukong then
		levelDisplayName = Localization:getInstance():getText('activity.wukong.start.panel.title')
		--levelDisplayName = Localization:getInstance():getText('weekly.race.play.scene.name')
		local len = math.ceil(string.len(levelDisplayName) / 3)
		levelNumberLabel = PanelTitleLabel:createWithString(levelDisplayName, len)
		levelNumberLabel:setScale(0.7)
	elseif gamePlaySceneUI.levelType == GameLevelType.kTaskForRecall or gamePlaySceneUI.levelType == GameLevelType.kTaskForUnlockArea then
		levelDisplayName = Localization:getInstance():getText('recall_text_5')
		local len = math.ceil(string.len(levelDisplayName) / 3)
		levelNumberLabel = PanelTitleLabel:createWithString(levelDisplayName, len)
		levelNumberLabel:setScale(0.7)
	else 
		levelDisplayName = LevelMapManager.getInstance():getLevelDisplayName(gamePlaySceneUI.levelId)
		levelNumberLabel = PanelTitleLabel:create(levelDisplayName, diguanWidth, diguanHeight, levelNumberWidth, levelNumberHeight, manualAdjustInterval)
	end

	if _isQixiLevel then -- qixi
		levelNumberLabel:setVisible(false)
	end

	local contentSize	= levelNumberLabel:getContentSize()
	self.displayLayer[GamePlaySceneTopAreaType.kEffect]:addChild(levelNumberLabel)
	levelNumberLabel:ignoreAnchorPointForPosition(false)
	levelNumberLabel:setAnchorPoint(ccp(0,1))

	local levelNumberLabelPosX = 4
	local levelNumberLabelPosY = visibleOrigin.y + visibleSize.height - 8.4

	levelNumberLabel:setPosition(ccp(levelNumberLabelPosX, levelNumberLabelPosY))

end

function GamePlaySceneTopArea:initPauseBtn( ... )
	-- body
	self.pauseBtnEnable = true
	local gamePlaySceneUI = self.gamePlaySceneUI
	local pauseRes = self.topLeftLeaves:getChildByName("pauseBtn")
	local size_pause = pauseRes:getGroupBounds().size
	self.pauseRes = pauseRes
	local transformData = {}
	pauseRes.transformData = transformData
	transformData.width = size_pause.width
	transformData.height = size_pause.height
	transformData.scaleX = pauseRes:getScaleX()
	transformData.scaleY = pauseRes:getScaleY()
	local function onPauseBtnBegin( evt )
		-- body
		-- print("-------------------onPauseBtnBegin")
		if not self.pauseBtnEnable then return end
		local scaleX = pauseRes.transformData.scaleX
		local scaleY = pauseRes.transformData.scaleY
		local deltaX = 4 / pauseRes.transformData.width
		local deltaY = 4 / pauseRes.transformData.height
		pauseRes:setScaleX(scaleX + deltaX)
		pauseRes:setScaleY(scaleY + deltaY)
	end

	local function onPauseBtnEnd( evt )
		-- body
		-- print("-------------------onPauseBtnEnd")
		if not self.pauseBtnEnable then return end
		if pauseRes.transformData and not pauseRes.isDisposed then
			local scaleX = pauseRes.transformData.scaleX
			local scaleY = pauseRes.transformData.scaleY
			pauseRes:setScaleX(scaleX)
			pauseRes:setScaleY(scaleY)
		end
	end

	local function onPauseBtnTapped()
		-- print("-------------------onPauseBtnTapped")
		if not self.pauseBtnEnable then return end
		gamePlaySceneUI:onPauseBtnTapped()
	end

	pauseRes:addEventListener(DisplayEvents.kTouchBegin, onPauseBtnBegin)
	pauseRes:addEventListener(DisplayEvents.kTouchEnd, onPauseBtnEnd)
	pauseRes:addEventListener(DisplayEvents.kTouchTap, onPauseBtnTapped)
	self:addTouchList(pauseRes)
end

function GamePlaySceneTopArea:touchBegin( evt )
	-- body
	local pos = evt.globalPosition
	-- print("touchBegin", pos.x, pos.y)
	if self.touchList then 
		for k, v in pairs(self.touchList) do
			local hit = v:hitTestPoint(pos, true)
			if hit then
				v.isTouched = true
				v:dispatchEvent(DisplayEvent.new(DisplayEvents.kTouchBegin, v, pos))
			else
				v.isTouched = false
			end 
		end
	end
end

function GamePlaySceneTopArea:touchEnd( evt )
	-- body
	local pos = evt.globalPosition
	-- print("touchEnd", pos.x, pos.y)
	if self.touchList then 
		for k, v in pairs(self.touchList) do
			v:dispatchEvent(DisplayEvent.new(DisplayEvents.kTouchEnd, v, pos))
		end
	end
end

function GamePlaySceneTopArea:touchTap( evt )
	-- body
	local pos = evt.globalPosition
	-- print("touchTap", pos.x, pos.y)
	if self.touchList then 
		for k, v in pairs(self.touchList) do
			if v.isTouched then
				local hit = v:hitTestPoint(pos, true)
				if hit then
					v:dispatchEvent(DisplayEvent.new(DisplayEvents.kTouchTap, v, pos))
				end 
			end
		end
	end
end

function GamePlaySceneTopArea:addTouchList( display )
	-- body
	if not self.touchList then self.touchList = {} end
	table.insertIfNotExist(self.touchList, display)
end


function GamePlaySceneTopArea:setPauseBtnEnable( enable )
	-- body
	self.pauseBtnEnable = enable
end

function GamePlaySceneTopArea:getPauseBtnEnable( ... )
	-- body
	return self.pauseBtnEnable
end


