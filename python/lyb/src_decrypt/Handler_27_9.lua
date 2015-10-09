Handler_27_9 = class(Command);

function Handler_27_9:execute()
  print(".27.9.",recvTable["FamilyInfoArray"]);
  uninitializeSmallLoading();
  if FamilyMediator then
	  local familyMediator=self:retrieveMediator(FamilyMediator.name);
	  if nil~=familyMediator then
	  	familyMediator:getViewComponent():refreshFamilyList(recvTable["FamilyInfoArray"]);
	  end
	end
end

Handler_27_9.new():execute();