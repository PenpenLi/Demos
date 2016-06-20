require "zoo.panel.basePanel.BasePanel"

SeasonWeeklyRaceResultPanel = class(BasePanel)

function SeasonWeeklyRaceResultPanel:create(starCount, score, rewards)
	local panel = SeasonWeeklyRaceResultPanel.new()
	panel:init(starCount, score, rewards)
	return panel
end

function SeasonWeeklyRaceResultPanel:init(starCount, score, rewards)
	local ts = Localhost:time()
	rewards = self:mergeRewards(rewards)
	self:loadRequiredResource("ui/panel_summer_weekly_share2.json")
	local ui = self:buildInterfaceGroup('SummerWeeklyRacePanel/ResultPanel')
	BasePanel.init(self, ui)

	local anim = ui:getChildByName('anim')
	local npc = anim:getChildByName('npc')
	local arr = {1, 2, 3, 4, 5, 6}
	local sprites = {}
	for i,v in ipairs(arr) do
		table.insert(sprites, npc:getChildByName(tostring(v)))
	end
	local index = CCUserDefault:sharedUserDefault():getIntegerForKey("season.weekly.result.index")
	arr = table.filter(arr, function(v) return v ~= index end)
	index = arr[math.random(#arr)]
	CCUserDefault:sharedUserDefault():setIntegerForKey("season.weekly.result.index", index)
	for i,v in ipairs(sprites) do
		if v.name ~= tostring(index) then
			v:removeFromParentAndCleanup(true)
		end
	end

	local shareTitle = ui:getChildByName("shareTitle")
	local title = shareTitle:getChildByName("shareTitle")
	title:setText(Localization:getInstance():getText("weeklyrace.winter.panel.achievement"..tostring(index + 4)))
	local size = title:getContentSize()
	title:setPositionX(-size.width / 2)

	local desc = ui:getChildByName("desc")
	desc:setString(Localization:getInstance():getText("weekly.race.winter.panel.result.desc"))

	local itemId = nil
	local count = 0

	self.items = {}
	local bubble1 = anim:getChildByName("bubble1")
	bubble1.obj = bubble1:getChildByName("icon")
	bubble1.obj:setVisible(false)
	local bubble2 = anim:getChildByName("bubble2")
	bubble2.obj = bubble2:getChildByName("icon")
	bubble2.obj:setVisible(false)
	local bubble3 = anim:getChildByName("bubble3")
	for i,v in ipairs(rewards) do
		if v.itemId == ItemType.KWATER_MELON then
			local sprite = Sprite:createWithSpriteFrameName("weeklyicon0000")
			local size = sprite:getContentSize()
			local icon = bubble1:getChildByName("icon")
			local iSize = icon:getGroupBounds(bubble1).size
			sprite:setAnchorPoint(ccp(0, 1))
			sprite:setScale(math.min(iSize.width / size.width, iSize.height / size.height))
			sprite:setPositionXY(icon:getPositionX(), icon:getPositionY())
			bubble1:addChildAt(sprite, bubble1:getChildIndex(icon))
			local num = bubble1:getChildByName("text")
			num:setText('×'..tostring(v.num))
			num:setScale(1.2)
			size = num:getContentSize()
			num:setPositionX(-size.width * 0.6)
			bubble1.itemId = ItemType.KWATER_MELON
			bubble1.num = v.num
			count = v.num
			table.insert(self.items, bubble1)
		elseif v.itemId == ItemType.COIN then
			local sprite = Sprite:createWithSpriteFrameName("SummerWeeklyRacePanel/img/coinbagsmall0000")
			local size = sprite:getContentSize()
			local icon = bubble2:getChildByName("icon")
			local iSize = icon:getGroupBounds(bubble2).size
			sprite:setAnchorPoint(ccp(0, 1))
			sprite:setScale(math.min(iSize.width / size.width, iSize.height / size.height))
			sprite:setPositionXY(icon:getPositionX(), icon:getPositionY())
			bubble2:addChildAt(sprite, bubble2:getChildIndex(icon))
			local num = bubble2:getChildByName("text")
			num:setText('×'..tostring(v.num))
			num:setScale(1.2)
			size = num:getContentSize()
			num:setPositionX(-size.width * 0.6)
			bubble2.itemId = ItemType.COIN
			bubble2.num = v.num
			table.insert(self.items, bubble2)
		end
	end

	local button = GroupButtonBase:create(ui:getChildByName("shareBtn"))
	button:setString(Localization:getInstance():getText("share.feed.button.achive"..tostring(index)))
	button:addEventListener(DisplayEvents.kTouchTap, function() self:onBtnTapped(index, count, ts) end)
	self.button = button

	self:scaleAccordingToResolutionConfig()
	self:setPositionForPopoutManager()

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
	close:setPositionX((vSize.width - self:getPositionX()) / self:getScale() - 60)
	close:setPositionY(-self:getPositionY() / self:getScale() - 60)
	close:setTouchEnabled(true)
	close:setButtonMode(true)
	close:addEventListener(DisplayEvents.kTouchTap, function() self:onCloseBtnTapped() end)
	self.close = close

	self:setAnimation(ui)
end

function SeasonWeeklyRaceResultPanel:onBtnTapped(index, count, timeStamp)
	local function onSuccess(isAddCount)
		DcUtil:doShareQrCodeSuccess(index)
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
					showTip(Localization:getInstance():getText("weeklyrace.winter.panel.tip4"))
				else
					if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
						showTip(Localization:getInstance():getText("share.feed.success.tips.mitalk"))
					else
						showTip(Localization:getInstance():getText("weekly.race.winter.share.success"))
					end
				end
			end))
		end

		self:playAnim()
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
				CommonTip:showTip(Localization:getInstance():getText("weekly.race.winter.share.fail"), "negative")
			end
		end
		self.button:setEnabled(true)
	end
	local function onCancel()
		if self.isDisposed then return end
		if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
			CommonTip:showTip(Localization:getInstance():getText("share.feed.cancel.tips.mitalk"), "negative")
		else
			CommonTip:showTip(Localization:getInstance():getText("weekly.race.winter.share.cancle"), "negative")
		end
		self.button:setEnabled(true)
	end
	DcUtil:clickShareQrCodeBtn(index)
	self.button:setEnabled(false)
	setTimeOut(function()
		if self.isDisposed then return end
		self.button:setEnabled(true)
	end, 2)
	if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		self:shareMessage(index, count, timeStamp, onSuccess, onFail, onCancel)
	else
		self:shareMessageForFeed(index, count, timeStamp, onSuccess, onFail, onCancel)
	end
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

function SeasonWeeklyRaceResultPanel:setAnimation(ui)
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
	local bubbles = {}
	table.insert(bubbles, anim:getChildByName('bubble1'))
	table.insert(bubbles, anim:getChildByName('bubble2'))
	table.insert(bubbles, anim:getChildByName('bubble3'))

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

	for i, v in ipairs(bubbles) do
		local position = v:getPosition()
		position = ccp(position.x, position.y)
		local scale = v:getScale()
		v:setPositionXY(0, 0)
		v:setScale(0)
		v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCSpawn:createWithTwoActions(CCScaleTo:create(0.2, scale),
			CCEaseBackOut:create(CCMoveTo:create(0.2, position)))))
	end

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

function SeasonWeeklyRaceResultPanel:popout()
	PopoutManager:sharedInstance():add(self)
	self.allowBackKeyTap = true
end

function SeasonWeeklyRaceResultPanel:onCloseBtnTapped()
	self.allowBackKeyTap = false
	HomeScene:sharedInstance():checkDataChange()
	PopoutManager:sharedInstance():remove(self)
	Director:sharedDirector():popScene()
	GamePlayEvents.dispatchPassLevelEvent({levelType=GameLevelType.kSummerWeekly})
end

function SeasonWeeklyRaceResultPanel:getStarLevelByScore(score, ...)
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

function SeasonWeeklyRaceResultPanel:playAnim()
	if self.isDisposed then
		return
	end

	local scene = HomeScene:sharedInstance()

	for _,v in pairs(self.items) do
		local bounds = v.obj:getGroupBounds()
		local posX = bounds:getMidX()
		local posY = bounds:getMidY()
		scene:runAction(CCCallFunc:create(function( ... )
			if v.itemId == ItemType.KWATER_MELON then
				-- 没图标暂不处理
			else
				local anim = FlyItemsAnimation:create({v})
				anim:setWorldPosition(ccp(posX,posY))
				anim:play()
			end
		end))
	end
end

function SeasonWeeklyRaceResultPanel:mergeRewards(rewardTable)
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

function SeasonWeeklyRaceResultPanel:getReward(successCallback, failCallback, cancelCallback)
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

--发送点对点链接 目前非米聊版本在用
function SeasonWeeklyRaceResultPanel:shareMessageForFeed(index, count, timeStamp, successCallback, failCallback, cancelCallback)
	local function onSuccess(isAddCount)
		if successCallback then successCallback(isAddCount) end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt) end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end

	local function onApply(_, qrCodeId)
		local uid = UserManager:getInstance():getUserRef().uid
		local inviteCode = UserManager:getInstance().inviteCode
		local platformName = StartupConfig:getInstance():getPlatformName()

		local webpageUrl = NetworkConfig.dynamicHost.."summer_week_match_2016_qr_code.html?uid="..tostring(uid)..
		"&invitecode="..tostring(inviteCode).."&pid="..tostring(platformName).."&action=1&index="..index.."&ts="..
		tostring(Localhost:time()).."&qrid="..tostring(string.gsub(qrCodeId, '_', 'X'))

		local profile = UserManager:getInstance().profile
		local userName = profile.name
		if type(userName) ~= "string" then
			userName = Localization:getInstance():getText("game.setting.panel.use.device.name.default")
		else
			userName = HeDisplayUtil:urlDecode(userName)
		end

		local title = Localization:getInstance():getText("weekly.race.winter.grade.link.title")
		local text = Localization:getInstance():getText("weekly.race.winter.grade.link", {name = userName, num = count})
		local thumbAddress = "materials/weekly_icon.png"
		SeasonWeeklyRaceManager:getInstance():snsShareForFeed(title, text, webpageUrl, thumbAddress, onSuccess, onFail, onCancel)
	end

	local weeklyType = SeasonWeeklyRaceConfig:getInstance().weeklyRaceType
	SeasonWeeklyRaceManager:getInstance():applyForNewShareQrCode(count, timeStamp, weeklyType, onApply, onFail, onCancel)
end

--发送到朋友圈 目前米聊版本在用
function SeasonWeeklyRaceResultPanel:shareMessage(index, count, timeStamp, successCallback, failCallback, cancelCallback)
	local function onSuccess(isAddCount)
		if successCallback then successCallback(isAddCount) end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt) end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end

	local anim
	local canceled = false
	local function callback(image)
		if canceled then return end
		PopoutManager:sharedInstance():remove(anim)
		local title = ""
		local text = ""
		SeasonWeeklyRaceManager:getInstance():snsShare(image, title, text, onSuccess, onFail, onCancel)
	end
	local function onCloseButtonTap()
		PopoutManager:sharedInstance():remove(anim)
		canceled = true
	end

	local function onApply(_, qrCodeId)
		local scene = Director:sharedDirector():getRunningSceneLua()
		anim = CountDownAnimation:createNetworkAnimationInHttp(scene, onCloseButtonTap)
		self:createShareImage(index, count, qrCodeId, callback)
	end

	local weeklyType = SeasonWeeklyRaceConfig:getInstance().weeklyRaceType
	SeasonWeeklyRaceManager:getInstance():applyForNewShareQrCode(count, timeStamp, weeklyType, onApply, onFail, onCancel)
end

function SeasonWeeklyRaceResultPanel:createShareImage(index, count, qrCodeId, callback)
	local profile = UserManager:getInstance().profile
	local uid = UserManager:getInstance():getUserRef().uid
	local inviteCode = UserManager:getInstance().inviteCode
	local platformName = StartupConfig:getInstance():getPlatformName()
	local function onCallback(sprite)
		local bgImg = Sprite:create("materials/weeklyshare"..tostring(index)..".jpg")
		bgImg:setAnchorPoint(ccp(0, 1))
		self:loadRequiredResource("ui/panel_summer_weekly_share2.json")
		local ui = self:buildInterfaceGroup("SummerWeeklyRacePanel/ResultPanelFeed")
		local bg = ui:getChildByName("bg")
		bg:setVisible(false)
		local size = bg:getGroupBounds(ui).size
		ui:setPositionY(size.height)
		local bSize = bgImg:getContentSize()
		local scale = math.min(size.width / bSize.width, size.height / bSize.height)
		bgImg:setScale(scale)
		ui:addChildAt(bgImg, ui:getChildIndex(bg))
		local img = ui:getChildByName("head")
		img:setVisible(false)
		size = img:getGroupBounds(ui).size
		bSize = sprite:getContentSize()
		scale = math.min(size.width / bSize.width, size.height / bSize.height)
		sprite:setScale(scale)
		sprite:setPositionXY(img:getPositionX() + size.width / 2, img:getPositionY() - size.height / 2)
		ui:addChildAt(sprite, ui:getChildIndex(img))
		-- local num = ui:getChildByName("count")
		-- num:setText('x'..tostring(count))
		-- local bSize = num:getContentSize()
		-- local rotation = num:getRotation()
		-- num:setScale(2)
		-- num:setPositionXY(num:getPositionX() + bSize.width * math.cos(rotation), num:getPositionY() - bSize.height * math.sin(rotation))
		local code = ui:getChildByName("qrcode")
		code:setVisible(false)
		local size = code:getGroupBounds(ui).size
		local webpageUrl = NetworkConfig.dynamicHost.."summer_week_match_2016_qr_code.html?uid="..tostring(uid)..
		"&invitecode="..tostring(inviteCode).."&pid="..tostring(platformName).."&action=1&index="..index.."&ts="..
		tostring(Localhost:time()).."&qrid="..tostring(string.gsub(qrCodeId, '_', 'X'))
		local qrCode = CocosObject.new(QRManager:generatorQRNode(webpageUrl, size.width, 1, ccc4(153, 51, 202, 255), ccc4(255, 255, 255, 255)))
		local bSize = qrCode:getGroupBounds().size
		local scale = math.min(size.width / bSize.width, size.height / bSize.height)
		qrCode:setScaleX(scale)
		qrCode:setScaleY(-scale)
		qrCode:setPositionXY(code:getPositionX(), code:getPositionY())
		ui:addChildAt(qrCode, ui:getChildIndex(code))
		local pos = ui:getChildByName("logo")
		pos:setVisible(false)
		local size = pos:getGroupBounds().size
		local logo = Sprite:create("materials/wechat_icon.png")
		local bSize = logo:getGroupBounds().size
		local scale = math.min(size.width / bSize.width, size.height / bSize.height)
		logo:setScale(scale)
		logo:setPositionXY(pos:getPositionX() + size.width / 2, pos:getPositionY() - size.height / 2)
		ui:addChildAt(logo, ui:getChildIndex(pos))
		local profile = UserManager:getInstance().profile
		local name = profile.name
		if type(name) ~= "string" then
			name = Localization:getInstance():getText("game.setting.panel.use.device.name.default")
		else
			name = HeDisplayUtil:urlDecode(name)
		end
		local text = ui:getChildByName("name")
		text:setString(name)

		local renderTexture = CCRenderTexture:create(bg:getGroupBounds(ui).size.width, bg:getGroupBounds(ui).size.height)
		renderTexture:begin()
		ui:visit()
		renderTexture:endToLua()
		local path = HeResPathUtils:getResCachePath().."/weeklyresult.jpg"
		if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then -- 非微信分享，将截图存储到外部存储中，以防第三方app无法直接读取图片
			local exStorageDir = luajava.bindClass("com.happyelements.android.utils.ScreenShotUtil"):getGamePictureExternalStorageDirectory()
			if exStorageDir then
				path = exStorageDir .. "/weeklyresult.jpg"
			end
		end
		renderTexture:saveToFile(path)

		if callback then callback(path) end
	end
	HeadImageLoader:create(uid, profile.headUrl, onCallback)
end
