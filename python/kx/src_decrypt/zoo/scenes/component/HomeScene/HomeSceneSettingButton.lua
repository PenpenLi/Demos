require 'zoo.panel.NewGameSettingPanel'
require 'zoo.panel.AccountPanel'

HomeSceneSettingButton = class()

local function getFAQurl()
    local function getKeyValueStr(key,value,isLast)
        local strPair = key.."="..value
        if not isLast then 
            strPair = strPair.."&"
        end
        return strPair
    end
    local preUrl = "http://fansclub.happyelements.com/fans/qa.php?"

    local level = UserManager:getInstance().user:getTopLevelId()
    local platform = StartupConfig:getInstance():getPlatformName()
    local timeStamp = os.time()
    local UID = UserManager.getInstance().uid
    local version = _G.bundleVersion
    local secret = "hxxxl!xxgkl!"

    local lv = getKeyValueStr("level",level)
    local pf = getKeyValueStr("pf",platform)
    local src = getKeyValueStr("src","client")
    local ts = getKeyValueStr("ts",timeStamp)
    local uid = getKeyValueStr("uid",UID) 
    local ver = getKeyValueStr("ver",version)
    local sig = getKeyValueStr("sig",HeMathUtils:md5(level..platform.."client"..timeStamp..UID..version..secret),true)

    local finalUrl = preUrl..lv..pf..src..ts..uid..ver..sig
    -- print(finalUrl)
    return finalUrl
end

local function encodeUri(str)
    local ret = HeDisplayUtil:urlEncode(str)
    return ret
end

local function getFAQParams()
    local deviceOS = "android"
    local appId = "1002"
    local secret = "andridxxl!sx0fy13d2"
    
    if __ANDROID and PlatformConfig:isQQPlatform() then -- android应用宝
        appId = "1003"
        secret = "yybxxl!1f0ft03ef"
    elseif __IOS then
        deviceOS = "ios"
        appId = "1001"
        secret = "iosxxl!23rj8945fc2d3"
    end
    
    local parameters = {}

    local metaInfo = MetaInfo:getInstance()
    parameters["app"] = appId
    parameters["os"] = deviceOS
    parameters["mac"] = metaInfo:getMacAddress()
    parameters["model"] = metaInfo:getDeviceModel()
    parameters["osver"] = metaInfo:getOsVersion()
    parameters["udid"] = metaInfo:getUdid()
    local network = "UNKNOWN"
    if __ANDROID then
        network = luajava.bindClass("com.happyelements.android.MetaInfo"):getNetworkTypeName()
    else
        network = Reachability:getNetWorkTypeName()
    end
    parameters["network"] = network

    parameters["vip"] = 0
    parameters["src"] = "client"
    parameters["lang"] = "zh-Hans"

    parameters["pf"] = StartupConfig:getInstance():getPlatformName() or ""
    parameters["uuid"] = _G.kDeviceID or ""

    local user = UserManager:getInstance().user
    parameters["level"] = user:getTopLevelId()
    local markData = UserManager:getInstance().mark
    local createTime = markData and markData.createTime or 0
    parameters["ct"] = tonumber(createTime) / 1000
    parameters["lt"] = PlatformConfig:getLoginTypeName()
    if __IOS then
        parameters["pt"] = "apple"
    else
        local pt = AndroidPayment.getInstance():getDefaultSmsPayment()
        local ptName = "NOSIM"
        if pt then ptName = PaymentNames[pt] end
        parameters["pt"] = tostring(ptName)
    end
    parameters["gold"] = user:getCash()
    parameters["silver"] = user:getCoin()
    parameters["uver"] = ResourceLoader.getCurVersion()
    parameters["uid"] = user.uid
    local name = ""
    if UserManager.getInstance().profile and UserManager.getInstance().profile:haveName() then
        name = UserManager.getInstance().profile:getDisplayName()
    end
    parameters["name"] = name
    parameters["ver"] = _G.bundleVersion
    parameters["ts"] = os.time()
    parameters["ext"] = ""

    local paramKeys = {}
    for k, v in pairs(parameters) do
        table.insert(paramKeys, k)
    end
    table.sort(paramKeys)
    local md5Src = ""
    for _, v in pairs(paramKeys) do
        md5Src = md5Src..tostring(parameters[v])
    end
    local sig = HeMathUtils:md5(md5Src)
    -- calc sig
    parameters["sig"] = sig
    return parameters
end

local function getNewFAQurl(params)
    local parameters = params or getFAQParams()
    local faqUrl = "http://fansclub.happyelements.com/fans/qa.php"
    -- local faqUrl = "http://fansclub.happyelements.com/kefu/qa.php"
    local isFirstParam = true
    for k, v in pairs(parameters) do
        local join = "&"
        if isFirstParam then 
            join = "?"
            isFirstParam = false
        end
        faqUrl = faqUrl .. join .. k .. "=" .. encodeUri(tostring(v))
    end
    return faqUrl
end

function HomeSceneSettingButton:create(ui)
    local instance = HomeSceneSettingButton.new()
    instance:init(ui)
    return instance
end

function HomeSceneSettingButton:init(ui)
    self.ui = ui
    self.ui:setScale(1.113)
    self.normalSettingBtn = ui:getChildByName('normalSettingBtnIcon')
    self.greenSettingBtn = ui:getChildByName('greenSettingBtnIcon')
    self.accountBtn = ui:getChildByName('accountBtnIcon')
    self.forumBtn = ui:getChildByName('forumBtnIcon')
    self.settingPanelBtn = ui:getChildByName('settingPanelBtnIcon')
    self.fcBtn = ui:getChildByName('fcBtnIcon')
    self.animBg = ui:getChildByName('settingAnimBg')

    self.normalSettingBtn:ad(DisplayEvents.kTouchTap, function() self:onNormalSettingBtnTapped() end)
    self.greenSettingBtn:ad(DisplayEvents.kTouchTap, function() self:onGreenSettingBtnTapped() end)
    self.accountBtn:ad(DisplayEvents.kTouchTap, function() self:onAccountBtnTapped() end)
    self.settingPanelBtn:ad(DisplayEvents.kTouchTap, function() self:onSettingPanelBtnTapped() end)
    self.fcBtn:ad(DisplayEvents.kTouchTap, function() self:onFcBtnTapped() end)
    self.animBg:ad(DisplayEvents.kTouchTap, function () self:onMaskTapped() end)

    -- 不判断点击位置，相当于创建了一个mask
    self.animBg.hitTestPoint = function (worldPosition, useGroupTest)
        return true
    end

    self.greenSettingBtn:setScale(0.87)
    self.greenSettingBtn:setVisible(false)
    self.accountBtn:setScale(0)
    self.accountBtn:setVisible(false)
    self.forumBtn:setScale(0)
    self.forumBtn:setVisible(false)
    self.settingPanelBtn:setScale(0)
    self.settingPanelBtn:setVisible(false)
    self.fcBtn:setScale(0)
    self.fcBtn:setVisible(false)
    self.animBg:setScale(0)
    self.animBg:setVisible(false)

    self.normalSettingBtn:setTouchEnabled(true, 0, true)
    self.isExtended = false

    if self:shouldShowForumBtn() then
        self.forumBtn:ad(DisplayEvents.kTouchTap, function() self:onForumBtnTapped() end)
    else
        self.forumBtn:setVisible(false)
    end

    self:updateDotTipStatus()
end

function HomeSceneSettingButton:updateDotTipStatus( ... )

    local dotTipVisible = false

    if not PlatformConfig:isAuthConfig(PlatformAuthEnum.kGuest) then
        dotTipVisible = not _G.sns_token
    end

    self.normalSettingBtn:getChildByName("dot"):setVisible(dotTipVisible)
    self.greenSettingBtn:getChildByName("dot"):setVisible(dotTipVisible)
    self.accountBtn:getChildByName("dot"):setVisible(dotTipVisible)
end

function HomeSceneSettingButton:setUIScale(scale)

end

function HomeSceneSettingButton:playOpenAnim(finishCallback)
    if self.isExtended == true then return end
    self.isExtended = true

    local bgScaleX = 1
    if not self:shouldShowForumBtn() then
        bgScaleX = 0.82
    end


    self.normalSettingBtn:setTouchEnabled(false)
    self.animBg:setTouchEnabled(true, 0, true)

    local arr0 = CCArray:create()
    arr0:addObject(CCDelayTime:create(2/24))
    arr0:addObject(CCScaleTo:create(3/24, 0.5, 1.32))
    arr0:addObject(CCScaleTo:create(3/24, 1, 1))
    arr0:addObject(CCHide:create())
    self.normalSettingBtn:runAction(
        CCSequence:create(arr0)
        )
    local arr1 = CCArray:create()
    arr1:addObject(CCDelayTime:create(5/24))
    arr1:addObject(CCShow:create())
    arr1:addObject(CCScaleTo:create(4/24, 0.87*bgScaleX, 0.87))
    arr1:addObject(CCScaleTo:create(2/24, 1.04*bgScaleX, 1.04))
    arr1:addObject(CCScaleTo:create(2/24, 0.96*bgScaleX, 0.96))
    arr1:addObject(CCScaleTo:create(1/24, 0.96*bgScaleX, 0.96))
    arr1:addObject(CCScaleTo:create(1/24, 1*bgScaleX, 1))
    self.animBg:runAction(
            CCSequence:create(arr1)
        )
    local arr2 = CCArray:create()
    arr2:addObject(CCDelayTime:create(7/24))
    arr2:addObject(CCShow:create())
    arr2:addObject(CCFadeIn:create(1/24))
    arr2:addObject(CCScaleTo:create(3/24, 1.07))
    arr2:addObject(CCScaleTo:create(3/24, 1))
    self.greenSettingBtn:setScale(0.87)
    self.greenSettingBtn:runAction(CCSequence:create(arr2))

    local function getBtnAction(delay)
        local arr = CCArray:create()
        arr:addObject(CCDelayTime:create(delay))
        arr:addObject(CCShow:create())
        arr:addObject(CCScaleTo:create(4/24, 1.14))
        arr:addObject(CCScaleTo:create(3/24, 0.93))
        arr:addObject(CCScaleTo:create(3/24, 1.08))
        arr:addObject(CCScaleTo:create(3/24, 1))
        return CCSequence:create(arr)
    end
    local function getDelayByIndex(index)
        if index == 1 then return 5/24
        elseif index == 2 then return 6/24
        elseif index == 3 then return 7/24
        elseif index == 4 then return 8/24
        end
    end
    self.fcBtn:runAction(getBtnAction(getDelayByIndex(self:getButtonIndex(self.fcBtn))))
    self.accountBtn:runAction(getBtnAction(getDelayByIndex(self:getButtonIndex(self.accountBtn))))
    self.settingPanelBtn:runAction(getBtnAction(getDelayByIndex(self:getButtonIndex(self.settingPanelBtn))))
    if self:shouldShowForumBtn() then
        self.forumBtn:setVisible(true)
        self.forumBtn:runAction(getBtnAction(getDelayByIndex(self:getButtonIndex(self.forumBtn))))
    end
    local function updateTouchButtons()
        -- self.normalSettingBtn:setTouchEnabled(false)
        self.greenSettingBtn:setTouchEnabled(true, 0, true)
        self.fcBtn:setTouchEnabled(true, 0, true)
        self.settingPanelBtn:setTouchEnabled(true, 0, true)
        self.accountBtn:setTouchEnabled(true, 0, true)
        if self:shouldShowForumBtn() then
            self.forumBtn:setTouchEnabled(true, 0, true)
        end
        BindPhoneGuideLogic:get():onOpenSettingBtn(self.accountBtn)
    end

    updateTouchButtons()

    if finishCallback then
        self.ui:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(19/24), CCCallFunc:create(finishCallback)))
    end
end

function HomeSceneSettingButton:playFoldAnim(finishCallback)
    if self.isExtended == false then return end
    self.isExtended = false

    self.greenSettingBtn:setTouchEnabled(false)
    self.animBg:setTouchEnabled(false)

    local arr0 = CCArray:create()
    arr0:addObject(CCDelayTime:create(11/24))
    arr0:addObject(CCShow:create())
    arr0:addObject(CCScaleTo:create(3/24, 1.01, 1.04))
    arr0:addObject(CCScaleTo:create(3/24, 0.88, 0.88))
    arr0:addObject(CCScaleTo:create(1/24, 1, 1))
    self.normalSettingBtn:setScale(0.8)
    self.normalSettingBtn:runAction(
        CCSequence:create(arr0)
        )
    local arr1 = CCArray:create()
    arr1:addObject(CCDelayTime:create(4/24))
    arr1:addObject(CCScaleTo:create(4/24, 0.69))
    arr1:addObject(CCScaleTo:create(4/24, 0))
    arr1:addObject(CCHide:create())
    self.animBg:runAction(
            CCSequence:create(arr1)
        )
    local arr2 = CCArray:create()
    arr2:addObject(CCDelayTime:create(5/24))
    arr2:addObject(CCScaleTo:create(4/24, 1.16))
    arr2:addObject(CCScaleTo:create(4/24, 0.87))
    arr2:addObject(CCHide:create())
    self.greenSettingBtn:runAction(CCSequence:create(arr2))

    local function getBtnAction(delay)
        local arr = CCArray:create()
        arr:addObject(CCDelayTime:create(delay))
        arr:addObject(CCScaleTo:create(4/24, 1.16))
        arr:addObject(CCScaleTo:create(3/24, 0))
        arr:addObject(CCHide:create())
        return CCSequence:create(arr)
    end
    local function getDelayByIndex(index)
        if index == 1 then return 5/24
        elseif index == 2 then return 4/24
        elseif index == 3 then return 3/24
        elseif index == 4 then return 2/24
        end
    end
    self.fcBtn:runAction(getBtnAction(getDelayByIndex(self:getButtonIndex(self.fcBtn))))
    self.accountBtn:runAction(getBtnAction(getDelayByIndex(self:getButtonIndex(self.accountBtn))))
    self.settingPanelBtn:runAction(getBtnAction(getDelayByIndex(self:getButtonIndex(self.settingPanelBtn))))
    if self:shouldShowForumBtn() then
        self.forumBtn:runAction(getBtnAction(getDelayByIndex(self:getButtonIndex(self.forumBtn))))
    end
    local function updateTouchButtons()
        self.normalSettingBtn:setTouchEnabled(true, 0, true)
        -- self.greenSettingBtn:setTouchEnabled(false)
        self.fcBtn:setTouchEnabled(false)
        self.settingPanelBtn:setTouchEnabled(false)
        self.accountBtn:setTouchEnabled(false)
        if self:shouldShowForumBtn() then
            self.forumBtn:setTouchEnabled(false)
        end
    end
    updateTouchButtons()
    if finishCallback then
        self.ui:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(19/24), CCCallFunc:create(finishCallback)))
    end
end

-- 加上了连点的屏蔽
function HomeSceneSettingButton:onMaskTapped()
    if self.isInAnimation == true then return end
    self.isInAnimation = true
    local function finish()
        self.isInAnimation = false
    end
    self:playFoldAnim(finish)
end

function HomeSceneSettingButton:onNormalSettingBtnTapped()
    if self.isInAnimation == true then return end
    self.isInAnimation = true
    local function finish()
        self.isInAnimation = false
    end
    self:playOpenAnim(finish)
end

function HomeSceneSettingButton:onGreenSettingBtnTapped()
    if self.isInAnimation == true then return end
    self.isInAnimation = true
    local function finish()
        self.isInAnimation = false
    end
    self:playFoldAnim(finish)
end

-- 这几个按键没有屏蔽连点，因为动画的最后阶段按钮已经完全出来了，但动画还没结束
-- 如果要等动画完全播完才允许点击，会有迟钝的感觉
function HomeSceneSettingButton:onFcBtnTapped()
    self:playFoldAnim()
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
            Wp8Utils:ShowMessageBox("QQ群: 114278702\n联系客服: xiaoxiaole@happyelements.com", "开心消消乐沟通渠道")
        end
    end
end

function HomeSceneSettingButton:onAccountBtnTapped()
    self:playFoldAnim()
    PopoutManager:sharedInstance():add(AccountPanel:create(), true, false)
end

function HomeSceneSettingButton:onSettingPanelBtnTapped()
    self:playFoldAnim()
    -- PopoutManager:sharedInstance():add(NewGameSettingPanel:create(), true, false)
    NewGameSettingPanel:create():popout()
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
    self:playFoldAnim()
    if __IOS_QQ then
        if GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen then
            SimpleAudioEngine:sharedEngine():pauseBackgroundMusic()
        end
        -- OpenUrlHandleManager:openUrlWithDefaultBrowser("http://wsq.qq.com/reflow/159718216")
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

function HomeSceneSettingButton:getButtonIndex(btn)
    if btn == self.fcBtn  then
        return 1
    elseif btn == self.accountBtn then
        return 2
    elseif btn == self.settingPanelBtn then
        return 3
    elseif btn == self.forumBtn then
        return 4
    end
end