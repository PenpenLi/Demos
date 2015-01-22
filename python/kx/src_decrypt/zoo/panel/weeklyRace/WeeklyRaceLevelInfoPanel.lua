require "zoo.scenes.GamePlaySceneUI"
require "zoo.panelBusLogic.StartLevelLogic"

require "zoo.panel.component.common.BubbleCloseBtn"
require "zoo.data.WeeklyRaceManager"
require "zoo.panel.weeklyRace.WeeklyRaceExchangePanel"
require 'zoo.panel.weeklyRace.CommonRulePanel'

-- short hand function
local function _text(key, replace)
    return Localization:getInstance():getText(key, replace)
end

WeeklyRaceLevelInfoPanel = class(BasePanel)

function WeeklyRaceLevelInfoPanel:init(parentPanel, levelId, ...)

    local ui = ResourceManager:sharedInstance():buildGroupWithCustomProperty("startGamePanel/weeklyRaceLevelInfoPanel")

    -- -----------------
    -- Init Base Class
    -- -------------------
    BasePanel.init(self, ui)
    self.parentPanel = parentPanel
    self.TAPPED_STATE_START_BTN_TAPPED  = 1
    self.TAPPED_STATE_CLOSE_BTN_TAPPED  = 2
    self.TAPPED_STATE_NONE          = 3
    self.tappedState            = self.TAPPED_STATE_NONE

    self.levelId = levelId

    ---------------------
    -- Additional Layer To Play User Guide
    -- -----------------------------------
    self.userGuideLayer = Layer:create()
    self:addChild(self.userGuideLayer)

    local panelTitlePlaceholder = ui:getChildByName('levelLabelPlaceholder')
    local panelTitlePlaceholderPosY = panelTitlePlaceholder:getPositionY()
    self.time = ui:getChildByName('time')
    self.closeBtn = BubbleCloseBtn:create(ui:getChildByName('bg'):getChildByName('closeBtn'))
    self.closeBtn.ui:ad(DisplayEvents.kTouchTap, function () self:onCloseBtnTapped() end)

    self.state1                     = ui:getChildByName('state1')
    self.state1.desc                = self.state1:getChildByName('desc')
    self.state1.summary             = self.state1:getChildByName('summary')
    self.state1.rule                = self.state1:getChildByName('rule')
    self.state1.rule.desc           = self.state1.rule:getChildByName('desc')
    self.state1.rule.btn            = self.state1.rule:getChildByName('btn')
    self.state1.rule.btn.desc       = self.state1.rule.btn:getChildByName('desc')
    self.state1.startBtn            = GroupButtonBase:create(self.state1:getChildByName('startBtn'))
    self.state1.startBtn.redDot     = self.state1.startBtn.groupNode:getChildByName('redDot')
    self.state1.startBtn.num        = self.state1.startBtn.groupNode:getChildByName('num')
    self.state1.exchangeBtn         = GroupButtonBase:create(self.state1:getChildByName('exchangeBtn'))

    self.state2                     = ui:getChildByName('state2')
    self.state2.rule                = self.state2:getChildByName('rule')
    self.state2.rule.desc           = self.state2.rule:getChildByName('desc')
    self.state2.rule.btn            = self.state2.rule:getChildByName('btn')
    self.state2.rule.btn.desc       = self.state2.rule.btn:getChildByName('desc')

    self.state2.item1               = self.state2:getChildByName('item1')
    self.state2.item1.desc          = self.state2.item1:getChildByName('desc')
    self.state2.item1.okIcon        = self.state2.item1:getChildByName('okIcon')
    self.state2.item1.btn           = GroupButtonBase:create(self.state2.item1:getChildByName('btn'))
    self.state2.item1.noRewardLabel = self.state2.item1:getChildByName('noRewardLabel')
    self.state2.item1.items         = self.state2.item1:getChildByName('items')
    self.state2.item1.items.desc    = self.state2.item1.items:getChildByName('desc')
    self.state2.item1.items.num1    = self.state2.item1.items:getChildByName('num1')
    self.state2.item1.items.icon1   = self.state2.item1.items:getChildByName('icon1')    
    self.state2.item1.items.num2    = self.state2.item1.items:getChildByName('num2')
    self.state2.item1.items.icon2   = self.state2.item1.items:getChildByName('icon2')
    self.state2.item1.items.num3    = self.state2.item1.items:getChildByName('num3')
    self.state2.item1.items.icon3   = self.state2.item1.items:getChildByName('icon3')
    self.state2.item1.items.num4    = self.state2.item1.items:getChildByName('num4')
    self.state2.item1.items.icon4   = self.state2.item1.items:getChildByName('icon4')
    self.state2.item1.items.num1    = self.state2.item1.items:getChildByName('num1')


    self.state2.item2               = self.state2:getChildByName('item2')
    self.state2.item2.desc          = self.state2.item2:getChildByName('desc')
    self.state2.item2.okIcon        = self.state2.item2:getChildByName('okIcon')
    self.state2.item2.btn           = GroupButtonBase:create(self.state2.item2:getChildByName('btn'))
    self.state2.item2.noRewardLabel = self.state2.item2:getChildByName('noRewardLabel')
    self.state2.item2.items         = self.state2.item2:getChildByName('items')
    self.state2.item2.items.desc    = self.state2.item2.items:getChildByName('desc')
    self.state2.item2.items.num1    = self.state2.item2.items:getChildByName('num1')
    self.state2.item2.items.icon1   = self.state2.item2.items:getChildByName('icon1')    
    self.state2.item2.items.num2    = self.state2.item2.items:getChildByName('num2')
    self.state2.item2.items.icon2   = self.state2.item2.items:getChildByName('icon2')
    self.state2.item2.items.num3    = self.state2.item2.items:getChildByName('num3')
    self.state2.item2.items.icon3   = self.state2.item2.items:getChildByName('icon3')
    self.state2.item2.items.num4    = self.state2.item2.items:getChildByName('num4')
    self.state2.item2.items.icon4   = self.state2.item2.items:getChildByName('icon4')

    for i=1, 2 do 
        for j=1, 4 do 
            local num = self.state2['item'..i].items['num'..j]
            local icon = self.state2['item'..i].items['icon'..j]
            num.pos = ccp(num:getPositionX(), num:getPositionY())
            icon.pos = icon:getPosition()
        end
    end

    self.state2.item3               = self.state2:getChildByName('item3')
    self.state2.item3.desc          = self.state2.item3:getChildByName('desc')
    self.state2.item3.btn           = GroupButtonBase:create(self.state2.item3:getChildByName('btn'))

    local levelDisplayName = _text('weekly.race.panel.start.title')
    local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
    local panelTitle = PanelTitleLabel:createWithString(levelDisplayName, len)

    local contentSize = panelTitle:getContentSize()
    self.ui:addChild(panelTitle)
    panelTitle:ignoreAnchorPointForPosition(false)
    panelTitle:setAnchorPoint(ccp(0,1))
    panelTitle:setPositionY(panelTitlePlaceholderPosY)
    panelTitle:setToParentCenterHorizontal()

    -- static texts
    self.state1.exchangeBtn:setString(_text('weekly.race.go.exchange.gem.btn'))
    self.state1.exchangeBtn:setColorMode(kGroupButtonColorMode.blue)

    self.state1.startBtn:setString(_text('weekly.race.panel.start.btn'))
    self.state1.startBtn:setColorMode(kGroupButtonColorMode.green)

    self.state1.rule.desc:setString(_text('weekly.race.panel.start.text1'))
    self.state1.rule.btn.desc:setString(_text('weekly.race.rules.link'))
    self.state1.desc:setString(_text('weekly.race.panel.start.text2'))

    self.state2.rule.desc:setString(_text('weekly.race.panel.reward.text3'))
    self.state2.rule.btn.desc:setString(_text('weekly.race.reward.rules.link'))
    self.state2.item1.btn:setString(_text('star.reward.panel.get.btn.label'))
    self.state2.item2.btn:setString(_text('star.reward.panel.get.btn.label'))
    self.state2.item3.btn:setString(_text('weekly.race.go.exchange.gem.btn'))
    self.state2.item1.noRewardLabel:setString(_text('weekly.race.no.reward'))
    self.state2.item2.noRewardLabel:setString(_text('weekly.race.no.reward'))
    -- self.state2.item1.items.desc:setString(_text(''))
    -- self.state2.item2.items.desc:setString(_text(''))

    self.state2.item1.btn:setColorMode(kGroupButtonColorMode.green)
    self.state2.item2.btn:setColorMode(kGroupButtonColorMode.green)
    self.state2.item3.btn:setColorMode(kGroupButtonColorMode.blue)

    local function getNearestSunday()
        local today = tonumber(os.date("%w", Localhost:time() / 1000))
        print('today', today)
        local diff = 7 - today
        if diff == 7 then diff = 0 end -- 如果今天就是周日，则显示今天
        local sunday = Localhost:time() / 1000 + diff * 24 * 3600
        local txt = os.date("%m月%d日23:59", sunday)
        return txt
    end
    if WeeklyRaceManager:sharedInstance():isPlayDay() then
        self.time:setString(_text('weekly.race.panel.start.duration', {time = getNearestSunday()}))
    else 
        self.time:setString(_text('weekly.race.panel.reward.duration', {time = getNearestSunday()}))
    end

    self.state1.startBtn:ad(DisplayEvents.kTouchTap, function () self:onStartButtonTapped() end)
    self.state1.exchangeBtn:ad(DisplayEvents.kTouchTap, function () 
                                    self:showExchangePanel() 
                                    DcUtil:weeklyRaceExchangeBtn(1)
                               end)
    self.state2.item3.btn:ad(DisplayEvents.kTouchTap, function () 
                                    self:showExchangePanel() 
                                    DcUtil:weeklyRaceExchangeBtn(2)
                                end)

    self.state1.rule.btn:setTouchEnabled(true)
    self.state2.rule.btn:setTouchEnabled(true)
    self.state1.rule.btn:ad(DisplayEvents.kTouchTap, function () self:showRulePanel() end)
    self.state2.rule.btn:ad(DisplayEvents.kTouchTap, function () self:showRewardRulePanel() end)
    self.state2.item1.btn:ad(DisplayEvents.kTouchTap, function () self:onReceiveReward1() end)
    self.state2.item2.btn:ad(DisplayEvents.kTouchTap, function () self:onReceiveReward2() end)
  
    WeeklyRaceManager:sharedInstance():setLevelInfoPanel(self)
    -- WeeklyRaceManager:sharedInstance():loadData() -- test
    UserManager:getInstance():checkDateChange()
    self:update()
end

function WeeklyRaceLevelInfoPanel:update()
    if WeeklyRaceManager:sharedInstance():isPlayDay() then
        self:showState1()
        self:hideState2()
    else
        self:hideState1()
        self:showState2()
    end
end


function WeeklyRaceLevelInfoPanel:onReceiveReward1()

    if not RequireNetworkAlert:popout() then
        -- CommonTip:showTip(_text('weekly.race.tip.no.network'), 'negative')
        return 
    end

    if not WeeklyRaceManager:sharedInstance():canReceiveReward1() then 
        CommonTip:showTip(_text('weekly.race.tip.no.surpass.friend'), 'negative')
        return 
    end

    if self._isReceivingReward1 == true then return end
    self._isReceivingReward1 = true
    self.state2.item1.btn:setEnabled(false)

    local function onSuccess(event)
        HomeScene:sharedInstance():checkDataChange()
        HomeScene:sharedInstance().coinButton:updateView()
        local rewards = WeeklyRaceManager:sharedInstance():getRewardConfig(1)

        -- 打点
        local user = UserManager:getInstance().user
        for k, v in pairs(rewards) do 
            if v.itemId == 14 then 
                DcUtil:logCreateCash("weeklyrace",v.num,user:getCash(),-1)
            elseif v.itemId == 2 then
                DcUtil:logCreateCoin("weeklyrace",v.num,user:getCoin(),-1)
            else
                DcUtil:logRewardItem("weeklyrace", v.itemId, v.num, -1)
            end
        end
        if self.isDisposed then return end
        self._isReceivingReward1 = false
        self.state2.item1.btn:setEnabled(true)
        self:update()
        -- animation
        local rewardIds = {}
        local rewardAmounts = {}
        for k, v in pairs(rewards) do 
            table.insert(rewardIds, v.itemId)
            table.insert(rewardAmounts, v.num)
        end
        local anims = HomeScene:sharedInstance():createFlyingRewardAnim(rewardIds, rewardAmounts)
        for k, v in pairs(anims) do 
            local icon = self.state2.item1.items['icon'..k]
            local pos = icon:getParent():convertToWorldSpace(icon.pos)
            v:setPosition(pos)
            v:playFlyToAnim()
        end
        DcUtil:weeklyRaceExceedReward()
    end

    local function onFail(event)
        local err_code = tonumber(event.data)
        CommonTip:showTip(_text('error.tip.'..err_code, 'negative', 3, nil))
        if self.isDisposed then return end
        self._isReceivingReward1 = false
        self.state2.item1.btn:setEnabled(true)
        self:update()
    end
    WeeklyRaceManager:sharedInstance():receiveReward1(onSuccess, onFail)
end


function WeeklyRaceLevelInfoPanel:onReceiveReward2()

    if not RequireNetworkAlert:popout() then
        -- CommonTip:showTip(_text('weekly.race.tip.no.network'), 'negative')
        return 
    end

    if not WeeklyRaceManager:sharedInstance():canReceiveReward2() then 
        CommonTip:showTip(_text('weekly.race.tip.no.gem.reward'), 'negative')
        return 
    end


    if self._isReceivingReward2 == true then return end
    self._isReceivingReward2 = true
    self.state2.item2.btn:setEnabled(false)

    local function onSuccess(event)       
        HomeScene:sharedInstance():checkDataChange()
        HomeScene:sharedInstance().coinButton:updateView()
        local rewards = WeeklyRaceManager:sharedInstance():getRewardConfig(2)
        -- 打点
        local user = UserManager:getInstance().user
        for k, v in pairs(rewards) do 
            if v.itemId == 14 then 
                DcUtil:logCreateCash("weeklyrace",v.num,user:getCash(),-1)
            elseif v.itemId == 2 then
                DcUtil:logCreateCoin("weeklyrace",v.num,user:getCoin(),-1)
            else
                DcUtil:logRewardItem("weeklyrace", v.itemId, v.num, -1)
            end
        end
        if self.isDisposed then return end
        self._isReceivingReward2 = false 
        self.state2.item2.btn:setEnabled(true)
        self:update()
        -- animation
        local rewardIds = {}
        local rewardAmounts = {}
        for k, v in pairs(rewards) do 
            table.insert(rewardIds, v.itemId)
            table.insert(rewardAmounts, v.num)
        end
        local anims = HomeScene:sharedInstance():createFlyingRewardAnim(rewardIds, rewardAmounts)
        for k, v in pairs(anims) do 
            local icon = self.state2.item2.items['icon'..k]
            local pos = icon:getParent():convertToWorldSpace(icon.pos)
            v:setPosition(pos)
            v:playFlyToAnim()
        end
        DcUtil:weeklyRaceGemReward()
    end

    local function onFail(event)
        local err_code = tonumber(event.data or 0)
        CommonTip:showTip(_text('error.tip.'..err_code, 'negative', 3, nil))
        if self.isDisposed then return end
        self._isReceivingReward2 = false
        self.state2.item2.btn:setEnabled(true)
        self:update()
    end
    WeeklyRaceManager:sharedInstance():receiveReward2(onSuccess, onFail)
end


function WeeklyRaceLevelInfoPanel:showRulePanel()
    local title = _text('weekly.race.panel.rules.title')
    local stringConfig = {}
    local indexs = {1, 3, 6, 8, 12, 15, 18}
    for i=1, 7 do 
        local config = {
            index = indexs[i],
            text = _text('weekly.race.panel.rules.text'..i)
        }
        table.insert(stringConfig, config)
    end
    self.parentPanel:setRankListPanelTouchDisable()
    local panel = CommonRulePanel:create()
    panel:setStrings(stringConfig)
    panel:setTitle(title)
    panel:popout(function () self.parentPanel:setRankListPanelTouchEnable() end)
    DcUtil:weeklyRaceInfo(1)
end

function WeeklyRaceLevelInfoPanel:showRewardRulePanel()
    local title = _text('weekly.race.reward.rules.title')
    local stringConfig = {}
    local indexs = {1, 4, 9, 13, 16}
    for i=1, 5 do 
        local config = {
            index = indexs[i],
            text = _text('weekly.race.reward.rules.text'..i)
        }
        table.insert(stringConfig, config)
    end
    self.parentPanel:setRankListPanelTouchDisable()
    local panel = CommonRulePanel:create()
    panel:setStrings(stringConfig)
    panel:setTitle(title)
    panel:popout(function () self.parentPanel:setRankListPanelTouchEnable() end)
    DcUtil:weeklyRaceInfo(2)
end

function WeeklyRaceLevelInfoPanel:showExchangePanel()
    self.parentPanel:setRankListPanelTouchDisable()
    local panel = WeeklyRaceExchangePanel:create(self)
    panel:popout(function () self.parentPanel:setRankListPanelTouchEnable() end)
end


function WeeklyRaceLevelInfoPanel:showState1()
    self.state1:setVisible(true)

    -- update texts
    local remainingPlayCount = WeeklyRaceManager:sharedInstance():getRemainingPlayCount()
    local remainingGemCount = WeeklyRaceManager:sharedInstance():getRemainingGemCount()
    local totalGemCount = WeeklyRaceManager:sharedInstance():getTotalGemCount()

    self.state1.startBtn.num:setString(remainingPlayCount)
    self.state1.summary:setString(_text('weekly.race.panel.gem.num1', {total = totalGemCount, remain = remainingGemCount}))
    self.state1.startBtn:setEnabled(true)
    self.state1.exchangeBtn:setEnabled(true)
    self.state1.rule.btn:setTouchEnabled(true)
end

function WeeklyRaceLevelInfoPanel:showState2()
    self.state2:setVisible(true)
    self.state2.item3.btn:setEnabled(true)
    local wrm = WeeklyRaceManager:sharedInstance()
    local surpassedFriendCount = wrm:getSurpassedFriendCount()
    local maxDigCountInOnePlay = wrm:getMaxDigCountInOnePlay()
    local remainingGemCount = wrm:getRemainingGemCount()
    local totalGemCount = wrm:getTotalGemCount()

    self.state2.item1.desc:setString(_text('weekly.race.panel.reward.text1', {num = surpassedFriendCount}))
    self.state2.item2.desc:setString(_text('weekly.race.panel.reward.text2', {num = maxDigCountInOnePlay}))
    self.state2.item3.desc:setString(_text('weekly.race.panel.gem.num1', {total = totalGemCount, remain = remainingGemCount}))

    local hasReceivedReward1 = wrm:hasReceivedReward1()
    local canReceiveReward1 = wrm:canReceiveReward1()
    local hasReceivedReward2 = wrm:hasReceivedReward2()
    local canReceiveReward2 = wrm:canReceiveReward2()

    local function setItems(itemsUI, itemsData)
        local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
        local count = #itemsData
        -- local leftMostX = itemsUI.icon1:getPositionX()
        -- local rightMostX = itemsUI.icon4:getPositionX()
        local leftMostX = itemsUI.icon1.pos.x
        local rightMostX = itemsUI.icon4.pos.x
        local diffX = rightMostX - leftMostX
        local offset = 0 -- simple stupid solution...
        if count == 1 then
            offset = diffX / 2
        elseif count == 2 then
            offset = diffX / 3
        elseif count == 3  then
            offset = diffX / 4
        end
        print(count, leftMostX, rightMostX, offset)
        for i=1, 4 do 
            itemsUI['icon'..i]:setVisible(false)
            itemsUI['num'..i]:setVisible(false)
        end
        for i=1, count do 
            print(i, 'test')

            local icon = itemsUI['icon'..i]
            local num = itemsUI['num'..i]
            num:setVisible(true)
            num:setString('x'..itemsData[i].num)
            local ui = iconBuilder:buildGroup('Prop_'..itemsData[i].itemId)
            ui:setPositionX(icon.pos.x + offset)
            num:setPositionX(num.pos.x + offset)
            ui:setScale(0.6)
            icon:getParent():addChildAt(ui, icon:getZOrder())

        end
    end

    local function changeItemState(item, hasReceived, canReceive)
        if hasReceived then
            item.btn:setVisible(false)
            item.okIcon:setVisible(true)
            item.btn:setEnabled(true)
            item.noRewardLabel:setVisible(true)
            item.items:setVisible(false)
        elseif canReceive then
            item.btn:setVisible(true)
            item.okIcon:setVisible(false)
            item.btn:setEnabled(true)
            item.noRewardLabel:setVisible(false)
            item.items:setVisible(true)
        else 
            item.btn:setVisible(true)
            item.okIcon:setVisible(false)
            item.btn:setEnabled(true)
            item.noRewardLabel:setVisible(true)
            item.items:setVisible(false)
        end
    end
    changeItemState(self.state2.item1, hasReceivedReward1, canReceiveReward1)
    changeItemState(self.state2.item2, hasReceivedReward2, canReceiveReward2)
    setItems(self.state2.item1.items, wrm:getRewardConfig(1))
    setItems(self.state2.item2.items, wrm:getRewardConfig(2))
end

function WeeklyRaceLevelInfoPanel:hideState1()
    self.state1:setVisible(false)
    self.state1.startBtn:setEnabled(false)
    self.state1.exchangeBtn:setEnabled(false)
    self.state1.rule.btn:setTouchEnabled(false)
end

function WeeklyRaceLevelInfoPanel:hideState2()
    self.state2:setVisible(false)
    self.state2.item1.btn:setEnabled(false)
    self.state2.item2.btn:setEnabled(false)
    self.state2.item3.btn:setEnabled(false)
    self.state2.rule.btn:setTouchEnabled(false)

end

function WeeklyRaceLevelInfoPanel:onCloseBtnTapped(event)
    if self.tappedState == self.TAPPED_STATE_NONE then

        local runningScene = Director:sharedDirector():getRunningScene()
        print("runningScene.name", runningScene.name)
        if GameGuide then
            local name = GameGuide:sharedInstance():currentGuideType()
            print("GameGuide:sharedInstance():currentGuideType()", name)
            if name then print("name", name)
                if name == "startInfo" or name == "showPreProp" then
                    print("should return")
                    return
                end
            end
        end

        self.tappedState = self.TAPPED_STATE_CLOSE_BTN_TAPPED
    else
        return
    end
    
    local function onRemoveAnimFinished()
        -- Check If Pop The Current Scene
        local runningScene = Director:sharedDirector():getRunningScene()
        if self.parentPanel.onClosePanelCallback then
            self.parentPanel:onClosePanelCallback()
        end
    end

    self.parentPanel:remove(onRemoveAnimFinished)
end



function WeeklyRaceLevelInfoPanel:onStartButtonTapped(event)
    if self.tappedState == self.TAPPED_STATE_NONE then
        --self.tappedState = self.TAPPED_STATE_START_BTN_TAPPED
    else
        return
    end

    if WeeklyRaceManager:sharedInstance():getRemainingPlayCount() > 0 then
        self:startGame()
    else
        CommonTip:showTip(_text('weekly.race.no.more.play.tip'), 'negative', nil, 2)
    end
end




function WeeklyRaceLevelInfoPanel:startGame()
    -- -------------------------------------
    -- Run The Start Level Bussiness Logic
    -- --------------------------------------
    local startLevelLogic = StartLevelLogic:create(self, self.levelId, GameLevelType.kDigWeekly, {}, true)
    startLevelLogic:start(true)
end

function WeeklyRaceLevelInfoPanel:onWillEnterPlayScene( ... )
    -- play count++, remaining play count--
    WeeklyRaceManager:sharedInstance():addPlayCount()

    if self.parentPanel and not self.parentPanel.isDisposed then
        print("onWillEnterPlayScene remove parentPanel")
        PopoutManager:sharedInstance():remove(self.parentPanel, true)
    end
end

function WeeklyRaceLevelInfoPanel:onDidEnterPlayScene( ... )
    DcUtil:weeklyRaceBegin()
end

function WeeklyRaceLevelInfoPanel:onStartLevelLogicFailed(err)
    local onStartLevelFailedKey     = "error.tip."..err
    local onStartLevelFailedValue   = Localization:getInstance():getText(onStartLevelFailedKey, {})
    CommonTip:showTip(onStartLevelFailedValue, "negative")
end

function WeeklyRaceLevelInfoPanel:create(parentPanel, levelId, ...)
    local newPanel = WeeklyRaceLevelInfoPanel.new()
    newPanel:init(parentPanel, levelId)
    return newPanel
end
