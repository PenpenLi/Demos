require "hecore.display.Scene"
require "zoo.scenes.component.fruitTreeScene.FruitTree"
require "zoo.net.OnlineGetterHttp"
require "zoo.panel.FruitTreePanel"

FruitTreeScene = class(Scene)

function FruitTreeScene:create()
	local scene = FruitTreeScene.new()
	scene:initScene()
	scene.instanceName = "FruitTreeScene"
	return scene
end

function FruitTreeScene:dispose()
	local scene = HomeScene:sharedInstance()
	if scene then scene:checkDataChange() end
	if scene and scene.coinButton and not scene.coinButton.isDisposed then scene.coinButton:updateView() end
	if scene and scene.energyButton and not scene.energyButton.isDisposed then scene.energyButton:updateView() end
	if GameGuide then
		if self.rulePanel then GameGuide:sharedInstance():onPopdown(self.rulePanel) end
		if self.upgradePanel then GameGuide:sharedInstance():onPopdown(self.upgradePanel) end
	end
	Scene.dispose(self)
end

function FruitTreeScene:onInit()
	-- background & tree
	local wSize = Director:sharedDirector():getWinSize()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()

	self.bg = Sprite:createWithSpriteFrameName("fruitTree")
	self.tree = FruitTree:create(FruitTreeSceneLogic:sharedInstance():getInfo())
	self.bg:setAnchorPoint(ccp(0.5, 0.1))
	self.bg:setScale(vSize.height / wSize.height)
	self.tree:setScale(vSize.height / wSize.height)
	self.bg:setPosition(ccp(wSize.width / 2, vOrigin.y + 127 * vSize.height / wSize.height))
	self.tree:setPosition(ccp(wSize.width / 2, vOrigin.y + 127 * vSize.height / wSize.height))
	self:addChild(self.bg)
	
	-- close button
	local builder = InterfaceBuilder:create(PanelConfigFiles.common_ui)
	local closeBtn = builder:buildGroup("ui_buttons/ui_button_close_cloud")
	closeBtn:setPosition(ccp(vOrigin.x + vSize.width - 50, vOrigin.y + vSize.height - 50))
	self:addChild(closeBtn)

	self:addChild(self.tree)

	-- for game guide
	self.guideLayer = Layer:create()
	self:addChild(self.guideLayer)

	local function onFruitClicked(evt)
		if self.titlePanel and not self.titlePanel.isDisposed then self.titlePanel:disableClick(true) end
		if self.bottomPanel and not self.bottomPanel.isDisposed then self.bottomPanel:disableClick(true) end
		closeBtn:setTouchEnabled(false)
		self.fruitClicked = true
	end
	self.tree:addEventListener(kFruitTreeEvents.kFruitClicked, onFruitClicked)
	local function onFruitReleased()
		if self.titlePanel and not self.titlePanel.isDisposed then self.titlePanel:disableClick(false) end
		if self.bottomPanel and not self.bottomPanel.isDisposed then self.bottomPanel:disableClick(false) end
		closeBtn:setTouchEnabled(true)
		self.fruitClicked = nil
	end
	self.tree:addEventListener(kFruitTreeEvents.kFruitReleased, onFruitReleased)
	local function onFruitUpdate()
		if self.upgradePanel and not self.upgradePanel.isDisposed then self.upgradePanel:refresh() end
		if self.bottomPanel and not self.bottomPanel.isDisposed then self.bottomPanel:refresh() end
	end
	self.tree:addEventListener(kFruitTreeEvents.kUpdate, onFruitUpdate)
	self.tree:addEventListener(kFruitTreeEvents.kUpdateData, onFruitUpdate)

	local function onExit()
		if not self.isDisposed then Director:sharedDirector():popScene() end
	end
	self.tree:addEventListener(kFruitTreeEvents.kExit, onExit)


	local function createRulePanel()
		if self.rulePanel or not self.titlePanel then return end
		self.rulePanel = FruitTreeRulePanel:create(self.titlePanel:getBottomY())
		if self.rulePanel then
			local function onClose()
				if GameGuide then
					GameGuide:sharedInstance():onPopdown(self.ruilePanel)
				end
				self.titlePanel:onRulePanelRemove()
				self.rulePanel:removeFromParentAndCleanup(true)
				closeBtn:setTouchEnabled(true)
				self.rulePanel = nil
				if self.bottomPanel and not self.bottomPanel.isDisposed then self.bottomPanel:disableClick(false) end
				self.tree:blockClick(false)
			end
			closeBtn:setTouchEnabled(false)
			self.rulePanel:addEventListener(kPanelEvents.kClose, onClose)
			local zOrder = self.titlePanel:getZOrder()
			local index = self:getChildIndex(self.titlePanel)
			self:addChildAt(self.rulePanel, index)
			self.rulePanel:playSlideInAnim()
			if GameGuide then
				GameGuide:sharedInstance():onPopup(self.rulePanel)
			end
		end
	end

	local function createTitlePanel()
		if self.titlePanel then return end
		self.titlePanel = FruitTreeTitlePanel:create()
		if self.titlePanel then
			local function onClose() Director:sharedDirector():popScene() end
			local function onButton()
				if not self.rulePanel then
					if self.bottomPanel and not self.bottomPanel.isDisposed then self.bottomPanel:disableClick(true) end
					self.tree:blockClick(true)
					createRulePanel()
				else self.rulePanel:remove() end
			end
			self.titlePanel:addEventListener(kPanelEvents.kClose, onClose)
			self.titlePanel:addEventListener(kPanelEvents.kButton, onButton)
			local index = self:getChildIndex(self.guideLayer)
			self:addChildAt(self.titlePanel, index)
		end
	end

	local function createUpgradePanel()
		if self.upgradePanel then return end
		self.upgradePanel = FruitTreeUpgradePanel:create()
		if self.upgradePanel then
			local function onClose()
				if GameGuide then
					GameGuide:sharedInstance():onPopdown(self.upgradePanel)
				end
				self.upgradePanel:removeFromParentAndCleanup(true)
				self.upgradePanel = nil
				if self.titlePanel and not self.titlePanel.isDisposed then self.titlePanel:disableClick(false, true) end
				self.tree:blockClick(false)
			end
			local function onButton()
				if self.bottomPanel then self.bottomPanel:refresh() end
			end
			self.upgradePanel:addEventListener(kPanelEvents.kButton, onButton)
			self.upgradePanel:addEventListener(kPanelEvents.kClose, onClose)
			local index = self:getChildIndex(self.guideLayer)
			self:addChildAt(self.upgradePanel, index)
			if GameGuide then
				GameGuide:sharedInstance():onPopup(self.upgradePanel)
			end
		end
	end

	local function createBottomPanel()
		if self.bottomPanel then return end
		self.bottomPanel = FruitTreeBottomPanel:create()
		if self.bottomPanel then
			local function onButton()
				self.tree:blockClick(true)
				if self.titlePanel and not self.titlePanel.isDisposed then self.titlePanel:disableClick(true, true) end
				createUpgradePanel()
			end
			self.bottomPanel:addEventListener(kPanelEvents.kButton, onButton)
			local index = self:getChildIndex(self.guideLayer)
			self:addChildAt(self.bottomPanel, index)
		end
	end

	createBottomPanel()
	createTitlePanel()

	local function onClose() Director:sharedDirector():popScene() end
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap, onClose)

	local function onEnterHandler(event)
		self:onEnterHandler(event)
	end
	self:registerScriptHandler(onEnterHandler)
end

function FruitTreeScene:onEnterHandler(event)
	print("FruitTreeScene:onEnterHandler", event)
	if event == "enter" then
		-- activity
		local list = ActivityUtil:getActivitys()
		for k, v in ipairs(list) do
			local config = require("activity/"..tostring(v.source))
			if type(config.fruitTreeScene) == "boolean" and config.fruitTreeScene then
				local activity = ActivityData.new(v)
				activity:start(false)
			end
		end
	end
end

function FruitTreeScene:shouldNewBtnDisabled()
	return self.fruitClicked or self.tree:isBlockClick()
end

function FruitTreeScene:refresh()
	if self.bottomPanel then self.bottomPanel:refresh() end
	if self.upgradePanel then self.upgradePanel:refresh() end
end

function FruitTreeScene:onKeyBackClicked()
	if self.rulePanel then
		if GameGuide then
			GameGuide:sharedInstance():onPopdown(self.rulePanel)
		end
		self.rulePanel:onKeyBackClicked()
	elseif self.upgradePanel then
		if GameGuide then
			GameGuide:sharedInstance():onPopdown(self.upgradePanel)
		end
		self.upgradePanel:onKeyBackClicked()
	elseif self.fruitClicked then self.tree:onKeyBackClicked()
	else Director:sharedDirector():popScene() end
end

FruitTreeSceneLogic = {}
local instance = nil
function FruitTreeSceneLogic:sharedInstance()
	if not instance then instance = FruitTreeSceneLogic end
	return instance
end

function FruitTreeSceneLogic:updateInfo(successCallback, failCallback)
	local function onSuccess(evt)
		if evt.data and evt.data.fruitInfos then
			self.info = evt.data.fruitInfos
			if successCallback then successCallback() end
		else
			if failCallback then failCallback(-2) end
		end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt.data) end
	end
	if self:_updateNeeded() then
		local http = GetFruitsInfoHttp.new(true)
		http:addEventListener(Events.kComplete, onSuccess)
		http:addEventListener(Events.kError, onFail)
		http:load()
	end
end

function FruitTreeSceneLogic:getInfo()
	return self.info
end

function FruitTreeSceneLogic:_updateNeeded()
	return true
end