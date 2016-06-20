
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月11日 16:01:34
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.panel.component.common.BubbleItem"
---------------------------------------------------
-------------- PreGameToolItem
---------------------------------------------------

local totalSubtractedCoin		= 0

assert(not PreGameToolItem)
--assert(BaseUI)
--PreGameToolItem = class(BaseUI)

assert(BubbleItem)
PreGameToolItem = class(BubbleItem)

function PreGameToolItem:init(ui, itemId, levelId, ...)
	assert(ui)
	assert(itemId)
	assert(type(itemId) == "number")
	assert(levelId)
	assert(type(levelId) == "number")
	assert(#{...} == 0)

	self.resourceManager = ResourceManager:sharedInstance()

	-- --------------
	-- Get UI Resource
	-- ---------------
	self.ui = ui
	self.priceLabel			= self.ui:getChildByName("priceLabel")
	self.unlockLabel		= self.ui:getChildByName("unlockLabel")
	self.lock			= self.ui:getChildByName("lock")
	self.checkIcon			= self.ui:getChildByName("checkIcon")
	self.coinIcon			= self.ui:getChildByName("coinIcon")
	self.bubbleItem			= self.ui:getChildByName("bubbleItem")

	assert(self.priceLabel)
	assert(self.unlockLabel)
	assert(self.lock)
	assert(self.checkIcon)
	assert(self.coinIcon)
	assert(self.bubbleItem)

	-- -----------------
	-- Init Base Class
	-- -------------------
	BubbleItem.init(self, self.bubbleItem, itemId)

	------------------
	-- Get Data About UI
	----------------------
	local labelColor = self.priceLabel:getColor()
	self.priceLabelOriginColor = ccc3(labelColor.r, labelColor.g, labelColor.b)

	--  ------------------
	--  Init UI Resource
	--  ----------------
	self.checkIcon:setVisible(false)
	self:setNumberVisible(false)
	self.priceLabel:setVisible(false)
	self.unlockLabel:setVisible(false)
	
	local newAnchorPoint = ccp(0.5,0)
	self.lock:setAnchorPointWhileStayOriginalPosition(newAnchorPoint)

	local size = self.priceLabel:getGroupBounds().size
	local position = self.priceLabel:getPosition()
	self.animLabel = LabelBMMonospaceFont:create(20, 35, 15, "fnt/target_amount.fnt")
	self.animLabel:setAnchorPoint(ccp(0, 1))
	self.animLabel:setPosition(ccp(position.x - 20, position.y))
	self.animLabel:setVisible(false)
	self:addChild(self.animLabel)
	self.iconPos = {x = self.coinIcon:getPosition().x, y = self.coinIcon:getPosition().y}

	
	-- -------
	-- Data
	-- -------
	self.selected			= false
	self.itemId			= itemId
	self.levelId			= levelId
	self.locked			= false
	self.price			= false

	-- Get Property Attribute
	local propData = MetaManager.getInstance().prop[self.itemId]
	assert(propData)

	-- Check If Locked
	local unLockLevel = propData.unlock
	assert(unLockLevel)

	if unLockLevel > self.levelId then
		self.locked = true
	else
		self.locked = false
	end

	-- Get Property Price
	local propAsGoodsData = false

	local goodsDataTable = MetaManager.getInstance().goods
	
	assert(goodsDataTable)
	for k,v in pairs(goodsDataTable) do
		if v.items[1].itemId == self.itemId then
			propAsGoodsData = v
		end
	end
	assert(propAsGoodsData)

	self.price = propAsGoodsData.coin
	assert(self.price)

	---------------------
	---- Update View
	--------------------
	if self.locked then
		-- Locked
		self.lock:setVisible(true)
		self.unlockLabel:setVisible(true)
		self.priceLabel:setVisible(false)

		self.coinIcon:setVisible(false)

		local stringKey		= "start.game.panel.unlock.txt"
		local stringValue 	= Localization:getInstance():getText(stringKey, {level_number = unLockLevel})
		self.unlockLabel:setString(stringValue)
		self.unlockLabel:setAnchorPointCenterWhileStayOrigianlPosition()
	else
		-- Unlocked
		self.lock:setVisible(false)
		self.unlockLabel:setVisible(false)
		self.priceLabel:setVisible(true)

		self.priceLabel:setString(self.price)
		self.animLabel:setString('-'..tostring(self.price))
	end

	self:updatePriceColor()

	-----------------
	-- Get Data About UI
	-- ------------------
	--self.priceLabelOriginalScaleX = self.priceLabel:getScaleX()
	--self.priceLabelOriginalScaleY = self.priceLabel:getScaleY()
	self.unlockLabelOriginalScaleX	= self.unlockLabel:getScaleX()
	self.unlockLabelOriginalScaleY	= self.unlockLabel:getScaleY()

	--------------
	-- Play Animation
	-- ----------------
	self:playBubbleNormalAnim(true)
end

function PreGameToolItem:createShakeLockAction(...)
	assert(#{...} == 0)

	local rotateAngle 	= 10
	local rotateTime	= 0.05

	local actionArray = CCArray:create()
	
	-- Rotate
	local rotateLeft 	= CCRotateTo:create(rotateTime, -rotateAngle)
	local rotateRight	= CCRotateTo:create(rotateTime*2, rotateAngle)
	-- Seq
	local rotate 		= CCSequence:createWithTwoActions(rotateLeft, rotateRight)
	local repeat3Time	= CCRepeat:create(rotate, 3)
	
	-- Rotate To Original
	local rotateOrigin	= CCRotateTo:create(rotateTime, 0)

	actionArray:addObject(repeat3Time)
	actionArray:addObject(rotateOrigin)
	local seq = CCSequence:create(actionArray)
	local targetedSeq = CCTargetedAction:create(self.lock.refCocosObj, seq)

	return targetedSeq
end

function PreGameToolItem:createEnlargeShrinkLabelAction(...)
	assert(#{...} == 0)

	local enlargeScale	= 1.2
	local enlargeDuration	= 0.2
	local restoreDuration	= 0.1

	--local anchorPoint = self.priceLabel:getAnchorPoint()
	--assert(anchorPoint.x == 0.5 and
	--	anchorPoint.y == 0.5)

	--local origScaleX	= self.priceLabel:getScaleX()
	--local origScaleY	= self.priceLabel:getScaleY()
	--local origScaleX	= self.priceLabelOriginalScaleX
	--local origScaleY	= self.priceLabelOriginalScaleY
	local origScaleX	= self.unlockLabelOriginalScaleX
	local origScaleY	= self.unlockLabelOriginalScaleY

	local newScalX	= origScaleX * enlargeScale
	local newScalY	= origScaleY * enlargeScale

	-- Enlarge Action
	local enlarge	= CCScaleTo:create(enlargeDuration, enlargeScale)
	-- Restore To Original
	local restore	= CCScaleTo:create(restoreDuration, origScaleX, origScaleY)
	-- Sequence
	local sequence	= CCSequence:createWithTwoActions(enlarge, restore)
	local targetSeq	= CCTargetedAction:create(self.unlockLabel.refCocosObj, sequence)

	--return sequence
	return targetSeq
end

function PreGameToolItem:playShakeLockAndLabelAnim(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	local shakeLockAct 	= self:createShakeLockAction()
	local labelAction	= self:createEnlargeShrinkLabelAction()
	-- Spawn
	local spawn		= CCSpawn:createWithTwoActions(shakeLockAct, labelAction)

	-- Callback 
	local function animFinish()
		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishAction = CCCallFunc:create(animFinish)

	-- Seq
	local actionArray = CCArray:create()
	--actionArray:addObject(shakeLockAct)
	--actionArray:addObject(labelAction)
	actionArray:addObject(spawn)
	actionArray:addObject(animFinishAction)

	--local seq = CCSequence:createWithTwoActions(shakeLockAct, animFinishAction)
	local seq = CCSequence:create(actionArray)
	self:runAction(seq)
end

function PreGameToolItem:getPrice(...)
	assert(#{...} == 0)

	return self.price
end

function PreGameToolItem:updatePriceColor(...)
	assert(#{...} == 0)
	
	local curCoin = UserManager.getInstance().user:getCoin()
	
	if type(self.price) == 'number' then -- qixi
		if self.price <= curCoin then
			self.priceLabel:setColor(ccc3(self.priceLabelOriginColor.r, 
							self.priceLabelOriginColor.g,
							self.priceLabelOriginColor.b))
		else
			if not self:isSelected() and 
				not self:isLocked() then
				print('updatePriceColor setColor')
				self.priceLabel:setColor(ccc3(255,0,0))
			end
		end
	else
		self.priceLabel:setColor(ccc3(self.priceLabelOriginColor.r, 
							self.priceLabelOriginColor.g,
							self.priceLabelOriginColor.b))
	end
end



function PreGameToolItem:getItemId(...)
	assert(#{...} == 0)

	return self.itemId
end

------------------------------------------
---- About Selected
--------------------------------------

function PreGameToolItem:isSelected(...)
	assert(#{...} == 0)

	return self.selected
end

function PreGameToolItem:setSelected(selected, ...)
	assert(selected ~= nil)
	assert(#{...} == 0)

	if selected then
		-- Select It
		self.selected = true
		self:playBubbleExplodedAnim(false)

	else
		-- UnSelect It
		self.selected = false
		self:playBubbleNormalAnim(true)
	end
end

function PreGameToolItem:playBubbleExplodedAnim(finishCallback)
	if self.isDisposed then return end
	self:stopAllActions()
	self:stopBubbleAnim()
	BubbleItem.playBubbleExplodedAnim(self, finishCallback)
	self.priceLabel:setString(Localization:getInstance():getText("start.game.panel.preprop.item.selected"))
	local position = self.priceLabel:getPosition()
	self.animLabel:stopAllActions()
	self.animLabel:setPosition(ccp(position.x - 20, position.y + 32))
	self.animLabel:setVisible(true)
	self.animLabel:delayFadeOut(0, 1.2)
	self.animLabel:runAction(CCMoveBy:create(1.2, ccp(0, 50)))
	local array = CCArray:create()
	array:addObject(CCFadeOut:create(0.3))
	array:addObject(CCMoveBy:create(0.3, ccp(-20, -50)))
	array:addObject(CCScaleTo:create(0.3, 1.2))
	self.coinIcon:stopAllActions()
	self.coinIcon:runAction(CCSpawn:create(array))
	self.checkIcon:stopAllActions()
	self.checkIcon:setAnchorPointCenterWhileStayOrigianlPosition()
	self.checkIcon:setScale(2)
	self.checkIcon:setOpacity(0)
	self.checkIcon:setVisible(true)
	self.checkIcon:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCSpawn:createWithTwoActions(CCFadeIn:create(0.2), CCScaleTo:create(0.2, 1))))
end

function PreGameToolItem:playBubbleNormalAnim(repeatForever)
	if self.isDisposed then return end
	self:stopAllActions()
	self:stopBubbleAnim()
	BubbleItem.playBubbleNormalAnim(self, repeatForever)
	self.priceLabel:setString(tostring(self.price))
	self.animLabel:stopAllActions()
	self.animLabel:setVisible(false)
	self.coinIcon:stopAllActions()
	self.coinIcon:setPosition(ccp(self.iconPos.x, self.iconPos.y))
	self.coinIcon:setScale(1)
	self.coinIcon:setOpacity(255)
	self.checkIcon:stopAllActions()
	self.checkIcon:setVisible(false)
end

----------------------------------------
------ About Locked
----------------------------------

function PreGameToolItem:isLocked(...)
	assert(#{...} == 0)

	return self.locked
end

function PreGameToolItem:setLocked(lock, ...)
	assert(lock ~= nil)
	assert(#{...} == 0)

	if lock ~= nil then
		assert(type(lock) == "boolean")
	end

	self.locked = lock

	if self.locked then
		self.lock:setVisible(true)
	else 
		self.lock:setVisible(false)
	end
end

function PreGameToolItem:create(ui, itemId, levelId, ...)
	assert(ui)
	assert(itemId)
	assert(type(itemId) == "number")
	assert(levelId)
	assert(type(levelId) == "number")
	assert(#{...} == 0)

	local newPreGameToolItem = PreGameToolItem.new()
	newPreGameToolItem:init(ui, itemId, levelId)
	return newPreGameToolItem
end


-- qixi

function PreGameToolItem:setFreePrice()
	self.price = '免费'
	self.priceLabel:setString('免费')
	self.animLabel:setString('免费')
	self._isFreeItem = true
end

function PreGameToolItem:isFreeItem()
	return self._isFreeItem == true
end