HalloweenBossConfig = class()

local count = 0
local boss = 
{
    [1] = {blood = 12, normalHit = 1, specialHit = 2, genBellCount = 1, genCloudCount = 0, dropBellOnHit = 1, dropBellOnDie = 8, dropAddMove = 1, maxMove = 8},
    [2] = {blood = 19, normalHit = 1, specialHit = 2, genBellCount = 1, genCloudCount = 1, dropBellOnHit = 1, dropBellOnDie = 12, dropAddMove = 1, maxMove = 8},
    [3] = {blood = 28, normalHit = 1, specialHit = 2, genBellCount = 2, genCloudCount = 1, dropBellOnHit = 1, dropBellOnDie = 18, dropAddMove = 1, maxMove = 7},
    [4] = {blood = 40, normalHit = 1, specialHit = 3, genBellCount = 2, genCloudCount = 1, dropBellOnHit = 1, dropBellOnDie = 25, dropAddMove = 2, maxMove = 6},

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