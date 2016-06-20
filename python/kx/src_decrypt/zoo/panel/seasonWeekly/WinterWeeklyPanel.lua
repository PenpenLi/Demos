require "zoo.panel.seasonWeekly.SeasonWeeklyRaceManager"
require "zoo/panel/component/common/BoxRewardTipPanel"
require "zoo.panel.seasonWeekly.SeasonWeeklyRaceRewardsPanel"
require "zoo.panel.seasonWeekly.SeasonWeeklyRaceRulePanel"
require "zoo.panel.seasonWeekly.SeasonWeeklyGetFreePlayPanel"
require "zoo.panel.seasonWeekly.SeasonWeeklyRaceSharePanel"
require "zoo.panel.seasonWeekly.SeasonWeeklyRaceChampPanel"
require "zoo.panel.seasonWeekly.SeasonWeeklyRacePassPanel"
require "zoo.panel.TwoChoicePanel"

local kDragonBonesName = "season_weekly_panel_animation"
local kTextureAtlasName = "season_weekly_panel_animation"

WinterWeeklyPanel = class(BasePanel)

function WinterWeeklyPanel:create(weeklyDecisionType)
	local panel = WinterWeeklyPanel.new()
	panel.weeklyDecisionType = weeklyDecisionType
	panel:loadRequiredResource("ui/panel_winter_weekly.json")
	panel:initUI()
	return panel
end

function WinterWeeklyPanel:ctor()
	self.cellItems = {}
end

function WinterWeeklyPanel:initUI()
	self.ui = self:buildInterfaceGroup("winterWeeklyPanel/panel")
	BasePanel.init(self, self.ui)
	local designPanel = self.ui:getChildByName("design_panel")

	local visibleSize = Director:sharedDirector():getVisibleSize()
	local visibleOrigin = Director:sharedDirector():getVisibleOrigin()	
	local bgSize = self.ui:getChildByName("bg"):getGroupBounds().size
	local designPanelSize = designPanel:getChildByName("bg"):getGroupBounds().size
	local heightScale = visibleSize.height / bgSize.height
	local widthScale = visibleSize.width / bgSize.width
	local scale = math.max(heightScale, widthScale)
	self.ui:setScale(scale)
	local panelPosX = (visibleSize.width - designPanelSize.width * scale) / 2
	self.ui:setPosition(ccp(panelPosX, 0))
	local bgPos = self.ui:getChildByName("bg"):getPosition()
	local bgZOrder = self.ui:getChildByName("bg"):getZOrder()

	-- init bg
	self.ui:getChildByName("bg"):removeFromParentAndCleanup(true)
	designPanel:getChildByName("bg"):removeFromParentAndCleanup(true)
	-- add panel bg
	SpriteUtil:addSpriteFramesWithFile("materials/weeklyPanelBg.plist", "materials/weeklyPanelBg.png")
	local bgImg = Sprite:createWithSpriteFrameName("weeklyPanelBg.png")
	bgImg:setAnchorPoint(ccp(0, 1))
	bgImg:setPosition(ccp(bgPos.x,bgPos.y))
	self.ui:addChildAt(bgImg, bgZOrder)

	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap, function() self:closePanel() end)
	closeBtn:setPositionX((designPanelSize.width + visibleSize.width / scale) / 2 - 50)

	local bottle = self.ui:getChildByName("bottle")
	local umbrella = self.ui:getChildByName("unbrella")
	EggsManager:showHorseIfNecessary(self.ui, bottle, umbrella)

	local descIcon = designPanel:getChildByName("descIcon")
	descIcon:setTouchEnabled(true)
	descIcon:setButtonMode(true)
	descIcon:addEventListener(DisplayEvents.kTouchTap, function()
		DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_2016_click_info'}, true)
		local panel = SeasonWeeklyRaceRulePanel:create()
		panel:popout()
		-- SeasonWeeklyRaceResultPanel:create(2, 423434, {{itemId=2,num=1000},{itemId=18, num=88}}):popout()
		-- SeasonWeeklyRaceSharePanel:create({{itemId=2,num=1000},{itemId=10003, num=1}}, 1, 3, 12):popout()
	end)

	local top = self:initTop(designPanel:getChildByName("top"))
	local bottom = self:initBottom(designPanel:getChildByName("bottom"))
	local desc = self:initDesc(designPanel:getChildByName("desc"))

	local context = self
	self.refreshAll = function( refreshRankList )
		print('wenkan refreshAll', context.hasPopout, context.isDisposed)
		if context.hasPopout and not context.isDisposed then
			SeasonWeeklyRaceManager:getInstance():getAndUpdateMatchData()
			desc:refresh()
			top:refresh()
			bottom:refresh(refreshRankList)
		end
	end
	
	self.dataChangeListener = function(evt)
		print('wenkan dataChangeListener', table.tostring(evt))
		local refreshRankList = false
		if evt and evt.data then refreshRankList = evt.data.refreshRankList end
		if context.refreshAll and not context.isDisposed then context.refreshAll(refreshRankList) end
	end
	GlobalEventDispatcher:getInstance():addEventListener(SummerWeeklyMatchEvents.kDataChangeEvent, self.dataChangeListener)
	self.passLevelListener = function(evt)
		assert(evt, "evt cannot be nil")
		context:onLevelPassed(evt.data)
	end
	GamePlayEvents.addPassLevelEvent(self.passLevelListener)

	local water, starfish = self:createSkeleton()
	self.ui:addChildAt(water, bgZOrder+1)
	water:setPositionXY(bgPos.x, -680)

	self.ui:getChildByName('tip2'):setVisible(false)
	self:initBottomAnimal(self.ui, starfish, self.ui:getChildByName('animalHitArea'), self.ui:getChildByName('tip2'))
end

function WinterWeeklyPanel:initTop(top)
	local dayReward = self:initDayReward(top:getChildByName("reward1"))
	local weekReward = self:initWeekReward(top:getChildByName("reward2"))

	local button = self:initButton(
		top:getChildByName("button"),
		top:getChildByName("coinBuyButton")
	)
	self.mainButton = button
	top.refresh = function(self)
		dayReward:refresh()
		weekReward:refresh()
		button:refresh()
	end

	return top
end

function WinterWeeklyPanel:initBottom(bottom)
	local rankList = self:initRankList(
		bottom:getChildByName("rankList"),
		bottom:getChildByName("rankTip")
	)
	local myNumber = self:initMyNumber(bottom:getChildByName("my"))
	if bottom:getChildByName("bg") then
		bottom:getChildByName("bg"):removeFromParentAndCleanup(true)
	end
	bottom.refresh = function(self, refreshRankList)
		myNumber:refresh()
		if refreshRankList then 
			rankList:refresh()
		end
	end
	return bottom
end

function WinterWeeklyPanel:initTopAnimal(ui, animal, tipUi)
	-- animal:setPosition(ccp(0, -30))
	ui:addChild(animal)

	if tipUi and not tipUi.play then
		tipUi.play = function(self)
			self:stopAllActions()

			local img = self:getChildByName("img")
			img:setOpacity(255)

			self:setVisible(true)
			self:setScale(0.15)
			self:setRotation(10.4)

			local act1 = CCSpawn:createWithTwoActions(CCRotateTo:create(0.3, 0), CCScaleTo:create(0.3, 1))
			local act2 = CCSpawn:createWithTwoActions(CCRotateTo:create(0.3, -3), CCScaleTo:create(0.3, 100/115, 1))
			local act3 = CCDelayTime:create(4)
			local act4 = CCTargetedAction:create(img.refCocosObj,CCFadeOut:create(0.6))
			local act5 = CCCallFunc:create(function() self:setVisible(false) end)
			local seq = CCArray:create()
			seq:addObject(act1)
			seq:addObject(act2)
			seq:addObject(act3)
			seq:addObject(act4)
			self:runAction(CCSequence:create(seq))
			seq:addObject(act5)
		end
	end

	local function onAnimalTaped(evt)
		if tipUi and not tipUi.isDisposed then
			tipUi:play()
		end
	end

	ui:setTouchEnabled(true)
	ui:addEventListener(DisplayEvents.kTouchTap, onAnimalTaped)

	local function playAnimalAnimation()
		if animal and not animal.isDisposed then
			animal:playByIndex(0, 1)
		end
	end
	local animalSeq = CCArray:create()
	animalSeq:addObject(CCDelayTime:create(8))
	animalSeq:addObject(CCCallFunc:create(playAnimalAnimation))
	ui:runAction(CCRepeatForever:create(CCSequence:create(animalSeq)))
	return ui
end

function WinterWeeklyPanel:initBottomAnimal(ui, skeleton, animal, tipUi)
	animal:getChildByName('sprite'):setOpacity(0)
	animal:addChild(skeleton)
	skeleton:setScale(1.3)
	skeleton:setPositionY(-70)

	if tipUi and not tipUi.play then
		tipUi.play = function(self)
			self:stopAllActions()

			local img = self:getChildByName("img")
			img:setOpacity(255)

			self:setVisible(true)
			self:setScale(0.15)
			self:setRotation(-8)

			local act1 = CCSpawn:createWithTwoActions(CCRotateTo:create(0.3, 0), CCScaleTo:create(0.3, 1))
			local act2 = CCSpawn:createWithTwoActions(CCRotateTo:create(0.3, -3), CCScaleTo:create(0.3, 104/113, 1.04))
			local act3 = CCDelayTime:create(3.6)
			local act4 = CCTargetedAction:create(img.refCocosObj,CCFadeOut:create(0.6))
			local act5 = CCCallFunc:create(function() self:setVisible(false) end)
			local seq = CCArray:create()
			seq:addObject(act1)
			seq:addObject(act2)
			seq:addObject(act3)
			seq:addObject(act4)
			seq:addObject(act5)
			self:runAction(CCSequence:create(seq))
		end
	end

	local function onAnimalTaped(evt)
		if animal:hitTestPoint(evt.globalPosition, true) then
			if tipUi and not tipUi.isDisposed then
				tipUi:play()
			end
		end
	end
	ui:setTouchEnabled(true)
	ui:addEventListener(DisplayEvents.kTouchTap, onAnimalTaped)
	return ui
end

function WinterWeeklyPanel:createSkeleton()
	FrameLoader:loadArmature("skeleton/season_weekly_panel_animation", kDragonBonesName, kTextureAtlasName)
	local armature1 = ArmatureNode:create("SeasonWeeklyPanelAnimation/Wave")
	armature1:playByIndex(0, 0)

	local armature2 = ArmatureNode:create("SeasonWeeklyPanelAnimation/starfish")
	armature2:playByIndex(0, 0)
	return armature1, armature2
end

function WinterWeeklyPanel:initDayReward( ui )
	ui:getChildByName("title.2"):setVisible(false)
	ui:getChildByName("leftArrow"):setVisible(false)
	ui:getChildByName("rightArrow"):setVisible(false)

	local todayTitle = ui:getChildByName("title.1")
	local tomorrowTitle = ui:getChildByName("title.3")

	local desc1 = ui:getChildByName("desc.1")
	local icon = ui:getChildByName("icon")
	local desc2 = ui:getChildByName("desc.2")
	local desc3 = ui:getChildByName("desc.3")
	local time = ui:getChildByName("time")
	local timeText = ui:getChildByName("time"):getChildByName("text")
	local pao = ui:getChildByName("pao")
	local arrow = ui:getChildByName("arrow")
	arrow.originPoint = ccp(arrow:getPositionX(),arrow:getPositionY())
	local timeLimitFlag = ui:getChildByName("time_limit_flag")

	local bubble = ui:getChildByName("pao")
	local bubbleExploaded = ui:getChildByName("ani")
	bubbleExploaded:setVisible(false)

	-- self:setBubbleMode(pao,arrow,true)

	local iconBoundBox = icon:boundingBox()

	desc1:setDimensions(CCSizeMake(0,0))
	desc2:setDimensions(CCSizeMake(0,0))

	desc1:setAnchorPoint(ccp(1,0.5))
	desc1:setPositionX(iconBoundBox:getMinX()-4)
	desc1:setPositionY(iconBoundBox:getMidY())

	desc2:setAnchorPoint(ccp(0,0.5))
	desc2:setPositionX(iconBoundBox:getMaxX()+4)
	desc2:setPositionY(iconBoundBox:getMidY())

	desc1:setString(Localization:getInstance():getText("weeklyrace.winter.panel.desc17"))--"当天最高"
	-- 今日奖励已领完
	desc3:setString(Localization:getInstance():getText("weeklyrace.winter.panel.desc7"))

	local function setNumber( num )
		desc2:setString(Localization:getInstance():getText("weeklyrace.winter.panel.desc19",{num=num}))
	end
	local function showDesc( isTomorrow )
		todayTitle:setVisible(not isTomorrow)
		desc1:setVisible(not isTomorrow)
		desc2:setVisible(not isTomorrow)
		icon:setVisible(not isTomorrow)

		tomorrowTitle:setVisible(isTomorrow)
		desc3:setVisible(isTomorrow)
	end

	timeText:setString("00:00:00")
	local timeTextBoundingBox = timeText:boundingBox()
	timeText:setDimensions(CCSizeMake(0,0))
	timeText:setAnchorPoint(ccp(0.5,0.5))
	timeText:setPositionX(timeTextBoundingBox:getMidX())
	timeText:setPositionY(timeTextBoundingBox:getMidY())


	local numLabel = LabelBMMonospaceFont:create(20, 35, 15, "fnt/event_default_digits.fnt")
	numLabel:setAnchorPoint(ccp(0.5, 0.5))
	numLabel:setPositionX(pao:getPositionX() + 35)
	numLabel:setPositionY(pao:getPositionY() - 35)
	ui:addChild(numLabel)

	pao:setTouchEnabled(true)
	
	local _self = self
	function ui:refresh( ... )
		local reward = SeasonWeeklyRaceManager:getInstance():getNextDailyReward()
		if not reward then 
			return
		end
		time:setVisible(true)
		timeText:stopAllActions()

		showDesc(reward.nextDayReward)

		local canReceive = false
		if not reward.nextDayReward then

			if reward.needMore == 0 then --可领奖
				canReceive = true
				time:setVisible(false)
			else
				local startTime = os.date("*t", Localhost:timeInSec())
				startTime.hour = 0
				startTime.min = 0
				startTime.sec = 0
				startTime = os.time(startTime)

				timeText:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(
					CCCallFunc:create(function( ... )
						local leftTime = math.max(0,24 * 3600 - (Localhost:timeInSec() - startTime))
						local leftHour = math.floor(leftTime/3600)
						local leftMinute = math.floor((leftTime - 3600 * leftHour) / 60)
						local leftSecond = leftTime - 3600 * leftHour - leftMinute*60  
						timeText:setString(string.format("%02d:%02d:%02d",leftHour,leftMinute,leftSecond))
					end),
					CCDelayTime:create(1.0)
			 	)))
			end
			setNumber(tostring(reward.condition))
		else
			time:setVisible(false)
		end

		local itemId = reward.items[1].itemId
		local num = reward.items[1].num
		local sprite = ui:getChildByName("item")
		if sprite then 
			sprite:removeFromParentAndCleanup(true)
		end

		local propId
		if ItemType:isTimeProp(itemId) then
			propId = ItemType:getRealIdByTimePropId(itemId)
			timeLimitFlag:setVisible(true)
		else
			propId = itemId
			timeLimitFlag:setVisible(false)
		end

		sprite = ResourceManager:sharedInstance():buildItemSprite(propId)
		sprite.name = "item"
		sprite:setAnchorPoint(ccp(0.5,0.5))
		sprite:setPositionX(pao:getPositionX())
		sprite:setPositionY(pao:getPositionY())
		ui:addChildAt(sprite,ui:getChildIndex(numLabel))

		numLabel:setVisible(true)
		numLabel:setString("x" .. tostring(num))

		pao:removeAllEventListeners()
		-- canReceive = true
		if canReceive then 
			-- receiveDailyReward
			pao:addEventListener(DisplayEvents.kTouchTap,function( ... )
				local r = {{itemId=itemId,num=num}}
				local pos = ui:convertToWorldSpace(pao:getPosition())

				SeasonWeeklyRaceManager:getInstance():receiveDailyReward( reward.id, function( ... )
					if _self.isDisposed then 
						return
					end

					numLabel:setVisible(false)
					sprite:setVisible(false)
					_self:setArrowMode(arrow,false)
					_self:playRewarsAnim(bubble,bubbleExploaded,r,pos,function( ... )
						if not _self.isDisposed then
							_self.refreshAll()
						end
					end)
				end, function( event )
					if _self.isDisposed then 
						return
					end

					-- 减少一种后端报错:后端领奖成功，前端丢失（取消）回调
					if tonumber(event.data or 0) == 730770 then
						_self:closePanel()
						setTimeOut(function () SeasonWeeklyRaceManager:getInstance():pocessSeasonWeeklyDecision(false) end, 1)
						return
					end

					_self.refreshAll()
				end )

				pao:removeAllEventListeners()
			end)
		else
			pao:addEventListener(DisplayEvents.kTouchTap,function( ... )
				_self:showPropsTip(pao:getGroupBounds(),itemId)
			end)
		end
		_self:setBubbleMode(pao,canReceive)
		_self:setArrowMode(arrow,canReceive)
		_self.dailyReceive = canReceive
	end

	ui:refresh()

	return ui
end

function WinterWeeklyPanel:showPropsTip(bounds, itemId)

	local content = self:buildInterfaceGroup('winterWeeklyPanel/bagItemTipContent')--ResourceManager:sharedInstance():buildGroup('bagItemTipContent')
	local desc = content:getChildByName('desc')
	local title = content:getChildByName('title')

	local propsId
	if ItemType:isTimeProp(itemId) then
		propsId = ItemType:getRealIdByTimePropId(itemId)
	else
		propsId = itemId
	end

	title:setString(Localization:getInstance():getText("prop.name."..itemId))
	local originSize = desc:getDimensions()
	desc:setDimensions(CCSizeMake(originSize.width, 0))
	desc:setString(Localization:getInstance():getText("level.prop.tip."..propsId, {n = "\n", replace1 = 1}))

	local tip = BubbleTip:create(content, propsId)
	tip:show(bounds)

end

function WinterWeeklyPanel:initWeekReward( ui )
	local _self = self

	ui:getChildByName("title.1"):setVisible(false)
	ui:getChildByName("title.3"):setVisible(false)
	ui:getChildByName("time"):setVisible(false)
 	ui:getChildByName("time_limit_flag"):setVisible(false)

 	local rewards = nil

	local desc1 = ui:getChildByName("desc.1")
	local icon = ui:getChildByName("icon")
	local desc2 = ui:getChildByName("desc.2")
	local pao = ui:getChildByName("pao")
	local arrow = ui:getChildByName("arrow")
	arrow.originPoint = ccp(arrow:getPositionX(),arrow:getPositionY())

	local bubble = ui:getChildByName("pao")
	local bubbleExploaded = ui:getChildByName("ani")
	bubbleExploaded:setVisible(false)

	local iconBoundBox = icon:boundingBox()

	desc1:setDimensions(CCSizeMake(0,0))
	desc2:setDimensions(CCSizeMake(0,0))

	desc1:setAnchorPoint(ccp(1,0.5))
	desc1:setPositionX(iconBoundBox:getMinX()-4)
	desc1:setPositionY(iconBoundBox:getMidY())

	desc2:setAnchorPoint(ccp(0,0.5))
	desc2:setPositionX(iconBoundBox:getMaxX()+4)
	desc2:setPositionY(iconBoundBox:getMidY())

	desc1:setString(Localization:getInstance():getText("weeklyrace.winter.panel.desc18"))--"累计获得"
	-- desc2:setString("2000个")


	local chestLayer = Layer:create()
	for i=1,5 do
		local chest = self:buildInterfaceGroup("winterWeeklyChest/chest")

		chestLayer["pao" .. tostring(i)] = chest:getChildByName("pao")
		chestLayer[tostring(i)] = chest:getChildByName(tostring(i))
		chestLayer["open." .. tostring(i)] = chest:getChildByName("open." .. tostring(i))

		for j=1,5 do
			chest:getChildByName(tostring(j)):setVisible(i == j)
			chest:getChildByName("open." .. tostring(j)):setVisible(i == j)
		end

		chest:setPositionX((i - 1)*180)
		chestLayer:addChild(chest)

		chest:setTouchEnabled(true)
		chestLayer["chest" .. tostring(i)] = chest
	end

	local mask = CCLayerColor:create()
	mask:setContentSize(CCSizeMake(50 + 155,175))
	mask:ignoreAnchorPointForPosition(false)
	mask:setAnchorPoint(ccp(0,1))
	mask:setPositionX(-155/2)
	mask:setPositionY(155/2)
	local clipingnode = ClippingNode.new(CCClippingNode:create(mask))
	clipingnode:setPositionX(pao:getPositionX() - 25)
	clipingnode:setPositionY(pao:getPositionY())
	-- clipingnode:setAlphaThreshold(0)
	ui:addChild(clipingnode)
	clipingnode:addChild(chestLayer)

	local leftArrow = ui:getChildByName("leftArrow")
	local rightArrow = ui:getChildByName("rightArrow")

	local chestIndex = 1
	function pao:setVisible( isVisible )
		if isVisible then 
			local chest = chestLayer["chest" .. tostring(chestIndex)]
			local worldPos = chest:convertToWorldSpace(chestLayer["pao" .. tostring(chestIndex)]:getPosition())
			local localPos = pao:convertToNodeSpace(worldPos)
			pao:getChildAt(0):setPositionX(localPos.x)
			pao:getChildAt(0):setPositionY(localPos.y)
		end
		
		pao:setChildrenVisible(isVisible,false)
		for i=1,5 do
			chestLayer["pao" .. tostring(i)]:setVisible(not isVisible)
		end
	end

	function chestLayer:refresh( ... )

		self:setVisible(true)
		self:stopAllActions()

		pao:setVisible(false)
		self:runAction(CCSequence:createWithTwoActions(
			CCMoveTo:create(0.3,ccp(25 + (1-chestIndex) * 180,self:getPositionY())),
			CCCallFunc:create(function( ... )
				pao:setVisible(true)
			end)
		))

		for i=1,5 do
			self[tostring(i)]:setVisible(not rewards[i].hasReceived)
			self["open." .. tostring(i)]:setVisible(rewards[i].hasReceived)
		end
		
		_self:setBubbleMode(pao,rewards[chestIndex]:canReceive())
		_self:setArrowMode(arrow,rewards[chestIndex]:canReceive() and not _self.dailyReceive)

		leftArrow:setVisible(chestIndex > 1)
		rightArrow:setVisible(chestIndex < 5)

		desc2:setString(Localization:getInstance():getText("weeklyrace.winter.panel.desc19",{num=rewards[chestIndex].condition}))
	end

	leftArrow:setTouchEnabled(true)
	leftArrow:setButtonMode(true)
	leftArrow:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if chestIndex > 1 then 
			chestIndex = chestIndex - 1
			chestLayer:refresh()
		end
	end)

	rightArrow:setTouchEnabled(true)
	rightArrow:setButtonMode(true)
	rightArrow:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if chestIndex < 5 then 
			chestIndex = chestIndex + 1
			chestLayer:refresh()
		end
	end)

	pao:setTouchEnabled(true)
	function ui:refresh( ... )
		rewards = SeasonWeeklyRaceManager:getInstance():getNextWeeklyReward()

		for k,v in pairs(rewards) do
			function v:canReceive( ... )
				return self.needMore == 0 and not self.hasReceived
			end
		end

		for i,v in ipairs(rewards) do
			if not v.hasReceived then
				chestIndex = i
				break
			end
		end
		chestLayer:refresh()

		pao:removeAllEventListeners()
		pao:addEventListener(DisplayEvents.kTouchTap,function( ... )
			local v = rewards[chestIndex]
			if v:canReceive() then
				local r = rewards[chestIndex].items
				local pos = ui:convertToWorldSpace(pao:getPosition())
				SeasonWeeklyRaceManager:getInstance():receiveWeeklyReward(v.id,function( ... )
					if _self.isDisposed then 
						return
					end
					chestLayer:setVisible(false)
					_self:setArrowMode(arrow,false)
					_self:playRewarsAnim(bubble,bubbleExploaded,r,pos,function( ... )
						if not _self.isDisposed then
							_self.refreshAll()
						end
					end,true)
				end, function(event)
					if _self.isDisposed then 
						return
					end

					-- 减少一种后端报错:后端领奖成功，前端丢失（取消）回调
					if tonumber(event.data or 0) == 730770 then
						_self:closePanel()
						setTimeOut(function () SeasonWeeklyRaceManager:getInstance():pocessSeasonWeeklyDecision(false) end, 1)
						return
					end
					-- tip
					_self.refreshAll()
				end )

				pao:removeAllEventListeners()
			elseif v.hasReceived then 
				CommonTip:showTip(Localization:getInstance():getText("weeklyrace.winter.panel.tip9"), "positive")
			elseif v.needMore > 0 then 
				local ipt = {}
				for k, v in ipairs(rewards[chestIndex].items) do
					local itemId = v.itemId
					if ItemType:isTimeProp(itemId) then
						itemId = ItemType:getRealIdByTimePropId(itemId)
					end
					table.insert(ipt, {itemId = itemId, num = v.num})
				end
				local tipPanel = BoxRewardTipPanel:create({ rewards=ipt })
				local text = Localization:getInstance():getText("weeklyrace.winter.panel.tip1",{num=v.needMore})
				-- local wmIcon = Sprite:createWithSpriteFrameName("winterWeeklyPanel/watermelon0000")
				-- wmIcon:setAnchorPoint(ccp(0.5,0.5))
				-- wmIcon:setScale(0.5)
				-- wmIcon:setPositionX(80)
				-- wmIcon:setPositionY(-40)
				-- tipPanel:addChild(wmIcon)

				tipPanel:setTipString(text)
				
				_self.ui:addChild(tipPanel)
				local bounds = pao:getGroupBounds()
				tipPanel:setArrowPointPositionInWorldSpace(bounds.size.width/2,bounds:getMidX(),bounds:getMidY())		
			end
		end)

	end

	ui:refresh()

	chestLayer:stopAllActions()
	chestLayer:setPositionX(25 + (1-chestIndex) * 180)
	pao:setVisible(true)

	return ui
end

function WinterWeeklyPanel:playRewarsAnim(bubble,bubbleExploded,rewards,pos,callback,isWeek)
	local function playFlyReward( cb )
		if self.isDisposed then 
			return 
		end

		if isWeek then
			local anim = OpenBoxAnimation:create(rewards)
			anim:setFinishCallback(cb)
			anim:play()
		else
			local anim = FlyItemsAnimation:create(rewards)
			anim:setWorldPosition(pos)
			anim:setFinishCallback(cb)
			anim:play()
		end
		
	end

	local arr = CCArray:create()
	arr:addObject(CCCallFunc:create(function( ... )
		bubble:setVisible(true)
		bubbleExploded:setVisible(true)
	end))
	arr:addObject(CCCallFunc:create(function( ... )
		playFlyReward(function( ... )
			if self.isDisposed then
				return
			end
			bubble:setVisible(true)
			bubbleExploded:setVisible(false)

			if callback then 
				callback()
			end
		end)
	end))
	arr:addObject(self:getBubbleExplodedAction(bubble,bubbleExploded))
	arr:addObject(CCCallFunc:create(function( ... )
		bubble:setVisible(false)
		bubbleExploded:setVisible(false)
	end))
	
	self:runAction(CCSequence:create(arr))
end

function WinterWeeklyPanel:initButton( ui,coinBuyUi )
	local _self = self

	local button = GroupButtonBase:create(ui)
	button.redDot = button.groupNode:getChildByName("redDot")
	button.num = button.groupNode:getChildByName("num")
	button.shadow = button.groupNode:getChildByName("shadow")
	function button:setNumberVisible( isVisible )
		button.redDot:setVisible(isVisible)
		button.num:setVisible(isVisible)
	end
	function button:setNumber( n )
		button.num:setString(tostring(n))
	end
	function button:setShadowVisible( isVisible )
		button.shadow:setVisible(isVisible)
	end

	local coinBuyButton = ButtonIconNumberBase:create(coinBuyUi)
	coinBuyButton:setIconByFrameName('ui_images/ui_image_coin_icon_small0000')
	coinBuyButton:setString(Localization:getInstance():getText("weekly.race.panel.rabbit.button2"))

	local bubbleAnim = nil
	function button:refresh( ... )
		print('wenkan button:refresh')
		button:removeAllEventListeners()
		coinBuyButton:removeAllEventListeners()
		button:setNumberVisible(false)
		button:setVisible(true)
		coinBuyButton:setVisible(false)
		button:setColorMode(kGroupButtonColorMode.green)
		button:setShadowVisible(false)

		print('wenkan getLeftPlay', 
			SeasonWeeklyRaceManager:getInstance():getLeftPlay(), 
			SeasonWeeklyRaceManager:getInstance():canGetFreePlay(),
			SeasonWeeklyRaceManager:getInstance():getLeftBuyCount())

		if SeasonWeeklyRaceManager:getInstance():getLeftPlay() > 0 then
			if not bubbleAnim then
				bubbleAnim = button:useBubbleAnimation()
			end
			button:setShadowVisible(true)
			button:setNumberVisible(true)
			button:setNumber(SeasonWeeklyRaceManager:getInstance():getLeftPlay())
			button:setString(Localization:getInstance():getText("weekly.race.panel.start.btn"))--"去闯关"
			button:addEventListener(DisplayEvents.kTouchTap,function( ... )
				local function onCancelPlay()
				end
				local function onConfirmPlay()
					button:rma()
					_self:startLevel()
				end
				if SeasonWeeklyRaceManager:getInstance():isNeedShowTimeWarnPanel() then
					_self:showTimeNotEnoughWarningPanel(onConfirmPlay, onCancelPlay)
				else
					onConfirmPlay()
				end
			end)
		elseif SeasonWeeklyRaceManager:getInstance():canGetFreePlay() then
			if bubbleAnim then
				bubbleAnim:cancelBubbleAnimation()
				bubbleAnim = nil
			end
			button:setString(Localization:getInstance():getText("weekly.race.panel.rabbit.button5"))--"获得次数"
			button:addEventListener(DisplayEvents.kTouchTap,function( ... )
				local panel = SeasonWeeklyGetFreePlayPanel:create(_self,
					SeasonWeeklyRaceManager:getInstance():getLevelId(),
					function()
						button:rma()
						_self:startLevel()
					end
				)
				panel:popout()
			end)
		elseif SeasonWeeklyRaceManager:getInstance():getLeftBuyCount() > 0 then
			if bubbleAnim then
				bubbleAnim:cancelBubbleAnimation()
				bubbleAnim = nil
			end
			local function onSuccess( ... ) 
				button:rma()
				_self:startLevel()
			end
			local function onFail( ... ) button:refresh() end
			local function onCancel( ... ) button:refresh() end
			local function onFinish( ... ) button:refresh() end
			local ignoreSecondConfirm = false

			local function buyPlayCard( ... )
				local function onCancelBuy()
				end
				local function onConfirmBuy()
					button:rma()
					SeasonWeeklyRaceManager:getInstance():buyPlayCard( onSuccess, onFail, onCancel, onFinish, ignoreSecondConfirm)
				end
				if SeasonWeeklyRaceManager:getInstance():isNeedShowTimeWarnPanel() then
					_self:showTimeNotEnoughWarningPanel(onConfirmBuy, onCancelBuy)
				else
					onConfirmBuy()
				end
			end

			local buyGoodId = SeasonWeeklyRaceManager:getInstance():getBuyGoodId()
	        if __ANDROID and not PaymentManager.getInstance():checkCanWindMillPay(buyGoodId) then
				local mark = Localization:getInstance():getText("buy.gold.panel.money.mark")
				local text = Localization:getInstance():getText("weekly.race.panel.rabbit.button2")
				local rmb = SeasonWeeklyRaceManager:getInstance():getBuyRmb()
				button:setString(string.format("%s%0.2f %s", mark, rmb, text))
				button:addEventListener(DisplayEvents.kTouchTap,function( ... )
					buyPlayCard()
				end)
			else
				button:setVisible(false)
				coinBuyButton:setVisible(true)
				coinBuyButton:setNumber(SeasonWeeklyRaceManager:getInstance():getBuyQCash())
				coinBuyButton:addEventListener(DisplayEvents.kTouchTap,function( ... )
					buyPlayCard()
				end)
			end
		else
			if bubbleAnim then
				bubbleAnim:cancelBubbleAnimation()
				bubbleAnim = nil
			end
			button:setString(Localization:getInstance():getText("weekly.race.panel.start.btn")) --"去闯关"
			button:setColorMode(kGroupButtonColorMode.grey)
			button:addEventListener(DisplayEvents.kTouchTap,function( ... )
				--"今日次数已用完"
				CommonTip:showTip(Localization:getInstance():getText("weekly.race.panel.rabbit.button3"),"negative")
			end)

		end
	end 

	button:refresh()
	return button
end

function WinterWeeklyPanel:checkLastWeekRewards()
	local function showWeekRewards()
		local weekRewards, rewardLevelId = SeasonWeeklyRaceManager:getInstance():getLastWeekRewardsForRewardsPanel()
		if weekRewards and #weekRewards > 0 then
			self.weeklyDecisionType = nil
			local panel = SeasonWeeklyRaceRewardsPanel:create(weekRewards, rewardLevelId)
			panel:popout()
		end
	end
	-- 优先显示上周排行奖励
	local rankRewards, rankLevelId, rank, surpass = SeasonWeeklyRaceManager:getInstance():getLastWeekRankRewardsForRewardsPanel()
	if rankRewards and #rankRewards > 0 then
		self.weeklyDecisionType = nil
		local panel = SeasonWeeklyRaceSharePanel:create(rankRewards, rankLevelId, rank, surpass)
		panel:popout(showWeekRewards)
	else
		showWeekRewards()
	end
end

function WinterWeeklyPanel:setBubbleMode(bubble,enable)
	bubble:stopAllActions()
	bubble:setScale(1)

	if enable then

		local bubbleAnimations = CCArray:create()
		bubbleAnimations:addObject(CCDelayTime:create(20/24))
		bubbleAnimations:addObject(CCScaleTo:create(15/24, 1.11))
		bubbleAnimations:addObject(CCScaleTo:create(15/24, 1))
		-- for i=1,2 do
		-- 	bubbleAnimations:addObject(CCScaleTo:create(5/24, 1.13,1))
		-- 	bubbleAnimations:addObject(CCScaleTo:create(5/24,0.956,1.068))
		-- 	bubbleAnimations:addObject(CCScaleTo:create(5/24,1,1))
		-- end
		bubble:runAction(CCRepeatForever:create(CCSequence:create(bubbleAnimations)))
		
	end
end

function WinterWeeklyPanel:setArrowMode(arrow,enable)
	arrow:setVisible(enable)
	arrow:stopAllActions()
	arrow:setPositionX(arrow.originPoint.x)
	arrow:setPositionY(arrow.originPoint.y)

	if enable then

		local arrowAnimations = CCArray:create()
		arrowAnimations:addObject(CCMoveBy:create(10/24,ccp(-16,-16)))
		arrowAnimations:addObject(CCMoveBy:create(10/24,ccp(16,16)))

		arrow:runAction(CCRepeatForever:create(CCSequence:create(arrowAnimations)))
		
	end

end


local data = {}

data[1] = {}
data[1][1]	= {	28.95,	-4.50,	1.047,	1.047,	7}
data[1][2]	= {	27.20,	4.75,	0.283,	0.283,	13}

data[2] = {}
data[2][1]	= {	7.55,	-19.40,	1.309,	1.309,	7}
data[2][2]	= {	-2.20,	-14.85,	0.244,	0.244,	13}

data[3]	= {}
data[3][1]	= {	7.80,	-26.05,	0.566,	0.566,	7}
data[3][2]	= {	0,	-25.55,	0.22,	0.22,	12}

data[4] = {}
data[4][1]	= {	9.0,	-45.90,	0.566,	0.566,	7}
data[4][2]	= {	3.9,	-48.25,	0.178,	0.178,	12}

data[5]	= {}
data[5][1]	= {	9.7,	-51.20,	0.861,	0.861,	7}
data[5][2]	= {	4.25,	-57.15,	0.209,	0.209,	12}

data[6]	= {}
data[6][1]	= {	37.5,	-62.7,	0.387,	0.387,	7}
data[6][2]	= {	38.10,	-68.25,	0.278,	0.278,	11}

data[7] = {}
data[7][1]	= {	57.85,	-57.80,	1.309,	1.309,	7}
data[7][2]	= {	65.40,	-65.35,	0.244,	0.244,	13}

data[8] = {}
data[8][1]	= {	60.45,	-51.20,	0.566,	0.566,	7}
data[8][2]	= {	65.9,	-54.80,	0.275,	0.275,	12}

data[9] = {}
data[9][1]	= {	61.40,	-35.90,	0.387,	0.387,	7}
data[9][2]	= {	66.45,	-36,	0.265,	0.265,	12}

data[10] = {}
data[10][1]	= {	62.40,	-10.25,	0.861,	0.861,	7}
data[10][2]	= {	69.45,	-4.35,	0.276,	0.276,	13}

------------------------------------------------------------
------------------------------------------------------------

data[11] = {}
data[11][1] = { 32.15,	1.05,	1.413, 1.413,	7}
data[11][2] = {	30.25,	19.30,	0.564,	0.564,	13}

data[12] = {}
data[12][1] = {	11.20,	-9.80,	0.973,	0.973,	7}
data[12][2] = {	2.15,	-1.05,	0.421,	0.421,	13}

data[13] = {}
data[13][1] = { 7.30,	-10.70,	0.447,	0.447,	7}
data[13][2] = { 1.55,	-6.05,	0.291,	0.291,	13}

data[14] = {}
data[14][1] = {	-2.65,	-30,	1.413,	1.413,	7}
data[14][2] = {-18.55,	-27.50,	0.38,	0.38,	15}

data[15] = {}
data[15][1] = {-4.25,	-40.05,	0.424,	0.424,	7}
data[15][2] = {-15.55,	-39.60,	0.181,	0.181,	13}

data[16] = {}
data[16][1] = {-7.30,	-42.30,	0.785,	0.785,	7}
data[16][2] = {-14.80,	-43.25,	0.273,	0.273,	14}

data[17] = {}
data[17][1] = { -0.20,	-57.15,	0.424,	0.424,	7}
data[17][2] = {-5,	-59.55,	0.255,	0.255,	13}

data[18] = {}
data[18][1] = {14.05,	-68.45,	1.031,	1.031,	7}
data[18][2] = {8.65,	-76.20,	0.318,	0.318,	14}

data[19] = {}
data[19][1] = {65.35,	-56.55,	2.025, 2.025, 7}
data[19][2] = {81.20,	-69.30,	0.438, 0.438, 15}

data[20] = {}
data[20][1] = {74.8,	-47.55,	0.447, 0.447,	7}
data[20][2] = {82.55,	-49.70,	0.291,	0.291,	13}

data[21] = {}
data[21][1] = {72.65,	-19.65,	1.054, 1.054,	7}
data[21][2] = {83.15,	-16.25,	0.302, 0.302,	13}

data[22] = {}
data[22][1] = {62.05,	-17.60,	0.608,	0.608,	7}
data[22][2] = {67.80,	-12.60,	0.362,	0.362,	12}

data[23] = {}
data[23][1] = {66.85,	-8.30,	1.50,	1.50,	7}
data[23][2] = {76.85,	-2.75,	0.52,	0.52,	14}

data[24] = {}
data[24][1] = {42.80,	-8.30,	0.608,	0.608,	7}
data[24][2] = {44.35,	10.0,	0.412,	0.412,	14}

function WinterWeeklyPanel:getBubbleExplodedAction( bubble,bubbleExploded )

	bubbleExploded:setScaleX(248.05 / 103.35)
	bubbleExploded:setScaleY(238.30 / 99.30)
	-- bubbleExploded:setPositionX(0)
	-- bubbleExploded:setPositionY(0)

	local bubbleClips = {}

	for index = 1,24 do
		local bubbleClip = bubbleExploded:getChildByName(tostring(index))
		assert(bubbleClip)
		bubbleClips[index] = bubbleClip
		bubbleClip:setVisible(false)
	end

	local bubbleClipsActionArray = CCArray:create()

	local manualAdjustFrameIndex = -1

	for index = 1,24 do

		local bubbleClipAnimInfo = {

			secondPerFrame = 1 / 36,
			--secondPerFrame = 1 / 24,
			--secondPerFrame = 1,

			object = {
				node = bubbleClips[index],
				deltaScaleX	= 1,
				deltaScaleY	= 1,
				originalScaleX = 1,
				originalScaleY = 1,
			},

			keyFrames = {
				{ tweenType = "delay", frameIndex = 1},

				{ tweenType = "normal", frameIndex = data[index][1][5] + manualAdjustFrameIndex, x = data[index][1][1] - 28, y = data[index][1][2] + 15, sx = data[index][1][3], sy = data[index][1][4]},
				{ tweenType = "static", frameIndex = data[index][2][5] + manualAdjustFrameIndex, x = data[index][2][1] - 28, y = data[index][2][2] + 15, sx = data[index][2][3], sy = data[index][2][4]}
			}
		}

		local bubbleClipAction = FlashAnimBuilder:sharedInstance():buildTimeLineAction(bubbleClipAnimInfo)
		
		local function hideBubbleClip()
			bubbleClips[index]:setVisible(false)
			bubbleClips[index]:setPosition(ccp(data[index][1][1], data[index][1][2]))
		end
		local hideBubbleClipAction = CCCallFunc:create(hideBubbleClip)

		local bubbleClipAction = CCSequence:createWithTwoActions(bubbleClipAction, hideBubbleClipAction)
		bubbleClipsActionArray:addObject(bubbleClipAction)

	end

	-- Spawn
	local bubbleClipsAction = CCSpawn:create(bubbleClipsActionArray)
	
	-- do return bubbleClipsAction end


	----------------------
	-- Bubble Animation
	-- --------------------

	local bubbleX = bubble:getPositionX()
	local bubbleY = bubble:getPositionY()

	local bubbleAnimInfo = {
		secondPerFrame = 1 / 36,
		--secondPerFrame = 1 / 2,
		--secondPerFrame = 1/24,
		-- secondPerFrame = 1,

		object = {
			node = bubble,
			deltaScaleX = 1,
			deltaScaleY = 1,
			originalScaleX = 1,
			originalScaleY = 1,
		},

		keyFrames = {
			--{ tweenType = "normal", frameIndex = 1, x = 0,		y = -0,		sx = 1,		sy = 1 },
			--{ tweenType = "static", frameIndex = 2, x = 16.65,	y = -15.40,	sx = 0.57,	sy = 0.60},
			--{ tweenType = "normal", frameIndex = 3, x = 12.95,	y = -13.90,	sx = 0.666,	sy = 0.640},
			--{ tweenType = "static", frameIndex = 6, x = 0.7,	y = -2.15,	sx = 0.982,	sy = 0.944},
			{ tweenType = "normal", frameIndex = 1, x = bubbleX,	y = bubbleY,		sx = 1,		sy = 1},
			{ tweenType = "static", frameIndex = 5, x = bubbleX,	y = bubbleY,	sx = 1.232,	sy = 1.184 },
			{ tweenType = "delay", frameIndex = 6}
		}
	}

	local bubbleAnim = FlashAnimBuilder:sharedInstance():buildTimeLineAction(bubbleAnimInfo)

	-- Bubble Anim Finish Callback
	local function bubbleAnimFinish()
		bubble:setVisible(false)
	end
	local bubbleAnimFinishCallback = CCCallFunc:create(bubbleAnimFinish)

	-- Bubble Anim
	local bubbleAnim = CCSequence:createWithTwoActions(bubbleAnim, bubbleAnimFinishCallback)


	local spawn = CCSpawn:createWithTwoActions(bubbleClipsAction, bubbleAnim)
	return spawn
end

function WinterWeeklyPanel:initRankList( listBgUi,tip )
	local _self = self

	local function attachHead( uid,head )
		local friendRef = nil
		if tostring(UserManager:getInstance().uid) == tostring(uid) then 
			friendRef = UserManager.getInstance().profile
		else
			friendRef = FriendManager.getInstance().friends[tostring(uid)]
		end
		-- friendRef.headUrl = "http://cdnq.duitang.com/uploads/item/201407/07/20140707014508_JxAY2.jpeg"

		local headUrl
		if friendRef then
			headUrl = friendRef.headUrl
		end

		local image = HeadImageLoader:create(uid, headUrl)
		image:setScaleX(head:getContentSize().width/100)
		image:setScaleY(head:getContentSize().height/100)
		image:setPositionX(head:getContentSize().width/2)
		image:setPositionY(head:getContentSize().height/2)
		head:addChild(image)

	end

	local function getFriendName( uid )
		local friendRef = nil
		if tostring(UserManager:getInstance().uid) == tostring(uid) then 
			-- friendRef = UserManager.getInstance().profile
			return "我"
		else
			friendRef = FriendManager.getInstance().friends[tostring(uid)]
		end
		if friendRef and friendRef.name and string.len(friendRef.name) > 0 then 
			return HeDisplayUtil:urlDecode(friendRef.name)
		else
			return "ID:"..tostring(uid)
		end
	end

	local boundingBox = listBgUi:boundingBox()
	listBgUi:setVisible(false)
	local tableViewWidth = boundingBox.size.width
	local tableViewHeight = boundingBox.size.height - 40	

	local tableViewRender = 
	{
		setData = function () end
	}
	function tableViewRender:getContentSize(tableView,idx)
		return CCSizeMake(616,90)
	end
	function tableViewRender:numberOfCells()
		if not _self.rankData then 
			return 0
		else
			return #_self.rankData:getRankList()
		end
	end
	function tableViewRender:buildCell(cell,idx)
		if _self.isDisposed then 
			return
		end

		local uid = _self.rankData:getRankList()[idx + 1].uid
		local score = _self.rankData:getRankList()[idx + 1].score

		local key = tostring(uid)
		local cellItem = _self.cellItems[key]
		if not cellItem then
			cellItem = _self:buildInterfaceGroup("winterWeeklyPanel/rank/rank")

			local cellItemSize = cellItem:getGroupBounds().size
			cellItem:setPositionX(tableViewWidth/2 - cellItemSize.width/2)
			cellItem:setPositionY(cellItemSize.height/2 + self:getContentSize(nil,idx).height/2)
			
			_self.cellItems[key] = cellItem

			attachHead(uid,cellItem:getChildByName("head"))
			cellItem:getChildByName("name"):setString(getFriendName(uid))

			cellItem.pos1 = cellItem:getChildByName("pos1")
			cellItem.pos2 = cellItem:getChildByName("pos2")
			cellItem.pos3 = cellItem:getChildByName("pos3")
			cellItem.pos4 = cellItem:getChildByName("pos4")
			cellItem.pos5 = cellItem:getChildByName("pos5")
			cellItem.pos4Num = cellItem:getChildByName("pos4Num")
			cellItem.pos4Num:setDimensions(CCSizeMake(0,0))
			cellItem.pos4Num:setAnchorPoint(ccp(0.5,0.5))
			cellItem.pos4Num:setPositionX(cellItem.pos4:boundingBox():getMidX())
			cellItem.pos4Num:setPositionY(cellItem.pos4:boundingBox():getMidY())
		end

		cellItem.pos1:setVisible(idx == 0 and score > 0)
		cellItem.pos2:setVisible(idx == 1 and score > 0)
		cellItem.pos3:setVisible(idx == 2 and score > 0)
		cellItem.pos4:setVisible(idx >= 3 and score > 0)
		cellItem.pos4Num:setVisible(idx >= 3 and score > 0)
		if cellItem.pos4Num:isVisible() then
			cellItem.pos4Num:setString(tostring(idx + 1))
			cellItem.pos4Num:setFontSize(idx >= 99 and 22 or 30)
		end
		cellItem.pos5:setVisible(score == 0)

		if score == 0 then 
			cellItem:getChildByName("icon"):setVisible(false)
			cellItem:getChildByName("icon2"):setVisible(false)
			--"努力闯关中"
			cellItem:getChildByName("num"):setString("")
			cellItem:getChildByName("num2"):setString(Localization:getInstance():getText("weeklyrace.winter.panel.desc16"))
		else
			-- if tostring(UserManager:getInstance().uid) == tostring(uid) then
			-- 	local num = SeasonWeeklyRaceManager:getInstance():getSurpassGoldReward()
			-- 	cellItem:getChildByName("icon"):setVisible(false)
			-- 	cellItem:getChildByName("icon2"):setVisible(true)
			-- 	cellItem:getChildByName("num"):setString(tostring(num))
			-- else
				cellItem:getChildByName("icon"):setVisible(true)
				cellItem:getChildByName("icon2"):setVisible(false)
				cellItem:getChildByName("num2"):setString("")
				cellItem:getChildByName("num"):setString(tostring(score))
			-- end
		end


		cellItem.refCocosObj:removeFromParentAndCleanup(false)
		cell.refCocosObj:addChild(cellItem.refCocosObj)

		if tostring(UserManager:getInstance().uid) == tostring(uid) then 
			cellItem:setTouchEnabled(true)
			cellItem:addEventListener(DisplayEvents.kTouchTap, function ()
				_self:showNumberTip()
			end)
		end
	end


	local tableView = TableView:create(tableViewRender,tableViewWidth,tableViewHeight)
	tableView:ignoreAnchorPointForPosition(false)
	tableView:setAnchorPoint(ccp(0.5,0.5))
	tableView:setPositionX(boundingBox:getMidX())
	tableView:setPositionY(boundingBox:getMidY())

	listBgUi:getParent():addChild(tableView)

	function tableView:refresh( ... )
		tip:setVisible(false)
		SeasonWeeklyRaceManager:getInstance():getRankData(function( ... )
			if _self.isDisposed then 
				return
			end
			tip:setVisible(false)
			_self.rankData = SeasonWeeklyRaceManager:getInstance().rankData
			self:reloadData()
		end,function( ... )
			if _self.isDisposed then 
				return 
			end
			tip:setVisible(true)
			_self.rankData = nil
			self:reloadData()
		end)
	end
	tableView:reloadData()
	tableView:refresh()
	return tableView
end

function WinterWeeklyPanel:showTimeNotEnoughWarningPanel(onConfirm, onCancel)
	local descText = Localization:getInstance():getText("weekly.race.winter.start.tip1")
	local panel = TwoChoicePanel:create(descText, "取消", "继续", "不再提醒", true)
	local function onCancelBtnTapped(dontShowAgain)
		SeasonWeeklyRaceManager:getInstance():setTimeWarningDisabled(dontShowAgain)
		if onCancel then onCancel() end
	end
	local function onConfirmBtnTapped(dontShowAgain)
		SeasonWeeklyRaceManager:getInstance():setTimeWarningDisabled(dontShowAgain)
		if onConfirm then onConfirm() end
	end
	panel:setButton1TappedCallback(onCancelBtnTapped)
	panel:setButton2TappedCallback(onConfirmBtnTapped)
	panel:setCloseButtonTappedCallback(onCancelBtnTapped)
	panel:popout()
end

function WinterWeeklyPanel:startLevel()
	print("!!!!!!!!!!!!!!!!StartGame", SeasonWeeklyRaceManager:getInstance():calcLevelId())
	local logic = StartLevelLogic:create(self, SeasonWeeklyRaceManager:getInstance():calcLevelId(), GameLevelType.kSummerWeekly, {}, true)
	logic:start(true)
end

function WinterWeeklyPanel:onStartLevelLogicSuccess()
	SeasonWeeklyRaceManager:getInstance():onStartLevel()
end

function WinterWeeklyPanel:onStartLevelLogicFailed(err)
	local onStartLevelFailedKey     = "error.tip."..err
    local onStartLevelFailedValue   = Localization:getInstance():getText(onStartLevelFailedKey, {})
    CommonTip:showTip(onStartLevelFailedValue, "negative")
    
    self.refreshAll(false)
end

function WinterWeeklyPanel:onWillEnterPlayScene()
	self.refreshAll(false)
end

function WinterWeeklyPanel:onDidEnterPlayScene(gamePlayScene)
	if gamePlayScene and gamePlayScene.gameBoardLogic then
		local summerWeeklyData = {}
		summerWeeklyData.dropPropsPercent = SeasonWeeklyRaceManager:getInstance():getSpecialPercent()
		summerWeeklyData.orignalDropPropsPercent = summerWeeklyData.dropPropsPercent
		-- summerWeeklyData.dropPropsPercent = 100
		gamePlayScene.gameBoardLogic.summerWeeklyData = summerWeeklyData
	end
end

function WinterWeeklyPanel:initMyNumber( ui )
	local _self = self

	local desc1 = ui:getChildByName("desc1")
	local icon = ui:getChildByName("icon")
	local desc2 = ui:getChildByName("desc2")

	local iconBoundBox = icon:boundingBox()

	desc1:setDimensions(CCSizeMake(0,0))
	desc2:setDimensions(CCSizeMake(0,0))

	local anchorpointY = 0.7
	if _G.kUseSmallResource then 
		anchorpointY = anchorpointY * 0.625
	end
	desc1:setAnchorPoint(ccp(1, anchorpointY))
	desc1:setPositionX(iconBoundBox:getMinX())
	desc1:setPositionY(iconBoundBox:getMidY())

	desc2:setAnchorPoint(ccp(0, anchorpointY))
	desc2:setPositionX(iconBoundBox:getMaxX())
	desc2:setPositionY(iconBoundBox:getMidY())

	desc1:setString(Localization:getInstance():getText("weeklyrace.winter.panel.desc6")) --"我的")
	-- desc2:setString(": 9999")

	function ui:refresh( ... )
		desc2:setString(": " .. tostring(SeasonWeeklyRaceManager:getInstance():getWeeklyScore()))
	end

	ui:setTouchEnabled(true)
	ui:addEventListener(DisplayEvents.kTouchTap,function( ... )
		_self:showNumberTip()
	end)

	ui:refresh()

	return ui
end

function WinterWeeklyPanel:showNumberTip()
	if not self.rankData then 
		return
	end
	local myRank = self.rankData:getMyRank()
	if myRank > 0 then 
		local surpassCount = self.rankData:getSurpassCount()
		if surpassCount > 0 then
			CommonTip:showTip(Localization:getInstance():getText("weeklyrace.winter.panel.desc10",{num=surpassCount}),"positive")	--"当前超越{num}位好友，下周可以来领奖励哟~"
		else
			if myRank ~= 1 then --我倒数第一
				CommonTip:showTip(Localization:getInstance():getText("weeklyrace.winter.panel.desc21"),"positive")	--"当前还没有超过好友哦，加油闯关吧！"
			else 	--没有好友上榜
				CommonTip:showTip(Localization:getInstance():getText("weeklyrace.winter.panel.desc20"),"positive")	--"喊好友一起来玩周赛吧，超越好友还有奖励拿哦！"
			end
		end
	else
		CommonTip:showTip(Localization:getInstance():getText("weeklyrace.winter.panel.desc9", {num = SeasonWeeklyRaceManager:getInstance():getRankMinScore()}),"negative")	--"本周收集{num}颗以上太阳宝石才能上榜哟~"
	end
end

function WinterWeeklyPanel:initDesc( ui )
	local _self = self

	local function leftTimeEqual(t1,t2)
		if not t1 or not t2 then 
			return false
		end

		return t1.leftDay == t2.leftDay 
			and t1.leftHour == t2.leftHour 
			and t1.leftMinute == t2.leftMinute
	end

	function ui:refresh( ... )
		ui:stopAllActions()

		ui:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(
			CCCallFunc:create(function( ... )
				local leftTime = SeasonWeeklyRaceManager:getInstance():getLeftTime()
				if ui.leftTime and ui.leftTime.leftDay ~= leftTime.leftDay then 
					local hasWeekChanged = (ui.leftTime.leftDay == 0)
					ui.leftTime = nil
					_self.refreshAll(hasWeekChanged)
					return
				end

				if not leftTimeEqual(leftTime,ui.leftTime) then
					ui:setString(Localization:getInstance():getText("weeklyrace.winter.panel.desc1",{
						num = leftTime.leftDay,
						num1 = leftTime.leftHour,
						num2 = leftTime.leftMinute
					}))
					ui.leftTime = leftTime
				end
			end),
			CCDelayTime:create(1)
		)))
	end

	ui:refresh()
	return ui
end

function WinterWeeklyPanel:popoutShowTransition()
  	self.hasPopout = true
 	self:checkLastWeekRewards()
 	self:pocessByDecision()
 	self:checkShowHelpTip()
end

function WinterWeeklyPanel:popout( ... )
  	PopoutQueue:sharedInstance():push(self)
  	self.allowBackKeyTap = true
  	self.hasPopout = true
end

function WinterWeeklyPanel:onLevelPassed(gameResult)
	if gameResult and gameResult.levelType == GameLevelType.kSummerWeekly then
		if not self.isDisposed then
			self:refreshAll()
		end
		SeasonWeeklyRaceManager:getInstance():getRankData(function()
			local scene = Director:sharedDirector():getRunningSceneLua()
			if not self.isDisposed and scene and scene:is(HomeScene) then
				if self.rankList and not self.rankList.isDisposed then
					self.rankList:refresh() 
				end
				if SeasonWeeklyRaceManager:getInstance():canShareChamp() then
					local panel = SeasonWeeklyRaceChampPanel:create()
					panel:popout()
					SeasonWeeklyRaceManager:getInstance():onShareChampSuccess()
				elseif SeasonWeeklyRaceManager:getInstance():canShareSurpass() then
					local surpassFriends = SeasonWeeklyRaceManager:getInstance():getSurpassFriends()
					local panel = SeasonWeeklyRacePassPanel:create(surpassFriends)
					panel:popout()
					SeasonWeeklyRaceManager:getInstance():onShareSurpassSuccess()
				end
			end
		end)
	end 
end

function WinterWeeklyPanel:dispose()
	if self.dataChangeListener then
		GlobalEventDispatcher:getInstance():removeEventListener(SummerWeeklyMatchEvents.kDataChangeEvent, self.dataChangeListener)
		self.dataChangeListener = nil
	end
	if self.passLevelListener then
		GamePlayEvents.removePassLevelEvent(self.passLevelListener)
		self.passLevelListener = nil
	end
    self.hasPopout = false
	BasePanel.dispose(self)
	for k,v in pairs(self.cellItems) do
		v:dispose()
	end
	ArmatureFactory:remove(kDragonBonesName, kTextureAtlasName)

	if HomeScene:sharedInstance().summerWeeklyButton and not HomeScene:sharedInstance().summerWeeklyButton.isDisposed then
		HomeScene:sharedInstance().summerWeeklyButton:update()
	end
end

function WinterWeeklyPanel:closePanel()
	HomeScene:sharedInstance():checkDataChange()
	if HomeScene:sharedInstance().coinButton and not HomeScene:sharedInstance().coinButton.isDisposed then
		HomeScene:sharedInstance().coinButton:updateView()
	end
	PopoutManager:sharedInstance():remove(self)
end

function WinterWeeklyPanel:onKeyBackClicked()
  	self.allowBackKeyTap = false
  	self:closePanel()
end

function WinterWeeklyPanel:checkShowHelpTip()
	if SeasonWeeklyRaceManager:getInstance():getIsShowHelpRecord() then
		CommonTip:showTip(Localization:getInstance():getText("weekly.race.share.feed.success.add.count", {num =
			SeasonWeeklyRaceManager:getInstance():getHelpNum()}), "positive")
		SeasonWeeklyRaceManager:getInstance():ShowedHelpTip()
	end
end

function WinterWeeklyPanel:pocessByDecision()
	local function _startLevel()
		if not self.isDisposed and self.mainButton then 
			self.mainButton:rma()
			self:startLevel()
		end
	end

	if self.weeklyDecisionType and (self.weeklyDecisionType == SeasonWeeklyDecisionType.kMainLevelTutorIn or 
		self.weeklyDecisionType == SeasonWeeklyDecisionType.kShareTutor or
		self.weeklyDecisionType == SeasonWeeklyDecisionType.kShowWithFreePanel) and
		not SeasonWeeklyRaceManager:getInstance():hasReward() then 

		local panel = SeasonWeeklyGetFreePlayPanel:create(self,SeasonWeeklyRaceManager:getInstance():getLevelId(),_startLevel)
		panel:popout(self.weeklyDecisionType)
	end
end