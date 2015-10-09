Handler_27_5 = class(Command);

function Handler_27_5:execute()
  print(".27.5.",recvTable["ApplierArray"]);
  for k,v in pairs(recvTable["ApplierArray"]) do
    print(".27.5..");
    for k_,v_ in pairs(v) do
      print(k_,v_);
    end
  end
  uninitializeSmallLoading();
  if BangpaiMediator then
	  local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
	  if bangpaiMediator then
	  	bangpaiMediator:getViewComponent():refreshFamilyApplierArray(recvTable["ApplierArray"]);
	  end
	end
end

Handler_27_5.new():execute();