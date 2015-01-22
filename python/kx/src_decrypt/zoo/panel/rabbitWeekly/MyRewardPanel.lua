require "zoo.panel.component.common.HorizontalTileLayout"
require "zoo.panel.component.common.LayoutItem"

local function _mgr()
    return RabbitWeeklyManager:sharedInstance()
end

local function _text(key, replace)
    return Localization:getInstance():getText(key, replace)
end

MyRewardPanel = class(BasePanel)

function MyRewardPanel:create()
    local instance = MyRewardPanel.new()
    instance:loadRequiredJson(PanelConfigFiles.panel_rabbit_weekly_v2)
    instance:init()
    return instance
end

function MyRewardPanel:init()
    local ui = self:buildInterfaceGroup('rabbitMyRewardPanel')
    BasePanel.init(self, ui)

    -- local winSize = CCDirector:sharedDirector():getWinSize()
    -- local origin = CCDirector:sharedDirector():getVisibleOrigin()

    -- local colorLayer = LayerColor:create()
    -- colorLayer:changeWidthAndHeight(60, 60)
    -- colorLayer:setColor(ccc3(0, 0, 0))
    -- colorLayer:setPosition(ccp(origin.x, origin.y))
    -- colorLayer:setOpacity(200)
    -- self:addChild(colorLayer)

    self.title = ui:getChildByName('title')
    self.desc1 = ui:getChildByName('desc1')
    self.desc2 = ui:getChildByName('desc2')
    self.desc3 = ui:getChildByName('desc3')
    self.loc1 = ui:getChildByName('loc1')
    self.loc2 = ui:getChildByName('loc2')
    self.icon2 = ui:getChildByName('icon2')
    self.bg2 = ui:getChildByName('bg2')
    self.deco = ui:getChildByName('deco')
    self.topRewardDesc = ui:getChildByName('topRewardDesc')
    self.noRewardDesc = ui:getChildByName('noRewardDesc')
    self.loc1:setVisible(false)
    self.loc2:setVisible(false)

    self.title:setString(_text('weekly.race.panel.rabbit.rank.my.rewards'))
    self.desc3:setString(_text('weekly.race.panel.rabbit.reward.bottom.text'))
    self.noRewardDesc:setString(_text('weekly.race.panel.rabbit.no.reward'))

    self.closeBtn = ui:getChildByName('closeBtn')
    self.closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn:ad(DisplayEvents.kTouchTap, function () self:onCloseBtnTapped() end)
    self:update()
end

function MyRewardPanel:update()
    local currentRewards = _mgr():getRewardConfig()
    local currentRank = _mgr():getMyRank()
    local rabbitCount = _mgr():getMaxCountInOnePlay() or 0
    local nextRewardRabbitCount = 0

    local desc1Txt = _text('weekly.race.panel.rabbit.reward.tip1', {num = rabbitCount})
    local desc2Txt = ''
    local nextReward = {}

    print("currentRank:", currentRank)
    if not currentRank or currentRank > 1 then        
        nextReward, nextRewardRabbitCount = _mgr():getNextRewardConfig(1)
        desc2Txt = _text('weekly.race.panel.rabbit.reward.tip2')
    else
        nextReward, nextRewardRabbitCount = _mgr():getNextRewardConfig(2)
        desc2Txt = _text('weekly.race.panel.rabbit.reward.tip3', {num = nextRewardRabbitCount})
    end

    self.desc1:setString(desc1Txt)
    self.desc2:setString(desc2Txt)

    local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
    local loc1Size = self.loc1:getGroupBounds().size
    local loc2Size = self.loc2:getGroupBounds().size

    local function setIcon(ui, itemId, num)
        local icon = iconBuilder:buildGroup('Prop_'..itemId)
        icon:setScale(0.7)
        local loc = ui:getChildByName('loc')
        local txt = ui:getChildByName('num')
        icon:setPositionX(loc:getPositionX())
        icon:setPositionY(loc:getPositionY())
        loc:setVisible(false)
        loc:getParent():addChildAt(icon, loc:getZOrder())
        txt:setString('x'..num)
    end

    local topContainer = HorizontalTileLayoutWithAlignment:create(loc1Size.width, loc1Size.height)
    topContainer:setAlignment(HorizontalAlignments.kCenter)
    topContainer:setItemHorizontalMargin(3)

    print("currentRewards:", table.tostring(currentRewards))
    if currentRewards and #currentRewards > 0 then
        for k, v in pairs(currentRewards) do 
            local ui = self:buildInterfaceGroup('rabbit_panel_reward_item2')
            setIcon(ui, v.itemId, v.num)
            local item = ItemInLayout:create()
            item:setContent(ui)
            topContainer:addItem(item)
        end
        self.noRewardDesc:setVisible(false)
    else
        self.noRewardDesc:setVisible(true)
    end
    topContainer:setPositionX(self.loc1:getPositionX())
    topContainer:setPositionY(self.loc1:getPositionY())
    self.loc1:getParent():addChildAt(topContainer, self.loc1:getZOrder())


    if nextReward ~= nil then
        local bottomContainer = HorizontalTileLayoutWithAlignment:create(loc2Size.width, loc2Size.height)
        bottomContainer:setAlignment(HorizontalAlignments.kCenter)
        bottomContainer:setItemHorizontalMargin(5)
        for k, v in pairs(nextReward) do 
            local ui = self:buildInterfaceGroup('rabbit_panel_reward_item2')
            setIcon(ui, v.itemId, v.num)
            local item = ItemInLayout:create()
            item:setContent(ui)
            bottomContainer:addItem(item)
        end
        bottomContainer:setPositionX(self.loc2:getPositionX())
        bottomContainer:setPositionY(self.loc2:getPositionY())
        self.loc2:getParent():addChildAt(bottomContainer, self.loc2:getZOrder())

    else
        self.icon2:setVisible(false)
        self.desc2:setVisible(false)
        self.deco:setVisible(false)
        self.topRewardDesc:setVisible(true)
        self.topRewardDesc:setString(_text('weekly.race.panel.rabbit.reward.tip4'))
    end
end

function MyRewardPanel:createMask()
    local wSize = CCDirector:sharedDirector():getWinSize()
    local mask = LayerColor:create()
    mask:changeWidthAndHeight(wSize.width, wSize.height)
    mask:setColor(ccc3(0, 0, 0))
    mask:setOpacity(180)
    mask:setPosition(ccp(0, 0))

    local layer = CCRenderTexture:create(wSize.width, wSize.height)
    layer:setPosition(ccp(wSize.width / 2, wSize.height / 2))
    layer:begin()
    mask:visit()
    layer:endToLua()
    if __WP8 then layer:saveToCache() end

    mask:dispose()

    local layerSprite = layer:getSprite()
    local obj = CocosObject.new(layer)
    local trueMaskLayer = Layer:create()
    trueMaskLayer:addChild(obj)
    trueMaskLayer:setTouchEnabled(true, 0, true)
    trueMaskLayer.layerSprite = layerSprite
    return trueMaskLayer
end

function MyRewardPanel:popout(closeCallback)
    PopoutManager:sharedInstance():addChildWithBackground(self, ccc3(0, 0, 0), 255 * 0.7)
    self.allowBackKeyTap = true
    self.closeCallback = closeCallback
end

function MyRewardPanel:onCloseBtnTapped()
    PopoutManager:sharedInstance():remove(self, true)
    self.allowBackKeyTap = false
    if self.closeCallback then self.closeCallback() end
end

function MyRewardPanel:dispose( ... )
    BaseUI.dispose(self)
end

