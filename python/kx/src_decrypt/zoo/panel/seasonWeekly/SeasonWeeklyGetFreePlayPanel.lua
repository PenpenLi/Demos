require "zoo.panelBusLogic.IapBuyPropLogic"
require "zoo.panel.rabbitWeekly.IapBuyRabbitWeeklyPlayCardPanel"
require "zoo.panel.TwoChoicePanel"

local function _text(key, replace)
    return Localization:getInstance():getText(key, replace)
end

SeasonWeeklyGetFreePlayItem = class()

function SeasonWeeklyGetFreePlayItem:init( ui, useIconNumBtn, useMainLevelIcon )
    self.ui = ui
    self.useIconNumBtn = useIconNumBtn

    self.icon           = self.ui:getChildByName("icon")
    self.statusLabel    = self.ui:getChildByName("status") -- may be nil
    self.common         = self.ui:getChildByName("common")

    self.title          = self.common:getChildByName("title")
    self.desc           = self.common:getChildByName("desc")
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

function SeasonWeeklyGetFreePlayItem:update(completed, statusTxt, desc)
    completed = completed or false
    if desc then self.desc:setString(desc) end
    if statusTxt and self.statusLabel then self.statusLabel:setString(statusTxt) end

    if completed then
        self.btn:setVisible(false)
        self.icon:setVisible(false)
        if self.statusLabel then self.statusLabel:setVisible(false) end
        
        self.completedFlag:setVisible(true)
        self.label:setVisible(true)
    else
        self.label:setVisible(false)
        self.completedFlag:setVisible(false)

        self.icon:setVisible(true)
        if self.statusLabel then self.statusLabel:setVisible(true) end
        self.btn:setVisible(true)
    end
end

function SeasonWeeklyGetFreePlayItem:setVisible(v)
    if not self.ui or self.ui.isDisposed then return end
    self.ui:setVisible(v)
    self.btn:setEnabled(v)
    if self.helpBtn then self.helpBtn:setTouchEnabled(v) end
end

function SeasonWeeklyGetFreePlayItem:isVisible()
    if not self.ui or self.ui.isDisposed then return false end
    return self.ui:isVisible()
end

function SeasonWeeklyGetFreePlayItem:create(ui, useIconNumBtn, useMainLevelIcon)
    local item = SeasonWeeklyGetFreePlayItem.new()
    item:init(ui, useIconNumBtn, useMainLevelIcon)
    return item
end

function SeasonWeeklyGetFreePlayItem:getPositionX()
    return self.ui:getPositionX()
end

function SeasonWeeklyGetFreePlayItem:setPositionX(v)
    self.ui:setPositionX(v)
end

-----------------------------------------
--- SeasonWeeklyGetFreePlayPanel
-----------------------------------------
SeasonWeeklyGetFreePlayPanel = class(BasePanel)

function SeasonWeeklyGetFreePlayPanel:init(coveredPanel, levelId, onBuyPlayCardSuccess)
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

    local mgr = SeasonWeeklyRaceManager:getInstance()
    local cfg = SeasonWeeklyRaceConfig:getInstance()

    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
        self.ui:getChildByName("itemShareWeChat"):removeFromParentAndCleanup(true)
        self.shareItem = SeasonWeeklyGetFreePlayItem:create(self.ui:getChildByName("itemShareMitalk"))
        self.shareItem.title:setString(_text("weekly.race.autumn.sendhelp.mitalk.des1"))
        self.shareItem.btn:setString(_text("weekly.race.autumn.sendhelp.mitalk.btn"))
    else
        self.ui:getChildByName("itemShareMitalk"):removeFromParentAndCleanup(true)
        self.shareItem = SeasonWeeklyGetFreePlayItem:create(self.ui:getChildByName("itemShareWeChat"))
        self.shareItem.title:setString(_text("weekly.race.autumn.sendhelp.des1"))
        self.shareItem.btn:setString(_text("weekly.race.autumn.sendhelp.btn"))
    end
    self.shareItem.desc:setString(_text("weekly.race.alert.rabbit.add.times", {num = cfg.freePlayByShare}))
    self.shareItem.label:setString(_text("weekly.race.alert.rabbit.times.button3"))
    self.shareItem.btn:setColorMode(kGroupButtonColorMode.blue)
    local function onShareItemBtnTapped(event)
        self:onShareBtnTapped()
    end
    self.shareItem.btn:ad(DisplayEvents.kTouchTap, onShareItemBtnTapped)

    self.mainLevelItem = SeasonWeeklyGetFreePlayItem:create(self.ui:getChildByName("itemMainLevel"), false, true)
    self.mainLevelItem.title:setString(_text("weeklyrace.winter.panel.desc15"))
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
        -- 这个引导的位置已改
        -- SeasonWeeklyRaceManager:getInstance():showWeeklyTimeTutor()
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

function SeasonWeeklyGetFreePlayPanel:initBuyItems()
    local goods = MetaManager:getInstance():getGoodMeta(SeasonWeeklyRaceConfig:getInstance().playCardGoodId)
    local userExtend = UserManager:getInstance().userExtend
    local buyItemRes = self.ui:getChildByName("itemBuy")
    if __ANDROID and not PaymentManager.getInstance():checkCanWindMillPay(goods.id) then
        self.buyItem = SeasonWeeklyGetFreePlayItem:create(buyItemRes, false)
        local price = goods.rmb / 100
        local mark = _text("buy.gold.panel.money.mark")
        local text = _text("weekly.race.panel.rabbit.button2")
        local label = string.format("%s%0.2f", mark, price)
        self.buyItem.btn:setString(label)
    else
        self.buyItem = SeasonWeeklyGetFreePlayItem:create(buyItemRes, true)
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
        if SeasonWeeklyRaceManager:getInstance():isNeedShowTimeWarnPanel() then
            self:showTimeNotEnoughWarningPanel(onConfirmBuy, onCancelBuy)
        else
            onConfirmBuy()
        end
    end
    self.buyItem.btn:ad(DisplayEvents.kTouchTap, onBuyItemBtnTapped)
end

function SeasonWeeklyGetFreePlayPanel:showTimeNotEnoughWarningPanel(onConfirm, onCancel)
    local descText = Localization:getInstance():getText("weekly.race.winter.start.tip1")
    local panel = TwoChoicePanel:create(descText, "取消", "继续", "不再提醒", true)
    local function onCancelBtnTapped(dontShowAgain)
        SeasonWeeklyRaceManager:getInstance():setTimeWarningDisabled(dontShowAgain)
        if onCancel then onCancel() end
    end
    local function onConfirmBtnTapped(dontShowAgain)
        SeasonWeeklyRaceManager:getInstance():setTimeWarningDisabled(dontShowAgain)
        if onConfirm then onConfirm() end
    end
    panel:setButton1TappedCallback(onCancelBtnTapped)
    panel:setButton2TappedCallback(onConfirmBtnTapped)
    panel:setCloseButtonTappedCallback(onCancelBtnTapped)
    panel:popout()
end

function SeasonWeeklyGetFreePlayPanel:onBuyItemBtnTapped()
    local function onSuccess()
        HomeScene:sharedInstance():checkDataChange()
        HomeScene:sharedInstance().goldButton:updateView()

        local goods = MetaManager:getInstance():getGoodMeta(SeasonWeeklyRaceConfig:getInstance().playCardGoodId)
        local cost = goods.qCash

        local function finish()
            if self then
                self:onCloseBtnTapped()
                if self.onBuyPlayCardSuccess 
                        and type(self.onBuyPlayCardSuccess) == "function" then 
                    self.onBuyPlayCardSuccess()
                end
            end
        end

        local array = CCArray:create()

        if not(__ANDROID and not PaymentManager.getInstance():checkCanWindMillPay(goods.id)) then
            array:addObject(CCDelayTime:create(0.8))

            local bounds = self.buyItem.btn:getGroupBounds()
            self.buyItem.btn:playFloatAnimation('-'..cost)
        end

        array:addObject(CCCallFunc:create(finish))
        self:runAction(CCSequence:create(array))
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
    SeasonWeeklyRaceManager:getInstance():buyPlayCard( onSuccess, onFail, onCancel, onFinish, true)
end

-- function SeasonWeeklyGetFreePlayPanel:onTouched()
--     local boundsLayer = LayerColor:create()
--     boundsLayer:setColor(ccc3(255,0,0))
--     local closeBtnSize = self.closeBtn:getGroupBounds().size
--     boundsLayer:changeWidthAndHeight(closeBtnSize.width, closeBtnSize.height)
--     self.closeBtn:addChild(boundsLayer)
-- end

function SeasonWeeklyGetFreePlayPanel:onShareBtnTapped()
    local shareType = PlatformShareEnum.kWechat
    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
        shareType = PlatformShareEnum.kMiTalk
    end

    local function onSuccess(addCount)
        local shareCallback = {
            onSuccess = function(data)
                DcUtil:seasonWeeklyShareSucceed()
            end,
            onError = function(data) end,
            onCancel = function(date) end,
        }

        if __WIN32 then
            shareCallback.onSuccess()
        else
            setTimeOut(function()
                if self.isDisposed then return end
                self.shareItem.btn:setEnabled(true)
            end, 2)
            SnsUtil.shareSummerWeeklyMatchFeed(shareType, shareCallback)
        end

        if type(addCount) == "number" and addCount > 0 then
            if shareType == PlatformShareEnum.kMiTalk or shareType == PlatformShareEnum.kWechat then
                CommonTip:showTip(Localization:getInstance():getText("weekly.race.share.feed.success.add.count", {num = addCount}), "positive", nil, 3)
            end
        else
            if shareType == PlatformShareEnum.kMiTalk then
                CommonTip:showTip(Localization:getInstance():getText("weekly.race.share.feed.success.mitalk.tips", {num = 1}), "positive", nil, 3)
            elseif shareType == PlatformShareEnum.kWechat then
                CommonTip:showTip(Localization:getInstance():getText("weekly.race.share.feed.success.tips"), "positive")
            end
        end            
        self:onCloseBtnTapped()
    end

    local function onFail(event)
        self.shareItem.btn:setEnabled(true)
        if type(event) == "table" and event.data then
            CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(event.data)))
        elseif shareType == PlatformShareEnum.kMiTalk then
             CommonTip:showTip(Localization:getInstance():getText("share.feed.faild.tips.mitalk"), "negative")
        else
            CommonTip:showTip(Localization:getInstance():getText("share.feed.faild.tips"), "negative")
        end
    end

    local function onCancel()
        self.shareItem.btn:setEnabled(true)
    end

    local function callWithConnection()
        self.shareItem.btn:setEnabled(false)
        SeasonWeeklyRaceManager:getInstance():onShareSuccess(onSuccess, onFail, onCancel)
    end
    
    DcUtil:seasonWeeklyShareTapped()
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

function SeasonWeeklyGetFreePlayPanel:updatePanel()
    if not self or self.isDisposed then return end

    local mgr = SeasonWeeklyRaceManager:getInstance()
    local cfg = SeasonWeeklyRaceConfig:getInstance()

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

function SeasonWeeklyGetFreePlayPanel:create( parentPanel, levelId, onBuyPlayCardSuccess )
	local panel = SeasonWeeklyGetFreePlayPanel.new()
	panel:init(parentPanel, levelId, onBuyPlayCardSuccess)
	return panel
end

function SeasonWeeklyGetFreePlayPanel:popout(weeklyDecisionType)
    PopoutManager:sharedInstance():add(self, true)
    self:addTutorMask(weeklyDecisionType)
    self.allowBackKeyTap = true
end

function SeasonWeeklyGetFreePlayPanel:onCloseBtnTapped( ... )
    self.allowBackKeyTap = false
    PopoutManager:sharedInstance():remove(self)
end

function SeasonWeeklyGetFreePlayPanel:addTutorMask(weeklyDecisionType)
    local winSize = CCDirector:sharedDirector():getWinSize()
    local designSizeHeight = 1280
    local widthParam = 960
    local function showTutorMask()
        local anim = CommonSkeletonAnimation:createTutorialMoveIn2()
        anim:setScaleX(-1)
        self.ui:addChild(anim) 
        anim:setPosition(ccp(110, -285))
    end
    if weeklyDecisionType and (weeklyDecisionType == SeasonWeeklyDecisionType.kMainLevelTutorIn or
                                weeklyDecisionType == SeasonWeeklyDecisionType.kShareTutor) then 
        if self.ui then 
            self.ui:runAction(CCCallFunc:create(showTutorMask))
        end
    end
end