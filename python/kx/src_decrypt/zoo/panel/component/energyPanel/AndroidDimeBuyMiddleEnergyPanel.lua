require "zoo.panel.basePanel.BasePanel"
require "zoo.panelBusLogic.IngamePaymentLogic"

AndroidDimeBuyMiddleEnergyPanel = class(BasePanel)

function AndroidDimeBuyMiddleEnergyPanel:create(energyPanel, buyCallback, maxTopPosYInWorldSpace)
	local panel = AndroidDimeBuyMiddleEnergyPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_energy_bubble)
	if panel:_init(energyPanel, buyCallback, maxTopPosYInWorldSpace) then
		return panel
	else
		panel = nil
		return nil
	end
end

local goodsId = 162
function AndroidDimeBuyMiddleEnergyPanel:_init(energyPanel, buyCallback, maxTopPosYInWorldSpace)
	-- data
	self.maxTopPosYInWorldSpace = maxTopPosYInWorldSpace
	self.energyPanel = energyPanel
	local meta = MetaManager:getInstance():getGoodMeta(goodsId)

	-- init panel
	self.ui	= self:buildInterfaceGroup("AndroidDimeBuyMidEnergyPanel")
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

	text:setString(Localization:getInstance():getText("energy.panel.dime.buy.middle.energy"))

	button:setColorMode(kGroupButtonColorMode.blue)
	button:setNumber(Localization:getInstance():getText("buy.gold.panel.money.mark")..meta.discountRmb / 100)
	button:setString(Localization:getInstance():getText("buy.prop.panel.btn.buy.txt"))

	local disNum = discount:getChildByName("num")
	local disText = discount:getChildByName("text")
	disNum:setString(tostring(math.ceil(meta.discountRmb / meta.rmb * 100) / 10))
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
		local function onCancel()
			button:setEnabled(true)
		end
		button:setEnabled(false)
		self:_onBuyMidEnergy(onSuccess, onFail, onCancel)
	end
	button:addEventListener(DisplayEvents.kTouchTap, onBuy)

	return true
end

function AndroidDimeBuyMiddleEnergyPanel:popout()
	PopoutManager:sharedInstance():add(self, false, true)
	self:_playFadeInAnim()
	self:_calcPosition()
end

function AndroidDimeBuyMiddleEnergyPanel:remove()
	local function onAnimFinished()
		if self and not self.isDisposed then
			PopoutManager:sharedInstance():remove(self)
		end
	end

	self.button:setEnabled(false)
	self:_playFadeOutAnim(onAnimFinished)
end

function AndroidDimeBuyMiddleEnergyPanel:_calcPosition()
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

function AndroidDimeBuyMiddleEnergyPanel:_playFadeInAnim()
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

function AndroidDimeBuyMiddleEnergyPanel:_playFadeOutAnim(animFinishCallback, ...)
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

function AndroidDimeBuyMiddleEnergyPanel:_onBuyMidEnergy(successCallback, failCallback, cancelCallback)
	local function onSuccess()
		UserManager:getInstance():getUserExtendRef():setFlagBit(7)
		if successCallback then successCallback() end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt.data) end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end
	local logic = IngamePaymentLogic:create(goodsId)
	logic:buy(onSuccess, onFail, onCancel)
end

function AndroidDimeBuyMiddleEnergyPanel:onCloseBtnTapped()
	if self.energyPanel then self.energyPanel:onCloseBtnTapped() end
end

function AndroidDimeBuyMiddleEnergyPanel:checkCanPop()
	if UserManager:getInstance():getUserExtendRef():isFlagBitSet(7) then return false end -- Already bought one
	if UserManager:getInstance():getUserRef():getTopLevelId() < 20 then return false end -- Level demand

	local lastPayTime = UserManager:getInstance():getUserExtendRef():getLastPayTime()
	local time = Localhost:time()
	local lastPopout = CCUserDefault:sharedUserDefault():getFloatForKey("AndroidDimeBuyMiddleEnergyPop")
	if lastPopout < 631123200000 then lastPopout = 631123200000 end
	if time - tonumber(lastPayTime) <= 2592000000 then return false end -- didn't buy anything in 30 days
	if compareDate(os.date("*t", time / 1000), os.date("*t", lastPopout / 1000)) == 0 then
		return false -- popout within 24 hours
	end

	local logic = IngamePaymentLogic:create(goodsId)
	local decisionType, paymentType = logic:getPaymentDecision()
	if decisionType ~= IngamePaymentDecisionType.kPayWithType or paymentType ~= Payments.CHINA_MOBILE then
		return false -- payment type is not china mobile mm
	end

	local ok = false

	local platform = PlatformConfig:getPlatformAuthName()
	if type(platform) ~= "string" then ok = true -- can't get platform
	else
		local targetPlatforms = UserManager:getInstance():getDimePlatforms()
		if type(targetPlatforms) ~= "table" then return false end

		for k, v in ipairs(targetPlatforms) do
			if string.lower(v) == "default" or platform == string.lower(v) then
				ok = true -- is one of the target platforms
				break
			end
		end
		if not ok then return false end
	end

	local province = Cookie.getInstance():read(CookieKey.kLocationProvince)
	if not province then ok = true -- can't get province
	else
		local targetProvince = UserManager:getInstance():getDimeProvinces()
		if type(targetProvince) ~= "table" then return false end

		for k, v in ipairs(targetProvince) do
			if string.lower(v) == "default" or province == v then
				ok = true -- is one of the target provinces
				break
			end
		end
		if not ok then return false end
	end

	CCUserDefault:sharedUserDefault():setFloatForKey("AndroidDimeBuyMiddleEnergyPop", Localhost:time())
	return true
end