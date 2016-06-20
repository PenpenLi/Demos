EditorStartPanel = class(LevelInfoPanel)

function EditorStartPanel:init(parentPanel, levelId, levelType, useSpecialActivityUI, ...)
	LevelInfoPanel.init(self, parentPanel, levelId, levelType, useSpecialActivityUI)

	self.helpIcon:setTouchEnabled(false)
	self.helpIcon:setButtonMode(false)

	for index = 1, #self.preGameTools do
		self.preGameTools[index]:setLocked(false)
		self.preGameTools[index]:setFreePrice()
		self.preGameTools[index]:updatePriceColor()
	end
end

function EditorStartPanel:startGame()
	self:startGamePlayScene()
end

function EditorStartPanel:onCloseBtnTapped(event, ...)

end

function EditorStartPanel:startGamePlayScene()
	local selectedItemsData = self:getSelectedItemsData()
	self:setSelectedItemAnimDestPos(selectedItemsData)
	self.selectedItemsData = selectedItemsData
	self.startFromEnergyPanel = false

	local devTestGPS = EditorGamePlayScene:create(self.levelId, self.levelType, selectedItemsData)
    self.devTestGPS = devTestGPS
    self.parentPanel:addChild(devTestGPS)
    self.parentPanel:removeChild(self)

    _G.currentEditorLevelScene = devTestGPS
end

function EditorStartPanel:create(parentPanel, levelId, levelType, useSpecialActivityUI, ...)
	assert(parentPanel)
	assert(type(levelId) 			== "number")
	assert(#{...} == 0)
	local newPanel = EditorStartPanel.new()
	newPanel:init(parentPanel, levelId, levelType, useSpecialActivityUI)
	return newPanel
end

