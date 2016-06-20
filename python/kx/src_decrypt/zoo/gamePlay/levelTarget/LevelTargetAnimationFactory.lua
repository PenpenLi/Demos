kLevelTargetType = {
     drop = "drop", 
     dig_move = "dig_move", 
     time = "time", 
     ice = "ice", 
     move = "move",
     order1 = "order1", 
     order2 = "order2", 
     order3 = "order3", 
     order4 = "order4", 
     order5 = "order5", 
     dig_move_endless = "dig_move_endless",
     dig_move_endless_qixi = "dig_move_endless_qixi",
     dig_move_endless_mayday = "dig_move_endless_mayday",            
     rabbit_weekly = "rabbit_weekly",
     summer_weekly = "summer_weekly",
     sea_order = "order6",
     acorn = "acorn",
     hedgehog_endless = "hedgehog_endless",
     wukong = "dig_move_endless_wukong",
     order_lotus = "order_lotus",
}
-- order1: normal,   order2: single props,     order3: compose props, order4: others{snow, coin}, order5:{balloon, blackCuteBall}
kLevelTargetTypeTexts = {
     drop = "level.target.drop.mode", 
     dig_move = "level.target.dig.step.mode",
     dig_time = "level.target.dig.time.mode",
     dig_move_endless = "level.target.dig.endless.mode",
     time = "level.target.time.mode",
     ice = "level.target.ice.mode",
     move = "level.target.step.mode",
     order1 = "level.target.objective.mode",
     order2 = "level.target.eliminate.effect.mode",
     order3 = "level.target.swap.effect.mode",
     order4 = "level.target.objective.mode",
     order5 = "level.target.other.mode", 
     dig_move_endless_qixi =  "level.target.dig.endless.mode.qixi",
     dig_move_endless_mayday = "level.target.TwoYear",
     rabbit_weekly = "level.target.rabbit.weekly.mode",
     sea_order = "level.target.sea.order.mode",
     acorn = "level.start.drop.key.mode",
     summer_weekly = "weeklyrace.winter.target",
     [kLevelTargetType.wukong] = "level.target.wukong.endless",
     [kLevelTargetType.order_lotus] = "level.start.meadow.mode",
     [kLevelTargetType.hedgehog_endless] = "activity.level.target.hedgehogendless",
}

require "zoo.animation.CountDownAnimation"
require "zoo.panel.component.levelTarget.LevelTargetItem"
require "zoo.panel.component.levelTarget.TimeTargetItem"
require "zoo.panel.component.levelTarget.EndlessMayDayTargetItem"
require "zoo.panel.component.levelTarget.SeaOrderTargetItem"
require "zoo.panel.component.levelTarget.EndlessTargetItem"
require "zoo.panel.component.levelTarget.FillTargetItem"
require "zoo.panel.component.levelTarget.HalloweenTargetItem"
require "zoo.gamePlay.levelTarget.LevelTargetAnimationOrder"
require "zoo.gamePlay.levelTarget.LevelTargetAnimationTime"
require "zoo.gamePlay.levelTarget.LevelTargetAnimationChildClass"

LevelTargetAnimationFactory = {}
function LevelTargetAnimationFactory:createLevelTargetAnimation( gamePlayType, topX )
     -- body
     local cls = LevelTargetAnimationOrder
     if gamePlayType == GamePlayType.kClassicMoves then
          cls = LevelTargetAnimationMove
     elseif gamePlayType == GamePlayType.kClassic then
          cls = LevelTargetAnimationTime
     elseif gamePlayType == GamePlayType.kDropDown or gamePlayType == GamePlayType.kUnlockAreaDropDown then
          cls = LevelTargetAnimationDrop
     elseif gamePlayType == GamePlayType.kLightUp then
          cls = LevelTargetAnimationIce
     elseif gamePlayType == GamePlayType.kSeaOrder then
          cls = LevelTargetAnimationSeaOrder
     elseif gamePlayType == GamePlayType.kDigMoveEndless then
          cls = _isQixiLevel and LevelTargetAnimationDigMoveEndlessQixi or LevelTargetAnimationDigMoveEndless
     elseif gamePlayType == GamePlayType.kDigMove then
          cls = LevelTargetAnimationDigMove
     elseif gamePlayType == GamePlayType.kMaydayEndless then
          cls = LevelTargetAnimationMaydayEndless
     elseif gamePlayType == GamePlayType.kHalloween then
          cls = LevelTargetAnimationHalloween
     elseif gamePlayType == GamePlayType.kRabbitWeekly then
          cls = LevelTargetAnimationDigMoveEndless
     elseif gamePlayType == GamePlayType.kHedgehogDigEndless then
          cls = LevelTargetAnimationHedgehogEndless
     elseif gamePlayType == GamePlayType.kWukongDigEndless then
          cls = LevelTargetAnimationWukongEndless
          --cls = LevelTargetAnimationMaydayEndless
     elseif gamePlayType == GamePlayType.kLotus then
          --cls = LevelTargetAnimationOrder
          cls = LevelTargetAnimationLotus
     end

     assert(cls)
     local ret = cls.new()
     ret:buildLevelTargets(topX)
     ret:buildLevelPanel()
     return ret
end