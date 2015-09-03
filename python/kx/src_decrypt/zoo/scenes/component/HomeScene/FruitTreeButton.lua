require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

FruitTreeButton = class(IconButtonBase)

function FruitTreeButton:create()
	local instance = FruitTreeButton.new()
	assert(instance)
	if instance then instance:init() end
	return instance
end

function FruitTreeButton:init()

	self.ui = ResourceManager:sharedInstance():buildGroup('fruitTree_icn')
	IconButtonBase.init(self, self.ui)

	self.btn = self.wrapper:getChildByName("btn")
	self.ring = self.wrapper:getChildByName("ring")
	self.number = self.wrapper:getChildByName("number")

	self.wrapper:setTouchEnabled(true)
	self.wrapper:setButtonMode(true)

	self.newTag = ResourceManager:sharedInstance():buildGroup("homescene_newtag_sprite")
	self.newTag:setPositionXY(self.ring:getPositionX(), self.ring:getPositionY())
	self.wrapper:addChild(self.newTag)

	if Localhost:time() > 1410364800000 then
		self.newTag:setVisible(false)
	end

	local function onEnterHandler(evt)
		if evt == "enter" then self:refresh() end
	end
	self:registerScriptHandler(onEnterHandler)

	self:refresh()
end

function FruitTreeButton:refresh()
	local num = FruitTreeButtonModel:getCrowNumber()
	local show = num > 0
	if self.ring and not self.ring.isDisposed then self.ring:setVisible(show) end
	if self.number and not self.number.isDisposed then self.number:setVisible(show) end
	if self.number and not self.number.isDisposed then self.number:setString(num) end
end

function FruitTreeButton:hideNewTag()
	self.newTag:setVisible(false)
end

FruitTreeButtonModel = class()
function FruitTreeButtonModel:getCrowNumber()
	local meta = MetaManager:getInstance().fruits_upgrade
	if type(meta) ~= "table" then return 0 end
	local extend = UserManager:getInstance():getUserExtendRef()
	if type(extend) ~= "table" then return 0 end
	local fruitTreeLevel = extend:getFruitTreeLevel()
	if type(fruitTreeLevel) ~= "number" then return 0 end
	local upgrade = meta[fruitTreeLevel]
	if type(upgrade) ~= "table" or type(upgrade.pickCount) ~= "number" then return 0 end
	local dailyData = UserManager:getInstance():getDailyData()
	if type(dailyData) ~= "table" or type(dailyData.pickFruitCount) ~= "number" then return 0 end
	return upgrade.pickCount - dailyData.pickFruitCount
end