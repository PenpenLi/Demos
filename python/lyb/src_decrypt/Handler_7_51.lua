
Handler_7_51 = class(MacroCommand)

function Handler_7_51:execute()
	local battleProxy = self:retrieveProxy(BattleProxy.name)
    local skillId;
    local QTEArray;
    local qteData = {};
    if not battleProxy.handlerType then
        skillId = recvTable["SkillId"];
        QTEArray = recvTable["QTEArray"];
        qteData.isOver = recvTable["isOver"];
        qteData.QTETime = recvTable["QTETime"];
        qteData.objectId = recvTable["objectId"];
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;

        skillId = handlerData.SkillId;
        QTEArray = handlerData.QTEArray;
        qteData.isOver = handlerData.isOver;
        qteData.QTETime = handlerData.QTETime;
        qteData.objectId = handlerData.objectId;
        package.loaded["main.controller.handler.Handler_7_51"] = nil
    end
    qteData.isOver = qteData.isOver and qteData.isOver==1;
    local battleMediator = self:retrieveMediator(BattleSceneMediator.name)
    BattleUtils:makeAttackStop(battleMediator,battleProxy,qteData.objectId,QTEArray,not qteData.isOver);
    qteData.skillId = skillId;
    qteData.QTEArray = QTEArray;
    local table = {type = "Handler_7_51", qteData = qteData};
    
    self:addSubCommand(BattleMoveCommand);  
    self:complete(table);
    local generalVO = battleProxy.battleGeneralArray[qteData.objectId]
    if qteData.isOver then
        generalVO.battleIcon:resume();
    else
        generalVO.battleIcon:pause();
    end
    --generalVO.battleIcon:setBodyEffectVisible(false)
    
   
end

Handler_7_51.new():execute();