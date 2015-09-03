HalloweenBossConfig = class()
--[[
blood           总血量
normalHit       消除一个普通动物减少的血量
specialHit      消除一个特效动物减少的血量
genBellCount    生成收集物的数量
genCloudCount   生成云块的数量
dropBellOnHit   收伤掉落收集物的数量
dropBellOnDie   Boss死亡掉落收集物的数量
dropAddMove     生成+5步的个数
maxMove         释放技能的步数
]]--
local count = 0
local boss = 
{
    [1] = {blood = 14, normalHit = 1, specialHit = 3, genBellCount = 1, genCloudCount = 0, dropBellOnHit = 1, dropBellOnDie = 8, dropAddMove = 1, maxMove = 0},
    [2] = {blood = 19, normalHit = 1, specialHit = 3, genBellCount = 1, genCloudCount = 1, dropBellOnHit = 1, dropBellOnDie = 12, dropAddMove = 1, maxMove = 8},
    [3] = {blood = 25, normalHit = 1, specialHit = 3, genBellCount = 2, genCloudCount = 1, dropBellOnHit = 1, dropBellOnDie = 17, dropAddMove = 1, maxMove = 7},
    [4] = {blood = 32, normalHit = 1, specialHit = 3, genBellCount = 2, genCloudCount = 1, dropBellOnHit = 1, dropBellOnDie = 23, dropAddMove = 1, maxMove = 6},

}
function HalloweenBossConfig.reinit()
    count = 0
end
function HalloweenBossConfig.genNewBoss()
    count = count + 1
    if count == 1 or count == 2 then
        return boss[1]
    elseif count == 3 then
        return boss[2]
    elseif count == 4 then
        return boss[3]
    elseif count > 4 then
        return boss[4]
    end
end