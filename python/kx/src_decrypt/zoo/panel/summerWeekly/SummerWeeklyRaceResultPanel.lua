require "zoo.panel.basePanel.BasePanel"

SummerWeeklyRaceResultPanel = class(BasePanel)

function SummerWeeklyRaceResultPanel:create(starCount, score, rewards)
	local panel = SummerWeeklyRaceResultPanel.new()
	panel:init(starCount, score, rewards)
	return panel
end

local assumeShareReward = {itemId = 2, num = 100}

function SummerWeeklyRaceResultPanel:init(starCount, score, rewards)
	self:loadRequiredResource("ui/panel_summer_weekly_share.json")
	local ui = self:buildInterfaceGroup('SummerWeeklyRacePanel/ResultPanel')
	BasePanel.init(self, ui)

	self.starCount = starCount
	self.score = score
	self.rewards = self:mergeRewards(rewards or {})

	self:buildUI(ui)

	local builder = InterfaceBuilder:createWithContentsOfFile("ui/NewSharePanel.json")
	local npc = Sprite:createWithSpriteFrameName("ShareFourStar/cell/xiong0000")
	npc:setAnchorPoint(ccp(0, 1))
	npc.name = "trophy"
	local trophy = ui:getChildByName("trophy")
	npc:setPositionXY(trophy:getPositionX(), trophy:getPositionY())
	npc:setRotation(18)
	npc:setPositionX(npc:getPositionX() + 37)
	npc:setPositionY(npc:getPositionY() + 20)
	ui:addChildAt(npc, ui:getChildIndex(trophy))
	trophy:removeFromParentAndCleanup(true)
	builder:unloadAsset("ui/NewSharePanel.json")

	local bubbleOrigin = ui:getChildByName("bubbleOrigin")
	bubbleOrigin:setVisible(false)

	local button = GroupButtonBase:create(ui:getChildByName("shareBtn"))
	button:setString(Localization:getInstance():getText("share.feed.button.achive"))
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
	close:setPositionX((vSize.width - self:getPositionX()) / self:getScale() - 60)
	close:setPositionY(-self:getPositionY() / self:getScale() - 60)
	close:setTouchEnabled(true)
	close:setButtonMode(true)
	close:addEventListener(DisplayEvents.kTouchTap, function() self:onCloseBtnTapped() end)
	self.close = close

	local stars = ui:getChildByName("stars")
	local totalWidth = 0
	for i = 1, 3 do
		local star = stars:getChildByName("star"..tostring(i))
		local glow = stars:getChildByName("glow"..tostring(i))
		local shadow = stars:getChildByName("shadow"..tostring(i))
		star:setVisible(i <= starCount)
		glow:setVisible(i <= starCount)
		totalWidth = star:getPositionX() + star:getGroupBounds().size.width
	end
	local shareTitle = ui:getChildByName("shareTitle")
	stars:setPositionX(shareTitle:getPositionX() - totalWidth / 2)
	stars:setPositionY(-self:getPositionY() / self:getScale() - 70)

	local scoreTxt = ui:getChildByName("score")
	scoreTxt:setDimensions(CCSizeMake(0, 0))
	scoreTxt:setString("分数:"..score)
	size = scoreTxt:getContentSize()
	scoreTxt:setPositionX(shareTitle:getPositionX() - size.width / 2)
	scoreTxt:setPositionY(-self:getPositionY() / self:getScale() - 260)

	self:setAnimation(ui)
end

function SummerWeeklyRaceResultPanel:buildUI(ui)
	local shareTitle = ui:getChildByName("shareTitle")
	local title = shareTitle:getChildByName("shareTitle")
	title:setText(Localization:getInstance():getText("weeklyrace.summer.panel.achievement3"))
	local size = title:getContentSize()
	title:setPositionX(-size.width / 2)

	local rewardsData = self.rewards
	self.items = {}
	for i = 1, 2 do
		local bubble = ui:getChildByName("bubble"..tostring(i))
		local icon = bubble:getChildByName("icon")
		icon:setVisible(false)
		local itemId = rewardsData[i].itemId
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
		local iSize = icon:getGroupBounds(bubble).size
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

		table.insert(self.items, {item = sprite, itemId = rewardsData[i].itemId, num = rewardsData[i].num})
	end
end

function SummerWeeklyRaceResultPanel:onBtnTapped()
	local function onSuccess(isAddCount)
		DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_share_content', share_id=1})
		if self.isDisposed then return end
		local scene = HomeScene:sharedInstance()
		if scene then
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
			scene:runAction(CCCallFunc:create(function()
				if isAddCount then
					showTip(Localization:getInstance():getText("weeklyrace.summer.panel.tip4"))
				else
					if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
						showTip(Localization:getInstance():getText("share.feed.success.tips.mitalk"))
					else
						showTip(Localization:getInstance():getText("share.feed.success.tips"))
					end
				end
			end))
		end
		self:onCloseBtnTapped()
	end
	local function onFail(evt)
		if self.isDisposed then return end
		if evt and evt.data then
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
		else
			if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
				CommonTip:showTip(Localization:getInstance():getText("share.feed.faild.tips.mitalk"), "negative")
			else
				CommonTip:showTip(Localization:getInstance():getText("share.feed.faild.tips"), "negative")
			end
		end
		self.button:setEnabled(true)
	end
	local function onCancel()
		if self.isDisposed then return end
		if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
			CommonTip:showTip(Localization:getInstance():getText("share.feed.cancel.tips.mitalk"), "negative")
		else
			CommonTip:showTip(Localization:getInstance():getText("share.feed.cancel.tips"), "negative")
		end
		self.button:setEnabled(true)
	end
	self.button:setEnabled(false)
	setTimeOut(function()
		if self.isDisposed then return end
		self.button:setEnabled(true)
	end, 2)
	self:shareMessage(onSuccess, onFail, onCancel)
end

function SummerWeeklyRaceResultPanel:setAnimation(ui)
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
	trophy:setPositionY(trophy:getPositionY() - 120)
	trophy:setOpacity(0)
	local array = CCArray:create()
	array:addObject(CCEaseIn:create(CCFadeIn:create(0.2)))
	array:addObject(CCEaseBackOut:create(CCMoveBy:create(0.2, ccp(0, 120))))
	trophy:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCSpawn:create(array)))

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
	for i = 1, 2 do
		local bubble = ui:getChildByName("bubble"..tostring(i))
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

	local stars = ui:getChildByName("stars")
	for i = 1, 3 do
		local star = stars:getChildByName("star"..tostring(i))
		if star:isVisible() then
			local scale = star:getScale()
			local size = star:getContentSize()
			star:setAnchorPointCenterWhileStayOrigianlPosition(ccp(10, -10))
			star:setScale(0)
			star:setOpacity(0)
			local array = CCArray:create()
			array:addObject(CCDelayTime:create(0.2 + i * 0.2))
			array:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(0.1),
				CCEaseElasticOut:create(CCScaleTo:create(0.8, scale))))
			array:addObject(CCCallFunc:create(function()
					local star = LadybugAnimation:createFinsihShineStar(star:getPosition())
					star:setScale(0.7)
					stars:addChild(star)
				end))
			local array2 = CCArray:create()
			array2:addObject(CCDelayTime:create(0.3 + i * 0.2))
			array2:addObject(CCCallFunc:create(function()
				GamePlayMusicPlayer:playEffect(GameMusicType.kStarOnPanel)
			end))
			star:runAction(CCSpawn:createWithTwoActions(CCSequence:create(array), CCSequence:create(array2)))
		end

		local glow = stars:getChildByName("glow"..tostring(i))
		if glow:isVisible() then
			glow:setAnchorPointCenterWhileStayOrigianlPosition(ccp(10, -10))
			glow:setOpacity(0)
			local array = CCArray:create()
			array:addObject(CCFadeIn:create(0.1))
			array:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(0.3), CCScaleTo:create(0.3, 1.5)))
			glow:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.35 + i * 0.2), CCSequence:create(array)))
		end
	end

	local score = ui:getChildByName("score")
	score:setAnchorPointCenterWhileStayOrigianlPosition()
	score:setScale(0)
	score:setOpacity(0)
	local array = CCArray:create()
	array:addObject(CCFadeIn:create(0.2))
	array:addObject(CCEaseBackOut:create(CCScaleTo:create(0.2, 1)))
	score:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.4), CCSpawn:create(array)))
end

function SummerWeeklyRaceResultPanel:popout()
	PopoutManager:sharedInstance():add(self)
	self.allowBackKeyTap = true
end

function SummerWeeklyRaceResultPanel:onCloseBtnTapped()
	self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self)
	Director:sharedDirector():popScene()
	GamePlayEvents.dispatchPassLevelEvent({levelType=GameLevelType.kSummerWeekly})
end

function SummerWeeklyRaceResultPanel:getStarLevelByScore(score, ...)
	assert(score)
	assert(#{...} == 0)

	-- Get Cur Level Target Scores
	local curLevelScoreTarget = MetaModel:sharedInstance():getLevelTargetScores(self.levelId)

	local star1Score	= curLevelScoreTarget[1]
	local star2Score	= curLevelScoreTarget[2]
	local star3Score	= curLevelScoreTarget[3]
	local star4Score 	= curLevelScoreTarget[4]

	local starLevel = false
	if score < star1Score then
		starLevel = 0
	elseif score >= star1Score and score < star2Score then
		starLevel = 1
	elseif score >= star2Score and score < star3Score then
		starLevel = 2
	elseif score >= star3Score then
		starLevel = 3
		if star4Score ~= nil and score > star4Score then
			starLevel = 4
		end
	else	
		assert(false)
	end

	return starLevel
end

function SummerWeeklyRaceResultPanel:playAnim()
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

function SummerWeeklyRaceResultPanel:mergeRewards(rewardTable)
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

function SummerWeeklyRaceResultPanel:getReward(successCallback, failCallback, cancelCallback)
	local function onSuccess()
		if successCallback then successCallback() end
	end
	local function onFail()
		if failCallback then failCallback() end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end
	-- ask manager
end

function SummerWeeklyRaceResultPanel:shareMessage(successCallback, failCallback, cancelCallback)
	local function onSuccess(isAddCount)
		if successCallback then successCallback(isAddCount) end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt) end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end

	local group = self:buildInterfaceGroup("SummerWeeklyRacePanel/ResultPanelFeed")
	self:buildUI(group, place, friend)

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