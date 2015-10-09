--
  --  战场结果命令
  
 Handler_7_6 = class(MacroCommand)

function Handler_7_6:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    local storyLineProxy = self:retrieveProxy(StoryLineProxy.name)

    -- 保存上一关的星级数据

    local bool = recvTable["BooleanValue"] == 1;
    local flipType = recvTable["Type"];
    local itemIdArray = recvTable["ItemIdArray"];
    local level = recvTable["Level"];
    local t = recvTable["BattleContinueTime"];
    local tableData = {type = "Handler_7_6", isVictory = bool ,
                    Type = flipType, itemIdPool = itemIdArray ,
                    battleLevel = level, Time = t};
  	
  	battleProxy.lastAttackData_7_6 = tableData
    self:addSubCommand(BattleOverCommand);  
    self:complete({type = "Handler_7_6"});	 
    local generalListProxy=self:retrieveProxy(GeneralListProxy.name);
    generalListProxy.expDontDisplay = nil;--战场结束经验不飘字，特殊处理
    
    -- self:refreshBattleBegin();
    local battleMediator = self:retrieveMediator(BattleSceneMediator.name);  
    battleMediator:stopAllNodeAction()
    battleProxy:cleanAIBattle()
    -- if battleProxy.needDebug then
    --     BattleUtils:sendDebugMessage(battleProxy.battleId)
    -- end
    if battleProxy.battleType == BattleConfig.BATTLE_TYPE_1
        or battleProxy.battleType == BattleConfig.BATTLE_TYPE_10 then
        if bool then 
             battleProxy:makeBattleStar();
        else
             battleProxy:makeBattleStar(true);
        end
    end
    print("battleProxy.strongPointId===",battleProxy.strongPointId)
    print("battleProxy:getBattleStar()===",battleProxy:getBattleStar())
    if battleProxy.strongPointId then
        storyLineProxy:setBattleStarCount(battleProxy.strongPointId,battleProxy:getBattleStar())
    end
    print("battleProxy.battleType:", battleProxy.battleType)
    local param
    
    closeTutorUI(param)
end

-- function Handler_7_6:refreshBattleBegin()
--   if TowerPopupMediator then
--     local towerPopupMediator=self:retrieveMediator(TowerPopupMediator.name);
--     if nil~=towerPopupMediator then
--       towerPopupMediator:refreshBattleBegin();
--     end
--   end
-- end

Handler_7_6.new():execute();