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
    local user = UserManager:getInstance().user
    for k, v in pairs(reward) do 
        if v.itemId == ItemType.COIN then
            user:setCoin(user:getCoin() + v.num)
            UserService:getInstance().user:setCoin(UserService:getInstance().user:getCoin() + v.num)
        else
            UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
            UserService:getInstance():addUserPropNumber(v.itemId, v.num)
        end
    end
end

WeeklyRaceManager = class()

local instance = nil
function WeeklyRaceManager:sharedInstance()
    if not instance then 
        instance = WeeklyRaceManager.new()
        instance:init()
    end

    return instance
end

function WeeklyRaceManager:init()

    local levelId = self:getLevelIdForToday()

    local meta = MetaManager:getInstance()
    self.dailyLimitConfig = meta.weekly_race_daily_limit
    self.exchangeConfig = meta.weekly_race_exchange
    self.gemRewardConfig = meta.weekly_race_gem_reward

    for k, v in pairs(meta.weekly_race_exchange) do 
        if v.levelId == levelId then
            self.exchangeConfig = v
        end
    end

    for k, v in pairs(meta.weekly_race_gem_reward) do 
        if v.levelId == levelId then
            self.gemRewardConfig = v
        end
    end

    self.playCount = 0
    self._hasReceivedReward1 = false
    self._hasReceivedReward2 = false
    self.totalGemCount = 0
    self.remainingGemCount = 0
    self.usedLimitForCoins = 0
    self.usedLimitForEnergy = 0
    self.maxDigInOnePlay = 0
    self.surpassedFirendCount = 0
    self.rank = 1

    -- consts
    self.lowestLevel = self.dailyLimitConfig[1].lowLevel
    self.surpassLimit = self.exchangeConfig.surpassLimit
    self.limitForCoins = self.exchangeConfig.coinExchangeLimit
    self.limitForEnergy = self.exchangeConfig.energyExchangeLimit
    self.coinExchangeRatio = self.exchangeConfig.coinExchangeRatio
    self.energyExchangeRatio = self.exchangeConfig.energyExchangeRatio
    self.surpassReward = self.exchangeConfig.surpassReward

    if not self:readFromStorage() then print('*********^^^^^^^^^^^ flushToStorage') self:flushToStorage() end
end

function WeeklyRaceManager:loadData(successCallback)
    local function onInitialized()
        self:showTipForFirstLogin()
        if successCallback then successCallback() end
    end

    local function onSuccess(event)

        self._isInitialized = true
        local data = event.data.datas
        -- print(table.tostring(data))
        local flag = tonumber(data.rewardFlag)
        self.playCount = tonumber(data.dailyCount)
        self.totalGemCount = tonumber(data.totalGems)
        self.remainingGemCount = tonumber(data.leftGems)
        -- self.remainingGemCount = 30
        self.maxDigInOnePlay = tonumber(data.maxGemsOfLevel)
        self.surpassedFirendCount = tonumber(data.passedFriendsCount)
        self._hasReceivedReward1 = isFlagBitSet(flag, 1)
        self._hasReceivedReward2 = isFlagBitSet(flag, 2)

        local exchangeRecord = {}
        for k, v in pairs(data.exchangeRecord) do 
            local key = tonumber(v.key)
            local value = tonumber(v.value)
            exchangeRecord[key] = value
        end

        self.usedLimitForCoins = tonumber(exchangeRecord[1]) or 0
        self.usedLimitForEnergy = tonumber(exchangeRecord[2]) or 0

        self:flushToStorage()
        onInitialized()

    end

    local function onFail(event)
        print('WeeklyRaceManager:loadData() Fail')
        if tonumber(event.data) == 203 then -- sync failed
            return 
        end


        self._isInitialized = true
        local data = self:readFromStorage()
        if not data then return end
        self.playCount = tonumber(data.playCount)
        self.totalGemCount = tonumber(data.totalGemCount)
        self.remainingGemCount = tonumber(data.remainingGemCount)
        self.usedLimitForCoins = tonumber(data.usedLimitForCoins)
        self.usedLimitForEnergy = tonumber(data.usedLimitForEnergy)
        self.maxDigInOnePlay = tonumber(data.maxDigInOnePlay)
        self.surpassedFirendCount = tonumber(data.surpassedFirendCount)
        self._hasReceivedReward1 = data._hasReceivedReward1
        self._hasReceivedReward2 = data._hasReceivedReward2

        
        if self._dayChanged == true then
            self:updateOnDayChange()
        end

        onInitialized()
    end

    local http = GetWeekMatchDataHttp.new(true)
    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    http:syncLoad()
end

function WeeklyRaceManager:onDayChange(oldDay, curDay)
    print('WeeklyRaceManager:onDayChange')

    print(oldDay.day, curDay.day)

    if compareDate(oldDay, curDay) ~= 0 then
        print('WeeklyRaceManager day changed')
        self._dayChanged = true
        self.oldDay = oldDay
        self.curDay = curDay
    end
end

function WeeklyRaceManager:updateOnDayChange()
    print('WeeklyRaceManager:updateOnDayChange')

    local oldDay = self.oldDay
    local curDay = self.curDay

    assert(oldDay)
    assert(curDay)
    if not oldDay or not curDay then return end

    self._dayChanged = false

    if compareDate(oldDay, curDay) < 0 then 
        print('clearPlayCount')
        self:clearPlayCount()
    elseif compareDate(oldDay, curDay) > 0 then
        print(' self.playCount = self:getMaxPlayCount()')
        self.playCount = self:getMaxPlayCount()
        self:flushToStorage()
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
        print('hasJumpedWeek over 7 days')
    else
        if newYearDay > oldYearDay then  -- 时间向后走了
            -- print('set time forward')
            if newYearDay >= nextTuesday(oldWeekDay, oldYearDay) then
                hasJumpedWeek = true
                print('hasJumpedWeek from ', oldWeekDay, newWeekDay)
            end
            -- 时间向前调的，不清除
        end
    end

    if hasJumpedWeek then 
        self:clearWeeklyData()
    end

end

function WeeklyRaceManager:onPassLevel(digGemCount)
    self.totalGemCount = self.totalGemCount + digGemCount
    self.remainingGemCount = self.remainingGemCount + digGemCount
    if digGemCount and self.maxDigInOnePlay < digGemCount then
        self.maxDigInOnePlay = digGemCount
    end
    self:flushToStorage()
    self:setGetRewardNotification()
end

function WeeklyRaceManager:setGetRewardNotification()
    if self:canReceiveReward1() or self:canReceiveReward2() then
        LocalNotificationManager.getInstance():setWeeklyRaceRewardNotification()
    end
end

function WeeklyRaceManager:clearPlayCount()
    print('WeeklyRaceManager:clearPlayCount()')
    self.playCount = 0
    self:flushToStorage()
end

function WeeklyRaceManager:clearWeeklyData()
    print('WeeklyRaceManager:clearWeeklyData()')
    self.playCount = 0
    self.totalGemCount = 0
    self.remainingGemCount = 0
    self.usedLimitForCoins = 0
    self.usedLimitForEnergy = 0
    self.maxDigInOnePlay = 0
    self.surpassedFirendCount = 0
    self._hasReceivedReward1 = false
    self._hasReceivedReward2 = false
    self:flushToStorage()
end

function WeeklyRaceManager:setMyRank(rank)
    self.myRank = rank
    self:flushToStorage()
end

function WeeklyRaceManager:getMyRank()
    return self.myRank
end

function WeeklyRaceManager:setLevelInfoPanel(panel)
    self.levelInfoPanel = panel
end

function WeeklyRaceManager:addPlayCount()
    self.playCount = self.playCount + 1
    self:flushToStorage()
end

function WeeklyRaceManager:shouldShowButton()
    return UserManager:getInstance().user.topLevelId >= self.lowestLevel
end

function WeeklyRaceManager:getMaxPlayCount()
    local topLevelId = UserManager:getInstance().user.topLevelId

    for k, v in pairs(self.dailyLimitConfig) do 
        if topLevelId >= v.lowLevel and topLevelId <= v.highLevel then
            return v.dailyLimit
        end
    end
    return 0
end

function WeeklyRaceManager:getRemainingPlayCount()
    return self:getMaxPlayCount() - self.playCount
    -- return 5
end

function WeeklyRaceManager:canReceiveReward1()
    return self.surpassedFirendCount > 0
end

function WeeklyRaceManager:canReceiveReward2()
    return self.maxDigInOnePlay >= self.gemRewardConfig.gems1
end

function WeeklyRaceManager:hasReceivedReward1()
    return self._hasReceivedReward1
end

function WeeklyRaceManager:hasReceivedReward2()
    return self._hasReceivedReward2
end

function WeeklyRaceManager:receiveReward1(successCallback, failCallback)

    local function onSuccess(event)
        self._hasReceivedReward1 = true
        local reward = self:getRewardConfig(1)
        addReward(reward)
        self:flushToStorage()
        if successCallback then successCallback(event) end
    end

    local function onFail(event)
        if failCallback then failCallback(event) end
    end

    local rewardId = 0
    local http = ReceiveWeekMatchRewardsHttp.new(true)
    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    http:load(rewardId, self:getLevelIdForToday())

    LocalNotificationManager.getInstance():cancelWeeklyRaceRewardNotification()
end

function WeeklyRaceManager:receiveReward2(successCallback, failCallback)

    local function onSuccess(event)
        self._hasReceivedReward2 = true
        local reward = self:getRewardConfig(2)
        addReward(reward)
        self:flushToStorage()
        if successCallback then successCallback(event) end
    end

    local function onFail(event)
        if failCallback then failCallback(event) end
    end

    local rewardId = 1
    local http = ReceiveWeekMatchRewardsHttp.new(true)
    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    http:load(rewardId, self:getLevelIdForToday())
    
    LocalNotificationManager.getInstance():cancelWeeklyRaceRewardNotification()
end

function WeeklyRaceManager:exchangeForCoins(amount, successCallback, failCallback)

    local usedGemCount = self:getCoinExchangeRatio() * amount

    -- pre-decrease counters to prevent excesive requests
    self.remainingGemCount = self.remainingGemCount - usedGemCount
    self.usedLimitForCoins = self.usedLimitForCoins + 1

    local function onSuccess(event)
        -- update counters
        self.usedLimitForCoins = tonumber(event.data.exchanged)
        self.remainingGemCount = tonumber(event.data.leftGems)
        local reward = {{itemId = ItemType.COIN, num = amount * 1000}}
        addReward(reward)
        if successCallback then successCallback(event) end
        self:flushToStorage()
    end

    local function onFail(event)
        -- recover counters
        self.remainingGemCount = self.remainingGemCount + usedGemCount
        self.usedLimitForCoins = self.usedLimitForCoins - 1
        if failCallback then failCallback(event) end
    end

    local rewardId = 1
    local number = amount
    local http = ExchangeWeekMatchItemsHttp.new(true)
    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    http:load(rewardId, amount, self:getLevelIdForToday())
end

function WeeklyRaceManager:exchangeForEnergy(amount, successCallback, failCallback)

    local usedGemCount = self:getEnergyExchangeRation() * amount

    -- pre-decrease counters to prevent excesive requests
    self.remainingGemCount = self.remainingGemCount - usedGemCount
    self.usedLimitForEnergy = self.usedLimitForEnergy + 1

    local function onSuccess(event)

        -- update counters
        self.usedLimitForEnergy = tonumber(event.data.exchanged)
        self.remainingGemCount = tonumber(event.data.leftGems)
        local reward = {{itemId = ItemType.SMALL_ENERGY_BOTTLE, num = amount}}
        addReward(reward)
        if successCallback then successCallback(event) end
        self:flushToStorage()
    end

    local function onFail(event)

        -- recover counters
        self.remainingGemCount = self.remainingGemCount + usedGemCount
        self.usedLimitForEnergy = self.usedLimitForEnergy - 1
        if failCallback then failCallback(event) end
    end

    local rewardId = 2
    local number = amount
    local http = ExchangeWeekMatchItemsHttp.new(true)
    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    http:load(rewardId, amount, self:getLevelIdForToday())
end

function WeeklyRaceManager:getCoinExchangeRatio()
    return self.coinExchangeRatio
end

function WeeklyRaceManager:getEnergyExchangeRation()
    return self.energyExchangeRatio
end

function WeeklyRaceManager:getTotalGemCount()
    return self.totalGemCount
end

function WeeklyRaceManager:getRemainingGemCount()
    return self.remainingGemCount
end

function WeeklyRaceManager:getSurpassedFriendCount()
    return self.surpassedFirendCount
end

function WeeklyRaceManager:getLimitForCoins()
    return self.limitForCoins - self.usedLimitForCoins
end

function WeeklyRaceManager:getLimitForEnergy()
    return self.limitForEnergy - self.usedLimitForEnergy
end

function WeeklyRaceManager:getMaxDigCountInOnePlay()
    return self.maxDigInOnePlay
end

function WeeklyRaceManager:getRewardConfig(id)
    local reward = {}
    if id == 1 then 
        if not self:canReceiveReward1() then return reward end
        for k, v in pairs(self.surpassReward) do
            local realSurpassCount  =  self.surpassedFirendCount
            if realSurpassCount > self.surpassLimit then realSurpassCount = self.surpassLimit end
            table.insert(reward, {itemId = v.itemId, num = v.num * realSurpassCount})
        end
    elseif id == 2 then
        if not self:canReceiveReward2() then return reward end

        if self.maxDigInOnePlay < self.gemRewardConfig.gems1 then
            reward = {}
        elseif self.maxDigInOnePlay >= self.gemRewardConfig.gems1 and self.maxDigInOnePlay < self.gemRewardConfig.gems2 then
            for k, v in pairs(self.gemRewardConfig.reward1) do 
                table.insert(reward, {itemId = v.itemId, num = v.num})
            end
        elseif self.maxDigInOnePlay >=self.gemRewardConfig.gems2 and self.maxDigInOnePlay < self.gemRewardConfig.gems3 then 
            for k, v in pairs(self.gemRewardConfig.reward2) do 
                table.insert(reward, {itemId = v.itemId, num = v.num})
            end
        elseif self.maxDigInOnePlay >=self.gemRewardConfig.gems3 and self.maxDigInOnePlay < self.gemRewardConfig.gems4 then 
            for k, v in pairs(self.gemRewardConfig.reward3) do 
                table.insert(reward, {itemId = v.itemId, num = v.num})
            end
        elseif self.maxDigInOnePlay >=self.gemRewardConfig.gems4 and self.maxDigInOnePlay < self.gemRewardConfig.gems5 then 
            for k, v in pairs(self.gemRewardConfig.reward4) do 
                table.insert(reward, {itemId = v.itemId, num = v.num})
            end
        else
            for k, v in pairs(self.gemRewardConfig.reward5) do 
                table.insert(reward, {itemId = v.itemId, num = v.num})
            end
        end
    end
    return reward
end

function WeeklyRaceManager:isPlayDay()
    local dayInWeek = tonumber(os.date("%w", Localhost.time() / 1000)) -- sunday is 0, monday is 1
    -- print('dayInWeek', dayInWeek)
    return dayInWeek ~= 1
    -- return true -- test
end

function WeeklyRaceManager:flushToStorage()
    -- print('FLUSH TO')
    local user = UserManager:getInstance()
    local service = UserService:getInstance()

    local data = {}

    data.playCount = self.playCount
    data.totalGemCount = self.totalGemCount
    data.remainingGemCount = self.remainingGemCount
    data.usedLimitForCoins = self.usedLimitForCoins
    data.usedLimitForEnergy = self.usedLimitForEnergy
    data.maxDigInOnePlay = self.maxDigInOnePlay
    data.surpassedFirendCount = self.surpassedFirendCount
    data._hasReceivedReward1 = self._hasReceivedReward1
    data._hasReceivedReward2 = self._hasReceivedReward2
    data.rank = self.rank

    user.weekMatch = data
    service.weekMatch = data
    print('WeeklyRaceManager:flushToStorage()', table.tostring(service.weekMatch))
    if NetworkConfig.writeLocalDataStorage then 
        print('DID FLUSH')
        Localhost:getInstance():flushCurrentUserData() 
    else
        print('DID NOT')
    end
end

function WeeklyRaceManager:readFromStorage()
    -- print('READ FROM')
    -- print(table.tostring(UserService:getInstance().weekMatch))
    -- print(table.tostring(UserManager:getInstance().weekMatch))
    return UserManager:getInstance().weekMatch
end

function WeeklyRaceManager:getLevelIdForToday()
    local config = MetaManager:getInstance().global.week_match_levels
    local length = #config
    local startDate = os.time({year = 2014, month = 6, day = 30, hour = 0, minute = 0, second = 0})
    local today = Localhost:time() / 1000
    print('today', os.date(today))
    local diffDay = math.abs(today - startDate) / (24 * 3600)
    print('diffDay', diffDay)
    local diffWeek = math.floor(diffDay / 7)
    local levelId = config[1 + diffWeek % length]
    print('levelId', levelId)
    return levelId
end

function WeeklyRaceManager:showTipForFirstLogin()

    if not self:isLevelReached() then return end

    local date = os.date('*t', Localhost:time() / 1000)
    local dateKey = string.format('%d.%d.%d.racetip', date.year, date.month, date.day)
    print(dateKey)
    local hasKey = CCUserDefault:sharedUserDefault():getBoolForKey(dateKey)
    if hasKey then return end    
    local tipKey
    local showTip = true
    if self:isPlayDay() then
        tipKey = 'weekly.race.tip1'
    else
        tipKey = 'weekly.race.tip2'
        if not self:canReceiveReward1() and not self:canReceiveReward2() then
            showTip = false
        elseif self:hasReceivedReward1() or self:hasReceivedReward2() then
            showTip = false
        end
    end

    if not showTip then return end

    CCUserDefault:sharedUserDefault():setBoolForKey(dateKey, true)
    local btn = HomeScene:sharedInstance().weeklyRaceBtn
    if btn then 
        btn:showTip(_text(tipKey))
    end

end

function WeeklyRaceManager:isLevelReached()
    return UserManager:getInstance().user:getTopLevelId() >= self.lowestLevel
end

function WeeklyRaceManager:onTopLevelChange()
    if UserManager:getInstance().user:getTopLevelId() == self.lowestLevel then
        HomeScene:sharedInstance():createWeeklyRaceButton()
    end
end