
Handler_7_29 = class(Command)

function Handler_7_29:execute()
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	local battleMediator = self:retrieveMediator(BattleSceneMediator.name)
    if not battleProxy.handlerType then
          battleMediator:skillSuccess(recvTable["SkillId"],recvTable["BooleanValue"]);
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
    	local handlerData = battleProxy.handlerData;
		battleMediator:skillSuccess(handlerData.SkillId,handlerData.BooleanValue);
    	battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
        package.loaded["main.controller.handler.Handler_7_29"] = nil
    end
end

Handler_7_29.new():execute();