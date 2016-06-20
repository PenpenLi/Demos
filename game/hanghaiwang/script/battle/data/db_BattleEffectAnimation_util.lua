module("db_BattleEffectAnimation_util",package.seeall)


local nameMap = {}
local init = false
function getDataByName(name)
    if(init ~= true) then
        init = true
        local  values = DB_KeyFramesInfo.KeyFramesInfo
        for k,v in pairs(values) do
            
            v = DB_KeyFramesInfo.getDataById(v[1])
            if(v.effectName ~= nil) then
                nameMap[v.effectName] = v
                -- print("db_BattleEffectAnimation_util:",v.effectName," ",v.keyFrameInfo)
            end
        end
    end

    local data = nameMap[name] 
    if(data == nil) then
        data = {totalFrames=10,keyFrameInfo="2"}
    end
	return data
end

function hasKeyFrame( name )
    return getAnimationTotalKeyFrames(name) >= 1
end

function isSkillMulityAttack( skillid )
    local skillEff = db_skill_util.getSkillAttackEffectName(skillid)
    if(skillEff) then
        return getAnimationTotalKeyFrames(skillEff) > 1
    end
    return false
end
-- 获取总帧数
function getAnimationTotalFrame(name)
  
    local ani = getDataByName(name)
       -- --print("getAnimationTotalFrame:",name,"totalFrames:",ani.totalFrames)
       if ani == nil then
            return 10
       end
    if(ani.totalFrames ~= nil) then
        return tonumber(ani.totalFrames)
    else
        error(name .. "totalFrame is nil")
    end
    return 10
end

function getFirstKeyFrame( name )
    return getAnimationKeyFrameArray(name)[1]
end

-- 获取关键帧数组
function getAnimationKeyFrameArray(name)
    local ani           = getDataByName(name)
    local keyFramesStri =  ani.keyFrameInfo
    -- print("getAnimationKeyFrameArray:",keyFramesStri)
    local result
    if keyFramesStri ~= nil and keyFramesStri ~= "" then
        result          = lua_string_split(keyFramesStri,",")
    else
        --print("we don't find aniamtion:",name," keyFrames info")
        result          = {5}
    end -- if end
    return result
end

-- 获取震动关键帧数组
function getAnimationShakeKeyFrameArray(name)
    local ani           = getDataByName(name)
    local keyFramesStri =  ani.shakeFrameInfo
    print("getAnimationKeyFrameArray:",keyFramesStri)
    local result
    if keyFramesStri ~= nil and keyFramesStri ~= "" then
        result          = lua_string_split(keyFramesStri,",")
    else
        --print("we don't find aniamtion:",name," keyFrames info")
        result          = {}
    end -- if end

    return result
end


function getShakeTypeArray(name)
    local ani           = getDataByName(name)
    local keyFramesStri =  ani.shakeTypeInfo
    print("getAnimationKeyFrameArray:",keyFramesStri)
    local result
    if keyFramesStri ~= nil and keyFramesStri ~= "" then
        result          = lua_string_split(keyFramesStri,",")
    else
        --print("we don't find aniamtion:",name," keyFrames info")
        result          = {}
    end -- if end
    return result
end


-- 获取总得关键帧数
function getAnimationTotalKeyFrames(name)
    local keyFrames =  getAnimationKeyFrameArray(name)
    local frameNum  = 0
    if keyFrames ~= nil then

        for i,v in pairs(keyFrames) do
            frameNum = frameNum + 1
        end --for end
    end -- if end
    return frameNum
end

-- 获取action对应的映射动作(策划需求:同一个动作可以配置不同的关键帧)
function getReflectionAction( action )
      local ani           = getDataByName(action)
      if(ani) then
            return ani.reflection
      end
end