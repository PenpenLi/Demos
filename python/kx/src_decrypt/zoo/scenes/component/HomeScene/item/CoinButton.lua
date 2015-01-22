

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月 1日 20:00:53
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com
--

require "zoo.scenes.component.HomeScene.item.CloudButton"
require "zoo.data.UserManager"

---------------------------------------------------
-------------- CoinButton
---------------------------------------------------

assert(not CoinButton)
assert(CloudButton)

CoinButton = class(CloudButton)

function CoinButton:init(belongScene, ...)
	assert(belongScene)
	assert(#{...} == 0)

	-- Get Resource
	self.ui			= ResourceManager:sharedInstance():buildGroup("newCoinButton")
	assert(self.ui)

	-- -----------------
	-- Init Base Class
	-- -----------------
	CloudButton.init(self, self.ui)

	-- -------------
	-- Get UI Resource
	-- ----------------
	self.blueBubbleItemRes		= self.ui:getChildByName("bubbleItem")
	self.labelPlaceholder 		= self.ui:getChildByName("label")
	self.coinIcon			= self.blueBubbleItemRes:getChildByName("placeHolder")

	assert(self.blueBubbleItemRes)
	assert(self.labelPlaceholder)
	assert(self.coinIcon)

	------------
	-- Init UI
	-- --------
	self.labelPlaceholder:setVisible(false)

	-- Scale Small
	local config 	= UIConfigManager:sharedInstance():getConfig()
	local uiScale	= config.homeScene_uiScale
	self:setScale(uiScale)

	--------------------------
	-- Get Data About UI Component
	-- ----------------------
	local placeholderPreferredSize	= self.labelPlaceholder:getPreferredSize()
	local placeholderPos		= self.labelPlaceholder:getPosition()
	self.placeholderPreferredSize	= placeholderPreferredSize
	self.placeholderPos		= placeholderPos

	-------------------
	-- Create UI Component
	-- -----------------
	self.bubbleItem	= HomeSceneBubbleItem:create(self.blueBubbleItemRes)

	-- Clipping The Bubble
	local stencil		= LayerColor:create()
	stencil:setColor(ccc3(255,0,0))
	stencil:changeWidthAndHeight(132, 71.85 + 30)
	stencil:setPosition(ccp(0, -71.85))
	local cppClipping	= CCClippingNode:create(stencil.refCocosObj)
	local luaClipping	= ClippingNode.new(cppClipping)
	stencil:dispose()
	
	self.ui:addChild(luaClipping)
	self.bubbleItem:removeFromParentAndCleanup(false)
	luaClipping:addChild(self.bubbleItem)


	local charWidth		= 35
	local charHeight	= 35
	local charInterval	= 16
	local fntFile		= "fnt/hud.fnt"
	if _G.useTraditionalChineseRes then fntFile = "fnt/zh_tw/hud.fnt" end
	self.label = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	self.label:setAnchorPoint(ccp(0,1))
	self.ui:addChild(self.label)
	
	self.label:setPosition(ccp(placeholderPos.x, placeholderPos.y))

	--------------
	---- Data
	-------------
	self.belongScene	= belongScene
	self.userRef		= UserManager.getInstance().user
	self.coin 		= self.userRef:getCoin()
	self.displayedCoin	= false
	assert(self.coin)

	local energyLabelKey	= "coin.bubble"
	local energyLabelValue	= Localization:getInstance():getText(energyLabelKey, {ten_thousand = ""})
	self.energyLabelValue	= energyLabelValue

	-- ----------
	-- Update View
	-- -----------
	self:updateView()

	-------------------------------
	-- Update View Then Data Change
	-- -------------------
	self.belongScene:addEventListener(HomeSceneEvents.USERMANAGER_COIN_CHANGE, self.onCoinDataChange, self)
end

function CoinButton:playHighlightAnim(...)
	assert(#{...} == 0)

	--local highlightRes = ResourceManager:sharedInstance():buildGroup("coinHighlightWrapper")
	local highlightRes = ResourceManager:sharedInstance():buildSprite("coinHighlightWrapper")
	self.bubbleItem:playHighlightAnim(highlightRes)
end

function CoinButton:getFlyToPosition()
	local pos = self.coinIcon:getPosition()
	local size = self.coinIcon:getGroupBounds().size
	return self.blueBubbleItemRes:convertToWorldSpace(ccp(pos.x + size.width / 2, pos.y - size.height / 2))
end

function CoinButton:getFlyToSize()
	local size = self.coinIcon:getGroupBounds().size
	size.width, size.height = size.width, size.height
	return size
end

function CoinButton:playBubbleSkewAnim(...)
	assert(#{...} == 0)

	self.bubbleItem:playBubbleSkewAnim()
end

function CoinButton:centerLabel(...)
	assert(#{...} == 0)

	--
	local curLabelPos 	= self.label:getPosition()
	local curLabelSize	= self.label:getContentSize()

	local deltaWidth	= self.placeholderPreferredSize.width - curLabelSize.width
	self.label:setPositionX(self.placeholderPos.x + deltaWidth/2)

	local deltaHeight	= self.placeholderPreferredSize.height - curLabelSize.height
	self.label:setPositionY(self.placeholderPos.y - deltaHeight/2)
end

function CoinButton.onCoinDataChange(event, ...)
	assert(event)
	assert(event.name == HomeSceneEvents.USERMANAGER_COIN_CHANGE)
	assert(event.context)
	assert(#{...} == 0)

	local self = event.context

	local newCoin = UserManager.getInstance().user:getCoin()
	self:setNumber(newCoin)

	print("CoinButton:onCoinDataChange Called !")
	print("New Coin: " .. newCoin)
	--debug.debug()
end

function CoinButton:updateView(...)
	assert(#{...} == 0)

	if self.displayedCoin ~= self.coin then

		self.displayedCoin = self.coin

		local coinString = false

		if self.coin > 100000 then
			coinString = math.floor(self.coin / 10000) .. self.energyLabelValue
		else
			coinString = tostring(self.coin)
		end

		print("CoinButton:updateView " .. coinString)

		self.label:setString(coinString)

		--self.label:setString(tostring(self.coin))
		self:centerLabel()
	end
end

function CoinButton:setNumber(number, ...)
	assert(number)
	assert(#{...} == 0)

	if self.coin == number then
		return
	else
		self.coin = number
		--self:updateView()
	end
end

function CoinButton:create(belongScene, ...)
	assert(belongScene)
	assert(#{...} == 0)

	local newCoinButton = CoinButton.new()
	newCoinButton:init(belongScene)
	return newCoinButton
end
