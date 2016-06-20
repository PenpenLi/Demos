-- Filename: ShowLogoUI.lua
-- Author: fang
-- Date: 2013-11-06
-- Purpose: 该文件用于显示平台要求的logo
-- modified: 
--[[
2016-01-08, zhangqi, 上线版本要去掉线下显示版本号的白屏，为了避免显示选服登录界面前不出现黑屏，
需要把添加LOGO的logoLayer保留到选服登录界面创建好之后才能删除，由LayerManager.removeLogoLayer控制
--]]

module("ShowLogoUI", package.seeall)

local function fnEnterLogin( ... )
    -- 进入更新检查模块
    LoginHelper.initMainApp()

    -- require "script/module/login/NewLoginCtrl"
    -- NewLoginCtrl.create()

end

local imageTable = {
        Android_91          = "platform/logo/91_android.png",
        Android_az          = "platform/logo/anzhi_logo.png",
        Android_dl          = "platform/logo/dangle_logo.jpg",
        Android_pps         = "platform/logo/pps_logo.png",
       Android_youmi       = "platform/logo/youmi_logo.png",
       Android_sogou       = "platform/logo/sogou_logo.png",
       Android_muzhiwan    = "platform/logo/muzhiwan_logo.jpg",
       Android_4399        = "platform/logo/4399_logo.png",
       Android_yygame      = "platform/logo/yygame.png",
       Android_pptv        = "platform/logo/pptv_logo.jpg",
       -- Android_zhongshouyou= "platform/logo/zsy_logo.jpg"
       Android_dianxin     = "platform/logo/ck_dianxin_logo.jpg",
       Android_yyh         = "platform/logo/yyh_logo.png",
       Android_cw          = "platform/logo/zsy_logo.png",
       Android_jrtt        = "platform/logo/jrtt_logo.jpg",
       Android_cczhushou   = "platform/logo/cczs_logo.png",
}

function showLogoUI( ... )
    -- if g_system_type == kBT_PLATFORM_ANDROID then
    --     jit.off()--关闭luajit
    -- end

	require "platform/Platform"
	Platform.initSDK()
    local needPlatformLogo = false
    local plName = Platform.getPlatformFlag()
    local logoName = imageTable[plName]
    if(logoName ~= nil)then
        needPlatformLogo = true
    end

    local uiLayer = LayerManager.getUIGroup()
    local logoLayer = CCLayerColor:create(ccc4(255, 255, 255, 255))
    local btLogo = createLogoByName("platform/logo/zsy_logo.png")
    setAllScreenNode(btLogo)
    local fristLogo, secondLogo
    fristLogo = btLogo
    local platformLogo=nil
   
    if(needPlatformLogo)then
        if logoName ~= nil then 
            platformLogo = createLogoByName(logoName)
        end
       
        if(scaleFunction == nil)then
            scaleFunction = setAllScreenNode
        end
        
        if(plName == "Android_dl")then
            scaleFunction = setAllScreenNode
        end
        if(plName == "Android_muzhiwan")then
            scaleFunction = setAllScreenNode
        end
        if(plName == "Android_pps" or plName == "Android_youmi" or plName == "Android_sogou" ) then
            fristLogo = platformLogo
            secondLogo = nil
            needPlatformLogo = false
            fristLogo:setVisible(true)
        else
            fristLogo = btLogo
            secondLogo = platformLogo
        end
        -- SDK自带闪屏，并且logo文件中有闪屏的渠道
        if (plName == "Android_dianxin") then
            fristLogo = platformLogo
            secondLogo = nil
            needPlatformLogo = false
            fristLogo:setVisible(true)
        end
        if (plName == "Android_yyh" or plName == "Android_cw") then
            fristLogo = nil
            secondLogo = nil
            needPlatformLogo = false
            --fristLogo:setVisible(true)
        end
        if(plName == "Android_baidu")then
            fristLogo = nil
            secondLogo = btLogo
            needPlatformLogo = false
            fristLogo:setVisible(true)
        end
        if(plName == "Android_uc")then
            fristLogo = nil
            secondLogo = btLogo
            needPlatformLogo = false
            fristLogo:setVisible(true)
        end
        scaleFunction(platformLogo)

        if(secondLogo)then
            secondLogo:setVisible(false)
        end
    end
    print(plName)
    if (not fristLogo and not secondLogo ) or plName == "IOS_APPSTORE_CHW" then
        fnEnterLogin()
        return
    end

    --ios不显示 CardPirate logo
    -- local plTarget = CCApplication:sharedApplication():getTargetPlatform()
    -- if plTarget == kTargetIphone or plTarget == kTargetIpad then
    --     if(not needPlatformLogo)then
    --         fnEnterLogin()
    --         return
    --     end
    --     print("platformLogo",platformLogo)
        
    --     fristLogo = platformLogo
    --     secondLogo = nil
    --     fristLogo:setVisible(true)
    --     needPlatformLogo = false
    -- end
    
    if(fristLogo)then
        print("fristLogo",fristLogo)
        logoLayer:addChild(fristLogo)
    end
    if(secondLogo)then
        logoLayer:addChild(secondLogo)
    end
    -- fristLogo:setOpacity(0)

    uiLayer:addChild(logoLayer, 99999, 11118888)
    function getAction( fun )
        function removeSelf(node)
            -- node:removeFromParentAndCleanup(true)
            print("removeSelf")
        end
        local actionArray = CCArray:create()
        actionArray:addObject(CCFadeIn:create(0.3))
        actionArray:addObject(CCDelayTime:create(2))
        -- actionArray:addObject(CCFadeOut:create(0.3))
        -- actionArray:addObject(CCCallFuncN:create(removeSelf))
        actionArray:addObject(CCCallFunc:create(function ( ... )
            fun()
        end))
        return actionArray
    end
    
    local fun = function( ... )
        if(needPlatformLogo == false)then
            -- logoLayer:removeFromParentAndCleanup(true)
            fnEnterLogin()
        else
            local platformAction = getAction(function( ... )
                -- logoLayer:removeFromParentAndCleanup(true)
                fnEnterLogin()
            end)
            if(secondLogo)then
                secondLogo:setVisible(true)
                local seq = CCSequence:create(platformAction)
                secondLogo:runAction(seq)
            end
        end
    end
    local btAction = getAction(fun)
    local seq = CCSequence:create(btAction)
    fristLogo:runAction(seq)
end

function createLogoByName( l_name )
    local winSize = CCDirector:sharedDirector():getWinSize()
    local logo    = CCSprite:create(l_name)
    logo:setAnchorPoint(ccp(0.5, 0.5))
    logo:setPosition(ccp(winSize.width/2, winSize.height/2))

    return logo
end

function setAdaptNode( node )
        -- 设备可视化size
    g_winSize = CCDirector:sharedDirector():getVisibleSize()
    -- 设备可视起始坐标
    g_origin = CCDirector:sharedDirector():getVisibleOrigin()

    -- 项目美术资源原始设备size
    g_originalDeviceSize = {width=640, height=960}

    -- X轴伸缩比
    g_fScaleX = g_winSize.width/g_originalDeviceSize.width
    -- Y轴伸缩比
    g_fScaleY = g_winSize.height/g_originalDeviceSize.height

    if g_fScaleX > g_fScaleY then
        g_fElementScaleRatio = g_fScaleY
        g_fBgScaleRatio = g_fScaleX
    else
        g_fElementScaleRatio = g_fScaleX
        g_fBgScaleRatio = g_fScaleY
    end

    node:setScale(g_fElementScaleRatio)
    return node
end

--设置当前节点拉伸到屏幕大小
--注意：此方法会使图片变形
function setAllScreenNode( node )
    g_winSize = CCDirector:sharedDirector():getVisibleSize()

    local  deviceHeith = g_winSize.height
    local  deviceWidth = g_winSize.width
    local scaleX =  deviceWidth/node:getContentSize().width
    local scaleY = deviceHeith/node:getContentSize().height
    local scale = scaleY;
    if(scaleX>scaleY)then
        scale = scaleX
    end
    node:setScaleX(scale)
    node:setScaleY(scale)
end



