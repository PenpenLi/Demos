
RequestMessageZeroItem = class(Layer)
RequestMessageZeroFriend = class(RequestMessageZeroItem)
RequestMessageZeroEnergy = class(RequestMessageZeroItem)
RequestMessageZeroUnlock = class(RequestMessageZeroItem)
RequestMessageZeroUpdate = class(RequestMessageZeroItem)
RequestMessageZeroActivity = class(RequestMessageZeroItem)



function RequestMessageZeroItem:create(width, height)
    local ret = self.new()
    ret:initLayer()
    ret:init(width, height)
    return ret
end

function RequestMessageZeroItem:init(width, height)
    local builder = InterfaceBuilder:create(PanelConfigFiles.request_message_panel)
    local text = TextField:create("", nil, 36, CCSizeMake(600,400))
    text:setColor(ccc3(144, 89, 2))
    text:setAnchorPoint(ccp(0, 1))
    self.text = text
    self:addChild(text)
end

function RequestMessageZeroItem:showBottomCloseButton()
    return true
end

function RequestMessageZeroUnlock:create(width, height)
    local ret = RequestMessageZeroUnlock.new()
    ret:initLayer()
    ret:init(width, height)
    return ret
end

function RequestMessageZeroUnlock:init(width, height)
    RequestMessageZeroItem.init(self, height)
    self.text:setString(Localization:getInstance():getText("request.message.panel.zero.unlock.text"))
    local size = self.text:getContentSize()
    self:setPositionX((width - size.width) / 2)
    self:setPositionY(-40)
end

function RequestMessageZeroUpdate:create(width, height)
    local ret = RequestMessageZeroUpdate.new()
    ret:initLayer()
    ret:init(width, height)
    return ret
end

function RequestMessageZeroUpdate:init(width, height)
    RequestMessageZeroItem.init(self, height)
    self.text:setString(Localization:getInstance():getText("request.message.panel.zero.update.text"))
    local size = self.text:getContentSize()
    self:setPositionX((width - size.width) / 2)
    self:setPositionY(-40)
end

function RequestMessageZeroFriend:create(width, height)
    local ret = RequestMessageZeroFriend.new()
    ret:initLayer()
    ret:init(width, height)
    return ret
end

function RequestMessageZeroFriend:init(width, height)
    local builder = InterfaceBuilder:create(PanelConfigFiles.request_message_panel)
    local ui = builder:buildGroup("request_message_panel_zero_friend")
    self:addChild(ui)
    local bg = ui:getChildByName("bg")
    local text1 = ui:getChildByName("text1")
    local text2 = ui:getChildByName("text2")
    local dscText1 = ui:getChildByName("dscText1")
    local dscText2 = ui:getChildByName("dscText2")
    local btn = ui:getChildByName("btn")
    btn = GroupButtonBase:create(btn)
    self.btn = btn


    local size = bg:getPreferredSize()
    local scale = width / (size.width + 40)
    if scale > height / (size.height + 40) then scale = height / (size.height + 40) end
    if scale < 1 then self:setScale(scale)
    else scale = 1 end
    self:setPositionX((width - size.width * scale) / 2)
    self:setPositionY(-(height - size.height * scale) / 2)

    text1:setString(Localization:getInstance():getText("request.message.panel.zero.friend.title"))
    text2:setString(Localization:getInstance():getText("request.message.panel.zero.friend.text"))
    dscText1:setString(Localization:getInstance():getText("request.message.panel.zero.friend.dsc1"))
    dscText2:setString(Localization:getInstance():getText("request.message.panel.zero.friend.dsc2"))
    btn:setString(Localization:getInstance():getText("request.message.panel.zero.friend.button"))

    local function onButton()
        local position = btn:getPosition()
        local wPosition = ui:convertToWorldSpace(ccp(position.x, position.y))
        --local panel = AddFriendPanel:create(wPosition)
        local panel = require("zoo.panel.addfriend.NewAddFriendPanel"):create(wPosition)
        -- panel:popout()
        --if panel then panel:popout() end
    end
    btn:addEventListener(DisplayEvents.kTouchTap, onButton)
end

function RequestMessageZeroFriend:setVisible(visible)
    RequestMessageZeroItem.setVisible(self, visible)
    self.btn:setEnabled(visible)
end

function RequestMessageZeroEnergy:create(width, height)
    local ret = RequestMessageZeroEnergy.new()
    ret:initLayer()
    ret:init(width, height)
    return ret
end

function RequestMessageZeroEnergy:init(width, height)
    RequestMessageZeroItem.init(self, width, height)
    self.text:setString(localize('request.message.panel.zero.energy.text2'))
    local size = self.text:getContentSize()
    self:setPositionX((width - size.width) / 2)
    self:setPositionY(-40)
end




function RequestMessageZeroActivity:create(width, height)
    local ret = RequestMessageZeroActivity.new()
    ret:initLayer()
    ret:init(width, height)
    return ret
end


function RequestMessageZeroActivity:init(width, height)
    RequestMessageZeroItem.init(self, height)
    self.text:setString(Localization:getInstance():getText("request.message.panel.zero.activity.text"))
    local size = self.text:getContentSize()
    self:setPositionX((width - size.width) / 2)
    self:setPositionY(-40)
end


RequestMessageZeroNews = class(RequestMessageZeroItem)


RequestMessageZeroWithAskFriend = class(RequestMessageZeroItem)
RequestMessageZeroWithQQLogin = class(RequestMessageZeroItem)
RequestMessageZeroFriendQQLogin = class(RequestMessageZeroWithQQLogin)
RequestMessageZeroEnergyQQLogin = class(RequestMessageZeroWithQQLogin)
RequestMessageZeroUnlockQQLogin = class(RequestMessageZeroWithQQLogin)

--------------------------------------------------------
-- RequestMessageZeroNews
--------------------------------------------------------

function RequestMessageZeroNews:create(width, height)
    local instance = RequestMessageZeroNews.new()
    instance:initLayer()
    instance:init(width, height)
    return instance
end

function RequestMessageZeroNews:init(width, height)
    RequestMessageZeroItem.init(self, height)
    self.text:setString(localize('request.message.panel.news.empty'))
    local size = self.text:getContentSize()
    self:setPositionX((width - size.width) / 2)
    self:setPositionY(-40)
end



local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
local function buildItemIcon(itemId)
    if ItemType:isTimeProp(itemId) then itemId = ItemType:getRealIdByTimePropId(itemId) end
    local propName = 'Prop_'..itemId
    if itemId == 14 then
        propName = 'homeSceneGoldItem'
    elseif itemId == 2 then
        propName = 'stackIcon'
    end
    return iconBuilder:buildGroup(propName)
end


--------------------------------------------------------
-- RequestMessageZeroWithAskFriend
--------------------------------------------------------
function RequestMessageZeroWithAskFriend:init(width, height)
    local builder = InterfaceBuilder:create(PanelConfigFiles.request_message_panel)
    local ui = builder:buildGroup('request_message_panel_zero_energy_askFriend')
    self.ui = ui
    self:addChild(ui)
    self.ui:getChildByName('desc'):setString(localize('request.message.panel.zero.energy.title'))
    self.ui:getChildByName('bubbleDesc'):setString(localize('request.message.panel.zero.energy.text1'))
    self.btn = GroupButtonBase:create(ui:getChildByName('btn'))
    self.btn:setColorMode(kGroupButtonColorMode.green)
    self.btn:setString(localize('request.message.panel.energy.btn'))
    self.btn:ad(DisplayEvents.kTouchTap, function () self:onBtnTapped() end)

    local size = self:getGroupBounds().size
    local scale = width / (size.width + 40)
    if scale > height / (size.height + 40) then scale = height / (size.height + 40) end
    if scale < 1 then self:setScale(scale)
    else scale = 1 end
    self:setPositionX((width - size.width * scale) / 2)
    self:setPositionY(-(height - size.height * scale) / 2)
end

function RequestMessageZeroWithAskFriend:showBottomCloseButton()
    return false
end

function RequestMessageZeroWithAskFriend:onBtnTapped()
    local function onRequestSuccess()
        -- 没什么可做的
    end
    AskForEnergyPanel:popoutPanel(onRequestSuccess)
end


RequestMessageZeroWithQRCodeQQLoginBase = class(RequestMessageZeroItem)
--------------------------------------------------------
-- RequestMessageZeroWithQRCodeQQLoginBase
--------------------------------------------------------
function RequestMessageZeroWithQRCodeQQLoginBase:initWithUI(name, width, height)
    local builder = InterfaceBuilder:create(PanelConfigFiles.request_message_panel)
    local ui = builder:buildGroup(name)
    self.ui = ui
    self:addChild(ui)
    self.qqBtn = GroupButtonBase:create(ui:getChildByName('btn'))
    local codeBtnUI = ui:getChildByName('codeBtn')
    self.codeBtn = GroupButtonBase:create(codeBtnUI)
    self.codeBtn.iconWechat = codeBtnUI:getChildByName("iconSize")
    self.codeBtn.iconMi = codeBtnUI:getChildByName("iconSizeMi")
    self.codeBtn.iconMi:setVisible(false)

    local size = self:getGroupBounds().size
    local scale = width / (size.width + 40)
    if scale > height / (size.height + 40) then scale = height / (size.height + 40) end
    if scale < 1 then self:setScale(scale)
    else scale = 1 end
    self:setPositionX((width - size.width * scale) / 2)
    self:setPositionY(-(height - size.height * scale) / 2)
    self.textCode = self.ui:getChildByName('textCode')
    self.textQQ = self.ui:getChildByName('textQQ')
end

function RequestMessageZeroWithQRCodeQQLoginBase:showQQLogin()

    self.codeBtn:setVisible(false)
    self.codeBtn:setEnabled(false)
    self.textCode:setVisible(false)

    self.qqBtn:setColorMode(kGroupButtonColorMode.orange)
    self.qqBtn:setString(localize('login.panel.button.5'))
    self.qqBtn:ad(DisplayEvents.kTouchTap, function () self:doQQLogin() end)

    if self:qqLoginRewardEnabled() then
        local item = MetaManager:getInstance().rewards[5].rewards[1]
        if item then
            local res = self.ui:getChildByName('reward'):getChildByName('item')
            local ph = res:getChildByName('ph')
            local num = res:getChildByName('num')
            ph:setVisible(false)
            local icon = buildItemIcon(item.itemId)
            icon:setPositionX(ph:getPositionX())
            icon:setPositionY(ph:getPositionY())
            icon:setScale(ph:getContentSize().width*ph:getScaleX() / icon:getGroupBounds().size.width)
            res:addChildAt(icon, ph:getZOrder())
            num:setText('x'..item.num)
        end
    else
        self.ui:getChildByName('reward'):setVisible(false)
    end
end

function RequestMessageZeroWithQRCodeQQLoginBase:showQRCode()
    if PlatformConfig:isPlatform(PlatformNameEnum.kJJ) then
        self.qqBtn:setVisible(true)
        self.qqBtn:setEnabled(true)
        self.qqBtn:setString(localize('friend.ranking.panel.button.add'))
        self.qqBtn:setColorMode(kGroupButtonColorMode.green)
        self.qqBtn:ad(DisplayEvents.kTouchTap, function () self:sendCode() end)

        self.ui:getChildByName('reward'):setVisible(false)
        self.codeBtn:setVisible(false)
        self.codeBtn:setEnabled(false)
        self.textQQ:setVisible(false)
    elseif PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
        self.qqBtn:setVisible(false)
        self.qqBtn:setEnabled(false)
        self.textQQ:setVisible(false)

        self.codeBtn:setVisible(true)
        self.codeBtn.iconWechat:setVisible(false)
        self.codeBtn.iconMi:setVisible(true)
        self.ui:getChildByName('reward'):setVisible(false)

        self.codeBtn:setColorMode(kGroupButtonColorMode.blue)
        self.codeBtn:setString(localize('invite.friend.panel.button.text.mitalk'))
        self.codeBtn:ad(DisplayEvents.kTouchTap, function () self:sendCode() end)
    else
        self.qqBtn:setVisible(false)
        self.qqBtn:setEnabled(false)
        self.textQQ:setVisible(false)

        self.codeBtn:setVisible(true)
        self.codeBtn.iconWechat:setVisible(true)
        self.codeBtn.iconMi:setVisible(false)
        self.ui:getChildByName('reward'):setVisible(false)

        self.codeBtn:setColorMode(kGroupButtonColorMode.green)
        self.codeBtn:setString(localize('my.card.btn2'))
        self.codeBtn:ad(DisplayEvents.kTouchTap, function () self:sendCode() end)
    end
end

function RequestMessageZeroWithQRCodeQQLoginBase:getDcId()
    return 0
end

function RequestMessageZeroWithQRCodeQQLoginBase:showBottomCloseButton()
    return false
end

function RequestMessageZeroWithQRCodeQQLoginBase:sendCode()
    if PlatformConfig:isPlatform(PlatformNameEnum.kJJ) then
        local position = self.qqBtn:getPosition()
        local wPosition = self.ui:convertToWorldSpace(ccp(position.x, position.y))
        local panel = require("zoo.panel.addfriend.NewAddFriendPanel"):create(wPosition)
        -- panel:popout()
        return 
    end

    local function restoreBtn()
        if self.codeBtn.isDisposed then return end
        self.codeBtn:setEnabled(true)
    end
    local function onSuccess()
        DcUtil:UserTrack({category = 'message', sub_category = 'message_center_send_qrcode', where = self:getDcId()}, true)
        restoreBtn()
    end
    local function onError(errCode, msg)
        restoreBtn()
    end
    local function onCancel()
        restoreBtn()
    end

    --just for mitalk
    local shareCallback = {
        onSuccess=function(result)
            DcUtil:UserTrack({category = 'message', sub_category = 'message_center_send_qrcode', where = self:getDcId()}, true)
            CommonTip:showTip(Localization:getInstance():getText("share.feed.invite.success.tips"), "positive")
            restoreBtn()
        end,
        onError=function(errCode, msg)
            if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
                CommonTip:showTip(Localization:getInstance():getText("share.feed.faild.tips.mitalk"), "negative")
            else
                CommonTip:showTip(Localization:getInstance():getText("share.feed.invite.code.faild.tips"), "negative")
            end
            restoreBtn()
        end,
        onCancel=function()
            CommonTip:showTip(Localization:getInstance():getText("share.feed.cancel.tips"), "positive")
            restoreBtn()
        end
    }

    self.codeBtn:setEnabled(false)
    setTimeOut(restoreBtn, 2)

    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then        
        SnsUtil.sendInviteMessage(PlatformShareEnum.kMiTalk, shareCallback)
    else
        PersonalCenterManager:sendBusinessCard(onSuccess, onError, onCancel)
    end 
end

function RequestMessageZeroWithQRCodeQQLoginBase:doQQLogin()
    self.qqBtn:setEnabled(false)
    local authorizeType = PlatformAuthEnum.kQQ
    local function finishCallback(mustExit)

        CCUserDefault:sharedUserDefault():setIntegerForKey('message.center.login.success.source', self:getDcId())
        DcUtil:UserTrack({category = 'message', sub_category = 'message_center_login_qq', where = self:getDcId()}, true)
        if self:qqLoginRewardEnabled() then
            QQLoginReward:setShouldGetReward(true)
            if not mustExit then
                local function popPanel()
                    if QQLoginReward:shouldGetReward() then
                        QQLoginReward:receiveReward()
                    end
                end
                Director:sharedDirector():popScene()
                HomeScene:sharedInstance():runAction(CCCallFunc:create(popPanel))
            end
        end
    end
    local function errorCallback()
        if not self.isDisposed then
            self.qqBtn:setEnabled(true)
        end
        -- CommonTip:showTip('testing 登陆失败')
    end
    local function cancelCallback()
        if not self.isDisposed then
            self.qqBtn:setEnabled(true)
        end
        -- CommonTip:showTip('testing 登陆取消')
    end
    if __WIN32 then
        finishCallback(false)
    else
        AccountBindingLogic:bindNewSns(authorizeType, finishCallback, errorCallback, cancelCallback)
    end
end

function RequestMessageZeroWithQRCodeQQLoginBase:qqLoginRewardEnabled()
    if __WIN32 then return true end
    return MaintenanceManager:getInstance():isEnabled('GetLoginBonus')
end

-- 用类名来区分功能（虽然里面代码的区别很小）
RequestMessageZeroEnergyWithQQLogin = class(RequestMessageZeroWithQRCodeQQLoginBase)
RequestMessageZeroEnergyWithQRCode = class(RequestMessageZeroWithQRCodeQQLoginBase)
--------------------------------------------------------
-- RequestMessageZeroEnergyWithQQLogin
--------------------------------------------------------
-- 两个共用素材，类名主要用来区分用途
-- 精力消息  QQ登录版
function RequestMessageZeroEnergyWithQQLogin:init(width, height)
    RequestMessageZeroWithQRCodeQQLoginBase.initWithUI(self, 'request_message_panel_zero_energy_qq_login', width, height)
    self:showQQLogin()
end
function RequestMessageZeroEnergyWithQQLogin:getDcId()
    return 2
end
--------------------------------------------------------
-- RequestMessageZeroEnergyWithQRCode
--------------------------------------------------------
-- 精力消息  二维码版
function RequestMessageZeroEnergyWithQRCode:init(width, height)
    RequestMessageZeroWithQRCodeQQLoginBase.initWithUI(self, 'request_message_panel_zero_energy_qq_login', width, height)
    self:showQRCode()
end
function RequestMessageZeroEnergyWithQRCode:getDcId()
    return 2
end

RequestMessageZeroFriendWithQQLogin = class(RequestMessageZeroWithQRCodeQQLoginBase)
RequestMessageZeroFriendWithQRCode = class(RequestMessageZeroWithQRCodeQQLoginBase)
--------------------------------------------------------
-- RequestMessageZeroFriendWithQQLogin
--------------------------------------------------------
function RequestMessageZeroFriendWithQQLogin:init(width, height)
    RequestMessageZeroWithQRCodeQQLoginBase.initWithUI(self, 'request_message_panel_zero_friend_qq_login', width, height)
    self.ui:getChildByName('dscText1'):setString(localize('request.message.panel.zero.friend.dsc1'))
    self.ui:getChildByName('dscText2'):setString(localize('request.message.panel.zero.friend.dsc2'))
    self.ui:getChildByName('dscText3'):setString(localize('request.message.panel.zero.friend.dsc3'))
    self:showQQLogin()
end

function RequestMessageZeroFriendWithQQLogin:getDcId()
    return 1
end

--------------------------------------------------------
-- RequestMessageZeroFriendWithQRCode
--------------------------------------------------------
function RequestMessageZeroFriendWithQRCode:init(width, height)
    RequestMessageZeroWithQRCodeQQLoginBase.initWithUI(self, 'request_message_panel_zero_friend_qq_login', width, height)
    self.ui:getChildByName('dscText1'):setString(localize('request.message.panel.zero.friend.dsc1'))
    self.ui:getChildByName('dscText2'):setString(localize('request.message.panel.zero.friend.dsc2'))
    self.ui:getChildByName('dscText3'):setString(localize('request.message.panel.zero.friend.dsc3'))
    self:showQRCode()
end

function RequestMessageZeroFriendWithQRCode:getDcId()
    return 1
end

RequestMessageZeroUnlockWithQQLogin = class(RequestMessageZeroWithQRCodeQQLoginBase)
RequestMessageZeroUnlockWithQRCode = class(RequestMessageZeroWithQRCodeQQLoginBase)
--------------------------------------------------------
-- RequestMessageZeroUnlockWithQQLogin
--------------------------------------------------------
function RequestMessageZeroUnlockWithQQLogin:init(width, height)
    RequestMessageZeroWithQRCodeQQLoginBase.initWithUI(self, 'request_message_panel_zero_unlock_qq_login', width, height)
    self:showQQLogin()
end

function RequestMessageZeroUnlockWithQQLogin:getDcId()
    return 3
end

--------------------------------------------------------
-- RequestMessageZeroUnlockWithQRCode
--------------------------------------------------------
-- 精力消息  二维码版
function RequestMessageZeroUnlockWithQRCode:init(width, height)
    RequestMessageZeroWithQRCodeQQLoginBase.initWithUI(self, 'request_message_panel_zero_unlock_qq_login', width, height)
    self:showQRCode()
end

function RequestMessageZeroUnlockWithQRCode:getDcId()
    return 3
end

-- 带索要精力和发送二维码
RequestMessageZeroEnergyTwoButtons = class(RequestMessageZeroItem)
--------------------------------------------------------
-- RequestMessageZeroEnergyTwoButtons
--------------------------------------------------------
function RequestMessageZeroEnergyTwoButtons:create(width, height)
    local ret = RequestMessageZeroEnergyTwoButtons.new()
    ret:initLayer()
    ret:init(width, height)
    return ret
end

function RequestMessageZeroEnergyTwoButtons:init(width, height)
    local builder = InterfaceBuilder:create(PanelConfigFiles.request_message_panel)
    local ui = builder:buildGroup("request_message_panel_zero_energy")
    self.ui = ui
    self:addChild(ui)
    local bg = ui:getChildByName("bg")
    local text1 = ui:getChildByName("text1")
    local text2 = ui:getChildByName("text2")
    local text3 = ui:getChildByName("text3")
    local btn1UI = ui:getChildByName("btn1")
    local btn2UI = ui:getChildByName("btn2")
    btn1 = GroupButtonBase:create(btn1UI)
    btn2 = GroupButtonBase:create(btn2UI)
    btn2.iconWechat = btn2UI:getChildByName("iconSize")
    btn2.iconMi = btn2UI:getChildByName("iconSizeMi")
    btn2.iconMi:setVisible(false)

    self.energyBtn = btn1
    self.codeBtn = btn2
    self.jjBtn = GroupButtonBase:create(ui:getChildByName('jjBtn'))

    local size = bg:getPreferredSize()
    local scale = width / (size.width + 40)
    if scale > height / (size.height + 40) then scale = height / (size.height + 40) end
    if scale < 1 then self:setScale(scale)
    else scale = 1 end
    self:setPositionX((width - size.width * scale) / 2)
    self:setPositionY(-(height - size.height * scale) / 2)

    text1:setString(Localization:getInstance():getText("request.message.panel.zero.energy.title"))
    text2:setString(Localization:getInstance():getText("request.message.panel.zero.energy.text1"))
    text3:setString(Localization:getInstance():getText("request.message.panel.zero.energy.text3"))
    btn1:setString(Localization:getInstance():getText("request.message.panel.zero.energy.button1"))
   
    btn1:addEventListener(DisplayEvents.kTouchTap, function() self:popAskForEnergy() end)
    btn2:addEventListener(DisplayEvents.kTouchTap, function () self:popQRCode() end)
    if PlatformConfig:isPlatform(PlatformNameEnum.kJJ) then
        btn2:setVisible(false)
        btn2:setEnabled(false)
        self.jjBtn:setVisible(true)
        self.jjBtn:setEnabled(true)
        self.jjBtn:setString(localize('friend.ranking.panel.button.add'))
        self.jjBtn:addEventListener(DisplayEvents.kTouchTap, function () self:popQRCode() end)
    elseif PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then 
        btn2:setString(Localization:getInstance():getText("invite.friend.panel.button.text.mitalk"))
        btn2:setColorMode(kGroupButtonColorMode.blue)
        btn2.iconWechat:setVisible(false)
        btn2.iconMi:setVisible(true)

        self.jjBtn:setVisible(false)
        self.jjBtn:setEnabled(false)
    else
        btn2:setString(Localization:getInstance():getText("my.card.btn2"))
        btn2.iconWechat:setVisible(true)
        btn2.iconMi:setVisible(false)

        self.jjBtn:setVisible(false)
        self.jjBtn:setEnabled(false)
    end
end

function RequestMessageZeroEnergyTwoButtons:popAskForEnergy()    
    local function onRequestSuccess()
        -- 没什么可做的
    end
    AskForEnergyPanel:popoutPanel(onRequestSuccess)
end
function RequestMessageZeroEnergyTwoButtons:showBottomCloseButton()
    return false
end

function RequestMessageZeroEnergyTwoButtons:popQRCode()
    if PlatformConfig:isPlatform(PlatformNameEnum.kJJ) then
        local position = self.jjBtn:getPosition()
        local wPosition = self.ui:convertToWorldSpace(ccp(position.x, position.y))
        --local panel = AddFriendPanel:create(wPosition)
        local panel = require("zoo.panel.addfriend.NewAddFriendPanel"):create(wPosition)
        -- panel:popout()
        return 
    end

    local function restoreBtn()
        if self.codeBtn.isDisposed then return end
        self.codeBtn:setEnabled(true)
    end
    local function onSuccess()
        restoreBtn()
        DcUtil:UserTrack({category = 'message', sub_category = 'message_center_send_qrcode', where = 4}, true)
    end
    local function onError(errCode, msg)
        restoreBtn()
    end
    local function onCancel()
        restoreBtn()
    end

    --just for mitalk
    local shareCallback = {
        onSuccess=function(result)
            CommonTip:showTip(Localization:getInstance():getText("share.feed.invite.success.tips"), "positive")
            restoreBtn()
            DcUtil:UserTrack({category = 'message', sub_category = 'message_center_send_qrcode', where = 4}, true)
        end,
        onError=function(errCode, msg)
            if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
                CommonTip:showTip(Localization:getInstance():getText("share.feed.faild.tips.mitalk"), "negative")
            else
                CommonTip:showTip(Localization:getInstance():getText("share.feed.invite.code.faild.tips"), "negative")
            end
            restoreBtn()
        end,
        onCancel=function()
            CommonTip:showTip(Localization:getInstance():getText("share.feed.cancel.tips"), "positive")
            restoreBtn()
        end
    }

    self.codeBtn:setEnabled(false)
    setTimeOut(restoreBtn, 2)

    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then        
        SnsUtil.sendInviteMessage(PlatformShareEnum.kMiTalk, shareCallback)
    else
        PersonalCenterManager:sendBusinessCard(onSuccess, onError, onCancel)
    end 
end

function RequestMessageZeroEnergyTwoButtons:setVisible(visible)
    RequestMessageZeroItem.setVisible(self, visible)
    self.energyBtn:setEnabled(visible)
    self.codeBtn:setEnabled(visible)
end