WdjInviteRewardPanel = class(BasePanel)

function WdjInviteRewardPanel:create()
    local instance = WdjInviteRewardPanel.new()
    instance:loadRequiredResource(PanelConfigFiles.wdj_invite_reward_panel)
    instance:init()
    return instance
end

function WdjInviteRewardPanel:loadRequiredResource( panelConfigFile )
    self.panelConfigFile = panelConfigFile
    self.builder = InterfaceBuilder:create(panelConfigFile)
end

function WdjInviteRewardPanel:init()
    -- body
    local ui = self:buildInterfaceGroup('wdjInviteRewardPanel')
    BasePanel.init(self, ui)
    self.btn = GroupButtonBase:create(ui:getChildByName('OkBtn'))
    self.desLabel = ui:getChildByName("desLabel")

    self.items = {}
    self.items[1] = ui:getChildByName("reward1")
    self.items[2] = ui:getChildByName("reward2")

    self.meta = MetaManager:getInstance():getEnterInviteCodeReward()
    print(table.tostring(self.meta))
    if #self.meta < 2 then
        self.meta = {
            {itemId = 10013, num = 2},
            {itemId = 2, num = 5000},
        }
    end
    -- todo    
    self.desLabel:setString(Localization:getInstance():getText("enter.invite.code.panel.des.wdj"))
    self.btn:setString(Localization:getInstance():getText("enter.invite.code.panel.receive.reward.btn"))
    self.btn:setColorMode(kGroupButtonColorMode.green)

    self.icons = {}
    for i = 1, 2 do
        local sprite
        if self.meta[i].itemId == 2 then
            sprite = Sprite:createWithSpriteFrameName("iconHeap_4uy30000")
            sprite:setAnchorPoint(ccp(0, 1))
        else
            sprite = ResourceManager:sharedInstance():buildItemGroup(self.meta[i].itemId)
        end
        local icon = self.items[i]:getChildByName("icon")
        local num = self.items[i]:getChildByName("num")

        local numFS = self.items[i]:getChildByName("num_fontSize")
        local label = TextField:createWithUIAdjustment(numFS, num)
        self.items[i]:addChild(label)
        self.items[i].label = label
        local pos = icon:getPosition()
        local size = sprite:getGroupBounds().size
        sprite:setScale(1.2)
        sprite:setPosition(ccp(pos.x - size.width / 2, pos.y + size.height / 2))
        sprite.name = "icon"
        icon:getParent():addChildAt(sprite, 1)
        icon:removeFromParentAndCleanup(true)
        table.insert(self.icons, sprite)
        label:setString("x"..self.meta[i].num)
    end

    self.btn:ad(DisplayEvents.kTouchTap, function() self:onBtnTapped() end)

end

function WdjInviteRewardPanel:onBtnTapped()
    self:onSucess()
end

function WdjInviteRewardPanel:onSucess()
    local manager = UserManager:getInstance()
    local user = manager.user
    local home = HomeScene:sharedInstance()

    local function addCoin(num)
        local money = user:getCoin()
        money = money + num
        user:setCoin(money)
    end
    for i = 1, 2 do
        if self.meta[i].itemId == 2 then addCoin(self.meta[i].num)
        else
            manager:addUserPropNumber(self.meta[i].itemId, self.meta[i].num)
        end
    end

    local function decreaseToZero(label, total, duration)
        local interval = 1/60
        local times = duration / interval
        local diff = total / times
        local last = total 
        local schedId = nil
        local function __perFrame()
            local new = last - diff
            if new > 0 then 
                local ceilNew = math.ceil(new)
                if ceilNew ~= math.ceil(last) then
                    if not label.isDisposed then
                        label:setString('x'..ceilNew)
                    end
                end
                last = new
            else 
                if not label.isDisposed then
                    label:setString('x0')
                end
                if not schedId then
                    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(schedId)
                end
            end
        end
        schedId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(__perFrame,interval,false)
    end

    home:checkDataChange()
    for i = 1, 2 do
        local sprite
        local callback = nil
        if self.meta[i].itemId == 2 then 
            sprite = home:createFlyingCoinAnim()
        else 
            -- sprite = home:createFloatingItemAnim(self.meta[i].itemId) 
            sprite = home:createFlyToBagAnimation(self.meta[i].itemId, self.meta[i].num)
            callback = function ()
                -- print('thisdebug callback')
                self:onCloseBtnTapped()
            end
        end

        local position = self.items[i]:getChildByName("icon"):getPosition()
        position = self.items[i]:convertToWorldSpace(ccp(position.x, position.y))
        sprite:setPosition(ccp(position.x, position.y))
        home:addChild(sprite)

        --- decreasing number animation
        local label = self.items[i].label
        local num = self.meta[i].num
        local duration = 0.4
        decreaseToZero(label, num, duration)



        sprite:playFlyToAnim(callback, false)
    end
    for __, v in ipairs(self.icons) do
        v:removeFromParentAndCleanup(true)
    end
end

function WdjInviteRewardPanel:popout(callback)
    -- print('thisdebug WdjInviteRewardPanel:popout')

    local function onAnimOver()
        self.allowBackKeyTap = true
    end
    PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, onAnimOver)
    -- HomeScene:sharedInstance():addChild(self)
    self:setToScreenCenterHorizontal()
    self:setToScreenCenterVertical()
    self.callback = callback
end

function WdjInviteRewardPanel:onCloseBtnTapped()
    if self.isDisposed then return end
    self.allowBackKeyTap = false
    if self.callback and type(self.callback) == 'function' then
        self.callback()
    end
    PopoutManager:sharedInstance():remove(self, true)
end