
Handler_24_48 = class(MacroCommand);

function Handler_24_48:execute()
  local Type = recvTable["Type"];--Count,Type
  local Count = recvTable["Count"];--Count,Type

  --Count已用次数
  print("Count", Count)
  print("Type", Type)

  self.handofMidasMed=self:retrieveMediator(HandofMidasMediator.name);  
  if self.handofMidasMed then
  	self.handofMidasMed:refreshData(Count)
  	if Type ~= 0 then
   		self.handofMidasMed:setBaojiEffect(Type);
   	end
  end
end

Handler_24_48.new():execute();