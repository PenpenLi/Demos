require 'zoo.util.FUUUManager'
require 'zoo.panel.IosOneYuanShopPanel'
require 'zoo.scenes.component.HomeScene.OneYuanShopButton'

local PROMO_DURATION = 24 * 60 * 60
-- local PROMO_DURATION = 10
local FAIL_COUNT_THRESHOLD = 5
local ENERGY_THRESHOLD = 15
local TIP_TIME = 3 * 60 * 60
local _config = nil


local function now()
    return os.time() + __g_utcDiffSeconds or 0
end

local function readConfig()
    local configPath = HeResPathUtils:getUserDataPath() .. '/ios_pay_guide_config_'..UserManager:getInstance().uid
    if not _config then
        local file = io.open(configPath, "r")
        if file then
            local data = file:read("*a") 
            file:close()
            if data then
                _config = table.deserialize(data) or {}
            else
                _config = {}
            end
        else
            _config = {}
        end
    end
    return _config
end
local function writeConfig(data)
    local configPath = HeResPathUtils:getUserDataPath() .. '/ios_pay_guide_config_'..UserManager:getInstance().uid
    _config = data
    local file = io.open(configPath,"w")
    if file then 
        file:write(table.serialize(data or {}))
        file:close()
    end
end

local function startGoldButtonTip()
    local function localCallback()
        local button = HomeScene:sharedInstance().goldButton
        local waitTime = 0
        local leftSeconds = IosPayGuide:getOneYuanFCashLeftSeconds()
        if leftSeconds < TIP_TIME then
            waitTime = 0
        else
            waitTime = leftSeconds - TIP_TIME
        end

        button:playTip('福利就要结束了', waitTime) -- 还剩n小时才playTip           
    end
    HomeScene:sharedInstance():runAction(CCCallFunc:create(localCallback))
end


local function init()
    local config = readConfig()
    if not config.oneYuanShopStartTime then
        config.oneYuanShopStartTime = 0
        config.oneYuanShopEndTime = 0
    end
    if not config.oneYuanFCashStartTime then
        config.oneYuanFCashStartTime = 0
        config.oneYuanFCashEndTime = 0
    end
    if not config._hasTriggeredFCash then -- 活动是否触发过（活动打开一次只能触发一次）
        config._hasTriggeredFCash = false
    end
    if not config._hasTriggeredOneYuanShop then -- 活动是否触发过（活动打开一次只能触发一次）
        config._hasTriggeredOneYuanShop = false
    end
    if not config.isEnabled then -- 活动是否开启（用来判断开关变化）
        config.isEnabled = false
    end
    writeConfig(config)
end

IosPayGuide = class()

function IosPayGuide:init()
    init()
    if IosPayGuide:shouldShowOneYuanShopIcon() then
        IosPayGuide:buildOneYuanShopIcon()
    end
    if IosPayGuide:isInFCashPromotion() then
        startGoldButtonTip()
    end
    if IosPayGuide:maintenanceEnabled() and IosPayGuide:isInAppleVerification() then -- 苹果审核阶段
        if not IosPayGuide:isInOneYuanShopPromotion() then
            IosPayGuide:startOneYuanShop()
        end
    end 
end

function IosPayGuide:onSuccessiveLevelFailure(levelId)
    if __ANDROID then return end
    if not IosPayGuide:maintenanceEnabled() then
        return
    end
    if not IosPayGuide:shouldTriggerOneYuanShop(levelId) then
        return
    end

    IosPayGuide:startOneYuanShop()
end

function IosPayGuide:startOneYuanShop()
    IosPayGuide:oneYuanShopStart()
    IosPayGuide:buildOneYuanShopIcon() 
    local function callback() -- 防止出现点击击穿
        IosPayGuide:popoutOneYuanShopPanel()
    end
    HomeScene:sharedInstance():runAction(CCCallFunc:create(callback)) 
end

function IosPayGuide:popoutOneYuanShopPanel()

    local function promoEndCallback()
        IosPayGuide:oneYuanShopEnd()
    end
    local panel = IosOneYuanShopPanel:create(IapBuyPropLogic:oneYuanShop().items, IosPayGuide:getOneYuanShopLeftSeconds(), promoEndCallback)
    panel:popout()
end

function IosPayGuide:shouldShowOneYuanShopIcon()
    return IosPayGuide:isInOneYuanShopPromotion()
end

function IosPayGuide:buildOneYuanShopIcon()
    local function onTap()
        IosPayGuide:popoutOneYuanShopPanel()
    end
    local function callback()
        local homeScene = HomeScene:sharedInstance()
        if homeScene.oneYuanShopButton and not homeScene.oneYuanShopButton.isDisposed then -- 防止添加多个按钮
            return 
        end
        local button = OneYuanShopButton:create(IosPayGuide:getOneYuanShopLeftSeconds())
        homeScene.rightRegionLayoutBar:addItem(button)
        homeScene.oneYuanShopButton = button
        button.wrapper:ad(DisplayEvents.kTouchTap, onTap)
    end
    HomeScene:sharedInstance():runAction(CCCallFunc:create(callback))
end

function IosPayGuide:oneYuanShopStart()
    DcUtil:UserTrack({ category='activity', sub_category='ios_promotion', num = 1})
    local config = readConfig()
    config.oneYuanShopStartTime = now()
    config.oneYuanShopEndTime = now() + PROMO_DURATION
    config._hasTriggeredOneYuanShop = true
    writeConfig(config)
    local shopSchedId
    local function endPromotion()
        if shopSchedId then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(shopSchedId)
            shopSchedId = nil
        end
        IosPayGuide:oneYuanShopEnd()
    end
    shopSchedId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(endPromotion, config.oneYuanShopEndTime - now(), false)
end

function IosPayGuide:oneYuanShopEnd()
    local config = readConfig()
    config.oneYuanShopStartTime = 0
    config.oneYuanShopEndTime = 0
    writeConfig(config)
    local homeScene = HomeScene:sharedInstance()
    if homeScene.oneYuanShopButton and not homeScene.oneYuanShopButton.isDisposed then
        homeScene.rightRegionLayoutBar:removeItem(homeScene.oneYuanShopButton)
        homeScene.oneYuanShopButton = nil
    end
end

function IosPayGuide:oneYuanFCashStart()
    DcUtil:UserTrack({ category='activity', sub_category='ios_promotion', num = 2})
    local config = readConfig()
    config.oneYuanFCashStartTime = now()
    config.oneYuanFCashEndTime = now() + PROMO_DURATION
    config._hasTriggeredFCash = true
    writeConfig(config)
    startGoldButtonTip()

    local fcashSchedId
    local function endPromotion()
        if fcashSchedId then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(fcashSchedId)
            fcashSchedId = nil
        end
        IosPayGuide:oneYuanFCashEnd()
    end
    fcashSchedId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(endPromotion, config.oneYuanFCashEndTime - now(), false)
end

function IosPayGuide:oneYuanFCashEnd()
    local config = readConfig()
    config.oneYuanFCashStartTime = 0
    config.oneYuanFCashEndTime = 0
    writeConfig(config)
end

function IosPayGuide:hasOneYuanShopPanelPopped()
    local config = readConfig()
    return (config.oneYuanShopStartTime and config.oneYuanShopStartTime ~= 0)
end

function IosPayGuide:hasOneYuanFCashShown()
    local config = readConfig()
    return (config.oneYuanFCashStartTime and config.oneYuanFCashStartTime ~= 0)
end

function IosPayGuide:isInFCashPromotion()
    local config = readConfig()
    return (now() > config.oneYuanFCashStartTime and now() < config.oneYuanFCashEndTime)
end

function IosPayGuide:isInOneYuanShopPromotion()
    local config = readConfig()
    return (now() > config.oneYuanShopStartTime and now() < config.oneYuanShopEndTime)
end

function IosPayGuide:shouldShowMarketOneYuanFCash()
    if IosPayGuide:maintenanceEnabled() and IosPayGuide:isInAppleVerification() then -- 苹果审核阶段
        return true
    else
        if __IOS and AppController:getSystemVersion() < 7 then
            return false
        end
        if UserManager:getInstance().userExtend.payUser then
            return false
        end
        if UserManager:getInstance().user.topLevelId < 40 then
            return false
        end
        if IosPayGuide:isInOneYuanShopPromotion() then 
            return false
        end
        -- 已经触发了1元风车币的，应该显示
        if IosPayGuide:isInFCashPromotion() then
            return true
        end
        -- 没有触发的，要看maintenance
        if not IosPayGuide:maintenanceEnabled() then
            return false
        end
        if IosPayGuide:hasTriggeredFCash() then
            return false
        end
        return true
    end
end

function IosPayGuide:getOneYuanFCashConfig()
    local config = MetaManager:getInstance().product[13]
    config.productIdentifier = "com.happyelements.animal.gold.cn.13"
    config.iapPrice = 1
    return config
end

function IosPayGuide:shouldTriggerOneYuanShop(levelId)
    if IosPayGuide:maintenanceEnabled() and IosPayGuide:isInAppleVerification() then -- 苹果审核阶段
        return true
    else
        if __IOS and AppController:getSystemVersion() < 7 then
            return false
        end
        if UserManager:getInstance().userExtend.payUser then
            return false
        end
        if UserManager:getInstance().user.topLevelId < 40 then
            return false
        end
        if IosPayGuide:hasTriggeredOneYuanShop() then
            return false
        end
        local failCount = FUUUManager:getLevelContinuousFailNum(levelId)
        print('onSuccessiveLevelFailure', failCount)
        if failCount < FAIL_COUNT_THRESHOLD then
            return false
        end
        local energyCount = UserManager:getInstance().user:getEnergy()
        if energyCount > ENERGY_THRESHOLD then
            return false
        end
        if IosPayGuide:isInFCashPromotion() then 
            return false
        end
        if IosPayGuide:hasOneYuanShopPanelPopped() then
            return false
        end
        return true
    end
end

function IosPayGuide:getOneYuanFCashLeftSeconds()
    local config = readConfig()
    local endTime = tonumber(config.oneYuanFCashEndTime) or 0
    return endTime - now()
end

function IosPayGuide:getOneYuanShopLeftSeconds()
    local config = readConfig()
    local endTime = tonumber(config.oneYuanShopEndTime) or 0
    return endTime - now()
end

function IosPayGuide:tryPopFailGuidePanel(cartoonCloseCallback)
    local config = readConfig()
    if config.failGuidePanelPopped then
        return false
    end
    if UserManager:getInstance().userExtend.payUser then
        return false
    end
    IosPayFailGuidePanel:create(cartoonCloseCallback):popout()
    config.failGuidePanelPopped = true
    writeConfig(config)
    return true
end

function IosPayGuide:maintenanceEnabled()
    local config = readConfig()
    local oldValue = config.isEnabled
    local newValue = MaintenanceManager:getInstance():isEnabled("IosOneYuanPay")
    -- local newValue = true
    if oldValue == false and newValue == true and _G.kUserLogin then
        IosPayGuide:onEnableByMaintenance()
    elseif oldValue == true and newValue == false and _G.kUserLogin then
        IosPayGuide:onDisableByMaintenance()
    end
    return newValue
    -- return true -- test
end

function IosPayGuide:isInAppleVerification()
    return MaintenanceManager:getInstance():isEnabled("AppleVerification")
end

function IosPayGuide:onEnableByMaintenance()
    local config = readConfig()
    config.isEnabled = true
    config._hasTriggeredOneYuanShop = false
    config._hasTriggeredFCash = false
    config.oneYuanShopStartTime = 0
    config.oneYuanShopEndTime = 0
    config.oneYuanFCashStartTime = 0
    config.oneYuanFCashEndTime = 0
    writeConfig(config)
end

function IosPayGuide:onDisableByMaintenance()
    local config = readConfig()
    config.isEnabled = false
    config._hasTriggeredOneYuanShop = false
    config._hasTriggeredFCash = false
    config.oneYuanShopStartTime = 0
    config.oneYuanShopEndTime = 0
    config.oneYuanFCashStartTime = 0
    config.oneYuanFCashEndTime = 0
    writeConfig(config)
end

function IosPayGuide:hasTriggeredFCash()
    return readConfig()._hasTriggeredFCash
end

function IosPayGuide:hasTriggeredOneYuanShop()
    return readConfig()._hasTriggeredOneYuanShop
end