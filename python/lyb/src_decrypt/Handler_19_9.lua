
Handler_19_9 = class(MacroCommand);

function Handler_19_9:execute()
	require "main.view.meeting.MeetingMediator";
    local state = tonumber(recvTable["State"]);
    local IDParamArray = recvTable["IDParamArray"];
    local IDStateParamArray = recvTable["IDStateParamArray"];
    --local time = tonumber(recvTable["Time"]);
	local mediator = self:retrieveMediator(MeetingMediator.name);
	if nil~=mediator then
		mediator:setProposal(IDParamArray);
		mediator:setState(state);
		if state >= 2 then
			mediator:setOfficerState(IDStateParamArray);
		end
	end
end

Handler_19_9.new():execute();