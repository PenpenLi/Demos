require "zoo.gamePlay.mode.GameMode"
require "zoo.gamePlay.mode.MoveMode"
require "zoo.gamePlay.mode.ClassicMoveMode"
require "zoo.gamePlay.mode.DigMoveMode"
require "zoo.gamePlay.mode.DropDownMode"
require "zoo.gamePlay.mode.LightUpMode"
require "zoo.gamePlay.mode.OrderMode"
require "zoo.gamePlay.mode.ClassicMode"
require "zoo.gamePlay.mode.DigTimeMode"
require "zoo.gamePlay.mode.DigMoveEndlessMode"
require "zoo.gamePlay.mode.MaydayEndlessMode"
require "zoo.gamePlay.mode.RabbitWeeklyMode"
require "zoo.gamePlay.mode.SeaOrderMode"
require "zoo.gamePlay.mode.HalloweenMode"

GameModeFactory = class()

function GameModeFactory:create(mainLogic)
    print('mainLogic.theGamePlayType **************', mainLogic.theGamePlayType)
    local gameMode = mainLogic.theGamePlayType
    if gameMode == GamePlayType.kClassicMoves then		----步数模式==========
        return ClassicMoveMode.new(mainLogic)
    elseif gameMode == GamePlayType.kDropDown then		----掉落模式==========
        return DropDownMode.new(mainLogic)
    elseif gameMode == GamePlayType.kLightUp then			----冰层消除模式======
        return LightUpMode.new(mainLogic)
    elseif gameMode == GamePlayType.kDigMove then			----步数挖地模式======	
        return DigMoveMode.new(mainLogic)
    elseif gameMode == GamePlayType.kOrder then  			----订单模式
        return OrderMode.new(mainLogic)
    elseif gameMode == GamePlayType.kDigTime then     ----时间挖地模式
        return DigTimeMode.new(mainLogic)
    elseif gameMode == GamePlayType.kClassic then     ----时间模式
        return ClassicMode.new(mainLogic)
    elseif gameMode == GamePlayType.kDigMoveEndless then ----无限挖地模式
        return DigMoveEndlessMode.new(mainLogic)
    elseif gameMode == GamePlayType.kMaydayEndless then
        return MaydayEndlessMode.new(mainLogic)
    elseif gameMode == GamePlayType.kRabbitWeekly then
        return RabbitWeeklyMode.new(mainLogic)
    elseif gameMode == GamePlayType.kSeaOrder then
        return SeaOrderMode.new(mainLogic)
    elseif gameMode == GamePlayType.kHalloween then
        return HalloweenMode.new(mainLogic)
    else
        return GameMode.new(mainLogic)
    end
end