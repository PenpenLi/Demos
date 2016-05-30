require "zoo.panel.component.startGamePanel.rankList.RankListItem"
require "zoo.panel.component.startGamePanel.rankList.RankListCache"
require "hecore.ui.TableView"
require "zoo.panel.component.startGamePanel.rankList.RankListButton"
require "zoo.panel.component.startGamePanel.rankList.GetMoreButton"
require "zoo.panel.weeklyRace.WeeklyRaceRankListCache"
require "zoo.panel.weeklyRace.WeeklyRaceRankAnimation"

--------------------------------------------
-----   Rank List Table View Render
---------------------------------------------

WeeklyRaceRankListTableViewRender = class(TableViewRenderer)

function WeeklyRaceRankListTableViewRender:init(rankListDataCache, cacheRankType, ...)
    assert(rankListDataCache)
    assert(cacheRankType)
    RankListCacheRankType.checkRankType(cacheRankType)
    assert(#{...} == 0)

    self.rankListDataCache  = rankListDataCache
    self.cacheRankType  = cacheRankType

    self.rankListItems = {}
end
function WeeklyRaceRankListTableViewRender:dispose(  )
    if not self.isDisposed then
        for k,v in pairs(self.rankListItems) do
            v:dispose()
        end
        self.isDisposed = true
    end
end


function WeeklyRaceRankListTableViewRender:create(rankListDataCache, cacheRankType, width, height)


    local render = WeeklyRaceRankListTableViewRender.new(width, height)
    render:init(rankListDataCache, cacheRankType)
    return render
end

function WeeklyRaceRankListTableViewRender:buildCell(cell, index, ...)
    assert(cell)
    assert(type(index) == "number")
    assert(#{...} == 0)

    local numberOfCells = self:numberOfCells()
    local rankListItemRes   = false

    rankListItemRes     = ResourceManager:sharedInstance():buildGroup("weeklyRaceRankListItem")
    local rankListItem  = RankListItem:create(rankListItemRes)
    self.rankListItems[index + 1] = rankListItem

    local rankListItemHeight = 80
    rankListItem:setPosition(ccp(0, rankListItemHeight))
    cell.refCocosObj:addChild(rankListItem.refCocosObj)

    rankListItem:releaseCocosObj()
end

function WeeklyRaceRankListTableViewRender:getContentSize(tableView, index, ...)
    assert(tableView)
    assert(type(index) == "number")
    assert(#{...} == 0)

    local numberOfCells = self:numberOfCells()
    return CCSizeMake(self.width, self.height)
end

function WeeklyRaceRankListTableViewRender:setData(rawCocosObj, index, ...)
    assert(rawCocosObj)
    assert(index)
    assert(#{...} == 0)
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

function WeeklyRaceRankListTableViewRender:numberOfCells(...)
    assert(#{...} == 0)

    local cachedDataLength = self.rankListDataCache:getCurCachedRankListLength(self.cacheRankType)
    return cachedDataLength
end


---------------------------------------------------
-------------- WeeklyRaceRankList
---------------------------------------------------

WeeklyRaceRankList = class(BaseUI)

function WeeklyRaceRankList:init(levelId, panelWithRank, ...)
    assert(levelId)
    assert(#{...} == 0)

    self.visibleSize        = CCDirector:sharedDirector():getVisibleSize()

    -- ----------------
    -- Get UI Resource
    -- ----------------
    self.ui = ResourceManager:sharedInstance():buildGroup("weeklyRaceRankListPanel")

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

    self.gemCountTxt = self.ui:getChildByName('txt')
    self.gemCountTxt:setString(Localization:getInstance():getText('weekly.race.panel.gem.num3', {num = WeeklyRaceManager:sharedInstance():getMaxDigCountInOnePlay()}))

    assert(self.rankLabelWrapper)
    assert(self.myRankLabel)
    assert(self.rankNumLabel)
    --assert(self.notHaveRankLabel)

    assert(self.rankListItemPh)
    assert(self.friendRankBtnRes)
    assert(self.scale9Bg)
    assert(self.rankListItemBg)

    assert(self.addFriendBtn)
    assert(self.noNetworkLabel)

    ----------------------
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
    local rankListItemWidth     = ResourceManager:sharedInstance():getGroupWidth("weeklyRaceRankListItem")
    -- TODO: check for wrong in getGroupBounds
    local rankListItemHeight    = 80
    -- local rankListItemHeight = ResourceManager:sharedInstance():getGroupHeight("rankListItem")

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
        
        self.isFriendRankHasData = true
        self.friendRankListTableView:reloadData()
        self:updateWhenDataChange(oldRank, newRank, surpassedFriend)
        self.gemCountTxt:setString(Localization:getInstance():getText('weekly.race.panel.gem.num3', {num = WeeklyRaceManager:sharedInstance():getMaxDigCountInOnePlay()}))
        if WeeklyRaceManager:sharedInstance():getMyRank() ~= nil then 
            self.myRankLabel:setVisible(true)
            self.rankNumLabel:setVisible(true)
            self.rankNumLabel:setString(WeeklyRaceManager:sharedInstance():getMyRank())
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
    self.rankListCache = WeeklyRaceRankListCache:create(self.levelId, onRankListCachedDataChange, playAnimation)
    self.rankListCache:setGetFriendRankFailedCallback(onGetFriendRankFailed)
    
    local size = self.rankListItemBg:getGroupBounds().size

    --------------------
    -- Craete Friend Rank List
    -- -----------------
    self.friendWeeklyRaceRankListTableViewRender  = WeeklyRaceRankListTableViewRender:create(self.rankListCache, RankListCacheRankType.FRIEND, rankListItemWidth, rankListItemHeight)
    self.friendRankListTableView        = TableView:create(self.friendWeeklyRaceRankListTableViewRender, rankListItemWidth, size.height - 25)

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

function WeeklyRaceRankList:onAddFriendButtonTapped(...)
    assert(#{...} == 0)

    print("WeeklyRaceRankList:onAddFriendButtonTapped Called !")

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
function WeeklyRaceRankList:prePopoutCallback(...)

end

function WeeklyRaceRankList:postPopoutCallback(...)
    assert(#{...} == 0)

    self:setTableViewTouchEnable(true)

    -- Load The User Head Picture

end


function WeeklyRaceRankList:updateNoNetWorkLabel(...)
    assert(#{...} == 0)

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


function WeeklyRaceRankList:updateWhenDataChange(oldRank, newRank, surpassedFriend)
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

function WeeklyRaceRankList:createLineStar(width, height)
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

function WeeklyRaceRankList:setTableViewTouchEnable(bool, ...)
    self.friendRankListTableView:setTouchEnabled(bool)
end

function WeeklyRaceRankList:setTableViewBounceable(bounceable, ...)
    self.friendRankListTableView:setBounceable(bounceable)
end

function WeeklyRaceRankList:getVisibleRankListTableView(...)
    assert(#{...} == 0)

    local result = false

    if self.friendRankListTableView:isVisible() then
        result = self.friendRankListTableView
    else
        assert(false)
    end

    return result
end

function WeeklyRaceRankList:getScale9Bg(...)
    assert(#{...} == 0)

    return self.scale9Bg
end

function WeeklyRaceRankList:getRankListItemBg(...)
    assert(#{...} == 0)

    return self.rankListItemBg
end

function WeeklyRaceRankList:create(levelId, panelWithRank, ...)
    assert(levelId)
    assert(panelWithRank)
    assert(#{...} == 0)

    local newRankList = WeeklyRaceRankList.new()
    newRankList:init(levelId, panelWithRank)
    return newRankList
end


function WeeklyRaceRankList:dispose()
    self.friendWeeklyRaceRankListTableViewRender:dispose()
    BasePanel.dispose(self)
end
