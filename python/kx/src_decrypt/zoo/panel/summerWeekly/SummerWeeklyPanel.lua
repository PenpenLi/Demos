require "zoo.panel.summerWeekly.SummerWeeklyMatchManager"
require "zoo/panel/component/common/BoxRewardTipPanel"
require "zoo.panel.summerWeekly.SummerWeeklyRaceRewardsPanel"
require "zoo.panel.summerWeekly.SummerWeeklyRaceRulePanel"
require "zoo.panel.summerWeekly.SummerWeeklyGetFreePlayPanel"
require "zoo.panel.summerWeekly.SummerWeeklyRaceSharePanel"
require "zoo.panel.summerWeekly.SummerWeeklyRaceChampPanel"
require "zoo.panel.summerWeekly.SummerWeeklyRacePassPanel"
require "zoo.panel.TwoChoicePanel"

SummerWeeklyPanel = class(BasePanel)
function SummerWeeklyPanel:create( ... )
  local panel = SummerWeeklyPanel.new()
  panel:loadRequiredResource("ui/panel_summer_weekly.json") 
  panel:init()
  return panel
end

function SummerWeeklyPanel:ctor( ... )
	self.cellItems = {}
end

function SummerWeeklyPanel:dispose( ... )
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

	if HomeScene:sharedInstance().summerWeeklyButton and not HomeScene:sharedInstance().summerWeeklyButton.isDisposed then
		HomeScene:sharedInstance().summerWeeklyButton:update()
	end
end

function SummerWeeklyPanel:onLevelPassed(gameResult)
	if gameResult and gameResult.levelType == GameLevelType.kSummerWeekly then
		if not self.isDisposed then
			self:refreshAll()
		end
		SummerWeeklyMatchManager:getInstance():getRankData(function()
			local scene = Director:sharedDirector():getRunningSceneLua()
			if not self.isDisposed and scene and scene:is(HomeScene) then
				if self.rankList and not self.rankList.isDisposed then
					self.rankList:refresh() 
				end
				if SummerWeeklyMatchManager:getInstance():canShareChamp() then
					local panel = SummerWeeklyRaceChampPanel:create()
					panel:popout()
					SummerWeeklyMatchManager:getInstance():onShareChampSuccess()
				elseif SummerWeeklyMatchManager:getInstance():canShareSurpass() then
					local surpassFriends = SummerWeeklyMatchManager:getInstance():getSurpassFriends()
					local panel = SummerWeeklyRacePassPanel:create(surpassFriends)
					panel:popout()
					SummerWeeklyMatchManager:getInstance():onShareSurpassSuccess()
				end
			end
		end)
	end 
end

function SummerWeeklyPanel:init( ... )
	self.ui = self:buildInterfaceGroup("panel")
	BasePanel.init(self, self.ui)
	local context = self

	local container = self.ui:getChildByName("container")
	local top = container:getChildByName("top")
	local bottom = container:getChildByName("bottom")

	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap, function() self:onKeyBackClicked() end)

	local descIcon = container:getChildByName("descIcon")
	descIcon:setTouchEnabled(true)
	descIcon:setButtonMode(true)
	descIcon:addEventListener(DisplayEvents.kTouchTap, function()
		DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_click_info'})
		local panel = SummerWeeklyRaceRulePanel:create()
		panel:popout()
	end)
	
	local desc = self:initDesc(container:getChildByName("desc"))


	local dayReward = self:initDayReward(top:getChildByName("reward1"))
	local weekReward = self:initWeekReward(top:getChildByName("reward2"))

	local button = self:initButton(
		top:getChildByName("button"),
		top:getChildByName("coinBuyButton")
	)

	local myNumber = self:initMyNumber(bottom:getChildByName("my"))
	local rankList = self:initRankList(
		bottom:getChildByName("listBg"),
		bottom:getChildByName("listTip")
	)
	self.rankList = rankList

	self.refreshAll = function( refreshRankList )
		if context.hasPopout then
			SummerWeeklyMatchManager:getInstance():getAndUpdateMatchData()
			desc:refresh()
			dayReward:refresh()
			weekReward:refresh()
			button:refresh()
			myNumber:refresh()
			if refreshRankList then 
				rankList:refresh()
			end
		end
	end

	self:initTopAni(
		top:getChildByName("npcTouch"),
		top:getChildByName("wm"),
		top:getChildByName("tip")
	)
	self:initBottomAni(
		bottom:getChildByName("npc"),
		bottom:getChildByName("npcEye"),
		bottom:getChildByName("tip")
	)

	local uiSize = self.ui:getGroupBounds().size
	local visibleSize = Director.sharedDirector():getVisibleSize()
	container:setScale(visibleSize.height/uiSize.height)

	self.dataChangeListener = function(evt)
		local refreshRankList = false
		if evt and evt.data then refreshRankList = evt.data.refreshRankList end
		if self.refreshAll and not self.isDisposed then self.refreshAll(refreshRankList) end
	end
	GlobalEventDispatcher:getInstance():addEventListener(SummerWeeklyMatchEvents.kDataChangeEvent, self.dataChangeListener)
	self.passLevelListener = function(evt)
		assert(evt, "evt cannot be nil")
		self:onLevelPassed(evt.data)
	end
	GamePlayEvents.addPassLevelEvent(self.passLevelListener)
end

function SummerWeeklyPanel:initDesc( ui )
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
				local leftTime = SummerWeeklyMatchManager:getInstance():getLeftTime()
				if ui.leftTime and ui.leftTime.leftDay ~= leftTime.leftDay then 
					local hasWeekChanged = (ui.leftTime.leftDay == 0)
					ui.leftTime = nil
					_self.refreshAll(hasWeekChanged)
					return
				end

				if not leftTimeEqual(leftTime,ui.leftTime) then
					ui:setString(Localization:getInstance():getText("weeklyrace.summer.panel.desc1",{
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

function SummerWeeklyPanel:checkLastWeekRewards()
	local function showWeekRewards()
		local weekRewards, rewardLevelId = SummerWeeklyMatchManager:getInstance():getLastWeekRewards()
		if weekRewards and #weekRewards > 0 then
			local panel = SummerWeeklyRaceRewardsPanel:create(weekRewards, rewardLevelId)
			panel:popout()
		end
	end
	-- 优先显示上周排行奖励
	local rankRewards, rankLevelId, rank, surpass = SummerWeeklyMatchManager:getInstance():getLastWeekRankRewards()
	if rankRewards and #rankRewards > 0 then
		local panel = SummerWeeklyRaceSharePanel:create(rankRewards, rankLevelId, rank, surpass)
		panel:popout(showWeekRewards)
	else
		showWeekRewards()
	end
end

function SummerWeeklyPanel:showPropsTip(bounds, itemId)

	local content = self:buildInterfaceGroup('summerWeeklyPanel/bagItemTipContent')--ResourceManager:sharedInstance():buildGroup('bagItemTipContent')
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


function SummerWeeklyPanel:setBubbleMode(bubble,enable)
	bubble:stopAllActions()
	bubble:setScale(1)

	if enable then

		local bubbleAnimations = CCArray:create()
		bubbleAnimations:addObject(CCDelayTime:create(20/24))
		for i=1,2 do
			bubbleAnimations:addObject(CCScaleTo:create(5/24, 1.13,1))
			bubbleAnimations:addObject(CCScaleTo:create(5/24,0.956,1.068))
			bubbleAnimations:addObject(CCScaleTo:create(5/24,1,1))
		end
		bubble:runAction(CCRepeatForever:create(CCSequence:create(bubbleAnimations)))
		
	end
end

function SummerWeeklyPanel:setArrowMode(arrow,enable)
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

function SummerWeeklyPanel:getBubbleExplodedAction( bubble,bubbleExploded )

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


function SummerWeeklyPanel:playRewarsAnim(bubble,bubbleExploded,rewards,pos,callback)

	local function playFlyReward( cb )
		if self.isDisposed then 
			return 
		end

		local c = 0
		for _,itemConfig in pairs(rewards) do
			local anim = nil
			local config = { number=itemConfig.num,updateButton=true }
			function config.finishCallback( ... )
				c = c + 1
				if c >= #rewards then 
					cb()
				end
			end

			if itemConfig.itemId == 14 then 
				anim = HomeSceneFlyToAnimation:sharedInstance():goldFlyToAnimation(config)
			elseif itemConfig.itemId == 2 then 
				anim = HomeSceneFlyToAnimation:sharedInstance():coinStackAnimation(config)
			else
				config.propId = itemConfig.itemId
				if ItemType:isTimeProp(config.propId) then
					config.propId = ItemType:getRealIdByTimePropId(config.propId)
				end
				anim = HomeSceneFlyToAnimation:sharedInstance():jumpToBagAnimation(config)
			end
			
			local sprites = (itemConfig.itemId == 2 and {anim.sprites}) or anim.sprites
			for k, v2 in ipairs(sprites) do
				if itemConfig.itemId ~= 14 and itemConfig.itemId ~= 2 then
					v2:setAnchorPoint(ccp(0.5,0.5))
				end
				v2:setPosition(pos)

				Director.sharedDirector():getRunningScene():addChild(v2)
			end

			HomeScene:sharedInstance():checkDataChange()
			local function delayFunc( ... )
				if anim and not anim.isDisposed then
					anim:play()
				end
			end

			setTimeOut(delayFunc, 0.3)
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


function SummerWeeklyPanel:initDayReward( ui )
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

	desc1:setString(Localization:getInstance():getText("weeklyrace.summer.panel.desc17"))--"当天最高"
	-- 今日奖励已领完
	desc3:setString(Localization:getInstance():getText("weeklyrace.summer.panel.desc7"))

	local function setNumber( num )
		desc2:setString(Localization:getInstance():getText("weeklyrace.summer.panel.desc19",{num=num}))
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
		local reward = SummerWeeklyMatchManager:getInstance():getNextDailyReward()
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

				SummerWeeklyMatchManager:getInstance():receiveDailyReward( reward.id, function( ... )
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
				end, function( ... )
					if _self.isDisposed then 
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

function SummerWeeklyPanel:initWeekReward( ui )
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

	desc1:setString(Localization:getInstance():getText("weeklyrace.summer.panel.desc18"))--"累计获得"
	-- desc2:setString("2000个")


	local chestLayer = Layer:create()
	for i=1,5 do
		local chest = self:buildInterfaceGroup("summerWeeklyChest/chest")

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

		desc2:setString(Localization:getInstance():getText("weeklyrace.summer.panel.desc19",{num=rewards[chestIndex].condition}))
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
		rewards = SummerWeeklyMatchManager:getInstance():getNextWeeklyReward()

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
				SummerWeeklyMatchManager:getInstance():receiveWeeklyReward(v.id,function( ... )
					if _self.isDisposed then 
						return
					end
					chestLayer:setVisible(false)
					_self:setArrowMode(arrow,false)
					_self:playRewarsAnim(bubble,bubbleExploaded,r,pos,function( ... )
						if not _self.isDisposed then
							_self.refreshAll()
						end
					end)
				end, function( ... )
					if _self.isDisposed then 
						return
					end
					-- tip
					_self.refreshAll()
				end )

				pao:removeAllEventListeners()
			elseif v.hasReceived then 
				CommonTip:showTip(Localization:getInstance():getText("weeklyrace.summer.panel.tip9"), "positive")
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
				local text = Localization:getInstance():getText("weeklyrace.summer.panel.tip1",{num=v.needMore})
				-- local wmIcon = Sprite:createWithSpriteFrameName("summerWeeklyPanel/watermelon0000")
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

function SummerWeeklyPanel:initButton( ui,coinBuyUi )
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

	function button:refresh( ... )
		button:removeAllEventListeners()
		coinBuyButton:removeAllEventListeners()
		button:setNumberVisible(false)
		button:setVisible(true)
		coinBuyButton:setVisible(false)
		button:setColorMode(kGroupButtonColorMode.green)
		button:setShadowVisible(false)

		if SummerWeeklyMatchManager:getInstance():getLeftPlay() > 0 then 
			button:setShadowVisible(true)
			button:setNumberVisible(true)
			button:setNumber(SummerWeeklyMatchManager:getInstance():getLeftPlay())
			button:setString(Localization:getInstance():getText("weekly.race.panel.start.btn"))--"去闯关"
			button:addEventListener(DisplayEvents.kTouchTap,function( ... )
				local function onCancelPlay()
				end
				local function onConfirmPlay()
					_self:startLevel()
					button:rma()
				end
				if SummerWeeklyMatchManager:getInstance():isNeedShowTimeWarnPanel() then
					_self:showTimeNotEnoughWarningPanel(onConfirmPlay, onCancelPlay)
				else
					onConfirmPlay()
				end
			end)
		elseif SummerWeeklyMatchManager:getInstance():canGetFreePlay() then
			button:setString(Localization:getInstance():getText("weekly.race.panel.rabbit.button5"))--"获得次数"
			button:addEventListener(DisplayEvents.kTouchTap,function( ... )
				local panel = SummerWeeklyGetFreePlayPanel:create(_self,
					SummerWeeklyMatchManager:getInstance():getLevelId(),
					function()
						_self:startLevel()
						button:rma()
					end
				)
				panel:popout()
			end)
		elseif SummerWeeklyMatchManager:getInstance():getLeftBuyCount() > 0 then
			local function onSuccess( ... ) 
				_self:startLevel()
				button:rma()
			end
			local function onFail( ... ) button:refresh() end
			local function onCancel( ... ) button:refresh() end
			local function onFinish( ... ) button:refresh() end
			local ignoreSecondConfirm = false

			local function buyPlayCard( ... )
				local function onCancelBuy()
				end
				local function onConfirmBuy()
					SummerWeeklyMatchManager:getInstance():buyPlayCard( onSuccess, onFail, onCancel, onFinish, ignoreSecondConfirm)
					button:rma()
				end
				if SummerWeeklyMatchManager:getInstance():isNeedShowTimeWarnPanel() then
					_self:showTimeNotEnoughWarningPanel(onConfirmBuy, onCancelBuy)
				else
					onConfirmBuy()
				end
			end

			local buyGoodId = SummerWeeklyMatchManager:getInstance():getBuyGoodId()
	        if __ANDROID and not PaymentManager.getInstance():checkCanWindMillPay(buyGoodId) then

	            local tmpLogic = IngamePaymentLogic:create(buyGoodId)
	            local decision, paymentType = tmpLogic:getPaymentDecision()
	            -- local operator = AndroidPayment.getInstance():getOperator()

	            if decision == IngamePaymentDecisionType.kPayWithType and 
	                -- operator == TelecomOperators.CHINA_MOBILE then
	                (paymentType == Payments.CHINA_MOBILE  or paymentType == Payments.DUOKU) then
	                ignoreSecondConfirm = true
	            end

				local mark = Localization:getInstance():getText("buy.gold.panel.money.mark")
				local text = Localization:getInstance():getText("weekly.race.panel.rabbit.button2")
				local rmb = SummerWeeklyMatchManager:getInstance():getBuyRmb()
				button:setString(string.format("%s%0.2f %s", mark, rmb, text))
				button:addEventListener(DisplayEvents.kTouchTap,function( ... )
					buyPlayCard()
				end)
			else
				button:setVisible(false)
				coinBuyButton:setVisible(true)
				coinBuyButton:setNumber(SummerWeeklyMatchManager:getInstance():getBuyQCash())
				coinBuyButton:addEventListener(DisplayEvents.kTouchTap,function( ... )
					buyPlayCard()
				end)
			end
		else
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

function SummerWeeklyPanel:showTimeNotEnoughWarningPanel(onConfirm, onCancel)
	local descText = Localization:getInstance():getText("weekly.race.summer.start.tip1")
	local panel = TwoChoicePanel:create(descText, "取消", "继续", "不再提醒", true)
	local function onCancelBtnTapped(dontShowAgain)
		SummerWeeklyMatchManager:getInstance():setTimeWarningDisabled(dontShowAgain)
		if onCancel then onCancel() end
	end
	local function onConfirmBtnTapped(dontShowAgain)
		SummerWeeklyMatchManager:getInstance():setTimeWarningDisabled(dontShowAgain)
		if onConfirm then onConfirm() end
	end
	panel:setButton1TappedCallback(onCancelBtnTapped)
	panel:setButton2TappedCallback(onConfirmBtnTapped)
	panel:setCloseButtonTappedCallback(onCancelBtnTapped)
	panel:popout()
end

function SummerWeeklyPanel:startLevel()
	local logic = StartLevelLogic:create(self, SummerWeeklyMatchManager:getInstance().levelId, GameLevelType.kSummerWeekly, {}, true)
	logic:start(true)
end

function SummerWeeklyPanel:onStartLevelLogicSuccess()
	SummerWeeklyMatchManager:getInstance():onStartLevel()
end

function SummerWeeklyPanel:onStartLevelLogicFailed(err)
	local onStartLevelFailedKey     = "error.tip."..err
    local onStartLevelFailedValue   = Localization:getInstance():getText(onStartLevelFailedKey, {})
    CommonTip:showTip(onStartLevelFailedValue, "negative")
end

function SummerWeeklyPanel:onWillEnterPlayScene()
	self.refreshAll(false)
end

function SummerWeeklyPanel:onDidEnterPlayScene(gamePlayScene)
	if gamePlayScene and gamePlayScene.gameBoardLogic then
		local summerWeeklyData = {}
		summerWeeklyData.dropPropsPercent = SummerWeeklyMatchManager:getInstance():getSpecialPercent()
		summerWeeklyData.orignalDropPropsPercent = summerWeeklyData.dropPropsPercent
		gamePlayScene.gameBoardLogic.summerWeeklyData = summerWeeklyData
	end
end

function SummerWeeklyPanel:initMyNumber( ui )
	local _self = self

	local desc1 = ui:getChildByName("desc1")
	local icon = ui:getChildByName("icon")
	local desc2 = ui:getChildByName("desc2")

	local iconBoundBox = icon:boundingBox()

	desc1:setDimensions(CCSizeMake(0,0))
	desc2:setDimensions(CCSizeMake(0,0))

	desc1:setAnchorPoint(ccp(1,0.5))
	desc1:setPositionX(iconBoundBox:getMinX())
	desc1:setPositionY(iconBoundBox:getMidY())

	desc2:setAnchorPoint(ccp(0,0.5))
	desc2:setPositionX(iconBoundBox:getMaxX())
	desc2:setPositionY(iconBoundBox:getMidY())

	desc1:setString(Localization:getInstance():getText("weeklyrace.summer.panel.desc6")) --"我的")
	-- desc2:setString(": 9999")

	function ui:refresh( ... )
		desc2:setString(": " .. tostring(SummerWeeklyMatchManager:getInstance():getWeeklyScore()))
	end

	ui:setTouchEnabled(true)
	ui:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if not _self.rankData then 
			return
		end
		local myRank = _self.rankData:getMyRank()
		if myRank > 0 then 
			local surpassCount = _self.rankData:getSurpassCount()
			if surpassCount > 0 then
				CommonTip:showTip(Localization:getInstance():getText("weeklyrace.summer.panel.desc10",{num=surpassCount}),"positive")
			else
				CommonTip:showTip(Localization:getInstance():getText("weeklyrace.summer.panel.desc20"),"positive")
			end
		else
			CommonTip:showTip(Localization:getInstance():getText("weeklyrace.summer.panel.desc9", {num = SummerWeeklyMatchManager:getInstance():getRankMinScore()}),"negative")
		end
	end)

	ui:refresh()

	return ui
end

function SummerWeeklyPanel:initTopAni( touchUi, wmUi,tipUi )

	FrameLoader:loadArmature("skeleton/summer_weekly_animation")
	local head = ArmatureNode:create("summerWeeklyPanelAni/sdgfrt")

	head:setScale(0.8)
	head:setRotation(12)
	head:setPositionX(wmUi:getPositionX() - 16)
	head:setPositionY(wmUi:getPositionY() + 202)
	wmUi:getParent():addChildAt(head,wmUi:getZOrder())

	if __use_small_res then
		CCTextureCache:sharedTextureCache():removeTextureForKey(
			CCFileUtils:sharedFileUtils():fullPathForFilename("skeleton/summer_weekly_animation@2x/texture.png")
		)
	else
		CCTextureCache:sharedTextureCache():removeTextureForKey(
			CCFileUtils:sharedFileUtils():fullPathForFilename("skeleton/summer_weekly_animation/texture.png")
		)
	end


	tipUi:setVisible(false)
	function tipUi:play( ... )
		self:stopAllActions()
		self:setScaleX(0.118)
		self:setScaleY(0.167)
		self:setRotation(-15)
		self:setVisible(true)

		local img = self:getChildByName("img")
		img:setOpacity(255)

		local arr = CCArray:create()
		arr:addObject(CCSpawn:createWithTwoActions(
			CCScaleTo:create(5/24,1.044,1.0),
			CCRotateTo:create(5/24,0)
		))
		arr:addObject(CCScaleTo:create(1/24,1.0,1.0))
		arr:addObject(CCDelayTime:create(54/24))
		arr:addObject(CCTargetedAction:create(
			img.refCocosObj,
			CCFadeOut:create(5/24)
		))
		arr:addObject(CCCallFunc:create(function( ... )
			self:setVisible(false)
		end))

		self:runAction(CCSequence:create(arr))
	end 


	local arr = CCArray:create()
	for _,v in pairs({30,15}) do
		for i=1,4 do
			arr:addObject(CCRotateBy:create(5/24,-15))
			arr:addObject(CCRotateBy:create(5/24,15))
		end
		arr:addObject(CCDelayTime:create(v/24 * 2.5))
	end
	arr:addObject(CCCallFunc:create(function( ... )
		head:playByIndex(0)
	end))
	arr:addObject(CCDelayTime:create(30/24))

	wmUi:runAction(CCRepeatForever:create(CCSequence:create(arr)))

	touchUi:setChildrenVisible(false,false)
	touchUi:setTouchEnabled(true)
	touchUi:addEventListener(DisplayEvents.kTouchTap,function( ... )
		tipUi:play()
	end)
end

function SummerWeeklyPanel:initBottomAni( npcUi,eyeUi,tipUi )

	tipUi:setVisible(false)
	function tipUi:play( ... )
		self:stopAllActions()
		self:setScaleX(0.128)
		self:setScaleY(0.177)
		self:setVisible(true)

		local img = self:getChildByName("img")
		img:setOpacity(255)

		local arr = CCArray:create()
		arr:addObject(CCScaleTo:create(5/24,1.132,1.0))
		arr:addObject(CCScaleTo:create(1/24,1.045,1.045))
		arr:addObject(CCDelayTime:create(73/24))
		arr:addObject(CCTargetedAction:create(
			img.refCocosObj,
			CCFadeOut:create(12/24)
		))
		arr:addObject(CCCallFunc:create(function( ... )
			self:setVisible(false)
		end))

		self:runAction(CCSequence:create(arr))
	end

	for i=1,4 do
		eyeUi["eye" .. tostring(i)] = eyeUi:getChildByName(tostring(i))
	end
	local function showEyeIndex( index )
		return function( ... )
			for i=1,4 do
				eyeUi["eye" .. tostring(i)]:setVisible(i == index)
			end
		end
	end
	local showIndexs = {
		{1,1},
		{2,1},
		{3,1},
		{4,3},
		{3,1},
		{2,1},
		{1,2},
		{2,1},
		{3,1},
		{4,2},
		{3,1},
		{2,1},
		{1,45}
	}

	local arr = CCArray:create()
	for _,v in pairs(showIndexs) do
		arr:addObject(CCCallFunc:create(showEyeIndex(v[1])))
		if v[1] == 1 then
			arr:addObject(CCDelayTime:create(v[2]/24 * 2.5))
		else
			arr:addObject(CCDelayTime:create(v[2]/24))
		end

	end
	eyeUi:runAction(CCRepeatForever:create(CCSequence:create(arr)))

	npcUi:setTouchEnabled(true)
	npcUi:addEventListener(DisplayEvents.kTouchTap,function( ... )
		tipUi:play()
	end)
end

function SummerWeeklyPanel:initRankList( listBgUi,tip )
	local _self = self

	tip:setString(Localization:getInstance():getText("rank.list.no.network"))

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
			SpriteUtil:addSpriteFramesWithFile("ui/panel_summer_weekly.plist", "ui/panel_summer_weekly.png")	
			cellItem = _self:buildInterfaceGroup("summerWeeklyPanel/rank/rank")

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
			cellItem:getChildByName("num2"):setString(Localization:getInstance():getText("weeklyrace.summer.panel.desc16"))
		else
			-- if tostring(UserManager:getInstance().uid) == tostring(uid) then
			-- 	local num = SummerWeeklyMatchManager:getInstance():getSurpassGoldReward()
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
	end


	local tableView = TableView:create(tableViewRender,tableViewWidth,tableViewHeight)
	tableView:ignoreAnchorPointForPosition(false)
	tableView:setAnchorPoint(ccp(0.5,0.5))
	tableView:setPositionX(boundingBox:getMidX())
	tableView:setPositionY(boundingBox:getMidY())

	listBgUi:getParent():addChild(tableView)

	function tableView:refresh( ... )
		tip:setVisible(false)
		SummerWeeklyMatchManager:getInstance():getRankData(function( ... )
			if _self.isDisposed then 
				return
			end
			tip:setVisible(false)
			_self.rankData = SummerWeeklyMatchManager:getInstance().rankData
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

function SummerWeeklyPanel:popoutShowTransition()
  	self.hasPopout = true
 	self:checkLastWeekRewards()
end

function SummerWeeklyPanel:popout( ... )
  	PopoutQueue:sharedInstance():push(self)
  	-- PopoutManager:sharedInstance():add(self,true,false)
end

function SummerWeeklyPanel:onKeyBackClicked( ... )
  	PopoutManager:sharedInstance():remove(self)
end
