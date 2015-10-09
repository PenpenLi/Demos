Handler_27_1 = class(Command);

function Handler_27_1:execute()
	uninitializeSmallLoading();

	print(".27.1.",recvTable["FamilyId"],recvTable["FamilyPositionId"]);
  local userProxy = self:retrieveProxy(UserProxy.name);
  local pre_familyId = userProxy.familyId;
  userProxy.familyId=recvTable["FamilyId"];
  userProxy.familyPositionId=recvTable["FamilyPositionId"];
  userProxy.familyName = recvTable["FamilyName"];

  	if 0 == recvTable["FamilyId"] then
  		if ShopMediator then
		local shopMediator=self:retrieveMediator(ShopMediator.name);
		  if shopMediator then--and 5 == shopMediator:getViewComponent().type then
		  	shopMediator:getViewComponent():closeUI();
		  end
		end

		if YongbingMediator then
		local yongbingMediator=self:retrieveMediator(YongbingMediator.name);
		  if yongbingMediator then
		  	yongbingMediator:getViewComponent():closeUI();
		  end
		end

  		if BangpaiMediator then
		local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
		  if bangpaiMediator then
		  	bangpaiMediator:onClose();
		  end
		end
	    if userProxy.sceneType == GameConfig.SCENE_TYPE_4 then
	    	local mapSceneData = {}
		    userProxy.sceneType = GameConfig.SCENE_TYPE_1
		    mapSceneData["sceneType"] = userProxy.sceneType
	        mapSceneData["from"] = GameConfig.SCENE_TYPE_4
		    local data = {type = GameConfig.SCENE_TYPE_1, mapSceneData = mapSceneData};
	    	BeginLoadingSceneCommand.new():execute(LoadingNotification.new(LoadingNotifications.BEGIN_LOADING_SCENE, data))
	    end
		--小贾退场景

		local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
		  heroHouseProxy.Hongidan_Huoyuedu=nil;
		  heroHouseProxy.Hongidan_Shenqingdu=nil;
		  require "main.controller.command.family.BangpaiRedDotRefreshCommand";
  			BangpaiRedDotRefreshCommand.new():execute();
  		return;
  	end
  	local bangpaiMediator;
  	if BangpaiMediator then
	  bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
	end
  	if 0 == pre_familyId and 0 ~= userProxy.familyId then
  		if 1 ~= recvTable["FamilyPositionId"] then
  			if not bangpaiMediator then
  				return;
  			else
  				bangpaiMediator:getViewComponent():refreshByFoundSuccess();
			  	if userProxy.familyId ~= 0 then
					sendMessage(27, 2)
				end
  			end
  		else
  			bangpaiMediator:getViewComponent():refreshByFoundSuccess();
		  	if userProxy.familyId ~= 0 then
				sendMessage(27, 2)
			end
  		end
  	end
end

Handler_27_1.new():execute();