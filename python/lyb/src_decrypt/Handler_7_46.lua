
Handler_7_46 = class(Command)

function Handler_7_46:execute()
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	local battleUnitID;
    local skillId;
    local isPlay
    if not battleProxy.handlerType then
        battleUnitID = recvTable["BattleUnitID"];
        skillId = recvTable["SkillId"];
        isPlay = recvTable["Play"];
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        battleUnitID = handlerData.BattleUnitID
        skillId =handlerData.SkillId
        isPlay =handlerData.Play
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
    end
    local battleGeneralVO = battleProxy.battleGeneralArray[battleUnitID];
    if not battleGeneralVO then return;end
    battleGeneralVO:beAttackAction(skillId,isPlay>0);  
end

Handler_7_46.new():execute();