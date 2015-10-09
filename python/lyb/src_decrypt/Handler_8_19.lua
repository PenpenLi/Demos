Handler_8_19 = class(Command)

function Handler_8_19:execute()
	local aRewardTaskMediator = self:retrieveMediator(ARewardTaskMediator.name)
	if nil ~= aRewardTaskMediator then
		aRewardTaskMediator:closePage();
	end
end

Handler_8_19.new():execute()