
require "zoo.util.NewVersionUtil"
require "zoo.panel.component.common.LayoutItem"
require "zoo.data.FreegiftManager"

local EnergyRequestItemMode = {kAcceptRequest = 1, kReceive = 2, kSendBack = 3}

RequestMessageItemBase = class(ItemInClippingNode)
UnlockCloudRequestItem = class(RequestMessageItemBase)
FriendRequestItem = class(RequestMessageItemBase)
EnergyRequestItem = class(RequestMessageItemBase)
UpdateNewVersionItem = class(RequestMessageItemBase)

MessageOriginTypeClass = {
    [0] = RequestMessageItemBase,
    [1] = EnergyRequestItem,
    [2] = EnergyRequestItem,
    [3] = UnlockCloudRequestItem,
    [5] = FriendRequestItem,
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

    -- self:addChild(ui)
    local size = self.ui:getGroupBounds().size
    self:setHeight(size.height) 
    self:buildSyncAnimation()

    local function onTouchCancel(event) self:sendIgnore(false) end
    local function onTouchConfirm(event) if self.panel then self.panel:setFocusedItem(self) end self:sendAccept(false) end
    self.cancel:ad(DisplayEvents.kTouchTap, onTouchCancel)
    self.confirm:ad(DisplayEvents.kTouchTap, onTouchConfirm)

    self:buildSyncAnimation()
end
function RequestMessageItemBase:setPanelRef(ref)
    self.panel = ref
end
function RequestMessageItemBase:onRequestSent(isBatch)
    self.processing = true
    if self.panel then self.panel:onRequestSent(isBatch) end
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
    if self.isDisposed then return end
    self._isInRequest = false
    self._hasCompleted = true
    self:showSyncAnimation(false)
    self:showButtons(false)
    self.ignoredTxt:setVisible(true) -- show ignore text
    GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kMessageCenterUpdate))
    self:onRequestCompleted(isBatch)
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
        local item = RequireNetworkAlert.new(CCNode:create())
        item:buildUI(message)
        scene:addChild(item) 
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

    self.msg_text:setString(Localization:getInstance():getText("message.center.text.unlock.area"))
    self.confirm:setString(Localization:getInstance():getText("message.center.agree.btn.unlock"))
end
function FriendRequestItem:setData(requestInfo)
    -- call super
    RequestMessageItemBase.setData(self, requestInfo)

    self.requestInfo = requestInfo

    self.msg_text:setString(Localization:getInstance():getText("message.center.text1"))
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
        mgr:sendGift(self.requestInfo.id, _onSuccess, _onFail)
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
        mgr:sendGift(self.requestInfo.id, _onSuccess, _onFail)
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
    self.msg_text:setString(Localization:getInstance():getText('message.center.message.need.update'))
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

RequestMessageZeroItem = class(Layer)
RequestMessageZeroFriend = class(RequestMessageZeroItem)
RequestMessageZeroEnergy = class(RequestMessageZeroItem)
RequestMessageZeroUnlock = class(RequestMessageZeroItem)
RequestMessageZeroUpdate = class(RequestMessageZeroItem)

function RequestMessageZeroItem:create(width, height)
    local ret = RequestMessageZeroItem.new()
    ret:initLayer()
    ret:init(width, height)
    return ret
end

function RequestMessageZeroItem:init(width, height)
    local builder = InterfaceBuilder:create(PanelConfigFiles.request_message_panel)
    local text = TextField:create("", nil, 36, CCSizeMake(600,0))
    text:setColor(ccc3(144, 89, 2))
    text:setAnchorPoint(ccp(0, 1))
    self.text = text
    self:addChild(text)
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
        local panel = AddFriendPanel:create(wPosition)
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
    local builder = InterfaceBuilder:create(PanelConfigFiles.request_message_panel)
    local ui = builder:buildGroup("request_message_panel_zero_energy")
    self:addChild(ui)
    local bg = ui:getChildByName("bg")
    local text1 = ui:getChildByName("text1")
    local text2 = ui:getChildByName("text2")
    local text3 = ui:getChildByName("text3")
    local btn1 = ui:getChildByName("btn1")
    local btn2 = ui:getChildByName("btn2")
    btn1 = GroupButtonBase:create(btn1)
    btn2 = GroupButtonBase:create(btn2)
    self.btn1 = btn1
    self.btn2 = btn2

    local size = bg:getPreferredSize()
    local scale = width / (size.width + 40)
    if scale > height / (size.height + 40) then scale = height / (size.height + 40) end
    if scale < 1 then self:setScale(scale)
    else scale = 1 end
    self:setPositionX((width - size.width * scale) / 2)
    self:setPositionY(-(height - size.height * scale) / 2)

    text1:setString(Localization:getInstance():getText("request.message.panel.zero.energy.title"))
    text2:setString(Localization:getInstance():getText("request.message.panel.zero.energy.text1"))
    text3:setString(Localization:getInstance():getText("request.message.panel.zero.energy.text2"))
    btn1:setString(Localization:getInstance():getText("request.message.panel.zero.energy.button1"))
    btn2:setString(Localization:getInstance():getText("request.message.panel.zero.energy.button2"))

    local function onButton1()
        local level = UserManager:getInstance().user:getTopLevelId()
        local meta = MetaManager:getInstance():getFreegift(level)
        local function onUpdateFriend(result, evt)
            if not self or self.isDisposed then return end
            if result == "success" then
                local function confirmAskFriend(selectedFriendsID)
                    if #selectedFriendsID > 0 then
                        local todayWants = UserManager:getInstance():getWantIds()
                        local todayWantsCount = #todayWants

                        local function onRequestSuccess()
                            local home = HomeScene:sharedInstance()
                            DcUtil:requestEnergy(#selectedFriendsID,level)
                            if not self or self.isDisposed then return end
                            if not __IOS_FB and home and todayWants and todayWantsCount < 1 then
                                local sprite = home:createFlyToBagAnimation(10013, 1)
                                local size = btn1:getGroupBounds().size
                                local pos = btn1:getPosition()
                                local parent = btn1:getParent()
                                pos = parent:convertToWorldSpace(ccp(pos.x, pos.y))
                                sprite:setPosition(ccp(pos.x + size.width / 2, pos.y - size.height / 2))
                                sprite:playFlyToAnim(false, false)
                            end
                            CommonTip:showTip(Localization:getInstance():getText("energy.panel.ask.energy.success"), "positive")
                        end
                        local function onFail(evt)
                            if not self or self.isDisposed then return end
                            CommonTip:showTip(Localization:getInstance():getText("error.tip."..evt.data), "negative")
                        end
                        FreegiftManager:sharedInstance():requestGift(selectedFriendsID, meta.itemId, onRequestSuccess, onFail)
                    end
                end
                local panel = AskForEnergyPanel:create(confirmAskFriend)
                if panel then panel:popout() end
            else
                local message = ''
                local err_code = tonumber(evt.data)
                if err_code then message = Localization:getInstance():getText("error.tip."..err_code) end
                CommonTip:showTip(message, "negative")
            end
        end
        FreegiftManager:sharedInstance():updateFriendInfos(true, onUpdateFriend)
    end
    btn1:addEventListener(DisplayEvents.kTouchTap, onButton1)
    local function onButton2()
        local position = btn2:getPosition()
        local wPosition = ui:convertToWorldSpace(ccp(position.x, position.y))
        local panel = InviteFriendRewardPanel:create(wPosition)
        if panel then panel:popout() end
    end
    btn2:addEventListener(DisplayEvents.kTouchTap, onButton2)
end

function RequestMessageZeroEnergy:setVisible(visible)
    RequestMessageZeroItem.setVisible(self, visible)
    self.btn1:setEnabled(visible)
    self.btn2:setEnabled(visible)
end

--------------------------------------------------------------------------------
-- RequestMessagePanel ---------------------------------------------------------
--------------------------------------------------------------------------------
RequestMessagePanel = class(LayerGradient)

function RequestMessagePanel:create()
    local winSize = CCDirector:sharedDirector():getWinSize()
    local ret = RequestMessagePanel.new()
    ret:loadRequiredResource(PanelConfigFiles.request_message_panel)
    ret:initLayer()
    ret:init()
    ret:changeWidthAndHeight(winSize.width, winSize.height)
    -- ret:setColor(ccc3(255,255,205)) --#FFFFCD
    ret:setStartColor(ccc3(255, 216, 119))
    ret:setEndColor(ccc3(247, 187, 129))
    ret:setStartOpacity(255)
    ret:setEndOpacity(255)
    ret:buildUI()
    return ret
end

function RequestMessagePanel:init()
    self.pendingRequestCount = 0 

    kDailyMaxReceiveGiftCount = MetaManager:getInstance():getDailyMaxReceiveGiftCount() or 10
    kDailyMaxSendGiftCount = MetaManager:getInstance():getDailyMaxSendGiftCount() or 20
    local newestCfg = Localhost.getInstance():getUpdatedGlobalConfig()
    if newestCfg and newestCfg.dailyMaxSendGiftCount then
        kDailyMaxSendGiftCount = newestCfg.dailyMaxSendGiftCount
    end
    if newestCfg and newestCfg.dailyMaxReceiveGiftCount then
        kDailyMaxReceiveGiftCount = newestCfg.dailyMaxReceiveGiftCount
    end
end

local function createRequestItemContent(requestInfoList, minWidth, minHeight, requestType)
    local list = {}
    local newVersionRequestInfos = {} 
    local hasNewVersionItem = false

    for i=#requestInfoList,1,-1 do
        local v = requestInfoList[i]
        if requestType == v.type then
            if (v.type ~= 1) and (v.type ~= 2) or (BagManager.getInstance():isValideItemId(v.itemId)) then
                table.insert(list,1,v)
            else
                
                table.insert(newVersionRequestInfos,v)

                if not hasNewVersionItem then
                    table.insert(list,1,v)
                end

                hasNewVersionItem = true
            end
        end
    end

    local container = CocosObject:create()
    local itemHeight = 150
    local totalWidth = minWidth
    local totalHeight = itemHeight * #list
    if totalHeight < minHeight then totalHeight = minHeight end
    container:setContentSize(CCSizeMake(totalWidth, totalHeight))
    local tab = {}

    for i,v in ipairs(list) do
        if __IOS_FB and v.type == 5 then

        else
            local item = RequestMessageItemFactory:createItem(v)
            if item then 
                -- item:setPosition(ccp(0, totalHeight - i * itemHeight + itemHeight))
                -- container:addChild(item)
                table.insert(tab, item)
            end

            if item:is(UpdateNewVersionItem) then
                item:setRequestInfos(newVersionRequestInfos)
            end
        end
    end

    return tab
end

local kMaxItemsPerPage = 100

local function getRequestInfoList()
    local requestInfoList = {}
    -- local list = UserManager:getInstance().requestInfos
    local list = FreegiftManager:sharedInstance():getMessages()
    local length = 0
    for i,v in ipairs(list) do
        if v and length < 100 then
            if v.type == 3 or v.type == 5 or v.type == 1 or v.type == 2 then 
                table.insert(requestInfoList, v) 
                length = length + 1
            end
        end
    end
    return requestInfoList
end

function RequestMessagePanel:buildInterfaceGroup(groupName)
    if self.builder then return self.builder:buildGroup(groupName)
    else return nil end
end

function RequestMessagePanel:loadRequiredResource(panelConfigFile)
    self.panelConfigFile = panelConfigFile
    self.builder = InterfaceBuilder:createWithContentsOfFile(panelConfigFile)
end

function RequestMessagePanel:unloadRequiredResource()
    if self.panelConfigFile then
        InterfaceBuilder:unloadAsset(self.panelConfigFile)
    end
end

function RequestMessagePanel:dispose()
    LayerColor.dispose(self)
    if type(self.unloadRequiredResource) == "function" then self:unloadRequiredResource() end
end

local tabTable = {
    {tabId = 0, pageIndex = 1, key = Localization:getInstance():getText("request.message.panel.tab.friend"), msgType = {RequestType.kAddFriend}},
    {tabId = 1, pageIndex = 2, key = Localization:getInstance():getText("request.message.panel.tab.receive"), msgType = {RequestType.kSendFreeGift, RequestType.kReceiveFreeGift}},
    {tabId = 2, pageIndex = 3, key = Localization:getInstance():getText("request.message.panel.tab.unlock"), msgType = {RequestType.kUnlockLevelArea}},
    {tabId = 3, pageIndex = 4, key = Localization:getInstance():getText("request.message.panel.tab.version"), msgType = {RequestType.kNeedUpdate}},
}

local pageTable = {
    {msgType = {RequestType.kAddFriend}, tabId = 0, pageIndex = 1,
        acceptAll = function() return false end, rejectAll = function() return true end,
        class = function() return FriendRequestItem end, zero = function() return RequestMessageZeroFriend end},
    {msgType = {RequestType.kSendFreeGift, RequestType.kReceiveFreeGift}, tabId = 1, pageIndex = 2,
        acceptAll = function() return true end, rejectAll = function() return true end,
        class = function() return EnergyRequestItem end, zero = function() return RequestMessageZeroEnergy end},
    {msgType = {RequestType.kUnlockLevelArea}, tabId = 2, pageIndex = 3,
        acceptAll = function() return true end, rejectAll = function() return true end,
        class = function() return UnlockCloudRequestItem end, zero = function() return RequestMessageZeroUnlock end},
    {msgType = {RequestType.kNeedUpdate}, tabId = 3, pageIndex = 4,
        acceptAll = function() return true end, rejectAll = function() return true end,
        class = function() return UpdateNewVersionItem end, zero = function() return RequestMessageZeroUpdate end},
}

function RequestMessagePanel:buildUI()
    local ui = self:buildInterfaceGroup("request_panel")
    ui:getChildByName("item"):removeFromParentAndCleanup(true)

    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local origin = CCDirector:sharedDirector():getVisibleOrigin()
    self:setPosition(ccp(origin.x, origin.y))

    local topHeight = 170
    local top = ui:getChildByName("top")
    top:setPositionY(winSize.height)
    local title = top:getChildByName("title")
    title:setText(Localization:getInstance():getText("message.center.tittle"))
    local titleSize = title:getContentSize()
    local titleScale = 65 / titleSize.height
    title:setScale(titleScale)
    title:setPositionX((winSize.width - titleSize.width * titleScale) / 2)
    self.closeBtn = top:getChildByName("close")
    local paramObj = {send = kDailyMaxSendGiftCount, receive = kDailyMaxReceiveGiftCount}
    local bottom = ui:getChildByName("bottom")
    local bottomHeight = 130
    bottom:setPositionY(bottomHeight)
    local acceptAllButton = GroupButtonBase:create(bottom:getChildByName("confirm")) 
    acceptAllButton:setString(Localization:getInstance():getText("message.center.agree.all.btn"))
    acceptAllButton:setColorMode(kGroupButtonColorMode.blue)
    self.acceptAllButton = acceptAllButton
    local rejectAllButton = GroupButtonBase:create(bottom:getChildByName("cancel"))
    rejectAllButton:setString(Localization:getInstance():getText("message.center.disagree.all.btn"))
    rejectAllButton:setColorMode(kGroupButtonColorMode.orange)
    self.rejectAllButton = rejectAllButton
    local addBg = ui:getChildByName("viewRect")
    local size = addBg:getPreferredSize()
    addBg:setPreferredSize(CCSizeMake(size.width, winSize.height - bottomHeight - topHeight + 20))
    addBg:setPositionY(addBg:getPositionY() + winSize.height)

    self:addChild(ui)
    
    local requestInfoList = getRequestInfoList()
    local listHeight = winSize.height - bottomHeight - topHeight
    local iptTable = {}
    for k, v in pairs(tabTable) do iptTable[k] = v end
    if FreegiftManager:sharedInstance():getMessageNumByType(tabTable[4].msgType) <= 0 then
        table.remove(iptTable, 4)
    end
    for k, v in ipairs(iptTable) do
        v.number = FreegiftManager:sharedInstance():getMessageNumByType(v.msgType)
    end
    local tab = RequestMessagePanelTab:create(iptTable)
    tab:setPositionXY(0, winSize.height - topHeight - 10)
    self:addChild(tab)

    local pagedView = PagedView:create(winSize.width - 36, listHeight - 80, #iptTable, tab, true, false)
    pagedView.pageMargin = 35
    pagedView:setIgnoreVerticalMove(false) -- important!
    tab:setView(pagedView)
    pagedView:setPosition(ccp(16, bottomHeight + 10))
    local function switchCallback() self:switchPage() end
    local function switchFinishCallback() self:switchPageFinish(listHeight - 70) end
    pagedView:setSwithPageCallback(switchCallback)
    pagedView:setSwitchPageFinishCallback(switchFinishCallback)
    self:addChild(pagedView)
    self.pagedView = pagedView

    self:createPages(winSize.width - 36, listHeight - 70)
    self:switchToFirstNonZeroPage()
    self:switchPageFinish(listHeight - 70)

    local function onCloseTapped()
        Director:sharedDirector():popScene()
    end
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:setButtonMode(true)
    self.closeBtn:ad(DisplayEvents.kTouchTap, onCloseTapped)

    local function onTouchCancel( evt )
        rejectAllButton:setEnabled(false)
        self:cancelAll()
    end
    local function onTouchConfirm( evt )
        acceptAllButton:setEnabled(false)
        self:acceptAll()
    end

    rejectAllButton:ad(DisplayEvents.kTouchTap, onTouchCancel)
    acceptAllButton:ad(DisplayEvents.kTouchTap, onTouchConfirm)
    
    return true
end

function RequestMessagePanel:switchToFirstNonZeroPage()
    for k, v in ipairs(self.layers) do
        local list = v:getChildByName("list")
        if list and not list.isDisposed then
            local layout = list:getContent()
            local toDelete = {}
            local content = layout:getItems()
            if type(content) == "table" and #content > 0 then
                self.pagedView:gotoPage(k)
                return
            end
        end
    end
end

function RequestMessagePanel:createPages(width, height)
    local count = 0
    self.layers = {}
    local iptTable = {}
    for k, v in pairs(pageTable) do iptTable[k] = v end
    if FreegiftManager:sharedInstance():getMessageNumByType(pageTable[4].msgType) <= 0 then
        table.remove(iptTable, 4)
    end
    for k, v in ipairs(iptTable) do
        local layer = Layer:create()
        local zero = v.zero():create(width, height)
        zero.name = "zero"
        layer:addChild(zero)
        local list = VerticalScrollable:create(width, height, false)
        list:setIgnoreHorizontalMove(false)
        layer:addChild(list)
        self.pagedView:addPageAt(layer, k)
        self.layers[k] = layer
        local layout = VerticalTileLayout:create(width)
        list.name = "list"
        list:setContent(layout)
        local content = FreegiftManager:sharedInstance():getMessages(v.msgType)
        if #content <= 0 then
            list:setVisible(false)
            zero:setVisible(true)
        else
            zero:setVisible(false)
            list:setVisible(true)
        end
        local elems = {}
        for k2, v2 in ipairs(content) do
            local elem = v.class().new()
            elem:loadRequiredResource(PanelConfigFiles.request_message_panel)
            elem:init()
            elem:setPanelRef(self)
            elem:setParentView(list)
            elem:setData(v2)
            table.insert(elems, elem)
            if v.class() == EnergyRequestItem then
                self.energyItems = self.energyItems or {}
                table.insert(self.energyItems, elem)
            end
        end
        layout:setItemVerticalMargin(10)
        layout:addItemBatch(elems)
        list:updateScrollableHeight()
        layout:__layout()
    end
end

function RequestMessagePanel:switchPage()
    self.rejectAllButton:setVisible(false)
    self.acceptAllButton:setVisible(false)
    local index = self.pagedView:getPageIndex()
    for k, v in ipairs(self.layers) do
        if k ~= index then
            local left = 0
            local content = FreegiftManager:sharedInstance():getMessages(pageTable[k].msgType)
            local list = v:getChildByName("list")
            local zero = v:getChildByName("zero")
            if list and not list.isDisposed then
                local layout = list:getContent()
                local toDelete = {}
                for k2, v2 in ipairs(layout:getItems()) do
                    left = left + 1
                    if v2:hasCompleted() then
                        left = left - 1
                        table.insert(toDelete, v2)
                    end
                end
                for k2, v2 in ipairs(toDelete) do
                    layout:removeItemAt(v2:getArrayIndex())
                    if pageTable[k].class() == EnergyRequestItem then
                        self.energyItems = self.energyItems or {}
                        for k3, v3 in ipairs(self.energyItems) do
                            if v3 == v2 then
                                table.remove(self.energyItems, k3)
                                break
                            end
                        end
                    end
                end
                list:updateScrollableHeight()
            end
            if left <= 0 then
                list:setVisible(false)
                zero:setVisible(true)
            end
        end
    end
end

function RequestMessagePanel:switchPageFinish(height)
    local index = self.pagedView:getPageIndex()
    self:setButtonsVisibleEnable(index)
end

function RequestMessagePanel:setButtonsVisibleEnable(index)
    self.rejectAllButton:setVisible(pageTable[index].rejectAll())
    self.acceptAllButton:setVisible(pageTable[index].acceptAll())
    self.rejectAllButton:setEnabled(true)
    self.acceptAllButton:setEnabled(true)
    local typeUpdate = false
    for k, v in ipairs(pageTable[index].msgType) do
        if v == RequestType.kNeedUpdate then
            typeUpdate = true
            break
        end
    end
    if typeUpdate then self.acceptAllButton:setString(Localization:getInstance():getText("new.version.download.text"))
    else self.acceptAllButton:setString(Localization:getInstance():getText("message.center.agree.all.btn")) end
    local content = FreegiftManager:sharedInstance():getMessages(pageTable[index].msgType)
    if self.layers[index] then
        local list = self.layers[index]:getChildByName("list")
        if list then
            local layout = list:getContent()
            if layout then
                local items = layout:getItems()
                local allProcessing = true
                for k, v in ipairs(items) do
                    if not v.processing then
                        allProcessing = false
                        break
                    end
                end
                if allProcessing then
                    self.rejectAllButton:setEnabled(false)
                    self.acceptAllButton:setEnabled(false)
                    return
                end
            end
        end
    end  
    self.rejectAllButton:setEnabled(self.rejectAllButton:getEnabled() and #content > 0)
    local typeEnergy = false
    for k, v in ipairs(pageTable[index].msgType) do
        if v == RequestType.kSendFreeGift or v == RequestType.kReceiveFreeGift then
            typeEnergy = true
            break
        end
    end
    if typeEnergy then
        local list = self.layers[index]:getChildByName("list")
        if list then
            local layout = list:getContent()
            if layout then
                local items = layout:getItems()
                local allProcessing = true
                for k, v in ipairs(items) do
                    if v.type == RequestType.kSendFreeGift and (FreegiftManager:sharedInstance():canSendMore()) or
                        v.type == RequestType.kReceiveFreeGift and (v.mode == EnergyRequestItemMode.kReceive and
                            FreegiftManager:sharedInstance():canReceiveMore() or v.mode == EnergyRequestItemMode.kSendBack and
                            FreegiftManager:sharedInstance():canSendMore()) then
                        self.acceptAllButton:setEnabled(#content > 0)
                        return
                    end
                end
            end
        end
        self.acceptAllButton:setEnabled(false)
    else self.acceptAllButton:setEnabled(self.acceptAllButton:getEnabled() and #content > 0) end
end

function RequestMessagePanel:setFocusedItem(item)
    self._focusedItem = item
end

function RequestMessagePanel:cancelAll()
    self._focusedItem = nil
    self.batchSend = false
    self.batchReceive = false
    ConnectionManager:block()
    local index = self.pagedView:getPageIndex()
    if self.layers[index] then
        local list = self.layers[index]:getChildByName("list")
        if list then
            local layout = list:getContent()
            if layout then
                local items = layout:getItems()
                for k, v in ipairs(items) do
                    if not v.processing then v:sendIgnore(true) end
                end
            end
        end
    end
    ConnectionManager:flush()
end

function RequestMessagePanel:acceptAll()
    local index = self.pagedView:getPageIndex()
    if pageTable[index].class() == EnergyRequestItem then
        local send, receive, request = {}, {}, {}
        local index = self.pagedView:getPageIndex()
        if self.layers[index] then
            local list = self.layers[index]:getChildByName("list")
            if list then
                local layout = list:getContent()
                if layout then
                    local items = layout:getItems()
                    for k, v in ipairs(items) do
                        if v:isSend() then
                            if not v:hasCompleted() then table.insert(send, v) end
                        elseif v:isReceive() then
                            if not v:hasCompleted() then table.insert(receive, v) end
                        end
                    end
                end
            end
        end
        local canSend, remainSend = FreegiftManager:sharedInstance():canSendMore()
        local canReceive, remainReceive = FreegiftManager:sharedInstance():canReceiveMore()
        if canReceive and #receive > 0 then
            self.batchReceive = true
            for k, v in ipairs(receive) do table.insert(request, v) end
        end
        if canSend then
            local function doYes()
                self.batchSend = true
                for k, v in ipairs(send) do table.insert(request, v) end
                ConnectionManager:block()
                for k, v in ipairs(request) do v:sendAccept(true) end
                ConnectionManager:flush()
            end
            local function doNo()
                if #request > 0 then
                    ConnectionManager:block()
                    for k, v in ipairs(request) do v:sendAccept(true) end
                    ConnectionManager:flush()
                end
                self:setButtonsVisibleEnable(index)
            end
            if #send > 0 and remainSend < #send then
                local tip = {
                    tip = Localization:getInstance():getText("request.message.panel.batch.energy.tip", {total = #send, quota = remainSend}),
                    yes = Localization:getInstance():getText("request.message.panel.batch.energy.yes"),
                    no = Localization:getInstance():getText("request.message.panel.batch.energy.no"),
                }
                CommonTipWithBtn:showTip(tip, "positive", doYes, doNo)
            else doYes() end
        else
            if #request > 0 then
                ConnectionManager:block()
                for k, v in ipairs(request) do v:sendAccept(true) end
                ConnectionManager:flush()
            end
        end
    elseif pageTable[index].class() == UnlockCloudRequestItem then
        ConnectionManager:block()
        local index = self.pagedView:getPageIndex()
        if self.layers[index] then
            local list = self.layers[index]:getChildByName("list")
            if list then
                local layout = list:getContent()
                if layout then
                    local items = layout:getItems()
                    for k, v in ipairs(items) do v:sendAccept(true) end
                end
            end
        end
        ConnectionManager:flush()
    elseif pageTable[index].class() == FriendRequestItem then
        -- do nothing
    elseif pageTable[index].class() == UpdateNewVersionItem then
        if __IOS then
            NewVersionUtil:gotoMarket()
        else
            --
            if NewVersionUtil:hasPackageUpdate() then 
                local panel = UpdatePageagePanel:create(
                    ccp(0,0),
                    Localization:getInstance():getText("new.version.tip.message")
                ) 
                panel:popout()
            end
        end
    end
    self:setButtonsVisibleEnable(index)
end

function RequestMessagePanel:onRequestSent(isBatch)
    self.pendingRequestCount = self.pendingRequestCount + 1
    self.energyItems = self.energyItems or {}
    for k, v in pairs(self.energyItems) do
        v:updateSelf()
    end
end

function RequestMessagePanel:onRequestCompleted(isBatch)
    self.pendingRequestCount = self.pendingRequestCount - 1
    if isBatch and self.pendingRequestCount <= 0
    or (not isBatch) then
        self.energyItems = self.energyItems or {}
        for k, v in pairs(self.energyItems) do
            if v == self._focusedItem then
                v:gainFocus()
            else
                v:looseFocus()
            end
            v:updateSelf()
        end
    end
    if isBatch and self.pendingRequestCount <= 0 then
        self:onBatchRequestCompleted()
    end

end

local _MILISEC_DAY = 24*3600*1000
local function _getDay()
	return math.ceil(Localhost:time() / _MILISEC_DAY)
end
local _today = _getDay()

local _tipShown1 = false
local _tipShown2 = false
local _tipShown3 = false
function RequestMessagePanel:onBatchRequestCompleted()
    local index = self.pagedView:getPageIndex()
    self:setButtonsVisibleEnable(index)
    for k, v in ipairs(pageTable) do
        if v.class() == EnergyRequestItem then
            if v.pageIndex ~= index then return end
        end
    end
    local canSendMore, leftSendMore = FreegiftManager:sharedInstance():canSendMore()
    local canReceiveMore, leftReceiveMore = FreegiftManager:sharedInstance():canReceiveMore()
    local txt = nil

    -- reset
    if _getDay() ~= _today then
    	_today = _getDay()
    	_tipShown1 = false
    	_tipShown2 = false
    	_tipShown3 = false
    end

    local paramObj = {send = kDailyMaxSendGiftCount, receive = kDailyMaxReceiveGiftCount} 
    if self.batchReceive and self.batchSend then
        if not _tipShown3 and not canSendMore and not canReceiveMore then
            CommonTip:showTip(Localization:getInstance():getText("message.center.panel.commontip.sentreceivedall", paramObj), 'positive', nil, 3)
            _tipShown3 = true
        end
    elseif self.batchReceive then
        if not _tipShown1 and not canReceiveMore then
            CommonTip:showTip(Localization:getInstance():getText("message.center.panel.commontip.receivedall", paramObj), 'positive', nil, 3)
            _tipShown1 = true
        end
    elseif batchSend then
        if not _tipShown2 and not canSendMore then
            CommonTip:showTip(Localization:getInstance():getText("message.center.panel.commontip.sentall", paramObj), 'positive', nil, 3)
            _tipShown2 = true
        end
    end
    self.batchSend = false
    self.batchReceive = false
end

function RequestMessagePanel:isBusy()
    return self.pendingRequestCount > 0 
end

RequestMessagePanelTab = class(BaseUI)

function RequestMessagePanelTab:create(config)
    local instance = RequestMessagePanelTab.new()
    instance:loadRequiredResource(PanelConfigFiles.request_message_panel)
    instance:init(config)
    return instance
end

function RequestMessagePanelTab:loadRequiredResource(config)
    self.builder = InterfaceBuilder:create(config)
end

function RequestMessagePanelTab:init(config)
    local ui = self.builder:buildGroup('market_tabs')
    BaseUI.init(self, ui)

    self.animDuration = 0.25

    self.config = config
    self.colorConfig = {
        normal = ccc3(157, 116, 75),
        focus = ccc3(243, 93, 99)
    }

    self.curIndex = 1

    self.tabs = {}
    local count = #config

    local function _tapHandler(event)
        local index = tonumber(event.context)
        self:onTabClicked(index)
    end

    for i=1, count do
        local tab = ui:getChildByName('market_tabButton'..i)
        tab.txt = tab:getChildByName('txt')
        tab.ring = tab:getChildByName('ring')
        tab.ring2 = tab:getChildByName('ring2')
        tab.num = tab:getChildByName('num')
        tab.locator = tab:getChildByName('arrowLocator')
        tab.locator:setVisible(false)
        tab.rect = tab:getChildByName('rect')
        tab.rect:setVisible(false)
        local dimension = tab.txt:getDimensions()
        tab.txt:setDimensions(CCSizeMake(0, 0))
        tab.txt:setString(Localization:getInstance():getText(config[i].key))
        local size = tab.txt:getContentSize()
        tab.txt:setPositionX(-size.width / 2)
        if config[i].number then
            if config[i].number > 99 then
                tab.num:setString('99+')
                tab.ring:setVisible(false)
                tab.num:setPositionX(tab.txt:getPositionX() + size.width + 12)
                tab.ring2:setPositionX(tab.txt:getPositionX() + size.width)
            elseif config[i].number > 0 then
                tab.num:setString(config[i].number)
                tab.ring2:setVisible(false)
                local offset = 12
                if config[i].number > 10 then offset = 6 end
                tab.num:setPositionX(tab.txt:getPositionX() + size.width + offset)
                tab.ring:setPositionX(tab.txt:getPositionX() + size.width)
            else
                tab.num:setVisible(false)
                tab.ring:setVisible(false)
                tab.ring2:setVisible(false)
            end
        else
            tab.num:setVisible(false)
            tab.ring:setVisible(false)
            tab.ring2:setVisible(false)
        end
        tab:ad(DisplayEvents.kTouchTap, _tapHandler, config[i].pageIndex)
        tab:setTouchEnabled(true, 0, true)
        tab:setButtonMode(false)
        tab.normalPos = ccp(tab.txt:getPositionX(), tab.txt:getPositionY())
        tab.focusPos = ccp(tab.txt:getPositionX() , tab.txt:getPositionY() + 15)
        table.insert(self.tabs, tab)
    end

    -------------------------------------------
    -- center tabs positions
    --
    local length = ui:getGroupBounds().size.width
    for k, v in pairs(self.tabs) do
        v:setPositionX(length * k / (count + 1))
    end

    for i=count+1, 5 do
        local tab = ui:getChildByName('market_tabButton'..i)
        tab:removeFromParentAndCleanup(true)
        -- tab:setVisible(false)
    end

    self.arrow = ui:getChildByName('market_tabArrow')

    self:goto(1)

end

function RequestMessagePanelTab:setView(view)
    self.view = view
end

function RequestMessagePanelTab:next()
    if self.curIndex == #self.config then return end
    self:goto(self.curIndex + 1)
end

function RequestMessagePanelTab:prev()
    if self.curIndex == 1 then return end
    self:goto(self.curIndex - 1)
end

function RequestMessagePanelTab:goto(index)
    local count = #self.config
    if not index or type(index) ~= 'number' or index > count or index < 1 then
        return 
    end
    local curTab = self.tabs[self.curIndex]
    local nextTab = self.tabs[index]
    if curTab then
        curTab.txt:stopAllActions()
        curTab.txt:runAction(self:_getTabLooseFocusAnim(curTab))
        curTab.num:setVisible(false)
        curTab.ring:setVisible(false)
        curTab.ring2:setVisible(false)
    end
    if nextTab then 
        nextTab.txt:stopAllActions()
        nextTab.txt:runAction(self:_getTabOnFocusAnim(nextTab))
        nextTab.num:setVisible(false)
        nextTab.ring:setVisible(false)
        nextTab.ring2:setVisible(false)
    end
    if self.arrow then
        self.arrow:stopAllActions()
        self.arrow:runAction(self:_getArrowAnim(index))
    end
    self.curIndex = index
end

function RequestMessagePanelTab:onTabClicked(index)
    self:goto(index)
    if self.view then self.view:gotoPage(index) end
end

function RequestMessagePanelTab:_getArrowAnim(index)
    local tab = self.tabs[index]
    if tab then 
        local pos = tab.locator:getPosition()
        local worldPos = tab:convertToWorldSpace(ccp(pos.x, pos.y))
        local realPos = tab:getParent():convertToNodeSpace(ccp(worldPos.x, worldPos.y))
        local move = CCMoveTo:create(self.animDuration, ccp(realPos.x, realPos.y))
        local ease = CCEaseSineOut:create(move)
        return ease
    end
    return nil
end

function RequestMessagePanelTab:_getTabOnFocusAnim(tab)
    if not tab then return nil end
    local tint = CCTintTo:create(self.animDuration, self.colorConfig.focus.r, self.colorConfig.focus.g, self.colorConfig.focus.b)
    local scale = CCScaleTo:create(self.animDuration, 34/28)
    local move = CCMoveTo:create(self.animDuration, tab.focusPos)
    local array = CCArray:create()
    array:addObject(tint)
    array:addObject(scale)
    array:addObject(move)
    local spawn = CCEaseSineOut:create(CCSpawn:create(array))
    return spawn
end

function RequestMessagePanelTab:_getTabLooseFocusAnim(tab)
    if not tab then return nil end
    local tint = CCTintTo:create(self.animDuration, self.colorConfig.normal.r, self.colorConfig.normal.g, self.colorConfig.normal.b)
    local scale = CCScaleTo:create(self.animDuration, 1)
    local move = CCMoveTo:create(self.animDuration, tab.normalPos)
    local array = CCArray:create()
    array:addObject(tint)
    array:addObject(scale)
    array:addObject(move)
    local spawn = CCEaseSineOut:create(CCSpawn:create(array))
    return spawn
end