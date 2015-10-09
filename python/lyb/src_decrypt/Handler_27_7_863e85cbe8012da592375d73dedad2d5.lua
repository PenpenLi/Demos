Handler_27_7 = class(Command);

function Handler_27_7:execute()
  print(".27.7.",recvTable["FamilyInfoArray"]);
  for k,v in pairs(recvTable["FamilyInfoArray"]) do
  	print(".27.7..");
  	for k_,v_ in pairs(v) do
  		print(k_,v_);
  	end
  end
  uninitializeSmallLoading();
  if BangpaiMediator then
	  local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
	  if nil~=bangpaiMediator then
	  	bangpaiMediator:getViewComponent():refreshFamilyList(recvTable["FamilyInfoArray"]);
	  end
	end
end

Handler_27_7.new():execute();