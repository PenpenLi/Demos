
Handler_27_22 = class(MacroCommand);

function Handler_27_22:execute()
  local UserId = recvTable["UserId"]
  if MainSceneMediator then
  	local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
  	if mainSceneMediator then
  		mainSceneMediator:removeOtherPlayer(UserId);
  	end
  end
end

Handler_27_22.new():execute();