require "zoo.util.NewVersionUtil"
require "zoo.panel.component.common.LayoutItem"
require "zoo.data.FreegiftManager"

EnergyRequestItemMode = {kAcceptRequest = 1, kReceive = 2, kSendBack = 3}

require 'zoo.panel.messageCenter.RequestMessageItems'
require 'zoo.panel.messageCenter.RequestMessageZeroItem'
require 'zoo.panel.messageCenter.RequestMessagePanelTab'
require 'zoo.panel.messageCenter.RequestMessagePage'

local PanelConfig = require 'zoo.panel.messageCenter.PanelConfig'

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
    self.processableMessageCount = 0 -- 未处理完的消息数量（回赠时，可回赠算未处理完；不可回赠算处理完）
    self.pageMessageCount = {}

    kDailyMaxReceiveGiftCount = MetaManager:getInstance():getDailyMaxReceiveGiftCount() or 10
    kDailyMaxSendGiftCount = MetaManager:getInstance():getDailyMaxSendGiftCount() or 20
    local newestCfg = Localhost.getInstance():getUpdatedGlobalConfig()
    if newestCfg and newestCfg.dailyMaxSendGiftCount then
        kDailyMaxSendGiftCount = newestCfg.dailyMaxSendGiftCount
    end
    if newestCfg and newestCfg.dailyMaxReceiveGiftCount then
        kDailyMaxReceiveGiftCount = newestCfg.dailyMaxReceiveGiftCount
    end

    self.hasRunGuide = CCUserDefault:sharedUserDefault():getBoolForKey('panel.request.message.hasRunGuide')

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

    self.bottomCloseBtn = GroupButtonBase:create(bottom:getChildByName("close"))
    self.bottomCloseBtn:setString('关闭') -- TODO
    self.bottomCloseBtn:setVisible(false)
    self.bottomCloseBtn:setEnabled(false)

    local addBg = ui:getChildByName("viewRect")
    local size = addBg:getPreferredSize()
    addBg:setPreferredSize(CCSizeMake(size.width, winSize.height - bottomHeight - topHeight + 20))
    addBg:setPositionY(addBg:getPositionY() + winSize.height)

    self.requestTip = bottom:getChildByName("requestTip")
    self.requestTip:setString(FreegiftManager:sharedInstance():getHelpRequestTip())
    self.requestTip:setVisible(false)

    self:addChild(ui)

    local tabConfig, pageConfig = PanelConfig:getConfig()
    self.tabConfig = tabConfig
    self.pageConfig = pageConfig
    
    local listHeight = winSize.height - bottomHeight - topHeight

    local tab = RequestMessagePanelTab:create(tabConfig)
    tab:setPositionXY(0, winSize.height - topHeight - 0)
    self:addChild(tab)
    self.tabs = tab

    local pagedView = PagedView:create(winSize.width - 36, listHeight - 80, #pageConfig, tab, true, false)
    pagedView.pageMargin = 35
    pagedView:setIgnoreVerticalMove(false) -- important!
    tab:setView(pagedView)
    pagedView:setPosition(ccp(16, bottomHeight + 10))
    local function switchCallback() self:switchPage() end
    local function switchFinishCallback() self:switchPageFinish(listHeight - 70) end
    pagedView:setSwitchPageCallback(switchCallback)
    pagedView:setSwitchPageFinishCallback(switchFinishCallback)
    self:addChild(pagedView)
    self.pagedView = pagedView

    self:createPages(pageConfig, winSize.width - 36, listHeight - 70)
    if not self:switchToFirstNonZeroPage() then
        self:setButtonsVisibleEnable(1)
    end
    -- self:switchPageFinish(listHeight - 70)

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
    local function onTouchClose( evt )
        onCloseTapped()
    end

    rejectAllButton:ad(DisplayEvents.kTouchTap, onTouchCancel)
    acceptAllButton:ad(DisplayEvents.kTouchTap, onTouchConfirm)
    self.bottomCloseBtn:ad(DisplayEvents.kTouchTap, onTouchClose)

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
                return true
            end
        end
    end
    return false
end

function RequestMessagePanel:gotoUnlockPage()
    local pageIndex = 0
    for k, v in pairs(self.tabConfig) do
        if v.pageName == 'unlock' then
            pageIndex = v.pageIndex
            break
        end
    end
    if pageIndex > 0 then
        self.pagedView:gotoPage(pageIndex)
    end
end

function RequestMessagePanel:createPages(pageConfig, width, height)
    self.layers = {}
    for k, v in ipairs(pageConfig) do
        local content = {
            normalMessages = FreegiftManager:sharedInstance():getMessages(v.msgType),
            pushMessages = FreegiftManager:sharedInstance():getPushMessages(v.msgType),
        }
        local layer = RequestMessagePage:create(self, v, content, width, height)
        if v.pageName == 'energy' then
            self.energyItems = layer:getItems()
        end
        self.pagedView:addPageAt(layer, k)
        self.layers[k] = layer


        -- 统计所有消息数
        self.pageMessageCount[v.pageIndex] = 0
        for k1, v1 in pairs(content.normalMessages) do
            self.processableMessageCount = self.processableMessageCount + 1
            self.pageMessageCount[v.pageIndex] = self.pageMessageCount[v.pageIndex] + 1
        end
        for k, v1 in pairs(content.pushMessages) do
            self.processableMessageCount = self.processableMessageCount + 1
            self.pageMessageCount[v.pageIndex] = self.pageMessageCount[v.pageIndex] + 1
        end

    end
end

function RequestMessagePanel:removeCurrentPage(playAnimation)
    self:removePageAt(self.pagedView:getPageIndex(), playAnimation)
end

function RequestMessagePanel:removePageAt(index, playAnimation)
    if self.layers[index] == nil then return end
    self.pagedview:removePageAt(index, playAnimation)
    table.remove(self.layers, index)
end

function RequestMessagePanel:switchPage()
    self.rejectAllButton:setVisible(false)
    self.acceptAllButton:setVisible(false)
    self.requestTip:setVisible(false)
    local index = self.pagedView:getPageIndex()
    for k, v in ipairs(self.layers) do
        if k ~= index then
            local left = 0
            local content = FreegiftManager:sharedInstance():getMessages(self.pageConfig[k].msgType)
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
                    if v2:is(EnergyRequestItem) then
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
    if self.tabConfig[index].pageName == 'unlock' and not self.hasRunGuide and UserManager:getInstance().user:getTopLevelId() <= 60 then -- 解锁
        local items = self.layers[index]:getChildByName('list'):getContent():getItems()
        if #items > 0 then
            self:tryRunGuide()
        end
    end
    self:setButtonsVisibleEnable(index)
end

function RequestMessagePanel:tryRunGuide()
    if self.hasRunGuide then return end
    local visibleSize   = CCDirector:sharedDirector():getVisibleSize()
    local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
    local panelY =  visibleOrigin.y + visibleSize.height / 2

    local panel = GameGuideUI:panelSU('tutorial.panel.request.message.text001', true, nil)
    panel:setPositionY(panelY)
    local pos = ccp(0, 0)
    local trueMask = GameGuideUI:mask(204, 1, pos, 0, false, nil, nil, false)
    trueMask:removeEventListenerByName(DisplayEvents.kTouchTap)
    trueMask:ad(DisplayEvents.kTouchTap, function () self:tryRemoveGuide() end)
    trueMask:setFadeIn(0.5, 0.3)
    local layer = Layer:create()
    layer:addChild(trueMask)
    layer:addChild(panel)
    self.guideLayer = layer
    local scene = Director:sharedDirector():getRunningScene()
    if scene then
        scene:addChild(layer)
    end
end

function RequestMessagePanel:tryRemoveGuide()
    if self.guideLayer and not self.guideLayer.isDisposed then
        self.guideLayer:removeFromParentAndCleanup(true)
        CCUserDefault:sharedUserDefault():setBoolForKey('panel.request.message.hasRunGuide', true)
        self.hasRunGuide = true
    end
end

function RequestMessagePanel:updateBottomCloseBtn(index)
    if self.isDisposed then return end
    if not index then index = self.pagedView:getPageIndex() end
    if self.processableMessageCount == 0 then
        local curPage = self.layers[index]
        if curPage then
            local zero = curPage.zero
            if zero:showBottomCloseButton() then
                self.bottomCloseBtn:setVisible(true)
                self.bottomCloseBtn:setEnabled(true)
            else
                self.bottomCloseBtn:setVisible(false)
                self.bottomCloseBtn:setEnabled(false)
            end
        end
    end
end

function RequestMessagePanel:setButtonsVisibleEnable(index)
    self:updateBottomCloseBtn(index)
    local content = FreegiftManager:sharedInstance():getMessages(self.pageConfig[index].msgType)
    if #content <= 0 then
        self.acceptAllButton:setVisible(false)
        self.acceptAllButton:setEnabled(false)
        self.rejectAllButton:setVisible(false)
        self.rejectAllButton:setEnabled(false)
        return 
    end
    self.rejectAllButton:setVisible(self.pageConfig[index].rejectAll())
    self.acceptAllButton:setVisible(self.pageConfig[index].acceptAll())
    self.requestTip:setVisible(self.pageConfig[index].showTip)
    self.rejectAllButton:setEnabled(true)
    self.acceptAllButton:setEnabled(true)
    local typeUpdate = false
    for k, v in ipairs(self.pageConfig[index].msgType) do
        if v == RequestType.kNeedUpdate then
            typeUpdate = true
            break
        end
    end
    if typeUpdate then self.acceptAllButton:setString(Localization:getInstance():getText("new.version.download.text"))
    else self.acceptAllButton:setString(Localization:getInstance():getText("message.center.agree.all.btn")) end
    local content = FreegiftManager:sharedInstance():getMessages(self.pageConfig[index].msgType)
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
    for k, v in ipairs(self.pageConfig[index].msgType) do
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
                for k, v in ipairs(items) do
                    if v.type == RequestType.kSendFreeGift and (FreegiftManager:sharedInstance():canSendMore()) or
                        v.type == RequestType.kReceiveFreeGift and (v.mode == EnergyRequestItemMode.kReceive and
                            v:canReceiveMore() or v.mode == EnergyRequestItemMode.kSendBack and
                            v:canSendBackToReceiver()) then
                        self.acceptAllButton:setEnabled(#content > 0)
                        return
                    end
                end
            end
        end
        self.acceptAllButton:setEnabled(false)
        self.acceptAllButton:setVisible(false)
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
                    if not v.processing then 
                        if v:canIgnoreAll() then
                            v:sendIgnore(true) 
                        end
                    end
                end
            end
        end
    end
    self:setButtonsVisibleEnable(index)
    ConnectionManager:flush()
end

function RequestMessagePanel:acceptAll()
    local index = self.pagedView:getPageIndex()
    if self.pageConfig[index].pageName == 'energy' then
        local send, receive, request = {}, {}, {}
        local index = self.pagedView:getPageIndex()
        if self.layers[index] then
            local list = self.layers[index]:getChildByName("list")
            if list then
                local layout = list:getContent()
                if layout then
                    local items = layout:getItems()
                    for k, v in ipairs(items) do
                        if v:canAcceptAll() then
                            if v:isSend() then
                                if not v:hasCompleted() and v:canAcceptAll() then 
                                    table.insert(send, v) 
                                end
                            elseif v:isReceive() then
                                if not v:hasCompleted() and v:canAcceptAll() then 
                                    table.insert(receive, v) 
                                end
                            end
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
                for k, v in ipairs(request) do 
                    if v:canAcceptAll() then
                        v:sendAccept(true) 
                    end
                end
                ConnectionManager:flush()
            end
            local function doNo()
                if #request > 0 then
                    ConnectionManager:block()
                    for k, v in ipairs(request) do 
                        if v:canAcceptAll() then
                            v:sendAccept(true) 
                        end
                    end
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
                for k, v in ipairs(request) do 
                    if v:canAcceptAll() then
                        v:sendAccept(true) 
                    end
                end
                ConnectionManager:flush()
            end
        end
    elseif self.pageConfig[index].pageName == 'unlock' then
        ConnectionManager:block()
        local index = self.pagedView:getPageIndex()
        if self.layers[index] then
            local list = self.layers[index]:getChildByName("list")
            if list then
                local layout = list:getContent()
                if layout then
                    local items = layout:getItems()
                    for k, v in ipairs(items) do 
                        if v:canAcceptAll() then
                            v:sendAccept(true) 
                        end
                    end
                end
            end
        end
        ConnectionManager:flush()
    elseif self.pageConfig[index].pageName == 'addFriend' then
        -- do nothing
    elseif self.pageConfig[index].pageName == 'needUpdate' then
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

function RequestMessagePanel:onMessageLifeFinished(pageIndex)
    self.processableMessageCount = self.processableMessageCount -  1
    if self.pageMessageCount[pageIndex] then
        self.pageMessageCount[pageIndex] = self.pageMessageCount[pageIndex] - 1
        self.tabs:setNumber(pageIndex, self.pageMessageCount[pageIndex])
    end

    print('self.processableMessageCount', self.processableMessageCount)

    if self.processableMessageCount <= 0 then --所有消息都处理完,显示关闭按钮
        self.acceptAllButton:setVisible(false)
        self.acceptAllButton:setEnabled(false)
        self.rejectAllButton:setVisible(false)
        self.rejectAllButton:setEnabled(false)
        self:updateBottomCloseBtn()
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
    for k, v in ipairs(self.pageConfig) do
        if v.pageName == 'energy' then
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
