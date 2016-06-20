local AliQuickPayGuide = require "zoo.panel.alipay.AliQuickPayGuide"

AliAppSignAndPayLogic = class()

local instance = nil
function AliAppSignAndPayLogic:getInstance()
    if not instance then
        instance = AliAppSignAndPayLogic.new()
        instance:init()
    end
    return instance
end

function AliAppSignAndPayLogic:init()

end

function AliAppSignAndPayLogic:start(platform, tradeId, goodsId, goodsType, num, goodsName, total_fee, signStr, successCallback, failCallback, cancelCallback)
    -- print(debug.traceback())
    -- 进入方式只能是风车币商店或者游戏内购买道具
    -- 1:风车币商店 
    -- 2:设置选择支付方式 （这里t4无效） 
    -- 3:1元特价 （关卡内非一元特价道具处签约，t3的值默认+1） 
    -- 4:游戏内购买道具 
    -- 6:1分购
    local entryType = 4
    if goodsType == 2 then
        entryType = 1
    end
    local defaultPayment = PaymentManager:getInstance():getDefaultPayment()
    local userType = 4
    
    if defaultPayment == Payments.ALIPAY then
        userType = 2
    elseif defaultPayment == Payments.WECHAT then
        userType = 3
    elseif defaultPayment ~= Payments.UNSUPPORT 
        and (table.exist(PlatformPaymentChinaMobileEnum, defaultPayment) 
        or table.exist(PlatformPaymentChinaUnicomEnum, defaultPayment)
        or table.exist(PlatformPaymentChinaTelecomEnum, defaultPayment)) then
        userType = 1
    end
    local paraT1 = entryType * 10 + userType

    local popoutTimes = AliQuickPayGuide.getPopoutTimes() + 1
    if not AliQuickPayGuide:isGuideTime() and entryType == 1 then
        popoutTimes = 4
    elseif entryType == 4 then -- 因为提前加了1
        popoutTimes = popoutTimes - 1
    end

    self.dcPara = {t1 = paraT1, t2 = popoutTimes}



    DcUtil:UserTrack({ category='alipay_mianmi_accredit', sub_category = 'app_enter', t1 = self.dcPara.t1, t2 = self.dcPara.t2})
    print(string.format('wenkan AliAppSignAndPayLogic:start %s %s %d %d %d %s %f %s', platform, tradeId, goodsId, goodsType, num, goodsName, total_fee, signStr))
    self.platform = platform
    self.tradeId = tradeId
    self.goodsId = goodsId
    self.goodsType = goodsType
    self.num = num
    self.subject = goodsName
    self.total_fee = total_fee
    self.checkStr = signStr
    self.successCallback = successCallback
    self.failCallback = failCallback
    self.cancelCallback = cancelCallback

    local host = NetworkConfig.dynamicHost
    if isLocalDevelopMode then -- 测试dev服务器地址
        host = 'http://well.happyelements.net/mobilepay/'
    end

    local notify_url = host..'payment/alicreateandpay'
    local return_url = 'happyanimal3://aliapp_return/redirect'
    local scene = 'INDUSTRY|GAME_CHARGE'
    local externalAgreementNo = UserManager:getInstance().uid or '12345'
    local agreement_sign_parameters = '{"productCode":"GENERAL_WITHHOLDING_P","scene":"'..scene..'","externalAgreementNo":"'..externalAgreementNo..'","notifyUrl":"'..notify_url..'"}'
    local _input_charset = 'UTF-8'
    local partner = '2088611544007134'
    local product_code = 'GENERAL_WITHHOLDING'
    local request_from_url = 'happyanimal3://aliapp_return/redirect'
    local notifyUrl = host..'payment/alicreateandpay'
    local notify_url = notify_url
    local service = 'alipay.acquire.page.createandpay'
    local seller_id = '2088611544007134'
    local integration_type = 'ALIAPP'
    local sign_type = 'MD5'
    local params = {
        _input_charset = _input_charset,
        partner = partner,
        product_code = product_code,
        agreement_sign_parameters = agreement_sign_parameters,
        scene = scene,
        request_from_url = request_from_url, 
        notify_url = notify_url,
        service = service,
        seller_id = seller_id,
        integration_type = integration_type,
        return_url = return_url,
        out_trade_no = self.tradeId,
        subject = tostring(self.subject),
        total_fee = tostring(self.total_fee),
    }
    if isLocalDevelopMode then
        params.total_fee = '0.01'
    end


    local function onRequestFinish(event)
        print('AliAppSignAndPayLogic onRequestFinish')

        self.isChecked = false
        
        local sign = tostring(event.data.signedString)
        local paraString = self:getParamString(params)
        paraString = paraString ..string.format('&sign=%s&sign_type=%s', sign, sign_type)
        paraString = 'https://mapi.alipay.com/gateway.do?'..paraString
        print('wenkan ', paraString)
        paraString = HeDisplayUtil:urlEncode(paraString)
        paraString = 'alipays://platformapi/startapp?appId=20000067&url='..paraString
        if __ANDROID then

            -- local txt = {tip = Localization:getInstance():getText("ali.app.sign.pay.panel.tip"), 
            --             yes = Localization:getInstance():getText("ali.app.sign.pay.panel.success"),
            --             no = Localization:getInstance():getText("ali.app.sign.pay.panel.fail")}
            -- local function yesCallback()                
            --     if self.successCallback then
            --         local scene = Director:sharedDirector():getRunningScene()
            --         if scene then
            --             scene:runAction(CCCallFunc:create(self.successCallback))
            --         else
            --             self.successCallback()
            --         end
            --         self:resetCallbacks()
            --     end
            -- end
            -- self.confirmPanel = CommonTipWithBtn:showTip(txt, 2, yesCallback, yesCallback)

            local function startActivity()
                self.waitingAliApp = true

                local MainActivityHolder = luajava.bindClass('com.happyelements.android.MainActivityHolder')
                local Intent = luajava.bindClass('android.content.Intent')
                local Uri =  luajava.bindClass('android.net.Uri') 
                local intent = luajava.newInstance('android.content.Intent')
                intent:setAction(Intent.ACTION_VIEW);
                intent:setData(Uri:parse(paraString))
                local context = MainActivityHolder.ACTIVITY:getContext()
                context:startActivity(intent)
            end
            if not pcall(startActivity) then
                if self.failCallback then
                    self.failCallback(tonumber(event.data or 0))
                end
                self:resetCallbacks()
            end
        end
    end
    local function onRequestError(event)
        print('AliAppSignAndPayLogic onRequestError')
        if self.failCallback then
            self.failCallback(tonumber(event.data or 0))
        end
        DcUtil:UserTrack({ category='alipay_mianmi_accredit', sub_category = 'app_result', result = 3, t1 = self.dcPara.t1, t2 = self.dcPara.t2})
    end
    local function onRequestCancel()
        print('AliAppSignAndPayLogic onRequestCancel')
        if self.cancelCallback then
            self.cancelCallback()
        end
        DcUtil:UserTrack({ category='alipay_mianmi_accredit', sub_category = 'app_result', result = 0, t1 = self.dcPara.t1, t2 = self.dcPara.t2})
    end

    local doOrderHttp = DoAliOrderHttp.new(true)
    doOrderHttp:addEventListener(Events.kComplete, onRequestFinish)
    doOrderHttp:addEventListener(Events.kError, onRequestError)
    doOrderHttp:addEventListener(Events.kCancel, onRequestCancel)
    doOrderHttp:load(self.platform, self.checkStr, self.tradeId, self.goodsId, self.goodsType, self.num,
        self.subject, self.total_fee, self:getSignString(params))

    GlobalEventDispatcher:getInstance():addEventListener(kGlobalEvents.kAliSignAndPayReturn, function (event) self:onAliAppReturn(event.data.url) end)


    if AliQuickPayGuide.isGuideTime() then
        AliQuickPayGuide.updateGuideTimeAndPopCount()
    end
end

function AliAppSignAndPayLogic:getSignString(params)
    -- 按字母顺序a-z排序
    local function sortFunc(v1, v2)
        local minLen = math.min(string.len(v1), string.len(v2))
        for i = 1, minLen do
            local byte1 = string.byte(v1, i)
            local byte2 = string.byte(v2, i)
            if byte1 < byte2 then
                return true
            elseif byte1 > byte2 then
                return false
            end
        end
        return false
    end
    local sortedParams = {}
    for k, v in pairs(params) do
        table.insert(sortedParams, k..'='..v)
    end
    table.sort(sortedParams, sortFunc)

    local signString = ""
    for k, v in pairs(sortedParams) do
        signString = signString..v.."&"
    end
    signString = string.sub(signString, 1, -2)
    return signString
end

function AliAppSignAndPayLogic:getParamString(params)
    local paraString = ""
    for k, v in pairs(params) do
        paraString = paraString..k..'='..HeDisplayUtil:urlEncode(v).."&"
    end
    paraString = string.sub(paraString, 1, -2)
    return paraString
end

function AliAppSignAndPayLogic:isWaitingAliApp()
    return self.waitingAliApp
end

function AliAppSignAndPayLogic:onAliAppReturn(url)
    if not url then return end
    local params = UrlParser:parseUrlScheme(url)
    print('onAliAppReturn ', url)

    local scene = Director:sharedDirector():getRunningScene()
    if params and params.para and params.para.is_success == tostring("T") then
        print('AliAppSignAndPayLogic:onAliAppReturn successCallback')
        if self.successCallback then
            if scene then
                scene:runAction(CCCallFunc:create(self.successCallback))
            else
                self.successCallback()
            end
        else
            if scene then
                scene:runAction(CCCallFunc:create(function () CommonTip:showTip(localize('ali.app.sign.pay.return.tip.success'), 'positive', nil, 3) end))
            end
        end
        self:resetCallbacks()
        DcUtil:UserTrack({ category='alipay_mianmi_accredit', sub_category = 'app_result', result = 2, t1 = self.dcPara.t1, t2 = self.dcPara.t2})
    elseif params and params.para and params.para.is_success == tostring("F") then
        print('AliAppSignAndPayLogic:onAliAppReturn failCallback')
        if self.failCallback then
            if scene then
                scene:runAction(CCCallFunc:create(self.failCallback))
            else
                self.failCallback()
            end
        else
            if scene then
                scene:runAction(CCCallFunc:create(function () CommonTip:showTip(localize('ali.app.sign.pay.return.tip.fail'), 'negative', nil, 3) end))
            end
        end
        self:resetCallbacks()
        DcUtil:UserTrack({ category='alipay_mianmi_accredit', sub_category = 'app_result', result = 3, t1 = self.dcPara.t1, t2 = self.dcPara.t2})
    else
        print('AliAppSignAndPayLogic:onAliAppReturn cancelCallback')
        if self.cancelCallback then
            print('AliAppSignAndPayLogic:onAliAppReturn cancelCallback222222')
            if scene then
                scene:runAction(CCCallFunc:create(self.cancelCallback))
            else
                self.cancelCallback()
            end
        end
        self:resetCallbacks()
        DcUtil:UserTrack({ category='alipay_mianmi_accredit', sub_category = 'app_result', result = 0, t1 = self.dcPara.t1, t2 = self.dcPara.t2})
    end
end


function AliAppSignAndPayLogic:resetCallbacks()
    self.successCallback = nil
    self.failCallback = nil
    self.cancelCallback = nil
    GlobalEventDispatcher:getInstance():removeEventListenerByName(kGlobalEvents.kAliSignAndPayReturn)
    -- self.isChecked = false
    self.waitingAliApp = false
    _G.use_ali_quick_pay = false
end

function AliAppSignAndPayLogic:isMaintenaceEnabled()
    local maintenacenOk = MaintenanceManager:getInstance():isEnabled('AliSignAndPay')
    return maintenacenOk
end

function AliAppSignAndPayLogic:isEnabled()

    -- 支付宝促销期间，不适用app签约
    if AliQuickPayPromoLogic:isEntryEnabled() then
        return false
    end
    local isInstalled = false
    if __ANDROID then
        local function safeCheck()
            print('wenkan safeCheck')
            he_log_info('wenkan safeCheck')
            local MainActivityHolder = luajava.bindClass("com.happyelements.android.MainActivityHolder")
            -- local PackageManager = luajava.bindClass("android.content.pm.PackageManager")
            local context = MainActivityHolder.ACTIVITY
            local packageManager = context:getPackageManager()
            local info = packageManager:getPackageInfo('com.eg.android.AlipayGphone', 64)
            print('wenkan getInfo OK ', info)

            -- if info then
            --     he_log_info('wenkan getInfo OK')
            --     if info.applicationInfo then
            --         he_log_info('wenkan applicationInfo ok')
            --         if info.applicationInfo.enabled then
            --             he_log_info('wenkan applicationInfo.enabled ok')
            --         end
            --     end
            -- end
            if info ~= nil and info.applicationInfo and info.applicationInfo.enabled then
                isInstalled = true
            end
        end
        -- he_log_info('wenkan is android')
        local ret = pcall(safeCheck)
        -- safeCheck()
        -- he_log_info('wenkan pcall '..tostring(ret))
    end
    local maintenacenOk = MaintenanceManager:getInstance():isEnabled('AliSignAndPay')
    print('wenkan maintenacenOk ', maintenacenOk, 'isInstalled', isInstalled, '_G.use_ali_quick_pay ', _G.use_ali_quick_pay)
    -- he_log_info('wenkan maintenacenOk '..tostring(maintenacenOk)..' isInstalled '..tostring(isInstalled)..'_G.use_ali_quick_pay '..tostring(_G.use_ali_quick_pay))
    return maintenacenOk and isInstalled and _G.use_ali_quick_pay
end