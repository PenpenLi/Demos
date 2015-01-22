CommonRulePanel = class(BasePanel)

function CommonRulePanel:create()
    local instance = CommonRulePanel.new()
    instance:loadRequiredJson(PanelConfigFiles.panel_game_start)
    instance:init()
    return instance
end

function CommonRulePanel:init()
    local ui = self:buildInterfaceGroup('rulePanel')
    BasePanel.init(self, ui)
    self.textBlocks = {}
    for i=1, 23 do 
        local textBlock = ui:getChildByName('textBlock'..i)
        textBlock.txt = textBlock:getChildByName('desc')
        table.insert(self.textBlocks, textBlock)
        textBlock:setVisible(false)
    end
    self.title = ui:getChildByName('title')
    local btn = GroupButtonBase:create(ui:getChildByName('btn'))
    btn:ad(DisplayEvents.kTouchTap, function () self:onCloseBtnTapped() end)
    btn:setString(Localization:getInstance():getText('fruit.tree.panel.rule.button'))
end

function CommonRulePanel:setStrings(stringConfig)
    for k, v in pairs(stringConfig) do 
        local index = v.index
        local text = v.text
        local textBlock = self.textBlocks[index]
        if textBlock then
            textBlock.txt:setString(text)
            textBlock:setVisible(true)
        end
    end
end

function CommonRulePanel:setTitle(title)
    self.title:setString(title)
end

function CommonRulePanel:popout(closeCallback)
    self:setPositionForPopoutManager()
    PopoutManager:sharedInstance():add(self, false, false)
    self.allowBackKeyTap = true
    self.closeCallback = closeCallback
end

function CommonRulePanel:onCloseBtnTapped()
    PopoutManager:sharedInstance():remove(self, true)
    self.allowBackKeyTap = false
    if self.closeCallback then self.closeCallback() end
end