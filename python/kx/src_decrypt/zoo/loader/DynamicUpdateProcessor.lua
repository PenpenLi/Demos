local Processor = {}

local function startGame(afterUpdate)
    if afterUpdate then
        if Processor.successCallback and type(Processor.successCallback) == 'function' then 
            Processor.successCallback() 
        end   
    else
        if Processor.failCallback and type(Processor.failCallback) == 'function' then 
            Processor.failCallback() 
        end   
    end
end

local function parseDynamicNameValuePair( item, target )
    if item ~= nil and item ~= "" then
        local list = string.split(item, ":")
        if list and #list == 2 then
            target[list[1]] = list[2]
        end
    end
end
local function parseDynamicUserData( userdata )
    local result = {}
    if userdata ~= nil and userdata ~= "" then
        local list = string.split(userdata, ";")
        if list and #list > 0 then
            for i,v in ipairs(list) do
                parseDynamicNameValuePair( v, result )
            end
        else
            parseDynamicNameValuePair( userdata, result )
        end
    end
    return result
end

function Processor:checkDynamicLoadRes()
    print("checkDynamicLoadRes")
    local haveNetwork = false
    local kDynamicUpdateTimeout = 10

    if __IOS then
        local reachability = Reachability:reachabilityForInternetConnection()
        if reachability:currentReachabilityStatus() ~= 0 then haveNetwork = true end
    elseif __ANDROID then 
        haveNetwork = true 
    elseif __WP8 then 
        haveNetwork = true 
    end

    local kMaxDynamicResource = 1024 * 300
    local kSkipDynamicResource = 1024 * 500
    if haveNetwork and enableSilentDynamicUpdate and not PrepackageUtil:isPreNoNetWork() then
        local function onResourceLoaderCallback( event, data )
            print("onResourceLoaderCallback")
            if event == ResCallbackEvent.onPrompt then 
                print("event == ResCallbackEvent.onPrompt")
                local needsize = 0
                local userdata = nil
                if data and data.status then 
                    needsize = data.status.needDownloadSize or 0 
                    userdata = data.status.userdata 
                end
                local config = parseDynamicUserData(userdata)
                local force = false
                local review = false
                if config then 
                    force = config["force"] == "1"
                    review = config["review"] == "1"
                end
                print("require silent dynamic loading"..table.tostring(config))
                print("needsize of dynamic update" .. tostring(needsize))
                local canUpdate = false
                if needsize > 0 then
                    if review then
                        canUpdate = true
                    elseif needsize < kMaxDynamicResource then
                        canUpdate = true
                    elseif needsize < kSkipDynamicResource then
                        if force then canUpdate = true end
                    end
                end
                print("silent dynamic update permit: " .. tostring(canUpdate))
                if canUpdate then
                    data.resultHandler(1)
                else
                    data.resultHandler(0)
                end
            elseif event == ResCallbackEvent.onSuccess then 
                print("event == ResCallbackEvent.onSuccess")
                print("silent load res success")
                startGame(true)
            elseif event == ResCallbackEvent.onProcess then
                print("event == ResCallbackEvent.onProcess")            
                self:updateUIOnDownloading(data.status, data.curSize, data.totalSize)
            elseif event == ResCallbackEvent.onError then 
                print("event == ResCallbackEvent.onError")
                startGame(false)
                he_log_warning("silent load res error, errorCode: " .. tostring(data.errorCode) .. ", item: " .. tostring(data.item))
            end
            print("~onResourceLoaderCallback")
        end
        print("ResourceLoader.loadRequiredResWithPrompt(onResourceLoaderCallback)")
        ResourceLoader.loadRequiredResWithPrompt(onResourceLoaderCallback, true)
        print("~ResourceLoader.loadRequiredResWithPrompt(onResourceLoaderCallback)")
    else 
        print("else startGame()")
        startGame(false) 
        print("~else startGame()")
    end

    print("~checkDynamicLoadRes")
    --DO NOT use timeout. otherwise after lua updated, require restart game.
    --setTimeOut(startGame, kDynamicUpdateTimeout) 
end


local function addSpriteFramesWithFile( plistFilename, textureFileName )
    local prefix = string.split(plistFilename, ".")[1]
    local realPlistPath = plistFilename
    local realPngPath = textureFileName
    if __use_small_res then  
        realPlistPath = prefix .. "@2x.plist"
        realPngPath = prefix .. "@2x.png"
    end
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(realPlistPath, realPngPath)
    return realPngPath, realPlistPath
end

function Processor:addForCuccwo(parent)
    if StartupConfig:getInstance():getPlatformName() == "cuccwo" then 
        self.cuccwoPng = addSpriteFramesWithFile( "materials/cuccwo.plist", "materials/cuccwo.png" )
        local cuccwo = CCSprite:createWithSpriteFrameName("cuccwo10000")
        cuccwo:setPosition(ccp(720,920))
        parent:addChild(cuccwo)
    end
end

local function getSysMemInfo()
    local msg = ""
    if __ANDROID then
        msg = luajava.bindClass("com.happyelements.hellolua.MainActivity"):getMemoryInfo()
    elseif __IOS then 

    end
    return msg
end

function Processor:buildStartupUI()
    print("buildStartupUI")
    local scene = CCScene:create()
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local origin = CCDirector:sharedDirector():getVisibleOrigin()
    local logoPng = addSpriteFramesWithFile( "materials/logo.plist", "materials/logo.png" )
    local logoTexture = CCTextureCache:sharedTextureCache():textureForKey("materials/logo.png")
    if not logoTexture then
        he_log_error(getSysMemInfo() .. " cache logo not found...")
    end
    local logo = CCSprite:createWithSpriteFrameName("logo.png")
    self:addForCuccwo(logo)
    local logoSize = logo:getContentSize()
    local scale = winSize.height/logoSize.height
    logo:setScale(scale)
    logo:setPosition(ccp(winSize.width/2, winSize.height/2 + origin.y))
    scene:addChild(logo)

    local statusLabel = CCLabelTTF:create("", "Helvetica", 26, CCSizeMake(winSize.width - 100, 120), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
    statusLabel:setColor(ccc3(255, 255, 255))
    statusLabel:setPosition(ccp(winSize.width/2, origin.y + 100))
    HeDisplayUtil:enableShadow(statusLabel, CCSizeMake(2, -2), 1, 1, true)
    scene:addChild(statusLabel)
    self.statusLabel = statusLabel

    CCDirector:sharedDirector():runWithScene(scene)
    Processor.scene = scene

    print("~buildStartupUI")
end

function Processor:updateUIOnDownloading(status, curSize, totalSize)
    print("dynamic onProcess")
    print("status: " .. status .. " progress: " .. curSize .. " / " .. totalSize)
    if status and type(status) == "number" then
        -- status define @see also ResLoadStatus.h
        if status == 1 then
            self.statusLabel:setString("正在检查版本信息")
        elseif status >= 2 then
            if curSize and totalSize and type(curSize) == "number" and type(totalSize) == "number" and totalSize > 0 then
                local percentage = 100 * curSize / totalSize
                local formatPercentage = string.format("%d", percentage) .. "%"
                print(formatPercentage)
                self.statusLabel:setString("少量配置更新中：" .. tostring(formatPercentage))
            end
        end
    end
end

function Processor:start(successCallback, failCallback)
    self.successCallback = successCallback
    self.failCallback = failCallback 
    self:buildStartupUI()

    local function checkDynamicLoadRes()
        self:checkDynamicLoadRes()
    end

    Processor.scene:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.02), CCCallFunc:create(checkDynamicLoadRes)))
end

return Processor
