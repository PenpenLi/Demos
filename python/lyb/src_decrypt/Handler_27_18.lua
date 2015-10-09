Handler_27_18 = class(Command);

function Handler_27_18:execute()
  print(".27.18.",recvTable["Huoyuedu"],recvTable["IDArray"]);
  uninitializeSmallLoading();
  if BangpaiMediator then
	  local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
	  if bangpaiMediator then
	  	bangpaiMediator:getViewComponent():refreshHuoyuedujiangli(recvTable["Huoyuedu"],recvTable["IDArray"]);
	  end
	 end
end

Handler_27_18.new():execute();