module("BattleGridPostion",package.seeall)

--敌人y轴偏移量
army_py               = 50
-- 网格信息
local grids 						= {}

-- public
width 								=	0
scale 								=	1
-- m_layerSize							=	CCSizeMake(640,600)
local cardHalfSizeY       = 172

--  index and data
-- (129 148 ) (320 148 ) (510 148 )
-- (129 325 ) (320 325 ) (510 325 )

-- (129 675 ) (320 675 ) (510 675 )
-- (129 852 ) (320 852 ) (510 852 )
black = 40          -- 偏移
local block = 15    -- 卡牌间隔(y轴)
local topSpcae = 10 -- 上边距(顶部卡牌的上边距)
design_positons       = {
                          
                          
                          {129,325 - black + block},{320,325 - black + block},{510,325 - black + block},
                          {129,148 - black },{320,148 - black},{510,148 - black },
                          {129,675 - black - topSpcae - block},{320,675 - black - topSpcae - block},{510,675 - black - topSpcae - block},
                          {129,852 - black - topSpcae},{320,852 - black - topSpcae},{510,852 - black - topSpcae}
                        }


--战斗网格信息
function initGrid(bgWidth,bgscale)

	width 							= bgWidth
	scale							  = bgscale
      --print("initGrid:",width," ", scale)
end
-- 获取己方屏外点(x轴中间)
function getSelfTeamOutScreenPostion()
  return ccp(CCDirector:sharedDirector():getWinSize().width/2,
            0)
end

-- 获取敌方屏外点(x轴中间)
function getArmyTeamOutScreenPostion()
   return ccp(CCDirector:sharedDirector():getWinSize().width/2,
              CCDirector:sharedDirector():getWinSize().height)
end
-- 获取 屏中点
function getSelfCenterScreenPostion()
   return ccp(CCDirector:sharedDirector():getWinSize().width/2,
              CCDirector:sharedDirector():getWinSize().height/2 + 100)
end

-- 获取 屏中点
function getArmyCenterScreenPostion()
   return ccp(CCDirector:sharedDirector():getWinSize().width/2,
              CCDirector:sharedDirector():getWinSize().height/2 - 100)
end

-- 获取 屏中点
function getCenterScreenPostion()
   return ccp(CCDirector:sharedDirector():getWinSize().width/2,
              CCDirector:sharedDirector():getWinSize().height/2)
end

-- 获取敌方队伍中间点
function getArmyTeamCenterPostion()
   -- local centerPostion = getEnemyPointByIndex(1)
   -- centerPostion.y = centerPostion.y 
   -- return centerPostion
   return getEnemyPointByIndex(1)
end
-- 获取己方队伍中间点
function getSelfTeamCenterPostion()
   -- local centerPostion = getEnemyPointByIndex(1)
   -- centerPostion.y = centerPostion.y + 50
   -- return centerPostion
   return getPlayerPointByIndex(1)
end


--获取敌人的位置
function getEnemyPointByIndex(position)
    --print("getEnemyPointByIndex width:",width," ",scale)
    -- local cardWidth = m_layerSize.width*0.2 * scale;
    local points = design_positons[position + 7]
    
    -- print("getEnemyPointByIndex :",position + 7,points[1] * g_fScaleX ,  points[2] * g_fScaleY)
    if(points) then
     return ccp(points[1] * g_fScaleX,points[2] * g_fScaleY)
    else
       error("getEnemyPointByIndex:" .. position)
    end
    -- local winSize = CCDirector:sharedDirector():getWinSize()
    -- local cardWidth = width*0.2;
    
    -- local startX = 0.20*width
    
    -- local space  = cardWidth/8--cardWidth * 1.2/6
    -- local row    = (winSize.height - space * 2)/5.5
    -- local startY = winSize.height - space - row * 1.5 - army_py
    -- return ccp(startX+position%3*cardWidth*1.4, startY+math.floor(position/3)*row)
    
end

function showDebugLabel()
    for i=0,5 do
        local position = getPlayerPointByIndex(i)--getSelfCloseAttackPostion(i)

        local nameLabel = CCLabelTTF:create(tostring(i),g_sFontName,30)
        nameLabel:setAnchorPoint(CCP_HALF)
        nameLabel:setPosition(position.x,position.y)
        BattleLayerManager.battleAnimationLayer:addChild(nameLabel)
    end

     -- for i=0,8 do
        -- local position = getEnemyCloseAttackPostion(i)--getEnemyPointByIndex(i)--
    --     local nameLabel = CCLabelTTF:create(tostring(i),g_sFontName,30)
    --     nameLabel:setAnchorPoint(CCP_HALF)
    --     nameLabel:setPosition(position.x,position.y)
    --     BattleLayerManager.battleAnimationLayer:addChild(nameLabel)
    -- end

end
-- 获取自己的位置
function getPlayerPointByIndex(index)
    

    local position = design_positons[index + 1]
     -- print("getEnemyPointByIndex :",index + 1,position[1] * g_fScaleX ,  position[2] * g_fScaleY)
    if(position) then
      return ccp(position[1] * g_fScaleX,position[2] * g_fScaleY)
    else
       error("getPlayerPointByIndex:" .. index)
    end
    return nil

    -- local cardWidth = width*0.2
    
    -- local startX = 0.20*width
    -- local winSize = CCDirector:sharedDirector():getWinSize()
    -- local space  = cardWidth/8--cardWidth * 1.2/6
    -- local row    = (winSize.height - space * 2)/5.5
    -- local startY =  space + row * 1.5 
    -- return ccp(startX+index%3*cardWidth*1.4, startY-math.floor(index/3)*row)

end

function getEnemyCloseAttackPostion(position)

    local point = getEnemyPointByIndex(position)

    if(point) then
       point.y = point.y - cardHalfSizeY * g_fScaleY 
       return point
    else
       error("getEnemyCloseAttackPostion:" .. position)
    end
    return nil
 
end
function getSelfCloseAttackPostion(index)

    local point = getPlayerPointByIndex(index)

    if(point) then
       point.y = point.y + cardHalfSizeY * g_fScaleY 
       return point
    else
       error("getSelfCloseAttackPostion:" .. index)
    end

   
    return nil
 
end
-- 获取近敌行中点位置
function getCloseLineCenter( teamid , position )
   local indexFunction = nil
   local dir           = 1
   if(teamid == BATTLE_CONST.TEAM1) then
        indexFunction = getPlayerPointByIndex
   else
        dir           = -1
        indexFunction = getEnemyPointByIndex
   end

   local centerIndex = 1
   if(position > 2) then
      centerIndex = 4
   end

   local point = indexFunction(centerIndex)
    point.y = point.y + cardHalfSizeY * dir * g_fScaleY 
   return point
end
-- 获取敌军近身远点
function getEnemyFarAttackPostion(position)

    local point = getEnemyPointByIndex(position)

    if(point) then
       point.y = point.y - cardHalfSizeY * 1.5 * g_fScaleY 
       return point
    else
       error("getEnemyCloseAttackPostion:" .. position)
    end
    return nil
 
end

-- 获取我方近身远点
function getSelfFarAttackPostion(index)

    local point = getPlayerPointByIndex(index)

    if(point) then
       point.y = point.y + cardHalfSizeY * 1.5 * g_fScaleY 
       return point
    else
       error("getSelfCloseAttackPostion:" .. index)
    end

   
    return nil
 
end
