Handler_7_69 = class(Command);

function Handler_7_69:execute()
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	local round;
	if not battleProxy.handlerType then
		round = recvTable["Round"];
	else
		local handlerData = battleProxy.handlerData;
		round = handlerData.Round
		battleProxy.handlerData = nil;
		battleProxy.handlerType = nil;
		package.loaded["main.controller.handler.Handler_7_69"] = nil
	end
	local battleSceneMediator=self:retrieveMediator(BattleSceneMediator.name);
	if battleSceneMediator then
		battleSceneMediator:refreshRoundTimes(round);
	end
end

Handler_7_69.new():execute();