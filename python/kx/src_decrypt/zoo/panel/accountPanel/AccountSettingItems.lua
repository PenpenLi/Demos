require 'zoo.panel.component.common.LayoutItem'
BaseAccountSettingItem = class(ItemInLayout)
PhoneAccountItem = class(BaseAccountSettingItem)
ThirdPartyAccountItem = class(BaseAccountSettingItem)
WeiboAccountItem = class(ThirdPartyAccountItem)
QQAccountItem = class(ThirdPartyAccountItem)
QihooAccountItem = class(ThirdPartyAccountItem)
WdjAccountItem = class(ThirdPartyAccountItem)
MitalkAccountItem = class(ThirdPartyAccountItem)
-- .....


----------------------- BaseAccountSettingItem --------------------
function BaseAccountSettingItem:create()
    local instance = self.new()
    instance:loadRequiredResource()
    instance:init()
    return instance
end
function BaseAccountSettingItem:setMainPanel(panel)
    self.mainPanel = panel
end
function BaseAccountSettingItem:init(config)
    ItemInLayout.init(self)
    local ui = self.builder:buildGroup('accout_setting_item')
    self.ui = ui
    self.label = ui:getChildByName('label')
    self.account = ui:getChildByName('account')
    self.notBinded = ui:getChildByName('notBinded')
    self.ph = ui:getChildByName('ph')
    self.ph:setVisible(false)
    self.btn = GroupButtonBase:create(ui:getChildByName('btn'))
    self:setContent(ui)
    if config then
        -- config = {platformName = PlatformAuthEnum.kQQ, labelKey = 'setting.panel.intro.3', nobindedKey = 'setting.panel.intro.8'}
        self.config = config
        if config.labelKey then
            self.label:setString(localize(config.labelKey))
        end
        if config.platformName then
            if self:getAccountAuthName(config.platformName) then
                self.account:setString(self:getAccountAuthName(config.platformName))
                self.notBinded:setString('')
            else
                self.account:setString('')                
                if config.nobindedKey then
                    self.notBinded:setString(localize(config.nobindedKey))
                end
            end
        end
    end
end
function BaseAccountSettingItem:getAccountAuthName(platform)
    return UserManager:getInstance().profile:getSnsUsername(platform)
end

function BaseAccountSettingItem:loadRequiredResource()
    self.builder = InterfaceBuilder:createWithContentsOfFile(PanelConfigFiles.panel_game_setting)
end
function BaseAccountSettingItem:update()
end

--------------------- PhoneAccountItem ------------------
function PhoneAccountItem:init()
    local config = {labelKey = 'setting.panel.intro.2', nobindedKey = 'setting.panel.intro.8'}
    BaseAccountSettingItem.init(self, config)
    self.btn:ad(DisplayEvents.kTouchTap, function() self:onBtnTapped() end)
    self:update()
end

function PhoneAccountItem:update()
    local function secretPhone(phone)
        return string.sub(phone, 1, 3).. string.rep("*",4) ..string.sub(phone, -4)
    end
    if self:isPhoneBinded() then
        if self:isAllowChangePhoneBinding() then
            self.btn:setString(localize('setting.panel.button.3'))
            self.btn:setEnabled(true)
            self.btn:setColorMode(kGroupButtonColorMode.orange)
        else
            self.btn:setVisible(false)
            self.btn:setEnabled(false)
        end
        local phone = self:getAccountAuthName(PlatformAuthEnum.kPhone)
        if #phone == 11 then
            phone = secretPhone(phone)
        end
        self.account:setString(phone)
    else
        self.btn:setString(localize('setting.panel.button.2'))
        self.btn:setEnabled(true)
        self.btn:setColorMode(kGroupButtonColorMode.blue)
        self.notBinded:setString(localize(self.config.nobindedKey))
    end
end

function PhoneAccountItem:onBtnTapped()
    if self:isPhoneBinded() then
        if self:isAllowChangePhoneBinding() then
            if self.mainPanel and not self.mainPanel.isDisposed then
                self.mainPanel:removeSelf()
                self.mainPanel:changePhoneBinding()
            end
        end
    else
        if self.mainPanel and not self.mainPanel.isDisposed then
            self.mainPanel:bindNewPhone()
        end
    end
end

function PhoneAccountItem:isPhoneBinded()
    if UserManager:getInstance().profile:getSnsUsername(PlatformAuthEnum.kPhone) ~= nil then
        return true
    end
    return false
end

function PhoneAccountItem:isAllowChangePhoneBinding()
    local val = UserManager:getInstance().userExtend:allowChangePhoneBinding()
    return val
end

----------------- ThirdPartyAccountItem ----------------------
function ThirdPartyAccountItem:init(config)
    BaseAccountSettingItem.init(self, config)
    self:update()
end

function ThirdPartyAccountItem:update()
    local account = self:getAccountAuthName(self.config.platformName)
    print("platformName: ", self.config.platformName, " ,account: ", account)
    if not account then
        self.btn:setVisible(true)
        self.btn:setEnabled(true)
        self.btn:setString(localize('setting.panel.button.2'))
        self.btn:setColorMode(kGroupButtonColorMode.blue)
        self.btn:removeEventListenerByName(DisplayEvents.kTouchTap)
        self.btn:ad(DisplayEvents.kTouchTap, function () self:onBtnTapped() end)
    else
        self.btn:setVisible(false)
        self.btn:setEnabled(false)
        self.account:setString(account)
        self.notBinded:setString('')
    end
end

function ThirdPartyAccountItem:onBtnTapped()
    self.btn:setEnabled(false)
    if self.mainPanel and not self.mainPanel.isDisposed then
        self.mainPanel:bindNewSns(self.config.platformName)
    end
end

------ QQAccountItem WeiboAccountItem QihooAccountItem ... ---------
function QQAccountItem:init()
    local config = {platformName = PlatformAuthEnum.kQQ, labelKey = 'setting.panel.intro.3', nobindedKey = 'setting.panel.intro.8'}
    ThirdPartyAccountItem.init(self, config)
end

function WeiboAccountItem:init()
    local config = {platformName = PlatformAuthEnum.kWeibo, labelKey = 'setting.panel.intro.4', nobindedKey = 'setting.panel.intro.8'}
    ThirdPartyAccountItem.init(self, config)
end

function QihooAccountItem:init()
    local config = {platformName = PlatformAuthEnum.k360, labelKey = 'setting.panel.intro.5', nobindedKey = 'setting.panel.intro.8'}
    ThirdPartyAccountItem.init(self, config)
end

function WdjAccountItem:init()
    local config = {platformName = PlatformAuthEnum.kWDJ, labelKey = 'setting.panel.intro.6', nobindedKey = 'setting.panel.intro.8'}
    ThirdPartyAccountItem.init(self, config)
end

function MitalkAccountItem:init()
    local config = {platformName = PlatformAuthEnum.kMI, labelKey = 'setting.panel.intro.7', nobindedKey = 'setting.panel.intro.8'}
    ThirdPartyAccountItem.init(self, config)
end