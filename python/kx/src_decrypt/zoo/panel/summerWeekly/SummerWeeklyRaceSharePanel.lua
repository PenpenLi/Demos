require "zoo.panel.basePanel.BasePanel"
require "zoo.panel.summerWeekly.SummerWeeklyMatchManager"

SummerWeeklyRaceSharePanel = class(BasePanel)

function SummerWeeklyRaceSharePanel:create(rewards, levelId, rank, surpass)
	local panel = SummerWeeklyRaceSharePanel.new()
	panel:init(rewards, levelId, rank, surpass)
	return panel
end

local assumeShareReward = {itemId = 2, num = 100}

function SummerWeeklyRaceSharePanel:init(rewards, levelId, rank, surpass)
	self:loadRequiredResource("ui/panel_summer_weekly_share.json")
	local ui = self:buildInterfaceGroup('SummerWeeklyRacePanel/SharePanel')
	BasePanel.init(self, ui)

	self.levelId = levelId
	self.place = rank
	self.rewards = self:mergeRewards(rewards or {})
	self.surpass = surpass or 0

	self:buildUI(ui)

	local bubbleOrigin = ui:getChildByName("bubbleOrigin")
	bubbleOrigin:setVisible(false)

	local button = GroupButtonBase:create(ui:getChildByName("shareBtn"))
	button:setString(Localization:getInstance():getText("weeklyrace.summer.panel.button1"))
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
	local firstShare = SummerWeeklyMatchManager:getInstance():isDailyFirstShare()
	shareTip:setVisible(firstShare)

	self:scaleAccordingToResolutionConfig()
	self:setPositionForPopoutManager()
	self:setPositionY(self:getPositionY() - 20)

	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local vSize = Director:sharedDirector():getVisibleSize()
	local layer = LayerColor:create()
	layer:setAnchorPoint(ccp(0, 1))
	layer:ignoreAnchorPointForPosition(false)
	layer:changeWidthAndHeight(vSize.width / self:getScale(), vSize.height / self:getScale())
	layer:setColor(ccc3(0, 0, 0))
	layer:setOpacity(210)
	layer:setPositionXY(-self:getPositionX() / self:getScale(), -self:getPositionY() / self:getScale())
	self:addChildAt(layer, 0)

	local close = ui:getChildByName("closeBtn")
	close:setPositionX((vSize.width - self:getPositionX()) / self:getScale() - 40)
	close:setPositionY(-self:getPositionY() / self:getScale() - 40)
	close:setTouchEnabled(true)
	close:setButtonMode(true)
	close:addEventListener(DisplayEvents.kTouchTap, function() self:onCloseBtnTapped() end)
	self.close = close

	local shareTitle = ui:getChildByName("shareTitle")
	local title = ui:getChildByName("title")
	title:setPositionX(shareTitle:getPositionX())
	title:setPositionY(-self:getPositionY() / self:getScale() - 60)
	local mid = title:getChildByName("mid")
	mid:setText(tostring(self.place))
	local size = mid:getContentSize()
	mid:setPositionX(-size.width / 2)
	mid:setPositionY(mid:getPositionY() + 25)
	local left = title:getChildByName("left")
	left:setDimensions(CCSizeMake(0, 0))
	left:setString(Localization:getInstance():getText("weeklyrace.summer.panel.desc13"))
	size = left:getContentSize()
	left:setPositionX(mid:getPositionX() - size.width - 20)
	local right = title:getChildByName("right")
	right:setDimensions(CCSizeMake(0, 0))
	right:setString(Localization:getInstance():getText("weeklyrace.summer.panel.desc14"))
	size = right:getContentSize()
	right:setPositionX(-mid:getPositionX() + 20)

	self:setAnimation(ui)
end

-- used by main panel and feed, so common parts only
function SummerWeeklyRaceSharePanel:buildUI(ui)
	local rewardsData = self.rewards
	local friends = self.surpass

	local shareTitle = ui:getChildByName("shareTitle")
	local title = shareTitle:getChildByName("shareTitle")
	title:setText(Localization:getInstance():getText("weeklyrace.summer.panel.achievement4", {num = friends}))
	local size = title:getContentSize()
	title:setPositionX(-size.width / 2)

	local skipSavingItem = false
	if not self.items then self.items = {}
	else skipSavingItem = true end
	for i = 1, 3 do
		local bubble = ui:getChildByName("bubble"..tostring(i))
		local icon = bubble:getChildByName("icon")
		icon:setVisible(false)
		local reward = rewardsData[i]
		if reward then
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
			num:setPositionX(icon:getPositionX() + iSize.width - size.width)
			if not skipSavingItem then
				table.insert(self.items, {item = sprite, itemId = rewardsData[i].itemId, num = rewardsData[i].num})
			end
		else
			bubble:setVisible(false)
		end
	end
end

function SummerWeeklyRaceSharePanel:onBtnTapped()
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
					showTip(Localization:getInstance():getText("weeklyrace.summer.panel.tip4"), "positive")
				else
					if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
						showTip(Localization:getInstance():getText("share.feed.success.tips.mitalk"), "positive")
					else
						showTip(Localization:getInstance():getText("share.feed.success.tips"), "positive")
					end
				end
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
	self.button:setEnabled(false)
	self:getReward(onSuccess, onFail, onCancel)
end

function SummerWeeklyRaceSharePanel:setAnimation(ui)
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

	local trophy = ui:getChildByName("trophy")
	trophy:setPositionY(trophy:getPositionY() - 200)
	trophy:setOpacity(0)
	local array = CCArray:create()
	array:addObject(CCEaseBackOut:create(CCMoveBy:create(0.2, ccp(0, 200))))
	array:addObject(CCFadeIn:create(0.2))
	trophy:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCSpawn:create(array)))

	local title = ui:getChildByName("title")
	title:setPositionY(title:getPositionY() - 20)
	title:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCMoveBy:create(0.2, ccp(0, 20))))
	local childList = {}
	title:getVisibleChildrenList(childList)
	for i, v in ipairs(childList) do
		v:setOpacity(0)
		v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCFadeIn:create(0.2)))
	end

	local circleLightBg = ui:getChildByName("circleLightBg")
	local bg = circleLightBg:getChildByName("bg")
	bg:setAnchorPoint(ccp(0.5, 0.5))
	bg:setPositionXY(0, 0)
	bg:setScale(0)
	bg:runAction(CCRepeatForever:create(CCRotateBy:create(1, 100)))
	bg:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.35), CCScaleTo:create(0.15, 2)))
	local bg1 = circleLightBg:getChildByName("bg1")
	bg1:setAnchorPoint(ccp(0.5, 0.5))
	bg1:setPositionXY(0, 0)
	bg1:setScale(0)
	array = CCArray:create()
	array:addObject(CCScaleTo:create(0.15, 2.2))
	array:addObject(CCEaseOut:create(CCFadeOut:create(0.15)))
	bg1:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.35), CCSpawn:create(array)))
	local bg2 = circleLightBg:getChildByName("bg2")
	bg2:setAnchorPoint(ccp(0.5, 0.5))
	bg2:setPositionXY(0, 0)
	bg2:setScale(0)
	array = CCArray:create()
	array:addObject(CCScaleTo:create(0.15, 2.2))
	array:addObject(CCEaseOut:create(CCFadeOut:create(0.15)))
	bg2:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.35), CCSpawn:create(array)))

	local origin = ui:getChildByName("bubbleOrigin")
	for i = 1, 3 do
		local bubble = ui:getChildByName("bubble"..tostring(i))
		if bubble:isVisible() then
			local sprite = bubble:getChildByName("bubble")
			local scale = sprite:getScale()
			array = CCArray:create()
			array:addObject(CCScaleTo:create(0.9, scale * 0.98, scale * 1.03))
			array:addObject(CCScaleTo:create(0.9, scale * 1.01, scale * 0.96))
			array:addObject(CCScaleTo:create(0.9, scale * 0.98, scale * 1.03))
			array:addObject(CCScaleTo:create(0.9, scale, scale))
			sprite:runAction(CCRepeatForever:create(CCSequence:create(array)))
			local position = bubble:getPosition()
			position = {x = position.x, y = position.y}
			bubble:setVisible(false)
			bubble:setScale(0.5)
			bubble:setPositionXY(origin:getPositionX(), origin:getPositionY())
			array = CCArray:create()
			array:addObject(CCToggleVisibility:create())
			array:addObject(CCEaseBackOut:create(CCMoveTo:create(0.2, ccp(position.x, position.y))))
			array:addObject(CCScaleTo:create(0.2, scale))
			bubble:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3 + i / 50), CCSpawn:create(array)))
		end
	end

	local starGroup3 = ui:getChildByName("starGroup3")
	local starList = {}
	starGroup3:getVisibleChildrenList(starList)
	for i, v in ipairs(starList) do
		local size = v:getGroupBounds().size
		v:setAnchorPoint(ccp(0.5, 0.5))
		v:setPositionXY(v:getPositionX() + size.width / 2, v:getPositionY() - size.height / 2)
		v:setOpacity(0)
		local function onDelayOver()
			array = CCArray:create()
			array:addObject(CCDelayTime:create(math.random() * 0.5))
			local rotateTime = math.random() * 1 + 1
			local array2 = CCArray:create()
			array2:addObject(CCFadeIn:create(rotateTime / 2))
			array2:addObject(CCFadeOut:create(rotateTime / 2))
			array:addObject(CCSpawn:createWithTwoActions(CCRotateBy:create(rotateTime, 180), CCSequence:create(array2)))
			array:addObject(CCDelayTime:create(math.random() * 1 + 0.5))
			v:runAction(CCRepeatForever:create(CCSequence:create(array)))
		end
		v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.6), CCCallFunc:create(onDelayOver)))
	end
end

function SummerWeeklyRaceSharePanel:popout(onClosed)
	self.allowBackKeyTap = true
	self.onClosedCallback = onClosed
	PopoutManager:sharedInstance():add(self)
end

function SummerWeeklyRaceSharePanel:onCloseBtnTapped()
	self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self)
	if self.onClosedCallback then self.onClosedCallback() end
end

function SummerWeeklyRaceSharePanel:playAnim()
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

function SummerWeeklyRaceSharePanel:mergeRewards(rewardTable)
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

function SummerWeeklyRaceSharePanel:getReward(successCallback, failCallback, cancelCallback)
	local function onSuccess()
		if successCallback then successCallback() end
	end
	local function onFail()
		if failCallback then failCallback() end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end
	SummerWeeklyMatchManager:getInstance():receiveLastWeekRankRewards(self.levelId, onSuccess, onFail, onCancel)
end

function SummerWeeklyRaceSharePanel:shareMessage(successCallback, failCallback, cancelCallback)
	local function onSuccess(isAddCount)
		if successCallback then successCallback(isAddCount) end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt) end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end

	local group = self:buildInterfaceGroup("SummerWeeklyRacePanel/SharePanelFeed")
	self:buildUI(group)

	local bg_2d = Sprite:create("share/summber_share_bg.png")
	bg_2d:setAnchorPoint(ccp(0, 1))
	local bg = group:getChildByName("bg")
	bg:setVisible(false)
	local size = bg:getGroupBounds().size
	local bSize = bg_2d:getGroupBounds().size
	bg_2d:setScaleX(size.width / bSize.width)
	bg_2d:setScaleY(size.height / bSize.height)
	group:addChildAt(bg_2d, group:getChildIndex(bg))

	local qr
	if __use_small_res then
		qr = Sprite:create("share/share_background_2d_small.png")
	else
		qr = Sprite:create("share/share_background_2d.png")
	end
	qr:setAnchorPoint(ccp(1, 1))
	qr:setPositionXY(size.width - 10, -10)
	group:addChildAt(qr, group:getChildIndex(bg))

	group:setPositionY(size.height)

	local filePath = HeResPathUtils:getResCachePath() .. "/share_image.jpg"
	print(filePath)
	local renderTexture = CCRenderTexture:create(size.width, size.height)
	renderTexture:begin()
	group:visit()
	renderTexture:endToLua()
	renderTexture:saveToFile(filePath)

	local title = ""
	local text = ""
	SummerWeeklyMatchManager:getInstance():snsShare(filePath, title, text, onSuccess, onFail, onCancel)
end