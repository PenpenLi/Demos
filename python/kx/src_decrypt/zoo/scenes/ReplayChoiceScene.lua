require "hecore.display.TextField"

require "zoo.scenes.ReplayScene"
require "zoo.config.LevelConfig"
require "zoo.scenes.ReplayGameScene"

local isTestMode = true

ReplayChoiceScene = class(Scene)
function ReplayChoiceScene:ctor()
	self.backButton = nil
	self.replayTable = nil
	self.nextPageButton = nil
	self.showingReplays = {}
	self.startIndex = 1
end
function ReplayChoiceScene:dispose()
	if self.backButton then self.backButton:removeAllEventListeners() end
	if self.nextPageButton then self.nextPageButton:removeAllEventListeners() end

	for i = 1, #self.showingReplays do
		self.showingReplays[i]:removeAllEventListeners()
		self.showingReplays[i] = nil
	end
	self.showingReplays = nil

	if self.replayTable then
		for i = 1, #self.replayTable do
			self.replayTable[i] = nil
		end
		self.replayTable = nil
	end

	self.backButton = nil
	self.nextPageButton = nil
	
	Scene.dispose(self)
end

function ReplayChoiceScene:create()
	local s = ReplayChoiceScene.new()
	s:initScene()
	return s
end

function ReplayChoiceScene:onInit()
	local vSize = CCDirector:sharedDirector():getVisibleSize()
	local vOrigin = CCDirector:sharedDirector():getVisibleOrigin()

	local function onTouchGameReplayLabel(evt)
        local target = evt.target
        local levelId = self.replayTable[target:getTag()].level
        -- local scene = ReplayScene:create(levelId, self.replayTable[target:getTag()])
        local scene = ReplayGameScene:create(levelId, self.replayTable[target:getTag()])
		Director:sharedDirector():pushScene(scene)
	end

	local function buildLayerButton(label, x, y, func, tag)
		local width = 160
		local height = 40
		local labelLayer = LayerColor:create()
		labelLayer:changeWidthAndHeight(width, height)
		labelLayer:setColor(ccc3(255, 20, 0))
		labelLayer:setOpacity(50)
		labelLayer:setPosition(ccp(x - width / 2, y - height / 2))
		labelLayer:setTouchEnabled(true, p, true)
		labelLayer:addEventListener(DisplayEvents.kTouchTap, func)
		labelLayer:setTag(tag)
		self:addChild(labelLayer)

		local textLabel = TextField:create(label.."", nil, 28, CCSizeMake(width,height), kCCTextAlignmentCenter, kCCVerticalTextAlignmentCenter)
		textLabel:setAnchorPoint(ccp(0,0))
		labelLayer:addChild(textLabel)

		return labelLayer
	end

	local function listReplayButtons()
		local counts = 4
		local textWidth = math.floor(vSize.width / counts);
		local textHeight = math.floor(textWidth / 4);

		local endIndex = ((vSize.height - 120) / textHeight - 4) * 4
		print(self.startIndex, endIndex, #self.replayTable)
		if endIndex > #self.replayTable - self.startIndex then
			endIndex = #self.replayTable - self.startIndex
		end
		print(self.startIndex, endIndex)

		for i = 1, endIndex do
			local x = textWidth * (math.fmod(i - 1, counts) + 0.5)
			local y = textHeight * (math.floor((i - 1)/ counts) + 0.5)
			local gameReplayLabel = buildLayerButton(self.replayTable[self.startIndex + i].level .. "(".. #self.replayTable[self.startIndex + i].replaySteps ..")",
				x, vSize.height - 260 - y + vOrigin.y, onTouchGameReplayLabel, self.startIndex + i)
			gameReplayLabel:addEventListener(DisplayEvents.kTouchTap, onTouchGameReplayLabel)
			table.insert(self.showingReplays, gameReplayLabel)
			self:addChild(gameReplayLabel)
		end
	end

	local function onTouchBackLabel(evt)
		Director:sharedDirector():popScene()
	end

	local function onTouchNextPage(evt)
		for i = 1, #self.showingReplays do
			self.showingReplays[i]:removeAllEventListeners()
			if self.showingReplays[i]:getParent() then
				self.showingReplays[i]:getParent():removeChild(self.showingReplays[i], false)
			end
			self.showingReplays[i] = nil
		end

		self.startIndex = self.startIndex + 80
		if self.startIndex >= #self.replayTable then
			self.startIndex = 0
		end

		listReplayButtons()
	end

	local function buildLabelButton(label, x, y, func)
		local width = 250
		local height = 80
		local labelLayer = LayerColor:create()
		labelLayer:changeWidthAndHeight(width, height)
		labelLayer:setColor(ccc3(255, 0, 0))
		labelLayer:setPosition(ccp(x - width / 2, y - height / 2))
		labelLayer:setTouchEnabled(true, p, true)
		labelLayer:addEventListener(DisplayEvents.kTouchTap, func)
		self:addChild(labelLayer)

		local textLabel = TextField:create(label.."", nil, 32)
		textLabel:setPosition(ccp(width/2, height/4))
		textLabel:setAnchorPoint(ccp(0,0))
		labelLayer:addChild(textLabel)

		return labelLayer
	end 
	self.backButton = buildLabelButton("Back", 0, vSize.height - 60 + vOrigin.y, onTouchBackLabel)
	self.nextPageButton = buildLabelButton("PgDn", 0, vSize.height - 160 + vOrigin.y, onTouchNextPage)

	local function getAllReplays(fileName)
		local path = HeResPathUtils:getUserDataPath() .. "/" .. fileName
		local hFile, err = io.open(path, "r")
		local text, replays
		if hFile and not err then
			text = hFile:read("*a")
			io.close(hFile)
		end

		if text then
			return table.deserialize(text)
		end
		return nil
	end

	if isTestMode then
		self.replayTable = getAllReplays("test.rep")

		if not self.replayTable or #self.replayTable == 0 then return end

		self.startIndex = 0
		listReplayButtons()
	end
end