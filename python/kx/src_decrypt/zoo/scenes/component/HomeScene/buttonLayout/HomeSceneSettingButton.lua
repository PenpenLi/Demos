require 'zoo.panel.NewGameSettingPanel'
require 'zoo.panel.AccountPanel'
require 'zoo.common.FAQ'

require 'zoo.scenes.component.HomeScene.buttonLayout.HomeSceneSettingButtonManager'
require 'zoo.scenes.component.HomeScene.iconButtons.FcButton'
require 'zoo.scenes.component.HomeScene.iconButtons.SettingButton'
require 'zoo.scenes.component.HomeScene.iconButtons.ForumButton'
require 'zoo.scenes.component.HomeScene.iconButtons.AccountButton'

require "zoo.PersonalCenter.PersonalCenterManager"


local function getFAQParams()
    return FAQ:getParams()
end

local function getNewFAQurl(params)
    return FAQ:getUrl("http://fansclub.happyelements.com/fans/faq.php",params)
end


HomeSceneSettingButton = class(BaseUI)
local ButtonState = table.const{
    kNoButton = 0,
}

function HomeSceneSettingButton:create(btnBarEvent)
    local bar = HomeSceneSettingButton.new()
    bar.btnBarEvent = btnBarEvent
    bar:init()
    return bar
end

function HomeSceneSettingButton:init()
    self.ui = ResourceManager:sharedInstance():buildGroup("homeSceneSettingBtn")
    BaseUI.init(self, self.ui)

    self.buttonsInfoTable = {}

    self.visibleSize    = CCDirector:sharedDirector():getVisibleSize()
    self.visibleOrigin  = CCDirector:sharedDirector():getVisibleOrigin()

    self.blueBtn = HideAndShowButton:create(self.ui:getChildByName("blueBtn"))
    self.blueBtn:ad(DisplayEvents.kTouchTap, function ()
        self:onBlueBtnTap()
    end)

    HomeSceneSettingButtonManager.getInstance():setBtnGroupBar(self)

    HomeSceneSettingButtonManager.getInstance():setButtonShowPosState(HomeSceneSettingButtonType.kFcBtn, true)
    HomeSceneSettingButtonManager.getInstance():setButtonShowPosState(HomeSceneSettingButtonType.kAccountBtn, true)
    HomeSceneSettingButtonManager.getInstance():setButtonShowPosState(HomeSceneSettingButtonType.kSettingBtn, true)
    HomeSceneSettingButtonManager.getInstance():setButtonShowPosState(HomeSceneSettingButtonType.kForumBtn, self:shouldShowForumBtn())
end

function HomeSceneSettingButton:onBgTap()
    self:hideButtons()
end

function HomeSceneSettingButton:onBlueBtnTap()
    self:hideButtons()
end

local function getBgNameByBtnCount(count)
    local ret = 'buttonBar_bg' .. count
    return ret
end

function HomeSceneSettingButton:initBg(count)
    local bgName = getBgNameByBtnCount(count)
    local bg = ResourceManager:sharedInstance():buildGroup(bgName)
    local x = 86
    local y = -64
    bg:setScaleX(-1)
    bg:setPosition(ccp(x, y))
    self.ui:addChildAt(bg, 0)
    self.bg = bg
    self.animBg = bg

    self.bg:setTouchEnabled(true)
    self.bg:ad(DisplayEvents.kTouchTap, function ()
        self:onBgTap()
    end)

    self.bg.hitTestPoint = function (worldPosition, useGroupTest)
        return true
    end

    local dotTipVisible = false

    if not BindPhoneGuideLogic:hasPersonalGuidePlayed() then
        dotTipVisible = true
    end
    self.ui:getChildByName('blueBtn'):getChildByName('dot'):setVisible(dotTipVisible)
end

function HomeSceneSettingButton:showButtons(endCallback)
    self:initBg(HomeSceneSettingButtonManager:getInstance():getButtonCount())
    --加号按钮动画
    self.bg:setTouchEnabled(false)
    self.blueBtn:setEnable(false)
    self.blueBtn:playAni(function ()
        self.blueBtn:setEnable(true)
        if endCallback then 
            endCallback()
        end
    end)

    --黑背景动画
    local bgWidth, bgHeight = HomeSceneSettingButtonManager.getInstance():getBarBgSize()
    local baseScaleX = -1
    local baseScaleY = 1
    local seqArr = CCArray:create()
    seqArr:addObject(CCScaleTo:create(2/24, 0.9*baseScaleX, 1*baseScaleY))
    seqArr:addObject(CCScaleTo:create(2/24, 1.1*baseScaleX, 1.1*baseScaleY))
    seqArr:addObject(CCScaleTo:create(2/24, 0.95*baseScaleX, 1*baseScaleY))
    seqArr:addObject(CCScaleTo:create(1/24, 1.05*baseScaleX, 1.05*baseScaleY))
    seqArr:addObject(CCScaleTo:create(1/24, 1*baseScaleX, 1*baseScaleY))
    seqArr:addObject(CCCallFunc:create(function ()
        self.bg:setTouchEnabled(true)
        for i,v in ipairs(self.buttonsInfoTable) do
            v.wrapper:setTouchEnabled(true, 0, true)
        end
    end))

    local pos = self:convertToNodeSpace(ccp(100, 100))
    --加防点击穿透层
    local touchLayer = LayerColor:create()
    touchLayer:setColor(ccc3(255,0,0))
    touchLayer:setOpacity(0)
    touchLayer:setContentSize(CCSizeMake(bgWidth, bgHeight))
    touchLayer:setTouchEnabled(true, 0, true)
    self.animBg:addChild(touchLayer)
    self.animBg:runAction(CCSequence:create(seqArr))

    local buttonTypeTable = HomeSceneSettingButtonManager.getInstance():getBtnTypeInfoTable()
    for row,rowConfig in pairs(buttonTypeTable) do
        for col,btnConfig in ipairs(rowConfig) do
            local buttonNode = {}
            buttonNode.btn = self:createButton(btnConfig.btnType)
            if row == 1 then 
                buttonNode.row = col + 1 
            else
                buttonNode.row = col
            end
            if buttonNode.btn ~= ButtonState.kNoButton then 
                buttonNode.wrapper = buttonNode.btn.wrapper
                buttonNode.wrapper:setTouchEnabled(false)
                self:addChild(buttonNode.btn)
                buttonNode.btn:setPosition(ccp(btnConfig.posX, btnConfig.posY))
                buttonNode.btn:setScale(0)
                table.insert(self.buttonsInfoTable, buttonNode)
            end
        end
    end

    for i,v in ipairs(self.buttonsInfoTable) do
        local seqArr1 = CCArray:create()
        seqArr1:addObject(CCDelayTime:create(v.row * 0.05 - 0.05))
        seqArr1:addObject(CCScaleTo:create(3/24, 0.9))
        seqArr1:addObject(CCScaleTo:create(2/24, 1.1))
        seqArr1:addObject(CCScaleTo:create(2/24, 0.95))
        seqArr1:addObject(CCScaleTo:create(1/24, 1.05))
        seqArr1:addObject(CCScaleTo:create(1/24, 1))
        v.btn:runAction(CCSequence:create(seqArr1))
    end
    if self.accountBtn then
        BindPhoneGuideLogic:get():onOpenSettingBtn(self.accountBtn)
    end
end

function HomeSceneSettingButton:hideButtons()
    self.bg:setTouchEnabled(false)
    self.blueBtn:setEnable(false)

    local seqArr = CCArray:create()
    seqArr:addObject(CCScaleTo:create(1/24, -1.05, 1.05))
    seqArr:addObject(CCScaleTo:create(2/24, -0.4, 0.4))
    seqArr:addObject(CCHide:create())
    self.animBg:runAction(CCSequence:create(seqArr))

    local buttonTypeTable = HomeSceneSettingButtonManager.getInstance():getBtnTypeInfoTable()
    local onelineBtnNum = #buttonTypeTable[2]
    for i,v in ipairs(self.buttonsInfoTable) do
        v.wrapper:setTouchEnabled(false)
        local seqArr1 = CCArray:create()
        local time = onelineBtnNum * 0.1 - v.row * 0.1
        seqArr1:addObject(CCDelayTime:create(time))
        seqArr1:addObject(CCScaleTo:create(2/24, 1.1))
        seqArr1:addObject(CCScaleTo:create(3/24, 0))
        v.btn:stopAllActions()
        v.btn:runAction(CCSequence:create(seqArr1))
    end

    self.blueBtn:playAni(function ()
        self.btnBarEvent:dispatchCloseEvent()
        self:removePopout()
    end)
end

function HomeSceneSettingButton:popout(endCallback, position)
    local scene = Director:sharedDirector():getRunningScene()
    scene:addChild(self)
    self:setPosition(position)
    self:showButtons(endCallback)
end

function HomeSceneSettingButton:removePopout()
    HomeSceneSettingButtonManager.getInstance():setBtnGroupBar(nil)
    self:removeFromParentAndCleanup(true)
end

function HomeSceneSettingButton:createButton(buttonType)
    local button = ButtonState.kNoButton
    if buttonType == HomeSceneSettingButtonType.kNull then 
    elseif buttonType == HomeSceneSettingButtonType.kFcBtn then
        button = FcButton:create()
        button.wrapper:addEventListener(DisplayEvents.kTouchTap, function ()
            if self.isDisposed then return end
            self:onFcBtnTapped()
        end)
        self.fcButton = button
    elseif buttonType == HomeSceneSettingButtonType.kAccountBtn then
        button = AccountButton:create()
        button.wrapper:addEventListener(DisplayEvents.kTouchTap, function ()
            if self.isDisposed then return end
            self:onAccountBtnTapped()
        end)
        self.accountBtn = button
    elseif buttonType == HomeSceneSettingButtonType.kSettingBtn then
        button = SettingButton:create()
        button.wrapper:addEventListener(DisplayEvents.kTouchTap, function ()
            if self.isDisposed then return end
            self:onSettingPanelBtnTapped()
        end)
        self.settingButton = button
    elseif buttonType == HomeSceneSettingButtonType.kForumBtn then
        button = ForumButton:create()
        button.wrapper:addEventListener(DisplayEvents.kTouchTap, function ()
            if self.isDisposed then return end
            self:onForumBtnTapped()
        end)
        self.forumButton = button
    else
        button = ForumButton:create()
    end

    return button
end

function HomeSceneSettingButton:onFcBtnTapped()
    DcUtil:iconClick("click_service_icon")
    self:hideButtons()

    if PrepackageUtil:isPreNoNetWork() then
        PrepackageUtil:showInGameDialog()
    else
        if __IOS and kUserLogin then 
            local params = getFAQParams()
            GspEnvironment:getCustomerSupportAgent():setExtraParams(params) 
            GspEnvironment:getCustomerSupportAgent():setFAQurl(getNewFAQurl(params)) 
            GspEnvironment:getCustomerSupportAgent():ShowJiraMain() 
        elseif __ANDROID then
            if kUserLogin then
                local onButton1Click = function()
                    local params = getFAQParams()
                    GspProxy:setExtraParams(params)
                    GspProxy:setFAQurl(getNewFAQurl(params))
                    GspProxy:showCustomerDiaLog()
                end
                CommonAlertUtil:showPrePkgAlertPanel(onButton1Click,NotRemindFlag.PHOTO_ALLOW,Localization:getInstance():getText("pre.tips.photo"));
            else               
                CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips", "negative"))
            end
        elseif __WP8 then
            Wp8Utils:ShowMessageBox("QQ群: 114278702(满) 313502987\n联系客服: xiaoxiaole@happyelements.com", "开心消消乐沟通渠道")
        end
    end
end

function HomeSceneSettingButton:onSettingPanelBtnTapped()
    DcUtil:iconClick("click_set_up_icon")
    self:hideButtons()
    NewGameSettingPanel:create(0):popout()
end

function HomeSceneSettingButton:onAccountBtnTapped()
    DcUtil:iconClick("click_user_icon")
    self:hideButtons()
    --PopoutManager:sharedInstance():add(AccountPanel:create(), true, false)
    PersonalCenterManager:showPersonalCenterPanel()
end

function HomeSceneSettingButton:shouldShowForumBtn()
    if __WIN32 then return false end
    if __IOS_QQ or PlatformConfig:isQQPlatform() then
        if _G.sns_token and UserManager.getInstance().profile:isQQBound() then
            return true
        end
    end
    return false
end

function HomeSceneSettingButton:onForumBtnTapped()
    DcUtil:iconClick("click_forum_icon")
    self:hideButtons()

    if __IOS_QQ then
        if GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen then
            SimpleAudioEngine:sharedEngine():pauseBackgroundMusic()
        end
        waxClass{"OnCloseCallback",NSObject,protocols={"WaxCallbackDelegate"}}
        function OnCloseCallback:onResult(ret) 
            if GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen then
                SimpleAudioEngine:sharedEngine():resumeBackgroundMusic()
            end
        end
        OpenUrlHandleManager:openUrlWithWebview_onClose("http://wsq.qq.com/reflow/159718216", OnCloseCallback:init())
    elseif PlatformConfig:isQQPlatform() then
        local function startAppBar(sub)
            ShareManager:openAppBar( sub )
        end
        pcall(startAppBar)
    end
end

