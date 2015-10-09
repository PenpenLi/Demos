Handler_7_61 = class(Command);

function Handler_7_61:execute()
	require "main.view.fiveElementsBattle.FiveEleBtleMediator";
    local IDArray = recvTable["IDArray"];
	local mediator = self:retrieveMediator(FiveEleBtleMediator.name);
	if nil~=mediator then
		mediator:getViewComponent():onMakeList(IDArray);
	end
end

Handler_7_61.new():execute();