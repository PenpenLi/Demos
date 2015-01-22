require "zoo.panel.weeklyRace.CommonRulePanel"

RabbitRulePanel = class(CommonRulePanel)

function RabbitRulePanel:create()
    local instance = RabbitRulePanel.new()
    instance:loadRequiredJson(PanelConfigFiles.panel_rabbit_weekly_v2)
    instance:init()
    return instance
end

-- override
function RabbitRulePanel:init()
    local ui = self:buildInterfaceGroup('rabbitRulePanel')
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

    self.icons = ui:getChildByName('icons')
    self.icons:setPositionY(self.icons:getPositionY() + 30)
end

function RabbitRulePanel:showIcons(isShow)
    self.icons:setVisible(isShow)
end

function RabbitRulePanel:dispose( ... )
    BaseUI.dispose(self)
end

function RabbitRulePanel:popout(closeCallback)
    PopoutManager:sharedInstance():addChildWithBackground(self, ccc3(0, 0, 0), 255 * 0.7)
    self.allowBackKeyTap = true
    self.closeCallback = closeCallback
end

function RabbitRulePanel:onCloseBtnTapped()
    PopoutManager:sharedInstance():remove(self, true)
    self.allowBackKeyTap = false
    if self.closeCallback then self.closeCallback() end
end
