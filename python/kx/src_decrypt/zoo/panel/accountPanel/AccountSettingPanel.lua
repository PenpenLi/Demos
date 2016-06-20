require 'zoo.panel.accountPanel.AccountSettingItems'
require 'zoo.panel.accountPanel.AccountSettingSubPanels'
require 'zoo.account.AccountBindingLogic'

AccountSettingPanel = class(BasePanel)
function AccountSettingPanel:create()
    local instance = AccountSettingPanel.new()
    instance:loadRequiredResource(PanelConfigFiles.panel_game_setting)
    instance:init()
    return instance
end

function AccountSettingPanel:init()
    local ui = self.builder:buildGroup('accountSettingPanel')
    BasePanel.init(self, ui)
    self._newBg = ui:getChildByName('_newBg')
    self._newBg2 = ui:getChildByName('_newBg2')
    self.itemBg = ui:getChildByName('itemBg')
    self.panelTitle = ui:getChildByName('panelTitle')
    self.panelTitle:setText('账号设置')

    local size = self.panelTitle:getContentSize()
    local scale = 65 / size.height
    self.panelTitle:setScale(scale)
    self.panelTitle:setPositionX((self._newBg:getGroupBounds().size.width - size.width * scale) / 2)

    self.closeBtn = ui:getChildByName('closeBtn')
    self.closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn:ad(DisplayEvents.kTouchTap, function () self:onCloseBtnTapped() end)
    self:initAccountItems()
end

function AccountSettingPanel:onEnterHandler(event, ...)
    if event == "enter" then
        self.allowBackKeyTap = true
        self:runAction(self:createShowAnim())
    end
end


function AccountSettingPanel:createShowAnim()
    local centerPosX    = self:getHCenterInParentX()
    local centerPosY    = self:getVCenterInParentY()

    local function initActionFunc()
        local initPosX  = centerPosX
        local initPosY  = centerPosY + 100
        self:setPosition(ccp(initPosX, initPosY))
    end
    local initAction = CCCallFunc:create(initActionFunc)
    local moveToCenter      = CCMoveTo:create(0.5, ccp(centerPosX, centerPosY))
    local backOut           = CCEaseQuarticBackOut:create(moveToCenter, 33, -106, 126, -67, 15)
    local targetedMoveToCenter  = CCTargetedAction:create(self.refCocosObj, backOut)

    local function onEnterAnimationFinished() self:onEnterAnimationFinished() end
    local actionArray = CCArray:create()
    actionArray:addObject(initAction)
    actionArray:addObject(targetedMoveToCenter)
    actionArray:addObject(CCCallFunc:create(onEnterAnimationFinished))
    return CCSequence:create(actionArray)
end

function AccountSettingPanel:onEnterAnimationFinished()

end

function AccountSettingPanel:popout()
    PopoutManager:sharedInstance():add(self, true, false)
end

function AccountSettingPanel:removeSelf()
    self.allowBackKeyTap = false
    PopoutManager:sharedInstance():remove(self, true)

    if self.bindCallBack then
        self.bindCallBack()
    end
end

function AccountSettingPanel:onCloseBtnTapped()
    self:removeSelf()
    --AccountPanel:create():popout()
end

local order = {
    [PlatformAuthEnum.kQQ]    = 1,
    [PlatformAuthEnum.kPhone] = 2,
    [PlatformAuthEnum.kWeibo] = 3,
    [PlatformAuthEnum.k360]   = 4,
    [PlatformAuthEnum.kWDJ]   = 5,
    [PlatformAuthEnum.kMI]    = 6,
}

function AccountSettingPanel:initAccountItems()
    local otherAccounts = {}
    local authConfig = PlatformConfig.authConfig

    if type(authConfig) == 'table' then
        for k, v in pairs(authConfig) do
            if v ~= PlatformAuthEnum.kGuest then
                table.insert(otherAccounts, v)
            end
        end
    else
        if authConfig ~= PlatformAuthEnum.kGuest then
            table.insert(otherAccounts, authConfig)
        end
    end

    table.sort(otherAccounts,function(a,b) return order[a] < order[b] end)

    local ph = self.ui:getChildByName('ph')
    local itemBg = self.ui:getChildByName('itemBg')
    local pos = ph:getPosition()
    ph:setVisible(false)
    local layoutWidth = ph:getContentSize().width * ph:getScaleX()
    local layout = VerticalTileLayout:create(layoutWidth)
    layout:setItemVerticalMargin(0)
    self.otherAccountItems = {}
    for k, v in pairs(otherAccounts) do
        local item
        if v == PlatformAuthEnum.kPhone then
            item = PhoneAccountItem:create()
        elseif v == PlatformAuthEnum.kQQ then
            item = QQAccountItem:create()
        elseif v == PlatformAuthEnum.kWeibo then
            item = WeiboAccountItem:create()
        elseif v == PlatformAuthEnum.k360 then
            item = QihooAccountItem:create()
        elseif v == PlatformAuthEnum.kWDJ then
            item = WdjAccountItem:create()
        elseif v == PlatformAuthEnum.kMI then
            item = MitalkAccountItem:create()
        end
        if not item then 
            assert(false, 'AccountSettingPanel:initAccountItems error')
            return 
        end
        self.otherAccountItems[v] = item
        item:setMainPanel(self)
        layout:addItem(item)

        if k ~= #otherAccounts then
            local decoItem = ItemInLayout:create()
            local res = self:buildInterfaceGroup('account_setting_deco_item')
            decoItem:setContent(res)
            layout:addItem(decoItem)
        end
    end
    self.layout = layout
    layout:setPosition(ccp(pos.x, pos.y))
    ph:getParent():addChildAt(layout, ph:getZOrder())

    local deltaHeight = layout:getHeight()
    self._newBg2:setPreferredSize(CCSizeMake(self._newBg2:getContentSize().width, self._newBg2:getContentSize().height+deltaHeight))
    self._newBg:setPreferredSize(CCSizeMake(self._newBg:getContentSize().width, self._newBg:getContentSize().height+deltaHeight))
    self.itemBg:setPreferredSize(CCSizeMake(self.itemBg:getContentSize().width, self.itemBg:getContentSize().height+deltaHeight))

end

function AccountSettingPanel:changePhoneBinding()
    local function onReturnCallback()
        AccountSettingPanel:create():popout()
    end

    local function onConfirmCallback()
        self:removeSelf()
    end

    AccountBindingLogic:changePhoneBinding(onConfirmCallback, onReturnCallback)
end

function AccountSettingPanel:bindNewPhone()
    local function onReturnCallback()
        -- AccountPanel:create():popout()
        AccountSettingPanel:create():popout()
    end

    local function onSuccess()
        AccountSettingPanel:create():popout()

        if self.bindCallBack then
            self.bindCallBack()
        end
    end

    self:removeSelf()
    AccountBindingLogic:bindNewPhone(onReturnCallback, onSuccess)
end

function AccountSettingPanel:bindConnect( authorizeType,snsInfo,sns_token )
    if not snsInfo then
        snsInfo = { snsName = Localization:getInstance():getText("game.setting.panel.use.device.name.default") }
    end
    local function callback()
        if self.isDisposed then return end
        if authorizeType ~= PlatformAuthEnum.kPhone then
            self:updateOtherAccount(authorizeType) 
        else
            AccountSettingPanel:create():popout()
        end
    end
    -- 三个callback做的事都一样，但留下三个函数方便以后修改
    local function onConnectFinish()
        callback()
    end
    local function onConnectError()
        callback()
    end
    local function onConnectCancel()
        callback()
    end
    AccountBindingLogic:bindConnect(authorizeType,snsInfo,sns_token, onConnectFinish, onConnectError, onConnectCancel)
end

function AccountSettingPanel:updateOtherAccount( authorizeType )
    if self.isDisposed then 
        return
    end
    local v = authorizeType
    local res = self.otherAccountItems[v]
    if not res then 
        return
    end

    res:update()
end

function AccountSettingPanel:bindNewSns( authorizeType )
    local function callback()
        if not self.isDisposed then
            self:updateOtherAccount(authorizeType) 
        end
    end
    -- 三个callback做的事都一样，但留下三个函数方便以后修改
    local function onConnectFinish()
        callback()
    end
    local function onConnectError()
        callback()
    end
    local function onConnectCancel()
        callback()
    end
    AccountBindingLogic:bindNewSns(authorizeType, onConnectFinish, onConnectError, onConnectCancel)
    
end


function AccountSettingPanel:getAccountAuthName(accountKey)
    return UserManager:getInstance().profile:getSnsUsername(accountKey)
end
