
Handler_24_47 = class(MacroCommand);

function Handler_24_47:execute()
  local Count = recvTable["Count"];
  print("Count", Count)
  local handofMidasMed=self:retrieveMediator(HandofMidasMediator.name);  
  if handofMidasMed then
  	handofMidasMed:refreshData(Count)
  end

end

Handler_24_47.new():execute();