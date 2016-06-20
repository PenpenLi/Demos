require 'zoo.panel.iosSalesPromotion.SalesButton'
require 'zoo.panel.iosSalesPromotion.IosSalesItemBubble'

local IosDiscountUI = class(BaseUI)
function IosDiscountUI:ctor()
    
end

function IosDiscountUI:init()
    BaseUI.init(self, self.ui)  

    local discountNumUI = self.ui:getChildByName("num")
    discountNumUI:setText(self.discoutNum)
end

function IosDiscountUI:create(ui, discoutNum)
    local discountUI = IosDiscountUI.new()
    discountUI.ui = ui
    discountUI.discoutNum = discoutNum
    discountUI:init()
    return discountUI
end


IosSalesBasePanel = class(BasePanel)

function IosSalesBasePanel:ctor()
	self.countDownLabel = nil
	self.buyButton = nil
	self.rewardsInfo = nil
	self.data = nil
	self.cdSeconds = nil
	self.promoEndCallback = nil
end

function IosSalesBasePanel:init(ui)
	BasePanel.init(self, ui)

    local titleUI = self.ui:getChildByName("title")
    self.panelTitle = TextField:createWithUIAdjustment(titleUI:getChildByName("panelTitleSize"), titleUI:getChildByName("panelTitle"))
    titleUI:addChild(self.panelTitle)

	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap,  function ()
		self:onCloseBtnTapped()
	end)

    self.countDownLabel = self.ui:getChildByName("label")

    self.buyButton = SalesButton:create(self.ui:getChildByName("buyBtn"))
	self.buyButton:addEventListener(DisplayEvents.kTouchTap, function (evt)
		self:onBuyBtnTap()
	end)
	self.buyButton:setString(localize("buy.gold.panel.money.mark")..self.data.price)
	self.buyButton:setOtherString(localize("buy.prop.panel.btn.buy.txt"))
	self.buyButton:setOriPrice(localize("buy.gold.panel.money.mark")..self.data.oriPrice)	

	self.resetButton = GroupButtonBase:create(ui:getChildByName('resetBtn'))
	self.resetButton:setString("重置道具")
    self.resetButton:ad(DisplayEvents.kTouchTap, function () self:onResetPanel() end)
    self.resetButton:setVisible(IosPayGuide:maintenanceEnabled() and IosPayGuide:isInAppleVerification())

    IosDiscountUI:create(self.ui:getChildByName("discount"), self.data.discount) 

    self.dcIosInfo = DCIosRmbObject:create()
    self.dcIosInfo:setGoodsId(self.data.productIdentifier)
    self.dcIosInfo:setGoodsType(1)
    self.dcIosInfo:setGoodsNum(1)
    self.dcIosInfo:setRmbPrice(self.data.iapPrice)

    self:startTimer()
end

function IosSalesBasePanel:pushSingleReward(icon, itemId, num)
	if not self.rewardsInfo then 
		self.rewardsInfo = {}
	end
	local singleReward = {}
	singleReward.icon = icon
	singleReward.itemId = itemId 
	singleReward.num = num

	table.insert(self.rewardsInfo, singleReward)
end

function IosSalesBasePanel:getPaymentEventDispatcher()
	local peDispatcher = PaymentEventDispatcher.new()
    local function successDcFunc(evt)
        self.dcIosInfo:setResult(IosRmbPayResult.kSuccess)
        PaymentIosDCUtil.getInstance():sendIosRmbPayEnd(self.dcIosInfo)
    end
    local function failedDcFunc(evt)
        self.dcIosInfo:setResult(IosRmbPayResult.kSdkFail)
        PaymentIosDCUtil.getInstance():sendIosRmbPayEnd(self.dcIosInfo)
    end
    peDispatcher:addEventListener(PaymentEvents.kIosBuySuccess, successDcFunc)
    peDispatcher:addEventListener(PaymentEvents.kIosBuyFailed, failedDcFunc)
    return peDispatcher
end

function IosSalesBasePanel:buySuccess()
    if self.isDisposed then return end
    if IosPayGuide:maintenanceEnabled() and IosPayGuide:isInAppleVerification() then
        self:playRewardAnim(self.rewardsInfo)
        self:onResetPanel()
    else
        self:setBuyBtnEnable(false)
        self:playRewardAnim(self.rewardsInfo)
        if self.promoEndCallback then
            self.promoEndCallback()
        end
    end
end

function IosSalesBasePanel:onBuyBtnTap()
	self:setBuyBtnEnable(false)
	self:setResetBtnEnable(false)
	local guideModel = require("zoo.gameGuide.IosPayGuideModel"):create()

	local function onBuySuccess()
		self:buySuccess()
	end

	local function onBuyFailed()
		if self.isDisposed then return end
        self:setBuyBtnEnable(true)
        self:setResetBtnEnable(true)
        CommonTip:showTip(localize('buy.gold.panel.err.undefined'))
	end

    local function loadCompleteFunc()
        if IosPayGuide:maintenanceEnabled() and IosPayGuide:isInAppleVerification() then
        	local peDispatcher = self:getPaymentEventDispatcher()
            IapBuyPropLogic:buy(self.data, onBuySuccess, onBuyFailed, peDispatcher)
            return
        end

        if guideModel:isInOneYuanShopPromotion() then
        	local peDispatcher = self:getPaymentEventDispatcher()
            IapBuyPropLogic:buy(self.data, onBuySuccess, onBuyFailed, peDispatcher)
        else
            if self.promoEndCallback then self.promoEndCallback() end
            self:onCloseBtnTapped()
            CommonTip:showTip(localize('您已经购买过特价道具或者活动已过期！'))
        end
    end

    local function loadFailFunc()
        CommonTip:showTip(localize("dis.connect.warning.tips"))
        self:setBuyBtnEnable(true)
        self:setResetBtnEnable(true)
    end

    local function onUserLogin()
    	guideModel:loadPromotionInfo(loadCompleteFunc, loadFailFunc, true)
    end

    local function onUserNotLogin()
    	 self:setBuyBtnEnable(true)
    	 self:setResetBtnEnable(true)
    end

    RequireNetworkAlert:callFuncWithLogged(onUserLogin, onUserNotLogin)
end

function IosSalesBasePanel:setButtonDelayEnable(delayTime)
	local _delayTime = delayTime or 1
	local function rebecomeEnable()
		self:setBuyBtnEnable(true)
		self:setResetBtnEnable(true)
	end
	self:setBuyBtnEnable(false)
	self:setResetBtnEnable(false)
	setTimeOut(rebecomeEnable, _delayTime)		
end

function IosSalesBasePanel:setBuyBtnEnable(isEnable)
	if self.isDisposed then return end
	self.buyButton:setEnabled(isEnable)
end

function IosSalesBasePanel:setResetBtnEnable(isEnable)
	if self.isDisposed then return end
	local isVisible = self.resetButton:isVisible()
	if isVisible then 
		self.resetButton:setEnabled(isEnable)
	end
end

function IosSalesBasePanel:startTimer()
    if self.schedId then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedId)
        self.schedId = nil
    end
    local function onTick()
        if self.isDisposed then return end
        self.cdSeconds = self.cdSeconds - 1
        if self.cdSeconds >= 0 then
            self.countDownLabel:setString(localize("ios.special.offer.desc")..convertSecondToHHMMSSFormat(self.cdSeconds))
        else
            if self.schedId then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedId)
                self.schedId = nil
            end
            if not self.isDisposed then 
                self.buyButton:setEnabled(IosPayGuide:maintenanceEnabled() and IosPayGuide:isInAppleVerification())
            end
            if self.promoEndCallback then
                self.promoEndCallback()
            end
        end
    end
    self.schedId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onTick, 1, false)
    onTick()
end

function IosSalesBasePanel:onResetPanel()
    local guideModel = require("zoo.gameGuide.IosPayGuideModel"):create()
    local function resetSuccess()
    	self:onCloseBtnTapped()
    	IosPayGuide:startOneYuanShop()
    	IosPayGuide:updateOneYuanShopIcon()
    end

    local function resetFailed()
    	CommonTip:showTip(localize("dis.connect.warning.tips"))
    	self:setResetBtnEnable(true)
    end
    guideModel:resetOneYuanShop(resetSuccess, resetFailed)

    self:setResetBtnEnable(false)
end

function IosSalesBasePanel:playRewardAnim(rewards)
    local scene = Director:sharedDirector():getRunningScene()
    if not scene then return end
    if self.isDisposed then return end

    HomeScene:sharedInstance():checkDataChange()
    for k, v in ipairs(rewards) do
        if v.itemId == 2 then
            local config = {updateButton = true,}
            local anim = HomeSceneFlyToAnimation:sharedInstance():coinStackAnimation(config)
            local position = v.icon:getPosition()
            local wPosition = v.icon:getParent():convertToWorldSpace(ccp(position.x, position.y))
            anim.sprites:setPosition(ccp(wPosition.x + 100, wPosition.y - 90))
            scene:addChild(anim.sprites)
            anim:play()
        elseif v.itemId == 14 then
            local num = v.num
            if num > 10 then num = 10 end
            local config = {number = num, updateButton = true,}
            print("config.number: "..tostring(config.number))
            local anim = HomeSceneFlyToAnimation:sharedInstance():goldFlyToAnimation(config)
            local position = v.icon:getPosition()
            local size = v.icon:getGroupBounds().size
            local wPosition = v.icon:getParent():convertToWorldSpace(ccp(position.x + size.width / 4, position.y - size.height / 4))
            for __, v2 in ipairs(anim.sprites) do
                v2:setPosition(ccp(wPosition.x, wPosition.y))
                v2:setScaleX(v.icon:getScaleX())
                v2:setScaleY(v.icon:getScaleY())
                scene:addChild(v2)
            end
            anim:play()
        else
            local num = v.num
            if num > 10 then num = 10 end
            local config = {propId = v.itemId, number = num, updateButton = true,}
            local anim = HomeSceneFlyToAnimation:sharedInstance():jumpToBagAnimation(config)
            local position = v.icon:getPosition()
            local size = v.icon:getGroupBounds().size
            local wPosition = v.icon:getParent():convertToWorldSpace(ccp(position.x, position.y))
            for k, v2 in ipairs(anim.sprites) do
                v2:setPosition(ccp(wPosition.x, wPosition.y))
                v2:setScaleX(v.icon:getScaleX())
                v2:setScaleY(v.icon:getScaleY())
                scene:addChild(v2)
            end
            anim:play()
        end
    end
end

function IosSalesBasePanel:popout()
	PopoutQueue:sharedInstance():push(self)
end

function IosSalesBasePanel:removePopout()
    self.allowBackKeyTap = false
    PopoutManager:sharedInstance():remove(self)
    IosPayGuide:setSalesPanel(nil)
end

function IosSalesBasePanel:popoutShowTransition()
	self.allowBackKeyTap = true
	self:_calcPosition()
end

function IosSalesBasePanel:onCloseBtnTapped()
    local payResult = self.dcIosInfo:getResult()
    if payResult and payResult ~= IosRmbPayResult.kSuccess then 
        if payResult == IosRmbPayResult.kSdkFail then 
            self.dcIosInfo:setResult(IosRmbPayResult.kCloseAfterSdkFail)
        else
            self.dcIosInfo:setResult(IosRmbPayResult.kCloseDirectly)
        end
        PaymentIosDCUtil.getInstance():sendIosRmbPayEnd(self.dcIosInfo)  
    end
    self:removePopout()
end


