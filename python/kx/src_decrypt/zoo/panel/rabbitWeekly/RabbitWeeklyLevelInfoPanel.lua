require "zoo.scenes.GamePlaySceneUI"
require "zoo.panelBusLogic.StartLevelLogic"
require "zoo.panel.component.common.BubbleCloseBtn"
require "zoo.panel.component.common.HorizontalTileLayout"
require "zoo.panel.component.common.LayoutItem"
require "zoo.panel.rabbitWeekly.RabbitRulePanel"
require "zoo.panel.rabbitWeekly.RabbitWeeklyGetFreePlayPanel"
require "zoo.panel.rabbitWeekly.RabbitStartGameTimeWarningPanel"
require "zoo.panelBusLogic.IapBuyPropLogic"

-- short hand function
local function _text(key, replace)
    return Localization:getInstance():getText(key, replace)
end

local function _mgr()
    return RabbitWeeklyManager:sharedInstance()
end

-----------------------------------------------------
-- RabbitDailyRewardBox
-----------------------------------------------------

RabbitDailyRewardBoxState = {
	CLOSED 		= 0,
	CAN_OPEN 	= 1,
	OPENED 		= 2,
}

RabbitDailyRewardBox = class()

function RabbitDailyRewardBox:init( topPanel, parent, index )
	self.parent = parent
	self.index = index
	self.topPanel = topPanel
	self.openedState = parent:getChildByName("rewardBoxOpened"..index)
	self.closedState = parent:getChildByName("rewardBoxClosed"..index)
	self.arrow 		 = parent:getChildByName("arrow"..index)
	self.label 		 = parent:getChildByName("boxLabel"..index)
	self.closedState:setAnchorPoint(ccp(0.5,0.5))
end

function RabbitDailyRewardBox:setDatas( levelId, config, state )
	self.needCount = config.needCount
	self.rewards = config.items
	self.levelId = levelId
	if self.label then self.label:setString(tostring(self.needCount)) end
	self:updateBoxState(state)
end

function RabbitDailyRewardBox.create(topPanel, parent, index)
	assert(type(index) == "number")
	local box = RabbitDailyRewardBox.new()
	box:init(topPanel, parent, index)
	return box
end

function RabbitDailyRewardBox:showRewardTips()
	local tipPanel = BoxRewardTipPanel:create({rewards=self.rewards})
	local myRabbits = _mgr().dailyRabbits
	tipPanel:setTipString(_text("weekly.race.panel.rabbit.treasure.tip", {num=self.needCount - myRabbits}))

	local tappedBoxPos = self.closedState:getPosition()
	local tappedBoxPosInWorldPos 	= self.closedState:getParent():convertToWorldSpace(ccp(tappedBoxPos.x, tappedBoxPos.y))

	local tappedBoxSize		= self.closedState:getGroupBounds().size
	tappedBoxPosInWorldPos.x 	= tappedBoxPosInWorldPos.x + tappedBoxSize.width / 2
	tappedBoxPosInWorldPos.y	= tappedBoxPosInWorldPos.y - tappedBoxSize.height / 2
	self.topPanel:addChild(tipPanel)

	tipPanel:setArrowPointPositionInWorldSpace(tappedBoxSize.width/2, tappedBoxPosInWorldPos.x, tappedBoxPosInWorldPos.y)
end

function RabbitDailyRewardBox:setVisible(visible)
	self.visible = visible
	if not visible then
		self.closedState:rma()
		self.closedState:stopAllActions()
		self.arrow:stopAllActions()
	end
end

function RabbitDailyRewardBox:updateBoxState(state)
	if not self.parent or self.parent.isDisposed then return end

	if self.state == state then return end
	self.state = state

	self.closedState:rma()
	self.closedState:stopAllActions()
	self.arrow:stopAllActions()

	if self.state == RabbitDailyRewardBoxState.CLOSED then
		self.openedState:setVisible(false)
		self.closedState:setVisible(true)
		local function onNodeTouch(event)
			self:showRewardTips()
		end
		self.arrow:setVisible(false)
		self.closedState:setTouchEnabled(true)
		self.closedState:ad(DisplayEvents.kTouchTap, onNodeTouch)
	elseif self.state == RabbitDailyRewardBoxState.CAN_OPEN then
		self.openedState:setVisible(false)
		self.closedState:setVisible(true)
		local function onNodeTouch(event)
			self:onReceiveBtnTapped()
		end
		self.closedState:setTouchEnabled(true)
		self.closedState:ad(DisplayEvents.kTouchTap, onNodeTouch)
		-- anim
		local originSize = self.closedState:getGroupBounds().size
		local anim = EnlargeRestore:create(self.closedState, originSize, 1.125, 1.3, 1.3)
		local delay = CCDelayTime:create(0.5)
		local action = CCRepeatForever:create(CCSequence:createWithTwoActions(anim, delay))
		-- action:setTag(13000+self.index)
		self.closedState:runAction(action)

		self.arrow:setVisible(true)
		local arrowAction = CCSequence:createWithTwoActions(
			CCMoveBy:create(10/24,ccp(0,20)),
			CCMoveBy:create(10/24,ccp(0,-20))
		)
		self.arrow:runAction(CCRepeatForever:create(arrowAction))
	elseif self.state == RabbitDailyRewardBoxState.OPENED then
		self.arrow:setVisible(false)
		self.openedState:setVisible(true)
		self.closedState:setVisible(false)
	end
end

function RabbitDailyRewardBox:onReceiveBtnTapped()
	if not RequireNetworkAlert:popout() then
        -- CommonTip:showTip(_text('weekly.race.tip.no.network'), 'negative')
        return 
    end

	local function successCallback(data)
		self:updateBoxState(RabbitDailyRewardBoxState.OPENED)
		local rewardIds = {}
	    local rewardAmounts = {}
	    for k, v in pairs(self.rewards) do 
	        table.insert(rewardIds, v.itemId)
	        table.insert(rewardAmounts, v.num)
	    end
	    local anims = HomeScene:sharedInstance():createFlyingRewardAnim(rewardIds, rewardAmounts)
	    local closedBoxPos = self.closedState:getPosition()
		local closedBoxPosInWorldPos 	= self.closedState:getParent():convertToWorldSpace(ccp(closedBoxPos.x, closedBoxPos.y))
	    local index = 0
	    for k, v in pairs(anims) do 
	        v:setPosition(ccp(closedBoxPosInWorldPos.x + 60 * index, closedBoxPosInWorldPos.y))
	        v:playFlyToAnim()
	        index = index + 1
	    end
	    HomeScene:sharedInstance():checkDataChange()
	    HomeScene:sharedInstance().coinButton:updateView()
	end
	local function failCallback()
		-- CommonTip:showTip("failed")
	end
	_mgr():receiveDailyRewardBox(self.levelId, self.index, successCallback, failCallback)
end

-----------------------------------------------------
-- RabbitWeeklyReward
-----------------------------------------------------

RabbitWeeklyReward = class()

function RabbitWeeklyReward:init(itemUi)
	self.desc = itemUi:getChildByName("desc")
    self.noRewardLabel = itemUi:getChildByName("noRewardLabel")
	self.items = itemUi:getChildByName("items")
end

function RabbitWeeklyReward:update( title, rewards )
    self.desc:setString(title)
    self.rewards = rewards
	
	local rewardCount = #rewards
	if not rewards or rewardCount<1 then
		self.noRewardLabel:setString(_text("weekly.race.panel.rabbit.no.reward"))
		self.noRewardLabel:setVisible(true)
		self.items:setVisible(false)
	else
		self.noRewardLabel:setVisible(false)
		self.items:setVisible(true)
		
		local maxCount = 4
		local offsetX = 0
		if rewardCount < maxCount then
			local maxItemX = self.items:getChildByName("icon"..maxCount):getPositionX()
			local existItemX = self.items:getChildByName("icon"..rewardCount):getPositionX()
			offsetX = (maxItemX - existItemX) / 2
		end

		local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
		for index=1,maxCount do
			local reward = rewards[index]
			local icon = self.items:getChildByName("icon"..index)
			local num = self.items:getChildByName("num"..index)
			icon:setVisible(false)
			if reward then
				local ui = iconBuilder:buildGroup('Prop_'..reward.itemId)
            	ui:setScale(0.6)
            	ui:setPositionX(icon:getPositionX() + offsetX)
            	ui:setPositionY(icon:getPositionY())
            	self.items:addChildAt(ui, icon:getZOrder())
            	num:setString("x"..reward.num)
            	num:setPositionX(ui:getPositionX() - 20)

            	reward.pos = ui:getParent():convertToWorldSpace(ui:getPosition())
			else
				num:setVisible(false)
			end
		end
	end
end

function RabbitWeeklyReward:playRewardAnim()
	if not self.rewards or #self.rewards == 0 then
		return
	end

    local rewardIds = {}
    local rewardAmounts = {}
    for k, v in pairs(self.rewards) do 
        table.insert(rewardIds, v.itemId)
        table.insert(rewardAmounts, v.num)
    end
    local anims = HomeScene:sharedInstance():createFlyingRewardAnim(rewardIds, rewardAmounts)
    for k, v in pairs(anims) do 
        local pos = self.rewards[k].pos
        v:setPosition(pos)
        v:playFlyToAnim()
    end
    HomeScene:sharedInstance():checkDataChange()
    HomeScene:sharedInstance().coinButton:updateView()
end

function RabbitWeeklyReward.create(itemUi)
	local reward = RabbitWeeklyReward.new()
	reward:init(itemUi)
	return reward
end

-----------------------------------------------------
-- RabbitWeeklyLevelInfoPanel
-----------------------------------------------------

RabbitWeeklyLevelInfoPanel = class(BasePanel)

function RabbitWeeklyLevelInfoPanel:create(parentPanel, levelId)
    local newPanel = RabbitWeeklyLevelInfoPanel.new()
    newPanel:init(parentPanel, levelId)
    return newPanel
end

function RabbitWeeklyLevelInfoPanel:init(parentPanel, levelId, ...)
    self.parentPanel = parentPanel
    self.TAPPED_STATE_START_BTN_TAPPED  = 1
    self.TAPPED_STATE_CLOSE_BTN_TAPPED  = 2
    self.TAPPED_STATE_NONE          = 3
    self.TAPPED_STATE_BUY_BTN_TAPPED  = 4
    self.tappedState            = self.TAPPED_STATE_NONE

    self:loadRequiredResource(PanelConfigFiles.panel_rabbit_weekly_v2)
    local ui = self:buildInterfaceGroup('startGamePanel/rabbitWeeklyV2LevelInfoPanel')
    -- local ui = ResourceManager:sharedInstance():buildGroupWithCustomProperty("startGamePanel/rabbitWeeklyV2LevelInfoPanel")
    BasePanel.init(self, ui)
    self.levelId = levelId

    local panelTitlePlaceholder = ui:getChildByName('levelLabelPlaceholder')
    local panelTitlePlaceholderPosY = panelTitlePlaceholder:getPositionY()
    self.closeBtn = BubbleCloseBtn:create(ui:getChildByName('bg'):getChildByName('closeBtn'))
    self.closeBtn.ui:ad(DisplayEvents.kTouchTap, function () self:onCloseBtnTapped() end)

    self.title                      = ui:getChildByName('title')
    self.state1                     = ui:getChildByName('state1')
    self.state2                     = ui:getChildByName('state2')

    self.myRabbitsLabel = ui:getChildByName("myRabbitsLabel")
    self.myRabbitsLabel:getChildByName("label"):setString(_text("weekly.race.panel.rabbit.tip1"))

    local rabbitCount = _mgr():getDailyRabbitsCount() or 0
    self.myRabbitsLabel:getChildByName("number"):setString(_text("weekly.race.panel.rabbit.tip2", {num=rabbitCount}))

    self.rule = ui:getChildByName("rule")
    self.rule:setTouchEnabled(true)
    self.rule:getChildByName("label"):setString(_text("weekly.race.panel.rabbit.rule.detail"))
    local function onRuleBtnTapped( ... )
    	self:onRuleTapped()
    end
    self.rule:ad(DisplayEvents.kTouchTap, onRuleBtnTapped)

    self.startBtn            = GroupButtonBase:create(ui:getChildByName('startBtn'))
    self.startBtn.redDot     = self.startBtn.groupNode:getChildByName('redDot')
    self.startBtn.num        = self.startBtn.groupNode:getChildByName('num')

    local goods = MetaManager:getInstance():getGoodMeta(RabbitWeeklyManager.playCardGoodsId)
	if __ANDROID then -- ANDROID
		self.price = goods.rmb / 100
	else -- else, on IOS and PC we use gold!
		self.price = goods.qCash
	end

    self.coinBuyBtn = ButtonIconNumberBase:create(ui:getChildByName('coinBuyBtn'))
    self.coinBuyBtn:setVisible(false)
    self.coinBuyBtn:setColorMode(kGroupButtonColorMode.blue)
	self.coinBuyBtn:setIconByFrameName('ui_images/ui_image_coin_icon_small0000')
	self.coinBuyBtn:setNumber(self.price)
	self.coinBuyBtn:setString(_text("weekly.race.panel.rabbit.button2"))

	local data = IapBuyPropLogic:rabbitWeeklyPlayCard()
	local meta = MetaManager:getInstance():getGoodMeta(data.goodsId)
	local rmbBuyBtnRes = ui:getChildByName("rmbBuyBtn")
	self.rmbBuyBtn = GroupButtonBase:create(rmbBuyBtnRes)
	self.rmbBuyBtn:setVisible(false)
	self.rmbBuyBtn:setString(Localization:getInstance():getText("buy.gold.panel.money.mark")..
		tostring(data.price)..Localization:getInstance():getText("buy.prop.panel.btn.buy.txt"))
	local discount = rmbBuyBtnRes:getChildByName("discount")
	local disNum = discount:getChildByName("num")
	local disText = discount:getChildByName("text")
	disNum:setString(math.ceil(meta.discountRmb / meta.rmb * 10))
	disText:setString(Localization:getInstance():getText("buy.gold.panel.discount"))
	local scaleBase = discount:getScale()
	local actArray = CCArray:create()
	actArray:addObject(CCDelayTime:create(5))
	actArray:addObject(CCScaleTo:create(0.1, scaleBase * 0.95))
	actArray:addObject(CCScaleTo:create(0.1, scaleBase * 1.1))
	actArray:addObject(CCScaleTo:create(0.2, scaleBase * 1))
	discount:runAction(CCRepeatForever:create(CCSequence:create(actArray)))

	self.coinBuyBtnPh1 = ui:getChildByName("coinBuyBtnPh1")
	self.coinBuyBtnPh1:setVisible(false)
	self.coinBuyBtnPh2 = ui:getChildByName("coinBuyBtnPh2")
	self.coinBuyBtnPh2:setVisible(false)

    self:updatePanel()
end

function RabbitWeeklyLevelInfoPanel:onRuleTapped()
    local title = _text('weekly.race.panel.rabbit.rule.title')
    local stringConfig = {}
    local indexs = {1, 3, 6, 9, 12, 17}
    for i=1, 6 do 
        local config = {
            index = indexs[i],
            text = _text('weekly.race.panel.rabbit.rule.content'..i)
        }
        if i == 4 then
        	local rabbitNum = _mgr().exchangeConfig.rankMinNum
            config.text = _text('weekly.race.panel.rabbit.rule.content4', {num = rabbitNum})
        elseif i == 5 then
        	local genRewardCfg = _mgr().gemRewardConfig
    		local rabbitNum = genRewardCfg.gems1.."、"..genRewardCfg.gems2.."、"..genRewardCfg.gems3.."、"
    			..genRewardCfg.gems4.."、"..genRewardCfg.gems5
            config.text = _text('weekly.race.panel.rabbit.rule.content5', {num = rabbitNum})
        end
        table.insert(stringConfig, config)
    end
    self.parentPanel:setRankListPanelTouchDisable()
    local panel = RabbitRulePanel:create()
    panel:setStrings(stringConfig)
    panel:setTitle(title)
    panel:popout(function () self.parentPanel:setRankListPanelTouchEnable() end)
    DcUtil:clickRabbitInfo()
end

function RabbitWeeklyLevelInfoPanel:updatePlayState(visible)
	if not visible then
		self.state1:setVisible(false)

		if self.state1.boxes then
			for _,v in pairs(self.state1.boxes) do
				v:setVisible(false)
			end
		end
		return
	end

	self.state1:setVisible(true)

    self.dailyRewardBoxes = _mgr().exchangeConfig.dailyRewardBoxes

	local myRabbits = _mgr().dailyRabbits
	local receivedBoxs = _mgr().dailyRewards
	self.state1.rewardBoxs = self.state1:getChildByName("rewardBoxs")
	if not self.state1.rewardBoxs.data then
		local boxes = {}
		for i = 1,4 do
			local box = RabbitDailyRewardBox.create(self, self.state1.rewardBoxs, i)
			local boxCfg = self.dailyRewardBoxes[i]
			local state = RabbitDailyRewardBoxState.CLOSED
			if receivedBoxs and table.includes(receivedBoxs, i-1) then -- 后端记录的index是从0开始的
				state = RabbitDailyRewardBoxState.OPENED
			elseif myRabbits >= boxCfg.needCount then
				state = RabbitDailyRewardBoxState.CAN_OPEN
			end
			box:setDatas(self.levelId, boxCfg, state)
			table.insert(boxes, box)
		end
		self.state1.boxes = boxes
	end

	self.state1:getChildByName("tips"):setString(_text("weekly.race.panel.rabbit.bottom.text1"))

	self.startBtn:rma()
	self.coinBuyBtn:rma()
	self.rmbBuyBtn:rma()
	self.coinBuyBtn:setVisible(false)
	self.rmbBuyBtn:setVisible(false)
	self.startBtn:setVisible(true)
	self.startBtn:setColorMode(kGroupButtonColorMode.green)
	self.startBtn.redDot:setVisible(false)
	self.startBtn.num:setVisible(false)
	
	if not self.timeValid then
		self.startBtn:setEnabled(false)
		self.startBtn:setString(_text("weekly.race.panel.rabbit.button1"))
		return
	end

    local leftFreePlay = _mgr():getFreePlayLeft()
	if leftFreePlay > 0 then
		self.startBtn:setString(_text("weekly.race.panel.start.btn"))
	    self.startBtn.redDot:setVisible(true)
		self.startBtn.num:setVisible(true)
	    self.startBtn.num:setString(tostring(leftFreePlay))
	    self.startBtn:ad(DisplayEvents.kTouchTap, function () self:onStartBtnTapped() end)
	elseif _mgr():getRemainingPayCount() > 0 then
		local userExtend = UserManager:getInstance().userExtend
		if __ANDROID then
			local mark = _text("buy.gold.panel.money.mark")
			local text = _text("weekly.race.panel.rabbit.button2")
			local label = mark..tostring(self.price).." "..text
    		self.startBtn:setColorMode(kGroupButtonColorMode.blue)
			self.startBtn:setString(label)
		    self.startBtn:ad(DisplayEvents.kTouchTap, function () self:onPayForPlayBtnTapped() end)
		elseif false and __IOS and _mgr():getMaxBuyCount() == _mgr():getRemainingPayCount() then
			-- 计费点藏得太深无法让苹果提审看到为了通过提审所以屏蔽掉
			self.startBtn:setVisible(false)
			self.rmbBuyBtn:setVisible(true)
		    self.rmbBuyBtn:ad(DisplayEvents.kTouchTap, function () self:onRmbForPlayBtnTapped() end)
		    self.coinBuyBtn:setPositionX(self.coinBuyBtnPh2:getPositionX())
		    self.coinBuyBtn:setPositionY(self.coinBuyBtnPh2:getPositionY())
		    self.coinBuyBtn:setVisible(true)
		    self.coinBuyBtn:ad(DisplayEvents.kTouchTap, function () self:onPayForPlayBtnTapped() end)
		else
			self.startBtn:setVisible(false)
			self.coinBuyBtn:setPositionX(self.coinBuyBtnPh1:getPositionX())
			self.coinBuyBtn:setPositionY(self.coinBuyBtnPh1:getPositionY())
			self.coinBuyBtn:setVisible(true)
		    self.coinBuyBtn:ad(DisplayEvents.kTouchTap, function () self:onPayForPlayBtnTapped() end)
		end
	else
		self.startBtn:setString(_text("weekly.race.panel.rabbit.button1"))
		self.startBtn:setEnabled(false)
		self.startBtn:setColorMode(kGroupButtonColorMode.grey)
		local function onDisableBtnTapped(evt)
			CommonTip:showTip(_text("weekly.race.no.more.play.tip"), "negative")
		end
		self.startBtn:ad(DisplayEvents.kTouchTap, onDisableBtnTapped)
	end
end

function RabbitWeeklyLevelInfoPanel:updateRewardState(visible)
	if not visible then
		self.state2:setVisible(false)
		return
	end

	self.state2:setVisible(true)

	self.state2.reward1 = self.state2:getChildByName("reward1")
    self.state2.reward2 = self.state2:getChildByName("reward2")
	self.state2:getChildByName("tips"):setString(_text("weekly.race.panel.rabbit.bottom.text2"))

	local fCount = _mgr():getSurpassedFriendCount()
	local fRewards = _mgr():getSurpassedFriendRewards()
	self.state2.reward1Obj = RabbitWeeklyReward.create(self.state2.reward1)
	self.state2.reward1Obj:update(_text("weekly.race.panel.reward.text1", {num=fCount}), fRewards)

	local mCount = _mgr():getMaxCountInOnePlay()
	local mRewards = _mgr():getLevelMaxCountRewards()
	self.state2.reward2Obj =RabbitWeeklyReward.create(self.state2.reward2)
	self.state2.reward2Obj:update(_text("weekly.race.panel.rabbit.reward.tip5", {num=mCount}), mRewards)

	self.coinBuyBtn:setVisible(false)
	self.coinBuyBtn:rma()
	self.startBtn:setVisible(true)
	self.startBtn:rma()
	self.startBtn.redDot:setVisible(false)
	self.startBtn.num:setVisible(false)

	if not self.timeValid then
		self.startBtn:setEnabled(false)
		self.startBtn:setString(_text("weekly.race.panel.rabbit.button1"))
		return
	end

	self.startBtn:setString(_text("weekly.race.panel.rabbit.button4"))
	if _mgr().rewardFlag > 0 or not self.timeValid then
		self.startBtn:setEnabled(false)
		self.startBtn:setString(_text("weekly.race.panel.rabbit.button4"))
	else
		self.startBtn:setColorMode(kGroupButtonColorMode.green)
	    self.startBtn:ad(DisplayEvents.kTouchTap, function () self:onReceiveBtnTapped() end)
	end
end

function RabbitWeeklyLevelInfoPanel:updatePanel()
	-- print("RabbitWeeklyLevelInfoPanel:updatePanel")
	if self and not self.isDisposed then
		local lastCheckTime = UserManager:getInstance().lastCheckTime or 0
		self.timeValid = math.ceil(Localhost:time()/1000) >= lastCheckTime

		local isPlayDay = _mgr():isPlayDay()
		self:updatePlayState(isPlayDay)
	    self:updateRewardState(not isPlayDay)
	    self.tappedState = self.TAPPED_STATE_NONE
	end
end

function RabbitWeeklyLevelInfoPanel:onCloseBtnTapped()
	if self.tappedState ~= self.TAPPED_STATE_NONE then return end

    self.tappedState = self.TAPPED_STATE_CLOSE_BTN_TAPPED

    local function onRemoveAnimFinished()
        -- Check If Pop The Current Scene
        if self.parentPanel.onClosePanelCallback then
            self.parentPanel:onClosePanelCallback()
        end
    end
    if self.parentPanel and not self.parentPanel.isDisposed then
        self.parentPanel:remove(onRemoveAnimFinished)
    end
end

-- 领取奖励按钮
function RabbitWeeklyLevelInfoPanel:onReceiveBtnTapped()
	if not RequireNetworkAlert:popout() then
        -- CommonTip:showTip(_text('weekly.race.tip.no.network'), 'negative')
        return 
    end

    if _mgr():isPlayDay() then
		CommonTip:showTip(_text("error.tip.730772"), "negative")
		self:updatePanel()
		return
	end

	local function successCallback()
		self:updatePanel()
		self.state2.reward1Obj:playRewardAnim()
		self.state2.reward2Obj:playRewardAnim()
		-- 更新HomeScene上的兔子周赛按钮状态
		local rabbitWeeklyButton = HomeScene:sharedInstance().rabbitWeeklyButton
		if rabbitWeeklyButton and not rabbitWeeklyButton.isDisposed then
			rabbitWeeklyButton:update()
		end
	end

	local function failCallback()
		self:updatePanel()
	end
	_mgr():receiveWeeklyReward(self.levelId, successCallback, failCallback)
end

-- Iap付费开始
function RabbitWeeklyLevelInfoPanel:onRmbForPlayBtnTapped()
	if not _mgr():isPlayDay() then
		CommonTip:showTip(_text("error.tip.730773"), "negative")
		self:updatePanel()
		return
	end

	local function onContinue()
		local function onSuccess()
			-- dcutil?
			if self then self:startGame() end
			if not self.isDisposed then
				self.rmbBuyBtn:setEnabled(true)
				self.coinBuyBtn:setEnabled(true)
			end
		end

		local function onFail()
			if self then self:updatePanel() end
			if not self.isDisposed then
				self.rmbBuyBtn:setEnabled(true)
				self.coinBuyBtn:setEnabled(true)
			end
		end

		self.rmbBuyBtn:setEnabled(false)
		self.coinBuyBtn:setEnabled(false)
		_mgr():rmbBuyPlayCard(onSuccess, onFail)
	end

	local function onCancel() end

	if _mgr():isNeedShowTimeWarnPanel() then
		self:popoutTimeWarningPanel(onContinue, onCancel)
	else
		onContinue()
	end
end

-- 付费开始
function RabbitWeeklyLevelInfoPanel:onPayForPlayBtnTapped( ... )
	-- if self.tappedState ~= self.TAPPED_STATE_NONE then
	-- 	return
	-- end
	-- self.tappedState = self.TAPPED_STATE_BUY_BTN_TAPPED

	if not _mgr():isPlayDay() then
		CommonTip:showTip(_text("error.tip.730773"), "negative")
		self:updatePanel()
		return
	end

	local function onContinue()
		local function onSuccess()
	        HomeScene:sharedInstance():checkDataChange()
	        HomeScene:sharedInstance().goldButton:updateView()
	        DcUtil:logWeeklyRaceActivity("buy_rabbit_times", {level_id = self.levelId})

			if self then self:startGame() end
		end

		local function onFail()
			if self then self:updatePanel() end
		end

		local function onCancel()
			if self then self:updatePanel() end
		end

		local function onFinish()
			if self then self:updatePanel() end
		end
		_mgr():buyPlayCard( onSuccess, onFail, onCancel, onFinish )
	end

	local function onCancel()
		-- self.tappedState = self.TAPPED_STATE_NONE
	end

	if _mgr():isNeedShowTimeWarnPanel() then
		self:popoutTimeWarningPanel(onContinue, onCancel)
	else
		onContinue()
	end
end

function RabbitWeeklyLevelInfoPanel:popoutTimeWarningPanel(onConfirmCallback, onCancelCallback)
	local panel = RabbitStartGameTimeWarningPanel:create(onConfirmCallback, onCancelCallback)

	self.parentPanel:setRankListPanelTouchDisable()
	local function onPopoutPanelClosed()
		self.parentPanel:setRankListPanelTouchEnable()
	end
	panel:popout(onPopoutPanelClosed)
end

-- 免费开始
function RabbitWeeklyLevelInfoPanel:onStartBtnTapped()
    if self.tappedState ~= self.TAPPED_STATE_NONE then
        return
    end

    if not _mgr():isPlayDay() then
		CommonTip:showTip(_text("error.tip.730773"), "negative")
		self:updatePanel()
		return
	end

	local function onContinue()
		if _mgr():getRemainingPlayCount() > 0 then
	    	self.tappedState = self.TAPPED_STATE_START_BTN_TAPPED
	        self:startGame()
	    else
	    	local function onBuyPlayCardSuccess()
	        	DcUtil:logWeeklyRaceActivity("buy_rabbit_times", {level_id = self.levelId})
	    		self:startGame()
	    	end
	    	RabbitWeeklyGetFreePlayPanel.create(self.parentPanel, self.levelId, onBuyPlayCardSuccess):popout()
	    end
	end

	local function onCancel() end

	if _mgr():isNeedShowTimeWarnPanel() then
		self:popoutTimeWarningPanel(onContinue, onCancel)
	else
		onContinue()
	end
end

function RabbitWeeklyLevelInfoPanel:startGame()
	if not _mgr():isPlayDay() then
		CommonTip:showTip(_text("error.tip.730773"), "negative")
		self:updatePanel()
		return
	end

    if self.parentPanel.replayStartGameCallback then
        self.parentPanel.replayStartGameCallback()
    end

    -- -------------------------------------
    -- Run The Start Level Bussiness Logic
    -- --------------------------------------
    local startLevelLogic = StartLevelLogic:create(self, self.levelId, GameLevelType.kRabbitWeekly, {}, true)
    startLevelLogic:start(true)
end

function RabbitWeeklyLevelInfoPanel:onStartLevelLogicSuccess( ... )
    -- body
end

function RabbitWeeklyLevelInfoPanel:onWillEnterPlayScene( ... )
    RabbitWeeklyManager:sharedInstance():descrLeftPlayCount()
    
	self.tappedState = self.TAPPED_STATE_NONE
    if self.parentPanel and not self.parentPanel.isDisposed then
        print("onWillEnterPlaySceneCallback remove parentPanel")
        PopoutManager:sharedInstance():remove(self.parentPanel, true)
    end
end

function RabbitWeeklyLevelInfoPanel:onDidEnterPlayScene( ... )
    DcUtil:beginRabbitMatch(self.levelId)
end

function RabbitWeeklyLevelInfoPanel:onStartLevelLogicFailed(err)
    self.tappedState = self.TAPPED_STATE_NONE

    local onStartLevelFailedKey     = "error.tip."..err
    local onStartLevelFailedValue   = Localization:getInstance():getText(onStartLevelFailedKey, {})
    CommonTip:showTip(onStartLevelFailedValue, "negative")
end
