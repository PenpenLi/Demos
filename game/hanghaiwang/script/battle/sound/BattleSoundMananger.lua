
module("BattleSoundMananger",package.seeall)

local soundRunningList = {}

local loops        = {}

function playDropItemEffect()
    local soundName = BATTLE_CONST.BATTLE_DROP_SOUND
    local record =true
    local loopSoundEffect = false
    local sid = nil  
    if(hasSound(soundName) ~= true) then
        
        local mp3 = BattleURLManager.getButtonEffectSoundURL(soundName)
        -- print("BattleSoundMananger playDropItemEffect:",soundName)
        if(file_exists( mp3 )) then
            sid = AudioHelper.playEffect(mp3,loopSoundEffect)
        -- else
            -- print("BattleSoundMananger 1")
        end
        if(record) then
             registSound(soundName)
        end
        if(loopSoundEffect) then
            registLoopSound(sid)
        end
    end
    return sid
end
function playEffectSound( soundName ,useCount ,effectIsLoop)

    local rawSound = soundName
    -- Logger.debug(" input play soundName:" .. soundName)
    -- 因为声音无法加速,所以要求当前播放音效和战斗加速做出对应的匹配资源
    -- 查找最接近加速倍数的声音播放
    local currentTimeLevel = BattleMainData.currentSpeedLevel()
     local sNames = {}
    local index = string.find(soundName,".mp3") 
        if(index ~= nil and index > 0) then
            sNames =   string.split(tostring(soundName),".")
        else
            sNames[1] = soundName
        end

    if(currentTimeLevel ~= 1) then
        -- for k,v in pairs(sNames) do
        --     print("sNames:",k,v)
        -- end
        nextSound3x = BattleURLManager.getBattleEffectMusicURL(sNames[1] .. "X3.mp3")
        nextSound2x = BattleURLManager.getBattleEffectMusicURL(sNames[1] .. "X2.mp3")
        nextSound3xExists = file_exists(nextSound3x)
        nextSound2xExists = file_exists(nextSound2x)
        -- Logger.debug("== playEffectSound:" .. soundName .. "  " .. tostring(currentTimeLevel) .. " soundName:" .. nextSound3x .. "   " .. nextSound2x)
        if(currentTimeLevel == 3) then
            if(nextSound3xExists == true) then
                soundName = sNames[1] .. "X3.mp3"
            elseif(nextSound2xExists == true) then
                soundName = sNames[1] .. "X2.mp3"
            end
        elseif(currentTimeLevel == 2) then

            if(nextSound2xExists == true) then
                soundName = sNames[1] .. "X2.mp3"
            elseif(nextSound3xExists == true) then
                soundName = sNames[1] .. "X3.mp3"
            end
        end
    end

    index = string.find(soundName,".mp3") 
    if(index == nil or index < 0) then
        soundName = soundName .. ".mp3"
    end
    
    -- Logger.debug("play soundName:" .. soundName .. " index:".. tostring(index) .. " hasSound:" .. tostring(hasSound(rawSound))) 
    local record = useCount or true
    local loopSoundEffect = false
    if(effectIsLoop ~= nil) then loopSoundEffect = effectIsLoop end
    -- Logger.debug("play soundName:" .. soundName .. " raw:".. tostring(rawSound)) 
    local sid = nil  
    if(hasSound(rawSound) ~= true) then
        -- print("BattleSoundMananger 0")
        local mp3 = BattleURLManager.getBattleEffectMusicURL(soundName)
        if(file_exists( mp3 )) then
            sid = AudioHelper.playEffect(mp3,loopSoundEffect)
        -- else
            -- print("BattleSoundMananger 1")
        end
        if(record) then
             registSound(rawSound)
        end
        if(loopSoundEffect) then
            registLoopSound(sid)
        end
    end
    return sid
end

function registSound(sname)
    soundRunningList[sname] = true
end

function registLoopSound( sid )
    table.insert(loops,sid)
    if(sid ~= nil) then
        loops["loop_" .. sid] = sid
    end
end

function stopLoop( sid )
    if(sid ~= nil) then
        AudioHelper.stopEffect(sid)
    end
end

function stopAllLoop( )
    for k,sid in pairs(loops) do
        stopLoop(sid)
    end
    loops = {}
end

function removeSound( sname )
    soundRunningList[sname] = nil
end

function hasSound( sname )
    return soundRunningList[sname] == true
end


function reset( ... )
    soundRunningList = {}
    stopAllLoop()
end