
WeeklyRaceRankListCacheRankType = {
    SERVER  = 1,
    FRIEND  = 2
}

WeeklyRaceRankListCache = class()

function WeeklyRaceRankListCache:init(levelId, onCachedDataChange, playAnimation)


    self.friendRankList = {}
    self.isAllreadyGetAllFriendRankData = false

    self.levelId = levelId
    self.onCachedDataChange = onCachedDataChange
    self.playAnimation = playAnimation
end

function WeeklyRaceRankListCache:getCurCachedRankListLength()
    return #self.friendRankList

end

function WeeklyRaceRankListCache:isAllreadyGetAllRankData()
    return self.isAllreadyGetAllFriendRankData
end

function WeeklyRaceRankListCache:getCurCachedFriendRankList(rankIndex)
    local result = self.friendRankList[rankIndex]

    if result then
        return result
    end
    return nil
end

function WeeklyRaceRankListCache:getCurCachedRankList(rankType, rankIndex)
    return self:getCurCachedFriendRankList(rankIndex)
end

function WeeklyRaceRankListCache:loadInitialData()
    self:sendGetLevelTopMessage()       -- Friend
end

function WeeklyRaceRankListCache:setGetFriendRankFailedCallback(callback)
    self.getFriendRankFailedCallback = callback
end

function WeeklyRaceRankListCache:loadInitialFriendRank()
    self:sendGetLevelTopMessage()       -- Friend
end

function WeeklyRaceRankListCache:sendGetLevelTopMessage()

    if self.isAllreadyGetAllFriendRankData then
        return
    end

    local function onSuccess(event)
 
        local scores = event.data.rankList

        -- print(table.tostring(scores))

        self.isAllreadyGetAllFriendRankData = true

        local userUID = tostring(UserManager.getInstance().uid)
        local hasMyData = false
        local myScore = WeeklyRaceManager:sharedInstance():getMaxDigCountInOnePlay()
        for k, v in pairs(scores) do 
            if tonumber(v.uid) == tonumber(userUID) then
                v.score = myScore
                hasMyData = true
            end
        end

        -- 没有我的排行，但是我达到了上榜条件
        if not hasMyData and myScore >= 20 then
            -- rank and levelId are useless
            table.insert(scores, {uid = userUID, score = myScore, rank = 0, levelId = 0})
        end



        local function sort(item1, item2)
            return item1.score > item2.score
        end

        table.sort(scores, sort)


        -------------
        --- Sort Data
        -----------
        self.friendRankList = {}

        local oldRank = WeeklyRaceManager:sharedInstance():getMyRank()
        local newRank = -1

        for k,v in pairs(scores) do
            local profile = FriendManager.getInstance().friends[tostring(v.uid)]
            local userData = {uid = v.uid, score = v.score}
            if profile then
                userData.name = profile.name
                userData.headUrl = profile.headUrl
            else 
                print('sendGetLevelTopMessage, not friend data')
                userData.name = 'ID: '..userData.uid
                userData.headUrl = 1
            end
            if v.uid == userUID then
                print('my self!!!!')
                profile = UserManager.getInstance().profile
                userData.name = profile:getDisplayName()
                userData.headUrl = profile.headUrl
                newRank = k -- set new rank
                WeeklyRaceManager:sharedInstance():setMyRank(newRank)
            end
            table.insert(self.friendRankList, userData)
        end



        print('rank list')
        print('old rank', oldRank, 'new rank', newRank)

        local surpassedFriend = self.friendRankList[newRank+1] -- could be nil
        self.onCachedDataChange(oldRank, newRank, surpassedFriend)
    end

    local function onFail(event)
        he_log_warning("WeeklyRaceRankListCache:sendGetLevelTopMessage failed !")
        if self.getFriendRankFailedCallback then
            self.getFriendRankFailedCallback()
        end
    end

    local http = GetCommonRankListHttp.new()
    http:addEventListener(Events.kComplete, onSuccess)
    http:addEventListener(Events.kError, onFail)
    http:load(1, 1, self.levelId)

end

function WeeklyRaceRankListCache:create(levelId, onCachedDataChange, playAnimation)


    local cache = WeeklyRaceRankListCache.new()
    cache:init(levelId, onCachedDataChange, playAnimation)

    return cache
end
