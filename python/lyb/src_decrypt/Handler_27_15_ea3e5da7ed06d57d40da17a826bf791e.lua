require "main.view.family.ui.familyBanquet.FamilyBanquetMediator"
require "main.view.family.ui.familyBanquet.FamilyHoldBanquetMediator"
Handler_27_15 = class(Command);

function Handler_27_15:execute()
  print(".27.15.",recvTable["UserId"]);
  uninitializeSmallLoading();
  local userProxy = self:retrieveProxy(UserProxy.name);
  if recvTable["UserId"] == userProxy:getUserID() then
  	self:onBangpaituichu();
  	return;
  end
  if BangpaiMediator then
    local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
    if bangpaiMediator then
    	bangpaiMediator:getViewComponent():refreshFamilyMemberKaichu(recvTable["UserId"]);
    end
  end
end

  if FamilyBanquetMediator then
    local familyBanquetMediator = Facade.getInstance():retrieveMediator(FamilyBanquetMediator.name);
    if familyBanquetMediator then
        familyBanquetMediator:onClose();
    end
  end
  if FamilyHoldBanquetMediator then
    local familyHoldBanquetMediator = Facade.getInstance():retrieveMediator(FamilyHoldBanquetMediator.name);
    if familyHoldBanquetMediator then
        familyHoldBanquetMediator:onClose();
    end
  end


function Handler_27_15:onBangpaituichu()
	if BangpaiMediator then
		local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
		  if bangpaiMediator then
		  	bangpaiMediator:onTuichu();
		  end
	end

	local userProxy = self:retrieveProxy(UserProxy.name)
    local mapSceneData = {}
    userProxy.sceneType = GameConfig.SCENE_TYPE_1
    mapSceneData["sceneType"] = userProxy.sceneType
    mapSceneData["from"] = GameConfig.SCENE_TYPE_4
    local data = {type = GameConfig.SCENE_TYPE_1, mapSceneData = mapSceneData};
    BeginLoadingSceneCommand.new():execute(LoadingNotification.new(LoadingNotifications.BEGIN_LOADING_SCENE, data))
end

Handler_27_15.new():execute();