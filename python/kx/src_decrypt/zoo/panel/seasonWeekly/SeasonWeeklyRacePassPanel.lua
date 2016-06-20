require "zoo.panel.basePanel.BasePanel"
require "zoo.panel.share.ChooseNotiFriendPanel"

SeasonWeeklyRacePassPanel = class(BasePanel)

function SeasonWeeklyRacePassPanel:create(friendIds)
	local panel = SeasonWeeklyRacePassPanel.new()
	panel:init(friendIds)
	return panel
end

local assumeShareReward = {itemId = 2, num = 100}

function SeasonWeeklyRacePassPanel:init(friendIds)
	self:loadRequiredResource("ui/panel_summer_weekly_share.json")
	local ui = self:buildInterfaceGroup('SummerWeeklyRacePanel/PassPanel')
	BasePanel.init(self, ui)

	self:buildUI(ui)

	local realPlistPath, realPngPath = SpriteUtil:addSpriteFramesWithFile("ui/NewSharePanel.plist", "ui/NewSharePanel.png")
	if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("SharePassFriend/cell/blueBear0000") then
		local npc = Sprite:createWithSpriteFrameName("SharePassFriend/cell/blueBear0000")
		npc:setAnchorPoint(ccp(0, 1))
		npc.name = "trophy"
		local trophy = ui:getChildByName("trophy")
		npc:setPositionXY(trophy:getPositionX(), trophy:getPositionY())
		ui:addChildAt(npc, ui:getChildIndex(trophy))
		trophy:removeFromParentAndCleanup(true)
		local chicken = ui:getChildByName("chicken")
		local flyAnimal = Sprite:createWithSpriteFrameName("SharePassFriend/cell/flyAnimal0000")
		flyAnimal.name = "chicken"
		local size = flyAnimal:getContentSize()
		flyAnimal:setPositionXY(chicken:getPositionX() + size.width / 2, chicken:getPositionY() - size.height / 2)
		ui:addChildAt(flyAnimal, ui:getChildIndex(chicken))
		chicken:removeFromParentAndCleanup(true)
	end
	SpriteUtil:removeLoadedPlist("ui/NewSharePanel.plist")
	if not __WP8 then
		CCTextureCache:sharedTextureCache():removeTextureForKey(realPngPath)
		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(realPlistPath)
	else
		CCTextureCache:sharedTextureCache():removeUnusedTextures()
	end

	local button = GroupButtonBase:create(ui:getChildByName("shareBtn"))
	button:setString(Localization:getInstance():getText("weeklyrace.winter.panel.button2"))
	button:addEventListener(DisplayEvents.kTouchTap, function() self:onBtnTapped(friendIds) end)
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

	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local vSize = Director:sharedDirector():getVisibleSize()
	local layer = LayerColor:create()
	layer:setAnchorPoint(ccp(0, 1))
	layer:ignoreAnchorPointForPosition(false)
	layer:changeWidthAndHeight(vSize.width / self:getScale(), vSize.height / self:getScale())
	layer:setColor(ccc3(0, 0, 0))
	layer:setOpacity(176)
	layer:setPositionXY(-self:getPositionX() / self:getScale(), -self:getPositionY() / self:getScale())
	self:addChildAt(layer, 0)

	local close = ui:getChildByName("closeBtn")
	close:setPositionX((vSize.width - self:getPositionX()) / self:getScale() - 40)
	close:setPositionY(-self:getPositionY() / self:getScale() - 40)
	close:setTouchEnabled(true)
	close:setButtonMode(true)
	close:addEventListener(DisplayEvents.kTouchTap, function() self:onCloseBtnTapped() end)
	self.close = close

	self:setAnimation(ui)
end

function SeasonWeeklyRacePassPanel:buildUI(ui)
	local shareTitle = ui:getChildByName("shareTitle")
	local title = shareTitle:getChildByName("shareTitle")
	title:setText(Localization:getInstance():getText("show_off_desc_130"))
	local size = title:getContentSize()
	title:setPositionX(-size.width / 2)
end

function SeasonWeeklyRacePassPanel:onBtnTapped(friendIds)
	local function onSuccess(isAddCount)
		if self.isDisposed then return end
		if isAddCount then
			CommonTip:showTip(Localization:getInstance():getText("weeklyrace.winter.panel.tip4"), "positive")
		else
			CommonTip:showTip(Localization:getInstance():getText("show_off_to_friend_success"), "positive")
		end
		self:onCloseBtnTapped()
	end
	local function onFail(evt)
		if self.isDisposed then return end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
		self.button:setEnabled(true)
	end
	local function onCancel()
		if self.isDisposed then return end
		self.button:setEnabled(true)
	end

	local function onChooseFriend(friendIds)
		if self.isDisposed then return end
		if #friendIds > 0 then
			self.button:setEnabled(false)
			SeasonWeeklyRaceManager:getInstance():sendPassNotify(friendIds, onSuccess, onFail, onCancel)
		else
			CommonTip:showTip(Localization:getInstance():getText("unlock.cloud.panel.request.friend.noselect"), "positive")
		end
	end
	
	local friends = {}
	for i, v in ipairs(friendIds) do
		table.insert(friends, FriendManager:getInstance():getFriendInfo(tostring(v)))
	end
	local panel = ChooseNotiFriendPanel:create(onChooseFriend, friends)
	panel:popout()
end

function SeasonWeeklyRacePassPanel:setAnimation(ui)
	local shareTitle = ui:getChildByName("shareTitle")
	shareTitle:setScale(0)
	shareTitle:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1),
		CCEaseBackOut:create(CCScaleTo:create(0.25, 1))))
	local childList = {}
	shareTitle:getVisibleChildrenList(childList)
	for i, v in ipairs(shareTitle) do
		v:setOpacity(0)
		v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1),
			CCEaseIn:create(CCFadeIn:create(0.25))))
	end

	local chicken = ui:getChildByName("chicken")
	chicken:setPositionY(chicken:getPositionY() - 200)
	chicken:setOpacity(0)
	local function onTimeOut2()
		local array = CCArray:create()
		array:addObject(CCRotateBy:create(0.4, -360))
		array:addObject(CCMoveBy:create(0.4, ccp(-500, 500)))
		chicken:runAction(CCSpawn:create(array))
	end
	local function onTimeOut1()
		local array = CCArray:create()
		local array2 = CCArray:create()
		array2:addObject(CCFadeIn:create(0.2))
		array2:addObject(CCEaseBackOut:create(CCMoveBy:create(0.2, ccp(0, 200))))
		array:addObject(CCSpawn:create(array2))
		array:addObject(CCDelayTime:create(0.15))
		array:addObject(CCCallFunc:create(onTimeOut2))
		chicken:runAction(CCSequence:create(array))
	end
	chicken:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(onTimeOut1)))
	

	local trophy = ui:getChildByName("trophy")
	trophy:setPositionY(trophy:getPositionY() - 200)
	trophy:setOpacity(0)
	array = CCArray:create()
	array:addObject(CCEaseBackOut:create(CCMoveBy:create(0.2, ccp(0, 200))))
	array:addObject(CCFadeIn:create(0.2))
	trophy:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCSpawn:create(array)))

	local circleLightBg = ui:getChildByName("circleLightBg")
	local bg = circleLightBg:getChildByName("bg")
	bg:setAnchorPoint(ccp(0.5, 0.5))
	bg:setPositionXY(0, 0)
	bg:setScale(0)
	bg:runAction(CCRepeatForever:create(CCRotateBy:create(1, 100)))
	bg:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.6), CCScaleTo:create(0.15, 2)))
	local bg1 = circleLightBg:getChildByName("bg1")
	bg1:setAnchorPoint(ccp(0.5, 0.5))
	bg1:setPositionXY(0, 0)
	bg1:setScale(0)
	array = CCArray:create()
	array:addObject(CCScaleTo:create(0.2, 2.2))
	array:addObject(CCEaseOut:create(CCFadeOut:create(0.2)))
	bg1:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.6), CCSpawn:create(array)))
	local bg2 = circleLightBg:getChildByName("bg2")
	bg2:setAnchorPoint(ccp(0.5, 0.5))
	bg2:setPositionXY(0, 0)
	bg2:setScale(0)
	array = CCArray:create()
	array:addObject(CCScaleTo:create(0.2, 2.2))
	array:addObject(CCFadeOut:create(0.2))
	bg2:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.6), CCSpawn:create(array)))
end

function SeasonWeeklyRacePassPanel:popout()
	PopoutManager:sharedInstance():add(self)
	self.allowBackKeyTap = true
end

function SeasonWeeklyRacePassPanel:onCloseBtnTapped()
	self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self)
end

function SeasonWeeklyRacePassPanel:playAnim()
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

-- function SeasonWeeklyRacePassPanel:shareMessage(successCallback, failCallback, cancelCallback)
-- 	local function onSuccess(isAddCount)
-- 		if successCallback then successCallback(isAddCount) end
-- 	end
-- 	local function onFail(evt)
-- 		if failCallback then failCallback(evt) end
-- 	end
-- 	local function onCancel()
-- 		if cancelCallback then cancelCallback() end
-- 	end

-- 	local group = self:buildInterfaceGroup("SummerWeeklyRacePanel/PassPanelFeed")
-- 	self:buildUI(group)

-- 	local filePath = WeeklyShareUtil.buildShareImage(group)

-- 	local title = ""
-- 	local text = ""
-- 	if filePath then
-- 		SeasonWeeklyRaceManager:getInstance():snsShare(filePath, title, text, onSuccess, onFail, onCancel)
-- 	else
-- 		if failCallback then failCallback() end
-- 	end
-- end