require "zoo.panel.component.startGamePanel.rankList.RankListItem"
require "zoo.panel.component.startGamePanel.rankList.RankListCache"
require "hecore.ui.TableView"
require "zoo.panel.component.startGamePanel.rankList.RankListButton"
require "zoo.panel.component.startGamePanel.rankList.GetMoreButton"
require "zoo.panel.rabbitWeekly.RabbitWeeklyRankListCache"
require "zoo.panel.rabbitWeekly.MyRewardPanel"
require "zoo.panel.weeklyRace.WeeklyRaceRankAnimation"

-- short hand function
local function _text(key, replace)
    return Localization:getInstance():getText(key, replace)
end

local function _mgr() return RabbitWeeklyManager:sharedInstance() end

--------------------------------------------
-----   Rank List Table View Render
---------------------------------------------

RabbitWeeklyRankListTableViewRender = class(TableViewRenderer)

function RabbitWeeklyRankListTableViewRender:init(rankListDataCache, cacheRankType)
    assert(rankListDataCache)
    assert(cacheRankType)
    RankListCacheRankType.checkRankType(cacheRankType)
    assert(#{} == 0)

    self.rankListDataCache  = rankListDataCache
    self.cacheRankType  = cacheRankType

    self.rankListItems = {}
end
function RabbitWeeklyRankListTableViewRender:dispose(  )
    if not self.isDisposed then
        for k,v in pairs(self.rankListItems) do
            v:dispose()
        end
        self.isDisposed = true
    end
end


function RabbitWeeklyRankListTableViewRender:create(rankListDataCache, cacheRankType, width, height)


    local render = RabbitWeeklyRankListTableViewRender.new(width, height)
    render:init(rankListDataCache, cacheRankType)
    return render
end

function RabbitWeeklyRankListTableViewRender:buildCell(cell, index)
    assert(cell)
    assert(type(index) == "number")
    assert(#{} == 0)

    local numberOfCells = self:numberOfCells()
    local rankListItemRes   = false

    rankListItemRes     = ResourceManager:sharedInstance():buildGroup("rabbitWeeklyRankListItem")
    local rankListItem  = RankListItem:create(rankListItemRes)
    self.rankListItems[index + 1] = rankListItem

    local rankListItemHeight = 80
    rankListItem:setPosition(ccp(0, rankListItemHeight))
    cell.refCocosObj:addChild(rankListItem.refCocosObj)

    rankListItem:releaseCocosObj()
end

function RabbitWeeklyRankListTableViewRender:getContentSize(tableView, index)
    assert(tableView)
    assert(type(index) == "number")
    assert(#{} == 0)

    local numberOfCells = self:numberOfCells()
    return CCSizeMake(self.width, self.height)
end

function RabbitWeeklyRankListTableViewRender:setData(rawCocosObj, index)
    assert(rawCocosObj)
    assert(index)
    assert(#{} == 0)
    if self.isDisposed then return end

    index = index + 1

    -- Get RankListItem To Set Data
    local rankListItemToControl = self.rankListItems[index]
    assert(rankListItemToControl)

    -- Get Data, And Update View
    local data = self.rankListDataCache:getCurCachedRankList(self.cacheRankType, index)
    assert(data)
    local userName = data.name
    if userName == nil or data.name == "" then userName = tostring(data.uid) end
    rankListItemToControl:setData(index, userName, data.score, data.headUrl)
end

function RabbitWeeklyRankListTableViewRender:numberOfCells()
    assert(#{} == 0)

    local cachedDataLength = self.rankListDataCache:getCurCachedRankListLength(self.cacheRankType)
    return cachedDataLength
end


---------------------------------------------------
-------------- RabbitWeeklyRankList
---------------------------------------------------

RabbitWeeklyRankList = class(BaseUI)

function RabbitWeeklyRankList:init(levelId, panelWithRank)
    assert(levelId)
    assert(#{} == 0)

    self.visibleSize        = CCDirector:sharedDirector():getVisibleSize()

    -- ----------------
    -- Get UI Resource
    -- ----------------
    self.ui = ResourceManager:sharedInstance():buildGroup("rabbitWeeklyRankListPanel")

    -- ----------------
    -- Init Base
    -- ----------------
    BaseUI.init(self, self.ui)

    ---------------
    -- Data
    -- ------------
    self.levelId        = levelId
    self.panelWithRank  = panelWithRank
    self.popouted = false

    -- ----------------
    -- Get UI Resource
    -- ----------------
    
    self.rankLabelWrapper   = self.ui:getChildByName("rankLabelWrapper")

    self.myRankLabel        = self.rankLabelWrapper:getChildByName("myRankLabel")
    self.rankNumLabel       = self.rankLabelWrapper:getChildByName("rankNumLabel")
    --self.notHaveRankLabel     = self.rankLabelWrapper:getChildByName("notHaveRankLabel")

    self.rankListItemPh = self.ui:getChildByName("rankListItemPh")
    self.friendRankBtnRes   = self.ui:getChildByName("friendRankBtn")
    self.scale9Bg       = self.ui:getChildByName("scale9Bg")
    self.rankListItemBg = self.ui:getChildByName("rankListItemBg")

    self.addFriendBtn   = self.ui:getChildByName("addFriendBtn")
    self.noNetworkLabel = self.ui:getChildByName("noNetworkLabel")

    self.myScore        = self.ui:getChildByName('myScore')

    self.myRewards      = self.ui:getChildByName('myRewards')
    self.myRewards:getChildByName('txt'):setString(_text('weekly.race.panel.rabbit.rank.my.rewards'))
    self.myScore:getChildByName('txt'):setString(_text('weekly.race.panel.rabbit.rank.my.score'))

    if RabbitWeeklyManager:sharedInstance():isPlayDay() and self.panelWithRank.panelName == 'startGamePanel' then
        self.myRewards:setVisible(true)
        self.myRewards:setTouchEnabled(true, 0, true)
        self.myRewards:ad(DisplayEvents.kTouchTap, function () self:showMyRewardsPanel() end)
        self.myScore:setVisible(false)
        self.myScore:setTouchEnabled(false)
    else
        self.myRewards:setVisible(false)
        self.myRewards:setTouchEnabled(false)
        self.myScore:setVisible(true)
        self.myScore:setTouchEnabled(true, 0, true)
        self.myScore:ad(DisplayEvents.kTouchTap, function () self:showMyScorePanel() end)
        -- self.myScore:ad(DisplayEvents.kTouchBegin, function () self:showMyScorePanel() end)
        -- self.myScore:ad(DisplayEvents.kTouchEnd, function () self:disposeMyScorePanel() end)
    end


    ---- Init UI Resource
    ----------------------
    self.rankListItemPh:setVisible(false)

    self.myRankLabel:setVisible(false)
    self.rankNumLabel:setVisible(false)
    --self.notHaveRankLabel:setVisible(false)
    self.rankLabelWrapper:setScale(1)

    -- Hide No Network Label
    self.noNetworkLabel:setVisible(false)

    --- Update UI
    local noNetWorkLabelKey     = "rank.list.no.network"
    local noNetWorkLabelValue   = Localization:getInstance():getText(noNetWorkLabelKey, {})
    self.noNetworkLabel:setString(noNetWorkLabelValue)

    -- ----------------- 
    -- -- Get Data About UI
    -- ------------------
    local rankListItemPhPos     = self.rankListItemPh:getPosition()
    local rankListItemWidth     = ResourceManager:sharedInstance():getGroupWidth("rabbitWeeklyRankListItem")
    -- TODO: check for wrong in getGroupBounds
    local rankListItemHeight    = 80

    local rankLabelKey  = "rank.list.my.rank"
    local rankLabelValue    = Localization:getInstance():getText(rankLabelKey, {})
    --self.rankLabelValue   = rankLabelValue
    -- Mocke
    --self.rankLabelValue   = "我的排名："
    rankLabelValue = rankLabelValue:gsub("：", ":  ")
    self.myRankLabel:setString(rankLabelValue)


    local notHaveRankLabelKey   = "rank.list.no.rank"
    local notHaveRankLabelValue = Localization:getInstance():getText(notHaveRankLabelKey)

    --------------
    -- Data
    -- -------

    self.isFriendRankHasData = true

    -- --------------------
    -- Create Component
    -- -----------------

    self.friendRankBtn  = RankListButton:create(self.friendRankBtnRes, false)

    -- Init Button State
    local friendRankBtnKey      = "rank.list.friend.rank"
    local friendRankBtnValue    = Localization:getInstance():getText(friendRankBtnKey, {})
    self.friendRankBtn:setString(friendRankBtnValue)
    
    -- --------------------
    -- Create Rank List Data Cache
    -- ------------------------
    -- Rank List Data Cache Is The Data Source For Server/Friend Rank List
    

    -- On Cache Data Change Callback
    -- To Reload Data And Keep The Scroll Position Not Changed
    local function onRankListCachedDataChange(oldRank, newRank, surpassedFriend)
        if self.isDisposed then return end
        -- todo
        self.isFriendRankHasData = true
        self.friendRankListTableView:reloadData()
        self:updateWhenDataChange(oldRank, newRank, surpassedFriend)
        if RabbitWeeklyManager:sharedInstance():getMyRank() ~= nil then 
            self.myRankLabel:setVisible(true)
            self.rankNumLabel:setVisible(true)
            self.rankNumLabel:setString(RabbitWeeklyManager:sharedInstance():getMyRank())
        else
            self.myRankLabel:setVisible(true)
            self.rankNumLabel:setVisible(false)
            self.myRankLabel:setString(notHaveRankLabelValue)
        end
    end

    -- On Get Friend Rank List Failed
    local function onGetFriendRankFailed()
        print("onGetFriendRankFailed Called !")
         if self.isDisposed then return end
        self.isFriendRankHasData = false
        self:updateNoNetWorkLabel()
        --self.noNetworkLabel:setVisible(true)
    end
    local playAnimation = false
    if self.panelWithRank.panelName == "levelSuccessPanel" then playAnimation = true end
    self.rankListCache = RabbitWeeklyRankListCache:create(self.levelId, onRankListCachedDataChange, playAnimation)
    self.rankListCache:setGetFriendRankFailedCallback(onGetFriendRankFailed)
    
    local size = self.rankListItemBg:getGroupBounds().size

    --------------------
    -- Craete Friend Rank List
    -- -----------------
    self.friendRabbitWeeklyRankListTableViewRender  = RabbitWeeklyRankListTableViewRender:create(self.rankListCache, RankListCacheRankType.FRIEND, rankListItemWidth, rankListItemHeight)
    self.friendRankListTableView        = TableView:create(self.friendRabbitWeeklyRankListTableViewRender, rankListItemWidth, size.height - 25)

    --------------------
    --- Cache Load Initial Data
    ---------------------------
    --self.rankListCache:loadInitialData()
    self.rankListCache:loadInitialFriendRank()

    ----------------------
    --- Set Rank List Position
    ----------------------------
    local rankListTableViewPosX = rankListItemPhPos.x
    local rankListTableViewPosY = rankListItemPhPos.y - self.friendRankListTableView:getViewSize().height

    self.friendRankListTableView:setPosition(ccp(rankListTableViewPosX, rankListTableViewPosY))
    self.ui:addChild(self.friendRankListTableView)

    -----------------
    -- Initial State
    -- -----------
    self:setTableViewTouchEnable(false)

    ---------------
    -- Add Event Listener
    -- ------------------

    local function onAddFriendBtnTapped()
        self:onAddFriendButtonTapped()
    end

    self.addFriendBtn:setTouchEnabled(true)
    self.addFriendBtn:setButtonMode(true)
    self.addFriendBtn:addEventListener(DisplayEvents.kTouchTap, onAddFriendBtnTapped)
end

function RabbitWeeklyRankList:onAddFriendButtonTapped()
    print("RabbitWeeklyRankList:onAddFriendButtonTapped Called !")

    local addFriendBtnPosInWorldSpace   = self.addFriendBtn:getPositionInWorldSpace()
    
    -- Pop The Add Friend Panel
    --local panel = AddFriendPanel:create(addFriendBtnPosInWorldSpace)
    local panel = require("zoo.panel.addfriend.NewAddFriendPanel"):create(addFriendBtnPosInWorldSpace)
    -- panel:popout()
    --local selfParent = self:getParent():setRankListPanelTouchDisable()
    self.panelWithRank:setRankListPanelTouchDisable()
    if panel then 
        --panel:popout()
    end

end

-- Called By PanelWithRankExchangeAnim / PanelWithRankPopRemoveAnim, When This Rank List Is 
-- About To Poping Out
function RabbitWeeklyRankList:prePopoutCallback()

end

function RabbitWeeklyRankList:postPopoutCallback()
    self:setTableViewTouchEnable(true)
end


function RabbitWeeklyRankList:updateNoNetWorkLabel()
    if self.isDisposed then
        return
    end

    if self.friendRankListTableView:isVisible() then

        if self.isFriendRankHasData then
            self.noNetworkLabel:setVisible(false)
        else
            self.noNetworkLabel:setVisible(true)
        end
    end
end


function RabbitWeeklyRankList:updateWhenDataChange(oldRank, newRank, surpassedFriend)
    -- print('updateWhenDataChange', oldRank, newRank, surpassedFriend.uid)
    if self.isDisposed then
        return
    end
    print('panelName', self.panelWithRank.panelName)
    local playAime = self.panelWithRank.panelName == 'levelSuccessPanel'


    if playAime and self.rankListCache:getCurCachedRankListLength() > 1 then
        if ((not oldRank) or (oldRank and newRank < oldRank)) and newRank ~= 1 and surpassedFriend then 
            WeeklyRaceRankAnimation:playSurpassingAnimation(surpassedFriend, self.panelWithRank)
        elseif ((not oldRank) or (oldRank and newRank < oldRank)) and newRank == 1 then
            WeeklyRaceRankAnimation:playNo1Animation(self.panelWithRank)
        end
    end

    self:updateNoNetWorkLabel()
end

function RabbitWeeklyRankList:createLineStar(width, height)
    local textureSprite = Sprite:createWithSpriteFrameName("win_star_shine0000")
    local container = SpriteBatchNode:createWithTexture(textureSprite:getTexture())
    for i = 1, 15 do
        local sprite = Sprite:createWithSpriteFrameName("win_star_shine0000")
        sprite:setPosition(ccp(width*math.random(), height*math.random()))
        sprite:setOpacity(0)
        sprite:setScale(0)
        sprite:runAction(CCRepeatForever:create(CCRotateBy:create(0.1 + math.random()*0.3, 150)))
        local scaleTo = 0.3 + math.random() * 0.8
        local fadeInTime, fadeOutTime = 0.4, 0.4
        local array = CCArray:create()
        array:addObject(CCDelayTime:create(math.random()*0.5))
        array:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(fadeInTime), CCScaleTo:create(fadeInTime, scaleTo)))
        array:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(fadeOutTime), CCScaleTo:create(fadeOutTime, 0)))
        sprite:runAction(CCSequence:create(array))
        container:addChild(sprite)
    end
    local function onAnimationFinished() container:removeFromParentAndCleanup(true) end
    container:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.3), CCCallFunc:create(onAnimationFinished)))
    textureSprite:dispose()
    return container
end

function RabbitWeeklyRankList:setTableViewTouchEnable(bool)
    self.friendRankListTableView:setTouchEnabled(bool)
end

function RabbitWeeklyRankList:setTableViewBounceable(bounceable)
    self.friendRankListTableView:setBounceable(bounceable)
end

function RabbitWeeklyRankList:getVisibleRankListTableView()
    local result = false

    if self.friendRankListTableView:isVisible() then
        result = self.friendRankListTableView
    end

    return result
end

function RabbitWeeklyRankList:getScale9Bg()
    return self.scale9Bg
end

function RabbitWeeklyRankList:getRankListItemBg()
    return self.rankListItemBg
end

function RabbitWeeklyRankList:create(levelId, panelWithRank)

    local newRankList = RabbitWeeklyRankList.new()
    newRankList:init(levelId, panelWithRank)
    return newRankList
end

function RabbitWeeklyRankList:showMyRewardsPanel()
    local function callback()
        if self.panelWithRank then self.panelWithRank:setRankListPanelTouchEnable() end
    end
    if self.panelWithRank then
        self.panelWithRank:setRankListPanelTouchDisable()
    end
    local panel = MyRewardPanel:create()
    panel:popout(callback)
end

function RabbitWeeklyRankList:showMyScorePanel()
    local maxCountInOnePlay = _mgr():getMaxCountInOnePlay()
    local passedFriendCount = _mgr():getSurpassedFriendCount()
    local tipText = _text('weekly.race.panel.rabbit.rank.my.score.tip', {num1 = maxCountInOnePlay, num2 = passedFriendCount, n = '\n'})
    -- local rect = self.myScore:getGroupBounds()
    -- local ui = ResourceManager:sharedInstance():buildGroup('rabbit_tip')
    -- ui:getChildByName('txt'):setString(_text('weekly.race.panel.rabbit.rank.my.score.tip', 
    --     {num1 = _mgr():getMaxCountInOnePlay(), num2 = _mgr():getSurpassedFriendCount(), n = '\n'}))
    -- local tip = BubbleTip:create(ui)
    -- tip:show(rect)
    -- self.scoreTip = tip
    CommonTip:showTip(tipText, "positive")
end

function RabbitWeeklyRankList:disposeMyScorePanel( ... )
    if self.scoreTip and not self.scoreTip.isDisposed then
        self.scoreTip:hide()
    end
end

function RabbitWeeklyRankList:showMyRecordPanel()

end

function RabbitWeeklyRankList:dispose()
    self.friendRabbitWeeklyRankListTableViewRender:dispose()
    BasePanel.dispose(self)
end
