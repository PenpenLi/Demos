
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014年01月26日 12:06:22
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- AddMaxEnergyPanel
---------------------------------------------------
require "zoo.panelBusLogic.BuyAndUseAddMaxEnergyLogic"
require "zoo.panelBusLogic.SyncBuyAndUseAddMaxEnergyLogic"

assert(not AddMaxEnergyPanel)
AddMaxEnergyPanel = class(BasePanel)

function AddMaxEnergyPanel:init(energyPanel, maxTopPosYInWorldSpace, flyEnergyTargetPosInWorldSpace, ...)
	assert(type(maxTopPosYInWorldSpace) == "number")
	assert(flyEnergyTargetPosInWorldSpace)
	assert(#{...} == 0)

	-- Get UI Resource
	self.ui	= self:buildInterfaceGroup("addMaxEnergyPanel")

	-- Init Base Class
	BasePanel.init(self, self.ui)

	-- Get UI Resource
	--self.animPic		= self.ui:getChildByName("animPic")
	self.energyIcon		= self.ui:getChildByName("energyIcon")
	self.desLabel		= self.ui:getChildByName("desLabel")
	self.addMaxLimitBtn	= self.ui:getChildByName("addMaxLimitBtn")

	--assert(self.animPic)
	assert(self.energyIcon)
	assert(self.desLabel)
	assert(self.addMaxLimitBtn)


	-----------------------
	-- Create UI Componenet
	-- -------------------
	
	-- Create Animal Picture
	self.animalPic	= Sprite:createWithSpriteFrameName("npc_small_10000")

	if self.animalPic then
		self.animalPic:setAnchorPoint(ccp(0,1))
		self:addChild(self.animalPic)
	end

	-- Create Buy Btn
	self.buyBtn	= ButtonIconNumberBase:create(self.addMaxLimitBtn)
	self.buyBtn:setColorMode(kGroupButtonColorMode.blue)

	-----------
	-- Data
	-- ---------
	self.maxTopPosYInWorldSpace 		= maxTopPosYInWorldSpace
	self.flyEnergyTargetPosInWorldSpaceX	= flyEnergyTargetPosInWorldSpace.x
	self.flyEnergyTargetPosInWorldSpaceY	= flyEnergyTargetPosInWorldSpace.y

	self.energyPanel = energyPanel


	---------------
	-- Update View
	-- --------------

	local desLabelKey	= "add.max.energy.panel.des"
	local desLabelValue	= Localization:getInstance():getText(desLabelKey, {number = 40})
	self.desLabel:setString(desLabelValue)

	local goodsMeta = MetaManager.getInstance():getGoodMetaByItemID(100)
	if __ANDROID then -- ANDROID
		self.buyBtn:setIcon(nil)
		self.buyBtn:setNumber(Localization:getInstance():getText("buy.gold.panel.money.mark")..tostring(goodsMeta.rmb / 100))
	else -- else, on IOS and PC we use gold!
		self.buyBtn:setIconByFrameName("ui_images/ui_image_coin_icon_small0000", true)
		self.buyBtn:setNumber(goodsMeta.qCash)
	end
	self.buyBtn:setString(Localization:getInstance():getText("add.max.energy.panel.buy.btn.txt", {}))

	------------------------
	-- Add Event Listener
	-- -----------------
	local function onBuyBtnTapped()
		self:onBuyBtnTapped()
	end

	self.buyBtn:addEventListener(DisplayEvents.kTouchTap, onBuyBtnTapped)
end

function AddMaxEnergyPanel:onBuyBtnTapped(...)
	assert(#{...} == 0)

	local function startBuyAndUseAddMaxEnergyLogic()
		self:startBuyAndUseAddMaxEnergyLogic()
	end

	if RequireNetworkAlert:popout() then
		self:startBuyAndUseAddMaxEnergyLogic()
	end
end

function AddMaxEnergyPanel:startBuyAndUseAddMaxEnergyLogic(...)
	assert(#{...} == 0)

	if not self.isStartBuyAndUseAddMaxEnergyLogicCalled then
		self.isStartBuyAndUseAddMaxEnergyLogicCalled = true

		local function onAddMaxSuccess()
			print("AddMaxEnergyPanel:onBuyBtnTapped Calleld !! onAddMaxSuccess !!")

			-- Play Flying Energy Anim
			local function onFlyingEnergyAnimFinished()
				self:remove()
				-- Update 
				HomeScene:sharedInstance():checkDataChange()
				HomeScene:sharedInstance().energyButton:updateView()
				self.energyPanel:playAddEnergyAnim(false)
				self.energyPanel:updateAfterMaxEnergyChange()
			end

			self:playFlyingEnergyAnim(ccp(self.flyEnergyTargetPosInWorldSpaceX, self.flyEnergyTargetPosInWorldSpaceY), onFlyingEnergyAnimFinished)
		end

		local function onAddMaxFailed(event)
			self.isStartBuyAndUseAddMaxEnergyLogicCalled = false

			if event and event.data == 730330 then
				-- Not Has Enough Money

				local function createGoldPanel()
					local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
					if index ~= 0 then
						local panel = createMarketPanel(index)
						panel:popout()
					end
				end
				local text = {
					tip = Localization:getInstance():getText("buy.prop.panel.tips.no.enough.cash"),
					yes = Localization:getInstance():getText("buy.prop.panel.yes.buy.btn"),
					no = Localization:getInstance():getText("buy.prop.panel.not.buy.btn"),
				}
				CommonTipWithBtn:setShowFreeFCash(true)
				CommonTipWithBtn:showTip(text, "negative", createGoldPanel)

			elseif event and event.data then
				CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative")
			else
				CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative")
			end
		end

		local function onAddMaxCanceled()
			self.isStartBuyAndUseAddMaxEnergyLogicCalled = false
		end

		-- if UserManager:getInstance().user:getCash() < MetaManager.getInstance():getGoodMetaByItemID(100).qCash then 
		-- 	local event = {}
		-- 	event.data = 730330
		-- 	onAddMaxFailed(event)
		-- 	return
		-- end

		local timeType 		= AddMaxEnergyTimeType.PERMANENT
		local energyType	= AddMaxEnergyType.MAX_ENERGY_40
		--local logic = BuyAndUseAddMaxEnergyLogic:create(timeType, energyType)
		if __ANDROID then -- ANDROID, no sync allowed 'cause no network
			local logic	= BuyAndUseAddMaxEnergyLogic:create(timeType, energyType)
			logic:start(onAddMaxSuccess, onAddMaxFailed, onAddMaxCanceled)
		else -- else, on IOS and PC we sync and then use gold!
			local logic	= SyncBuyAndUseAddMaxEnergyLogic:create(timeType, energyType)
			logic:start(onAddMaxSuccess, onAddMaxFailed, onAddMaxCanceled)
		end
	end
end

function AddMaxEnergyPanel:playFlyingEnergyAnim(flyToPosInWorldSpace, animFinishCallback, ...)
	assert(flyToPosInWorldSpace)
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	if not self.energyIcon then

		if animFinishCallback then
			animFinishCallback()
		end

		return
	end

	-- Remove energyIcon From Self, Add To Scene
	local energyIconPosInWorld = self.energyIcon:getPositionInWorldSpace()
	self.energyIcon:removeFromParentAndCleanup(false)
	local energyIcon = self.energyIcon
	self.energyIcon = nil


	local runningScene = Director:sharedDirector():getRunningScene()
	runningScene:addChild(energyIcon)
	energyIcon:setPosition(ccp(energyIconPosInWorld.x, energyIconPosInWorld.y))


	-- Fly To Action
	local moveToTime = 0.3
	--local moveTo		= CCMoveTo:create(moveToTime, ccp(flyToPosInSelfSpace.x, flyToPosInSelfSpace.y))
	local manualAdjustMoveToPosX	= 10
	local selfEnergyIconSize	= energyIcon:getGroupBounds().size
	local moveTo			= CCMoveTo:create(moveToTime, ccp(flyToPosInWorldSpace.x - selfEnergyIconSize.width/2 + manualAdjustMoveToPosX,
									flyToPosInWorldSpace.y + selfEnergyIconSize.height/2))
	local targetMoveTo		= CCTargetedAction:create(energyIcon.refCocosObj, moveTo)

	-- Fade Out Blue Energy 
	local label 		= energyIcon:getChildByName("label")
	local energyNumberBg	= energyIcon:getChildByName("energyNumberBg")
	local blueEnergyIcon	= energyIcon:getChildByName("energyIcon")


	local fadeOutTime	= 0.2

	local fadeoutTargets = {label, energyNumberBg, blueEnergyIcon}
	local spawnActionArray = CCArray:create()
	for k,v in pairs(fadeoutTargets) do

		local fadeOut 		= CCFadeOut:create(fadeOutTime)
		local targetFadeOut	= CCTargetedAction:create(v.refCocosObj, fadeOut)
		spawnActionArray:addObject(targetFadeOut)
	end

	local fadeOutSpawn = CCSpawn:create(spawnActionArray)

	-- Delay 
	local delay = CCDelayTime:create(0.2)

	-- Anim Finish
	local function animFinishedFunc()

		local energyIconParent = energyIcon:getParent()
		energyIconParent:removeChild(energyIcon, true)

		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishedAction	= CCCallFunc:create(animFinishedFunc)

	-- Seq
	--local seq = CCSequence:createWithTwoActions(targetMoveTo, animFinishedAction)
	
	local actionArray = CCArray:create()
	actionArray:addObject(targetMoveTo)
	actionArray:addObject(fadeOutSpawn)
	actionArray:addObject(delay)
	actionArray:addObject(animFinishedAction)

	local seq = CCSequence:create(actionArray)
	energyIcon:runAction(seq)
end

function AddMaxEnergyPanel:popout(...)
	assert(#{...} == 0)

	print("AddMaxEnergyPanel:popout Called !")
	PopoutManager:sharedInstance():add(self, false, true)

	self:playFadeInAnim()
	self:positionSelf()

	-- Update Last Opened Time
	CCUserDefault:sharedUserDefault():setDoubleForKey("addMaxEnergyPanel_lastOpenedTime", Localhost.getInstance():time())
end

function AddMaxEnergyPanel:playFadeInAnim(...)
	assert(#{...} == 0)

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

function AddMaxEnergyPanel:playFadeOutAnim(animFinishCallback, ...)
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

function AddMaxEnergyPanel:remove(...)
	assert(#{...} == 0)

	print("AddMaxEnergyPanel:remove Called !")

	if not self.isRemoveCalled then
		self.isRemoveCalled = true

		local function onAnimFinished()
			if self and not self.isDisposed then
				PopoutManager:sharedInstance():remove(self)
			end
		end

		self:playFadeOutAnim(onAnimFinished)
	end
end

function AddMaxEnergyPanel:onCloseBtnTapped()
	if self.energyPanel then self.energyPanel:onCloseBtnTapped() end
end

function AddMaxEnergyPanel:create(energyPanel, maxTopPosYInWorldSpace, flyEnergyTargetPosInWorldSpace, ...)
	assert(type(maxTopPosYInWorldSpace) == "number")
	assert(flyEnergyTargetPosInWorldSpace)
	assert(#{...} == 0)

	local newAddMaxEnergyPanel = AddMaxEnergyPanel.new()
	newAddMaxEnergyPanel:loadRequiredResource(PanelConfigFiles.panel_energy_bubble)
	newAddMaxEnergyPanel:init(energyPanel, maxTopPosYInWorldSpace, flyEnergyTargetPosInWorldSpace)
	return newAddMaxEnergyPanel
end

function AddMaxEnergyPanel:positionSelf(...)
	assert(#{...} == 0)

	-- Position Self To The Bottom Of The Screen
	local selfSize		= self:getGroupBounds().size
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()

	local deltaWidth	= visibleSize.width - selfSize.width
	--local deltaHeight	= visibleSize.height - selfSize.height

	local selfParent	= self:getParent()

	-- Target Position In Screen Space
	if selfParent then

		local pos = selfParent:convertToNodeSpace(ccp(visibleOrigin.x + deltaWidth/2, 
								self.maxTopPosYInWorldSpace))

		local manualAdjustPosY		= 140
		self:setPosition(ccp(pos.x, pos.y + manualAdjustPosY))
	end

	-- Position Animal Picture
	if self.animalPic then

		local animalParent 	= self.animalPic:getParent()
		local animalPicSize	= self.animalPic:getGroupBounds().size

		local pos = animalParent:convertToNodeSpace(ccp(visibleOrigin.x,
							visibleOrigin.y + animalPicSize.height))

		self.animalPic:setPosition(ccp(pos.x, pos.y))
	end
end
