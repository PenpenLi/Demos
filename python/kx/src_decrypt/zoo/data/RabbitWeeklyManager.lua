require "zoo.panelBusLogic.IapBuyPropLogic"

local function isFlagBitSet(flag, bitIndex)
    if bitIndex < 1 then bitIndex = 1 end
    local mask = math.pow(2, bitIndex - 1) -- e.g.: mask: 0010

    local bit = require("bit")
    return mask == bit.band(flag, mask)
end

-- short hand function
local function _text(key, replace)
    return Localization:getInstance():getText(key, replace)
end

local function addReward(reward)
    for k, v in pairs(reward) do 
        if v.itemId == ItemType.COIN then
            UserManager:getInstance().user:setCoin(UserManager:getInstance().user:getCoin() + v.num)
            UserService:getInstance().user:setCoin(UserService:getInstance().user:getCoin() + v.num)
            DcUtil:logCreateCoin("weeklyrace",v.num,UserManager:getInstance().user:getCoin(),-1)
        else
            UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
            UserService:getInstance():addUserPropNumber(v.itemId, v.num)
            DcUtil:logRewardItem("weeklyrace", v.itemId, v.num, -1)
        end
    end
end


local function merge(rewardBase, rewardAddDiff)
    local found = false
    for k, v in pairs(rewardBase) do 
        if v.itemId == rewardAddDiff.itemId then
            v.num = v.num + rewardAddDiff.num
            found = true
        end
    end
    if not found then
        table.insert(rewardBase, rewardAddDiff)
    end
end

local RabbitWeeklyConfig = {
    dailyMainLevelCount = 5,
    freePlayByMainLevel = 2,
    dailyShare = 1,
    freePlayByShare = 1,
    lowestLevel = 31,
}

RabbitWeeklyManager = class()

RabbitWeeklyManager.playCardGoodsId = 150

local instance = nil
function RabbitWeeklyManager:sharedInstance()
    if not instance then
        instance = RabbitWeeklyManager.new()
        instance:init()
    end
    return instance
end

function RabbitWeeklyManager:init()
    -- 初始化配置
    local levelId = instance:getLevelIdForToday()
    self.levelId = levelId
    self:updateConfigByLevelId(levelId)

    self.extraConfig = RabbitWeeklyConfig
    self.lowestLevel = RabbitWeeklyConfig.lowestLevel
    -- read datas from storage
    local data = self:readFromStorage()
    if data then
        print("read data from storage:", table.tostring(data))
        for k, v in pairs(data) do
            self[k] = v
        end
    else
        print("read data from storage: nil")
        self:resetWeeklyData() -- init datas
        self:flushToStorage()
    end

    self.needShowFreeTimeTip = false
end

function RabbitWeeklyManager:updateDataIfWeekChange()
    local levelId = self:getLevelIdForToday()
    if self.levelId ~= levelId then
        self:resetWeeklyData()
        self:flushToStorage()
    end
end

function RabbitWeeklyManager:updateConfigByLevelId(levelId)
    local meta = MetaManager:getInstance()
    -- print(levelId, table.tostring(meta.weekly_race_exchange))

    for k, v in pairs(meta.weekly_race_exchange) do 
        if v.levelId == levelId then
            self.exchangeConfig = v
            break
        end
    end

    -- print("RabbitWeeklyManager", levelId, table.tostring(self.exchangeConfig))
    for k, v in pairs(meta.weekly_race_gem_reward) do 
        if v.levelId == levelId then
            self.gemRewardConfig = v
            break
        end
    end

    self.surpassLimit = self.exchangeConfig.surpassLimit
    self.surpassReward = self.exchangeConfig.surpassReward
end

function RabbitWeeklyManager:onShareSuccess()
    self.share = self.share + 1
    if not self.shareItemCompleted
            and self.share >= self.extraConfig.dailyShare then
        self.shareItemCompleted = true
        self.leftPlay = self.leftPlay + 1
    end
    self:flushToStorage()
end

function RabbitWeeklyManager:onStartMainLevel()
    self.mainLevelCount = self.mainLevelCount + 1
    if not self.mainLevelItemCompleted 
            and self.mainLevelCount >= self.extraConfig.dailyMainLevelCount then
        self.mainLevelItemCompleted = true
        self.needShowFreeTimeTip = true
        self.leftPlay = self.leftPlay + self.extraConfig.freePlayByMainLevel
    end
    self:flushToStorage()
end

--显示通过5次打主线关而获得的周赛次数tip
function RabbitWeeklyManager:showGetFreeTimeTip()
    if self:isPlayDay() then 
        if self.needShowFreeTimeTip then 
            self.needShowFreeTimeTip = false
            local rabbitBtn = HomeScene:sharedInstance().rabbitWeeklyButton 
            if rabbitBtn then 
                rabbitBtn.id = "rabbit_mainlevel"
                if not IconButtonManager:getInstance():todayIsShow(rabbitBtn) then
                    IconButtonManager:getInstance():clearShowTime(rabbitBtn)
                    rabbitBtn:stopHasNotificationAnim()
                    rabbitBtn:showTip(Localization:getInstance():getText("weekly.race.panel.rabbit.notice"))
                end
            end
        end
    end
end

function RabbitWeeklyManager:showRabbitTimeTutor()
    local leftPlayTime = nil
    if self.extraConfig.dailyMainLevelCount and self.mainLevelCount then 
        leftPlayTime = self.extraConfig.dailyMainLevelCount - self.mainLevelCount
        if leftPlayTime < 1 then 
            return
        end
    else
        return
    end

    local userDefault = CCUserDefault:sharedUserDefault()
    local curTime = os.time()
    local lastTutorTime = userDefault:getStringForKey("rabbit.mainlevel.tutor.time")
    if lastTutorTime then 
        local oneDaySec = 24 * 3600
        lastTutorTime = tonumber(lastTutorTime)
        if type(lastTutorTime) == "number" then 
            if curTime - lastTutorTime < oneDaySec then 
                return 
            end
        end
    end
    userDefault:setStringForKey("rabbit.mainlevel.tutor.time", tostring(curTime))
    userDefault:flush()

    local scene = HomeScene:sharedInstance()
    local layer = scene.guideLayer
    local levelId = UserManager:getInstance().user:getTopLevelId()
    
    local topLevelNode = scene.worldScene.levelToNode[levelId]
    if topLevelNode and leftPlayTime then 
        local pos = topLevelNode:getPosition()
        local worldPos = topLevelNode:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
        local trueMask = GameGuideUI:mask(180, 1, ccp(worldPos.x, worldPos.y-70), 1.2, false, false, false, false, true)
        trueMask.setFadeIn(0.3, 0.3)

        --关卡花代理
        local touchLayer = LayerColor:create()
        touchLayer:setColor(ccc3(255,0,0))
        touchLayer:setOpacity(0)
        touchLayer:setAnchorPoint(ccp(0.5, 0.5))
        touchLayer:ignoreAnchorPointForPosition(false)
        touchLayer:setPosition(ccp(worldPos.x, worldPos.y-70))
        touchLayer:changeWidthAndHeight(100, 100)
        touchLayer:setTouchEnabled(true, 0, true)

        local function onTrueMaskTap()
            --点击关闭引导
            if layer:contains(trueMask) then 
                layer:removeChild(trueMask)
            end
        end

        local function onTouchLayerTap()
            --关了自己
            onTrueMaskTap()
            --打最高关卡
            if not PopoutManager:sharedInstance():haveWindowOnScreen()
                    and not HomeScene:sharedInstance().ladyBugOnScreen then
                local levelType = LevelType:getLevelTypeByLevelId(levelId)
                local startGamePanel = StartGamePanel:create(levelId, levelType)
                startGamePanel:popout(false)
            end
        end
        touchLayer:addEventListener(DisplayEvents.kTouchTap, onTouchLayerTap)
        trueMask:addChild(touchLayer)

        trueMask:addEventListener(DisplayEvents.kTouchTap, onTrueMaskTap)

        local panel = nil
        -- if worldPos.x > 360 then 
        --     panel = GameGuideUI:panelSDR(Localization:getInstance():getText("weekly.race.panel.rabbit.tutorial", {num = leftPlayTime, n = '\n'}), false, 0)
        -- else
            panel = GameGuideUI:panelSD(Localization:getInstance():getText("weekly.race.panel.rabbit.tutorial", {num = leftPlayTime, n = '\n'}), false, 0)
        -- end
        panel:setScale(0.8)
        local panelPos = panel:getPosition()
        panel:setPosition(ccp(panelPos.x + 120, worldPos.y+250))
        local function addTipPanel()
            trueMask:addChild(panel)
        end
        trueMask:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(addTipPanel)))

        local hand = GameGuideAnims:handclickAnim(0.5, 0.3)
        hand:setAnchorPoint(ccp(0, 1))
        hand:setPosition(ccp(worldPos.x , worldPos.y - 70))
        trueMask:addChild(hand)

        if layer then
            layer:addChild(trueMask)
        end
    end
end

function RabbitWeeklyManager:getFreePlayLeft()
    local left = self.leftPlay
    if not self.mainLevelItemCompleted then
        left = left + self.extraConfig.freePlayByMainLevel
    end
    if not self.shareItemCompleted then
        left = left + self.extraConfig.freePlayByShare
    end
    return left
end

function RabbitWeeklyManager:loadDataWithAnim(successCallback)
    local function onInitialized()
        if self.levelInfoPanel and not self.levelInfoPanel.isDisposed then
            self.levelInfoPanel:update()
        end  
        if successCallback then successCallback() end
    end

    local animation

    local function onFail( evt )
        evt.target:removeAllEventListeners()
        animation:removeFromParentAndCleanup(true)
        if tonumber(evt.data) == 203 then -- sync failed
            return 
        end
        self:onLoadDataFailed()
        onInitialized()
    end
    local function onSuccess( evt )
        evt.target:removeAllEventListeners()
        animation:removeFromParentAndCleanup(true)
        self:onLoadDataSuccess(evt.data)
        onInitialized()
    end 

    local http = GetRabbitMatchDatasHttp.new()
    local function onCloseButtonTap()
        if http then http:removeAllEventListeners() end
        animation:removeFromParentAndCleanup(true)
        self:onLoadDataFailed()
        onInitialized()
    end

    local scene = Director:sharedDirector():getRunningScene()
    animation = CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap)
    -- scene:addChild(animation)

    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    http:syncLoad(self.levelId)
end

function RabbitWeeklyManager:onLoadDataSuccess(data)
    self.rewardFlag = tonumber(data.rewardFlag) -- 周一领奖标识
    self.leftPlay = tonumber(data.leftPlay)
    self.share = tonumber(data.share) -- 今天分享的次数
    self.mainLevelCount = tonumber(data.mainLevelCount) -- 今天玩主线关卡的次数
    self.maxCountInOnePlay = tonumber(data.maxRabbitsOfLevel) -- 单关获得的最多兔子数
    self.dailyRabbits = tonumber(data.dailyRabbits) -- 今天获得的兔子总数
    self.passedFriendsCount = tonumber(data.passedFriendsCount) -- 本周单关兔子数超越的好友个数
    self.dailyRewards = data.dailyRewards -- 当天领取过的宝箱列表
    self.shareItemCompleted = self.share >= self.extraConfig.dailyShare
    self.mainLevelItemCompleted = self.mainLevelCount >= self.extraConfig.dailyMainLevelCount

    self:flushToStorage()
end

function RabbitWeeklyManager:onLoadDataFailed()
    local data = self:readFromStorage()
    -- print(table.tostring(data))
    if not data then return end
    for k, v in pairs(data) do
        self[k] = v
    end

    if self._dayChanged == true then
        self:updateOnDayChange()
    end
end

function RabbitWeeklyManager:loadData(successCallback)
    local function onInitialized()
        if self.levelInfoPanel and not self.levelInfoPanel.isDisposed then
            self.levelInfoPanel:update()
        end  
        if successCallback then successCallback() end
    end

    local function onSuccess(event)
        local data = event.data
        self:onLoadDataSuccess(data)
        onInitialized()
    end

    local function onFail(event)
        if tonumber(event.data) == 203 then -- sync failed
            -- print('sync failed')
            return 
        end
        self:onLoadDataFailed()
        onInitialized()
    end

    local http = GetRabbitMatchDatasHttp.new()
    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    http:syncLoad(self.levelId)
end

function RabbitWeeklyManager:flushToStorage()
    -- print('FLUSH TO')
    local user = UserManager:getInstance()
    local service = UserService:getInstance()

    local data = {}

    data.leftPlay = self.leftPlay
    data.share = self.share -- 今天分享的次数
    data.mainLevelCount = self.mainLevelCount -- 今天玩主线关卡的次数
    data.maxCountInOnePlay = self.maxCountInOnePlay -- 单关获得的最多兔子数
    data.dailyRabbits = self.dailyRabbits -- 今天获得的兔子总数
    data.passedFriendsCount = self.passedFriendsCount -- 本周单关兔子数超越的好友个数
    data.rewardFlag = self.rewardFlag -- 周一领奖标识
    data.dailyRewards = self.dailyRewards -- 当天领取过的宝箱列表
    data.shareItemCompleted = self.shareItemCompleted
    data.mainLevelItemCompleted = self.mainLevelItemCompleted
    data.rank = self.rank

    user.rabbitWeekly = data
    service.rabbitWeekly = data

    print("RabbitWeeklyManager:flushToStorage:", table.tostring(data))
    if NetworkConfig.writeLocalDataStorage then 
        -- print('DID FLUSH')
        Localhost:getInstance():flushCurrentUserData() 
    else
        -- print('DID NOT')
    end
end

function RabbitWeeklyManager:readFromStorage()
    -- print('READ FROM')
    return UserManager:getInstance().rabbitWeekly
end

function RabbitWeeklyManager:onDayChange(oldDay, curDay)
    -- print('RabbitWeeklyManager:onDayChange')

    -- print(oldDay.day, curDay.day)

    if compareDate(oldDay, curDay) ~= 0 then
        -- print('RabbitWeeklyManager day changed')
        self._dayChanged = true
        self.oldDay = oldDay
        self.curDay = curDay
    end
end

function RabbitWeeklyManager:updateOnDayChange()
    print('RabbitWeeklyManager:updateOnDayChange')

    local oldDay = self.oldDay
    local curDay = self.curDay

    assert(oldDay)
    assert(curDay)
    if not oldDay or not curDay then return end

    self._dayChanged = false

    if compareDate(oldDay, curDay) < 0 then 
        self:resetDailyData()
        self:flushToStorage()
    elseif compareDate(oldDay, curDay) > 0 then
        print('clearPlayCount')
    end

    local oldYearDay = oldDay.yday
    local newYearDay = curDay.yday
    local oldWeekDay = oldDay.wday
    local newWeekDay = curDay.wday

    -- sunday is 1, monday is 2
    local function prevTuesday(oldWeekDay, oldYearDay)
        local diff = 0
        if oldWeekDay >= 3 then 
            diff = oldWeekDay - 3
        elseif oldWeekDay <= 2 then
            diff = oldWeekDay + 7 - 3
        end
        return oldYearDay - diff
    end

    local function nextTuesday(oldWeekDay, oldYearDay)
        local diff = 0
        if oldWeekDay >= 3 then 
            diff = 10 - oldWeekDay
        elseif oldWeekDay <= 2 then
            diff = 3 - oldWeekDay
        end
        return oldYearDay + diff
    end

    local hasJumpedWeek = false
    -- print('oldWeekDay, newWeekDay', oldWeekDay, newWeekDay)
    if newYearDay - oldYearDay >= 7 then
        hasJumpedWeek = true
        -- print('hasJumpedWeek over 7 days')
    else
        if newYearDay > oldYearDay then  -- 时间向后走了
            -- print('set time forward')
            if newYearDay >= nextTuesday(oldWeekDay, oldYearDay) then
                hasJumpedWeek = true
                -- print('hasJumpedWeek from ', oldWeekDay, newWeekDay)
            end
            -- 时间向前调的，不清除
        end
    end

    if hasJumpedWeek then 
        self:resetWeeklyData()
        self:flushToStorage()
    end

    if self.levelInfoPanel and not self.levelInfoPanel.isDisposed then
        self.levelInfoPanel:update()
    end
end

function RabbitWeeklyManager:onPassLevel(rabbitCount, levelId)
    assert(type(rabbitCount) == "number")
    if rabbitCount <= 0 then return end

    self.dailyRabbits = self.dailyRabbits + rabbitCount
    if self.maxCountInOnePlay < rabbitCount then
        self.maxCountInOnePlay = rabbitCount
    end
    self:flushToStorage()

    levelId = levelId or self.levelId
    DcUtil:levelRabbitNum(levelId, rabbitCount)
    self:setGetRewardNotification()
end

function RabbitWeeklyManager:setGetRewardNotification()
    if self:canReceiveWeeklyReward() then
        LocalNotificationManager.getInstance():setWeeklyRaceRewardNotification()
    end
end

function RabbitWeeklyManager:clearPlayCount()
    self.leftPlay = 0
    self:flushToStorage()
    if self.levelInfoPanel and not self.levelInfoPanel.isDisposed then
        self.levelInfoPanel:update()
    end  
end

function RabbitWeeklyManager:resetDailyData()
    print("RabbitWeeklyManager:resetDailyData")
    self.leftPlay = 0
    self.share = 0 -- 今天分享的次数
    self.mainLevelCount = 0 -- 今天玩主线关卡的次数
    self.dailyRabbits = 0 -- 今天获得的兔子总数
    self.dailyRewards = {} -- 当天领取过的宝箱列表
    self.shareItemCompleted = false
    self.mainLevelItemCompleted = false
end

function RabbitWeeklyManager:resetWeeklyData()
    print("RabbitWeeklyManager:resetWeeklyData")

    self:resetDailyData() -- 每日数据

    self.maxCountInOnePlay = 0 -- 单关获得的最多兔子数
    self.passedFriendsCount = 0 -- 本周单关兔子数超越的好友个数
    self.rewardFlag = 0 -- 周一领奖标识
    self.rank = nil
    -- update levelId and configs
    self.levelId = self:getLevelIdForToday()
    self:updateConfigByLevelId(self.levelId)
end

function RabbitWeeklyManager:isPlayDay()
    local dayInWeek = tonumber(os.date("%w", Localhost.time() / 1000)) -- sunday is 0, monday is 1
    -- print('dayInWeek', dayInWeek)
    return dayInWeek ~= 1
end

function RabbitWeeklyManager:getLevelIdForToday()
    local config = MetaManager:getInstance().global.rabbit_week_match_levels
    local length = #config
    local startDate = os.time({year = 2013, month = 12, day = 3, hour = 0, minute = 0, second = 0})
    local today = Localhost:time() / 1000
    -- print('today', os.date(today))
    local diffDay = math.abs(today - startDate) / (24 * 3600)
    -- print('diffDay', diffDay)
    local diffWeek = math.floor(diffDay / 7)
    local levelId = config[1 + diffWeek % length]
    -- print('rabbit weekly levelId:', levelId)
    return levelId
    -- return 30001 -- test
end

function RabbitWeeklyManager:isLevelReached()
    return UserManager:getInstance().user:getTopLevelId() >= self.lowestLevel
end

function RabbitWeeklyManager:onTopLevelChange()
    if UserManager:getInstance().user:getTopLevelId() == self.lowestLevel then
        HomeScene:sharedInstance():createRabbitWeeklyButton()
    end
end

function RabbitWeeklyManager:exchangeForCoins(amount, successCallback, failCallback)
    he_log_info("not used any more!")
end

function RabbitWeeklyManager:exchangeForEnergy(amount, successCallback, failCallback)
    he_log_info("not used any more!")
end

function RabbitWeeklyManager:receiveDailyRewardBox(levelId, idx, successCallback, failCallback)
    assert(idx > 0)
    local idxInServer = idx - 1
    local function onSuccess(event)
        local dailyRewardBox = self.exchangeConfig.dailyRewardBoxes[idx]
        addReward(dailyRewardBox.items)
        table.insert(self.dailyRewards, idxInServer)
        self:flushToStorage()
        if successCallback then successCallback(event) end
        DcUtil:receiveRabbitDailyReward(levelId, idx)
    end

    local function onFail(event)
        if event and event.data then
            CommonTip:showTip(_text("error.tip."..event.data), "negative", onFail)
        end
        if failCallback then failCallback(event) end
    end

    local http = ReceiveRabbitMatchRewardsHttp.new(true)
    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    http:syncLoad(levelId, 3, idxInServer)
end

function RabbitWeeklyManager:receiveWeeklyReward(levelId, successCallback, failCallback)
    local surpassedFriendRewards, surpassedCount = self:getSurpassedFriendRewards()
    local levelMaxCountRewards, rewardLevel = self:getLevelMaxCountRewards()
    if #surpassedFriendRewards == 0 and #levelMaxCountRewards == 0 then
        CommonTip:showTip(_text("error.tip.730780"), "negative")
        if failCallback then failCallback() end
        return
    end

    local function onSuccess(event)
        addReward(surpassedFriendRewards)
        addReward(levelMaxCountRewards)
        self.rewardFlag = 1
        self:flushToStorage()
        if successCallback then successCallback(event) end

        if surpassedCount > 0 then
            DcUtil:receiveExceedReward(surpassedCount)
        end
        if rewardLevel > 0 then
            DcUtil:receiveMaxReward(rewardLevel)
        end
    end

    local function onFail(event)
        if event and event.data then
            CommonTip:showTip(_text("error.tip."..event.data), "negative", onFail)
        end
        if failCallback then failCallback(event) end
    end

    local http = ReceiveRabbitMatchRewardsHttp.new(true)
    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    http:syncLoad(levelId, 0, 0)
end

function RabbitWeeklyManager:getRemainingPlayCount()
    return self.leftPlay
end

function RabbitWeeklyManager:getDailyRabbitsCount()
    return self.dailyRabbits
end

function RabbitWeeklyManager:getSurpassedFriendCount()
    return self.passedFriendsCount
end

function RabbitWeeklyManager:getMaxCountInOnePlay()
    return self.maxCountInOnePlay
end

function RabbitWeeklyManager:setMyRank(rank)
    assert(type(rank) == "number")
    if rank > 0 then
        self.rank = rank
    else
        self.rank = nil
    end
    self:flushToStorage()
end

function RabbitWeeklyManager:getMyRank()
    return self.rank
end

function RabbitWeeklyManager:descrLeftPlayCount()
    assert(self.leftPlay > 0)

    self.leftPlay = self.leftPlay - 1
    self:flushToStorage()
end

function RabbitWeeklyManager:addLeftPlayCount(addCount)
    assert(type(addCount) == "number")
    self.leftPlay = self.leftPlay + 1
    self:flushToStorage()
end

function RabbitWeeklyManager:buyPlayCard( onSuccess, onFail, onCancel, onFinish, ignoreSecondConfirm)
    if self:getRemainingPayCount() <= 0 then
        CommonTip:showTip(_text("weekly.race.no.more.play.tip"), "negative")
        return
    end

    local function onBuyGoldFinish(evt)
        if evt and evt.target then evt.target:rma() end
        if onFinish then onFinish() end
    end

    local function onCreateGoldPanel()
        local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
        if index ~= 0 then
            local panel = createMarketPanel(index)
            panel:popout()
            panel:addEventListener(kPanelEvents.kClose, onBuyGoldFinish)
        end
    end

    local function onBuySuccess()
        print("onBuySuccess")
        self:addLeftPlayCount(1)
        onSuccess()
    end

    local function onBuyFail(errorCode)
        if type(evt) == "table" and errorCode == 730330 then -- not enough gold
            GoldlNotEnoughPanel:create(onCreateGoldPanel, onCancel):popout()
        else
            if __ANDROID then -- ANDROID
                CommonTip:showTip(_text("add.step.panel.buy.fail.android"), "negative", onFail)
            else -- else, onIOS and PC we use gold!
                CommonTip:showTip(_text("error.tip."..errorCode), "negative", onFail)
            end
        end
    end

    local function onBuyCancel()
        -- print("onBuyCancel")
        if onCancel then onCancel() end
    end
    if __ANDROID then -- ANDROID
        if PaymentManager.getInstance():checkCanWindMillPay(RabbitWeeklyManager.playCardGoodsId) then
            local function successCallback()
                self:addLeftPlayCount(1)
                if onSuccess then onSuccess() end
            end
            local function failCallback()
                if onFail then onFail() end
            end
            local function cancelCallback()
                if onCancel then onCancel() end
            end
            local function updateFunc()
                if onFinish then onFinish() end
            end

            self.dcAndroidInfo = DCWindmillObject:create()
            self.dcAndroidInfo:setGoodsId(RabbitWeeklyManager.playCardGoodsId)
            PaymentDCUtil.getInstance():sendAndroidWindMillPayStart(self.dcAndroidInfo)

            local logic = WMBBuyItemLogic:create()
            local buyLogic = BuyLogic:create(RabbitWeeklyManager.playCardGoodsId, 2)
            buyLogic:getPrice()
            logic:buy(RabbitWeeklyManager.playCardGoodsId, 1, self.dcAndroidInfo, buyLogic, successCallback, failCallback, cancelCallback, updateFunc)
        else 
            local logic = IngamePaymentLogic:create(RabbitWeeklyManager.playCardGoodsId)
            if ignoreSecondConfirm then
                logic:ignoreSecondConfirm(true)
            end
            logic:buy(onBuySuccess, onBuyFail, onBuyCancel)
        end
    else -- else, on IOS and PC we use gold!
    	local function onUserHasLogin()
    		local logic = BuyLogic:create(RabbitWeeklyManager.playCardGoodsId, 2)
            logic:getPrice()
            logic:start(1, onBuySuccess, onBuyFail)
    	end
        onUserHasLogin()
    	-- RequireNetworkAlert:callFuncWithLogged(onUserHasLogin)
    end
end

function RabbitWeeklyManager:rmbBuyPlayCard(successCallback, failCallback)
    if self:getRemainingPayCount() <= 0 then
        CommonTip:showTip(_text("weekly.race.no.more.play.tip"), "negative")
        if failCallback then failCallback() end
        return
    end

    local function onSuccess()
        self:addLeftPlayCount(1)
        if successCallback then successCallback() end
    end

    local function onFail()
        CommonTip:showTip(_text("buy.gold.panel.err.undefined"), "negative")
        if failCallback then failCallback() end
    end

    local data = IapBuyPropLogic:rabbitWeeklyPlayCard()
    IapBuyPropLogic:buy(data, onSuccess, onFail)
end

function RabbitWeeklyManager:getRemainingPayCount()
    local maxBuyCount = self:getMaxBuyCount()
    print("getRemainingPayCount maxBuyCount", maxBuyCount)
    if maxBuyCount <= 0 then return 1 end -- 没有限制

    local bought = UserManager:getInstance():getDailyBoughtGoodsNumById(RabbitWeeklyManager.playCardGoodsId)
    print("getRemainingPayCount bought", bought)
    return maxBuyCount - bought
end

function RabbitWeeklyManager:getMaxBuyCount()
    local meta = MetaManager:getInstance():getGoodMeta(RabbitWeeklyManager.playCardGoodsId)
    assert(meta)
    return meta.limit
end

function RabbitWeeklyManager:hasReceivedWeeklyReward()
    return self.rewardFlag > 0
end

function RabbitWeeklyManager:canReceiveWeeklyReward()
    if self:hasReceivedWeeklyReward() then
        return false
    end

    local surpassedFriendRewards = self:getSurpassedFriendRewards()
    local levelMaxCountRewards = self:getLevelMaxCountRewards()
    if #surpassedFriendRewards == 0 and #levelMaxCountRewards == 0 then -- 没有任何奖励
        return false 
    end
    return true
end

function RabbitWeeklyManager:getSurpassedFriendRewards()
    local reward = {}
    local count = self.passedFriendsCount
    if self.passedFriendsCount > 0 then
        for k, v in pairs(self.surpassReward) do
            if self.passedFriendsCount > self.surpassLimit then self.passedFriendsCount = self.surpassLimit end
            merge(reward, {itemId = v.itemId, num = v.num * self.passedFriendsCount})
        end
    end
    return reward, count
end

function RabbitWeeklyManager:getLevelMaxCountRewards()
    local maxRewardLevel = 5

    -- calc reward level
    local rewardLevel = 0
    for lv=1,maxRewardLevel do
        if self.maxCountInOnePlay >= self.gemRewardConfig["gems"..lv] then
            rewardLevel = lv
        else
            break
        end
    end
    -- get rewards by rewardLevel
    local reward = {}
    if rewardLevel > 0 then
        local rewardsByLevel = self.gemRewardConfig["reward"..rewardLevel]
        assert(rewardLevel, "reward config should not be nil")
        for k, v in pairs(rewardsByLevel) do 
            merge(reward, {itemId = v.itemId, num = v.num})
        end
    end
    return reward, rewardLevel
end

function RabbitWeeklyManager:getRewardConfig()
    local reward = {}
    local rewardLevel = nil
    local hasSurpassReward = false

    for k, v in pairs(self.surpassReward) do
        local realSurpassCount  =  self.passedFriendsCount
        if realSurpassCount > self.surpassLimit then realSurpassCount = self.surpassLimit end
        if realSurpassCount > 0 then
            merge(reward, {itemId = v.itemId, num = v.num * realSurpassCount})
            hasSurpassReward = true
        end
    end

    if self.maxCountInOnePlay < self.gemRewardConfig.gems1 then
        -- do nothing
    elseif self.maxCountInOnePlay >= self.gemRewardConfig.gems1 and self.maxCountInOnePlay < self.gemRewardConfig.gems2 then
        for k, v in pairs(self.gemRewardConfig.reward1) do 
            merge(reward, {itemId = v.itemId, num = v.num})
        end
        rewardLevel = 1
    elseif self.maxCountInOnePlay >=self.gemRewardConfig.gems2 and self.maxCountInOnePlay < self.gemRewardConfig.gems3 then 
        for k, v in pairs(self.gemRewardConfig.reward2) do 
            merge(reward, {itemId = v.itemId, num = v.num})
        end
        rewardLevel = 2
    elseif self.maxCountInOnePlay >=self.gemRewardConfig.gems3 and self.maxCountInOnePlay < self.gemRewardConfig.gems4 then 
        for k, v in pairs(self.gemRewardConfig.reward3) do 
            merge(reward, {itemId = v.itemId, num = v.num})
        end
        rewardLevel = 3
    elseif self.maxCountInOnePlay >=self.gemRewardConfig.gems4 and self.maxCountInOnePlay < self.gemRewardConfig.gems5 then 
        for k, v in pairs(self.gemRewardConfig.reward4) do 
            merge(reward, {itemId = v.itemId, num = v.num})
        end
        rewardLevel = 4
    else
        for k, v in pairs(self.gemRewardConfig.reward5) do 
            merge(reward, {itemId = v.itemId, num = v.num})
        end
        rewardLevel = 5
    end

    return reward, hasSurpassReward, rewardLevel
end

function RabbitWeeklyManager:getNextRewardConfig(type)
    local reward = {}
    local nextRewardRabbitCount = 0
    if type == 1 then
        for k, v in pairs(self.surpassReward) do
            merge(reward, {itemId = v.itemId, num = v.num})
        end
        return reward, nextRewardRabbitCount
    else
        for k, v in pairs(self.surpassReward) do
            local realSurpassCount  =  self.passedFriendsCount
            if realSurpassCount > self.surpassLimit then realSurpassCount = self.surpassLimit end
            merge(reward, {itemId = v.itemId, num = v.num * realSurpassCount})
        end

        if self.maxCountInOnePlay < self.gemRewardConfig.gems1 then
            for k, v in pairs(self.gemRewardConfig.reward1) do 
                merge(reward, {itemId = v.itemId, num = v.num})
            end
            nextRewardRabbitCount = self.gemRewardConfig.gems1
        elseif self.maxCountInOnePlay >= self.gemRewardConfig.gems1 and self.maxCountInOnePlay < self.gemRewardConfig.gems2 then
            for k, v in pairs(self.gemRewardConfig.reward2) do 
                merge(reward, {itemId = v.itemId, num = v.num})
            end
            nextRewardRabbitCount = self.gemRewardConfig.gems2
        elseif self.maxCountInOnePlay >=self.gemRewardConfig.gems2 and self.maxCountInOnePlay < self.gemRewardConfig.gems3 then 
            for k, v in pairs(self.gemRewardConfig.reward3) do 
                merge(reward, {itemId = v.itemId, num = v.num})
            end
            nextRewardRabbitCount = self.gemRewardConfig.gems3
        elseif self.maxCountInOnePlay >=self.gemRewardConfig.gems3 and self.maxCountInOnePlay < self.gemRewardConfig.gems4 then 
            for k, v in pairs(self.gemRewardConfig.reward4) do 
                merge(reward, {itemId = v.itemId, num = v.num})
            end
            nextRewardRabbitCount = self.gemRewardConfig.gems4
        elseif self.maxCountInOnePlay >=self.gemRewardConfig.gems4 and self.maxCountInOnePlay < self.gemRewardConfig.gems5 then 
            for k, v in pairs(self.gemRewardConfig.reward5) do 
                merge(reward, {itemId = v.itemId, num = v.num})
            end
            nextRewardRabbitCount = self.gemRewardConfig.gems5
        else
            return nil, nil
        end

        return reward, nextRewardRabbitCount
    end  
end

function RabbitWeeklyManager:isNeedShowTimeWarnPanel()
    return not self:isTimeWarningDisabled() and self:isTimeNotEnough()
end

-- 时间晚于当日23:30时，首先弹出提示面板
function RabbitWeeklyManager:isTimeNotEnough()
    local currentTime = math.ceil(Localhost:time()/1000)
    local currentDate = os.date("*t", currentTime)
    if currentDate.hour >= 23 and currentDate.min >= 30 then
        return true
    end
    return false
end

function RabbitWeeklyManager:isTimeWarningDisabled()
    return CCUserDefault:sharedUserDefault():getBoolForKey("game.weekly.rabbit.timewarning")
end

function RabbitWeeklyManager:setTimeWarningDisabled(isEnable)
    if isEnable ~= true then isEnable = false end
    CCUserDefault:sharedUserDefault():setBoolForKey("game.weekly.rabbit.timewarning", isEnable)
    CCUserDefault:sharedUserDefault():flush()
end

