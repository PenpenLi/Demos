 require "main.model.MonthCardProxy";
Handler_24_6 = class(Command);

function Handler_24_6:execute()
  local monthCardProxy=self:retrieveProxy(MonthCardProxy.name);
  local count = recvTable["Count"];
  local booleanValue = recvTable["BooleanValue"];
  print("Handler_24_6 Count booleanValue",count, booleanValue);
    if MonthCardMediator then
		local monthCardMediator = self:retrieveMediator(MonthCardMediator.name);
		if monthCardMediator then
			monthCardMediator:refreshData(count, booleanValue);
		end
	end	
end




Handler_24_6.new():execute();