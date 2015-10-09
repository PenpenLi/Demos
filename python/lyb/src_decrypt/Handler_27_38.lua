Handler_27_38 = class(MacroCommand);

function Handler_27_38:execute()
  local familyProxy=self:retrieveProxy(FamilyProxy.name);
  familyProxy:refreshYongbingData(recvTable["EmployArray"]);
  for k,v in pairs(recvTable["EmployArray"]) do
  	print("..");
  	for k_,v_ in pairs(v) do
  		print(k_,v_);
  	end
  end
end

Handler_27_38.new():execute();