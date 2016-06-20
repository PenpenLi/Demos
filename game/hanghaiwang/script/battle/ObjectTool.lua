module("ObjectTool",package.seeall)

function setProperties( target )
		 
	target.__instanceName					= BattleFactory.getInstaceName()
 	target.instanceName=function() return target.__instanceName end
    target.className=function() return target.__cname end
 

end

local spriteFreamCache = CCSpriteFrameCache:sharedSpriteFrameCache()
function getFrameSprite( frameName )
    
    local spCache = nil--ObjectSharePool.getObject(frameName)
    -- if(spCache == nil) then
        local frameData = spriteFreamCache:spriteFrameByName(frameName)
        -- 如果没有frame数据那么我们再加载一次,如果还没有,release版本就生成空sprite,debug版本直接报错
        if(frameData == nil) then
            spriteFreamCache:addSpriteFramesWithFile(BATTLE_CONST.ALL_WORDS_PLIST,BATTLE_CONST.ALL_WORDS_TEXTURE)
            spriteFreamCache:addSpriteFramesWithFile(BATTLE_CONST.BATTLE_UI_PLIST,BATTLE_CONST.BATTLE_UI_TEXTURE)
            frameData = spriteFreamCache:spriteFrameByName(frameName)
            if(g_debug_mode) then
                assert(frameData,"spriteFrame不存在:" .. frameName)
            end
        end
        local frameSprite   = CCSprite:create()
        if(frameData) then
            frameSprite:setDisplayFrame(frameData)
        end
        return frameSprite
    -- else
    --     return spCache
    -- end
    
    -- return nil
end



function getRandomWalkSoundName()
    return BATTLE_CONST.WALK_SOUND .. math.floor(math.random()*3+1)
end

-- 获取目标AABBBox(注意这个方法在遇到CCLayer等全屏容器的时候会不准,最好是只用在CCSprite等容器上)
function getTargetAABBBox( node )
        local boundingBox = require(BATTLE_CLASS_NAME.BaseBoundingBox).new()
        if(node) then
            local world = node:convertToWorldSpace(CCP_ZERO)
            local size  = node:getContentSize()
            local p     = node:getAnchorPoint()
            local scale = node:getScale()
            -- print("--- icon scale:",scale)
            -- boundingBox:iniWithData(world.x - p.x * size.width * scale,world.y - p.y * size.height * scale
            --                      ,size.width * scale ,size.height * scale)
            boundingBox:iniWithData(world.x ,world.y 
                                    ,size.width * scale ,size.height * scale)
        end
        return boundingBox  
    end

function countTable( target )
    local result = 0
    for k,v in pairs(target or {}) do
        if(v ~= nil) then
            result = result + 1
        end
    end

    return result
end
function check( target )
    if(target.__instanceName and target.instanceName and target.className) then 
        return true
    end
    return false
end
function playShakeWithStyle( shakeType )
    local stype = tonumber(shakeType)
    local shakeScreen = require("script/battle/action/BAForShakeScreen").new()
    shakeScreen.timeMode = false
    local flag = true

    if(stype == 1) then
        shakeScreen.minY = 1
        shakeScreen.range = 2
        shakeScreen.total = 8 -- * BATTLE_CONST.FRAME_TIME
    elseif(stype == 2) then
        shakeScreen.minY = 2
        shakeScreen.range = 6
        shakeScreen.total = 6 --* BATTLE_CONST.FRAME_TIME
    elseif(stype == 3) then
        shakeScreen.minY = 4
        shakeScreen.range = 8
        shakeScreen.total = 6 --* BATTLE_CONST.FRAME_TIME
    else
        -- print("-- wrong shakeType:",stype)
        flag = false
    end

    if(flag == true) then
        shakeScreen:start()
    else
        shakeScreen = nil
    end

end
function playShakeScreen( shakeTime )
    if(shakeTime == nil or shakeTime <= 0) then shakeTime = 0.6 end
    local shakeScreen = require("script/battle/action/BAForShakeScreen").new()
    shakeScreen.total = shakeTime
    shakeScreen:start()
end

-- 是否是活动副本呢
function isActiveCopy( copyid )
    return copyid >= 300001 and copyid < 400000
end

-- 是否是普通副本
function isNormalCopy( copyid)
--     1~100000    对应普通副本
-- 200000~210000 对应精英副本
    return copyid <= 100000
end

-- 是否是精英副本
function isEliteCopy( copyid)
--     1~100000    对应普通副本
-- 200000~210000 对应精英副本
    return copyid >= 200000 and copyid <= 210000
end


function length(startPoint,endPoint)
    assert(startPoint)
    assert(endPoint)
    local dx         = endPoint.x - startPoint.x
    local dy         = endPoint.y - startPoint.y
    local len        = math.sqrt(dx * dx + dy * dy)
    return len
end
function isOnStage( target )
    if(target ~= nil and not tolua.isnull(target) and target:getParent() ~= nil and target:retainCount() > 0) then
        return true
    end
    return false
end

function hasChild( target )
    if(target ~= nil and not tolua.isnull(target) and target:retainCount() > 0) then
        local childArray = target:getChildren()
        if(childArray ~= nil and childArray:count() > 0) then
            return true
        end
    end
    return false
end

function isBoxEmpyt(box)
    if(box == nil or box.minX == nil or box.minY == nil or box.maxX == nil or box.maxY == nil) then return true end
    return false
end

-- 获取指定ccnode的boundingBox
function getBoundingBox( target ,boundingBox)



    if(boundingBox == nil) then
        boundingBox = require(BATTLE_CLASS_NAME.BaseBoundingBox).new()
    end

    -- local world = target:convertToWorldSpace(ccp(target:getPositionX(),target:getPositionY()))
    local world = target:convertToWorldSpace(CCP_ZERO)
    local size  = target:getContentSize()

         
    boundingBox:iniWithData(world.x,world.y,size.width,size.height)
    return boundingBox      


    -- boundingBox:combineCCNodeToSelf(target)
    -- if(hasChild(target)== true) then
    --     local childArray = target:getChildren()
    --     for idx=1,childArray:count() do
    --         local childNode = tolua.cast(childArray:objectAtIndex(idx-1),"CCNode")
    --         boundingBox:combineCCNodeToSelf(childNode)
    --         print("-- combineBoxToSelf")
    --         boundingBox:debug()

    --         if(hasChild(childNode) == true) then
    --             getBoundingBox(childNode,boundingBox)
    --         end
    --     end
    -- end 
    -- return boundingBox
end
function removeAllChildren( target)
    -- removeAllChildren()
    if(target ~= nil and not tolua.isnull(target) and target:retainCount() > 0) then
        local cc = tolua.cast(target,"CCNode")

        if(cc) then
            -- print(" ===== removeAllChildren")
            cc:removeAllChildrenWithCleanup(true)
        end
        
        return true
    end
    return false

end
function removeObject( target ,notClean)
    -- print("removeObject",target ~= nil , not tolua.isnull(target) , target:getParent() ~= nil , target:retainCount() > 0)
    if(target ~= nil and not tolua.isnull(target) and target:getParent() ~= nil and target:retainCount() > 0) then

            if(notClean ~= true) then
                target:removeFromParentAndCleanup(true)
            else
                target:getParent():removeChild(target)
            end
        
        return true
    end
    return false
end
function getAnimation( animationName,loop,completeCall,loopSound)
        assert(animationName)

        local hasAnimation,imageURL,plistURL,url = checkAnimation(animationName)
        -- Logger.debug("hasAnimation:".. animationName .. " " ..tostring(hasAnimation))
        if(hasAnimation) then
             originalFormat = CCTexture2D:defaultAlphaPixelFormat()
             CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)
            -- local url                               = BattleURLManager.BATTLE_EFFECT .. animationName .. ".ExportJson"
            -- local plistURL                          = BattleURLManager.BATTLE_EFFECT .. animationName .. "0.plist"
            -- local imageURL                          = BattleURLManager.BATTLE_EFFECT .. animationName .. "0.pvr.ccz"

            -- CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(imageURL, plistURL ,url );
           
            local cache = ObjectSharePool.getObject(animationName)
            if(cache == nil) then
                BattleNodeFactory.registArmature(url,imageURL,plistURL)
                CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(imageURL, plistURL ,url )
                cache = CCArmature:create(animationName)
            end
            local animation = cache
            -- BattleSoundMananger.playEffectSound(animationName,true,loopSound)

            -- animation:setScale(g_fScaleX)
            animation:setScaleX(g_fScaleX)
            animation:setScaleY(g_fScaleX)
            -- local start,endPostion = string.find(animationName, 'effect')
            -- if(start and start>=1) then
            --      local start1,endPostion1 = string.find(animationName, 'heffect')
            --       if(start1 and start1>=1) then
            --             -- animation:setScale((BATTLE_CONST.ANIMATION_SCALE + 0.4))
            --             animation:setScale((BATTLE_CONST.ANIMATION_SCALE))
            --       else  
            --             -- start1,endPostion1 = string.find(animationName, 'beffect')
            --             -- animation:setScale((BATTLE_CONST.ANIMATION_SCALE + 0.2))
            --             animation:setScale((BATTLE_CONST.ANIMATION_SCALE))
            --       end
            -- else
            --     animation:setScale((BATTLE_CONST.ANIMATION_SCALE))
            -- end

            -- animation:setScaleX(g_fScaleX)
            -- animation:setScaleY(g_fScaleY)
            -- animation:setScale(g_fScaleX)
            if(completeCall ~= nil) then
                animation:getAnimation():setMovementEventCallFunc(completeCall)
            end
            if(loop) then
               animation:getAnimation():playWithIndex(0,0,-1,1)
            else
                animation:getAnimation():playWithIndex(0,-1,-1,0)
            end
            
            CCTexture2D:setDefaultAlphaPixelFormat(originalFormat)
            return animation
        else
            error("动画" .. tostring(animationName) .. "不全")
        end
      
     
end
function removeAnimationByName( animationName ,target , collect)
    local hasAnimation,imageURL,plistURL,url = checkAnimation(animationName)
    -- Logger.debug("url:".. url .. " hasAnimation:" .. tostring(hasAnimation))
 
    removeObject(target)
    if(hasAnimation) then
        CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(url)
    end

                        
    if(collect) then
        CCTextureCache:sharedTextureCache():removeUnusedTextures()
    end
     
end
function getOnceAnimation(animationName)
           
            local completeCall = function ( sender, MovementEventType )
                                        if (MovementEventType == EVT_COMPLETE) then
                                             BattleSoundMananger.removeSound(animationName)

                                            if(animation and animation:getParent() ~= nil and animation:retainCount() > 0) then
                                                animation:removeFromParentAndCleanup(true)
                                            end
                                            animation = nil

                                        end

                                end
             

            animation = getAnimation(animationName,false,completeCall)
            return animation
end
-- 获取粒子(会检测plist)
function getParticle( pName )
    assert(pName,"getParticle pName is nil")

    local plist = BattleURLManager.BATTLE_PARTICLE .. pName .. ".plist"
    -- local imgPNG = BattleURLManager.BATTLE_EFFECT .. animationName .. ".png"
    -- local imgPVR = BattleURLManager.BATTLE_EFFECT .. animationName .. ".pvr.ccz"
    -- local pimage  = 1
    if(not file_exists( plist )) then
         ObjectTool.showTipWindow( "Particle is not existes url:" .. plist , nil, false, nil)
         return false
    end 
    return  CCParticleSystemQuad:create(plist)
end

function checkAnimation( animationName )

    local shareName = db_shareTextureList_util.getShareName(animationName)
    if(shareName == nil or shareName == "") then
        shareName = animationName
    end
    local url                               = BattleURLManager.BATTLE_EFFECT ..  animationName .. ".ExportJson"       
    local pbRUL                             = BattleURLManager.BATTLE_EFFECT ..  animationName .. ".pb" 
          
    local plistURL                          = BattleURLManager.BATTLE_EFFECT .. shareName .. "0.plist"
    local imageURL                          = nil

    local imageURLCCZ                          = BattleURLManager.BATTLE_EFFECT .. shareName .. "0.pvr.ccz"
    local imageURLPNG                          = BattleURLManager.BATTLE_EFFECT .. shareName .. "0.png"
    local imageURLPVR                          = BattleURLManager.BATTLE_EFFECT .. shareName .. "0.pvr"
    local imageURLPKM                          = BattleURLManager.BATTLE_EFFECT .. shareName .. "0.pkm"
   

     if(not file_exists( url ) and not file_exists( pbRUL )) then
        ObjectTool.showTipWindow( "url:" .. url .. "," .. animationName .. ".ExportJson" .. " 不存在", nil, false, nil)
   
        -- print(animationName .. ".ExportJson" .. " 不存在")
        -- print(debug.traceback())
        -- print("===========================================================")
        return false
    else
        if(file_exists( pbRUL )) then
            url = pbRUL
        end
    end
    
    if(not file_exists( plistURL )) then
        ObjectTool.showTipWindow( animationName .. "0.plist" .. " 不存在", nil, false, nil)
        return false
    end
    local imageExits = false
    -- Logger.debug("g_system_type:" + g_system_type)
    --and g_system_type == "android"
    -- 优先ccz
    if(file_exists( imageURLCCZ )) then
  
        imageExits = true
        imageURL = imageURLCCZ
    elseif(file_exists( imageURLPVR )) then
  
        imageExits = true
        imageURL = imageURLPVR
    elseif(file_exists( imageURLPKM ) ) then
    
        imageExits = true
        imageURL = imageURLPKM
  

    elseif(file_exists( imageURLPNG )) then
  
        imageExits = true
        imageURL = imageURLPNG

    end

    if(not imageExits) then
        ObjectTool.showTipWindow( animationName .. "贴图不存在" , nil, false, nil)
        imageExits = false
        return false
    else
        -- Logger.debug("getTexture:" .. imageURL)
    end
    
    return true,imageURL,plistURL,url
end
function deepcopy(object)

    local lookup_table = {}
    if object == nil then
        return nil
    end
    
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end  -- if
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end  -- for
        return setmetatable(new_table, getmetatable(object))
    end  -- function _copy
    return _copy(object)
end  -- function deepcopy



-- 获取总伤害数字(无正负符号)
-- value:数字
function getTotalHurtNumber( value )

    local num1 = require("script/battle/ui/CCSpriteBatchNumber").new()
    num1:create(BATTLE_CONST.ALL_WORDS_PLIST,
                BATTLE_CONST.ALL_WORDS_TEXTURE,
                value,
                BATTLE_CONST.NUMBER_TOTAL_HURT,
                false)
    return num1
end

-- 获取红色数字
-- value:数字
-- useSign:是否显示加号
function getRedNumber( value , usePlusSign )

    local num1 = require("script/battle/ui/CCSpriteBatchNumber").new()
    num1:create(BATTLE_CONST.ALL_WORDS_PLIST,
                BATTLE_CONST.ALL_WORDS_TEXTURE,
                value,
                BATTLE_CONST.NUMBER_RED,
                usePlusSign)
    return num1
end


-- 获取绿色数字
-- value:数字
-- useSign:是否显示加号
function getGreenNumber( value , usePlusSign )

    -- local className = "script/battle/ui/BattleVisualSpriteFrameContaner"
    -- local roundNum = require(className).new()
    -- local batchNode = BattleLayerManager.getBatchNode("GreenNumber")
    -- assert(batchNode,"BattleLayerManager.getBatchNode(\"GreenNumber\") return nil")

    -- roundNum:ini(batchNode,BATTLE_CONST.NUMBER_GREEN_TEXTURE,BATTLE_CONST.NUMBER_GREEN_PLIST,BATTLE_CONST.NUMBER_GREEN)

    -- -- roundNum:setPosition(size.width*0.85,size.height*0.965)
    -- roundNum:setString(tostring(value))
    -- return roundNum
    
    local num1 = require("script/battle/ui/CCSpriteBatchNumber").new()
    num1:create(BATTLE_CONST.ALL_WORDS_PLIST,
                BATTLE_CONST.ALL_WORDS_TEXTURE,
                value,
                BATTLE_CONST.NUMBER_GREEN,
                usePlusSign)
    return num1
end

-- 获取橘黄色数字
-- value:数字
-- useSign:是否显示加号
function getOrangeNumber( value , usePlusSign )

    local num1 = require("script/battle/ui/CCSpriteBatchNumber").new()
    num1:create(BATTLE_CONST.ALL_WORDS_PLIST,
                BATTLE_CONST.ALL_WORDS_TEXTURE,
                value,
                BATTLE_CONST.NUMBER_ORANGE,
                usePlusSign)
    return num1
end


function getRageUpNumber(value)
    local num1 = require("script/battle/ui/CCSpriteBatchNumber").new()
    num1:create(BATTLE_CONST.ALL_WORDS_PLIST,
                BATTLE_CONST.ALL_WORDS_TEXTURE,
                value,
                BATTLE_CONST.NUMBER_RAGE_UP,
                usePlusSign)
    return num1
end



function getRageDownNumber(value)
    local num1 = require("script/battle/ui/CCSpriteBatchNumber").new()
    num1:create(BATTLE_CONST.ALL_WORDS_PLIST,
                BATTLE_CONST.ALL_WORDS_TEXTURE,
                value,
                BATTLE_CONST.NUMBER_RAGE_DOWN,
                usePlusSign)
    return num1
end


function showTipWindow(info,call1,cancleCall)
        local alert = UIHelper.createCommonDlg(info,nil,call1,2,cancleCall)
        LayerManager.addLayout(alert,nil,g_tbTouchPriority.popDlg)
end

-- 加载人物动画
function loadRoleAnimation( ... )

    local hasAnimation,imageURL,plistURL,url = checkAnimation("kapian") 
   if(hasAnimation) then
        BattleNodeFactory.registArmature(url,imageURL,plistURL)
   else
        error("动画文件:kapian不存在")
   end
end
function getBenchMenuFadeOut( completeCall )


    -- 人物框收回  数值如下：
    -- 第 1  帧     位置 X = 0       比例 100 ：100  透明度 100 %
    -- 第 7  帧     位置 X = 10      比例 100 ：100  透明度 100 %
    -- 第 9  帧     位置 X = 10      比例 100 ：100  透明度 100 %
    -- 第 11 帧     位置 X = 10      比例 100 ：54   透明度 100 %
    -- 第 13 帧     位置 X = -5      比例 100 ：8    透明度 100 %
    -- 第 17 帧     位置 X = -40     比例 100 ：8    透明度 30  %
    -- 第 13 帧     位置 X = -90     比例 100 ：8    透明度 0   %
    local actionsArray = CCArray:create()
    -- actionsArray:addObject(CCMoveBy(0.01,ccp(-90,0)))
    -- actionsArray:addObject(
    --                             CCSpawn:createWithTwoActions(
    --                                                             CCMoveBy:create(4 * BATTLE_CONST.FRAME_TIME,ccp(50,0)),
    --                                                             CCFadeTo:create(4 * BATTLE_CONST.FRAME_TIME,255)
    --                                                         )
    --                        )
    actionsArray:addObject(CCMoveBy:create(6 * BATTLE_CONST.FRAME_TIME,ccp(10,0)))
    actionsArray:addObject(CCDelayTime:create(2 * BATTLE_CONST.FRAME_TIME))

    actionsArray:addObject(CCFadeTo:create(2 * BATTLE_CONST.FRAME_TIME,0.54 * 255))
    actionsArray:addObject(
                            CCSpawn:createWithTwoActions(
                                                            CCMoveBy:create(2 * BATTLE_CONST.FRAME_TIME,ccp(-15,0)),
                                                            CCFadeTo:create(2 * BATTLE_CONST.FRAME_TIME,0.08* 255)
                                                        )
                       )
    actionsArray:addObject(CCMoveBy:create(4 * BATTLE_CONST.FRAME_TIME,ccp(-35,0)))
    actionsArray:addObject(CCMoveBy:create(4 * BATTLE_CONST.FRAME_TIME,ccp(-50,0)))
    if(completeCall ~= nil) then
        actionsArray:addObject(CCCallFuncN:create(completeCall))
    end
    return CCSequence:create(actionsArray)
end

function getBenchMenuFadeIn( completeCall )
    local actionsArray = CCArray:create()
    actionsArray:addObject(CCMoveBy:create(0.01,ccp(-90,0)))
    -- 第 1  帧     位置 X = -90     比例 100 ：100  透明度 0   %
    -- 第 5  帧     位置 X = -40     比例 100 ：100  透明度 100 %
    -- 第 9  帧     位置 X = 10      比例 100 ：100  透明度 100 %
    -- 第 13 帧     位置 X = -5      比例 100 ：100  透明度 100 %
    -- 第 17 帧     位置 X = 0       比例 100 ：100  透明度 100 %
    actionsArray:addObject(
                                CCSpawn:createWithTwoActions(
                                                                CCMoveBy:create(4 * BATTLE_CONST.FRAME_TIME,ccp(50,0)),
                                                                CCFadeTo:create(4 * BATTLE_CONST.FRAME_TIME,255)
                                                            )
                           )
    actionsArray:addObject(CCMoveBy:create(4 * BATTLE_CONST.FRAME_TIME,ccp(50,0)))
    actionsArray:addObject(CCMoveBy:create(4 * BATTLE_CONST.FRAME_TIME,ccp(-15,0)))
    actionsArray:addObject(CCMoveBy:create(4 * BATTLE_CONST.FRAME_TIME,ccp(5,0)))
    if(completeCall ~= nil) then
        actionsArray:addObject(CCCallFuncN:create(completeCall))
    end
    return CCSequence:create(actionsArray)
end


function getRotation( startX , startY , endX , endY , ady)
    local ay 
     local ax = 0
     if(ady == nil) then
        ay = 1
     else
        ay = ady or 1
     end
    -- 已知弹道起点 S(sx,sy) 终点 E(ex,ey)
        -- 已知特效方向为 A(ax,ay) ->(0,1)
        -- 求弹道旋转角度

            -- 1.弹道方向向量: D = E - S = (ex - sx,ey - sy)
            -- 2.点乘:        A * D =  ax * dx + ay * dy = |A| * |D| * cos
            -- 3.叉乘:        A x D = ax * dy - ay * dx
            -- 4.叉乘结果大于0则表示在顺时针方向
         local rotation = 0
        -- 如果特效需要旋转 或者 有粒子特效 那么需要计算偏转(粒子需要偏转)
         local dx = endX - startX
         local dy = endY - startY
         local dLength = math.sqrt(dx * dx + dy * dy)
         
         local dot = ax * dx + ay * dy 
         local product = ax * dy - ay * dx
         -- local dLength = math.sqrt(dx * dx + dy * dy)
         local aLength = 1
         local cos = dot/dLength
         rotation = math.deg(math.acos(cos))
         -- 如果大于零说明是逆时针方向
         if(product > 0 ) then rotation = 360 - rotation end
         -- return math.min(rotation,360-rotation)
         return rotation

end

-- 获取重心
function getCentreOfGravityOfPoints( list )
    local xx,yy,num = 0,0,0
    for k,po in pairs(list or {}) do
        xx = xx + po.x
        yy = yy + po.y
        num = num + 1
    end
    return ccp(xx/num,yy/num)
end

-- local BSSequence = require ("script/battle/action/order/BSSequence")
-- local BSSpawn    = require ("script/battle/action/order/BSSpawn")
    
-- local BADelayTime    = require ("script/battle/action/ccActions/BADelayTime")
-- local BAFadeTo       = require ("script/battle/action/ccActions/BAFadeTo")
-- local BAMoveBy       = require ("script/battle/action/ccActions/BAMoveBy")
-- local BAScaleTo      = require ("script/battle/action/ccActions/BAScaleTo")
-- local BACall         = require ("script/battle/action/ccActions/BACall")
-- -- debug 用
-- function getCustomAnimation( targets )
    
--        -- 关键帧 1              比例 60                 透明度 50
--         local frame1 = BSSpawn:new({
--                                         BAScaleTo:new(1,0.6,targets),
--                                         BAFadeTo:new(1,0.5,targets)
--                                       })

         
--         -- 关键帧 4              比例 200                透明度 75
--         local frame4 = BSSpawn:new({
--                                         BAScaleTo:new(3,2,targets),
--                                         BAFadeTo:new(3,0.75,targets)
--                                       })

--          -- 关键帧 6              比例 200                透明度 100
--          local frame6 = BAScaleTo:new(2,2,targets)
--          -- 关键帧 8              比例 200                透明度 100
--          local frame8 = BADelayTime:new(2)
--           -- 关键帧 12             比例 85                 透明度 100
--          local frame12 = BAScaleTo:new(4,0.85,targets)
--          -- 关键帧 16             比例 100                透明度 100
--          local frame16 = BAScaleTo:new(4,1,targets)
--          -- 关键帧 52             比例 100                透明度 100
--          local frame52 = BADelayTime:new(3006)
         
--          -- 关键帧 60             比例 50                 透明度 0
--          local frame60 = BSSpawn:new({
--                                         BAScaleTo:new(8,0.5,targets),
--                                         BAFadeTo:new(8,0,targets)
--                                       })

--          local call    = BACall:new(function ( ... )
--              print("-- getCustomAnimation completeCall")
--          end)
          
--           local result = BSSequence:new({
--                                           frame1,frame4,frame6,frame8,frame16,frame12,frame52,frame60,call
--                                           -- frame1,frame4,frame6,frame8,frame16,frame12,frame52,call
--                                           -- frame1,call
--                                         })

--           return result

-- end

 
