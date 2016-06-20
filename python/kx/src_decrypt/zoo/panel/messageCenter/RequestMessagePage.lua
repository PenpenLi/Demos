RequestMessagePage = class(Layer)

function RequestMessagePage:create(mainPanel, config, content, width, height)
    local instance = RequestMessagePage.new()
    instance:init(mainPanel, config, content, width, height)
    return instance
end

function RequestMessagePage:init(mainPanel, config, content, width, height)
    Layer.initLayer(self)
    self.pageIndex = config.pageIndex
    local zero = config.zero():create(width, height)
    zero.name = 'zero'
    self:addChild(zero)
    local list = VerticalScrollable:create(width, height, false)
    list.name = "list"
    list:setIgnoreHorizontalMove(false)
    self:addChild(list)
    local layout = VerticalTileLayout:create(width)
    list:setContent(layout)
    local normalMsgs = content.normalMessages
    local pushMsgs = content.pushMessages

    local allMsgNumber = FreegiftManager:sharedInstance():getMessageNumByType(config.msgType)

    if allMsgNumber <= 0 then
        list:setVisible(false)
        zero:setVisible(true)
    else
        zero:setVisible(false)
        list:setVisible(true)
    end
    local elems = {}
    for k2, v2 in pairs(normalMsgs) do
        local elem = config.class(v2).new()
        elem:loadRequiredResource(PanelConfigFiles.request_message_panel)
        elem:init()
        elem:setPanelRef(mainPanel)
        elem:setParentView(list)
        elem:setData(v2)
        elem:setPageIndex(self.pageIndex)
        table.insert(elems, elem)
    end
    layout:setItemVerticalMargin(10)
    layout:addItemBatch(elems)
    list:updateScrollableHeight()
    layout:__layout()

    self.layout = layout
    self.layer = layer
    self.items = elems
    self.zero = zero
    self.scrollable = list
    self.panel = mainPanel

    self.topStickyItems = {}
    table.sort(pushMsgs, function (v1, v2) return v1.type < v2.type end)
    for k, v in pairs(pushMsgs) do
        self:addTopStickyItem(v, false)
    end
end

function RequestMessagePage:getTopStickyItems()
    return self.topStickyItems
end

function RequestMessagePage:getItems()
    return self.items
end

function RequestMessagePage:addTopStickyItem(data, playAnimation)


    if data.type == RequestType.kPushEnergy or data.type == RequestType.kDengchaoEnergy then
        local item
        if data.type == RequestType.kPushEnergy then
            item = PushEnergyItem.new()
        elseif data.type == RequestType.kDengchaoEnergy then
            item = DengchaoEnergyItem.new()
        end
        item:loadRequiredResource(PanelConfigFiles.request_message_panel)
        item:init()
        item:setPanelRef(self.panel)
        item:setParentView(self.scrollable)
        item:setData(data)
        item:setPageIndex(self.pageIndex)
        self.layout:addItemAt(item, 1, playAnimation)
        table.insert(self.topStickyItems, item)
    end
    self.layout:__layout()
    self.scrollable:updateScrollableHeight()
end
