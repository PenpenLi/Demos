require "zoo.panel.basePanel.BasePanel"
require "zoo.panel.seasonWeekly.SeasonWeeklyRaceManager"

SeasonWeeklyRaceSharePanel = class(BasePanel)

function SeasonWeeklyRaceSharePanel:create(rewards, levelId, rank, surpass)
	local panel = SeasonWeeklyRaceSharePanel.new()
	panel:init(rewards, levelId, rank, surpass)
	return panel
end

local assumeShareReward = {itemId = 2, num = 100}

function SeasonWeeklyRaceSharePanel:init(rewards, levelId, rank, surpass)
	self:loadRequiredResource("ui/panel_summer_weekly_share.json")
	local ui = self:buildInterfaceGroup('SummerWeeklyRacePanel/SharePanel')
	BasePanel.init(self, ui)

	self.levelId = levelId
	self.place = rank
	self.rewards = self:mergeRewards(rewards or {})
	self.surpass = surpass or 0

	local shareTitle = ui:getChildByName("shareTitle")
	local title = shareTitle:getChildByName("shareTitle")
	title:setText(Localization:getInstance():getText("weeklyrace.winter.panel.achievement4", {num = self.surpass}))
	local size = title:getContentSize()
	title:setPositionX(-size.width / 2)

	local anim = ui:getChildByName("anim")
	self.items = {}
	local bubble = anim:getChildByName("bubble")
	bubble.item = bubble:getChildByName("icon")
	bubble.item:setVisible(false)
	for i,v in ipairs(rewards) do
		if v.itemId == ItemType.COIN then
			local sprite = Sprite:createWithSpriteFrameName("SummerWeeklyRacePanel/img/coinbagsmall0000")
			local size = sprite:getContentSize()
			local icon = bubble:getChildByName("icon")
			local iSize = icon:getGroupBounds(bubble).size
			sprite:setAnchorPoint(ccp(0, 1))
			sprite:setScale(math.min(iSize.width / size.width, iSize.height / size.height))
			sprite:setPositionXY(icon:getPositionX(), icon:getPositionY())
			bubble:addChildAt(sprite, bubble:getChildIndex(icon))
			local num = bubble:getChildByName("num")
			num:setText('x'..tostring(v.num))
			size = num:getContentSize()
			num:setPositionX(-size.width / 2)
			bubble.itemId = ItemType.COIN
			bubble.num = v.num
			table.insert(self.items, bubble)
		end
	end

	local button = GroupButtonBase:create(ui:getChildByName("shareBtn"))
	button:setString(Localization:getInstance():getText("weeklyrace.winter.panel.button1"))
	button:addEventListener(DisplayEvents.kTouchTap, function() self:onBtnTapped() end)
	self.button = button

	local btnTag = ui:getChildByName("btnTag")
	local shareReward = assumeShareReward
	local icon = btnTag:getChildByName("icon")
	icon:setVisible(false)
	local sprite
	if shareReward.itemId == 2 then
		sprite = ResourceManager:sharedInstance():buildGroup("itemIcon2")
	elseif shareReward.itemId == 14 then
		sprite = Sprite:createWithSpriteFrameName("wheel0000")
		sprite:setAnchorPoint(ccp(0, 1))
	else
		if ItemType:isTimeProp(shareReward.itemId) then
			ItemType:getRealIdByTimePropId(shareReward.itemId)
		end
		sprite = ResourceManager:sharedInstance():buildItemGroup(shareReward.itemId)
	end
	local size = sprite:getGroupBounds().size
	size = {width = size.width, height = size.height}
	local iSize = icon:getGroupBounds().size
	sprite:setScale(iSize.width / size.width)
	if sprite:getScale() > iSize.height / size.height then
		sprite:setScale(iSize.height / size.height)
	end
	sprite:setPositionX(icon:getPositionX() + (iSize.width - size.width * sprite:getScale()) / 2)
	sprite:setPositionY(icon:getPositionY() - (iSize.height - size.height * sprite:getScale()) / 2)
	btnTag:addChildAt(sprite, btnTag:getChildIndex(icon))
	local number = btnTag:getChildByName("number")
	number:setText('+'..tostring(shareReward.num))
	local nSize = number:getContentSize()
	number:setPositionX(icon:getPositionX() + (iSize.width - nSize.width) / 2)
	btnTag:setVisible(false)

	local shareTip = ui:getChildByName("shareTip")
	local firstShare = SeasonWeeklyRaceManager:getInstance():isDailyFirstShare()
	shareTip:setVisible(firstShare)

	self:scaleAccordingToResolutionConfig()
	self:setPositionForPopoutManager()
	self:setPositionY(self:getPositionY() - 20)

	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local vSize = Director:sharedDirector():getVisibleSize()
	local bg
	if _G.__use_small_res then
		bg = Sprite:create("materials/weeklyShareBg@2x.png")
	else
		bg = Sprite:create("materials/weeklyShareBg.png")
	end
	bg:setAnchorPoint(ccp(0, 1))
	print(vSize.height)
	bg:setScale(vSize.height / 1280 / self:getScale())
	local side = (960 - 1280 * vSize.width / vSize.height) / 2
	bg:setPositionXY(-self:getPositionX() / self:getScale() - side / self:getScale(), -self:getPositionY() / self:getScale())
	self:addChildAt(bg, 0)

	local close = ui:getChildByName("closeBtn")
	close:setPositionX((vSize.width - self:getPositionX()) / self:getScale() - 40)
	close:setPositionY(-self:getPositionY() / self:getScale() - 40)
	close:setTouchEnabled(true)
	close:setButtonMode(true)
	close:addEventListener(DisplayEvents.kTouchTap, function() self:onCloseBtnTapped() end)
	self.close = close

	local shareTitle = ui:getChildByName("shareTitle")
	local title = ui:getChildByName("title")
	title:setScale(1.3)
	title:setPositionX(shareTitle:getPositionX()+5)
	title:setPositionY(-self:getPositionY() / self:getScale() - 100)
	local mid = title:getChildByName("mid")
	mid:setText(tostring(self.place))
	local size = mid:getContentSize()
	mid:setPositionX(-size.width / 2)
	mid:setPositionY(mid:getPositionY() + 25)
	local left = title:getChildByName("left")
	left:setDimensions(CCSizeMake(0, 0))
	left:setString(Localization:getInstance():getText("weeklyrace.winter.panel.desc13"))
	size = left:getContentSize()
	left:setPositionX(mid:getPositionX() - size.width - 20)
	local right = title:getChildByName("right")
	right:setDimensions(CCSizeMake(0, 0))
	right:setString(Localization:getInstance():getText("weeklyrace.winter.panel.desc14"))
	size = right:getContentSize()
	right:setPositionX(-mid:getPositionX() + 20)

	self:setAnimation(ui)
end

-- used by main panel and feed, so common parts only
function SeasonWeeklyRaceSharePanel:buildUI(ui, hiddenRewards)
	local rewardsData = self.rewards
	local friends = self.surpass

	local shareTitle = ui:getChildByName("shareTitle")
	local title = shareTitle:getChildByName("shareTitle")
	title:setText(Localization:getInstance():getText("weeklyrace.winter.panel.achievement4", {num = friends}))
	local size = title:getContentSize()
	title:setPositionX(-size.width / 2)

	local skipSavingItem = false
	if not self.items then self.items = {}
	else skipSavingItem = true end
	for i = 1, 1 do
		local bubble = ui:getChildByName("bubble"..tostring(i))
		local icon = bubble:getChildByName("icon")
		icon:setVisible(false)
		local reward = rewardsData[i]
		if reward and not hiddenRewards then
			local itemId = reward.itemId
			local sprite
			if itemId == 2 then
				sprite = ResourceManager:sharedInstance():buildGroup("stackIcon")
			elseif itemId == 14 then
				sprite = Sprite:createWithSpriteFrameName("wheel0000")
				sprite:setAnchorPoint(ccp(0, 1))
			else
				if ItemType:isTimeProp(itemId) then
					ItemType:getRealIdByTimePropId(itemId)
				end
				sprite = ResourceManager:sharedInstance():buildItemGroup(itemId)
			end
			local size = sprite:getGroupBounds().size
			size = {width = size.width, height = size.height}
			local iSize = icon:getGroupBounds().size
			sprite:setScale(iSize.width / size.width)
			if sprite:getScale() > iSize.height / size.height then
				sprite:setScale(iSize.height / size.height)
			end
			sprite:setPositionX(icon:getPositionX() + (iSize.width - size.width * sprite:getScale()) / 2)
			sprite:setPositionY(icon:getPositionY() - (iSize.height - size.height * sprite:getScale()) / 2)
			bubble:addChildAt(sprite, bubble:getChildIndex(icon))

			local num = bubble:getChildByName("num")
			num:setText('x'..tostring(rewardsData[i].num))
			size = num:getContentSize()
			num:setPositionX(icon:getPositionX() - (size.width - iSize.width)/2)
			if not skipSavingItem then
				table.insert(self.items, {item = sprite, itemId = rewardsData[i].itemId, num = rewardsData[i].num})
			end
		else
			bubble:setVisible(false)
		end
	end
end

function SeasonWeeklyRaceSharePanel:onBtnTapped()
	local function onSuccess()
		if self.isDisposed then return end
		self:playAnim()
		local function showTip(tip)
	        local scene = Director:sharedDirector():getRunningScene()
	        if scene then
	            local panel = CommonTip:create(tip, 2, nil, 4)
	            if not panel then
	                return
	            end
	            function panel:removeSelf()
	                if not scene.isDisposed then
	                    scene:superRemoveChild(self,true)
	                end
	            end
	            local winSize = Director:sharedDirector():getVisibleSize()
	            while panel:getPositionY() < 0 or panel:getPositionY() > winSize.height do
	                if panel:getPositionY() < 0 then
	                    panel:setPositionY(panel:getPositionY() + winSize.height)
	                end
	                if panel:getPositionY() > winSize.height then
	                    panel:setPositionY(panel:getPositionY() - winSize.height)
	                end
	            end
	            scene:superAddChild(panel)
	        end
	    end
		local function onTimeOut()
			if self.isDisposed then return end
			local function onSuccess(isAddCount)
				if self.isDisposed then return end
				if isAddCount then
					showTip(Localization:getInstance():getText("weeklyrace.winter.panel.tip4"), "positive")
				else
					if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
						showTip(Localization:getInstance():getText("share.feed.success.tips.mitalk"), "positive")
					else
						showTip(Localization:getInstance():getText("share.feed.success.tips"), "positive")
					end
				end
				DcUtil:doShareWeeklyRankSuccess()
				self:onCloseBtnTapped()
			end
			local function onFail(evt)
				if self.isDisposed then return end
				if evt and evt.data then
					showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
				else
					if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
						showTip(Localization:getInstance():getText("share.feed.faild.tips.mitalk"), "negative")
					else
						showTip(Localization:getInstance():getText("share.feed.faild.tips"), "negative")
					end
				end
				self:onCloseBtnTapped()
			end
			local function onCancel()
				if self.isDisposed then return end
				if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
					showTip(Localization:getInstance():getText("share.feed.cancel.tips.mitalk"), "negative")
				else
					showTip(Localization:getInstance():getText("share.feed.cancel.tips"), "negative")
				end
				self:onCloseBtnTapped()
			end
			self:shareMessage(onSuccess, onFail, onCancel)
		end
		setTimeOut(onTimeOut, 2)
	end
	local function onFail(evt)
		if self.isDisposed then return end
		-- CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
		self.button:setEnabled(true)
	end
	local function onCancel()
		if self.isDisposed then return end
		self.button:setEnabled(true)
	end
	DcUtil:clickWeeklyRankShareBtn()
	self.button:setEnabled(false)
	setTimeOut(function()
		if self.isDisposed then return end
		self.button:setEnabled(true)
	end, 2)
	self:getReward(onSuccess, onFail, onCancel)
end

local function createRisingBubble(ui, left, width)
	local function doBubbleAnim(bubble, finishCallback)
		local deltaX, deltaY = math.random() * 70 - 35, math.random() * 100 + 350
		local opacity = math.random() * 80 + 70
		local deltaTime = math.random() * 2.8 + 2
		local arr1 = CCArray:create()
		arr1:addObject(CCEaseSineOut:create(CCMoveBy:create(deltaTime / 4, ccp(deltaX, 0))))
		arr1:addObject(CCEaseSineIn:create(CCMoveBy:create(deltaTime / 4, ccp(-deltaX, 0))))
		arr1:addObject(CCEaseSineOut:create(CCMoveBy:create(deltaTime / 4, ccp(-deltaX, 0))))
		arr1:addObject(CCEaseSineIn:create(CCMoveBy:create(deltaTime / 4, ccp(deltaX, 0))))
		local arr2 = CCArray:create()
		arr2:addObject(CCFadeTo:create(deltaTime / 6, opacity))
		arr2:addObject(CCDelayTime:create(deltaTime * 2 / 3))
		arr2:addObject(CCFadeTo:create(deltaTime / 6, 0))
		local arr3 = CCArray:create()
		arr3:addObject(CCMoveBy:create(deltaTime, ccp(0, deltaY)))
		arr3:addObject(CCCallFunc:create(finishCallback))
		local arr = CCArray:create()
		arr:addObject(CCSequence:create(arr1))
		arr:addObject(CCSequence:create(arr2))
		arr:addObject(CCSequence:create(arr3))
		bubble:runAction(CCSpawn:create(arr))
	end

	local bubble = Sprite:createWithSpriteFrameName("ui_images/ui_bubble_10000")
	local bubbleLayer = SpriteBatchNode:createWithTexture(bubble:getTexture())
	ui:addChildAt(bubbleLayer, 0)
	local function createBubbleAnim()
		local bubble = Sprite:createWithSpriteFrameName("ui_images/ui_bubble_10000")
		bubble:setScale(math.random() * 0.3 + 0.2)
		bubble:setPositionXY(math.random() * width + left)
		bubble:setOpacity(0)
		bubbleLayer:addChildAt(bubble, 1)
		doBubbleAnim(bubble, function()
				bubble:removeFromParentAndCleanup(true)
				createBubbleAnim()
			end)
	end

	for i = 1, 4 do
		ui:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(math.random() * 3 + 0.3), CCCallFunc:create(createBubbleAnim)))
	end
end

function SeasonWeeklyRaceSharePanel:setAnimation(ui)
	local shareTitle = ui:getChildByName("shareTitle")
	shareTitle:setScale(0)
	shareTitle:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1),
		CCEaseBackOut:create(CCScaleTo:create(0.1, 1))))
	local childList = {}
	shareTitle:getVisibleChildrenList(childList)
	for i, v in ipairs(childList) do
		v:setOpacity(0)
		v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCEaseIn:create(CCFadeIn:create(0.1))))
	end

	local anim = ui:getChildByName('anim')
	local npc = anim:getChildByName('npc')
	local shine = anim:getChildByName('shine1')
	shine:setAnchorPointCenterWhileStayOrigianlPosition()
	local shine2 = anim:getChildByName('shine2')
	shine2:setAnchorPointCenterWhileStayOrigianlPosition()
	local shine3 = anim:getChildByName('shine3')
	shine3:setAnchorPointCenterWhileStayOrigianlPosition()
	local bubble = anim:getChildByName('bubble')

	npc:ignoreAnchorPointForPosition(false)
	npc:setAnchorPointCenterWhileStayOrigianlPosition()
	local position = npc:getPosition()
	position = ccp(position.x, position.y)
	local scale = npc:getScale()
	npc:setPositionY(0)
	npc:setScale(0.5)
	npc:setVisible(false)
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.1))
	array:addObject(CCToggleVisibility:create())
	array:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.2, scale), CCEaseBackOut:create(CCMoveTo:create(0.3, position))))
	npc:runAction(CCSequence:create(array))

	local position = bubble:getPosition()
	position = ccp(position.x, position.y)
	local scale = bubble:getScale()
	bubble:setPositionXY(0, 0)
	bubble:setScale(0)
	bubble:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCSpawn:createWithTwoActions(CCScaleTo:create(0.2, scale),
		CCEaseBackOut:create(CCMoveTo:create(0.2, position)))))

	shine:setScale(0)
	shine:runAction(CCRepeatForever:create(CCRotateBy:create(1, 60)))
	shine:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCScaleTo:create(0.2, 6)))

	shine2:setScale(0)
	shine2:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCSpawn:createWithTwoActions(CCEaseSineOut:create(CCFadeOut:create(0.3)),
		CCScaleTo:create(0.3, 3))))

	shine3:setScale(0)
	shine3:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCSpawn:createWithTwoActions(CCEaseSineOut:create(CCFadeOut:create(0.3)),
		CCScaleTo:create(0.3, 2.2))))

	FrameLoader:loadArmature("skeleton/season_weekly_panel_animation", "season_weekly_panel_animation", "season_weekly_panel_animation")
 	local armature = ArmatureNode:create("SeasonWeeklyPanelAnimation/bubble")
 	armature:setPositionXY(shine:getPositionX(), shine:getPositionY())
 	anim:addChildAt(armature, anim:getChildIndex(npc))
 	armature:update(0.001)
 	armature:setAnimationScale(1)
 	armature:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.15), CCCallFunc:create(function()
 			armature:playByIndex(0)
 		end)))

	createRisingBubble(anim, -360, 720)
end

function SeasonWeeklyRaceSharePanel:runFireworkAction()
	local fireworkTable = {}
	local timerId = nil 
	for i=1,5 do
		local firework = SpriteColorAdjust:createWithSpriteFrameName("yanhua_0000.png")
		firework:setAnchorPoint(ccp(0.5, 0.5))
		if i==1 then 
			firework:setPosition(ccp(-70,-150))
			firework:setScale(1.5)
		elseif i==2 then 
			firework:setPosition(ccp(-10,-20))
			firework:setScale(1.5)
		elseif i==3 then 
			firework:setPosition(ccp(120,20))
			firework:setScale(1.5)
		elseif i==4 then 
			firework:setPosition(ccp(280,-30))
			firework:setScale(1.3)
		elseif i==5 then 
			firework:setPosition(ccp(210,-110))
			firework:setScale(2.5)
		end
		table.insert(fireworkTable, firework)
	end
	local fireworkIndex = 1
	local function playFireWork()
		if fireworkIndex>5 or self.isDisposed then 
			if timerId then 
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timerId)
			end
			timerId = nil
			return
		end
		local firework = fireworkTable[fireworkIndex]
		self.ui:addChild(firework)
		firework:play(SpriteUtil:buildAnimate(SpriteUtil:buildFrames("yanhua_%04d.png", 0, 41), 1/20), 0, 1, nil, true)
		fireworkIndex = fireworkIndex + 1
	end
	timerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(playFireWork,0.1,false);
end

function SeasonWeeklyRaceSharePanel:popout(onClosed)
	self.allowBackKeyTap = true
	self.onClosedCallback = onClosed
	PopoutManager:sharedInstance():add(self)
end

function SeasonWeeklyRaceSharePanel:onCloseBtnTapped()
	self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self)
	SeasonWeeklyRaceManager:getInstance():setLastWeekRankRewardsCancelFlag()
	if self.onClosedCallback then self.onClosedCallback() end
end

function SeasonWeeklyRaceSharePanel:dispose()
	BasePanel.dispose(self)
	if _G.__use_small_res then
 		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("share/yanhua@2x.plist")
 	else
		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("share/yanhua.plist")
	end
end

function SeasonWeeklyRaceSharePanel:playAnim()
	local scene = HomeScene:sharedInstance()
	if not scene then return end
	scene:checkDataChange()
	for i, v in ipairs(self.items) do
		if v.itemId == 2 then
			local config = {updateButton = true,}
			local anim = HomeSceneFlyToAnimation:sharedInstance():coinStackAnimation(config)
			local position = v.item:getPosition()
			local wPosition = v.item:getParent():convertToWorldSpace(ccp(position.x, position.y))
			anim.sprites:setPosition(ccp(wPosition.x + 100, wPosition.y - 90))
			scene:addChild(anim.sprites)
			anim:play()
		elseif v.itemId == 14 then
			local num = v.num
			if num > 10 then num = 10 end
			local config = {number = num, updateButton = true,}
			local anim = HomeSceneFlyToAnimation:sharedInstance():goldFlyToAnimation(config)
			local position = v.item:getPosition()
			local size = v.item:getGroupBounds().size
			local wPosition = v.item:getParent():convertToWorldSpace(ccp(position.x + size.width / 4, position.y - size.height / 4))
			for i, v2 in ipairs(anim.sprites) do
				v2:setPosition(ccp(wPosition.x, wPosition.y))
				v2:setScaleX(v.item:getScaleX())
				v2:setScaleY(v.item:getScaleY())
				scene:addChild(v2)
			end
			anim:play()
		else
			local num = v.num
			if num > 10 then num = 10 end
			local config = {propId = v.itemId, number = num, updateButton = true,}
			local anim = HomeSceneFlyToAnimation:sharedInstance():jumpToBagAnimation(config)
			local position = v.item:getPosition()
			local size = v.item:getGroupBounds().size
			local wPosition = v.item:getParent():convertToWorldSpace(ccp(position.x + size.width / 8, position.y - size.height / 8))
			for i, v2 in ipairs(anim.sprites) do
				v2:setPosition(ccp(wPosition.x, wPosition.y))
				v2:setScaleX(v.item:getScaleX())
				v2:setScaleY(v.item:getScaleY())
				scene:addChild(v2)
			end
			anim:play()
		end
	end
end

function SeasonWeeklyRaceSharePanel:mergeRewards(rewardTable)
	local rewards = {}
	for i, v in ipairs(rewardTable) do
		local found = false
		for i2, v2 in ipairs(rewards) do
			if v2.itemId == v.itemId then
				found = true
				v2.num = v2.num + v.num
				break
			end
		end
		if not found then
			table.insert(rewards, {itemId = v.itemId, num = v.num})
		end
	end
	return rewards
end

function SeasonWeeklyRaceSharePanel:getReward(successCallback, failCallback, cancelCallback)
	local function onSuccess()
		if successCallback then successCallback() end
	end
	local function onFail()
		if failCallback then failCallback() end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end
	SeasonWeeklyRaceManager:getInstance():receiveLastWeekRankRewards(self.levelId, onSuccess, onFail, onCancel)
end

function SeasonWeeklyRaceSharePanel:shareMessage(successCallback, failCallback, cancelCallback)
	local function onSuccess(isAddCount)
		if successCallback then successCallback(isAddCount) end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt) end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end

	local group = self:buildInterfaceGroup("SummerWeeklyRacePanel/SharePanelFeedWinter")
	local numLabel = group:getChildByName("num")
	numLabel:setText(tostring(self.surpass))

	local contentSize = numLabel:getContentSize()
	local pos = numLabel:getPosition()
	local xDelta = -contentSize.width
	local yDelta = -contentSize.width * math.tan(math.rad(10))
	numLabel:setPosition(ccp(pos.x + xDelta, pos.y + yDelta))
	
	local filePath = WeeklyShareUtil.buildShareImageWinter(group)

	local title = ""
	local text = ""
	if filePath then
		SeasonWeeklyRaceManager:getInstance():snsShare(filePath, title, text, onSuccess, onFail, onCancel)
	else
		if failCallback then failCallback() end
	end
end