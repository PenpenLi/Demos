Handler_27_39 = class(MacroCommand);

function Handler_27_39:execute()
  local familyProxy=self:retrieveProxy(FamilyProxy.name);
  familyProxy:refreshYongbingDataOnChange(recvTable["ChangeEmployArray"]);
  for k,v in pairs(recvTable["ChangeEmployArray"]) do
  	print("..");
  	for k_,v_ in pairs(v) do
  		print(k_,v_);
  	end
  end
  if YongbingMediator then
  	local mediator = self:retrieveMediator(YongbingMediator.name);
  	if mediator then
  		mediator:getViewComponent():refreshChange();
  	end
  end
end

Handler_27_39.new():execute();