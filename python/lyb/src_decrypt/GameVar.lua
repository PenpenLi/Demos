GameVar=
{
    mapWidth = 0,
    mapHeight = 0,
    screenWidth = 1280,
    screenHeight = 720,
    tutorStage = 0,--新手阶段
    tutorSmallStep = 0,--新手的哪一步
    tuturReaccess = true,-- 新手重新进入
    publicTuturSmallStep = 0,--新手的哪一步
    isFirstEnterGame = nil,--手动停止玩家走路
    moveMap = {x=0, y=0, width=1280, height=720},
    mapBgX = 0,
    mapBgY = 0,
    hideCurrencyForTutor = nil,
    firstfight = nil,
    tutorXiLian = nil,
    skipTutor = nil,
    saoDangQuanCount = 0,
}
function GameVar:dispose()

    self.mapWidth = 0
    self.mapHeight = 0
    self.screenWidth = 0
    self.screenHeight = 0
    self.tutorStage = 0--新手阶段
    self.tutorSmallStep = 0--新手的哪一步
    self.tuturReaccess = true
    self.publicTuturSmallStep = 0
    self.isFirstEnterGame = nil
    self.firstfight = nil
end

function GameVar:isForceTutor()

   return false
end
