require "zoo.panelBusLogic.IapBuyPropLogic"
require "zoo.panel.rabbitWeekly.IapBuyRabbitWeeklyPlayCardPanel"

local function _text(key, replace)
    return Localization:getInstance():getText(key, replace)
end

RabbitWeeklyGetFreePlayItem = class()

function RabbitWeeklyGetFreePlayItem:init( ui, useIconNumBtn, useMainLevelIcon )
    self.ui = ui
    self.useIconNumBtn = useIconNumBtn

    self.icon           = self.ui:getChildByName("icon")
    self.statusLabel    = self.ui:getChildByName("status") -- may be nil
    self.common         = self.ui:getChildByName("common")

    self.title          = self.common:getChildByName("title")
    self.desc           = self.common:getChildByName("desc")
    self.inactiveBg     = self.common:getChildByName("inactiveBg")
    self.activeBg       = self.common:getChildByName("activeBg")
    self.completedFlag  = self.common:getChildByName("completed")
    self.label          = self.common:getChildByName("label")
    if useIconNumBtn then
        self.btn        = ButtonIconNumberBase:create(self.common:getChildByName("iconNumBtn"))
        self.common:getChildByName("btn"):removeFromParentAndCleanup(true)
    else
        self.btn        = GroupButtonBase:create(self.common:getChildByName("btn"))
        self.common:getChildByName("iconNumBtn"):removeFromParentAndCleanup(true)
    end

    if useMainLevelIcon then
        local sprite = Sprite:createWithSpriteFrameName("normalFlowerAnim10000")
        local sSize = sprite:getContentSize()
        sSize = {width = sSize.width, height = sSize.height}
        local iSize = self.icon:getGroupBounds().size
        local scale = iSize.width / sSize.width
        if iSize.height / sSize.height < scale then
            scale = iSize.height / sSize.height
        end
        sprite:setScale(scale)
        sprite:setAnchorPoint(ccp(0, 1))
        sprite:setPositionX(self.icon:getPositionX() + (iSize.width - sSize.width * scale) / 2)
        sprite:setPositionY(self.icon:getPositionY() - (iSize.height - sSize.height * scale) / 2)
        local parent = self.icon:getParent()
        parent:addChildAt(sprite, parent:getChildIndex(self.icon))
        self.icon:removeFromParentAndCleanup(true)
        self.icon = sprite
        if self.statusLabel then
            self.statusLabel:setPositionX(sprite:getPositionX() + sSize.width * scale - 40)
            self.statusLabel:setPositionY(sprite:getPositionY() - sSize.height * scale + 20)
        end
    end

    self:update(false)
end

function RabbitWeeklyGetFreePlayItem:update(completed, statusTxt, desc)
    completed = completed or false
    if desc then self.desc:setString(desc) end
    if statusTxt and self.statusLabel then self.statusLabel:setString(statusTxt) end

    if completed then
        self.activeBg:setVisible(false)
        self.btn:setVisible(false)
        self.icon:setVisible(false)
        if self.statusLabel then self.statusLabel:setVisible(false) end
        
        self.inactiveBg:setVisible(true)
        self.completedFlag:setVisible(true)
        self.label:setVisible(true)
    else
        self.inactiveBg:setVisible(false)
        self.label:setVisible(false)
        self.completedFlag:setVisible(false)

        self.activeBg:setVisible(true)
        self.icon:setVisible(true)
        if self.statusLabel then self.statusLabel:setVisible(true) end
        self.btn:setVisible(true)
    end
end

function RabbitWeeklyGetFreePlayItem:setVisible(v)
    if not self.ui or self.ui.isDisposed then return end
    self.ui:setVisible(v)
    self.btn:setEnabled(v)
    if self.helpBtn then self.helpBtn:setTouchEnabled(v) end
end

function RabbitWeeklyGetFreePlayItem:create(ui, useIconNumBtn, useMainLevelIcon)
    local item = RabbitWeeklyGetFreePlayItem.new()
    item:init(ui, useIconNumBtn, useMainLevelIcon)
    return item
end

-----------------------------------------
--- RabbitWeeklyGetFreePlayPanel
-----------------------------------------
RabbitWeeklyGetFreePlayPanel = class(BasePanel)

function RabbitWeeklyGetFreePlayPanel:init(coveredPanel, levelId, onBuyPlayCardSuccess)
	self.coveredPanel = coveredPanel
    self.onBuyPlayCardSuccess = onBuyPlayCardSuccess
    self.levelId = levelId

	self:loadRequiredResource(PanelConfigFiles.panel_rabbit_weekly_v2)
    local ui = self:buildInterfaceGroup('rabbitWeeklyGetFreePlayPanel')
    BasePanel.init(self, ui)

    self.ui:getChildByName("title"):setString(_text("weekly.race.alert.rabbit.times"))

    -- local panelSize = self.ui:getGroupBounds().size
    -- local bgLayer = LayerColor:create()
    -- bgLayer:setColor(ccc3(0,0,0))
    -- bgLayer:setOpacity(255 * 0.7)
    -- bgLayer:setAnchorPoint(ccp(0, 1))
    -- bgLayer:ignoreAnchorPointForPosition(false)
    -- bgLayer:setPosition(ccp(0, 0))
    -- bgLayer:changeWidthAndHeight(panelSize.width, panelSize.height)
    -- self.ui:addChildAt(bgLayer, 1)

    -- self.ui:getChildByName("bg"):removeFromParentAndCleanup(true)

    local mgr = RabbitWeeklyManager:sharedInstance()
    local cfg = mgr.extraConfig

    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
        self.ui:getChildByName("itemShareWeChat"):removeFromParentAndCleanup(true)
        self.shareItem = RabbitWeeklyGetFreePlayItem:create(self.ui:getChildByName("itemShareMitalk"))
        self.shareItem.title:setString(_text("weekly.race.alert.rabbit.times2.mitalk"))
    else
        self.ui:getChildByName("itemShareMitalk"):removeFromParentAndCleanup(true)
        self.shareItem = RabbitWeeklyGetFreePlayItem:create(self.ui:getChildByName("itemShareWeChat"))
        self.shareItem.title:setString(_text("weekly.race.alert.rabbit.times2"))
    end
    self.shareItem.desc:setString(_text("weekly.race.alert.rabbit.add.times", {num = cfg.freePlayByShare}))
    self.shareItem.label:setString(_text("weekly.race.alert.rabbit.times.button3"))
    self.shareItem.btn:setString(_text("weekly.race.alert.rabbit.times.button2"))
    self.shareItem.btn:setColorMode(kGroupButtonColorMode.blue)
    local function onShareItemBtnTapped(event)
        self:onShareBtnTapped()
    end
    self.shareItem.btn:ad(DisplayEvents.kTouchTap, onShareItemBtnTapped)

    self.mainLevelItem = RabbitWeeklyGetFreePlayItem:create(self.ui:getChildByName("itemMainLevel"), false, true)
    self.mainLevelItem.title:setString(_text("weekly.race.alert.rabbit.times1"))
    local desLabelDimension = self.mainLevelItem.title:getDimensions()
    self.mainLevelItem.title:setDimensions(CCSizeMake(desLabelDimension.width - 30, 0))
    self.mainLevelItem.desc:setString(_text("weekly.race.alert.rabbit.add.times", {num = cfg.freePlayByMainLevel}))
    self.mainLevelItem.label:setString(_text("weekly.race.alert.rabbit.times.button3"))
    self.mainLevelItem.helpBtn = self.mainLevelItem.ui:getChildByName("helpBtn")
    self.mainLevelItem.btn:setString(_text("weekly.race.alert.rabbit.times.button1"))
    self.mainLevelItem.btn:setColorMode(kGroupButtonColorMode.green)

    self.mainLevelItem.helpBtn:setTouchEnabled(true)
    self.mainLevelItem.helpBtn:setButtonMode(true)
    local function onMainLevelHelpBtnTapped(evt)
        CommonTip:showTip(_text("weekly.race.alert.rabbit.tip.times1"), "positive")
    end
    self.mainLevelItem.helpBtn:ad(DisplayEvents.kTouchTap, onMainLevelHelpBtnTapped)

    local function showRabbitTutor()
        RabbitWeeklyManager:sharedInstance():showRabbitTimeTutor()
    end

    local function onMainLevelItemBtnTapped(event)
        PopoutManager:sharedInstance():removeAll()
        self:onCloseBtnTapped()
        HomeScene:sharedInstance().worldScene:moveTopLevelNodeToCenter(showRabbitTutor)
        DcUtil:logWeeklyRaceActivity("click_rabbit_times_panel_start", {level_id = self.levelId})
    end
    self.mainLevelItem.btn:ad(DisplayEvents.kTouchTap, onMainLevelItemBtnTapped)

    self:initBuyItems()

    self.closeBtn = self.ui:getChildByName("closeBtn")
    local function onCloseButtonTapped(event)
    	self:onCloseBtnTapped()
    end
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:setButtonMode(true)
    self.closeBtn:ad(DisplayEvents.kTouchTap, onCloseButtonTapped)

    self:updatePanel()
end

function RabbitWeeklyGetFreePlayPanel:initBuyItems()
    local goods = MetaManager:getInstance():getGoodMeta(RabbitWeeklyManager.playCardGoodsId)
    local userExtend = UserManager:getInstance().userExtend
    for i=1,2 do
        local buyItemRes = self.ui:getChildByName("itemBuy"..i)
        if __ANDROID then
            self["buyItem"..i] = RabbitWeeklyGetFreePlayItem:create(buyItemRes, false)
            local price = goods.rmb / 100
            local mark = _text("buy.gold.panel.money.mark")
            local text = _text("weekly.race.panel.rabbit.button2")
            local label = string.format("%s%0.2f", mark, price)
            self["buyItem"..i].btn:setString(label)
        else
            self["buyItem"..i] = RabbitWeeklyGetFreePlayItem:create(buyItemRes, true)
            local price = goods.qCash
            self["buyItem"..i].btn:setIconByFrameName('ui_images/ui_image_coin_icon_small0000')
            self["buyItem"..i].btn:setNumber(price)
            self["buyItem"..i].btn:setString(_text("weekly.race.panel.rabbit.button2"))
        end
        self["buyItem"..i].btn:setColorMode(kGroupButtonColorMode.blue)
        self["buyItem"..i].title:setString(_text("weekly.race.alert.rabbit.buy.times"))
        self["buyItem"..i].desc:setString(_text("weekly.race.alert.rabbit.add.times", {num = 1}))
        self["buyItem"..i].label:setString(_text("weekly.race.alert.rabbit.buy.times.maximum"))
        
        local function onBuyItemBtnTapped(event)
            self:onBuyItemBtnTapped()
        end
        self["buyItem"..i].btn:ad(DisplayEvents.kTouchTap, onBuyItemBtnTapped)
    end
end

function RabbitWeeklyGetFreePlayPanel:onBuyItemBtnTapped()
    local function onSuccess()
        HomeScene:sharedInstance():checkDataChange()
        HomeScene:sharedInstance().goldButton:updateView()

        if self then
            self:onCloseBtnTapped()
            if self.onBuyPlayCardSuccess 
                    and type(self.onBuyPlayCardSuccess) == "function" then 
                self.onBuyPlayCardSuccess()
            end
        end
    end

    local function onFail()
        self:updatePanel()
    end

    local function onCancel()
        self:updatePanel()
    end

    local function onFinish()
        self:updatePanel()
    end
    RabbitWeeklyManager:sharedInstance():buyPlayCard( onSuccess, onFail, onCancel, onFinish, true)
end

-- function RabbitWeeklyGetFreePlayPanel:onTouched()
--     local boundsLayer = LayerColor:create()
--     boundsLayer:setColor(ccc3(255,0,0))
--     local closeBtnSize = self.closeBtn:getGroupBounds().size
--     boundsLayer:changeWidthAndHeight(closeBtnSize.width, closeBtnSize.height)
--     self.closeBtn:addChild(boundsLayer)
-- end

function RabbitWeeklyGetFreePlayPanel:onShareBtnTapped()
    local shareType = PlatformShareEnum.kWechat
    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
        shareType = PlatformShareEnum.kMiTalk
    end

    local shareCallback = {
    onSuccess = function(data)
        print("on share success", tostring(data))
        local function onSuccess(event)
            SnsUtil.showShareSuccessTip(shareType)

            RabbitWeeklyManager:sharedInstance():onShareSuccess()
            if self.coveredPanel and self.coveredPanel.levelInfoPanel then 
                self.coveredPanel.levelInfoPanel:updatePanel()
            end
            DcUtil:logWeeklyRaceActivity("share_rabbit_times_panel_feed", {level_id = self.levelId})
            -- self:updatePanel()
            self:onCloseBtnTapped()
        end

        local function onFail(event)
            SnsUtil.showShareFailTip(shareType)
        end
        local http = OpNotifyHttp.new()
        http:ad(Events.kComplete, onSuccess)
        http:ad(Events.kError, onFail)
        http:load(OpNotifyType.kShare)
    end,
    onError = function()
        print("on share fail")
        SnsUtil.showShareFailTip(shareType)
    end,
    onCancel = function()
        print("on share cancel")
    end
    }

    if __WIN32 then
        shareCallback.onSuccess()
        return
    end

    SnsUtil.shareRabbitWeeklyMatchFeed(shareType, shareCallback)
end

function RabbitWeeklyGetFreePlayPanel:updatePanel()
    if not self or self.isDisposed then return end

    local mgr = RabbitWeeklyManager:sharedInstance()
    local mainLevelComplete = mgr.mainLevelCount
    local dailyMainLevelCount = mgr.extraConfig.dailyMainLevelCount
    if mainLevelComplete > dailyMainLevelCount then
        mainLevelComplete = dailyMainLevelCount
    end

    if mgr.mainLevelItemCompleted then -- completed
        self.mainLevelItem:setVisible(false)
        self.buyItem1:setVisible(true)
        if mgr:getRemainingPayCount() > 0 then
            local desc = _text("weekly.race.alert.rabbit.add.times", {num = 1})
            self.buyItem1:update(false, nil, desc)
        else
            local maxCount = mgr:getMaxBuyCount()
            local desc = _text("weekly.race.alert.rabbit.add.times", {num = maxCount})
            self.buyItem1:update(true, nil, desc)
        end
    else
        self.buyItem1:setVisible(false)
        self.mainLevelItem:setVisible(true)
        self.mainLevelItem:update(false, string.format("%d/%d", mainLevelComplete, dailyMainLevelCount))
    end

    local shareCmplete = mgr.share
    local dailyShare = mgr.extraConfig.dailyShare
    if shareCmplete > dailyShare then
        shareCmplete = dailyShare
    end
    if mgr.shareItemCompleted then -- completed
        --self.shareItem:update(true)
        self.shareItem:setVisible(false)
        self.buyItem2:setVisible(true)
        if mgr:getRemainingPayCount() > 0 then
            local desc = _text("weekly.race.alert.rabbit.add.times", {num = 1})
            self.buyItem2:update(false, nil, desc)
        else
            local maxCount = mgr:getMaxBuyCount()
            local desc = _text("weekly.race.alert.rabbit.add.times", {num = maxCount})
            self.buyItem2:update(true, nil, desc)
        end
    else
        self.buyItem2:setVisible(false)
        self.shareItem:update(false)
    end
end

function RabbitWeeklyGetFreePlayPanel.create( parentPanel, levelId, onBuyPlayCardSuccess )
	local panel = RabbitWeeklyGetFreePlayPanel.new()
	panel:init(parentPanel, levelId, onBuyPlayCardSuccess)
	return panel
end

function RabbitWeeklyGetFreePlayPanel:popout()
	-- PopoutManager:sharedInstance():add(self, false, false)
    if self.coveredPanel then 
        local bgLayer = LayerColor:create()
        local panelSize = self.ui:getGroupBounds().size
        local visibleSize = CCDirector:sharedDirector():getVisibleSize()
        local scale = self.coveredPanel:getScale()
        bgLayer:setColor(ccc3(0,0,0))
        bgLayer:setOpacity(0)
        bgLayer:setAnchorPoint(ccp(0, 1))
        bgLayer:ignoreAnchorPointForPosition(false)
        bgLayer:setPosition(ccp(0, 0))
        bgLayer:changeWidthAndHeight(panelSize.width, panelSize.height)
        bgLayer:setTouchEnabled(true, 0 ,true)

        local container = Layer:create()
        local visibleOrigin = Director:sharedDirector():getVisibleOrigin()
        local panelPos = self.coveredPanel:convertToNodeSpace(ccp(visibleOrigin.x, visibleOrigin.y + panelSize.height))
        container:setPosition(ccp(panelPos.x, panelPos.y))
        container:setContentSize(CCSizeMake(panelSize.width,panelSize.height))

        container:addChild(bgLayer)
        container:addChild(self)
        self.coveredPanel.tipPanelContainer = container
        container:setScale(1/scale)
        self.coveredPanel:addChild(container)
        
    	-- self:setToScreenCenter()
        if RabbitWeeklyManager:sharedInstance().mainLevelItemCompleted then
            -- 计费点藏得太深无法让苹果提审看到为了通过提审所以屏蔽掉
            -- self:popoutIapBuyPlayCardPanel()
        end
        self.allowBackKeyTap = true
    	if self.coveredPanel and self.coveredPanel.setRankListPanelTouchDisable then
    		self.coveredPanel:setRankListPanelTouchDisable()
    	end
    end
end

function RabbitWeeklyGetFreePlayPanel:onCloseBtnTapped( ... )
	-- print("RabbitWeeklyGetFreePlayPanel:onCloseBtnTapped")
	-- PopoutManager:sharedInstance():remove(self)
    if self.coveredPanel and not self.coveredPanel.isDisposed then
        if self.coveredPanel:contains(self.coveredPanel.tipPanelContainer) then 
            self.coveredPanel:removeChild(self.coveredPanel.tipPanelContainer)
            self.coveredPanel.tipPanelContainer = nil
        end
        if self.bottomPanel then
            self.bottomPanel:remove()
            self.bottomPanel = nil
        end
        self.allowBackKeyTap = false
    	if self.coveredPanel and self.coveredPanel.setRankListPanelTouchEnable then
    		self.coveredPanel:setRankListPanelTouchEnable()
    	end
    end
end

function RabbitWeeklyGetFreePlayPanel:dispose( ... )
	BaseUI.dispose(self)
end

function RabbitWeeklyGetFreePlayPanel:popoutIapBuyPlayCardPanel()
    if not __IOS then return end
    local mgr = RabbitWeeklyManager:sharedInstance()
    if mgr:getMaxBuyCount() ~= mgr:getRemainingPayCount() then return end
    local function boughtCallback()
        HomeScene:sharedInstance():checkDataChange()
        HomeScene:sharedInstance().goldButton:updateView()

        if self then
            self:onCloseBtnTapped()
            if self.onBuyPlayCardSuccess 
                    and type(self.onBuyPlayCardSuccess) == "function" then 
                self.onBuyPlayCardSuccess()
            end
        end
    end

    local pos = self:getPosition()
    local parent = self:getParent()
    local size = self:getGroupBounds().size
    local wPos = parent:convertToWorldSpace(ccp(pos.x, pos.y - size.height))
    local panel = IapBuyRabbitWeeklyPlayCardPanel:create(self, boughtCallback, wPos.y)
    if panel then panel:popout() end
    self.bottomPanel = panel
end