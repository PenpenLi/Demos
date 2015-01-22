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
        self.leftPlay = self.leftPlay + self.extraConfig.freePlayByMainLevel
    end
    self:flushToStorage()
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
    scene:addChild(animation)

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
    http:load(levelId, 3, idxInServer)
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
    http:load(levelId, 0, 0)
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

function RabbitWeeklyManager:buyPlayCard( onSuccess, onFail, onCancel, onFinish )
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

    local function onBuyFail( evt )
        -- print("onBuyFail")
        if type(evt) == "table" and evt.data == 730330 then -- not enough gold
            local text = {
                tip = Localization:getInstance():getText("buy.prop.panel.tips.no.enough.cash"),
                yes = Localization:getInstance():getText("buy.prop.panel.yes.buy.btn"),
                no = Localization:getInstance():getText("buy.prop.panel.not.buy.btn"),
            }
            CommonTipWithBtn:showTip(text, "negative", onCreateGoldPanel, onCancel)
        else
            if __ANDROID then -- ANDROID
                CommonTip:showTip(_text("add.step.panel.buy.fail.android"), "negative", onFail)
            else -- else, onIOS and PC we use gold!
                CommonTip:showTip(_text("error.tip."..evt.data), "negative", onFail)
            end
        end
    end

    local function onBuyCancel()
        -- print("onBuyCancel")
        if onCancel then onCancel() end
    end
    if __ANDROID then -- ANDROID
        local logic = IngamePaymentLogic:create(RabbitWeeklyManager.playCardGoodsId)
        logic:buy(onBuySuccess, onBuyFail, onBuyCancel)
    else -- else, on IOS and PC we use gold!
        if RequireNetworkAlert:popout() then
            local logic = BuyLogic:create(RabbitWeeklyManager.playCardGoodsId, 2)
            logic:getPrice()
            logic:start(1, onBuySuccess, onBuyFail)
        end
    end
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

