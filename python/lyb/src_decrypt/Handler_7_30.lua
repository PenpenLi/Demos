
Handler_7_30 = class(Command)

function Handler_7_30:execute()
	local bool = recvTable["BooleanValue"];
	local userProxy = self:retrieveProxy(UserProxy.name);
	userProxy.autoBattle = bool;
	local battleMediator = self:retrieveMediator(BattleSceneMediator.name)
    if battleMediator then
        battleMediator:autoSuccess(bool);
    end
end

Handler_7_30.new():execute();