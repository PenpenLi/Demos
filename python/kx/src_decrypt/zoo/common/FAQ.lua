FAQ = {}

function FAQ:getParams()
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
    elseif __IOS then 
        network = Reachability:getNetWorkTypeName()
    end
    parameters["network"] = network

    parameters["vip"] = 0
    parameters["src"] = "client"
    parameters["lang"] = "zh-Hans"

    parameters["pf"] = StartupConfig:getInstance():getPlatformName() or ""
    parameters["uuid"] = _G.kDeviceID or ""

    local user = UserManager:getInstance().user
    local profile = UserManager.getInstance().profile
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
    if profile and profile:haveName() then
        name = profile:getDisplayName()
    end
    parameters["name"] = name
    parameters["ver"] = _G.bundleVersion
    parameters["ts"] = os.time()
    parameters["ext"] = ""
    local roleId = UserManager.getInstance().inviteCode or ""
    parameters["roleid"] = tostring(roleId)
    local headUrl = "1"
    if profile and profile.headUrl then
        headUrl = profile.headUrl
    end
    parameters["roleavatar"] = headUrl

    local paramKeys = {}
    for k, v in pairs(parameters) do
        table.insert(paramKeys, k)
    end
    table.sort(paramKeys)
    local md5Src = ""
    for _, v in pairs(paramKeys) do
        md5Src = md5Src..tostring(parameters[v])
    end
    local sig = HeMathUtils:md5(md5Src .. secret)
    -- calc sig
    parameters["sig"] = sig
    return parameters
end

function FAQ:getUrl( url,params )
    params = params or self:getParams()

    local qs = {}
    for k,v in pairs(params) do
         table.insert(qs,k .. "=" .. HeDisplayUtil:urlEncode(tostring(v)))
    end

    if string.find(url,"%?") then
        return url .. "&" .. table.concat(qs,"&")
    else
        return url .. "?" .. table.concat(qs,"&")        
    end
end