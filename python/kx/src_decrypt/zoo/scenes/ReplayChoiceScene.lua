require "hecore.display.TextField"

require "zoo.config.LevelConfig"
require "zoo.scenes.CheckPlayScene"
require "zoo.gamePlay.CheckPlay"

local isTestMode = true

ReplayChoiceScene = class(Scene)
function ReplayChoiceScene:ctor()
	self.backButton = nil
	self.replayTable = nil
	self.nextPageButton = nil
	self.prePageButton = nil
	self.showingReplays = {}
	self.startIndex = 1
end
function ReplayChoiceScene:dispose()
	if self.backButton then self.backButton:removeAllEventListeners() end
	if self.nextPageButton then self.nextPageButton:removeAllEventListeners() end
	if self.prePageButton then self.prePageButton:removeAllEventListeners() end

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
	self.prePageButton = nil
	
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
        local scene = CheckPlayScene:create(levelId, self.replayTable[target:getTag()])
		scene:startReplay()
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

		local endIndex = ((vSize.height - 120) / textHeight - 2) * 4
		print(self.startIndex, endIndex, #self.replayTable)
		if endIndex > #self.replayTable - self.startIndex then
			endIndex = #self.replayTable - self.startIndex
		end
		print(self.startIndex, endIndex)

		for i = endIndex, 1, -1 do
			local x = textWidth * (math.fmod(endIndex - i, counts) + 0.5)
			local y = textHeight * (math.floor((endIndex - i)/ counts) + 0.5)
			local gameReplayLabel = buildLayerButton(self.replayTable[self.startIndex + i].level .. "(".. #self.replayTable[self.startIndex + i].replaySteps ..")",
				x, vSize.height - 160 - y + vOrigin.y, onTouchGameReplayLabel, self.startIndex + i)
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

	local function onTouchPrePage(evt)
		for i = 1, #self.showingReplays do
			self.showingReplays[i]:removeAllEventListeners()
			if self.showingReplays[i]:getParent() then
				self.showingReplays[i]:getParent():removeChild(self.showingReplays[i], false)
			end
			self.showingReplays[i] = nil
		end

		self.startIndex = self.startIndex - 80
		if self.startIndex >= #self.replayTable or self.startIndex < 0 then
			self.startIndex = 0
		end

		listReplayButtons()
	end

	local function buildLabelButton(label, x, y, func)
		local width = 150
		local height = 80
		local labelLayer = LayerColor:create()
		labelLayer:changeWidthAndHeight(width, height)
		labelLayer:setColor(ccc3(255, 0, 0))
		labelLayer:setPosition(ccp(x, y - height / 2))
		labelLayer:setTouchEnabled(true, p, true)
		labelLayer:addEventListener(DisplayEvents.kTouchTap, func)
		self:addChild(labelLayer)

		local textLabel = TextField:create(label.."", nil, 32)
		textLabel:setPosition(ccp(width/4 - 20, height/4))
		textLabel:setAnchorPoint(ccp(0,0))
		labelLayer:addChild(textLabel)

		return labelLayer
	end 
	self.backButton = buildLabelButton("< 返回", 0, vSize.height - 60 + vOrigin.y, onTouchBackLabel)
	self.nextPageButton = buildLabelButton("下一页", 250, vSize.height - 60 + vOrigin.y, onTouchNextPage)
	self.prePageButton = buildLabelButton("上一页", 450, vSize.height - 60 + vOrigin.y, onTouchPrePage)

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