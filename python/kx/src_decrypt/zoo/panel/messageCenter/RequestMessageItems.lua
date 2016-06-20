

RequestMessageItemBase = class(ItemInClippingNode)
UnlockCloudRequestItem = class(RequestMessageItemBase)
FriendRequestItem = class(RequestMessageItemBase)
EnergyRequestItem = class(RequestMessageItemBase)
UpdateNewVersionItem = class(RequestMessageItemBase)
ActivityRequestItem = class(RequestMessageItemBase)

StartLevelMessageItemBase = class(RequestMessageItemBase)

LevelSurpassMessageItem = class(StartLevelMessageItemBase)
PassLastLevelOfLevelAreaMessageItem = class(StartLevelMessageItemBase)
ScoreSurpassMessageItem = class(StartLevelMessageItemBase)
PassMaxNormalLevelMessageItem = class(StartLevelMessageItemBase)
WeeklyMessageItem = class(StartLevelMessageItemBase)
PushEnergyItem = class(RequestMessageItemBase)
DengchaoEnergyItem = class(PushEnergyItem)

MessageOriginTypeClass = {
    [RequestType.kNeedUpdate]               = RequestMessageItemBase,
    [RequestType.kReceiveFreeGift]          = EnergyRequestItem,
    [RequestType.kSendFreeGift]             = EnergyRequestItem,
    [RequestType.kUnlockLevelArea]          = UnlockCloudRequestItem,
    [RequestType.kAddFriend]                = FriendRequestItem,
    [RequestType.kActivity]                 = ActivityRequestItem,
    [RequestType.kLevelSurpass]             = LevelSurpassMessageItem,
    [RequestType.kLevelSurpassLimited]      = LevelSurpassMessageItem,
    [RequestType.kPassLastLevelOfLevelArea] = PassLastLevelOfLevelAreaMessageItem,
    [RequestType.kScoreSurpass]             = ScoreSurpassMessageItem,
    [RequestType.kPassMaxNormalLevel]       = PassMaxNormalLevelMessageItem,
    [RequestType.kPushEnergy]               = PushEnergyItem,
    [RequestType.kDengchaoEnergy]           = DengchaoEnergyItem,
    [RequestType.kWeeklyRace]               = WeeklyMessageItem,
}

function RequestMessageItemBase:loadRequiredResource(panelConfigFile)
    self.panelConfigFile = panelConfigFile
    self.builder = InterfaceBuilder:create(panelConfigFile)
end

-- call in subclasses
function RequestMessageItemBase:init()
    self._isInRequest = false
    self._hasCompleted = false

    local ui = self.builder:buildGroup("friends_message_item")
    ItemInClippingNode.init(self)
    self:setContent(ui)
    self.ui = ui
    self.avatar_ico = ui:getChildByName("avatar_ico")
    self.line = ui:getChildByName("line")
    self.name_text = ui:getChildByName("name_text")
    self.msg_text = ui:getChildByName("msg_text")

    self.cancel = GroupButtonBase:create(ui:getChildByName("cancel"))
    self.confirm = GroupButtonBase:create(ui:getChildByName("confirm_button"))
    self.selected = ui:getChildByName("selected")

    self.ignoredTxt = ui:getChildByName('ignoredTxt')
    self.ignoredTxt:setString(Localization:getInstance():getText('message.center.disagree.already.text'))
    self.ignoredTxt:setVisible(false)

    self.descTxt = ui:getChildByName('descTxt')
    self.descTxt:setVisible(false)

    self.cancel:setColorMode(kGroupButtonColorMode.orange)
    self.confirm:setColorMode(kGroupButtonColorMode.green)

    self.selected:setVisible(false)

    self.itemPh = self.ui:getChildByName("itemPh")
    self.itemPhPos  = self.itemPh:getPosition()
    self.itemPhSize = self.itemPh:getGroupBounds().size
    self.itemPhSize = {width = self.itemPhSize.width, height = self.itemPhSize.height}
    self.itemPh:setVisible(false)

    self.numberLabel = self.ui:getChildByName("numberLabel")
    -- self:addChild(ui)
    local size = self.ui:getGroupBounds().size
    self:setHeight(size.height) 
    self:buildSyncAnimation()

    local function onTouchCancel(event) self:sendIgnore(false) end
    local function onTouchConfirm(event) if self.panel then self.panel:setFocusedItem(self) end self:sendAccept(false) end
    self.cancel:ad(DisplayEvents.kTouchTap, onTouchCancel)
    self.confirm:ad(DisplayEvents.kTouchTap, onTouchConfirm)

    self.ui:getChildByName('ph'):setVisible(false)
    self.ui:getChildByName('ph2'):setVisible(false)
end

function RequestMessageItemBase:setPageIndex(index)
    self.pageIndex = index
end

function RequestMessageItemBase:showDescText(text, showTime, fadeOutTime)
    showTime = showTime or 3
    fadeOutTime = fadeOutTime or 0.1
    if self.descTxt then
        self.descTxt:setVisible(true)
        self.descTxt:stopAllActions()
        self.descTxt:setOpacity(255)
        self.descTxt:setString(text)
        self.descTxt:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(showTime), CCFadeOut:create(fadeOutTime)))
    end
end


function RequestMessageItemBase:canAcceptAll()
    return true
end

function RequestMessageItemBase:canIgnoreAll()
    return true
end

function RequestMessageItemBase:setPanelRef(ref)
    self.panel = ref
end
function RequestMessageItemBase:onRequestSent(isBatch)
    self.processing = true
    if self.panel then self.panel:onRequestSent(isBatch) end
end
function RequestMessageItemBase:onMessageLifeFinished()
    if self.panel then self.panel:onMessageLifeFinished(self.pageIndex) end
end
function RequestMessageItemBase:onRequestCompleted(isBatch)
    self.processing = nil
    if self.panel then self.panel:onRequestCompleted(isBatch) end
end
function RequestMessageItemBase:sendAccept(isBatch)
    if self:isInRequest() then return end
    if self:hasCompleted() then return end
    local function _onSuccess(event)
        FreegiftManager:sharedInstance():removeMessageById(self.id) 
        self:onSendAcceptSuccess(event, isBatch)
    end
    local function _onFail(event) self:onSendAcceptFail(event, isBatch) end
    self:showSyncAnimation(true)
    self:showButtons(false)
    local action = 1
    local http = RespRequest.new()
    http:addEventListener(Events.kComplete, _onSuccess)
    http:addEventListener(Events.kError, _onFail)
    http:load(self.requestInfo.id, action)
    self:onRequestSent(isBatch)
end
function RequestMessageItemBase:sendIgnore(isBatch)
    if self:isInRequest() then return end
    if self:hasCompleted() then return end
    local function _onSuccess(event)
        FreegiftManager:sharedInstance():removeMessageById(self.id)
        self:onSendIgnoreSuccess(event, isBatch)
    end
    local function _onFail(event) self:onSendIgnoreFail(event, isBatch) end
    self:showSyncAnimation(true)
    self:showButtons(false)
    local action = 2
    local http = RespRequest.new()
    http:addEventListener(Events.kComplete, _onSuccess)
    http:addEventListener(Events.kError, _onFail)
    http:load(self.requestInfo.id, action)
    self:onRequestSent(isBatch)
end
function RequestMessageItemBase:onSendAcceptSuccess(event, isBatch)
    if self.isDisposed then return end
    self._isInRequest = false
    self._hasCompleted = true
    self:showSyncAnimation(false)
    self:showButtons(false)
    if self.selected and not self.selected.isDisposed then self.selected:setVisible(true) end -- show selected
    GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kMessageCenterUpdate))
    self:onRequestCompleted(isBatch)
    self:onMessageLifeFinished()
end
function RequestMessageItemBase:onSendAcceptFail(event, isBatch)
    if self.isDisposed then return end
    self._isInRequest = false
    self:showSyncAnimation(false)
    self:showButtons(true)
    if event then 
        RequestMessageItemBase:alert(event.data)
    end
    self:onRequestCompleted(isBatch)
end
function RequestMessageItemBase:onSendIgnoreSuccess(event, isBatch)
    GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kMessageCenterUpdate))
    
    if self.isDisposed then return end
    self._isInRequest = false
    self._hasCompleted = true
    self:showSyncAnimation(false)
    self:showButtons(false)
    self.ignoredTxt:setVisible(true) -- show ignore text
    self:onRequestCompleted(isBatch)
    self:onMessageLifeFinished()
end
function RequestMessageItemBase:onSendIgnoreFail(event, isBatch)
    if self.isDisposed then return end
    self._isInRequest = false
    self:showSyncAnimation(false)
    self:showButtons(true)
    if event then 
        RequestMessageItemBase:alert(event.data)
    end
    self:onRequestCompleted(isBatch)
end
function RequestMessageItemBase:buildSyncAnimation()
    if self.isDisposed then return end
    local winSize = CCDirector:sharedDirector():getWinSize()
    local container = Sprite:createEmpty()
    local back = Sprite:createWithSpriteFrameName("loading_ico_circle instance 10000")  
    local icon = Sprite:createWithSpriteFrameName("loading_ico_turn instance 10000")

    container:setCascadeOpacityEnabled(true)
    back:setCascadeOpacityEnabled(true)
    icon:setCascadeOpacityEnabled(true)

    container:setOpacity(0)
    container:addChild(back)
    container:addChild(icon)
    container:setPosition(ccp(winSize.width - 100, -100))
    container:setVisible(false)
    self.container = container
    self.icon = icon
    self:addChild(container)
end
function RequestMessageItemBase:showSyncAnimation(show)
    if self.isDisposed then return end
    local container = self.container
    local icon = self.icon
    if container.isDisposed or icon.isDisposed then return end
    container:setVisible(show)
    if show then
        container:runAction(CCFadeIn:create(0.2))
        icon:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 180)))
    else
        container:stopAllActions()
        icon:stopAllActions()
    end
end
function RequestMessageItemBase:showButtons(show)
    if self.isDisposed then return end
    self.confirm:setVisible(show)
    self.confirm:setEnabled(show)
    self.cancel:setVisible(show)
    self.cancel:setEnabled(show)
end
function RequestMessageItemBase:enableAcceptButton(enable)
    if self.isDisposed then return end
    if enable ~= true and enable ~= false then enable = false end
    self.enabled = enable
    self.confirm:setEnabled(enable)
end
local _isAlert = false
function RequestMessageItemBase:alert(err_code)
    local message
    if not tonumber(err_code) then 
        message = Localization:getInstance():getText("message.center.message.request.error") 
    else
        message = Localization:getInstance():getText("error.tip."..err_code)
    end
    local scene = Director:sharedDirector():getRunningScene()
    local function resetAlertFlag() _isAlert = false end
    if not _isAlert and scene then 
        _isAlert = true
        CommonTip:showTip(message, 'negative', nil, 2)
        setTimeOut(resetAlertFlag, 2)
    end
end
function RequestMessageItemBase:isInRequest()
    return self._isInRequest == true
end
function RequestMessageItemBase:hasCompleted()
    return self._hasCompleted == true
end
function RequestMessageItemBase:gainFocus()
end
function RequestMessageItemBase:looseFocus()
end
function RequestMessageItemBase:updateSelf()
end
function RequestMessageItemBase:dispose()
    CocosObject.dispose(self)
end
function RequestMessageItemBase:setData(requestInfo)
    self.requestInfo = requestInfo
    self.id = requestInfo.id
    self.type = requestInfo.type
    self.originType = requestInfo.originType
    local userName = requestInfo.name or ''
    local headUrl = requestInfo.headUrl
    local senderId = tonumber(requestInfo.senderUid)
    local friendRef = FriendManager.getInstance().friends[tostring(senderId)]
    if friendRef then
        if friendRef.name and friendRef.name ~= "" then userName = friendRef.name end
        if friendRef.headUrl and friendRef.headUrl ~= "" then headUrl = friendRef.headUrl end
    end
    if userName == nil or userName == "" then userName = "ID:"..tostring(senderId) end

    -- if headUrl then
    local framePos = self.avatar_ico:getPosition()
    local frameSize = self.avatar_ico:getContentSize()
    local function onImageLoadFinishCallback(clipping)
        if not self.ui or self.ui.isDisposed then return end
        
        local scale = frameSize.width/clipping:getContentSize().width
        clipping:setScale(scale*0.84)
        clipping:setPosition(ccp(frameSize.width/2-3, frameSize.height/2+2))
        -- clipping:setPosition(ccp(clippingPos.x + 9, clippingPos.y - 6 ))
        -- clipping:setAnchorPoint(ccp(-0.5, 0.5))
        -- clipping:setScale(0.89)
        self.avatar_ico:addChild(clipping)
    end
    HeadImageLoader:create(requestInfo.senderUid, headUrl,onImageLoadFinishCallback)

    self.name_text:setString(HeDisplayUtil:urlDecode(userName))
    self.confirm:setString(Localization:getInstance():getText("message.center.agree.btn"))
    self.cancel:setString(Localization:getInstance():getText("message.center.disagree.btn"))
end
function UnlockCloudRequestItem:setData(requestInfo)
    -- call super
    RequestMessageItemBase.setData(self, requestInfo)

    self.requestInfo = requestInfo
    local level = (requestInfo.itemId - 40001) * 15

    self.msg_text:setString(Localization:getInstance():getText("message.center.text.unlock.area", {level = level}))
    self.confirm:setString(Localization:getInstance():getText("message.center.agree.btn.unlock"))
end
function FriendRequestItem:setData(requestInfo)
    -- call super
    RequestMessageItemBase.setData(self, requestInfo)

    self.requestInfo = requestInfo

    self.msg_text:setString(Localization:getInstance():getText("message.center.text1"))
end
function FriendRequestItem:sendAccept(isBatch)
    if FriendManager:getInstance():getFriendCount() >= FriendManager:getInstance():getMaxFriendCount() then
        CommonTip:showTip(Localization:getInstance():getText("error.tip.731014"), "negative")
    else
        RequestMessageItemBase.sendAccept(self, isBatch)
    end
end
-- override super
function EnergyRequestItem:setData(requestInfo)
    -- call super
    RequestMessageItemBase.setData(self, requestInfo)

    self.requestInfo = requestInfo

    if requestInfo.type == 1 then -- send gift
        self:setToReceiveMode()
    elseif requestInfo.type == 2 then -- request for gift
        self:setToAcceptMode()
    end

end
-- override super
function EnergyRequestItem:sendIgnore(isBatch)
    if self:isInRequest() then return end
    if self:hasCompleted() then return end
    local function _onSuccess(event)
        self:onSendIgnoreSuccess(event, isBatch)
    end
    local function _onFail(event) self:onSendIgnoreFail(event) end
    self:showSyncAnimation(true)
    self:showButtons(false)
    local mgr = FreegiftManager:sharedInstance()
    mgr:ignoreFreegift(self.requestInfo.id, _onSuccess, _onFail)
    self:onRequestSent(isBatch)
end
-- override super
function EnergyRequestItem:sendAccept(isBatch)
    if self:isInRequest() then return end
    if self:hasCompleted() then return end

    if self.mode == EnergyRequestItemMode.kAcceptRequest then
        self:confirmForAcceptRequest(isBatch)
    elseif self.mode == EnergyRequestItemMode.kSendBack then
        self:confirmForSendBack(isBatch)
    elseif self.mode == EnergyRequestItemMode.kReceive then
        self:confirmForReceive(isBatch)
    end
end

function EnergyRequestItem:isSend()
    return self.mode == EnergyRequestItemMode.kAcceptRequest or self.mode == EnergyRequestItemMode.kSendBack
end

function EnergyRequestItem:isReceive()
    return self.mode == EnergyRequestItemMode.kReceive
end

function EnergyRequestItem:confirmForAcceptRequest(isBatch)
    local function _onSuccess(event)
        self:onSendAcceptSuccess(event, isBatch)
        DcUtil:energyGive(self.requestInfo.senderUid,self.requestInfo.itemId)
    end
    local function _onFail(event) self:onSendAcceptFail(event, isBatch) end

    if self:canSendMore() then -- confirm
        self._isInRequest = true
        self:showSyncAnimation(true)
        self:showButtons(false)
        local mgr = FreegiftManager:sharedInstance()
        mgr:sendGift(self.requestInfo.id, _onSuccess, _onFail, isBatch)
        self:onRequestSent(isBatch)
    end
end

function EnergyRequestItem:confirmForReceive(isBatch)
    local function _onSuccess(event)
        self:onSendAcceptSuccess(event, isBatch)
        DcUtil:energy_receive(self.requestInfo.senderUid,self.requestInfo.itemId)
    end
    local function _onFail(event) self:onSendAcceptFail(event, isBatch) end

    if self:canReceiveMore() then -- confirm
        
        self._isInRequest = true
        self:showSyncAnimation(true)
        self:showButtons(false)
        local mgr = FreegiftManager:sharedInstance()
        mgr:acceptFreegift(self.requestInfo.id, _onSuccess, _onFail)
        self:onRequestSent(isBatch)
    end
end

function EnergyRequestItem:confirmForSendBack(isBatch)
    local function _onSuccess(event)
        self:onSendAcceptSuccess(event, isBatch)
        DcUtil:energySendBack(self.requestInfo.senderUid,self.requestInfo.itemId)
    end
    local function _onFail(event) self:onSendAcceptFail(event, isBatch) end

    if self:canSendMore() and self:canSendBackToReceiver() then -- confirm

        local mgr = FreegiftManager:sharedInstance()
        self._isInRequest = true
        self:showSyncAnimation(true)
        self:showButtons(false)
        mgr:sendBackGift(self.requestInfo.id, _onSuccess, _onFail)
        self:onRequestSent(isBatch)
    end
end

function EnergyRequestItem:setToAcceptMode()
    if self.isDisposed then return end

    self.mode = EnergyRequestItemMode.kAcceptRequest
    self.msg_text:setString(Localization:getInstance():getText('message.center.message.requesting.energy'))
    
    self.confirm:setString(Localization:getInstance():getText('message.center.agree.btn'))
    if self:canSendMore() then 
        self.enabled = true
        self.confirm:setEnabled(true)
    else 
        self.enabled = false
        self.confirm:setEnabled(false)
        self.confirm:setString(Localization:getInstance():getText('message.center.panel.btn.sendtomorrow'))
    end
end

function EnergyRequestItem:setToSendBackMode()
    if self.isDisposed then return end
    
    self.mode = EnergyRequestItemMode.kSendBack
    self.msg_text:setString(Localization:getInstance():getText('message.center.message.sendingback.energy'))
    self.confirm:setString(Localization:getInstance():getText('message.center.button.sendback'))
    if self:canSendMore() and self:canSendBackToReceiver() then 
        self.confirm:setColorMode(kGroupButtonColorMode.blue)
        self.confirm:setEnabled(true)
    else 
        self.enabled = false
        self.confirm:setEnabled(false)
        self.confirm:setString(Localization:getInstance():getText('message.center.panel.btn.sendtomorrow'))
    end
    self.cancel:setEnabled(false)
    self.cancel:setVisible(false)
end

function EnergyRequestItem:setToReceiveMode()
    if self.isDisposed then return end

    self.mode = EnergyRequestItemMode.kReceive
    self.msg_text:setString(Localization:getInstance():getText('message.center.message.receiving.energy'))

    self.confirm:setString(Localization:getInstance():getText('beginner.panel.btn.get.text'))
    if self:canReceiveMore() then 
        self.enabled = true
        self.confirm:setColorMode(kGroupButtonColorMode.green)
        self.confirm:setEnabled(true)
    else 
        self.enabled = false
        self.confirm:setEnabled(false)
        self.confirm:setString(Localization:getInstance():getText('message.center.panel.btn.receivetomorrow'))
    end
end
-- override super
function EnergyRequestItem:onSendAcceptSuccess(event, isBatch)
    if self.isDisposed then return end
    self._isInRequest = false
    self:showSyncAnimation(false)
    local txt = ''
    if self.mode == EnergyRequestItemMode.kReceive then
        -- play animation
        local pos = self.confirm:getPosition()
        local rPos = {x = pos.x - 20, y = pos.y + 40}
        local worldPos = self.ui:convertToWorldSpace(ccp(rPos.x, rPos.y))
        -- local scale = self.energy_ico:getScale()
        local anim = HomeScene:sharedInstance():createFlyToBagAnimation(10012, 1)
        anim:setPosition(ccp(worldPos.x, worldPos.y))
        -- anim:setScale(scale)
        anim:playFlyToAnim(false)

        -- change to send back mode
        if self:canSendBackToReceiver() then 
            self:setToSendBackMode()
            self:showButtons(true)
        else
            self._hasCompleted = true
            self:showButtons(false)
            FreegiftManager:sharedInstance():removeMessageById(self.id)
            if self.selected and not self.selected.isDisposed then self.selected:setVisible(true) end
        end

        if not isBatch then
            -- local __, num = FreegiftManager:sharedInstance():canReceiveMore()
            local num = FreegiftManager:sharedInstance():getReceivedNum()
            txt = Localization:getInstance():getText('message.center.panel.ruledesc.receive', {n = num})
        end


    else
        self._hasCompleted = true
        self:showButtons(false)
        if self.selected and not self.selected.isDisposed then self.selected:setVisible(true) end -- show selected

        if not isBatch then
            -- local __, num = FreegiftManager:sharedInstance():canSendMore()
            local num = FreegiftManager:sharedInstance():getSentNum()
            txt = Localization:getInstance():getText('message.center.panel.ruledesc.send', {n = num})
        end
    end
    if not isBatch then
        self.descTxt:setString(txt)
        self.descTxt:setVisible(true)
        self.descTxt:setOpacity(255)
        self.descTxt:stopAllActions()
        self.descTxt:runAction(
            CCSequence:createWithTwoActions(
            CCDelayTime:create(2), CCFadeOut:create(0.5)
                                            )
                               )
    end


    GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kMessageCenterUpdate))
    self:onRequestCompleted(isBatch)
    if self._hasCompleted then self:onMessageLifeFinished() end
end

function EnergyRequestItem:looseFocus()
    self._isOnFocus = false

end
function EnergyRequestItem:gainFocus()
    self._isOnFocus = true
end
function EnergyRequestItem:updateSelf()
    if self:isInRequest() then return end
    if self.mode == EnergyRequestItemMode.kAcceptRequest then
        self:setToAcceptMode()
    elseif self.mode == EnergyRequestItemMode.kSendBack then
        self:setToSendBackMode()
    elseif self.mode == EnergyRequestItemMode.kReceive then 
        self:setToReceiveMode()
    end
end
function EnergyRequestItem:canSendBackToReceiver()
    return FreegiftManager:sharedInstance():canSendBackTo(self.requestInfo.senderUid)
end
function EnergyRequestItem:canSendMore()
    return FreegiftManager:sharedInstance():canSendMore()
end
function EnergyRequestItem:canReceiveMore()
    return FreegiftManager:sharedInstance():canReceiveMore()
end


--UpdateNewVersionItem
function UpdateNewVersionItem:ctor()
    self.requestInfos = nil
end

function UpdateNewVersionItem:setRequestInfos(requestInfos)
    self.requestInfos = requestInfos
end

function UpdateNewVersionItem:setData(requestInfo)
    RequestMessageItemBase.setData(self, requestInfo)

    --
    if NewVersionUtil:hasPackageUpdate() then
        self.msg_text:setString(Localization:getInstance():getText('message.center.message.need.update'))
    else
        self.msg_text:setString(Localization:getInstance():getText('new.version.tip.message.1'))
    end

    self.msg_text:setFontSize(26)
    self.msg_text:setPositionY(self.msg_text:getPositionY())
    self.cancel:setVisible(false)
    self.confirm:setVisible(false)
end

function UpdateNewVersionItem:sendIgnore(isBatch)
    if MessageOriginTypeClass[self.originType] then
        MessageOriginTypeClass[self.originType].sendIgnore(self, isBatch)
    else
        FreegiftManager:sharedInstance():removeMessageById(self.id)
    end
end

function UpdateNewVersionItem:sendAccept(isBatch)
    -- do nothing
end

function ActivityRequestItem:init()
    RequestMessageItemBase.init(self)
    self.iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
end

function ActivityRequestItem:setData(requestInfo)
    RequestMessageItemBase.setData(self, requestInfo)

    self.requestInfo = requestInfo
    local message = requestInfo.message or ""
    self.msg_text:setString(message)
    self.confirm:setString(Localization:getInstance():getText('message.center.help.btn'))
    
end

local function addReward(reward)
    for k, v in pairs(reward) do 
        if v.itemId == ItemType.COIN then
            UserManager:getInstance().user:setCoin(UserManager:getInstance().user:getCoin() + v.num)
            UserService:getInstance().user:setCoin(UserService:getInstance().user:getCoin() + v.num)
            if HomeScene:sharedInstance().coinButton then
                HomeScene:sharedInstance():checkDataChange()
                HomeScene:sharedInstance().coinButton:updateView()
            end
        elseif v.itemId == ItemType.GOLD then
            UserManager:getInstance().user:setCash(UserManager:getInstance().user:getCash() + v.num)
            UserService:getInstance().user:setCash(UserService:getInstance().user:getCash() + v.num)
            if HomeScene:sharedInstance().goldButton then
                HomeScene:sharedInstance():checkDataChange()
                HomeScene:sharedInstance().goldButton:updateView()
            end
        else
            UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
            UserService:getInstance():addUserPropNumber(v.itemId, v.num)
        end
    end
end

function ActivityRequestItem:onSendAcceptSuccess(event, isBatch)
    if self.isDisposed then return end
    local itemsData = event.data.rewards

    self._isInRequest = false
    self._hasCompleted = true
    self:showSyncAnimation(false)
    self:showButtons(false)

    local function flyEndCallback()
        if self.selected and not self.selected.isDisposed then self.selected:setVisible(true) end -- show selected
        GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kMessageCenterUpdate))
        self:onRequestCompleted(isBatch)
        self:onMessageLifeFinished()
    end  

    local function showResultMessage(text, time, fadeOutTime)
        if not isBatch then
            self:showDescText(text, time, fadeOutTime)
        end
    end

    local respState = event.data.helpResult
    if respState == 1 then              --1 帮助成功并可领奖
        self:showRewardIcon(itemsData, flyEndCallback)
    elseif respState == 2 then          --2 帮助成功没有奖
        flyEndCallback()
        showResultMessage(event.data.message, 3, 0.5)
    elseif respState == 3 then          --3 帮助自己
        flyEndCallback() 
        showResultMessage(Localization:getInstance():getText(event.data.message), 3, 0.5)
        -- CommonTip:showTip(Localization:getInstance():getText(event.data.message), "negative")
    elseif respState == 4 then          --4 活动结束
        flyEndCallback() 
        showResultMessage(Localization:getInstance():getText(event.data.message), 3, 0.5)
        -- CommonTip:showTip(Localization:getInstance():getText(event.data.message), "negative")
    elseif respState == 5 then          --5 重复帮助一个人无奖励
        flyEndCallback() 
        showResultMessage(Localization:getInstance():getText(event.data.message), 3, 0.5)
        -- CommonTip:showTip(Localization:getInstance():getText(event.data.message), "negative")
    else
        flyEndCallback()
    end
end

function ActivityRequestItem:showRewardIcon(itemsData, flyEndCallback)
    if not itemsData then return end 
    local itemId = itemsData[1].itemId
    local itemNum = itemsData[1].num 
    if not itemId or not itemNum then return end

    if ItemType:isTimeProp(itemId) then itemId = ItemType:getRealIdByTimePropId(itemId) end
    local itemRes   = ResourceManager:sharedInstance():buildItemGroup(itemId)
    self.itemRes    = itemRes
    self.ui:addChild(itemRes)

    local itemResSize   = itemRes:getGroupBounds().size
    local neededScaleX  = self.itemPhSize.width / itemResSize.width
    local neededScaleY  = self.itemPhSize.height / itemResSize.height

    local smallestScale = neededScaleX
    if neededScaleX > neededScaleY then
        smallestScale = neededScaleY
    end

    itemRes:setScaleX(smallestScale)
    itemRes:setScaleY(smallestScale)

    local itemResSize   = itemRes:getGroupBounds().size
    local deltaWidth    = self.itemPhSize.width - itemResSize.width
    local deltaHeight   = self.itemPhSize.height - itemResSize.height
    
    itemRes:setPosition(ccp( self.itemPhPos.x + deltaWidth/2, 
                self.itemPhPos.y - deltaHeight/2))
    self.numberLabel:setString("x" .. itemNum)

    self.numberLabel:stopAllActions()
    self.numberLabel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(function ()
        self:flyRewardIcon(itemsData, flyEndCallback)
    end)))
end

function ActivityRequestItem:flyRewardIcon(itemsData, endCallback)
    if self.itemRes then self.itemRes:setVisible(false) end 
    if self.numberLabel then self.numberLabel:setVisible(false) end

    local rewardIds = {}
    local rewardAmounts = {}

    for k1,v1 in pairs(itemsData) do
        local itemId        = v1.itemId
        local itemNumber    = v1.num
        table.insert(rewardIds, itemId)
        table.insert(rewardAmounts, itemNumber)
    end

    local anims = HomeScene:sharedInstance():createFlyingRewardAnim(rewardIds, rewardAmounts)
    local itemResPosInWorld = self.itemRes:getPositionInWorldSpace()
    anims[1]:setPosition(ccp(itemResPosInWorld.x, itemResPosInWorld.y))

    local scaleX = self.itemRes:getScaleX()
    local scaleY = self.itemRes:getScaleY()
    if scaleX > scaleY then
        anims[1]:setScaleX(scaleX)
        anims[1]:setScaleY(scaleX)
    else
        anims[1]:setScaleX(scaleY)
        anims[1]:setScaleY(scaleY)
    end

    addReward(itemsData)
    local function onAnimFinished()
        if self.isDisposed then return end
        local delay = CCDelayTime:create(0.3)
        local function removeSelf()
            if endCallback then
                endCallback() 
            end             
        end
        local callAction = CCCallFunc:create(removeSelf)
        local seq = CCSequence:createWithTwoActions(delay, callAction)
        self:runAction(seq)
    end
    anims[1]:playFlyToAnim(onAnimFinished)
end

-- function ActivityRequestItem:onSendAcceptSuccess(event, isBatch)
--     if self.isDisposed then return end
--     self._isInRequest = false
--     self._hasCompleted = true
--     self:showSyncAnimation(false)
--     self:showButtons(false)

--     if self.selected and not self.selected.isDisposed then self.selected:setVisible(true) end -- show selected
--     GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kMessageCenterUpdate))
--     self:onRequestCompleted(isBatch)

--     print(table.tostring(event.data))
--     local itemsData = event.data.rewards
--     local isError = false
--     if itemsData == nil then
--         itemsData = {}
--         isError = true
--     end

--     addReward(itemsData)

--     local message = event.data.message or ""
--     local message2 = event.data.rewardlimitDesc or ""
--     self:showRewardPanel(itemsData, message, message2, isError)
-- end

-- function ActivityRequestItem:showRewardPanel(itemsData, message, message2, isError)
--     local scene = Director:sharedDirector():getRunningScene()
--     if not scene then return end

--     local function getItem(itemId, num)
--         if ItemType:isTimeProp(itemId) then itemId = ItemType:getRealIdByTimePropId(itemId) end
--         local item = self.builder:buildGroup('message_item')
--         local icon = self.iconBuilder:buildGroup('Prop_'..itemId)
--         item.iconPh = item:getChildByName('icon')
--         item.text = item:getChildByName('text')
--         item.iconPh:setVisible(false)
--         item.iconPh:getParent():addChild(icon)
--         icon:setScale(item.iconPh:getGroupBounds().size.width / icon:getGroupBounds().size.width)
--         if itemId == ItemType.COIN then
--             icon:setScale(icon:getScale() * 1.2)
--         end
--         icon:setPositionX(item.iconPh:getPositionX())
--         icon:setPositionY(item.iconPh:getPositionY())
--         item.text:setText('x'..tostring(num))
--         return item
--     end

--     local items = {}

--     for k, v in pairs(itemsData) do
--         local item = getItem(v.itemId, v.num)
--         table.insert(items, item)
--     end

--     local panel = self.builder:buildGroup('message_activity')
--     panel:ignoreAnchorPointForPosition(false)
--     panel:setAnchorPoint(ccp(0.5, 0.5))
--     local explain = panel:getChildByName('explain')
--     explain:setString(message2)

--     local text = nil 
--     if not isError then
--         text = panel:getChildByName('text')
--         panel:getChildByName('animError'):setVisible(false)
--     else
--         text = panel:getChildByName('errorText')
--         panel:getChildByName('anim'):setVisible(false)
--     end
--     text:setString(message)


--     local ph = panel:getChildByName('items')
--     ph:setVisible(false)
--     local width = ph:getGroupBounds().size.width
--     local totalWidth = 0
--     for k, v in pairs(items) do
--         totalWidth = totalWidth + v:getGroupBounds().size.width
--     end
--     local offset = ph:getPositionX() + (width - totalWidth) / 2
--     local Y = ph:getPositionY()
--     for k, v in pairs(items) do
--         v:setPositionY(Y)
--         v:setPositionX(offset)
--         offset = offset + v:getGroupBounds().size.width
--         ph:getParent():addChild(v)
--     end


--     local function onTimeout()
--         if not self.schedule or panel.isDisposed then return end
--         Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedule)
--         self.schedule = nil
--         local function remove()
--             if not panel or panel.isDisposed then return end
--             panel:removeFromParentAndCleanup(true)
--         end
--         panel:runAction(CCSequence:createWithTwoActions(CCEaseBackIn:create(CCScaleTo:create(0.2, 0)), CCCallFunc:create(remove)))
        
--     end
--     local function onScaled()
--         self.schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout, 2, false)
--     end
--     panel:setScale(0)
--     panel:runAction(CCSequence:createWithTwoActions(CCEaseBackOut:create(CCScaleTo:create(0.2, 1)), CCCallFunc:create(onScaled)))
--     local scene = Director:sharedDirector():getRunningScene()
--     local wSize = Director:sharedDirector():getWinSize()
--     local vSize = Director:sharedDirector():getVisibleSize()
--     local vOrigin = Director:sharedDirector():getVisibleOrigin()
--     panel:setPosition(ccp(vOrigin.x + vSize.width / 2, vSize.height / 2 + vOrigin.y))
--     scene:addChild(panel)

-- end


function PushEnergyItem:init()
    self._isInRequest = false
    self._hasCompleted = false

    local ui = self.builder:buildGroup("push_energy_message_item")
    ItemInClippingNode.init(self)
    self:setContent(ui)
    self.ui = ui

    self.bg = ui:getChildByName('sprite')
    self.confirm = GroupButtonBase:create(ui:getChildByName('btn'))
    self.confirm:setString(localize('接收'))
    self.confirm:ad(DisplayEvents.kTouchTap, function () self:sendAccept() end)

    self.selected = ui:getChildByName('selected')
    self.selected:setVisible(false)

    self:buildSyncAnimation()
end

-- override super
function PushEnergyItem:setData(requestInfo)
    self.requestInfo = requestInfo
end

-- override super
function PushEnergyItem:sendIgnore(isBatch)
    -- 不支持忽略
end

local function addReward(reward)
    for k, v in pairs(reward) do 
        if v.itemId == ItemType.COIN then
            UserManager:getInstance().user:setCoin(UserManager:getInstance().user:getCoin() + v.num)
            UserService:getInstance().user:setCoin(UserService:getInstance().user:getCoin() + v.num)
            if HomeScene:sharedInstance().coinButton then
                HomeScene:sharedInstance():checkDataChange()
                HomeScene:sharedInstance().coinButton:updateView()
            end
        elseif v.itemId == ItemType.GOLD then
            UserManager:getInstance().user:setCash(UserManager:getInstance().user:getCash() + v.num)
            UserService:getInstance().user:setCash(UserService:getInstance().user:getCash() + v.num)
            if HomeScene:sharedInstance().goldButton then
                HomeScene:sharedInstance():checkDataChange()
                HomeScene:sharedInstance().goldButton:updateView()
            end
        else
            if not ItemType:isTimeProp(v.itemId) then
                UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
                UserService:getInstance():addUserPropNumber(v.itemId, v.num)
            else
                local propMeta = MetaManager:getInstance():getPropMeta(v.itemId)
                assert(propMeta)
                local p = TimePropRef.new()
                p.itemId = v.itemId
                p.num = v.num
                p.expireTime = Localhost:time() + propMeta.expireTime
                table.insert(UserManager:getInstance().timeProps, p)

                local p2 = TimePropRef.new()
                p2:fromLua(p)
                table.insert(UserService:getInstance().timeProps, p2)
            end
        end
        if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
                    else print("Did not write user data to the device.") end
    end
end
-- override super
function PushEnergyItem:sendAccept(isBatch)
    if self:isInRequest() then return end
    if self:hasCompleted() then return end
    local function _onSuccess(event)
        if self.isDisposed then return end
        local itemId = tonumber(self.requestInfo.itemId)
        local num = tonumber(self.requestInfo.itemNum)
        local pos = self.confirm:getPosition()
        -- local rPos = {x = pos.x - 20, y = pos.y + 40}
        -- local worldPos = self.ui:convertToWorldSpace(ccp(rPos.x, rPos.y))
        -- local scale = self.energy_ico:getScale()
        -- local anim = HomeScene:sharedInstance():createFlyToBagAnimation(itemId, num)
        -- anim:setPosition(ccp(worldPos.x, worldPos.y))
        -- -- anim:setScale(scale)
        -- anim:playFlyToAnim(false)

        local anim = FlyItemsAnimation:create({{itemId = itemId, num = num}})
        anim:setWorldPosition(self.ui:convertToWorldSpace(pos))
        anim:play()

        addReward({{itemId = itemId, num = num}})

        -- change to send back mode
        self._hasCompleted = true
        self:showButtons(false)
        FreegiftManager:sharedInstance():removeMessageById(self.id)
        if self.selected and not self.selected.isDisposed then self.selected:setVisible(true) end

        FreegiftManager:sharedInstance():removeMessageById(self.id) 
        self:onSendAcceptSuccess(event, isBatch)
    end
    local function _onFail(event) self:onSendAcceptFail(event, isBatch) end
    self:showSyncAnimation(true)
    self:showButtons(false)
    local action = 1
    local http = RespRequest.new()
    http:addEventListener(Events.kComplete, _onSuccess)
    http:addEventListener(Events.kError, _onFail)
    http:load(self.requestInfo.id, action)
    self:onRequestSent(isBatch)
    DcUtil:UserTrack({category = 'message', sub_category = 'message_center_get_npc_energy'}, true)
end

function PushEnergyItem:canAcceptAll()
    return true
end

function PushEnergyItem:canIgnoreAll()
    return false
end

function PushEnergyItem:isReceive()
    return true
end

function PushEnergyItem:isSend()
    return false
end

function PushEnergyItem:showButtons(show)
    if self.isDisposed then return end
    self.confirm:setVisible(show)
    self.confirm:setEnabled(show)
end

--------------------------------------------------------
-- DengchaoEnergyItem
--------------------------------------------------------
function DengchaoEnergyItem:loadRequiredResource()
    self.panelConfigFile = 'ui/DengchaoPushEnergy.json'
    self.builder = InterfaceBuilder:createWithContentsOfFile(self.panelConfigFile)
end

function DengchaoEnergyItem:init()
    
    self._isInRequest = false
    self._hasCompleted = false

    local ui = self.builder:buildGroup("push_energy_message_item_dengchao")
    ItemInClippingNode.init(self)
    self:setContent(ui)
    self.ui = ui

    self.bg = ui:getChildByName('sprite')
    self.confirm = GroupButtonBase:create(ui:getChildByName('btn'))
    self.confirm:setString('接收')
    self.confirm:ad(DisplayEvents.kTouchTap, function () self:sendAccept() end)

    self.selected = ui:getChildByName('selected')
    self.selected:setVisible(false)

    self:setHeight(252)

    self:buildSyncAnimation()
    DcUtil:UserTrack({category = 'message', sub_category = 'message_center_see_chenkun_energy'})
end

function DengchaoEnergyItem:sendAccept(isBatch)
    if self:isInRequest() then return end
    if self:hasCompleted() then return end
    local function _onSuccess(event)
        if self.isDisposed then return end
        local itemId = tonumber(self.requestInfo.itemId)
        local num = tonumber(self.requestInfo.itemNum)
        local pos = self.confirm:getPosition()
        local rPos = {x = pos.x - 20, y = pos.y + 40}
        local worldPos = self.ui:convertToWorldSpace(ccp(rPos.x, rPos.y))
        -- local scale = self.energy_ico:getScale()
        local anim = HomeScene:sharedInstance():createFlyToBagAnimation(itemId, num)
        anim:setPosition(ccp(worldPos.x, worldPos.y))
        -- anim:setScale(scale)
        anim:playFlyToAnim(false)
        addReward({{itemId = itemId, num = num}})

        -- change to send back mode
        self._hasCompleted = true
        self:showButtons(false)
        FreegiftManager:sharedInstance():removeMessageById(self.id)
        if self.selected and not self.selected.isDisposed then self.selected:setVisible(true) end

        FreegiftManager:sharedInstance():removeMessageById(self.id) 
        HomeScene:sharedInstance():hideDengchaoEnergyAnim()
        self:onSendAcceptSuccess(event, isBatch)
    end
    local function _onFail(event) self:onSendAcceptFail(event, isBatch) end
    self:showSyncAnimation(true)
    self:showButtons(false)
    local action = 1
    local http = RespRequest.new()
    http:addEventListener(Events.kComplete, _onSuccess)
    http:addEventListener(Events.kError, _onFail)
    http:load(self.requestInfo.id, action)
    self:onRequestSent(isBatch)
    DcUtil:UserTrack({category = 'message', sub_category = 'message_center_get_chenkun_energy'})
end

function DengchaoEnergyItem:canAcceptAll()
    return false
end



-- LevelSurpassMessageItem = class(RequestMessageItemBase)
-- PassLastLevelOfLevelAreaMessageItem = class(RequestMessageItemBase)
-- ScoreSurpassMessageItem = class(RequestMessageItemBase)
-- PassMaxNormalLevelMessageItem = class(RequestMessageItemBase)

-------------------------------------------------
-- StartLevelMessageItemBase
-------------------------------------------------
function StartLevelMessageItemBase:init()
    RequestMessageItemBase.init(self)
end

function StartLevelMessageItemBase:setData(requestInfo)
    RequestMessageItemBase.setData(self, requestInfo)
    self.confirm:setString(localize('request.message.panel.news.btn2')) 
end

function StartLevelMessageItemBase:canAcceptAll()
    return false
end

function StartLevelMessageItemBase:canIgnoreAll()
    return true
end

function StartLevelMessageItemBase:sendAccept(isBatch)
    self:sendIgnore(isBatch)
    self:startLevel(UserManager:getInstance().user:getTopLevelId())
end

function StartLevelMessageItemBase:startLevel(levelId)
    local function startLevel()
        if levelId then
            HomeScene:sharedInstance().worldScene:startLevel(levelId)
        end
    end
    self:onRequestSent(isBatch)
    self:onSendAcceptSuccess(nil, isBatch)
    Director:sharedDirector():popScene()
    HomeScene:sharedInstance():runAction(CCCallFunc:create(startLevel))
end

-------------------------------------------------
-- LevelSurpassMessageItem
-------------------------------------------------
function LevelSurpassMessageItem:setData(requestInfo)
    RequestMessageItemBase.setData(self, requestInfo)
    self.levelId = tonumber(self.requestInfo.itemId)
    local levelString = tostring(self.levelId)
    if self.levelId > LevelConstans.HIDE_LEVEL_ID_START then
        levelString = '+'..tostring(self.levelId - LevelConstans.HIDE_LEVEL_ID_START) 
    end
    self.confirm:setString(localize('request.message.panel.news.btn2'))
    self.msg_text:setString(localize('request.message.panel.news.text2', {num = levelString}))

end

function LevelSurpassMessageItem:sendAccept(isBatch)
    StartLevelMessageItemBase.sendAccept(self, isBatch)
    DcUtil:UserTrack({category = 'message', sub_category = 'message_center_challenge_high_level'}, true)
end

-------------------------------------------------
-- WeeklyMessageItem
-------------------------------------------------
function WeeklyMessageItem:setData(requestInfo)
    StartLevelMessageItemBase.setData(self, requestInfo)
    self.confirm:setString(localize('request.message.panel.news.btn2'))
    self.msg_text:setString(localize('weeklyrace.winter.rank.news'))
end

function WeeklyMessageItem:sendAccept(isBatch)
    self:sendIgnore(isBatch)
    -- DcUtil:UserTrack({category = 'message', sub_category = 'message_center_challenge_high_level'}, true)

    local function startLevel()
        --周赛处理逻辑
        SeasonWeeklyRaceManager:getInstance():pocessSeasonWeeklyDecision(true)
    end
    self:onRequestSent(isBatch)
    self:onSendAcceptSuccess(nil, isBatch)
    Director:sharedDirector():popScene()
    HomeScene:sharedInstance():runAction(CCCallFunc:create(startLevel))
end

------------------------------------------------
-- PassLastLevelOfLevelAreaMessageItem
------------------------------------------------
function PassLastLevelOfLevelAreaMessageItem:setData(requestInfo)
    RequestMessageItemBase.setData(self, requestInfo)
    self.levelId = tonumber(self.requestInfo.itemId)
    self.confirm:setString(localize('request.message.panel.news.btn2'))
    self.msg_text:setString(localize('request.message.panel.news.text3', {num = self.levelId}))
end

function PassLastLevelOfLevelAreaMessageItem:sendAccept(isBatch)
    StartLevelMessageItemBase.sendAccept(self, isBatch)
    DcUtil:UserTrack({category = 'message', sub_category = 'message_center_challenge_zone_level'}, true)
end


------------------------------------------------
-- PassMaxNormalLevelMessageItem
------------------------------------------------
function PassMaxNormalLevelMessageItem:setData(requestInfo)
    RequestMessageItemBase.setData(self, requestInfo)
    self.levelId = tonumber(requestInfo.itemId)
    self.confirm:setString(localize('request.message.panel.news.btn2'))
    self.msg_text:setString(localize('request.message.panel.news.text4', {num = self.levelId}))
end

function PassMaxNormalLevelMessageItem:sendAccept(isBatch)
    StartLevelMessageItemBase.sendAccept(self, isBatch)
    DcUtil:UserTrack({category = 'message', sub_category = 'message_center_challenge_version_level'}, true)
end



----------------------------------------------------
-- ScoreSurpassMessageItem
----------------------------------------------------
function ScoreSurpassMessageItem:init()
    RequestMessageItemBase.init(self)
end

function ScoreSurpassMessageItem:setData(requestInfo)
    RequestMessageItemBase.setData(self, requestInfo)
    self.confirm:setString(localize('request.message.panel.news.btn1'))
    self.levelId = tonumber(requestInfo.itemId) or 0
    local levelString = tostring(self.levelId)
    if self.levelId > LevelConstans.HIDE_LEVEL_ID_START then
        levelString = '+'..tostring(self.levelId - LevelConstans.HIDE_LEVEL_ID_START) 
    end
    self.msg_text:setString(localize('request.message.panel.news.text1', {num = levelString}))
end

function ScoreSurpassMessageItem:canAcceptAll()
    return false
end

function ScoreSurpassMessageItem:canIgnoreAll()
    return true
end

function ScoreSurpassMessageItem:sendAccept(isBatch)
    if self.levelId and self.levelId > 0 then
        self:sendIgnore(isBatch)
        self:startLevel(self.levelId)
    end
    DcUtil:UserTrack({category = 'message', sub_category = 'message_center_challenge_high_score'}, true)
end