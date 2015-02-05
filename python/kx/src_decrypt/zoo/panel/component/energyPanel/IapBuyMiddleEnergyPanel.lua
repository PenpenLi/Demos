require "zoo.panel.basePanel.BasePanel"

IapBuyMiddleEnergyPanel = class(BasePanel)

function IapBuyMiddleEnergyPanel:create(energyPanel, buyCallback, maxTopPosYInWorldSpace)
	local panel = IapBuyMiddleEnergyPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_energy_bubble)
	if panel:_init(energyPanel, buyCallback, maxTopPosYInWorldSpace) then
		return panel
	else
		panel = nil
		return nil
	end
end

function IapBuyMiddleEnergyPanel:_init(energyPanel, buyCallback, maxTopPosYInWorldSpace)
	-- data
	self.maxTopPosYInWorldSpace = maxTopPosYInWorldSpace
	self.energyPanel = energyPanel
	local data = IapBuyPropLogic:midEnergyBottle()
	local meta = MetaManager:getInstance():getGoodMeta(data.goodsId)

	-- init panel
	self.ui	= self:buildInterfaceGroup("IapBuyMidEnergyPanel")
	BasePanel.init(self, self.ui)
	self:scaleAccordingToResolutionConfig()

	-- get & create controls
	local icon = self.ui:getChildByName("icon")
	local text = self.ui:getChildByName("text")
	local button = ButtonNumberBase:create(self.ui:getChildByName("button"))
	local gold = self.ui:getChildByName("gold")
	local charge = self.ui:getChildByName("charge")
	local chargeLine = self.ui:getChildByName("chargeline")
	local discount = self.ui:getChildByName("discount")
	local animalPic = Sprite:createWithSpriteFrameName("npc_small_10000")
	self.button = button
	self.animalPic = animalPic

	-- set controls
	local builder = InterfaceBuilder:create(PanelConfigFiles.properties)
	local sprite = builder:buildGroup("Prop_10013")
	local sBound = sprite:getGroupBounds().size
	sBound = {width = sBound.width, height = sBound.height}
	local rBound = icon:getGroupBounds().size
	local scale = rBound.width / sBound.width
	if rBound.height / sBound.height < scale then
		scale = rBound.height / sBound.height
	end
	sprite:setScale(scale)
	sprite:setPositionX(icon:getPositionX() + (rBound.width - sBound.width * scale) / 2)
	sprite:setPositionY(icon:getPositionY() - (rBound.height - sBound.height * scale) / 2)
	self.ui:addChild(sprite)
	icon:removeFromParentAndCleanup(true)

	sprite = builder:buildGroup("Prop_14")
	sBound = sprite:getGroupBounds().size
	sBound = {width = sBound.width, height = sBound.height}
	rBound = gold:getGroupBounds().size
	scale = rBound.width / sBound.width
	if rBound.height / sBound.height < scale then
		scale = rBound.height / sBound.height
	end
	sprite:setScale(scale)
	sprite:setPositionX(gold:getPositionX() + (rBound.width - sBound.width * scale) / 2)
	sprite:setPositionY(gold:getPositionY() - (rBound.height - sBound.height * scale) / 2)
	self.ui:addChild(sprite)
	gold:removeFromParentAndCleanup(true)

	charge:setDimensions(CCSizeMake(0, 0))
	charge:setString(meta.qCash..' ')
	local tBound = charge:getContentSize()
	local lBound = chargeLine:getContentSize()
	chargeLine:setPositionXY(charge:getPositionX(), charge:getPositionY())
	chargeLine:setScaleX(tBound.width / lBound.width)
	chargeLine:setScaleY(tBound.height / lBound.height)

	text:setString(Localization:getInstance():getText("energy.panel.iap.buy.middle.energy"))

	button:setColorMode(kGroupButtonColorMode.blue)
	button:setNumber(Localization:getInstance():getText("buy.gold.panel.money.mark")..data.price)
	button:setString(Localization:getInstance():getText("buy.prop.panel.btn.buy.txt"))

	local disNum = discount:getChildByName("num")
	local disText = discount:getChildByName("text")
	disNum:setString(tostring(math.ceil(meta.discountRmb / meta.rmb * 10)))
	disText:setString(Localization:getInstance():getText("buy.gold.panel.discount"))
	local scaleBase = discount:getScale()
	local actArray = CCArray:create()
	actArray:addObject(CCDelayTime:create(5))
	actArray:addObject(CCScaleTo:create(0.1, scaleBase * 0.95))
	actArray:addObject(CCScaleTo:create(0.1, scaleBase * 1.1))
	actArray:addObject(CCScaleTo:create(0.2, scaleBase * 1))
	discount:runAction(CCRepeatForever:create(CCSequence:create(actArray)))

	self.animalPic:setAnchorPoint(ccp(0, 1))
	self.animalPic:setScale(1 / self:getScale())
	self:addChild(self.animalPic)

	local function onBuy()
		local function onSuccess()
			if buyCallback then buyCallback() end
		end
		local function onFail()
			button:setEnabled(true)
			CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative")
		end
		button:setEnabled(false)
		self:_onBuyMidEnergy(data, onSuccess, onFail)
	end
	button:addEventListener(DisplayEvents.kTouchTap, onBuy)

	return true
end

function IapBuyMiddleEnergyPanel:popout()
	PopoutManager:sharedInstance():add(self, false, true)
	if self.animalPic then
		print("self position", self:getPositionX(), self:getPositionY())
		print("animal position", self.animalPic:getPositionX(), self.animalPic:getPositionY())
	end
	self:_playFadeInAnim()
	self:_calcPosition()
end

function IapBuyMiddleEnergyPanel:remove()
	local function onAnimFinished()
		if self and not self.isDisposed then
			PopoutManager:sharedInstance():remove(self)
		end
	end

	self.button:setEnabled(false)
	self:_playFadeOutAnim(onAnimFinished)
end

function IapBuyMiddleEnergyPanel:_calcPosition()
	local selfSize = self:getGroupBounds().size
	local vOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local vSize = CCDirector:sharedDirector():getVisibleSize()
	local deltaWidth = vSize.width - selfSize.width
	local selfParent = self:getParent()

	print("selfParent", selfParent)
	if selfParent and self.maxTopPosYInWorldSpace then
		local pos = selfParent:convertToNodeSpace(ccp(vOrigin.x + deltaWidth / 2, self.maxTopPosYInWorldSpace))
		local manualAdjustPosY = 95
		self:setPosition(ccp(pos.x, pos.y + manualAdjustPosY))
	end

	if self.animalPic then
		local animalParent 	= self.animalPic:getParent()
		local animalPicSize	= self.animalPic:getGroupBounds().size
		local pos = animalParent:convertToNodeSpace(ccp(vOrigin.x, vOrigin.y + animalPicSize.height))

		self.animalPic:setPosition(ccp(pos.x, pos.y))
	end
	
end

function IapBuyMiddleEnergyPanel:_playFadeInAnim()
	local visibleChildren = {}
	self:getVisibleChildrenList(visibleChildren)

	-- Fade In Time
	local fadeInTime	= 0.3

	for k,v in pairs(visibleChildren) do
		local fadeInAction = CCFadeIn:create(fadeInTime)
		v:runAction(fadeInAction)
	end
	local function onFinish() self.allowBackKeyTap = true end
	self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(fadeInTime), CCCallFunc:create(onFinish)))
end

function IapBuyMiddleEnergyPanel:_playFadeOutAnim(animFinishCallback, ...)
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	local visibleChildren = {}
	self:getVisibleChildrenList(visibleChildren)

	-- Fade Out Time
	local fadeOutTime	= 0.3

	-- ------------------
	-- Individual Fade out
	-- --------------------
	self.allowBackKeyTap = false
	local spawnActionArray = CCArray:create()
	for k,v in pairs(visibleChildren) do
		local fadeOutAction 	= CCFadeOut:create(fadeOutTime)
		local targetAction	= CCTargetedAction:create(v.refCocosObj, fadeOutAction)
		--actionArray:addObject(targetAction)
		spawnActionArray:addObject(targetAction)
	end
	local spawn = CCSpawn:create(spawnActionArray)


	-- -------------------
	-- Anim Finish Callback
	-- -------------------
	local function animFinishedFunc()
		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishedAction = CCCallFunc:create(animFinishedFunc)

	----------
	-- Seq
	-- --------
	-- Action Array
	local actionArray = CCArray:create()
	actionArray:addObject(spawn)
	actionArray:addObject(animFinishedAction)

	local seq = CCSequence:create(actionArray)

	self:runAction(seq)
end

function IapBuyMiddleEnergyPanel:_onBuyMidEnergy(data, successCallback, failCallback)
	IapBuyPropLogic:buy(data, successCallback, failCallback)
end

function IapBuyMiddleEnergyPanel:onCloseBtnTapped()
	if self.energyPanel then self.energyPanel:onCloseBtnTapped() end
end