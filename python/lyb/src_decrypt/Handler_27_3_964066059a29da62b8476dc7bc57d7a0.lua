

Handler_27_3 = class(Command);

function Handler_27_3:execute()
  print("recvTable UserId", recvTable["UserId"])
  local userProxy=self:retrieveProxy(UserProxy.name);
  if userProxy.sceneType == GameConfig.SCENE_TYPE_4 and MainSceneMediator then
	  local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
	  if   mainSceneMediator then
	    local data = {UserId=recvTable["UserId"],UserName=recvTable["UserName"],ConfigId=recvTable["ConfigId"],Vip=recvTable["Vip"]}
	    mainSceneMediator:addOrUpdateOtherPlayer(data, true);
	  end
  end
end

Handler_27_3.new():execute();