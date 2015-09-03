ThirdPayPromotionGoods = {
    [18]    = {itemId = 10014, discount = 1}, -- 高级精力瓶
    -- [17]    = {itemId = 10013, discount = 3}, -- 中级精力瓶 -- 暂时缺短代支付点
    [147]   = {itemId = 10052, discount = 1}, -- 章鱼冰
    [5]     = {itemId = 10005, discount = 1}, -- 条纹刷子
    [3]     = {itemId = 10003, discount = 1}, -- 强制交换
    [4]     = {itemId = 10004, discount = 2}, -- +5道具栏
    [24]    = {itemId = 10004, discount = 2}, -- +5 最终
    [46]    = {itemId = 10040, discount = 2}, -- 兔兔导弹
    [150]   = {itemId = 10054, discount = 2}, -- 周赛次数
    [7]     = {itemId = 10010, discount = 3}, -- 小木槌
    [1]     = {itemId = 10001, discount = 3}, -- 刷新
    [151]   = {itemId = 10055, discount = 3}, -- 随机魔力鸟
    [155]   = {itemId = 16,    discount = 3}, -- +15秒
    [153]   = {itemId = 10056, discount = 3}, -- 消2行
    [2]     = {itemId = 10002, discount = 5}, -- 后退
}

require 'zoo.util.OpenUrlUtil'

local PromotionGoodsIdOffset = 5000

ThirdPayGuidePanel = class(BasePanel)
function ThirdPayGuidePanel:create(paymentType)
    local instance = ThirdPayGuidePanel.new()
    instance:loadRequiredResource(PanelConfigFiles.third_pay_guide_panel)
    instance:init(paymentType)
    return instance
end
function ThirdPayGuidePanel:init(paymentType)
    local ui = self:buildInterfaceGroup('ThirdPayGuidePanel')
    BasePanel.init(self, ui)
    local txt = ui:getChildByName('txt')
    txt:setString(localize('pay.fail.help.text'))
    local btn = GroupButtonBase:create(ui:getChildByName('btn'))
    btn:setString(localize('hide.area.panel.go.and.see.btn'))
    btn:ad(DisplayEvents.kTouchTap, function () self:onBtnTapped() end)
    local closeBtn = ui:getChildByName('closeBtn')
    closeBtn:setTouchEnabled(true, 0, true)
    closeBtn:ad(DisplayEvents.kTouchTap, function () self:onCloseBtnTapped() end)
    self.paymentType = paymentType
end
function ThirdPayGuidePanel:onBtnTapped()
    DcUtil:UserTrack({category = "pay", sub_category = "pay_help_panel_click"})
    self:onCloseBtnTapped()
    OpenUrlUtil:openUrl(ThirdPayGuideLogic:getHelpAddress(self.paymentType))
end
function ThirdPayGuidePanel:onCloseBtnTapped()
    self.allowBackKeyTap = false
    PopoutManager:sharedInstance():remove(self, true)
    if self.closeCallback then
        self.closeCallback()
    end
end
function ThirdPayGuidePanel:popout(closeCallback)
    DcUtil:UserTrack({category = "pay", sub_category = "pay_help_panel_pop"})
    PopoutManager:sharedInstance():add(self, false, false)
    self:setToScreenCenterVertical()
    self:setPositionY(self:getPositionY() + 130)
    self:runAction(CCEaseElasticOut:create(CCMoveBy:create(0.8, ccp(0, -130))))

    self.allowBackKeyTap = true
    self.closeCallback = closeCallback
end

ThirdPayDiscountPanel = class(BasePanel)
function ThirdPayDiscountPanel:create(goodsId, closeCallback, buyBtnCallback, smsBuyCallback)
    local instance = ThirdPayDiscountPanel.new()
    instance:loadRequiredResource(PanelConfigFiles.third_pay_guide_panel)
    instance:init(goodsId, closeCallback, buyBtnCallback, smsBuyCallback)
    return instance
end
function ThirdPayDiscountPanel:init(goodsId, closeCallback, buyBtnCallback, smsBuyCallback)
    local ui = self:buildInterfaceGroup('ThirdPayDiscountPanel')
    BasePanel.init(self, ui)
    local builder = InterfaceBuilder:create(PanelConfigFiles.properties)
    local iconPath = 'Goods_'..goodsId
    if goodsId == 24 then
        iconPath = 'Goods_4'
    end
    local icon = builder:buildGroup(iconPath)
    local discount = ThirdPayPromotionGoods[goodsId].discount or 10
    local meta = MetaManager:getInstance():getGoodMeta(goodsId + PromotionGoodsIdOffset)
    local originalPrice
    if goodsId == 17 then
        originalPrice = tonumber(meta.qCash)
    else
        originalPrice = tonumber(meta.rmb) / 100
    end
    local promoPrice = tonumber(meta.thirdRmb) / 100
    self.promoPrice = promoPrice
    local itemName = localize('goods.name.text'..goodsId)

    if goodsId == 17 then
        ui:getChildByName('originalPrice'):setString(originalPrice)
        ui:getChildByName('coin'):setPositionX(ui:getChildByName('coin'):getPositionX() + 5)
    else
        ui:getChildByName('originalPrice'):setString(string.format("%s%0.2f", localize("buy.gold.panel.money.mark"), originalPrice))
        ui:getChildByName('coin'):setVisible(false)
    end

    -- ui:getChildByName('originalPrice'):setString(string.format("%s%0.2f", localize("buy.gold.panel.money.mark"), originalPrice))
    ui:getChildByName('desc'):setString(localize('buy.prop.panel.sale.title', {item_name = itemName}))
    local btn = GroupButtonBase:create(ui:getChildByName('btn'))
    btn:setString(string.format("%s%0.2f%s", localize("buy.gold.panel.money.mark"), promoPrice, '购买'))
    btn:ad(DisplayEvents.kTouchTap, 
        function ()  
            -- self:removeSelf()
            self:disableButtons()
            setTimeOut(function () self:enableButtons() end, 3)
            if self.buyBtnCallback then
                self.buyBtnCallback()
            end
        end)
    btn:setColorMode(kGroupButtonColorMode.blue)
    self.buyBtn = btn

    local closeBtn = ui:getChildByName('closeBtn')
    closeBtn:ad(DisplayEvents.kTouchTap, 
        function() 
            self:onCloseBtnTapped()
        end)
    closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn = closeBtn

    local discountLabel = ui:getChildByName('discount')
    local discountTxt = discountLabel:getChildByName('text')
    local discountNum = discountLabel:getChildByName('num')
    discountTxt:setScale(0.35)
    discountTxt:setText(localize('buy.gold.panel.discount'))
    discountTxt:setPositionX(discountTxt:getPositionX() + 8)
    discountTxt:setPositionY(discountTxt:getPositionY() + 2)
    discountNum:setScale(0.95)
    discountNum:setText(discount)
    discountNum:setPositionX(discountNum:getPositionX() + 8)
    discountNum:setPositionY(discountNum:getPositionY() + 4)

    local ph = ui:getChildByName('icon')
    ph:setVisible(false)
    ph:getParent():addChildAt(icon, ph:getZOrder())
    icon:setPosition(ccp(ph:getPositionX(), ph:getPositionY()))
    icon:setScale(ph:getScaleX() * ph:getContentSize().width / icon:getGroupBounds().size.width)

    self.closeCallback = closeCallback
    self.buyBtnCallback = buyBtnCallback
    self.smsBuyCallback = smsBuyCallback

    self.smsBuyButton = ui:getChildByName('smsBuyButton')


    local supportSms = (IngamePaymentLogic:getSMSPaymentDecision() ~= IngamePaymentDecisionType.kPayFailed and PaymentManager.getInstance():checkSmsPayEnabled())
    if supportSms then
        self.smsBuyButton:setButtonMode(true)
        self.smsBuyButton:setTouchEnabled(true, 0, true)
        self.smsBuyButton:ad(DisplayEvents.kTouchTap, 
            function () 
                -- self:removeSelf()
                self:disableButtons()
                setTimeOut(function () self:enableButtons() end, 3)
                self.animation = CountDownAnimation:createNetworkAnimation(Director:sharedDirector():getRunningScene(), nil) 
                if self.smsBuyCallback then 
                    self.smsBuyCallback() 
                end 
            end)
    else
        self.smsBuyButton:setVisible(false)
    end
end

function ThirdPayDiscountPanel:enableButtons()
    if self.isDisposed then return end
    self.buyBtn:setEnabled(true)
    self.smsBuyButton:setTouchEnabled(true, 0, true)
    if self.animation and not self.animation.isDisposed then
        self.animation:removeFromParentAndCleanup(true)
        self.animation = nil
    end
end

function ThirdPayDiscountPanel:disableButtons()
    if self.isDisposed then return end
    self.buyBtn:setEnabled(false)
    self.smsBuyButton:setTouchEnabled(false)
end

function ThirdPayDiscountPanel:onCloseBtnTapped()
    if self.closeCallback then
        self.closeCallback(self.failBeforePayEnd, self.promoPrice)
    end
    self:removeSelf()
end

function ThirdPayDiscountPanel:removeSelf()
    self.allowBackKeyTap = false
    PopoutManager:sharedInstance():remove(self, true)
    self:removeSkeleton()
    if self.animation and not self.animation.isDisposed then
        self.animation:removeFromParentAndCleanup(true)
        self.animation = nil
    end
end

function ThirdPayDiscountPanel:skeleton()
    self.anim = CommonSkeletonAnimation:createTutorialMoveIn2()
    local scene = Director:sharedDirector():getRunningScene()
    local vo = Director:sharedDirector():getVisibleOrigin()
    local vs = Director:sharedDirector():getVisibleSize()
    scene:addChild(self.anim)
    self.anim:setPosition(ccp(vo.x + vs.width - 80, vo.y + vs.height / 2 - 10))
    self.anim:setRotation(30)
    setTimeOut(
        function () 
            self:removeSkeleton()
        end, 4)
end

function ThirdPayDiscountPanel:removeSkeleton()
    if self.anim then 
        self.anim:removeFromParentAndCleanup(true) 
        self.anim = nil
    end 
end

function ThirdPayDiscountPanel:popout()
    PopoutManager:sharedInstance():add(self, false, false)
    self:skeleton()
    self:setToScreenCenterVertical()
    self:setPositionY(self:getPositionY() + 130)
    self:runAction(CCEaseElasticOut:create(CCMoveBy:create(0.8, ccp(0, -130))))

    self.allowBackKeyTap = true
end

function ThirdPayDiscountPanel:setFailBeforePayEnd()
    self.failBeforePayEnd = true
end

ThirdPayGuideLogic = class()

local instance = nil
function ThirdPayGuideLogic:get()
    if not instance then
        instance = ThirdPayGuideLogic.new()
        instance:init()
    end
    return instance
end

function ThirdPayGuideLogic:init()

end

function ThirdPayGuideLogic:onPayFailure(paymentType, closeCallback)
    if CCUserDefault:sharedUserDefault():getBoolForKey("third.pay.first.failure.has.played", false) then
        if closeCallback then closeCallback() end
        return
    end
    ThirdPayGuidePanel:create(paymentType):popout(closeCallback)
    CCUserDefault:sharedUserDefault():setBoolForKey("third.pay.first.failure.has.played", true)
end

function ThirdPayGuideLogic:isPromotionGoods(goodsId)
    -- 活动期间有限商城风车币特价，不出这个特价
    if _G.thirdPayConfig and _G.thirdPayConfig.isSupport() then
        return nil
    end
    local isInTable = ThirdPayPromotionGoods[goodsId]
    return isInTable
end

function ThirdPayGuideLogic:shouldShowMarketBtnTip()
    if _G.thirdPayConfig and _G.thirdPayConfig.isSupport() then
        local yearDay = os.date('*t', Localhost:time() / 1000).yday  -- 虽然yday并不是全局唯一，但是在活动中可以保证是不重复的
        if not CCUserDefault:sharedUserDefault():getBoolForKey("third.pay.market.tip."..yearDay, false) then
            return true
        end
    end
    return false
end

function ThirdPayGuideLogic:MarketBtnTipPlayed()
    local yearDay = os.date('*t', Localhost:time() / 1000).yday
    CCUserDefault:sharedUserDefault():setBoolForKey("third.pay.market.tip."..yearDay, true)
end

function ThirdPayGuideLogic:getHelpAddress(paymentType)
    if paymentType == Payments.WECHAT then
        return 'http://xiaoqu.qq.com/mobile/detail.html?&&_wv=1027#bid=130050&pid=4748639-1433834487&source=barindex&from=buluoadmin'
    elseif paymentType == Payments.ALIPAY then
        return 'http://xiaoqu.qq.com/mobile/detail.html?&&_wv=1027#bid=130050&pid=4748639-1433834948&source=barindex&from=buluoadmin'
    end
end