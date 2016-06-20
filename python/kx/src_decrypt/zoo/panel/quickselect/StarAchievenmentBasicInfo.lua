
---------------------------------------------------
---------------------------------------------------
-------------- StarRewardItem2
---------------------------------------------------
---------------------------------------------------

assert(not StarRewardItem2)
assert(BaseUI)
StarRewardItem2 = class(BaseUI)

function StarRewardItem2:create(ui, itemId, itemNumber, ...)
	assert(ui)
	assert(type(itemId) == "number")
	assert(type(itemNumber) == "number")
	assert(#{...} == 0)

	local newStarRewardItem2 = StarRewardItem2.new()
	newStarRewardItem2:init(ui, itemId, itemNumber)
	return newStarRewardItem2
end

function StarRewardItem2:init(ui, itemId, itemNumber, ...)
	assert(ui)
	assert(type(itemId) == "number")
	assert(type(itemNumber) == "number")
	assert(#{...} == 0)

	------------------
	-- Init Base Class
	-- ---------------
	BaseUI.init(self, ui)

	-----------------
	-- Get UI Resource
	-- ---------------
	self.numberLabel	= self.ui:getChildByName("numberLabel")
	self.numberLabelFontSize = self.ui:getChildByName("numberLabel_fontSize")
	self.numberLabel = TextField:createWithUIAdjustment(self.numberLabelFontSize, self.numberLabel)

	self.itemNameLabel	= self.ui:getChildByName("itemNameLabel")
	self.itemPh		= self.ui:getChildByName("itemPh")

	assert(self.numberLabel)
	assert(self.itemNameLabel)
	assert(self.itemPh)

	---------
	-- Data
	-- -------
	self.itemId	= itemId
	self.itemNumber	= itemNumber

	-----------------
	-- Get Data About itemPh
	-- -------------------
	self.itemPhPos	= self.itemPh:getPosition()
	self.itemPhSize	= self.itemPh:getGroupBounds().size
	self.itemPhSize = {width = self.itemPhSize.width, height = self.itemPhSize.height}
	self.itemPh:setVisible(false)

	-------------
	-- Create Item Icon
	-- -----------------
	--if not self.itemId or self.itemId <= 0 then
		--self.itemId = ItemType.COIN --itemId必须有值，否则会不创建self.itemRes，造成ui层会crash
		--正常情况下，如果没有itemId，则根本不会弹板
	--end
	self:rebuild(self.itemId,self.itemNumber)
end

function StarRewardItem2:rebuild(itemId, itemNumber, ...)
	self.itemId	= itemId
	self.itemNumber	= itemNumber

	if self.itemId > 0 then
		if self.itemRes then self.itemRes:removeFromParentAndCleanup(true) end

		local itemRes	= ResourceManager:sharedInstance():buildItemGroup(self.itemId)
		self.itemRes	= itemRes
		self.ui:addChild(itemRes)

		--------------------------------
		-- Resize And Position Item Res
		-- ---------------------------
		-- Resize
		local itemResSize	= itemRes:getGroupBounds().size
		local neededScaleX	= self.itemPhSize.width / itemResSize.width
		local neededScaleY	= self.itemPhSize.height / itemResSize.height
		
		local smallestScale = neededScaleX
		if neededScaleX > neededScaleY then
			smallestScale = neededScaleY
		end

		itemRes:setScaleX(smallestScale)
		itemRes:setScaleY(smallestScale)
		-- itemRes:setScaleX(1.2)
		-- itemRes:setScaleY(1.2)

		-- Reposition
		local itemResSize	= itemRes:getGroupBounds().size
		local deltaWidth	= self.itemPhSize.width - itemResSize.width
		local deltaHeight	= self.itemPhSize.height - itemResSize.height
		
		itemRes:setPosition(ccp( self.itemPhPos.x + deltaWidth/2, 
					self.itemPhPos.y - deltaHeight/2))

		----------------
		-- Update View
		-- --------------
		local itemNameKey	= "prop.name." .. self.itemId
		local itemNameValue	= Localization:getInstance():getText(itemNameKey, {})
		self.itemNameLabel:setString(itemNameValue)

		self.numberLabel:removeFromParentAndCleanup(false)
		self.ui:addChild(self.numberLabel)

		self.numberLabel:setString("x" .. self.itemNumber)
	end
end




---------------------------------------------------
---------------------------------------------------
-------------- StarBasicInfo 
---------------------------------------------------
---------------------------------------------------
assert(not StarBasicInfoPanel)
assert(BaseUI)
StarBasicInfoPanel = class(BaseUI)

function StarBasicInfoPanel:create(ui, itemId, itemNumber, ...)
	assert(ui)
	-- assert(type(itemId) == "number")
	-- assert(type(itemNumber) == "number")
	-- assert(#{...} == 0)

	local panel = StarBasicInfoPanel.new()
	panel:init(ui, itemId, itemNumber)
	return panel
end

function StarBasicInfoPanel:init(ui, itemId, itemNumber, ...)
	------------------
	-- Init Base Class
	-- ---------------
	BaseUI.init(self, ui)

	self:initData()

	self:initUI()
end

function StarBasicInfoPanel:initData()
	self:caculateStarInfo()
end


function StarBasicInfoPanel:initUI()
	self.rewardHolder = self.ui:getChildByName("reward_holder")
	self.mcOpenSoon = self.ui:getChildByName("mc_open_soon")
	self.mcGetNone = self.ui:getChildByName("mc_get_none")
	self.mcRewardFlashHolder = self.ui:getChildByName("mc_reward_flash_holder")
	self.starIcon = self.ui:getChildByName("star_icon")
	self.starBaseX = self.starIcon:getPositionX()
	self.starSlice = self.ui:getChildByName("star_txt_slice")
	self.starSliceBaseX = self.starSlice:getPositionX()
	
	self.starCountNotEnough = TextField:createWithUIAdjustment(self.ui:getChildByName("star_count_fontsize"), self.ui:getChildByName("star_count_not_enough"))
	self.starCount = TextField:createWithUIAdjustment(self.ui:getChildByName("star_count_fontsize"), self.ui:getChildByName("star_count"))
	self.starNeedCount = TextField:createWithUIAdjustment(self.ui:getChildByName("star_need_count_fontsize"), self.ui:getChildByName("star_need_count"))

	self.getRewardButton = GroupButtonBase:create(self.ui:getChildByName("get_reward"))	
end

function  StarBasicInfoPanel:createGetRewardFlashAnimation()

	local function seqCallback(sp)
		print("seqCallback remove from parent ...----------")
		sp:stopAllActions()
		sp:removeFromParentAndCleanup(true)
	end

	local a = CommonEffect:buildGetPropLightAnimWithoutBg()
	a:setCascadeOpacityEnabled(true)
	a:setScale(0.1)
	
	-- action1 is a sequence
	local delayAction = CCDelayTime:create(0.5)	
	local fadeAction = CCFadeOut:create(0.5)

	local s1Array = CCArray:create()
	s1Array:addObject(delayAction)
	s1Array:addObject(fadeAction)
	s1Array:addObject(CCCallFunc:create(
		    function()
			    return seqCallback(a)
			end
	))
	local s1Action = CCSequence:create(s1Array)

	-- action2
	local scaleToAction = CCScaleTo:create(0.2, 1)

	-- -------------- spawn -----------------
	local action = CCSpawn:createWithTwoActions(
		scaleToAction,
		s1Action)

	a:runAction(action)
	return a

	-- self.mcRewardFlashHolder:addChild(self:createGetRewardFlashAnimation())
end

function StarBasicInfoPanel:updateView()

	self.getRewardButton:setColorMode(kGroupButtonColorMode.green)
	-- self.getRewardButton:useBubbleAnimation()
	-- self.getRewardButton:setPositionY(self.getRewardButton:getPositionY() - 25)

	if self.rewardLevelToPushMeta then
		-- 有奖励，但星星等级不够
		local delta = self.rewardLevelToPushMeta.starNum - self.curTotalStar
		if delta > 0 then
			self.getRewardButton:setString(Localization:getInstance():getText('mystar_getbutton_no',{num = delta}))
			self.getRewardButton:setEnabled(false)
			self.getRewardButton.groupNode:stopAllActions()
			
		else
			self.getRewardButton:setString(Localization:getInstance():getText('mystar_getbutton_yes'))
			self.getRewardButton:setEnabled(true)
			self.getRewardButton:useBubbleAnimation()
			self.getRewardButton:addEventListener(DisplayEvents.kTouchTap, handler(self,self.ongetRewardButtonTapped))
		end
		self.mcGetNone:setVisible(false)
		self.mcOpenSoon:setVisible(false)
	-- 没有奖励了
	else
		self.mcGetNone:setVisible(true)
		self.mcOpenSoon:setVisible(true)
		self.getRewardButton:setVisible(false)
		self.rewardHolder:getChildByName("itemPh"):setVisible(false)
		self.rewardHolder:getChildByName("numberLabel_fontSize"):setVisible(false)
		self.rewardHolder:getChildByName("itemNameLabel"):setVisible(false)
		if (self.rewardItem) then 
			self.rewardItem.itemRes:setVisible(false)
			self.rewardItem.numberLabel:setVisible(false)
		end 
		
		self.getRewardButton:setString(Localization:getInstance():getText('mystar_getbutton_yes'))
		self.getRewardButton:setEnabled(false)
		self.getRewardButton.groupNode:stopAllActions()
	end
	
	if self.rewardLevelToPushMeta then
		if (self.rewardItem) then 
			self.rewardItem:rebuild(self.rewardItemId, self.rewardItemCount)
		else
			self.rewardItem	= StarRewardItem2:create(self.rewardHolder, self.rewardItemId, self.rewardItemCount)
		end
	end

	self.normalStar = (UserManager:getInstance().user:getStar())
	self.hiddenStar = (UserManager:getInstance().user:getHideStar())
	self.totalStar = (UserManager:getInstance():getFullStarInOpenedRegionInclude4star() + MetaModel.sharedInstance():getFullStarInOpenedHiddenRegion())

	-- local n = self.normalStar + self.hiddenStar
	-- local d = self.totalStar
	-- 分子 
	local n = self.curTotalStar
	-- 分母
	local d = self.rewardLevelToPushMeta and self.rewardLevelToPushMeta.starNum or 0

	self.displayedN = n
	self.displayedD = d

	self.starCount:removeFromParentAndCleanup(false)
	self.starNeedCount:removeFromParentAndCleanup(false)
	self.starCountNotEnough:removeFromParentAndCleanup(false)
	self.ui:addChild(self.starCount)
	self.ui:addChild(self.starCountNotEnough)
	self.ui:addChild(self.starNeedCount)

	self.starCount:setString(tostring(n))
	self.starCountNotEnough:setString(tostring(n))

	if (self:isEnoughStar()) then 
		self.starCount:setVisible(true)
		self.starCountNotEnough:setVisible(false)
	else
		self.starCount:setVisible(false)
		self.starCountNotEnough:setVisible(true)
	end

	if self.rewardLevelToPushMeta then
		self.starNeedCount:setString(tostring(d))
	else
		self.starNeedCount:setString("?")
	end

	-- action 
	local actionBy = CCScaleBy:create(0.2, 1.5)
	self.starNeedCount:setAnchorPoint(ccp(0.5,0.5))
	-- self.starNeedCount:ignoreAnchorPointForPosition(false)
	self.starNeedCount:runAction(CCSequence:createWithTwoActions(actionBy, actionBy:reverse()))

	-- 位置微调，蛋碎一地
	if (n > 999) then
		self.starIcon:setPositionX(self.starBaseX - 23)
	elseif (n > 99 ) then 
		local donothing = ""
	elseif (n > 9) then
		local donothing = ""
	else 
		self.starIcon:setPositionX(self.starBaseX + 20)
	end

	if (d > 999) then
		self.starNeedCount:setPositionX(self.starSliceBaseX + 70)
	elseif (d > 99 ) then 
		local donothing = ""
	elseif (d > 9) then
		self.starNeedCount:setPositionX(self.starSliceBaseX + 50)
	else 
		self.starNeedCount:setPositionX(self.starSliceBaseX + 40)
	end
	self.starNeedCount:setPositionY(self.starNeedCount:getPositionY() - 1)
end

-- ===========================================
-- ===========================================
-- 				Logic 
-- ===========================================
-- ===========================================
function StarBasicInfoPanel:caculateStarInfo()
	-- Get Current Star
	self.curTotalStar 	= UserManager:getInstance().user:getTotalStar()
	local userExtend 	= UserManager:getInstance().userExtend

	-- Get RewardLevelMeta 
	local nearestStarRewardLevelMeta	= MetaManager.getInstance():starReward_getRewardLevel(self.curTotalStar)
	local nextRewardLevelMeta		= MetaManager.getInstance():starReward_getNextRewardLevel(self.curTotalStar)
	local rewardLevelToPushMeta 		= false

	if nearestStarRewardLevelMeta then
		local rewardLevelToPush = userExtend:getFirstNotReceivedRewardLevel(nearestStarRewardLevelMeta.id)

		if rewardLevelToPush then
			-- Has Reward Level
			rewardLevelToPushMeta = MetaManager.getInstance():starReward_getStarRewardMetaById(rewardLevelToPush)
		else
			-- All Reward Level Has Received
		end
	end

	if not rewardLevelToPushMeta then
		-- If Has Next Reward Level, Show It
		if nextRewardLevelMeta then
			rewardLevelToPushMeta = nextRewardLevelMeta
		end
	end

	self.rewardLevelToPushMeta =  rewardLevelToPushMeta

	local itemId		= 0
	local itemNumber	= 0

	if rewardLevelToPushMeta then
		assert(rewardLevelToPushMeta)
		print(rewardLevelToPushMeta.reward[1].num)
		print(rewardLevelToPushMeta.reward[1].itemId)

		self.rewardItemId		= rewardLevelToPushMeta.reward[1].itemId
		self.rewardItemCount	= rewardLevelToPushMeta.reward[1].num
	end
end

-- 是否有足够星星数
function StarBasicInfoPanel:isEnoughStar()
	if (not self.rewardLevelToPushMeta) then 
		return false
	end
	return self.curTotalStar >= self.rewardLevelToPushMeta.starNum
end


function StarBasicInfoPanel:ongetRewardButtonTapped(event, ...)
	assert(#{...} == 0)

	print("StarBasicInfoPanel:ongetRewardButtonTapped")

	if (__isQQ) then 
		return
	end

	if false == self.getRewardButton.isEnabled then
		return
	end


	if self.rewardLevelToPushMeta and not self:isEnoughStar() then
		-- self:popoutMoreStarPanel()
		print("not enough star")
	else
		RequireNetworkAlert:callFuncWithLogged(handler(self,self.getReward))
	end

end


function StarBasicInfoPanel:getReward(...)
	assert(#{...} == 0)
	print("StarBasicInfoPanel:getReward")

	-- local function onSendGetRewardMsgSuccess(event)
	-- 	self:caculateStarInfo()
	-- 	self:updateView(true)
	-- end

	local function onSendGetRewardMsgSuccess(event)

		-- @TBD delete
		self.mcRewardFlashHolder:addChild(self:createGetRewardFlashAnimation())



		print("StarRewardPanel:ongetRewardButtonTapped Called ! onSendGetRewardMsgSuccess ")
		if self.isDisposed then
			return
		end

		-- Play The Flying Reward Anim
		print("StarRewardPanel:ongetRewardButtonTapped onSendGetRewardMsgSuccess Called !")

		local rewardIds = {}
		local rewardAmounts = {}

		if type(event.data) == "table" and type(event.data.rewardItems) == "table" then
			for k1,v1 in pairs(event.data.rewardItems) do
				local itemId 		= v1.itemId
				local itemNumber	= v1.num
				table.insert(rewardIds, itemId)
				table.insert(rewardAmounts, itemNumber)
			end
		end

		local anims = HomeScene:sharedInstance():createFlyingRewardAnim(rewardIds, rewardAmounts)
		print("number of anims : " .. #anims)

		-- Get Item Pos In World Space
		local itemResPosInWorld = self.rewardItem.itemRes:getPositionInWorldSpace()
		-- self.rewardItem.itemRes:setVisible(false)
		anims[1]:setPosition(ccp(itemResPosInWorld.x, itemResPosInWorld.y))

		-- Get Item Size
		local  itemResScale	= self.rewardItem.itemRes:getScale()
		anims[1]:setScale(itemResScale)

		local function onAnimFinished()

			if self.isDisposed then
				return
			end

			local delay = CCDelayTime:create(0.5)

			local function removeSelf()
				self.getRewardButton:setEnabled(true)
				self:remove()

				print("after animation ========================")
				self:caculateStarInfo()
				self:updateView(true)


				-- 奖励领取变化，可能影响星星icon展现
				local scene = HomeScene:sharedInstance()
				if scene then
					if scene.starButton then 
						scene.starButton:updateView() 
					end
				end

			end
			local callAction = CCCallFunc:create(removeSelf)

			local seq = CCSequence:createWithTwoActions(delay, callAction)
			self:runAction(seq)
		end

		--------------------------------------------------------
		-- number-decreasing animation
		--------------------------------------------------------
		local item = self.rewardItem
		local label = item.numberLabel
		local num = item.itemNumber
		local interval = 0.2 -- the same value from function HomeScene:createFlyToBagAnimation
		local function __decreaseNumber()
			if num >= 1 then
				num = num - 1
				-- trible reference checks
				if label and not label.isDisposed and label.refCocosObj then 
					label:setString('x'..num)
					setTimeOut(__decreaseNumber, interval)
				end
			end
		end
		setTimeOut(__decreaseNumber, interval)

		anims[1]:playFlyToAnim(onAnimFinished)
	end

	local function onSendGetRewardMsgFail(evt)

		if self.isDisposed then
			return
		end

		self.getRewardButton:setEnabled(true)
		
		local code
		if evt and evt.data then code = tonumber(evt.data) end
		-- CommonTip, change error tip
		if code then 
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..code), "negative")
			-- 已经领过奖，刷新到下一个			
			if (tonumber(code) == 730690) then
				self:caculateStarInfo()
				self:updateView(true)
			end
		else
			local networkType = MetaInfo:getInstance():getNetworkInfo();
			local errorCode = "-2";
			if networkType and networkType==-1 then 
				errorCode = "-6";
			end
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..errorCode), "negative")
		end
		-- @TBD QQStarRewardPanel 224
		-- self:onSendGetRewardMsgFail(code) 
	end

	local function onSendGetRewardMsgCancel()
		print("onSendGetRewardMsgCancel")
		if self.isDisposed then
			return
		end

		self.getRewardButton:setEnabled(true)
	end

	print("send SyncGetStarRewardLogic")
	self.getRewardButton:setEnabled(false)
	local rewardLevel = self.rewardLevelToPushMeta.id
	local logic	= GetStarRewardsLogic:create(rewardLevel)
	logic:setSuccessCallback(onSendGetRewardMsgSuccess)
	logic:setFailCallback(onSendGetRewardMsgFail)
	logic:setCancelCallback(onSendGetRewardMsgCancel)
	logic:start()	-- Default Show The Communicating Tip, And Block The Touch
end

function StarBasicInfoPanel:remove(...)
	assert(#{...} == 0)
	print("StarBasicInfoPanel:remove Called !")

	if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then 
		self.btnTappedState = self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED
	else
		return
	end

	local function onHideAnimFinished()
		PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)

		if self.closeCallback then
			self.closeCallback()
		end
	end
	
	-- self.showHideAnim:playHideAnim(onHideAnimFinished)
end