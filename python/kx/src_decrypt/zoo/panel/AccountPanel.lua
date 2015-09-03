require "zoo.util.IllegalWordFilterUtil"
require "zoo.panel.CDKeyPanel"
require "zoo.config.PlatformConfig"
require "zoo.panel.QRCodePanel"
require "zoo.net.QzoneSyncLogic"
require "zoo.panel.RequireNetworkAlert"

local ChangePhonePromptPanel = class(BasePanel)
local UnbindAccountPromptPanel = class(BasePanel)

AccountPanel = class(BasePanel)
function AccountPanel:initAvatar( group )
    if not group then return nil end
    local avatarPlaceholder = group:getChildByName("avatarPlaceholder")
    local frameworkChosen = group:getChildByName("frameworkChosen")
    if frameworkChosen then frameworkChosen:setVisible(false) end

    local hitArea = CocosObject:create()
    hitArea.name = kHitAreaObjectName
    hitArea:setContentSize(CCSizeMake(100,100))
    hitArea:setPosition(ccp(-50,-50))
    group:addChild(hitArea)

    group.chooseIcon = frameworkChosen
    group.select = function ( self, val )
        self.selected = val
        if self.chooseIcon then self.chooseIcon:setVisible(val) end
    end
    group.changeImage = function( self, userId, headUrl )
        local oldImageIndex = nil
        if self.headImage then 
            oldImageIndex = self.headImage.headImageUrl 
            self.headImage:removeFromParentAndCleanup(true) 
        end

        local framePos = avatarPlaceholder:getPosition()
        local frameSize = avatarPlaceholder:getContentSize()
        local function onImageLoadFinishCallback(clipping)
            if self.isDisposed then return end
            local clippingSize = clipping:getContentSize()
            local scale = frameSize.width/clippingSize.width
            clipping:setScale(scale*0.83)
            clipping:setPosition(ccp(frameSize.width/2-2,frameSize.height/2))
            avatarPlaceholder:addChild(clipping)
            self.headImage = clipping   
        end
        HeadImageLoader:create(userId, headUrl, onImageLoadFinishCallback)

        return oldImageIndex
    end
    group.getProfileURL = function( self )
        if self.headImage then return self.headImage.headImageUrl end
        return nil
    end
    return group
end
function AccountPanel:initMoreAvatars( group )
    local kDefaultUserIndex = 10
    local profile = UserManager.getInstance().profile
    local kMaxHeadImages = UserManager.getInstance().kMaxHeadImages
    local moreAvatarList = {}
    local function getAvatarByHeadImage(headUrl)
        for i=0 , 10 do
            local v = moreAvatarList[i]
            if v:getProfileURL() == headUrl then return v end
        end
        return nil
    end
    local function changeDefaultAvatarImage()
        local oldHeadAvatar = getAvatarByHeadImage(profile.headUrl)
        local oldImageIndex = moreAvatarList[kDefaultUserIndex]:changeImage(profile.uid, profile.headUrl)
        if self.playerAvatar then self.playerAvatar:changeImage(profile.ui, profile.headUrl) end
        if oldHeadAvatar then oldHeadAvatar:changeImage("exp."..tostring(oldImageIndex), oldImageIndex) end
    end
    local function onAvatarItemTouch( evt )
        for i=0 , 10 do
            local v = moreAvatarList[i]
            if v:hitTestPoint(evt.globalPosition, true) then
                self:onAvatarTouch() 
                local headUrl = v:getProfileURL()
                if profile.headUrl ~= headUrl then
                    profile.headUrl = headUrl
                    AccountPanel:updateUserProfile()
                    changeDefaultAvatarImage()
                end
            end
        end
    end
    for i=0 , 10 do
        local avatar = self:initAvatar(group:getChildByName("p"..(i+1)))
        if avatar then
            avatar.index = i
            moreAvatarList[i] = avatar
            avatar:changeImage("exp."..i, i)
        end
    end
    changeDefaultAvatarImage()
    moreAvatarList[kDefaultUserIndex]:select(true)  
    self.moreAvatarList = moreAvatarList
    group:setTouchEnabled(true, -1, true)
    group:ad(DisplayEvents.kTouchTap, onAvatarItemTouch)
end
function AccountPanel:initInput(onBeginCallback)
    local user = UserManager.getInstance().user
    local profile = UserManager.getInstance().profile   
    local inputSelect = self.nameLabel:getChildByName("inputBegin")
    local inputSize = inputSelect:getContentSize()
    local inputPos = inputSelect:getPosition()
    inputSelect:setVisible(true)
    inputSelect:removeFromParentAndCleanup(false)

    local function onTextBegin()
        if onBeginCallback then onBeginCallback() end
    end
    
    local function onTextEnd()
        if self.input then
            local profile = UserManager.getInstance().profile
            local text = self.input:getText() or ""
            if text ~= "" then
                -- 敏感词过滤
                if IllegalWordFilterUtil.getInstance():isIllegalWord(text) then
                    local oldName = HeDisplayUtil:urlDecode(profile.name or "")
                    self.input:setText(oldName)
                    CommonTip:showTip(Localization:getInstance():getText("error.tip.illegal.word"), "negative")
                else
                    if profile.name ~= text then
                        profile:setDisplayName(text)
                        AccountPanel:updateUserProfile()
                    end
                end
            else
                CommonTip:showTip(Localization:getInstance():getText("game.setting.panel.username.empty"), "negative")
            end
        end
    end

    local position = ccp(inputPos.x + inputSize.width/2, inputPos.y - inputSize.height/2)
    local input = TextInputIm:create(inputSize, Scale9Sprite:createWithSpriteFrameName("ui_empty0000"), inputSelect.refCocosObj)
    input.originalX_ = position.x
    input.originalY_ = position.y
    input:setText(profile:getDisplayName())
    input:setPosition(position)
    input:setFontColor(ccc3(0,0,0))
    input:setMaxLength(15)
    input:ad(kTextInputEvents.kBegan, onTextBegin)
    input:ad(kTextInputEvents.kEnded, onTextEnd)
    self.nameLabel:addChild(input)
    self.input = input
    inputSelect:dispose()
end
local function startAppBar(sub)
    ShareManager:openAppBar( sub )
end

function AccountPanel:isNicknameUnmodifiable()
    if not _G.sns_token then
        return false
    end

    if __IOS then
        local authType = SnsProxy:getAuthorizeType()
        return authType == PlatformAuthEnum.kQQ
    elseif __ANDROID then
        local authType = SnsProxy:getAuthorizeType()
        return authType == PlatformAuthEnum.kQQ
            or authType == PlatformAuthEnum.kWeibo
            or authType == PlatformAuthEnum.kMI
            or authType == PlatformAuthEnum.kWDJ
            or authType == PlatformAuthEnum.k360
    end

    return false
end

function AccountPanel:isAvatarUnmodifiable()
    if not _G.sns_token then
        return false
    end

    if __IOS then
        local authType = SnsProxy:getAuthorizeType()
        return authType == PlatformAuthEnum.kQQ
    elseif __ANDROID then
        local authType = SnsProxy:getAuthorizeType()
        return authType == PlatformAuthEnum.kQQ
            or authType == PlatformAuthEnum.kWeibo
            or authType == PlatformAuthEnum.kMI
    end

    return false
end

function AccountPanel:init()
    self.ui = self:buildInterfaceGroup("accountPanel") --ResourceManager:sharedInstance():buildGroup("AccountPanel")
    
    BasePanel.init(self, self.ui)
    local user = UserManager.getInstance().user
    local profile = UserManager.getInstance().profile

    -- 是否允许修改头像和昵称
    self.headImageModifiable = true
    self.nickNameModifiable = true
    
    if (__ANDROID or __IOS) then
        if self:isNicknameUnmodifiable() then
            self.nickNameModifiable = false
        end
        if self:isAvatarUnmodifiable() then
            self.headImageModifiable = false
        end
    end

    if not kUserLogin then
        self.headImageModifiable = false
        self.nickNameModifiable = false
    end

    self.panelTitle     = self.ui:getChildByName("panelTitle")
    self.closeBtn       = self.ui:getChildByName("closeBtn")
    self.nameLabel      = self.ui:getChildByName("touch")
    self.moreAvatars    = self.ui:getChildByName("moreAvatars")
    self.avatar         = self.ui:getChildByName("avatar")
    self.bg = self.ui:getChildByName("_newBg")
    self.innerBg = self.ui:getChildByName('_newBg2')

    self.cdkeyBg = self.ui:getChildByName("bg2")
    self.cdkeyBtn = self.ui:getChildByName("cdkeyBtn")
    self.cdkeySprite = self.cdkeyBtn
    self.cdkeyBtnText = self.cdkeyBtn:getChildByName('text')

    self.upArrow = self.ui:getChildByName('upArrow')
    self.otherAccountsBtn = self.ui:getChildByName('otherAccountsBtn')
    self.unbindBtn = self.ui:getChildByName('unbindBtn')
    self.animBg = self.ui:getChildByName('animBg')

    self.upArrow:ad(DisplayEvents.kTouchTap, function () 
        self:fold(true) 

        DcUtil:UserTrack({ category='setting', sub_category="setting_click_other", action = 2})
    end)
    self.otherAccountsBtn:ad(DisplayEvents.kTouchTap, function () 
        self:extend(true) 

        DcUtil:UserTrack({ category='setting', sub_category="setting_click_other", action = 1})
    end)
    self.unbindBtn:ad(DisplayEvents.kTouchTap, function () self:onUnbindAccountBtnTapped() end)

    if self:shouldShowUnbindBtn() then
        self.unbindBtn:setTouchEnabled(true)
    else
        self.unbindBtn:setVisible(false)
    end


    self.codeBtn = self.ui:getChildByName('codeBtn')
    self.codeBtn:getChildByName('txt'):setString(Localization:getInstance():getText('setting.panel.button.1')..'>')
    self.codeBtn:setTouchEnabled(true)
    self.codeBtn:ad(DisplayEvents.kTouchTap, function() self:onCodeBtnTapped() end)

    self.moreAvatars:setVisible(false)

    self.playerAvatar = self:initAvatar(self.avatar:getChildByName("settingavatarframework"))
    self.playerAvatar:changeImage(profile.ui, profile.headUrl)

    self.panelTitle:setText('我的账号')  -- TEST
    local size = self.panelTitle:getContentSize()
    local scale = 65 / size.height
    self.panelTitle:setScale(scale)
    self.panelTitle:setPositionX((self.bg:getGroupBounds().size.width - size.width * scale) / 2)

    if not self.headImageModifiable then 
        local arrow = self.avatar:getChildByName("avatarArrow") 
        if arrow then arrow:setVisible(false) end
    end

    self.cdkeyBtnText:setString(Localization:getInstance():getText("quit.panel.cdkey"))

    self.nameLabel:getChildByName("touch"):removeFromParentAndCleanup(true) 
    self.nameLabel:getChildByName("label"):setString(profile:getDisplayName())
    self.nameLabel:getChildByName("inputBegin"):setVisible(false)
    self:initMoreAvatars(self.moreAvatars)


    -- 需求：做任何操作都会取消5秒后仅一次的邀请码放大缩小
    local schedule = nil
    local function stopSchedule()
        if schedule then
            Director:sharedDirector():getScheduler():unscheduleScriptEntry(schedule)
            schedule = nil
        end
    end

    --昵称可修改时 TextField隐藏 创建TextInput 否则不创建TextInput
    if self.nickNameModifiable then 
        self.nameLabel:getChildByName("label"):setVisible(false)
        self:initInput(stopSchedule)
    end

    local inviteCode = UserManager.getInstance().inviteCode
    if __IOS_FB then inviteCode = UserManager.getInstance().user.uid end
    if inviteCode and inviteCode ~= "" then
        if __IOS_FB then 
            self.ui:getChildByName("idLabelPrefix"):setString("uid:") 
            self.ui:getChildByName("idLabelNum"):setText(tostring(inviteCode))
        else
            local prefix = self.ui:getChildByName("idLabelPrefix")
            prefix:setString(Localization:getInstance():getText("setting.panel.intro.1"))

            local text = self.ui:getChildByName("idLabelNum")
            local newTxt = LabelBMMonospaceFont:create(36, 36, 19, "fnt/target_amount.fnt")
            newTxt:setAnchorPoint(ccp(0.5, 0.5))
            newTxt:setString(tostring(inviteCode))
            newTxt.name = "idLabelNum"

            prefix:setDimensions(CCSizeMake(0,0))
            newTxt:setPositionX(text:getPositionX() + newTxt:getContentSize().width/2)
            newTxt:setPositionY(prefix:boundingBox():getMidY() - 2)

            self.ui:addChildAt(newTxt, self.ui:getChildIndex(text))
            text:removeFromParentAndCleanup(true)

            if PlatformConfig:isAuthConfig(PlatformAuthEnum.kGuest) then
                for k,v in pairs({ prefix,newTxt,self.codeBtn }) do
                    v:setPositionY(v:getPositionY() - 28)
                end
            end
        end
    else
        self.ui:getChildByName("idLabelPrefix"):setVisible(false)
    end


    -------------------
    -- Add Event Listener
    -- ----------------
    if self.headImageModifiable then
        local function onAvatarTouch()
            stopSchedule()
            self:onAvatarTouch()
        end
        self.avatar:setTouchEnabled(true)
        self.avatar:setButtonMode(true)
        self.avatar:addEventListener(DisplayEvents.kTouchTap, onAvatarTouch)
    end


    local function onCloseBtnTapped(event)
        stopSchedule()
        self:onCloseBtnTapped(event)
    end
    self.closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn:setButtonMode(true)
    self.closeBtn:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)
  
    local function onCDKeyButton()
        DcUtil:UserTrack({ category='setting', sub_category="setting_click_exchange_code"})
        stopSchedule()
        local position = self.cdkeyBtn:getPosition()
        local parent = self.cdkeyBtn:getParent()
        local wPos = parent:convertToWorldSpace(ccp(position.x, position.y))
        local panel = CDKeyPanel:create(wPos)
        if panel then
            PopoutManager:sharedInstance():remove(self, true)
            panel:popout()
        end
    end
    if MaintenanceManager:getInstance():isEnabled("CDKeyCode") then
        self.cdkeyBtn:setTouchEnabled(true, 0, true)
        self.cdkeyBtn:addEventListener(DisplayEvents.kTouchTap, onCDKeyButton)
    else
        self.cdkeyBtn:setVisible(false)
    end

    local function onTimeOut()
        stopSchedule()
        if self.isDisposed then return end
        local text = self.ui:getChildByName("idLabelNum")
        if not text or text.isDisposed then return end
        local arr = CCArray:create()
        arr:addObject(CCScaleTo:create(0.1, 1.35))
        arr:addObject(CCScaleTo:create(0.1, 0.85))
        arr:addObject(CCScaleTo:create(0.1, 1.1))
        arr:addObject(CCScaleTo:create(0.1, 1))
        text:runAction(CCSequence:create(arr))
    end
    schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeOut, 5, false)


    self:initOtherAccounts()

    -- self.animMoveY = 130
    self.foldedBgHeight = self.bg:getGroupBounds().size.height
    self.foldedInnerBgHeight = self.innerBg:getGroupBounds().size.height
    self.foldedAnimBgHeight = self.animBg:getGroupBounds().size.height

    self.extendedBgHeight = self.foldedBgHeight + self.animMoveY
    self.extendedInnerBgHeight = self.foldedInnerBgHeight + self.animMoveY
    self.extendedAnimBgHeight = self.foldedAnimBgHeight + self.animMoveY

    -- test
    self.animBgFoldedSize = self.animBg:getContentSize()
    self.animBgExtendedSize = CCSizeMake(self.animBgFoldedSize.width, self.animBgFoldedSize.height + self.animMoveY)
    -- end test

    self.extendedClippingY = self.clipping:getPositionY()
    self.foldedClippingY = self.extendedClippingY + self.animMoveY
    self.extendedLayoutY = self.layout:getPositionY() 
    self.foldedLayoutY = self.extendedLayoutY - self.animMoveY

    self.foldedCdkeyBtnY = self.cdkeyBtn:getPositionY()
    self.extendedCdkeyBtnY = self.foldedCdkeyBtnY - self.animMoveY

    self.foldedUnbindBtnY = self.unbindBtn:getPositionY()
    self.extendedUnbindBtnY = self.foldedUnbindBtnY - self.animMoveY
    self.animDuration = 0.3

    self:fold()

    if not self.otherAccountsBtnEnabled then
        self.otherAccountsBtn:setVisible(false)
        self.otherAccountsBtn:setTouchEnabled(false)
    end


    
end

function AccountPanel:popout()
    PopoutManager:sharedInstance():add(self, true, false)
end

function AccountPanel:onAvatarTouch()
    if self.moreAvatars:isVisible() then 
        self.moreAvatars:setVisible(false)
        if self.input then self.input:setPosition(ccp(self.input.originalX_, self.input.originalY_)) end
    else 
        self.moreAvatars:setVisible(true)  
        if self.input then self.input:setPosition(ccp(9999,9999)) end
    end
end

if __ANDROID then
require "hecore.gsp.GspProxy"
end

function AccountPanel:onCloseBtnTapped(event, ...)
    BindPhoneGuideLogic:get():removeGuide()
    self.allowBackKeyTap = false
    PopoutManager:sharedInstance():remove(self, true)
end

function AccountPanel:onEnterAnimationFinished()
    if self.nickNameModifiable then
        if self.nameLabel and not self.nameLabel.isDisposed then
            local label = self.nameLabel:getChildByName("label")
            if label and not label.isDisposed then
                label:removeFromParentAndCleanup(true)
            end
        end
    end
    if self.input then self.input:setPosition(ccp(self.input.originalX_, self.input.originalY_)) end
    if self.bindPhoneBtn then
        BindPhoneGuideLogic:get():onShowAccountPanel(self.bindPhoneBtn)
    end
end
function AccountPanel:onEnterHandler(event, ...)
    if event == "enter" then
        self.allowBackKeyTap = true
        self:runAction(self:createShowAnim())
    end
end

function AccountPanel:createShowAnim()
    local centerPosX    = self:getHCenterInParentX()
    local centerPosY    = self:getVCenterInParentY()

    local function initActionFunc()
        local initPosX  = centerPosX
        local initPosY  = centerPosY + 100
        self:setPosition(ccp(initPosX, initPosY))
    end
    local initAction = CCCallFunc:create(initActionFunc)
    local moveToCenter      = CCMoveTo:create(0.5, ccp(centerPosX, centerPosY))
    local backOut           = CCEaseQuarticBackOut:create(moveToCenter, 33, -106, 126, -67, 15)
    local targetedMoveToCenter  = CCTargetedAction:create(self.refCocosObj, backOut)

    local function onEnterAnimationFinished( )self:onEnterAnimationFinished() end
    local actionArray = CCArray:create()
    actionArray:addObject(initAction)
    actionArray:addObject(targetedMoveToCenter)
    actionArray:addObject(CCCallFunc:create(onEnterAnimationFinished))
    return CCSequence:create(actionArray)
end

function AccountPanel:playShowHideLabelAnim(labelToControl, ...)

    local delayTime = 3

    labelToControl:stopAllActions()

    local function showFunc()
        -- Hide All Tip
        for k,v in pairs(self.tips) do
            v:setVisible(false)
        end

        labelToControl:setVisible(true)
    end
    local showAction = CCCallFunc:create(showFunc)


    local delay = CCDelayTime:create(delayTime)


    local function hideFunc()
        labelToControl:setVisible(false)
    end
    local hideAction = CCCallFunc:create(hideFunc)

    local actionArray = CCArray:create()
    actionArray:addObject(showAction)
    actionArray:addObject(delay)
    actionArray:addObject(hideAction)

    local seq = CCSequence:create(actionArray)
    --return seq
    
    labelToControl:runAction(seq)
end

function AccountPanel:updateUserProfile()
    local profile = UserManager.getInstance().profile
    local http = UpdateProfileHttp.new()

    if _G.sns_token then 
        local authorizeType = SnsProxy:getAuthorizeType()
        local snsPlatform = PlatformConfig:getPlatformAuthName(authorizeType)
        local snsName = profile:getSnsUsername(authorizeType)

        profile:setSnsInfo(authorizeType,snsName,profile:getDisplayName(),profile.headUrl)

        http:load(profile.name, profile.headUrl,snsPlatform,HeDisplayUtil:urlEncode(snsName))
    else
        http:load(profile.name, profile.headUrl)
    end
end

function AccountPanel:updateSnsUserProfile( authorizeType,snsName,name,headUrl )
    local profile = UserManager.getInstance().profile
    local http = UpdateProfileHttp.new()

    profile:setSnsInfo(authorizeType,snsName,name,headUrl)

    local snsPlatform = PlatformConfig:getPlatformAuthName(authorizeType)
    snsName = HeDisplayUtil:urlEncode(snsName)
    if name then
        name = HeDisplayUtil:urlEncode(name)
    end

    http:load(name, headUrl,snsPlatform,snsName)
end

function AccountPanel:create()
    local newQuitPanel = AccountPanel.new()
    newQuitPanel:loadRequiredResource(PanelConfigFiles.panel_game_setting)
    newQuitPanel:init()
    return newQuitPanel
end
    
function AccountPanel:extend(playAnim)
    print('extend')
    if self.isExtended then return end
    self.isExtended = true
    local function animFinish()
        if self.isDisposed then return end
        self.upArrow:setVisible(true)
        self.upArrow:setTouchEnabled(true)
        self.upArrow:setPositionY(self.unbindBtn:getPositionY())-- 保证箭头按钮与解绑定按钮对齐
    end

    for k, v in pairs(self.otherAccountItems) do
         --v:setVisible(false)
         local btn = v:getChildByName('btn')
         btn:setTouchEnabled(true)
    end

    if playAnim then
        -- self.animBg:runAction(CCEaseSineIn:create(CCScaleTo:create(self.animDuration, 1, (self.extendedAnimBgHeight/self.foldedAnimBgHeight))))
        self.animBg:runAction(CCEaseSineIn:create(CCSizeTo:create(self.animDuration, self.animBgExtendedSize.width, self.animBgExtendedSize.height)))
        self.innerBg:runAction(CCEaseSineIn:create(CCScaleTo:create(self.animDuration, 1, (self.extendedInnerBgHeight/self.foldedInnerBgHeight))))
        self.bg:runAction(CCEaseSineIn:create(CCScaleTo:create(self.animDuration, 1, (self.extendedBgHeight/self.foldedBgHeight))))
        self.otherAccountsBtn:setVisible(false)
        self.otherAccountsBtn:setTouchEnabled(false)
        self.unbindBtn:runAction(CCEaseSineIn:create(CCMoveTo:create(self.animDuration, ccp(self.unbindBtn:getPositionX(), self.extendedUnbindBtnY))))
        self.cdkeyBtn:runAction(CCEaseSineIn:create(CCMoveTo:create(self.animDuration, ccp(self.cdkeyBtn:getPositionX(), self.extendedCdkeyBtnY))))
        self.clipping:runAction(CCEaseSineIn:create(CCMoveTo:create(self.animDuration, ccp(self.clipping:getPositionX(), self.extendedClippingY))))
        self.layout:runAction(CCEaseSineIn:create(CCMoveTo:create(self.animDuration, ccp(self.layout:getPositionX(), self.extendedLayoutY))))
        setTimeOut(animFinish, self.animDuration)
    else
        self.animBg:setScaleY(self.extendedAnimBgHeight/self.foldedAnimBgHeight)
        self.innerBg:setScaleY(self.extendedInnerBgHeight/self.foldedInnerBgHeight)
        self.bg:setScaleY(self.extendedBgHeight/self.foldedBgHeight)
        self.otherAccountsBtn:setVisible(false)
        self.otherAccountsBtn:setTouchEnabled(false)
        self.unbindBtn:setPositionY(self.extendedUnbindBtnY)
        self.cdkeyBtn:setPositionY(self.extendedCdkeyBtnY)
        self.clipping:setPositionY(self.extendedClippingY)
        self.layout:setPositionY(self.extendedLayoutY)
        self.upArrow:setVisible(true)
        self.upArrow:setTouchEnabled(true)
        self.qqLabelNum:setVisible(false)
        self.qqLabelNum:setVisible(true)
        self.qqLabelPrefix:setVisible(true)
        self.weiboLabelNum:setVisible(true)
        self.weiboLabelPrefix:setVisible(true)
    end
end

function AccountPanel:fold(playAnim)
    print('fold')
    if self.isExtended == false then return end
    self.isExtended = false

     -- for k, v in pairs(self.otherAccountItems) do
     --     --v:setVisible(false)
     --    local btn = v:getChildByName('btn')
     --    btn:setTouchEnabled(false)
     -- end
    if playAnim then
        -- self.animBg:runAction(CCEaseSineIn:create(CCScaleTo:create(self.animDuration, 1, 1)))
        self.animBg:runAction(CCEaseSineIn:create(CCSizeTo:create(self.animDuration, self.animBgFoldedSize.width, self.animBgFoldedSize.height)))
        self.innerBg:runAction(CCEaseSineIn:create(CCScaleTo:create(self.animDuration, 1, 1)))
        self.bg:runAction(CCEaseSineIn:create(CCScaleTo:create(self.animDuration, 1, 1)))
        self.upArrow:setVisible(false)
        self.upArrow:setTouchEnabled(false)
        self.unbindBtn:runAction(CCEaseSineIn:create(CCMoveTo:create(self.animDuration, ccp(self.unbindBtn:getPositionX(), self.foldedUnbindBtnY))))
        self.cdkeyBtn:runAction(CCEaseSineIn:create(CCMoveTo:create(self.animDuration, ccp(self.cdkeyBtn:getPositionX(), self.foldedCdkeyBtnY))))
        self.clipping:runAction(CCEaseSineIn:create(CCMoveTo:create(self.animDuration, ccp(self.clipping:getPositionX(), self.foldedClippingY))))
        self.layout:runAction(CCEaseSineIn:create(CCMoveTo:create(self.animDuration, ccp(self.layout:getPositionX(), self.foldedLayoutY))))
        setTimeOut(function () self.otherAccountsBtn:setVisible(true) self.otherAccountsBtn:setTouchEnabled(true) end, self.animDuration)
    else
        self.animBg:setScaleY(1)
        self.innerBg:setScaleY(1)
        self.bg:setScaleY(1)
        self.upArrow:setVisible(false)
        self.upArrow:setTouchEnabled(false)
        self.otherAccountsBtn:setVisible(true)
        self.otherAccountsBtn:setTouchEnabled(true)
        self.unbindBtn:setPositionY(self.foldedUnbindBtnY)
        self.cdkeyBtn:setPositionY(self.foldedCdkeyBtnY)
        self.clipping:setPositionY(self.foldedClippingY)
        self.layout:setPositionY(self.foldedLayoutY)
    end
end

function AccountPanel:onCodeBtnTapped()
    if not RequireNetworkAlert:popout() then return end
    DcUtil:UserTrack({ category='setting', sub_category="setting_click_qrcode"})
    self:onCloseBtnTapped()
    QRCodePostPanel:create():popout()
end

function AccountPanel:changePhoneBinding()

    local function onReturnCallback()
        AccountPanel:create():popout()
    end

    local function onRebindingError(event)
        event.target:rma()
    end

    local function onSuccessCallback(openId, phoneNumber)
    	print("--------------onSuccessCallback called!!!!!!!!!!!!!!")

        local function onRebindingFinish(event)
            event.target:rma()
            UserManager:getInstance().userExtend:setFlagBit(8, true)

            local snsName = phoneNumber
            UserManager:getInstance().profile:setSnsInfo(PlatformAuthEnum.kPhone, snsName)
            Localhost:writeCachePhoneListData(phoneNumber)

            --CommonTip:showTip(localize("setting.alert.content.3"), "positive")

            local panel = AccountConfirmPanel:create()
            panel:initLabel(localize("setting.alert.content.3"), "知道了")
            panel:popout()
            panel.allowBackKeyTap = false
            DcUtil:UserTrack({ category='setting', sub_category="setting_click_switch_success"})
        end

        local http = RebindingHttp.new()
        http:addEventListener(Events.kComplete, onRebindingFinish)
        http:addEventListener(Events.kError, onRebindingError)
        http:load(phoneNumber, openId)
    end

    local function doChangePhone()
        local phoneNumber = self:getAccountAuthName(PlatformAuthEnum.kPhone) or ''
        self:onCloseBtnTapped()
        local panel = PasswordValidatePanel:create(onReturnCallback, onSuccessCallback, phoneNumber, kModeChangeBinding, nil)
        panel:setPlace(2)
        panel:popout()
    end
    local panel = ChangePhonePromptPanel:create(doChangePhone, nil)
    panel:popout()
end

function AccountPanel:bindNewPhone()
    local function onReturnCallback()
        AccountPanel:create():popout()
    end

    self:onCloseBtnTapped()
    local panel = PhoneRegisterPanel:create(onReturnCallback, kModeRegisterInGame, nil)
    panel:setPhoneLoginCompleteCallback(function( openId,phoneNumber )

        local profile = UserManager.getInstance().profile

        Localhost:writeCachePhoneListData(phoneNumber)
        local sns_token = {openId=openId,accessToken="",authorType=PlatformAuthEnum.kPhone}
        local snsInfo = { snsName=phoneNumber }
        if not _G.sns_token then
            snsInfo.name = profile.name
            snsInfo.headUrl = profile.headUrl
        end
        self:bindConnect(PlatformAuthEnum.kPhone,snsInfo,sns_token)
    end)
    panel:setPlace(2)
    panel:popout()
end

function AccountPanel:guestBindConnect( authorizeType,snsInfo,sns_token )

    local snsName = snsInfo.snsName
    local name = snsInfo.name
    local headUrl = snsInfo.headUrl

    local function onFinish( mustExit )
        self:updateSnsUserProfile(authorizeType,snsName,name,headUrl)
        -- UserManager:getInstance().profile:setSnsInfo(authorizeType,snsName,name,headUrl)
        -- self:updateUserProfile()
        if mustExit then            
            if __ANDROID then luajava.bindClass("com.happyelements.android.ApplicationHelper"):restart()
            else Director.sharedDirector():exitGame() end        
        else
            _G.sns_token = sns_token

            if authorizeType ~= PlatformAuthEnum.kPhone then
                self:updateOtherAccount(authorizeType)
                SnsProxy:syncSnsFriend()
            else
                AccountPanel:create():popout()
            end

            HomeScene:sharedInstance().pauseBtn:updateDotTipStatus()
        end
        DcUtil:UserTrack({ category='setting', sub_category="setting_click_binding_success", object = authorizeType})
    end

    local function onCancel( ... )
        if authorizeType ~= PlatformAuthEnum.kPhone then
            self:updateOtherAccount(authorizeType)
        else
             AccountPanel:create():popout()
        end
    end

    local function onError(  )
        if authorizeType ~= PlatformAuthEnum.kPhone then
            self:updateOtherAccount(authorizeType)
        else
             AccountPanel:create():popout()
        end

        CommonTip:showTip("绑定账号失败！","negative")
        -- CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative")

        print("bindSns:guestBindConnect connect error")
    end

    local openId = sns_token.openId
    local accessToken = sns_token.accessToken
    local snsPlatform = PlatformConfig:getPlatformAuthName(authorizeType)
    local oldSnsPlatform =  nil

    local function preconnect( onGetPreConnect )

        local function onError( evt )
            onGetPreConnect(nil)
        end
        local function onFinish( evt )  
            onGetPreConnect(evt.data)
        end

        local http = PreQQConnectHttp.new(true)
        http:addEventListener(Events.kComplete, onFinish)
        http:addEventListener(Events.kError, onError)
        http:syncLoad(openId,accessToken,false,snsPlatform,HeDisplayUtil:urlEncode(snsName))
    end

    local function connect( onGetConnect )

        local function onError( evt )
            onGetConnect(nil)
        end

        local function onFinish( evt )
            onGetConnect(evt.data)
        end

        local http = QQConnectHttp.new(true)
        http:addEventListener(Events.kComplete, onFinish)
        http:addEventListener(Events.kError, onError)
        http:syncLoad(openId,accessToken,snsPlatform,HeDisplayUtil:urlEncode(snsName))
    end

    
    local function onGetConnect( result )
        if result and result.uid and result.uuid then
            local serverNewUid = result.uid
            local serverNewUDID = result.uuid
            local localOldUid = UserManager.getInstance().uid

            UdidUtil:saveUdid(serverNewUDID)
            Localhost.getInstance():setLastLoginUserConfig(serverNewUid, serverNewUDID, _G.kDefaultSocialPlatform)
            if tostring(serverNewUid) ~= tostring(localOldUid) then
                Localhost.getInstance():deleteUserDataByUserID(localOldUid)

                local function onRegisterFinish( ... ) 
                    SnsProxy:setAuthorizeType(authorizeType)
                    Localhost:setCurrentUserOpenId(sns_token.openId,nil,authorizeType)

                    onFinish(true)
                end
                local function onRegisterError( ... )
                    UdidUtil:revertUdid()
                    Localhost.getInstance():setLastLoginUserConfig(0, nil, _G.kDefaultSocialPlatform) 

                    onFinish(true)
                end

                local scene = Director:sharedDirector():getRunningScene()
                if scene then 
                    CountDownAnimation:createNetworkAnimation(scene, onRegisterError) 
                end

                kDeviceID = serverNewUDID            
                local logic = PostLoginLogic.new()
                logic:addEventListener(PostLoginLogicEvents.kComplete, onRegisterFinish)
                logic:addEventListener(PostLoginLogicEvents.kError, onRegisterError)
                logic:load()
            else
                kDeviceID = serverNewUDID
                UserManager.getInstance().sessionKey = kDeviceID
                Localhost.getInstance():flushCurrentUserData()

                ConnectionManager:invalidateSessionKey()

                SnsProxy:setAuthorizeType(authorizeType)
                Localhost:setCurrentUserOpenId(sns_token.openId,nil,authorizeType)

                onFinish(false)
            end
        else
            onError()
            return
        end

    end

    local function onGetPreConnect( result )
        if not result then 
            onError()
            return
        end

        local errorCode = result.errorCode or 0
        local alertCode = result.alertCode or 0
        if errorCode > 0 then
            onError()
            return
        end

        if alertCode > 0 then 

                local function onTouchPositiveButton()
                    connect(onGetConnect)
                end
                local function onTouchNegativeButton()
                    onCancel()
                end
            print("alert code: "..tostring(alertCode))
            if alertCode == QzoneSyncLogic.AlertCode.MERGE then
                local platform = PlatformConfig:getPlatformNameLocalization(authorizeType)
                local formated = QzoneSyncLogic:formatLevelInfoMessage(result.mergeLevelInfo or 1, tonumber(result.mergeUpdateTimeInfo))
                local accMode = Localization:getInstance():getText("loading.tips.preloading.warnning.mode1")

                local mergePanel = QQSyncPanel:create( 
                    Localization:getInstance():getText("loading.tips.start.btn.qq", {platform=platform}),
                    Localization:getInstance():getText("loading.tips.preloading.warnning.8",{user=formated,platform=platform,mode=accMode}),
                    onTouchPositiveButton, 
                    onTouchNegativeButton
                )
                mergePanel:popout()
            elseif alertCode == QzoneSyncLogic.AlertCode.DIFF_PLATFORM then
                require "zoo.panel.phone.CrossDeviceDescPanel"
                local function onTouchOK()
                    connect(onGetConnect)
                    if __ANDROID then 
                        DcUtil:UserTrack({ category='login', sub_category='login_switch_platform',action=2 })
                    else
                        DcUtil:UserTrack({ category='login', sub_category='login_switch_platform',action=1 })
                    end
                end
                local function onTouchCancel()
                    onCancel()
                end

                local panel = CrossDeviceDescPanel:create()
                panel:setOkCallback(onTouchOK)
                panel:setCancelCallback(onTouchCancel)
                panel:popout() 

            elseif alertCode == QzoneSyncLogic.AlertCode.NEED_SYNC then 
                local syncPanel = QQSyncPanel:create( 
                    Localization:getInstance():getText("loading.tips.start.btn.qq", {platform=platform}),
                    Localization:getInstance():getText("loading.tips.preloading.warnning.4", {platform=platform}), 
                    onTouchPositiveButton, 
                    onTouchNegativeButton
                )
                syncPanel:popout()
            else
                print("unhandled alert code!!!!!!!!!")
                onError()
                return
            end
        else
            onGetConnect(result)
        end
    end

    preconnect(onGetPreConnect)
end

function AccountPanel:snsBindConnect( authorizeType,snsInfo,sns_token )
    local oldAuthorizeType = SnsProxy:getAuthorizeType()

    local snsName = snsInfo.snsName
    local name = snsInfo.name
    local headUrl = snsInfo.headUrl

    local function onConnectFinish( ... )
        self:updateSnsUserProfile(authorizeType,snsName,name,headUrl)
        -- UserManager:getInstance().profile:setSnsInfo(authorizeType,snsName,name,headUrl)
        -- self:updateUserProfile()

        if authorizeType ~= PlatformAuthEnum.kPhone then
            self:updateOtherAccount(authorizeType)

            if not PlatformConfig:isQQPlatform() then
                SnsProxy:setAuthorizeType(authorizeType)
                SnsProxy:syncSnsFriend(sns_token)
                SnsProxy:setAuthorizeType(oldAuthorizeType)
            end
        else
            AccountPanel:create():popout()
        end

        print("bindSns:connect success")
        DcUtil:UserTrack({ category='setting', sub_category="setting_click_binding_success", object = authorizeType})        
    end

    local function onConnectError ( event )
        -- if onFailCallback then onFailCallback() end

        if authorizeType ~= PlatformAuthEnum.kPhone then
            self:updateOtherAccount(authorizeType)
        else
             AccountPanel:create():popout()
        end

        if tonumber(event.data) == 730764 then
            local tipStr = localize("setting.alert.content.2", 
                                    {account = PlatformConfig:getPlatformNameLocalization(authorizeType), 
                                     account1 = PlatformConfig:getPlatformNameLocalization(authorizeType),
                                     account2 =  PlatformConfig:getPlatformNameLocalization(authorizeType)
                                    })
            local panel = AccountConfirmPanel:create()
            panel:initLabel(tipStr, "知道了")
            panel:popout()
            panel.allowBackKeyTap = false
        else
            CommonTip:showTip("绑定账号失败！","negative")
        end
        -- CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative")

        print("bindSns:snsBindConnect error")
    end

    local http = ExtraConnectHttp.new(true)    
    http:addEventListener(Events.kComplete, onConnectFinish)
    http:addEventListener(Events.kError, onConnectError)
    http:load(
        sns_token.openId,
        sns_token.accessToken,
        PlatformConfig:getPlatformAuthName(authorizeType),
        HeDisplayUtil:urlEncode(snsName)
    )

    -- print("bindSns:",       
    --     sns_token.openId,
    --     sns_token.accessToken,
    --     PlatformConfig:getPlatformAuthName(authorizeType),
    --     HeDisplayUtil:urlEncode(snsName)
    -- )

end

function AccountPanel:bindConnect( authorizeType,snsInfo,sns_token )
    if not snsInfo then
        snsInfo = { snsName = Localization:getInstance():getText("game.setting.panel.use.device.name.default") }
    end
    if _G.sns_token then 
        self:snsBindConnect(authorizeType,snsInfo,sns_token)
    else
        self:guestBindConnect(authorizeType,snsInfo,sns_token)
    end
end

function AccountPanel:bindNewSns( authorizeType )

    local scene = Director:sharedDirector():getRunningScene()
    if not scene then
        return
    end
    local isCancel = false
    local animation
    animation = CountDownAnimation:createBindAnimation(scene, function( ... )
        isCancel = true
        animation:removeFromParentAndCleanup(true)
        self:updateOtherAccount(authorizeType)
    end)
    
    local oldAuthorizeType = SnsProxy:getAuthorizeType()
    local logoutCallback = {
        onSuccess = function(result)

            local function onSNSLoginResult( status, result )
                if status == SnsCallbackEvent.onSuccess then
                    local sns_token = result
                    sns_token.authorType = authorizeType

                    print("bindSns:" .. table.tostring(sns_token))

                    local function successCallback( ... )
                        if not isCancel then
                            local snsInfo = {
                                snsName = SnsProxy.profile.nick,
                                name = SnsProxy.profile.nick,
                                headUrl = SnsProxy.profile.headUrl,
                            }
                            self:bindConnect(authorizeType,snsInfo,sns_token)
                            animation:removeFromParentAndCleanup(true)
                        end

                        print("bindSns: successCallback")
                    end
                    local function errorCallback( ... )
                        if not isCancel then
                            self:bindConnect(authorizeType,nil,sns_token)
                            animation:removeFromParentAndCleanup(true)
                        end

                        print("bindSns: errorCallback")
                    end
                    local function cancelCallback( ... )
                       if not isCancel then
                            self:bindConnect(authorizeType,nil,sns_token)
                            animation:removeFromParentAndCleanup(true)
                        end

                        print("bindSns: cancelCallback")
                    end
                    SnsProxy:setAuthorizeType(authorizeType)
                    SnsProxy:getUserProfile(successCallback,errorCallback,cancelCallback)
                    SnsProxy:setAuthorizeType(oldAuthorizeType)
                else 
                    if not isCancel then
                        CommonTip:showTip("绑定账号失败！","negative")
                        self:updateOtherAccount(authorizeType)
                        animation:removeFromParentAndCleanup(true)
                    end

                    print("bindSns:login error " .. tostring(status))
                end
            end
            SnsProxy:setAuthorizeType(authorizeType)
            SnsProxy:login(onSNSLoginResult)
            SnsProxy:setAuthorizeType(oldAuthorizeType)
        end,
        onError = function(errCode, msg) 
            if not isCancel then
                CommonTip:showTip("绑定账号失败！","negative")
                self:updateOtherAccount(authorizeType)
                animation:removeFromParentAndCleanup(true)
            end

            print("bindSns:",errCode,msg)
        end,
        onCancel = function()
            if not isCancel then
                CommonTip:showTip("绑定账号失败！","negative")
                self:updateOtherAccount(authorizeType)
                animation:removeFromParentAndCleanup(true)
            end

            print("bindSns: cancel")
        end
    }

    SnsProxy:setAuthorizeType(authorizeType)
    SnsProxy:logout(logoutCallback)
    SnsProxy:setAuthorizeType(oldAuthorizeType)
end


function AccountPanel:phoneAccountBtnTapped()
    if self:isPhoneBinded() then
        if self:isAllowChangePhoneBinding() then
            self:changePhoneBinding()

            DcUtil:UserTrack({ category='setting', sub_category="setting_click_switch"})
        end
    else
        self:bindNewPhone()

        DcUtil:UserTrack({ category="setting",sub_category="setting_click_binding",object=PlatformAuthEnum.kPhone })
    end
end

function AccountPanel:onUnbindAccountBtnTapped()
    DcUtil:UserTrack({ category='setting', sub_category="setting_click_unbundling"})
    
    local function yesCallback()
        if __ANDROID then luajava.bindClass("com.happyelements.android.ApplicationHelper"):restart()
        else Director.sharedDirector():exitGame() end
    end

    local function onSuccessCallback()
        local uid = UserManager.getInstance().uid
        Localhost.getInstance():deleteUserDataByUserID(uid) 
        Localhost.getInstance():deleteLastLoginUserConfig()
        Localhost.getInstance():deleteGuideRecord()
        Localhost.getInstance():deleteMarkPriseRecord()
        Localhost.getInstance():deletePushRecord()
        Localhost.getInstance():deleteWeeklyMatchData()
        Localhost.getInstance():deleteLocalExtraData()
        LocalNotificationManager.getInstance():cancelAllAndroidNotification()
        CCUserDefault:sharedUserDefault():setStringForKey("game.devicename.userinput", "")
        CCUserDefault:sharedUserDefault():flush()
        UdidUtil:revertUdid()

        local panel = CommonTipWithBtn:showTip({ tip = localize('setting.alert.content.7'), yes = localize('button.ok'), no = ''}, 'positive', yesCallback, nil, nil, true)
        if panel then panel:setAfterScaledCallback(function() panel.allowBackKeyTap = false end) end
    end

    local function onError(err)
        CommonTip:showTip("解除绑定失败！", "negative",nil,2)
    end

    local function onReturnCallback()
        AccountPanel:create():popout()
    end

    local function sendDisposeRequest()
        local http = DisposeBindingHttp.new()
        http:load({PlatformAuthDetail[PlatformAuthEnum.kPhone].name})
        http:ad(Events.kComplete, onSuccessCallback)
        http:ad(Events.kError, onError)
    end

    local function validateSuccessCallback()
        local panel = UnbindAccountPromptPanel:create(sendDisposeRequest, nil)
        panel:popout()
    end

    local phoneNumber = self:getAccountAuthName(PlatformAuthEnum.kPhone) or ''
    if UserManager.getInstance().profile:isPhoneBound() then
        self:onCloseBtnTapped()
        local panel = PasswordValidatePanel:create(onReturnCallback, validateSuccessCallback, phoneNumber, kModeDisposeBinding, nil)
        panel:setPlace(2)
        panel:popout()
    else
        validateSuccessCallback()
    end

end

function AccountPanel:getAccountAuthName(accountKey)
    return UserManager:getInstance().profile:getSnsUsername(accountKey)
end

function AccountPanel:isAllowChangePhoneBinding()
    local val = UserManager:getInstance().userExtend:allowChangePhoneBinding()
    print("isAllowChangePhoneBinding test: "..tostring(val))
    
    return val
end

function AccountPanel:isPhoneBinded()
    if UserManager:getInstance().profile:getSnsUsername(PlatformAuthEnum.kPhone) ~= nil then
        return true
    end
    return false
end

function AccountPanel:isPhoneSupported()
    local config = PlatformConfig.authConfig
    if type(config) == 'table' then
        return table.exist(config, PlatformAuthEnum.kPhone)
    else
        return config == PlatformAuthEnum.kPhone
    end
end

function AccountPanel:shouldShowUnbindBtn()

    return false

    -- for k, v in pairs(PlatformAuthEnum) do
    --     if self:getAccountAuthName(v) ~= nil then
    --         return true
    --     end
    -- end
    -- return false
    -- return true
end

local order = {
    [PlatformAuthEnum.kPhone] = 1,
    [PlatformAuthEnum.kQQ]    = 2,
    [PlatformAuthEnum.kWeibo] = 3,
    [PlatformAuthEnum.kWDJ]   = 4,
    [PlatformAuthEnum.kMI]    = 5,
    [PlatformAuthEnum.k360]   = 6,
}

function AccountPanel:updateOtherAccount( authorizeType )
    if self.isDisposed then 
        return
    end
    local v = authorizeType
    local res = self.otherAccountItems[v]
    if not res then 
        return
    end

    print('otherAccounts', v)
    local prefix, account
    if v == PlatformAuthEnum.kWeibo then
        prefix = Localization:getInstance():getText('setting.panel.intro.4')
        account = self:getAccountAuthName(PlatformAuthEnum.kWeibo)
    elseif v == PlatformAuthEnum.kQQ then
        prefix = Localization:getInstance():getText('setting.panel.intro.3')
        account = self:getAccountAuthName(PlatformAuthEnum.kQQ)
    elseif v == PlatformAuthEnum.kWDJ then
        prefix = Localization:getInstance():getText('setting.panel.intro.6')
        account = self:getAccountAuthName(PlatformAuthEnum.kWDJ)
    elseif v == PlatformAuthEnum.kMI then
        prefix = Localization:getInstance():getText('setting.panel.intro.7')
        account = self:getAccountAuthName(PlatformAuthEnum.kMI)
    elseif v == PlatformAuthEnum.k360 then
        prefix = Localization:getInstance():getText('setting.panel.intro.5')
        account = self:getAccountAuthName(PlatformAuthEnum.k360)
    end
    -- local item = ItemInLayout:create()
    -- local res = self:buildInterfaceGroup('AccountPanel_otherAccountItem')
    -- self.otherAccountItems[v] = res
    res:getChildByName('prefix'):setString(prefix)

    local function isToppest(curType)
        for k,_ in pairs(self.otherAccountItems) do
            if order[k] < order[curType] then
                return false
            end
        end

        return true
    end

    local btn = res:getChildByName('btn')
    btn:removeAllEventListeners()
    btn:setVisible(true)

    if not account then
        btn:getChildByName('txt'):setString(Localization:getInstance():getText('setting.panel.button.2')..'>')
        btn:setTouchEnabled(true)
        btn:setButtonMode(true)
        btn:addEventListener(DisplayEvents.kTouchTap,function( ... )
            print("button touched!!!!!!!!!!!!!!"..tostring(isToppest(authorizeType)))
            if btn:isVisible() and (self.isExtended or (isToppest(authorizeType)  and not self:isPhoneSupported())) then
                btn:setVisible(false)
                self:bindNewSns(v)
                DcUtil:UserTrack({ category='setting', sub_category="setting_click_binding", object = v})
            end
        end)
        res:getChildByName('account2'):setString('')
        res:getChildByName('nobinded'):setString(Localization:getInstance():getText('setting.panel.intro.8'))
    else
        btn:setTouchEnabled(false)
        btn:getChildByName('txt'):setString('')
        res:getChildByName('account2'):setString(account)
        res:getChildByName('nobinded'):setString('')

        if account == "" and authorizeType == PlatformAuthEnum.kQQ then
            res:getChildByName('nobinded'):setDimensions(CCSizeMake(0,0))
            res:getChildByName('nobinded'):setString(Localization:getInstance():getText("setting.panel.intro.9"))
        end
    end
end



function AccountPanel:initOtherAccounts()
    local otherAccounts = {}
    local authConfig = PlatformConfig.authConfig

    if type(authConfig) == 'table' then
        for k, v in pairs(authConfig) do
            if v ~= PlatformAuthEnum.kPhone and v ~= PlatformAuthEnum.kGuest then
                table.insert(otherAccounts, v)
            end
        end
    else
        if authConfig ~= PlatformAuthEnum.kPhone and authConfig ~= PlatformAuthEnum.kGuest then
            table.insert(otherAccounts, authConfig)
        end
    end

    table.sort(otherAccounts,function(a,b) return order[a] < order[b] end)

    -- test
    -- table.insert(otherAccounts, PlatformAuthEnum.kWeibo)
    -- table.insert(otherAccounts, PlatformAuthEnum.kQQ)
    -- table.insert(otherAccounts, PlatformAuthEnum.k360)

    local function secretPhone(phone)
        return string.sub(phone, 1, 3).."xxxx"..string.sub(phone, -4)
    end

    local ph = self.ui:getChildByName('otherAccountsPlaceHolder')
    ph:setVisible(false)
    local layoutWidth = ph:getContentSize().width * ph:getScaleX()
    local pos = ph:getPosition()

    local layout = VerticalTileLayout:create(layoutWidth)

    if self:isPhoneSupported() then

        local function phoneAccountBtnTapped()
            self:phoneAccountBtnTapped()
        end

        local res = self:buildInterfaceGroup('AccountPanel_phoneAccountItem')

        self.phoneAccountItem = res

        local prefix = Localization:getInstance():getText('setting.panel.intro.2')
        local phone = self:getAccountAuthName(PlatformAuthEnum.kPhone) or ''
        if #phone == 11 then
            phone = secretPhone(phone)
        end
        res:getChildByName('prefix'):setString(prefix)
        local btn = res:getChildByName('btn')

        self.bindPhoneBtn = btn

        if self:isPhoneBinded() then
            if self:isAllowChangePhoneBinding() then
                res:getChildByName('account'):setText(phone)
                res:getChildByName('nobinded'):setVisible(false)
                btn:getChildByName('txt'):setString(Localization:getInstance():getText('setting.panel.button.3')..'>')
            else
                res:getChildByName('account'):setText(phone)
                res:getChildByName('nobinded'):setVisible(false)
                btn:getChildByName('txt'):setString('')
            end
        else
            res:getChildByName('account'):setText('')
            res:getChildByName('nobinded'):setVisible(true)
            res:getChildByName('nobinded'):setString(Localization:getInstance():getText('setting.panel.intro.8'))
            btn:getChildByName('txt'):setString(Localization:getInstance():getText('setting.panel.button.2')..'>')
        end
        btn:setTouchEnabled(true)
        btn:ad(DisplayEvents.kTouchTap, phoneAccountBtnTapped)
        local item = ItemInLayout:create()
        item:setContent(res)
        item:setHeight(50)
        layout:addItem(item)
    end

    self.otherAccountItems = {}

    for k, v in pairs(otherAccounts) do
        local item = ItemInLayout:create()
        local res = self:buildInterfaceGroup('AccountPanel_phoneAccountItem')
        self.otherAccountItems[v] = res

        self:updateOtherAccount(v)

        item:setContent(res)
        item:setHeight(50)
        layout:addItem(item)
    end
    -- layout:setPositionX(pos.x)
    -- layout:setPositionY(pos.y)

    local layoutHeight = layout:getHeight()
    local clipping2 = ClippingNode:create({size = {width = layoutWidth, height = layoutHeight}})
    -- local clipping2 = LayerColor:create()
    -- clipping2:setContentSize(CCSizeMake(layoutWidth, layoutHeight))
    clipping2:addChild(layout)
    layout:setPositionY(layoutHeight)
    clipping2:setPositionX(pos.x)
    clipping2:setPositionY(pos.y - layoutHeight)
    self.ui:addChildAt(clipping2, self.moreAvatars:getZOrder() - 1)
    self.clipping = clipping2
    self.layout = layout

    -- self.animMoveY = layoutHeight - 50
    local itemHeight = 55
    self.animMoveY = layoutHeight - itemHeight
    if (#otherAccounts >= 1 and self:isPhoneSupported()) or (#otherAccounts >= 2) then
        self.otherAccountsBtnEnabled = true
    else
        self.otherAccountsBtnEnabled = false
    end
end


function ChangePhonePromptPanel:create(confirmCallback, cancelCallback)
    local instance = ChangePhonePromptPanel.new()
    instance:loadRequiredResource(PanelConfigFiles.panel_game_setting)
    instance:init(confirmCallback, cancelCallback)
    return instance
end

function ChangePhonePromptPanel:popout()
    PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false)
    local vs = Director:sharedDirector():getVisibleSize()
    local vo = Director:sharedDirector():getVisibleOrigin()
    self:setPositionX(vs.width / 2 - self:getGroupBounds().size.width / 2)
    self:setPositionY(-(vs.height / 2 - self:getGroupBounds().size.height / 2))
end

function ChangePhonePromptPanel:init(confirmCallback, cancelCallback)
    self.confirmCallback = confirmCallback
    self.cancelCallback = cancelCallback
    self.ui = self:buildInterfaceGroup('changePhonePromptPanel')
    BasePanel.init(self, self.ui)
    self.ui:getChildByName('desLabel'):setString(Localization:getInstance():getText('setting.alert.content.1'))
    self.cancelBtn = GroupButtonBase:create(self.ui:getChildByName('cancelBtn'))
    self.cancelBtn:setColorMode(kGroupButtonColorMode.blue)
    self.cancelBtn:setString(Localization:getInstance():getText('button.cancel'))
    self.cancelBtn:ad(DisplayEvents.kTouchTap, 
        function ()  
            PopoutManager:sharedInstance():remove(self, true)
            if self.cancelCallback then self.cancelCallback() end
        end)
    self.confirmBtn = GroupButtonBase:create(self.ui:getChildByName('confirmBtn'))
    self.confirmBtn:setColorMode(kGroupButtonColorMode.green)
    self.confirmBtn:setString(Localization:getInstance():getText('setting.panel.button.6'))
    self.confirmBtn:ad(DisplayEvents.kTouchTap, 
        function () 
            PopoutManager:sharedInstance():remove(self, true)
            if self.confirmCallback then self.confirmCallback() end
        end)
end

function UnbindAccountPromptPanel:create(confirmCallback, cancelCallback)
    local instance = UnbindAccountPromptPanel.new()
    instance:loadRequiredResource(PanelConfigFiles.panel_game_setting)
    instance:init(confirmCallback, cancelCallback)
    return instance
end

function UnbindAccountPromptPanel:popout()
    PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false)
    local vs = Director:sharedDirector():getVisibleSize()
    local vo = Director:sharedDirector():getVisibleOrigin()
    self:setPositionX(vs.width / 2 - self:getGroupBounds().size.width / 2)
    self:setPositionY(-(vs.height / 2 - self:getGroupBounds().size.height / 2))
end

function UnbindAccountPromptPanel:init(confirmCallback, cancelCallback)
    self.confirmCallback = confirmCallback
    self.cancelCallback = cancelCallback
    self.ui = self:buildInterfaceGroup('unbingAccountPromtPanel')
    BasePanel.init(self, self.ui)
    self.ui:getChildByName('panelTitle'):setString(Localization:getInstance():getText('setting.panel.button.5'))
    self.ui:getChildByName('desLabel'):setString(
        Localization:getInstance():getText('setting.alert.content.4') ..'\n\n' .. Localization:getInstance():getText('setting.alert.content.5')
        )
    self.cancelBtn = GroupButtonBase:create(self.ui:getChildByName('cancelBtn'))
    self.cancelBtn:setColorMode(kGroupButtonColorMode.blue)
    self.cancelBtn:setString(Localization:getInstance():getText('button.cancel'))
    self.cancelBtn:ad(DisplayEvents.kTouchTap, 
        function ()  
            PopoutManager:sharedInstance():remove(self, true)
            if self.cancelCallback then self.cancelCallback() end
        end)
    self.confirmBtn = GroupButtonBase:create(self.ui:getChildByName('confirmBtn'))
    self.confirmBtn:setColorMode(kGroupButtonColorMode.green)
    self.confirmBtn:setString(Localization:getInstance():getText('button.ok'))
    self.confirmBtn:ad(DisplayEvents.kTouchTap, function() self:onConfirmBtnTapped() end)
end

function UnbindAccountPromptPanel:onConfirmBtnTapped()
    if not self.confirmedOnce then
        self.confirmedOnce = true
        self.ui:getChildByName('secondConfirmMessage'):setString(Localization:getInstance():getText('setting.alert.content.6'))
    else
        PopoutManager:sharedInstance():remove(self, true)
        if self.confirmCallback then
            self.confirmCallback()
        end
    end
end