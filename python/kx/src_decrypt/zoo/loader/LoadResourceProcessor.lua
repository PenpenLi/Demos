local Processor = class(EventDispatcher)

function Processor:start(statusLabel, statusLabelShadow, progressBar)
    local loader = FrameLoader.new()
    for i,v in ipairs(ResourceConfig.json) do loader:add(v, kFrameLoaderType.json) end
    for i,v in ipairs(ResourceConfig.plist) do loader:add(v, kFrameLoaderType.plist) end
    for i, v in ipairs(ResourceConfig.skeleton) do loader:add(v, kFrameLoaderType.skeleton) end
    for i, v in ipairs(ResourceConfig.mp3) do loader:add(v, kFrameLoaderType.mp3) end
    for i, v in ipairs(ResourceConfig.sfx) do loader:add(v, kFrameLoaderType.sfx) end

    if __WP8 then
        for i, v in ipairs(ResourceConfig.asyncPlist) do loader:add(v, kFrameLoaderType.plist) end
    end

    local startTime = os.clock()
    DcUtil:up(120)
    local function onLoadingDc()
        DcUtil:up(122)
    end
    local funcId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onLoadingDc, 30, false)
    local function onFrameLoadComplete( evt )
        loader:removeAllEventListeners()
        local endTime = os.clock()
        print("load resource done, total time:", endTime - startTime)

        ResourceManager:sharedInstance():loadNeededJsonFiles()

        if WorldSceneShowManager:isInAcitivtyTime() then 
            if not WorldSceneShowManager:getHasPlaySpringMusic() then 
                GamePlayMusicPlayer:getInstance():playSpringBgMusic()
                setTimeOut(function ()
                    WorldSceneShowManager:setHasPlaySpringMusic(true)
                    GamePlayMusicPlayer:getInstance():playWorldSceneBgMusic()
                end, 9)
            else
                GamePlayMusicPlayer:getInstance():playWorldSceneBgMusic()
            end
        else
            GamePlayMusicPlayer:getInstance():playWorldSceneBgMusic()
        end
        
        statusLabel:setVisible(false)
        statusLabelShadow:setVisible(false)
        if funcId ~= nil then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(funcId) end
        DcUtil:up(130)

        progressBar:removeFromParentAndCleanup(true)

        self:dispatchEvent(Event.new(Events.kComplete, nil, self))
    end 
    local function onFrameLoadProgress( evt )
        local progress = loader.loaded / loader:getLength()
        progressBar:setPercentage(progress)
    end 
    loader:addEventListener(Events.kComplete, onFrameLoadComplete)
    loader:addEventListener(Events.kProgress, onFrameLoadProgress)
    loader:load()

    local tipIndex = math.floor(math.random() * 12)
    local tipKey = tostring(tipIndex)
    if tipIndex < 10 then tipKey = "0" .. tipKey end
    statusLabel:setString(Localization:getInstance():getText("loading.tips.text"..tipKey))
    statusLabelShadow:setString(Localization:getInstance():getText("loading.tips.text"..tipKey))

    if __IOS_QQ then
        -- get maintenance config
        local function onRequestFinish()
            print("MaintenanceManager:initialize - onRequestFinish")
            local ad = AdvertiseSDK:presentFishbowlAD()
            local scene = Director:sharedDirector():getRunningScene()
            if ad and scene then scene:addChild(ad) end
        end
        MaintenanceManager.getInstance():initialize(onRequestFinish)
        
    elseif not PlatformConfig:hasAuthConfig(PlatformAuthEnum.kPhone) then
        MaintenanceManager.getInstance():initialize() --取手机登录配置
    end
end

return Processor