require 'zoo.payment.AddMinusButton'

local kButtonType = {
    kAdd = 0,
    kMinus = 1,
}
WeeklyRaceExchangePanel = class(BasePanel)

function WeeklyRaceExchangePanel:create(parentPanel)
    local instance = WeeklyRaceExchangePanel.new()
    instance:loadRequiredJson(PanelConfigFiles.panel_game_start)
    instance:init(parentPanel)
    return instance
end

function WeeklyRaceExchangePanel:init(parentPanel)
    self.parentPanel = parentPanel
    local ui = self:buildInterfaceGroup('weeklyRaceExchangePanel')
    BasePanel.init(self, ui)
    self.desc = ui:getChildByName('desc')
    self.coinItem = ui:getChildByName('coinItem')
    self.energyItem = ui:getChildByName('energyItem')
    self.closeBtn = ui:getChildByName('closeBtn')
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:ad(DisplayEvents.kTouchTap, function () self:onCloseBtnTapped() end)

    self.coinItem.iconLocator = self.coinItem:getChildByName('iconLocator')
    self.coinItem.btnBuy = ButtonIconNumberBase:create(self.coinItem:getChildByName('btnBuy'))
    self.coinItem.btnBuy:setColorMode(kGroupButtonColorMode.blue)
    self.coinItem.btnAdd = AddMinusButton:create(self.coinItem:getChildByName('btnAdd'))
    self.coinItem.btnMinus = AddMinusButton:create(self.coinItem:getChildByName('btnMinus'))
    self.coinItem.number = self.coinItem:getChildByName('number')
    self.coinItem.limitNumber = self.coinItem:getChildByName('limitNumber')

    self.energyItem.iconLocator = self.energyItem:getChildByName('iconLocator')
    self.energyItem.btnBuy = ButtonIconNumberBase:create(self.energyItem:getChildByName('btnBuy'))
    self.energyItem.btnBuy:setColorMode(kGroupButtonColorMode.blue)
    self.energyItem.btnAdd = AddMinusButton:create(self.energyItem:getChildByName('btnAdd'))
    self.energyItem.btnMinus = AddMinusButton:create(self.energyItem:getChildByName('btnMinus'))
    self.energyItem.number = self.energyItem:getChildByName('number')
    self.energyItem.limitNumber = self.energyItem:getChildByName('limitNumber')

    local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
    local _coinIcon = iconBuilder:buildGroup('heapIcon')
    local _energyIcon = iconBuilder:buildGroup('Prop_10012')

    local _coinLocator = self.coinItem:getChildByName('icon')
    _coinLocator:setVisible(false)
    _coinIcon:setPosition(ccp(_coinLocator:getPositionX(), _coinLocator:getPositionY()))
    _coinLocator:getParent():addChildAt(_coinIcon, _coinLocator:getZOrder())
    local _coinNum = self.coinItem:getChildByName('num')
    _coinNum:setString('1000')

    local _energyLocator = self.energyItem:getChildByName('icon')
    _energyLocator:setVisible(false)
    _energyIcon:setPosition(ccp(_energyLocator:getPositionX(), _energyLocator:getPositionY()))
    _energyLocator:getParent():addChildAt(_energyIcon, _energyLocator:getZOrder())
    local _energyNum = self.energyItem:getChildByName('num')
    _energyNum:setVisible(false)

    self.desc = ui:getChildByName('desc')
    self.coinItem.btnBuy:setString(Localization:getInstance():getText('weekly.race.gem.exchange.btn'))
    self.energyItem.btnBuy:setString(Localization:getInstance():getText('weekly.race.gem.exchange.btn'))


    self.coinItem.btnAdd:setButtonType(kButtonType.kAdd)
    self.coinItem.btnMinus:setButtonType(kButtonType.kMinus)
    self.energyItem.btnAdd:setButtonType(kButtonType.kAdd)
    self.energyItem.btnMinus:setButtonType(kButtonType.kMinus)
    self.coinItem.btnAdd:ad(DisplayEvents.kTouchTap, function () self:onCoinAddTapped() end)
    self.coinItem.btnMinus:ad(DisplayEvents.kTouchTap, function () self:onCoinMinusTapped() end)
    self.energyItem.btnAdd:ad(DisplayEvents.kTouchTap, function () self:onEnergyAddTapped() end)
    self.energyItem.btnMinus:ad(DisplayEvents.kTouchTap, function () self:onEnergyMinusTapped() end)

    self.coinItem.btnBuy:ad(DisplayEvents.kTouchTap, function () self:onCoinExchangeTapped() end)
    self.energyItem.btnBuy:ad(DisplayEvents.kTouchTap, function () self:onEnergyExchangeTapped() end)

    self.coinAmount = 1
    self.energyAmount = 1
    self:update()
end

function WeeklyRaceExchangePanel:update()
    local remainingGemCount = WeeklyRaceManager:sharedInstance():getRemainingGemCount()
    self.desc:setString(Localization:getInstance():getText('weekly.race.panel.gem.num2', {num = remainingGemCount}))
    self.coinItem.number:setString('x'..self.coinAmount)
    self.energyItem.number:setString('x'..self.energyAmount)
    local coinLimit = WeeklyRaceManager:sharedInstance():getLimitForCoins()
    local energyLimit = WeeklyRaceManager:sharedInstance():getLimitForEnergy()
    self.coinItem.limitNumber:setString(Localization:getInstance():getText('weekly.race.gem.exchange.limit', {num = coinLimit}))
    self.energyItem.limitNumber:setString(Localization:getInstance():getText('weekly.race.gem.exchange.limit', {num = energyLimit}))
    self:updateButtons()
end

function WeeklyRaceExchangePanel:popout(closeCallback)
    PopoutManager:sharedInstance():add(self, false, false)
    self:setPositionForPopoutManager()
    self:setPositionY(self:getPositionY() + 130)
    self:runAction(CCEaseElasticOut:create(CCMoveBy:create(0.8, ccp(0, -130))))
    self.allowBackKeyTap = true
    self.closeCallback = closeCallback
end

function WeeklyRaceExchangePanel:onCloseBtnTapped()
    PopoutManager:sharedInstance():remove(self, true)
    self.allowBackKeyTap = false
    if self.closeCallback then self.closeCallback() end
end

function WeeklyRaceExchangePanel:updateButtons()
    local disableCoinAddBtn = false
    local disableCoinMinusBtn = false
    local disableEnergyAddBtn = false
    local disableEnergyMinusBtn = false
    local disableCoinBuyBtn = false
    local disableEnergyBuyBtn = false
    local coinRatio = WeeklyRaceManager:sharedInstance():getCoinExchangeRatio()
    local energyRatio = WeeklyRaceManager:sharedInstance():getEnergyExchangeRation()
    local remainingGemCount = WeeklyRaceManager:sharedInstance():getRemainingGemCount()
    local coinLimit = WeeklyRaceManager:sharedInstance():getLimitForCoins()
    local energyLimit = WeeklyRaceManager:sharedInstance():getLimitForEnergy()

    if -- ((self.coinAmount + 1) * coinRatio + self.energyAmount * energyRatio > remainingGemCount )
        -- or 
        (coinLimit - self.coinAmount <= 0) then
        disableCoinAddBtn = true
    end

    if self.coinAmount == 1 then
        disableCoinMinusBtn = true
        --disableCoinBuyBtn = true
    end

    if --(self.coinAmount * coinRatio + (self.energyAmount + 1) * energyRatio > remainingGemCount)
       -- or 
        (energyLimit - self.energyAmount <= 0) then
        disableEnergyAddBtn = true
    end

    if self.energyAmount == 1 then
        disableEnergyMinusBtn = true
        --disableEnergyBuyBtn  = true
    end

    self.coinItem.btnBuy:setEnabled(not disableCoinBuyBtn and not self._isCoinBtnBusy)
    self.coinItem.btnAdd:setEnabled(not disableCoinAddBtn)
    self.coinItem.btnMinus:setEnabled(not disableCoinMinusBtn)

    self.energyItem.btnBuy:setEnabled(not disableEnergyBuyBtn and not self._isEnergyBtnBusy)
    self.energyItem.btnAdd:setEnabled(not disableEnergyAddBtn)
    self.energyItem.btnMinus:setEnabled(not disableEnergyMinusBtn)

    local coinGemCount = self.coinAmount * coinRatio
    local energyGemCount = self.energyAmount * energyRatio
    self.coinItem.btnBuy:setNumber(coinGemCount)
    self.energyItem.btnBuy:setNumber(energyGemCount)
end

function WeeklyRaceExchangePanel:onCoinAddTapped()
    self.coinAmount = self.coinAmount + 1
    self.coinItem.number:setString('x'..self.coinAmount)
    self:updateButtons()
end

function WeeklyRaceExchangePanel:onCoinMinusTapped()
    self.coinAmount = self.coinAmount - 1
    self.coinItem.number:setString('x'..self.coinAmount)
    self:updateButtons()
end

function WeeklyRaceExchangePanel:onEnergyAddTapped()
    self.energyAmount = self.energyAmount + 1
    self.energyItem.number:setString('x'..self.energyAmount)
    self:updateButtons()
end

function WeeklyRaceExchangePanel:onEnergyMinusTapped()
    self.energyAmount = self.energyAmount - 1
    self.energyItem.number:setString('x'..self.energyAmount)
    self:updateButtons()
end

function WeeklyRaceExchangePanel:onCoinExchangeTapped()

    if self._isCoinBtnBusy then return end

    if self.coinAmount * WeeklyRaceManager:sharedInstance():getCoinExchangeRatio() > WeeklyRaceManager:sharedInstance():getRemainingGemCount() then
        CommonTip:showTip(Localization:getInstance():getText('weekly.race.gem.exchange.tip1'), 'negative', nil, 1)
        return
    elseif self.coinAmount > WeeklyRaceManager:sharedInstance():getLimitForCoins() then
        CommonTip:showTip(Localization:getInstance():getText('weekly.race.gem.exchange.tip2'), 'negative', nil, 1)
        return 
    end

    local num = self.coinAmount * 1000
    local coin = UserManager:getInstance().user:getCoin()
    -- add lock
    self._isCoinBtnBusy = true
    self.coinItem.btnBuy:setEnabled(false)

    local function onSuccess(event)
        print('onSuccess')
        HomeScene:sharedInstance():checkDataChange()
        HomeScene:sharedInstance().coinButton:updateView()
        if self.isDisposed then return end
        self._isCoinBtnBusy = false -- release lock
        self.coinAmount = 1
        self:update()
        if self.parentPanel and not self.parentPanel.isDisposed then
            self.parentPanel:update()
        end
        -- animation
        local anim = HomeScene:sharedInstance():createFlyingCoinAnim() 
        local pos = self.coinItem:convertToWorldSpace(self.coinItem:getChildByName('icon'):getPosition())
        anim:setPosition(pos)
        anim:playFlyToAnim()

        DcUtil:logCreateCoin("weeklyrace",num, coin,-1)
        DcUtil:weeklyRaceExchangeReward(1)
    end

    local function onFail(event)
        local err_code = tonumber(event.data or 0)
        CommonTip:showTip(Localization:getInstance():getText('error.tip.'..err_code), 'negative', nil, 3)
        if self.isDisposed then return end
        self._isCoinBtnBusy = false
        self:update()
    end

    WeeklyRaceManager:sharedInstance():exchangeForCoins(self.coinAmount, onSuccess, onFail)
    self:update()
end

function WeeklyRaceExchangePanel:onEnergyExchangeTapped()

    if self._isEnergyBtnBusy then return end

    if self.energyAmount * WeeklyRaceManager:sharedInstance():getEnergyExchangeRation() > WeeklyRaceManager:sharedInstance():getRemainingGemCount() then
        CommonTip:showTip(Localization:getInstance():getText('weekly.race.gem.exchange.tip1'), 'negative', nil, 1)
        return
    elseif self.energyAmount > WeeklyRaceManager:sharedInstance():getLimitForEnergy() then
        CommonTip:showTip(Localization:getInstance():getText('weekly.race.gem.exchange.tip2'), 'negative', nil, 1)
        return 
    end

    local itemId = 10012
    local num = self.energyAmount

    -- add lock
    self._isEnergyBtnBusy = true
    self.energyItem.btnBuy:setEnabled(false)

    local function onSuccess(event)
        HomeScene:sharedInstance():checkDataChange()
        HomeScene:sharedInstance().coinButton:updateView()
        if self.isDisposed then return end
        self._isEnergyBtnBusy = false -- release lock
        self.energyAmount = 1
        self:update()
        if self.parentPanel and not self.parentPanel.isDisposed then
            self.parentPanel:update()
        end

        -- animation
        local anim = HomeScene:sharedInstance():createFlyToBagAnimation(10012, num, false) 
        local pos = self.energyItem:convertToWorldSpace(self.energyItem:getChildByName('icon'):getPosition())
        anim:setPosition(pos)
        anim:playFlyToAnim()

        DcUtil:logRewardItem("weeklyrace", itemId, num, -1)
        DcUtil:weeklyRaceExchangeReward(2)
    end

    local function onFail(event)
        local err_code = tonumber(event.data or 0)
        CommonTip:showTip(Localization:getInstance():getText('error.tip.'..err_code), 'negative', nil, 3)
        if self.isDisposed then return end
        self._isEnergyBtnBusy = false
        self:update()
    end

    WeeklyRaceManager:sharedInstance():exchangeForEnergy(self.energyAmount, onSuccess, onFail)
    self:update()
end