
module("WordsAnimationManager",package.seeall)
 

local tNumber        = require("script/battle/ui/BattleVisualSpriteFrameContaner")
local ttPath         = BATTLE_CONST.ALL_WORDS_TEXTURE
local tpPath         = BATTLE_CONST.ALL_WORDS_PLIST



local wordsSp        = require("script/battle/ui/BattleWordsContainer")

local rage_down      = "battle_ragedown_num_"
local rage_up        = "battle_rageup_num_"
local red            = "red_"
local green          = "green_"
local critical       = "critical_"
local words          = "battle_words_"

local numberMap      = nil


function getRageUpNumber( value ,showSign,autoAdd)
     return getTextureLabel(value,rage_up,showSign,false,autoAdd)
end

function getRageDownNumber( value ,showSign)
    return getTextureLabel(value,rage_down,showSign,value == 0,autoAdd)
end


function getRedNumber( value ,showSign)
    return getTextureLabel(value,red,showSign,false)
end

function getCriticalNumber( value ,showSign)
    return getTextureLabel(value,critical,showSign,false)
end

function getGreenNumber( value ,showSign)
    return getTextureLabel(value,green,showSign,false)
end


function reloadSource(  )
    
    local plistCache = CCSpriteFrameCache:sharedSpriteFrameCache()
    -- print("------- SpriteFramesManager add:",tpPath,ttPath)
    -- plistCache:addSpriteFramesWithFile(tpPath,ttPath)
    SpriteFramesManager.add(tpPath,ttPath)


    numberMap = {}

end


function regestNumberLabel(target,id)
    if(numberMap == nil) then numberMap = {} end
    if(numberMap[id] ~= nil ) then 
        -- numberMap[id]:complete()
        -- numberMap[id]:release()
        numberMap[id] = nil
    end

    -- numberMap[id] = target

end

function removeNumberLabel( id )
  if(numberMap ~= nil and numberMap[id] ~= nil) then
      numberMap[id] = nil
  end
end

function getTextureLabel( value, preName ,showSign,zeroAddSubSign,autoAdd)


    local num = wordsSp:new()
    -- local num = tNumber.new()
    showSign = showSign or false
 
    num:setCenterStyle(true)
    num:setAnchorPoint(CCP_HALF)
    
    if(value ~= nil) then
      -- 如果是强制添加减号(策划需求0的时候需要显示 + or -)
      if(zeroAddSubSign == true and tonumber(value) == 0) then
        num:setString("-" .. tostring(value),preName)
      elseif(tonumber(value) >= 0 and showSign == true) then
          num:setString("+" .. tostring(value),preName)
      else
          num:setString(tostring(value),preName)
      end
      
    end
    if(autoAdd == nil or autoAdd == true) then
      BattleLayerManager.battleNumberLayer:addChild(num)
    end
    return num
end

function getWord( word , autoAdd)
   local cache    = CCSpriteFrameCache:sharedSpriteFrameCache()
 
   local frameData   = cache:spriteFrameByName(words .. tostring(word))
    if(word == nil or frameData == nil) then 
          reloadSource()
          frameData   = cache:spriteFrameByName(words .. tostring(word))
          if(word == nil or frameData == nil) then 
            error("CCSpriteFrame can't find :" .. words .. tostring(word)) 
          end
    end -- if end
    -- print("getWord:",words .. tostring(word))
    local frameSprite  = CCSprite:create()
     
    frameSprite:setDisplayFrame(frameData)
    frameSprite:setAnchorPoint(CCP_HALF)
    frameSprite:setCascadeOpacityEnabled(true)
    
    if(autoAdd == true or autoAdd == nil) then
      BattleLayerManager.battleNumberLayer:addChild(frameSprite)
    end

    local rect = frameData:getRect()
    local height = rect:getMaxY() - rect:getMinY()

    return frameSprite,height
end

function getAnimationByColor( color,completeCall )
      local action = nil
      if(color == nil or color == BATTLE_CONST.NUMBER_RED) then
          actions = getAnimation(BATTLE_CONST.NUM_ANI_RED ,completeCall),BATTLE_CONST.POS_MIDDLE
      elseif(color == BATTLE_CONST.NUMBER_GREEN) then
          actions = getAnimation(BATTLE_CONST.NUM_ANI_GREEN ,completeCall),BATTLE_CONST.POS_MIDDLE
      else
          actions = getAnimation(BATTLE_CONST.NUM_ANI_CRTICAL ,completeCall),BATTLE_CONST.POS_MIDDLE
      end
      return action
end

-- 获取添加挂点
function getWordAnimationAddIndex( word )
  if(word ~= nil) then
        -- 上升动画
        if(
            word == "attackup.png" or
            word == "blockup.png" or
            word == "criticalup.png" or
            word == "defenseup.png" or
            word == "dodgeup.png"  or
            word == "dodge.png" or 
            word == "fightback.png" or 
            word == "immunity.png"
           ) then 
              return BATTLE_CONST.POS_MIDDLE
        -- 暴击
        elseif(word == "block.png") then
             -- return BATTLE_CONST.POS_HEAD
             return BATTLE_CONST.POS_MIDDLE
             -- return BATTLE_CONST.POS_FEET
        elseif(word == "critical.png") then
             return BATTLE_CONST.POS_HEAD
        -- 下降动画
        elseif(
                word == "attackdown.png"   or 
                word == "defensedown.png"  or 
                word == "hitratedown.png"
              ) then

              return BATTLE_CONST.POS_HEAD

         elseif(
                word == "poison.png"   or 
                word == "burn.png"
              ) then

              return BATTLE_CONST.POS_MIDDLE
         else
            return  BATTLE_CONST.POS_FEET
        end
 

    
    end
    return BATTLE_CONST.POS_MIDDLE
end
function getAnimationByWord( word,completeCall)
  local action = nil

    if(word ~= nil) then
        -- 上升动画
        if(
            word == "attackup.png" or
            word == "blockup.png" or
            word == "criticalup.png" or
            word == "defenseup.png" or
            word == "dodgeup.png" 
           ) then 
              return getAnimation(BATTLE_CONST.NUM_ANI_UP,completeCall),BATTLE_CONST.POS_FEET
        
        -- 下降动画
        elseif(
                word == "attackdown.png"   or 
                word == "defensedown.png"  or 
                word == "hitratedown.png"
              ) then
              return getAnimation(BATTLE_CONST.NUM_ANI_DOWN,completeCall),BATTLE_CONST.POS_HEAD
        elseif(word == "critical.png") then
               -- print("-- getAnimationByWord:critical.png")
               return getAnimation(BATTLE_CONST.NUM_ANI_CRTICAL_TEXT,completeCall),BATTLE_CONST.POS_HEAD
        elseif(
                word == "poison.png"   or 
                word == "burn.png"  or
                word == "block.png"
              ) then
              -- print("-- getAnimation: NUM_ANI_HURT_TYPE_1")
              return getAnimation(BATTLE_CONST.NUM_ANI_HURT_TYPE_1,completeCall),BATTLE_CONST.POS_MIDDLE
         else
            -- 放逐  battle_words_banish.png
            -- 魅惑  battle_words_charm.png
            -- 混乱  battle_words_confusion.png
            -- 沮丧  battle_words_depress.png
            -- 眩晕  battle_words_dizzy.png
            -- 封怒  battle_words_forbidanger.png
            -- 禁疗  battle_words_forbidcure.png
            -- 冰冻  battle_words_frozen.png
            -- 免疫  battle_words_immunity.png
            -- 底力  battle_words_indomitable.png
            -- 无敌  battle_words_invincible.png
            -- 魔免  battle_words_magicimmune.png
            -- 麻痹  battle_words_paralysis.png
            -- 石化  battle_words_petrification.png
            -- 物免  battle_words_physicsimmune.png
            -- 标记  battle_words_sign.png
            -- 沉默  battle_words_silence.png
            -- 格挡  battle_words_block.png
            -- 闪避  battle_words_dodge.png
            -- 反击  battle_words_fightback.png
            return getAnimation(BATTLE_CONST.NUM_ANI_SCALE_SHOW,completeCall),BATTLE_CONST.POS_MIDDLE
        end
 

    
    end
    return actions
end

function getKickOutAnimation(postionchange,completeCall)
        local cb = nil
        if(completeCall == nil) then
           completeCall= function ( ... )
             
           end
           
        end

    
        cb = CCCallFuncN:create(completeCall)

          local inOne = CCArray:create()
           inOne:addObject( CCSpawn:createWithTwoActions(
                                                          CCRotateBy:create(1200/60,180),
                                                          CCMoveBy:create(1200/60,ccp(postionchange[1],postionchange[2]))
                                                        ))
          inOne:addObject(cb)

        return CCSequence:create(inOne)


end
-- 获取战斗力上升动画
function getFightUpAnimation( completeCall )
   local cb = nil
    if(completeCall == nil) then completeCall = function ( ... )
        end
      end

    if(completeCall ~= nil) then
       cb = CCCallFuncN:create(completeCall)
    end

     local inone1 = CCArray:create()
     inone1:addObject( CCMoveBy:create(13/60,ccp(0,24 * g_fScaleY)))
     inone1:addObject( CCDelayTime:create(1/60))
     inone1:addObject( CCMoveBy:create(29/60,ccp(0,9 * g_fScaleY)))
     inone1:addObject( CCDelayTime:create(1/60))
     inone1:addObject( CCMoveBy:create(9/60,ccp(0,7 * g_fScaleY)))
     inone1:addObject( CCDelayTime:create(10/60))
     inone1:addObject( cb)

     return CCSequence:create(inone1)

  -- 第0 帧    位置  0    透明度  0
  -- 第13 帧   位置  24   透明度 100
  -- 第14 帧   位置  24   透明度 100
  -- 第43 帧   位置  33   透明度  100
  -- 第44 帧   位置  33   透明度  100
  -- 第53 帧   位置  40   透明度  50
  -- 第54 帧   位置  40   透明度  50
  -- 第63 帧   位置  40   透明度  0




end

-- POS_HEAD                = 1 -- 卡片顶
-- POS_MIDDLE                = 2 -- 卡片中间
-- POS_FEET                = 3 -- 卡片脚
function getAnimation(animationType ,completeCall)


        local cb = nil
        if(completeCall == nil) then completeCall = function ( ... )
          
            end
          end
        if(completeCall ~= nil) then
           
           cb = CCCallFuncN:create(completeCall)
        end

    -- 1.暴击文字
      if(animationType == BATTLE_CONST.NUM_ANI_CRTICAL_TEXT ) then
        -- 总时间 【 85帧】  起始挂点 卡牌顶端
        -- 关键帧 1        位移Y 0         比例 50              透明度 0
        -- 关键帧 2        位移Y 0         比例 50              透明度 50
        -- 关键帧 4        位移Y 18        比例 75              透明度 100
        -- 关键帧 6        位移Y 35        比例 150             透明度 100  
        -- 关键帧 10       位移Y 17        比例 100             透明度 100
        -- 关键帧 75       位移Y 17        比例 100             透明度 100
        -- 关键帧 85       位移Y 17        比例 100             透明度 0
                
                local inone1 = CCArray:create()
           inone1:addObject( CCScaleTo:create(2/60 , 0.5))
           inone1:addObject( CCMoveBy:create(2/60,ccp(0,18 * g_fScaleY)))
           inone1:addObject( CCFadeTo:create(2/60, 1 *255))

                local frame1 = CCSpawn:createWithTwoActions(CCScaleTo:create(1/60 , 0.5),CCFadeTo:create(1/60, 0))

               local frame2 = CCFadeTo:create(1/60, 0.5*255)
                local frame4 = CCSpawn:create( inone1 )

                local frame6 = CCSpawn:createWithTwoActions(
                                                CCScaleTo:create(2/60 , 1.5),
                                                CCMoveBy:create(2/60,ccp(0,17 * g_fScaleY))
                                              )



                 local frame10 = CCSpawn:createWithTwoActions(
                                                CCScaleTo:create(2/60 , 1),
                                                CCMoveBy:create(2/60,ccp(0,-18 * g_fScaleY))
                                              )


                  local frame75 = CCDelayTime:create(35/60)
                  local frame85 = CCFadeTo:create(10/60, 0)
                  local inOne = CCArray:create()
                  inOne:addObject( frame1)
                  inOne:addObject( frame2)
                  inOne:addObject( frame4)
                  inOne:addObject( frame6)
                  inOne:addObject( frame10)
                  inOne:addObject( frame75)
                  inOne:addObject( frame85)
                  inOne:addObject( cb)
          return CCSequence:create(inOne)
    
    -- 2.暴击非多段数字动画
    elseif(animationType == BATTLE_CONST.NUM_ANI_CRTICAL) then
    
        -- 总时间 【 85帧】  起始挂点 卡牌顶端
        -- 关键帧 1        位移Y 0          比例 50              透明度 0 
        -- 关键帧 2        位移Y 0          比例 50              透明度 50
        -- 关键帧 4        位移Y -31        比例 75              透明度 100
        -- 关键帧 6        位移Y -57        比例 150             透明度 100 
        -- 关键帧 10       位移Y -46        比例 100             透明度 100
        -- 关键帧 75       位移Y -46        比例 100             透明度 100
        -- 关键帧 85       位移Y -46        比例 100             透明度 0


 

        local frame1 = CCSpawn:createWithTwoActions(
                                        CCScaleTo:create(1/60,0.5),
                                        CCFadeTo:create(1/60,0)
                                      )
        local frame2  = CCFadeTo:create(1/60,0.5*255)

            local inone1 = CCArray:create()
           inone1:addObject( CCScaleTo:create(2/60 , 0.75))
           inone1:addObject( CCMoveBy:create(2/60,ccp(0,-31 * g_fScaleY)))
           inone1:addObject( CCFadeTo:create(2/60, 1))

        local frame4 = CCSpawn:create(inone1)
        
          local frame6 = CCSpawn:createWithTwoActions(
                                        CCScaleTo:create(2/60,1.5),
                                        CCMoveBy:create(2/60,ccp(0,-26 * g_fScaleY))
                                      )


        local frame10 = CCSpawn:createWithTwoActions(
                                        CCScaleTo:create(4/60,1.5),
                                        CCMoveBy:create(4/60,ccp(0,11 * g_fScaleY))
                                      )

        local frame75 = CCDelayTime:create(20/60)
         -- 关键帧 6              比例 200                透明度 100
        local frame85 = CCFadeTo:create(10/60,0)
         
        local inOne = CCArray:create()
          inOne:addObject( frame1)
          inOne:addObject( frame2)
          inOne:addObject( frame4)
          inOne:addObject( frame6)
          inOne:addObject( frame10)
          inOne:addObject( frame75)
          inOne:addObject( frame85)
          inOne:addObject( cb)
 
           return CCSequence:create(inOne)
    
    -- 3.数字: 多段 and 暴击  
    -- 多次暴击黄色数字（暴击多次伤害数值）  总时间 【 040帧】 起始挂点 卡牌底端  层次关系在文字之下   
    -- 关键帧 1         位移Y 0       比例 75             透明度 0
    -- 关键帧 2         位移Y 0       比例 75             透明度 50
    -- 关键帧 3         位移Y 7       比例 86             透明度 100
    -- 关键帧 12        位移Y 68      比例 175            透明度 100
    -- 关键帧 13        位移Y 70      比例 175            透明度 100
    -- 关键帧 20        位移Y 85      比例 100            透明度 100
    -- 关键帧 30        位移Y 85      比例 100            透明度 100
    -- 关键帧 40        位移Y 85      比例 105            透明度 0


    elseif(animationType == BATTLE_CONST.NUM_ANI_CRTICAL_MULITY) then
 
    
      local frame1 = CCSpawn:createWithTwoActions(
                                        CCScaleTo:create(1/60,0.75),
                                        CCFadeTo:create(1/60,0)
                                      )
      local frame2 = CCFadeTo:create(1/60,0.5*255)


          local inone1 = CCArray:create()
           inone1:addObject( CCScaleTo:create(1/60,0.86))
           inone1:addObject( CCMoveBy:create(1/60,ccp(0,7 * g_fScaleY)))
           inone1:addObject( CCFadeTo:create(1/60,1*255))

        local frame3 = CCSpawn:create(inone1)

      local frame12 = CCSpawn:createWithTwoActions(
                                    CCScaleTo:create(9/60,1.75),
                                    CCMoveBy:create(9/60,ccp(0,61 * g_fScaleY))
                                )

      local frame13 = CCMoveBy:create(1/60,ccp(0,2 * g_fScaleY))
      
      local frame20 = CCSpawn:createWithTwoActions(
                                    CCScaleTo:create(7/60,1),
                                    CCMoveBy:create(7/60,ccp(0,15 * g_fScaleY))
                                )
      local frame30 = CCDelayTime:create(30/60)
      local frame40 = CCSpawn:createWithTwoActions(
                                    CCScaleTo:create(10/60,1.05),
                                    CCFadeTo:create(10/60,0)
                                  )

              local inOne = CCArray:create()
          inOne:addObject( frame1)
          inOne:addObject( frame2)
          inOne:addObject( frame3)
          inOne:addObject( frame12)
          inOne:addObject( frame13)
          inOne:addObject( frame20)
          inOne:addObject( frame30)
          inOne:addObject( frame40)
          inOne:addObject( cb)
 
           return CCSequence:create(inOne)
      -- if(cb ~= nil) then
      --       result = CCSequence:create( frame1,frame2,frame3,frame12,frame13,frame20,frame30,frame40,cb )
      --     else
      --       result = CCSequence:create( frame1,frame2,frame3,frame12,frame13,frame20,frame30,frame40 )
      --       -- result:add(cb)
      --     end

      -- return result

     -- 4.红色数字伤害动画
   
    -- 4.红色数字
    elseif(animationType == BATTLE_CONST.NUM_ANI_RED) then
      -- 红色数字（伤害数值）  总时间 【 85帧】   起始挂点 卡牌中间   层次关系在文字之下  
      -- 关键帧 1         位移Y 0       比例 75             透明度 0
      -- 关键帧 2         位移Y 0       比例 75             透明度 50
      -- 关键帧 3         位移Y 7       比例 86             透明度 100
      -- 关键帧 12        位移Y 53      比例 175            透明度 100
      -- 关键帧 13        位移Y 55      比例 175            透明度 100
      -- 关键帧 20        位移Y 70      比例 100            透明度 100
      -- 关键帧 55        位移Y 70      比例 100            透明度 100
      -- 关键帧 65        位移Y 70      比例 40             透明度 0
          local inone1 = CCArray:create()
           inone1:addObject(CCScaleTo:create(1/60,0.75))
           -- inone1:addObject(CCFadeTo:create(1/60,0))


           local inone2 = CCArray:create()
           inone2:addObject(CCScaleTo:create(1/60,0.86))
           -- inone2:addObject(CCFadeTo:create(1/60,1*255))
           inone2:addObject(CCMoveBy:create(1/60,ccp(0,7 * g_fScaleY)))


           local inone3 = CCArray:create()
           inone3:addObject(CCScaleTo:create(9/60,1.75))
           inone3:addObject(CCMoveBy:create(9/60,ccp(0,51 * g_fScaleY)))

            local inone4 = CCArray:create()
           inone4:addObject(CCScaleTo:create(7/60,1))
           inone4:addObject(CCMoveBy:create(7/60,ccp(0,15 * g_fScaleY)))

            local inone5 = CCArray:create()
           inone5:addObject(CCScaleTo:create(10/60,0.4))
           -- inone5:addObject(CCFadeTo:create(10/60,0))

           local inOne = CCArray:create()
           inOne:addObject(CCSpawn:create(inone1))
           inOne:addObject( CCFadeTo:create(1/60,0.5*255) )
           inOne:addObject( CCSpawn:create(inone2))
           inOne:addObject( CCSpawn:create(inone3))
           inOne:addObject( CCMoveBy:create(1/60,ccp(0,2 * g_fScaleY) ))
           inOne:addObject( CCSpawn:create(inone4))
           inOne:addObject( CCDelayTime:create(35/60))
           inOne:addObject( CCSpawn:create(inone5))
           inOne:addObject( cb)
           
           return CCSequence:create(inOne)
   

    -- 5.红色数字多段 
    -- 多次红色数字（多次伤害数值）  总时间 【 35帧】 起始挂点 卡牌中间  层次关系在文字之下   
 

    -- 关键帧 1         位移Y 0       比例 75             透明度 0
    -- 关键帧 2         位移Y 0       比例 75             透明度 50
    -- 关键帧 3         位移Y 7       比例 86             透明度 100
    -- 关键帧 12        位移Y 53      比例 175            透明度 100
    -- 关键帧 13        位移Y 55      比例 175            透明度 100
    -- 关键帧 20        位移Y 70      比例 100            透明度 100
    -- 关键帧 30        位移Y 70      比例 100            透明度 100
    -- 关键帧 35        位移Y 70      比例 100            透明度 0
    elseif(animationType == BATTLE_CONST.NUM_ANI_MULITY) then

    
      local inone2 = CCArray:create()
           inone2:addObject(CCScaleTo:create(1/60,0.86))
           -- inone2:addObject(CCFadeTo:create(1/60,1*255))
           inone2:addObject(CCMoveBy:create(1/60,ccp(0,7 * g_fScaleY)))

           


            local inOne = CCArray:create()
           inOne:addObject(CCScaleTo:create(1/60,0.75))
           inOne:addObject( CCFadeTo:create(1/60,0.5*255) )
           inOne:addObject( CCFadeTo:create(1/60,0.5*255))
           inOne:addObject( CCSpawn:create(inone2))
           inOne:addObject( CCSpawn:createWithTwoActions(
                                                          CCScaleTo:create(9/60,1.75),
                                                          -- CCFadeTo:create(1,1),
                                                          CCMoveBy:create(9/60,ccp(0,46 * g_fScaleY))
                                                        ))
           inOne:addObject( CCMoveBy:create(1/60,ccp(0,2 * g_fScaleY)))
           inOne:addObject( CCDelayTime:create(10/60))
           inOne:addObject( CCSpawn:createWithTwoActions(
                                                          CCScaleTo:create(5/60,1.35),
                                                          CCMoveBy:create(5/60,ccp(0,15 * g_fScaleY))
                                                        ))
           inOne:addObject( cb)

           return CCSequence:create(inOne)
            
    -- 6.绿色加血
    elseif(animationType == BATTLE_CONST.NUM_ANI_GREEN and false) then
        -- 绿色数字（加血数值）   总时间 【 80帧】 下层
        -- 关键帧 1         位移 （0，0）       比例 75             透明度 0
        -- 关键帧 2         位移 （0，0）       比例 75             透明度 50
        -- 关键帧 3         位移 （0，6)        比例 86             透明度 100
        -- 关键帧 11        位移 （0，55）      比例 175            透明度 100
        -- 关键帧 12        位移 （0，55）      比例 175            透明度 100
        -- 关键帧 20        位移 （0，80）      比例 100            透明度 100
        -- 关键帧 55        位移 （0，80）      比例 100            透明度 100
        -- 关键帧 60        位移 （4，70）      比例 93             透明度 75
        -- 关键帧 65        位移 （-4，60）     比例 80             透明度 30
        -- 关键帧 70        位移 （0，50）      比例 80             透明度 0
          local inone2 = CCArray:create()
           inone2:addObject(CCScaleTo:create(1/60,0.86))
           -- inone2:addObject(CCFadeTo:create(1/60,1))
           inone2:addObject(CCMoveBy:create(1/60,ccp(4 * g_fScaleX,6 * g_fScaleY)))

          local inone3 = CCArray:create()
           inone3:addObject(CCScaleTo:create(5/60,0.93))
           -- inone3:addObject(CCFadeTo:create(5/60,0.75))
           inone3:addObject(CCMoveBy:create(5/60,ccp(4 * g_fScaleX,-10 * g_fScaleY)))
          

               local inone4 = CCArray:create()
           inone4:addObject(CCScaleTo:create(5/60,0.8))
           -- inone4:addObject(CCFadeTo:create(5/60,0.3))
           inone4:addObject(CCMoveBy:create(5/60,ccp(-8 * g_fScaleX,-10 * g_fScaleY)))



            local inOne = CCArray:create()
             -- 关键帧 1         位移 （0，0）       比例 75             透明度 0
           -- inOne:addObject( CCSpawn:createWithTwoActions(
           --                                                CCScaleTo:create(1/60,0.75),
           --                                                CCFadeTo:create(1/60,0)
           --                                              ))
           inOne:addObject( CCScaleTo:create(2/60,0.75))

           -- 关键帧 2         位移 （0，0）       比例 75             透明度 50
           -- inOne:addObject( CCFadeTo:create(1/60,0.5))

           -- 关键帧 3         位移 （0，6)        比例 86             透明度 100
           inOne:addObject( CCSpawn:create(inone2))

             -- 关键帧 11        位移 （0，55）      比例 175            透明度 100
           inOne:addObject( CCSpawn:createWithTwoActions(
                                                          CCScaleTo:create(8/60,1.75),
                                                          CCMoveBy:create(8/60,ccp(0,49 * g_fScaleY))
                                                        ))

           -- 关键帧 12        位移 （0，55）      比例 175            透明度 100
           inOne:addObject( CCDelayTime:create(1/60))


           -- 关键帧 20        位移 （0，80）      比例 100            透明度 100
           inOne:addObject( CCSpawn:createWithTwoActions(
                                                          CCScaleTo:create(8/60,1),
                                                          CCMoveBy:create(8/60,ccp(0,25 * g_fScaleY))
                                                        ))
           
           -- 关键帧 55        位移 （0，80）      比例 100            透明度 100
           inOne:addObject( CCDelayTime:create(35/60))

            -- 关键帧 60        位移 （4，70）      比例 93             透明度 75
           inOne:addObject( CCSpawn:create(inone3))
           -- 关键帧 65        位移 （-4，60）     比例 80             透明度 30
           inOne:addObject( CCSpawn:create(inone4))

            -- 关键帧 70        位移 （0，50）      比例 80             透明度 0
           -- inOne:addObject( CCSpawn:createWithTwoActions(
           --                                                CCFadeTo:create(5/60,0),
           --                                                CCMoveBy:create(5/60,ccp(4 * g_fScaleX,-10 * g_fScaleY))
           --                                              ))
           
           inOne:addObject(CCMoveBy:create(5/60,ccp(4 * g_fScaleX,-10 * g_fScaleY)))
           inOne:addObject( cb)
           
           return CCSequence:create(inOne)
    -- 7.buff文字
    elseif(animationType == BATTLE_CONST.NUM_ANI_SCALE_SHOW) then
 

        -- 关键帧 1         位移Y 25           比例 200              透明度 0
        -- 关键帧 6         位移Y 25           比例 95               透明度 100
        -- 关键帧 9         位移Y 25           比例 100              透明度 100
        -- 关键帧 60        位移Y 25           比例 100              透明度 100
        -- 关键帧 70        位移Y 25           比例 110              透明度 0

         local inOne = CCArray:create()

         local inone2 = CCArray:create()
           inone2:addObject(CCScaleTo:create(2/60,2))
           -- inone2:addObject(CCFadeTo:create(1/60,0))
           inone2:addObject(CCMoveBy:create(1/60,ccp(0,25 * g_fScaleY)))



        -- 关键帧 1         位移Y 25           比例 200              透明度 0
        inOne:addObject( CCSpawn:create(inone2))
        
        -- 关键帧 6         位移Y 25           比例 95               透明度 100
        -- inOne:addObject( CCSpawn:createWithTwoActions(CCScaleTo:create(5/60,0.95),
        --                                                CCFadeTo:create(5/60,1*255)))
           inOne:addObject(CCScaleTo:create(5/60,0.95))

        -- 关键帧 9         位移Y 25           比例 100              透明度 100
        inOne:addObject( CCScaleTo:create(3/60,1))

        -- 关键帧 60        位移Y 25           比例 100              透明度 100
        inOne:addObject( CCDelayTime:create(51/60))

         -- 关键帧 70        位移Y 25           比例 110              透明度 0
        inOne:addObject( 
                          CCScaleTo:create(10/60,0.6)
                       )
        inOne:addObject( cb)
       
        -- 总时间 【  85帧】  起始挂点  卡牌中间
        return CCSequence:create(inOne),BATTLE_CONST.POS_MIDDLE

    


    
    -- 8.中毒和灼烧加数字
    elseif(animationType == BATTLE_CONST.NUM_ANI_HURT_TYPE_1) then
            -- 中毒和灼烧加数字  总时间 【  85帧】 
            -- 关键帧 1              比例 100              透明度 0
            -- 关键帧 3              比例 100              透明度 50
            -- 关键帧 5              比例 115              透明度 100
            -- 关键帧 8              比例 130              透明度 100
            -- 关键帧 12             比例 100              透明度 100
            -- 关键帧 75             比例 100              透明度 100
            -- 关键帧 85             比例 110              透明度 0
            
            local inOne = CCArray:create()

            inOne:addObject( CCSpawn:createWithTwoActions(CCScaleTo:create(1/60,0.75),
                                                       CCFadeTo:create(1/60,0)))
            inOne:addObject( CCFadeTo:create(2/60,0.5 * 255))
            inOne:addObject( CCSpawn:createWithTwoActions(CCScaleTo:create(2/60,1.15),
                                                       CCFadeTo:create(2/60,255)))
            inOne:addObject( CCDelayTime:create(63/60))
            inOne:addObject( CCScaleTo:create(3/60,1.3))
            inOne:addObject( CCScaleTo:create(4/60,1))
            inOne:addObject( CCSpawn:createWithTwoActions(CCScaleTo:create(10/60,1.1),
                                                       CCFadeTo:create(10/60,0)))
     
            inOne:addObject( cb)
 
            return CCSequence:create(inOne) 
     -- 9.上升动画 
     elseif(animationType == BATTLE_CONST.NUM_ANI_UP or animationType == BATTLE_CONST.BATTLE_CONST.NUM_ANI_GREEN) then
      -- 上升【带上升符号的buff文字】   总时间 【  75帧】       起始挂点  卡牌中间
      -- 关键帧 1               位移Y 0                透明度  0                  
      -- 关键帧 6               位移Y 2                透明度  100        
      -- 关键帧 45              位移Y 55               透明度  100    
      -- 关键帧 55              位移Y 65               透明度 



            local inOne = CCArray:create()

            -- inOne:addObject( CCFadeTo:create(1/60,0))
            -- inOne:addObject( CCSpawn:createWithTwoActions(
            --                                               ,
            --                                               CCFadeTo:create(4/60,255))
            --                                              )

            inOne:addObject(CCMoveBy:create(4/60,ccp(0,2 * g_fScaleY)))
                                                         

            inOne:addObject( CCMoveBy:create(40/60,ccp(0,39 * g_fScaleY)))

            inOne:addObject(CCMoveBy:create(10/60,ccp(0,10 * g_fScaleY)))
            inOne:addObject( cb)
 
            return CCSequence:create(inOne) 
 
     -- 10.下降动画
     elseif(animationType == BATTLE_CONST.NUM_ANI_DOWN) then
       
        
        -- 下降【带下降符号的buff文字】  总时间 【  80帧】        起始挂点  卡牌顶端
        -- 关键帧 1               位移Y -20              透明度  0    
        -- 关键帧 6               位移Y -22              透明度  100   
        -- 关键帧 65              位移Y -75              透明度  100    
        -- 关键帧 75              位移Y -85              透明度  0

            local inOne = CCArray:create()

            -- inOne:addObject( CCFadeTo:create(1/60,0))
            inOne:addObject(CCMoveBy:create(1/60,ccp(0,-20 * g_fScaleY)))

             inOne:addObject(CCMoveBy:create(4/60,ccp(0,-2 * g_fScaleY)))

            inOne:addObject( CCMoveBy:create(40/60,ccp(0,-53 * g_fScaleY)))

            inOne:addObject(CCMoveBy:create(10/60,ccp(0,-10 * g_fScaleY)))
            inOne:addObject( cb)
 
            return CCSequence:create(inOne) 


        
    elseif(animationType == BATTLE_CONST.NUM_ANI_RAGE_UP) then

        -- 11. 怒气 加 数字   总时间 【  90帧】    起始挂点  卡牌中间
        -- 关键帧 1               位移Y 0                透明度  0                  
        -- 关键帧 6               位移Y 2                透明度  100        
        -- 关键帧 36              位移Y 55               透明度  100    
        -- 关键帧 46              位移Y 65               透明度  0  


          local inOne = CCArray:create()

            -- inOne:addObject( CCFadeTo:create(1/60,0))
            -- inOne:addObject( CCSpawn:createWithTwoActions(
            --                                               CCMoveBy:create(5/60,ccp(0,2 * g_fScaleY)),
            --                                               CCFadeTo:create(5/60,1*255))
            --                                              )
            inOne:addObject( 
                              CCMoveBy:create(5/60,ccp(0,2 * g_fScaleY))
                            )
 

            inOne:addObject( CCMoveBy:create(30/60,ccp(0,53 * g_fScaleY)))

            -- inOne:addObject( CCSpawn:createWithTwoActions(
            --                                   CCMoveBy:create(10/60,ccp(0, 15* g_fScaleY)),
            --                                   CCFadeTo:create(10/60,0))
            --                                  )
            inOne:addObject(CCMoveBy:create(10/60,ccp(0, 15* g_fScaleY)))

            inOne:addObject( cb)
 
            return CCSequence:create(inOne)
    elseif(animationType == BATTLE_CONST.NUM_ANI_RAGE_DOWN) then
          
        -- 12.下降【带下降符号的buff文字】  总时间 【  46帧】        起始挂点  卡牌顶端   [改] 
        -- 关键帧 1               位移Y -20              透明度  0    
        -- 关键帧 6               位移Y -22              透明度  100   
        -- 关键帧 36              位移Y -75              透明度  100    
        -- 关键帧 46              位移Y -85              透明度  0

           local inOne = CCArray:create()

            -- inOne:addObject( CCFadeTo:create(1/60,0))
            -- inOne:addObject( CCSpawn:createWithTwoActions(
            --                                               CCMoveBy:create(1/60,ccp(0,-20 * g_fScaleY)),
            --                                               CCFadeTo:create(1/60,0))
            --                                              )

              inOne:addObject(CCMoveBy:create(1/60,ccp(0,-20 * g_fScaleY)))


             -- inOne:addObject( CCSpawn:createWithTwoActions(
             --                                              CCMoveBy:create(5/60,ccp(0,-2 * g_fScaleY)),
             --                                              CCFadeTo:create(5/60,1*255))
             --                                             )
            inOne:addObject( CCMoveBy:create(5/60,ccp(0,-2 * g_fScaleY)))
                                                         

            inOne:addObject( CCMoveBy:create(30/60,ccp(0,-53 * g_fScaleY)))

            -- inOne:addObject( CCSpawn:createWithTwoActions(
            --                                   CCMoveBy:create(10/60,ccp(0,-10 * g_fScaleY)),
            --                                   CCFadeTo:create(10/60,0))
            --                                  )


             inOne:addObject(CCMoveBy:create(10/60,ccp(0,-10 * g_fScaleY)))

            inOne:addObject( cb)
            return CCSequence:create(inOne)
    end


  
    return CCSpawn:create()
end