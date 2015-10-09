Handler_27_30 = class(Command);

function Handler_27_30:execute()

  local userProxy=self:retrieveProxy(UserProxy.name);
  local familyProxy=self:retrieveProxy(FamilyProxy.name);
  familyProxy.BanquetInfoArray = recvTable["BanquetInfoArray"]
  familyProxy:setFamilyLevel(recvTable["FamilyLevel"]);
  
  if userProxy.sceneType == GameConfig.SCENE_TYPE_4 and MainSceneMediator then
    local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
    if nil~=mainSceneMediator then
    	mainSceneMediator:refreshFamilyBanquet(familyProxy.BanquetInfoArray);
    end
  end
end

Handler_27_30.new():execute();