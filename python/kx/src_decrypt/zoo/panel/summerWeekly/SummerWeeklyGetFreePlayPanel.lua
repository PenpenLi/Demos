require "zoo.panelBusLogic.IapBuyPropLogic"
require "zoo.panel.rabbitWeekly.IapBuyRabbitWeeklyPlayCardPanel"
require "zoo.panel.TwoChoicePanel"

local function _text(key, replace)
    return Localization:getInstance():getText(key, replace)
end

SummerWeeklyGetFreePlayItem = class()

function SummerWeeklyGetFreePlayItem:init( ui, useIconNumBtn, useMainLevelIcon )
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

function SummerWeeklyGetFreePlayItem:update(completed, statusTxt, desc)
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

function SummerWeeklyGetFreePlayItem:setVisible(v)
    if not self.ui or self.ui.isDisposed then return end
    self.ui:setVisible(v)
    self.btn:setEnabled(v)
    if self.helpBtn then self.helpBtn:setTouchEnabled(v) end
end

function SummerWeeklyGetFreePlayItem:isVisible()
    if not self.ui or self.ui.isDisposed then return false end
    return self.ui:isVisible()
end

function SummerWeeklyGetFreePlayItem:create(ui, useIconNumBtn, useMainLevelIcon)
    local item = SummerWeeklyGetFreePlayItem.new()
    item:init(ui, useIconNumBtn, useMainLevelIcon)
    return item
end

function SummerWeeklyGetFreePlayItem:getPositionX()
    return self.ui:getPositionX()
end

function SummerWeeklyGetFreePlayItem:setPositionX(v)
    self.ui:setPositionX(v)
end

-----------------------------------------
--- SummerWeeklyGetFreePlayPanel
-----------------------------------------
SummerWeeklyGetFreePlayPanel = class(BasePanel)

function SummerWeeklyGetFreePlayPanel:init(coveredPanel, levelId, onBuyPlayCardSuccess)
	self.coveredPanel = coveredPanel
    self.onBuyPlayCardSuccess = onBuyPlayCardSuccess
    self.levelId = levelId

	self:loadRequiredResource("ui/summer_weekly_get_free_play_panel.json")
    local ui = self:buildInterfaceGroup('SummerWeeklyGetFreePlayPanel/Panel')
    print(ui)
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

    local mgr = SummerWeeklyMatchManager:getInstance()
    local cfg = SummerWeeklyMatchConfig:getInstance()

    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
        self.ui:getChildByName("itemShareWeChat"):removeFromParentAndCleanup(true)
        self.shareItem = SummerWeeklyGetFreePlayItem:create(self.ui:getChildByName("itemShareMitalk"))
        self.shareItem.title:setString(_text("weekly.race.alert.rabbit.times2.mitalk"))
    else
        self.ui:getChildByName("itemShareMitalk"):removeFromParentAndCleanup(true)
        self.shareItem = SummerWeeklyGetFreePlayItem:create(self.ui:getChildByName("itemShareWeChat"))
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

    self.mainLevelItem = SummerWeeklyGetFreePlayItem:create(self.ui:getChildByName("itemMainLevel"), false, true)
    self.mainLevelItem.title:setString(_text("weeklyrace.summer.panel.desc15"))
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
        CommonTip:showTip(_text("weekly.race.alert.rabbit.tip.times1"), "positive", nil, 3)
    end
    self.mainLevelItem.helpBtn:ad(DisplayEvents.kTouchTap, onMainLevelHelpBtnTapped)

    local function showRabbitTutor()
        SummerWeeklyMatchManager:getInstance():showWeeklyTimeTutor()
    end

    local function onMainLevelItemBtnTapped(event)
        PopoutManager:sharedInstance():removeAll()
        self:onCloseBtnTapped()
        HomeScene:sharedInstance().worldScene:moveTopLevelNodeToCenter(showRabbitTutor)
        -- HomeScene:sharedInstance().worldScene:moveTopLevelNodeToCenter()
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

    self:scaleAccordingToResolutionConfig()
    self:setPositionForPopoutManager()
end

function SummerWeeklyGetFreePlayPanel:initBuyItems()
    local goods = MetaManager:getInstance():getGoodMeta(SummerWeeklyMatchConfig:getInstance().playCardGoodId)
    local userExtend = UserManager:getInstance().userExtend
    local buyItemRes = self.ui:getChildByName("itemBuy")
    if __ANDROID and not PaymentManager.getInstance():checkCanWindMillPay(goods.id) then
        self.buyItem = SummerWeeklyGetFreePlayItem:create(buyItemRes, false)
        local price = goods.rmb / 100
        local mark = _text("buy.gold.panel.money.mark")
        local text = _text("weekly.race.panel.rabbit.button2")
        local label = string.format("%s%0.2f", mark, price)
        self.buyItem.btn:setString(label)
    else
        self.buyItem = SummerWeeklyGetFreePlayItem:create(buyItemRes, true)
        local price = goods.qCash
        self.buyItem.btn:setIconByFrameName('ui_images/ui_image_coin_icon_small0000')
        self.buyItem.btn:setNumber(price)
        self.buyItem.btn:setString(_text("weekly.race.panel.rabbit.button2"))
    end
    self.buyItem.btn:setColorMode(kGroupButtonColorMode.blue)
    self.buyItem.title:setString(_text("weekly.race.alert.rabbit.buy.times"))
    self.buyItem.desc:setString(_text("weekly.race.alert.rabbit.add.times", {num = 1}))
    self.buyItem.label:setString(_text("weekly.race.alert.rabbit.buy.times.maximum"))
    
    local function onBuyItemBtnTapped(event)
        local function onCancelBuy()
        end
        local function onConfirmBuy()
            self:onBuyItemBtnTapped()
        end
        if SummerWeeklyMatchManager:getInstance():isNeedShowTimeWarnPanel() then
            self:showTimeNotEnoughWarningPanel(onConfirmBuy, onCancelBuy)
        else
            onConfirmBuy()
        end
    end
    self.buyItem.btn:ad(DisplayEvents.kTouchTap, onBuyItemBtnTapped)
end

function SummerWeeklyGetFreePlayPanel:showTimeNotEnoughWarningPanel(onConfirm, onCancel)
    local descText = Localization:getInstance():getText("weekly.race.summer.start.tip1")
    local panel = TwoChoicePanel:create(descText, "取消", "继续", "不再提醒", true)
    local function onCancelBtnTapped(dontShowAgain)
        SummerWeeklyMatchManager:getInstance():setTimeWarningDisabled(dontShowAgain)
        if onCancel then onCancel() end
    end
    local function onConfirmBtnTapped(dontShowAgain)
        SummerWeeklyMatchManager:getInstance():setTimeWarningDisabled(dontShowAgain)
        if onConfirm then onConfirm() end
    end
    panel:setButton1TappedCallback(onCancelBtnTapped)
    panel:setButton2TappedCallback(onConfirmBtnTapped)
    panel:setCloseButtonTappedCallback(onCancelBtnTapped)
    panel:popout()
end

function SummerWeeklyGetFreePlayPanel:onBuyItemBtnTapped()
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
        self.buyItem.btn:setEnabled(true)
        self:updatePanel()
    end

    local function onCancel()
        self.buyItem.btn:setEnabled(true)
        self:updatePanel()
    end

    local function onFinish()
        self:updatePanel()
    end

    self.buyItem.btn:setEnabled(false)
    SummerWeeklyMatchManager:getInstance():buyPlayCard( onSuccess, onFail, onCancel, onFinish, true)
end

-- function SummerWeeklyGetFreePlayPanel:onTouched()
--     local boundsLayer = LayerColor:create()
--     boundsLayer:setColor(ccc3(255,0,0))
--     local closeBtnSize = self.closeBtn:getGroupBounds().size
--     boundsLayer:changeWidthAndHeight(closeBtnSize.width, closeBtnSize.height)
--     self.closeBtn:addChild(boundsLayer)
-- end

function SummerWeeklyGetFreePlayPanel:onShareBtnTapped()
    local shareType = PlatformShareEnum.kWechat
    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
        shareType = PlatformShareEnum.kMiTalk
    end

    local shareCallback = {
    onSuccess = function(data)
        print("on share success", tostring(data))
        local function onSuccess(event)
            DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_share_content', share_id=3})
            if shareType == PlatformShareEnum.kMiTalk then
                CommonTip:showTip(Localization:getInstance():getText("share.feed.success.tips.mitalk"), "positive")
            elseif shareType == PlatformShareEnum.kWechat then
                CommonTip:showTip(Localization:getInstance():getText("share.feed.success.tips"), "positive")
            end
            self:onCloseBtnTapped()
        end

        local function onFail(event)
            if shareType == PlatformShareEnum.kMiTalk then
                CommonTip:showTip(Localization:getInstance():getText("share.feed.faild.tips.mitalk"), "negative")
            elseif shareType == PlatformShareEnum.kWechat then
                CommonTip:showTip(Localization:getInstance():getText("share.feed.faild.tips"), "negative")
            end
        end
        SummerWeeklyMatchManager:getInstance():onShareSuccess(onSuccess, onFail)
    end,
    onError = function()
        print("on share fail")
        self.shareItem.btn:setEnabled(true)
        if shareType == PlatformShareEnum.kMiTalk then
            CommonTip:showTip(Localization:getInstance():getText("share.feed.faild.tips.mitalk"), "negative")
        elseif shareType == PlatformShareEnum.kWechat then
            CommonTip:showTip(Localization:getInstance():getText("share.feed.faild.tips"), "negative")
        end
    end,
    onCancel = function()
        self.shareItem.btn:setEnabled(true)
        print("on share cancel")
    end
    }

    if __WIN32 then
        shareCallback.onSuccess()
        return
    end

    local function callWithConnection()
        self.shareItem.btn:setEnabled(false)
        setTimeOut(function()
            if self.isDisposed then return end
            self.shareItem.btn:setEnabled(true)
        end, 2)
        SnsUtil.shareSummerWeeklyMatchFeed(shareType, shareCallback)
    end

    if __IOS then
        if ReachabilityUtil.getInstance():isNetworkAvailable() then
            RequireNetworkAlert:callFuncWithLogged(callWithConnection, nil)
        else
            CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"))
        end
    else
        RequireNetworkAlert:callFuncWithLogged(callWithConnection, nil)
    end
end

function SummerWeeklyGetFreePlayPanel:updatePanel()
    if not self or self.isDisposed then return end

    local mgr = SummerWeeklyMatchManager:getInstance()
    local cfg = SummerWeeklyMatchConfig:getInstance()

    local mainLevelComplete = mgr:getDailyLevelPlayCount()
    local dailyMainLevelCount = cfg.dailyMainLevelPlay
    if mainLevelComplete > dailyMainLevelCount then
        mainLevelComplete = dailyMainLevelCount
    end
    self.mainLevelItem:update(mainLevelComplete >= dailyMainLevelCount,
        string.format("%d/%d", mainLevelComplete, dailyMainLevelCount),
        _text("weekly.race.alert.rabbit.add.times", {num = cfg.freePlayByMainLevel}))

    local shareCmplete = mgr:getShareCount()
    local dailyShare = cfg.dailyShare
    if shareCmplete > dailyShare then
        shareCmplete = dailyShare
    end
    self.shareItem:update(shareCmplete >= dailyShare, nil,
        _text("weekly.race.alert.rabbit.add.times", {num = cfg.freePlayByShare}))

    if mgr:getLeftBuyCount() > 0 then
        self.buyItem:update(false, nil, _text("weekly.race.alert.rabbit.add.times", {num = 1}))
    else
        local maxCount = mgr:getMaxBuyCount()
        self.buyItem:update(true, nil, _text("weekly.race.alert.rabbit.add.times", {num = maxCount}))
    end

    if mgr:getLeftBuyCount() > 0 then
        self.mainLevelItem:setVisible(mainLevelComplete < dailyMainLevelCount)
        self.shareItem:setVisible(not self.mainLevelItem:isVisible())
        self.shareItem:setPositionX(self.mainLevelItem:getPositionX())
        self.buyItem:setVisible(true)
    else
        self.mainLevelItem:setVisible(true)
        self.shareItem:setVisible(true)
        self.shareItem:setPositionX(self.buyItem:getPositionX())
        self.buyItem:setVisible(false)
    end
end

function SummerWeeklyGetFreePlayPanel:create( parentPanel, levelId, onBuyPlayCardSuccess )
	local panel = SummerWeeklyGetFreePlayPanel.new()
	panel:init(parentPanel, levelId, onBuyPlayCardSuccess)
	return panel
end

function SummerWeeklyGetFreePlayPanel:popout()
    PopoutManager:sharedInstance():add(self)
    self.allowBackKeyTap = true
end

function SummerWeeklyGetFreePlayPanel:onCloseBtnTapped( ... )
    self.allowBackKeyTap = false
    PopoutManager:sharedInstance():remove(self)
end