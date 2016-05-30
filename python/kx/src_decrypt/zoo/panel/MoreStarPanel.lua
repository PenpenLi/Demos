require  'zoo.panel.component.common.GridLayout'
require "zoo.animation.FlowerNode"
-- short hand function
local function _text(key, replace)
    return Localization:getInstance():getText(key, replace)
end

MoreStarPanel = class(BasePanel)

function MoreStarPanel:create()
    local instance = MoreStarPanel.new()
    instance:loadRequiredResource(PanelConfigFiles.more_star_panel)
    instance:init()
    return instance
end

function MoreStarPanel:init()
    local ui = self:buildInterfaceGroup('more_star_panel')
    BasePanel.init(self, ui)
    self.btn = GroupButtonBase:create(ui:getChildByName('btn'))
    self.btn:ad(DisplayEvents.kTouchTap, function () self:onCloseBtnTapped() end)
    self.btn:setString(_text('hide.area.infor.panel.btn'))
    self.title = ui:getChildByName('title')

    self.desc = ui:getChildByName('desc')
    self.desc:setString(_text('more.star.panel.desc'))
    local gridViewSize = ui:getChildByName('gridView')
    gridViewSize:setVisible(false)
    self.bg = ui:getChildByName('bg')

    -- transparent bg
    local vs = Director:sharedDirector():getVisibleSize()
    local vo = Director:sharedDirector():getVisibleOrigin()

    local gridView = GridLayout:create()
    gridView:setColumn(4)
    gridView:setItemSize(CCSizeMake(152, 185))
    -- local size = CCSizeMake(700, 740)
    local size = gridViewSize:getGroupBounds().size
    gridView:setWidth(size.width)
    gridView:setHeight(size.height)
    gridView:setPosition(ccp(gridViewSize:getPositionX(), gridViewSize:getPositionY()))
    gridViewSize:getParent():addChildAt(gridView, gridViewSize:getZOrder())
    self.gridView = gridView
    self:setData(self:getData())

    self:scaleAccordingToResolutionConfig()
    self:setPositionForPopoutManager()
end

function MoreStarPanel:getData()
    local availableStarCount = 0 
    local scores = UserManager:getInstance():getScoreRef()
    local result = {}
    local counter = 0

    for levelId = LevelConstans.MAIN_LEVEL_ID_START, LevelConstans.MAIN_LEVEL_ID_END do 
        local levelScore = UserManager:getInstance():getUserScore(levelId)
        if levelScore and levelScore.star > 0 and levelScore.star < 3 then
            table.insert(result, levelScore)
            availableStarCount = availableStarCount + (3 - levelScore.star)
            counter = counter + 1
            if counter == 16 then break end
        elseif JumpLevelManager.getInstance():hasJumpedLevel(levelId) then
            if not levelScore then 
                levelScore = ScoreRef.new()
                levelScore.uid = UserManager:getInstance().uid
                levelScore.levelId = levelId
            end
            table.insert(result, levelScore)
            availableStarCount = availableStarCount + 3
            counter = counter + 1
            if counter == 16 then break end
        end
    end

    print('availableStarCount', availableStarCount)
    self.availableStarCount = availableStarCount
    self.title:setString(_text('more.star.panel.title', {num = availableStarCount}))
    return result
end

function MoreStarPanel:setData(data)


    for k, v in pairs(data) do
        local flowerType = kFlowerType.kNormal
        if v.star == 0 then flowerType = kFlowerType.kJumped end
        local node = FlowerNodeUtil:createWithSize(flowerType, v.levelId, v.star, CCSizeMake(152, 185))
        node:setAnchorPoint(ccp(0, 1))
        node:ignoreAnchorPointForPosition(false)
        local item = ItemInLayout:create()
        item:setContent(node)
        self.gridView:addItem(item)

        node:setTouchEnabled(true)
        node:ad(DisplayEvents.kTouchTap, function () self:onItemTouched(v.levelId) end)
    end
end

function MoreStarPanel:onItemTouched(levelId)
    print('MoreStarPanel:onItemTouched', levelId)
    self:onCloseBtnTapped()

    if not PopoutManager:sharedInstance():haveWindowOnScreen() and not HomeScene:sharedInstance().ladyBugOnScreen then
        local startGamePanel = StartGamePanel:create(levelId, GameLevelType.kMainLevel)
        startGamePanel:popout(false)
    end

end

function MoreStarPanel:onCloseBtnTapped()
    PopoutManager:sharedInstance():remove(self, true)
    self.allowBackKeyTap = false
    if self.closeCallback then self.closeCallback() end
end

function MoreStarPanel:popout()
    self:setPositionForPopoutManager()
    PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
    self.allowBackKeyTap = true 
end

