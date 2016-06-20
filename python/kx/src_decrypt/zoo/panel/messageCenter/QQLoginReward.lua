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

local Panel = class(BasePanel)
function Panel:create(rewards)
    local instance = Panel.new()
    instance:loadRequiredResource(PanelConfigFiles.request_message_panel)
    instance:init(rewards)
    return instance
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
function Panel:init(rewards)
    local ui = self.builder:buildGroup('qq_login_reward_panel')
    BasePanel.init(self, ui)
    self.btn = GroupButtonBase:create(ui:getChildByName('confirm'))
    self.btn:setString('领取')
    self.btn:ad(DisplayEvents.kTouchTap, function () self:onBtnTapped() end)

    local bg = self.ui:getChildByName("bg")
    local title = ui:getChildByName('title')
    title._setText = title.setText
    title._bgWidth= bg:getGroupBounds().size.width
    function title:setText( text )
        self:_setText(text)
        self:setPositionX(self._bgWidth/2 - self:getContentSize().width/2)
    end 
    title:setText(localize('get.login.bonus.title'))
    ui:getChildByName('label'):setString(localize('get.login.bonus.content'))

    self.rewards = rewards
    if rewards and #rewards > 0 then
        local reward = self.rewards[1]
        local icon = buildItemIcon(reward.itemId)
        local res = self.ui:getChildByName('item1')
        local ph = res:getChildByName('item')
        local num = res:getChildByName('num')
        local rect = res:getChildByName('rect')
        local rcSize = rect:getGroupBounds().size
        local rcPositionX = rect:getPositionX()
        local position = num:getPosition()
        rect:setVisible(false)
        ph:setVisible(false)
        icon:setPositionX(ph:getPositionX())
        icon:setPositionY(ph:getPositionY())
        icon:setScale(ph:getContentSize().width*ph:getScaleX() / icon:getGroupBounds().size.width)
        res:addChildAt(icon, ph:getZOrder())
        num:setText('x'..reward.num)
        local size = num:getContentSize()
        num:setPosition(ccp(rcPositionX + rcSize.width - size.width, position.y))
        self.icon = icon
    else
        self.ui:getChildByName('item1'):setVisible(false)
        ui:getChildByName('label'):setString('您已经领取过奖励了~')
        self.btn:setString('确定')
    end
end

function Panel:onBtnTapped()
    self.btn:setEnabled(false)
    if self.rewards and #self.rewards > 0 then
        local function cb()
            self:removeSelf()
        end

        local bounds = self.icon:getGroupBounds()

        HomeScene:sharedInstance():checkDataChange()
        
        local anim = FlyItemsAnimation:create({self.rewards[1]})
        anim:setWorldPosition(ccp(bounds:getMidX(),bounds:getMidY()))
        anim:setScaleX(self.icon:getScaleX())
        anim:setScaleY(self.icon:getScaleY())
        anim:setFinishCallback(cb)
        anim:play()

    else
        self:removeSelf()
    end
end

function Panel:popout()
    self:setPositionForPopoutManager()
    PopoutQueue:sharedInstance():push(self)
    self.allowBackKeyTap = true
end

function Panel:removeSelf()
    PopoutManager:sharedInstance():removeWithBgFadeOut(self, false)
    self.allowBackKeyTap = false
end

local NewGetRewardHttp = class(HttpBase)
function NewGetRewardHttp:load(rewardId)
    if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
    local context = self
    local loadCallback = function(endpoint, data, err)
        if err then
            he_log_info("NewGetRewardHttp error: " .. err)
            context:onLoadingError(err)
        else
            he_log_info("NewGetRewardHttp success !")
            context:onLoadingComplete(data)
        end
    end
    self.transponder:call(kHttpEndPoints.getRewards, {rewardId = rewardId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

QQLoginReward = class()

function QQLoginReward:shouldGetReward()
    return CCUserDefault:sharedUserDefault():getBoolForKey('message.center.qq.login.reward', false) == true
end

function QQLoginReward:setShouldGetReward(value)
    CCUserDefault:sharedUserDefault():setBoolForKey('message.center.qq.login.reward', value)
end

function QQLoginReward:receiveReward()
    local function onSuccess(evt)
        print('QQLoginReward:receiveReward onSuccess')
        if evt.data.rewardItems then
            addReward(evt.data.rewardItems)
            Panel:create(evt.data.rewardItems):popout()    
            local dcId = CCUserDefault:sharedUserDefault():getIntegerForKey('message.center.login.success.source')
            DcUtil:UserTrack({category = 'message', sub_category = 'message_center_get_qq_reward', where = dcId}, true)
        end    
        QQLoginReward:setShouldGetReward(false)
    end
    local function onFail()
        print('QQLoginReward:receiveReward onFail')
    end
    -- if __WIN32 then
    --     onSuccess({data = {rewardItems = {{itemId = 10012, num =1}}}})
    -- else
        local http = NewGetRewardHttp.new()
        http:ad(Events.kComplete, onSuccess)
        http:ad(Events.kError, onFail)
        http:load(5)
    -- end
end