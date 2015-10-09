Handler_27_9 = class(Command);

function Handler_27_9:execute()
  	print(".27.9.",recvTable["UserId"],recvTable["FamilyPositionId"],recvTable["ChangeMemberArray"]);
  	uninitializeSmallLoading();
	local userProxy = self:retrieveProxy(UserProxy.name);
	-- if recvTable["UserId"] == userProxy:getUserID() then
	-- 	userProxy.familyPositionId=recvTable["FamilyPositionId"];
	-- end
	local bool = false;
	for k,v in pairs(recvTable["ChangeMemberArray"]) do
		if v.UserId == userProxy:getUserID() then
			userProxy.familyPositionId=v.FamilyPositionId;
			bool = true;
		end
		-- print("UserId,UserName,FamilyPositionId,ConfigId", v.UserId, v.UserName,v.FamilyPositionId,v.ConfigId)

	end

	if BangpaiMediator then
	  local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
	  if bangpaiMediator then
	  	-- bangpaiMediator:getViewComponent():refreshFamilyMemeberPositionID(recvTable["UserId"],recvTable["FamilyPositionId"]);
	  	if bool then
	  		bangpaiMediator:getViewComponent():refreshFamilyMemeberPositionIDs(recvTable["ChangeMemberArray"]);
	  	else
		  	for k,v in pairs(recvTable["ChangeMemberArray"]) do
		  		bangpaiMediator:getViewComponent():refreshFamilyMemeberPositionID(v.UserId,v.FamilyPositionId);
		  	end
		end
	  end
	end
  	
  	for k,v in pairs(recvTable["ChangeMemberArray"]) do
		local familyProxy = self:retrieveProxy(FamilyProxy.name);
  		if v.FamilyPositionId == 1 then
		    familyProxy.bangZhuName = v["UserName"]--ParamStr1,UserName,ConfigId
    		familyProxy.bangZhuConfigId = v["ConfigId"]

    		-- print("familyProxy.bangZhuConfigId", familyProxy.bangZhuConfigId)

			if MainSceneMediator then
				local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
				if nil~=mainSceneMediator then
					mainSceneMediator:refreshBangZhu(familyProxy.bangZhuName, familyProxy.bangZhuConfigId);
				end
			end
  		end
  	end

end

Handler_27_9.new():execute();